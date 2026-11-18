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

ACC_NORTE EQU 0
ACC_SUR EQU 1
ACC_ESTE EQU 2
ACC_OESTE EQU 3
ACC_CANT EQU 4

; Notar que el enum aparece como puntero, entonces no afecta los offsets
extern malloc


global accionInversa
accionInversa:
cmp edi, ACC_NORTE
je .norte

cmp edi, ACC_SUR
je .sur

cmp edi, ACC_ESTE
je .este

cmp edi, ACC_OESTE
je .oeste

.norte:
    mov eax, ACC_SUR
    ret
.sur:
    mov eax, ACC_NORTE
    ret 
.este:
    mov eax, ACC_OESTE
    ret
.oeste:
    mov eax, ACC_ESTE
    ret

global  invertirRecorridoConDirecciones
invertirRecorridoConDirecciones:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r12, rdi ; rec
mov r13, rsi ; len

test r12, r12 ; rec == NULL?
jz .null
cmp [r12 + REC_ACCIONES_OFFSET], 0 ; rec->acciones == NULL
je .null
cmp [r12 + REC_CANT_ACCIONES_OFFSET], 0 ; rec->cant_acciones == 0
je .null

mov rdi, REC_SIZE
call malloc
mov r14, rax ; rec_res

mov rdi, ACC_CANT ; sizeof(Accion)
imul rdi, r13     ; * len
call malloc
mov [r14 + REC_ACCIONES_OFFSET], rax

mov [r14 + REC_CANT_ACCIONES_OFFSET], r13 ; rec_res->cant_acciones = len;

xor r15, r15 ; i = 0
.ciclo:
    cmp r15, r13
    jae .fin

    mov r8, r13
    sub r8, r15
    dec r8 ; len - 1 - i
    mov r9, [r12 + REC_ACCIONES_OFFSET] ; rec->acciones
    mov edi, dword[r9 + r8 * 4]         ; rec->acciones[len - 1 - i]
    call accionInversa
    
    mov r10, [r14 + REC_ACCIONES_OFFSET] ; rec_res->acciones
    mov dword[r10 + r15 * 4], eax        ; rec_res->acciones[i]

    inc r15
    jmp .ciclo

.null:
    xor rax, rax
    jmp .epilogo

.fin:
mov rax, r14
.epilogo:
pop r15
pop r14
pop r13
pop r12
pop rbp
ret
