/*******************************************************************
 $CRT 09 Jul 1996 : hb

 $AUT Holger Burkarth
 $DAT >>VLabDigiDev.c<<   19 Jul 1996    12:58:04 - (C) ProDAD
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
// mcpp:cppc -gs cisys:Device/Std/Std.o -o df4:vlabdigi.device abc:vlabDigiDev.c abc:vlab_Convert.s.o -l amiga -l debug

/***************************************************************************
Main2                 MyOpen                MyClose
myExpunge             MyBeginIO             MyAbortIO
***************************************************************************/

#include "grund/inc.h"
#include "grund/inc_string.h"
#include "inc_cpp/linkerfunc.h"
#include "ABC:VDigiDev.h"



//#define __WWW(a) a;
#define __WWW(a) ;



extern "C" {
 #include <exec/resident.h>
 #include <exec/devices.h>
 #include <exec/io.h>
 #include <exec/errors.h>
 #include <exec/interrupts.h>


 #ifndef  CLIB_EXEC_PROTOS_H
 #include <clib/exec_protos.h>
 #include <pragmas/exec_lib.h>
 #endif
 #ifndef  CLIB_ALIB_PROTOS_H
 #include <clib/alib_protos.h>
 #endif
 #ifndef  CLIB_DOS_PROTOS_H
 #include <clib/dos_protos.h>
 #include <pragmas/dos_lib.h>
 #endif
 #ifndef  CLIB_INTUITION_PROTOS_H
 #include <clib/intuition_protos.h>
 #include <pragmas/intuition_lib.h>
 #endif
 #include <intuition/intuition.h>
 #include <dos/dos.h>
 #include <dos/dostags.h>
 #include <dos/rdargs.h>
 #include <exec/memory.h>


  struct HB_Device;

  VOID Main(VOID);
  SLONG myOpen(register __a6 HB_Device*,register __a1 struct HB_VDigiIO*,
                     register __d0 ULONG Unit);
  SLONG myClose(register __a6 HB_Device*,register __a1 struct HB_VDigiIO*);
  SLONG myExpunge(register __a6 HB_Device*);
  SLONG myNull(register __a6 HB_Device*);
  SLONG myBeginIO(register __a6 HB_Device*,register __a1 struct HB_VDigiIO*);
  SLONG myAbortIO(register __a6 HB_Device*,register __a1 struct HB_VDigiIO*);
  schck_t Main2(HB_Device*);

  extern ULONG _SegList;
}


struct VLabLibrary
{
  struct Library Lib;
  WORD    vlb_MaxWidth;
  WORD    vlb_MaxHeightPAL;
  WORD    vlb_MaxHeightNTSC;
  WORD    vlb_InputsPerBoard;
  WORD    vlb_RatioYUV;
  ULONG   vlb_HardInfo;
};



struct Library* VLabBase;



VOID VLab_Custom(ULONG reg,ULONG value);
ULONG VLab_Scan(UBYTE* bufferY,UBYTE* bufferU,UBYTE* bufferV,ULONG x1,ULONG y1,ULONG x2,ULONG y2);
VOID VLab_YUVtoRGB(UBYTE* bufferY,UBYTE* bufferU,UBYTE* bufferV,UBYTE* bufferRGB,ULONG size,ULONG mode);
ULONG VLab_Error();

#pragma amicall(VLabBase, 0x1e, VLab_Custom(d0,d1))
#pragma amicall(VLabBase, 0x24, VLab_Scan(a0,a1,a2,d0,d1,d2,d3))
#pragma amicall(VLabBase, 0x2a, VLab_YUVtoRGB(a0,a1,a2,a3,d0,d1))
#pragma amicall(VLabBase, 0x30, VLab_Error())
//#pragma amicall(VLabBase, 0x3c, VLab_DeInterlace(a0,d0,d1,d2,d3,d4,d5))
//#pragma amicall(VLabBase, 0x48, VLab_CountInputs())
//#pragma amicall(VLabBase, 0x4e, VLab_InputAvailable(d0))



