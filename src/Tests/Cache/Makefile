all: L1Cache

L1Cache: L1Cache.c
	gcc -O2 -o L1Cache -Wall -Wpedantic $< -lpapi -o $@
clean:
	rm -rf L1Cache
