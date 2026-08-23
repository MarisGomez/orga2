CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = dados

all: $(TARGET)

$(TARGET): dados.o
	$(CC) $(CFLAGS) $^ -o $@

dados.o: dados.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean