#ifndef INTUITION_SGHOOKS_H
#define INTUITION_SGHOOKS_H TRUE

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
OBJECT StringExtend
 
    
      Font:PTR TO TextFont	
    Pens[2]:UBYTE	
    ActivePens[2]:UBYTE	
    
    InitialModes:LONG	
      EditHook:PTR TO Hook	
    WorkBuffer:PTR TO UBYTE	
    Reserved[4]:LONG	
ENDOBJECT

OBJECT SGWork
	
    
     	Gadget:PTR TO Gadget	
     	StringInfo:PTR TO StringInfo	
    WorkBuffer:PTR TO UBYTE	
    PrevBuffer:PTR TO UBYTE	
    Modes:LONG		
    
     	IEvent:PTR TO InputEvent	
    Code:UWORD		
    BufferPos:WORD	
    NumChars:WORD
    Actions:LONG	
    LongInt:LONG	
     	GadgetInfo:PTR TO GadgetInfo	
    EditOp:UWORD		
ENDOBJECT


#define EO_NOOP		$($0001)
	
#define EO_DELBACKWARD	$($0002)
	
#define EO_DELFORWARD	$($0003)
	
#define EO_MOVECURSOR	$($0004)
	
#define EO_ENTER	$($0005)
	
#define EO_RESET	$($0006)
	
#define EO_REPLACECHAR	$($0007)
	
#define EO_INSERTCHAR	$($0008)
	
#define EO_BADFORMAT	$($0009)
	
#define EO_BIGCHANGE	$($000A)	
	
#define EO_UNDO		$($000B)	
	
#define EO_CLEAR	$($000C)
	
#define EO_SPECIAL	$($000D)	
	

#define SGM_REPLACE	(1 << 0)	

#define SGM_FIXEDFIELD	(1 << 1)	
					
#define SGM_NOFILTER	(1 << 2)	

#define SGM_EXITHELP	(1 << 7)	

#define SGM_NOCHANGE	(1 << 3)	
#define SGM_NOWORKB	(1 << 4)	
#define SGM_CONTROL	(1 << 5)	
#define SGM_LONGINT	(1 << 6)	

#define SGA_USE		$($1)	
#define SGA_END		$($2)	
#define SGA_BEEP	$($4)	
#define SGA_REUSE	$($8)	
#define SGA_REDISPLAY	$($10)	

#define SGA_NEXTACTIVE	$($20)	
#define SGA_PREVACTIVE	$($40)	

#define SGH_KEY		(1)	
#define SGH_CLICK	(2)	

#endif
