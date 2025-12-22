/* MultiDesktop-Library, Fehlerbehandlung, Break, Programmende */
#include <exec/alerts.h>
#include "multidesktop.h"

struct GuruEntry
{
 ULONG  Number;
 UBYTE *Text;
};

struct GuruEntry GuruList[]=
{
 {0x00000002,"7:Bus Error"},
 {0x00000003,"8:Address Error"},
 {0x00000004,"9:Illegal Instruction"},
 {0x00000005,"10:Divide by Zero"},
 {0x00000006,"11:CHK Instruction"},
 {0x00000007,"12:TRAPV Instruction"},
 {0x00000008,"13:Privilege Violation"},
 {0x00000009,"14:Trace"},
 {0x0000000A,"15:Axxx Instruction"},
 {0x0000000B,"16:Fxxx Instruction"},
 {0x01000009,"Exec: Memory freed twice"},
 {0x01000005,"Exec: Corrupt memory list"},
 {0x0100000F,"Exec: Bad FreeMem() address"},
 {0x00000000,NULL}
};

struct GuruEntry GuruANList[]=
{
 {AN_ExecLib,     "Exec Library"},
 {AN_GraphicsLib, "Graphics Library"},
 {AN_Intuition,   "Intuition Library"},
 {AN_LayersLib,   "Layers Library"},
 {AN_MathLib,     "Math Libraries"},
 {AN_DOSLib,      "DOS Library"},
 {AN_RAMLib,      "Ramlib Library"},
 {AN_IconLib,     "Icon Library"},
 {AN_ExpansionLib,"Expansion Library"},
 {AN_DiskfontLib, "Diskfont Library"},
 {AN_UtilityLib,  "Utility Library"},
 {AN_AudioDev,    "Audio Device"},
 {AN_ConsoleDev,  "Console Device"},
 {AN_GamePortDev, "Gameport Device"},
 {AN_KeyboardDev, "Keyboard Device"},
 {AN_TrackDiskDev,"Trackdisk Device"},
 {AN_TimerDev,    "Timer Device"},
 {AN_CIARsrc,     "CIA Resource"},
 {AN_DiskRsrc,    "Disk Resource"},
 {AN_Workbench,   "Workbench"},
 {AN_GadTools,    "GadTools Library"},
 {AN_Unknown,     "Unknown"},
 {0x00000000,NULL}
};

struct GuruEntry GuruAGList[]=
{
 {AG_NoMemory,  "No memory"},
 {AG_MakeLib,   "Make library"},
 {AG_OpenLib,   "Open library"},
 {AG_OpenDev,   "Open device"},
 {AG_OpenRes,   "Open resource"},
 {AG_IOError,   "IO error"},
 {AG_NoSignal,  "No signal"},
 {AG_BadParm,   "Bad parameter"},
 {AG_CloseLib,  "Close library"},
 {AG_CloseDev,  "Close device"},
 {AG_ProcCreate,"Process creation"},
 {0x00000000,NULL}
};

struct GuruEntry GuruAOList[]=
{
 {AO_ExecLib,     "Exec Library"},
 {AO_GraphicsLib, "Graphics Library"},
 {AO_Intuition,   "Intuition Library"},
 {AO_LayersLib,   "Layers Library"},
 {AO_MathLib,     "Math Libraries"},
 {AO_DOSLib,      "DOS Library"},
 {AO_RAMLib,      "Ramlib Library"},
 {AO_IconLib,     "Icon Library"},
 {AO_ExpansionLib,"Expansion Library"},
 {AO_DiskfontLib, "Diskfont Library"},
 {AO_UtilityLib,  "Utility Library"},
 {AO_AudioDev,    "Audio Device"},
 {AO_ConsoleDev,  "Console Device"},
 {AO_GamePortDev, "Gameport Device"},
 {AO_KeyboardDev, "Keyboard Device"},
 {AO_TrackDiskDev,"Trackdisk Device"},
 {AO_TimerDev,    "Timer Device"},
 {AO_CIARsrc,     "CIA Resource"},
 {AO_DiskRsrc,    "Disk Resource"},
 {AO_Workbench,   "Workbench"},
 {AO_GadTools,    "GadTools Library"},
 {AO_Unknown,     "Unknown"},
 {0000000000,NULL}
};

extern struct MultiDesktopBase *MultiDesktopBase;
extern struct ExecBase         *SysBase;
extern APTR                     MultiDesktopTrap;
extern APTR                     MultiDesktopException;
struct Catalog                 *Catalog;

