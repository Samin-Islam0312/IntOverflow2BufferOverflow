#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

#include <map>
#include <set>
#include <vector>

using namespace llvm;

/*
  Type System:
  0 (00): Trusted & Non-overflowed (Safe)
  1 (01): Trusted & May Overflow   (Safe source, unchecked math)
  2 (10): Untrusted & Non-overflow (Input source, no math yet)
  3 (11): Untrusted & May Overflow (DANGEROUS - Patch Target)
*/

namespace IntPatch {

    class DetectPass : public PassInfoMixin<DetectPass> {
    public:
        // Persistent analysis state
        std::map<Value*, int> v2Type;           // Value -> Type
        std::map<Value*, int> tp_v;             // Pointer -> Type (Memory)
        std::set<Value*> all_arithmetic_instr;  // For reporting
        std::map<Value*, bool> vulnerables;     // Detected sinks

        PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
            
            // Access Function Analysis Manager for Alias Analysis
            FunctionAnalysisManager &FAM = AM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

            // Clear state for a fresh run
            v2Type.clear();
            tp_v.clear();
            all_arithmetic_instr.clear();
            vulnerables.clear();

            bool change = true;
            int iterCount = 1;

            // PHASE 1: Iterative Type Propagation (Fixpoint)
            while (change) {
                errs() << "\n\n\033[32m===============iteration: " << iterCount << "====================\033[0m\n";
                iterCount++;
                change = false;

                for (Function &F : M) {
                    if (F.isDeclaration()) {
                        // Skip printing for library functions to reduce noise
                        continue; 
                    }

                    // Alias Analysis Setup 
                    AAResults &AA = FAM.getResult<AAManager>(F);
                    BatchAAResults BatchAA(AA); // Required wrapper for LLVM 16+
                    AliasSetTracker aliasSetTracker(BatchAA);

                    for (BasicBlock &BB : F) {
                        for (Instruction &inst : BB) {
                            unsigned opcode = inst.getOpcode();

                            //Arithmetic (Add, Sub, Mul, Shl) 
                            if (opcode == Instruction::Add || opcode == Instruction::Sub || 
                                opcode == Instruction::Mul || opcode == Instruction::Shl) {
                                
                                int type = 1; // Default: Trusted but may overflow (01)
                                for (unsigned i = 0; i < inst.getNumOperands(); i++) {
                                    Value *operand = inst.getOperand(i);
                                    if (v2Type.count(operand)) {
                                        type |= v2Type[operand]; // Propagate Taint & Overflow bits
                                    }
                                }

                                if (v2Type[&inst] != type) {
                                    change = true;
                                    v2Type[&inst] = type;
                                }
                                all_arithmetic_instr.insert(&inst);
                            } 
                            // Store 
                            else if (opcode == Instruction::Store) {
                                StoreInst *store = cast<StoreInst>(&inst);
                                Value *storePtr = store->getPointerOperand();
                                aliasSetTracker.add(store);
                                
                                Value *value = store->getValueOperand();
                                if (v2Type.count(value)) {
                                    int valueType = v2Type[value];
                                    tp_v[storePtr] |= valueType; // Taint the memory location
                                    v2Type[&inst] = valueType;

                                    if (v2Type[value] == 3) {
                                        errs() << "\033[1m\033[31m[WARN] Uses a Type 3 (Dangerous) operand at Sink!\n";
                                        errs() << "      Instruction: " << inst << "\033[0m\n";
                                        vulnerables[&inst] = true;
                                    }
                                }
                            } 
                            // Load (Sources from Memory) 
                            else if (opcode == Instruction::Load) {
                                LoadInst *load = cast<LoadInst>(&inst);
                                Value *loadPtr = load->getPointerOperand();
                                MemoryLocation loadAddr = MemoryLocation::get(load);
                                
                                int type = tp_v[loadPtr];
                                aliasSetTracker.add(load);
                                
                                // If any alias is tainted, this load is tainted
                                AliasSet &aliasSet = aliasSetTracker.getAliasSetFor(loadAddr);
                                errs() << "\033[36m[INFO]\033[35m[ALIAS ANALYSIS]\033[0m " << *load << " has alias:\n";
                                
                                for (auto I = aliasSet.begin(), E = aliasSet.end(); I != E; ++I) {
                                    Value *V = const_cast<Value*>(I->Ptr); // LLVM 21 Fix: Access .Ptr directly
                                    errs() << " * ";
                                    V->print(errs(), false);
                                    errs() << "\n";
                                    if (tp_v.count(V)) {
                                        type |= tp_v[V];
                                    }
                                }

                                if (v2Type[&inst] != type) {
                                    change = true;
                                    v2Type[&inst] = type;
                                }
                                errs() << inst << " : Type " << v2Type[&inst] << "\n";
                            } 
                            // Branch / Control Flow 
                            else if (opcode == Instruction::Br || opcode == Instruction::IndirectBr) {
                                v2Type[&inst] = 0;
                            } 
                            //Comparisons (ICmp, FCmp)
                            else if (opcode == Instruction::ICmp || opcode == Instruction::FCmp) {
                                int type = 0;
                                for (unsigned i = 0; i < inst.getNumOperands(); i++) {
                                    Value *operand = inst.getOperand(i);
                                    if (v2Type.count(operand)) type |= v2Type[operand];
                                }
                                type &= 2; // Comparisons generally reset overflow bit (0), keep Untrusted (2)
                                if (v2Type[&inst] != type) change = true;
                                v2Type[&inst] = type;
                            } 
                            //PHI Nodes (Merges) 
                            else if (opcode == Instruction::PHI) {
                                int type = 0;
                                for (unsigned i = 0; i < inst.getNumOperands(); i++) {
                                    Value *operand = inst.getOperand(i);
                                    if (v2Type.count(operand)) {
                                        type |= v2Type[operand];
                                    }
                                }
                                if (v2Type[&inst] != type) change = true;
                                v2Type[&inst] = type;
                            }
                            // Call (Source Detection - TAINT SOURCE) 
                            else if (opcode == Instruction::Call) {
                                CallInst *call = cast<CallInst>(&inst);
                                Function *fun = call->getCalledFunction();
                                if (fun) {
                                    // *** CRITICAL FIX: Check BOTH "fscanf" (Mac) and "__isoc99_fscanf" (Linux) ***
                                    if (fun->getName() == "fscanf" || fun->getName() == "__isoc99_fscanf") {
                                        Value *v = call->getArgOperand(2); // The variable being written to
                                        errs() << "\033[1m\033[31m[TAINT SOURCE] Detected fscanf reading into:\033[0m ";
                                        v->print(errs(), false);
                                        errs() << "\n";
                                        
                                        v2Type[v] = 3; // Set as Untrusted (11) directly
                                        tp_v[v] = 3;
                                    }
                                }
                            } 
                            // --- 8. Default Propagation ---
                            else {
                                int type = 0;
                                if (inst.getNumOperands() > 0 && v2Type.count(inst.getOperand(0))) {
                                    type = v2Type[inst.getOperand(0)];
                                }
                                if (v2Type[&inst] < type) change = true;
                                v2Type[&inst] |= type;
                            }
                        }
                    }
                }
            } 

