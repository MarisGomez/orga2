; ------------------------
; Offsets para los structs
; Plataforma: x86_64 (LP64)
; ------------------------

section .data

section .text

; ------------------------
; info_t (packed)
; ------------------------
INFO_NOMBRE_OFFSET        EQU 0   ; char nombre[16]
INFO_TIPO_OFFSET          EQU 0   ; char tipo[12]
INFO_NIVEL_OFFSET         EQU 0   ; uint16_t nivel
INFO_TAMANIO              EQU 0   ; sizeof(info_t)

; ------------------------
; pokemon_t
; ------------------------
POKEMON_ID_OFFSET               EQU 0   ; uint16_t id
POKEMON_MOVIMIENTOS_OFFSET      EQU 0   ; char* movimientos[4]
POKEMON_INFO_OFFSET             EQU 0   ; info_t info
POKEMON_DESCRIPCION_OFFSET      EQU 0   ; char* descripcion
POKEMON_EVOLUCIONA_DE_ID_OFFSET EQU 0   ; uint16_t evoluciona_de_id
POKEMON_TAMANIO                 EQU 0   ; sizeof(pokemon_t)

; ------------------------
; nodo_evolucion_t
; ------------------------
NODO_EVOLUCION_ID_OFFSET            EQU 0   ; uint16_t id
NODO_EVOLUCION_EVOLUCIONA_EN_OFFSET EQU 0   ; struct nodo_evolucion* evoluciona_en
NODO_EVOLUCION_TAMANIO              EQU 0   ; sizeof(nodo_evolucion_t)

; ------------------------
; pokedex_t
; ------------------------
POKEDEX_POKEMONS_OFFSET EQU 0   ; matriz_pokemons pokemons
POKEDEX_BITMAP_OFFSET   EQU 0   ; uint8_t* bitmap
POKEDEX_FILAS_OFFSET    EQU 0   ; uint32_t filas
POKEDEX_COLUMNAS_OFFSET EQU 0   ; uint32_t columnas
POKEDEX_TAMANIO         EQU 0   ; sizeof(pokedex_t)

; ------------------------
; pokemon_filtrados_t
; ------------------------
POKEMON_FILTRADOS_IDS_OFFSET      EQU 0   ; uint16_t* ids_pokemons
POKEMON_FILTRADOS_CANTIDAD_OFFSET EQU 0   ; uint16_t cantidad_pokemons
POKEMON_FILTRADOS_TAMANIO         EQU 0   ; sizeof(pokemon_filtrados_t)

; ------------------------
; Funciones externas
; ------------------------
extern malloc
extern free
extern strdup
extern strlen
extern strcpy

; ----------------------------------------------------
; void actualizar_movimientos_pokemon(pokemon_t* pokemon, char** nuevos_movimientos, int cantidad)
; Argumentos:
;   ??? = pokemon_t* pokemon
;   ??? = char** nuevos_movimientos
;   ??? = int cantidad
; ----------------------------------------------------
global actualizar_movimientos_pokemon
actualizar_movimientos_pokemon:
    ret

