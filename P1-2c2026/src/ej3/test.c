/* Tests del Ejercicio 3: rastrear_linea_evolutiva */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "../ejs.h"
#include "../utils.h"

/* Helper: cuenta nodos en una lista enlazada */
static int largo_cadena(nodo_evolucion_t* cabeza) {
    int count = 0;
    while (cabeza) { count++; cabeza = cabeza->evoluciona_en; }
    return count;
}

/* Helper: obtiene el ID del nodo en posicion idx (0-based) */
static uint16_t id_cadena_en(nodo_evolucion_t* cabeza, int idx) {
    for (int i = 0; i < idx && cabeza; i++) cabeza = cabeza->evoluciona_en;
    return cabeza ? cabeza->id : 0;
}

/* Test 1: Cadena de evolucion de 3 (Caterpie -> Metapod -> Butterfree) */
TEST(test_ej3_chain_of_3) {
    pokedex_t* pdx = crear_pokedex(1, 3);
    pdx->pokemons[0][0] = crear_pokemon(10, "Caterpie", "Bicho", 5, 0);
    pdx->pokemons[0][1] = crear_pokemon(11, "Metapod", "Bicho", 7, 10);
    pdx->pokemons[0][2] = crear_pokemon(12, "Butterfree", "Bicho", 10, 11);

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 12);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 10);
    TEST_ASSERT(id_cadena_en(res, 1) == 11);
    TEST_ASSERT(id_cadena_en(res, 2) == 12);

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Test 2: Pokemon base (evoluciona_de_id = 0) -> cadena de 1 */
TEST(test_ej3_base_pokemon_single_node) {
    pokedex_t* pdx = crear_pokedex(1, 1);
    pdx->pokemons[0][0] = crear_pokemon(1, "Bulbasaur", "Planta", 5, 0);

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 1);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 1);
    TEST_ASSERT(res->id == 1);
    TEST_ASSERT(res->evoluciona_en == NULL);

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Test 3: Cadena de evolucion de 2 */
TEST(test_ej3_chain_of_2) {
    pokedex_t* pdx = crear_pokedex(1, 2);
    pdx->pokemons[0][0] = crear_pokemon(133, "Eevee", "Normal", 10, 0);
    pdx->pokemons[0][1] = crear_pokemon(134, "Vaporeon", "Agua", 25, 133);

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 134);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 2);
    TEST_ASSERT(id_cadena_en(res, 0) == 133);
    TEST_ASSERT(id_cadena_en(res, 1) == 134);

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Test 4: IDs de evolucion no consecutivos (Pichu -> Pikachu -> Raichu) */
TEST(test_ej3_non_consecutive_ids) {
    pokedex_t* pdx = crear_pokedex(1, 3);
    pdx->pokemons[0][0] = crear_pokemon(172, "Pichu", "Electrico", 1, 0);
    pdx->pokemons[0][1] = crear_pokemon(25, "Pikachu", "Electrico", 15, 172);
    pdx->pokemons[0][2] = crear_pokemon(26, "Raichu", "Electrico", 30, 25);

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 26);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 172);
    TEST_ASSERT(id_cadena_en(res, 1) == 25);
    TEST_ASSERT(id_cadena_en(res, 2) == 26);

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Test 5: Cadena larga de 4 evoluciones */
TEST(test_ej3_chain_of_4) {
    pokedex_t* pdx = crear_pokedex(2, 2);
    pdx->pokemons[0][0] = crear_pokemon(100, "PokemonA", "Normal", 1, 0);
    pdx->pokemons[0][1] = crear_pokemon(200, "PokemonB", "Normal", 10, 100);
    pdx->pokemons[1][0] = crear_pokemon(300, "PokemonC", "Normal", 20, 200);
    pdx->pokemons[1][1] = crear_pokemon(400, "PokemonD", "Normal", 30, 300);

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 400);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 4);
    TEST_ASSERT(id_cadena_en(res, 0) == 100);
    TEST_ASSERT(id_cadena_en(res, 1) == 200);
    TEST_ASSERT(id_cadena_en(res, 2) == 300);
    TEST_ASSERT(id_cadena_en(res, 3) == 400);

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Test 6: Dos llamados sucesivos sobre la misma pokedex */
TEST(test_ej3_multiple_calls_independent) {
    pokedex_t* pdx = crear_pokedex(2, 3);
    /* Linea A: Pichu(172) -> Pikachu(25) -> Raichu(26) */
    pdx->pokemons[0][0] = crear_pokemon(172, "Pichu", "Electrico", 1, 0);
    pdx->pokemons[0][1] = crear_pokemon(25, "Pikachu", "Electrico", 15, 172);
    pdx->pokemons[0][2] = crear_pokemon(26, "Raichu", "Electrico", 30, 25);
    /* Linea B: Caterpie(10) -> Metapod(11) -> Butterfree(12) */
    pdx->pokemons[1][0] = crear_pokemon(10, "Caterpie", "Bicho", 5, 0);
    pdx->pokemons[1][1] = crear_pokemon(11, "Metapod", "Bicho", 7, 10);
    pdx->pokemons[1][2] = crear_pokemon(12, "Butterfree", "Bicho", 10, 11);

    nodo_evolucion_t* res1 = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 26);
    nodo_evolucion_t* res2 = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 12);

    TEST_ASSERT(res1 != NULL);
    TEST_ASSERT(largo_cadena(res1) == 3);
    TEST_ASSERT(id_cadena_en(res1, 0) == 172);
    TEST_ASSERT(id_cadena_en(res1, 1) == 25);
    TEST_ASSERT(id_cadena_en(res1, 2) == 26);

    TEST_ASSERT(res2 != NULL);
    TEST_ASSERT(largo_cadena(res2) == 3);
    TEST_ASSERT(id_cadena_en(res2, 0) == 10);
    TEST_ASSERT(id_cadena_en(res2, 1) == 11);
    TEST_ASSERT(id_cadena_en(res2, 2) == 12);

    liberar_cadena_evolucion(res1);
    liberar_cadena_evolucion(res2);
    liberar_pokedex(pdx);
}

