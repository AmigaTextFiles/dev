#ifndef	RESOURCES_FILESYSRES_H
#define	RESOURCES_FILESYSRES_H

#ifndef	EXEC_NODES_H
MODULE 	'exec/nodes'
#endif
#ifndef	EXEC_LISTS_H
MODULE 	'exec/lists'
#endif
#ifndef	DOS_DOS_H
MODULE 	'dos/dos'
#endif
#define	FSRNAME	'FileSystem.resource'
OBJECT FileSysResource
 
      Node:Node		
    Creator:LONG		
      FileSysEntries:List	
ENDOBJECT

OBJECT FileSysEntry
 
      Node:Node	
				
    DosType:LONG	
    Version:LONG	
    PatchFlags:LONG	
				
				
				
    Type:LONG		
    Task:CPTR		
    Lock:LONG		
    Handler:BSTR	
    StackSize:LONG	
    Priority:LONG	
    Startup:LONG	
    SegList:LONG	
    GlobalVec:LONG	
    
ENDOBJECT

#endif	
