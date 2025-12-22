@DATABASE "gg:doc/NDK/Guide/Include/devices/prtbase.h"
@MASTER   "gg:os-include/devices/prtbase.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/prtbase.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/prtbase.h" LINK File}


@{b}Structures@{ub}

@{"DeviceData" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 43}            @{"PrinterData" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 104}  @{"PrinterExtendedData" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 276}  @{"PrinterSegment" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 442}
@{"PrtDriverPreferences" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 460}  


@{b}#defines@{ub}

@{"DUB_STOPPED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 78}           @{"DUF_STOPPED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 80}        @{"IOB_CURRENT" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 57}
@{"IOB_DONE" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 59}              @{"IOB_QUEUED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 56}         @{"IOB_SERVICING" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 58}
@{"IOF_CURRENT" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 62}           @{"IOF_DONE" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 64}           @{"IOF_QUEUED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 61}
@{"IOF_SERVICING" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 63}         @{"P_BUFSIZE" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 84}          @{"P_OLDSTKSIZE" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 82}
@{"P_SAFESIZE" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 85}            @{"P_STKSIZE" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 83}          @{"PB_EXPUNGED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 70}
@{"PB_IOOPENED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 69}           @{"PB_IOR0" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 67}            @{"PB_IOR1" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 68}
@{"PBF_EXPUNGED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 75}          @{"PBF_IOOPENDED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 74}      @{"PBF_IOR0" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 72}
@{"PBF_IOR1" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 73}              @{"PCC_4COLOR" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 258}         @{"PCC_ADDITIVE" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 259}
@{"PCC_BGR" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 261}               @{"PCC_BGR_WB" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 262}         @{"PCC_BGRW" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 263}
@{"PCC_BW" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 254}                @{"PCC_MULTI_PASS" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 272}     @{"PCC_WB" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 260}
@{"PCC_YMC" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 255}               @{"PCC_YMC_BW" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 256}         @{"PCC_YMCB" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 257}
@{"PPC_BWALPHA" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 236}           @{"PPC_BWGFX" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 237}          @{"PPC_COLORALPHA" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 238}
@{"PPC_COLORGFX" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 239}          @{"PPCB_COLOR" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 233}         @{"PPCB_EXTENDED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 241}
@{"PPCB_GFX" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 231}              @{"PPCB_NOSTRIP" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 250}       @{"PPCF_COLOR" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 234}
@{"PPCF_EXTENDED" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 242}         @{"PPCF_GFX" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 232}           @{"PPCF_NOSTRIP" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 251}
@{"PRTA_8BitGuns" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 415}         @{"PRTA_AntiAlias" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 418}     @{"PRTA_ColorCorrect" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 428}
@{"PRTA_ColorCorrection" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 419}  @{"PRTA_ColorSize" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 422}     @{"PRTA_ConvertSource" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 416}
@{"PRTA_DensityInfo" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 429}      @{"PRTA_DitherNames" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 426}   @{"PRTA_Dummy" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 410}
@{"PRTA_FloydDithering" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 417}   @{"PRTA_LeftBorder" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 432}    @{"PRTA_MixBWColor" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 435}
@{"PRTA_NewColor" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 421}         @{"PRTA_NoIO" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 420}          @{"PRTA_NoScaling" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 423}
@{"PRTA_Preferences" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 438}      @{"PRTA_ShadingNames" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 427}  @{"PRTA_TopBorder" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 433}

@ENDNODE
@NODE File "devices/prtbase.h"
#ifndef DEVICES_PRTBASE_H
#define DEVICES_PRTBASE_H
/*
**      $VER: prtbase.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      printer driver structure definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef  EXEC_DEVICES_H
#include <@{"exec/devices.h" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File"}>
#endif

#ifndef  DEVICES_PARALLEL_H
#include <@{"devices/parallel.h" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File"}>
#endif

#ifndef  DEVICES_SERIAL_H
#include <@{"devices/serial.h" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File"}>
#endif

#ifndef  DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif

#ifndef  DOS_DOSEXTENS_H
#include <@{"dos/dosextens.h" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File"}>
#endif

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

/****************************************************************************/

struct DeviceData
{
        @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34}  dd_Device;      /* standard library node */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}            dd_Segment;     /* A0 when initialized */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}            dd_ExecBase;    /* A6 for exec */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}            dd_CmdVectors;  /* command table for device commands */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}            dd_CmdBytes;    /* bytes describing which command queue */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}           dd_NumCommands; /* the number of commands supported */
};

/****************************************************************************/

/* IO Flags */
#define IOB_QUEUED      4
#define IOB_CURRENT     5
#define IOB_SERVICING   6
#define IOB_DONE        7

#define IOF_QUEUED      (1L<<@{"IOB_QUEUED" LINK File 56})
#define IOF_CURRENT     (1L<<@{"IOB_CURRENT" LINK File 57})
#define IOF_SERVICING   (1L<<@{"IOB_SERVICING" LINK File 58})
#define IOF_DONE        (1L<<@{"IOB_DONE" LINK File 59})

/* pd_Flags */
#define PB_IOR0         0
#define PB_IOR1         1
#define PB_IOOPENED     2
#define PB_EXPUNGED     7

#define PBF_IOR0        (1L<<@{"PB_IOR0" LINK File 67})
#define PBF_IOR1        (1L<<@{"PB_IOR1" LINK File 68})
#define PBF_IOOPENDED   (1L<<@{"PB_IOOPENED" LINK File 69})
#define PBF_EXPUNGED    (1L<<@{"PB_EXPUNGED" LINK File 70})

/* du_Flags (actually placed in pd_Unit.mp_Node.ln_Pri) */
#define DUB_STOPPED     0

#define DUF_STOPPED     (1L<<@{"DUB_STOPPED" LINK File 78})

#define P_OLDSTKSIZE    0x0800  /* stack size for child task (OBSOLETE) */
#define P_STKSIZE       0x1000  /* stack size for child task */
#define P_BUFSIZE       256     /* size of internal buffers for text i/o */
#define P_SAFESIZE      128     /* safety margin for text output buffer */

/****************************************************************************/

/*
        "@{"struct PrinterData" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 104}" was a very bad concept in the old V1.0 days
        because it is both: the device and the unit.

        Starting with V44 PrinterData may be duplicated for many Units. But all
        new fields that are specific to the Unit  are now part of the new
        "struct PrinterUnit". Don't touch the private fields!

        A note on the function pointers in these data structure definitions:
        unless otherwise specified, all functions expect that their parameters
        are passed on the *stack* rather than in CPU registers. Every parameter
        must be passed a 32 bit long word, i.e. an "@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}" will use the same
        stack space as an "@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}".
*/

struct PrinterData
{
        @{"struct DeviceData" LINK File 43} pd_Device;

        /* PRIVATE & OBSOLETE: the one and only unit */
        @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} pd_Unit;

        /* the printer specific segment */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} pd_PrinterSegment;

        /* the segment printer type */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pd_PrinterType;

        /* the segment data structure */
        @{"struct PrinterSegment" LINK File 442} * pd_SegmentData;

        /* the raster print buffer */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} * pd_PrintBuf;

        /* the write function:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"PWrite" LINK "gg:doc/NDK/Guide/printer/PWrite"}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} data,
         *                  @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} len);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*pd_PWrite)();

        /* write function's done:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"PBothReady" LINK "gg:doc/NDK/Guide/printer/PBothReady"}(@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24});
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*pd_PBothReady)();

        /* PRIVATE: port I/O request 0 */
        union
                @{"struct IOExtPar" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 27} pd_p0;
                @{"struct IOExtSer" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 36} pd_s0;
        } pd_ior0;

        #define pd_PIOR0 pd_ior0.pd_p0
        #define pd_SIOR0 pd_ior0.pd_s0

        /* PRIVATE:  and 1 for double buffering */
        union
                @{"struct IOExtPar" LINK "gg:doc/NDK/Guide/Include/devices/parallel.h/File" 27} pd_p1;
                @{"struct IOExtSer" LINK "gg:doc/NDK/Guide/Include/devices/serial.h/File" 36} pd_s1;
        } pd_ior1;

        #define pd_PIOR1 pd_ior1.pd_p1
        #define pd_SIOR1 pd_ior1.pd_s1

        /* PRIVATE: timer I/O request */
        @{"struct timerequest" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 40} pd_TIOR;

        /* PRIVATE: and message reply port */
        @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} pd_IORPort;

        /* PRIVATE: write task */
        @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} pd_TC;

        /* PRIVATE: and stack space (OBSOLETE) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pd_OldStk[@{"P_OLDSTKSIZE" LINK File 82}];

        /* PRIVATE: device flags */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pd_Flags;

        /* PRIVATE: padding */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pd_pad;

        /* the latest preferences */
        @{"struct Preferences" LINK "gg:doc/NDK/Guide/Include/intuition/preferences.h/File" 58} pd_Preferences;

        /* PRIVATE: wait function switch */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pd_PWaitEnabled;

        /**************************************************************
         *
         * New fields for V2.0:
         *
         *************************************************************/

        /* PRIVATE: padding */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pd_Flags1;

        /* PRIVATE: stack space (OBSOLETE) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} pd_Stk[@{"P_STKSIZE" LINK File 83}];

        /**************************************************************
         *
         *  New fields for V3.5 (V44):
         *
         *************************************************************/

        /* PRIVATE: the Unit. pd_Unit is obsolete */
        struct PrinterUnit * pd_PUnit;

        /* the read function:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} pd_PRead(char * buffer,
         *                    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} * length,
         *                    @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} * tv);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*pd_PRead)();

        /* call application's error hook:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} pd_CallErrorHook(@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} * hook,
         *                            struct printerIO * ior,
         *                            @{"struct PrtErrMsg" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 384} * pem);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*pd_CallErrHook)();

        /* unit number */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} pd_UnitNumber;

        /* name of loaded driver */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} pd_DriverName;

        /* the query function:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} pd_PQuery(@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} * numofchars);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*pd_PQuery)();
};

/****************************************************************************/

