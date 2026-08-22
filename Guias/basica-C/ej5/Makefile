CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = puntoflotante

all: $(TARGET)

$(TARGET): puntoflotante.o
	$(CC) $(CFLAGS) $^ -o $@

puntoflotante.o: puntoflotante.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean