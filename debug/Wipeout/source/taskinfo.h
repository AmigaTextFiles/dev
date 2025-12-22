/*
 * $Id: taskinfo.h 1.4 1998/04/13 09:16:41 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _TASKINFO_H
#define _TASKINFO_H 1

/****************************************************************************/

/* task types */
enum
{
	TASKTYPE_Task,
	TASKTYPE_Process,
	TASKTYPE_CLI_Program
};

/****************************************************************************/

#endif /* _TASKINFO_H */
