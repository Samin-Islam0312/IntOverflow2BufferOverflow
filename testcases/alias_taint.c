// test3_store_load.c
#include <stdio.h>

int main(void) {
    int n;
    if (fscanf(stdin, "%d", &n) != 1)
        return 0;

    int tmp;
    tmp = n;                // store tainted n into tmp (memory)
    int m = tmp;            // load tainted value back

    int k = m * 2;          // <- this mul should be type 3

    printf("%d\n", k);
    return 0;
}
