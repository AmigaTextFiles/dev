TARGETS = bin/bmp2chr bin/bmp2level bin/bmp2palette bin/bmp2sprite bin/bmp2table bin/bmpmerge bin/chr2bmp bin/sprites2chrsprite 

all: $(TARGETS)

clean:
	rm bin/* obj/*

bin/bmp2chr: obj/BMPImage.o obj/bmp2chr.o
	g++ obj/BMPImage.o obj/bmp2chr.o -o bin/bmp2chr

bin/bmp2level: obj/BMPImage.o obj/bmp2level.o
	g++ obj/BMPImage.o obj/bmp2level.o -o bin/bmp2level

bin/bmp2palette: obj/BMPImage.o obj/bmp2palette.o
	g++ obj/BMPImage.o obj/bmp2palette.o -o bin/bmp2palette

bin/bmp2sprite: obj/BMPImage.o obj/bmp2sprite.o
	g++ obj/BMPImage.o obj/bmp2sprite.o -o bin/bmp2sprite

bin/bmp2table: obj/BMPImage.o obj/bmp2table.o
	g++ obj/BMPImage.o obj/bmp2table.o -o bin/bmp2table

bin/bmpmerge: obj/BMPImage.o obj/bmpmerge.o
	g++ obj/BMPImage.o obj/bmpmerge.o -o bin/bmpmerge

bin/chr2bmp: obj/BMPImage.o obj/chr2bmp.o
	g++ obj/BMPImage.o obj/chr2bmp.o -o bin/chr2bmp

bin/sprites2chrsprite: obj/BMPImage.o obj/sprites2chrsprite.o
	g++ obj/BMPImage.o obj/sprites2chrsprite.o -o bin/sprites2chrsprite


obj/BMPImage.o: BMPImage.cpp BMPImage.h
	g++ -c BMPImage.cpp -o obj/BMPImage.o

obj/bmp2chr.o: bmp2chr.cpp
	g++ -c bmp2chr.cpp -o obj/bmp2chr.o

obj/bmp2palette.o: bmp2palette.cpp
	g++ -c bmp2palette.cpp -o obj/bmp2palette.o

obj/bmp2sprite.o: bmp2sprite.cpp
	g++ -c bmp2sprite.cpp -o obj/bmp2sprite.o

obj/bmp2table.o: bmp2table.cpp
	g++ -c bmp2table.cpp -o obj/bmp2table.o

obj/bmpmerge.o: bmpmerge.cpp
	g++ -c bmpmerge.cpp -o obj/bmpmerge.o

obj/chr2bmp.o: chr2bmp.cpp
	g++ -c chr2bmp.cpp -o obj/chr2bmp.o

obj/sprites2chrsprite.o: sprites2chrsprite.cpp
	g++ -c sprites2chrsprite.cpp -o obj/sprites2chrsprite.o

obj/bmp2level.o: bmp2level.cpp
	g++ -c bmp2level.cpp -o obj/bmp2level.o
