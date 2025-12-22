MODULE 'dos/dos'
PMODULE 'PMODULES:sysDate'

PROC main ()
  DEF currentDate : sd_julianDateType

  sd_getCurrentDate (currentDate)

/*---  Test current date.  -----------------------------------------------*/

  WriteF ('\n*** Current date:')

  WriteF ('\nThe Julian date is day \d of year \d.',
          currentDate.day, currentDate.year)

  WriteF ('\nThe Gregorian date is \d/\d/\d',
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  WriteF ('\nThe Alphanumeric date is \s \d, \d',
          sd_monthNameFor (sd_monthFrom (currentDate)),
          sd_dayOfMonthFrom (currentDate),
          currentDate.year)

/*---  Test a leap year.  ------------------------------------------------*/

  WriteF ('\n\n*** Leap year:')
  currentDate.year := 1992

  currentDate.day := 1
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 32
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 60
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 61
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 366
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

/*---  Test a non-leap year.  --------------------------------------------*/

  WriteF ('\n\n*** Non-leap year:')
  currentDate.year := 1993

  currentDate.day := 1
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 32
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 60
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 61
  WriteF ('\n\d \d = \d/\d/\d',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

  currentDate.day := 365
  WriteF ('\n\d \d = \d/\d/\d\n\n',
          currentDate.year, currentDate.day,
          currentDate.year,
          sd_monthFrom (currentDate),
          sd_dayOfMonthFrom (currentDate))

ENDPROC

