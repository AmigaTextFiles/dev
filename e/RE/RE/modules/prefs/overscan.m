#ifndef PREFS_OVERSCAN_H
#define PREFS_OVERSCAN_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif
#ifndef GRAPHICS_GFX_H
MODULE  'graphics/gfx'
#endif

#define ID_OSCN MAKE_ID("O","S","C","N")
#define OSCAN_MAGIC  $FEDCBA89
OBJECT OverscanPrefs

    Reserved:LONG
    Magic:LONG
    HStart:UWORD
    HStop:UWORD
    VStart:UWORD
    VStop:UWORD
    DisplayID:LONG
    ViewPos:Point
    Text:Point
      Standard:Rectangle
ENDOBJECT



#endif 
