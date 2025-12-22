/*
 * Aztec C version 3.6 does not support system(), but here is a substitute.
 * This is a bonafide untested-original-it-just-compiles routine.
 * Manx will probably implement system() before we fix this version...
 */
#include <stdio.h>
#include <ctype.h>

#define KLUDGE1 256
#define KLUDGE2 64
int system(s)
char *s;
{
   char text[KLUDGE1], *cp=text;
   char **av[KLUDGE2];
   int ac = 0;
   int l  = strlen(s);

   if (l >= KLUDGE1)
      return -1;
   strcpy(text,s);
   av[ac++] = text;
   while(*cp && ac<KLUDGE2-1) {
      if (isspace(*cp)) {
         *cp++ = '\0';
	 while(isspace(*cp))
	    cp++;
         if (*cp)
	    av[ac++] = cp;
         }
      else {
         cp++;
         }
      }
    av[ac] = NULL;
    return fexecv(av[0], av);
}
