; Hace que los accesos a memoria por defecto se compilen como [rip + offset]
; en lugar de [offset_desde_el_0x0].
;
; Ver https://www.nasm.us/doc/nasmdoc7.html#section-7.2.1 para más información
DEFAULT REL

TRUE  EQU 1
FALSE EQU 0

SINCOS_SIN_OFF EQU 0
SINCOS_COS_OFF EQU 4
SINCOS_SZ      EQU 8

section .rodata

global ej_1_hecho
global ej_2_hecho
global ej_3_hecho
global ej_4_hecho
ej_1_hecho: db TRUE
ej_2_hecho: db TRUE
ej_3_hecho: db FALSE
ej_4_hecho: db FALSE

ALIGN 16
espacios:
	times 10 db ' ' - '0'
	times 6  db 0x0
ceros:
	times 10 db '0'
	times 6  db 0x0
; ... y otra data que les resulte útil para resolver los ejercicios

section .text

global ej1_sample
; void ej1_sample(size_t buf_len, int16_t buf[buf_len],
;                 size_t freq_a_len, int16_t freq_a[freq_a_len], size_t a_start,
;                 size_t freq_b_len, int16_t freq_b[freq_b_len], size_t b_start);
;
; buf_len:    Está en RDI
; buf:        Está en RSI
; freq_a_len: Está en RDX
; freq_a:     Está en RCX
; a_start:    Está en R8
; freq_b_len: Está en R9
; freq_b:     Está en [RBP+16]
; b_start:    Está en [RBP+24]
;
; Tener en mente que:
; - buf_len, freq_a_len, freq_b_len, a_start y b_start son siempre múltiplos de 16
; - a_start < freq_a_len y b_start < freq_b_len
; - freq_a y freq_b están dados tal que sumarlos entre sí no causa overflow
ej1_sample:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15

	mov r12, r8       ;; guardo los valores de a_start y b_start
	mov r13, [RBP+24] ;;       para poder hacer reset
	mov r15, [RBP+16] ; r15 = freq_b

	add rdi, rdi ; ahora mido en bytes en lugar de ítems (2 bytes por c/int16_t)

	xor r10, r10 ; i = 0
	jmp .guarda
	.loop:
		cmp r12, rdx ; if (a_start >= |a|) then reset
		jge .reset_a
		cmp r13, r9  ; if (b_start >= |b|) then reset
		jge .reset_b

		movdqu xmm0, [rcx + r12 * 2] ; sample_a
		movdqu xmm1, [r15 + r13 * 2] ; sample_b

		paddw xmm0, xmm1 ; sample_b + sample_b
		psraw xmm0, 1 ; / 2

		movdqu [rsi + r10], xmm0 ; sample_a

		add r12, 8
		add r13, 8

		add r10, 16 ; avanzo de a 8 words en simultaneo
		jmp .guarda
		.reset_a:
			xor r12, r12 ; a_start = 0
			jmp .loop

		.reset_b:
			xor r13, r13 ; b_start = 0
			jmp .loop		
	.guarda:
		cmp r10, rdi
		jl .loop

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

global ej2_detect
; float ej2_detect(size_t size, int16_t signal[size], sincos_t freq[size]);
;
; size:   Está en RDI
; signal: Está en RSI
; freq:   Está en RDX
ej2_detect:
	push rbp
	mov rbp, rsp

	mov r8, rdi 
	add r8, r8 ; ahora mido en bytes en lugar de ítems (2 bytes por c/int16_t)
	xorps xmm5, xmm5 ; re
	xorps xmm6, xmm6 ; im

	xor r10, r10 ; i = 0
	jmp .guarda
	.loop:
		movdqu xmm0, [rdx + r10 * 4]      ;; | Sin [0] | Cos [0] | Sin [1] | Cos [1] |
		movdqu xmm1, [rdx + r10 * 4 + 16] ;; | Sin [2] | Cos [2] | Sin [3] | Cos [3] |

		movdqu xmm3, xmm0 ; guardo el primer operando para no perderlo en el shuf

		shufps xmm0, xmm1, 0x88           ;; | Sin [0] | Sin [1] | Sin [2] | Sin [3] | 
		shufps xmm3, xmm1, 0xDD           ;; | Cos [0] | Cos [1] | Cos [2] | Cos [3] |

		pmovsxwd xmm4, [rsi + r10] ; extiendo signal
		cvtdq2ps xmm4, xmm4               ;; | sig [0] | sig [1] | sig [2] | sig [3] |

		mulps xmm0, xmm4 ; sin[i] * sig[i] (parcial)
		addps xmm6, xmm0 ; im += xmm0
		mulps xmm3, xmm4 ; cos[i] * sig[i] (parcial)
		addps xmm5, xmm3 ; re += xmm3

		add r10, 8 ; avanzo de a 4 words en simultaneo
		jmp .guarda	
	.guarda:
		cmp r10, r8
		jl .loop

	; Sumo horizontalmente dos veces para im y re
	haddps xmm5, xmm5
	haddps xmm5, xmm5
	haddps xmm6, xmm6
	haddps xmm6, xmm6

	mulps xmm5, xmm5 ; re*re
	mulps xmm6, xmm6 ; im*im
	addps xmm5, xmm6 ; re*re + im*im
	sqrtps xmm5, xmm5 ; sqrt
	addps xmm5, xmm5 ; 2*

	cvtsi2ss xmm7, rdi; Convierto size a float
	shufps xmm7, xmm7, 0x00; extiendo 
	divps xmm5, xmm7

	movaps xmm0, xmm5 ; valor de retorno
	pop rbp
	ret

global ej3_remove_duplicates
; void ej3_remove_duplicates(size_t size, char detected[size], char output[]);
;
; size:   Está en ??
; signal: Está en ??
; output: Está en ??
ej3_remove_duplicates:
	ret

global ej4_get_numbers
; void ej4_get_numbers(size_t size, char numbers[10 * (size - 1) + 16], size_t output[size]);
;
; size:   Está en ??
; signal: Está en ??
; output: Está en ??
ej4_get_numbers:
	ret
