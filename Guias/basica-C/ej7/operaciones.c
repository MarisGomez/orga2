#include <stdio.h>
#include <stdint.h>

int main() {
    int a = 5, b = 3, c = 2, d = 1;

    printf("Valor a: %d \n", a);
    printf("Valor b: %d \n", b);
    printf("Valor c: %d \n", c);
    printf("Valor d: %d \n", d);

    printf("a + b * c / d: %d \n", a + b * c / d);
    printf("a %% b: %d \n", a % b); // Para mostrar un % literal, se usa %%
    printf("a == b: %d \n", a == b); // 1 → verdadero
    printf("a != b: %d \n", a != b); // 0 → falso
    printf("a & b: %d \n", a & b); // compara bit a bit: 0101 & 0011 → 0001 = 1 decimal
    printf("a | b: %d \n", a | b); // 0101 | 0011 → 0111 = 7 decimal
    printf("~a: %d \n", ~a); // ~ invierte todos los bits de la variable.
    printf("a && b: %d \n", a && b); // && evalúa si ambos operandos son distintos de cero.
    printf("a || b: %d \n", a || b); // || evalúa si al menos uno es distinto de cero.
    printf("a << 1: %d \n", a << 1); // << es el desplazamiento a la izquierda.
    printf("a >> 1: %d \n", a >> 1); // >> es el desplazamiento a la derecha.
    printf("a += b: %d \n", a += b); // a += b suma b a a y guarda el resultado en a.
    printf("a -= b: %d \n", a -= b);
    printf("a *= b: %d \n", a *= b);
    printf("a /= b: %d \n", a /= b);
    printf("a %%= b: %d \n", a %= b); // %= aplica el módulo y guarda el resultado.
}