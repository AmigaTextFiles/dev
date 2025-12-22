#ifndef PREFS_PREFHDR_H
#define PREFS_PREFHDR_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_PREF	 MAKE_ID("P","R","E","F")
#define ID_PRHD	 MAKE_ID("P","R","H","D")
OBJECT PrefHeader

    Version:UBYTE	
    Type:UBYTE	
    Flags:LONG	
ENDOBJECT


#endif 
