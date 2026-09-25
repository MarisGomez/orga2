extern free

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

; void eliminar_publicaciones_del_usuario(feed_t* feed, uint32_t id_usuario)
; feed       [RDI]
; id_usuario [RSI]
global eliminar_publicaciones_del_usuario
eliminar_publicaciones_del_usuario:
push rbp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

mov r12, rdi ; feed       [R12]
mov r13, rsi ; id_usuario [R13]

mov r14, [r12 + FEED_FIRST_OFFSET] ; r14 = actual
xor r15, r15                       ; r15 = previa
xor rbx, rbx                       ; rbx = encontramos_nuevo_first (bool)

.ciclo:
    cmp r14, 0 ; actual != NULL
    je .fin

    mov rbp, [r14 + PUBLICACION_NEXT_OFFSET] ; rbp = siguiente

    mov r8, [r14 + PUBLICACION_VALUE_OFFSET] ; r8 = actual->value
    cmp dword [r8 + TUIT_ID_AUTOR_OFFSET], r13d ; actual->value->id_autor == id_usuario
    jne .no_eliminar_publicacion
    jmp .eliminar_publicacion

    .no_eliminar_publicacion:
        cmp rbx, 0
        jne .nueva_previa

        mov [r12 + FEED_FIRST_OFFSET], r14
        mov rbx, 1
        
        .nueva_previa:
            mov r15, r14
            jmp .siguiente

    .eliminar_publicacion:
        cmp r15, 0
        je .free

        mov [r15 + PUBLICACION_NEXT_OFFSET], rbp

    .free:
        mov rdi, r14
        call free
        jmp .siguiente

    .siguiente:
    mov r14, rbp
    jmp .ciclo

.fin:
cmp rbx, 0
jne .epilogo

mov qword [r12 + FEED_FIRST_OFFSET], qword 0

.epilogo:
add rsp, 8
pop rbx
pop r15
pop r14
pop r13
pop r12
pop rbp
ret

; void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear);
global bloquearUsuario 
bloquearUsuario:
retbloquearUsuario:
    .prologo:
    push rbp
    mov rbp, rsp
    push r12
    push r13    ; Stack alineado

    ; Preservo los valores iniciales
    mov r12, rdi    ; usuario
    mov r13, rsi    ; usuarioABloquear

    xor r8, r8
    mov r8d, dword [r12 + USUARIO_CANT_BLOQUEADOS_OFFSET]   ; Cantidad de usuarios bloqueados
    mov r9, [r12 + USUARIO_BLOQUEADOS_OFFSET] ; usuario->bloqueados
    mov [r9 + r8 * 8], r13

    inc dword [r12 + USUARIO_CANT_BLOQUEADOS_OFFSET]   ; usuario->cantBloqueados++

    ; Solo nos queda llamar a la función auxiliar con el feed de cada usuario y el usuario a bloquar/bloqueador
    mov rdi, [r12 + USUARIO_FEED_OFFSET]
    mov rsi, [r13 + USUARIO_ID_OFFSET]
    call eliminar_publicaciones_del_usuario

    mov rdi, [r13 + USUARIO_FEED_OFFSET]
    mov rsi, [r12 + USUARIO_ID_OFFSET]
    call eliminar_publicaciones_del_usuario

    .epilogo:
    pop r13
    pop r12
    pop rbp
    ret
