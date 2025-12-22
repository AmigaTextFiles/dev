{ Date.i }

{$I   "Include:Exec/Types.i"}

Type
      ClockData = Record
        sec,
        min,
        hour,
        mday,
        month,
        year,
        wday : Word;
      END;
      ClockDataPtr = ^ClockData;


PROCEDURE Amiga2Date(AmigaTime : Integer; Date : ClockDataPtr);
    External;

FUNCTION CheckDate(date : ClockDataPtr) : Integer;
    External;

FUNCTION Date2Amiga(Date : ClockDataPtr) : Integer;
    External;


