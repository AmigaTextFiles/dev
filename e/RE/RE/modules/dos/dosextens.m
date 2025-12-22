#ifndef DOS_DOSEXTENS_H
#define DOS_DOSEXTENS_H

#ifndef EXEC_TASKS_H
MODULE  'exec/tasks'
#endif
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef EXEC_SEMAPHORES_H
MODULE  'exec/semaphores'
#endif
#ifndef DEVICES_TIMER_H
MODULE  'devices/timer'
#endif
#ifndef DOS_DOS_H
MODULE  'dos/dos'
#endif



OBJECT Process
 
          Task:Task
       MsgPort:MsgPort 
    Pad:WORD		
    SegList:LONG		
    StackSize:LONG	
    GlobVec:LONG		
    TaskNum:LONG		
    StackBase:LONG	
    Result2:LONG		
    CurrentDir:LONG	
    CIS:LONG		
    COS:LONG		
    ConsoleTask:LONG	
    FileSystemTask:LONG	
    CLI:LONG		
    ReturnAddr:LONG	
    PktWait:LONG		
    WindowPtr:LONG	
    
    HomeDir:LONG		
    Flags:LONG		
    ExitCode:LONG	
    ExitData:LONG	
    Arguments:PTR TO UBYTE	
      LocalVars:MinList 
    ShellPrivate:LONG	
    CES:LONG		
ENDOBJECT 

#define	PRB_FREESEGLIST		0
#define	PRF_FREESEGLIST		1
#define	PRB_FREECURRDIR		1
#define	PRF_FREECURRDIR		2
#define	PRB_FREECLI		2
#define	PRF_FREECLI		4
#define	PRB_CLOSEINPUT		3
#define	PRF_CLOSEINPUT		8
#define	PRB_CLOSEOUTPUT		4
#define	PRF_CLOSEOUTPUT		16
#define	PRB_FREEARGS		5
#define	PRF_FREEARGS		32

OBJECT FileHandle
 
     Link:PTR TO Message	 
     Port:PTR TO MsgPort	 
     Type:PTR TO MsgPort	 
   Buf:LONG
   Pos:LONG
   End:LONG
   Funcs:LONG
   Func2:LONG
   Func3:LONG
   Args:LONG
   Arg2:LONG
ENDOBJECT
#define fh_Func1 fh_Funcs
#define fh_Arg1 fh_Args

OBJECT DosPacket
 
     Link:PTR TO Message	 
     Port:PTR TO MsgPort	 
				 
   Type:LONG		 
   Res1:LONG		 
   Res2:LONG		 

   Arg1:LONG
   Arg2:LONG
   Arg3:LONG
   Arg4:LONG
   Arg5:LONG
   Arg6:LONG
   Arg7:LONG
ENDOBJECT
#define dp_Action  dp_Type
#define dp_Status  dp_Res1
#define dp_Status2 dp_Res2
#define dp_BufAddr dp_Arg1

OBJECT StandardPacket
 
       Msg:Message
     Pkt:DosPacket
ENDOBJECT

#define ACTION_NIL		0
#define ACTION_STARTUP		0
#define ACTION_GET_BLOCK	2	
#define ACTION_SET_MAP		4
#define ACTION_DIE		5
#define ACTION_EVENT		6
#define ACTION_CURRENT_VOLUME	7
#define ACTION_LOCATE_OBJECT	8
#define ACTION_RENAME_DISK	9
#define ACTION_WRITE		"W"
#define ACTION_READ		"R"
#define ACTION_FREE_LOCK	15
#define ACTION_DELETE_OBJECT	16
#define ACTION_RENAME_OBJECT	17
#define ACTION_MORE_CACHE	18
#define ACTION_COPY_DIR		19
#define ACTION_WAIT_CHAR	20
#define ACTION_SET_PROTECT	21
#define ACTION_CREATE_DIR	22
#define ACTION_EXAMINE_OBJECT	23
#define ACTION_EXAMINE_NEXT	24
#define ACTION_DISK_INFO	25
#define ACTION_INFO		26
#define ACTION_FLUSH		27
#define ACTION_SET_COMMENT	28
#define ACTION_PARENT		29
#define ACTION_TIMER		30
#define ACTION_INHIBIT		31
#define ACTION_DISK_TYPE	32
#define ACTION_DISK_CHANGE	33
#define ACTION_SET_DATE		34
#define ACTION_SCREEN_MODE	994
#define ACTION_READ_RETURN	1001
#define ACTION_WRITE_RETURN	1002
#define ACTION_SEEK		1008
#define ACTION_FINDUPDATE	1004
#define ACTION_FINDINPUT	1005
#define ACTION_FINDOUTPUT	1006
#define ACTION_END		1007
#define ACTION_SET_FILE_SIZE	1022	
#define ACTION_WRITE_PROTECT	1023	

