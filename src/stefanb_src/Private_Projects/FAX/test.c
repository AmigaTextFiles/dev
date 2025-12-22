/* Test program for serial routines */

#include "serio.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <clib/dos_protos.h>

char cmd[80];
char buffer[10000];

int main(int argc, char *argv[])
{
 struct SerialStream *ss;

 if (ss=CreateSerialStream("serial.device",2,SERF_SHARED|SERF_7WIRE))
  {
   SetSerialParamsTags(ss,SIO_Baud,19200,TAG_DONE);

   printf("serial stream created! bps: %d\n",ss->ss_Baud);

   ss->ss_Cmd->IOSer.io_Command=CMD_CLEAR;
   DoIO((struct IORequest *) ss->ss_Cmd);

   while (1)
    {
     int len;
     char *cp;

     scanf("%s",cmd);
     if (feof(stdin)) break;
     len=strlen(cmd);
     cmd[len++]='\r';
     cmd[len]='\0';

     WriteSerialSynch(ss,cmd,len);
     puts("write");

     QuerySerial(ss);
     if (ss->ss_Unread>0)
      {
       len=ReadSerialSynch(ss,buffer,ss->ss_Unread);
       printf("read %d chars\n",len);
       cp=buffer;
       while (len--) putchar(*cp++);
       puts("\n---");
      }
    }

   DeleteSerialStream(ss);
  }
 return(0);
}
