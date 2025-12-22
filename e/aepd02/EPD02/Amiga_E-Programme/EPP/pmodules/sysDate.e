/* NOTE:  sd_init () is called automatically. */

/* Holds a julian date.  These are easiest to perform calculations with. */
OBJECT sd_julianDateType
  year, day
ENDOBJECT


DEF sd_month_BeginDay = NIL,  /* Day of year that month starts on. */
    sd_monthName [12] : ARRAY OF LONG  /* String values for months.       */


PROC sd_isLeapYear (year) RETURN (Mod (year, 4) = 0)


PROC sd_init ()
  sd_month_BeginDay := [  1,  32,  60,  91, 121, 152,
                        182, 213, 244, 274, 305, 335]
  sd_monthName [ 0] := 'January'
  sd_monthName [ 1] := 'February'
  sd_monthName [ 2] := 'March'
  sd_monthName [ 3] := 'April'
  sd_monthName [ 4] := 'May'
  sd_monthName [ 5] := 'June'
  sd_monthName [ 6] := 'July'
  sd_monthName [ 7] := 'August'
  sd_monthName [ 8] := 'September'
  sd_monthName [ 9] := 'October'
  sd_monthName [10] := 'November'
  sd_monthName [11] := 'December'
ENDPROC
  /* sd_init */


PROC sd_monthFrom (julianDate : PTR TO sd_julianDateType)
  DEF day, m
  IF sd_month_BeginDay = NIL THEN sd_init ()
  day := julianDate.day
  IF day < Long (sd_month_BeginDay + 4) THEN RETURN 1
  IF sd_isLeapYear (julianDate.year) THEN DEC day
  FOR m := 2 TO 11
    IF day < Long (sd_month_BeginDay + (Mul (m, 4))) THEN RETURN m
  ENDFOR
ENDPROC  m
  /* sd_monthFrom */

PROC sd_monthNameFor (monthNumber) RETURN sd_monthName [monthNumber - 1]
  /* Month number must be 1-12.  Can be gotten via sd_monthFrom(). */


PROC sd_dayOfMonthFrom (julianDate : PTR TO sd_julianDateType)
  /* Variables used here for readability. */
  DEF today, month, month_BeginDay, leapYearAdjustment = 0
  today := julianDate.day
  month := sd_monthFrom (julianDate)
  month_BeginDay := Long (sd_month_BeginDay + Mul ((month-1), 4))
  IF (sd_isLeapYear (julianDate.year)) AND (month > 2) THEN DEC leapYearAdjustment
  RETURN (today - month_BeginDay + 1 + leapYearAdjustment)
ENDPROC
  /* sd_dayOfMonthFrom */

PROC sd_add (julianDate : PTR TO sd_julianDateType,
             numberOfDays)
  /* Add any number of days (within reason) to a julian date. Returns the */
  /* computed julian date.  The parameter julianDate is unmodified.       */
  DEF computedJulianDate : sd_julianDateType,
      newNumberOfDays
  IF sd_month_BeginDay = NIL THEN sd_init ()
  IF ((sd_isLeapYear (julianDate.year) = FALSE) AND
      (julianDate.day + numberOfDays <= 365)) OR
     ((sd_isLeapYear (julianDate.year)) AND
      (julianDate.day + numberOfDays <= 365))
    computedJulianDate.year := julianDate.year
    computedJulianDate.day := julianDate.day + numberOfDays
  ELSE
    computedJulianDate.year := julianDate.year + 1
    computedJulianDate.day := 1;
    IF sd_isLeapYear (julianDate.year) = FALSE
      newNumberOfDays := numberOfDays - (365 - julianDate.day + 1)
    ELSE
      newNumberOfDays := numberOfDays - (366 - julianDate.day + 1)
    ENDIF
    RETURN sd_add (computedJulianDate, newNumberOfDays)
  ENDIF
ENDPROC  computedJulianDate
  /* sd_add */


PROC sd_getCurrentDate (julianDate : PTR TO sd_julianDateType)
/* Parameter julianDate must not be NIL! */
  DEF ds : datestamp,
      baseDate : sd_julianDateType,
      currentDate : PTR TO sd_julianDateType
  VOID DateStamp (ds)
  baseDate.year := 1978  /* All dates are derived from this year. */
  baseDate.day := 1      /* 1 January (julian format).            */
  currentDate := sd_add (baseDate, ds.days)
  julianDate.year := currentDate.year
  julianDate.day := currentDate.day
ENDPROC  julianDate
  /* sd_getCurrentDate */

