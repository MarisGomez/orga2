CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = puntero

all: $(TARGET)

$(TARGET): puntero.o
	$(CC) $(CFLAGS) $^ -o $@

puntero.o: puntero.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean