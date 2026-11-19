#include "../ejs.h"

bool cumpleCondiciones(producto_t* producto){
    if(producto->estado == 1 && producto->usuario->nivel >= 1) return true;
    return false;
}

producto_t *filtrarPublicacionesNuevasDeUsuariosVerificados(catalogo_t *h) {
    int contador = 0;

    producto_t** res = (producto_t**) malloc(10 * sizeof(producto_t));
    publicacion_t* actual = h->first;

    while(actual != NULL){
        if(cumpleCondiciones(actual->value) == true){
            res[contador] = actual->value;
            contador ++;
        }
        actual = actual->next;
    }

    return(producto_t*)res;
}
