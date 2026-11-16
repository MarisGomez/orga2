/* Tests del Ejercicio 2: obtener_avistados_por_tipo */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "../ejs.h"
#include "../utils.h"

/* Test 1: Todos los pokemon vistos y del mismo tipo */
TEST(test_ej2_all_seen_same_type) {
    pokedex_t* pdx = crear_pokedex(1, 3);
    pdx->pokemons[0][0] = crear_pokemon(1, "Charmander", "Fuego", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(4, "Vulpix", "Fuego", 10, 0);
    pdx->pokemons[0][2] = crear_pokemon(37, "Growlithe", "Fuego", 15, 0);

    activar_bit_mapa(pdx, 0);
    activar_bit_mapa(pdx, 1);
    activar_bit_mapa(pdx, 2);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Fuego");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 3);
    TEST_ASSERT(res->ids_pokemons[0] == 1);
    TEST_ASSERT(res->ids_pokemons[1] == 4);
    TEST_ASSERT(res->ids_pokemons[2] == 37);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 2: Ningun pokemon visto (bitmap todo ceros) */
TEST(test_ej2_none_seen) {
    pokedex_t* pdx = crear_pokedex(1, 2);
    pdx->pokemons[0][0] = crear_pokemon(1, "Bulbasaur", "Planta", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(2, "Ivysaur", "Planta", 16, 1);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Planta");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 0);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 3: Pokemon visto pero tipo incorrecto */
TEST(test_ej2_seen_wrong_type) {
    pokedex_t* pdx = crear_pokedex(1, 2);
    pdx->pokemons[0][0] = crear_pokemon(1, "Charmander", "Fuego", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(7, "Squirtle", "Agua", 5, 0);

    activar_bit_mapa(pdx, 0);
    activar_bit_mapa(pdx, 1);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Planta");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 0);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 4: Mezcla de vistos/no vistos y tipos correctos/incorrectos */
TEST(test_ej2_mixed_seen_and_types) {
    pokedex_t* pdx = crear_pokedex(2, 2);
    pdx->pokemons[0][0] = crear_pokemon(1, "Charmander", "Fuego", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(7, "Squirtle", "Agua", 5, 0);
    pdx->pokemons[1][0] = crear_pokemon(4, "Vulpix", "Fuego", 10, 0);
    pdx->pokemons[1][1] = crear_pokemon(37, "Ponyta", "Fuego", 20, 0);

    /* Solo vemos posiciones 0 y 2 (Charmander y Vulpix) */
    activar_bit_mapa(pdx, 0);
    activar_bit_mapa(pdx, 2);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Fuego");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 2);
    TEST_ASSERT(res->ids_pokemons[0] == 1);
    TEST_ASSERT(res->ids_pokemons[1] == 4);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 5: Pokedex con un solo pokemon que coincide */
TEST(test_ej2_single_match) {
    pokedex_t* pdx = crear_pokedex(1, 1);
    pdx->pokemons[0][0] = crear_pokemon(150, "Mewtwo", "Psiquico", 70, 0);
    activar_bit_mapa(pdx, 0);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Psiquico");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 1);
    TEST_ASSERT(res->ids_pokemons[0] == 150);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 7: Todos vistos, multiples tipos, filtrar uno */
TEST(test_ej2_all_seen_filter_one_type) {
    pokedex_t* pdx = crear_pokedex(2, 3);
    pdx->pokemons[0][0] = crear_pokemon(1, "Bulbasaur", "Planta", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(4, "Charmander", "Fuego", 5, 0);
    pdx->pokemons[0][2] = crear_pokemon(7, "Squirtle", "Agua", 5, 0);
    pdx->pokemons[1][0] = crear_pokemon(2, "Ivysaur", "Planta", 16, 1);
    pdx->pokemons[1][1] = crear_pokemon(5, "Charmeleon", "Fuego", 16, 4);
    pdx->pokemons[1][2] = crear_pokemon(8, "Wartortle", "Agua", 16, 7);

    for (uint32_t i = 0; i < 6; i++) activar_bit_mapa(pdx, i);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Agua");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 2);
    TEST_ASSERT(res->ids_pokemons[0] == 7);
    TEST_ASSERT(res->ids_pokemons[1] == 8);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 8: Bitmap en distintos bytes (mas de 8 pokemons) */
TEST(test_ej2_bitmap_multiple_bytes) {
    pokedex_t* pdx = crear_pokedex(3, 4);
    /* 12 posiciones = 2 bytes de bitmap */
    /* Poner pokemon de tipo "Agua" en posiciones 0, 9, 11 */
    pdx->pokemons[0][0] = crear_pokemon(7, "Squirtle", "Agua", 5, 0);
    pdx->pokemons[2][1] = crear_pokemon(8, "Wartortle", "Agua", 16, 7);
    pdx->pokemons[2][3] = crear_pokemon(9, "Blastoise", "Agua", 36, 8);

    /* Poner pokemon de otro tipo en posicion 5 */
    pdx->pokemons[1][1] = crear_pokemon(25, "Pikachu", "Electrico", 15, 172);

    activar_bit_mapa(pdx, 0);
    activar_bit_mapa(pdx, 5);
    activar_bit_mapa(pdx, 9);
    activar_bit_mapa(pdx, 11);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Agua");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 3);
    TEST_ASSERT(res->ids_pokemons[0] == 7);
    TEST_ASSERT(res->ids_pokemons[1] == 8);
    TEST_ASSERT(res->ids_pokemons[2] == 9);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 9: Tipo vacio como cadena */
TEST(test_ej2_no_pokemon_matches_rare_type) {
    pokedex_t* pdx = crear_pokedex(1, 2);
    pdx->pokemons[0][0] = crear_pokemon(1, "Bulbasaur", "Planta", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(4, "Charmander", "Fuego", 5, 0);

    activar_bit_mapa(pdx, 0);
    activar_bit_mapa(pdx, 1);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Dragon");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 0);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test 10: Solo algunos vistos del tipo correcto */
TEST(test_ej2_partial_seen_correct_type) {
    pokedex_t* pdx = crear_pokedex(1, 4);
    pdx->pokemons[0][0] = crear_pokemon(1, "Charmander", "Fuego", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(5, "Charmeleon", "Fuego", 16, 1);
    pdx->pokemons[0][2] = crear_pokemon(6, "Charizard", "Fuego", 36, 5);
    pdx->pokemons[0][3] = crear_pokemon(37, "Vulpix", "Fuego", 10, 0);

    /* Solo vemos el primero y el tercero */
    activar_bit_mapa(pdx, 0);
    activar_bit_mapa(pdx, 2);

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Fuego");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 2);
    TEST_ASSERT(res->ids_pokemons[0] == 1);
    TEST_ASSERT(res->ids_pokemons[1] == 6);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Stress test: Gen 1 - filtrar pokemon de agua vistos */
TEST(test_ej2_stress_gen1_filter_agua) {
    pokedex_t* pdx = crear_pokedex_gen1();

    /* Pokemon de Agua con ID par (vistos):
       8 Wartortle, 54 Psyduck, 60 Poliwag, 62 Poliwrath, 72 Tentacool,
       80 Slowbro, 86 Seel, 90 Shellder, 98 Krabby, 116 Horsea,
       118 Goldeen, 120 Staryu, 130 Gyarados, 134 Vaporeon */
    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Agua");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 14);

    /* Verificar que todos los IDs devueltos son pares y de tipo Agua */
    for (uint16_t i = 0; i < res->cantidad_pokemons; i++) {
        TEST_ASSERT(res->ids_pokemons[i] % 2 == 0);
        pokemon_t* p = buscar_por_id(pdx, res->ids_pokemons[i]);
        TEST_ASSERT(p != NULL);
        TEST_ASSERT(strcmp(p->info.tipo, "Agua") == 0);
    }

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Stress test: Gen 1 - filtrar pokemon de fuego vistos */
TEST(test_ej2_stress_gen1_filter_fuego) {
    pokedex_t* pdx = crear_pokedex_gen1();

    /* Pokemon de Fuego con ID par (vistos):
       4 (no, Charmander es impar... wait, 4 es par!
       4 Charmander, 6 Charizard, 38 Ninetales, 58 Growlithe,
       78 Rapidash, 126 Magmar, 136 Flareon, 146 Moltres */
    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Fuego");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 8);

    /* Verificar primer y ultimo ID */
    TEST_ASSERT(res->ids_pokemons[0] == 4);
    TEST_ASSERT(res->ids_pokemons[res->cantidad_pokemons - 1] == 146);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Stress test: Gen 1 - filtrar tipo dragon (pocos pokemon) */
TEST(test_ej2_stress_gen1_filter_dragon) {
    pokedex_t* pdx = crear_pokedex_gen1();

    /* Dragon con ID par: 148 Dragonair */
    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Dragon");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 1);
    TEST_ASSERT(res->ids_pokemons[0] == 148);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Stress test: Gen 1 - tipo que no existe */
TEST(test_ej2_stress_gen1_filter_inexistente) {
    pokedex_t* pdx = crear_pokedex_gen1();

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Acero");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 0);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

/* Test: Matriz dispersa con pokemon coincidente en posicion no trivial [2][1] */
TEST(test_ej2_sparse_matrix_non_trivial_position) {
    pokedex_t* pdx = crear_pokedex(3, 3);
    /* Pikachu (Electrico) en [2][1], visto (indice 7) */
    pdx->pokemons[2][1] = crear_pokemon(25, "Pikachu", "Electrico", 15, 172);
    activar_bit_mapa(pdx, 2 * 3 + 1);

    /* Charmander (Fuego) en [0][2], visto (indice 2) */
    pdx->pokemons[0][2] = crear_pokemon(4, "Charmander", "Fuego", 5, 0);
    activar_bit_mapa(pdx, 0 * 3 + 2);

    /* Raichu (Electrico) en [1][0], NO visto (indice 3, bit en 0) */
    pdx->pokemons[1][0] = crear_pokemon(26, "Raichu", "Electrico", 30, 25);

    /* Resto de las posiciones permanecen en NULL con bit en 0 */

    pokemon_filtrados_t* res = TEST_CALL_S(obtener_avistados_por_tipo, pdx, "Electrico");
    TEST_ASSERT(res != NULL);
    TEST_ASSERT(res->cantidad_pokemons == 1);
    TEST_ASSERT(res->ids_pokemons[0] == 25);

    liberar_pokemon_filtrados(res);
    liberar_pokedex(pdx);
}

int main(int argc, char *argv[]) {
    (void)argc; (void)argv;
    printf("Corriendo los tests del ejercicio 2 ...\n");

    test_ej2_all_seen_same_type();
    test_ej2_none_seen();
    test_ej2_seen_wrong_type();
    test_ej2_mixed_seen_and_types();
    test_ej2_single_match();
    test_ej2_all_seen_filter_one_type();
    test_ej2_bitmap_multiple_bytes();
    test_ej2_no_pokemon_matches_rare_type();
    test_ej2_partial_seen_correct_type();
    test_ej2_sparse_matrix_non_trivial_position();
    test_ej2_stress_gen1_filter_agua();
    test_ej2_stress_gen1_filter_fuego();
    test_ej2_stress_gen1_filter_dragon();
    test_ej2_stress_gen1_filter_inexistente();

    tests_end("Ejercicio 2");
    return 0;
}
