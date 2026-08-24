#include <stdio.h>
#include <stdint.h>

int main(){
    int8_t memoria[5] = {10,20,30,40,50};
    uint8_t *x = (uint8_t*) &memoria[0]; // hacemos un cast ya que el arreglo es de tipo int8_t y el puntero uint8_t
    int8_t *y = &memoria[4];

    printf("Dir de x: %p Valor: %d\n", (void*) x, *x);
    printf("Dir de y: %p Valor: %d\n", (void*) y, *y);
}