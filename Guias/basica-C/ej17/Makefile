CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = estado

all: $(TARGET)

$(TARGET): estado.o
	$(CC) $(CFLAGS) $^ -o $@

estado.o: estado.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean