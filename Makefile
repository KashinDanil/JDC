PROGS = hpas

all : $(PROGS)

hpas:
	cd src/HPAS-master
	./configure
	make
	make install
	cd ../..

clean:
	rm -f $(PROGS)
