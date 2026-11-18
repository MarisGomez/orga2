#include "../ejs.h"

Accion accionInversa(Accion accion) {
    if(accion == ACC_NORTE) return ACC_SUR;
    if(accion == ACC_SUR) return ACC_NORTE;
    if(accion == ACC_ESTE) return ACC_OESTE;
    if(accion == ACC_OESTE) return ACC_ESTE;
}

Recorrido *invertirRecorridoConDirecciones(const Recorrido *rec, uint64_t len) {
    if(rec == NULL || rec->acciones == NULL || rec->cant_acciones == 0) return NULL;

    Recorrido* rec_res = (Recorrido*) malloc(sizeof(Recorrido));
    rec_res->acciones = (Accion*) malloc(sizeof(Accion) * len);
    rec_res->cant_acciones = len;

    for (int i = 0; i < len; i++){
        rec_res->acciones[i] = accionInversa(rec->acciones[len -1 - i]);
    }
    return rec_res;
}