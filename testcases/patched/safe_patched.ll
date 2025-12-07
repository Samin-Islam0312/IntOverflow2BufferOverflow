; ModuleID = 'testcases/irFiles/safe.ll'
source_filename = "testcases/safe.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@__stdinp = external global ptr, align 8
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@0 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@1 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@2 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@3 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@4 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@5 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@6 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@7 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1
@8 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %6 = load ptr, ptr @__stdinp, align 8
  %7 = call i32 (ptr, ptr, ...) @fscanf(ptr noundef %6, ptr noundef @.str, ptr noundef %2)
  %8 = icmp ne i32 %7, 1
  br i1 %8, label %9, label %10

9:                                                ; preds = %0
  store i32 1, ptr %1, align 4
  br label %50

10:                                               ; preds = %0
  %11 = load i32, ptr %2, align 4
  %12 = icmp sle i32 %11, 0
  br i1 %12, label %16, label %13

13:                                               ; preds = %10
  %14 = load i32, ptr %2, align 4
  %15 = icmp sgt i32 %14, 536870911
  br i1 %15, label %16, label %17

16:                                               ; preds = %13, %10
  store i32 1, ptr %1, align 4
  br label %50

17:                                               ; preds = %13
  %18 = load i32, ptr %2, align 4
  %19 = mul nsw i32 %18, 4
  %20 = icmp sgt i32 %18, 0
  %21 = icmp sgt i32 %19, 0
  %22 = icmp slt i32 %19, 0
  %23 = icmp eq i1 %20, true
  %24 = icmp ne i1 %20, true
  %25 = and i1 %23, %22
  %26 = and i1 %24, %21
  %27 = or i1 %25, %26
  br i1 %27, label %overflow_trap4, label %safe_continue

safe_continue:                                    ; preds = %17
  store i32 %19, ptr %3, align 4
  %28 = load i32, ptr %3, align 4
  %29 = sext i32 %28 to i64
  %30 = call ptr @malloc(i64 noundef %29) #3
  store ptr %30, ptr %4, align 8
  %31 = load ptr, ptr %4, align 8
  %32 = icmp ne ptr %31, null
  br i1 %32, label %34, label %33

33:                                               ; preds = %safe_continue
  store i32 1, ptr %1, align 4
  br label %50

34:                                               ; preds = %safe_continue
  store i32 0, ptr %5, align 4
  br label %35

35:                                               ; preds = %45, %34
  %36 = load i32, ptr %5, align 4
  %37 = load i32, ptr %2, align 4
  %38 = icmp slt i32 %36, %37
  br i1 %38, label %39, label %48

39:                                               ; preds = %35
  %40 = load i32, ptr %5, align 4
  %41 = load ptr, ptr %4, align 8
  %42 = load i32, ptr %5, align 4
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds i32, ptr %41, i64 %43
  store i32 %40, ptr %44, align 4
  br label %45

45:                                               ; preds = %39
  %46 = load i32, ptr %5, align 4
  %47 = add nsw i32 %46, 1
  store i32 %47, ptr %5, align 4
  br label %35, !llvm.loop !6

48:                                               ; preds = %35
  %49 = load ptr, ptr %4, align 8
  call void @free(ptr noundef %49)
  store i32 0, ptr %1, align 4
  br label %50

50:                                               ; preds = %48, %33, %16, %9
  %51 = load i32, ptr %1, align 4
  ret i32 %51

overflow_trap:                                    ; No predecessors!
  ret i32 42

overflow_trap1:                                   ; No predecessors!
  ret i32 42

overflow_trap2:                                   ; No predecessors!
  ret i32 42

overflow_trap3:                                   ; No predecessors!
  ret i32 42

overflow_trap4:                                   ; preds = %17
  ret i32 42

overflow_trap5:                                   ; No predecessors!
  ret i32 42

overflow_trap6:                                   ; No predecessors!
  ret i32 42

overflow_trap7:                                   ; No predecessors!
  ret i32 42

overflow_trap8:                                   ; No predecessors!
  ret i32 42
}

declare i32 @fscanf(ptr noundef, ptr noundef, ...) #1

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #2

declare void @free(ptr noundef) #1

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #2 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }
attributes #3 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 21.1.2"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
