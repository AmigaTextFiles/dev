#ifndef _JOINOS_PROTOS_H_
#define _JOINOS_PROTOS_H_ 1

/* JoinOSProto.h
 *
 * The prototypes of the functions in the joinOS.library.
 */

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDos.h>
#endif

#ifndef _DOSBASE_H_
#include <joinOS/dos/DosBase.h>
#endif

extern struct Library *JoinOSBase;

#ifdef _AMIGA

/* -------------------------------------------------------------------------- */
/* --- Amiga-Part ----------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

#include <joinOS/pragmas/JoinOSPragma.h>
#include <joinOS/misc/TagItems.h>

/* --- Exec memory support functions - Memory.c ----------------------------- */

APTR AllocVector (ULONG size, ULONG attributes);
void FreeVector (APTR mem);

void* AllocStack (struct Task *task, ULONG size);	/* DON'T USE -> GURU */
void FreeStack (struct Task *task, ULONG size);		/* DON'T USE -> GURU */

ULONG AvailMemory (struct List *memList, ULONG Attributes);
void ClearMem (APTR mem, ULONG size);
void FillMem (APTR mem, ULONG size, UBYTE byte);
void MoveMem (APTR source, APTR dest, ULONG length);
void ClearMemHeader (struct MemHeader *membh);

void* CreateMemPool (ULONG MemFlags, ULONG PuddleSize, ULONG ThreshSize);
void* AllocPoolMem (void *PoolHeader, ULONG size);
void FreePoolMem (void *PoolHeader, void *mem, ULONG size);
void DeleteMemPool (void* PoolHeader);

/* --- other Exec support functions - Lists.c - Semaphore.c - Exec.c -------- */

ULONG CountNodes (struct List *list);

struct SignalSemaphore *CreateSignalSemaphore (STRPTR name, BYTE pri);
void DeleteSignalSemaphore (struct SignalSemaphore *sigSem);

void MakeUniqueName (UBYTE *Buffer, ULONG Count);

/* --- Macros needed for writing portable code ------------------------------ */

/* NAME
 *		IsValidMemList - check the returnvalue of AllocEntry()
 *
 * SYNOPSIS
 *		BOOL IsValidMemList (struct MemList *);
 *
 *		succeed = IsValidMemList (memList);
 *
 * FUNCTION
 *		Because of the different return values - returned by AllocEntry() under
 *		the different systems that indicates failure, you should use this macro
 *		to test the result of the function AllocEntry() to write compatible code.
 *
 * INPUT
 *		memList - a pointer to a MemList structure as returned by AllocEntry().
 *
 * RESULT
 *		A boolean value indicating that the MemList structure is a valid MemList
 *		structure is returned.
 *		If TRUE is returned, AllocEntry() has succeed, else AllocEntry() failed
 *		and memList is the requirement that failed (something like MEMF_CHIP or
 *		MEMF_FAST etc.).
 *
 * EXAMPLE
 *			if (IsValidMemList(memlist = AllocEntry (aMemList)))
 *			{
 *				// succeed
 *			}
 *			else
 *			{
 *				// failure, memlist is the type of memory we failed to allocate
 *			}
 */
#define IsValidMemList(memList) (!((memList) & 0x80000000))

/* NAME
 *		GetSysBase - Get the address of Execs library node
 *
 * SYNOPSIS
 *		SysBase = GetSysBase ()
 *		struct ExecBase *GetSysBase (void)
 *
 * FUNCTION
 *		This macro (and the equivalent Windoof-function) returns the address
 *		where the Exec library node is found in memory.
 *
 *	RESULT
 *		The address of Execs library node is returned.
 */
#define GetSysBase() (*((struct ExecBase **) 4))

/* --- Function-equivalents for Alloc...(), FreeDosObject() --- DosMemory.c - */

void *AllocDOSObject (ULONG Type, struct TagItem *Tags);
void FreeDOSObject (ULONG Type, void *Object);

/* --- Function-equivalents for ExAll(), ExAllEnd() ------------- DOSLock.c - */

LONG ExamineAll (BPTR FileLock, struct ExAllData *Buffer, ULONG BufSize,
											ULONG Type, struct ExAllControl *ExAllControl);
void ExamineAllEnd (BPTR FileLock, struct ExAllData *Buffer, ULONG BufSize,
											ULONG Type, struct ExAllControl *ExAllControl);

/* --- Argument parsing functions - RDArgs.c -------------------------------- */

