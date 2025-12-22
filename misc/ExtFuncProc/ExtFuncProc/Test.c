
/***************************************************************************
*
*        Programm:   test
*        Modul:      test.c
*        Funktion:   testet ExtFuncProc
*
*        Datum:            01.05.90
*        letzte Änderung:
*
***************************************************************************/

#include <stdlib.h>
#include <stdio.h>

void
end(struct MsgPort *port,char *s)

{
   puts(s);
   if (port)
      DeletePort(port);
   exit(10);
}

void
main(int argc,char **argv)

{
   long segment;
   struct ExtFuncPort *efp;
   struct ExtFuncMessage efm;
   struct FileHandle *fh;
   struct MsgPort *myport;
   char buffer[16];
   void *proc_id;

   if (!(myport = CreatePort(NULL,0L)))
      end(NULL,"no replyport");
   efm.efm_Msg.mn_ReplyPort = myport;
   efm.efm_Msg.mn_Length = sizeof(struct ExtFuncPort);
   if (!(efp = (struct ExtFuncPort *)FindPort((char *)EFP_PORTNAME))) {
      if (!(segment = LoadSeg((char *)"ExtFuncProc")))
         end(myport,"no segment");
      if (!(proc_id = CreateProc((char *)"ExtFuncProc",0L,segment,4000L)))
         end(myport,"no process");
      PutMsg(proc_id,(struct Message *)&efm);
      WaitPort(myport);
      GetMsg(myport);
      efp = (struct ExtFuncPort *)FindPort((char *)EFP_PORTNAME);
   }
   if (efp && ((efp->efp_MatchWord!=EFP_MATCHWORD) || (efp->efp_MatchTag!=efp)))
      /* war irgend ein anderer Port,
         sollte zumindest beim 1. Mal geprüft werden */
      efp = NULL;
   if (!efp)
      end(myport,"no port");
   /* */
   efm.efm_LibName = (UBYTE *)"dos.library";
   efm.efm_LibVersion = 0L;
   /* Open */
   efm.efm_LibVectorOffset = -30;
   efm.efm_ArgD1 = (long)"con:0/0/300/70/test";
   efm.efm_ArgD2 = 1006L;
   PutMsg((struct MsgPort *)efp,(struct Message *)&efm);
   WaitPort(myport);
   GetMsg(myport);
   if (efm.efm_Error)
      end(myport,"no library");
   if (!(fh = (struct FileHandle *)efm.efm_Result))
      end(myport,"open error");
   /* Write */
   efm.efm_LibVectorOffset = -48;
   efm.efm_ArgD1 = (long)fh;
   efm.efm_ArgD2 = (long)"this is a test\nhit RETURN\nand wait\n";
   efm.efm_ArgD3 = 35L;
   PutMsg((struct MsgPort *)efp,(struct Message *)&efm);
   WaitPort(myport);
   GetMsg(myport);
   if (efm.efm_Error)
      end(myport,"no library");
   if (efm.efm_Result != efm.efm_ArgD3)
      end(myport,"write error");
   /* Read */
   efm.efm_LibVectorOffset = -42;
   efm.efm_ArgD1 = (long)fh;
   efm.efm_ArgD2 = (long)buffer;
   efm.efm_ArgD3 = 1L;
   PutMsg((struct MsgPort *)efp,(struct Message *)&efm);
   WaitPort(myport);
   GetMsg(myport);
   if (efm.efm_Error)
      end(myport,"no library");
   if (efm.efm_Result != efm.efm_ArgD3)
      end(myport,"read error");
   /* Delay */
   efm.efm_LibVectorOffset = -198;
   efm.efm_ArgD1 = 100L;
   PutMsg((struct MsgPort *)efp,(struct Message *)&efm);
   WaitPort(myport);
   GetMsg(myport);
   if (efm.efm_Error)
      end(myport,"no library");
   /* Close */
   efm.efm_LibVectorOffset = -36;
   efm.efm_ArgD1 = (long)fh;
   PutMsg((struct MsgPort *)efp,(struct Message *)&efm);
   WaitPort(myport);
   GetMsg(myport);
   if (efm.efm_Error)
      end(myport,"no library");
}

