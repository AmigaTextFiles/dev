#ifndef __QUEUE_H
#define __QUEUE_H

#include <3d.h>
#include <exec/types.h>

typedef struct {
	mapcell *here;
	int x,y;
	int mask;
} queue_item;

void        QUEUE_Init(void);
void        QUEUE_Queue(mapcell* cell, int x, int y, int mask);
queue_item* QUEUE_Dequeue(void);
BOOL        QUEUE_IsEmpty(void);

#endif
