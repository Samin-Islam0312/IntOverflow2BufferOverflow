; ModuleID = 'testcases/irFiles/pointerAlias.ll'
source_filename = "testcases/pointerAlias.c"
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
@5 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@6 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@7 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %5 = load ptr, ptr @__stdinp, align 8
  %6 = call i32 (ptr, ptr, ...) @fscanf(ptr noundef %5, ptr noundef @.str, ptr noundef %2)
  %7 = icmp ne i32 %6, 1
  br i1 %7, label %8, label %9

8:                                                ; preds = %0
  store i32 0, ptr %1, align 4
  br label %26

9:                                                ; preds = %0
  store ptr %2, ptr %3, align 8
  %10 = load ptr, ptr %3, align 8
  %11 = load i32, ptr %10, align 4
  %12 = add nsw i32 %11, 1
  %13 = load ptr, ptr %3, align 8
  store i32 %12, ptr %13, align 4
  %14 = load i32, ptr %2, align 4
  %15 = mul nsw i32 %14, 8
  %16 = icmp sgt i32 %14, 0
  %17 = icmp sgt i32 %15, 0
  %18 = icmp slt i32 %15, 0
  %19 = icmp eq i1 %16, true
  %20 = icmp ne i1 %16, true
  %21 = and i1 %19, %18
  %22 = and i1 %20, %17
  %23 = or i1 %21, %22
  br i1 %23, label %overflow_trap5, label %safe_continue

safe_continue:                                    ; preds = %9
  store i32 %15, ptr %4, align 4
  %24 = load i32, ptr %4, align 4
  %25 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %24)
  store i32 0, ptr %1, align 4
  br label %26

26:                                               ; preds = %safe_continue, %8
  %27 = load i32, ptr %1, align 4
  ret i32 %27

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

overflow_trap5:                                   ; preds = %9
  ret i32 42

overflow_trap6:                                   ; No predecessors!
  ret i32 42

overflow_trap7:                                   ; No predecessors!
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
