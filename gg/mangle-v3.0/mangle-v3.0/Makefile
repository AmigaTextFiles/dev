VERSION = 3.0
NAME = mangle
BETA = no

DIR = $(NAME)-v$(VERSION)

DEFINES = -DVERSION=\"$(VERSION)\" -DNAME=\"$(NAME)\" -DBETA
DISTROFILES = Makefile README CHANGES main.cpp main.h io.cpp io.h dformat.cpp dformat.h func.cpp func.h mangle.1
OPTIONS = -O2

#DEBUG = -g -DDEBUG -DIODEBUG

all:
	c++ $(DEBUG) $(OPTIONS) $(DEFINES) -c io.cpp
	c++ $(DEBUG) $(OPTIONS) $(DEFINES) -c dformat.cpp
	c++ $(DEBUG) $(OPTIONS) $(DEFINES) -c func.cpp
	c++ $(DEBUG) $(OPTIONS) $(DEFINES) -c main.cpp
	c++ -o $(NAME) main.o io.o dformat.o func.o -Xlinker -s

install:
	@echo -n "Installing binary: "
	@cp mangle /usr/local/bin
	@chmod 755 /usr/local/bin/mangle
	@echo -e "Done.\n"
	@echo "Installing man page"
	@cp mangle.1 /usr/man/man1
	@echo
	@mangle

distro:
	rm -rf $(DIR)*.tar.gz $(NAME) $(DIR)
	@if [ "$(BETA)" = "yes" ]; then \
		mkdir $(DIR)b; \
		cp $(DISTROFILES) $(DIR)b; \
		tar -cvzf $(DIR)b.tar.gz $(DIR)b; \
		rm -rf $(DIR)b; \
	else \
		mkdir $(DIR); \
		cp $(DISTROFILES) $(DIR); \
		tar -cvzf $(DIR).tar.gz $(DIR); \
		rm -rf $(DIR); \
	fi
