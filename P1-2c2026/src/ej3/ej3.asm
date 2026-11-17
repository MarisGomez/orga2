; ------------------------
; Offsets para los structs
; Plataforma: x86_64 (LP64)
; ------------------------

section .data

section .text

; ------------------------
; info_t (packed)
; ------------------------
INFO_NOMBRE_OFFSET        EQU 0    ; char nombre[16]
INFO_TIPO_OFFSET          EQU 16   ; char tipo[12]
INFO_NIVEL_OFFSET         EQU 28   ; uint16_t nivel
INFO_TAMANIO              EQU 30   ; sizeof(info_t)
;; | N | N | N | N | N | N | N | N |
;; | N | N | N | N | N | N | N | N |
;; | type | type | type | type | type | type | type | type |
;; | type | type | type | type | lvl | lvl | 0 | 0 |

; ------------------------
; pokemon_t
; ------------------------
POKEMON_ID_OFFSET               EQU 0   ; uint16_t id
POKEMON_MOVIMIENTOS_OFFSET      EQU 8   ; char* movimientos[4] (OJO: ES UN PUNTERO * 4)
POKEMON_INFO_OFFSET             EQU 40  ; info_t info
POKEMON_DESCRIPCION_OFFSET      EQU 72  ; char* descripcion
POKEMON_EVOLUCIONA_DE_ID_OFFSET EQU 80  ; uint16_t evoluciona_de_id
POKEMON_TAMANIO                 EQU 88  ; sizeof(pokemon_t)
;; | ID | ID | 0 | 0 | 0 | 0 | 0 | 0 |
;; | MOV | MOV | MOV | MOV | MOV | MOV | MOV | MOV |
;; | MOV | MOV | MOV | MOV | MOV | MOV | MOV | MOV |
;; | MOV | MOV | MOV | MOV | MOV | MOV | MOV | MOV |
;; | MOV | MOV | MOV | MOV | MOV | MOV | MOV | MOV |
;; | info | info | info | info | info | info | info | info |
;; | info | info | info | info | info | info | info | info |
;; | info | info | info | info | info | info | info | info |
;; | info | info | info | info | info | info | 0 | 0 |
;; | DESC | DESC | DESC | DESC | DESC | DESC | DESC | DESC |
;; | EVOL | EVOL | 0 | 0 | 0 | 0 | 0 | 0 |

; ------------------------
; nodo_evolucion_t
; ------------------------
NODO_EVOLUCION_ID_OFFSET            EQU 0   ; uint16_t id
NODO_EVOLUCION_EVOLUCIONA_EN_OFFSET EQU 8   ; struct nodo_evolucion* evoluciona_en
NODO_EVOLUCION_TAMANIO              EQU 16  ; sizeof(nodo_evolucion_t)
;; | ID | ID | 0 | 0 | 0 | 0 | 0 | 0 |
;; | EVOL | EVOL | EVOL | EVOL | EVOL | EVOL | EVOL | EVOL |

; ------------------------
; pokedex_t
; ------------------------
POKEDEX_POKEMONS_OFFSET EQU 0   ; matriz_pokemons pokemons
POKEDEX_BITMAP_OFFSET   EQU 8   ; uint8_t* bitmap
POKEDEX_FILAS_OFFSET    EQU 16  ; uint32_t filas
POKEDEX_COLUMNAS_OFFSET EQU 20  ; uint32_t columnas
POKEDEX_TAMANIO         EQU 24   ; sizeof(pokedex_t)
;; | mat | mat | mat | mat | mat | mat | mat | mat |
;; | bit | bit | bit | bit | bit | bit | bit | bit |
;; | fil | fil | fil | fil | col | col | col | col |

; ------------------------
; pokemon_filtrados_t
; ------------------------
POKEMON_FILTRADOS_IDS_OFFSET      EQU 0   ; uint16_t* ids_pokemons
POKEMON_FILTRADOS_CANTIDAD_OFFSET EQU 8   ; uint16_t cantidad_pokemons
POKEMON_FILTRADOS_TAMANIO         EQU 16  ; sizeof(pokemon_filtrados_t)
;; | ID | ID | ID | ID | ID | ID | ID | ID |
;; | cant | cant | 0 | 0 | 0 | 0 | 0 | 0 |

; ------------------------
; Funciones externas
; ------------------------
extern malloc
extern free

; ----------------------------------------------------
; pokemon_t* buscar_pokemon_por_id(pokedex_t* pokedex, uint16_t id)
; Argumentos:
;   ??? = pokedex_t* pokedex
;   ???  = uint16_t id
; Retorno:
;   ??? = pokemon_t* (o NULL si no se encuentra / id == 0)
; ----------------------------------------------------
global buscar_pokemon_por_id
buscar_pokemon_por_id:
    xor rax, rax
    ret

; ----------------------------------------------------
; nodo_evolucion_t* rastrear_linea_evolutiva(pokedex_t* pokedex, uint16_t id_final)
; Argumentos:
;   ??? = pokedex_t* pokedex
;   ???  = uint16_t id_final
; Retorno:
;   ??? = nodo_evolucion_t*
; ----------------------------------------------------
global rastrear_linea_evolutiva
rastrear_linea_evolutiva:
    xor rax, rax
    ret
