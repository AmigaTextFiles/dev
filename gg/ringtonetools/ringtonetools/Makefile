
#FLAGS = -DDEBUG
FLAGS=-Xlinker -s
CC=gcc

default:
	$(CC) -o rtttl2nokia rtttl2nokia.c -Wall $(FLAGS)
	$(CC) -o ems2nokia ems2nokia.c -Wall $(FLAGS)

clean:
	@if [ -e rtttl2nokia ]; then rm rtttl2nokia; fi;
	@if [ -e ems2nokia ]; then rm ems2nokia; fi;
	@echo "Clean!"

install:
	install ems2nokia /usr/local/bin

uninstall:
	rm /usr/local/bin/rtttl2nokia
	rm /usr/local/bin/ems2nokia


