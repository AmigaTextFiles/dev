/*
 * $Id: filter.c,v 1.2 2009/06/14 08:49:04 itix Exp $
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

	/* pre-initialize the filter lists and assume
	 * defaults (track all memory allocations)
	 */

STATIC struct MinList ForbidList = { (APTR)&ForbidList.mlh_Tail, NULL, (APTR)&ForbidList };
STATIC struct MinList PermitList = { (APTR)&PermitList.mlh_Tail, NULL, (APTR)&PermitList };
STATIC BOOL ForbidAll = FALSE;
STATIC BOOL PermitAll = TRUE;

/******************************************************************************/

STATIC VOID
ClearList(struct MinList * list)
{
	struct MinNode * node;
	struct MinNode * next;

	/* return the contents of a list to the
	 * public memory list.
	 */
	for(node = list->mlh_Head ;
	   (next = node->mln_Succ) != NULL ;
	    node = next)
	{
		PrivateFreeVec(node);
	}

	/* leave an empty list behind */
	NEWLIST((struct List *)list);
}

STATIC VOID
MoveList(struct MinList * source,struct MinList * destination)
{
	struct MinNode * node;
	struct MinNode * next;

	#warning This could be optimised -ilkka
	/* move the contents of one list to another */
	for(node = source->mlh_Head ;
	   (next = node->mln_Succ) != NULL ;
	    node = next)
	{
		ADDTAIL((struct List *)destination,(struct Node *)node);
	}

	/* leave an empty source list behind */
	NEWLIST((struct List *)source);
}

/******************************************************************************/

VOID
ClearFilterList(VOID)
{
	/* clear both filter lists
	 */
	ClearList(&ForbidList);
	ClearList(&PermitList);
}

/******************************************************************************/

STATIC BOOL
GetNextName(
	STRPTR *	keyPtr,
	STRPTR		name,
	LONG		nameLen)
{
	STRPTR start;
	STRPTR stop;
	BOOL result = FALSE;

	/* scan the "key" string for the next following name;
	 * names are separated by "|" characters
	 */

	ASSERT(keyPtr != NULL && name != NULL && nameLen > 0);

	start = (*keyPtr);
	while((*start) != '\0' && (*start) == '|')
		start++;

	stop = start;

	while((*stop) != '\0')
	{
		if((*stop) == '\\')
		{
			if(stop[1] != '\0')
			{
				stop += 2;
			}
			else
			{
				break;
			}
		}
		else
		{
			if((*stop) == '|')
			{
				break;
			}
			else
			{
				stop++;
			}
		}
	}

	if(start != stop)
	{
		LONG keyLen = (LONG)stop - (LONG)start + 1;
		LONG len;
		LONG i;

		len = 0;

		for(i = 0 ; i < keyLen ; i++)
		{
			if(start[i] == '|' || len == nameLen)
				break;

			if(start[i] == '\\')
			{
				name[len++] = start[++i];
			}
			else
			{
				name[len++] = start[i];
			}
		}

		name[len] = '\0';

		if((*stop) == '|')
		{
			(*keyPtr) = stop+1;
		}
		else
		{
			(*keyPtr) = stop;
		}

		result = TRUE;
	}

	/* return TRUE if there is another name to follow,
	 * FALSE otherwise (= finished processing the key
	 * string)
	 */

	return(result);
}

/******************************************************************************/

