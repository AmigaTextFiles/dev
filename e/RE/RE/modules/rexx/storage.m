#ifndef REXX_STORAGE_H
#define REXX_STORAGE_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif

OBJECT NexxStr
 
   Ivalue:LONG		       
   Length:UWORD		       
   Flags:UBYTE		       
   Hash:UBYTE		       
   Buff[8]:BYTE	       
   ENDOBJECT			       
#define NXADDLEN 9		       
#define IVALUE(nsPtr) (nsPtr.ns_Ivalue)

#define NSB_KEEP     0		       
#define NSB_STRING   1		       
#define NSB_NOTNUM   2		       
#define NSB_NUMBER   3		       
#define NSB_BINARY   4		       
#define NSB_FLOAT    5		       
#define NSB_EXT      6		       
#define NSB_SOURCE   7		       

#define NSF_KEEP     (1 << NSB_KEEP  )
#define NSF_STRING   (1 << NSB_STRING)
#define NSF_NOTNUM   (1 << NSB_NOTNUM)
#define NSF_NUMBER   (1 << NSB_NUMBER)
#define NSF_BINARY   (1 << NSB_BINARY)
#define NSF_FLOAT    (1 << NSB_FLOAT )
#define NSF_EXT      (1 << NSB_EXT   )
#define NSF_SOURCE   (1 << NSB_SOURCE)

#define NSF_INTNUM   (NSF_NUMBER OR NSF_BINARY OR NSF_STRING)
#define NSF_DPNUM    (NSF_NUMBER OR NSF_FLOAT)
#define NSF_ALPHA    (NSF_NOTNUM OR NSF_STRING)
#define NSF_OWNED    (NSF_SOURCE OR NSF_EXT    OR NSF_KEEP)
#define KEEPSTR      (NSF_STRING OR NSF_SOURCE OR NSF_NOTNUM)
#define KEEPNUM      (NSF_STRING OR NSF_SOURCE OR NSF_NUMBER OR NSF_BINARY)

OBJECT RexxArg
 
   Size:LONG		       
   Length:UWORD		       
   Flags:UBYTE		       
   Hash:UBYTE		       
   Buff[8]:BYTE	       
   ENDOBJECT			       

OBJECT RexxMsg
 
     Node:Message	       
   TaskBlock:LONG	       
   LibBase:LONG	       
   Action:LONG		       
   Result1:LONG	       
   Result2:LONG	       
   Args[16]:PTR TO CHAR	       
     PassPort:PTR TO MsgPort        
   CommAddr:PTR TO CHAR	       
   FileExt:PTR TO CHAR	       
   Stdin:LONG		       
   Stdout:LONG		       
   avail:LONG		       
   ENDOBJECT			       

#define ARG0(rmp) (rmp.rm_Args[0])    
#define ARG1(rmp) (rmp.rm_Args[1])    
#define ARG2(rmp) (rmp.rm_Args[2])    
#define MAXRMARG  15		       

#define RXCOMM	  $01000000	       
#define RXFUNC	  $02000000	       
#define RXCLOSE   $03000000	       
#define RXQUERY   $04000000	       
#define RXADDFH   $07000000	       
#define RXADDLIB  $08000000	       
#define RXREMLIB  $09000000	       
#define RXADDCON  $0A000000	       
#define RXREMCON  $0B000000	       
#define RXTCOPN   $0C000000	       
#define RXTCCLS   $0D000000	       

#define RXFB_NOIO    16	       
#define RXFB_RESULT  17	       
#define RXFB_STRING  18	       
#define RXFB_TOKEN   19	       
#define RXFB_NONRET  20	       

#define RXFF_NOIO    (1 << RXFB_NOIO  )
#define RXFF_RESULT  (1 << RXFB_RESULT)
#define RXFF_STRING  (1 << RXFB_STRING)
#define RXFF_TOKEN   (1 << RXFB_TOKEN )
#define RXFF_NONRET  (1 << RXFB_NONRET)
#define RXCODEMASK   $FF000000
#define RXARGMASK    $0000000F

OBJECT RexxRsrc
 
     Node:Node
   Func:WORD		       
   Base:LONG		       
   Size:LONG		       
   Arg1:LONG		       
   Arg2:LONG		       
   ENDOBJECT			       

#define RRT_ANY      0		       
#define RRT_LIB      1		       
#define RRT_PORT     2		       
#define RRT_FILE     3		       
#define RRT_HOST     4		       
#define RRT_CLIP     5		       

#define GLOBALSZ  200		       
OBJECT RexxTask
 
   Global[GLOBALSZ]:BYTE       
     MsgPort:MsgPort	       
   Flags:UBYTE		       
   SigBit:BYTE		       
   ClientID:LONG	       
   MsgPkt:LONG		       
   TaskID:LONG		       
   RexxPort:LONG	       
   ErrTrap:LONG	       
   StackPtr:LONG	       
     Header1:List	       
     Header2:List	       
     Header3:List	       
     Header4:List	       
     Header5:List	       
   ENDOBJECT


#define RTFB_TRACE   0		       
#define RTFB_HALT    1		       
#define RTFB_SUSP    2		       
#define RTFB_TCUSE   3		       
#define RTFB_WAIT    6		       
#define RTFB_CLOSE   7		       

#define MEMQUANT  16		       
#define MEMMASK   $FFFFFFF0	       
#define MEMQUICK  (1 << 0 )	       
#define MEMCLEAR  (1 << 16)	       

OBJECT SrcNode
 
     Succ:PTR TO SrcNode	       
     Pred:PTR TO SrcNode	       
   Ptr:LONG		       
   Size:LONG		       
   ENDOBJECT			       
#endif
