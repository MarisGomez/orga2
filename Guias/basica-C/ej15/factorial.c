#include <stdio.h>

int factorial(int n) {
    if (n < 0) {
        return -1; // indicador de error
    }

    int res = 1; // inicializar
    for (int i = 1; i <= n; i++) {
        res *= i;
    }
    return res;
}

int main(void) {
    int n;
    printf("Ingrese un numero: ");
    scanf("%d", &n);

    int resultado = factorial(n);

    if (resultado == -1) {
        printf("El factorial no está definido para números negativos.\n");
    } else {
        printf("El factorial de %d es %d\n", n, resultado);
    }

    return 0;
}
