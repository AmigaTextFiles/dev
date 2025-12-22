CXX = g++ -m68020 -m68881 # -noixemul

CFLAGS = -Werror -Wall -Wno-unused

all: allegro openglallegro openglsdl sdl

allegro:
	$(CXX) allegrohelloworld.cpp -o allegrohelloworld $(CFLAGS) \
	-lguichan_allegro -lguichan `allegro-config --libs --cflags`
	$(CXX) allegrowidgets.cpp -o allegrowidgets  $(CFLAGS) \
	-lguichan_allegro -lguichan `allegro-config --libs --cflags`
	$(CXX) allegroaction.cpp -o allegroaction $(CFLAGS) \
	-lguichan_allegro -lguichan `allegro-config --libs --cflags`

openglallegro:
	$(CXX) openglallegrohelloworld.cpp -o openglallegrohelloworld  $(CFLAGS) \
	-lguichan_opengl -lguichan_allegro -lguichan -lGL -lGLU -lagl `allegro-config --libs --cflags`
	$(CXX) openglallegrowidgets.cpp -o openglallegrowidgets  $(CFLAGS) \
	-lguichan_opengl -lguichan_allegro -lguichan -lGL -lGLU -lagl `allegro-config --libs --cflags`
	$(CXX) openglallegrowidgets.cpp -o openglallegroaction  $(CFLAGS) \
	-lguichan_opengl -lguichan_allegro -lguichan -lGL -lGLU -lagl `allegro-config --libs --cflags`

openglsdl:
	$(CXX) openglsdlhelloworld.cpp -o openglsdlhelloworld $(CFLAGS) \
	-lguichan_sdl -lguichan_opengl -lguichan -lSDL_image -ljpeg -lpng -lz `sdl-config6 --libs --cflags` -lm
	$(CXX) openglsdlwidgets.cpp -o openglsdlwidgets $(CFLAGS) \
	-lguichan_sdl -lguichan_opengl -lguichan -lSDL_image -ljpeg -lpng -lz `sdl-config6 --libs --cflags` -lm
	$(CXX) openglsdlaction.cpp -o openglsdlaction $(CFLAGS) \
	-lguichan_sdl -lguichan_opengl -lguichan -lSDL_image -ljpeg -lpng -lz `sdl-config6 --libs --cflags` -lm

sdl:
	$(CXX) sdlhelloworld.cpp -o sdlhelloworld $(CFLAGS) \
	-lguichan_sdl -lguichan -lSDL_image -ljpeg -lpng -lz `sdl-config2 --libs --cflags` -lm
	$(CXX) sdlwidgets.cpp -o sdlwidgets $(CFLAGS) \
	-lguichan_sdl -lguichan -lSDL_image -ljpeg -lpng -lz `sdl-config2 --libs --cflags` -lm
	$(CXX) sdlaction.cpp -o sdlaction $(CFLAGS) \
	-lguichan_sdl -lguichan -lSDL_image -ljpeg -lpng -lz `sdl-config2 --libs --cflags` -lm

clean:
	rm -f allegroaction allegrohelloworld allegrowidgets
	rm -f openglallegroaction openglallegrohelloworld openglallegrowidgets
	rm -f openglsdlaction openglsdlhelloworld openglsdlwidgets
	rm -f sdlaction sdlhelloworld sdlwidgets