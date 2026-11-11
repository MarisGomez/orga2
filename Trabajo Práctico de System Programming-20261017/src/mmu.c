/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de funciones del manejador de memoria
*/

#include "mmu.h"
#include "i386.h"

#include "kassert.h"

static pd_entry_t* kpd = (pd_entry_t*)KERNEL_PAGE_DIR;
static pt_entry_t* kpt = (pt_entry_t*)KERNEL_PAGE_TABLE_0;

static const uint32_t identity_mapping_end = 0x003FFFFF;
static const uint32_t user_memory_pool_end = 0x02FFFFFF;

static paddr_t next_free_kernel_page = 0x100000;
static paddr_t next_free_user_page = 0x400000;

/**
 * kmemset asigna el valor c a un rango de memoria interpretado
 * como un rango de bytes de largo n que comienza en s
 * @param s es el puntero al comienzo del rango de memoria
 * @param c es el valor a asignar en cada byte de s[0..n-1]
 * @param n es el tamaño en bytes a asignar
 * @return devuelve el puntero al rango modificado (alias de s)
*/
static inline void* kmemset(void* s, int c, size_t n) {
  uint8_t* dst = (uint8_t*)s;
  for (size_t i = 0; i < n; i++) {
    dst[i] = c;
  }
  return dst;
}

/**
 * zero_page limpia el contenido de una página que comienza en addr
 * @param addr es la dirección del comienzo de la página a limpiar
*/
static inline void zero_page(vaddr_t addr) {
  kmemset((void*)addr, 0x00, PAGE_SIZE);
}


void mmu_init(void) {}


/**
 * mmu_next_free_kernel_page devuelve la dirección física de la próxima página de kernel disponible. 
 * Las páginas se obtienen en forma incremental, siendo la primera: next_free_kernel_page
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de kernel
 */
paddr_t mmu_next_free_kernel_page(void) {
  paddr_t actual = next_free_kernel_page;
  next_free_kernel_page += PAGE_SIZE;

  return actual;
}

/**
 * mmu_next_free_user_page devuelve la dirección de la próxima página de usuarix disponible
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de usuarix
 */
paddr_t mmu_next_free_user_page(void) {
  paddr_t actual = next_free_user_page;
  next_free_user_page += PAGE_SIZE;

  return actual;
}

/**
 * mmu_init_kernel_dir inicializa las estructuras de paginación vinculadas al kernel y
 * realiza el identity mapping
 * @return devuelve la dirección de memoria de la página donde se encuentra el directorio
 * de páginas usado por el kernel
 */
paddr_t mmu_init_kernel_dir(void) {
  zero_page(KERNEL_PAGE_DIR);
  zero_page(KERNEL_PAGE_TABLE_0);

  // PDE[0] apunta a la tabla de páginas
  kpd[0].pt = KERNEL_PAGE_TABLE_0 >> 12; // kpd[0].pt guarda el page frame (bits 31-12)
  kpd[0].attrs = MMU_P | MMU_W; // 0x001 | 0x002 = 0x003 (Bit P y R/W prendidos, dejamos U/S en 0 ya que es de nivel kernel)

  for (int i = 0; i < 1024; i++) {
    kpt[i].page = i;
    kpt[i].attrs = MMU_P | MMU_W;
  }

  return KERNEL_PAGE_DIR;
}

/**
 * mmu_map_page agrega las entradas necesarias a las estructuras de paginación de modo de que
 * la dirección virtual virt se traduzca en la dirección física phy con los atributos definidos en attrs
 * @param cr3 el contenido que se ha de cargar en un registro CR3 al realizar la traducción
 * @param virt la dirección virtual que se ha de traducir en phy
 * @param phy la dirección física que debe ser accedida (dirección de destino)
 * @param attrs los atributos a asignar en la entrada de la tabla de páginas
 */
void mmu_map_page(uint32_t cr3, vaddr_t virt, paddr_t phy, uint32_t attrs) {
  paddr_t pd_phy = CR3_TO_PAGE_DIR(cr3); // obtengo el page directory de cr3
  pd_entry_t* pd = (pd_entry_t*) pd_phy; // cast

  uint32_t pdi = VIRT_PAGE_DIR(virt);    // Page Directory index
  uint32_t pti = VIRT_PAGE_TABLE(virt);  // Page Table index

  if((pd[pdi].attrs & MMU_P) == 0) { // Veo si la PDE (Page Directory Entry) está presente 
    paddr_t pt_phy = mmu_next_free_kernel_page(); // Si no esta presente, pido una pagina libre al kernel para usarla como page table
    zero_page(pt_phy); // La limpio

    pd[pdi].pt = pt_phy >> 12; // Page frame (bits 31-12)
    pd[pdi].attrs = MMU_P | MMU_W | (attrs & MMU_U); // LA PDE necesita P, W y U si es una pag de usuario
  }
  pt_entry_t* pt = (pt_entry_t*)MMU_ENTRY_PADDR(pd[pdi].pt); // Obtengo la page table desde la PDE

  pt[pti].page = phy >> 12; // escribo la PTE con la dir física
  pt[pti].attrs = attrs;    // y los atributos

  tlbflush(); // Es necesario pq estamos modificando la traducción actual
}

/**
 * mmu_unmap_page elimina la entrada vinculada a la dirección virt en la tabla de páginas correspondiente
 * @param virt la dirección virtual que se ha de desvincular
 * @return la dirección física de la página desvinculada
 */
