%define SYS_WRITE 1
%define SYS_EXIT 60
%define STDOUT 1

section .data
msg db '¡Hola mundo!', 10
len EQU $ - msg

global _start
section .text
_start:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, SYS_EXIT
    mov rdi, 0
    syscall

;Para ensamblarlo podemos correr la siguiente línea en la terminal de comandos (estando en la misma carpeta que el código):

;$ nasm -f elf64 -g -F DWARF HolaMundo.asm
;(el directorio se les habrá creado un archivo HolaMundo.o, un binario.
;Luego lo linkeamos con:)
;$ ld -o HolaMundo HolaMundo.o
;(Y finalmente lo ejecutamos con:)
;$ ./HolaMundo

; una vez tengo el Makefile ejecuramos
;$ make 
; o en su defecto
;$ make clean
;$ make
; y ahora sí
;$ ./HolaMundo