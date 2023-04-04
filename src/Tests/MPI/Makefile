all: mpipacks

mpipacks: mpipacks.c
	mpicc -O2 -o mpipacks $< -o $@

clean:
	rm -rf mpipacks
#mpiexec -n 2 ./mpipacks 600