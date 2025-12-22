#ifndef PREFS_ICONTROL_H
#define PREFS_ICONTROL_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_ICTL MAKE_ID("I","C","T","L")
OBJECT IControlPrefs

    Reserved[4]:LONG	
    TimeOut:UWORD		
    MetaDrag:WORD		
    Flags:LONG		
    WBtoFront:UBYTE		
    FrontToBack:UBYTE	
    ReqTrue:UBYTE		
    ReqFalse:UBYTE		
ENDOBJECT


#define ICB_COERCE_COLORS 0
#define ICB_COERCE_LACE   1
#define ICB_STRGAD_FILTER 2
#define ICB_MENUSNAP	  3
#define ICB_MODEPROMOTE   4
#define ICF_COERCE_COLORS (1<<0)
#define ICF_COERCE_LACE   (1<<1)
#define ICF_STRGAD_FILTER (1<<2)
#define ICF_MENUSNAP	  (1<<3)
#define ICF_MODEPROMOTE   (1<<4)

#endif 
