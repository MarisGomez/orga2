#include "../ejs.h"
#include "../utils.h"
#include <string.h>

pokemon_t* buscar_pokemon_por_id(pokedex_t* pokedex, uint16_t id) {
    for (uint32_t i = 0; i < pokedex->filas; i++){
        for (uint32_t j = 0; j < pokedex->columnas; j++){
            pokemon_t* pokemon_actual = (pokemon_t*) pokedex->pokemons[i][j];

            if(pokemon_actual->id == id) return pokemon_actual;
        }
    }
}


nodo_evolucion_t* rastrear_linea_evolutiva(pokedex_t* pokedex, uint16_t id_final) {
    nodo_evolucion_t* res = (nodo_evolucion_t*) malloc(sizeof(nodo_evolucion_t));

    pokemon_t* pokemon = buscar_pokemon_por_id(pokedex, id_final);

    while(pokemon->evoluciona_de_id != 0){
        res->id = pokemon->evoluciona_de_id;
        res->evoluciona_en = pokemon->id;

        pokemon->id = pokemon->evoluciona_de_id;
    }

    res->id = 0;
    res->evoluciona_en = pokemon->id;
    return pokemon;
}
