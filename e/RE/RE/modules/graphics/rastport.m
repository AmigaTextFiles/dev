#ifndef	GRAPHICS_RASTPORT_H
#define	GRAPHICS_RASTPORT_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef GRAPHICS_GFX_H
MODULE  'graphics/gfx'
#endif

OBJECT AreaInfo

    VctrTbl:PTR TO WORD	     
    VctrPtr:PTR TO WORD	     
    FlagTbl:PTR TO BYTE	      
    FlagPtr:PTR TO BYTE	      
    Count:WORD	     
    MaxCount:WORD	     
    FirstX:WORD
FirstY:WORD    
ENDOBJECT

OBJECT TmpRas

    RasPtr:PTR TO BYTE
    Size:LONG
ENDOBJECT


OBJECT GelsInfo

    sprRsrvd:BYTE	      
    Flags:UBYTE	      
      gelHead:PTR TO VSprite
 gelTail:PTR TO VSprite 
    
    nextLine:PTR TO WORD
    
    lastColor:LONG
      collHandler:PTR TO collTable     
    leftmost:WORD
 rightmost:WORD
 topmost:WORD
 bottommost:WORD
   firstBlissObj:LONG
lastBlissObj:LONG    
ENDOBJECT

OBJECT RastPort

       Layer:PTR TO Layer
         BitMap:PTR TO BitMap
    AreaPtrn:PTR TO UWORD	     
       TmpRas:PTR TO TmpRas
       AreaInfo:PTR TO AreaInfo
       GelsInfo:PTR TO GelsInfo
    Mask:UBYTE             
    FgPen:BYTE	      
    BgPen:BYTE	      
    AOlPen:BYTE	      
    DrawMode:BYTE	      
    AreaPtSz:BYTE	      
    linpatcnt:BYTE	      
    dummy:BYTE
    Flags:UWORD	     
    LinePtrn:UWORD	     
    x:WORD
 y:WORD	     
    minterms[8]:UBYTE
    PenWidth:WORD
    PenHeight:WORD
       Font:PTR TO TextFont   
    AlgoStyle:UBYTE	      
    TxFlags:UBYTE	      
    TxHeight:UWORD	      
    TxWidth:UWORD	      
    TxBaseline:UWORD       
    TxSpacing:WORD	      
    User:PTR TO LONG
    longreserved[2]:LONG
#ifndef GFX_RASTPORT_1_2
    wordreserved[7]:UWORD  
    reserved[8]:UBYTE      
#endif
ENDOBJECT

#define RP_JAM1	    0	      
#define RP_JAM2	    1	      
#define RP_COMPLEMENT  2	      
#define RP_INVERSVID   4	      

#define FRST_DOT    $01      
#define ONE_DOT     $02      
#define DBUFFER     $04      
	     
#define AREAOUTLINE $08      
#define NOCROSSFILL $20      



#endif	
