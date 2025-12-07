# Build 
```bash
cmake -DLLVM_DIR=$(llvm-config --cmakedir) ..
make
```

# Compile Testcases
```bash
clang -S -emit-llvm -O0 testcases/safe.c -o testcases/irFiles/safe.ll
clang -S -emit-llvm -O0 testcases/prop.c -o testcases/irFiles/prop.ll
clang -S -emit-llvm -O0 testcases/aliasTrack.c -o testcases/irFiles/aliasTrack.ll
clang -S -emit-llvm -O0 testcases/basic_taint.c -o testcases/irFiles/basic_taint.ll
clang -S -emit-llvm -O0 testcases/buffer.c -o testcases/irFiles/buffer.ll
clang -S -emit-llvm -O0 testcases/chain_arith.c -o testcases/irFiles/chain_arith.ll
clang -S -emit-llvm -O0 testcases/nothing.c -o testcases/irFiles/nothing.ll
clang -S -emit-llvm -O0 testcases/pointerAlias.c -o testcases/irFiles/pointerAlias.ll
clang -S -emit-llvm -O0 testcases/SMT.c -o testcases/irFiles/SMT.ll
clang -S -emit-llvm -O0 testcases/alias_taint.c -o testcases/irFiles/alias_taint.ll
```

# Run the pass, and record flags in txt files in the `results` subdirectory and patched IR codes in `irfiles`
```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/alias_taint.ll -S -o testcases/patched/alias_taint_patched.ll \
    2> testcases/results/alias_taint_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/aliasTrack.ll -S -o testcases/patched/aliasTrack_patched.ll \
    2> testcases/results/aliasTrack_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/basic_taint.ll -S -o testcases/patched/basic_taint_patched.ll \
    2> testcases/results/basic_taint_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/buffer.ll -S -o testcases/patched/buffer_patched.ll \
    2> testcases/results/buffer_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/chain_arith.ll -S -o testcases/patched/chain_arith_patched.ll \
    2> testcases/results/chain_arith_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/nothing.ll -S -o testcases/patched/nothing_patched.ll \
    2> testcases/results/nothing_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/pointerAlias.ll -S -o testcases/patched/pointerAlias_patched.ll \
    2> testcases/results/pointerAlias_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/prop.ll -S -o testcases/patched/prop_patched.ll \
    2> testcases/results/prop_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/safe.ll -S -o testcases/patched/safe_patched.ll \
    2> testcases/results/safe_results.txt
```

```bash
opt -load-pass-plugin=./build/IntPatch.dylib -passes='default<O0>,intpatch-detect' \
    testcases/irFiles/SMT.ll -S -o testcases/patched/SMT_patched.ll \
    2> testcases/results/SMT_results.txt
```


