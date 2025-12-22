
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.1 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Profyler Database Module					Last modified 01-Mar-22	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 The Database (DB) module encapsulates the database functionality of Profyl-
 er. The databases -- one per target program -- hold the profile data read
 from the target in both numeric form and as formatted strings suitable for
 display to the user. The module knows how to transform the raw data read
 from the target into the numeric format, and how to then transform that into
 the formatted strings. It also knows how to sort the database records on the
 various database fields.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This program is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by the Free
 Software Foundation; either version 2 of the License, or (at your option)
 any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

============================================================================
***************************************************************************/

/***************************************************************************
*																		   *
* Setup																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#define __NOLIBBASE__
#define __NOGLOBALIFACE__

#include <exec/types.h>
#include <exec/avl.h>
#include <exec/exectags.h>
#include <exec/debug.h>
#include <devices/timer.h>

#include "Profyler.h"
#include "ProfDB.h"
#include "ProfGUI.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <proto/exec.h>
#include <proto/timer.h>

// -------------------------------------------------------------------------
// === Prototypes ===

static int32 AVLNodeComp(struct AVLNode *Node1, struct AVLNode *Node2);
static int32 AVLKeyComp(struct AVLNode *Node, AVLKey Key);
static int32 TimeStr(STRPTR Buff, uint32 Len, uint64 Time);

// This function lives in libstdc++, and is normally accessed via cxxabi.h.
// They're both compatible with C code, but are part of the C++ environment.
// To avoid the hassle of including C++ headers in a C program, we just pro-
// totype it here. Note that adding this one function and its support rou-
// tines (including malloc() and free()) increases the size of the executable
// by more than 50%- demangling is no small job.
extern char *__cxa_demangle(const char *MangledName, char *OutputBuffer,
	size_t *Length, int *Status);

// -------------------------------------------------------------------------
// === Macros ===

// Convert an EClock tick count to nanoseconds, using the psPerTick value
// stored in the environment. Rounding is used for best accuracy. If the in-
// put and result are uint64 then intervals of up to around 200 days can be
// accommodated without overflow.
#define TicksToNS(Ticks)	(((Ticks * Envmt.psPerTick) + 500) / 1000)

/***************************************************************************
*																		   *
* Data																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Defines ===

// Each function record in the profile database is made up of one of these
// structures, linked into an Exec AVL tree by the embedded AVLNode at its
// beginning. All strings are NUL-delimited.
struct DBFuncRecd
{
	// Used to link the function records together into an Exec AVL tree. By
	// putting this at the start of the structure we can pass a pointer to
	// the structure to any code that expects a pointer to an AVLNode.
	struct AVLNode Link;

	// The function's address. May be used to look up the function's name in
	// the symbol table, and also serves as the AVL key, since it's guaran-
	// teed to be unique.
	APTR FuncID;

	// The function's name, or the function ID as a hex string if no symbol
	// information is available.
	TEXT FuncName[FUNC_NAME_LEN];

	// The source code file and line number separated by a colon, suitable
	// for display. Blank if no symbol information is available.
	TEXT FuncLocn[FUNC_LOCN_LEN];

	// The name of the source code file where the function is defined. Kept
	// in addition to FuncLocn to allow efficient sorting by location.
	TEXT FuncFile[FUNC_LOCN_LEN];

	// The line number of the above file where the function is found. Kept
	// in addition to FuncLocn to allow efficient sorting by location.
	uint32 FuncLine;

	// The number of times the function was executed (called and returned).
	uint32 CallCount;

	// The call count as a string.
	TEXT CallCountStr[CALL_CNT_LEN];

	// The total inclusive execution time for all calls to the function, in
	// ns.
	uint64 InclTime;

	// The total inclusive execution time as a string. Units are variable,
	// and are scaled to between 1 and 999 ns, 1.000 and 999.999 us or ms, or
	// 1.000 to 999999 sec.
	TEXT InclTimeStr[EXEC_TIME_LEN];

	// The average inclusive execution time, as a percent of the total exe-
	// cution time. Units are tenths of a percent.
	uint16 PctInclTime;

	// The inclusive percent as a string, to one decimal place. Includes the
	// '%' sign.
	TEXT PctInclTimeStr[PERCT_LEN];

	// The average inclusive execution time per call to the function, in ns.
	uint64 AvgInclTime;

	// The average inclusive execution time as a string. Units are variable,
	// and are scaled like the InclTimeStr.
	TEXT AvgInclTimeStr[EXEC_TIME_LEN];

	// The total exclusive execution time for all calls to the function, in
	// ns.
	uint64 ExclTime;

	// The total exclusive execution time as a string. Units are variable,
	// and are scaled like the InclTimeStr.
	TEXT ExclTimeStr[EXEC_TIME_LEN];

	// The average exclusive execution time, as a percent of the total exe-
	// cution time. Units are tenths of a percent.
	uint16 PctExclTime;

	// The exclusive percent as a string, to one decimal place. Includes the
	// '%' sign.
	TEXT PctExclTimeStr[PERCT_LEN];

	// The average exclusive execution time per call to the function, in ns.
	uint64 AvgExclTime;

	// The average exclusive execution time as a string. Units are variable,
	// and are scaled like the InclTimeStr.
	TEXT AvgExclTimeStr[EXEC_TIME_LEN];

	// Set to TRUE when this record has been added to the GUI for display.
	// The GUI then has a pointer back to this record which it may use when
	// it needs to sort or update the displayed records.
	BOOL Displayed;
};

// The size of a DBFuncRecd.
#define FUNCRECD_SIZE		(sizeof(struct DBFuncRecd))

// The initial size of the buffer that holds demangled function names. The
// demangler may enlarge the buffer if needed. This size -- far larger than
// we can actually display -- is big enough to make that unlikely.
#define NAME_BUFF_LEN	128

// Exec versions older than this have a bug in ObtainDebugSymbol() that we
// need to work around.
#define EXEC_BUGFIX_VER	54
#define EXEC_BUGFIX_REV	47

// -------------------------------------------------------------------------
// === Locals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).

// The Database module's local data. It's relatively small, so we put it in
// BSS to avoid the need to allocate it.
static struct
{
	// Item pools (one per database) from which to allocate function records.
	// NULL if the corresponding database does not exist.
	APTR DBasePool[MAX_TARGETS];

	// The names of the databases.
	TEXT DBaseName[MAX_TARGETS][DBASE_NAME_LEN];

	// Pointers to the root nodes of the databases, or NULL if the database
	// is empty or does not exist.
	struct DBFuncRecd *Database[MAX_TARGETS];

	// A pointer to a buffer allocated with malloc(), into which demangled
	// function names are placed.
	char *NameBuff;

	// The size of the name buffer.
	size_t NameBuffLen;

	// The number of picoseconds per EClock tick, used to convert EClock
	// ticks into units of time.
	uint32 psPerTick;

	// TRUE if we're running under a version of Exec that has a bug in the
	// ObtainDebugSymbol() function that we need to work around.
	BOOL ExecBug;

} Envmt;

// An empty string, for display when no record is available.
STRPTR Empty = "";

// Null (zero) data, for return when no record is available. Can be cast to
// any smaller size and will still be zero.
uint64 None = 0LL;

// -------------------------------------------------------------------------
// === Globals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).


/***************************************************************************
*																		   *
* Code																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Private code ===

/***************************************************************************

 Result = AVLNodeComp(Node1, Node2)

 This is a callback function for use in accessing an Exec AVL tree. It com-
 pares two nodes in the tree, and returns their sort order.

 The nodes are declared as pointers to AVLNodes since that's what the OS4 in-
 cludes specify, but they're actually pointers to the AVLNodes at the front
 of DBFuncRecds, which make up the contents of the database.

 The key used to sort the database records is the profiled function's ad-
 dress. The nodes are sorted in address order, from lowest address to high-
 est.

 In -----------------------------------------------------------------------

 Node1 = A pointer to the first function record to be compared.

 Node2 = A pointer to the second function record to be compared.

 Out ----------------------------------------------------------------------

 Result = A positive number if the first node is greater than the second; a
	negative number if the second node is greater than the first, or zero if
	the two nodes are equal.

***************************************************************************/

