#include <stdio.h>
#include <stdint.h>

int main(void) {
    int32_t n = 100;       // NOT tainted, no fscanf here
    int32_t bytes = n * 4; // pure constant arithmetic
    int32_t arr[100];

    for (int32_t i = 0; i < n; i++) {
        arr[i] = i;
    }
    return 0;
}
