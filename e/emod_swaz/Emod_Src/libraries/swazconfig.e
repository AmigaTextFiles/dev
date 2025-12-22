OPT MODULE
OPT PREPROCESS
OPT EXPORT

/*
**      $Filename: libraries/swazconfig.h $
**      $Release: 1.0 $
**      $Revision: 1.0 $
**
**      SwazConfig definitions
**
**	(C) Copyright 1995 David Swasbrook
**	    All Rights Reserved
**
**	Quick conversion to AmigaE
**	by Krzysztof Cmok
*/


#define SWAZCONFIGNAME	'swazconfig.library'
#define SC_TagBase		TAG_USER

/*****************************************************************************
   This structure is private
 ****************************************************************************/
OBJECT sc_config
	pool:PTR TO LONG
	list:PTR TO LONG
ENDOBJECT

/*****************************************************************************
   This structure is read only
 ****************************************************************************/
OBJECT sc_configvar
	node:PTR TO LONG
	data:PTR TO CHAR
	datasize:PTR TO LONG
ENDOBJECT


#define SCV_COMMENT    0
#define SCV_VARIABLE   1

