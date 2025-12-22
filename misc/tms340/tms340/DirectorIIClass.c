/*
    File: DirectorIIClass.c

    Description:
            This is the first tms340class for use with the
            DirectorII Video Board

    Author: Jürgen Schober
    Date:   19.1.1996

    19.1.1996 Just copied it from the BaseClass.c 

    29.1.1996 Build in all transfer commands
              ExecuteTMSCommand seems not to do anything
              One bug exists in the byte oriented 
              Array-transfers. The data size MUST NOT
              be smaller than 4 yet !
*/

#include <pragmas/exec_pragmas.h>
#include <pragmas/expansion_pragmas.h>
#include <pragmas/BaseClass_pragmas.h>

#include <clib/BaseClass_protos.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/configvars.h>
#include <tms340/BaseClass.h>

UBYTE *Version = "TMS340Class for the Director II V0.01 ©1996 Jürgen Schober";
struct Library *ExpansionBase,*TMS340ClassBase;

#define TMS_CLASS_NAME "DirectorII"
#define DIRECTOR_II_ID (2154)
#define PROD_ID (1L)
/* 4 bit/pixel is not yet supported ! */
#define DIRECTOR_II_DEPTH (1<<4 | 1<<8 | 1<<15 | 1<<16 | 1<<24 |1<<32)

struct DirectorIICmd {
    ULONG	Command;	/* Horizon Command Register          */
    ULONG	Param1;		/* Horizon Parameter Register 1      */
    ULONG	Param2;		/* Horizon Parameter Register 2      */
    ULONG	Param3;		/* Horizon Parameter Register 3      */
    ULONG	VRAM;		/* Horizon VRAM Byte Count Register  */
    ULONG	DRAM;		/* Horizon DRAM Byte Count Register  */
    ULONG	Stat;		/* Horizon Status Register           */
    ULONG	GROM;		/* Horizon Grom Status Register      */
    ULONG	Mode;		/* Horizon Mode Word Copy Register   */
    ULONG	CoPro;		/* Horizon TMS34082 Status Register  */
    ULONG	AbtPnt;		/* Horizon Autoboot Grom Table       */
    ULONG	AsvcPnt;	/* Horizon Autoservice Grom Table    */
    ULONG	TabPnt;		/* Horizon Fitted Grom Routine Table */
    ULONG	ROMNum;		/* holds current rom version         */
};
typedef struct DirectorIICmd *DirectorIICmdPtr;

struct DirectorIIMap
{
    APTR MemBase;
    DirectorIICmdPtr DirectorIICmd;
};
typedef struct DirectorIIMap *DirectorIIMapPtr;

/*
    The Class Functions
/*
/*
    IO Register read/writes use WORD I/O, 
    The Director II has only a long mapped area,
    so this is why I have to "simulate" a WORD I/O
    here
*/
void __asm _WriteTMSReg(register __a5 TMSClassPtr TMSClass,
                        register __a0 ULONG Register,register __d0 UWORD val)
{
    register ULONG regval;

    regval = *(ULONG*)(Register & ~2L);
    if (Register & 2)
    {
        *(ULONG*)(Register & ~2L) = ((regval & 0xFFFF0000) | val);
    }
    else
    {
        *(ULONG*)(Register & ~2L) = (regval & 0x0000FFFF) | (val << 16);
    }
}

UWORD __asm _ReadTMSReg(register __a5 TMSClassPtr TMSClass,
                        register __a0 ULONG* Register)
{
    register ULONG regval;
    
    regval = *(ULONG*)((ULONG)Register & ~2L);
    if ((ULONG)Register & 2)
    {
        return((UWORD)regval);
    }
    else
    {
        return((UWORD)(regval >> 16));
    }
}

/*
    The size of "val" is _NOT_ specified. It asumes that you 
    use the current pixel size. Default the Director II (short D2)
    uses 32 bit BGRA pixels. So the Basic Class uses this
    psize for Read/WriteTMSData/XY.
    The Address is a TMS Bitaddress.
 */

void __asm _WriteTMSData(register __a5 TMSClassPtr TMSClass,
                         register __a0 ULONG *Dest, register __d0 ULONG val)
{
    register ULONG *Base;

    Base = (ULONG*)(TMSClass->TMSBoardInfo->VRAMBase + ((ULONG)Dest >> 3));
    *Base = val;
}

/*
    Read a longword from a gsp bitaddress
 */
