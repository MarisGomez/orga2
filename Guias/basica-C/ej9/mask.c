#include <stdio.h>
#include <stdint.h>

int main() {
    uint32_t a = 0xDEADBEEF;
    uint32_t b = 0xCAFEBABE;

    uint32_t lowmask = a & 0x7; // conserva solo los 3 bits menos significativos (en binario 000...000111).
    uint32_t highmask = b & 0xE0000000; // conserva solo los 3 bits más significativos  (en binario 1110...00000000).

    if (lowmask << 29 == highmask) { // Al hacer lowmask << 29, esos 3 bits se desplazan hasta la posición más alta (bits 31–29) y se puede comparar.
        printf("Los 3 bits más altos de 'a' son iguales a los 3 bits más bajos de 'b'.\n");
    } else {
        printf("No son iguales.\n");
    }

    return 0;
}