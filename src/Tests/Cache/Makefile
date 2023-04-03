all: L1Cache LLCCache

L1Cache: L1Cache.c
	gcc -O2 -o L1Cache $< -o $@

LLCCache: LLCCache.c
	gcc -O2 -o LLCCache $< -o $@

clean:
	rm -rf L1Cache LLCCache
