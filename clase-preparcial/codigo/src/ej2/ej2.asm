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
mov rbp, rsp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

mov r12, rdi ; feed       [R12]
mov r13, rsi ; id_usuario [R13]

mov r14, [r12 + FEED_FIRST_OFFSET] ; r14 = actual
mov r15, 0                         ; r15 = previa
mov rbx, 0                         ; rbx = encontramos_nuevo_first (bool)

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
ret