static int32 AVLNodeComp(struct AVLNode *Node1, struct AVLNode *Node2)
{
	// Compare the two function addresses. There's an awful lot of casting
	// required to simply subtract one number from another.
	return((int32)((struct DBFuncRecd *)Node1)->FuncID -
		(int32)((struct DBFuncRecd *)Node2)->FuncID);
}

/***************************************************************************

 Result = AVLKeyComp(Node, Key)

 This is a callback function for use in accessing an Exec AVL tree. It com-
 pares a node in the tree to a standalone key value, and returns their sort
 order.

 The node is declared as a pointer to an AVLNode since that's what the OS4
 includes specify, but it's actually a pointer to the AVLNode at the front
 of a DBFuncRecd, which makes up the contents of the database.

 The key used to sort the database records is the profiled function's ad-
 dress. The nodes are sorted in address order, from lowest address to high-
 est.

 In -----------------------------------------------------------------------

 Node = A pointer to the function record to be compared.

 Key = The key to be compared.

 Out ----------------------------------------------------------------------

 Result = A positive number if the node is greater than the key; a negative
	number if key is greater than the node, or zero if the two are equal.

***************************************************************************/

static int32 AVLKeyComp(struct AVLNode *Node, AVLKey Key)
{
	// Compare the function address to the key.
	return((int32)((struct DBFuncRecd *)Node)->FuncID - (int32)Key);
}

/***************************************************************************

 Len = TimeStr(Buff, Len, Time)

 Convert the given time in nanoseconds to a formatted string for display to
 the user. The time is scaled as necessary to maintain six significant digits
 of precision; the units are appended to the string. The formatted string is
 placed in the specified buffer, and is limited to the specified length.

 The displayed times are rounded to keep the result accurate to within +/-
 one half LSD.

 In -----------------------------------------------------------------------

 Buff = A pointer to a buffer of at least Len bytes into which the time
	string is to be placed.

 Len = The maximum length of the generated string, including the trailing
	NUL.

 Time = The 64-bit time, in nanoseconds.

 Out ----------------------------------------------------------------------

 Len = The number of characters that would be placed in the buffer if the
	length was not limited, not counting the trailing NUL. If this is >= Len
	then the string was truncated; otherwise the entire string was placed.

***************************************************************************/

