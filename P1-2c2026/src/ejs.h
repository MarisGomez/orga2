#pragma once
#include <assert.h>
#include <ctype.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

//*************************************
// Declaración de estructuras de la Pokedex
//*************************************

typedef struct __attribute__((packed)) {
    char nombre[16]; // asmdef_offset:INFO_NOMBRE_OFFSET
    char tipo[12];   // asmdef_offset:INFO_TIPO_OFFSET
    uint16_t nivel;  // asmdef_offset:INFO_NIVEL_OFFSET        
} info_t;            // asmdef_size:INFO_TAMANIO

typedef struct {
    uint16_t id;                        // asmdef_offset:POKEMON_ID_OFFSET
    char* movimientos[4];               // asmdef_offset:POKEMON_MOVIMIENTOS_OFFSET
    info_t info;                        // asmdef_offset:POKEMON_INFO_OFFSET
    char* descripcion;                  // asmdef_offset:POKEMON_DESCRIPCION_OFFSET
    uint16_t evoluciona_de_id;          // asmdef_offset:POKEMON_EVOLUCIONA_DE_ID_OFFSET
} pokemon_t;                            // asmdef_size:POKEMON_TAMANIO

typedef struct nodo_evolucion {
    uint16_t id;                          // asmdef_offset:NODO_EVOLUCION_ID_OFFSET
    struct nodo_evolucion* evoluciona_en; // asmdef_offset:NODO_EVOLUCION_EVOLUCIONA_EN_OFFSET
} nodo_evolucion_t;                       // asmdef_size:NODO_EVOLUCION_TAMANIO

typedef pokemon_t*** matriz_pokemons;

typedef struct {
    matriz_pokemons pokemons;    // asmdef_offset:POKEDEX_POKEMONS_OFFSET
    uint8_t* bitmap;             // asmdef_offset:POKEDEX_BITMAP_OFFSET
    uint32_t filas;              // asmdef_offset:POKEDEX_FILAS_OFFSET
    uint32_t columnas;           // asmdef_offset:POKEDEX_COLUMNAS_OFFSET
} pokedex_t;                     // asmdef_size:POKEDEX_TAMANIO

typedef struct {
    uint16_t* ids_pokemons;       // asmdef_offset:POKEMON_FILTRADOS_IDS_OFFSET
    uint16_t cantidad_pokemons;   // asmdef_offset:POKEMON_FILTRADOS_CANTIDAD_OFFSET
} pokemon_filtrados_t;           // asmdef_size:POKEMON_FILTRADOS_TAMANIO

//*************************************
// Declaración de funciones de los ejercicios
//*************************************

void actualizar_movimientos_pokemon(pokemon_t* pokemon, char** nuevos_movimientos, int cantidad);

pokemon_filtrados_t* obtener_avistados_por_tipo(pokedex_t* pokedex, char* tipo_objetivo);

nodo_evolucion_t* rastrear_linea_evolutiva(pokedex_t* pokedex, uint16_t id_final);
