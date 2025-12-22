#ifndef  DISKFONT_GLYPH_H
#define  DISKFONT_GLYPH_H

#ifndef  EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef  EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef  EXEC_NODES_H
MODULE  'exec/nodes'
#endif

OBJECT GlyphEngine
 
      Library:PTR TO Library 
    Name:LONG		
    
ENDOBJECT

  
#define FIXED LONG	
OBJECT GlyphMap
 
    BMModulo:UWORD	
    BMRows:UWORD		
    BlackLeft:UWORD	
    BlackTop:UWORD	
    BlackWidth:UWORD	
    BlackHeight:UWORD	
    XOrigin:FIXED	
    YOrigin:FIXED	
    X0:WORD		
    Y0:WORD		
    X1:WORD		
    Y1:WORD		
    Width:FIXED		
    BitMap:PTR TO UBYTE		
ENDOBJECT

OBJECT GlyphWidthEntry
 
      Node:MinNode	
    Code:UWORD		
    Width:FIXED		
ENDOBJECT
#endif	 
