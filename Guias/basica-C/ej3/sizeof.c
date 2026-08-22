#include <stdio.h>

int main() {
    char c = 100;
    short s = -8712;
    int i = 123456;
    long l = 1234567890;

    printf("char(%lu): %d \n", sizeof(c),c); // sizeof(c) devuelve el tamaño en bytes de la variable c
    printf("short(%lu): %d \n", sizeof(s),s); // %d para int y short
    printf("int(%lu): %d \n", sizeof(i),i); // 
    printf("long(%lu): %ld \n", sizeof(l),l); // %ld para long
// %lu para unsigned long (en este caso se usa para imprimir el resultado de sizeof, que devuelve un size_t
    return 0;
}