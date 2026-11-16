#include "utils.h"
#include "ejs.h"

pokemon_t* crear_pokemon(uint16_t id, const char* nombre, const char* tipo,
                         uint16_t nivel, uint16_t evoluciona_de_id) {
    pokemon_t* p = calloc(1, sizeof(pokemon_t));
    if (!p) return NULL;
    p->id = id;
    strncpy(p->info.nombre, nombre, 15);
    p->info.nombre[15] = '\0';
    strncpy(p->info.tipo, tipo, 11);
    p->info.tipo[11] = '\0';
    p->info.nivel = nivel;
    p->evoluciona_de_id = evoluciona_de_id;
    p->descripcion = NULL;
    for (int i = 0; i < 4; i++) p->movimientos[i] = NULL;
    return p;
}

void agregar_movimiento(pokemon_t* p, int slot, const char* nombre_movimiento) {
    if (!p || slot < 0 || slot >= 4) return;
    if (p->movimientos[slot]) free(p->movimientos[slot]);
    p->movimientos[slot] = malloc(strlen(nombre_movimiento) + 1);
    if (p->movimientos[slot]) {
        strcpy(p->movimientos[slot], nombre_movimiento);
    }
}

pokedex_t* crear_pokedex(uint32_t filas, uint32_t columnas) {
    pokedex_t* pdx = malloc(sizeof(pokedex_t));
    if (!pdx) return NULL;
    pdx->filas = filas;
    pdx->columnas = columnas;

    pdx->pokemons = malloc(sizeof(pokemon_t**) * filas);
    for (uint32_t i = 0; i < filas; i++) {
        pdx->pokemons[i] = calloc(columnas, sizeof(pokemon_t*));
    }

    uint32_t total = filas * columnas;
    uint32_t bitmap_bytes = (total + 7) / 8;
    pdx->bitmap = calloc(bitmap_bytes, 1);

    return pdx;
}

void activar_bit_mapa(pokedex_t* pokedex, uint32_t indice) {
    pokedex->bitmap[indice / 8] |= (1 << (indice % 8));
}

void desactivar_bit_mapa(pokedex_t* pokedex, uint32_t indice) {
    pokedex->bitmap[indice / 8] &= ~(1 << (indice % 8));
}

/**
 * Devuelve el valor del bit (0 o 1) en una posición dada dentro de un bitmap.
 *
 * @param bitmap    Puntero al arreglo de bytes del bitmap.
 * @param posicion  Índice del bit (0-indexado).
 * @return          1 si el bit está encendido, 0 si está apagado.
 */
uint8_t obtener_bit(const uint8_t* bitmap, uint32_t posicion) {
    uint32_t byte_index = posicion / 8;
    uint8_t bit_offset = posicion % 8;

    return (bitmap[byte_index] >> bit_offset) & 1;
}

void liberar_pokemon(pokemon_t* p) {
    if (!p) return;
    for (int i = 0; i < 4; i++) {
        free(p->movimientos[i]);
    }
    free(p->descripcion);
    free(p);
}

void liberar_pokedex(pokedex_t* pokedex) {
    if (!pokedex) return;
    for (uint32_t i = 0; i < pokedex->filas; i++) {
        for (uint32_t j = 0; j < pokedex->columnas; j++) {
            liberar_pokemon(pokedex->pokemons[i][j]);
        }
        free(pokedex->pokemons[i]);
    }
    free(pokedex->pokemons);
    free(pokedex->bitmap);
    free(pokedex);
}

void liberar_pokemon_filtrados(pokemon_filtrados_t* res) {
    if (!res) return;
    free(res->ids_pokemons);
    free(res);
}

void liberar_cadenas_evolucion(nodo_evolucion_t** cadenas, int cantidad) {
    if (!cadenas) return;
    for (int i = 0; i < cantidad; i++) {
        nodo_evolucion_t* cur = cadenas[i];
        while (cur) {
            nodo_evolucion_t* next = cur->evoluciona_en;
            free(cur);
            cur = next;
        }
    }
    free(cadenas);
}

