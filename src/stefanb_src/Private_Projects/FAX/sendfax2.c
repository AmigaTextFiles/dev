#include "serio.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <clib/dos_protos.h>

static struct ReadArgs *rda;
static struct SerialStream *ss;
static char Template[]="DEVICE/K,UNIT/K/N,BAUD/K/N,RETRIES/K/N,NUMBER/K,FILES/M/A";
static struct {
               char *device;
               long *unit;
               long *baud;
               long *retries;
               char *number;
               char **files;
              } def={"serial.device",NULL,NULL,NULL,NULL,NULL};
#define BUFLEN 1024
static UBYTE buffer[BUFLEN];
static ULONG GlobalReturnCode;
static BOOL notend;
static BOOL notendofsession;

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

/* Read and analyse modem reply */
/* Possible normal replies */
#define REPLY_OK          0
#define REPLY_CONNECT     1
#define REPLY_NO_CARRIER  3
#define REPLY_ERROR       4
#define REPLY_NO_DIALTONE 6
/* Possible FAX Class II replies */
#define REPLY_FHNG        10

static ULONG ReadModemReply(void)
{
 ULONG rc;

 while (TRUE)
  {
   /* Read one line */
   ReadLine(buffer);
   printf("%s",buffer);

   /* Skip empty lines */
   if (strlen(buffer)==2) continue;

   /* Check for normal replies */
   if (!strncmp(buffer,"OK",2))
    {
     rc=REPLY_OK;
     break;
    }
   if (!strncmp(buffer,"CONNECT",7))
    {
     rc=REPLY_CONNECT;
     break;
    }
   if (!strncmp(buffer,"NO CARRIER",10))
    {
     rc=REPLY_NO_CARRIER;
     break;
    }
   if (!strncmp(buffer,"ERROR",5))
    {
     rc=REPLY_ERROR;
     break;
    }
   if (!strncmp(buffer,"NO DIALTONE",11))
    {
     rc=REPLY_NO_DIALTONE;
     break;
    }

   /* Check for FAX Class II responses */
   if (!strncmp(buffer,"+FHNG:",6))
    {
     rc=REPLY_FHNG;
     GlobalReturnCode=atol(buffer+6);
     break;
    }

   /* Everything else is skipped */
  }

 return(rc);
}

/* Send a FAX page */
static void SendFAXPage(FILE *fh)
{
 /* Wait until modem sent a XON */
 {
  char c='\0';
  while (c!='\x11') ReadSerialSynch(ss,&c,1);
 }

 /* Send FAX data */
 while (!feof(fh))
  {
   ULONG len;
   char *cp=buffer;

   /* Read data from file */
   len=fread(buffer,1,BUFLEN,fh);

   /* Send buffer */
   while (len--)
    {
     /* Write one byte */
     WriteSerialSynch(ss,cp,1);

     /* Special DLE processing. DLE --> DLE DLE */
     if (*cp=='\x10') WriteSerialSynch(ss,cp,1);

     /* Next byte */
     cp++;
    }

   /* Flow control */
   if (QuerySerial(ss) && ((len = ss->ss_Unread)>0))
    {
     char c='\0';

     /* Read until XOFF */
     while ((len--) && (c!='\x13')) ReadSerialSynch(ss,&c,1);

     /* Read until XON (will be skipped if no XOFF found!) */
     while ((len--) && (c!='\x11')) ReadSerialSynch(ss,&c,1);
    }
  }

 /* End of FAX data, send DLE ETX */
 WriteSerialSynch(ss,"\x10\x03",2);
}

/* FAX session main loop */
static void DoFAXSession(char **files)
{
 /* Repeat until end of session */
 notendofsession=TRUE;
 while (notendofsession)
  {
   struct FILE *fh;

   /* Open FAX file */
   if (fh=fopen(*files,"r"))
    {
     /* Signal modem: "Ready to send phase C data!" */
     WriteSerialSynch(ss,"AT+FDT\r",7);

     /* Got a CONNECT? */
     switch(ReadModemReply())
      {
       case REPLY_CONNECT:    /* Yes. Send next page */
                              puts("sending page");
                              SendFAXPage(fh);
                              puts("page send");
                              ReadModemReply();
                              puts("read reply");
                              break;

       case REPLY_NO_CARRIER: /* No. Something has gone wrong */
       case REPLY_ERROR:
       case REPLY_FHNG:       notendofsession=FALSE;
                              break;
      }

     /* Close FAX file */
     fclose(fh);
    }
   else printf("Couldn't open %s!\n",*files);

   /* Additional pages to send? */
   if (notendofsession)
    {
     WriteSerialSynch(ss,"AT+FET=",7);
     if (*++files)
      WriteSerialSynch(ss,"0\r",2); /* Yes. */
     else
      WriteSerialSynch(ss,"2\r",2); /* No. End of document */

     /* Read reply */
     if (ReadModemReply()!=REPLY_OK)
      notendofsession=FALSE;
    }
  }
}

/* CTRL-C shut down routine */
static int Shutdown(void)
{
 notend=FALSE;
 return(0);
}

int main(int argc, char *argv[])
{
 int (*oldbreak)();
 ULONG Unit,Baud,Retries;

 /* Read command line parameters */
 if (!(rda=ReadArgs(Template,(LONG *) &def,NULL)))
  {
   PrintFault(IoErr(),argv[0]);
   exit(20);
  }
 Unit=(def.unit)?(*def.unit):0;
 Baud=(def.baud)?(*def.baud):19200;
 Retries=(def.retries)?(*def.retries):5;

 /* Install CTRL-C shut down routine */
 GlobalReturnCode=20;
 notend=TRUE;
 oldbreak=onbreak(Shutdown);
 printf("'%s' %ld (%ldbps)\n",def.device,Unit,Baud);

 if (ss=CreateSerialStream(def.device,Unit,
                           SERF_SHARED|SERF_7WIRE|SERF_RAD_BOOGIE))
  {
   if (SetSerialParamsTags(ss,SIO_Baud,Baud,TAG_DONE))
    while (notend && Retries)
     {
      /* Init modem */
      WriteSerialSynch(ss,"AT+fclass=2+fbor=0\r",19);
      ReadModemReply();
      WriteSerialSynch(ss,"AT+flid=+49-241-505705\r",23);
      ReadModemReply();
      WriteSerialSynch(ss,"AT+fdcc=0,5,0,2,0\r",18);
      ReadModemReply();

      /* Dial number */
      if (def.number)
       {
        WriteSerialSynch(ss,"ATDP",4);
        WriteSerialSynch(ss,def.number,strlen(def.number));
        WriteSerialSynch(ss,"\r",1);
       }
      else WriteSerialSynch(ss,"ATD\r",4);

      /* Got a connect? */
      switch (ReadModemReply())
       {
        case REPLY_OK:DoFAXSession(def.files);
                      Retries=0;
                      break;
        case REPLY_NO_DIALTONE:continue;
        default:Retries--;
       }
     }
   else puts("Couldn't set parameters!");

   DeleteSerialStream(ss);
  }
 else puts("Couldn't open stream!");

 /* Free command line parameters */
 FreeArgs(rda);

 /* Leave program */
 onbreak(oldbreak);
 return(GlobalReturnCode);
}

