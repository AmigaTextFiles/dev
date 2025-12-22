-> A set of strings holding the date in text format

OPT MODULE,OSVERSION=36

MODULE 'dos/datetime'

/****** datestring.m/--overview-- *******************************************
*
*   PURPOSE
*	To represent a textual form of the current date and time.
*
*   OVERVIEW
*	A  very  simple  object  that  datestamps  itself on creation, and
*	transforms  that  datestamp into a set of three strings, which are
*	accessable as the object attributes 'day', 'date' and 'time'.
*
****************************************************************************
*
*
*/

CONST DATELEN = LEN_DATSTRING+1

EXPORT OBJECT datestring
   day[DATELEN]:ARRAY OF CHAR
  date[DATELEN]:ARRAY OF CHAR
  time[DATELEN]:ARRAY OF CHAR
ENDOBJECT

/****** datestring.m/new *******************************************
*
*   NAME
*	datefield.new() -- Constructor.
*
*   SYNOPSIS
*	new()
*       new(format)
*
*   FUNCTION
*	Initialises an instance of the datestring class.
*
*   INPUTS
*	format - the format the 'date' attribute will take:
*	         format = 0, dd-mmm-yy (12-Feb-92)
*	         format = 1, yy-mm-dd  (92-02-12)
*	         format = 2, mm-dd-yy  (02-12-92)
*	         format = 3, dd-mm-yy  (12-02-92)
*
*	         The default format is 0.
*
*   RESULT
*	The initialised instance now contains three readable attributes:
*	    day  - string representing the name of the day, eg 'Monday'
*	    date - string representing the current date, eg '27-Feb-94'
*	    time - string representing the current time, eg '12:34:56'
*
****************************************************************************
*
*
*/

EXPORT PROC new(format=0) OF datestring
  DEF dt:datetime
  dt.strday  := self.day
  dt.strdate := self.date
  dt.strtime := self.time
  dt.format  := format
  DateStamp(dt)
  DateToStr(dt)
ENDPROC
