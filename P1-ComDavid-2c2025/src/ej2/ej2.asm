;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0     ; uint32_t id     | 4
USUARIO_NIVEL_OFFSET EQU 4  ; uint8_t nivel   | 1 
USUARIO_SIZE EQU 8          ; DEBE ESTAR ALINEADO A 4
; | ID | ID | ID | ID | lvl | 0 | 0 | 0 |

PRODUCTO_USUARIO_OFFSET EQU 0    ; usuario_t* usuario | 8
PRODUCTO_CATEGORIA_OFFSET EQU 8  ; char categoria[9]  | 9  (1)
PRODUCTO_NOMBRE_OFFSET EQU 17    ; char nombre[25]    | 25 (1)
PRODUCTO_ESTADO_OFFSET EQU 42    ; uint16_t estado    | 2
PRODUCTO_PRECIO_OFFSET EQU 44    ; uint32_t precio    | 4
PRODUCTO_ID_OFFSET EQU 48        ; uint32_t id        | 4
PRODUCTO_SIZE EQU 56             ; DEBE ESTAR ALINEADO A 8 (mayor alineacion)
; | us | us | us | us | us | us | us | us |
; | cat | cat | cat | cat | cat | cat | cat | cat |
; | cat | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | N | N | N | N | N | N |
; | N | N | EST | EST | $ | $ | $ | $ |
; | ID | ID | ID | ID | 0 | 0 | 0 | 0 |

PUBLICACION_NEXT_OFFSET EQU 0    ; struct publicacion_t *next  | 8 (puntero)
PUBLICACION_VALUE_OFFSET EQU 8   ; producto_t *value           | 8 (puntero)
PUBLICACION_SIZE EQU 16          ; DEBE ESTAR ALINEADO A 8
; | next | next | next | next | next | next | next | next |
; | value | value | value | value | value | value | value | value |

CATALOGO_FIRST_OFFSET EQU 0      ; struct publicacion_t *first | 8 (puntero)
CATALOGO_SIZE EQU 8              ; DEBE ESTAR ALINEADO A 8
; | first | first | first | first | first | first | first | first | 

extern strcmp
extern free

global removerAparicionesPosterioresDe
removerAparicionesPosterioresDe:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r15, rdi ; p
mov r12, rdi                             ; prev (p)
mov r13, [r12 + PUBLICACION_NEXT_OFFSET] ; actual

.ciclo:
    test r13, r13
    jz .fin

    mov r14, [r13 + PUBLICACION_NEXT_OFFSET] ; siguiente

    mov r8, [r13 + PUBLICACION_VALUE_OFFSET]
    mov r8, [r8 + PRODUCTO_USUARIO_OFFSET]
    mov r9d, dword[r8 + USUARIO_ID_OFFSET]

    mov r10, [r15 + PUBLICACION_VALUE_OFFSET]
    mov r10, [r10 + PRODUCTO_USUARIO_OFFSET]
    mov r11d, dword[r10 + USUARIO_ID_OFFSET]

    cmp r9d, r11d
    jne .else

    mov r8, [r13 + PUBLICACION_VALUE_OFFSET]
    lea rdi, [r8 + PRODUCTO_NOMBRE_OFFSET]

    mov r10, [r15 + PUBLICACION_VALUE_OFFSET]
    lea rsi, [r10 + PRODUCTO_NOMBRE_OFFSET]

    call strcmp
    test eax, eax
    jne .else

    mov [r12 + PUBLICACION_NEXT_OFFSET], r14
    mov rdi, [r13 + PUBLICACION_VALUE_OFFSET]
    call free

    mov rdi, r13
    call free

    jmp .siguiente
    .else:
        mov r12, r13 ; prev = actual

    .siguiente:
        mov r13, r14 ; actual = siguiente
        jmp .ciclo

.fin:
pop r15
pop r14
pop r13
pop r12
pop rbp
ret


;catalogo* removerCopias(catalogo* h)
global removerCopias
removerCopias:
push rbp
mov rbp, rsp
push r12
push r13

mov r12, rdi ; h
mov r13, [r12 + CATALOGO_FIRST_OFFSET] ; actual

.ciclo:
    test r13, r13
    jz .fin

    mov rdi, r13
    call removerAparicionesPosterioresDe
    mov r13, [r13 + PUBLICACION_NEXT_OFFSET]

    jmp .ciclo
.fin:
mov rax, r12
pop r13
pop r12
pop rbp
ret
