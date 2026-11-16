# Primer parcial - Arquitectura y Organización del Computador
### Segundo cuatrimestre 2026

- [Primer parcial - Arquitectura y Organización del Computador](#primer-parcial---arquitectura-y-organización-del-computador)
    - [Segundo cuatrimestre 2026](#segundo-cuatrimestre-2026)
- [Normas generales y modalidad de entrega](#normas-generales-y-modalidad-de-entrega)
  - [Régimen de Aprobación](#régimen-de-aprobación)
  - [Conocimientos a evaluar](#conocimientos-a-evaluar)
  - [Compilación y Testeo](#compilación-y-testeo)
  - [Verificación de tests](#verificación-de-tests)
- [Enunciado](#enunciado)
  - [Estructuras Principales](#estructuras-principales)
  - [Ejercicio 1](#ejercicio-1)
  - [Ejercicio 2](#ejercicio-2)
  - [Ejercicio 3](#ejercicio-3)



# Normas generales y modalidad de entrega

- El parcial es **INDIVIDUAL**
- Una vez terminada la evaluación se deberán subir los archivos `.asm` de cada ejercicio al campus de la materia.

## Régimen de Aprobación

- El parcial es en los laboratorios, usando las compus de los labos o sus propias compus.
- Es a libro abierto, pueden tener todo lo que se les ocurra a disposición. Esta totalmente prohibido el uso del celular, internet y chatbots.
- El internet de los laboratorios está limitado a la página del campus de la materia. 
- Quienes rindan con su computadora personal deberán conectarse al internet del labo mediante cable ethernet.
- **Sólo se evalúa programación en Assembly**, **C no se corrije** pero recomendamos que primero planteen una solución en C y después pasarla a Assembly cuando tengan en claro cómo estructurar la solución.
- Para aprobar el parcial deben implementar 2 de los 3 puntos del enunciado y que corran con éxito los tests funcionales, de abi y de memoria (valgrind).
- Vamos a usar herramientas de detección de plagio para asegurarnos de que su entrega sea original.

> [!NOTE]
> El comando `./tester.sh` corre los mismos tests que nosotros al corregir. Pueden usarlo para revisar que su parcial vaya a pasar los tests en dicho entorno.

> [!NOTE]
> Durante el parcial estaremos disponibles para resolver consultas de enunciado y para destrabarles si están dando vueltas mucho tiempo en algo que no forma parte de lo evaluado. NO responderemos preguntas teóricas.


## Conocimientos a evaluar 
- Uso de memoria dinámica.
- Navegación de punteros.
- Representación binaria de los tipos de datos.
- Manejo de pila.
- Manejo de structs.
- Convención C, ABI, uso de registros.
- Uso del debugger GDB.

## Compilación y Testeo

Para compilar y ejecutar los tests cada ejercicio dispone de un archivo
`Makefile` para cada uno, con los siguientes *targets*:

| Comando             | Descripción                                                         |
| ------------------- | ------------------------------------------------------------------- |
| `make test_c`       | Genera el ejecutable usando la implementación en C del ejercicio.   |
| `make test_asm`     | Genera el ejecutable usando la implementación en ASM del ejercicio. |
| `make test_abi`     | Genera usando la implementación en ASM del ejercicio + archivos necesarios para ABI enforcer |
| `make run_c`        | Corre los tests usando la implementación en C.                      |
| `make run_asm`      | Corre los tests usando la implementación en ASM.                    |
| `make run_abi`      | Corre los tests usando la implementación en ASM + ABI enforcer.     |
| `make valgrind_c`   | Corre los tests en valgrind usando la implementación en C.          |
| `make valgrind_asm` | Corre los tests en valgrind usando la implementación en ASM.        |
| `make valgrind_abi` | Corre los tests en valgrind usando la implementación en ASM + ABI enforcer        |
| `make check_offsets` | Corre el chequeo de offsets                                         |
| `make run_main_c`        | Corre main usando la implementación en C.                      |
| `make run_main_asm`      | Corre main usando la implementación en ASM (no corre ABI enforcer).                    |
| `make clean`        | Borra todo archivo generado por el `Makefile`.                      |


> [!CAUTION]
> Para considerar un ejercicio aprobado, debe pasar los tests **con el comando** `make valgrind_abi`

# Enunciado
Durante décadas, los datos de la Pokédex de Kanto fueron almacenados en una supercomputadora central que hoy es una reliquia tecnológica. Para modernizar la infraestructura, el Profesor Oak ha iniciado la migración de los datos a los nuevos servidores de la Liga Pokémon. Los datos en crudo han sido transferidos con éxito, pero la lógica de acceso se ha perdido. Tu tarea es actuar como el puente técnico: debes programar las funciones de bajo nivel que interpreten este mapa de memoria antiguo y lo hagan funcional para las interfaces modernas de los entrenadores.

Para reconstruir el sistema, es fundamental entender los cuatro pilares que definen a cada Pokémon en la investigación:
1. Identidad

Cada ejemplar posee un número de registro único con numeración entera positiva de 16 bits (arranca desde 1), que funciona como su huella dactilar. A esto lo acompaña su nombre oficial (por ejemplo, 'Charmander'). En el sistema antiguo, los nombres tienen una reserva fija de 16 caracteres (incluyendo el terminador nulo), lo que limita la longitud de las denominaciones de las especies.

2. Tipo Elemental

Representa la esencia biológica del Pokémon. Esta clasificación (Fuego, Agua, etc.) se almacena como una cadena de texto con un espacio máximo de 12 caracteres(incluyendo el terminador nulo).

3. Set de Movimientos

Es el arsenal de técnicas de combate. El sistema está diseñado para gestionar un máximo de 4 movimientos por Pokémon simultáneamente. Estos ataques no se guardan como texto fijo dentro del registro principal, sino como punteros a cadenas de longitud variable ubicadas en otra sección de la memoria, permitiendo que el set sea dinámico y cambie durante el entrenamiento.


4. Evoluciones

Casi todos los Pokémon provienen de una especie previa. El sistema registra el ID del ancestro (un valor de 16 bits). Si este valor es 0, significa que estamos ante una forma base. Rastrear este linaje permite dibujar el mapa genético completo de una especie

La estructura `pokedex_t` actúa como el panel de control de toda la migración. Para interactuar con ella en bajo nivel, debemos entender cómo organiza sus componentes:

    matriz_pokemons pokemons: Es una matriz implementada como array de arrays de punteros a pokemon_t.

    uint8_t* bitmap: Es la memoria de los pokemons vistos o no vistos. En lugar de usar bytes enteros, cada bit representa a un Pokémon. Cada posición del bitmap corresponde al pokemón encontrado en la misma posición de la matriz.

    uint32_t filas y columnas: Define cuantas filas y columnas tiene la pokedex.

> **OJO**: El id de un pokemon **no** guarda relación con su posición en la matriz.

¿Cómo funciona el Bitmap?

El Bitmap es una cadena de bits compacta. Cada byte contiene 8 bits, indicando en cada bit con 1 si el pokemon fue visto y 0 sino. Por ejemplo, en una pokédex de 3 filas y 8 columnas, para saber si localizamos al pokemon en la posición [2][1] (tercer fila, segunda columna) de la matriz, entonces debemos buscar en el tercer byte del bitmap, en el segundo bit menos significativo.

## Estructuras Principales:

```C
typedef struct __attribute__((packed)) {
    char nombre[16];
    char tipo[12];
    uint16_t nivel;         
} info_t;
```

```C
typedef struct {
    uint16_t id;            
    char* movimientos[4];         
    info_t info;            
    char* descripcion;
    uint16_t evoluciona_de_id;
} pokemon_t;
```

```C
typedef pokemon_t*** matriz_pokemons;
```

```C
typedef struct {
    matriz_pokemons pokemons;   
    uint8_t* bitmap;  
    uint32_t filas;  
    uint32_t columnas;
} pokedex_t;
```

## Ejercicio 1

El sistema de combate ha quedado desfasado y los entrenadores reportan errores al aprender nuevas técnicas. Implementar:

```C
void actualizar_movimientos_pokemon(pokemon_t* pokemon, char** nuevos_movimientos, int cantidad);
```

La función debe actualizar el registro de movimientos del Pokémon pasado por parámetro. Considerar que:
- `cantidad` indica la cantidad de elementos (movimientos) que contiene `nuevos_movimientos`.
- Si `pokemon` es NULL, la función no debe hacer nada y retornar.
- Si el pokemon tuviera ya movimientos, se debe liberar la memoria de sus strings. 
- Se debe realizar una **copia** de hasta los primeros 4 elementos de los movimientos nuevos. 
    - Si los movimientos nuevos son menos de 4, los punteros restantes en el arreglo del Pokémon deben quedar en NULL. 
    - Si se tienen mas de 4 movimientos, hay que quedarse con los primeros 4.



## Ejercicio 2

Para organizar las expediciones de búsqueda, Oak necesita saber qué Pokémones de un tipo específico ya han sido registrados como "vistos". Implementar la siguiente funcion:

```C
pokemon_filtrados_t* obtener_avistados_por_tipo(pokedex_t* pokedex, char* tipo_objetivo);
```

La función debe recorrer los registros de la Pokedex y filtrar aquellos especímenes que cumplan dos condiciones:

- El pokemon debe haber sido avistado, es decir que en la posicion correspondiente del `bitmap`, aparezca el bit prendido en uno
- Su `tipo` tiene que coincidir con el argumento `tipo_objetivo` pasado por parametros

Debe devolver un puntero a una estructura `pokemon_filtrados_t` que tiene la siguiente forma:

```C
typedef struct {
    uint16_t* ids_pokemons;
    uint16_t cantidad_pokemons;
} pokemon_filtrados_t;
```

que contiene un arreglo `uint16_t* ids_pokemons` con los IDs hallados y un `uint16_t cantidad_pokemons` con la cantidad total de coincidencias

> [!NOTE]
> - Se debe retornar un `pokemon_filtrados_t` aunque no se haya avistado ningún pokemon del tipo `tipo_objetivo`
> - No es necesario que el tamaño de ids_pokemon sea exacto. Con un array de tamaño 20 debería bastar.
> - Se encuentra disponible la función auxiliar `uint8_t obtener_bit(const uint8_t* bitmap, uint32_t posicion)` para consultar el estado de un bit en el bitmap. Donde `posicion` es el índice lineal de la posición en la matriz. 
> - Se puede asumir que el bitmap no tendrá seteado un bit en  una posición para la que no haya un pokemon definido en la matriz.
> - Se puede asumir que los punteros recibidos por parámetro son válidos (no son NULL).

## Ejercicio 3

La base de datos ha perdido las jerarquías de evolución. Oak necesita reconstruir el árbol genealógico de especies específicas para entender su crecimiento. Implementar:

```C
nodo_evolucion_t* rastrear_linea_evolutiva(pokedex_t* pokedex, uint16_t id_final);
```


Dado el ID de un Pokémon final (`id_final`), se debe navegar por la Pokedex "hacia atrás" utilizando el campo `evoluciona_de_id` hasta alcanzar la forma base (donde el ID de origen sea 0).

La función debe devolver un puntero al primer nodo (la forma inicial) de una lista enlazada que culmine en el Pokémon solicitado. Cada `nodo_evolucion_t` de la lista debe contener únicamente el `id` y el puntero `evoluciona_en` al siguiente eslabón.

```C
typedef struct nodo_evolucion {
    uint16_t id;
    struct nodo_evolucion* evoluciona_en;      
} nodo_evolucion_t;
```

> Nota: Los ids de las evoluciones **NO** necesariamente son consecutivos.

Por ejemplo:

Entrada: `id_final` = 26

    Rastreo: Raichu (26) ← Pikachu (25) ← Pichu (172) ← Base (0).

    Lista generada: [ID 172] → [ID 25] → [ID 26] → NULL.

> [!NOTE]
> - Se puede asumir que el Pokémon pedido y sus ancestros existen en la Pokédex.
> - Sugerimos implementar la función auxiliar `pokemon_t* buscar_pokemon_por_id(pokedex_t* pokedex, uint16_t pokemon_id)`