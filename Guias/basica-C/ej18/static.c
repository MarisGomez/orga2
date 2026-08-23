#include <stdio.h>
#define FELIZ 0
#define TRISTE 1

int estado = TRISTE; // static duration. File scope

void alcoholizar();

void print_estado();

int main(){
    print_estado();
    alcoholizar();
    print_estado();
    alcoholizar();alcoholizar();alcoholizar();
    print_estado(); // que imprime?
}

void alcoholizar(){
    static int cantidad = 0; // static duration. block scope
    cantidad++;
    if(cantidad < 3){
        estado = FELIZ;
    }else{
        estado = TRISTE;
    }
}

void print_estado(){
    printf("Estoy %s\n", estado == FELIZ ? "feliz" : "triste");
}

// static hace que la variable recuerde su valor entre llamadas. Es como una memoria interna de la función