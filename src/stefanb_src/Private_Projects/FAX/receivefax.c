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
static BOOL notend;

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

/* FAX data receive routine */
static int faxreceive(void)
{
 char *faxname,*infoname;
 FILE *fhfax,*fhinfo;
 ULONG rc=5;

 /* Build file names */
 if (!(faxname=malloc(strlen(def.file)+4))) goto fre1;
 strcpy(faxname,def.file);
 strcat(faxname,".g3");
 if (!(infoname=malloc(strlen(def.file)+5))) goto fre2;
 strcpy(infoname,def.file);
 strcat(infoname,".txt");

 /* Open files */
 if (!(fhfax=fopen(faxname,"w"))) goto fre3;
 if (!(fhinfo=fopen(infoname,"w"))) goto fre4;

 /* Wait until modem is ready */
 while (TRUE)
  {
   /* Get status bits */
   if (!QuerySerial(ss)) goto fre5; /* Can't query device */

   /* Check Carrier detect */
   if (ss->ss_Status&0x0020) goto fre5; /* Carrier lost */

   /* Check CTS becomes low */
   if (!(ss->ss_Status&0x0010)) break;

   /* Short Delay */
   Delay(5);
  }

 /* Modem ready for transfer, send DC2 */
 WriteSerialSynch(ss,"\x12",1);

 /* Read parameter line and write it to FAX info file */
 ReadLine(buffer);
 ReadLine(buffer);
 fprintf(fhinfo,"%s",buffer);

 /* Receive FAX Data */
 while (TRUE)
  {
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
     fwrite(buffer,1,len,fhfax);
    }
   else
    {
     /* No, carrier lost? */
     if (ss->ss_Status&0x0020)
      {
       rc=0; /* Yes, FAX probably received OK */
       break;
      }

     /* No. Wait a little while */
     Delay(5);
    }
  }

 /* Free resources */
fre5:fclose(fhinfo);
fre4:fclose(fhfax);
fre3:free(infoname);
fre2:free(faxname);
fre1:return(rc);
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
 ULONG rc=5;
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
 notend=TRUE;
 oldbreak=onbreak(Shutdown);
 printf("'%s' %ld (%ldbps) file '%s'\n",def.device,Unit,Baud,def.file);

 if (ss=CreateSerialStream(def.device,Unit,
                           SERF_SHARED|SERF_7WIRE|SERF_RAD_BOOGIE))
  {
   if (SetSerialParamsTags(ss,SIO_Baud,Baud,TAG_DONE))
    while (notend)
     {
      /* Wait on modem reply */
      ReadLine(buffer);
      printf("%s",buffer);

      /* Analyse modem reply */
      if (strlen(buffer)==2) continue; /* Ignore empty replies */
      if (!strncmp("ZyXEL",buffer, 5)) rc=faxreceive(); /* Read FAX data */
      notend=FALSE; /* Every other reply is errornous */
     }
   else printf("Couldn't set parameters!\n");

   DeleteSerialStream(ss);
  }
 else printf("Couldn't open stream!\n");

 /* Free command line parameters */
 FreeArgs(rda);

 /* Leave program */
 onbreak(oldbreak);
 return(0);
}
