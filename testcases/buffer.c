// io2bo_vuln.c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(void) {
    int32_t n;

    if (fscanf(stdin, "%d", &n) != 1) {
        return 1;
    }

    if (n <= 0) {
        return 1;
    }

    int32_t bytes = n * 4;

    int32_t *buf = (int32_t *)malloc(bytes);
    if (!buf) {
        return 1;
    }

    for (int32_t i = 0; i < n; i++) {
        buf[i] = i;      
    }

    free(buf);
    return 0;
}
