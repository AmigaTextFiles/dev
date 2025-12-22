#ifndef PREFS_SCREENMODE_H
#define PREFS_SCREENMODE_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_SCRM MAKE_ID("S","C","R","M")
OBJECT ScreenModePrefs

    Reserved[4]:LONG
    DisplayID:LONG
    Width:UWORD
    Height:UWORD
    Depth:UWORD
    Control:UWORD
ENDOBJECT


#define SMB_AUTOSCROLL 1
#define SMF_AUTOSCROLL (1<<0)

#endif 
