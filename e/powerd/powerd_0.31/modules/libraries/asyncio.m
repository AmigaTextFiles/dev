MODULE  'exec/ports','dos/dos','dos/dosextens'

OBJECT AsyncFile
  File:BPTR,
  BlockSize:ULONG,
  Handler:PTR TO MsgPort,
  Offset:PTR TO UBYTE,
  BytesLeft:LONG,
  BufferSize:ULONG,
  Buffers[2]:PTR TO UBYTE,
  Packet:StandardPacket,
  PacketPort:MsgPort,
  CurrentBuf:ULONG,
  SeekOffset:ULONG,
  PacketPending:UBYTE,
  ReadMode:UBYTE,
  CloseFH:UBYTE,

/* The following members were not listed in the V39 source code
of asyncio.library, although they were used.
I decided to add them at the end.
Any, this structure is private and you should keep you hand off
unless you dnot know how to use then !!! */

  SeekPastEOF:UBYTE,
  LastRes1:LONG,
  LastBytesLeft:LONG

/*
These enum werde typedef structures before. I turned them into ints.
But this does not affect your code anyway (100% compatible ! to V39 !)
*/
ENUM  MODE_READ,
    MODE_WRITE,
    MODE_APPEND

ENUM  MODE_START=-1,
    MODE_CURRENT,
    MODE_END
