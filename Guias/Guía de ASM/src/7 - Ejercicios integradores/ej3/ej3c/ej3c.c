#include <string.h>
#include "../ejs.h"

estadisticas_t* calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id){

    estadisticas_t* estadisticas = calloc (1, sizeof(estadisticas_t)); // 1 * 7 = 7 bytes

    for (int i = 0; i < largo; i++) {
        caso_t caso = arreglo_casos[i]; 

        if (usuario_id != 0 && caso.usuario->id != usuario_id)
            continue; // con usuario id == 0 el continue nunca se dispara
        
        if (caso.estado == 0) estadisticas->cantidad_estado_0++;
        else if (caso.estado == 1) estadisticas->cantidad_estado_1++;
        else estadisticas->cantidad_estado_2++;

        if (strcmp(caso.categoria, "CLT") == 0) estadisticas->cantidad_CLT++;
        else if (strcmp(caso.categoria, "RBO") == 0) estadisticas->cantidad_RBO++;
        else if (strcmp(caso.categoria, "KSC") == 0) estadisticas->cantidad_KSC++;
        else estadisticas->cantidad_KDT++;
    }

    return estadisticas;
}



