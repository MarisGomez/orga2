#include "../ejs.h"

// Función auxiliar para contar casos por nivel
int contar_casos_por_nivel(caso_t* arreglo_casos, int largo, int nivel) {

    int contador = 0;

    for (int i = 0; i < largo; i++) {
        caso_t caso = arreglo_casos[i];

        if (caso.usuario->nivel == nivel)
            contador += 1;
        
    }
    return contador;
}

segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo) {

    int contador0 = contar_casos_por_nivel(arreglo_casos, largo, 0);
    int contador1 = contar_casos_por_nivel(arreglo_casos, largo, 1);
    int contador2 = contar_casos_por_nivel(arreglo_casos, largo, 2);

    segmentacion_t* segmento = (segmentacion_t*) malloc(sizeof(segmentacion_t));

    segmento->casos_nivel_0 = contador0 > 0 ? (caso_t*) malloc(contador0 * sizeof(caso_t)) : NULL;
    segmento->casos_nivel_1 = contador1 > 0 ? (caso_t*) malloc(contador1 * sizeof(caso_t)) : NULL;
    segmento->casos_nivel_2 = contador2 > 0 ? (caso_t*) malloc(contador2 * sizeof(caso_t)) : NULL;

    int t0 = 0, t1 = 0, t2 = 0;

    for (int i = 0; i < largo; i++) {
        caso_t caso = arreglo_casos[i];

        if (caso.usuario->nivel == 0)
            segmento->casos_nivel_0[t0++] = caso;
        else if (caso.usuario->nivel == 1)
            segmento->casos_nivel_1[t1++] = caso;
        else
            segmento->casos_nivel_2[t2++] = caso;
    }
    return segmento;
}
