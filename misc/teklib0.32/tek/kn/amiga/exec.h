
#ifndef _TEK_KERNEL_EXEC_AMIGA_H
#define	_TEK_KERNEL_EXEC_AMIGA_H 1

#include <exec/exec.h>
#include <exec/libraries.h>
#include <dos/dosextens.h>

struct amithread
{
	struct Message message;
	struct Process *childproc;
	struct MsgPort *initreplyport;

	APTR data;
	void (*function)(APTR);

	struct DosLibrary *dosbase;
	struct Library *socketbase;

	LONG sockerrno;
};


struct amievent
{
	struct Task *task;
	BYTE signal;
};



#endif
