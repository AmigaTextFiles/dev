#ifndef CLIB_MODEM_LINK_PROTOS_H
#define CLIB_MODEM_LINK_PROTOS_H

/*
**
** FILENAME:   ModemLink_protos.h
** RELEASE:    1.0
** REVISION:   36.0
**
** C prototypes.
**
** (C) Copyright 1997 Michael Veroukis
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_IO_H
#include <exec/io.h>
#endif
#ifndef  DEVICES_SERIAL_H
#include <devices/serial.h>
#endif

/*
** Following group of functions are only accessible through the
** ModemLink.lib link library.  Use the AmigaOS routines in exec.library
** if you are using the ModemLink.device
*/
BYTE ML_DoIO(struct IORequest *IOReq);
void ML_SendIO(struct IORequest *IOReq);
void __asm ML_AbortIO(register __a1 struct IORequest *IOReq);


/*
** the following group of functions are available in the ModemLink.lib and 
** ModemLinkDev.lib link libraries.  If you plan on using the
** ModemLink.device with any of the "Tags" functions, make sure you link
** with the ModemLinkDev.lib, as it contains the glue routines for
** the tag calls.
*/
ULONG ML_SendModemCMDTags(struct IOExtSer *SerIO, char *CMD, ULONG tagitem, ...);
ULONG ML_DialTags(struct IOExtSer *SerIO, char *PhoneNum, ULONG tagitem, ...);
ULONG ML_AnswerTags(struct IOExtSer *SerIO,  ULONG tagitem, ...);

ULONG ML_EstablishTags(struct IOExtLink *LinkIO, struct IOExtSer *SerIO, ULONG data, ...);


/*
** The rest of these routines are accessible from both the link library
** (ModemLink.lib) and the device (via pragmas).  ModemLinkDev.lib not
** required for these...
*/
ULONG __asm
ML_SendModemCMDTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 char *CMD,
  register __a2 struct TagItem *tagList
);

ULONG __asm
ML_DialTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 char *PhoneNum,
  register __a2 struct TagItem *tagList
);

ULONG __asm
ML_AnswerTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 struct TagItem *tagList
);


ULONG __asm
ML_EstablishTagList
(
  register __a0 struct IOExtLink *LinkIO,
  register __a1 struct IOExtSer *SerIO,
  register __a2 struct TagItem *tagList
);

void __asm
ML_Terminate
(
  register __a0 struct IOExtLink *LinkIO
);


struct LinkPkt __saveds __asm
*ML_AllocPkt(void);

void __asm
ML_FreePkt
(
  register __a0 struct LinkPkt *Pkt
);

void __asm
ML_FreePktList
(
  register __a0 struct MinList *PktList
);


ULONG __asm
ML_PacketizeData
(
  register __a0 struct MinList *PktList,
  register __a1 UBYTE *Data,
  register __d0 ULONG Length,
  register __d1 ULONG PktSize
);

ULONG __asm
ML_DePacketizeData
(
  register __a0 struct MinList *PktList,
  register __a1 UBYTE *Data,
  register __d0 ULONG Length
);

ULONG __asm
ML_PacketDataSize
(
  register __a0 struct MinList *PktList
);

#endif
