extern malloc
extern free

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
;   - optimizar
global EJERCICIO_2A_HECHO
EJERCICIO_2A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_2B_HECHO
EJERCICIO_2B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12 ; padding de 1 byte
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16 ; padding de 1 byte

; mapa                    [RDI]
; compartida              [RSI]
; fun_hash(attackunit_t*) [RDX]
global optimizar
optimizar:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8
	
	mov r12, rdi ; mapa[r12]
	mov r13, rsi ; compartida[r13]
	mov r14, rdx ; fun_hash[r14]

	xor r15, r15 ; i = 0
	xor rbx, rbx ; j = 0

	.ciclo_filas:
	cmp r15, 255
	je .fin
		.ciclo_columnas:
		cmp rbx, 255
		je .ciclo_filas

		mov r9, [r12 + r15 * 8] ; r9 = mapa[i]
		mov r8, [r9 + rbx * 8] ; r8 = mapa[i][j]
		; PRIMER IF:
		test r8, r8   ;; Caso unidad == NULL
		je .continue  ;; ||
		cmp r8, r13   ;; Caso unidad == compartida
		je .continue  ;;
		; SEGUNDO IF:
		mov rdi, r8 ; fun_hash espera a la unidad en rdi
		call r14
		mov rdx, rax ; fun_hash(unidad)[RDX]

		mov rdi, r13 ; fun_hash espera a compartida en rdi
		call r14
		mov rcx, rax ; fun_hash(compartida)[RCX]

		cmp rdx, rcx
		jne .continue

		dec byte [r8 + ATTACKUNIT_REFERENCES] ; unidad->references --
		; TERCER IF:
		cmp byte [r8 + ATTACKUNIT_REFERENCES], 0 
		jne .notfree

		.free:
		mov rdi, r8
		call free

		.notfree:
		mov r8, r13
		inc byte [r13 + ATTACKUNIT_REFERENCES]

		.continue:
		inc rbx
		jmp .ciclo_columnas
	
	inc r15
	jmp .ciclo_filas

	.fin:
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; r/m64 = mapa_t           mapa
	; r/m64 = uint16_t*        fun_combustible(char*)
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret
