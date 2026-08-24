#include <stdio.h>

int main(){
    int x = 42;
    int *p = &x;

    printf("Direccion de x: %p Valor: %d\n", (void*) &x, x);
    printf("Direccion de p: %p Valor: %p\n", (void*) &p, (void*) p);
    printf("Valor de lo que apunta p: %d\n", *p);
}

// Direccion de x: 0x7fff803877ec (&x) | Valor: 42
// Direccion de p: 0x7fff803877f0 (&p) | Valor: 0x7fff803877ec (&x)
// Valor de lo que apunta p: 42 (x = *p)