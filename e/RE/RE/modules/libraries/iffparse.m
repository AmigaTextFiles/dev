#ifndef IFF_IFFPARSE_H
#define IFF_IFFPARSE_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef DEVICES_CLIPBOARD_H
MODULE  'devices/clipboard'
#endif


OBJECT IFFHandle

    Stream:LONG
    Flags:LONG
    Depth:LONG	
ENDOBJECT


#define IFFF_READ	0			 
#define IFFF_WRITE	1			 
#define IFFF_RWBITS	(IFFF_READ OR IFFF_WRITE) 
#define IFFF_FSEEK	(1<<1)		 
#define IFFF_RSEEK	(1<<2)		 
#define IFFF_RESERVED	$FFFF0000		 


OBJECT IFFStreamCmd

    Command:LONG	
    Buf:LONG	
    NBytes:LONG	
ENDOBJECT



OBJECT ContextNode

      Node:MinNode
    ID:LONG
    Type:LONG
    Size:LONG	
    Scan:LONG	
ENDOBJECT



OBJECT LocalContextItem

      Node:MinNode
    ID:LONG
    Type:LONG
    Ident:LONG
ENDOBJECT



OBJECT StoredProperty

    Size:LONG
    Data:LONG
ENDOBJECT



OBJECT CollectionItem

      Next:PTR TO CollectionItem
    Size:LONG
    Data:LONG
ENDOBJECT



OBJECT ClipboardHandle

      Req:IOClipReq
        CBport:MsgPort
        SatisfyPort:MsgPort
ENDOBJECT



#define IFFERR_EOF	  -1	
#define IFFERR_EOC	  -2	
#define IFFERR_NOSCOPE	  -3	
#define IFFERR_NOMEM	  -4	
#define IFFERR_READ	  -5	
#define IFFERR_WRITE	  -6	
#define IFFERR_SEEK	  -7	
#define IFFERR_MANGLED	  -8	
#define IFFERR_SYNTAX	  -9	
#define IFFERR_NOTIFF	  -10	
#define IFFERR_NOHOOK	  -11	
#define IFF_RETURN2CLIENT -12	

#define MAKE_ID(a,b,c,d)	( (a)<<24 OR  (b)<<16 OR  (c)<<8 OR  (d))

#define ID_FORM		MAKE_ID("F","O","R","M")
#define ID_LIST		MAKE_ID("L","I","S","T")
#define ID_CAT			MAKE_ID("C","A","T"," ")
#define ID_PROP		MAKE_ID("P","R","O","P")
#define ID_NULL		MAKE_ID(" "," "," "," ")

#define IFFLCI_PROP		MAKE_ID("p","r","o","p")
#define IFFLCI_COLLECTION	MAKE_ID("c","o","l","l")
#define IFFLCI_ENTRYHANDLER	MAKE_ID("e","n","h","d")
#define IFFLCI_EXITHANDLER	MAKE_ID("e","x","h","d")


#define IFFPARSE_SCAN	 0
#define IFFPARSE_STEP	 1
#define IFFPARSE_RAWSTEP 2


#define IFFSLI_ROOT  1  
#define IFFSLI_TOP   2  
#define IFFSLI_PROP  3  


#define IFFSIZE_UNKNOWN -1


#define IFFCMD_INIT	0	
#define IFFCMD_CLEANUP	1	
#define IFFCMD_READ	2	
#define IFFCMD_WRITE	3	
#define IFFCMD_SEEK	4	
#define IFFCMD_ENTRY	5	
#define IFFCMD_EXIT	6	
#define IFFCMD_PURGELCI 7	


#ifndef IFFPARSE_V37_NAMES_ONLY
#define IFFSCC_INIT	IFFCMD_INIT
#define IFFSCC_CLEANUP	IFFCMD_CLEANUP
#define IFFSCC_READ	IFFCMD_READ
#define IFFSCC_WRITE	IFFCMD_WRITE
#define IFFSCC_SEEK	IFFCMD_SEEK
#endif

#endif 
