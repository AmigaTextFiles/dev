OPT TURBO

/*---------------------------------------------------------------------*/
/* Module systemTimeStr() function.  This is necessary for KS1.3 users */
/* since we can't use the utilities.library, nor the DatetoStr()       */
/* function of the newer OS.                                           */
/*---------------------------------------------------------------------*/

MODULE 'dos/datetime', 'dos/dos'
PMODULE 'PMODULES:itoa'

PROC buildTimeStr (theString, hour, minute, second)
  DEF tempStr [2] : STRING
  SetStr (theString, 0)
  VOID itoa (tempStr, hour)
  IF hour < 10 THEN StrAdd (theString, '0', ALL)
  StrAdd (theString, tempStr, ALL)
  StrAdd (theString, ':', ALL)

  VOID itoa (tempStr, minute)
  IF minute < 10 THEN StrAdd (theString, '0', ALL)
  StrAdd (theString, tempStr, ALL)
  StrAdd (theString, ':', ALL)

  VOID itoa (tempStr, second)
  IF second < 10 THEN StrAdd (theString, '0', ALL)
  StrAdd (theString, tempStr, ALL)
ENDPROC  theString
  /* buildTimeStr */


PROC systemTimeStr (theString)
  DEF ds : PTR TO datestamp,
      hour, minute, second
  ds := DateStamp (New (SIZEOF datestamp))
  hour := ds.minute / 60
  minute := ds.minute - (hour * 60)
  second := ds.tick / 50
  Dispose (ds)
ENDPROC  buildTimeStr (theString, hour, minute, second)
  /* systemTimeStr */

