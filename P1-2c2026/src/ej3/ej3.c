#include "../ejs.h"
#include "../utils.h"
#include <string.h>

pokemon_t* buscar_pokemon_por_id(pokedex_t* pokedex, uint16_t id) {
    for (uint32_t i = 0; i < pokedex->filas; i++){
        for (uint32_t j = 0; j < pokedex->columnas; j++){
            pokemon_t* pokemon_actual = (pokemon_t*) pokedex->pokemons[i][j];

            if(pokemon_actual != NULL && pokemon_actual->id == id) return pokemon_actual;
        }
    }
    return NULL;
}


nodo_evolucion_t* rastrear_linea_evolutiva(pokedex_t* pokedex, uint16_t id_final) {
    nodo_evolucion_t* cabeza = NULL;
    uint16_t id_actual = id_final;

    while(id_actual != 0){
        pokemon_t* pokemon = buscar_pokemon_por_id(pokedex, id_actual);

        nodo_evolucion_t* nodo = (nodo_evolucion_t*) malloc(sizeof(nodo_evolucion_t));
        nodo->id = id_actual;
        nodo->evoluciona_en = cabeza;
        cabeza = nodo;

        id_actual = pokemon->evoluciona_de_id;
    }
    return cabeza;
}
