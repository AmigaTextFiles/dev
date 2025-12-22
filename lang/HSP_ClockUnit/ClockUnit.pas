{****************************************************************}
{ ClockUnit                                                      }
{                                                                }
{ By Hans Luyten , Using HighSpeed Pascal 1.10 with OS2.0 Units. }
{ A small demo on how to read the clock using OS2.x and higher.  }
{ Uses Utility.library and Battclock.resource !!                 }
{ NOTE: This will NOT work on systems with <OS2.0 !!             }
{****************************************************************}
Unit ClockUnit;

INTERFACE

Uses Exec, Utility, BattClock;
  
VAR
  Current  : pClockData;      { Need this for clock data -> Utility unit }

FUNCTION GetTimeDate(VAR Hour,Min,Sec,Day,Month,Year:Word; 
                      VAR WDay:string):BOOLEAN;
                      
IMPLEMENTATION

FUNCTION GetTimeDate(VAR Hour,Min,Sec,Day,Month,Year:Word; 
                      VAR WDay:string):BOOLEAN;
BEGIN
  UtilityBase:=OpenLibrary('utility.library',36); { Open utility.library }
  BattClockBase:=OpenResource(BATTCLOCKNAME);     { Open resource        }

  IF (BattClockBase<>NIL)AND(UtilityBase<>NIL) THEN  { All opened ??     }
    BEGIN
    
      NEW(Current);                      { Allocate memory for ClockData }
      Amiga2Date(ReadBattClock,Current); { Convert AmigaData->NormalDate }
      
      Hour:=Current^.hour;
      Min:=Current^.min;
      Sec:=Current^.sec;
      Day:=Current^.mday;
      Month:=Current^.month;
      Year:=Current^.year;
      CASE Current^.wday OF
        1: WDay:='Monday';               { Current^.wday=1 }
        2: WDay:='Tuesday';              { Current^.wday=2 }
        3: WDay:='Wednesday';            { Current^.wday=3 }
        4: WDay:='Thursday';             { Current^.wday=4 }
        5: WDay:='Friday';               { Current^.wday=5 }
        6: WDay:='Saturday';             { Current^.wday=6 }
        7: WDay:='Sunday';               { Current^.wday=7 }
      END;
      
      CloseLibrary(UtilityBase);         { Close utility.library         }
      GetTimeDate:=TRUE;
    END
  ELSE
    GetTimeDate:=FALSE;
END;

BEGIN
END.
