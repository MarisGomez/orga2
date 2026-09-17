#include "../ejs.h"

// Función auxiliar: Cuenta la cantidad de tuits sobresalientes del feed de un usuario
uint32_t cuantos_tuits_trending_topic(feed_t* feed, uint32_t user_id, 
                                      uint8_t (*esTuitSobresaliente)(tuit_t *)) {
    
    uint32_t contador = 0;
    publicacion_t* actual = feed->first;
    while (actual != NULL) { // Recorremos el feed
        tuit_t * tuit = actual->value;
        if (esTuitSobresaliente(tuit) && tuit->id_autor == user_id) {
            contador++; 
        }
        actual = actual->next; 
    }
    return contador;
}


tuit_t **trendingTopic(usuario_t *user,
                       uint8_t (*esTuitSobresaliente)(tuit_t *)) {
    
    // Cantidad de tuits tt del usuario
    uint32_t cantidad_tuits = cuantos_tuits_trending_topic(user->feed, user->id, esTuitSobresaliente);

    // Si cantidad_tuits es 0, devolvemos NULL
    if (cantidad_tuits == 0) return NULL;

    // Si cantidad_tuits es distinto a 0, pedimos memoria (+1 para NULL)
    tuit_t** tuits = (tuit_t**) malloc((cantidad_tuits + 1) * sizeof(tuit_t*));

    uint32_t i = 0;
    publicacion_t* actual = user->feed->first;
    while (actual != NULL) { // Comenzamos a recorrer el feed del usuario
        tuit_t* tuit = actual->value;
        if (esTuitSobresaliente(tuit) && tuit->id_autor == user->id) {
            tuits[i] = tuit;
            i++;
        }
        actual = actual->next;
    }
    tuits[i] = NULL;
    return tuits;
}
