echo "Compiling..."

If EXISTS SYS:AROS.boot

echo "---------for Aros--------------------------------------------------------------"

gcc -Wall  -noixemul -O3 -c CoW3D6.c
gcc -Wall  -noixemul -O3 -o CoW3D6-aros CoW3D6.o 


Else
Version VERSION 46
If WARN
echo "---------for 68020-40--------------------------------------------------------------"


gcc  -Wall -m68020-40 -m68881 -noixemul -O3 -c CoW3D6.c
gcc  -Wall -m68020-40 -m68881 -noixemul -O3 -o CoW3D6-os3 CoW3D6.o

stack 100000
adis -c4 -c8  -a CoW3D6-os3

Else
echo "---------for ppc-------------------------------------------------------------------"


gcc   -noixemul -O3 -c CoW3D6.c
gcc   -noixemul -O3 -o CoW3D6-os4 CoW3D6.o 

EndIf

EndIf
delete #?.o > NIL:
echo "Compilation done"
wait 600




