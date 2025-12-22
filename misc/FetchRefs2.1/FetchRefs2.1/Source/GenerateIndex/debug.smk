OBJ = GenerateIndex.o GUI.o lists.o

AmiCAD:  $(OBJ)
    slink WITH debug.lnk

GenerateIndex.o: GenerateIndex.c GenerateIndex.h
    sc NOSTKCHK DEBUG=FULL GST=GenerateIndex.gst GenerateIndex.c

GUI.o: GUI.c GenerateIndex.h
    sc NOSTKCHK DEBUG=FULL GST=GenerateIndex.gst GUI.c

lists.o: lists.c GenerateIndex.h
    sc NOSTKCHK DEBUG=FULL GST=GenerateIndex.gst lists.c
