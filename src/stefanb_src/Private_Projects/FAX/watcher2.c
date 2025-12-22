#include "serio.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <clib/dos_protos.h>

static struct ReadArgs *rda;
static char Template[]="DEVICE/K,UNIT/K/N,BAUD/K/N,RECEIVER/K,PATH/K";
static struct {
               char *device;
               long *unit;
               long *baud;
               char *receiver;
               char *path;
              } def={"serial.device",NULL,NULL,"receivefax2","FAX:"};
static struct SerialStream *ss;
static BOOL notend;
static UBYTE buffer[1024];

/* Read one reply line from modem */
static void ReadLine(void *buf)
{
 char c='\0',*cp=buf;

 /* Read until EOL is reached */
 while (c!='\n')
  {
   if (ReadSerialSynch(ss,&c,1)==0) break;
   *cp++=c;
  }

 /* Terminate string */
 *cp='\0';
}

/* CTRL-C shutdown routine */
static int Shutdown(void)
{
 notend=FALSE;
 return(0);
}

int main(int argc, char *argv[])
{
 int (*oldbreak)();
 ULONG Unit,Baud;

 /* Read command line arguments */
 if (!(rda=ReadArgs(Template,(LONG *) &def,NULL)))
  {
   PrintFault(IoErr(),argv[0]);
   exit(20);
  }
 Unit=(def.unit)?(*def.unit):0;
 Baud=(def.baud)?(*def.baud):19200;

 /* Set CTRL-C shut down routine */
 notend=TRUE;
 oldbreak=onbreak(Shutdown);
 printf("Monitoring device '%s' unit %ld (%ldbps)\n",def.device,Unit,Baud);
 printf("FAX Parameters - Receiver: '%s'  Path: '%s'\n",def.receiver,def.path);

 /* Open serial stream */
 if (ss=CreateSerialStream(def.device,Unit,
                           SERF_SHARED|SERF_7WIRE|SERF_RAD_BOOGIE))
  {
   ULONG faxnumber=1;

   if (SetSerialParamsTags(ss,SIO_Baud,Baud,TAG_DONE))
    while (notend)
     {
      /* Reset modem */
      WriteSerialSynch(ss,"ATZ\r",4);
      Delay(100);
      ClearSerial(ss);

      /* Init Modem */
      WriteSerialSynch(ss,"AT+fclass=0+fcr=1+fbor=1\r",25);
      Delay(50);
      ReadLine(buffer);
      printf("%s",buffer);

      /* Wait for FAX connect */
      while (notend)
       {
        /* Wait on modem reply */
        ReadLine(buffer);
        printf("%s",buffer);

        /* FAX connect message? */
        if (!strncmp("+FCON",buffer,5))
         {
          LONG rc;

          /* Yes. Build FAX receiver command line */
          sprintf(buffer,"%s DEVICE %s UNIT %ld BAUD %ld FILE %s/fax%04ld",
                  def.receiver,def.device,Unit,Baud,def.path,faxnumber);

          /* Start FAX receiver */
          rc=SystemTags(buffer,TAG_DONE);

          /* Analyse return code */
          if (rc==-1) puts("Couldn't start FAX receiver!");
          else if (rc>0) puts("Error in FAX receiver!");
          else faxnumber++;

          /* Leave connect loop */
          break;
         }
       }
     }
   else printf("Couldn't set parameters!\n");

   /* Free resources */
   DeleteSerialStream(ss);
  }
 else printf("Couldn't open stream!\n");

 /* Free command line argumets */
 FreeArgs(rda);

 /* Leave program */
 onbreak(oldbreak);
 return(0);
}
