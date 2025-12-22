#ifndef PREFS_SOUND_H
#define PREFS_SOUND_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_SOND MAKE_ID("S","O","N","D")
OBJECT SoundPrefs

    Reserved[4]:LONG	      
    DisplayQueue:BOOL	      
    AudioQueue:BOOL	      
    AudioType:UWORD	      
    AudioVolume:UWORD	      
    AudioPeriod:UWORD	      
    AudioDuration:UWORD	      
    AudioFileName[256]:LONG     
ENDOBJECT


#define SPTYPE_BEEP	0	
#define SPTYPE_SAMPLE	1	

#endif 
