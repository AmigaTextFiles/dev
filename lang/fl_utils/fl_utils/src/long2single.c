/* 
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long l1 = 0;
long l2 = 10;
float fl = 0;
char *patA = "%.";
char patB[256];
char *patC = "f\n";

int main (int argc, char **argv) {
   if (argc < 2) return 0;
   l1=strtol(&argv[1][0], NULL, 0);
   if (argc > 2) l2=strtol(&argv[2][0], NULL, 0);
   memcpy(&fl, &l1, 4);
   sprintf(patB,"%s%d%s",patA,l2,patC);
   printf(patB,fl);
   return 0;
}
