; ModuleID = 'testcases/irFiles/prop.ll'
source_filename = "testcases/prop.c"
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
@9 = private unnamed_addr constant [20 x i8] c"Overflow Detected!\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %7 = load ptr, ptr @__stdinp, align 8
  %8 = call i32 (ptr, ptr, ...) @fscanf(ptr noundef %7, ptr noundef @.str, ptr noundef %2)
  %9 = icmp ne i32 %8, 1
  br i1 %9, label %10, label %11

10:                                               ; preds = %0
  store i32 1, ptr %1, align 4
  br label %51

11:                                               ; preds = %0
  %12 = load i32, ptr %2, align 4
  %13 = add nsw i32 %12, 10
  %14 = icmp sgt i32 %12, 0
  %15 = icmp sgt i32 %13, 0
  %16 = icmp eq i1 %14, true
  %17 = icmp ne i1 %14, %15
  %18 = and i1 %16, %17
  br i1 %18, label %overflow_trap2, label %safe_continue

safe_continue:                                    ; preds = %11
  store i32 %13, ptr %3, align 4
  %19 = load i32, ptr %3, align 4
  %20 = mul nsw i32 %19, 4
  %21 = icmp sgt i32 %19, 0
  %22 = icmp sgt i32 %20, 0
  %23 = icmp slt i32 %20, 0
  %24 = icmp eq i1 %21, true
  %25 = icmp ne i1 %21, true
  %26 = and i1 %24, %23
  %27 = and i1 %25, %22
  %28 = or i1 %26, %27
  br i1 %28, label %overflow_trap5, label %safe_continue6

safe_continue6:                                   ; preds = %safe_continue
  store i32 %20, ptr %4, align 4
  %29 = load i32, ptr %4, align 4
  %30 = sext i32 %29 to i64
  %31 = call ptr @malloc(i64 noundef %30) #3
  store ptr %31, ptr %5, align 8
  %32 = load ptr, ptr %5, align 8
  %33 = icmp ne ptr %32, null
  br i1 %33, label %35, label %34

34:                                               ; preds = %safe_continue6
  store i32 1, ptr %1, align 4
  br label %51

35:                                               ; preds = %safe_continue6
  store i32 0, ptr %6, align 4
  br label %36

36:                                               ; preds = %46, %35
  %37 = load i32, ptr %6, align 4
  %38 = load i32, ptr %3, align 4
  %39 = icmp slt i32 %37, %38
  br i1 %39, label %40, label %49

40:                                               ; preds = %36
  %41 = load i32, ptr %6, align 4
  %42 = load ptr, ptr %5, align 8
  %43 = load i32, ptr %6, align 4
  %44 = sext i32 %43 to i64
  %45 = getelementptr inbounds i32, ptr %42, i64 %44
  store i32 %41, ptr %45, align 4
  br label %46

46:                                               ; preds = %40
  %47 = load i32, ptr %6, align 4
  %48 = add nsw i32 %47, 1
  store i32 %48, ptr %6, align 4
  br label %36, !llvm.loop !6

49:                                               ; preds = %36
  %50 = load ptr, ptr %5, align 8
  call void @free(ptr noundef %50)
  store i32 0, ptr %1, align 4
  br label %51

51:                                               ; preds = %49, %34, %10
  %52 = load i32, ptr %1, align 4
  ret i32 %52

overflow_trap:                                    ; No predecessors!
  ret i32 42

overflow_trap1:                                   ; No predecessors!
  ret i32 42

overflow_trap2:                                   ; preds = %11
  ret i32 42

overflow_trap3:                                   ; No predecessors!
  ret i32 42

overflow_trap4:                                   ; No predecessors!
  ret i32 42

overflow_trap5:                                   ; preds = %safe_continue
  ret i32 42

overflow_trap7:                                   ; No predecessors!
  ret i32 42

overflow_trap8:                                   ; No predecessors!
  ret i32 42

overflow_trap9:                                   ; No predecessors!
  ret i32 42

overflow_trap10:                                  ; No predecessors!
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
