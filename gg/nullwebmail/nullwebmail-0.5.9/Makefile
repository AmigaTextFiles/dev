# MAKEFILE FOR NULL WEBMAIL
CC=gcc
#CC=/usr/uClibc/bin/gcc
CFLAGS = -Wall -O2 -s
LDFLAGS = -s

all: webmail.cgi

webmail.cgi: main.o cgi-lib.o webmail.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o webmail.cgi main.o cgi-lib.o webmail.o
	@echo
	@echo "Copy webmail.cgi to your web server's cgi-bin directory,"
	@echo "ie. 'cp -a webmail.cgi /var/www/cgi-bin'."
	@echo "Copy webmail/ to your web server's htdocs directory,"
	@echo "ie. 'cp -a webmail /var/www/htdocs'."
	@echo

clean:
	rm -f webmail.cgi *.o *~

install:
	@echo
	@echo "There is no install.  Copy webmail.cgi to your web server's cgi-bin directory,"
	@echo "ie. 'cp -a webmail.cgi /var/www/cgi-bin'."
	@echo "Copy webmail/ to your web server's htdocs directory,"
	@echo "ie. 'cp -a webmail /var/www/htdocs'."
	@echo
