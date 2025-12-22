OBJ = FindRef.o Main.o MessageLoop.o ToolTypesToReadArgs.o

FetchRefs: $(OBJ)
    slink with debug.lnk

main.o: main.c FetchRefs.h
    sc NOSTKCHK DEBUG FULL gst=FetchRefs.gst main.c

FindRef.o: FindRef.c FetchRefs.h
    sc NOSTKCHK DEBUG FULL gst=FetchRefs.gst FindRef.c

MessageLoop.o: MessageLoop.c FetchRefs.h
    sc NOSTKCHK DEBUG FULL gst=FetchRefs.gst MessageLoop.c

ToolTypesToReadArgs.o: ToolTypesToReadArgs.c FetchRefs.h
    sc NOSTKCHK DEBUG FULL gst=FetchRefs.gst ToolTypesToReadArgs.c
