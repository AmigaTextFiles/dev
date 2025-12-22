SHELL = /bin/sh

FLAGS = -O

all: 
	cd basic;     $(MAKE) -i CFLAGS=$(FLAGS)
	cd arith;     if [ `arch` = sun4 ];\
                      then $(MAKE) -i CFLAGS=$(FLAGS) sparc;\
                      else $(MAKE) -i CFLAGS=$(FLAGS); fi
	cd dict;      $(MAKE) -i CFLAGS=$(FLAGS)
	cd prio;      $(MAKE) -i CFLAGS=$(FLAGS)
	cd graph;     $(MAKE) -i CFLAGS=$(FLAGS)
	cd graph_alg; $(MAKE) -i CFLAGS=$(FLAGS)
	cd plane;     $(MAKE) -i CFLAGS=$(FLAGS)
	cd window;    $(MAKE) -i CFLAGS=$(FLAGS)
	cd x11;       $(MAKE) -i CFLAGS=$(FLAGS)

clean: 
	cd basic;     $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd arith;     $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd dict;      $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd prio;      $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd graph;     $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd graph_alg; $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd plane;     $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd window;    $(MAKE) -i CFLAGS=$(FLAGS) clean
	cd x11;       $(MAKE) -i CFLAGS=$(FLAGS) clean
