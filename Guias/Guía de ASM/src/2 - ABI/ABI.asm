extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: 
; x1[EDI] Por convención de llamadas (64 bits)
; x2[ESI]                 ""
; x3[EDX]                 ""
; x4[ECX]                 ""
; x5[R8D]                 ""
; x6[R9D]                 ""
; x7[RBP+16] A este punto, nos quedamos sin registros y comenzamos a pushear a pila
; x8[RBP+24] OBS: normalmente los argumentos pasados por pila se acceden mediante desplazamientos positivos
alternate_sum_8:
	;prologo
  push RBP
  mov RBP, RSP
  sub RSP, 32 ; muevo el tope de la pila 8 bytes para guardar x4, 8 para x5 y 8 para x6 (+ 8 bytes para que quede alineada)

	mov [rbp-8], rdx  ; x3  | Notar que, no guardo x7 y x8 porque ya tienen su espacio en pila
  mov [rbp-16], rcx ; x4  | 
  mov [rbp-24], r8  ; x5  | 
  mov [rbp-32], r9  ; x6  | OBS: los desplazamientos negativos son para variables locales

  ; x1 - x2
  call restar_c 

  ; (x1 - x2) + x3
  mov EDI, EAX
  mov ESI, dword [RBP - 8] ;leo x3 de la pila
  call sumar_c

  ; (...) - x4
  mov EDI, EAX
  mov ESI, dword [RBP - 16] ;leo x4 de la pila
  call restar_c

  ; (...) + x5 
  mov EDI, EAX
  mov ESI, dword [RBP - 24] ;leo x5 de la pila
  call sumar_c

  ; (...) - x6
  mov EDI, EAX
  mov ESI, dword [RBP - 32] ;leo x6 de la pila
  call restar_c

  ; (...) + x7
  mov EDI, EAX
  mov ESI, dword [RBP + 16] ;leo x7 de la pila
  call sumar_c

  ; (...) - x8
  mov EDI, EAX
  mov ESI, dword [RBP + 24] ;leo x8 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 32 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros:
; destination[RDI] 
; x1[ESI]
; f1[XMM0]
product_2_f:
	cvtsi2ss xmm1, ESI ; xmm1 = x1 (float)

  mulss xmm1, xmm0   ; xmm1 *= xmm0

  cvtss2si EAX, xmm1 ; EAX = (uint32_t) resultado (trunca la parte decimal)

  mov [rdi], EAX     ; destination* = eax

  ret

;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: 
; destination[RDI]
; x1[ESI]                    f1[XMM0]
; x2[EDX]                    f2[XMM1]
; x3[ECX]                    f3[XMM2]
; x4[R8D]                    f4[XMM3]
; x5[R9D]                    f5[XMM4]
; x6[RBP+16]                 f6[XMM5]
; x7[RBP+24]                 f7[XMM6]
; x8[RBP+32]                 f8[XMM7]
;	x9[RBP+40]                 f9[RBP+48]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

  mov [rbp-8], rdx  ; x2
  mov [rbp-16], rcx ; x3
  mov [rbp-24], r8  ; x4
  mov [rbp-32], r9  ; x5

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0, xmm0 ; En esta instancia, todavía no convierto
  cvtss2sd xmm1, xmm1 ; f9 a double, ya que no me quedan registros
  cvtss2sd xmm2, xmm2 ; flotantes disponibles y la instrucción
  cvtss2sd xmm3, xmm3 ; cvtss2sd me obliga a usar xmm como 
  cvtss2sd xmm4, xmm4 ; registro destino.
  cvtss2sd xmm5, xmm5 ;
  cvtss2sd xmm6, xmm6 ;
  cvtss2sd xmm7, xmm7 ;

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd xmm0, xmm1
  mulsd xmm0, xmm2
  mulsd xmm0, xmm3
  mulsd xmm0, xmm4
  mulsd xmm0, xmm5
  mulsd xmm0, xmm6
  mulsd xmm0, xmm7
  cvtss2sd xmm1, [RBP+48] ; Convierto f9 a double en xmm1 ya que fue utilizado.
  mulsd xmm0, xmm1

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd xmm1, ESI
  cvtsi2sd xmm2, dword [rbp-8]  ; x2
  cvtsi2sd xmm3, dword [rbp-16] ; x3
  cvtsi2sd xmm4, dword [rbp-24] ; x4
  cvtsi2sd xmm5, dword [rbp-32] ; x5
  cvtsi2sd xmm6, dword [rbp+16] ; x6
  cvtsi2sd xmm7, dword [rbp+24] ; x7 | Me detengo acá por el mismo motivo que antes.

  mulsd xmm0, xmm1
  mulsd xmm0, xmm2
  mulsd xmm0, xmm3
  mulsd xmm0, xmm4
  mulsd xmm0, xmm5
  mulsd xmm0, xmm6
  mulsd xmm0, xmm7
  cvtss2sd xmm1, dword [RBP+32] ; x8
  cvtss2sd xmm2, dword [RBP+40] ; x9
  mulsd xmm0, xmm1
  mulsd xmm0, xmm2

  movsd [rdi], xmm0 ; destination* = xmm0
	; epilogo
	pop rbp
	ret

