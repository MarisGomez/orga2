extern malloc
extern free
extern fprintf

section .data
msg_null: db 'NULL', 10
format_string: db '%s', 10

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; ////////////////////////////////////////////////////////////////////////////////////////////////////////
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

; ////////////////////////////////////////////////////////////////////////////////////////////////////////
; char* strClone(char* a)
; a[RDI]
strClone:
	;prólogo 
	push RBP
	mov RBP, RSP
    push RBX
    sub RSP, 8           ; muevo el tope de la pila 8 bytes para que quede alineada

    mov RBX, RDI         ; guardamos puntero original en rbx (registro no volátil)
    call strLen          ; devuelve la longitud del string en eax
    inc EAX              ; +1 para '\0'
    mov EDI, EAX         ; Por convención de llamadas, malloc espera el tamaño en RDI
    call malloc          ; devuelve puntero en RAX

    mov RDX, RAX         ; copio RAX en RDI para no incrementar RAX
.copiar:
    mov CL, [RBX]        ; leer char (no podemos usar AL ni BL pq corrompemos los punteros fuente (RBX ) y destino (RAX))
    mov [RDX], CL        ; escribir char

    test CL, CL          ; ¿es '\0'?
    je .fin              ; Jump if Equal: si '\0' → terminamos de copiar el string

    inc RBX
    inc RDX
    jmp .copiar

.fin:
    ;puntero destino ya está en RAX
	;epílogo
    add RSP, 8
    pop RBX
    pop RBP
    ret

; ////////////////////////////////////////////////////////////////////////////////////////////////////////
; void strDelete(char* a)
strDelete:
    ;prólogo 
	push RBP
	mov RBP, RSP
    call free
    ;epílogo
    pop RBP
    ret

; ////////////////////////////////////////////////////////////////////////////////////////////////////////
; void strPrint(char* a, FILE* pFile)
; a[RDI]
; pFIle[RSI]
strPrint:
    ;prólogo mov AL, [RSI]
	push RBP
	mov RBP, RSP

    ; Me fijo si el string es vacío
    mov AL, [RDI]
    test AL, AL             ; ¿es NULL?
    jne .escribir           ; Jump if not equal

    ; Si es NULL, lo escribirmos 
    mov RDI, RSI            ; primer argumento: FILE*
    mov RSI, format_string  ; segundo argumento: "%s"
    mov RDX, msg_null       ; Tercer argumento: "NULL\n"
    call fprintf            ; fprintf(pFile, "%s", "NULL")
    jmp .fin

.escribir:
    mov RDX, RDI            ; Tercer argumento: a (antes de pisar RDI)
    mov RDI, RSI            ; primer argumento: FILE*
    mov RSI, format_string  ; segundo argumento: "%s"
    call fprintf           ; fprintf(pFile, "%s", a)

.fin:
    ;epílogo
    pop RBP
    ret

; ////////////////////////////////////////////////////////////////////////////////////////////////////////
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