void liberar_cadena_evolucion(nodo_evolucion_t* cabeza) {
    while (cabeza) {
        nodo_evolucion_t* next = cabeza->evoluciona_en;
        free(cabeza);
        cabeza = next;
    }
}

/* Asigna 2-4 movimientos segun el tipo del pokemon */
static void asignar_movimientos_por_tipo(pokemon_t* p, int evo_stage) {
    /* evo_stage: 0=base, 1=evo1, 2=evo2/legendario */
    const char* t = p->info.tipo;

    if (strcmp(t, "Planta") == 0) {
        agregar_movimiento(p, 0, "Latigo Cepa");
        agregar_movimiento(p, 1, "Hoja Afilada");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Drenadoras");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Rayo Solar");
    } else if (strcmp(t, "Fuego") == 0) {
        agregar_movimiento(p, 0, "Ascuas");
        agregar_movimiento(p, 1, "Giro Fuego");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Lanzallamas");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Llamarada");
    } else if (strcmp(t, "Agua") == 0) {
        agregar_movimiento(p, 0, "Pistola Agua");
        agregar_movimiento(p, 1, "Burbuja");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Surf");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Hidrobomba");
    } else if (strcmp(t, "Bicho") == 0) {
        agregar_movimiento(p, 0, "Picadura");
        agregar_movimiento(p, 1, "Disparo Demora");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Tijera X");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Zumbido");
    } else if (strcmp(t, "Normal") == 0) {
        agregar_movimiento(p, 0, "Placaje");
        agregar_movimiento(p, 1, "Rapidez");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Golpe Cuerpo");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Hiperrayo");
    } else if (strcmp(t, "Veneno") == 0) {
        agregar_movimiento(p, 0, "Acido");
        agregar_movimiento(p, 1, "Bomba Lodo");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Toxico");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Residuos");
    } else if (strcmp(t, "Electrico") == 0) {
        agregar_movimiento(p, 0, "Impactrueno");
        agregar_movimiento(p, 1, "Onda Trueno");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Rayo");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Trueno");
    } else if (strcmp(t, "Tierra") == 0) {
        agregar_movimiento(p, 0, "Ataque Arena");
        agregar_movimiento(p, 1, "Excavar");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Terremoto");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Fisura");
    } else if (strcmp(t, "Hada") == 0) {
        agregar_movimiento(p, 0, "Encanto");
        agregar_movimiento(p, 1, "Beso Dulce");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Brillo Magico");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Fuerza Lunar");
    } else if (strcmp(t, "Psiquico") == 0) {
        agregar_movimiento(p, 0, "Confusion");
        agregar_movimiento(p, 1, "Hipnosis");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Psiquico");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Premonicion");
    } else if (strcmp(t, "Roca") == 0) {
        agregar_movimiento(p, 0, "Lanzarrocas");
        agregar_movimiento(p, 1, "Pulimento");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Avalancha");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Roca Afilada");
    } else if (strcmp(t, "Hielo") == 0) {
        agregar_movimiento(p, 0, "Nieve Polvo");
        agregar_movimiento(p, 1, "Rayo Hielo");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Ventisca");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Granizo");
    } else if (strcmp(t, "Dragon") == 0) {
        agregar_movimiento(p, 0, "Furia Dragon");
        agregar_movimiento(p, 1, "Garra Dragon");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Pulso Dragon");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Cometa Draco");
    } else if (strcmp(t, "Fantasma") == 0) {
        agregar_movimiento(p, 0, "Lenguetazo");
        agregar_movimiento(p, 1, "Tinieblas");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Bola Sombra");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Maldicion");
    } else if (strcmp(t, "Lucha") == 0) {
        agregar_movimiento(p, 0, "Golpe Karate");
        agregar_movimiento(p, 1, "Patada Baja");
        if (evo_stage >= 1) agregar_movimiento(p, 2, "Patada Salto");
        if (evo_stage >= 2) agregar_movimiento(p, 3, "Onda Certera");
    }
}