/* Test 7: Ancestros distribuidos en distintas filas y columnas de la matriz */
TEST(test_ej3_ancestors_spread_across_matrix) {
    pokedex_t* pdx = crear_pokedex(3, 2);
    pdx->pokemons[0][0] = crear_pokemon(1, "Charmander", "Fuego", 5, 0);
    pdx->pokemons[1][1] = crear_pokemon(2, "Charmeleon", "Fuego", 16, 1);
    pdx->pokemons[2][0] = crear_pokemon(3, "Charizard", "Fuego", 36, 2);

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 3);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 1);
    TEST_ASSERT(id_cadena_en(res, 1) == 2);
    TEST_ASSERT(id_cadena_en(res, 2) == 3);

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Test 8: Matriz con ruido y posiciones NULL */
TEST(test_ej3_matrix_with_noise_and_nulls) {
    pokedex_t* pdx = crear_pokedex(3, 3);
    /* Cadena: Charmander(4) -> Charmeleon(5) -> Charizard(6) */
    pdx->pokemons[0][0] = crear_pokemon(4, "Charmander", "Fuego", 5, 0);
    pdx->pokemons[1][2] = crear_pokemon(5, "Charmeleon", "Fuego", 16, 4);
    pdx->pokemons[2][1] = crear_pokemon(6, "Charizard", "Fuego", 36, 5);

    /* Ruido: pokemons que no pertenecen a la cadena */
    pdx->pokemons[0][2] = crear_pokemon(25, "Pikachu", "Electrico", 15, 172);
    pdx->pokemons[2][0] = crear_pokemon(7, "Squirtle", "Agua", 5, 0);

    /* Posiciones [0][1], [1][0], [1][1], [2][2] permanecen en NULL */

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 6);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 4);
    TEST_ASSERT(id_cadena_en(res, 1) == 5);
    TEST_ASSERT(id_cadena_en(res, 2) == 6);

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Stress test 1: Gen 1 - Venusaur (Bulbasaur->Ivysaur->Venusaur) */
TEST(test_ej3_stress_gen1_venusaur_line) {
    pokedex_t* pdx = crear_pokedex_gen1();

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 3);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 1);  /* Bulbasaur */
    TEST_ASSERT(id_cadena_en(res, 1) == 2);  /* Ivysaur */
    TEST_ASSERT(id_cadena_en(res, 2) == 3);  /* Venusaur */

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Stress test 2: Gen 1 - Charizard (Charmander->Charmeleon->Charizard) */
TEST(test_ej3_stress_gen1_charizard_line) {
    pokedex_t* pdx = crear_pokedex_gen1();

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 6);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 4);  /* Charmander */
    TEST_ASSERT(id_cadena_en(res, 1) == 5);  /* Charmeleon */
    TEST_ASSERT(id_cadena_en(res, 2) == 6);  /* Charizard */

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Stress test 3: Gen 1 - Blastoise (Squirtle->Wartortle->Blastoise) */
TEST(test_ej3_stress_gen1_blastoise_line) {
    pokedex_t* pdx = crear_pokedex_gen1();

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 9);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 7);  /* Squirtle */
    TEST_ASSERT(id_cadena_en(res, 1) == 8);  /* Wartortle */
    TEST_ASSERT(id_cadena_en(res, 2) == 9);  /* Blastoise */

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Stress test 4: Gen 1 - Dragonite (cadena de 3 con IDs altos: Dratini->Dragonair->Dragonite) */
TEST(test_ej3_stress_gen1_dragonite_line) {
    pokedex_t* pdx = crear_pokedex_gen1();

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 149);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 147); /* Dratini */
    TEST_ASSERT(id_cadena_en(res, 1) == 148); /* Dragonair */
    TEST_ASSERT(id_cadena_en(res, 2) == 149); /* Dragonite */

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Stress test 5: Gen 1 - Gengar (Gastly->Haunter->Gengar) */
TEST(test_ej3_stress_gen1_gengar_line) {
    pokedex_t* pdx = crear_pokedex_gen1();

    nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, 94);

    TEST_ASSERT(res != NULL);
    TEST_ASSERT(largo_cadena(res) == 3);
    TEST_ASSERT(id_cadena_en(res, 0) == 92); /* Gastly */
    TEST_ASSERT(id_cadena_en(res, 1) == 93); /* Haunter */
    TEST_ASSERT(id_cadena_en(res, 2) == 94); /* Gengar */

    liberar_cadena_evolucion(res);
    liberar_pokedex(pdx);
}

