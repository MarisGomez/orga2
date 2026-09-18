extern strcpy
extern malloc
extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

ITEM_OFFSET_NOMBRE EQU 0
ITEM_OFFSET_ID EQU 12
ITEM_OFFSET_CANTIDAD EQU 16

POINTER_SIZE EQU 4
UINT32_SIZE EQU 8

; Marcar el ejercicio como hecho (`true`) o pendiente (`false`).

global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_4_HECHO
EJERCICIO_4_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.


; uint64_t ejercicio1(uint64_t sum1, uint64_t sum2, uint64_t sum3, uint64_t sum4, uint64_t sum5);
; sum1 [RDI]
; sum2 [RSI]
; sum3 [RDX]
; sum4 [RCX]
; sum5 [R8]
global ejercicio1
ejercicio1:
	add rdi, rsi  ; Paso 1: Paso todos los registros de 32 bits a registros de 64 bits
	add rdi, rdx  ; Paso 2: Paso los argumentos en orden y por convención de llamadas
    add rdi, rcx
    add rdi, r8
	mov rax, rdi
	ret


; void ejercicio2(item_t* un_item, uint32_t id, uint32_t cantidad, char nombre[]);
; un_item [RDI] PUNTERO
; id [RSI]
; cantidad [RDX]
; nombre[] [RCX]
global ejercicio2
ejercicio2:
	mov [rdi+ITEM_OFFSET_ID], esi ; 4 bytes
	mov [rdi+ITEM_OFFSET_CANTIDAD], edx ; 4 bytes
	sub rsp, 8 ; Antes de ejecutar un call, la pila debe estar alineada (strcpy usa la pila)

	mov rsi, rcx ; movemos nombre[] a rsi
	call strcpy ; strcpy espera al operando destino en rdi y al operando fuente en rsi

	add rsp, 8
	ret


; uint32_t ejercicio3(uint32_t* array, uint32_t size, uint32_t (*fun_ej_3)(uint32_t a, uint32_t b));
; arrray [RDI] -> puntero
; size [RSI]
; fun [RDX] -> puntero
global ejercicio3
ejercicio3:
	;prólogo 
	push rbp
	mov rbp, rsp
    push rbx
	push r12
	push r13
	push r14

	mov rbx, rdi ; array[rcx] -> puntero del array
	mov r14, rdx ; fun[r14] -> puntero de la funcion
	mov r12, 64 ; r12 = resultado parcial

	test rsi, rsi ; caso n = 0
	je .end

	xor r13, r13 ; i = 0

	.loop:
	mov rdi, r12 ; rdi = resultado parcial
	mov esi, dword [rbx + r13*4] ; array[i] -> uint32_t de 4 bytes

	; fun_ej_3 espera a "a" en RDI y a "b" en RSI, devuelve en RAX
	call r14 ; llama a fun_ej_3

	add r12, rax ; resultado parcial += rax

	inc r13 
	cmp r13, rsi
	jb .loop ; jump if r13 < rsi

	.end:
	mov rax, r12
	;epílogo
	pop r14
    pop r13
    pop r12
	pop rbx
	pop rbp
	ret

global ejercicio4
ejercicio4:
	mov r12, rdi
	mov r13, rsi
	mov r14, rdx

	xor rdi, rdi
	mov eax, UINT32_SIZE
	mul esi
	mov edi, eax

	call malloc
	mov r15, rax
	
	xor rbx, rbx
	.loop:
	
	cmp rbx, r13
	je .end

	mov r8, [r12+rbx*POINTER_SIZE]
	mov r9d, [r8]
	mov rax, r14
	mul r9d
	mov [r15+rbx*UINT32_SIZE], eax
	
	mov rsi, r8 
	call free

	inc rbx
	jmp .loop

	.end:
	mov rax, r15
	ret
