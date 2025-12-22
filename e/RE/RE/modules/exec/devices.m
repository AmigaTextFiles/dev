#ifndef	EXEC_DEVICES_H
#define	EXEC_DEVICES_H

#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif 
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif 

OBJECT Device
 
       Library:Library
ENDOBJECT


OBJECT Unit
 
       MsgPort:MsgPort	
					
    flags:UBYTE
    pad:UBYTE
    OpenCnt:UWORD		
ENDOBJECT

#define UNITF_ACTIVE	(1<<0)
#define UNITF_INTASK	(1<<1)
#endif	
