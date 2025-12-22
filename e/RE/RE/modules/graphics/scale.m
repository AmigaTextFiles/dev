#ifndef	GRAPHICS_SCALE_H
#define	GRAPHICS_SCALE_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
OBJECT BitScaleArgs
 
    SrcX:UWORD
 SrcY:UWORD			
    SrcWidth:UWORD
 SrcHeight:UWORD	
    XSrcFactor:UWORD
 YSrcFactor:UWORD	
    DestX:UWORD
 DestY:UWORD		
    DestWidth:UWORD
 DestHeight:UWORD	
    XDestFactor:UWORD
 YDestFactor:UWORD	
      SrcBitMap:PTR TO BitMap		
      DestBitMap:PTR TO BitMap		
    Flags:LONG				
    XDDA:UWORD
 YDDA:UWORD			
    Reserved1:LONG
    Reserved2:LONG
ENDOBJECT
#endif	
