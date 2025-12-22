#ifndef LIBRARIES_AMIGAGUIDE_H
#define LIBRARIES_AMIGAGUIDE_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif 
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif 
#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 
#ifndef EXEC_SEMAPHORES_H
MODULE  'exec/semaphores'
#endif
#ifndef INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif
#ifndef INTUITION_SCREENS_H
MODULE  'intuition/screens'
#endif
#ifndef INTUITION_CLASSUSR_H
MODULE  'intuition/classusr'
#endif
#ifndef DO_DOS_H
MODULE  'dos/dos'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif
#ifndef APSH_TOOL_ID
#define	APSH_TOOL_ID 11000
#define	StartupMsgID		(APSH_TOOL_ID+1)	
#define	LoginToolID		(APSH_TOOL_ID+2)	
#define	LogoutToolID		(APSH_TOOL_ID+3)	
#define	ShutdownMsgID		(APSH_TOOL_ID+4)	
#define	ActivateToolID		(APSH_TOOL_ID+5)	
#define	DeactivateToolID	(APSH_TOOL_ID+6)	
#define	ActiveToolID		(APSH_TOOL_ID+7)	
#define	InactiveToolID		(APSH_TOOL_ID+8)	
#define	ToolStatusID		(APSH_TOOL_ID+9)	
#define	ToolCmdID		(APSH_TOOL_ID+10)	
#define	ToolCmdReplyID		(APSH_TOOL_ID+11)	
#define	ShutdownToolID		(APSH_TOOL_ID+12)	
#endif

#define	AGA_Dummy		(TAG_USER)
#define	AGA_Path		(AGA_Dummy+1)
#define	AGA_XRefList		(AGA_Dummy+2)
#define	AGA_Activate		(AGA_Dummy+3)
#define	AGA_Context		(AGA_Dummy+4)
#define	AGA_HelpGroup		(AGA_Dummy+5)
    
#define	AGA_Reserved1		(AGA_Dummy+6)
#define	AGA_Reserved2		(AGA_Dummy+7)
#define	AGA_Reserved3		(AGA_Dummy+8)
#define	AGA_ARexxPort		(AGA_Dummy+9)
    
#define	AGA_ARexxPortName	(AGA_Dummy+10)
   
  
#define void voidAMIGAGUIDECONTEXT

OBJECT AmigaGuideMsg

     	 Msg:Message			
    Type:LONG			
    Data:LONG			
    DSize:LONG			
    DType:LONG			
    Pri_Ret:LONG			
    Sec_Ret:LONG			
    System1:LONG
    System2:LONG
ENDOBJECT


OBJECT NewAmigaGuide

    Lock:LONG			
    Name:PTR TO CHAR			
     	Screen:PTR TO Screen			
    PubScreen:PTR TO CHAR			
    HostPort:PTR TO CHAR			
    ClientPort:PTR TO CHAR		
    BaseName:PTR TO CHAR			
    Flags:LONG			
    Context:PTR TO CHAR			
    Node:PTR TO CHAR			
    Line:LONG			
     	Extens:PTR TO TagItem			
    Client:PTR TO LONG			
ENDOBJECT


#define	HTF_LOAD_INDEX		(1<<0)			
#define	HTF_LOAD_ALL		(1<<1)			
#define	HTF_CACHE_NODE		(1<<2)			
#define	HTF_CACHE_DB		(1<<3)			
#define	HTF_UNIQUE		(1<<15)		
#define	HTF_NOACTIVATE		(1<<16)		
#define	HTFC_SYSGADS		$80000000

#define	HTH_OPEN		0
#define	HTH_CLOSE		1
#define	HTERR_NOT_ENOUGH_MEMORY		100
#define	HTERR_CANT_OPEN_DATABASE	101
#define	HTERR_CANT_FIND_NODE		102
#define	HTERR_CANT_OPEN_NODE		103
#define	HTERR_CANT_OPEN_WINDOW		104
#define	HTERR_INVALID_COMMAND		105
#define	HTERR_CANT_COMPLETE		106
#define	HTERR_PORT_CLOSED		107
#define	HTERR_CANT_CREATE_PORT		108
#define	HTERR_KEYWORD_NOT_FOUND		113
  
#define AmigaGuideHost struct *AMIGAGUIDEHOST


OBJECT XRef

     		 Node:Node			
    Pad:UWORD			
     	DF:PTR TO DocFile				
    File:PTR TO CHAR			
    Name:PTR TO CHAR			
    Line:LONG			
ENDOBJECT

#define	XRSIZE	(  SIZEOF XRef)

#define	XR_GENERIC	0
#define	XR_FUNCTION	1
#define	XR_COMMAND	2
#define	XR_INCLUDE	3
#define	XR_MACRO	4
#define	XR_STRUCT	5
#define	XR_FIELD	6
#define	XR_TYPEDEF	7
#define	XR_DEFINE	8

OBJECT AmigaGuideHost

     		 Dispatcher:Hook		
    Reserved:LONG			
    Flags:LONG
    UseCnt:LONG			
    SystemData:LONG		
    UserData:LONG			
ENDOBJECT


#define	HM_FINDNODE	1
#define	HM_OPENNODE	2
#define	HM_CLOSENODE	3
#define	HM_EXPUNGE	10		

OBJECT opFindHost

    MethodID:LONG
      Attrs:PTR TO TagItem		
    Node:PTR TO CHAR			
    TOC:PTR TO CHAR			
    Title:PTR TO CHAR			
    Next:PTR TO CHAR			
    Prev:PTR TO CHAR			
ENDOBJECT


OBJECT opNodeIO

    MethodID:LONG
      Attrs:PTR TO TagItem		
    Node:PTR TO CHAR			
    FileName:PTR TO CHAR		
    DocBuffer:PTR TO CHAR		
    BuffLen:LONG			
    Flags:LONG			
ENDOBJECT


#define	HTNF_KEEP	(1<<0)	
#define	HTNF_RESERVED1	(1<<1)	
#define	HTNF_RESERVED2	(1<<2)	
#define	HTNF_ASCII	(1<<3)	
#define	HTNF_RESERVED3	(1<<4)	
#define	HTNF_CLEAN	(1<<5)	
#define	HTNF_DONE	(1<<6)	

#define	HTNA_Dummy	(TAG_USER)
#define	HTNA_Screen	(HTNA_Dummy+1)	
#define	HTNA_Pens	(HTNA_Dummy+2)	
#define	HTNA_Rectangle	(HTNA_Dummy+3)	
#define	HTNA_HelpGroup	(HTNA_Dummy+5)	

OBJECT opExpungeNode

    MethodID:LONG
      Attrs:PTR TO TagItem		
ENDOBJECT

#endif 
