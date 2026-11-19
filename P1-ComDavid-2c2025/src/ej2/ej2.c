#include "../ejs.h"
void *removerAparicionesPosterioresDe(publicacion_t *p){
   publicacion_t* prev = p;
   publicacion_t* actual = p->next;

   while(actual != NULL){
      publicacion_t* siguiente = actual->next;
      if(actual->value->usuario->id == p->value->usuario->id && 
         strcmp(actual->value->nombre, p->value->nombre) == 0){

            prev->next = siguiente;
            free(actual->value);
            free(actual);
      } else {
         prev = actual;
      }
   actual = siguiente;
   }
}

catalogo_t *removerCopias(catalogo_t *h) {
   for(publicacion_t* actual = h->first; actual != NULL; actual = actual->next){
      removerAparicionesPosterioresDe(actual);
   }
   return h;
}
