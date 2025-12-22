/*
 * Benchmark is a small utility to show you exactly how fast
 * tddbase.library is.
 *
 * This is version 1.2
 *
 * Changes between 1.1 and 1.2
 *	  Added deletion of nodes.
 *    Recompiled for 68000 CPU.
 *
 * Changes between 1.0 and 1.1
 *    A reasonable failure path.
 *    Added version string.
 *    Uses 50 instead of 25 databases.
 */

#include <utility/tagitem.h>
#include <libraries/tddbase.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/tddbase.h>
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Declears that we should use 50 databases for this benchmark test.
#define DBANTAL	50

/*
 *	Here we create the fields that we use to store data in.
 *	This defines is all we need to do to use the fields.
 */
#define Int0 IntTag(0x1)
#define Int1 IntTag(0x2)
#define Int2 IntTag(0x3)
#define Int3 IntTag(0x4)
#define Int4 IntTag(0x5)
#define Int5 IntTag(0x6)
#define Int6 IntTag(0x7)
#define Int7 IntTag(0x8)
#define Int8 IntTag(0x9)
#define Int9 IntTag(0xa)

#define Str0 StrTag(0x11)
#define Str1 StrTag(0x12)
#define Str2 StrTag(0x13)
#define Str3 StrTag(0x14)
#define Str4 StrTag(0x15)
#define Str5 StrTag(0x16)
#define Str6 StrTag(0x17)
#define Str7 StrTag(0x18)
#define Str8 StrTag(0x19)
#define Str9 StrTag(0x1a)

char DBNamn[ DBANTAL ][8];				// Names on databases to create.

struct DBHandle *DBase[ DBANTAL ];		// Handles on databases
struct DBNode *Node[ DBANTAL ];			// And a pointer to a node.

char _vstring[]="$VER: Benchmark 1.2 "__AMIGADATE__;

// These 2 are used for timing.
clock_t Start,End;

// This string is printed whenever a failure happens.
STRPTR ErrStrings[]=
{
	"No error",						// Err_NoErr
	"The node doesent exists",		// Err_NoNode
	"Ran out of memory",			// Err_NoMem
	"DOS Error",					// Err_DosErr
	"File is not a database",		// Err_NotDBase
	"Node is already locked",		// Err_NodeBusy.
};

// This routine is called to start timing, we could have an Forbid() here
// but it will be broken by almost any routines anyway its realy no need for
// it.
static __inline void StartTimer(void)
{
	Start=clock();
}

// This routine is called to end timing and also print the result.
static __inline void EndTimer(void)
{
clock_t Time;
int Secs,Micro,Antal;

	End=clock();
	Time=End-Start;

	Secs=Time / CLOCKS_PER_SEC;
	Micro=Time % CLOCKS_PER_SEC;

	if(Time==0)
		Time=1;

	Antal=(CLOCKS_PER_SEC*DBANTAL)/Time;

	printf("Took: %d.%03d (%d/sec)\n\n",Secs,Micro,Antal);
}

/* * * * * * * * * * Here comes the demo functions. * * * * * * * * * * */

// This is called whenever a functions fails. Print short error string and
// close all opened databases.
void Failure(ULONG Error)
{
int x;

	puts(ErrStrings[Error]);

	for(x=0;x!=DBANTAL;x++)
	{
		if(DBase[x])
			TDDB_CloseBase(DBase[x]);
	}
	exit(20);
}

