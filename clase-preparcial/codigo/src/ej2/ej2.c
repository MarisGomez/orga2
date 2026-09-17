#include "../ejs.h"

// Función auxiliar 
void eliminar_publicaciones_del_usuario(feed_t* feed, uint32_t id_usuario) {

  publicacion_t* actual = feed->first;
  publicacion_t* previa = NULL;
  bool encontramos_nuevo_first = false;

  while (actual != NULL) {
    publicacion_t* siguiente = actual->next;

    // vemos si la publicación es del usuario bloqueado o bloqueador
    bool es_del_usuario = (actual->value->id_autor == id_usuario);

    if (es_del_usuario) {
      // Eliminamos la publicación del arreglo
      if (previa != NULL) { // Desenlazamos la publicación actual
        previa->next = siguiente; // Pasamos de [previa -> actual -> siguiente] a [previa -> siguiente]
      }
      free(actual); 
      
    } else {
      // No hacemos nada, no tenemos que borrar la publicación
      if (!encontramos_nuevo_first) { // (no encontramos nuevo first)
        feed->first = actual;
        encontramos_nuevo_first = true;
      }
      previa = actual;
    }
    actual = siguiente; // avanzamos en el feed
  }

  if (!encontramos_nuevo_first) { // Suponiendo que todo el feed queda bloqueado o está vacío
    feed->first = NULL;
  }
}

void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear){
  
  // Agregamos usuarioABloquear al final del arreglo bloqueados de usuario
  usuario->bloqueados[usuario->cantBloqueados] = usuarioABloquear;
  usuario->cantBloqueados++;

  // Eliminamos las publicaciones de usuarioABloquear del feed de usuario
  eliminar_publicaciones_del_usuario(usuario->feed, usuarioABloquear->id);

  // Eliminamos las publicaciones de usuario del feed de usuarioABloquear
  eliminar_publicaciones_del_usuario(usuarioABloquear->feed, usuario->id);
}
