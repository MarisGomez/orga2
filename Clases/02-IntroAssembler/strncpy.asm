global .strncpy_asm

section .text
strncpy_asm:
    push rcx
    cld
    mov rcx, rdx
    REPE movsb
    pop rcx
    mov rax, rdi
    ret