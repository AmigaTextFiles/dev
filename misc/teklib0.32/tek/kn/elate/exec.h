
#ifndef _TEK_KERNEL_ELATE_EXEC_H
#define	_TEK_KERNEL_ELATE_EXEC_H 1

#include <tek/type.h>
#include <tek/kn/exec.h>

struct elatethread
{
	void (*function)(void *data);
	void *data;

	pid_t pid;
	ELATE_PCB pcb;
	ELATE_SPAWN *spawn;

	int	initok;

	void *globaldata;			/* self reference via GP */
	char globalname[16];		/* self reference via named data */

	char *argvblock[3];
	char adrstr[12];
	char toolname[10];
};


#endif