/* Printer Class */
#define PPCB_GFX        0       /* graphics (bit position) */
#define PPCF_GFX        0x1     /* graphics (and/or flag) */
#define PPCB_COLOR      1       /* color (bit position) */
#define PPCF_COLOR      0x2     /* color (and/or flag) */

#define PPC_BWALPHA     0x00    /* black&white alphanumerics */
#define PPC_BWGFX       0x01    /* black&white graphics */
#define PPC_COLORALPHA  0x02    /* color alphanumerics */
#define PPC_COLORGFX    0x03    /* color graphics */

#define PPCB_EXTENDED   2       /* extended PED structure (V44) */
#define PPCF_EXTENDED   0x4

/*
        Some printer drivers (PrinterPS) do not support
        strip printing. An application has to print a page
        using a single print request or through clever use
        of the @{"PRD_DUMPRPORTTAGS" LINK "gg:doc/NDK/Guide/printer/PRD_DUMPRPORTTAGS"} printing callback hook.
*/
#define PPCB_NOSTRIP    3       /* no strip printing, please */
#define PPCF_NOSTRIP    0x8

/* Color Class */
#define PCC_BW          0x01    /* black&white only */
#define PCC_YMC         0x02    /* yellow/magenta/cyan only */
#define PCC_YMC_BW      0x03    /* yellow/magenta/cyan or black&white */
#define PCC_YMCB        0x04    /* yellow/magenta/cyan/black */
#define PCC_4COLOR      0x04    /* a flag for YMCB and BGRW */
#define PCC_ADDITIVE    0x08    /* not ymcb but blue/green/red/white */
#define PCC_WB          0x09    /* black&white only, 0 == BLACK */
#define PCC_BGR         0x0A    /* blue/green/red */
#define PCC_BGR_WB      0x0B    /* blue/green/red or black&white */
#define PCC_BGRW        0x0C    /* blue/green/red/white */

/*
        The picture must be scanned once for each color component, as the
        printer can only define one color at a time.  ie. If '@{"PCC_YMC" LINK File 255}' then
        first pass sends all 'Y' info to printer, second pass sends all 'M'
        info, and third pass sends all C info to printer.  The CalComp
        PlotMaster is an example of this type of printer.
*/
#define PCC_MULTI_PASS  0x10    /* see explanation above */

/****************************************************************************/

struct PrinterExtendedData
{
        /* printer name, null terminated */
        char * ped_PrinterName;

        /* called after @{"LoadSeg" LINK "gg:doc/NDK/Guide/dos/LoadSeg"}:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_Init(@{"struct PrinterData" LINK "gg:doc/NDK/Guide/Include/devices/prtbase.h/File" 104} * pd);
         */
        @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*ped_Init)();

        /* called before @{"UnLoadSeg" LINK "gg:doc/NDK/Guide/dos/UnLoadSeg"}:
         *
         *      @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} ped_Expunge(@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24});
         */
        @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*ped_Expunge)();

        /* called at @{"OpenDevice" LINK "gg:doc/NDK/Guide/exec/OpenDevice"}:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_Open(struct printerIO * ior);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*ped_Open)();

        /* called at @{"CloseDevice" LINK "gg:doc/NDK/Guide/exec/CloseDevice"}:
         *
         *      @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} ped_Close(struct printerIO * ior);
         */
        @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*ped_Close)();

        /* printer class */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ped_PrinterClass;

        /* color class */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ped_ColorClass;

        /* number of print columns available */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ped_MaxColumns;

        /* number of character sets */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ped_NumCharSets;

        /* number of 'pins' in print head */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ped_NumRows;

        /* number of dots max in a raster dump */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ped_MaxXDots;

        /* number of dots max in a raster dump */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ped_MaxYDots;

        /* horizontal dot density */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ped_XDotsInch;

        /* vertical dot density */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ped_YDotsInch;

        /* printer text command table */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ** ped_Commands;

        /* special command handler:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_DoSpecial(@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} * command,
         *                         @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} output_buffer[],
         *                         @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} * current_line_position,
         *                         @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} * current_line_spacing,
         *                         @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} * crlf_flag,
         *                         @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} params[]);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*ped_DoSpecial)();

        /* raster render function:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_Render(@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ct,@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} x,@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} y,@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} status);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*ped_Render)();

        /* good write timeout */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_TimeoutSecs;

        /**************************************************************
         *
         * The following only exists if the segment version is >= 33:
         *
         *************************************************************/

        /* Conversion strings for the extended font */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} * ped_8BitChars;

        /* Set if text printed, otherwise 0 */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_PrintMode;

        /**************************************************************
         *
         * The following only exists if the segment version is >= 34:
         *
         *************************************************************/

        /* ptr to conversion function for all chars:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_ConvFunc(@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} * buf,
         *                        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} c,
         *                        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} crlf_flag);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*ped_ConvFunc)();

        /**************************************************************
         *
         * The following only exists if the segment version is >= 44
         * AND @{"PPCB_EXTENDED" LINK File 241} is set in ped_PrinterClass:
         *
         *************************************************************/

        /* Attributes and features */
        @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} * ped_TagList;

        /* driver specific preferences:
         *
         *      @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ped_DoPreferences(struct printerIO * ior,
         *                             @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} command);
         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} (*ped_DoPreferences)();

        /* custom error handling:
         *
         *      @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} ped_CallErrHook(struct printerIO * ior,
         *                           @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} * hook);
         */
        @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*ped_CallErrHook)();
};

