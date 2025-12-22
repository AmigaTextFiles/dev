#ifndef REXX_REXXIO_H
#define REXX_REXXIO_H

#ifndef REXX_STORAGE_H
MODULE  'rexx/storage'
#endif
#define RXBUFFSZ  204		       

OBJECT IoBuff
 
     iobNode:RexxRsrc	       
   iobRpt:LONG		       
   iobRct:LONG		       
   iobDFH:LONG		       
   iobLock:LONG		       
   iobBct:LONG		       
   iobArea[RXBUFFSZ]:BYTE	       
   ENDOBJECT			       

#define RXIO_EXIST   -1	       
#define RXIO_STRF    0		       
#define RXIO_READ    1		       
#define RXIO_WRITE   2		       
#define RXIO_APPEND  3		       

#define RXIO_BEGIN   -1	       
#define RXIO_CURR    0	       
#define RXIO_END     1	       

#define LLOFFSET(rrp) (rrp.rr_Arg1)   
#define LLVERS(rrp)   (rrp.rr_Arg2)   

#define CLVALUE(rrp) (() rrp.rr_Arg1)

OBJECT RexxMsgPort
 
     Node:RexxRsrc	       
      Port:MsgPort	       
    	   ReplyList:List      
   ENDOBJECT


#define DT_DEV	  0		       
#define DT_DIR	  1		       
#define DT_VOL	  2		       

#define ACTION_STACK 2002	       
#define ACTION_QUEUE 2003	       
#endif
