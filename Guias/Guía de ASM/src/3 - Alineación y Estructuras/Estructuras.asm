

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
%define NODO_OFFSET_NEXT 0
%define NODO_OFFSET_CATEGORIA 8
%define NODO_OFFSET_ARREGLO 16
%define NODO_OFFSET_LONGITUD 24
%define NODO_SIZE 32
%define PACKED_NODO_OFFSET_NEXT 0
%define PACKED_NODO_OFFSET_CATEGORIA 8
%define PACKED_NODO_OFFSET_ARREGLO 9
%define PACKED_NODO_OFFSET_LONGITUD 17
%define PACKED_NODO_SIZE 20
%define LISTA_OFFSET_HEAD 0
%define LISTA_SIZE 8
%define PACKED_LISTA_OFFSET_HEAD 0
%define PACKED_LISTA_SIZE 8

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
	xor eax, eax  ; acumulador = 0
    mov rdi, [rdi + LISTA_OFFSET_HEAD] ; rdi = lista->head

.ciclo:
	test rdi, rdi  ; ¿es NULL?
    je .fin ;Jump if equal

    add eax, [rdi + NODO_OFFSET_LONGITUD] ; acumular longitud
    mov rdi, [rdi + NODO_OFFSET_NEXT]     ; avanzar al siguiente nodo
    jmp .ciclo

.fin:
	;epílogo
    pop rbp
    ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	;prólogo 
	push RBP
	mov RBP, RSP

	;tengo en RDI un puntero al comienzo de un array
	xor eax, eax  ; acumulador = 0
    mov rdi, [rdi + PACKED_LISTA_OFFSET_HEAD] ; rdi = lista->head

.ciclo:
	test rdi, rdi  ; ¿es NULL?
    je .fin ;Jump if equal

    add eax, [rdi + PACKED_NODO_OFFSET_LONGITUD] ; acumular longitud
    mov rdi, [rdi + PACKED_NODO_OFFSET_NEXT]     ; avanzar al siguiente nodo
    jmp .ciclo

.fin:
	;epílogo
    pop rbp
    ret

