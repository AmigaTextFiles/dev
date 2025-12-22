@DATABASE "gg:doc/NDK/Guide/Include/prefs/printertxt.h"
@MASTER   "gg:os-include/prefs/printertxt.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/printertxt.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/printertxt.h" LINK File}


@{b}Structures@{ub}

@{"PrinterDeviceUnitPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 98}  @{"PrinterTxtPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 29}  @{"PrinterUnitPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 87}


@{b}#defines@{ub}

@{"DEVICENAMESIZE" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 26}  @{"DRIVERNAMESIZE" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 25}  @{"ID_PDEV" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 23}       @{"ID_PTXT" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 21}
@{"ID_PUNT" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 22}         @{"PP_ELITE" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 72}        @{"PP_FINE" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 73}       @{"PP_PARALLEL" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 47}
@{"PP_PICA" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 71}         @{"PP_SERIAL" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 48}       @{"PQ_DRAFT" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 80}      @{"PQ_LETTER" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 81}
@{"PS_CUSTOM" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 59}       @{"PS_EIGHT_LPI" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 77}    @{"PS_EURO_A0" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 60}    @{"PS_EURO_A1" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 61}
@{"PS_EURO_A2" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 62}      @{"PS_EURO_A3" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 63}      @{"PS_EURO_A4" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 64}    @{"PS_EURO_A5" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 65}
@{"PS_EURO_A6" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 66}      @{"PS_EURO_A7" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 67}      @{"PS_EURO_A8" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 68}    @{"PS_N_TRACTOR" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 57}
@{"PS_SIX_LPI" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 76}      @{"PS_US_LEGAL" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 56}     @{"PS_US_LETTER" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 55}  @{"PS_W_TRACTOR" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 58}
@{"PT_FANFOLD" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 51}      @{"PT_SINGLE" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 52}       @{"UNITNAMESIZE" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 27}  

@ENDNODE
@NODE File "prefs/printertxt.h"
#ifndef PREFS_PRINTERTXT_H
#define PREFS_PRINTERTXT_H
/*
**      $VER: printertxt.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      File format for text printer preferences
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

/*****************************************************************************/

#define ID_PTXT @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','T','X','T')
#define ID_PUNT @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','U','N','T')
#define ID_PDEV @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','D','E','V')

#define DRIVERNAMESIZE 30               /* Filename size     */
#define  DEVICENAMESIZE 32              /* .device name size */
#define  UNITNAMESIZE   32    /* Unit name size    */

struct PrinterTxtPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  pt_Reserved[4];               /* System reserved            */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pt_Driver[@{"DRIVERNAMESIZE" LINK File 25}];    /* printer driver filename    */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pt_Port;                      /* printer port connection    */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_PaperType;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_PaperSize;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_PaperLength;               /* Paper length in # of lines */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_Pitch;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_Spacing;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_LeftMargin;                /* Left margin                */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_RightMargin;               /* Right margin       */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pt_Quality;
};

/* constants for PrinterTxtPrefs.pt_Port */
#define PP_PARALLEL 0
#define PP_SERIAL   1

/* constants for PrinterTxtPrefs.pt_PaperType */
#define PT_FANFOLD  0
#define PT_SINGLE   1

/* constants for PrinterTxtPrefs.pt_PaperSize */
#define PS_US_LETTER    0
#define PS_US_LEGAL     1
#define PS_N_TRACTOR    2
#define PS_W_TRACTOR    3
#define PS_CUSTOM       4
#define PS_EURO_A0      5               /* European size A0: 841 x 1189 */
#define PS_EURO_A1      6               /* European size A1: 594 x 841  */
#define PS_EURO_A2      7               /* European size A2: 420 x 594  */
#define PS_EURO_A3      8               /* European size A3: 297 x 420  */
#define PS_EURO_A4      9               /* European size A4: 210 x 297  */
#define PS_EURO_A5      10              /* European size A5: 148 x 210  */
#define PS_EURO_A6      11              /* European size A6: 105 x 148  */
#define PS_EURO_A7      12              /* European size A7: 74 x 105   */
#define PS_EURO_A8      13              /* European size A8: 52 x 74    */

/* constants for PrinterTxtPrefs.pt_PrintPitch */
#define PP_PICA  0
#define PP_ELITE 1
#define PP_FINE  2

/* constants for PrinterTxtPrefs.pt_PrintSpacing */
#define PS_SIX_LPI   0
#define PS_EIGHT_LPI 1

/* constants for PrinterTxtPrefs.pt_PrintQuality */
#define PQ_DRAFT  0
#define PQ_LETTER 1


/* PrinterUnitPrefs is used from @{"printer.device" LINK "gg:doc/NDK/Guide/printer/MAIN"} to open
   the connection device
*/
struct PrinterUnitPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  pu_Reserved[4];                 /* System reserved              */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  pu_UnitNum;                     /* Unit number for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"} */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} pu_OpenDeviceFlags;             /* Flags for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"}       */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pu_DeviceName[@{"DEVICENAMESIZE" LINK File 26}];  /* Name for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"}        */
};

/* PrinterDeviceUnitPrefs is used as descriptor for printer device
   units.
*/
struct PrinterDeviceUnitPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  pd_Reserved[4];       /* System reserved                */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  pd_UnitNum;           /* Unit number for @{"OpenDevice()" LINK "gg:doc/NDK/Guide/exec/OpenDevice"}   */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pd_UnitName[@{"UNITNAMESIZE" LINK File 27}]; /* Symbolic name of the unit */
};

/*****************************************************************************/

#endif /* PREFS_PRINTERTXT_H */
@ENDNODE