#define ACTION_SAME_LOCK	40
#define ACTION_CHANGE_SIGNAL	995
#define ACTION_FORMAT		1020
#define ACTION_MAKE_LINK	1021


#define ACTION_READ_LINK	1024
#define ACTION_FH_FROM_LOCK	1026
#define ACTION_IS_FILESYSTEM	1027
#define ACTION_CHANGE_MODE	1028

#define ACTION_COPY_DIR_FH	1030
#define ACTION_PARENT_FH	1031
#define ACTION_EXAMINE_ALL	1033
#define ACTION_EXAMINE_FH	1034
#define ACTION_LOCK_RECORD	2008
#define ACTION_FREE_RECORD	2009
#define ACTION_ADD_NOTIFY	4097
#define ACTION_REMOVE_NOTIFY	4098

#define ACTION_EXAMINE_ALL_END	1035
#define ACTION_SET_OWNER	1036

#define	ACTION_SERIALIZE_DISK	4200

OBJECT ErrorString
 
	Nums:PTR TO LONG
	Strings:PTR TO UBYTE
ENDOBJECT


OBJECT DosLibrary
 
      lib:Library
      Root:PTR TO RootNode 
    GV:LONG	      
    A2:LONG	      
    A5:LONG
    A6:LONG
      Errors:PTR TO ErrorString	  
      TimeReq:PTR TO timerequest	  
          UtilityBase:PTR TO Library   
          IntuitionBase:PTR TO Library 
ENDOBJECT 

OBJECT RootNode
 
    TaskArray:LONG	     
    ConsoleSegment:LONG 
       Time:DateStamp 
    RestartSeg:LONG     
    Info:LONG	       
    FileHandlerSegment:LONG 
      CliList:MinList 
			       
      BootProc:PTR TO MsgPort 
    ShellSegment:LONG   
    Flags:LONG	       
ENDOBJECT 
#define RNB_WILDSTAR	24
#define RNF_WILDSTAR	(1<<24)
#define RNB_PRIVATE1	1	
#define RNF_PRIVATE1	2

OBJECT CliProcList
 
	  Node:MinNode
	First:LONG	     
	  Array:LONG
			     
ENDOBJECT

OBJECT DosInfo
 
    McName:LONG	       
    DevInfo:LONG	       
    Devices:LONG	       
    Handlers:LONG       
    NetHand:LONG	       
       DevLock:SignalSemaphore	   
       EntryLock:SignalSemaphore  
       DeleteLock:SignalSemaphore 
ENDOBJECT 

#define di_ResList di_McName

OBJECT Segment
 
	Next:LONG
	UC:LONG
	Seg:LONG
	Name[4]:UBYTE	
ENDOBJECT

#define CMD_SYSTEM	-1
#define CMD_INTERNAL	-2
#define CMD_DISABLED	-999

OBJECT CommandLineInterface
 
    Result2:LONG	       
    SetName:LONG->BSTR	       
    CommandDir:LONG     
    ReturnCode:LONG     
    CommandName:LONG->BSTR    
    FailLevel:LONG      
    Prompt:LONG->BSTR	       
    StandardInput:LONG  
    CurrentInput:LONG   
    CommandFile:LONG->BSTR    
    Interactive:LONG    
    Background:LONG     
    CurrentOutput:LONG  
    DefaultStack:LONG   
    StandardOutput:LONG 
    Module:LONG	       
