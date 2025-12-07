; ModuleID = 'testcases/irFiles/chain_arith.ll'
source_filename = "testcases/chain_arith.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@__stdinp = external global ptr, align 8
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"%d %d %d\0A\00", align 1
@0 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@1 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@2 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@3 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@4 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@5 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@6 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@7 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@8 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@9 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@10 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@11 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@12 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %6 = load ptr, ptr @__stdinp, align 8
  %7 = call i32 (ptr, ptr, ...) @fscanf(ptr noundef %6, ptr noundef @.str, ptr noundef %2)
  %8 = icmp ne i32 %7, 1
  br i1 %8, label %9, label %10

9:                                                ; preds = %0
  store i32 0, ptr %1, align 4
  br label %40

10:                                               ; preds = %0
  %11 = load i32, ptr %2, align 4
  %12 = add nsw i32 %11, 10
  %13 = icmp sgt i32 %11, 0
  %14 = icmp sgt i32 %12, 0
  %15 = icmp eq i1 %13, true
  %16 = icmp ne i1 %13, %14
  %17 = and i1 %15, %16
  br i1 %17, label %overflow_trap7, label %safe_continue

safe_continue:                                    ; preds = %10
  store i32 %12, ptr %3, align 4
  %18 = load i32, ptr %3, align 4
  %19 = mul nsw i32 %18, 3
  %20 = icmp sgt i32 %18, 0
  %21 = icmp sgt i32 %19, 0
  %22 = icmp slt i32 %19, 0
  %23 = icmp eq i1 %20, true
  %24 = icmp ne i1 %20, true
  %25 = and i1 %23, %22
  %26 = and i1 %24, %21
  %27 = or i1 %25, %26
  br i1 %27, label %overflow_trap8, label %safe_continue9

safe_continue9:                                   ; preds = %safe_continue
  store i32 %19, ptr %4, align 4
  %28 = load i32, ptr %4, align 4
  %29 = sub nsw i32 %28, 5
  %30 = icmp sgt i32 %28, 0
  %31 = icmp sle i32 %29, %28
  %32 = icmp sgt i32 %29, %28
  %33 = icmp ne i1 %30, true
  %34 = or i1 %31, %32
  %35 = and i1 %33, %34
  br i1 %35, label %overflow_trap10, label %safe_continue11

safe_continue11:                                  ; preds = %safe_continue9
  store i32 %29, ptr %5, align 4
  %36 = load i32, ptr %3, align 4
  %37 = load i32, ptr %4, align 4
  %38 = load i32, ptr %5, align 4
  %39 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %36, i32 noundef %37, i32 noundef %38)
  store i32 0, ptr %1, align 4
  br label %40

40:                                               ; preds = %safe_continue11, %9
  %41 = load i32, ptr %1, align 4
  ret i32 %41

overflow_trap:                                    ; No predecessors!
  ret i32 42

overflow_trap1:                                   ; No predecessors!
  ret i32 42

overflow_trap2:                                   ; No predecessors!
  ret i32 42

overflow_trap3:                                   ; No predecessors!
  ret i32 42

overflow_trap4:                                   ; No predecessors!
  ret i32 42

overflow_trap5:                                   ; No predecessors!
  ret i32 42

overflow_trap6:                                   ; No predecessors!
  ret i32 42

overflow_trap7:                                   ; preds = %10
  ret i32 42

overflow_trap8:                                   ; preds = %safe_continue
  ret i32 42

overflow_trap10:                                  ; preds = %safe_continue9
  ret i32 42

overflow_trap12:                                  ; No predecessors!
  ret i32 42

overflow_trap13:                                  ; No predecessors!
  ret i32 42

overflow_trap14:                                  ; No predecessors!
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
