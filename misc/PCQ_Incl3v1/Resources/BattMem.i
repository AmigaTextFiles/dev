
CONST
 BATTMEMNAME   =  "battmem.resource";

PROCEDURE ObtainBattSemaphore;
    External;

PROCEDURE ReleaseBattSemaphore;
    External;

FUNCTION ReadBattMem(Buffer : Address; offset, length : Integer) : Integer;
    External;

FUNCTION WriteBattMem(Buffer : Address; offset, length : Integer) : Integer;
    External;


