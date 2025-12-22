#include <stdio.h>

void main(int argc, char **argv)
{
 int *i=(int *)0x090F1810;
 int *ptr;
 int j,depth,count;
 if (argc<2) return;
 if (argc==2) depth=1;
 else 
 {
  sscanf(argv[2],"%i",&depth);
 }
 sscanf(argv[1],"%x",&j);
 i=(int *)j;
 for (count=0;count<depth;count++)
 {
  ptr=i;
  ptr=*i;
  ptr++;
  ptr++;
  if (ptr==0) return;
  fprintf(stderr,"%i. Depth: %x\n",count+1,(*ptr));
  ptr--;
  ptr--;
  i=(int *)ptr;
 }
}