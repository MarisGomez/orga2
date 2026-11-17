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
extern strdup
extern strlen
extern strcpy

; ----------------------------------------------------
; void actualizar_movimientos_pokemon(pokemon_t* pokemon, char** nuevos_movimientos, int cantidad)
; Argumentos:
;   RDI = pokemon_t* pokemon
;   RSI = char** nuevos_movimientos
;   RDX = int cantidad
; ----------------------------------------------------
global actualizar_movimientos_pokemon
actualizar_movimientos_pokemon:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r12, rdi ;; pokemon
mov r13, rsi ;; nuevos movimientos

test r12, r12 ;; if pokemon == NULL
jz .fin

cmp rdx, 4 ;; cantidad < 4 ?
jb .n_cantidad

mov r14, 4 ;; n = 4
jmp .for

.n_cantidad:
    mov r14, rdx ;; n = cantidad

.for:
    xor r15, r15 ;; i = 0
.ciclo:
    cmp r15, 4
    jae .fin

    mov rdi, [r12 + POKEMON_MOVIMIENTOS_OFFSET + r15 * 8]
    call free

    cmp r15, r14
    jb .copiar
    jmp .null

    .copiar:
        mov rdi, [r13 + r15 * 8]
        call strlen

        mov rdi, rax
        inc rdi
        call malloc

        mov [r12 + POKEMON_MOVIMIENTOS_OFFSET + r15 * 8], rax

        mov rdi, [r12 + POKEMON_MOVIMIENTOS_OFFSET + r15 * 8]
        mov rsi, [r13 + r15 * 8]
        call strcpy

        inc r15
        jmp .ciclo

    .null:
        mov qword[r12 + POKEMON_MOVIMIENTOS_OFFSET + r15 * 8], 0

        inc r15
        jmp .ciclo
.fin:
pop r15
pop r14
pop r13
pop r12
pop rbp
ret

