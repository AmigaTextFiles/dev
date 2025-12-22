#ifndef DEVICES_BOOTBLOCK_H
#define DEVICES_BOOTBLOCK_H

#ifndef EXEC_TYPES_H
MODULE 	'exec/types'
#endif
OBJECT BootBlock
 
	id[4]:UBYTE		
	chksum:LONG		
	dosblock:LONG		
ENDOBJECT

#define		BOOTSECTS	2	
#define BBID_DOS	{ "D", "O", "S", "\0" }
#define BBID_KICK	{ "K", "I", "C", "K" }
#define BBNAME_DOS	$444F5300	
#define BBNAME_KICK	$4B49434B	
#endif	
