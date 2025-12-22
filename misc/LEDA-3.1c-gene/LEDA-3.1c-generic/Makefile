
lib: 
	cd src;  $(MAKE) -i FLAGS=-O

lib0: 
	cd src;  $(MAKE) -i FLAGS=

lib_g: 
	cd src;  $(MAKE) -i FLAGS=-g

lib_pg: 
	cd src;  $(MAKE) -i FLAGS=-pg

pro:
	cd prog; $(MAKE) -i FLAGS=-O

pro0:
	cd prog; $(MAKE) -i FLAGS=

pro_g:
	cd prog; $(MAKE) -i FLAGS=-g

pro_pg:
	cd prog; $(MAKE) -i FLAGS=-pg


all: lib pro

all0: lib0 pro0

all_g: lib_g pro_g

all_pg: lib_pg pro_pg


del: clean
	rm -f lib*.a      

clean:
	cd src;  $(MAKE) -i clean
	cd prog; $(MAKE) -i clean

touch:
	touch src/*/*.c
	touch prog/*/*.c

