#include <stdio.h> // Incluye la biblioteca stdio.h

int main() { // main es el punto de entrada
    printf("Hola Orga!\n"); // imprime en pantalla
    return 0; // devuelve un 0 al SO
}

// Ejecutamos en la terminal:
// En dos pasos:
// gcc -c hola.c -o hola.o
// gcc hola.o -o hola
// En uno solo:
// gcc hola.c -o hola
// ./hola

// Flags que brindan mas info en caso de errores:
// gcc -Wall -Wextra -pedantic -c hola.c -o hola.o
// gcc -Wall -Wextra -pedantic hola.o -o hola