void FreeArguments (struct RDArgs* rdArgs);
struct RDArgs *ParseArgs (STRPTR template, LONG *array, struct RDArgs *rdArgs);
LONG FindArgument (STRPTR template, STRPTR keyword);
LONG ParseItem (UBYTE *buffer, ULONG bufSize, struct CSource *source);

/* --- Pattern parsing functions - MatchPattern.c --------------------------- */

LONG PatternParse (const UBYTE *rawPattern, UBYTE *tokenBuffer, ULONG bufSize);
LONG PatternParseNoCase (const UBYTE *rawPattern, UBYTE *tokenBuffer,
													 								ULONG bufSize);

/* --- Pattern matching functions - MatchPattern.c -------------------------- */

BOOL PatternMatch (UBYTE *Pattern, const UBYTE *TokenString);
BOOL PatternMatchNoCase (UBYTE *Pattern, const UBYTE *TokenString);

/* --- Filesystem objects locating functions - MatchPattern.c --------------- */

LONG FindFirstMatch (STRPTR pattern, struct AnchorPath *anchor);
LONG FindNextMatch (struct AnchorPath *anchor);
void FindMatchEnd (struct AnchorPath *anchor);

/* --- usefull functions ---------------------------------------- DOSLock.c - */

LONG PathFromLock (BPTR fl, STRPTR path, ULONG size);

/* --- usefull functions ----------------------------------------- JoinOS.c - */

STRPTR TempFileName (STRPTR tempdir, STRPTR prefix, STRPTR extension);
BOOL AsyncCopyFile (STRPTR source, STRPTR dest, BOOL fExist);

/* --- AmigaDOS function replacements (for OS 1.2 upto OS. 1.3) - DOSDate.c - */

LONG Str2Long (STRPTR String, LONG *Value);
LONG Long2Str (LONG Value, char* Buffer);
LONG DatesCompare (const struct DateStamp *First, const struct DateStamp *Second);
BOOL Date2Str (struct DateTime *DateTime);
BOOL Str2Date (struct DateTime *DateTime);

/* --- DosList -------------------------------------------------- DOSList.c - */

struct DosList *LockDOSList (ULONG AccessFlags);
void UnLockDOSList (ULONG AccessFlags);
struct DosList *NextDOSEntry(struct DosList *Previous, ULONG AccessFlags);
struct DosList *FindDOSEntry(struct DosList *Previous, const char *Name,
																		 ULONG AccessFlags);

/* --- Packet-I/O --------------------------------------------- DOSPacket.c - */

void AbortDosPkt (struct MsgPort *mp, struct DosPacket *dp);
LONG DoDosPkt (struct MsgPort *mp, LONG type, LONG arg1, LONG arg2, LONG arg3,
																			LONG arg4, LONG arg5);
void SendDosPkt (struct DosPacket *dp, struct MsgPort *mp,
													struct MsgPort *rp);
void ReplyDosPkt (struct DosPacket *dp, LONG res1, LONG res2);
struct DosPacket *WaitDosPkt (void);

/* --- Errorhandling functions --------------------------------- DOSError.c - */

LONG SetIOErr (LONG result);
LONG ErrorText (LONG code, STRPTR text, STRPTR buffer, LONG bufsize);
LONG PrintError (LONG ErrorCode, STRPTR Text);
LONG ReportError (LONG code, ULONG type, ULONG arg1, struct MsgPort *mp);

/* --- Tag functions (as in utility.library) ------------------- TagItems.c - */

struct TagItem *AllocateTagList (ULONG numTags);
void ChangeTagList (struct TagItem *list, struct TagItem *changeList);
struct TagItem *CloneTagList (struct TagItem *original);
void FilterChangeTags (struct TagItem *changeList, struct TagItem *originalList, ULONG apply);
ULONG FilterTagList (struct TagItem *tagList, Tag *FilterArray, ULONG logic);
struct TagItem *FindTag (Tag tagValue, struct TagItem *tagList);
void FreeTagList (struct TagItem *tagList);
ULONG GetTagItem (Tag tagValue, ULONG defaultVal, struct TagItem *tagList);
void MapTagList (struct TagItem *tagList, struct TagItem *mapList, ULONG mapType);
struct TagItem *NextTag (struct TagItem **tagItemPtr);
ULONG PackBooleanTags (ULONG initialFlags, struct TagItem *tagList,
																struct TagItem *boolMap);
ULONG PackStructTags (APTR pack, ULONG *packTable,
											struct TagItem *tagList);
