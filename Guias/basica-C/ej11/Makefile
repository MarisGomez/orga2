CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = array

all: $(TARGET)

$(TARGET): array.o
	$(CC) $(CFLAGS) $^ -o $@

array.o: array.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean