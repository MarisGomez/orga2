#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define NAME_LEN 50

typedef struct {
    char nombre[NAME_LEN + 1];
    int edad;
} persona_t;

persona_t* crearPersona(char nombre[], int edad){
    persona_t* persona = malloc(sizeof(persona_t));

    strcpy(persona->nombre, nombre);
    persona->edad = edad;

    return persona;
}

void eliminarPersona(persona_t* persona){
    free(persona);
}

int main(){
    persona_t* persona = crearPersona("Juan", 21);

    printf("Nombre: %s | Edad: %d\n", persona->nombre, persona->edad);

    free(persona);

    return 0;
}
