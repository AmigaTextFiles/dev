#ifndef PREFS_SERIAL_H
#define PREFS_SERIAL_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_SERL MAKE_ID("S","E","R","L")
OBJECT SerialPrefs

    Reserved[3]:LONG		
    Unit0Map:LONG			
    BaudRate:LONG			
    InputBuffer:LONG		
    OutputBuffer:LONG		
    InputHandshake:UBYTE		
    OutputHandshake:UBYTE		
    Parity:UBYTE			
    BitsPerChar:UBYTE		
    StopBits:UBYTE			
ENDOBJECT


#define PARITY_NONE	0
#define PARITY_EVEN	1
#define PARITY_ODD	2
#define PARITY_MARK	3		
#define PARITY_SPACE	4		

#define HSHAKE_XON	0
#define HSHAKE_RTS	1
#define HSHAKE_NONE	2

#endif 
