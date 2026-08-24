#include <stdio.h>
#include <string.h>

int main() {
    // Ejemplo strcpy
    char origen[] = "Hola mundo";
    char destino[20];

    strcpy(destino, origen);

    printf("Cadena copiada: %s\n", destino);

    // Ejemplo strcat
    char saludo[30] = "Hola";
    char nombre[] = " Juan";

    strcat(saludo, nombre);

    printf("Saludo completo: %s\n", saludo);

    // Ejemplo strlen
    char texto[] = "Arquitectura y Organización de Computadores";
    size_t longitud = strlen(texto);

    printf("La longitud de '%s' es %zu\n", texto, longitud);

    // Ejemplo strcmp
    char a[] = "Hola";
    char b[] = "Hola";
    char c[] = "Chau";

    printf("Comparando a y b: %d\n", strcmp(a, b)); // 0 → iguales
    printf("Comparando a y c: %d\n", strcmp(a, c)); // ≠ 0 → distintas

    // Ejemplo strchr
    // teniendo char texto[] = "Arquitectura y Organización de Computadores";
    char *ptr = strchr(texto, 'C');

    if (ptr != NULL) {
        printf("Encontrado en posición: %ld\n", ptr - texto);
    } else {
        printf("No se encontró el carácter.\n");
    }
    return 0;
}