void RefreshTagListClones (struct TagItem *clone, struct TagItem *original);
BOOL TagIsInArray (Tag tagValue, Tag *tagArray);
ULONG UnpackStructTags (APTR pack, ULONG *packTable,
											struct TagItem *tagList);

/* --- an easy to use requester --------------------------------- TextBox.c - */

LONG TextBoxA (APTR window, const char *caption, const char *textFormat, UWORD type, ULONG *args);
LONG TextBox (APTR window, const char *caption, const char *textFormat, UWORD type, ULONG arg1,...);

/* --- 64 bit math functions ----------------------------------- Math64.asm - */

/* These are the C-Language functions for 64bit calculations.
 *
 * If a division by zero occurs, the division functions returns a result with
 * all bits set, the caller of this functions should take care, that such a
 * case never occures, because this result could also be produced by valid
 * divisors (e.g. 0xFFFF FFFF FFFF FFFF / 1)
 *
 * Every function expects a pointer to the DOUBLELONG as argument (a DOUBLELONG
 * is an array of two LONG values, the first LONG gets/holds the upper
 *	significant 32 bits, the second LONG gets/holds the lower 32 bits).
 * See <JoinOs/exec/defines.h>
 */

/* Function prototypes of the Math64 functions:
 */
void __asm Mulu64 (register __d0 ULONG arg1, register __d1 ULONG arg2,
															register __a0 DOUBLELONG *result);
void __asm Muls64 (register __d0 LONG arg1, register __d1 LONG arg2,
															register __a0 DOUBLELONG *result);
void __asm Divu64 (register __a0 DOUBLELONG *divident, register __d0 ULONG divisor);
void __asm Divs64 (register __a0 DOUBLELONG *divident, register __d0 LONG divisor);
void __asm Adds64 (register __a0 DOUBLELONG *arg1, register __a1 DOUBLELONG *arg2);
void __asm Neg64 (register __a0 DOUBLELONG *arg);

/* Function prototypes for other math functions:
 */
ULONG __asm Sqrt32 (register __d0 ULONG value);

/* --- math64-related functions ---------------------------------- JoinOS.c - */

LONG DOUBLELONG2Str (DOUBLELONG *value, STRPTR buffer);
LONG Str2DOUBLELONG (STRPTR string, DOUBLELONG *value);

/* --- macros --------------------------------------------------------------- */

/* NAME
 *		Upper - convert a character to an upper character
 *
 * SYNOPSIS
 *		upper = Upper (lower)
 *     D0             D0
 *		char Upper (const char)
 *
 * FUNCTION
 *		This function returns the upper character of the specified character.
 *		All characters - including the special characters (like 'ä') - are
 *		converted to upper characters. If the specified character is a number
 *		or something like a punctuation mark, or even already an upper character
 *		the character is returned unchanged.
 *
 * INPUT
 *		lower	- the character that should be transformed to its upper equivalent.
 *
 *	RESULT
 *		The equivalent upper character to the specified one is returned.
 *		If there is no equivalent upper character, or the specified one is
 *		already an upper one, the same character is returned.
 */
#ifndef Upper
#define Upper(c) (((((c)>96)&&((c)<123))||(((c)>223)&&((c)<255)))?(c)&223:(c))
#endif

#else		/*_AMIGA */

/* -------------------------------------------------------------------------- */
/* --- Windoof-Part --------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

#ifndef EXPORT
#define EXPORT __declspec(dllimport)
#endif

/* --- perhaps usefull functions, used by patternmatching routines ---------- */

#include <ctype.h>

#ifndef Upper
#define Upper(c) toupper(c)
#endif

/* --- Exec function replacements (for OS 1.2 upto OS 2.1) ------------------ */

#ifndef AllocVector
#define AllocVector(size,attributes) AllocVec(size,attributes)
#endif

#ifndef FreeVector
#define FreeVector(mem) FreeVec(mem)
#endif

#ifndef CreateMemPool
#define CreateMemPool(MemFlags,PuddleSize,ThreshSize) CreatePool(MemFlags,PuddleSize,ThreshSize)
#endif

#ifndef AllocPoolMem
#define AllocPoolMem(poolHeader,size) AllocPooled(poolHeader,size)
#endif

#ifndef FreePoolMem
#define FreePoolMem(poolHeader,mem,size) FreePooled(poolHeader,mem,size)
#endif

#ifndef DeleteMemPool
#define DeleteMemPool(poolHeader) DeletePool(poolHeader)
#endif

/* --- AmigaDOS function replacements (for OS 1.2 upto OS 1.3) -------------- */

#ifndef LockDOSList
#define LockDOSList(AccessFlags) LockDosList(AccessFlags)
#endif

#ifndef UnLockDOSList
#define UnLockDOSList(AccessFlags) UnLockDosList(AccessFlags)
#endif

#ifndef FindDOSEntry
#define FindDOSEntry(Previous,Name,AccessFlags) FindDosEntry(Previous,Name,AccessFlags)
#endif

#ifndef NextDOSEntry
#define NextDOSEntry(Previous,AccessFlags) NextDosEntry(Previous,AccessFlags)
#endif

#ifndef Str2Long
#define Str2Long(string,value) StrToLong(string,value)
#endif

#ifndef Long2Str
#define Long2Str(value,string) LongToStr(value,string)
#endif

#ifndef DatesCompare
#define DatesCompare(First,Second) CompareDates(First,Second)
#endif

#ifndef Date2Str
#define Date2Str(DateTime) DateToStr(DateTime)
#endif

#ifndef Str2Date
#define Str2Date(DateTime) StrToDate(DateTime)
#endif

#ifndef AllocDOSObject
#define AllocDOSObject(Type,Tags) AllocDosObject(Type,Tags)
#endif

#ifndef FreeDOSObject
#define FreeDOSObject(Type,Object) FreeDosObject(Type,Object)
#endif

#ifndef SetIOErr
#define SetIOErr(result) SetIoErr(result)
#endif

#ifndef ErrorText
#define ErrorText(code,text,buffer,bufsize) Fault(code,text,buffer,bufsize)
#endif

#ifndef PrintError
#define PrintError(ErrorCode,Text) PrintFault(ErrorCode,Text)
#endif

#ifndef ReportError
#define ReportError(code,type,arg1,mp) ErrorReport(code,type,arg1,mp)
#endif

/* --- Examining functions -------------------------------------------------- */

#ifndef ExamineAll
#define ExamineAll(fl,Buffer,BufSize,Type,eac) ExAll(fl,Buffer,BufSize,Type,eac)
#endif

#ifndef ExamineAllEnd
#define ExamineAllEnd(fl,Buffer,BufSize,Type,eac) ExAllEnd(fl,Buffer,BufSize,Type,eac)
#endif

#ifndef PathFromLock
#define PathFromLock(fl,path,size) NameFromLock(fl,path,size)
#endif

/* --- Argument parsing functions ------------------------------------------- */

#ifndef FreeArguments
#define FreeArguments(rdArgs) FreeArgs(rdArgs)
#endif

#ifndef ParseArgs
#define ParseArgs(template,array,rdArgs) ReadArgs(template,array,rdArgs)
#endif

#ifndef FindArgument
#define FindArgument(template,keyword) FindArg(template,keyword)
#endif

#ifndef ParseItem
#define ParseItem(buffer,bufSize,source) ReadItem(buffer,bufSize,source)
#endif

/* --- Pattern parsing functions -------------------------------------------- */

#ifndef PatternParse
#define PatternParse(rawPattern,tokenBuffer,bufSize) ParsePattern(rawPattern,tokenBuffer,bufSize)
#endif

#ifndef PatternParseNoCase
#define PatternParseNoCase(rawPattern,tokenBuffer,bufSize) ParsePatternNoCase(rawPattern,tokenBuffer,bufSize)
#endif

/* --- Pattern matching functions ------------------------------------------- */

#ifndef PatternMatch
#define PatternMatch(Pattern,TokenString) MatchPattern(Pattern,TokenString)
#endif

#ifndef PatternMatchNoCase
#define PatternMatchNoCase(Pattern,TokenString) MatchPatternNoCase(Pattern,TokenString)
#endif

/* --- Filesystem objects locating functions -------------------------------- */

#ifndef FindFirstMatch
#define FindFirstMatch(pattern,anchor) MatchFirst(pattern,anchor)
#endif

#ifndef FindNextMatch
#define FindNextMatch(anchor) MatchNext(anchor)
#endif

#ifndef FindMatchEnd
#define FindMatchEnd(anchor) MatchEnd(anchor)
#endif

/* --- Packet-I/O ----------------------------------------------------------- */

#ifndef AbortDosPkt
#define AbortDosPkt(mp,dp) AbortPkt(mp,dp)
#endif

#ifndef DoDosPkt
#define DoDosPkt(mp,type,arg1,arg2,arg3,arg4,arg5) DoPkt(mp,type,arg1,arg2,arg3,arg4,arg5)
#endif