typedef struct {
    uint16_t id;
    const char* name;
    const char* type;
    uint16_t level;
    uint16_t evolves_from_id;
    int evo_stage; /* 0=base, 1=evo1, 2=evo2/legend/no-evo-fuerte */
} gen1_entry_t;

pokedex_t* crear_pokedex_gen1(void) {
    static const gen1_entry_t gen1[] = {
        {  1, "Bulbasaur",   "Planta",    5,   0, 0},
        {  2, "Ivysaur",     "Planta",   16,   1, 1},
        {  3, "Venusaur",    "Planta",   32,   2, 2},
        {  4, "Charmander",  "Fuego",     5,   0, 0},
        {  5, "Charmeleon",  "Fuego",    16,   4, 1},
        {  6, "Charizard",   "Fuego",    36,   5, 2},
        {  7, "Squirtle",    "Agua",      5,   0, 0},
        {  8, "Wartortle",   "Agua",     16,   7, 1},
        {  9, "Blastoise",   "Agua",     36,   8, 2},
        { 10, "Caterpie",    "Bicho",     3,   0, 0},
        { 11, "Metapod",     "Bicho",     7,  10, 1},
        { 12, "Butterfree",  "Bicho",    10,  11, 2},
        { 13, "Weedle",      "Bicho",     3,   0, 0},
        { 14, "Kakuna",      "Bicho",     7,  13, 1},
        { 15, "Beedrill",    "Bicho",    10,  14, 2},
        { 16, "Pidgey",      "Normal",    3,   0, 0},
        { 17, "Pidgeotto",   "Normal",   18,  16, 1},
        { 18, "Pidgeot",     "Normal",   36,  17, 2},
        { 19, "Rattata",     "Normal",    3,   0, 0},
        { 20, "Raticate",    "Normal",   20,  19, 1},
        { 21, "Spearow",     "Normal",    5,   0, 0},
        { 22, "Fearow",      "Normal",   20,  21, 1},
        { 23, "Ekans",       "Veneno",    5,   0, 0},
        { 24, "Arbok",       "Veneno",   22,  23, 1},
        { 25, "Pikachu",     "Electrico", 10,  0, 0},
        { 26, "Raichu",      "Electrico", 30, 25, 1},
        { 27, "Sandshrew",   "Tierra",    5,   0, 0},
        { 28, "Sandslash",   "Tierra",   22,  27, 1},
        { 29, "NidoranF",    "Veneno",    5,   0, 0},
        { 30, "Nidorina",    "Veneno",   16,  29, 1},
        { 31, "Nidoqueen",   "Veneno",   36,  30, 2},
        { 32, "NidoranM",    "Veneno",    5,   0, 0},
        { 33, "Nidorino",    "Veneno",   16,  32, 1},
        { 34, "Nidoking",    "Veneno",   36,  33, 2},
        { 35, "Clefairy",    "Hada",     10,   0, 0},
        { 36, "Clefable",    "Hada",     30,  35, 1},
        { 37, "Vulpix",      "Fuego",    10,   0, 0},
        { 38, "Ninetales",   "Fuego",    30,  37, 1},
        { 39, "Jigglypuff",  "Normal",    8,   0, 0},
        { 40, "Wigglytuff",  "Normal",   30,  39, 1},
        { 41, "Zubat",       "Veneno",    5,   0, 0},
        { 42, "Golbat",      "Veneno",   22,  41, 1},
        { 43, "Oddish",      "Planta",    5,   0, 0},
        { 44, "Gloom",       "Planta",   21,  43, 1},
        { 45, "Vileplume",   "Planta",   36,  44, 2},
        { 46, "Paras",       "Bicho",     5,   0, 0},
        { 47, "Parasect",    "Bicho",    24,  46, 1},
        { 48, "Venonat",     "Bicho",     5,   0, 0},
        { 49, "Venomoth",    "Bicho",    31,  48, 1},
        { 50, "Diglett",     "Tierra",    5,   0, 0},
        { 51, "Dugtrio",     "Tierra",   26,  50, 1},
        { 52, "Meowth",      "Normal",    5,   0, 0},
        { 53, "Persian",     "Normal",   28,  52, 1},
        { 54, "Psyduck",     "Agua",      5,   0, 0},
        { 55, "Golduck",     "Agua",     33,  54, 1},
        { 56, "Mankey",      "Lucha",     5,   0, 0},
        { 57, "Primeape",    "Lucha",    28,  56, 1},
        { 58, "Growlithe",   "Fuego",    10,   0, 0},
        { 59, "Arcanine",    "Fuego",    35,  58, 1},
        { 60, "Poliwag",     "Agua",      5,   0, 0},
        { 61, "Poliwhirl",   "Agua",     25,  60, 1},
        { 62, "Poliwrath",   "Agua",     36,  61, 2},
        { 63, "Abra",        "Psiquico",  5,   0, 0},
        { 64, "Kadabra",     "Psiquico", 16,  63, 1},
        { 65, "Alakazam",    "Psiquico", 36,  64, 2},
        { 66, "Machop",      "Lucha",     5,   0, 0},
        { 67, "Machoke",     "Lucha",    28,  66, 1},
        { 68, "Machamp",     "Lucha",    36,  67, 2},
        { 69, "Bellsprout",  "Planta",    5,   0, 0},
        { 70, "Weepinbell",  "Planta",   21,  69, 1},
        { 71, "Victreebel",  "Planta",   36,  70, 2},
        { 72, "Tentacool",   "Agua",      5,   0, 0},
        { 73, "Tentacruel",  "Agua",     30,  72, 1},
        { 74, "Geodude",     "Roca",      5,   0, 0},
        { 75, "Graveler",    "Roca",     25,  74, 1},
        { 76, "Golem",       "Roca",     36,  75, 2},
        { 77, "Ponyta",      "Fuego",    10,   0, 0},
        { 78, "Rapidash",    "Fuego",    40,  77, 1},
        { 79, "Slowpoke",    "Agua",      5,   0, 0},
        { 80, "Slowbro",     "Agua",     37,  79, 1},
        { 81, "Magnemite",   "Electrico", 5,   0, 0},
        { 82, "Magneton",    "Electrico",30,  81, 1},
        { 83, "Farfetchd",   "Normal",   25,   0, 1},
        { 84, "Doduo",       "Normal",    5,   0, 0},
        { 85, "Dodrio",      "Normal",   31,  84, 1},
        { 86, "Seel",        "Agua",      5,   0, 0},
        { 87, "Dewgong",     "Agua",     34,  86, 1},
        { 88, "Grimer",      "Veneno",    5,   0, 0},
        { 89, "Muk",         "Veneno",   38,  88, 1},
        { 90, "Shellder",    "Agua",      5,   0, 0},
        { 91, "Cloyster",    "Agua",     35,  90, 1},
        { 92, "Gastly",      "Fantasma",  5,   0, 0},
        { 93, "Haunter",     "Fantasma", 25,  92, 1},
        { 94, "Gengar",      "Fantasma", 38,  93, 2},
        { 95, "Onix",        "Roca",     25,   0, 1},
        { 96, "Drowzee",     "Psiquico",  5,   0, 0},
        { 97, "Hypno",       "Psiquico", 26,  96, 1},
        { 98, "Krabby",      "Agua",      5,   0, 0},
        { 99, "Kingler",     "Agua",     28,  98, 1},
        {100, "Voltorb",     "Electrico", 5,   0, 0},
        {101, "Electrode",   "Electrico",30, 100, 1},
        {102, "Exeggcute",   "Planta",    5,   0, 0},
        {103, "Exeggutor",   "Planta",   35, 102, 1},
        {104, "Cubone",      "Tierra",    5,   0, 0},
        {105, "Marowak",     "Tierra",   28, 104, 1},
        {106, "Hitmonlee",   "Lucha",    30,   0, 1},
        {107, "Hitmonchan",  "Lucha",    30,   0, 1},
        {108, "Lickitung",   "Normal",   25,   0, 1},
        {109, "Koffing",     "Veneno",    5,   0, 0},
        {110, "Weezing",     "Veneno",   35, 109, 1},
        {111, "Rhyhorn",     "Tierra",    5,   0, 0},
        {112, "Rhydon",      "Tierra",   42, 111, 1},
        {113, "Chansey",     "Normal",   30,   0, 1},
        {114, "Tangela",     "Planta",   25,   0, 1},
        {115, "Kangaskhan",  "Normal",   30,   0, 1},
        {116, "Horsea",      "Agua",      5,   0, 0},
        {117, "Seadra",      "Agua",     32, 116, 1},
        {118, "Goldeen",     "Agua",      5,   0, 0},
        {119, "Seaking",     "Agua",     33, 118, 1},
        {120, "Staryu",      "Agua",      5,   0, 0},
        {121, "Starmie",     "Agua",     30, 120, 1},
        {122, "Mr.Mime",     "Psiquico", 30,   0, 1},
        {123, "Scyther",     "Bicho",    30,   0, 1},
        {124, "Jynx",        "Hielo",    30,   0, 1},
        {125, "Electabuzz",  "Electrico",30,   0, 1},
        {126, "Magmar",      "Fuego",    30,   0, 1},
        {127, "Pinsir",      "Bicho",    30,   0, 1},
        {128, "Tauros",      "Normal",   30,   0, 1},
        {129, "Magikarp",    "Agua",      5,   0, 0},
        {130, "Gyarados",    "Agua",     20, 129, 1},
        {131, "Lapras",      "Agua",     35,   0, 2},
        {132, "Ditto",       "Normal",   25,   0, 1},
        {133, "Eevee",       "Normal",   10,   0, 0},
        {134, "Vaporeon",    "Agua",     30, 133, 1},
        {135, "Jolteon",     "Electrico",30, 133, 1},
        {136, "Flareon",     "Fuego",    30, 133, 1},
        {137, "Porygon",     "Normal",   25,   0, 1},
        {138, "Omanyte",     "Roca",      5,   0, 0},
        {139, "Omastar",     "Roca",     40, 138, 1},
        {140, "Kabuto",      "Roca",      5,   0, 0},
        {141, "Kabutops",    "Roca",     40, 140, 1},
        {142, "Aerodactyl",  "Roca",     35,   0, 2},
        {143, "Snorlax",     "Normal",   35,   0, 2},
        {144, "Articuno",    "Hielo",    50,   0, 2},
        {145, "Zapdos",      "Electrico",50,   0, 2},
        {146, "Moltres",     "Fuego",    50,   0, 2},
        {147, "Dratini",     "Dragon",    5,   0, 0},
        {148, "Dragonair",   "Dragon",   30, 147, 1},
        {149, "Dragonite",   "Dragon",   55, 148, 2},
        {150, "Mewtwo",      "Psiquico", 70,   0, 2},
        {151, "Mew",         "Psiquico", 50,   0, 2},
    };

    int n = sizeof(gen1) / sizeof(gen1[0]); /* 151 */

    pokedex_t* pdx = crear_pokedex(16, 10);

    for (int i = 0; i < n; i++) {
        const gen1_entry_t* e = &gen1[i];
        pokemon_t* p = crear_pokemon(e->id, e->name, e->type, e->level, e->evolves_from_id);
        asignar_movimientos_por_tipo(p, e->evo_stage);

        /* Ubicar en la matriz: ID 1 en [0][0], ID 2 en [0][1], ... */
        uint32_t idx = e->id - 1;
        uint16_t row = idx / 10;
        uint16_t col = idx % 10;
        pdx->pokemons[row][col] = p;

        /* Bitmap: pokemon con ID par esta visto */
        if (e->id % 2 == 0) {
            activar_bit_mapa(pdx, idx);
        }
    }

    return pdx;
}

pokemon_t* buscar_por_id(pokedex_t* pokedex, uint16_t id) {
    if (id == 0) return NULL;
    for (uint32_t i = 0; i < pokedex->filas; i++) {
        for (uint32_t j = 0; j < pokedex->columnas; j++) {
            pokemon_t* p = pokedex->pokemons[i][j];
            if (p != NULL && p->id == id) return p;
        }
    }
    return NULL;
}

