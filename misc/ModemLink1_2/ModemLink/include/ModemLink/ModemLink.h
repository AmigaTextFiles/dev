#ifndef MODEM_LINK_H
#define MODEM_LINK_H

/*
**
** FILENAME:   ModemLink.h
** RELEASE:    1.2
** REVISION:   36.2
**
** Definitions and structures used by the ModemLink device/lib
**
** (C) Copyright 1997 Michael Veroukis
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_IO_H
#include <exec/io.h>
#endif
#ifndef  EXEC_LISTS_H
#include <exec/lists.h>
#endif


/*
** Tags to be used with ML_SendModemCMD()
*/
#define ML_DUMMY             (TAG_USER + 0x1000)

#define ML_DialTime          (ML_DUMMY + 0x00)
#define ML_AnswerTime        (ML_DUMMY + 0x01)
#define ML_DialPrefix        (ML_DUMMY + 0x02)
#define ML_Suffix            (ML_DUMMY + 0x03)
#define ML_OkText            (ML_DUMMY + 0x04)
#define ML_BusyText          (ML_DUMMY + 0x05)
#define ML_NoCarrierText     (ML_DUMMY + 0x06)
#define ML_NoDialText        (ML_DUMMY + 0x07)
#define ML_AutoAnsText       (ML_DUMMY + 0x08)


/*
** Return codes for the SendModemCMD() & Dial/Answer routines
** Note that most of these corresponde to what the modem itself
** would return.  However, the MODEM_CONNECT is returned when
** the Carrier Detect (CD) bit is set in serial device status bits.
** The MODEM_TIMEOUT is set when none of the other results codes
** occured in the specified amount of time for that command.
*/
#define MODEM_OK              0x0000
#define MODEM_ERROR           0x0001
#define MODEM_BUSY            0x0002
#define MODEM_NOCARRIER       0x0003
#define MODEM_NODIAL          0x0004
#define MODEM_OFF             0x0005
#define MODEM_CONNECT         0x0010
#define MODEM_TIMEOUT         0x0011


/*
** Error codes that could be returned from an IO request.  It's a good idea
** to check the error field of the IO struct after the WaitIO() call to
** check to see if everything went okay.  Also note that the normal error
** codes used by exec.library may also be used.
*/
#define LinkErr_OK       0x0000    // everything went fine
#define LinkErr_NOPROC   0x0001    // The ML handler process is not running! -- bad!

/*
** Return codes for the ML_Establish routine.  Make sure you always check
** the result code of this function!!!
*/
#define EstErr_OK        0x0000    // Connected!  Everything A-OKAY
#define EstErr_TIMEOUT   0x0001    // Could not connect, ran out of time...
#define EstErr_TASK_ERR  0x0002    // ML Task already exists.  Can only have one!


/*
** Commands to be sent to the device
*/
#define MLCMD_READ      (CMD_NONSTD+0)      // Send a packet
#define MLCMD_WRITE     (CMD_NONSTD+1)      // recieve a packet
#define MLCMD_QUERY     (CMD_NONSTD+2)      // query the device

#define MLCMD_INIT      (CMD_NONSTD+0x10)   // for internal use only



/*
** CAUTION:  If you plan to issue IO requests to the ModemLink device/lib
**           then you MUST use the IOExtLink structure, otherwise innocent
**           memory WILL be trashed.
*/
struct IOExtLink {
  struct IOStdReq IOLink;
  char LinkPortName[10];           // Read only - port to send IO reqs to
  char LinkProcName[10];           // Read only - proc which handles IO reqs
  ULONG Flags;                     // Check flag defs for modification perms.
  ULONG Unit;                      // Private (may change)
};


/*
** This defines the basic structure of a ModemLink packet.
*/
struct LinkPkt {
  struct MinNode ml_Node;          // for linked lists
  ULONG Length;                    // size of Data block
  ULONG CRC;                       // contains CRC32 code (internal use)
  UBYTE Socket;                    // not used - set to zero
  UBYTE *Data;                     // points to data block
  int Flags;                       // no flags yet - set to zero
  UBYTE *UserData;                 // points to user defined data
};

#define MODEMLINKNAME "modemlink.device"

#endif