ULONG EReq(const CHAR* titel,const CHAR* but);
struct RDArgs* ReadArgsFile(const CHAR* fileName,const CHAR* temp,ULONG* arg);



struct HB_Device
{
  struct Library     dev_Lib;
  struct HB_VDigiIO *dev_ActIO;
  struct SignalSemaphore dev_Sem;
  ULONG Ops[4];
  UBYTE VideoChannel;
};


const CHAR *Template=
// 0     1      2
"VTR/S,PAL/S,INPUT/N/K";


VOID x_Open();
VOID x_Close();
VOID GetFrame(struct HB_VDigiIO*);



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
const CHAR DeviceName[]  ="vlabdigi.device";
const CHAR DeviceIDName[]="vlabdigi.device 1.0 ("__DATE2__") (Copyright 1996 by proDAD) (Created by Holger Burkarth)";

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
  InitSemaphore(&MyBase->dev_Sem);

  MyBase->dev_Lib.lib_Node.ln_Type = NT_DEVICE;
  MyBase->dev_Lib.lib_Node.ln_Name = (CHAR*)DeviceName;
  MyBase->dev_Lib.lib_Flags        = LIBF_SUMUSED | LIBF_CHANGED;
  MyBase->dev_Lib.lib_Version      = 1;
  MyBase->dev_Lib.lib_Revision     = 1;
  MyBase->dev_Lib.lib_IdString     = (CHAR*)DeviceIDName;

  x_Open();

  if(VLabBase) {
    struct RDArgs* RDA=ReadArgsFile("ENV:Videofon/VLabDigi.config",Template,MyBase->Ops);
    if(RDA) {
      VLab_Custom(3,MyBase->Ops[0]);  // VLREG_VTR
      VLab_Custom(4,MyBase->Ops[1]);  // VLREG_PAL
      if(MyBase->Ops[2]) MyBase->VideoChannel=*((ULONG*)MyBase->Ops[2]);
      else               MyBase->VideoChannel=0;

      FreeArgs(RDA);
    }
  }
  else EReq("Cannot open vlab.library version 7","Ok");

  return( VLabBase!=NULL );
}




/*----------------------------------
-----------------------------------*/
SLONG MyOpen(HB_Device *dev,struct HB_VDigiIO *io,ULONG unitNr)
{
  if(unitNr>0) io->io_Error=IOERR_OPENFAIL;
  else {
    dev->dev_Lib.lib_OpenCnt++;
    dev->dev_Lib.lib_Flags &= ~LIBF_DELEXP;
    io->io_Error=0;
  }
__WWW( kprintf("vdigi.device-Open %ld\n",io->io_Error) );
  return(io->io_Error);
}


SLONG myOpen(register __a6 HB_Device *myBase,register __a1 struct HB_VDigiIO *_io,
             register __d0 ULONG unitNr)
{
  return( MyOpen(myBase,_io,unitNr));
}


/*----------------------------------
-----------------------------------*/
SLONG MyClose(HB_Device *dev,struct HB_VDigiIO *io)
{
  SLONG retval = 0;

// *********** Schutzmechanismus
  io->io_Unit  =(struct Unit*)-1;
  io->io_Device=(struct Device*)-1;

  if(--dev->dev_Lib.lib_OpenCnt == 0) {
    if(dev->dev_Lib.lib_Flags & LIBF_DELEXP) {
      retval = myExpunge(dev);
    }
  }
__WWW( kprintf("vdigi.device-Close\n") );
  return(retval);
}

SLONG myClose(register __a6 HB_Device *myBase,register __a1 struct HB_VDigiIO *_io)
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

    x_Close();
    CleanupModules();
  }
  else MyBase->dev_Lib.lib_Flags |= LIBF_DELEXP;

__WWW( kprintf("vdigi.device-Expunge %lx\n",seglist) );
  return((SLONG)seglist);
}


/*----------------------------------
-----------------------------------*/
SLONG myNull(register __a6 HB_Device *MyBase) { return(0); }



