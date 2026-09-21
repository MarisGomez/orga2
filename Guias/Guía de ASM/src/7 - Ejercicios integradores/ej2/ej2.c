#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej2.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_2A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_2B_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_2C_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
void optimizar(mapa_t mapa, attackunit_t* compartida, uint32_t (*fun_hash)(attackunit_t*)) {

    for (uint16_t i = 0; i < 255; i++) {
        for (uint16_t j = 0; j < 255; j++) {

            attackunit_t* unidad = mapa[i][j];

            if (unidad == NULL || unidad == compartida)
                continue;
            if (fun_hash(unidad) == fun_hash(compartida)) {
                unidad->references --;
                if (unidad->references == 0)
                    free(unidad);
                mapa[i][j] = compartida;
                compartida->references ++;
            }
        }
    }
}

/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {

    uint16_t combustible_asignado = 0;

    for (uint16_t i = 0; i < 255; i++) {
        for (uint16_t j = 0; j < 255; j++) {

            attackunit_t* unidad = mapa[i][j];
            if (unidad == NULL)
                continue;
            if (unidad->combustible > fun_combustible(unidad)) {
                combustible_asignado += (unidad->combustible - fun_combustible(unidad));
            }
        }
    }
    return combustible_asignado;
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t*)) {

    attackunit_t* unidad = mapa[x][y];

    if (unidad != NULL) {
        if (unidad->references == 1){
            fun_modificar(unidad);
        } else {
            attackunit_t* nueva_unidad = malloc(sizeof(attackunit_t));
            *nueva_unidad = *unidad;
            nueva_unidad->references = 1;
            unidad->references --;
            mapa[x][y] = nueva_unidad;
            fun_modificar(nueva_unidad);
        }
    }
}
