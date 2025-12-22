
{$I   "Include:DOS/DOS.i"}

CONST
{     Modes for LockRecord/LockRecords() }
       REC_EXCLUSIVE          = 0;
       REC_EXCLUSIVE_IMMED    = 1;
       REC_SHARED             = 2;
       REC_SHARED_IMMED       = 3;

{     struct to be passed to LockRecords()/UnLockRecords() }

Type
       RecordLock = Record
        rec_FH    : BPTR;         {     filehandle }
        rec_Offset,               {     offset in file }
        rec_Length,               {     length of file to be locked }
        rec_Mode  : Integer;      {     Type of lock }
       END;
       RecordLockPtr = ^RecordLock;


FUNCTION LockRecord(Datei : FileHandle; offset, num, mode, timeout : Integer) : Boolean;
    External;

FUNCTION LockRecords(RL : RecordLockPtr; timeout : Integer) : Boolean;
    External;

FUNCTION UnLockRecord(datei : FileHandle; offset, num : Integer) : Boolean;
    External;

FUNCTION UnLockRecords(RL : RecordLockPtr) : Boolean;
    External;

