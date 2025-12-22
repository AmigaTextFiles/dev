/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_mem.c,v 1.1 2001/06/27 21:05:48 root Exp root $
 * $Author: root $
 * rain_mem.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_mem.c,v $
 * Revision 1.1  2001/06/27 21:05:48  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"


/* 
 * Free's buffer and sets it to NULL
 * to ensure it won't be used again. 
 */
extern void 
freebuf(void *memory) {
  if(memory == NULL) return;
  free(memory);
  memory = NULL;
}
