{**********************************************************************}
{ ClockDemo                                                            }
{                                                                      }
{ Demonstrates the use of 'Clockunit'                                  }
{**********************************************************************}
PROGRAM ClockDemo;

Uses ClockUnit;

VAR
  Hour,Min,Sec   : Word;
  Day,Month,Year : Word;
  WDay           : String;

BEGIN
  IF GetTimeDate(Hour,Min,Sec,Day,Month,Year,WDay) THEN
    BEGIN
      Writeln('Current time : ',Hour,':',Min,':',Sec);
      Writeln('Current date : ',Day,'-',Month,'-',Year);
      Writeln('Todays is ',WDay);
    END;
END.
  