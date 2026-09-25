extern calloc
extern strcmp
;########### SECCION DE DATOS
section .data
    categoria_clt db "CLT", 0
    categoria_rbo db "RBO", 0
    categoria_ksc db "KSC", 0
    categoria_kdt db "KDT", 0

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

;void calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id)
; arreglo_casos [RDI]
; largo         [RSI]
; usuario_id    [RDX]
global calcular_estadisticas
calcular_estadisticas:
    push rbp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8

    mov r12, rdi ; arreglo_casos [R12]
    mov r13, rsi ; largo         [R13]
    mov r14, rdx ; usuario_id    [R14]

    ; defino estadisticas
    mov rdi, 1
    mov rsi, ESTADISTICAS_SIZE
    call calloc
    mov r15, rax ; estadísticas [R15]

    xor rbx, rbx ; i = 0

.ciclo:
    cmp rbx, r13
    jae .fin

    imul rcx, rbx, CASO_SIZE ; rcx = i * CASO_SIZE
    mov rdx, [r12 + rcx + CASO_USUARIO_OFFSET] ; rdx = caso.usuario
    mov eax, [rdx + USUARIO_ID_OFFSET] ; eax = caso.usuario->id

    cmp r14, 0 ; usuario == 0?
    je .contar

    cmp eax, r14d ; caso.usuario->id != usuario_id
    jne .siguiente

.contar:
    movzx eax, word [r12 + rcx + CASO_ESTADO_OFFSET]
    cmp eax, 0
    je .estado_0
    cmp eax, 1
    je .estado_1
    inc byte [r15 + ESTADISTICAS_ESTADO2_OFFSET]
    jmp .categoria

.estado_0:
    inc byte [r15 + ESTADISTICAS_ESTADO0_OFFSET]
    jmp .categoria

.estado_1:
    inc byte [r15 + ESTADISTICAS_ESTADO1_OFFSET]

.categoria:
    imul rcx, rbx, CASO_SIZE ; rcx = i * CASO_SIZE
    lea rdx, [r12 + rcx + CASO_CATEGORIA_OFFSET] ; rdx = &caso.categoria
    
    mov rdi, rdx
    mov rsi, categoria_clt
    call strcmp
    cmp rax, 0
    je .ctl

    imul rcx, rbx, CASO_SIZE ; rcx = i * CASO_SIZE
    lea rdx, [r12 + rcx + CASO_CATEGORIA_OFFSET] ; rdx = &caso.categoria
    
    mov rdi, rdx
    mov rsi, categoria_rbo
    call strcmp
    cmp rax, 0
    je .rbo

    imul rcx, rbx, CASO_SIZE ; rcx = i * CASO_SIZE
    lea rdx, [r12 + rcx + CASO_CATEGORIA_OFFSET] ; rdx = &caso.categoria
    
    mov rdi, rdx
    mov rsi, categoria_ksc
    call strcmp
    cmp rax, 0
    je .ksc

    inc byte[r15 + ESTADISTICAS_KDT_OFFSET]
    jmp .siguiente

.ctl:
    inc byte[r15 + ESTADISTICAS_CLT_OFFSET]
    jmp .siguiente

.rbo:
    inc byte[r15 + ESTADISTICAS_RBO_OFFSET]
    jmp .siguiente

.ksc:
    inc byte[r15 + ESTADISTICAS_KSC_OFFSET]
    jmp .siguiente

.siguiente:
    inc rbx
    jmp .ciclo

.fin:
    mov rax, r15

    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
