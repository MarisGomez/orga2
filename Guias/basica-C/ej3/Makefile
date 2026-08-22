CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = sizeof

all: $(TARGET)

$(TARGET): sizeof.o
	$(CC) $(CFLAGS) $^ -o $@

sizeof.o: sizeof.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean