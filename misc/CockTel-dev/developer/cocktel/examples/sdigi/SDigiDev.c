/*******************************************************************
 $CRT 04 Feb 1996 : hb

 $AUT Holger Burkarth
 $DAT >>SDigiDev.c<<   22 Jun 1996    08:39:40 - (C) ProDAD
*******************************************************************/

/*\
*** ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG
***
*** Der folgende Source-Code ist ein unbearbeitetes Experiment aus
*** den proDAD Labors und soll nur der Veranschauung dienen.
***
*** ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG  ACHTUNG
\*/


// ASSIGN ABC: ci:_Projekte/Tiny/ComDev
// mcpp:cppc -gs cisys:Device/Std/Std.o -o df4:sdigi.device abc:SDigiDev.c abc:sdigidevA.o -l amiga -l debug

/***************************************************************************
Main2                 MyOpen                MyClose
myExpunge             MyBeginIO             MyAbortIO
StartTimer            FindFreeTimer         TryTimer
***************************************************************************/

#include "grund/inc.h"
#include "grund/inc_string.h"
#include "inc_cpp/linkerfunc.h"
#include "ABC:SDigiDev.h"

//#define __WWW(a) a;
#define __WWW(a) ;


#ifdef __cplusplus
 extern "C" {
#endif

 #include <exec/resident.h>
 #include <exec/devices.h>
 #include <exec/io.h>
 #include <exec/errors.h>
 #include <exec/interrupts.h>
 #include <hardware/cia.h>
 #include <resources/cia.h>


 #ifndef  CLIB_EXEC_PROTOS_H
 #include <clib/exec_protos.h>
 #include <pragmas/exec_lib.h>
 #endif
 #ifndef  CLIB_ALIB_PROTOS_H
 #include <clib/alib_protos.h>
 #endif
 #ifndef  CLIB_CIA_PROTOS_H
 #include <clib/cia_protos.h>
 #include <pragmas/cia_lib.h>
 #endif


  struct HB_Device;
  struct HB_SDigiIO;


  BOOL TryTimer(HB_Device*);
  BOOL FindFreeTimer(HB_Device*);
  VOID StartTimer(HB_Device*);

  VOID IntPort();
  VOID InterruptFunc();


  VOID Main(VOID);
  SLONG myOpen(register __a6 HB_Device*,register __a1 struct HB_SDigiIO*,
                     register __d0 ULONG Unit);
  SLONG myClose(register __a6 HB_Device*,register __a1 struct HB_SDigiIO*);
  SLONG myExpunge(register __a6 HB_Device*);
  SLONG myNull(register __a6 HB_Device*);
  SLONG myBeginIO(register __a6 HB_Device*,register __a1 struct HB_SDigiIO*);
  SLONG myAbortIO(register __a6 HB_Device*,register __a1 struct HB_SDigiIO*);
  schck_t Main2(HB_Device*);

  extern ULONG _SegList;

#ifdef __cplusplus
 }
#endif


struct HB_Device
{
  struct Library     dev_Lib;
  struct HB_SDigiIO *dev_ActIO;
  struct List        dev_IOList;

  struct CIA        *dev_Cia;
  UBYTE             *dev_Ciacr;
  UBYTE             *dev_CiaLo;
  UBYTE             *dev_CiaHi;
  UBYTE              dev_StopMask;
  UBYTE              dev_StartMask;

  struct Interrupt   dev_Interrupt;
  struct Library    *dev_CiaBase;
  ULONG              dev_TimerBit;
};


#define STOPA_AND  CIACRAF_TODIN | CIACRAF_PBON | CIACRAF_OUTMODE | CIACRAF_SPMODE
#define STOPB_AND  CIACRBF_ALARM | CIACRBF_PBON | CIACRBF_OUTMODE
#define STARTA_OR  CIACRAF_START
#define STARTB_OR  CIACRBF_START

struct CIA *ciaa = (struct CIA *)0xbfe001;
struct CIA *ciab = (struct CIA *)0xbfd000;
struct Library *CiaBase;


struct InitTable {
  ULONG    it_DataSize;          /* library data space size                */
  VOID     **it_FuncTable;       /* table of entry points                  */
  VOID     *it_DataInit;         /* table of data initializers             */
  VOID     (*it_InitFunc)(VOID); /* initialization function to run */
};

extern struct InitTable initTable;
extern VOID   *libfunctab[];



/*----------------------------------
 Dummy-Funktion zum Verlassen des Progs mit Returncode -1
-----------------------------------*/
SLONG FirstFunc() { return -1;}


static ULONG DummyTabelle=0;
const CHAR DeviceName[]  ="sdigi.device";
const CHAR DeviceIDName[]="sdigi.device 1.1 ("__DATE2__") (Copyright 1996 by proDAD) (Created by Holger Burkarth)";

