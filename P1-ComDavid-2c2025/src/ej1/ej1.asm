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

extern malloc

global cumpleCondiciones
cumpleCondiciones:
mov r8w, word[rdi + PRODUCTO_ESTADO_OFFSET]
cmp r8w, 1
jne .false

mov r9, [rdi + PRODUCTO_USUARIO_OFFSET]
mov r10b, byte[r9 + USUARIO_NIVEL_OFFSET]
cmp r10b, 1
jb .false

.true:
    mov eax, 1
    jmp .fin

.false:
    xor eax, eax
    jmp .fin

.fin:
ret

;producto_t* filtrarPublicacionesNuevasDeUsuariosVerificados (catalogo*)
global filtrarPublicacionesNuevasDeUsuariosVerificados
filtrarPublicacionesNuevasDeUsuariosVerificados:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r12, rdi ; *h

mov rdi, PRODUCTO_SIZE
imul rdi, 10
call malloc

mov r13, rax ; **res
mov r14, [r12 + CATALOGO_FIRST_OFFSET] ; *actual

xor r15, r15 ; contador = 0
.ciclo:
    cmp r14, 0
    je .fin

    mov rdi, [r14 + PUBLICACION_VALUE_OFFSET]
    call cumpleCondiciones
    cmp rax, 1 ; (actual->value) == true)?
    jne .siguiente

    mov r8, [r14 + PUBLICACION_VALUE_OFFSET] ; actual->value
    mov [r13 + r15 * 8], r8 ; res[contador] RECORDEMOS QUE RES TIENE PUNTEROS
    inc r15

    .siguiente:
        mov r14, [r14 + PUBLICACION_NEXT_OFFSET]
        jmp .ciclo

.fin:
mov qword[r13 + r15 * 8], 0 ; cerramos con null
mov rax, r13 
pop r15
pop r14
pop r13
pop r12
pop rbp
ret
