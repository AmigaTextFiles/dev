#ifndef FEELIN_STRINGS_H
#define FEELIN_STRINGS_H

#ifndef FEELIN_TYPES_H
#include <feelin/types.h>
#endif

/*
**  feelin/strings.h
**
**  © 2001-2006 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 01.00 (2006/08/27)

	Prototypes for the string support functions defined in the feelin linked
	library  (/feelin/include/lib/).  The following functions area currently
	available:

		f_stch()
		f_stcd()

************************************************************************************************/

uint32 f_stch(const char *in, int32 *lvalue);
uint32 f_stcd(const char *in, int32 *lvalue);

#endif
