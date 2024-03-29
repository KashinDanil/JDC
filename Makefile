all: HPAS OSU Cache GPU MPI

HPAS:
	chmod -R 777 src/HPAS; cd src/HPAS; ./autogen.sh; ./configure --prefix=$PWD; make; make install; cd ../..;

OSU:
	chmod -R 777 src/osu-micro-benchmarks; cd src/osu-micro-benchmarks; ./configure CC=oshcc CXX=oshcxx; make; cd ../..;

Cache:
	chmod -R 777 src/Tests/Cache; cd src/Tests/Cache; make; cd ../../..;

GPU:
	chmod -R 777 src/Tests/GPU; cd src/Tests/GPU; make; cd ../../..;

MPI:
	chmod -R 777 src/Tests/MPI; cd src/Tests/MPI; make; cd ../../..;