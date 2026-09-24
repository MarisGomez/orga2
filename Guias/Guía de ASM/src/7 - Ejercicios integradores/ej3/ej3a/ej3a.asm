extern malloc
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0 ; padding de 1 byte
CASO_ESTADO_OFFSET EQU 4    ; padding de 2 bytes
CASO_USUARIO_OFFSET EQU 8
CASO_SIZE EQU 16

SEGMENTACION_CASOS0_OFFSET EQU 0
SEGMENTACION_CASOS1_OFFSET EQU 8
SEGMENTACION_CASOS2_OFFSET EQU 16
SEGMENTACION_SIZE EQU 24

ESTADISTICAS_CLT_OFFSET EQU 0
ESTADISTICAS_RBO_OFFSET EQU 1
ESTADISTICAS_KSC_OFFSET EQU 2
ESTADISTICAS_KDT_OFFSET EQU 3
ESTADISTICAS_ESTADO0_OFFSET EQU 4
ESTADISTICAS_ESTADO1_OFFSET EQU 5
ESTADISTICAS_ESTADO2_OFFSET EQU 6
ESTADISTICAS_SIZE EQU 7

;int contar_casos_por_nivel(caso_t* arreglo_casos, int largo, int nivel)
; arreglo_casos(caso_t*) [RDI]
; largo                  [RSI]
; nivel                  [RDX]
contar_casos_por_nivel:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

mov r12, rdi ; arreglo_casos[r12]
mov r13, rsi ; largo[r13]
mov r14, rdx ; nivel[r14]

xor r15, r15 ; i = 0
xor rbx, rbx ; contador = 0

.ciclo:
    cmp r15, r13
    jae .fin

    imul rdx, r15, CASO_SIZE ; rdx = i * CASO_SIZE
    mov r8, [r12 + rdx + CASO_USUARIO_OFFSET] ; r8 = caso.usuario

    ; if (caso.usuario->nivel == nivel)
    mov ecx, dword [r8 + USUARIO_NIVEL_OFFSET] ; exc = caso.usuario->nivel

    cmp ecx, r14d
    jne .sigue ; si no son el mismo nivel seguimos iterando

    inc rbx ; contador += 1

.sigue:
    inc r15 ; i++
    jmp .ciclo

.fin:
mov rax, rbx

add rsp, 8
pop rbx
pop r15
pop r14
pop r13
pop r12
pop rbp
ret


;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)
; arreglo_casos(caso_t*) [RDI]
; largo                  [RSI]
global segmentar_casos
segmentar_casos:
push rbp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

mov r12, rdi ; arreglo_casos[r12]
mov r13d, esi ; largo[r13d]

; INICIALIZO LOS CONTADORES
; contador0
mov rdi, r12
mov rsi, r13
xor rdx, rdx ; rdx = 0
call contar_casos_por_nivel
mov r14d, eax ; contador0

; contador1
mov rdi, r12
mov rsi, r13
mov rdx, 1 ; rdx = 1
call contar_casos_por_nivel
mov r15d, eax ; contador1

; contador2
mov rdi, r12
mov rsi, r13
mov rdx, 2 ; rdx = 2
call contar_casos_por_nivel
mov ebx, eax ; contador2

; defino segmento
mov rdi, SEGMENTACION_SIZE
call malloc
mov rbp, rax ; rbp = segmento

; DEFINO LOS CASOS POR NIVEL
.casos_nivel_0:
    test r14, r14
    je .null0

    imul rdi, r14, CASO_SIZE ; contador0 * sizeof(caso_t)
    call malloc
    mov [rbp + SEGMENTACION_CASOS0_OFFSET], rax
    jmp .casos_nivel_1

    .null0:
    mov qword [rbp + SEGMENTACION_CASOS0_OFFSET], 0

.casos_nivel_1:
    test r15, r15
    je .null1

    imul rdi, r15, CASO_SIZE ; contador1 * sizeof(caso_t)
    call malloc
    mov [rbp + SEGMENTACION_CASOS1_OFFSET], rax
    jmp .casos_nivel_2

    .null1:
    mov qword [rbp + SEGMENTACION_CASOS1_OFFSET], 0

.casos_nivel_2:
    test rbx, rbx
    je .null2

    imul rdi, rbx, CASO_SIZE ; contador2 * sizeof(caso_t)
    call malloc
    mov [rbp + SEGMENTACION_CASOS2_OFFSET], rax
    jmp .continue

    .null2:
    mov qword [rbp + SEGMENTACION_CASOS2_OFFSET], 0

.continue:
    xor r8, r8 ; i = 0
    xor r9, r9 ; t0 = 0
    xor r10, r10 ; t1 = 0
    xor r11, r11 ; t2 = 0

.ciclo:
    cmp r8, r13
    jae .fin

    imul rcx, r8, CASO_SIZE ; rcx = i * CASO_SIZE

    mov rdx, [r12 + rcx + CASO_USUARIO_OFFSET] ; rdx = caso.usuario
    mov eax, [rdx + USUARIO_NIVEL_OFFSET]      ; eax = caso.usuario->nivel

    cmp eax, 0 ; caso.usuario->nivel == 0
    je .caso0
    cmp eax, 1 ; caso.usuario->nivel == 1
    je .caso1
    jmp .caso2 ; dominio: sobra nivel 2

.caso0:
    mov rdi, [rbp + SEGMENTACION_CASOS0_OFFSET] ; base del array nivel 0
    imul rdx, r9, CASO_SIZE                     ; rdx = t0 * CASO_SIZE
    mov rax, [r12 + rcx]                        ; primer qword del caso
    mov rsi, [r12 + rcx + 8]                    ; segundo qword del caso
    mov [rdi + rdx], rax
    mov [rdi + rdx + 8], rsi
    inc r9
    jmp .siguiente

.caso1:
    mov rdi, [rbp + SEGMENTACION_CASOS1_OFFSET] ; base del array nivel 1
    imul rdx, r10, CASO_SIZE                                 ; rdx = t1 * CASO_SIZE
    mov rax, [r12 + rcx]                        ; primer qword del caso
    mov rsi, [r12 + rcx + 8]                    ; segundo qword del caso
    mov [rdi + rdx], rax
    mov [rdi + rdx + 8], rsi
    inc r10
    jmp .siguiente

.caso2:
    mov rdi, [rbp + SEGMENTACION_CASOS2_OFFSET] ; base del array nivel 2
    imul rdx, r11, CASO_SIZE                                 ; rdx = t2 * CASO_SIZE
    mov rax, [r12 + rcx]                        ; primer qword del caso
    mov rsi, [r12 + rcx + 8]                    ; segundo qword del caso
    mov [rdi + rdx], rax
    mov [rdi + rdx + 8], rsi
    inc r11
    jmp .siguiente

.siguiente:
    inc r8
    jmp .ciclo

.fin:
mov rax, rbp

add rsp, 8
pop rbx
pop r15
pop r14
pop r13
pop r12
pop rbp
ret