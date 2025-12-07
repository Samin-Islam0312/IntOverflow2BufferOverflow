
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(void) {
    int32_t n;
    if (fscanf(stdin, "%d", &n) != 1)
        return 1;

    int32_t m = n + 10;      // arithmetic #1 on tainted input
    int32_t bytes = m * 4;   // arithmetic #2 (mul on tainted)

    int32_t *buf = (int32_t *)malloc(bytes);
    if (!buf) return 1;

    for (int32_t i = 0; i < m; i++) {
        buf[i] = i;          // can overflow if bytes overflowed
    }

    free(buf);
    return 0;
}
