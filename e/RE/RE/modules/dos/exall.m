#ifndef DOS_EXALL_H
#define DOS_EXALL_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef UTILITY_HOOKS_H
MODULE  'utility/hooks'
#endif








#define	ED_NAME		1
#define	ED_TYPE		2
#define ED_SIZE		3
#define ED_PROTECTION	4
#define ED_DATE		5
#define ED_COMMENT	6
#define ED_OWNER	7

OBJECT ExAllData
 
	  Next:PTR TO ExAllData
	Name:PTR TO UBYTE
	Type:LONG
	Size:LONG
	Prot:LONG
	Days:LONG
	Mins:LONG
	Ticks:LONG
	Comment:PTR TO UBYTE	
	OwnerUID:UWORD	
	OwnerGID:UWORD
ENDOBJECT


OBJECT ExAllControl
 
	Entries:LONG	 
	LastKey:LONG	 
	MatchString:PTR TO UBYTE 
	  MatchFunc:PTR TO Hook 
ENDOBJECT

#endif 
