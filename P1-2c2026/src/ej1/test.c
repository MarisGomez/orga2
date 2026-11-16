/* Tests del Ejercicio 1: actualizar_movimientos_pokemon */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "../ejs.h"
#include "../utils.h"

/* Test 1: Update con exactamente 4 moves */
TEST(test_ej1_update_4_moves) {
    pokemon_t* poke = crear_pokemon(1, "Charmander", "Fuego", 5, 0);

    char* new_moves[] = {"Ember", "Scratch", "Growl", "Leer"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, new_moves, 4);

    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Ember") == 0);
    TEST_ASSERT(poke->movimientos[1] != NULL && strcmp(poke->movimientos[1], "Scratch") == 0);
    TEST_ASSERT(poke->movimientos[2] != NULL && strcmp(poke->movimientos[2], "Growl") == 0);
    TEST_ASSERT(poke->movimientos[3] != NULL && strcmp(poke->movimientos[3], "Leer") == 0);

    liberar_pokemon(poke);
}

/* Test 2: Update con menos de 4 moves, el resto debe quedar NULL */
TEST(test_ej1_update_fewer_than_4_moves) {
    pokemon_t* poke = crear_pokemon(2, "Squirtle", "Agua", 5, 0);

    char* new_moves[] = {"Tackle", "Bubble"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, new_moves, 2);

    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Tackle") == 0);
    TEST_ASSERT(poke->movimientos[1] != NULL && strcmp(poke->movimientos[1], "Bubble") == 0);
    TEST_ASSERT(poke->movimientos[2] == NULL);
    TEST_ASSERT(poke->movimientos[3] == NULL);

    liberar_pokemon(poke);
}

/* Test 3: Update con mas de 4 moves, solo los primeros 4 */
TEST(test_ej1_update_more_than_4_moves) {
    pokemon_t* poke = crear_pokemon(3, "Bulbasaur", "Planta", 5, 0);

    char* new_moves[] = {"Tackle", "Growl", "Vine Whip", "Razor Leaf", "Sleep Powder", "Solar Beam"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, new_moves, 6);

    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Tackle") == 0);
    TEST_ASSERT(poke->movimientos[1] != NULL && strcmp(poke->movimientos[1], "Growl") == 0);
    TEST_ASSERT(poke->movimientos[2] != NULL && strcmp(poke->movimientos[2], "Vine Whip") == 0);
    TEST_ASSERT(poke->movimientos[3] != NULL && strcmp(poke->movimientos[3], "Razor Leaf") == 0);

    liberar_pokemon(poke);
}

/* Test 4: Liberar moves anteriores y reemplazar */
TEST(test_ej1_free_old_moves_then_replace) {
    pokemon_t* poke = crear_pokemon(4, "Pikachu", "Electrico", 10, 172);

    agregar_movimiento(poke, 0, "Thunder Shock");
    agregar_movimiento(poke, 1, "Quick Attack");
    agregar_movimiento(poke, 2, "Tail Whip");
    agregar_movimiento(poke, 3, "Thunder Wave");

    char* new_moves[] = {"Thunderbolt", "Iron Tail"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, new_moves, 2);

    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Thunderbolt") == 0);
    TEST_ASSERT(poke->movimientos[1] != NULL && strcmp(poke->movimientos[1], "Iron Tail") == 0);
    TEST_ASSERT(poke->movimientos[2] == NULL);
    TEST_ASSERT(poke->movimientos[3] == NULL);

    liberar_pokemon(poke);
}

/* Test 5: Pokemon NULL no produce cambios ni errores */
TEST(test_ej1_null_pokemon) {
    char* new_moves[] = {"Sing"};
    TEST_CALL_V(actualizar_movimientos_pokemon, NULL, new_moves, 1);
    /* No debe crashear */
}

/* Test 6: Update con 0 moves (todos NULL) */
TEST(test_ej1_update_zero_moves) {
    pokemon_t* poke = crear_pokemon(6, "Mewtwo", "Psiquico", 70, 0);

    agregar_movimiento(poke, 0, "Psychic");
    agregar_movimiento(poke, 1, "Shadow Ball");

    char* new_moves[] = {};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, new_moves, 0);

    TEST_ASSERT(poke->movimientos[0] == NULL);
    TEST_ASSERT(poke->movimientos[1] == NULL);
    TEST_ASSERT(poke->movimientos[2] == NULL);
    TEST_ASSERT(poke->movimientos[3] == NULL);

    liberar_pokemon(poke);
}

/* Test 7: Update con 1 solo move */
TEST(test_ej1_update_single_move) {
    pokemon_t* poke = crear_pokemon(7, "Magikarp", "Agua", 1, 0);

    char* new_moves[] = {"Splash"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, new_moves, 1);

    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Splash") == 0);
    TEST_ASSERT(poke->movimientos[1] == NULL);
    TEST_ASSERT(poke->movimientos[2] == NULL);
    TEST_ASSERT(poke->movimientos[3] == NULL);

    liberar_pokemon(poke);
}

