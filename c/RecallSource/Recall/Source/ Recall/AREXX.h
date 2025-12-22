/*
 *	File:					AREXX.h
 *	Description:	Defines the set of AREXX commands understood by Recall.
 *								97 AREXX commands defined
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef AREXX_H
#define AREXX_H

/*** PRIVATE INCLUDES ****************************************************************/
#ifndef LIBRARIES_EASYREXX_H
#include <libraries/easyrexx.h>
#endif

/*** GLOBALS *************************************************************************/
extern struct ARexxContext *arexxcontext;
extern BYTE lockgui;
extern struct ARexxCommandTable commandTable[];

/*** PROTOTYPES **********************************************************************/
LONG HandleAREXX(struct ARexxContext *c)
BYTE GetSwitch(struct ARexxContext *c, BYTE state)

#endif
