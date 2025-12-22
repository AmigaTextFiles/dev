MODULE MCCDate;

(*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCDate.mod 12.2 (22.12.97)
**
*)

  IMPORT
    mb := MuiBasics,
    u  := Utility,
    y  := SYSTEM;


  CONST
    (*cDate			*= "Date.mcc";*)

    aDateDay			*= 081EE0001H;
    aDateMonth			*= 081EE0002H;
    aDateYear			*= 081EE0003H;
    aDateFirstWeekday		*= 081EE0004H;
    aDateLanguage		*= 081EE0007H;
    aDateCountry		*= 081EE0008H;
    aDateCalendar		*= 081EE0035H;
    aDateMinDay			*= 081EE0041H;
    aDateMinMonth		*= 081EE0042H;
    aDateMinYear		*= 081EE0043H;
    aDateMaxDay			*= 081EE0044H;
    aDateMaxMonth		*= 081EE0045H;
    aDateMaxYear		*= 081EE0046H;
    aDateJD			*= 081EE0053H;
    aDateMJD			*= 081EE0054H;
    aDateYDay			*= 081EE0056H;
    aDateWeek			*= 081EE0057H;
    aDateWeekday		*= 081EE0058H;


    mDateSetCurrent		*= 081EE0048H;
    mDateIncreaseDays		*= 081EE0049H;
    mDateDecreaseDays		*= 081EE004AH;
    mDateIncreaseMonths		*= 081EE004BH;
    mDateDecreaseMonths		*= 081EE004CH;
    mDateIncreaseYears		*= 081EE004DH;
    mDateDecreaseYears		*= 081EE004EH;
    mDateIncreaseToWeekday	*= 081EE004FH;
    mDateDecreaseToWeekday	*= 081EE0052H;
    mDateCompare		*= 081EE0055H;


    vDateCountryUnknown		*= 0;
    vDateCountryItalia		*= 1;
    vDateCountryDeutschland	*= 2;
    vDateCountrySchweiz		*= 3;
    vDateCountryDanmark		*= 4;
    vDateCountryNederland	*= 5;
    vDateCountryGreatBritain	*= 6;

    vDateCalendarJulian		*= 0;
    vDateCalendarGregorian	*= 1;
    vDateCalendarHeis		*= 2;

    vDateWeekdayMonday		*= 1;
    vDateWeekdayTuesday		*= 2;
    vDateWeekdayWednesday	*= 3;
    vDateWeekdayThursday	*= 4;
    vDateWeekdayFriday		*= 5;
    vDateWeekdaySaturday	*= 6;
    vDateWeekdaySunday		*= 7;

    vDateLangLocale		*= 0;
    vDateLangEnglish		*= 1;
    vDateLangDeutsch		*= 2;
    vDateLangFrancais		*= 3;
    vDateLangEspanol		*= 4;
    vDateLangPortugues		*= 5;
    vDateLangDansk		*= 6;
    vDateLangItaliano		*= 7;
    vDateLangNederlands		*= 8;
    vDateLangNorsk		*= 9;
    vDateLangSvenska		*= 10;
    vDateLangPolski		*= 11;
    vDateLangSuomi		*= 12;
    vDateLangMagyar		*= 13;
    vDateLangGreek		*= 14;
    vDateLangEsperanto		*= 15;
    vDateLangLatina		*= 16;
    vDateLangRussian		*= 17;
    vDateLangCzech		*= 18;
    vDateLangCatalonian		*= 19;

    vDateCompareLess		*= -1;
    vDateCompareEqual		*=  0;
    vDateCompareGreater		*=  1;


  TYPE
    pDateSetCurrent *=
      STRUCT
        MethodID	*: LONGINT;
      END;

    pDateIncreaseDays *=
      STRUCT
        MethodID	*: LONGINT;
        days		*: LONGINT;
      END;

    pDateDecreaseDays *=
      STRUCT
        MethodID	*: LONGINT;
        days		*: LONGINT;
      END;

    pDateIncreaseMonths *=
      STRUCT
        MethodID	*: LONGINT;
        months		*: LONGINT;
      END;

    pDateDecreaseMonths *=
      STRUCT
        MethodID	*: LONGINT;
        months		*: LONGINT;
      END;

    pDateIncreaseYears *=
      STRUCT
        MethodID	*: LONGINT;
        years		*: LONGINT;
      END;

    pDateDecreaseYears *=
      STRUCT
        MethodID	*: LONGINT;
        years		*: LONGINT;
      END;

    pDateIncreaseToWeekday *=
      STRUCT
        MethodID	*: LONGINT;
        weekday		*: LONGINT;
      END;

    pDateDecreaseToWeekday *=
      STRUCT
        MethodID	*: LONGINT;
        weekday		*: LONGINT;
      END;

    pDateCompare *=
      STRUCT
        MethodID	*: LONGINT;
        obj		*: I.ObjectPtr;
      END;


  (*PROCEDURE DateObject *{"Date.DateObjectA"} (tags{9}..: u.Tag);*)


  (*PROCEDURE DateObjectA *(tags{9}: u.TagListPtr);

  BEGIN
    mb.NewObjectA(y.ADR(cDate),tags);
  END DateObjectA;*)

END MCCDate.