ULONG __asm _ReadTMSData(register __a5 TMSClassPtr TMSClass,register __a0 ULONG *Src)
{
    register ULONG *Base;

    Base = (ULONG*)(TMSClass->TMSBoardInfo->VRAMBase + ((ULONG)Src >> 3 ));
    return(*Base);
}

/*
    An Array is always a BYTE array. It is mainly used to copy 
    Code etc. to the board. So this differs from the other 
    DataIO commands in its datasize. While the other Read/WriteTMSData/XY
    routines use psize for the datasize, this one _allways_ use
    bytesizes !
 */
void __asm _WriteTMSArray(register __a5 TMSClassPtr TMSClass,
                          register __a0 ULONG Src,
                          register __a1 ULONG Dest,
                          register __d0 ULONG DataSize)
{
    register ULONG *dest,*src,buf,r;
    ULONG m[4];

    dest = (ULONG*)(TMSClass->TMSBoardInfo->VRAMBase + ((ULONG)Dest >> 3 ));
/*
    D2 is LONG mapped, so check if left byte boundary
    and convert to long
    WARNING ! Sizes < 4 are not checked yet !
 */
    if ((ULONG)dest & 3L)
    {
        r = (ULONG)dest & 3L;
        DataSize -= r;
        dest = (ULONG*)((ULONG)dest - r);
        m[1] = 0xFF000000;
        m[2] = 0xFFFF0000;
        m[3] = 0xFFFFFF00;
        buf = (*dest) & m[r]; 
        buf |= (*(ULONG*)Src) & ~m[r];
        *dest++ = buf;
        Src += r;
    }
    src = (ULONG*)Src;
    r = DataSize & 3L;
    DataSize >>= 2;
    while (DataSize--)
    {
        *dest++ = *src++;
    }
/*
    If there are some bytes left, copy them
 */
    if (r)
    {
        m[1] = 0xFF000000;
        m[2] = 0xFFFF0000;
        m[3] = 0xFFFFFF00;
        buf  = *dest & ~m[r];
        buf |= *src  &  m[r];
        *dest = buf;
    }
}

/* 
    Same as above, but read data here
 */
void __asm _ReadTMSArray(register __a5 TMSClassPtr TMSClass,
                         register __a0 long Src,register __a1 long Dest,register __d0 long DataSize)
{
    register ULONG *dest,*src,buf,r;
    ULONG m[4];

    src = (ULONG*)(TMSClass->TMSBoardInfo->VRAMBase + ((ULONG)Src >> 3 ));
    dest = (ULONG*)Dest;
    if ((ULONG)src & 3L)
    {
        r = (ULONG)src & 3L;
        DataSize -= r;
        src = (ULONG*)((ULONG)src - r);
        m[1] = 0x000000FF;
        m[2] = 0x0000FFFF;
        m[3] = 0x00FFFFFF;
        buf = (*src++) << (r << 3 );      // read a long and set to next long
        *dest &= m[r];
        *dest |= buf;
        dest = (ULONG*)((ULONG)dest + r);               // add the bytes from the board
        /*
            src is now long aligned,
            dest can be any alignment.
        */
    }
    r = DataSize & 3L;
    DataSize >>= 2;
    while (DataSize--)
    {
        *dest++ = *src++;
    }
    if (r)
    {
        m[1] = 0xFF000000;
        m[2] = 0xFFFF0000;
        m[3] = 0xFFFFFF00;
        buf  = (*src)  &  m[r];
        buf |= (*dest) & ~m[r];
        *dest = buf;
    }
}

/*
    Copy an rectangle area to the board
    This depends on the Pixelsize.
    This class uses BGRA32 pixels. 
    The pitch is (against the TIGA standard !)
    a pixel value, not a bitvalue !
 */
void __asm _WriteTMSDataXY(register __a5 TMSClassPtr TMSClass,
                   register __a0 ULONG Src,  register __a1 ULONG SPitch,
                   register __d0 ULONG Sx,   register __d1 ULONG Sy,
                   register __a2 ULONG Dest, register __a3 ULONG DPitch,
                   register __d2 ULONG Dx,   register __d3 ULONG Dy,
                   register __d4 ULONG W,    register __d5 ULONG H)
{
    register ULONG *src,*dest,w;
    ULONG Base;

    Base = TMSClass->TMSBoardInfo->VRAMBase;
    dest = (ULONG*)(Dest + Base + ((Dx + DPitch * Dy) << 2));
    src  = (ULONG*)(Src + Sx + SPitch * Sy);
    DPitch = ((DPitch - W) << 2);
    SPitch = ((SPitch - W) << 2);
    while (H--) 
    {
        w = W;
        while (w--)
        {
            *dest++ = *src++;
        }
        dest = (ULONG*)((ULONG)dest + DPitch) ;
        src  = (ULONG*)((ULONG)src  + SPitch) ;
    }
}

/* 
    Same as above to read an XY Data array.
 */
void __asm _ReadTMSDataXY(register __a5 TMSClassPtr TMSClass,
                   register __a0 ULONG Src,  register __a1 ULONG SPitch,
                   register __d0 ULONG Sx,   register __d1 ULONG Sy,
                   register __a2 ULONG Dest, register __a3 ULONG DPitch,
                   register __d2 ULONG Dx,   register __d3 ULONG Dy,
                   register __d4 ULONG W,    register __d5 ULONG H)
{
    register ULONG *src,*dest,w;
    ULONG Base;

    Base   = TMSClass->TMSBoardInfo->VRAMBase;
    src    = (ULONG*)(Src + Base + ((Sx + SPitch * Sy) << 2));
    dest   = (ULONG*)(Dest + Dx + DPitch * Dy);
    DPitch = ((DPitch - W) << 2);
    SPitch = ((SPitch - W) << 2);
    while (H--)
    {
        w = W;
        while (w--)
        {
            *dest++ = *src++;
        }
        dest = (ULONG*)((ULONG)dest + DPitch) ;
        src  = (ULONG*)((ULONG)src  + SPitch) ;
    }
}

/*
    Function to set the Video Clock speed.
    This is not supported right now.
 */

long __asm _SetTMSClock(register __a5 TMSClassPtr TMSClass,
                        register __d0 WORD ClockNum,register __d1 WORD ClockVal)
{
    return(0L);
}

/*
    Execute an TMS Command in 340x0 memory.
    The module is an offset in the TMS jumptable.
    It's mainly used for gfx core functions
    At the moment I can not check this out, because
    my D2 seems not to do anything. I have to write
    a new TMS34020 core first. But this will not change
    this routine here.
 */
ULONG __asm _ExecuteTMSCommand(register __a5 TMSClassPtr TMSClass,
                              register __d0 long TMSCommand,
                              register __a0 ULONG *ParamList)
{
    DirectorIICmdPtr CmdRegs;

    CmdRegs = ((DirectorIIMapPtr)TMSClass->TMSBoardInfo->UserData)->DirectorIICmd;
    CmdRegs->Param1 = ParamList[0];
    CmdRegs->Param2 = ParamList[1];
    CmdRegs->Param3 = ParamList[2];
    CmdRegs->Command = TMSCommand;
    while(CmdRegs->Stat) ;
    return(CmdRegs->Param1);
}

/*
    This is similar to the above, except it calls a
    "Module". The TMSModule is a (gsp) pointer
    to the Module address in TMS memory. 
 */
long __asm _ExecuteTMSModule(register __a5 TMSClassPtr TMSClass,
                             register __a0 APTR TMSModule,register __a1 APTR ParamList)
{  
    return(0L);
}


void Reserved(void)
{
/*
    Dummy Function for the lid.fd (libentry.o)
 */
}

/*
    Class Init Code (Used by CreateTMSClass())
 */
