#include <stdio.h>
#define NAME_LEN 50

typedef struct {
    char nombre[NAME_LEN + 1];
    int vida;
    double ataque;
    double defensa;
} monstruo_t;

monstruo_t lista_de_monstruos[] = {
    {"Nahuelito", 480, 120, 1000},
    {"Abyzou", 666, 500, 5000},
    {"Lobizon", 150, 60, 600},
    {"Pomberito", 80, 40, 100}
};

monstruo_t evolucion(monstruo_t m){
    m.ataque += 10;
    m.defensa += 10;

    return m;
}

int len = sizeof lista_de_monstruos / sizeof lista_de_monstruos[0];

int main(){
    for( int i = 0; i < len; i++){
        printf ("Nombre: %s, Vida: %d\n", lista_de_monstruos[i].nombre, lista_de_monstruos[i].vida);
    }

    monstruo_t babelito = {"Babelito", 1000, 666, 200};

    printf("Antes de evolucionar:\n");
    printf("Nombre: %s | Vida: %d | Ataque: %f | Defensa: %f\n",babelito.nombre, babelito.vida, babelito.ataque, babelito.defensa);

    babelito = evolucion(babelito);

    printf("Después de evolucionar:\n");
    printf("Nombre: %s | Vida: %d | Ataque: %f | Defensa: %f\n",babelito.nombre, babelito.vida, babelito.ataque, babelito.defensa);

    return 0;
}