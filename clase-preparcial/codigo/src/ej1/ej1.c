#include "../ejs.h"
#include <string.h>

// Función auxiliar: crea publicación y la agrega al comienzo del feed
void agregar_tuit_al_feed(tuit_t* tuit, feed_t* feed) {
  // Pedimos memoria para la publicación
  publicacion_t* publicacion = (publicacion_t*) malloc(sizeof(publicacion_t));

  // Ponemos el puntero al tuit
  publicacion->value = tuit;

  // Ponemos como next el puntero que actualmente tiene como first el feed
  publicacion_t* next = feed->first;
  publicacion->next = next;

  // Agregamos la publicación al inicio del feed
  feed->first = publicacion;
}


// Función principal: publicar un tuit
tuit_t *publicar(char *mensaje, usuario_t *user) {
  // Pedimos memoria para el tuit 
  tuit_t* tuit = (tuit_t*) malloc(sizeof(tuit_t));

  // Completamos los campos que corresponden al tuit
  // * Favoritos
  // * Retuits
  // * Autor
  // * MENSAJE
  tuit->favoritos = 0;
  tuit->retuits = 0;
  tuit->id_autor = user->id;
  // Copiamos el mensaje
  strcpy(tuit->mensaje, mensaje);

  // Agregamos el tuit al principio del feed como una publicación
  // Primero al principio de su propio feed (del autor)
  agregar_tuit_al_feed(tuit, user->feed);

  // Ahora lo agregamos al principio del feed de sus seguidores
  for (int i = 0; i < user->cantSeguidores; i++) {
    usuario_t* seguidor = user->seguidores[i];
    agregar_tuit_al_feed(tuit, seguidor->feed);
  }

  return tuit;
}
