// test6_safe_but_flagged.c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int main(void) {
    int n;
    if (fscanf(stdin, "%d", &n) != 1)
        return 0;

    if (n < 0 || n > INT_MAX / 4)
        return 0;                   // explicit safety check

    int bytes = n * 4;              // logically safe now
    int *buf  = (int *)malloc(bytes);

    free(buf);
    return 0;
}
