extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 20 ; padding de 1 byte
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 28 ; padding de 2 bytes (para que quede alineado)


;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);
; item_t**     inventario [RDI]
; uint16_t*    indice     [RSI]
; uint16_t     tamanio    [RDX]
; comparador_t comparador [RCX]

global es_indice_ordenado
es_indice_ordenado:
	; prólogo: 
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8

	mov r12, rdi  ; item_t**     inventario [R12]
	mov r13, rsi  ; uint16_t*    indice     [R13]
	movzx r14, dx ; uint16_t     tamanio    [R14]
	mov r15, rcx  ; comparador_t comparador [R15]

	mov eax, 1 ; inicializo res en eax con true
	xor rbx, rbx ; i = 0

	cmp r14, 1 ; si el tamaño es 1 no hay loop
	je .fin

	dec r14 ; tamanio - 1
	.ciclo:
	cmp rbx, r14
	je .fin

	movzx r8, word [r13 + rbx * 2]     ; r8 = indice[i]
	movzx r9, word [r13 + rbx * 2 + 2] ; r9 = indice[i+1]
	mov rdi, [r12 + r8*8] ; rdi = item_actual
	mov rsi, [r12 + r9*8] ; rsi = item_siguiente
	call r15 ; funcion comparador

	test al, al
	je .false

	inc rbx
	jmp .ciclo

	.false:
	xor eax, eax

	.fin:
	; epílogo:
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret


;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);
; item_t**  inventario [RDI]
; uint16_t* indice     [RSI]
; uint16_t  tamanio    [RDX]
global indice_a_inventario
indice_a_inventario:
	; prólogo:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8

	mov r12, rdi  ; item_t**     inventario [R12]
	mov r13, rsi  ; uint16_t*    indice     [R13]
	movzx r14, dx ; uint16_t     tamanio    [R14]

	; PEDIMOS MEMORIA PARA resultado**
	mov rax, 8
	imul rax, r14 ; rax = tamanio * 8
	mov rdi, rax 
    call malloc

	mov r15, rax ; r15 = resultado**
	xor rbx, rbx ; i = 0

	.ciclo:
	cmp rbx, r14
	je .fin

	movzx r8, word [r13 + rbx * 2] ; r8 = indice[i]
	mov rax, [r12 + r8*8] ; rax = inventario[indice[i]]
	mov [r15 + rbx*8], rax ; resultado[i] = rax

	inc rbx
	jmp .ciclo

	.fin:
	mov rax, r15

	; epílogo:
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
