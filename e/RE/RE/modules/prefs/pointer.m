#ifndef PREFS_POINTER_H
#define PREFS_POINTER_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_PNTR MAKE_ID("P","N","T","R")

OBJECT PointerPrefs

    Reserved[4]:LONG
    Which:UWORD				
    Size:UWORD				
    Width:UWORD				
    Height:UWORD				
    Depth:UWORD				
    YSize:UWORD				
    X:UWORD
 Y:UWORD				
    
    
ENDOBJECT



#define	WBP_NORMAL	0
#define	WBP_BUSY	1

OBJECT RGBTable

    Red:UBYTE
    Green:UBYTE
    Blue:UBYTE
ENDOBJECT


#endif 
