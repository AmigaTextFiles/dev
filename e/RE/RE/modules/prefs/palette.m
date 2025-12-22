#ifndef PREFS_PALETTE_H
#define PREFS_PALETTE_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif
#ifndef INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif

#define ID_PALT MAKE_ID("P","A","L","T")
OBJECT PalettePrefs

    Reserved[4]:LONG	 
    4ColorPens[32]:UWORD
    8ColorPens[32]:UWORD
      Colors[32]:ColorSpec	 
ENDOBJECT


#endif 
