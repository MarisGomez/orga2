/* ** por compatibilidad se omiten tildes **
================================================================================
 TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Rutinas del controlador de interrupciones.
*/
#include "pic.h"

#define PIC1_PORT 0x20
#define PIC2_PORT 0xA0

static __inline __attribute__((always_inline)) void outb(uint32_t port,
                                                         uint8_t data) {
  __asm __volatile("outb %0,%w1" : : "a"(data), "d"(port));
}
void pic_finish1(void) { outb(PIC1_PORT, 0x20); }
void pic_finish2(void) {
  outb(PIC1_PORT, 0x20);
  outb(PIC2_PORT, 0x20);
}

// COMPLETAR: implementar pic_reset()
void pic_reset() {
  // ICW1: Inicializar, modo cascada, se requiere ICW4
  outb(PIC1_PORT, 0x11); // 0001 1001b VER: Inicialization Control Words
  outb(PIC2_PORT, 0x11); 

  // ICW2: Interrupt vector address
  outb(PIC1_PORT + 1, 0x20); // PIC 1 Empieza en 32
  outb(PIC2_PORT + 1, 0x28); // PIC 2 Empieza en 40

  // ICW3: Conexión en cascada
  outb(PIC1_PORT + 1, 0x04); // 0000 0100b | bit 2 = 1 - Esclavo en IRQ2
  outb(PIC2_PORT + 1, 0x02); // 0000 0010b | ID = 2    - Soye esclavo en IRQ2

  // ICW4: Modo 8086
  outb(PIC1_PORT + 1, 0x01); // 0000 0001b
  outb(PIC2_PORT + 1, 0x01); // 0000 0001b

  // Enmascarar todas las interrupcione hasta llamar a pic enable
  outb(PIC1_PORT + 1, 0xFF);
  outb(PIC2_PORT + 1, 0xFF);
}

void pic_enable() {
  outb(PIC1_PORT + 1, 0x00);
  outb(PIC2_PORT + 1, 0x00);
}

void pic_disable() {
  outb(PIC1_PORT + 1, 0xFF);
  outb(PIC2_PORT + 1, 0xFF);
}
