#ifndef WORKBENCH_STARTUP_H
#define WORKBENCH_STARTUP_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef LIBRARIES_DOS_H
MODULE  'libraries/dos'
#endif
OBJECT WBStartup
 
     	Message:Message	
      	Process:PTR TO MsgPort	
    Segment:LONG	
    NumArgs:LONG	
    ToolWindow:LONG	
      	ArgList:PTR TO WBArg	
ENDOBJECT

OBJECT WBArg
 
    Lock:LONG	
    		Name:PTR TO BYTE	
ENDOBJECT

#endif	
