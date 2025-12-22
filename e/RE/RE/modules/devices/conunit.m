#ifndef DEVICES_CONUNIT_H
#define DEVICES_CONUNIT_H

#ifndef	EXEC_TYPES_H
MODULE 	'exec/types'
#endif
#ifndef EXEC_PORTS_H
MODULE 	'exec/ports'
#endif
#ifndef DEVICES_CONSOLE_H
MODULE 	'devices/console'
#endif
#ifndef DEVICES_KEYMAP_H
MODULE 	'devices/keymap'
#endif
#ifndef DEVICES_INPUTEVENT_H
MODULE 	'devices/inputevent'
#endif

#define	CONU_LIBRARY	-1	
#define	CONU_STANDARD	0	

#define	CONU_CHARMAP	1	
#define	CONU_SNIPMAP	3	

#define CONFLAG_DEFAULT			0
#define CONFLAG_NODRAW_ON_NEWSIZE	1
#define	PMB_ASM		(M_LNM+1)	
#define	PMB_AWM		(PMB_ASM+1)	
#define	MAXTABS		80
OBJECT ConUnit
 
       MP:MsgPort
    
       Window:PTR TO Window	
    XCP:WORD		
    YCP:WORD
    XMax:WORD		
    YMax:WORD
    XRSize:WORD		
    YRSize:WORD
    XROrigin:WORD	
    YROrigin:WORD
    XRExtant:WORD	
    YRExtant:WORD
    XMinShrink:WORD	
    YMinShrink:WORD
    XCCP:WORD		
    YCCP:WORD
    
    
       KeyMapStruct:KeyMap
    
    TabStops[MAXTABS]:UWORD 
    
    Mask:BYTE
    FgPen:BYTE
    BgPen:BYTE
    AOLPen:BYTE
    DrawMode:BYTE
    Obsolete1:BYTE	
    Obsolete2:LONG	
    Minterms[8]:UBYTE	
       Font:PTR TO TextFont
    AlgoStyle:UBYTE
    TxFlags:UBYTE
    TxHeight:UWORD
    TxWidth:UWORD
    TxBaseline:UWORD
    TxSpacing:WORD
    
    Modes[(PMB_AWM+7)/8]:UBYTE	
    RawEvents[(IECLASS_MAX+8)/8]:UBYTE
ENDOBJECT

#endif	
