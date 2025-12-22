echo "Compiling..."

If EXISTS SYS:AROS.boot

echo "---------for Aros--------------------------------------------------------------"

gcc -Wall  -noixemul -O1 -c ObjDumpFuncs.c
gcc -Wall  -noixemul -O1 -o ObjDumpFuncs ObjDumpFuncs.o 


Else
Version VERSION 46
If WARN
echo "---------for 68020-40--------------------------------------------------------------"


gcc  -Wall -m68020-40 -m68881 -noixemul -O1 -c ObjDumpFuncs.c
gcc  -Wall -m68020-40 -m68881 -noixemul -O1 -o ObjDumpFuncs ObjDumpFuncs.o

Else
echo "---------for ppc-------------------------------------------------------------------"


gcc   -noixemul -O1 -c ObjDumpFuncs.c
gcc   -noixemul -O1 -o ObjDumpFuncs-ppc ObjDumpFuncs.o

EndIf

EndIf
delete #?.o > NIL:
echo "Compilation done"
wait 600




