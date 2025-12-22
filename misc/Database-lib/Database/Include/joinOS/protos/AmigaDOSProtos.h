#ifndef _AMIGA_DOS_PROTOS_H_
#define _AMIGA_DOS_PROTOS_H_ 1

/* AmigaDOSProtos.h
 *
 * -------------------------------------------------------------------------- *
 *			Prototypes for routines of AmigaDOS (subset of commands)					*
 * -------------------------------------------------------------------------- *
 */

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

#ifdef _AMIGA

#ifndef PROTO_DOS_H
#include <proto/dos.h>
#endif

/* Function definition for filedeletion.
 * Should be used, cause of a nameconflict with Windoof function
 */
#define FileDelete(file) DeleteFile(file)

#else		/* _AMIGA */

#ifndef EXPORT
#define EXPORT __declspec(dllimport)
#endif

#ifndef _TAGITEMS_H_
#include <joinOS/misc/TagItems.h>
#endif

extern struct DosLibrary *DOSBase;

/* Private functions, only for reference, don't call direct
 *
 *	void _SYSTIME2DateStamp (SYSTEMTIME *st, struct DateStamp *ds);"DOSDate.c"
 * void _DateStamp2SYSTIME (struct DateStamp *ds, SYSTEMTIME *st);"DOSDate.c"
 * void _FILETIME2DateStamp (FILETIME *ft, struct DateStamp *ds); "DOSDate.c"
 * void _DateStamp2FILETIME (struct DateStamp *ds, FILETIME *ft); "DOSDate.c"
 *
 * BOOL _AskVolume (struct FileLock *fl); 	"DOSLock.c"
 * BOOL _GetVolume (struct FileLock *fl); 	"DOSLock.c"
 * BPTR _Lock (char *Path, LONG AccessMode); "DOSLock.c"
 * void _UnLock (BPTR Filelock);					"DOSLock.c"
 *
 * BOOL _MountAssigns (void);				"DOSList.c"
 * BOOL _MountVolumes (void);				"DOSList.c"
 * BOOL _MountDevices (void);				"DOSList.c"
 *
 * BOOL _RetryIOError (BPTR fh, BOOL read);	"DOSError.c"
 */

/* --- DOS-Memory functions - DOSMemory.c ----------------------------------- */

EXPORT void *AllocDosObject (ULONG Type, struct TagItem *Tags);
EXPORT void FreeDosObject(ULONG Type, void *Object);

/* --- Functions for the DosList - DOSList.c -------------------------------- */

EXPORT struct DosList *AttemptLockDosList (ULONG AccessFlags);
EXPORT struct DosList *LockDosList (ULONG AccessFlags);
EXPORT void UnLockDosList (ULONG AccessFlags);
EXPORT struct DosList *MakeDosEntry (const char *Name, LONG Type);
EXPORT void FreeDosEntry(struct DosList *dol);
EXPORT LONG AddDosEntry(struct DosList *dol);
EXPORT LONG RemDosEntry (struct DosList *dolRemove);
EXPORT struct DosList *FindDosEntry(struct DosList *Previous, const char *Name,
												ULONG AccessFlags);
EXPORT struct DosList *NextDosEntry(struct DosList *Previous, ULONG AccessFlags);

EXPORT BOOL AssignAdd (STRPTR name, BPTR fl);
EXPORT BOOL AssignLate (STRPTR name, STRPTR path);
EXPORT BOOL AssignLock (STRPTR name, BPTR fl);
EXPORT BOOL AssignPath (STRPTR name, STRPTR path);
EXPORT BOOL RemAssignList (STRPTR name, BPTR fl);

/* --- Functions directly accessing handlers - DOSHandlerIO.c --------------- */

/* --- Accessing/manipulating volumes --- */

EXPORT LONG Relabel(STRPTR oldName, STRPTR newName);
EXPORT LONG Info(BPTR FileLock, struct InfoData *InfoData);

/* --- Accessing/examining filesystem objects --- */

EXPORT BPTR Lock (STRPTR name, LONG accessMode);
EXPORT void UnLock (BPTR FileLock);
EXPORT LONG ChangeMode (ULONG Type, BPTR Object, LONG NewMode);
EXPORT BPTR CreateDir (STRPTR path);
EXPORT BPTR ParentDir (BPTR FileLock);
EXPORT LONG NameFromLock (BPTR FileLock, UBYTE *Buffer, ULONG BufSize);
EXPORT LONG SameLock (BPTR fl1, BPTR fl2);
EXPORT BPTR DupLock(BPTR FileLock);
EXPORT LONG Examine (BPTR FileLock, struct FileInfoBlock *fib);
EXPORT LONG ExNext (BPTR FileLock, struct FileInfoBlock *fib);
EXPORT LONG ExAll (BPTR FileLock, struct ExAllData *Buffer, ULONG BufSize,
		ULONG Type, struct ExAllControl *ExAllControl);