__saveds long __UserLibInit()
{
    int i;
    TMSClassPtr TMSClass;
    struct ConfigDev *D2Config = NULL;
    TMSBoardInfoPtr TMSBoardInfo;
    DirectorIIMapPtr D2ConInfo;
    ULONG *IORegs;
    ULONG IORegBase;

    if (ExpansionBase = (struct Library*)OpenLibrary("expansion.library",0L))
    {
        /*
            Get the board
        */
        if (D2Config = (struct ConfigDev*)FindConfigDev(D2Config,DIRECTOR_II_ID,PROD_ID))
        {
            if (TMS340ClassBase = (struct Library*)OpenLibrary("tms340class.library",0L))
            {
                /*
                    Create a new TMSClass
                */
                if (TMSClass = CreateTMSClass(TMS_CLASS_NAME))
                {
                    TMSClass->BoardID = DIRECTOR_II_BOARD_ID;
                    TMSClass->PixType = PT_BGRA32_F; 
                    TMSClass->FieldSize = FOUR_BYTE_PIXEL;
                    /*
                        Basic Board Config Mode :
                    */
                    TMSBoardInfo = TMSClass->TMSBoardInfo;
                    // Board Userdata
                    D2ConInfo = (DirectorIIMapPtr)AllocVec(sizeof(struct DirectorIIMap),MEMF_CLEAR); //  2 pointer for the Config areas
                    TMSBoardInfo->UserData = (APTR)D2ConInfo;
                     // The D2 is Memory mapped
                    TMSBoardInfo->MemMapped = TRUE;
                    // VRAM and DRAM both use the same address, they are paged 
                    TMSBoardInfo->VRAMBase = TMSBoardInfo->DRAMBase = (ULONG)D2Config->cd_BoardAddr;
                    // I use a private membase, too
                    D2ConInfo->MemBase = (APTR)TMSBoardInfo->VRAMBase;
                    TMSBoardInfo->Depth = DIRECTOR_II_DEPTH;
                    // The D2 has a constant clock (I know about)
                    TMSBoardInfo->Clocks = 0;
                    // Board description
                    TMSBoardInfo->BoardInfo = "Director II 34020 Video-Capture Board";
                    // get the second IO area of the board
                    if (D2Config = (struct ConfigDev*)FindConfigDev(D2Config,DIRECTOR_II_ID,PROD_ID))
                    {
                        // Get the address of the Class' IORegister addresses
                        IORegs = (ULONG*)TMSBoardInfo->IORegister;
                        // get the D2 base address offset
                        IORegBase = ((ULONG)D2Config->cd_BoardAddr + 0x4000);
                        // setup the address table
                        for (i = 0; i < sizeof(struct TMSIORegister) >> 2; i+= 2)
                        {
                            IORegs[i+1] = (IORegBase + (i<<1) );
                            IORegs[i]   = (IORegBase + 2 + (i<<1) ); // next WORD Address
                        }
                        // get the Commandspace into my private data
                        D2ConInfo->DirectorIICmd = (DirectorIICmdPtr)D2Config->cd_BoardAddr;
                        // and calculate the memory sizes
                        TMSBoardInfo->VRAMSize = D2ConInfo->DirectorIICmd->VRAM;
                        TMSBoardInfo->DRAMSize = D2ConInfo->DirectorIICmd->DRAM;

                    }
                    /*
                        The Functiontable: (local functions have a "_" prefix
                                            to avoid libcall conflicts)
                    */
                    AddTMSMethod( TMSClass, WRITE_TMS_REG,   (void*)_WriteTMSReg   );
                    AddTMSMethod( TMSClass, READ_TMS_REG,    (void*)_ReadTMSReg    );
                    AddTMSMethod( TMSClass, WRITE_TMS_PIXEL, (void*)_WriteTMSData  );
                    AddTMSMethod( TMSClass, READ_TMS_PIXEL,  (void*)_ReadTMSData   );
                    AddTMSMethod( TMSClass, WRITE_TMS_ARRAY, (void*)_WriteTMSArray );
                    AddTMSMethod( TMSClass, READ_TMS_ARRAY,  (void*)_ReadTMSArray  );
                    AddTMSMethod( TMSClass, WRITE_TMS_XY,    (void*)_WriteTMSDataXY);
                    AddTMSMethod( TMSClass, READ_TMS_XY,     (void*)_ReadTMSDataXY );
/* no clock (yet)
                    AddTMSMethod( TMSClass, SET_TMS_CLOCK,   (void*)_SetTMSClock    );
*/
                    AddTMSMethod( TMSClass, EXEC_TMS_COMMAND,(void*)_ExecuteTMSCommand );
                    AddTMSMethod( TMSClass, EXEC_TMS_MODULE, (void*)_ExecuteTMSModule );

                    // get off again
                    CloseLibrary(TMS340ClassBase);
                    CloseLibrary(ExpansionBase);
                    return(0L);

                }
                CloseLibrary(TMS340ClassBase);
            }
        }
        CloseLibrary(ExpansionBase);
    }
    return(-1L);
}

__saveds void __UserLibCleanup(void)
{
/*
    This is only use to free resources you have allocated in your
    __UserLibInit before. Do not Dispose a Class here !!
    The Class handling is done by the TMS340Class.library
 */    
    TMSClassPtr TMSClass;

    // get the Class
    if (TMSClass = ObtainTMSClass(TMS_CLASS_NAME))
    {
        // and free allocated memory
        FreeVec(TMSClass->UserData);
    }
}
