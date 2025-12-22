wav-player: loopwave.c
	gcc -O2 `sdl-config --cflags` loopwave.c `sdl-config --libs` -o wav-player -I/usr/local/include
	strip wav-player

clean:
	rm wav-player
