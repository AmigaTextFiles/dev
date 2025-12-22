#ifndef __GLOBAL_H__ 
#define __GLOBAL_H__ 1

/*********************************************************************
----------------------------------------------------------------------

	global

----------------------------------------------------------------------
*********************************************************************/

#include <exec/types.h>

extern void CloseGlobal(void);
BOOL InitGlobal(void);

void *Malloc(unsigned long size);
void *Malloclear(unsigned long size);
void Free(void *mem);

extern struct Library *MysticBase;
extern struct Library *GuiGFXBase;


#endif