/* ---- Startup */
void DesktopStartup(wbStartup,flags)
 struct WBStartup *wbStartup;
 UWORD             flags;
{
 UWORD                    signals;
 struct MultiDesktopUser *mu;
 struct Task             *task;

 task=SysBase->ThisTask;
 mu=task->tc_UserData;
 mu->WBStartup=wbStartup;

 if(flags & STARTUP_TRAPHANDLER)
  {
   mu->OldTrapHandler=task->tc_TrapCode;
   task->tc_TrapCode=&MultiDesktopTrap;
   task->tc_TrapData=0;
  }

 if((flags & STARTUP_BREAKHANDLER_ON)||(flags & STARTUP_BREAKHANDLER_OFF))
  {
   signals=0;
   if(flags & STARTUP_BREAKHANDLER_D) signals |= SIGBREAKF_CTRL_D;
   if(flags & STARTUP_BREAKHANDLER_E) signals |= SIGBREAKF_CTRL_E;
   if(flags & STARTUP_BREAKHANDLER_F) signals |= SIGBREAKF_CTRL_F;
   if((flags & STARTUP_BREAKHANDLER_C)||(signals==0)) signals |= SIGBREAKF_CTRL_C;

   if(flags & STARTUP_BREAKHANDLER_ON)  mu->BreakControl=0xffff;
   mu->OldExceptHandler=task->tc_ExceptCode;
   task->tc_ExceptCode=&MultiDesktopException;
   task->tc_ExceptData=0;
   SetExcept(signals,0xffffffff);
  }

 if(flags & STARTUP_ALERTHANDLER)
  {
   mu->AlertControl=0xffff;
  }
}

/* ---- Exit */
void DesktopExit()
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 if(mu->OldTrapHandler)
   SysBase->ThisTask->tc_TrapCode=mu->OldTrapHandler;
 if(mu->OldExceptHandler)
  {
   SetExcept(0,0xffffffff);
   SysBase->ThisTask->tc_ExceptCode=mu->OldExceptHandler;
  }
}

/* ---- User komplett terminieren */
void TerminateTask(task)
 struct Task *task;
{
 struct MultiDesktopUser *mu;

 if(task==NULL) task=SysBase->ThisTask;
 mu=task->tc_UserData;
 if(mu!=NULL)
  {
   if(mu->TermProcedure) mu->TermProcedure();
   if(mu->SysTermProcedure) mu->SysTermProcedure();

/*
   mu=task->tc_UserData;
   if(mu)  * MultiDesktop noch offnen, weitere Schritte erforderlich *
    {

    }
*/
  }
}

/* ---- Programm terminieren */
void Terminate(result)
{
 TerminateTask(NULL);
 Exit(result);
}

/* ---- Fehlerprozedur festlegen */
void SetSysTermProcedure(proc)
 void (*proc)();
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 mu->SysTermProcedure=proc;
}

/* ---- Fehlerprozedur ermitteln */
APTR GetTermProcedure()
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 return(mu->TermProcedure);
}

/* ---- Fehlerprozedur ermitteln */
APTR GetSysTermProcedure()
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 return(mu->TermProcedure);
}

/* ---- Anzahl der freien Task-Signale ermitteln */
UBYTE AvailSignals(task)
 struct Task *task;
{
 ULONG i;
 UBYTE j;

 if(task==NULL) task=SysBase->ThisTask;
 j=0;
 for(i=0;i<32;i++)
  {
   if(!(task->tc_SigAlloc & (1L<<i))) j++;
  }
 return(j);
}

/* ---- Anzahl der freien Task-Signale ermitteln */
UBYTE AvailTraps(task)
 struct Task *task;
{
 UWORD i;
 UBYTE j;

 if(task==NULL) task=SysBase->ThisTask;
 j=0;
 for(i=0;i<16;i++)
  {
   if(!(task->tc_TrapAlloc & (1L<<i))) j++;
  }
 return(j);
}

/* ---- Fehlercode setzen */
void SetError(error)
 ULONG error;
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 mu->LastError=error;
}

/* ---- Gurucode setzen */
void SetGuru(error)
 ULONG error;
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 mu->LastGuru=error;
}

/* ---- Gurucode ermitteln */
ULONG GetGuru()
{
 struct MultiDesktopUser *mu;
 ULONG                    err;

 mu=SysBase->ThisTask->tc_UserData;
 err=mu->LastGuru;
 mu->LastGuru=0;
 return(err);
}

/* ---- Fehlercode ermitteln */
ULONG GetError()
{
 struct MultiDesktopUser *mu;
 ULONG                    err;

 mu=SysBase->ThisTask->tc_UserData;
 err=mu->LastError;
 mu->LastError=MERR_NoError;
 return(err);
}

/* ---- Fehler bei zu wenig Speicherplatz */
void NoMemory()
{
 ErrorL(0,0);
 SetError(MERR_NoMemory);
}

/* ---- Trap zum Abfangen von Gurus */
#asm
   public _MultiDesktopTrap
_MultiDesktopTrap:
   move.l a0,-(sp)

   move.l $4,a0             ; a0=SysBase
   move.l 276(a0),a0        ; a0=SysBase->ThisTask
   move.l 88(a0),a0         ; a0=SysBase->ThisTask->tc_UserData
   move.l 4(sp),22(a0)      ; a0->LastGuru=GuruCode

   move.l (sp),a0           ; Rücksprungadresse ändern
   addq.l #8,sp
   move.l #.Guru,2(sp)
   rte

DivByZero:                  ; Rücksprung zur Anwendung
   move.l (sp),a0
   addq.l #8,sp
   rte

