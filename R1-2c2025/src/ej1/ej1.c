#include "../ejs.h"
#include <string.h>

bool encontrarTesoroEnMapa(Mapa *mapa, Recorrido *rec, uint64_t *acciones_ejecutadas) {
    *acciones_ejecutadas = 0;
    uint32_t actual = mapa->id_entrada;
    if(mapa->habitaciones[actual].contenido.es_tesoro) return true;

    for (int i = 0; i < rec->cant_acciones; i++){
        uint32_t direccion = rec->acciones[i];
        uint32_t siguiente = mapa->habitaciones[actual].vecinos[direccion];

        if (siguiente == 99) return false; // NO HAY VECINO EN ESA DIRECCIÓN
        
        actual = siguiente;
        (*acciones_ejecutadas) ++;
        if(mapa->habitaciones[actual].contenido.es_tesoro == true) return true;
    }
    return false;
}