; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - Arquitectura y Organizacion de Computadoras - FCEN
; ==============================================================================

%include "print.mac"

global start


; Agreguen declaraciones extern según vayan necesitando
extern GDT_DESC
extern screen_draw_layout
extern idt_init
extern IDT_DESC
extern pic_reset
extern pic_enable
extern mmu_init_kernel_dir
extern mmu_init_task_dir
; Definan correctamente estas constantes cuando las necesiten
; CS_RING_0_SEL apunta a GDT_IDX_CODE_0 y DS_RING_0_SEL apunta a GDT_IDX_DATA_0
%define CS_RING_0_SEL ((1 << 3) | 0)
%define DS_RING_0_SEL ((3 << 3) | 0)


BITS 16
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; ==============================
    ; ||  Salto a modo protegido  ||
    ; ==============================

    ;Deshabilitar interrupciones (Parte 1: Pasaje a modo protegido)
    cli ; clear interrupt flag

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida - MODO REAL (Parte 1: Pasaje a modo protegido)
    print_text_rm start_rm_msg, start_rm_len, 0x0A, 0, 0 

    ; Habilitar A20 (Parte 1: Pasaje a modo protegido)
    call A20_enable

    ; Cargar la GDT (Parte 1: Pasaje a modo protegido)
    lgdt [GDT_DESC] ; load GDT

    ; Setear el bit PE del registro CR0 (Parte 1: Pasaje a modo protegido)
    mov eax, CR0
    or eax, 1
    mov CR0, eax

    ; Saltar a modo protegido (far jump) (Parte 1: Pasaje a modo protegido)
    jmp CS_RING_0_SEL:modo_protegido

BITS 32
modo_protegido:
    ; (Parte 1: Pasaje a modo protegido) - Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    mov ax, DS_RING_0_SEL
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax

    ; Establecer el tope y la base de la pila (Parte 1: Pasaje a modo protegido)
    mov ebp, 0x25000
    mov esp, 0x25000

    ; Imprimir mensaje de bienvenida - MODO PROTEGIDO (Parte 1: Pasaje a modo protegido)
    print_text_pm start_pm_msg, start_pm_len, 0x04, 0, 0 

    ; Inicializar pantalla (Parte 1: Pasaje a modo protegido)
    call screen_draw_layout
    
    ; ===================================
    ; ||     (Parte 3: Paginación)     ||
    ; ===================================

    ; los defines para la MMU en defines.h
    ; las funciones en mmu.c
    ; COMPLETAR - reemplazar la implementacion de la interrupcion 88 (ver comentarios en isr.asm)
    ; COMPLETAR - La rutina de atención del page fault en isr.asm
    ; Inicializar el directorio de paginas
    call mmu_init_kernel_dir

    ; Cargar directorio de paginas
    mov cr3, eax

    ; Habilitar paginacion
    mov eax, cr0
    or eax, 0x80000000 ;; 1000 0000 0000 0000 0000 0000 0000 0000 (cr0.pg = 1 para activar paginación)
    mov cr0, eax

    ; ========================
    ; ||  (Parte 4: Tareas) ||
    ; ========================

    ; COMPLETAR - reemplazar la implementacion de la interrupcion 88 (ver comentarios en isr.asm)
    ; COMPLETAR - las funciones en tss.c
    ; COMPLETAR - Inicializar tss

    ; COMPLETAR - Inicializar el scheduler

    ; COMPLETAR - Inicializar las tareas


    ; ===================================
    ; ||   (Parte 2: Interrupciones)   ||
    ; ===================================

    ; COMPLETAR - las funciones en idt.c

    ; Inicializar y cargar la IDT
    call idt_init    ;; inicializo IDT
    lidt [IDT_DESC]  ;; cargo IDT en memoria 

    ; Reiniciar y habilitar el controlador de interrupciones (ver pic.c)
    call pic_reset
    call pic_enable

    ; Rutinas de atención de reloj, teclado, e interrupciones 88 y 89 (en isr.asm)

    ; COMPLETAR (Parte 4: Tareas)- Cargar tarea inicial

    ; Habilitar interrupciones (!! en etapas posteriores, evaluar si se debe comentar este código !!)
    sti
    
    ; NOTA: Pueden chequear que las interrupciones funcionen forzando a que se
    ;       dispare alguna excepción (lo más sencillo es usar la instrucción
    ;       `int3`)
    ;int3

    ; Probar Sys_call (para etapas posteriores, comentar este código)
    mov eax, 0
    int 88

    mov eax, 0
    int 98

    ; Probar generar una excepción (para etapas posteriores, comentar este código)
    
    ; ========================
    ; ||  (Parte 4: Tareas)  ||
    ; ========================
    
    ; Inicializar el directorio de paginas de la tarea de prueba
    cli ;; Evito que una interrupción se meta en el medio

    mov ebx, cr3 ;; Guardo el cr3 actual en pila del kernel
    push ebx

    push 0x18000
    call mmu_init_task_dir ;; mmu_init_task_dir(0x18000) devuelve en eax el cr3 de la tarea ficticia
    add esp, 4

    ; Cargar directorio de paginas de la tarea
    mov cr3, eax ;; eax contiene el cr3 del directorio de páginas de tarea

    ;; Primera escritura
    mov dword [0x07000000], 0x12345678 ;; 0x07000000 todavia no esta mapeada, se dispara page fault

    ;; Segunda escritura
    mov dword [0x07000000], 0x12345670 ;; 0x07000000 ya quedó mapeada, no debe disparar page fault

    ; Restaurar directorio de paginas del kernel
    pop ebx
    mov cr3, ebx

    sti ;; Vuelvo a habilitar interrupciones

    ; COMPLETAR - Saltar a la primera tarea: Idle

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
