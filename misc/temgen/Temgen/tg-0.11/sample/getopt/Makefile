TG=../../tg

all: options

options: options.c

options.c: opdef.tg options.tg
	$(TG) options.tg > options.c
	
clean:
	rm -f *.o *.c options
