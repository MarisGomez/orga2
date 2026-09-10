extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
; a[RDI]
; b[RSI]
strCmp:
	;prólogo 
	push RBP
	mov RBP, RSP

.ciclo:
	movzx EDX, byte [RDI] ; Move with zero-extend: mueve 1 byte y lo extiende con ceros hasta 32 bits.
	movzx ECX, byte [RSI]

    cmp EDX, ECX
    jl .menor             ; Jump if less
    jg .mayor             ; Jump if greater

    test EDX, EDX         ; ¿es '\0'?
    je .iguales           ; Jump if Equal: si ambos '\0' → iguales

    inc rdi
    inc rsi
    jmp .ciclo

.iguales:
    xor eax, eax          ; return 0
    jmp .fin

.menor:
    mov eax, 1            ; return 1
    jmp .fin

.mayor:
    mov eax, -1            ; return -1
    jmp .fin

.fin:
	;epílogo
    pop rbp
    ret

; char* strClone(char* a)
; a[RDI]
strClone:
	;prólogo 
	push RBP
	mov RBP, RSP

    mov RSI, RDI         ; guardamos puntero original en rsi
    call strLen          ; devuelve la longitud del string en eax
    inc EAX              ; +1 para '\0'
    mov EDI, EAX         ; Por convención de llamadas, malloc espera el tamaño en RDI
    call malloc          ; devuelve puntero en RAX

.copiar:
    mov AL, [RSI]        ; leer char
    mov [RAX], AL        ; escribir char

    test AL, AL          ; ¿es '\0'?
    je .fin              ; Jump if Equal: si '\0' → terminamos de copiar el string

    inc RSI
    inc RAX
    jmp .copiar

.fin:
    ;puntero destino ya está en RAX
	;epílogo
    pop RBP
    ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
; a[RDI]
strLen:
	;prólogo 
	push RBP
	mov RBP, RSP

    xor EAX, EAX         ; longitud = 0
.ciclo:
	movzx EDX, byte [RDI]

    test EDX, EDX        ; ¿es '\0'?
    je .fin              ; Jump if Equal: si '\0' → terminamos de recorrer el string

    inc EAX              ; incremento la longitud en 1
    inc RDI
    jmp .ciclo

.fin:
    ; la longitud ya está guardada en eax
    ;epílogo
    pop RBP
    ret


