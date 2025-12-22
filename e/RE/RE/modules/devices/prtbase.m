#ifndef  DEVICES_PRTBASE_H
#define  DEVICES_PRTBASE_H

#ifndef  EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef  EXEC_NODES_H
MODULE  'exec/nodes'
#endif
#ifndef  EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef  EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef  EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef  EXEC_TASKS_H
MODULE  'exec/tasks'
#endif
#ifndef  DEVICES_PARALLEL_H
MODULE  'devices/parallel'
#endif
#ifndef  DEVICES_SERIAL_H
MODULE  'devices/serial'
#endif
#ifndef  DEVICES_TIMER_H
MODULE  'devices/timer'
#endif
#ifndef  LIBRARIES_DOSEXTENS_H
MODULE  'libraries/dosextens'
#endif
#ifndef  INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif
OBJECT DeviceData
 
      Device:Library 
    Segment:LONG	      
    ExecBase:LONG	      
    CmdVectors:LONG       
    CmdBytes:LONG	      
    NumCommands:UWORD   
ENDOBJECT

#define P_OLDSTKSIZE	$0800	
#define P_STKSIZE	$1000	
#define P_BUFSIZE	256	
#define P_SAFESIZE	128	
OBJECT PrinterData
 
	  Device:DeviceData
	  Unit:MsgPort	
	PrinterSegment:LONG	
	PrinterType:UWORD	
				
	  SegmentData:PTR TO PrinterSegment
	PrintBuf:PTR TO UBYTE	
	PWrite:LONG	
	PBothReady:LONG	
	 UNION ior0
			
		  p0:IOExtPar
		  s0:IOExtSer
	 ENDUNION
	 UNION ior1
			
		  p1:IOExtPar
		  s1:IOExtSer
	 ENDUNION
	  TIOR:timerequest	
	  IORPort:MsgPort	
	  TC:Task		
	OldStk[P_OLDSTKSIZE]:UBYTE	
	Flags:UBYTE			
	pad:UBYTE			
	  Preferences:Preferences	
	PWaitEnabled:UBYTE		
	
	Flags1:UBYTE		
	Stk[P_STKSIZE]:UBYTE	
ENDOBJECT
/*
#define  pd_PIOR0 pd_ior0pd_ior0pd_p0
#define  pd_SIOR0 pd_ior0pd_ior0pd_s0

#define  pd_PIOR1 pd_ior1pd_ior1pd_p1
#define  pd_SIOR1 pd_ior1pd_ior1pd_s1
*/
#define PPCB_GFX	0	
#define PPCF_GFX	$1	
#define PPCB_COLOR	1	
#define PPCF_COLOR	$2	
#define PPC_BWALPHA	$00	
#define PPC_BWGFX	$01	
#define PPC_COLORALPHA	$02	
#define PPC_COLORGFX	$03	

#define	PCC_BW		$01	
#define	PCC_YMC		$02	
#define	PCC_YMC_BW	$03	
#define	PCC_YMCB	$04	
#define	PCC_4COLOR	$04	
#define	PCC_ADDITIVE	$08	
#define	PCC_WB		$09	
#define	PCC_BGR		$0A	
#define	PCC_BGR_WB	$0B	
#define	PCC_BGRW	$0C	

#define PCC_MULTI_PASS	$10	
OBJECT PrinterExtendedData
 
	PrinterName:LONG    
	Init:LONG	     
	Expunge:LONG    
	Open:LONG	     
	Close:LONG      
	PrinterClass:UBYTE    
	ColorClass:UBYTE      
	MaxColumns:UBYTE      
	NumCharSets:UBYTE     
	NumRows:UWORD	     
	MaxXDots:LONG	     
	MaxYDots:LONG	     
	XDotsInch:UWORD	     
	YDotsInch:UWORD	     
	Commands:LONG     
	DoSpecial:LONG  
	Render:LONG     
	TimeoutSecs:LONG     
	
	EightBitChars:LONG     
	PrintMode:LONG	     
	
	
	ConvFunc:LONG
ENDOBJECT

OBJECT PrinterSegment
 
    NextSegment:LONG	 
    runAlert:LONG	 
    Version:UWORD	 
    Revision:UWORD	 
       PED:PrinterExtendedData   
ENDOBJECT
#endif
