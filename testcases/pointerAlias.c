// test4_alias.c
#include <stdio.h>

int main(void) {
    int n;
    if (fscanf(stdin, "%d", &n) != 1)
        return 0;

    int *p = &n;
    *p = *p + 1;         // store via alias

    int z = n * 8;       // <- should still be type 3

    printf("%d\n", z);
    return 0;
}
