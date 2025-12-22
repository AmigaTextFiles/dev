all: openclit.lib
OBJS=litatom.obj litdrm.obj litlib.obj litembiggen.obj littags.obj litmetatags.obj litmanifest.obj litdirectory.obj litsections.obj litheaders.obj litutil.obj sha\mssha1.obj des\des.obj newlzx\lzxglue.obj newlzx\lzxd.obj
CFLAGS=/D_DLL /Fo$*.obj /c /W3 /Ogsi1 /O1 /G6yAFs /DWIN32_LEAN_AND_MEAN -Ides -Isha -Inewlzx -I.
clean:  
    -del $(OBJS) openclit.lib

openclit.lib: $(OBJS)
    -del openclit.lib
    lib /OUT:openclit.lib $**

