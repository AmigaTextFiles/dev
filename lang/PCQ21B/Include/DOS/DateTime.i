{ DateTime.i }

{$I   "Include:DOS/DOS.i"}

{
 *      Data structures and equates used by the V1.4 DOS functions
 * StrtoDate() and DatetoStr()
 }

{--------- String/Date structures etc }
Type
       DateTime = Record
        dat_Stamp : DateStampRec;      { DOS DateStamp }
        dat_Format,                    { controls appearance of dat_StrDate }
        dat_Flags : Byte;              { see BITDEF's below }
        dat_StrDay,                    { day of the week string }
        dat_StrDate,                   { date string }
        dat_StrTime : String;          { time string }
       END;
       DateTimePtr = ^DateTime;

{ You need this much room for each of the DateTime strings: }
CONST
 LEN_DATSTRING =  16;

{      flags for dat_Flags }

 DTB_SUBST      = 0;               { substitute Today, Tomorrow, etc. }
 DTF_SUBST      = 1;
 DTB_FUTURE     = 1;               { day of the week is in future }
 DTF_FUTURE     = 2;

{
 *      date format values
 }

 FORMAT_DOS     = 0;               { dd-mmm-yy }
 FORMAT_INT     = 1;               { yy-mm-dd  }
 FORMAT_USA     = 2;               { mm-dd-yy  }
 FORMAT_CDN     = 3;               { dd-mm-yy  }
 FORMAT_MAX     = FORMAT_CDN;

function DateToStr(DT : DateTimePtr) : Boolean;
    External;

FUNCTION StrToDate(DT : DateTimePtr) : Boolean;
    External;

