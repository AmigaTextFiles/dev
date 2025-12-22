

echo "CompositePoc.c ..."
gcc -noixemul -c -O3 CompositePoc.c  
gcc -noixemul -o CompositePoc-ppc CompositePoc.o  
echo "CompositePoc-ppc done..."

wait 6000
