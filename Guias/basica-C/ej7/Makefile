CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = operaciones

all: $(TARGET)

$(TARGET): operaciones.o
	$(CC) $(CFLAGS) $^ -o $@

operaciones.o: operaciones.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean