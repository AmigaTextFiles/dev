/*
 * yath.h   V0.06 (beta)
 *
 * main include file
 *
 * (c) 1992 by Stefan Becker
 *
 */

/* Version string */
#define YATH_VERSION "$VER: yatape-handler 0.06 (18.01.1992)"

/* System includes */
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/filehandler.h>
#include <devices/scsidisk.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/* Prototypes for system functions */
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_protos.h>

/* Prototypes for program functions */
LONG DoSCSICmd(WORD, ULONG, ULONG, ULONG);

/* Debugging */
#ifdef DEBUG
#define MPORTNAME "YATH Monitor Port"
#define MONITOR(a,b,c) {if (MonitorPort) SendMonitor((a),(b),(c));}
void SendMonitor(ULONG, ULONG, ULONG);

struct MonitorMessage {
                       struct Message mm_msg;
                       ULONG          mm_cmd;
                       ULONG          mm_arg1;
                       ULONG          mm_arg2;
                      };

/* Monitor commands */
#define YATH_OPEN    1   /* Arg1 = BOOLEAN Read/Write */
#define YATH_CLOSE   2   /* No arguments */
#define YATH_READ    3   /* Arg1 = Bytes to read */
#define YATH_WRITE   4   /* Arg1 = Bytes to write */
#define YATH_FLUSH   5   /* No arguments */
#define YATH_IOERR   6   /* Arg1 = io_Error, Arg2 = scsi_Status */
#define YATH_SCSI    7   /* Arg1 = SCSI Cmd, Arg2 = BOOLEAN Asynch I/O */

#else
#define MONITOR(a,b,c) /* Undefine debug function */
#endif

/* Global defines */
#define ID_BUSY (0x42555359)    /* 'BUSY' */
#define SENSELEN 254
#define SCSI_WAIT  0
#define SCSI_READ  1
#define SCSI_WRITE 2
#define SCSI_WEOFM 3
#define SCSI_REWND 4
#define SCSI_SENSE 5
#define SCSI_SPACE 6

/* Global data structure definitions */
struct SCSIStuff {
                  struct SCSICmd scmd;
                  UBYTE command[6];
                  UBYTE sense[SENSELEN];
                 };
