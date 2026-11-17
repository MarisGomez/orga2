#include "../ejs.h"
#include "../utils.h"
#include <string.h>

pokemon_filtrados_t* obtener_avistados_por_tipo(pokedex_t* pokedex, char* tipo_objetivo) {
    pokemon_filtrados_t* pokemons_res = (pokemon_filtrados_t*) malloc(sizeof(pokemon_filtrados_t));
    pokemons_res->ids_pokemons = (uint16_t*) malloc(20 * 2);
    pokemons_res->cantidad_pokemons = 0; // Es un valor, no un puntero
    uint16_t index = 0;

    for (uint32_t i = 0; i < pokedex->filas; i++){
        for (uint32_t j = 0; j < pokedex->columnas; j++){
            pokemon_t* pokemon_actual = (pokemon_t*) pokedex->pokemons[i][j];

            uint32_t pos = i * pokedex->columnas + j;
            uint8_t bit = obtener_bit(pokedex->bitmap, pos);

            if(bit == 1 && strcmp(pokemon_actual->info.tipo, tipo_objetivo) == 0){
                pokemons_res->ids_pokemons[index] = pokemon_actual->id;
                pokemons_res->cantidad_pokemons ++;
                index ++;
            }
        }
    }
    return pokemons_res;
}

