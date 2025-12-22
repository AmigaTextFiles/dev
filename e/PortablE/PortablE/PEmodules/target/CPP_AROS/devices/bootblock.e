/* $Id: bootblock.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types'
{#include <devices/bootblock.h>}
NATIVE {DEVICES_BOOTBLOCK_H} CONST

NATIVE {BootBlock} OBJECT bb
    {bb_id}	id[4]	:ARRAY OF UBYTE
    {bb_chksum}	chksum	:VALUE
    {bb_dosblock}	dosblock	:VALUE
ENDOBJECT

NATIVE {BOOTSECTS}	    	CONST BOOTSECTS	    	= 2

NATIVE {BBID_DOS}	    	CONST ->#BBID_DOS	    	= {"D", "O", "S", "\0"}
#define BBID_DOS bbid_dos
STATIC bbid_dos = ["D","O","S","\0"]:CHAR
NATIVE {BBID_KICK}	    	CONST ->#BBID_KICK	    	= {"K", "I", "C", "K"}
#define BBID_KICK bbid_kick
STATIC bbid_kick = ["K","I","C","K"]:CHAR

NATIVE {BBNAME_DOS}	    	CONST BBNAME_DOS	    	= $444F5300 /* "DOS0" */
NATIVE {BBNAME_KICK}	    	CONST BBNAME_KICK	    	= $4B49434B /* "KICK" */
