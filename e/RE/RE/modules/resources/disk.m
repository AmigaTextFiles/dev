#ifndef	RESOURCES_DISK_H
#define RESOURCES_DISK_H

#ifndef	EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef	EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef	EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef	EXEC_INTERRUPTS_H
MODULE  'exec/interrupts'
#endif
#ifndef	EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif

OBJECT DiscResourceUnit
 
      Message:Message
      DiscBlock:Interrupt
      DiscSync:Interrupt
      Index:Interrupt
ENDOBJECT

OBJECT DiscResource
 
     		Library:Library
     	Current:PTR TO DiscResourceUnit
    Flags:UBYTE
    pad:UBYTE
     		SysLib:PTR TO Library
     		CiaResource:PTR TO Library
    UnitID[4]:LONG
     		Waiting:List
     		DiscBlock:Interrupt
     		DiscSync:Interrupt
     		Index:Interrupt
     			CurrTask:PTR TO Task
ENDOBJECT


#define DRB_ALLOC0	0	
#define DRB_ALLOC1	1	
#define DRB_ALLOC2	2	
#define DRB_ALLOC3	3	
#define DRB_ACTIVE	7	
#define DRF_ALLOC0	(1<<0)	
#define DRF_ALLOC1	(1<<1)	
#define DRF_ALLOC2	(1<<2)	
#define DRF_ALLOC3	(1<<3)	
#define DRF_ACTIVE	(1<<7)	

#define	DSKDMAOFF	$4000	


#define DISKNAME	'disk.resource'
#define	DR_ALLOCUNIT	(LIB_BASE - 0*LIB_VECTSIZE)
#define	DR_FREEUNIT	(LIB_BASE - 1*LIB_VECTSIZE)
#define	DR_GETUNIT	(LIB_BASE - 2*LIB_VECTSIZE)
#define	DR_GIVEUNIT	(LIB_BASE - 3*LIB_VECTSIZE)
#define	DR_GETUNITID	(LIB_BASE - 4*LIB_VECTSIZE)
#define	DR_READUNITID	(LIB_BASE - 5*LIB_VECTSIZE)
#define	DR_LASTCOMM	(DR_READUNITID)

#define	DRT_AMIGA	$($00000000)
#define	DRT_37422D2S	$($55555555)
#define DRT_EMPTY	$($FFFFFFFF)
#define DRT_150RPM	$($AAAAAAAA)
#endif 
