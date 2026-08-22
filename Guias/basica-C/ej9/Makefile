CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = mask

all: $(TARGET)

$(TARGET): mask.o
	$(CC) $(CFLAGS) $^ -o $@

mask.o: mask.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean