all: bmp_go

libbmp.o:	bmp.cpp bmp.h
					gcc -c bmp.cpp -o libbmp.o
libbmp.a:	libbmp.o
					ar rcs libbmp.a libbmp.o
					rm -f libbmp.o
bmp_go:		bmp_go.cpp libbmp.a
					g++ -static bmp_go.cpp -L. -lbmp -o bmp_go

clean: 
	rm -f *.o
	rm -f *.a
	rm -f bmp_go