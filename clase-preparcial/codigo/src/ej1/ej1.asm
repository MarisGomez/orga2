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

; tuit_t *publicar(char *mensaje, usuario_t *usuario);
; mensaje [RDI]
; usuario [RSI]
global publicar
publicar:
ret
