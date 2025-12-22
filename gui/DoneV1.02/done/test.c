#include <clib/dos_protos.h>
#include "done.h"

#define MY_VERSION_STRING "$VER:test1 By Stuart Kelly Copyright 1996 © Uses Done V 1.02"

char *version = MY_VERSION_STRING;

void main(void)
{
 int a;
 int b=0;
 printf(" test1 By Stuart Kelly Copyright 1996 ©\n");
 printf(" Written Using Dice C\n");
 printf(" Uses '%s' Working Requester\n", DONE_VERSION_A);
 printf(" Press Return When Ready-> ");
 getchar();

 /*
 ** NOTE: For ST_SetTopAndLeft(....) to work it must be called
 ** before ST_WorkReq(....)
 */ 
 ST_SetTopAndLeft(90,139);      /* Put Window in Center */

 ST_WorkReq(NULL);

 ST_SetScreenTitle(" Please Wait, Working......");

 for (a=0; a<ALL_DONE; a++)
 {
 printf("  %d\n", a);
 /*  printf("  %.2f\n", a);  print %f with 2 decimal places!!!1*/
 ST_SetDone(a);
 }
 
 printf(" %d\n", a);

 ST_SetDone(ALL_DONE);

 ST_SetTitles(" All Done", "(100%) Done");

 printf(" Press Return to Clear -> ");
 getchar();

 ST_ClearWR();

 printf(" Press Return To Set to 30%% -> ");
 getchar();

 ST_SetDone(30);

 printf(" Press Return To Set to 50%% -> ");
 getchar();
 
 ST_SetDone(HALF_DONE);

 printf(" Press Return To Quit\n");
 getchar();

 ST_FreeWorkReq();

 return;
}

