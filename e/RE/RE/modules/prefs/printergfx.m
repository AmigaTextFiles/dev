#ifndef PREFS_PRINTERGFX_H
#define PREFS_PRINTERGFX_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_PGFX MAKE_ID("P","G","F","X")
OBJECT PrinterGfxPrefs

    Reserved[4]:LONG
    Aspect:UWORD
    Shade:UWORD
    Image:UWORD
    Threshold:WORD
    ColorCorrect:UBYTE
    Dimensions:UBYTE
    Dithering:UBYTE
    GraphicFlags:UWORD
    PrintDensity:UBYTE		
    PrintMaxWidth:UWORD
    PrintMaxHeight:UWORD
    PrintXOffset:UBYTE
    PrintYOffset:UBYTE
ENDOBJECT


#define PA_HORIZONTAL 0
#define PA_VERTICAL   1

#define PS_BW		0
#define PS_GREYSCALE	1
#define PS_COLOR	2
#define PS_GREY_SCALE2	3

#define PI_POSITIVE 0
#define PI_NEGATIVE 1

#define PCCB_RED   1	
#define PCCB_GREEN 2	
#define PCCB_BLUE  3	
#define PCCF_RED   (1<<0)
#define PCCF_GREEN (1<<1)
#define PCCF_BLUE  (1<<2)

#define PD_IGNORE   0  
#define PD_BOUNDED  1  
#define PD_ABSOLUTE 2  
#define PD_PIXEL    3  
#define PD_MULTIPLY 4  

#define PD_ORDERED	0  
#define PD_HALFTONE	1  
#define PD_FLOYD	2  

#define PGFB_CENTER_IMAGE	0	
#define PGFB_INTEGER_SCALING	1	
#define PGFB_ANTI_ALIAS		2	
#define PGFF_CENTER_IMAGE	(1<<0)
#define PGFF_INTEGER_SCALING	(1<<1)
#define PGFF_ANTI_ALIAS		(1<<2)

#endif 
