/*
 *	File:					HotKey.h
 *	Description:	Generates a hotkey
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef HOTKEY_H
#define HOTKEY_H

/*** INCLUDES ************************************************************************/
#include <devices/inputevent.h>

/*** PROTOTYPES **********************************************************************/
struct InputEvent *CreateInputEvent(UBYTE *command);
void SendHotkey(UBYTE *command);
#endif
