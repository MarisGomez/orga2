#include <stdio.h>

int main() {
    int arr[] = {1, 2, 3, 4};
    int len = sizeof(arr) / sizeof(arr[0]);
    int k = 2;

    k = k % len;

    int arrN[len];
    for (int i = 0; i < len; i++) {
        arrN[i] = arr[(i + k) % len];
    }

    for (int i = 0; i < len; i++) {
        printf("%d", arrN[i]);
    }
    return 0;
}