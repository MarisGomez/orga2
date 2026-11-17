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
extern strcmp
extern obtener_bit  ; uint8_t obtener_bit(const uint8_t* bitmap, uint32_t posicion)

; ----------------------------------------------------
; pokemon_filtrados_t* obtener_avistados_por_tipo(pokedex_t* pokedex, char* tipo_objetivo)
; Argumentos:
;   RDI = pokedex_t* pokedex
;   RSI = char* tipo_objetivo
; Retorno:
;   RAX = pokemon_filtrados_t*
; ----------------------------------------------------
global obtener_avistados_por_tipo
obtener_avistados_por_tipo:
push rbp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

mov r12, rdi ;; pokedex
mov r13, rsi ;; tipo_objetivo

mov rdi, POKEMON_FILTRADOS_TAMANIO
call malloc
mov r14, rax ;; pokemons_res

mov rdi, 40
call malloc
mov [r14 + POKEMON_FILTRADOS_IDS_OFFSET], rax ;; pokemons_res->ids_pokemons
mov word[r14 + POKEMON_FILTRADOS_CANTIDAD_OFFSET], 0 ;; pokemons_res->cantidad_pokemons

xor r15, r15 ;; index
xor rbx, rbx ;; i
.ciclo_filas:
    cmp ebx, dword[r12 + POKEDEX_FILAS_OFFSET]
    jae .fin

    xor rbp, rbp ;; j
    .ciclo_columnas:
        cmp ebp, dword[r12 + POKEDEX_COLUMNAS_OFFSET]
        jae .siguiente_fila

        mov rdi, [r12 + POKEDEX_BITMAP_OFFSET] ;; pokedex->bitmap
        mov r8d, dword[r12 + POKEDEX_COLUMNAS_OFFSET] ;; pokedex->columnas
        imul r8, rbx
        lea esi, dword[r8 + rbp] ;; pokedex->columnas * i + j = pos | LEA CALCULA LA DIR EFECTIVA
        call obtener_bit

        cmp rax, 1
        jne .siguiente_columna

        mov r9, [r12 + POKEDEX_POKEMONS_OFFSET]
        mov r10, [r9 + rbx * 8 ]
        mov r11, [r10 + rbp * 8] ;; pokemon_actual
        
        lea rdi, [r11 + POKEMON_INFO_OFFSET + INFO_TIPO_OFFSET]
        mov rsi, r13
        call strcmp

        cmp rax, 0
        jne .siguiente_columna

        mov r9, [r12 + POKEDEX_POKEMONS_OFFSET] ;; VUELVO A COPIAR
        mov r10, [r9 + rbx * 8 ]
        mov r11, [r10 + rbp * 8] ;; pokemon_actual

        mov r8, [r11 + POKEMON_ID_OFFSET] ;; pokemon_actual->id
        mov r9, [r14 + POKEMON_FILTRADOS_IDS_OFFSET]
        mov [r9 + r15 * 2], r8 ;; pokemons_res->ids_pokemons[index] = pokemon_actual->id;
        inc r15
        mov word[r14 + POKEMON_FILTRADOS_CANTIDAD_OFFSET], r15w

    .siguiente_columna:
        inc rbp
        jmp .ciclo_columnas
    .siguiente_fila:
        inc rbx
        jmp .ciclo_filas
.fin:
mov rax, r14

add rsp, 8
pop rbx
pop r15
pop r14
pop r13
pop r12
pop rbp
ret

