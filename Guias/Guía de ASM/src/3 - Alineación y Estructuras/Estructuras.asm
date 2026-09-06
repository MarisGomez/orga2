

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT 0
NODO_OFFSET_CATEGORIA 8
NODO_OFFSET_ARREGLO 16
NODO_OFFSET_LONGITUD 24
NODO_SIZE 32
PACKED_NODO_OFFSET_NEXT 0
PACKED_NODO_OFFSET_CATEGORIA 8
PACKED_NODO_OFFSET_ARREGLO 9
PACKED_NODO_OFFSET_LONGITUD 17
PACKED_NODO_SIZE 20
LISTA_OFFSET_HEAD 0
LISTA_SIZE 8
PACKED_LISTA_OFFSET_HEAD 0
PACKED_LISTA_SIZE 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos:
	;prólogo 
	push RBP
	mov RBP, RSP

	;tengo en RDI un puntero al comienzo de un array
	;y en RSI el tamaño del array
	;asumimos que al menos hay un elemento en el array
	
	XOR R8, R8; usamos R8 como índice del array

	.ciclo:
		mov RDX, [RDI + R8 * NODO_SIZE + NODO_OFFSET_NEXT]
		mov CL, BYTE [RDI + R8 * NODO_SIZE + NODO_OFFSET_CATEGORIA]
		mov R9, [RDI + R8 * NODO_SIZE + NODO_OFFSET_ARREGLO]
		mov [RBP+16], DWORD [RDI + R8 * NODO_SIZE + NODO_OFFSET_LONGITUD]

		INC R8; avanzo el índice del array
		CMP R8, RSI
		JL .ciclo

	;epílogo
	pop RBP
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	ret

