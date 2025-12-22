include "inc/dos/dos.inc";

def REC_EXCLUSIVE = 0;
def REC_EXCLUSIVE_IMMED = 1;
def REC_SHARED = 2;
def REC_SHARED_IMMED = 3;

struct RecordLock is
  rec_FH:long;
  rec_Offset:ulong;
  rec_Length:ulong;
  rec_Mode:ulong;
;