static int32 TimeStr(STRPTR Buff, uint32 Len, uint64 Time)
{
	lldiv_t Result;

	// Times > 999,999 s.
	if(Time > 999999000000000ULL)
	{
		// Time is too large to display (more than 11.5 days!).
		return(snprintf(Buff, Len, ">999999 s"));
	}

	// Times from 100,000 - 999,999 s.
	if(Time >= 100000000000000ULL)
	{
		// Scale time to seconds, with rounding.
		Time = (Time + 500000000ULL) / 1000000000ULL;

		// Display time as seconds.
		return(snprintf(Buff, Len, "%lu s", (uint32)Time));
	}

	// Times from 10,000.0 - 99,999.9 s.
	if(Time >= 10000000000000ULL)
	{
		// Scale time to tenths of seconds, with rounding.
		Time = (Time + 50000000ULL) / 100000000ULL;

		// Display time as xxxxx.x seconds.
		Result = lldiv(Time, 10ULL);
		return(snprintf(Buff, Len, "%lu.%lu s", (uint32)Result.quot,
			(uint32)Result.rem));
	}

	// Times from 1,000.00 - 9,999.99 s.
	if(Time >= 1000000000000ULL)
	{
		// Scale time to hundredths of seconds, with rounding.
		Time = (Time + 5000000ULL) / 10000000ULL;

		// Display time as xxxx.xx seconds.
		Result = lldiv(Time, 100ULL);
		return(snprintf(Buff, Len, "%lu.%02lu s", (uint32)Result.quot,
			(uint32)Result.rem));
	}

	// Times from 1.000 - 999.999 s.
	if(Time >= 1000000000ULL)
	{
		// Scale time to milliseconds, with rounding.
		Time = (Time + 500000ULL) / 1000000ULL;

		// Display time as xxx.xxx seconds.
		Result = lldiv(Time, 1000ULL);
		return(snprintf(Buff, Len, "%lu.%03lu s", (uint32)Result.quot,
			(uint32)Result.rem));
	}

	// Times from 1.000 - 999.999 ms.
	if(Time >= 1000000ULL)
	{
		// Scale time to microseconds, with rounding.
		Time = (Time + 500ULL) / 1000ULL;

		// Display time as xxx.xxx milliseconds.
		Result = lldiv(Time, 1000ULL);
		return(snprintf(Buff, Len, "%lu.%03lu ms", (uint32)Result.quot,
			(uint32)Result.rem));
	}

	// Times from 1.000 - 999.999 us.
	if(Time >= 1000ULL)
	{
		// Display time as xxx.xxx microseconds.
		Result = lldiv(Time, 1000ULL);
		return(snprintf(Buff, Len, "%lu.%03lu us", (uint32)Result.quot,
			(uint32)Result.rem));
	}

	// Times from 1 to 999 ns.
	else
	{
		// Display time directly in nanoseconds.
		return(snprintf(Buff, Len, "%lu ns", (uint32)Time));
	}
}

// -------------------------------------------------------------------------
// === Public code ===

/***************************************************************************

 Success = DB_Start()

 Initialize the Database module when the program starts up. If successful,
 the module is ready for action. If not, the program must abort. If initial-
 ization fails then everything has been cleaned up, and there is no need to
 call DB_Stop().

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Success = TRUE if the initialization was successful, or FALSE if it failed.

***************************************************************************/

BOOL DB_Start(void)
{
	struct EClockVal ETime;
	uint64 EClockFreq;

	// Allocate a buffer to hold demangled C++ function names. We must use
	// malloc() to do this, since the demangler may use realloc() on the buf-
	// fer if it's not big enough. The buffer is small and this is highly un-
	// likely to fail, but if it does we'll try again when we go to demangle
	// a name. If successful, remember the buffer size.
	Envmt.NameBuff = malloc(NAME_BUFF_LEN);
	if(Envmt.NameBuff) Envmt.NameBuffLen = NAME_BUFF_LEN;

	// Query the timer device to get the EClock frequency.
	EClockFreq = (uint64)ITimer->ReadEClock(&ETime);

	// Convert that into the number of picoseconds per tick, which we'll need
	// to convert EClock ticks to units of time. Use rounding for greatest
	// accuracy if the result isn't an integer.
	Envmt.psPerTick = (1000000000000LL + (EClockFreq / 2)) / EClockFreq;

	// Make a note if we're running under a version of Exec that has a bug
	// that we need to work around.
	if(!LIB_IS_AT_LEAST(&((struct ExecBase *)SysBase)->LibNode,
		EXEC_BUGFIX_VER, EXEC_BUGFIX_REV)) Envmt.ExecBug = TRUE;

	// Done- return success.
	return(TRUE);
}