            errs() << "\n\n\033[32m===============End of all iterations====================\033[0m\n";

            // PHASE 2: Reporting
            for (auto i : v2Type) {
                Instruction *inst = dyn_cast<Instruction>(i.first);
                if (inst) {
                    int type = i.second;
                    errs() << "\033[36m[INFO]\033[0m";
                    errs() << "Fn:" << inst->getFunction()->getName();
                    errs() << " BB:";
                    inst->getParent()->printAsOperand(errs(), false);
                    if(type == 3) errs() << "\033[31m"; // Red for danger
                    errs() << " Inst:";
                    inst->print(errs(), false);
                    errs() << " Type:" << type << "\n";
                    errs() << "\033[0m";
                }
            }

            errs() << "\n\n\033[32m===============Dangerous Registers====================\033[0m\n";
            for (auto i : v2Type) {
                Instruction *inst = dyn_cast<Instruction>(i.first);
                if (inst) {
                    int type = i.second;
                    if (type != 3) continue; // Skip safe ones

                    errs() << "\033[31m[DANGER]\033[0m ";
                    errs() << "Fn:" << inst->getFunction()->getName();
                    errs() << " Inst:";
                    inst->print(errs(), false);
                    errs() << " Type:" << type << "\n";

                    bool hasRelated = false;
                    for (auto one : all_arithmetic_instr) {
                        Instruction *arith = dyn_cast<Instruction>(one);
                        if (!arith) continue;
                        
                        // Check if this dangerous instruction is used by another arithmetic op
                        for (unsigned k = 0; k < arith->getNumOperands(); ++k) {
                            if (inst == arith->getOperand(k)) {
                                if (!hasRelated) {
                                    hasRelated = true;
                                    errs() << "   -> Related arithmetic operations: \n";
                                }
                                errs() << "      ";
                                arith->print(errs(), false);
                                errs() << "\n";
                                break;
                            }
                        }
                    }
                }
            }