EXPORT void ExAllEnd (BPTR FileLock, struct ExAllData *Buffer, ULONG BufSize,
		ULONG Type, struct ExAllControl *ExAllControl);

/* --- Manipulating filesystem objects --- */

EXPORT BPTR Open (STRPTR name, long accessMode);
EXPORT BPTR OpenFromLock (BPTR FileLock);
EXPORT LONG Close (BPTR file);
EXPORT LONG IsInteractive(BPTR FileHandle);
EXPORT BPTR ParentOfFH (BPTR FileHandle);
EXPORT LONG NameFromFH (BPTR FileHandle, UBYTE *Buffer, ULONG BufSize);
EXPORT BPTR DupLockFromFH (BPTR FileHandle);
EXPORT LONG ExamineFH (BPTR FileHandle, struct FileInfoBlock *fib);

EXPORT LONG SetFileSize (BPTR file, LONG size, LONG offset);
EXPORT LONG Seek (BPTR file, LONG position, LONG offset);
/* LONG DeleteFile (STRPTR name);			AmigaOS */
/* BOOL DeleteFile (LPCTSTR lpFileName);	Windoof */
EXPORT LONG Delete (STRPTR name);
EXPORT LONG Rename (STRPTR oldName, STRPTR newName);
EXPORT LONG SetComment (STRPTR file, STRPTR comment);
EXPORT LONG SetFileDate (STRPTR file, struct DateStamp *ds);
EXPORT LONG SetProtection (STRPTR file, ULONG protection);


/* --- Packet-I/O - DOSPacket.c --------------------------------------------- */

EXPORT struct DevProc *GetDeviceProc (STRPTR name, struct DevProc *prev);
EXPORT void FreeDeviceProc (struct DevProc *dvp);
EXPORT void AbortPkt (struct MsgPort *mp, struct DosPacket *dp);
EXPORT LONG DoPkt (struct MsgPort *mp, LONG type, LONG arg1, LONG arg2,
													LONG arg3, LONG arg4, LONG arg5);
EXPORT void SendPkt (struct DosPacket *dp, struct MsgPort *mp,
														 struct MsgPort *rp);
EXPORT void ReplyPkt (struct DosPacket *dp, LONG res1, LONG res2);
EXPORT struct DosPacket *WaitPkt (void);

/* --- manipulating the DOS resident list - DOSBase.c ----------------------- */

EXPORT BOOL AddSegment (STRPTR name, BPTR segList, LONG type);
EXPORT struct Segment *FindSegment (STRPTR name, struct Segment *start, LONG system);
EXPORT BOOL RemSegment (struct Segment *segment);

/* --- Creating new AmigaDos process's - DOSBase.c (DOSProcess.c) ----------- */

EXPORT BPTR LoadSeg (STRPTR file);
EXPORT BOOL UnLoadSeg (BPTR segList);
EXPORT struct Process *CreateNewProc (struct TagItem *tagList);
EXPORT struct MsgPort *CreateProc (STRPTR name, LONG priority,
												BPTR segList, LONG stackSize);
EXPORT void Exit (LONG returnValue);

/* --- manipulating cli-process entries - DOSBase.c ------------------------- */

EXPORT struct Process *FindCliProc (ULONG prNum);
EXPORT ULONG MaxCli (void);

/* --- manipulating Process information - DOSBase.c (DOSProcess.c) ---------- */

EXPORT ULONG CheckSignal (ULONG signals);
EXPORT struct CommandLineInterface *Cli (void);
EXPORT BPTR CurrentDir (BPTR newCurrent);
EXPORT BPTR Input (void);
EXPORT BPTR Output(void);
EXPORT STRPTR GetArgStr (void);
EXPORT BOOL GetPrompt(STRPTR buffer, ULONG bufSize);
EXPORT BPTR GetProgramDir(void);
EXPORT BOOL GetProgramName(STRPTR buffer, ULONG bufSize);
EXPORT BOOL GetCurrentDirName(STRPTR buffer, ULONG bufSize);
EXPORT struct MsgPort *GetConsoleTask (void);
EXPORT struct MsgPort *GetFileSysTask (void);
EXPORT BPTR SelectInput (BPTR newInput);
EXPORT BPTR SelectOutput (BPTR newOutput);
EXPORT STRPTR SetArgStr (STRPTR newArgStr);
EXPORT BPTR SetProgramDir(BPTR newDir);
EXPORT BOOL SetProgramName(STRPTR newName);
EXPORT BOOL SetCurrentDirName(STRPTR path);
EXPORT struct MsgPort *SetConsoleTask (struct MsgPort *newPort);
EXPORT struct MsgPort *SetFileSysTask (struct MsgPort *newPort);
EXPORT BOOL SetPrompt(STRPTR prompt);

