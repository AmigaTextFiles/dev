#ifndef     DEVICES_CLIPBOARD_H
#define     DEVICES_CLIPBOARD_H

#ifndef	EXEC_TYPES_H
MODULE 	'exec/types'
#endif
#ifndef	EXEC_NODES_H
MODULE 	'exec/nodes'
#endif
#ifndef	EXEC_LISTS_H
MODULE 	'exec/lists'
#endif
#ifndef	EXEC_PORTS_H
MODULE 	'exec/ports'
#endif
#define	CBD_POST		(CMD_NONSTD+0)
#define	CBD_CURRENTREADID	(CMD_NONSTD+1)
#define	CBD_CURRENTWRITEID	(CMD_NONSTD+2)
#define	CBD_CHANGEHOOK		(CMD_NONSTD+3)
#define	CBERR_OBSOLETEID	1
OBJECT ClipboardUnitPartial
 
       Node:Node	
    UnitNum:LONG		
    
ENDOBJECT

OBJECT IOClipReq
 
      Message:Message
      Device:PTR TO Device	
      Unit:PTR TO ClipboardUnitPartial 
    Command:UWORD		
    Flags:UBYTE		
    Error:BYTE		
    Actual:LONG		
    Length:LONG		
    Data:PTR TO CHAR		
    Offset:LONG		
    ClipID:LONG		
ENDOBJECT

#define	PRIMARY_CLIP	0	
OBJECT SatisfyMsg
 
      Msg:Message	
    Unit:UWORD		
    ClipID:LONG		
ENDOBJECT

OBJECT ClipHookMsg
 
    Type:LONG		
    ChangeCmd:LONG	
				
    ClipID:LONG		
ENDOBJECT

#endif	
