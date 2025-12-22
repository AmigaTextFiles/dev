/*
**	$VER: name.m 39.5 (11.8.1993)
**	Includes Release 44.1
**
**	Namespace definitions
**
**	(C) Copyright 1992-1999 Amiga, Inc.
**	All Rights Reserved
**/

/* The named object structure */
OBJECT NamedObject
	Object:PTR     /* Your pointer, for whatever you want */

/* Tags for AllocNamedObject() */
CONST	ANO_NameSpace=4000,
		ANO_UserSpace=4001,
		ANO_Priority=4002,
		ANO_Flags=4003

FLAG	NS_NODUPS,
		NS_CASE
