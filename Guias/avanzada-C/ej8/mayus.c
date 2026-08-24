#include <stdio.h>

void aMayusculas(char *str) {
    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] >= 'a' && str[i] <= 'z') {
            str[i] = str[i] + ('A' - 'a');
        }
    }
}

int main() {
    char texto[] = "Hola mundo en minusculas";
    aMayusculas(texto);
    printf("%s\n", texto);  // Imprime: HOLA MUNDO EN MINUSCULAS
    return 0;
}
