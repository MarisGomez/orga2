#ifndef TEST_H
#define TEST_H

#include "../test_utils/test-utils.h"
#include "./ejs.h"

//*************************************
// Declaraciones de funciones auxiliares para tests
//*************************************

pokemon_t* crear_pokemon(uint16_t id, const char* nombre, const char* tipo,
                         uint16_t nivel, uint16_t evoluciona_de_id);
void agregar_movimiento(pokemon_t* p, int slot, const char* nombre_movimiento);
pokedex_t* crear_pokedex(uint32_t filas, uint32_t columnas);
void activar_bit_mapa(pokedex_t* pokedex, uint32_t indice);
void desactivar_bit_mapa(pokedex_t* pokedex, uint32_t indice);
void liberar_pokemon(pokemon_t* p);
void liberar_pokedex(pokedex_t* pokedex);
void liberar_pokemon_filtrados(pokemon_filtrados_t* res);
void liberar_cadenas_evolucion(nodo_evolucion_t** cadenas, int cantidad);
void liberar_cadena_evolucion(nodo_evolucion_t* cabeza);

// Helper para buscar un pokemon por id
pokemon_t* buscar_por_id(pokedex_t* pokedex, uint16_t id);

/**
 * Devuelve el valor del bit (0 o 1) en una posición dada dentro de un bitmap.
 *
 * @param bitmap    Puntero al arreglo de bytes del bitmap.
 * @param posicion  Índice del bit (0-indexado).
 * @return          1 si el bit está encendido, 0 si está apagado.
 */
uint8_t obtener_bit(const uint8_t* bitmap, uint32_t posicion);

// Crea una pokedex 16x10 con los 151 pokemon de Gen 1
// Bitmap: pokemon con ID par estan vistos
// Cada pokemon tiene 2-4 movimientos segun su tipo
pokedex_t* crear_pokedex_gen1(void);

#endif