            // PHASE 3: Patching
            
            // 1. Collect targets first (Type 3 Arithmetic Instructions)
            std::vector<Instruction*> toPatch;
            for (auto const& [val, type] : v2Type) {
                Instruction *inst = dyn_cast<Instruction>(val);
                if (inst && type == 3) {
                    toPatch.push_back(inst);
                }
            }

            bool patchedAny = false;
            LLVMContext &context = M.getContext();

            // 2. Patch each target
            for (Instruction *inst : toPatch) {
                Function *func = inst->getFunction();
                
                // Create the Trap Block (Exit with code 42 on overflow)
                BasicBlock *tempBB = BasicBlock::Create(context, "overflow_trap", func);
                IRBuilder<> tempBuilder(tempBB);
                Value *tempRet = tempBuilder.getInt32(42);
                
                // Optional: Print "Detected!" (Requires declaring 'puts', skipping for simplicity)
                Constant *str = tempBuilder.CreateGlobalString("Overflow Detected!\n");
                
                if (func->getReturnType()->isVoidTy()) tempBuilder.CreateRetVoid();
                else if (func->getReturnType()->isIntegerTy()) tempBuilder.CreateRet(tempRet);
                else tempBuilder.CreateUnreachable(); 

                // Inject the check logic
                switch (inst->getOpcode()) {
                    case Instruction::Add:
                        add_patch(inst, tempBB, context);
                        patchedAny = true;
                        break;
                    case Instruction::Sub:
                        sub_patch(inst, tempBB, context);
                        patchedAny = true;
                        break;
                    case Instruction::Mul:
                        mul_patch(inst, tempBB, context);
                        patchedAny = true;
                        break;
                }
            }

            return patchedAny ? PreservedAnalyses::none() : PreservedAnalyses::all();
        }

    private:
        //  Helper: Signed Addition Check 
        void add_patch(Instruction* inst, BasicBlock* tempBB, LLVMContext &context) {
            IRBuilder<> Builder(inst->getParent());
            Builder.SetInsertPoint(inst->getNextNode());
            Value *op0 = inst->getOperand(0);
            Value *op1 = inst->getOperand(1);
            Value *zero = ConstantInt::get(Type::getInt32Ty(context), 0);

            Value *cmp1 = Builder.CreateICmpSGT(op0, zero);
            Value *cmp2 = Builder.CreateICmpSGT(op1, zero);
            Value *cmp3 = Builder.CreateICmpSGT(inst, zero);

            // Overflow if (Pos + Pos = Neg) OR (Neg + Neg = Pos)
            Value *cmp1Eqcmp2 = Builder.CreateICmpEQ(cmp1, cmp2);       // Same sign inputs
            Value *cmp1Neqcmp3 = Builder.CreateICmpNE(cmp1, cmp3);      // Result sign differs
            Value *allHold = Builder.CreateAnd(cmp1Eqcmp2, cmp1Neqcmp3);

            injectBranch(inst, allHold, tempBB);
        }

