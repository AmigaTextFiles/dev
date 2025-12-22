/* $Id: record.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/dos/dos'
MODULE 'target/exec/types'
{#include <dos/record.h>}
NATIVE {DOS_RECORD_H} CONST

/* LockRecord() and LockRecords() locking modes. EXCLUSIVE modes mean that
   nobody else is allowed to lock a specific record, which is allowed, when
   locking with SHARED mode. When using IMMED modes, the timeout is ignored. */
NATIVE {REC_EXCLUSIVE}       CONST REC_EXCLUSIVE       = 0
NATIVE {REC_EXCLUSIVE_IMMED} CONST REC_EXCLUSIVE_IMMED = 1
NATIVE {REC_SHARED}          CONST REC_SHARED          = 2
NATIVE {REC_SHARED_IMMED}    CONST REC_SHARED_IMMED    = 3


/* Structure as passed to LockRecords() and UnLockRecords(). */
NATIVE {RecordLock} OBJECT recordlock
    {rec_FH}	fh	:BPTR     /* (struct FileHandle *) The file to get the current
                         record from. */
    {rec_Offset}	offset	:ULONG /* The offset, the current record should start. */
    {rec_Length}	length	:ULONG /* The length of the current record. */
    {rec_Mode}	mode	:ULONG   /* The mode od locking (see above). */
ENDOBJECT
