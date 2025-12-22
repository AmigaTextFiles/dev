/*
	target.inc

	Default Target Specification
	You should create your own target.inc file containing
	the:
	  * CPU type (#arch <deviceName>)
	  * additional include files, that are required by your C programs
	  * additional segment allocation, if memory mapped port are 
	    present in your system

	and include it in every assembler source.

	Uros Platise, (c) 24. Januar 1999
*/

#ifndef __TARGET
#define __TARGET

/* your memory size if present */
;#define __ERAM_SIZE

/* your chip */
;#arch AT90S8515

/* additional default include directories */
;#adddir "..."

/* additional include files */
;#include "..."

/* put your declarations here of the memory mapped ports and 
   other memory holes that should not be used by ava */
;seg abs=? size=? eram.?

#endif