/*----------------------------------
-----------------------------------*/
struct InitTable initTable={
  sizeof(HB_Device),
  libfunctab,
  (VOID*)&DummyTabelle,
  Main,
};


VOID *libfunctab[] = {
  myOpen, myClose, myExpunge, myNull,

  myBeginIO,
  myAbortIO,

  (VOID*)-1
};


/*************************************************************************/


/*----------------------------------
-----------------------------------*/
schck_t Main2(HB_Device *MyBase)
{
  GetBaseReg();
  InitModules();

  MyBase->dev_Lib.lib_Node.ln_Type = NT_DEVICE;
  MyBase->dev_Lib.lib_Node.ln_Name = (CHAR*)DeviceName;
  MyBase->dev_Lib.lib_Flags        = LIBF_SUMUSED | LIBF_CHANGED;
  MyBase->dev_Lib.lib_Version      = 1;
  MyBase->dev_Lib.lib_Revision     = 1;
  MyBase->dev_Lib.lib_IdString     = (CHAR*)DeviceIDName;

  NewList(&MyBase->dev_IOList);

  MyBase->dev_Interrupt.is_Node.ln_Type = NT_INTERRUPT;
  MyBase->dev_Interrupt.is_Node.ln_Name = "sdigi.device";
  MyBase->dev_Interrupt.is_Node.ln_Pri  = 0;
  MyBase->dev_Interrupt.is_Code         = InterruptFunc;
  MyBase->dev_Interrupt.is_Data         = (APTR)MyBase;

  return(TRUE);
}




/*----------------------------------
-----------------------------------*/
SLONG MyOpen(HB_Device *dev,struct HB_SDigiIO *io,ULONG unitNr)
{
  if(unitNr>0) io->io_Error=IOERR_OPENFAIL;
  else {
    io->io_Frquence=701000;  //707000;
    io->io_MinBPS=3000;
    io->io_MaxBPS=9000;

    dev->dev_Lib.lib_OpenCnt++;
    dev->dev_Lib.lib_Flags &= ~LIBF_DELEXP;
    io->io_Error=0;
    if(dev->dev_Lib.lib_OpenCnt==1) {
      if(FindFreeTimer(dev)) {
        StartTimer(dev);
        IntPort();
        Disable();
        *dev->dev_Ciacr &= dev->dev_StopMask;
        Enable();
      }
      else {
        dev->dev_Lib.lib_OpenCnt=0;
        io->io_Error=IOERR_UNITBUSY;
      }
    }
  }
__WWW( kprintf("sdigi.device-Open %ld\n",io->io_Error) );
  return(io->io_Error);
}


SLONG myOpen(register __a6 HB_Device *myBase,register __a1 struct HB_SDigiIO *_io,
             register __d0 ULONG unitNr)
{
  return( MyOpen(myBase,_io,unitNr));
}


/*----------------------------------
-----------------------------------*/
SLONG MyClose(HB_Device *dev,struct HB_SDigiIO *io)
{
  SLONG retval = 0;

// *********** Schutzmechanismus
  io->io_Unit  =(struct Unit*)-1;
  io->io_Device=(struct Device*)-1;

  if(--dev->dev_Lib.lib_OpenCnt == 0) {
    if(dev->dev_TimerBit!=-1) {
      Disable();
      *dev->dev_Ciacr &= dev->dev_StopMask;
      Enable();
      RemICRVector(dev->dev_TimerBit,&dev->dev_Interrupt);
    }

    if(dev->dev_Lib.lib_Flags & LIBF_DELEXP) {
      retval = myExpunge(dev);
    }
  }
__WWW( kprintf("sdigi.device-Close\n") );
  return(retval);
}

SLONG myClose(register __a6 HB_Device *myBase,register __a1 struct HB_SDigiIO *_io)
{
  return(MyClose(myBase,_io));
}


/*----------------------------------
-----------------------------------*/
SLONG myExpunge(register __a6 HB_Device *myBase)
{
  ULONG seglist = 0;

  HB_Device *const MyBase=myBase;

  if(MyBase->dev_Lib.lib_OpenCnt == 0) {
    seglist = _SegList;
    ::Remove((struct Node*)MyBase);

    const SLONG libsize=(SLONG)MyBase->dev_Lib.lib_NegSize + MyBase->dev_Lib.lib_PosSize;
    ::FreeMem((char*)MyBase - MyBase->dev_Lib.lib_NegSize, libsize);

    CleanupModules();
  }
  else MyBase->dev_Lib.lib_Flags |= LIBF_DELEXP;

__WWW( kprintf("sdigi.device-Expunge %lx\n",seglist) );
  return((SLONG)seglist);
}


/*----------------------------------
-----------------------------------*/
SLONG myNull(register __a6 HB_Device *MyBase) { return(0); }



