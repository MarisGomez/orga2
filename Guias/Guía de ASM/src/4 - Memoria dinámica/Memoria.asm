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
    jne .distintos        ; Jump if not Equal

    test EDX, EDX         ; ¿es '\0'?
    je .iguales           ; Jump if Equal: si ambos '\0' → iguales

    inc rdi
    inc rsi
    jmp .ciclo

.iguales:
    xor eax, eax          ; return 0
    jmp .fin

.distintos:
    mov eax, 1            ; return 1
    jmp .fin

.fin:
	;epílogo
    pop rbp
    ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
	ret