        // Helper: Signed Multiplication Check
        void mul_patch(Instruction* inst, BasicBlock* tempBB, LLVMContext &context) {
            IRBuilder<> Builder(inst->getParent());
            Builder.SetInsertPoint(inst->getNextNode());
            Value *op0 = inst->getOperand(0);
            Value *op1 = inst->getOperand(1);
            Value *zero = ConstantInt::get(Type::getInt32Ty(context), 0);

            Value *cmp1 = Builder.CreateICmpSGT(op0, zero);
            Value *cmp2 = Builder.CreateICmpSGT(op1, zero);
            Value *cmp3 = Builder.CreateICmpSGT(inst, zero); // Result > 0
            Value *cmp4 = Builder.CreateICmpSLT(inst, zero); // Result < 0

            Value *cmp1Eqcmp2 = Builder.CreateICmpEQ(cmp1, cmp2); // Same signs?
            Value *cmp1Neqcmp2 = Builder.CreateICmpNE(cmp1, cmp2); // Diff signs?

            // 1. Same signs input -> Must be Positive. If Neg -> Overflow.
            Value *condition1 = Builder.CreateAnd(cmp1Eqcmp2, cmp4);
            // 2. Diff signs input -> Must be Negative. If Pos -> Overflow.
            Value *condition2 = Builder.CreateAnd(cmp1Neqcmp2, cmp3);
            
            Value *allHold = Builder.CreateOr(condition1, condition2);

            injectBranch(inst, allHold, tempBB);
        }

        //  Helper: Signed Subtraction Check 
        void sub_patch(Instruction* inst, BasicBlock* tempBB, LLVMContext &context) {
            IRBuilder<> Builder(inst->getParent());
            Builder.SetInsertPoint(inst->getNextNode());
            Value *op0 = inst->getOperand(0);
            Value *op1 = inst->getOperand(1);
            Value *zero = ConstantInt::get(Type::getInt32Ty(context), 0);

            Value *cmp1 = Builder.CreateICmpSGT(op0, zero);
            Value *cmp2 = Builder.CreateICmpSGT(op1, zero);
            
            Value *cmp3 = Builder.CreateICmpSLE(inst, op0);
            Value *cmp4 = Builder.CreateICmpSGT(inst, op0);

            // Overflow only possible if signs differ (Pos - Neg, or Neg - Pos)
            Value *first_case = Builder.CreateICmpNE(cmp1, cmp2); 
            // Wrap-around logic
            Value *second_case = Builder.CreateOr(cmp3, cmp4);
            Value *allHold = Builder.CreateAnd(first_case, second_case);

            injectBranch(inst, allHold, tempBB);
        }

        // Helper: Control Flow Injection 
        void injectBranch(Instruction *inst, Value *condition, BasicBlock *trapBB) {
            Instruction *splitPoint = dyn_cast<Instruction>(condition)->getNextNode();
            if (!splitPoint) return;

            BasicBlock *currentBB = inst->getParent();
            // Split the block: "safe_continue" gets the rest of the original code
            BasicBlock *safeContinuationBB = currentBB->splitBasicBlock(splitPoint, "safe_continue");
            
            errs() << "SPLIT AT:";
            safeContinuationBB->printAsOperand(errs(), false);
            errs() << "\n";

            // Remove the unconditional branch created by splitBasicBlock
            Instruction *oldTerminator = currentBB->getTerminator();
            IRBuilder<> Builder(oldTerminator);
            
            // Insert Conditional Branch:
            // IF overflow (condition is true) -> GOTO trapBB
            // ELSE -> GOTO safeContinuationBB
            Builder.CreateCondBr(condition, trapBB, safeContinuationBB);
            oldTerminator->eraseFromParent();
        }
    };
} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION,
        "IntPatchDetect",
        LLVM_VERSION_STRING,
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "intpatch-detect") {
                        MPM.addPass(IntPatch::DetectPass());
                        return true;
                    }
                    return false;
                });
        }};
}