#include <stdio.h>

int main() {
    int mensaje_secreto[] = {116, 104, 101, 32, 103, 105, 102, 116, 32, 111, 102, 32, 119, 111, 114, 100, 115, 32, 105, 115, 32, 116, 104, 101, 32, 103, 105, 102, 116, 32, 111, 102, 32, 100, 101, 99, 101, 112, 116, 105, 111, 110, 32, 97, 110, 100, 32, 105, 108, 108, 117, 115, 105, 111, 110}; // Cada número es un código ASCII que representa un carácter

    size_t length = sizeof(mensaje_secreto) / sizeof(int); // tamaño total en bytes del arreglo /  tamaño de un entero.
    char decoded[length]; // Declara un arreglo de caracteres (char) con la misma longitud.

    for (size_t i = 0; i < length; i++) {
    decoded[i] = (char) (mensaje_secreto[i]); // casting de int a char
    } // Recorre el arreglo mensaje_secreto y convierte cada entero en su carácter ASCII equivalente. El resultado se guarda en decoded.

    for (size_t i = 0; i < length; i++) {
    printf("%c", decoded[i]);
    } // Recorre el arreglo decoded y va imprimiendo cada carácter con %c.

    // printf("%s", decoded); imprime todo de una.
}