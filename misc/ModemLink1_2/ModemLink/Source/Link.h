/*
** NAME: Link.h
*/

#ifndef LINK_H
#define LINK_H

#include <exec/types.h>
#include <exec/io.h>
#include <devices/serial.h>
#include <devices/timer.h>
#include <utility/tagitem.h>

#include <string.h>

// PRIVATE:

/*
** Flags for the IO struct.  Assume these are all private flags, so don't
** touch, unless otherwise stated.
*/
#define ML_PIPE0    0x0001L   // Queued for LinkProc
#define ML_PIPE1    0x0002L   // LinkProc has removed it from Queue but no processing yet
#define ML_PIPE2    0x0003L   // Currently processing request

/*
** prototypes
*/

struct IOExtLink *ML_GetMsg(struct MsgPort *MPort, ULONG PipeBit);
void ML_ReplyMsg(struct IOExtLink *LinkReq);

// PUBLIC:

/*
** Error codes that could be returned.  It's a good idea to check the
** error field of the IO struct after the WaitIO() call to check to see
** if everything went okay.
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
** structures
*/

struct IOExtLink {
  struct IOStdReq IOLink;
  UBYTE LinkPortName[10];           // Read only - port to send IO reqs to
  UBYTE LinkProcName[10];           // Read only - proc which handles IO reqs
  ULONG Flags;                     // Check flag defs for modification perms.
  ULONG Unit;                      // Private (may change)
};

struct LinkPkt {
  struct MinNode ml_Node;          // for linked lists
  ULONG Length;                    // size of Data block
  ULONG CRC;                       // contains CRC32 code (internal use)
  UBYTE Socket;                    // not used - set to zero
  UBYTE *Data;                     // points to data block
  int Flags;                       // no flags yet - set to zero
  UBYTE *UserData;                 // points to user defined data
};


/*
** prototypes
*/
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

struct LinkPkt  __asm
*ML_AllocPkt(void);

void  __asm
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