/*----------------------------------
-----------------------------------*/
SLONG MyBeginIO(HB_Device *dev,struct HB_SDigiIO *io)
{
  if(io->io_Command==CMD_READ) {
    io->io_Flags &= ~IOF_QUICK;
    io->io_Message.mn_Node.ln_Type=NT_MESSAGE; // *** wird bearbeitet

    io->io_Error=0;
    io->io_Actual=0;

__WWW( kprintf("sdigi.device-BeginIO<%lx> dev_ActIO=%lx Adr=%lx Len=%ld\n",
       io,dev->dev_ActIO,io->io_Data,io->io_Length) );
    Disable();
    if(dev->dev_ActIO) {
      AddTail(&dev->dev_IOList,&io->io_Message.mn_Node);
    }
    else {
__WWW( kprintf("sdigi.device-BeginIO Time=%ld\n",io->io_MicroDelay) );
      dev->dev_ActIO=io;
      *dev->dev_Ciacr &= dev->dev_StopMask;
      *dev->dev_CiaLo  = io->io_MicroDelay;
      *dev->dev_CiaHi  = io->io_MicroDelay>>8;
      *dev->dev_Ciacr |= dev->dev_StartMask;
    }
    Enable();
  }
  else {
__WWW( kprintf("sdigi.device-BeginIO  unkown command\n",io->io_Command) );

    io->io_Error=IOERR_NOCMD;
    if(!(io->io_Flags & IOF_QUICK)) ReplyMsg(&io->io_Message);
  }

  return(io->io_Error);
}

SLONG myBeginIO(register __a6 HB_Device *myBase,register __a1 struct HB_SDigiIO *_io)
{
  return( MyBeginIO(myBase,_io) );
}


/*----------------------------------
-----------------------------------*/
SLONG MyAbortIO(HB_Device *dev,struct HB_SDigiIO *io)
{
__WWW( kprintf("sdigi.device-AbortIO<%lx>\n",io) );

  Disable();
  io->io_Error=IOERR_ABORTED;

  if(dev->dev_ActIO==io) {
    if(!(dev->dev_ActIO=(HB_SDigiIO*)RemHead(&dev->dev_IOList))) {
      *dev->dev_Ciacr &= dev->dev_StopMask;
    }
  }
  else if(io->io_Message.mn_Node.ln_Type==NT_MESSAGE) {
    Remove(&io->io_Message.mn_Node);
  }
  Enable();
  ReplyMsg(&io->io_Message);

  return(io->io_Error);
}

SLONG myAbortIO(register __a6 HB_Device *myBase,register __a1 struct HB_SDigiIO *_io)
{
  return(MyAbortIO(myBase,_io));
}



/*************************************************************************/

/*----------------------------------
-----------------------------------*/
VOID StartTimer(HB_Device* dev)
{
  struct CIA *cia;

  cia = dev->dev_Cia;

  if(dev->dev_TimerBit == CIAICRB_TA) {
    dev->dev_Ciacr = &cia->ciacra;    /* control register A   */
    dev->dev_CiaLo = &cia->ciatalo;   /* low byte counter     */
    dev->dev_CiaHi = &cia->ciatahi;   /* high byte counter    */

    dev->dev_StopMask  = STOPA_AND;   /* set-up mask values   */
    dev->dev_StartMask = STARTA_OR;
  }
  else {
    dev->dev_Ciacr = &cia->ciacrb;     /* control register B   */
    dev->dev_CiaLo = &cia->ciatblo;    /* low byte counter     */
    dev->dev_CiaHi = &cia->ciatbhi;    /* high byte counter    */

    dev->dev_StopMask  = STOPB_AND;    /* set-up mask values   */
    dev->dev_StartMask = STARTB_OR;
  }
}



/*----------------------------------
-----------------------------------*/
BOOL FindFreeTimer(HB_Device* dev)
{
  struct CIABase *ciaabase, *ciabbase;

  ciaabase =(CIABase*)OpenResource(CIAANAME);

  dev->dev_CiaBase =(Library*)ciaabase; /* library address  */
  dev->dev_Cia     = ciaa;              /* hardware address */

  CiaBase=dev->dev_CiaBase;
  if(TryTimer(dev)) return(TRUE);



  ciabbase =(CIABase*)OpenResource(CIABNAME);

  dev->dev_CiaBase =(Library*)ciabbase; /* library address  */
  dev->dev_Cia     = ciab;              /* hardware address */

  CiaBase=dev->dev_CiaBase;
  if(TryTimer(dev)) return(TRUE);


  return(FALSE);
}



/*----------------------------------
-----------------------------------*/
BOOL TryTimer(HB_Device *dev)
{
  if(!(AddICRVector(CIAICRB_TA,&dev->dev_Interrupt))) {
    dev->dev_TimerBit = CIAICRB_TA;
    return(TRUE);
  }
  if(!(AddICRVector(CIAICRB_TB,&dev->dev_Interrupt))) {
    dev->dev_TimerBit = CIAICRB_TB;
    return(TRUE);
  }
  dev->dev_TimerBit=-1;
  return(FALSE);
}




