/*
	cls.c - emty AmigaShell's console output

	Micha B. 05/2023

	gcc -O -s -o CLS cls.c
	strip --strip-unneeded CLS
*/

#include <stdio.h>

void main()
{
    puts("\f");
}
