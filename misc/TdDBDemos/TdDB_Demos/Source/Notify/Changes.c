
/*
 * This is a small utility that doesnt make much sound unless you run it
 * together with notify.
 *
 * Version 1.2
 *
 * Changes since 1.1:
 * - Removed all delays since Notify uses several messages now.
 *
 * Changes since 1.0:
 * - Added versionstring
 * - Now also deletes nodes
 */ 

#include <exec/ports.h>
#include <dos/dos.h>
#include <libraries/tddbase.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/tddbase.h>
#include <stdio.h>
#include <stdlib.h>

char vers[]="Changes 1.1 "__AMIGADATE__;

struct DBHandle *DBase;

/* The name of the database we will use. */
char DBName[]="PROGDIR:Example.DBS";

/* Decleare the field we will be using. */
#define	Int	IntTag(0x001)
#define Str	StrTag(0x002)

void main(void)
{
BPTR lock;
struct DBNode *Node;

	if(!(DBase=TDDB_OpenBase(DBName)))
	{
		puts("TDDB_OpenBase failed\n");
		exit(10);
	}

	/* And remeber that it can return a handle even if OpenBase failed. */
	if(DBase->Error)
	{
		/* Check if the file exists, if not create it. */
		if(lock=Lock(DBName, SHARED_LOCK))
		{
			/* The file exist, and therefore it was some other error.
			 * Another way to do what we just have done is to check for
			 * Err_DosErr and IoErr reports ObjectNotFound. */
			UnLock(lock);

			puts("TDDB_OpenBase failed");
			TDDB_CloseBase(DBase);
			exit(10);
		}
		else
		{
			/* First, we close the old base to free up its resources. */
			TDDB_CloseBase(DBase);

			/* And then we create the database. */
			DBase=TDDB_CreateBaseA(DBName, FILID_STATIC, DBID_NOID, NULL);

			if(DBase==NULL)
			{
				puts("TDDB_CreateBaseA failed\n");
				exit(10);
			}
			if(DBase->Error)
			{
				puts("TDDB_CreateBaseA failed\n");
				TDDB_CloseBase(DBase);
				exit(10);
			}
		}
	}

	/* Okey, the database is now up and running... Then maybe we should
	 * start playing around with some of the commands. */

	/* First we must create a empty node to store data in. Note that this
	 * functions returns a Node that is already locked for writing. Note
	 * also that we produce a MSG_NEWNODE already here! */
	if(!(Node=TDDB_NewNode(DBase)))
	{
		puts("TDDB_NewNode failed!");

		/* TDDB_CloseBase also free up all other resourses used by database. */
		TDDB_CloseBase(DBase);
		exit(10);
	}

	/* And we store som data in node. */
	TDDB_SetDataList(DBase,Node,Int, 12345,
								Str, "Testing testing...",
								TAG_DONE);

	/* Saves down the node to file. This will also trigger a MSG_CHANGED msg */
	TDDB_FreeNode(DBase, Node);

	/* And we do the same thing with another node... */
	if(!(Node=TDDB_NewNode(DBase)))
	{
		puts("TDDB_NewNode failed!");

		/* TDDB_CloseBase also free up all other resourses used by database. */
		TDDB_CloseBase(DBase);
		exit(10);
	}
	TDDB_SetDataList(DBase,Node,Int, 67890,
								Str, "Yet another string...",
								TAG_DONE);
	TDDB_FreeNode(DBase, Node);

	/* And finaly its end of all the fun stuff and all that remains is to
	 * delete the nodes and close the database... */

	/* Note that by deleting 0, 1 will become the new 0 if you understand
	 * what I mean... Also, dont forget the delays so we see what happens. */
	TDDB_DeleteNode(DBase, NULL);
	TDDB_DeleteNode(DBase, NULL);

	TDDB_CloseBase(DBase);
}