-> Read_BattClock.e
->
-> Example of reading the BattClock and converting its output to a useful
-> measure of time by calling the Amiga2Date() utility function.

OPT PREPROCESS

-> E-Note: E does not (as of v3.1a) support Resources in the conventional way
MODULE 'other/battclock',  -> E-Note: swapping these two trips a bug in EC v3.1a
       'utility',
       'resources/battclock',
       'utility/date'

ENUM ERR_NONE, ERR_LIB, ERR_RES

RAISE ERR_LIB IF OpenLibrary()=NIL,
      ERR_RES IF OpenResource()=NIL

PROC main() HANDLE
  DEF days:PTR TO LONG, months:PTR TO LONG, ampm,
      amigaTime, myClock:clockdata
  days:=['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
         'Friday', 'Saturday']
  months:=['January', 'February', 'March', 'April', 'May', 'June',
           'July', 'August', 'September', 'October', 'November', 'December']

  utilitybase:=OpenLibrary('utility.library', 33)
  battclockbase:=OpenResource(BATTCLOCKNAME)

  -> Get number of seconds till now
  amigaTime:=readBattClock()

  -> Convert to a ClockData structure
  Amiga2Date(amigaTime, myClock)

  WriteF('\nRobin, tell everyone the BatDate and BatTime')

  -> Print the Date
  WriteF('\n\nOkay Batman, the BatDate is ')
  WriteF('\s, \s \d, \d', days[myClock.wday], months[myClock.month-1],
                          myClock.mday, myClock.year)

  -> Convert military time to normal time and set AM/PM
  IF myClock.hour<12
    ampm:='AM'  -> hour less than 12, must be morning
  ELSE
    ampm:='PM'  -> hour greater than 12,must be night
    myClock.hour:=myClock.hour-12  -> Subtract the extra 12 of military
  ENDIF

  IF myClock.hour=0 THEN myClock.hour:=12  -> Don't forget the 12s

  -> Print the time
  WriteF('\n             the BatTime is ')
  WriteF('\d:\z\d[2]:\z\d[2] \s\n\n',
         myClock.hour, myClock.min, myClock.sec, ampm)
EXCEPT DO
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: Could not open utility.library\n')
  CASE ERR_RES;  WriteF('Error: Unable to open the \s\n', BATTCLOCKNAME)
  ENDSELECT
ENDPROC
