extern malloc
extern strcpy

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


; void agregar_tuit_al_feed(tuit_t* tuit, feed_t* feed)
; tuit [RDI]
; feed [RSI]
global agregar_tuit_al_feed
agregar_tuit_al_feed:
push rbp
mov rbp, rsp
push r12
push r13

mov r12, rdi ; tuit [R12]
mov r13, rsi ; feed [R13]

mov rdi, PUBLICACION_SIZE
call malloc ; publicacion[RAX]

mov [rax + PUBLICACION_VALUE_OFFSET], r12 ; publicacion->value = tuit;

mov r8, [r13 + FEED_FIRST_OFFSET] ; publicacion_t* next = feed->first;
mov [rax + PUBLICACION_NEXT_OFFSET], r8 ; publicacion->next = next;

mov [r13 + FEED_FIRST_OFFSET], rax ; feed->first = publicacion;

pop r13
pop r12
pop rbp
ret

; tuit_t *publicar(char *mensaje, usuario_t *usuario);
; mensaje [RDI]
; usuario [RSI]
global publicar
publicar:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r12, rdi ; mensaje[r12]
mov r13, rsi ; usuario[r13]

; pido memoria para el tuit
mov rdi, TUIT_SIZE
call malloc
mov  r14, rax ; tuit[r14]

; completo los campos del tuit
mov word [r14 + TUIT_FAVORITOS_OFFSET], word 0
mov word [r14 + TUIT_RETUITS_OFFSET], word 0
mov r8d, dword [r13 + USUARIO_ID_OFFSET] ; user->id[r8]
mov dword [r14 + TUIT_ID_AUTOR_OFFSET], r8d ; tuit->id_autor = user->id;

; copio el mensaje
lea rdi, [r14 + TUIT_MENSAJE_OFFSET]
mov rsi, r12
call strcpy

; agrego tuit al principio del feed del autor
mov rdi, r14
mov rsi, [r13 + USUARIO_FEED_OFFSET]
call agregar_tuit_al_feed

xor r15, r15 ; i = 0
.ciclo:
    cmp r15d, dword [r13 + USUARIO_CANT_SEGUIDORES_OFFSET]
    jae .fin

    mov r9, [r13 + USUARIO_SEGUIDORES_OFFSET] 
    mov r10, [r9 + r15 * 8] ; seguidor[r10]

    mov rdi, r14
    mov rsi, [r10 + USUARIO_FEED_OFFSET]
    call agregar_tuit_al_feed

    inc r15
    jmp .ciclo

.fin:
mov rax, r14

pop r15
pop r14
pop r13
pop r12
pop rbp
ret
