; ModuleID = 'testcases/irFiles/SMT.ll'
source_filename = "testcases/SMT.c"
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  %5 = load ptr, ptr @__stdinp, align 8
  %6 = call i32 (ptr, ptr, ...) @fscanf(ptr noundef %5, ptr noundef @.str, ptr noundef %2)
  %7 = icmp ne i32 %6, 1
  br i1 %7, label %8, label %9

8:                                                ; preds = %0
  store i32 0, ptr %1, align 4
  br label %31

9:                                                ; preds = %0
  %10 = load i32, ptr %2, align 4
  %11 = icmp slt i32 %10, 0
  br i1 %11, label %15, label %12

12:                                               ; preds = %9
  %13 = load i32, ptr %2, align 4
  %14 = icmp sgt i32 %13, 536870911
  br i1 %14, label %15, label %16

15:                                               ; preds = %12, %9
  store i32 0, ptr %1, align 4
  br label %31

16:                                               ; preds = %12
  %17 = load i32, ptr %2, align 4
  %18 = mul nsw i32 %17, 4
  %19 = icmp sgt i32 %17, 0
  %20 = icmp sgt i32 %18, 0
  %21 = icmp slt i32 %18, 0
  %22 = icmp eq i1 %19, true
  %23 = icmp ne i1 %19, true
  %24 = and i1 %22, %21
  %25 = and i1 %23, %20
  %26 = or i1 %24, %25
  br i1 %26, label %overflow_trap3, label %safe_continue

safe_continue:                                    ; preds = %16
  store i32 %18, ptr %3, align 4
  %27 = load i32, ptr %3, align 4
  %28 = sext i32 %27 to i64
  %29 = call ptr @malloc(i64 noundef %28) #3
  store ptr %29, ptr %4, align 8
  %30 = load ptr, ptr %4, align 8
  call void @free(ptr noundef %30)
  store i32 0, ptr %1, align 4
  br label %31

31:                                               ; preds = %safe_continue, %15, %8
  %32 = load i32, ptr %1, align 4
  ret i32 %32

overflow_trap:                                    ; No predecessors!
  ret i32 42

overflow_trap1:                                   ; No predecessors!
  ret i32 42

overflow_trap2:                                   ; No predecessors!
  ret i32 42

overflow_trap3:                                   ; preds = %16
  ret i32 42

overflow_trap4:                                   ; No predecessors!
  ret i32 42

overflow_trap5:                                   ; No predecessors!
  ret i32 42

overflow_trap6:                                   ; No predecessors!
  ret i32 42

overflow_trap7:                                   ; No predecessors!
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
