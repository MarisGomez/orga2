#include<stdio.h> // stdio.h: funciones de entrada/salida (printf, puts).
#include<string.h> // string.h: funciones de manejo de cadenas (strlen, strncpy).
#include<stdlib.h> // stdlib.h: funciones como malloc, free, exit

//                               rdi          rci        rdx     => Registros que contienen los punteros
extern char * strncpy_asm64 (char * dest, char * src, size_t n); // Se declara una función externa (probablemente implementada en ensamblador) que copia cadenas similar a strncpy. strncpy_asm64 recibe tres parámetros: un puntero destino, un puntero origen y un tamaño (size_t n). strncpy_asm64 devuelve un puntero a char.

int main (int argc, char * argv[]){ // argc: número de argumentos pasados por línea de comandos (incluye el nombre del programa). argv: arreglo de cadenas con los argumentos.

    char * destino1, * destino2; // Punteros a strings destino (donde se copiara la cadena origen)
    int strmembytes; // Cantidad de memoria que ocupara la string (en bytes)
    if (argc != 2) // VERIFICA QUE HAYA UN ARGUMENTO (argc debe ser = 2 ya que solo requerimos el programa y el texto a copiar)
    {
        fprintf (stderr, "Argumentos insuficientes. Invocar: %s [cadena de texto]\n\n", argv[0]);
        exit(1); // Si no se pasa exactamente un argumento, se muestra un mensaje de error en stderr y se termina el programa.
    }
    printf ("Cadena origen: %s\n", argv[1]); // Se imprime la cadena que el usuario pasó como argumento.
    printf ("----------------------------\n\n");
    // CALCULA EL ESPACIO NECESARIO PARA COPIARLO
    strmembytes = strlen (argv[1]) + 1; //Calculamos la cantidad de bytes que usa la string origen. (Se hace +1 a la longitud de la cadena pq strlen no incluye \0)
    // RESERVA MEMORIA DINAMICA
    destino1 = malloc (strmembytes * sizeof(char)); // Reservamos la memoria que utilizara la string destino.
    destino2 = malloc (strmembytes * sizeof(char)); // Reservamos la memoria que utilizara la string destino.
    // COPIA LA CADENA CON DOS FUNCIONES DISTINTAS Y MUESTRA LOS RESULTADOS
    puts  ("copiando texto con strncpy");
    strncpy (destino1,argv[1],strmembytes); // Se copia la cadena origen en destino1.
    printf ("Cadena destino => \"%s\"\n\n", destino1); // Se imprime el resultado.
    printf ("----------------------------\n\n");

    puts  ("copiando texto con strncpy_asm64");
    strncpy_asm64 (destino2,argv[1],strmembytes);
    printf ("Cadena destino => \"%s\"\n\n", destino2);
    printf ("----------------------------\n\n");
    // LIBERA MEMORIA Y FINALIZA
    free(destino1); // Se libera la memoria reservada
    free(destino2);
    exit(0); // Se termina el programa
}

//Resumen: el programa compara la copia de cadenas usando la función estándar strncpy y una versión personalizada en ensamblador (strncpy_asm64)