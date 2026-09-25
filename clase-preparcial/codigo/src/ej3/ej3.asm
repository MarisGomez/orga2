extern malloc

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
TUIT_MENSAJE_OFFSET EQU 0
TUIT_FAVORITOS_OFFSET EQU 140 ; uint16_t
TUIT_RETUITS_OFFSET EQU 142 ; uint16_t
TUIT_ID_AUTOR_OFFSET EQU 144 ; uint32_t
TUIT_SIZE EQU 148

PUBLICACION_NEXT_OFFSET EQU 0 ; puntero (8 bytes)
PUBLICACION_VALUE_OFFSET EQU 8 ; puntero (8 bytes)
PUBLICACION_SIZE EQU 16

FEED_FIRST_OFFSET EQU 0 ; puntero (8 bytes)
FEED_SIZE EQU 8

USUARIO_FEED_OFFSET EQU 0 ; puntero (8 bytes)
USUARIO_SEGUIDORES_OFFSET EQU 8 ; puntero (8 bytes)
USUARIO_CANT_SEGUIDORES_OFFSET EQU 16 ; uint_32
USUARIO_SEGUIDOS_OFFSET EQU 24 ; puntero (8 bytes)
USUARIO_CANT_SEGUIDOS_OFFSET EQU 32 ; uint_32
USUARIO_BLOQUEADOS_OFFSET EQU 40 ; puntero (8 bytes)
USUARIO_CANT_BLOQUEADOS_OFFSET EQU 48 ; uint_32
USUARIO_ID_OFFSET EQU 52 ; uint_32
USUARIO_SIZE EQU 56

;uint32_t cuantos_tuits_trending_topic(feed_t* feed, uint32_t user_id, 
;                                      uint8_t (*esTuitSobresaliente)(tuit_t *))
; feed                [RDI]
; user_id             [RSI]
; esTuitSobresaliente [RDX]
global cuantos_tuits_trending_topic
cuantos_tuits_trending_topic:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

mov r12, rdi ; feed                [R12]
mov r13, rsi ; user_id             [R13]
mov r14, rdx ; esTuitSobresaliente [R14]

xor r15, r15 ; contador = 0
mov rbx, [r12 + FEED_FIRST_OFFSET] ; rbx = actual

.ciclo:
    cmp rbx, 0
    je .fin

    mov r8, [rbx + PUBLICACION_VALUE_OFFSET] ; r8 = tuit
    
    mov rdi, r8
    call r14 ;esTuitSobresaliente(tuit)
    cmp rax, 1
    jne .siguiente ; no activamos el contador

    mov r8, [rbx + PUBLICACION_VALUE_OFFSET] ; vuelvo a guardar el tuit por la call
    cmp dword [r8 + TUIT_ID_AUTOR_OFFSET], r13d
    jne .siguiente

    inc r15

    .siguiente:
    mov rbx, [rbx + PUBLICACION_NEXT_OFFSET]
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

; tuit_t **trendingTopic(usuario_t *usuario, uint8_t (*esTuitSobresaliente)(tuit_t *));
; user                [RDI]
; esTuitSobresaliente [RSI]
global trendingTopic 
trendingTopic:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

mov r12, rdi ; user                [R12]
mov r13, rsi ; esTuitSobresaliente [R13]

; llamamos a la funcion auxiliar
mov rdi, [r12 + USUARIO_FEED_OFFSET]
mov esi, dword [r12 + USUARIO_ID_OFFSET]
mov rdx, r13
call cuantos_tuits_trending_topic

cmp eax, dword 0 ; cantidad_tuits == 0?
je .null ; return NULL

; pedimos memoria para ** tuit (+1 para null)
inc rax ; cantidad_tuits + 1
imul rdi, rax, TUIT_SIZE
call malloc
mov r14, rax ; r14 = tuits

xor r15, r15 ; i = 0

mov r8, [r12 + USUARIO_FEED_OFFSET]
mov rbx, [r8 + FEED_FIRST_OFFSET] ; rbx = actual

.ciclo:
    cmp rbx, 0
    je .fin

    mov rdi, [rbx + PUBLICACION_VALUE_OFFSET] ; rdi = tuit
    mov esi, dword [rdi + TUIT_ID_AUTOR_OFFSET] ; rsi = tuit->id_autor
    cmp esi, dword [r12 + USUARIO_ID_OFFSET] ; tuit->id_autor == user->id
    jne .siguiente

    call r13 ; esTuitSobresaliente(tuit)
    cmp al, byte 1
    jne .siguiente

    mov rdi, [rbx + PUBLICACION_VALUE_OFFSET] ; vuelvo a hacer el tuit por el call
    mov [r14 + r15 * 8], rdi
    inc r15

    .siguiente:
        mov rbx, [rbx + PUBLICACION_NEXT_OFFSET]
        jmp .ciclo

.null:
    xor rax, rax
    jmp .epilogo

.fin:
    mov qword [r14 + r15 * 8], qword 0 ; tuits[i]
    mov rax, r14

.epilogo:
add rsp, 8
pop rbx
pop r15
pop r14
pop r13
pop r12
pop rbp
ret
