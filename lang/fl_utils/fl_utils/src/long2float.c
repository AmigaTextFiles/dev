/* 
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long l1 = 0;
long l2 = 0;
long l3 = 20;
double dub = 0;
char buf[7];
char *patA = "%.";
char patB[256];
char *patC = "f\n";

int main (int argc, char **argv) {
   if (argc < 3) return 0;
   l1=strtol(&argv[1][0], NULL, 0);
   l2=strtol(&argv[2][0], NULL, 0);
   if (argc > 3) l3=strtol(&argv[3][0], NULL, 0);
   memcpy(&buf, &l1, 4);
   memcpy(&buf[4], &l2, 4);
   memcpy(&dub, &buf, 8);
   sprintf(patB,"%s%d%s",patA,l3,patC);
   printf(patB,dub);
   return 0;
}
