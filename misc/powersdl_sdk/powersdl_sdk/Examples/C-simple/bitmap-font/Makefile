bitmap-font:
	gcc -O2 `sdl-config --cflags` font.cpp lesson4.cpp `sdl-config --libs` -o bitmap-font -I/usr/local/include
	strip bitmap-font

clean:
	-rm *.o
	-rm bitmap-font
