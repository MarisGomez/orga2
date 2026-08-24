CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = string

all: $(TARGET)

$(TARGET): string.o
	$(CC) $(CFLAGS) $^ -o $@
string.o: string.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean