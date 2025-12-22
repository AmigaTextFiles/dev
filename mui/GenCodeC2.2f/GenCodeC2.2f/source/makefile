Objects = 	GenCodeC.o \
			GenCodeCGUI.o \
			GenCodeCMain.o \
			Hook_Utility.o \
			TextField.o \
			Tools.o \
			WriteCatalogFiles.o \
			WriteExternalFile.o \
			WriteGUIFiles.o \
			WriteMainFile.o

Program =	../Module/GenCodeC

$(Program): $(Objects)
	#gcc $(Objects) -o $(Program) -noixemul -L/apf/lib -lAPur-gcc
	gcc $(Objects) -o $(Program) -noixemul -lmui -L. -lMB
	cp Hook_Utility.o ../Module/Hook_Utility.o.gcc
	cp Hook_Utility.h ../Module/Hook_Utility.h

.c.o:
	#apf -v -sl gcc -c $*.c -o $*.o
	gcc -c $*.c -o $*.o
                    
clean:
	delete $(Objects)
