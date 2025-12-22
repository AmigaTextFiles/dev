#ifndef DOS_RDARGS_H
#define DOS_RDARGS_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif

OBJECT CSource
 
	Buffer:PTR TO UBYTE
	Length:LONG
	CurChr:LONG
ENDOBJECT


OBJECT RDArgs
 
		 Source:CSource	
	DAList:LONG		
	Buffer:PTR TO UBYTE		
	BufSiz:LONG		
	ExtHelp:PTR TO UBYTE		
	Flags:LONG		
ENDOBJECT

#define RDAB_STDIN	0	
#define RDAF_STDIN	1
#define RDAB_NOALLOC	1	
#define RDAF_NOALLOC	2
#define RDAB_NOPROMPT	2	
#define RDAF_NOPROMPT	4

#define MAX_TEMPLATE_ITEMS	100

#define MAX_MULTIARGS		128
#endif 
