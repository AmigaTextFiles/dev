ifeq ($(shell uname), AmigaOS)
TOPDIR 	= `CD`/
else
TOPDIR 	= `pwd`/
endif

all: lib tools

lib:
	make -C src TOPDIR=$(TOPDIR)
		
tools: lib
	make -C tools TOPDIR=$(TOPDIR)
	
example: lib tools
	make -C example TOPDIR=$(TOPDIR)

clean:
	make -C src clean TOPDIR=$(TOPDIR)
	make -C tools clean TOPDIR=$(TOPDIR)
	make -C example clean TOPDIR=$(TOPDIR)
	
install:
	make -C src install TOPDIR=$(TOPDIR)
	make -C tools install TOPDIR=$(TOPDIR)
	make -C example install TOPDIR=$(TOPDIR)
	