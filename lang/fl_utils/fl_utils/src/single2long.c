/* 
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long l1 = 0;
float fl = 0;

int main (int argc, char **argv) {
   if (argc < 2) return 0;
   fl=atof(&argv[1][0]);
   memcpy(&l1, &fl, 4);
   printf("%ld\n",l1);
   return 0;
}