ENDOBJECT 


OBJECT DeviceList
 
    Next:LONG	
    Type:LONG	
      	Task:PTR TO MsgPort	
    Lock:LONG	
     	VolumeDate:DateStamp	
    LockList:LONG	
    DiskType:LONG	
    unused:LONG
    Name:LONG->BSTR	
ENDOBJECT


OBJECT DevInfo
 
    Next:LONG
    Type:LONG
    Task:LONG
    Lock:LONG
    Handler:LONG->BSTR
    StackSize:LONG
    Priority:LONG
    Startup:LONG
    SegList:LONG
    GlobVec:LONG
    Name:LONG->BSTR
ENDOBJECT


OBJECT DosList
 
    Next:LONG	 
    Type:LONG	 
          Task:PTR TO MsgPort	 
    Lock:LONG
     UNION misc

	 OBJECT handler

	Handler:LONG->BSTR	
	StackSize:LONG	
	Priority:LONG	
	Startup:LONG	
	SegList:LONG	
	GlobVec:LONG	
	 ENDOBJECT
	 OBJECT volume

	 	VolumeDate:DateStamp	 
	LockList:LONG	 
	DiskType:LONG	 
	 ENDOBJECT
	 OBJECT assign

	AssignName:PTR TO UBYTE     
	  List:PTR TO AssignList 
	 ENDOBJECT
     ENDUNION
    Name:LONG->BSTR	 
    ENDOBJECT


OBJECT AssignList
 
	  Next:PTR TO AssignList
	Lock:LONG
ENDOBJECT


#define DLT_DEVICE	0
#define DLT_DIRECTORY	1	
#define DLT_VOLUME	2
#define DLT_LATE	3	
#define DLT_NONBINDING	4	
#define DLT_PRIVATE	-1	

OBJECT DevProc
 
	  Port:PTR TO MsgPort
	Lock:LONG
	Flags:LONG
	  DevNode:PTR TO DosList	
ENDOBJECT


#define DVPB_UNLOCK	0
#define DVPF_UNLOCK	(1 << DVPB_UNLOCK)
#define DVPB_ASSIGN	1
#define DVPF_ASSIGN	(1 << DVPB_ASSIGN)

#define LDB_DEVICES	2
#define LDF_DEVICES	(1 << LDB_DEVICES)
#define LDB_VOLUMES	3
#define LDF_VOLUMES	(1 << LDB_VOLUMES)
#define LDB_ASSIGNS	4
#define LDF_ASSIGNS	(1 << LDB_ASSIGNS)
#define LDB_ENTRY	5
#define LDF_ENTRY	(1 << LDB_ENTRY)
#define LDB_DELETE	6
#define LDF_DELETE	(1 << LDB_DELETE)

#define LDB_READ	0
#define LDF_READ	(1 << LDB_READ)
#define LDB_WRITE	1
#define LDF_WRITE	(1 << LDB_WRITE)

#define LDF_ALL		(LDF_DEVICESORLDF_VOLUMESORLDF_ASSIGNS)

OBJECT FileLock
 
    Link:LONG	
    Key:LONG		
    Access:LONG	
      	Task:PTR TO MsgPort	
    Volume:LONG	
ENDOBJECT


#define REPORT_STREAM		0	
#define REPORT_TASK		1	
#define REPORT_LOCK		2	
#define REPORT_VOLUME		3	
#define REPORT_INSERT		4	

#define ABORT_DISK_ERROR	296	
#define ABORT_BUSY		288	


#define RUN_EXECUTE		-1
#define RUN_SYSTEM		-2
#define RUN_SYSTEM_ASYNCH	-3





#define ST_ROOT		1
#define ST_USERDIR	2
#define ST_SOFTLINK	3	
#define ST_LINKDIR	4	
#define ST_FILE		-3	
#define ST_LINKFILE	-4	
#define ST_PIPEFILE	-5	
#endif	
