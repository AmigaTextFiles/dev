#ifndef LIBRARIES_EXPANSIONBASE_H
#define LIBRARIES_EXPANSIONBASE_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif	
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif	
#ifndef EXEC_SEMAPHORES_H
MODULE  'exec/semaphores'
#endif	
#ifndef LIBRARIES_CONFIGVARS_H
MODULE  'libraries/configvars'
#endif	

OBJECT BootNode

	  Node:Node
	Flags:UWORD
	DeviceNode:LONG
ENDOBJECT


OBJECT ExpansionBase

	 	LibNode:Library
	Flags:UBYTE				
	Private01:UBYTE			
	Private02:LONG			
	Private03:LONG			
			Private04:CurrentBinding	
			Private05:List		
			MountList:List	
	
ENDOBJECT


#define EE_OK		0
#define EE_LASTBOARD	40  
#define EE_NOEXPANSION	41  
#define EE_NOMEMORY	42  
#define EE_NOBOARD	43  
#define EE_BADMEM	44  

#define EBB_CLOGGED	0	
#define EBF_CLOGGED	(1<<0)
#define EBB_SHORTMEM	1	
#define EBF_SHORTMEM	(1<<1)
#define EBB_BADMEM	2	
#define EBF_BADMEM	(1<<2)
#define EBB_DOSFLAG	3	
#define EBF_DOSFLAG	(1<<3)
#define EBB_KICKBACK33	4	
#define EBF_KICKBACK33	(1<<4)
#define EBB_KICKBACK36	5	
#define EBF_KICKBACK36	(1<<5)

#define EBB_SILENTSTART	6
#define EBF_SILENTSTART	(1<<6)

#define	EBB_START_CC0	7
#define	EBF_START_CC0	(1<<7)
#endif	
