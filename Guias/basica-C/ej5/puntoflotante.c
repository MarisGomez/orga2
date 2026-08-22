#include <stdio.h>
#include <stdint.h>

int main() {
    float f = 0.1F;
    double d = 0.1;

    printf("Valor como float: %f \n", f);
    printf("Valor como double: %f \n", d);

    printf("Cast float->int: %d\n", (int)f);
    printf("Cast double->int: %d\n", (int)d);

    return 0;
}