/* Test 8: Actualizaciones consecutivas sobre el mismo pokemon */
TEST(test_ej1_consecutive_updates) {
    pokemon_t* poke = crear_pokemon(25, "Pikachu", "Electrico", 15, 172);

    char* moves1[] = {"Thunder Shock", "Quick Attack"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, moves1, 2);
    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Thunder Shock") == 0);
    TEST_ASSERT(poke->movimientos[1] != NULL && strcmp(poke->movimientos[1], "Quick Attack") == 0);
    TEST_ASSERT(poke->movimientos[2] == NULL);

    char* moves2[] = {"Volt Tackle", "Thunder", "Agility", "Electro Ball"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, moves2, 4);
    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Volt Tackle") == 0);
    TEST_ASSERT(poke->movimientos[1] != NULL && strcmp(poke->movimientos[1], "Thunder") == 0);
    TEST_ASSERT(poke->movimientos[2] != NULL && strcmp(poke->movimientos[2], "Agility") == 0);
    TEST_ASSERT(poke->movimientos[3] != NULL && strcmp(poke->movimientos[3], "Electro Ball") == 0);

    char* moves3[] = {"Spark"};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, moves3, 1);
    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Spark") == 0);
    TEST_ASSERT(poke->movimientos[1] == NULL);
    TEST_ASSERT(poke->movimientos[2] == NULL);
    TEST_ASSERT(poke->movimientos[3] == NULL);

    liberar_pokemon(poke);
}

/* Test 9: Los nuevos moves son copias independientes */
TEST(test_ej1_moves_are_copies) {
    pokemon_t* poke = crear_pokemon(10, "Caterpie", "Bicho", 3, 0);

    char move_buf[32];
    strcpy(move_buf, "Tackle");
    char* new_moves[] = {move_buf};
    TEST_CALL_V(actualizar_movimientos_pokemon, poke, new_moves, 1);

    /* Modificar el buffer original no debe afectar al move guardado */
    strcpy(move_buf, "CHANGED");
    TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Tackle") == 0);

    liberar_pokemon(poke);
}

/* Test 10: Multiples pokemons independientes, update solo modifica al seleccionado */
TEST(test_ej1_multiple_pokemons_update_independent) {
    pokemon_t* p1 = crear_pokemon(1, "Bulbasaur", "Planta", 5, 0);
    pokemon_t* p2 = crear_pokemon(4, "Charmander", "Fuego", 5, 0);
    pokemon_t* p3 = crear_pokemon(7, "Squirtle", "Agua", 5, 0);

    agregar_movimiento(p1, 0, "Tackle");

    char* new_moves[] = {"Flamethrower", "Fire Spin"};
    TEST_CALL_V(actualizar_movimientos_pokemon, p2, new_moves, 2);

    /* p2 (Charmander) should be updated */
    TEST_ASSERT(p2->movimientos[0] != NULL && strcmp(p2->movimientos[0], "Flamethrower") == 0);
    TEST_ASSERT(p2->movimientos[1] != NULL && strcmp(p2->movimientos[1], "Fire Spin") == 0);
    TEST_ASSERT(p2->movimientos[2] == NULL);
    TEST_ASSERT(p2->movimientos[3] == NULL);

    /* p1 (Bulbasaur) should NOT be changed */
    TEST_ASSERT(p1->movimientos[0] != NULL && strcmp(p1->movimientos[0], "Tackle") == 0);
    TEST_ASSERT(p1->movimientos[1] == NULL);

    /* p3 (Squirtle) should NOT be changed */
    TEST_ASSERT(p3->movimientos[0] == NULL);

    liberar_pokemon(p1);
    liberar_pokemon(p2);
    liberar_pokemon(p3);
}