/****************************************************************************/

/* The following tags are used to define more printer driver features */

#define PRTA_Dummy (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 0x50000)

/****************************************************************************/

/* V44 features */
#define PRTA_8BitGuns           (@{"PRTA_Dummy" LINK File 410} + 1) /* LBOOL */
#define PRTA_ConvertSource      (@{"PRTA_Dummy" LINK File 410} + 2) /* LBOOL */
#define PRTA_FloydDithering     (@{"PRTA_Dummy" LINK File 410} + 3) /* LBOOL */
#define PRTA_AntiAlias          (@{"PRTA_Dummy" LINK File 410} + 4) /* LBOOL */
#define PRTA_ColorCorrection    (@{"PRTA_Dummy" LINK File 410} + 5) /* LBOOL */
#define PRTA_NoIO               (@{"PRTA_Dummy" LINK File 410} + 6) /* LBOOL */
#define PRTA_NewColor           (@{"PRTA_Dummy" LINK File 410} + 7) /* LBOOL */
#define PRTA_ColorSize          (@{"PRTA_Dummy" LINK File 410} + 8) /* @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} */
#define PRTA_NoScaling          (@{"PRTA_Dummy" LINK File 410} + 9) /* LBOOL */

/* User interface */
#define PRTA_DitherNames        (@{"PRTA_Dummy" LINK File 410} + 20) /* @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} * */
#define PRTA_ShadingNames       (@{"PRTA_Dummy" LINK File 410} + 21) /* @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} * */
#define PRTA_ColorCorrect       (@{"PRTA_Dummy" LINK File 410} + 22) /* LBOOL */
#define PRTA_DensityInfo        (@{"PRTA_Dummy" LINK File 410} + 23) /* @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} * */

/* Hardware page borders */
#define PRTA_LeftBorder         (@{"PRTA_Dummy" LINK File 410} + 30) /* @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, inches/1000 */
#define PRTA_TopBorder          (@{"PRTA_Dummy" LINK File 410} + 31) /* @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, inches/1000 */

#define PRTA_MixBWColor         (@{"PRTA_Dummy" LINK File 410} + 32) /* LBOOL */

/* Driver Preferences */
#define PRTA_Preferences        (@{"PRTA_Dummy" LINK File 410} + 40) /* LBOOL */

/****************************************************************************/

struct PrinterSegment
{
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                            ps_NextSegment;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                           ps_runAlert;    /* MOVEQ #0,D0 : RTS */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                           ps_Version;     /* segment version */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                           ps_Revision;    /* segment revision */
        @{"struct PrinterExtendedData" LINK File 276}      ps_PED;         /* printer extended data */
};

/****************************************************************************/

/*
        Driver specific preferences. This structure is device specific: every
        driver must base its preferences structure on this to allow version
        checking etc.

        The application will read/write this structure as an I/O buffer.
*/
struct PrtDriverPreferences
{
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}    pdp_Version;                           /* PRIVATE! driver specific version */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}    pdp_PrinterID[32];                     /* PRIVATE! driver specific id */
        char     pdp_PrefName[@{"FILENAME_SIZE" LINK "gg:doc/NDK/Guide/Include/intuition/preferences.h/File" 26}-16];
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}    pdp_Length;                            /* size of this structure */

        /* .. more driver private fields follow .. */
};

#endif /* DEVICES_PRTBASE_H */
@ENDNODE
