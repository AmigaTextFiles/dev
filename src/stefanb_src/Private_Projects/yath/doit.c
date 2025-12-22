#include <stdio.h>
#include <exec/memory.h>

#include "io.h"

struct scsichan sc={"scsi.device",6,0,NULL,NULL};

#define BLOCKLEN 2048
#define BLOCKS   100
#define DATALEN  BLOCKLEN*BLOCKS
/* __aligned UBYTE data[DATALEN]; */
UBYTE *data;
__aligned UBYTE scmd[10]={0,0,0,0,0,0,0,0,0,0};
__aligned UBYTE sense[255];
__aligned struct SCSICmd sioc={NULL,DATALEN,0,scmd,10,0,0,0,sense,255,0};

main(int argc,char **argv)
{
 int i,j;
 BYTE rc;

 if (!(data=AllocMem(DATALEN,MEMF_CLEAR|MEMF_PUBLIC))) {
  fprintf(stderr,"no memory\n");
  CloseSCSIchan(&sc);
  exit(0);
 }
 sioc.scsi_Data=data;
 fprintf(stderr,"SCSI Geöffnet!\n");
 sioc.scsi_Flags=SCSIF_READ;

 if (argc<2) exit(0);
 if (OpenSCSIchan(&sc))
  {
   fprintf(stderr,"Fehler beim oeffnen!\n");
   exit(0);
  }

 scmd[0]=0x12;
 scmd[4]=255;
 if (rc=DoSCSIcmd(&sc,&sioc))
  {
   fprintf(stderr,"Fehler %d\n",rc);
   CloseSCSIchan(&sc);
   FreeMem(data,DATALEN);
   exit(0);
  }
 fprintf(stderr,"Inquiry Data: %s\n",&data[8]);

 if (!strcmp("-r",argv[1]))
  {
   fprintf(stderr,"Rewinding...\n");
   scmd[0]=0x1;
   scmd[1]=1;
   scmd[2]=0;
   scmd[3]=0;
   scmd[4]=0;
   scmd[5]=0;
   if (rc=DoSCSIcmd(&sc,&sioc))
    {
     fprintf(stderr,"Fehler %d\n",rc);
    }
   CloseSCSIchan(&sc);
   FreeMem(data,DATALEN);
   exit(0);
  }

#if 0
 j=atoi(argv[1]);
 fprintf(stderr,"\nReading %d blocks\n",j);
   while (j>0)
    {
     fprintf(stderr,"%d\n",j);
#endif
     scmd[0]=0x43;
     scmd[1]=0;
     scmd[2]=0;
     scmd[3]=0;
     scmd[4]=0;
     scmd[5]=0;
     scmd[6]=0;
     scmd[7]=(DATALEN>>8) & 0xff;
     scmd[8]=DATALEN & 0xff;
     scmd[9]=0;
     if (rc=DoSCSIcmd(&sc,&sioc))
      {
       fprintf(stderr,"Fehler %d\n",rc);
       CloseSCSIchan(&sc);
       FreeMem(data,DATALEN);
       exit(0);
      }

     fwrite(data,DATALEN,1,stdout);
#if 0
     j-=BLOCKS;
    }
   fprintf(stderr,"\n");

   /* Media removal */
   scmd[0]=0x1e;
   scmd[1]=0;
   scmd[2]=0;
   scmd[3]=0;
   scmd[4]=1;
   scmd[5]=0;
   if (rc=DoSCSIcmd(&sc,&sioc))
    {
     fprintf(stderr,"Fehler %d\n",rc);
     CloseSCSIchan(&sc);
     FreeMem(data,DATALEN);
     exit(0);
    }
#endif

 CloseSCSIchan(&sc);
 FreeMem(data,DATALEN);
}
