CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = arrayn

all: $(TARGET)

$(TARGET): arrayn.o
	$(CC) $(CFLAGS) $^ -o $@

arrayn.o: arrayn.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean