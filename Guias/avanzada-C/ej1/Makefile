CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = monstruo

all: $(TARGET)

$(TARGET): monstruo.o
	$(CC) $(CFLAGS) $^ -o $@

monstruo.o: monstruo.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean