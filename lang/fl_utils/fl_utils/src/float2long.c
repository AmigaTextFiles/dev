/* 
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long l1 = 0;
long l2 = 0;
double dub = 0;
char buf[7];

int main (int argc, char **argv) {
   if (argc < 2) return 0;
   dub=atof(&argv[1][0]);
   memcpy(&buf, &dub, 8);
   memcpy(&l1, &buf, 4);
   memcpy(&l2, &buf[4], 4);
   printf("%ld %ld\n",l1,l2);
   return 0;
}
