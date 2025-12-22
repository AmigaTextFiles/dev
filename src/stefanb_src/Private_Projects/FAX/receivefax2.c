#include "serio.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <clib/dos_protos.h>

static struct ReadArgs *rda;
static struct SerialStream *ss;
static char Template[]="DEVICE/K,UNIT/K/N,BAUD/K/N,FILE/K/A";
static struct {
               char *device;
               long *unit;
               long *baud;
               char *file;
              } def={"serial.device",NULL,NULL,NULL};
#define BUFLEN 1024
static UBYTE buffer[BUFLEN];
static ULONG GlobalReturnCode;
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

   /* Check for FAX Class II responses */
   if (!strncmp(buffer,"+FHNG:",6))
    {
     rc=REPLY_FHNG;
     GlobalReturnCode=atol(buffer+6);
     break;
    }
   if (!strncmp(buffer,"+FET:2",6)) /* 2 == End of Document */
    notendofsession=FALSE;

   /* Everything else is skipped */
  }

 return(rc);
}

/* Receive a FAX page */
static void ReceiveFAXPage(char *filename)
{
 FILE *fh;

 /* Open file */
 if (fh=fopen(filename,"w"))
  {
   BOOL notendofpage=TRUE;

   /* Flush any characters */
   ClearSerial(ss);

   /* Send DC2 to start phase C data stream */
   WriteSerialSynch(ss,"\x12",1);

   /* Phase C data receive loop */
   while (notendofpage)
    {
     BOOL pdle=FALSE; /* No pending DLE */

     /* Get number of bytes in buffer */
     QuerySerial(ss);

     /* Any bytes to read? */
     if (ss->ss_Unread>0)
      {
       /* Yes, get them and process them */
       LONG len=(ss->ss_Unread>BUFLEN)?BUFLEN:ss->ss_Unread;
       UBYTE *cp=buffer;

       /* Read bytes into buffer */
       if (ReadSerialSynch(ss,buffer,len)!=len) break;

       while (len--)
        {
         /* DLE character pending? */
         if (pdle)
          {
           /* Yes. Analyse control code */
           switch(*cp)
            {
             case '\x03':notendofpage=FALSE; /* DLE ETX -> End of page */
                         len=0;
                         break;
             case '\x10':fputc('\x10',fh);   /* DLE DLE -> DLE */
                         break;
            }
           pdle=FALSE; /* DLE handled */
          }
         else
          /* No. Normal character */
          if (*cp!='\x10')
           fputc(*cp,fh); /* Normal character found */
          else
           pdle=TRUE;     /* DLE found */

         /* Next character */
         cp++;
        }
      }
     else
      /* No, carrier lost? */
      if (ss->ss_Status&0x0020) notendofpage=FALSE; /* Yep! */
      else Delay(5);                                /* No. Wait a while */
    }

   /* Close file */
   fclose(fh);
  }
 else printf("Couldn't open '%s'!\n",filename);
}

/* FAX session main loop */
static void DoFAXSession(char *basename)
{
 ULONG page=0;
 char *filename;

 /* Get memory for file name */
 if (filename=malloc(strlen(basename)+9))
  {
   /* Repeat until session end */
   notendofsession=TRUE;
   while(notendofsession)
    {
     /* Signal modem: "Ready to receive phase C data!" */
     WriteSerialSynch(ss,"AT+FDR\r",7);

     /* Got a CONNECT? */
     switch(ReadModemReply())
      {
       case REPLY_CONNECT:    /* Yes. Receive next page */
                              sprintf(filename,"%s.g3.%04d",basename,++page);
                              ReceiveFAXPage(filename);
                              break;
       case REPLY_NO_CARRIER: /* No. Something has gone wrong */
       case REPLY_ERROR:
       case REPLY_FHNG:       notendofsession=FALSE;
                              break;
      }
    }

   /* Free memory */
   free(filename);
  }
 else puts("Not enough memory!");

 /* Signal modem: "End of transmission" */
 WriteSerialSynch(ss,"AT+FET=2\r",9);

 /* Get hangup code */
 ReadModemReply();
 printf("Received %d page(s)\n",page);
}

/* CTRL-C shut down routine */
static int Shutdown(void)
{
 return(0);
}

int main(int argc, char *argv[])
{
 int (*oldbreak)();
 ULONG Unit,Baud;

 /* Read command line parameters */
 if (!(rda=ReadArgs(Template,(LONG *) &def,NULL)))
  {
   PrintFault(IoErr(),argv[0]);
   exit(20);
  }
 Unit=(def.unit)?(*def.unit):0;
 Baud=(def.baud)?(*def.baud):19200;

 /* Install CTRL-C shut down routine */
 GlobalReturnCode=20;
 oldbreak=onbreak(Shutdown);
 printf("'%s' %ld (%ldbps) file '%s'\n",def.device,Unit,Baud,def.file);

 if (ss=CreateSerialStream(def.device,Unit,
                           SERF_SHARED|SERF_7WIRE|SERF_RAD_BOOGIE))
  {
   if (SetSerialParamsTags(ss,SIO_Baud,Baud,TAG_DONE))
    {
     if (ReadModemReply()==REPLY_OK) DoFAXSession(def.file);
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
