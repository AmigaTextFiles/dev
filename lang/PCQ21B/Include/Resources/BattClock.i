
CONST
  BATTCLOCKNAME =  "battclock.resource";

PROCEDURE ResetBattClock;
    External;

FUNCTION ReadBattClock : Integer;
    External;

PROCEDURE WriteBattClock(Time : Integer);
    External;