/* Stress test 1: Varios pokemon independientes con distintas cantidades de movimientos */
TEST(test_ej1_stress_multiple_standalone_pokemon) {
    pokemon_t* p_charizard = crear_pokemon(6, "Charizard", "Fuego", 36, 5);
    pokemon_t* p_pikachu = crear_pokemon(25, "Pikachu", "Electrico", 20, 172);
    pokemon_t* p_mewtwo = crear_pokemon(150, "Mewtwo", "Psiquico", 70, 0);
    pokemon_t* p_mew = crear_pokemon(151, "Mew", "Psiquico", 50, 0);

    agregar_movimiento(p_mew, 0, "Confusion");

    /* Update Charizard: 4 moves */
    char* charizard_moves[] = {"Vuelo", "Lanzallamas", "Terremoto", "Danza Dragon"};
    TEST_CALL_V(actualizar_movimientos_pokemon, p_charizard, charizard_moves, 4);
    TEST_ASSERT(strcmp(p_charizard->movimientos[0], "Vuelo") == 0);
    TEST_ASSERT(strcmp(p_charizard->movimientos[1], "Lanzallamas") == 0);
    TEST_ASSERT(strcmp(p_charizard->movimientos[2], "Terremoto") == 0);
    TEST_ASSERT(strcmp(p_charizard->movimientos[3], "Danza Dragon") == 0);

    /* Update Pikachu: 2 moves */
    char* pika_moves[] = {"Rayo", "Ataque Rapido"};
    TEST_CALL_V(actualizar_movimientos_pokemon, p_pikachu, pika_moves, 2);
    TEST_ASSERT(strcmp(p_pikachu->movimientos[0], "Rayo") == 0);
    TEST_ASSERT(strcmp(p_pikachu->movimientos[1], "Ataque Rapido") == 0);
    TEST_ASSERT(p_pikachu->movimientos[2] == NULL);
    TEST_ASSERT(p_pikachu->movimientos[3] == NULL);

    /* Update Mewtwo: 6 moves (only first 4) */
    char* mewtwo_moves[] = {"Psiquico", "Bola Sombra", "Onda Certera", "Rayo Hielo", "Trueno", "Llamarada"};
    TEST_CALL_V(actualizar_movimientos_pokemon, p_mewtwo, mewtwo_moves, 6);
    TEST_ASSERT(strcmp(p_mewtwo->movimientos[0], "Psiquico") == 0);
    TEST_ASSERT(strcmp(p_mewtwo->movimientos[1], "Bola Sombra") == 0);
    TEST_ASSERT(strcmp(p_mewtwo->movimientos[2], "Onda Certera") == 0);
    TEST_ASSERT(strcmp(p_mewtwo->movimientos[3], "Rayo Hielo") == 0);

    /* Mew untouched */
    TEST_ASSERT(p_mew->movimientos[0] != NULL && strcmp(p_mew->movimientos[0], "Confusion") == 0);

    liberar_pokemon(p_charizard);
    liberar_pokemon(p_pikachu);
    liberar_pokemon(p_mewtwo);
    liberar_pokemon(p_mew);
}

/* Stress test 2: Multiples actualizaciones repetidas y liberaciones en bucle */
TEST(test_ej1_stress_repeated_rapid_updates) {
    pokemon_t* poke = crear_pokemon(1, "Bulbasaur", "Planta", 5, 0);

    char* set_a[] = {"Placaje", "Gruñido"};
    char* set_b[] = {"Drenadoras", "Latigo Cepa", "Polvo Veneno"};
    char* set_c[] = {"Rayo Solar", "Bomba Lodo", "Sintesis", "Gigadrenado"};
    char* set_d[] = {};

    for (int iter = 0; iter < 20; iter++) {
        TEST_CALL_V(actualizar_movimientos_pokemon, poke, set_a, 2);
        TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Placaje") == 0);
        TEST_ASSERT(poke->movimientos[1] != NULL && strcmp(poke->movimientos[1], "Gruñido") == 0);
        TEST_ASSERT(poke->movimientos[2] == NULL);

        TEST_CALL_V(actualizar_movimientos_pokemon, poke, set_b, 3);
        TEST_ASSERT(poke->movimientos[0] != NULL && strcmp(poke->movimientos[0], "Drenadoras") == 0);
        TEST_ASSERT(poke->movimientos[2] != NULL && strcmp(poke->movimientos[2], "Polvo Veneno") == 0);
        TEST_ASSERT(poke->movimientos[3] == NULL);

        TEST_CALL_V(actualizar_movimientos_pokemon, poke, set_c, 4);
        TEST_ASSERT(poke->movimientos[3] != NULL && strcmp(poke->movimientos[3], "Gigadrenado") == 0);

        TEST_CALL_V(actualizar_movimientos_pokemon, poke, set_d, 0);
        TEST_ASSERT(poke->movimientos[0] == NULL);
        TEST_ASSERT(poke->movimientos[1] == NULL);
        TEST_ASSERT(poke->movimientos[2] == NULL);
        TEST_ASSERT(poke->movimientos[3] == NULL);
    }

    liberar_pokemon(poke);
}

int main(int argc, char *argv[]) {
    (void)argc; (void)argv;
    printf("Corriendo los tests del ejercicio 1 ...\n");

    test_ej1_update_4_moves();
    test_ej1_update_fewer_than_4_moves();
    test_ej1_update_more_than_4_moves();
    test_ej1_free_old_moves_then_replace();
    test_ej1_null_pokemon();
    test_ej1_update_zero_moves();
    test_ej1_update_single_move();
    test_ej1_consecutive_updates();
    test_ej1_moves_are_copies();
    test_ej1_multiple_pokemons_update_independent();
    test_ej1_stress_multiple_standalone_pokemon();
    test_ej1_stress_repeated_rapid_updates();

    tests_end("Ejercicio 1");
    return 0;
}
