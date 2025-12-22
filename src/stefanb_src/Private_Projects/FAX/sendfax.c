#include "serio.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <clib/dos_protos.h>

static struct ReadArgs *rda;
static char Template[]="DEVICE/K,UNIT/K/N,BAUD/K/N,FILE/K/A,NUMBER/K";
static struct {
               char *device;
               long *unit;
               long *baud;
               char *file;
               char *number;
              } def={"serial.device",NULL,NULL,NULL,""};
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

/* Send FAX data */
void faxsend(void)
{
 UBYTE c='\0';
 FILE *fh;

 /* Wait until modem sent a XON */
 while (c!='\x11') ReadSerialSynch(ss,&c,1);

 /* Start FAX data send */
 if (fh=fopen(def.file,"r"))
  {
   int i;

   while (!feof(fh))
    {
     /* Read on byte from and send it */
     c=fgetc(fh);
     WriteSerialSynch(ss,&c,1);

     /* Special DLE processing: DLE -> DLE DLE */
     if (c=='\x10') WriteSerialSynch(ss,&c,1);

     /* Check Flow control every 2000 characters */
     if (++i==2000)
      {
       /* Reset counter */
       i=0;

       /* Check for XOFF */
       ReadSerialASynchStart(ss,&c,1);
       RemoveIORequest((struct IORequest *) ss->ss_Read);
       if ((ss->ss_Read->IOSer.io_Error==0) && (c=='\x13'))
        do
         ReadSerialSynch(ss,&c,1);
        while(c!='\x11'); /* Wait on XON */
      }
    }

   /* End of FAX data, send DLE ETX */
   WriteSerialSynch(ss,"\x10\x03",2);

   /* Close FAX data file */
   fclose(fh);

   /* Wait on reply */
   while (notend)
    {
     ReadLine(buffer);
     printf("%s",buffer);
     if (!strncmp(buffer,"OK",2)) break;
     if (!strncmp(buffer,"NO CARRIER",10)) break;
    }

   /* End of transmission */
   WriteSerialSynch(ss,"AT+FET=2\r",9);
   while (notend)
    {
     ReadLine(buffer);
     printf("%s",buffer);
     if (!strncmp(buffer,"OK",2)) break;
    }
  }

 /* Set exit flag */
 notend=FALSE;
}

/* Got a connect */
void faxconnect(void)
{
 /* Set FAX parameters */
 WriteSerialSynch(ss,"AT+FDT=0,1,0,2\r",15);

 /* Wait on CONNECT reply */
 while (notend)
  {
   /* Wait on modem reply */
   ReadLine(buffer);
   printf("%s",buffer);

   if (strlen(buffer)==2) continue; /* Skip empty lines */
   if (!strncmp(buffer,"CONNECT",7))     /* Got a connect? */
    {
     faxsend();
     break;
    }
   if (!strncmp(buffer,"+FHNG",5))       break; /* Hang-up */
   if (!strncmp(buffer,"NO CARRIER",10)) break; /* Carrier lost */
  }
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
 printf("Using device '%s' unit %ld (%ldbps)\n",def.device,Unit,Baud);
 printf("Sending file '%s' to '%s'\n",def.file,def.number);

 /* Open serial stream */
 if (ss=CreateSerialStream(def.device,Unit,
                           SERF_SHARED|SERF_7WIRE|SERF_RAD_BOOGIE))
  {
   if (SetSerialParamsTags(ss,SIO_Baud,Baud,TAG_DONE))
    while (notend)
     {
      /* Reset modem */
      WriteSerialSynch(ss,"ATZ\r",4);
      Delay(100);
      ClearSerial(ss);

      /* Init Modem */
      WriteSerialSynch(ss,"AT+fbor=1+fclass=2\r",19);
      Delay(50);
      ReadLine(buffer);
      printf("%s",buffer);
      ReadLine(buffer);
      printf("%s",buffer);

      /* Dial number */
      if (strlen(def.number))
       {
        WriteSerialSynch(ss,"ATDP",4);
        WriteSerialSynch(ss,def.number,strlen(def.number));
        WriteSerialSynch(ss,"\r",1);
       }
      else WriteSerialSynch(ss,"ATD\r",4);
      ReadLine(buffer);
      printf("%s",buffer);
      ReadLine(buffer);
      printf("%s",buffer);

      /* Check connection status */
      if (!strncmp(buffer,"BUSY",4))         continue;
      if (!strncmp(buffer,"NO CARRIER",10))  continue;
      if (!strncmp(buffer,"NO DIALTONE",11)) continue;

      /* Connected, wait for FAX connect */
      while (notend)
       {
        /* Wait on modem reply */
        ReadLine(buffer);
        printf("%s",buffer);

        if (strlen(buffer)==2) continue; /* Skip empty lines */
        if (!strncmp(buffer,"OK",2))     /* Got a connect? */
         {
          faxconnect();
          break;
         }
        if (!strncmp(buffer,"+FHNG",5))       break; /* Hang-up */
        if (!strncmp(buffer,"NO CARRIER",10)) break; /* Carrier lost */
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
