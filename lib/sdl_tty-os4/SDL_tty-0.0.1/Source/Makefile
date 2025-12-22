all : c64lookalike fontdump

c64lookalike : c64lookalike.c SDL_tty.c
	$(CC) -o $@ $< SDL_tty.c -Wall -O2 `sdl-config --cflags --libs` -mcrt=newlib -lSDL_image -ltiff -lpng -ljpeg -lz -lSDL_ttf -lfreetype -lz -lsdlmain -lsdl -lauto -lpthread -lm -lunix

fontdump: fontdump.c
	$(CC) -o $@ $< -Wall -O2 `sdl-config --cflags --libs` -mcrt=newlib -lSDL_image -ltiff -lpng -ljpeg -lz -lSDL_ttf -lfreetype -lz -lsdlmain -lsdl -lauto -lpthread -lm

# EOF #