/***************************************************************************

 DB_Stop()

 Shut down the Databse module when the program is quit. No harm comes if the
 module has never been initialized, if the initialization failed, or if
 DB_Stop() has already been called.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void DB_Stop(void)
{
	uint32 i;

	// Delete any database pools that are present.
	for(i = 0; i < MAX_TARGETS; i++)
	{
		// Delete the database item pool if present, which effectively del-
		// etes the database.
		if(Envmt.DBasePool[i])
			IExec->FreeSysObject(ASOT_ITEMPOOL, Envmt.DBasePool[i]);
	}

	// Free the demangled name buffer.
	if(Envmt.NameBuff) free(Envmt.NameBuff);

	// Zero out the environment, so we know it's all disposed of in case
	// we're called again.
	memset(&Envmt, 0, sizeof(Envmt));
}

/***************************************************************************

 Success = DB_Create(Target, Name)

 Create a new, empty database to hold profile data for the specified target.
 The database will be given the specified name, which will appear on the GUI
 tab used to display the database. The database contents will not be added to
 the GUI until DB_Display() is called on it.

 Fails if there is already a database for the specified target.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure.

 Name = A pointer to an ASCIIZ string with the name of the target program.
	The target number and a colon will be prepended to the program name to
	form the database name. The maximum length of the name (including the
	trailing NUL) is DBASE_NAME_LEN - 2; any further characters will be trun-
	cated.

 Out ----------------------------------------------------------------------

 Success = TRUE if the database was created, or FALSE if it failed.

***************************************************************************/

BOOL DB_Create(uint32 Target, STRPTR Name)
{
	STRPTR DBName;

	// Turn the target number into an array index.
	Target--;

	// Validate the target number; fail if it's invalid.
	if(Target >= MAX_TARGETS) return(FALSE);

	// Fail if there is already a database for this target.
	if(Envmt.DBasePool[Target]) return(FALSE);

	// Create an item pool for database function records. No garbage collec-
	// tion is necessary, since we only allocate items and never free them.
	Envmt.DBasePool[Target] = IExec->AllocSysObjectTags(ASOT_ITEMPOOL,
		ASOITEM_MFlags, MEMF_CLEAR, ASOITEM_ItemSize, FUNCRECD_SIZE,
		ASOITEM_GCPolicy, ITEMGC_NONE, TAG_END);

	// Fail if we didn't get the item pool.
	if(!Envmt.DBasePool[Target]) return(FALSE);

	// Generate the database's name. Convert the target number into an ASCII
	// digit, followed by a colon.
	DBName = Envmt.DBaseName[Target];
	*DBName++ = '1' + Target; *DBName++ = ':';

	// Add the target program's name, truncating any characters that won't
	// fit. Someday we might want to handle this a bit more elegantly, such
	// as adding an ellipsis ("...") to indicate the truncation.
	STRCPYN(DBName, Name, DBASE_NAME_LEN-3);

	// Done- return success.
	return(TRUE);
}

/***************************************************************************

 Success = DB_Delete(Target)

 Delete the specified database. Do nothing if the specified database doesn't
 exist; this is not considered an error.

 Note that the corresponding target tab should be removed from the GUI before
 the database is deleted, since the tab's list viewer has pointers to records
 in the database.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure.

 Out ----------------------------------------------------------------------

 Success = TRUE if the database was deleted or doesn't exist, or FALSE if we
	couldn't.

***************************************************************************/

BOOL DB_Delete(uint32 Target)
{
	// Turn the target number into an array index.
	Target--;

	// Validate the target number; fail if it's invalid.
	if(Target >= MAX_TARGETS) return(FALSE);

	// Do nothing if there is no database for this target. This is not con-
	// sidered an error.
	if(!Envmt.DBasePool[Target]) return(TRUE);

	// Delete the item pool for the database. This effectively deletes all of
	// the database records.
	IExec->FreeSysObject(ASOT_ITEMPOOL, Envmt.DBasePool[Target]);

	// Blank the database pointers to signify its absense.
	Envmt.DBasePool[Target] = NULL;
	Envmt.Database[Target] = NULL;
	Envmt.DBaseName[Target][0] = '\0';

	// Done- return success.
	return(TRUE);
}

/***************************************************************************

 Result = DB_Check(Target)

 Check to see if the specified database exists.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	return FALSE.

 Out ----------------------------------------------------------------------

 Result = TRUE if the database exists, or FALSE if it doesn't or if the tar-
	get number was invalid.

***************************************************************************/

BOOL DB_Check(uint32 Target)
{
	// Turn the target number into an array index.
	Target--;

	// Validate the target number; fail if it's invalid.
	if(Target >= MAX_TARGETS) return(FALSE);

	// Let the caller know whether the database exists or not.
	if(Envmt.DBasePool[Target]) return(TRUE);
	else return(FALSE);
}

/***************************************************************************

 Title = DB_Title(Target)

 Return the title of the specified database, which is intended to serve as
 the title of the corresponding GUI tab. It's a maximum of DBASE_NAME_LEN
 characters (including the trailing NUL), and takes the form <TgtNum>:<Tgt-
 Name>, where <TgtNum> is the target number, and <TgtName> is the name of the
 target program.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	return NULL.

 Out ----------------------------------------------------------------------

 Result = A pointer to the database title, or NULL if the target number was
	invalid or the specified database doesn't exist.

***************************************************************************/

STRPTR DB_Title(uint32 Target)
{
	// Turn the target number into an array index.
	Target--;

	// Validate the target number; fail if it's invalid.
	if(Target >= MAX_TARGETS) return(NULL);

	// If the database is present, return its name.
	if(Envmt.DBasePool[Target]) return(Envmt.DBaseName[Target]);

	// Otherwise fail.
	else return(NULL);
}

/***************************************************************************

 Result = DB_PutRecord(Target, FuncID, CallCt, InclTime, ExclTime)

 Write the given data to the specified function's record in the specified
 target database. The database must already exist. If the function already
 has a record in the database, it is updated with the new data. If the func-
 tion does not have a record in the database, one is added.

 The data is converted from raw format to display format (i.e. timer ticks to
 time units), dependent data is (re)calculated (average times), and the dis-
 play text strings are updated to reflect the new values. All this can take
 some time to happen.

 The percentage fields are not updated, since they depend on all records in
 the database, not just this one. Call DB_Totalize() to update the percent-
 ages once all of the individual records have been updated.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure, as will lack of a database for this target.

 FuncID = The ID (address) of the function whose entry is being written to.

 CallCt = The call count for the function.

 InclTime = The total inclusive execution time for all calls to the function,
	in EClock ticks.

 ExclTime = The total exclusive execution time for all calls to the function,
	in EClock ticks.

 Out ----------------------------------------------------------------------

 Result = TRUE if the data was added to or updated in the database; FALSE if
	the operation failed.

***************************************************************************/

BOOL DB_PutRecord(uint32 Target, APTR FuncID, uint32 CallCt,
	uint64 InclTime, uint64 ExclTime)
{
	struct DBFuncRecd *Record;
	struct DebugSymbol *SrcInfo;
	char *Demangled;
	int NameErr;
	BOOL DoIncl = FALSE;
	BOOL DoExcl = FALSE;

	// Turn the target number into an array index.
	Target--;

	// Validate the target number; fail if it's invalid.
	if(Target >= MAX_TARGETS) return(FALSE);

	// Fail if there's no database for this target.
	if(!Envmt.DBasePool[Target]) return(FALSE);

	// Look up the function's record in the database.
	Record = (struct DBFuncRecd *)
		IExec->AVL_FindNode((struct AVLNode *)Envmt.Database[Target],
		FuncID, AVLKeyComp);

	// If the record could not be found, then we need to add it.
	if(!Record)
	{
		// Allocate a new function record from the item pool. Fail if we
		// can't.
		Record = IExec->ItemPoolAlloc(Envmt.DBasePool[Target]);
		if(!Record) return(FALSE);

		// Initialize the record. Store the function's address as its ID/AVL
		// key.
		Record->FuncID = FuncID;

		// Get source code information for the function based on its address.
		// Exec looks this up from the target file's debug info. Older Exec
		// versions have a bug that requires the function address to be
		// bumped ahead by four.
		if(Envmt.ExecBug)
			SrcInfo = IDebug->ObtainDebugSymbol(FuncID + 4, NULL);
		else
			SrcInfo = IDebug->ObtainDebugSymbol(FuncID, NULL);

		if(SrcInfo && SrcInfo->SourceFunctionName)
		{
			// Run all source names through the C++ demangler.
			if(Demangled = __cxa_demangle(SrcInfo->SourceFunctionName,
				Envmt.NameBuff, &Envmt.NameBuffLen, &NameErr))
			{
				// Demangling succeeded, so the name must have been a mangled
				// C++ name. Put the demangled name into the function record.
				// Truncate the name if it's too long.
				STRCPYN(Record->FuncName, Demangled, FUNC_NAME_LEN-1);

				// Update the address of the name buffer, in case the deman-
				// gler allocated a larger one. If it did, it has already up-
				// dated the buffer size.
				Envmt.NameBuff = Demangled;
			}
			else
			{
				// Demangling failed (which will happen if the name isn't
				// mangled, or if something else went wrong). Put the actual
				// name into the function record. Truncate the name if it's
				// too long.
				STRCPYN(Record->FuncName, SrcInfo->SourceFunctionName,
					FUNC_NAME_LEN-1);
			}

			// Leave the source file location empty if no information is
			// available.
			if(SrcInfo->SourceFileName)
			{
				// Store the source file name and line number for efficient
				// sorting. We keep a few more characters of long names than
				// we'll display.
				STRCPYN(Record->FuncFile, SrcInfo->SourceFileName,
					 FUNC_LOCN_LEN-1);
				Record->FuncLine = SrcInfo->SourceLineNumber;

				// Turn the location into a displayable string. Start with
				// the file name; reserve enough room for the separator and
				// line number, truncating the file name if necessary. Then
				// add a colon separator, followed by the line number. Enough
				// room is kept for line numbers up to 9999; larger numbers
				// may be truncated if the file name is too long.
				snprintf(Record->FuncLocn, FUNC_LOCN_LEN, "%.*s:%lu",
					FUNC_LOCN_LEN-6, SrcInfo->SourceFileName,
					SrcInfo->SourceLineNumber);
			}
		}
		else
		{
			// No source info is available, so do the best we can. Convert
			// the function address into printable hex characters, with a
			// leading '0x'. This serves as the function's name.
			snprintf(Record->FuncName, FUNC_NAME_LEN, "%p", FuncID);

			// The function's source code location remains blank.
		}

		// We're done with the symbol info.
		if(SrcInfo) IDebug->ReleaseDebugSymbol(SrcInfo);

		// All of the numeric text strings are blank until the data is mod-
		// ified the first time. The 'Displayed' flag is false until the 
		// record is sent to the GUI.

		// Add the new record to the database. This can't fail.
		IExec->AVL_AddNode((struct AVLNode **)&Envmt.Database[Target],
			(struct AVLNode *)Record, AVLNodeComp);
	}

	// Whether the record existed already or was just added, fill it in with
	// the given data and create the corresponding text strings. First, con-
	// vert the times from EClock ticks to nanoseconds.
	InclTime = TicksToNS(InclTime);
	ExclTime = TicksToNS(ExclTime);

	// Update the call count only if it's changed.
	if(CallCt != Record->CallCount)
	{
		// Store the new call count, and update the corresponding text
		// string.
		Record->CallCount = CallCt;
		snprintf(Record->CallCountStr, CALL_CNT_LEN, "%lu", CallCt);

		// Need to update the averages that vary with the call count.
		DoIncl = DoExcl = TRUE;
	}

	// Update the inclusive time only if it's changed.
	if(InclTime != Record->InclTime)
	{
		// Store the new inclusive time, and update the corresponding text
		// string.
		Record->InclTime = InclTime;
		TimeStr(Record->InclTimeStr,  EXEC_TIME_LEN, InclTime);

		// Need to update the averages that vary with the inclusive time.
		DoIncl = TRUE;
	}

	// Update the exclusive time only if it's changed.
	if(ExclTime != Record->ExclTime)
	{
		// Store the new exclusive time, and update the corresponding text
		// string.
		Record->ExclTime = ExclTime;
		TimeStr(Record->ExclTimeStr,  EXEC_TIME_LEN, ExclTime);

		// Need to update the averages that vary with the exclusive time.
		DoExcl = TRUE;
	}

	// Update the inclusive average, if it's changed.
	if(DoIncl)
	{
		// Calculate the new average time based on the new total time and
		// call count, with rounding. Update the corresponding text string.
		Record->AvgInclTime = (InclTime + CallCt / 2) / CallCt;
		TimeStr(Record->AvgInclTimeStr,  EXEC_TIME_LEN, Record->AvgInclTime);
	}

	// Update the exclusive average, if it's changed.
	if(DoExcl)
	{
		// Calculate the new average time based on the new total time and
		// call count, with rounding. Update the corresponding text string.
		Record->AvgExclTime = (ExclTime + CallCt / 2)  / CallCt;
		TimeStr(Record->AvgExclTimeStr,  EXEC_TIME_LEN, Record->AvgExclTime);
	}

	// Done- return success.
	return(TRUE);
}

/***************************************************************************

 Result = DB_Totalize(Target)

 Calculate the cross-function values for the specified database. The total
 exclusive run time of all functions in the database is determined, to serve
 as the total run time of the target program to date. The percentages of this
 time for each function are then calculated, based on the total in/exclusive
 run times of the function. The corresponding display text strings are updat-
 ed to reflect the new numbers.

 Since the values calculated depend on the current contents of the database,
 this function should only be called after all the records in the database
 have been updated.

 Does nothing if the database exists but is empty; this is not considered an
 error.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure, as will lack of a database for this target.

 Out ----------------------------------------------------------------------

 Result = TRUE if the database was updated. FALSE if the operation failed.

***************************************************************************/

BOOL DB_Totalize(uint32 Target)
{
	struct DBFuncRecd *Record;
	uint64 HalfTime, TotalTime = 0;
	uint32 Percent;
	ldiv_t Result;

	// Turn the target number into an array index.
	Target--;

	// Validate the target number; fail if it's invalid.
	if(Target >= MAX_TARGETS) return(FALSE);

	// Fail if there's no database for this target.
	if(!Envmt.DBasePool[Target]) return(FALSE);

	// Get the first record in the database. Abort if there isn't one (the
	// database is empty, so there's nothing to do).
	Record = (struct DBFuncRecd *)
		IExec->AVL_FindFirstNode((struct AVLNode *)Envmt.Database[Target]);
	if(!Record) return(TRUE);

	// There's at least one record in the database. Loop through the records
	// in function ID/address order.
	while(Record)
	{
		// Add the function's total exclusive execution time to the grand
		// total for the target. We assume a uint64 is big enough that over-
		// flow will not be a problem.
		TotalTime += Record->ExclTime;

		// Get the next record.
		Record = (struct DBFuncRecd *)
			IExec->AVL_FindNextNodeByAddress((struct AVLNode *)Record);
	}

	// To save time below, pre-calculate the value used for rounding during
	// the percentage calculations.
	HalfTime = TotalTime / 2;

	// Now that we've got the total execution time for the target program,
	// loop through the database again to update the percentages.
	Record = (struct DBFuncRecd *)
		IExec->AVL_FindFirstNode((struct AVLNode *)Envmt.Database[Target]);
	while(Record)
	{
		// Calculate the inclusive time as a percentage of the total time,
		// with rounding. Units are tenths of a percent.
		Percent = (Record->InclTime * 1000 + HalfTime) / TotalTime;

		// For speed only update the percentage if the value has changed, ex-
		// cept display zero instead of blank once some time has accumulated.
		if((Percent != Record->PctInclTime) ||
			(Record->InclTime && (Record->PctInclTimeStr[0] == '\0')))
		{
			Record->PctInclTime = Percent;

			// Update the corresponding text string.
			Result = ldiv(Percent, 10UL);
			snprintf(Record->PctInclTimeStr, PERCT_LEN, "%lu.%lu %%",
				Result.quot, Result.rem);
		}

		// Calculate the exclusive time as a percentage of the total time,
		// with rounding. Units are tenths of a percent.
		Percent = (Record->ExclTime * 1000 + HalfTime) / TotalTime;

		// For speed only update the percentage if the value has changed, ex-
		// cept display zero instead of blank once some time has accumulated.
		if((Percent != Record->PctExclTime) ||
			(Record->ExclTime && (Record->PctExclTimeStr[0] == '\0')))
		{
			Record->PctExclTime = Percent;

			// Update the corresponding text string.
			Result = ldiv(Percent, 10UL);
			snprintf(Record->PctExclTimeStr, PERCT_LEN, "%lu.%lu %%",
				Result.quot, Result.rem);
		}

		// Get the next record.
		Record = (struct DBFuncRecd *)
			IExec->AVL_FindNextNodeByAddress((struct AVLNode *)Record);
	}

	// Done- return success.
	return(TRUE);
}

/***************************************************************************

 DB_GetStrings(Record, Strings)

 Return pointers to the display text strings for the specified database rec-
 ord. The GUI stores only the record address for each entry it displays, and
 depends on this function to translate that value into the text strings that
 are displayed for each column in the display.

 The order of the columns in the GUI display is hardcoded in this function:
 Function, Location, Call Count, Inclusive Time, Percent Inclusive Time, Av-
 erage Inclusive Time, Exclusive Time, Percent Exclusive Time, Average Ex-
 clusive Time. The GUI allows the columns to be reordered, but always accepts
 the strings in this order.

 The GUI has no idea whether the corresponding database is still present or
 not, and will continue to feed record pointers to this function even if the
 database has been deleted. To prevent this, the GUI tab corresponding to the
 database must be closed before the database is deleted.

 In -----------------------------------------------------------------------

 Record = A pointer to the database record of interest. If NULL then empty
	strings ("") will be returned.

 Strings = A pointer to an array of NUM_GUI_COLUMNS string pointers. Each
	pointer in the array will be set to point to the corresponding column's
	display text string.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void DB_GetStrings(APTR Record, STRPTR *Strings)
{
	struct DBFuncRecd *Recd;

	// Save a lot of casting.
	Recd = (struct DBFuncRecd *)Record;

	// Fill the strings array with pointers to the text display strings for
	// the specified record, or empty strings if the record is NULL.
	Strings[0] = Recd ? Recd->FuncName : Empty;
	Strings[1] = Recd ? Recd->FuncLocn : Empty;
	Strings[2] = Recd ? Recd->CallCountStr : Empty;
	Strings[3] = Recd ? Recd->InclTimeStr : Empty;
	Strings[4] = Recd ? Recd->PctInclTimeStr : Empty;
	Strings[5] = Recd ? Recd->AvgInclTimeStr : Empty;
	Strings[6] = Recd ? Recd->ExclTimeStr : Empty;
	Strings[7] = Recd ? Recd->PctExclTimeStr : Empty;
	Strings[8] = Recd ? Recd->AvgExclTimeStr : Empty;
}

/***************************************************************************

 DB_GetData(Record, Data)

 Return pointers to the raw data values for the specified database record.
 These are the values that are used to generate the GUI-suitable strings re-
 turned by DB_GetStrings(), and may be used in cases where the strings are
 not appropriate. For the Function and Location fields the string is the raw
 data, so the returned value is a string pointer. For the other values the
 returned value is a pointer to the raw data.

 The order of the returned data fields matches the GUI columns: Function,
 Location, Call Count, Inclusive Time, Percent Inclusive Time, Average In-
 clusive Time, Exclusive Time, Percent Exclusive Time, Average Exclusive
 Time. As with DB_GetStrings(), this function depends on the database being
 present in order to return meaningful data.

 In -----------------------------------------------------------------------

 Record = A pointer to the database record of interest. If NULL then empty
	strings or NULL data will be returned.

 Data = A pointer to an array of NUM_GUI_COLUMNS data pointers. Each pointer
	in the array will be set to point to the corresponding column's raw data
	value.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void DB_GetData(APTR Record, APTR *Data)
{
	struct DBFuncRecd *Recd;

	// Save a lot of casting.
	Recd = (struct DBFuncRecd *)Record;

	// Fill the data array with pointers to the raw data for the specified
	// record, or empty strings/null data if the record is NULL.
	Data[0] = Recd ? Recd->FuncName : Empty;
	Data[1] = Recd ? Recd->FuncLocn : Empty;
	Data[2] = Recd ? (APTR)&Recd->CallCount : &None;
	Data[3] = Recd ? &Recd->InclTime : &None;
	Data[4] = Recd ? (APTR)&Recd->PctInclTime : &None;
	Data[5] = Recd ? &Recd->AvgInclTime : &None;
	Data[6] = Recd ? &Recd->ExclTime : &None;
	Data[7] = Recd ? (APTR)&Recd->PctExclTime : &None;
	Data[8] = Recd ? &Recd->AvgExclTime : &None;
}

/***************************************************************************

 Result = DB_compare(Record1, Record2, Column)

 Compare the two given database records and determine which is greater than
 the other for sorting purposes. The specified database column determines
 which field in the records is the one to be compared.

 In -----------------------------------------------------------------------

 Record1 = A pointer to the first database record to be compared. NULL causes
	zero to be returned.

 Record2 = A pointer to the second database record to be compared. NULL caus-
	es zero to be returned.

 Column = A value between 0 and NUM_GUI_COLUMNS - 1. Illegal values cause
	zero to be returned.

 Out ----------------------------------------------------------------------

 Result = A positive number if Record1 comes after Record2, a negative num-
	ber if Record1 comes before Record2, or zero if both records are equal
	(or an error was encountered).

***************************************************************************/

