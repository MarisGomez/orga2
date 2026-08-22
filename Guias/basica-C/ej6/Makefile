CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = casting

all: $(TARGET)

$(TARGET): casting.o
	$(CC) $(CFLAGS) $^ -o $@

casting.o: casting.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean