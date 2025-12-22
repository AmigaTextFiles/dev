#ifndef WORKBENCH_WORKBENCH_H
#define WORKBENCH_WORKBENCH_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef	EXEC_NODES_H
MODULE  'exec/nodes'
#endif
#ifndef	EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef EXEC_TASKS_H
MODULE  'exec/tasks'
#endif
#ifndef INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif
#define	WBDISK		1
#define	WBDRAWER	2
#define	WBTOOL		3
#define	WBPROJECT	4
#define	WBGARBAGE	5
#define	WBDEVICE	6
#define	WBKICK		7
#define WBAPPICON	8
OBJECT OldDrawerData
  
     	NewWindow:NewWindow	
    CurrentX:LONG	
    CurrentY:LONG	
ENDOBJECT

#define OLDDRAWERDATAFILESIZE	( SIZEOF OldDrawerData)
OBJECT DrawerData
 
     	NewWindow:NewWindow	
    CurrentX:LONG	
    CurrentY:LONG	
    Flags:LONG	
    ViewModes:UWORD	
ENDOBJECT

#define DRAWERDATAFILESIZE	( SIZEOF DrawerData)
OBJECT DiskObject
 
    Magic:UWORD 
    Version:UWORD 
     	Gadget:Gadget	
    Type:UBYTE
    DefaultTool:LONG
    ToolTypes:LONG
    CurrentX:LONG
    CurrentY:LONG
      	DrawerData:PTR TO DrawerData
    ToolWindow:LONG	
    StackSize:LONG	
ENDOBJECT

#define WB_DISKMAGIC	$e310	
#define WB_DISKVERSION	1	
#define WB_DISKREVISION	1	

#define WB_DISKREVISIONMASK	255
OBJECT FreeList
 
    NumFree:WORD
     		MemList:List
ENDOBJECT


#define GFLG_GADGBACKFILL $0001
#define GADGBACKFILL	  $0001    

#define NO_ICON_POSITION	$($80000000)

#define WORKBENCH_NAME		'workbench.library'

#define	AM_VERSION	1
OBJECT AppMessage
 
      Message:Message	
    Type:UWORD		
    UserData:LONG		
    ID:LONG		
    NumArgs:LONG		
      ArgList:PTR TO WBArg	
    Version:UWORD		
    Class:UWORD		
    MouseX:WORD		
    MouseY:WORD		
    Seconds:LONG		
    Micros:LONG		
    Reserved[8]:LONG	
ENDOBJECT


#define AMTYPE_APPWINDOW   7	
#define AMTYPE_APPICON	   8	
#define AMTYPE_APPMENUITEM 9	

OBJECT AppWindow
	 private:PTR TO LONG
ENDOBJECT
OBJECT AppIcon
		 private:PTR TO LONG
ENDOBJECT
OBJECT AppMenuItem
	 private:PTR TO LONG
ENDOBJECT

#endif	