int32 DB_Compare(APTR Record1, APTR Record2, uint32 Column)
{
	struct DBFuncRecd *Recd1, *Recd2;
	int32 Result;
	int64 Delta;

	// Return zero if either record pointer is NULL.
	if(!Record1 || !Record2) return(0);

	// Save a lot of casting.
	Recd1 = (struct DBFuncRecd *)Record1;
	Recd2 = (struct DBFuncRecd *)Record2;

	// Compare the specified field in the two records.
	switch(Column)
	{
		case 0:
			// Compare the function names, ignoring case. Length is limited
			// in case either record is invalid.
			return(strncasecmp(Recd1->FuncName, Recd2->FuncName,
				FUNC_NAME_LEN));
			break;

		case 1:
			// Compare the source file names, ignoring case. Length is limit-
			// ed in case either record is invalid. If the names are differ-
			// ent, sort by the name alone.
			Result = strncasecmp(Recd1->FuncFile, Recd2->FuncFile,
				FUNC_LOCN_LEN);
			if(Result) return(Result);

			// If the names are the same, then sort by the line number.
			return(Recd1->FuncLine - Recd2->FuncLine);
			break;

		case 2:
			// Compare the call counts.
			return(Recd1->CallCount - Recd2->CallCount);
			break;

		case 3:
		case 4:
			// Compare the total inclusive run time. Used for the percent
			// column as well, since the sort order is the same and the times
			// have greater resolution.
			Delta = Recd1->InclTime - Recd2->InclTime;
			return((Delta > 0) ? 1 : (Delta < 0) ? -1 : 0);
			break;

		case 5:
			// Compare the average inclusive run time.
			Delta = Recd1->AvgInclTime - Recd2->AvgInclTime;
			return((Delta > 0) ? 1 : (Delta < 0) ? -1 : 0);
			break;

		case 6:
		case 7:
			// Compare the total exclusive run time. Used for the percent
			// column as well, since the sort order is the same and the times
			// have greater resolution.
			Delta = Recd1->ExclTime - Recd2->ExclTime;
			return((Delta > 0) ? 1 : (Delta < 0) ? -1 : 0);
			break;

		case 8:
			// Compare the average exclusive run time.
			Delta = Recd1->AvgExclTime - Recd2->AvgExclTime;
			return((Delta > 0) ? 1 : (Delta < 0) ? -1 : 0);
			break;

		default:
			// Return zero for invalid column numbers.
			return(0);
	}
}

/***************************************************************************

 Result = DB_Display(Target)

 Display the database for the given target via the GUI. The GUI must already
 have an open tab for the target. Any database records that have not already
 been sent to the GUI are added, the GUI display is sorted per the current
 sort column and order, and the GUI's display is refreshed to show any chan-
 ges. This will also pick up changes to database records that have already
 been sent to the GUI.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values cause
	failure, as do values for which no database or GUI tab exists.

 Out ----------------------------------------------------------------------

 Result = TRUE if successful as far as we can tell, or FALSE if there was a
	known error.

***************************************************************************/

BOOL DB_Display(uint32 Target)
{
	struct DBFuncRecd *Record;
	uint32 Tgt;

	// Validate the target number. Fail if it's invalid.
	if((Target == 0) || (Target > MAX_TARGETS)) return(FALSE);

	// Fail if there is no GUI tab for this target.
	if(!GUI_CheckTarget(Target)) return(FALSE);

	// Turn the target number into an array index.
	Tgt = Target - 1;

	// Fail if there's no database for this target.
	if(!Envmt.DBasePool[Tgt]) return(FALSE);

	// Get the first record in the database. Abort if there isn't one (the
	// database is empty, so there's nothing to do).
	Record = (struct DBFuncRecd *)
		IExec->AVL_FindFirstNode((struct AVLNode *)Envmt.Database[Tgt]);
	if(!Record) return(TRUE);

	// There's at least one record in the database. Set the GUI so it won't
	// refresh its display until we're done processing records.
	GUI_BeginUpdate(Target);

	// Loop through the database records in function ID/address order.
	while(Record)
	{
		// See if the record has already been sent to the GUI.
		if(!Record->Displayed)
		{
			// Nope- add the record to the GUI, and remember that we've done
			// so.
			GUI_AddEntry(Target, (APTR)Record);
			Record->Displayed = TRUE;
		}

		// Get the next record.
		Record = (struct DBFuncRecd *)
			IExec->AVL_FindNextNodeByAddress((struct AVLNode *)Record);
	}

	// The GUI now has all the records in the database. Have it sort them to
	// reflect any additions, as well as changes to the content of existing
	// records.
	GUI_Sort(Target);

	// Allow the GUI to refresh its display to reflect all the changes that
	// have been made.
	GUI_EndUpdate(Target);

	// Let the caller know all is well.
	return(TRUE);
}
