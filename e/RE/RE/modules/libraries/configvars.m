#ifndef LIBRARIES_CONFIGVARS_H
#define LIBRARIES_CONFIGVARS_H

#ifndef	EXEC_TYPES_H
MODULE  'exec/types'
#endif	
#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 
#ifndef LIBRARIES_CONFIGREGS_H
MODULE  'libraries/configregs'
#endif 

OBJECT ConfigDev
 
     		Node:Node
    Flags:UBYTE	
    Pad:UBYTE		
     	Rom:ExpansionRom		
    BoardAddr:LONG 
    BoardSize:LONG	
    SlotAddr:UWORD	
    SlotSize:UWORD	
    Driver:LONG	
      	NextCD:PTR TO ConfigDev	
    Unused[4]:LONG	
ENDOBJECT


#define	CDB_SHUTUP	0	
#define	CDB_CONFIGME	1	
#define	CDB_BADMEMORY	2	
#define	CDB_PROCESSED	3	
#define	CDF_SHUTUP	$01
#define	CDF_CONFIGME	$02
#define	CDF_BADMEMORY	$04
#define	CDF_PROCESSED	$08

OBJECT CurrentBinding
 
      	ConfigDev:PTR TO ConfigDev		
    		FileName:PTR TO UBYTE		
    		ProductString:PTR TO UBYTE	
    		ToolTypes:LONG		
ENDOBJECT

#endif 
