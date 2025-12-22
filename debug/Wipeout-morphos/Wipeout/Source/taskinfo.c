/*
 * $Id: taskinfo.c,v 1.1 2005/12/21 19:48:23 itix Exp $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

CONST_STRPTR
GetTaskTypeName(LONG type)
{
	CONST_STRPTR table[TASKTYPE_CLI_Program-TASKTYPE_Task+1] =
	{
		"task",
		"process",
		"CLI program"
	};

	ASSERT(TASKTYPE_Task <= type && type <= TASKTYPE_CLI_Program);

	/* map a name to a task type */
	return(table[type]);
}

/******************************************************************************/

LONG
GetTaskType(struct Task * whichTask)
{
	struct Process * pr;
	LONG result;

	/* this routine determines whether the current task
	 * is only a plain Task, a plain Process or a CLI
	 * which executes a command
	 */

	if(whichTask != NULL)
		pr = (struct Process *)whichTask;
	else
		pr = (struct Process *)FindTask(NULL);

	if(pr->pr_Task.tc_Node.ln_Type == NT_PROCESS)
	{
		result = TASKTYPE_Process;

		if(pr->pr_CLI != NULL)
		{
			struct CommandLineInterface * cli = BADDR(pr->pr_CLI);

			if(IsValidAddress((ULONG)cli))
			{
				STRPTR commandName = BADDR(cli->cli_CommandName);
	
				if(IsValidAddress((ULONG)commandName))
				{
					if(commandName[0] != 0)
					{
						result = TASKTYPE_CLI_Program;
					}
				}
			}
		}
	}
	else
	{
		result = TASKTYPE_Task;
	}

	return(result);
}

BOOL
GetTaskName(struct Task * whichTask,STRPTR name,LONG nameLen)
{
	struct Process * pr;
	BOOL gotName = FALSE;

	/* determine the name of the given task; if it is in fact
	 * a process, check whether it is really a CLI with a program
	 * running in it and get its name
	 */

	if(whichTask != NULL)
		pr = (struct Process *)whichTask;
	else
		pr = (struct Process *)FindTask(NULL);

	if(pr->pr_Task.tc_Node.ln_Type == NT_PROCESS && pr->pr_CLI != NULL)
	{
		struct CommandLineInterface * cli = BADDR(pr->pr_CLI);

		if(IsValidAddress((ULONG)cli))
		{
			STRPTR commandName = BADDR(cli->cli_CommandName);

			if(IsValidAddress((ULONG)commandName))
			{
				if(commandName[0] != 0)
				{
					int len = commandName[0];
	
					if(len >= nameLen)
						len = nameLen-1;
	
					strncpy(name,&commandName[1],len);
					name[len] = '\0';
	
					gotName = TRUE;
				}
			}
		}
	}

	if(NOT gotName)
	{
		if(IsValidAddress((ULONG)pr->pr_Task.tc_Node.ln_Name))
		{
			StrcpyN(nameLen,name,pr->pr_Task.tc_Node.ln_Name);
			gotName = TRUE;
		}
	}

	return(gotName);
}