/*----------------------------------
-----------------------------------*/
SLONG MyBeginIO(HB_Device *dev,struct HB_VDigiIO *io)
{
  if(io->io_Command==CMD_READ) {
    io->io_Flags &= ~IOF_QUICK;
    io->io_Message.mn_Node.ln_Type=NT_MESSAGE; // *** wird bearbeitet

    io->io_Error=0;
    io->io_Actual=0;

__WWW( kprintf("vdigi.device-BeginIO<%lx> dev_ActIO=%lx Adr=%lx Len=%ld\n",
       io,dev->dev_ActIO,io->io_Data,io->io_Length) );

    ObtainSemaphore(&dev->dev_Sem);
    GetFrame(io);
    ReleaseSemaphore(&dev->dev_Sem);
    ReplyMsg(&io->io_Message);
  }
  else if(io->io_Command==CMDVDIGI_ASK) {
    switch(io->io_DigiType) {
      case VDIGI_BW:
      case VDIGI_RGB:
      case VDIGI_YUV411:
        io->io_Error=0;
        if(io->io_Width<320) {
          io->io_Width =128;
          io->io_Height=94;
        }
        else {
          io->io_Width =704;
          io->io_Height=248;
        }
        break;

      default:
        io->io_Error=IOERR_UnknownDType;
    }

    if(!(io->io_Flags & IOF_QUICK)) ReplyMsg(&io->io_Message);
  }
  else {
__WWW( kprintf("vdigi.device-BeginIO  unkown command\n",io->io_Command) );

    io->io_Error=IOERR_NOCMD;
    if(!(io->io_Flags & IOF_QUICK)) ReplyMsg(&io->io_Message);
  }


  return(io->io_Error);
}

SLONG myBeginIO(register __a6 HB_Device *myBase,register __a1 struct HB_VDigiIO *_io)
{
  return( MyBeginIO(myBase,_io) );
}


/*----------------------------------
-----------------------------------*/
SLONG MyAbortIO(HB_Device *dev,struct HB_VDigiIO *io)
{
__WWW( kprintf("vdigi.device-AbortIO<%lx>\n",io) );

#ifdef xxxxxxxxxxxx
  Forbid();
  io->io_Error=IOERR_ABORTED;

  if(dev->dev_ActIO==io) {
  }
  else if(io->io_Message.mn_Node.ln_Type==NT_MESSAGE) {
    Remove(&io->io_Message.mn_Node);
  }
  Permit();
  ReplyMsg(&io->io_Message);
#endif
  return(io->io_Error);
}

SLONG myAbortIO(register __a6 HB_Device *myBase,register __a1 struct HB_VDigiIO *_io)
{
  return(MyAbortIO(myBase,_io));
}



/*************************************************************************/

ULONG EReq(const CHAR* titel,const CHAR* but)
{
/******
  static struct EasyStruct es;
  es.es_StructSize = sizeof (struct EasyStruct);
  es.es_Flags = 0;
  es.es_Title = NULL;
  es.es_TextFormat = (UBYTE*)titel;
  es.es_GadgetFormat = (UBYTE*)but;
  return(::EasyRequestArgs(NULL,&es, NULL,NULL));
*****/
  return(0);
}


/*----------------------------------
-----------------------------------*/
struct RDArgs* ReadArgsFile(const CHAR* fileName,const CHAR* temp,ULONG* arg)
{
  UBYTE Puffer[200];
  struct RDArgs* RDA;
  BPTR ConfigFile;

  if(RDA=(RDArgs*)AllocDosObject(DOS_RDARGS,NULL)) {
    if(ConfigFile=::Open((CHAR*)fileName,MODE_OLDFILE)) {
      Puffer[0]='#';
      while(::FGets(ConfigFile,Puffer,sizeof(Puffer))) {
        if(Puffer[0]!='#') break;
      }
      ::Close(ConfigFile);
      if(Puffer[0]!='#' && Puffer[0]!='\0') {
        strcat(Puffer,"\n");
        RDA->RDA_Source.CS_Buffer = Puffer;
        RDA->RDA_Source.CS_Length = sizeof(Puffer)-1;
        RDA->RDA_Source.CS_CurChr = 0;

        if(ReadArgs((CHAR*)temp,(SLONG*)arg,RDA)) {
        }
        else {
          sprintf(Puffer,"ReadArgs fails, File=<%s> DosErr=%ld",fileName,IoErr());
          EReq(Puffer,"Ok");
          ::FreeArgs(RDA); RDA=NULL;
        }
      }
    }
    else {
      sprintf(Puffer,"Cannot open file=<%s> DosErr=%ld",fileName,IoErr());
      EReq(Puffer,"Ok");
      ::FreeArgs(RDA); RDA=NULL;
    }
  }