BOOL
UpdateFilter(const STRPTR filterString)
{
	STRPTR string = (STRPTR)filterString;
	struct MinList forbidList;
	struct MinList permitList;
	UBYTE taskName[MAX_FILENAME_LEN];
	STRPTR name;
	BOOL forbidAll;
	BOOL permitAll;
	BOOL success = TRUE;

	/* assume defaults */
	NEWLIST((struct List *)&forbidList);
	NEWLIST((struct List *)&permitList);

	forbidAll = FALSE;
	permitAll = TRUE;

	/* process the filter string */
	while(GetNextName(&string,taskName,sizeof(taskName)))
	{
		/* exclude a name from the list? */
		if(taskName[0] == '!')
		{
			name = &taskName[1];

			/* "ALL" means that no allocation should be
			 * excluded from being watched
			 */
			if(Stricmp(name,"ALL") == SAME)
			{
				forbidAll = TRUE;

				ClearList(&forbidList);
			}
			else
			{
				struct Node * node;

				/* remember the name of the task whose name
				 * should be used in the exclusion list
				 */
				node = PrivateAllocVec(sizeof(*node) + strlen(name)+1,MEMF_ANY);
				if(node != NULL)
				{
					node->ln_Name = (char *)(node + 1);

					strcpy(node->ln_Name,name);
					ADDTAIL((struct List *)&forbidList,node);

					forbidAll = FALSE;
				}
				else
				{
					success = FAILURE;
					break;
				}
			}
		}
		else
		{
			name = taskName;

			/* "ALL" means that all allocations should be
			 * watched
			 */
			if(Stricmp(name,"ALL") == SAME)
			{
				permitAll = TRUE;

				ClearList(&permitList);
			}
			else
			{
				struct Node * node;

				/* remember the name of the task whose name
				 * should be used in the inclusion list
				 */
				node = PrivateAllocVec(sizeof(*node) + strlen(name)+1,MEMF_ANY);
				if(node != NULL)
				{
					node->ln_Name = (char *)(node + 1);

					strcpy(node->ln_Name,name);
					ADDTAIL((struct List *)&permitList,node);

					permitAll = FALSE;
				}
				else
				{
					success = FAILURE;
					break;
				}
			}
		}
	}

	/* did we succeed in splitting the filter string
	 * into list nodes?
	 */
	if(success)
	{
		Forbid();

		/* get rid of all the old filter list entries */
		ClearList(&ForbidList);
		ClearList(&PermitList);

		/* use the new list entries */
		MoveList(&forbidList,&ForbidList);
		MoveList(&permitList,&PermitList);

		/* and the new options */
		ForbidAll = forbidAll;
		PermitAll = permitAll;

		Permit();
	}
	else
	{
		ClearList(&forbidList);
		ClearList(&permitList);
	}

	return(success);
}

/******************************************************************************/

BOOL
CanAllocate(VOID)
{
	BOOL result = TRUE;

	/* check whether the current task should be allowed to
	 * make a memory allocation to be watched
	 */
	if(GetTaskName(NULL,GlobalNameBuffer,sizeof(GlobalNameBuffer)))
	{
		if(ForbidAll)
		{
			/* should the allocations not be watched? */
			if(CANNOT FindIName((struct List *)&PermitList,GlobalNameBuffer))
				result = FALSE;
		}
		else if (PermitAll)
		{
			/* should the allocations not be watched? */
			if(FindIName((struct List *)&ForbidList,GlobalNameBuffer))
				result = FALSE;
		}
		else
		{
			result = FALSE;

			/* should the allocations be watched? */
			if(       FindIName((struct List *)&PermitList,GlobalNameBuffer) &&
			   CANNOT FindIName((struct List *)&ForbidList,GlobalNameBuffer))
			{
				result = TRUE;
			}
		}
	}

	return(result);
}

/******************************************************************************/

VOID
CheckFilter(VOID)
{
	/* print the contents of the two watch lists */

	Forbid();

	if(NOT IsListEmpty((struct List *)&PermitList))
	{
		struct Node * node;

		DPrintf("\nMemory allocations done by the following task(s) are being watched:\n");

		for(node = (struct Node *)PermitList.mlh_Head ;
		    node->ln_Succ != NULL ;
		    node = node->ln_Succ)
		{
			DPrintf("\t\"%s\"\n",node->ln_Name);
		}
	}

	if(NOT IsListEmpty((struct List *)&ForbidList))
	{
		struct Node * node;

		DPrintf("\nMemory allocations done by the following task(s) are NOT being watched:\n");

		for(node = (struct Node *)ForbidList.mlh_Head ;
		    node->ln_Succ != NULL ;
		    node = node->ln_Succ)
		{
			DPrintf("\t\"%s\"\n",node->ln_Name);
		}
	}

	Permit();
}
