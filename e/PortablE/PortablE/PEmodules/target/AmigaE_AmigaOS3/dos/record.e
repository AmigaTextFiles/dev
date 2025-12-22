/* $VER: record.h 36.5 (12.7.1990) */
OPT NATIVE
MODULE 'target/dos/dos_shared'
MODULE 'target/exec/types', 'target/dos/dos'
{MODULE 'dos/record'}

/* Modes for LockRecord/LockRecords() */
NATIVE {REC_EXCLUSIVE}		CONST REC_EXCLUSIVE		= 0
NATIVE {REC_EXCLUSIVE_IMMED}	CONST REC_EXCLUSIVE_IMMED	= 1
NATIVE {REC_SHARED}		CONST REC_SHARED		= 2
NATIVE {REC_SHARED_IMMED}	CONST REC_SHARED_IMMED	= 3

/* struct to be passed to LockRecords()/UnLockRecords() */

NATIVE {recordlock} OBJECT recordlock
	{fh}	fh	:BPTR		/* filehandle */
	{offset}	offset	:ULONG	/* offset in file */
	{length}	length	:ULONG	/* length of file to be locked */
	{mode}	mode	:ULONG	/* Type of lock */
ENDOBJECT
