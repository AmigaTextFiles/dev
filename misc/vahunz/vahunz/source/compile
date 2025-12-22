#!/bin/sh
#===========================================================================
# Compile script for Vahunz
#
# To compile under some Unix-System, simply invoke this script.
#
# Maybe you have to replace `gcc' by `cc' or whatever compiler you are
# using.
#===========================================================================
echo "Compiling"
echo "  ugly/expstr.o"
gcc -I ugly -I ubiqx -I vahunz -I. -c ugly/expstr.c       -o ugly/expstr.o
echo "  ugly/umemory.o"
gcc -I ugly -I ubiqx -I vahunz -I. -c ugly/umemory.c      -o ugly/umemory.o
echo "  ugly/ustring.o"
gcc -I ugly -I ubiqx -I vahunz -I. -c ugly/ustring.c      -o ugly/ustring.o
echo "  ubiqx/ubi_AVLTree.o"
gcc -I ugly -I ubiqx -I vahunz -I. -c ubiqx/ubi_AVLtree.c -o ubiqx/ubi_AVLtree.o
echo "  ubiqx/ubi_BinTree.o"
gcc -I ugly -I ubiqx -I vahunz -I. -c ubiqx/ubi_BinTree.c -o ubiqx/ubi_BinTree.o
echo "  vahunz/vahunz.o"
gcc -I ugly -I ubiqx -I vahunz -I. -c vahunz/vahunz.c     -o vahunz/vahunz.o
echo "Linking vahunz/vahunz"
gcc -o vahunz/vahunz ugly/expstr.o ugly/umemory.o ugly/ustring.o vahunz/vahunz.o ubiqx/ubi_AVLtree.o ubiqx/ubi_BinTree.o
echo ""
echo "Finished. The executable is in vahunz/vahunz."







