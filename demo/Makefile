# Demo Makefile for C version

CC = gcc
CFLAGS = -Wall -O2

demo: demo.c
	$(CC) $(CFLAGS) -o demo demo.c

clean:
	rm -f demo

run: demo
	./demo

.PHONY: clean run
