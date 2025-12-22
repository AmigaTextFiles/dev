#ifndef	EXEC_IO_H
#define	EXEC_IO_H

#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif 
OBJECT IORequest
 
       Message:Message
        Device:PTR TO Device     
          Unit:PTR TO Unit	    
    Command:UWORD	    
    Flags:UBYTE
    Error:BYTE		    
ENDOBJECT

OBJECT IOStdReq
 
       Message:Message
        Device:PTR TO Device     
          Unit:PTR TO Unit	    
    Command:UWORD	    
    Flags:UBYTE
    Error:BYTE		    
    Actual:LONG		    
    Length:LONG		    
    Data:LONG		    
    Offset:LONG		    
ENDOBJECT


#define DEV_BEGINIO	(-30)
#define DEV_ABORTIO	(-36)

#define IOB_QUICK	0
#define IOF_QUICK	(1<<0)
#define CMD_INVALID	0
#define CMD_RESET	1
#define CMD_READ	2
#define CMD_WRITE	3
#define CMD_UPDATE	4
#define CMD_CLEAR	5
#define CMD_STOP	6
#define CMD_START	7
#define CMD_FLUSH	8
#define CMD_NONSTD	9
#endif	