paddr_t mmu_unmap_page(uint32_t cr3, vaddr_t virt) {
  paddr_t pd_phy = CR3_TO_PAGE_DIR(cr3); // obtengo el page directory de cr3
  pd_entry_t* pd = (pd_entry_t*) pd_phy; // cast

  uint32_t pdi = VIRT_PAGE_DIR(virt);    // Page Directory index
  uint32_t pti = VIRT_PAGE_TABLE(virt);  // Page Table index

  if((pd[pdi].attrs & MMU_P) == 0) return 0; // Si la PDE no esta presente, devuelvo 0

  pt_entry_t* pt = (pt_entry_t*)MMU_ENTRY_PADDR(pd[pdi].pt); // Obtengo la page table desde la PDE

  if((pt[pti].attrs & MMU_P) == 0) return 0; // Si la PTE no esta presente, devuelvo 0

  paddr_t phy = MMU_ENTRY_PADDR(pt[pti].page); // guardo la dirección física de la PTE

  pt[pti].page = 0;  // Limpio la PTE
  pt[pti].attrs = 0; // Limpio la PTE

  tlbflush();
  return phy; // Devuelvo la dirección física
}

#define DST_VIRT_PAGE 0xA00000
#define SRC_VIRT_PAGE 0xB00000

/**
 * copy_page copia el contenido de la página física localizada en la dirección src_addr a la página física ubicada en dst_addr
 * @param dst_addr la dirección a cuya página queremos copiar el contenido
 * @param src_addr la dirección de la página cuyo contenido queremos copiar
 *
 * Esta función mapea ambas páginas a las direcciones SRC_VIRT_PAGE y DST_VIRT_PAGE, respectivamente, realiza
 * la copia y luego desmapea las páginas. Usar la función rcr3 definida en i386.h para obtener el cr3 actual
 */
void copy_page(paddr_t dst_addr, paddr_t src_addr) {
  uint32_t cr3 = rcr3(); // obtengo el cr3 ACTUAL

  mmu_map_page(cr3, SRC_VIRT_PAGE, src_addr, MMU_P | MMU_W); // mapear src_addr en SRC_VIRT_PAGE
  mmu_map_page(cr3, DST_VIRT_PAGE, dst_addr, MMU_P | MMU_W); // mapear dst_addr en DST_VIRT_PAGE

  for (int i = 0; i < PAGE_SIZE; i++) { // Copiar
    ((uint8_t*)DST_VIRT_PAGE)[i] = ((uint8_t*)SRC_VIRT_PAGE)[i];
  }
  
  mmu_unmap_page(cr3, SRC_VIRT_PAGE); // Desmapeo
  mmu_unmap_page(cr3, DST_VIRT_PAGE); // Desmapeo
}

 /**
 * mmu_init_task_dir inicializa las estructuras de paginación vinculadas a una tarea cuyo código se encuentra en la dirección phy_start
 * @pararm phy_start es la dirección donde comienzan las dos páginas de código de la tarea asociada a esta llamada
 * @return el contenido que se ha de cargar en un registro CR3 para la tarea asociada a esta llamada
 */
paddr_t mmu_init_task_dir(paddr_t phy_start) {
  paddr_t pd_phy = mmu_next_free_kernel_page(); // Pido una página libre al kernel para el PD
  zero_page(pd_phy); // Limpio la PD

  pd_entry_t* task_pd = (pd_entry_t*) pd_phy;
  task_pd[0] = kpd[0]; // Identity mapping del kernel (kpd = kernel page directory)

  // Código: 2 páginas
  for (int i = 0; i < TASK_CODE_PAGES; i++) { // Mapeo las dos páginas de código
    mmu_map_page(
      pd_phy,
      TASK_CODE_VIRTUAL + i * PAGE_SIZE,
      phy_start + i * PAGE_SIZE,
      MMU_P | MMU_U // Sin MMU_W porque son sólo lectura
    );
  }
  
  // Stack: 1 página
  paddr_t stack_phy = mmu_next_free_user_page();
  mmu_map_page(
    pd_phy,
    TASK_STACK_BASE - PAGE_SIZE, // TASK_STACK_BASE es el tope de pila, no la base de la página | TASK_STACK_BASE - PAGE_SIZE = 0x08002000
    stack_phy,
    MMU_P | MMU_W | MMU_U
  );

  // Página compartida
  mmu_map_page(
    pd_phy,
    TASK_SHARED_PAGE,
    SHARED,
    MMU_P | MMU_U // Solo lectura
  );

  return pd_phy;
}

// Devuelve true si se atendió el page fault y puede continuar la ejecución 
// y false si no se pudo atender
bool page_fault_handler(vaddr_t virt) {
  // Chequeemos si el acceso fue dentro del area on-demand
  if (virt < ON_DEMAND_MEM_START_VIRTUAL || virt > ON_DEMAND_MEM_END_VIRTUAL) return false; // Verifico si virt esta dentro del rango

  uint32_t page = virt & 0xFFFFF000;
  uint32_t cr3 = rcr3();

  // En caso de que si, mapear la pagina
  mmu_map_page(
    cr3,
    page,
    ON_DEMAND_MEM_START_PHYSICAL,
    MMU_P | MMU_U | MMU_W // Lectura/escritura nivel usuario
  );
  print("Atendiendo page fault...", 0, 0, C_FG_WHITE | C_BG_BLACK);
  return true;
}