#ifndef SendDosPkt
#define SendDosPkt(dp,mp,rp) SendPkt(dp,mp,rp)
#endif

#ifndef ReplyDosPkt
#define ReplyDosPkt(dp,res1,res2) ReplyPkt(dp,res1,res2)
#endif

#ifndef WaitDosPkt
#define WaitDosPkt() WaitPkt()
#endif

/* --- Tag-list processing - (utility.library) ------------------------------ */

#ifndef AllocateTagList
#define AllocateTagList(numTags) AllocateTagItems(numTags)
#endif

#ifndef ChangeTagList
#define ChangeTagList(list,changeList) ApplyTagChanges(list,changeList)
#endif

#ifndef CloneTagList
#define CloneTagList(original) CloneTagItems(original)
#endif

#ifndef FilterChangeTags
#define FilterChangeTags(changeList,originalList,apply) FilterTagChanges(changeList,originalList,apply)
#endif

#ifndef FilterTagList
#define FilterTagList(tagList,FilterArray,logic) FilterTagItems(tagList,FilterArray,logic)
#endif

#ifndef FindTag
#define FindTag(tagValue,tagList) FindTagItem(tagValue,tagList)
#endif

#ifndef FreeTagList
#define FreeTagList(tagList) FreeTagItems(tagList)
#endif

#ifndef GetTagItem
#define GetTagItem(tagValue,defaultVal,tagList) GetTagData(tagValue,defaultVal,tagList)
#endif

#ifndef MapTagList
#define MapTagList(tagList,mapList,mapType) MapTags(tagList,mapList,mapType)
#endif

#ifndef NextTag
#define NextTag(tagItemPtr) NextTagItem(tagItemPtr)
#endif

#ifndef PackBooleanTags
#define PackBooleanTags(initialFlags,tagList,boolMap) PackBoolTags(initialFlags,tagList,boolMap)
#endif

#ifndef PackStructTags
#define PackStructTags(pack,packTable,tagList) PackStructureTags(pack,packTable,tagList)
#endif

#ifndef RefreshTagListClones
#define RefreshTagListClones(clone,original) RefreshTagItemClones(clone,original)
#endif

#ifndef TagIsInArray
#define TagIsInArray(tagValue,tagArray) TagInArray(tagValue,tagArray)
#endif

#ifndef UnpackStructTags
#define UnpackStructTags(pack,packTable,tagList) UnpackStructureTags(pack,packTable,tagList)
#endif

/* --- joinOS.library ------------------------------------------------------- */

/* --- an easy to use requester --------------------------------- TextBox.c - */

EXPORT LONG TextBoxA (const char *Caption, const char *TextFormat, UWORD Type, ULONG *Args);

/* --- interface stub ----------------------------------------- JoinOSLib.c - */

LONG TextBox (const char *Caption, const char *TextFormat, UWORD Type, ULONG Arg1,...);

/* --- usefull functions ----------------------------------------- JoinOS.c - */

EXPORT STRPTR TempFileName (STRPTR tempdir, STRPTR prefix, STRPTR extension);
EXPORT BOOL AsyncCopyFile (STRPTR source, STRPTR dest, BOOL fExist);

/* --- 64 bit math functions ----------------------------------- Math64.asm - */

/* These are the C-Language functions for 64bit calculations.
 *
 * If a division by zero occurs, the division functions returns a result with
 * all bits set, the caller of this functions should take care, that such a
 * case never occures, because this result could also be produced by valid
 * divisors (e.g. 0xFFFF FFFF FFFF FFFF / 1)
 *
 * Every function expects a pointer to the DOUBLELONG as argument (a DOUBLELONG
 * is an array of two LONG values, the first LONG gets/holds the upper
 * significant 32 bits, the second LONG gets/holds the lower 32 bits).
 * See <JoinOs/exec/defines.h>
 */

/* Function prototypes of the Math64 functions:
 */
void Mulu64 (ULONG arg1, ULONG arg2, DOUBLELONG *result);
void Muls64 (LONG arg1, LONG arg2, DOUBLELONG *result);
void Divu64 (DOUBLELONG *divident, ULONG divisor);
void Divs64 (DOUBLELONG *divident, LONG divisor);
void Adds64 (DOUBLELONG *arg1, DOUBLELONG *arg2);
void Neg64 (DOUBLELONG *arg);

/* Function prototypes for other math functions:
 */
ULONG Sqrt32 (ULONG value);

#endif		/*_AMIGA */

#endif		/* _JOINOS_PROTOS_H_ */
