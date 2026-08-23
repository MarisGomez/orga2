#include <stdio.h>

int main() {
    int arr[] = {1, 2, 3, 4};
    int len = sizeof(arr) / sizeof(arr[0]);

    int ultimo = arr[0];
    for (int i = 0; i < (len - 1); i++) {
        arr[i] = arr[i + 1];
    }
    arr[len - 1] = ultimo;

    for (int i = 0; i < len; i++) {
    printf("%d", arr[i]);
    }
    return 0;
}