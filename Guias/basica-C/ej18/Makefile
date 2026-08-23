CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = static

all: $(TARGET)

$(TARGET): static.o
	$(CC) $(CFLAGS) $^ -o $@

static.o: static.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean