OBJ = FindRef.o Main.o MessageLoop.o ToolTypesToReadArgs.o

FetchRefs: $(OBJ)
    slink with FetchRefs.lnk

main.o: main.c FetchRefs.h
    sc NOSTKCHK gst=FetchRefs.gst OPTIMIZE CPU=68060 main.c

FindRef.o: FindRef.c FetchRefs.h
    sc NOSTKCHK gst=FetchRefs.gst OPTIMIZE CPU=68060 FindRef.c

MessageLoop.o: MessageLoop.c FetchRefs.h
    sc NOSTKCHK gst=FetchRefs.gst OPTIMIZE CPU=68060 MessageLoop.c

ToolTypesToReadArgs.o: ToolTypesToReadArgs.c FetchRefs.h
    sc NOSTKCHK gst=FetchRefs.gst OPTIMIZE CPU=68060 ToolTypesToReadArgs.c
