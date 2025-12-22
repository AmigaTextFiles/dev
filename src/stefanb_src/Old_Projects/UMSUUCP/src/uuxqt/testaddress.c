/*
 * Test program for SplitAddress()
 *
 */

#include "uuxqt.h"

char argbuf[100];
char name[1000];
char address[1000];
char buffer[3000];
char *UMSDebugProgram="",*UMSDebugFile="CONSOLE:";
long UMSDebugLevel=5;

int main(int argc, char *argv[])
{
 char *arg;

 if (argc<2) {
  char c,*cp=argbuf;

  while ((c=getchar())!='\n') *cp++=c;
  arg=argbuf;
 } else
  arg=argv[1];

 SplitAddress(arg,name,address,buffer);

 exit(0);
}
