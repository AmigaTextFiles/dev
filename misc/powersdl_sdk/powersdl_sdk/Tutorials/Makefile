all: tutorial_01 tutorial_02

tutorial_01: tutorial_01.c
		gcc -noixemul -O2 `sdl-config --cflags` tutorial_01.c -o tutorial_01 `sdl-config --libs` -I/usr/local/include

tutorial_02: tutorial_02.c
		gcc -noixemul -O2 `sdl-config --cflags` tutorial_02.c -o tutorial_02 `sdl-config --libs` -I/usr/local/include

clean:
	-rm tutorial_01
	-rm tutorial_02
