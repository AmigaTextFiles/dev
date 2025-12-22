#ifndef PREFS_FONT_H
#define PREFS_FONT_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif
#ifndef GRAPHICS_TEXT_H
MODULE  'graphics/text'
#endif

#define ID_FONT MAKE_ID("F","O","N","T")
#define FONTNAMESIZE (128)
OBJECT FontPrefs

    Reserved[3]:LONG
    Reserved2:UWORD
    Type:UWORD
    FrontPen:UBYTE
    BackPen:UBYTE
    DrawMode:UBYTE
      TextAttr:TextAttr
    Name[FONTNAMESIZE]:BYTE
ENDOBJECT


#define FP_WBFONT     0
#define FP_SYSFONT    1
#define FP_SCREENFONT 2

#endif 
