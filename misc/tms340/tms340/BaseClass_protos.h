/* Prototypes for functions defined in BaseClass.c
 */
/*
    6.2.96
        Changed Read/WriteTMSData into Read/WriteTMSPixel
                Read/WriteTMSDataXY into Read/WriteTMSPixelXY
        both use Pixel sizes for I/O, while the Read/WriteTMSDataArray
        always uses byte sizes on Data I/O. This name points
        this out more clearly.
*/

#include <exec/types.h>
#include <tms340/BaseClass.h>
/*
    Class Function/Method Prototypes
 */
/* 
    Register I/O operation ----------------------------------------------------
*/
long __asm WriteTMSReg(register __a5 TMSClassPtr TMSClass,
                       register __a0 UWORD *Register,register __d0 UWORD val);
long __asm ReadTMSReg(register __a5 TMSClassPtr TMSClass, register __d0 UWORD *Register);
/* 
    Data I/O operation --------------------------------------------------------
*/
long __asm WriteTMSDataArray(register __a5 TMSClassPtr TMSClass,
                             register __a0 long Src,
                             register __a1 long Dest,
                             register __d0 long DataSize);
long __asm ReadTMSDataArray(register __a5 TMSClassPtr TMSClass,
                            register __a0 long Src,
                            register __a1 long Dest,
                            register __d0 long DataSize);
/* 
    Pixel I/O operation -------------------------------------------------------
*/
long __asm WriteTMSPixel(register __a5 TMSClassPtr TMSClass,
                        register __a0 ULONG *Dest,register __d0 ULONG val);
long __asm ReadTMSPixel(register __a5 TMSClassPtr TMSClass, register __a0 ULONG *Src);

long __asm WriteTMSPixelXY(register __a5 TMSClassPtr TMSClass,
                          register __a0 ULONG Src,   register __a1 ULONG SPitch,
                          register __d0 ULONG Sx,   register __d1 ULONG Sy,
                          register __a2 ULONG Dest, register __a3 ULONG DPitch,
                          register __d2 ULONG Dx,   register __d3 ULONG Dy,
                          register __d4 ULONG W,    register __d5 ULONG H);

long __asm ReadTMSPixelXY(register __a5 TMSClassPtr TMSClass,
                         register __a0 ULONG Src,  register __a1 ULONG SPitch,
                         register __d0 ULONG Sx,   register __d1 ULONG Sy,
                         register __a2 ULONG Dest, register __a3 ULONG DPitch,
                         register __d2 ULONG Dx,   register __d3 ULONG Dy,
                         register __d4 ULONG W,    register __d5 ULONG H);
/*
    Direct TMS Command & support operation ------------------------------------
 */
long __asm SetTMSClock(register __a5 TMSClassPtr TMSClass,
                       register __d0 WORD ClockNum,register __d1 WORD ClockVal);
long __asm ExecuteTMSCommand(register __a5 TMSClassPtr TMSClass,
                             register __d0 long TMSCommand,register __a0 APTR ParamList);
long __asm ExecuteTMSModule(register __a5 TMSClassPtr TMSClass,
                            register __a0 APTR TMSModule,register __a1 APTR ParamList);
/*
    Class Support Functions ---------------------------------------------------
 */

TMSClassPtr __asm __saveds CreateTMSClass(register __a0 STRPTR );

TMSClassPtr __asm __saveds CreateTMSSubClass(register __a5 TMSClassPtr , register __a0 STRPTR );

TMSClassPtr __asm __saveds ObtainTMSClass(register __a0 STRPTR );

long __asm __saveds ReleaseTMSClass(register __a5 TMSClassPtr );

long __asm __saveds AddTMSMethod(register __a5 TMSClassPtr , register __d0 long , register __a0 void * );
