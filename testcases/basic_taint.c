// test1_basic_mul.c
#include <stdio.h>

int main(void) {
    int n;
    if (fscanf(stdin, "%d", &n) != 1)
        return 0;

    int x = n * 4;      // <- this mul should become type 3 and be patched

    printf("%d\n", x);
    return 0;
}
