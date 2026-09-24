extern strcmp
;########### SECCION DE DATOS
section .data
    categoria_clt db "CLT", 0
    categoria_rbo db "RBO", 0

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0
CASO_ESTADO_OFFSET EQU 4
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

;void resolver_automaticamente(funcionCierraCasos* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo)
; funcion         [RDI]
; arreglo_casos   [RSI]
; casos_a_revisar [RDX]
; largo           [RCX]
global resolver_automaticamente
resolver_automaticamente:
    push rbp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8

    mov r12, rdi ; funcion         [R12]
    mov r13, rsi ; arreglo_casos   [R13]
    mov r14, rdx ; casos_a_revisar [R14]
    mov r15, rcx ; largo           [R15]

    xor rbx, rbx ; index = 0
    xor rbp, rbp ; i = 0

.ciclo:
    cmp rbp, r15
    jae .fin

    imul rcx, rbp, CASO_SIZE ; rcx = i * CASO_SIZE
    mov rdx, [r13 + rcx + CASO_USUARIO_OFFSET] ; rdx = caso.usuario
    mov eax, [rdx + USUARIO_NIVEL_OFFSET] ; eax = caso.usuario->nivel

    ; if (caso.usuario->nivel == 0)
    cmp eax, 0
    je .caso_a_revisar

    ; if (caso.usuario->nivel == 1 || caso.usuario->nivel == 2)
    imul rcx, rbp, CASO_SIZE ; rcx = i * CASO_SIZE
    lea rdi, [r13 + rcx]
    call r12 ; eax = funcion(&caso)

    ; if (res_func == 1)
    cmp eax, 1
    je .cerrar_favorable

    ; res_func == 0 
    ; chequeo categorias "CLT" y "RBO"
    imul rcx, rbp, CASO_SIZE ; rcx = i * CASO_SIZE
    lea rdx, [r13 + rcx + CASO_CATEGORIA_OFFSET] ; rdx = &caso.categoria
    
    mov rdi, rdx
    mov rsi, categoria_clt
    call strcmp
    cmp rax, 0
    je .cerrar_desfavorable

    ; vuelvo a traer los datos por si el call los rompio
    imul rcx, rbp, CASO_SIZE ; rcx = i * CASO_SIZE
    lea rdx, [r13 + rcx + CASO_CATEGORIA_OFFSET] ; rdx = &caso.categoria
    
    mov rdi, rdx
    mov rsi, categoria_rbo
    call strcmp
    cmp rax, 0
    je .cerrar_desfavorable

    jmp .caso_a_revisar

.cerrar_desfavorable:
    imul rcx, rbp, CASO_SIZE ; rcx = i * CASO_SIZE
    mov word [r13 + rcx + CASO_ESTADO_OFFSET], 2 ; arreglo_casos[i].estado = 1;
    jmp .siguiente

.cerrar_favorable:
    imul rcx, rbp, CASO_SIZE ; rcx = i * CASO_SIZE
    mov word [r13 + rcx + CASO_ESTADO_OFFSET], 1 ; arreglo_casos[i].estado = 1;
    jmp .siguiente

.caso_a_revisar:
    imul rcx, rbp, CASO_SIZE ; rcx = i * CASO_SIZE
    imul rsi, rbx, CASO_SIZE ; rsi = index + CASO_SIZE
    mov r8, [r13 + rcx]      ; 1er qword del caso
    mov r9, [r13 + rcx + 8]  ; 2do qword del caso
    mov [r14 + rsi], r8
    mov [r14 + rsi + 8], r9 

    inc rbx ; index++
    jmp .siguiente

.siguiente:
    inc rbp
    jmp .ciclo

.fin:
    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
