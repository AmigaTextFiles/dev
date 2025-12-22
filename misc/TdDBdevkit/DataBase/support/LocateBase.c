
/*
 * LocaleBase is an utilityfunction that either opens an existing database
 * or if that doesnt exist, create it.
 */

#include <libraries/tddbase.h>
#include <dos/dos.h>
#include <proto/tddbase.h>
#include <proto/dos.h>

#include "support.h"

struct DBHandle *LocateBaseA(STRPTR Name,LONG FileID,LONG DBID,struct TagItem *Tags)
{
BPTR lock;
struct DBHandle *DBase;

	if(lock=Lock(Name,SHARED_LOCK))
	{
		/* File exists, now open it */
		UnLock(lock);
		DBase=TDDB_OpenBase(Name);
	}
	else
	{
		/* File didnt exists, instead we must create this new database. */
		DBase=TDDB_CreateBaseA(Name,FileID,DBID,Tags);
	}

	return DBase;
}