/* Stress test 6: Gen 1 - pokemon base sin evoluciones (Mew, Mewtwo, Articuno) */
TEST(test_ej3_stress_gen1_base_legendaries) {
    pokedex_t* pdx = crear_pokedex_gen1();

    uint16_t legendarios[] = {144, 145, 146, 150, 151};
    for (int i = 0; i < 5; i++) {
        nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, legendarios[i]);
        TEST_ASSERT(res != NULL);
        TEST_ASSERT(largo_cadena(res) == 1);
        TEST_ASSERT(res->id == legendarios[i]);
        TEST_ASSERT(res->evoluciona_en == NULL);
        liberar_cadena_evolucion(res);
    }

    liberar_pokedex(pdx);
}

/* Stress test 7: Gen 1 - Eeveelutions (3 ramas distintas desde el mismo base) */
TEST(test_ej3_stress_gen1_eeveelutions) {
    pokedex_t* pdx = crear_pokedex_gen1();

    uint16_t eeveelutions[] = {134, 135, 136}; /* Vaporeon, Jolteon, Flareon */
    for (int i = 0; i < 3; i++) {
        nodo_evolucion_t* res = TEST_CALL_S(rastrear_linea_evolutiva, pdx, eeveelutions[i]);
        TEST_ASSERT(res != NULL);
        TEST_ASSERT(largo_cadena(res) == 2);
        TEST_ASSERT(id_cadena_en(res, 0) == 133); /* Eevee */
        TEST_ASSERT(id_cadena_en(res, 1) == eeveelutions[i]);
        liberar_cadena_evolucion(res);
    }

    liberar_pokedex(pdx);
}

int main(int argc, char *argv[]) {
    (void)argc; (void)argv;
    printf("Corriendo los tests del ejercicio 3 ...\n");

    test_ej3_chain_of_3();
    test_ej3_base_pokemon_single_node();
    test_ej3_chain_of_2();
    test_ej3_non_consecutive_ids();
    test_ej3_chain_of_4();
    test_ej3_multiple_calls_independent();
    test_ej3_ancestors_spread_across_matrix();
    test_ej3_matrix_with_noise_and_nulls();
    test_ej3_stress_gen1_venusaur_line();
    test_ej3_stress_gen1_charizard_line();
    test_ej3_stress_gen1_blastoise_line();
    test_ej3_stress_gen1_dragonite_line();
    test_ej3_stress_gen1_gengar_line();
    test_ej3_stress_gen1_base_legendaries();
    test_ej3_stress_gen1_eeveelutions();

    tests_end("Ejercicio 3");
    return 0;
}