/* --- Environment variable handling - DOSVars.c ---------------------------- */

EXPORT BOOL DeleteVar (STRPTR name, ULONG flags);
EXPORT struct LocalVar *FindVar (STRPTR name, ULONG type);
EXPORT LONG GetVar (STRPTR name, STRPTR buffer, LONG size, ULONG flags);
EXPORT BOOL SetVar (STRPTR name, STRPTR value, LONG length, ULONG flags);

/* --- Path parsing functions - DOSFiles.c ---------------------------------- */

EXPORT BOOL AddPart (STRPTR FirstPart, STRPTR NextPart, ULONG BufSize);
EXPORT STRPTR PathPart (STRPTR Path);
EXPORT STRPTR FilePart (STRPTR Path);
EXPORT SWORD SplitName (STRPTR FullPath, UBYTE Separator, STRPTR Buffer,
															UWORD Index, ULONG BufSize);

/* --- Functions that still needs to be implemented ------------------------- */

/* LockRecord() 	LockFileEx() */
/* UnLockRecord() UnLockFileEx() */

/* --- Functions for date and time - DOSDate.c ------------------------------ */

EXPORT LONG CompareDates(const struct DateStamp *First, const struct DateStamp *Second);
EXPORT struct DateStamp *DateStamp (struct DateStamp *DateStamp);
EXPORT BOOL DateToStr (struct DateTime *DateTime);
EXPORT BOOL StrToDate (struct DateTime *DateTime);
EXPORT LONG StrToLong (STRPTR String, LONG *Value);
EXPORT void Delay (LONG ticks);

/* --- Unbuffered file I/O - DOSFileIO.c ------------------------------------ */

EXPORT LONG Read (BPTR file, APTR buffer, long length);
EXPORT LONG Write (BPTR file, APTR buffer, long length);

/* --- Buffered file I/O - DOSFileIO.c -------------------------------------- */

EXPORT LONG FGetC (BPTR FileHandle);
EXPORT char *FGets (BPTR FileHandle, char *Buffer, ULONG BufSize);
EXPORT ULONG FRead (BPTR FileHandle, void *Buffer, ULONG BlockSize, ULONG NoOfBlocks);
EXPORT LONG FPutC (BPTR FileHandle, ULONG Character);
EXPORT LONG FPuts (BPTR FileHandle, const char *String);
EXPORT ULONG FWrite (BPTR FileHandle, const void *Buffer, ULONG BlockSize, ULONG NoOfBlocks);
EXPORT LONG VFPrintf (BPTR FileHandle, STRPTR FormatString, LONG* Args);
EXPORT LONG FPrintf (BPTR FileHandle, STRPTR FormatString, ...);
EXPORT LONG VPrintf (STRPTR FormatString, LONG* Args);
EXPORT LONG Printf (STRPTR FormatString, ...);
/* void VFWritef (BPTR FileHandle, const char* FormatString, const LONG *valist); */
EXPORT LONG Flush(BPTR file);
EXPORT LONG SetVBuf (BPTR FileHandle, STRPTR Buffer, LONG BufSize, LONG BufMode);
EXPORT LONG PutStr (STRPTR String);
EXPORT LONG WriteChars (STRPTR Buffer, ULONG BufSize);
EXPORT LONG UnGetC (BPTR FileHandle, LONG Character);

/* --- ANSI-C-like IO-Operations (inefficient) ------------------------------ */

#define ReadChar()		FGetC(Input())
#define WriteChar(c)		FPutC(Output(),(c))
#define UnReadChar(c)		UnGetC(Input(),(c))
/* next one is very inefficient */
#define ReadChars(buf,num)	FRead(Input(),(buf),1,(num))
#define ReadLn(buf,len)		FGets(Input(),(buf),(len))
#define WriteStr(s)		FPuts(Output(),(s))
#define VWritef(format,argv)	VFWritef(Output(),(format),(argv))

/* --- special functions -------------------------- AmigaDOS.c -------------- */

EXPORT LONG WaitForChar(BPTR FileHandle, ULONG WaitTime);

/* --- Error handling functions - DOSError.c -------------------------------- */

EXPORT LONG IoErr(void);
EXPORT LONG SetIoErr (LONG);
EXPORT LONG ErrorReport (LONG,ULONG,ULONG,struct MsgPort *);
EXPORT LONG Fault (LONG, STRPTR, STRPTR, LONG);
EXPORT LONG PrintFault (LONG ErrorCode, STRPTR Text);