int main(int argc, char *argv[])
{
int x,y;
STRPTR Data;

	/*
	 * Hey, were do you open the library? 
	 * There is no need for it, since this demo is linked with a special
	 * support library that contains routines that will open it for us
	 * before main is called.
	 */ 

	// Initlizing all values
	for(x=0;x!=DBANTAL;x++)
	{
		sprintf(DBNamn[x], "%d.DBS", x);
		DBase[x]=NULL;
		Node[x]=NULL;
	}

	// First we create all databases. Mote that this also includes opening.
	puts("Creating databases...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
	{
		if(!(DBase[x]=TDDB_CreateBase(DBNamn[x],FILID_STATIC,DBID_NOID,TAG_DONE)))
			Failure(Err_NoMem);

		// Note that both TDDB_CreateBase and TDDB_OpenBase almost always
		// returns a handle, and therefore we have to check its error field
		// to see if the creation realy worked.

		if(DBase[x]->Error)
			Failure(DBase[x]->Error);
	}
	EndTimer();

	// Then we close them. Not logical? Well, we have to close them
	// sometime anyway so why not now when the next call is opening of
	// datases.
	puts("Closing databases...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		TDDB_CloseBase(DBase[x]);
	EndTimer();

	// And to use them furter we must open them again.
	puts("Opens databases...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
	{
		if(!(DBase[x]=TDDB_OpenBase(DBNamn[x])))
			Failure(Err_NoMem);

		if(DBase[x]->Error)
			Failure(DBase[x]->Error);
	}
	EndTimer();

	// And now its time for some more interesting parts. First we create
	// some empty nodes to store data in.
	puts("Creating new nodes...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
	{
		if(!(Node[x]=TDDB_NewNode(DBase[x])))
			Failure(DBase[x]->Error);
	}
	EndTimer();

	// And now we store some data in the node. Note that a call to this
	// function is all we need to store data in a node. What it does is that
	// it first search if we already have a value stored and replacing the
	// value, or if it doesnt exist create a new entry for it.
	puts("Storing 10 integrers in node...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
	{
		TDDB_SetDataList(DBase[x], Node[x], Int0, 0,
											Int1, 1,
											Int2, 2,
											Int3, 3,
											Int4, 4,
											Int5, 5,
											Int6, 6,
											Int7, 7,
											Int8, 8,
											Int9, 9,
											TAG_DONE);
		if(DBase[x]->Error)
			Failure(DBase[x]->Error);
	}
	EndTimer();

	// And here we do the same thing but with strings instead, this will
	// take some more time since this also includes the allocation of a new
	// buffer for them.
	puts("Storing 10 strings in node...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
	{
		TDDB_SetDataList(DBase[x], Node[x], Str0, "String 0",
											Str1, "String 1",
											Str2, "String 2",
											Str3, "String 3",
											Str4, "String 4",
											Str5, "String 5",
											Str6, "String 6",
											Str7, "String 7",
											Str8, "String 8",
											Str9, "String 9",
											TAG_DONE);
		if(DBase[x]->Error)
			Failure(DBase[x]->Error);
	}
	EndTimer();

	// And here we say that we are done with this node for now. The new data
	// we have stored in the node will also be written to disk by this call.
	// However, the node will still reside in the RAM cache like a library
	// until it is flushed out. 
	puts("Writing data to disk...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
	{
		TDDB_FreeNode(DBase[x], Node[x]);

		if(DBase[x]->Error)
			Failure(DBase[x]->Error);
	}
	EndTimer();

	// We can also flush the RAM cache manualy if we want that.
	puts("Flushing cache...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		TDDB_FlushNodes(DBase[x]);
	EndTimer();

	// And now we get the node again, since they arent found in the cache
	// they will be loaded form disk.
	puts("Loading nodes...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		if(!(Node[x]=TDDB_GetNode(DBase[x], 0,MODEF_READ)))
			Failure(DBase[x]->Error);
	EndTimer();

	// Ofcourse we can read data's also. Since we only get data from one
	// field we maybe should use TDDB_GetDataValue instead but I think this
	// is a better example, also this is the slowest way go get data from
	// a single field but I have so much confidence that I want you to
	// see this value. 
	puts("Reading data...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		TDDB_GetDataList(Node[x],Str9, &Data,TAG_DONE);
	EndTimer();

	// And here we let go of the node, this only to give us the opertunity
	// to lock them from the cache and not need to load them from disk in
	// the next example.
	puts("Releasing nodes...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		TDDB_FreeNode(DBase[x], Node[x]);
	EndTimer();

	// Here we get them from the cache without having to load them from
	// disk. Notice that this is even faster than loading from RAM:
	puts("Geting nodes from cache...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		if(!(Node[x]=TDDB_GetNode(DBase[x],0,MODEF_WRITE)))
			Failure(DBase[x]->Error);
	EndTimer();

	// And we release them for the 256 time :)
	for(x=0;x!=DBANTAL;x++)
		TDDB_FreeNode(DBase[x], Node[x]);

	// And now we are deleting all those nodes... Why? You should see more
	// belowe..
	puts("Deleteing nodes...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		TDDB_DeleteNode(DBase[x],0);
	EndTimer();

	// And we close all databases. Note that all databases have internal
	// resourcetracking and thus closing the database will also remove all
	// nodes in memory and cache and close all files.
	puts("Closing databases...");
	StartTimer();
	for(x=0;x!=DBANTAL;x++)
		TDDB_CloseBase(DBase[x]);
	EndTimer();

	// And since I hope that you dont want alot of trashfiles all over your
	// HD I will remove them for you.
	puts("Deleting files...");
	for(x=0;x!=DBANTAL;x++)
	{
		DeleteFile(DBNamn[x]);

		strmfe(DBNamn[x],DBNamn[x],"IDX");
		DeleteFile(DBNamn[x]);
	}
}