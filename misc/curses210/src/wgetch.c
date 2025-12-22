/* -*-C-*-
 *
 *
 * Filename : wgetch.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Read a character.
 *
 *
 * THIS CODE IS NOT PUBLIC DOMAIN
 * ==============================
 * 
 * This code is copyright Simon J Raybould 1991, all rights are reserved.
 * All code, ideas, data structures and algorithms remain the property of the
 * author. Neither the whole nor sections of this code may be used as part
 * of other code without the authors consent. If you wish to use some of this
 * code then please email me at (sie@fulcrum.bt.co.uk).
 *
 * This source is not public domain, so you do not have any right to alter it
 * or sell it for personal gain. The source is provided purely for reference
 * purposes. You may re-compile the source with any compiler you choose.
 * You must not distribute altered copies without the authors consent. My
 * intention is that the source will help people isolate any bugs much more
 * effectivly.
 *
 * Disclaimer
 * ==========
 *
 * No implication is made as to this code being fit for any purpose at all.
 * I (the author) shall not be held responsible for any loss of data or damage 
 * to property that may result from its use or misuse.
 *
 *
 * Revision History
 * ================
 *
 * $Log: wgetch.c,v $
 * Revision 1.6  1993/05/17  23:31:47  sie
 * Underscores added to names.
 * Speed optimisations for V2.10
 *
 * Revision 1.5  1992/12/25  23:39:35  sie
 * GNU C port.
 *
 * Revision 1.4  92/06/10  23:44:59  sie
 * Added serial support.
 * 
 * Revision 1.3  91/12/28  22:45:46  sie
 * changed attrs to UBYTE from short + some tidying up.
 * 
 * Revision 1.2  91/12/27  10:02:38  sie
 * Attempted to speed up wgetch a bit.
 * 
 * Revision 1.1  91/09/07  11:50:10  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/wgetch.c,v 1.6 1993/05/17 23:31:47 sie Exp $";

#include <fcntl.h>
#include "acurses.h"

wgetch(WINDOW *WinPtr)
{
  static unsigned char buffer[RAWBUFSIZ];
  int Class, i;
  struct IntuiMessage *Message;
  static struct InputEvent ievent = { NULL, IECLASS_RAWKEY, 0, 0, 0 };
  char c;
  
  if(!(_CursesFlags & CFLAG_INITSCR))  /* Haven't called initscr() */
    return ERR;
  
  if(_CursesType == CUST_CURSES) {
    if(_GetchBufPos < _GetchNChars) /* If we still have some chars then return next */
      return (int)buffer[_GetchBufPos++];

    /* Else read a new buffer */
    _GetchBufPos = _GetchNChars = 0;
    while(!_GetchNChars) {
#ifdef LATTICE
      chkabort(); /* Check if INTR */
#endif
      /* Get message if there is one already queued */
      Message = (struct IntuiMessage *)GetMsg(_CursesWindow->UserPort);
      if(!Message) {
	/* Nuffin yet */
	if(WinPtr->_nodelay)  /* If non-blocking return ERR */
	  return ERR;
	else {    /* Wait for character */
	  Wait(1<<_CursesWindow->UserPort->mp_SigBit);
	  Message = (struct IntuiMessage *)GetMsg(_CursesWindow->UserPort);
	}
      }
      if(!Message)  /* Try again */
	continue;
      
      Class = Message->Class;
      switch(Class) {
      case RAWKEY:
	_GetchBufPos = 0;
	ievent.ie_Code = Message->Code;
	ievent.ie_Qualifier = Message->Qualifier;
	ievent.ie_position.ie_addr = *((APTR*)Message->IAddress);
	ReplyMsg((struct Message *)Message);
	_GetchNChars = RawKeyConvert(&ievent, buffer, RAWBUFSIZ, 0L);
	if(!_GetchNChars)  /* If no characters then try again */
	  break;
	if(_CursesFlags & CFLAG_ECHO)
	  for(i=0; i<_GetchNChars; i++)
	    _DoEcho(WinPtr, buffer[i]);
	/* Translate ANSI sequence if keypad set to TRUE */
	if(_CursesFlags & CFLAG_KEYPAD) {
	  switch(_GetchNChars) {
	  case 1:
	    _GetchNChars = 0;  /* Translation will use up all chars */
	    if((_CursesFlags & CFLAG_NLCR) && (buffer[0] == '\r'))
	      return (int)'\n';
	    return (int)*buffer;
	  case 2:    /* ARROW KEY */
	    _GetchNChars = 0;  /* Translation will use up all chars */
	    if(buffer[0] != 155)
	      return -1;
	    switch(buffer[1]) {
	    case 'A':
	      return KEY_UP;
	    case 'B':
	      return KEY_DOWN;
	    case 'C':
	      return KEY_RIGHT;
	    case 'D':
	      return KEY_LEFT;
	    default:
	      return -1;
	    }
	  case 3:    /* FUNCTION KEY */
	    _GetchNChars = 0;  /* Translation will use up all chars */
	    if(buffer[0] != 155)
	      return -1;
	    if(buffer[2] != 126)
	      return -1;
	    if(buffer[1] == 63)
	      return KEY_HELP;
	    return KEY_F0 + (buffer[1] - 47);  /* KEY_F(1) = F1 */
	  default:
	    _GetchNChars = 0;  /* Translation will use up all chars */
	    return -1;
	  }
	}
	break;
      default:
	ReplyMsg((struct Message *)Message);
	break;
      }
    }
    if((_CursesFlags & CFLAG_NLCR) && (buffer[_GetchBufPos] == '\r')) {
      _GetchBufPos++;
      return (int)'\n';
    }
    return (int)buffer[_GetchBufPos++];
  } else if(_CursesType == ANSI_CURSES) {
    if((WinPtr->_nodelay) && (!WaitForChar(_ifh, 10000L)))
      return ERR;		/* if nodelay and no char ready */
    read(0, &c, 1);
    if(_CursesFlags & CFLAG_ECHO)
      _DoEcho(WinPtr, c);
    if((_CursesFlags & CFLAG_NLCR) && (c == '\r'))
      return (int)'\n';

    if(c == ESC && WaitForChar(_ifh, 10000L)) { /* if ESC wait for [ */
      read(0, &c, 1);
      if(_CursesFlags & CFLAG_ECHO)
	_DoEcho(WinPtr, c);
      if(c != '[')
	return -1;
    } else if((unsigned char)c != 0x9b)	/* if not ESC of 9b then return */
      return (int)c;

    /* Got CSI, wait for rest */
    if(!WaitForChar(_ifh, 10000L))
      return -1;
    read(0, &c, 1);
    if(_CursesFlags & CFLAG_ECHO)
      _DoEcho(WinPtr, c);

    if(_CursesFlags & CFLAG_KEYPAD) {
      switch(c) {
      case 'A':
	return KEY_UP;
      case 'B':
	return KEY_DOWN;
      case 'C':
	return KEY_RIGHT;
      case 'D':
	return KEY_LEFT;
      default:
	return -1;
      }      
    }
  }
}
