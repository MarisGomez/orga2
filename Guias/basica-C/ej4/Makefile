CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = anchofijo

all: $(TARGET)

$(TARGET): anchofijo.o
	$(CC) $(CFLAGS) $^ -o $@

anchofijo.o: anchofijo.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean