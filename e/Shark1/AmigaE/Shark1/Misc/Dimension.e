
DEF ptr:PTR TO LONG

PROC main()
ptr:=AllocMem(1024,0)
ptr[1]:='hello '
ptr[2]:='world!'

WriteF('\s\s',ptr[1],ptr[2])
FreeMem(ptr,1024)
ENDPROC
