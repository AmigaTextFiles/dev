#ifndef PREFS_WBPATTERN_H
#define PREFS_WBPATTERN_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_PTRN MAKE_ID("P","T","R","N")

OBJECT WBPatternPrefs

    Reserved[4]:LONG
    Which:UWORD			
    Flags:UWORD
    Revision:BYTE			
    Depth:BYTE			
    DataLength:UWORD		
ENDOBJECT



#define	WBP_ROOT	0
#define	WBP_DRAWER	1
#define	WBP_SCREEN	2

#define	WBPF_PATTERN	$0001
    
#define	WBPF_NOREMAP	$0010
    

#define MAXDEPTH	3	
#define DEFPATDEPTH	2	

#define PAT_WIDTH	16
#define PAT_HEIGHT	16

#endif 
