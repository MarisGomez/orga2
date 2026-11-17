#include "../ejs.h"
#include <string.h>

void actualizar_movimientos_pokemon(pokemon_t* pokemon, char** nuevos_movimientos, int cantidad) {
    if(pokemon != NULL) {
        int n = cantidad < 4 ? cantidad : 4; // if cantidad < 4 then cantidad else 4 (esto porque cantidad puede ser > 4)
        for (int i = 0; i < 4; i++) {
            free(pokemon->movimientos[i]);
            if (i < n) { // i < cantidad || 4
                pokemon->movimientos[i] = malloc(strlen(nuevos_movimientos[i]) + 1);
                strcpy(pokemon->movimientos[i], nuevos_movimientos[i]);
            } else { // i > cantidad
                pokemon->movimientos[i] = NULL;
            }
        }
    }
}