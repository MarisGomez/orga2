; ------------------------
; Offsets para los structs
; Plataforma: x86_64 (LP64)
; ------------------------

section .data

section .text

; COMPLETAR las definiciones (serán revisadas por ABI enforcer):
; ------------------------
; Contenido
; ------------------------
CONT_NOMBRE_OFFSET      EQU 0      ; char nombre[64]             | 64
CONT_VALOR_OFFSET       EQU 64     ; uint32_t valor              | 4 <-
CONT_COLOR_OFFSET       EQU 68     ; char color[32]              | 32
CONT_ES_TESORO_OFFSET   EQU 100    ; bool es_tesoro              | 1
CONT_PESO_OFFSET        EQU 104    ; float peso                  | 4 <-
CONT_SIZE               EQU 108    ; sizeof(Contenido) (rounded) | DEBE ESTAR ALINEADO A 4
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | val | val | val | val | col | col | col | col | (char[] requiere alineacion 1 / mide 1)
; | col | col | col | col | col | col | col | col |
; | col | col | col | col | col | col | col | col |
; | col | col | col | col | col | col | col | col |
; | col | col | col | col | es | 0 | 0 | 0 |        (bool requiere alineacion 1 / mide 1)
; | peso | peso | peso | peso | 0 | 0 | 0 | 0 |     (float requiere alineacion 4 / mide 4)

; ------------------------
; Habitacion
; ------------------------
HAB_ID_OFFSET          EQU 0      ; uint32_t id                 | 4
HAB_VECINOS_OFFSET     EQU 4      ; uint32_t vecinos[ACC_CANT]  | 16
HAB_CONTENIDO_OFFSET   EQU 20     ; Contenido contenido         | 108 
HAB_VISITAS_OFFSET     EQU 128    ; uint32_t visitas            | 4
HAB_SIZE               EQU 132    ; sizeof(Habitacion)          | DEBE ESTAR ALINEADO A 4
; | ID | ID | ID | ID | veci | veci | veci | veci |
; | veci | veci | veci | veci | veci | veci | veci | veci |
; | veci | veci | veci | veci | C | C | C | C |
; | C | C | C | ..................... | C | C | C |
; | vis | vis | vis | vis | 0 | 0 | 0 | 0 |

; ------------------------
; Mapa
; ------------------------
MAP_HABITACIONES_OFFSET    EQU 0     ; Habitacion *habitaciones  | 8
MAP_N_HABITACIONES_OFFSET  EQU 8     ; uint64_t n_habitaciones   | 8
MAP_ID_ENTRADA_OFFSET      EQU 16    ; uint32_t id_entrada       | 4
MAP_SIZE                   EQU 24    ; sizeof(Mapa)              | DEBE ESTAR ALINEADO A 8

; ------------------------
; Recorrido
; ------------------------
REC_ACCIONES_OFFSET        EQU 0     ; Accion *acciones        | 8
REC_CANT_ACCIONES_OFFSET   EQU 8     ; uint64_t cant_acciones  | 8
REC_SIZE                   EQU 16    ; sizeof(Recorrido)       | DEBE ESTAR ALINEADO A 8

; Notar que el enum aparece como puntero, entonces no afecta los offsets

global  encontrarTesoroEnMapa
encontrarTesoroEnMapa:
    ret