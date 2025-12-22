/* $VER: bootblock.h 36.6 (5.11.1990) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types'
{#include <devices/bootblock.h>}
NATIVE {DEVICES_BOOTBLOCK_H} CONST

NATIVE {BootBlock} OBJECT bb
	{bb_id}	id[4]	:ARRAY OF UBYTE		/* 4 character identifier */
	{bb_chksum}	chksum	:VALUE		/* boot block checksum (balance) */
	{bb_dosblock}	dosblock	:VALUE		/* reserved for DOS patch */
ENDOBJECT

NATIVE {BOOTSECTS}	CONST BOOTSECTS	= 2	/* 1K bootstrap */

NATIVE {BBID_DOS}	CONST ->#BBID_DOS	= { "D", "O", "S", "\0" }
#define BBID_DOS bbid_dos
STATIC bbid_dos = ["D","O","S","\0"]:CHAR
NATIVE {BBID_KICK}	CONST ->#BBID_KICK	= { "K", "I", "C", "K" }
#define BBID_KICK bbid_kick
STATIC bbid_kick = ["K","I","C","K"]:CHAR

NATIVE {BBNAME_DOS}	CONST BBNAME_DOS	= $444F5300	/* 'DOS\0' */
NATIVE {BBNAME_KICK}	CONST BBNAME_KICK	= $4B49434B	/* 'KICK' */
