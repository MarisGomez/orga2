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
EJERCICIO_3_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_4_HECHO
EJERCICIO_4_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

global ejercicio1
; uint64_t ejercicio1(uint64_t sum1, uint64_t sum2, uint64_t sum3, uint64_t sum4, uint64_t sum5);
; sum1 [RDI]
; sum2 [RSI]
; sum3 [RDX]
; sum4 [RCX]
; sum5 [R8]
ejercicio1:
	add rdi, rsi  ; Paso 1: Paso todos los registros de 32 bits a registros de 64 bits
	add rdi, rdx  ; Paso 2: Paso los argumentos en orden y por convención de llamadas
    add rdi, rcx
    add rdi, r8
	mov rax, rdi
	ret


global ejercicio2
; void ejercicio2(item_t* un_item, uint32_t id, uint32_t cantidad, char nombre[]);
; un_item [RDI] PUNTERO
; id [RSI]
; cantidad [RDX]
; nombre[] [RCX]
ejercicio2:
	mov [rdi+ITEM_OFFSET_ID], esi ; 4 bytes
	mov [rdi+ITEM_OFFSET_CANTIDAD], edx ; 4 bytes
	sub rsp, 8 ; Antes de ejecutar un call, la pila debe estar alineada (strcpy usa la pila)

	mov rsi, rcx ; movemos nombre[] a rsi
	call strcpy ; strcpy espera al operando destino en rdi y al operando fuente en rsi

	add rsp, 8
	ret


global ejercicio3
ejercicio3:
	cmp rsi, 0
	je .vacio
	
	mov rcx, rdi ; array
	mov r8, 0 ; sumatoria
	mov r9, 0 ; i

	.loop:
	mov rdi, r8
	mov rsi, [rcx + r9*4]

	call rdx

	add r8, rax
	mov rax, r8

	inc r9
	cmp r9, rsi
	je .end

	jmp .loop

	.vacio:
	mov rax, 64

	.end:
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