.Guru:                      ; Task beenden
   jmp _Guru(pc)


 ; ---- Abschnitte aus Guru-Code herausfiltern
   public _GetGuruAN
_GetGuruAN:
   move.l 4(sp),d0
   and.l #%01111111000000000000000000000000,d0
   rts
   public _GetGuruAG
_GetGuruAG:
   move.l 4(sp),d0
   and.l #%00000000111111110000000000000000,d0
   rts
   public _GetGuruAO
_GetGuruAO:
   move.l 4(sp),d0
   and.l #$0000ffff,d0
   rts
#endasm

/* ---- Fehlerprozedur festlegen */
void SetTermProcedure(proc)
 void (*proc)();
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 mu->TermProcedure=proc;
}

/* ---- Guru-Nummer ausgeben und Programm terminieren */
void Guru()
{
 BOOL                     found,recoverable;
 ULONG                    guru,g;
 UBYTE                    text[256];
 UBYTE                    tx2[60];
 struct MultiDesktopUser *mu;
 long                     i;

 guru=GetGuru();
 mu=SysBase->ThisTask->tc_UserData;
 if(guru)
  {
   if((guru>=0x20)&&(guru<=0x2F))
    {
     sprintf(&text,FindID(Catalog,"21:Program halted!\nTrap #%ld"),guru-0x20);
     ErrorRequest("20:Trap Instruction!",&text,"18:Terminate!");
    }
   else
    {
     if((guru & AT_DeadEnd)||(guru<0x20))
      {
       recoverable=FALSE;
       sprintf(&text,FindID(Catalog,"19:Unrecoverable error in application!\nGuru #%08lx"),guru);
      }
     else
      {
       recoverable=TRUE;
       sprintf(&text,FindID(Catalog,"25:Recoverable error in application!\nGuru #%08lx"),guru);
       SetGuru(guru);
      }

     guru &= ~AT_DeadEnd;
     found=FALSE; i=0; strcpy(&tx2,"");
     while(GuruList[i].Text!=NULL)
      {
       if(GuruList[i].Number==guru)
        {
         sprintf(&tx2," (%s)",FindID(Catalog,GuruList[i].Text));
         strcat(&text,&tx2);
         found=TRUE;
        }
       i++;
      }

     if(found==FALSE)
      {
       i=0; g=GetGuruAN(guru);
       while(GuruANList[i].Text!=NULL)
        {
         if(GuruANList[i].Number==g)
          {
           sprintf(&tx2,"\nSubsystem: %s",GuruANList[i].Text);
           strcat(&text,&tx2);
          }
         i++;
        }

       i=0; g=GetGuruAG(guru);
       while(GuruAGList[i].Text!=NULL)
        {
         if(GuruAGList[i].Number==g)
          {
           sprintf(&tx2,"\nGeneral: %s",GuruAGList[i].Text);
           strcat(&text,&tx2);
          }
         i++;
        }

       i=0; g=GetGuruAO(guru);
       while(GuruAOList[i].Text!=NULL)
        {
         if(GuruAOList[i].Number==g)
          {
           sprintf(&tx2,"\nObject: %s",GuruAOList[i].Text);
           strcat(&text,&tx2);
          }
         i++;
        }
      }

     if(!recoverable)
       i=ErrorRequest("17:Software error!",&text,"18:Terminate!");
     else
      {
       i=ErrorRequest("17:Software error!",&text,"23:Continue!|Terminate!");
       if(i==1) return;
      }
    }
  }
 Terminate(RETURN_FAIL);
}

/* ---- Programm anhalten */
void Halt()
{
 ErrorRequest("Halt()","22:Program haltet.","18:Terminate!");
 Terminate(0);
}

/* ---- Programm anhalten */
void Pause()
{
 LONG i;

 i=ErrorRequest("Pause()","22:Program haltet.","23:Continue!|Terminate!");
 if(i==0) Terminate(0);
}

/* ---- Exception für CTRL-C/D/E/F */
#asm
   public _MultiDesktopException
_MultiDesktopException:
   move.l d0,-(sp)
   jsr _Break(pc)
   move.l (sp)+,d0
   rts
#endasm

/* ---- Break */
void Break(signals)
 ULONG signals;
{
 UBYTE                    str[60];
 LONG                     i;
 UBYTE                    chr;
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 if(mu->BreakControl==0) return;

 if(signals & SIGBREAKF_CTRL_C) chr='C';
 else if(signals & SIGBREAKF_CTRL_D) chr='D';
 else if(signals & SIGBREAKF_CTRL_E) chr='E';
 else if(signals & SIGBREAKF_CTRL_F) chr='F';
 sprintf(&str,FindID(Catalog,"24:<Control>-<%c> detected!"),chr);
 i=ErrorRequest("Break()",&str,"23:Continue!|Terminate!");
 if(i==0) Terminate(0);
}

/* ---- Break einschalten */
void BreakOn()
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 mu->BreakControl=0xffff;
}

/* ---- Break einschalten */
void BreakOff()
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 mu->BreakControl=0;
}
