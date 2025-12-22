/* ------------------------------------------------------------------
    TREEFIND.C -- binary search for A6 assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <stdlib.h>
#include <string.h>

/* TREEFIND -- fastest find in char** I can do */
long treefind(char **array,char *findme, long size)
{
	long i,s,lower=0,upper=size-1;

	while(1) {
		if(upper<lower) return(-1);

		i=(lower+upper)/2;

		s=strcmp(array[i],findme);

		if(s==0) return(i);

		if(s>0) {
			upper=i-1;
		} else {
			lower=i+1;
		}
	}
}
