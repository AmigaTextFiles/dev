#ifndef BGUIPLAYER_H
#define BGUIPLAYER_H
/*
 *      BGUIPLAYER.H
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>
#include <devices/scsidisk.h>
#include <devices/timer.h>
#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>
#include <intuition/icclass.h>

#include <proto/exec.h>
#include <proto/bgui.h>
#include <proto/intuition.h>
#include <proto/dos.h>

#include <clib/alib_protos.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "BGUIPlayer_rev.h"

/*
 *      For DICE it's "MakeProto" tool which
 *      automatically generates a prototypes
 *      header included at the end of this
 *      file.
 */
#define Prototype               extern

/*
 *      BGUI object ID's.
 */
#define ID_PLAY                         21
#define ID_PAUSE                        22
#define ID_STOP                         23
#define ID_PREV                         24
#define ID_NEXT                         25
#define ID_BACKWARD                     26
#define ID_FORWARD                      27
#define ID_EJECT                        28
#define ID_VOLUME                       29
#define ID_INQUIRE                      30
#define ID_ABOUT                        31
#define ID_QUIT                         32
#define ID_HIDE                         33
#define ID_EDIT                         34

#define ID_DISKLIST                     1
#define ID_CD                           2
#define ID_ARTIST                       3
#define ID_LABEL                        4
#define ID_TRACK                        5
#define ID_SAVEDISK                     6

/*
 *      Commodity hotkeys.
 */
#define CXK_POPUP                       21

/*
 *      For the configuration file parser (Config.c).
 */
typedef struct {
        UBYTE           *cc_Name;
        UBYTE           *cc_ArgTemplate;
        VOID           (*cc_Func)( ULONG * );
} CONFIGCOMM;

/*
 *      Compiler muck.
 */
#ifdef _DCC
#define SAVEDS __geta4
#define ASM
#define REG(x) __ ## x
#else
#define SAVEDS __saveds
#define ASM __asm
#define REG(x) register __ ## x
#endif

/*
 *      All below definitions were taken from
 *      the MultiCDPlayer V1.0 header by
 *      Boris Jakubaschk.
 *
 *      Since I have no info on the ANSI SCSI-2
 *      specifications I can't tell you what it
 *      all means.
 */
#define SENSE_LEN               252
#define MAX_DATA_LEN            252
#define MAX_TOC_LEN             804

struct SCSICmd6 {
        UBYTE           Opcode;
        UBYTE           B1;
        UBYTE           B2;
        UBYTE           B3;
        UBYTE           B4;
        UBYTE           Control;
};

struct SCSICmd10 {
        UBYTE           Opcode;
        UBYTE           B1;
        UBYTE           B2;
        UBYTE           B3;
        UBYTE           B4;
        UBYTE           B5;
        UBYTE           B6;
        UBYTE           B7;
        UBYTE           B8;
        UBYTE           Control;
};

struct SCSICmd12 {
        UBYTE           Opcode;
        UBYTE           B1;
        UBYTE           B2;
        UBYTE           B3;
        UBYTE           B4;
        UBYTE           B5;
        UBYTE           B6;
        UBYTE           B7;
        UBYTE           B8;
        UBYTE           B9;
        UBYTE           B10;
        UBYTE           Control;
};

#define SCSI_CMD_TUR                    0x00
#define SCSI_CMD_RZU                    0x01
#define SCSI_CMD_RQS                    0x03
#define SCSI_CMD_FMU                    0x04
#define SCSI_CMD_RAB                    0x07
#define SCSI_CMD_RD                     0x08
#define SCSI_CMD_WR                     0x0A
#define SCSI_CMD_SK                     0x0B
#define SCSI_CMD_INQ                    0x12
#define SCSI_CMD_MSL                    0x15
#define SCSI_CMD_RU                     0x16
#define SCSI_CMD_RLU                    0x17
#define SCSI_CMD_MSE                    0x1A
#define SCSI_CMD_SSU                    0x1B
#define SCSI_CMD_RDI                    0x1C
#define SCSI_CMD_SDI                    0x1D
#define SCSI_CMD_PAMR                   0x1E
#define SCSI_CMD_RCP                    0x25
#define SCSI_CMD_RXT                    0x28
#define SCSI_CMD_WXT                    0x2A
#define SCSI_CMD_SKX                    0x2B
#define SCSI_CMD_WVF                    0x2E
#define SCSI_CMD_VF                     0x2F
#define SCSI_CMD_RDD                    0x37
#define SCSI_CMD_WDB                    0x3B
#define SCSI_CMD_RDB                    0x3C

#define SCSI_CMD_COPY                   0x18
#define SCSI_CMD_COMPARE                0x39
#define SCSI_CMD_COPYANDVERIFY          0x3A
#define SCSI_CMD_CHGEDEF                0x40
#define SCSI_CMD_READSUBCHANNEL         0x42
#define SCSI_CMD_READTOC                0x43
#define SCSI_CMD_READHEADER             0x44
#define SCSI_CMD_PLAYAUDIO12            0xA5
#define SCSI_CMD_PLAYAUDIOTRACKINDEX    0x48
#define SCSI_CMD_PAUSERESUME            0x4B

#define SCSI_STAT_NO_DISK               0       /* No CD in the drive.  */
#define SCSI_STAT_PLAYING               1       /* Audio playing.       */
#define SCSI_STAT_STOPPED               2       /* Drive motor stopped. */
#define SCSI_STAT_PAUSED                3       /* Audio paused.        */

/*
 *      As generated by "MakeProto".
 */
#include "BGUIPlayer_protos.h"

#endif
