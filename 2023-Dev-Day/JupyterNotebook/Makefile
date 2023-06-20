MPI_CXX=/usr/bin/mpicxx
CXXFLAGS=-std=c++11

ifeq ($(PREFIX),)
	PREFIX := /usr
endif

all: shuffle

shuffle: shuffle.cpp worker.cpp worker.hpp read_all.c read_all.h utils.c utils.h
	$(MPI_CXX) $(CXXFLAGS) $^ -o $@

install: shuffle
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 744 shuffle $(DESTDIR)$(PREFIX)/bin/

.PHONY: install

clean:
	rm -f *.o shuffle