  return(RDA);
}



VOID x_Open()
{
  VLabBase=OpenLibrary((UBYTE*)"vlab.library",7);
}

VOID x_Close()
{
  if(VLabBase) CloseLibrary(VLabBase);
}



extern "C"  VOID YUVHiresToRGBHires(register __a0 UBYTE*,register __a1 UBYTE*,
  register __a2 UBYTE*,register __a3 UBYTE*,register __a4 UBYTE*,
  register __d1 UBYTE*,register __d0 ULONG,register __d2 ULONG y);



VOID GetFrame(struct HB_VDigiIO *io)
{
  HB_Device *const MyBase=(HB_Device*)io->io_Device;

  const ULONG Width =io->io_Width;
  const ULONG Height=io->io_Height;
  VLabLibrary *VLib=(VLabLibrary*)VLabBase;
  const ULONG BufYSize=Width*Height;
  const ULONG BufUSize=(Width/VLib->vlb_RatioYUV)*Height;
  const ULONG BufVSize=BufUSize;

  VLab_Custom(12,MyBase->VideoChannel);
  VLab_Custom(11,0);  // VLREG_SLOWSCAN
  VLab_Custom(10,0);  // VLREG_FULLFRAME

  switch(io->io_DigiType) {
// -----
    case VDIGI_BW:
      {
        Forbid();
        if(io->io_Width==128)
          VLab_Scan(io->io_BW.iobw_L,NULL,NULL,
                  (720-160)/2,(310-100)/2,Width,Height);
        else
          VLab_Scan(io->io_BW.iobw_L,NULL,NULL,8,20,Width,Height);
        Permit();
        if(VLab_Error()) io->io_Error=IOERR_NoVideoSignal;
      }
      break;

// -----
    case VDIGI_RGB:
      {
        UBYTE *BufY=(UBYTE*)AllocMem(BufYSize,0);
        UBYTE *BufU=(UBYTE*)AllocMem(BufUSize,0);
        UBYTE *BufV=(UBYTE*)AllocMem(BufVSize,0);

        if(BufY && BufU && BufV) {
          Forbid();
          if(io->io_Width==128)
            VLab_Scan(BufY,BufU,BufV,(720-160)/2,(310-100)/2,Width,Height);
          else
            VLab_Scan(BufY,BufU,BufV,8,20,Width,Height);
          Permit();
          if(VLab_Error()) io->io_Error=IOERR_NoVideoSignal;
          else {
            YUVHiresToRGBHires(BufY,BufU,BufV,
                  io->io_RGB.iorl_R,io->io_RGB.iorl_G,io->io_RGB.iorl_B,
                  Width,Height);
          }
        }
        if(BufY) FreeMem(BufY,BufYSize);
        if(BufU) FreeMem(BufU,BufUSize);
        if(BufV) FreeMem(BufV,BufVSize);

      }
      break;

// -----
    case VDIGI_YUV411:
      {
        Forbid();
        if(io->io_Width==128)
          VLab_Scan(io->io_YUV.ioyv_Y,io->io_YUV.ioyv_U,io->io_YUV.ioyv_V,
                  (720-160)/2,(310-100)/2,Width,Height);
        else
          VLab_Scan(io->io_YUV.ioyv_Y,io->io_YUV.ioyv_U,io->io_YUV.ioyv_V,8,20,Width,Height);
        Permit();
        if(VLab_Error()) io->io_Error=IOERR_NoVideoSignal;
      }
      break;

// -----
    default:
      io->io_Error=IOERR_UnknownDType;
  }
}

