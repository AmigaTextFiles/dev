/* Wichtig: Programm mit LargeCode/Data erzeugen! */
#define VERSION  38
#define REVISION  0
#define IDSTRING "guru.resource 38.0  02-Sep-95"

#include <exec/types.h>
#include <exec/tasks.h>
#include <exec/execbase.h>
#include <exec/alerts.h>
#include <exec/libraries.h>
#include "multidesktop.h"

#define ALERT_OFFSET -108

struct MultiDesktopBase *MultiDesktopBase;
extern struct ExecBase  *SysBase;

extern void AlertHandler();
extern void LED();

struct GuruResource
{
 struct Library Library;
 APTR           OldAlertHandler;
 struct Task   *NoGuruTask;
 ULONG          NoGuruSignalMask;
};

struct GuruResource GuruResource=
{
 {
  {0L,0L,NT_RESOURCE,-10,"guru.resource"},
   LIBF_SUMUSED,0,
   0,sizeof(struct Library),
   VERSION,REVISION,IDSTRING,
   0L,0
 },
 NULL,NULL
};

void main(argc,argv)
 int    argc;
 UBYTE *argv[];
{
 LONG                 i;
 BOOL                 new=FALSE,off=FALSE;
 struct GuruResource *GuruRes;

 MultiDesktopBase=OpenLibrary("multidesktop.library",0L);
 if(MultiDesktopBase)
  {
   if((argc>1)&&(!(strcmp(argv[1],"?"))))
    {
     puts("Usage: NoGuru {off|test|new}");
    }
   else
    {
     if((argv>2)&&(!(strcmp(argv[1],"test"))))
      {
       SetFunction(SysBase,ALERT_OFFSET,&LED);
       Alert(0,0);
       new=TRUE;
      }

     if((argv>2)&&(!(strcmp(argv[1],"new"))))
       new=TRUE;

     if((argv>2)&&(!(strcmp(argv[1],"off"))))
       off=TRUE;
    
     GuruRes=OpenResource("guru.resource",0L);
     if((GuruRes)&&(!new))
      {
       if(!off)
         puts("NoGuru already installed!");
       else
        {
         Signal(GuruRes->NoGuruTask,GuruRes->NoGuruSignalMask);
        }
      }
     else if(!off)
      {
       GuruResource.OldAlertHandler=GetFunction(SysBase,ALERT_OFFSET);
       i=AllocSignal(-1L);
       if(i!=-1L)
        {
         GuruResource.NoGuruTask=SysBase->ThisTask;
         GuruResource.NoGuruSignalMask=(1L<<i);
         SumLibrary(&GuruResource);
         AddResource(&GuruResource);
         InitNewAlert();
         SetFunction(SysBase,ALERT_OFFSET,&AlertHandler);
         puts("MultiDesktop NoGuru installed!");

         i=Wait(GuruResource.NoGuruSignalMask);
         SetFunction(SysBase,ALERT_OFFSET,GuruResource.OldAlertHandler);
         RemResource(&GuruResource);
         puts("MultiDesktop NoGuru removed!");
        }
      }
    }
   CloseLibrary(MultiDesktopBase);
  }
 else
   puts("Unable to open multidesktop.library!");
}

/* ---- Assembler-Teil */
#asm
   public _AlertHandler
   public _AlertHandlerEnd
   public _OldAlertAddress
   public _LED

 ; ***** Beginn des Alert-Handlers *****************************************
_AlertHandler:
   movem.l d0-d6/a0-a6,-(sp)          ; Alert nach MultiDesktop umleiten
   move.l  d7,-(sp)
   jsr _CheckAlert(pc)
   addq.w #4,sp
   move.l d0,d7                       ; Ergebnis ist Alertnummer oder Null
   movem.l (sp)+,d0-d6/a0-a6

   tst.l d7                           ; Wurde Alert schon bearbeitet?
   beq 1$                             ; Ja -> Zurück

   move.l a3,-(sp)                    ; Exec-Alert() aufrufen
   move.l _OldAlertAddress(pc),a3
   jsr (a3)
   move.l (sp)+,a3

1$:                                   ; Zurück zur Applikation
   rts

_LED:
   bchg #1,$bfe001
   rts

_OldAlertAddress:
   dc.l 0
_AlertHandlerEnd:
 ; ***** Ende des Alert-Handlers *******************************************

 ; ---- Alte Adresse initialisieren
   public _InitNewAlert

_InitNewAlert:
   move.l $4,a0
   move.l -106(a0),d0
   lea _OldAlertAddress(pc),a0
   move.l d0,(a0)
   rts
#endasm

/* ---- MagicID testen, bei MultiDesktop-Task zu Guru() verzweigen */
ULONG CheckAlert(guru)
 ULONG guru;
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 if(mu->MagicID!=MAGIC_ID) return(guru);

 SetGuru(guru);
 Guru();
 return(0);
}

