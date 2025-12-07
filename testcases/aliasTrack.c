
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(void) {
    int32_t n;
    int32_t shadow;

    if (fscanf(stdin, "%d", &n) != 1)
        return 1;

    int32_t *p = &n;
    int32_t *q = &shadow;

    // copy through memory to confuse a naive analysis
    *q = *p;                 // store/load chain, alias-based propagation

    int32_t bytes = (*q) * 4;

    int32_t *buf = (int32_t *)malloc(bytes);
    if (!buf) return 1;

    for (int32_t i = 0; i < *q; i++) {
        buf[i] = i;
    }

    free(buf);
    return 0;
}
