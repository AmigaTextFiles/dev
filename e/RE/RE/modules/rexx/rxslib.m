#ifndef REXX_RXSLIB_H
#define REXX_RXSLIB_H

#ifndef REXX_STORAGE_H
MODULE  'rexx/storage'
#endif
#define RXSNAME  'rexxsyslib.library'
#define RXSDIR	 'REXX'
#define RXSTNAME 'ARexx'


OBJECT RxsLib
 
     Node:Library	       
   Flags:UBYTE		       
   Shadow:UBYTE		       
   SysBase:LONG	       
   DOSBase:LONG	       
   IeeeDPBase:LONG	       
   SegList:LONG	       
   NIL:LONG		       
   Chunk:LONG		       
   MaxNest:LONG	       
     NULL:PTR TO NexxStr	       
     FALSE:PTR TO NexxStr	       
     TRUE:PTR TO NexxStr	       
     REXX:PTR TO NexxStr	       
     COMMAND:PTR TO NexxStr	       
     STDIN:PTR TO NexxStr	       
     STDOUT:PTR TO NexxStr	       
     STDERR:PTR TO NexxStr	       
   Version:PTR TO CHAR	       
   TaskName:PTR TO CHAR	       
   TaskPri:LONG	       
   TaskSeg:LONG	       
   StackSize:LONG	       
   RexxDir:PTR TO CHAR	       
   CTABLE:PTR TO CHAR	       
   Notice:PTR TO CHAR	       
     RexxPort:MsgPort	       
   ReadLock:UWORD	       
   TraceFH:LONG	       
     TaskList:List	       
   NumTask:WORD	       
     LibList:List	       
   NumLib:WORD	       
     ClipList:List	       
   NumClip:WORD	       
     MsgList:List	       
   NumMsg:WORD	       
     PgmList:List	       
   NumPgm:WORD	       
   TraceCnt:UWORD	       
   avail:WORD
   ENDOBJECT


#define RLFB_TRACE RTFB_TRACE	       
#define RLFB_HALT  RTFB_HALT	       
#define RLFB_SUSP  RTFB_SUSP	       
#define RLFB_STOP  6		       
#define RLFB_CLOSE 7		       
#define RLFMASK    (1<<RLFB_TRACE) OR (1<<RLFB_HALT) OR (1<<RLFB_SUSP)

#define RXSCHUNK   1024	       
#define RXSNEST    32		       
#define RXSTPRI    0		       
#define RXSSTACK   4096	       

#define CTB_SPACE   0		       
#define CTB_DIGIT   1		       
#define CTB_ALPHA   2		       
#define CTB_REXXSYM 3		       
#define CTB_REXXOPR 4		       
#define CTB_REXXSPC 5		       
#define CTB_UPPER   6		       
#define CTB_LOWER   7		       

#define CTF_SPACE   (1 << CTB_SPACE)
#define CTF_DIGIT   (1 << CTB_DIGIT)
#define CTF_ALPHA   (1 << CTB_ALPHA)
#define CTF_REXXSYM (1 << CTB_REXXSYM)
#define CTF_REXXOPR (1 << CTB_REXXOPR)
#define CTF_REXXSPC (1 << CTB_REXXSPC)
#define CTF_UPPER   (1 << CTB_UPPER)
#define CTF_LOWER   (1 << CTB_LOWER)
#endif
