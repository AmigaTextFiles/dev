#ifndef EXEC_EXECBASE_H
#define EXEC_EXECBASE_H

#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif 
#ifndef EXEC_INTERRUPTS_H
MODULE  'exec/interrupts'
#endif 
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif 
#ifndef EXEC_TASKS_H
MODULE  'exec/tasks'
#endif 

OBJECT ExecBase
 
	  LibNode:Library 

	SoftVer:UWORD	
	LowMemChkSum:WORD	
	ChkBase:LONG	
	ColdCapture:LONG	
	CoolCapture:LONG	
	WarmCapture:LONG	
	SysStkUpper:LONG	
	SysStkLower:LONG	
	MaxLocMem:LONG	
	DebugEntry:LONG	
	DebugData:LONG	
	AlertData:LONG	
	MaxExtMem:LONG	
	ChkSum:UWORD	

		 IntVects[16]:IntVector

		 ThisTask:PTR TO Task 
	IdleCount:LONG	
	DispCount:LONG	
	Quantum:UWORD	
	Elapsed:UWORD	
	SysFlags:UWORD	
	IDNestCnt:BYTE	
	TDNestCnt:BYTE	
	AttnFlags:UWORD	
	AttnResched:UWORD	
	ResModules:LONG	
	TaskTrapCode:LONG
	TaskExceptCode:LONG
	TaskExitCode:LONG
	TaskSigAlloc:LONG
	TaskTrapAlloc:UWORD

		 MemList:List
		 ResourceList:List
		 DeviceList:List
		 IntrList:List
		 LibList:List
		 PortList:List
		 TaskReady:List
		 TaskWait:List
		 SoftInts[5]:SoftIntList

	LastAlert[4]:LONG
	
	VBlankFrequency:UBYTE	
	PowerSupplyFrequency:UBYTE	
		 SemaphoreList:List
	
	KickMemPtr:LONG	
	KickTagPtr:LONG	
	KickCheckSum:LONG	

	Pad0:UWORD		
	LaunchPoint:LONG		
	RamLibPrivate:LONG
	
	EClockFrequency:LONG	
	CacheControl:LONG	
	TaskID:LONG		
	Reserved1[5]:LONG
	MMULock:LONG		
	Reserved2[3]:LONG

	
			MemHandlers:MinList	
	MemHandler:LONG		
ENDOBJECT



#define AFB_68010	0	
#define AFB_68020	1	
#define AFB_68030	2	
#define AFB_68040	3
#define AFB_68881	4	
#define AFB_68882	5
#define	AFB_FPU40	6	

#define AFB_PRIVATE	15	
#define AFF_68010	(1<<0)
#define AFF_68020	(1<<1)
#define AFF_68030	(1<<2)
#define AFF_68040	(1<<3)
#define AFF_68881	(1<<4)
#define AFF_68882	(1<<5)
#define	AFF_FPU40	(1<<6)
#define AFF_PRIVATE	(1<<15)



#define CACRF_EnableI	    (1<<0)  
#define CACRF_FreezeI	    (1<<1)  
#define CACRF_ClearI	    (1<<3)  
#define CACRF_IBE	    (1<<4)  
#define CACRF_EnableD	    (1<<8)  
#define CACRF_FreezeD	    (1<<9)  
#define CACRF_ClearD	    (1<<11) 
#define CACRF_DBE	    (1<<12) 
#define CACRF_WriteAllocate (1<<13) 
#define	CACRF_EnableE	    (1<<30) 
				     
				     
				     
				     
				     
#define CACRF_CopyBack	    (1<<31) 
#define DMA_Continue	    (1<<1)  
#define DMA_NoModify	    (1<<2)  
#define	DMA_ReadFromRAM     (1<<3)  
#endif	