#define IsAmigaDosError(ec) ((ec & AMIGA_ERROR)||(ec==ERROR_DISK_FULL)||(ec==ERROR_BUFFER_OVERFLOW))
/* FUNCTION
 *		This macro checks, wheather a given error number is an AmigaDOS error
 *		code or a system dependent (Windoof) error code.
 *		This macro is usefull to determine, if the occured error is an error
 *		that could be handled by an application. Every system dependent error
 *		that is expected by the AmigaDOS library, is converted to an AmigaDOS
 *		error code, so you are able to write system independent error-handling
 *		function.
 *		If this function returns FALSE, the occured error hasn't been expected
 *		by the AmigaDOS library and therefor you could be shure, it's a hard
 *		error that could be displayed to the user, but not be handled without
 *		the users choise.
 *
 * INPUT
 *		ec - an error number as returned by Ioerr()
 *
 *	RESULT
 *		TRUE -> if the error number belongs to an AmigaDOS error code.
 *		FALSE -> if the error number belongs to a system (Windoof) specific
 *		error code.
 */

/* --- Argument parsing functions - RDArgs.c -------------------------------- */

EXPORT void FreeArgs (struct RDArgs* rdArgs);
EXPORT struct RDArgs *ReadArgs ( STRPTR template, LONG *array,
											struct RDArgs *rdArgs);
EXPORT LONG FindArg (STRPTR template, STRPTR keyword);
EXPORT LONG ReadItem (UBYTE *buffer, ULONG bufSize, struct CSource *source);

/* --- Pattern parsing functions - MatchPattern.c --------------------------- */

EXPORT LONG ParsePattern (const UBYTE *rawPattern, UBYTE *tokenBuffer, ULONG bufSize);
EXPORT LONG ParsePatternNoCase ( const UBYTE *rawPattern, UBYTE *tokenBuffer,
											ULONG bufSize);

/* --- Pattern matching functions - MatchPattern.c -------------------------- */

EXPORT BOOL MatchPattern (UBYTE *Pattern, const UBYTE *TokenString);
EXPORT BOOL MatchPatternNoCase (UBYTE *Pattern, const UBYTE *TokenString);

/* --- Filesystem objects locating functions - MatchPattern.c --------------- */

EXPORT LONG MatchFirst (STRPTR pattern, struct AnchorPath *anchor);
EXPORT LONG MatchNext (struct AnchorPath *anchor);
EXPORT void MatchEnd (struct AnchorPath *anchor);

/* --- Functions new for every system - DOSDate.c --------------------------- */

EXPORT LONG LongToStr (LONG Value, char* Buffer);					/* DOSDate.c */

#endif		/* _AMIGA */


/* --- Makros new for every system ------------------------------------------ */

/* NAME
 *		DayOfWeek - return a number representing the weekday
 *
 * SYNOPSIS
 *		week = DayOfWeek (days_passed);
 *		ULONG DayOfWeek (ULONG);
 *
 * FUNCTION
 * 	This function returns the no. of the weekday (0 = sunday, 1 = monday ...)
 * 	for a specified day.
 *
 *	INPUT
 *		days - number of days passed since 01.01.1978.
 *
 * RESULT
 *		The number of the weekday (0 - 6).
 */
#define DayOfWeek(days) ((days) % 7)

/* NAME
 *		IsValidDate - Check if a DateStamp contains a valid date.
 *
 * SYNOPSIS
 *		success IsValidDate (ds)
 *		BOOL IsValidDate(struct DateStamp *)
 *
 * FUNCTION
 *		Test whether a given DateStamp structure holds a valid date or not.
 *		It is only testet if every value of the structure is greater or equal to
 *		null and that at least one value is greater then null.
 *
 * INPUT
 *		ds - a pointer to the DateStamp structure which contents should be testet
 *
 * RESULT
 *		boolean, TRUE if the structure contains a valid date, FALSE if not.
 */
#define IsValidDate(ds) (((ds)->ds_Days >= 0) && ((ds)->ds_Minute >= 0) && ((ds)->ds_Tick >= 0) && ((ds)->ds_Days || (ds)->ds_Minute || (ds)->ds_Tick))


#ifdef _AMIGA


/* On Amiga systems every error number is an Amiga error number ;-)
 */
#define IsAmigaDosError(ec) (TRUE)

/* alias, needed because of name-conflict with Windoof-function
 */
#define Delete(file) DeleteFile(file)


#endif		/* _AMIGA */

#endif 		/*  _AMIGA_DOS_PROTOS_H_ */
