#include <string.h>
#include "../ejs.h"

void resolver_automaticamente(funcionCierraCasos_t* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo){

    int index = 0; // indice para arreglo casos_a_revisar

    for (int i = 0; i < largo; i++) {
        caso_t caso = arreglo_casos[i];

        if (caso.usuario->nivel == 1 || caso.usuario->nivel == 2) {
            uint16_t res_func = funcion(&caso); // caso_t* p = &caso

            if (res_func == 1)
                arreglo_casos[i].estado = 1;
            else if (res_func == 0 && (strcmp(caso.categoria, "CLT") == 0 || strcmp(caso.categoria, "RBO") == 0))
                arreglo_casos[i].estado = 2;
            else 
                casos_a_revisar[index++] = caso;

        } else {
            casos_a_revisar[index++] = caso;
        }
    }

}

