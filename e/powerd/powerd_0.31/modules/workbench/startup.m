/*
**	$VER: startup.m 36.3 (11.7.90)
**	Includes Release 40.15
**
**	workbench startup definitions
**
**	(C) Copyright 1985-1993 Commodore-Amiga, Inc.
**	All Rights Reserved
*/

MODULE	'exec/ports'

OBJECT WBStartup
	Message:MN,					// a standard message structure
	Process:PTR TO MP,		// the process descriptor for you
	Segment:BPTR,				// a descriptor for your code
	NumArgs:LONG,				// the number of elements in ArgList
	ToolWindow:PTR TO CHAR,	// description of window
	ArgList:PTR TO WBArg		// the arguments themselves

OBJECT WBArg
	Lock:BPTR,					// a lock descriptor
	Name:PTR TO CHAR			// a string relative to that lock
