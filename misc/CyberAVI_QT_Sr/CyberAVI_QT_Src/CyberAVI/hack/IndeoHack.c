unsigned long __asm Indeo_Init_YUVBufs(register __d0 long width,
                                       register __d1 long height);

#include <stdio.h>
#include <stdlib.h>

extern far const void *YContrib;
extern far const void *indeo_bufs;
extern far const void *L000124;
extern far const void *L000125;
extern far void *L000126;
extern far unsigned long L000127;
extern far const void *L000128;
extern far const void *L000129;
extern far const void *L00012A;
extern far const void *L00012B;
extern far const void *L00012C;
extern far const void *L00012D;
extern far const void *L00012E;

void *mybuffer;
void main(void)
{
  FILE *f;

  mybuffer=malloc(46720);
  if(mybuffer) {
    L000126=mybuffer;
    L000127=46720;
    printf("%08lx\n",Indeo_Init_YUVBufs(160,120));
    if(f=fopen("sd0:y","w")) {
      fwrite(YContrib,1024,1,f);
      fclose(f);
    }
  }
  else printf("no mem\n");
}

