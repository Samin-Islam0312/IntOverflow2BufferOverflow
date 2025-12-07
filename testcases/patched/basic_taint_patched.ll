; ModuleID = 'testcases/irFiles/basic_taint.ll'
source_filename = "testcases/basic_taint.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@__stdinp = external global ptr, align 8
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@0 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@1 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@2 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@3 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@4 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %4 = load ptr, ptr @__stdinp, align 8
  %5 = call i32 (ptr, ptr, ...) @fscanf(ptr noundef %4, ptr noundef @.str, ptr noundef %2)
  %6 = icmp ne i32 %5, 1
  br i1 %6, label %7, label %8

7:                                                ; preds = %0
  store i32 0, ptr %1, align 4
  br label %21

8:                                                ; preds = %0
  %9 = load i32, ptr %2, align 4
  %10 = mul nsw i32 %9, 4
  %11 = icmp sgt i32 %9, 0
  %12 = icmp sgt i32 %10, 0
  %13 = icmp slt i32 %10, 0
  %14 = icmp eq i1 %11, true
  %15 = icmp ne i1 %11, true
  %16 = and i1 %14, %13
  %17 = and i1 %15, %12
  %18 = or i1 %16, %17
  br i1 %18, label %overflow_trap2, label %safe_continue

safe_continue:                                    ; preds = %8
  store i32 %10, ptr %3, align 4
  %19 = load i32, ptr %3, align 4
  %20 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %19)
  store i32 0, ptr %1, align 4
  br label %21

21:                                               ; preds = %safe_continue, %7
  %22 = load i32, ptr %1, align 4
  ret i32 %22

overflow_trap:                                    ; No predecessors!
  ret i32 42

overflow_trap1:                                   ; No predecessors!
  ret i32 42

overflow_trap2:                                   ; preds = %8
  ret i32 42

overflow_trap3:                                   ; No predecessors!
  ret i32 42

overflow_trap4:                                   ; No predecessors!
  ret i32 42
}

declare i32 @fscanf(ptr noundef, ptr noundef, ...) #1

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 21.1.2"}
