#include "serio.h"
#include <stdio.h>
#include <stdlib.h>
#include <clib/dos_protos.h>

struct SerialStream *ss;
UBYTE buffer[100];

int main(int argc, char *argv[])
{
 if (ss=CreateSerialStream("serial.device",2,
                           SERF_SHARED|SERF_7WIRE|SERF_RAD_BOOGIE))
  {
   puts("device opened");

   if (SetSerialParamsTags(ss,SIO_Baud,19200,TAG_DONE))
    {
     puts("parameters set 1");

     if (SetSerialParamsTags(ss,SIO_Baud,19200,TAG_DONE))
      {
       puts("parameters set 2");
       WriteSerialSynch(ss,"at\r",3);
       ReadSerialSynch(ss,buffer,4);
       puts(buffer);

       if (argc>2) SystemTags("test1 1",TAG_DONE);
       else if (argc>1) SystemTags("test1",TAG_DONE);
      }
    }
   DeleteSerialStream(ss);
  }

 return(0);
}
