Objects = 	WriteCatalogGUI.o \
			WriteCatalogMain.o

Program =	../../Module/WriteCatalog/WriteCatalog

$(Program): $(Objects)
	#gcc $(Objects) ../WriteCatalogFiles.o ../Tools.o ../TextField.o \
	#-o $(Program) -noixemul -L/apf/lib -lAPur-gcc
	gcc $(Objects) ../WriteCatalogFiles.o ../Tools.o ../TextField.o \
	-o $(Program) -noixemul -lmui -L.. -lMB

.c.o:
	#apf -v -sl gcc -c $*.c -o $*.o -I ..
	gcc -c $*.c -o $*.o -I ..

clean:
	delete $(Objects)
