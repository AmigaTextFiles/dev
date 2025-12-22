#ifndef PREFS_INPUT_H
#define PREFS_INPUT_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif
#ifndef DEVICES_TIMER_H
MODULE  'devices/timer'
#endif

#define ID_INPT MAKE_ID("I","N","P","T")
OBJECT InputPrefs

    Keymap[16]:LONG
    PointerTicks:UWORD
      DoubleClick:timeval
      KeyRptDelay:timeval
      KeyRptSpeed:timeval
    MouseAccel:WORD
ENDOBJECT


#endif 
