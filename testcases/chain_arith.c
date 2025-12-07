// test2_chain.c
#include <stdio.h>

int main(void) {
    int n;
    if (fscanf(stdin, "%d", &n) != 1)
        return 0;

    int a = n + 10;     // tainted
    int b = a * 3;      // tainted
    int c = b - 5;      // tainted

    printf("%d %d %d\n", a, b, c);
    return 0;
}
