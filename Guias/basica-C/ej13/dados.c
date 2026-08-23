#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    int contador[6] = {0};

    srand(time(NULL)); // semilla para que cada tirada sea al azar

    for (int i = 0; i < 60000000; i++) {
        int tirada = (rand() % 6) + 1 ;
        contador[tirada - 1]++;
    }

    for (int i = 0; i < 6; i++) {
        printf("Cara %d: %d veces\n", i + 1, contador[i]);
    }
    return 0;
}