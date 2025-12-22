MODULE MCCTime;

(*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCTime.mod 12.5 (18.10.97)
**
*)

  IMPORT
    mb := MuiBasics,
    u  := Utility,
    I  := Intuition,
    y  := SYSTEM;

  CONST
    (*cTime				*= "Time.mcc";*)

    aTimeMidnightSecs			*= 081EE0080H;
    aTimeHour				*= 081EE0081H;
    aTimeMinute				*= 081EE0082H;
    aTimeSecond				*= 081EE0083H;
    aTimeMinHour			*= 081EE0084H;
    aTimeMinMinute			*= 081EE0085H;
    aTimeMinSecond			*= 081EE0086H;
    aTimeMaxHour			*= 081EE0087H;
    aTimeMaxMinute			*= 081EE0088H;
    aTimeMaxSecond			*= 081EE0089H;
    aTimeZoneMinute			*= 081EE008BH;
    aTimeNextDay			*= 081EE008CH;
    aTimePrevDay			*= 081EE008DH;
    aTimeDaylightSaving			*= 081EE008EH;
    aTimeChangeHour			*= 081EE008FH;
    aTimeChangeDay			*= 081EE0095H;


    vTimeChangeDayNormal		*= 0;
    vTimeChangeDayWinterToSummer	*= 1;
    vTimeChangeDaySummerToWinter	*= 2;


    vTimeCompareLess			*= -1;
    vTimeCompareEqual			*=  0;
    vTimeCompareGreater			*=  1;


    mTimeIncrease			*= 081EE0092H;
    mTimeDecrease			*= 081EE0093H;
    mTimeSetCurrent			*= 081EE0094H;
    mTimeCompare			*= 081EE0096H;


  TYPE
    pTimeIncrease *=
      STRUCT
        MethodID	*: LONGINT;
        seconds		*: LONGINT;
      END;
    pTimeDecrease *=
      STRUCT
        MethodID	*: LONGINT;
        seconds		*: LONGINT;
      END;
    pTimeSetCurrent *=
      STRUCT
        MethodID	*: LONGINT;
      END;
    pTimeCompare *=
      STRUCT
        MethodID	*: LONGINT;
        obj		*: I.ObjectPtr;
      END;


  (*PROCEDURE TimeObject *{"Time.TimeObjectA"} (tags{9}..: u.Tag);*)


  (*PROCEDURE TimeObjectA *(tags{9}: u.TagListPtr);

  BEGIN
    mb.NewObjectA(y.ADR(cTime),tags);
  END TimeObjectA;*)

END MCCTime.
