OPT PREPROCESS

MODULE 'devices/cd', 'dos/rdargs', '*cdplayer'

DEF cd=NIL:PTR TO cdplayer, quit=FALSE



#define TEMPLATE 'currenttrack/s,discchanged/s,discinserted/s,eject/s,'+\
  'ejected/s,insert/s,length/s,location/s,pause/s,paused/s,play/s,'+\
  'playing/s,search/s,spindown/s,spinning/s,spinup/s,stop/s,trackinfo/s,'+\
  'tracks/s,unpause/s,waitfordisc/s,'+\
  'playtrack/s,fwd/s,back/s,info/s,help/s,quit=exit/s,arg1,arg2'

OBJECT cmd
  currenttrack,discchanged,discinserted,eject,ejected,insert,length
  location,pause,paused,play,playing,search,spindown,spinning,spinup
  stop,trackinfo,tracks,unpause,waitfordisc
  playtrack,fwd,back,info,help,quit,arg1,arg2
ENDOBJECT

PROC main() HANDLE
  DEF rdargs, args:PTR TO LONG, line[100]:STRING, c:cmd

  -> create CDPlayer object for device and unit specified on commandline
  IF rdargs := ReadArgs('DEVICE,UNIT/N', args := ['cd.device', [0]], NIL)
    NEW cd.open(args[0], Long(args[1]))
    FreeArgs(rdargs)
  ELSE
    PrintFault(IoErr(), NIL)
    RETURN 20
  ENDIF

  -> main loop converts line from stdin into a cmd struct, and processes it
  PutStr('type help for command list\n')
  REPEAT
    Write(stdout, '-> ', STRLEN)
    IF Fgets(stdin, line, StrMax(line)-1)
      IF args := NEW [line, StrLen(line), 0,NIL,NIL,0,NIL, RDAF_NOPROMPT]
        IF rdargs := ReadArgs(TEMPLATE, clr(c, SIZEOF cmd), args)
          process_cmd(c)
          FreeArgs(rdargs)
        ENDIF
        END args
      ENDIF
    ENDIF
  UNTIL quit

EXCEPT DO
  IF exception THEN explain_cd_exception()
  END cd
ENDPROC


-> returns the text name of a CDSEARCH mode
#define SEARCHMODE(mode) ( \
  IF      mode = CDSEARCH_FWD  THEN 'CDSEARCH_FWD'  \
  ELSE IF mode = CDSEARCH_BACK THEN 'CDSEARCH_BACK' \
  ELSE                              'CDSEARCH_STOP' \
)

-> returns the text name of a CDTRACK type
#define TRACKTYPE(type) ( \
  IF      type = CDTRACK_DATA  THEN 'CDTRACK_DATA'    \
  ELSE IF type = CDTRACK_AUDIO THEN 'CDTRACK_AUDIO'   \
  ELSE                              'CDTRACK_INVALID' \
)

-> prints information about the specified track
PROC trackinfo(track)
  DEF t,o,l; t,o,l := cd.trackinfo(track)
  trck('track', track); Vprintf('type = \s\n', [TRACKTYPE(t)])
  time('offset', o); time('length', l)
ENDPROC

-> prints a boolean value
PROC bool(name, val)
  PutStr(name); PutStr(IF val THEN ' = TRUE\n' ELSE ' = FALSE\n')
ENDPROC

-> prints a time value
PROC time(name, val)
  DEF m,s,f;  m,s,f := timeval(val)
  PutStr(name); PutStr(' = ')
  IF val = -1 THEN RETURN PutStr('CDTIME_INVALID\n')
ENDPROC Vprintf('\d:\z\d[2]:\z\d[2]\n', [m,s,f])

-> prints a track number
PROC trck(name, val)
  PutStr(name); PutStr(' = ')
  IF val = -1 THEN RETURN PutStr('CDTRACK_INVALID\n')
ENDPROC Vprintf('\d\n', {val})


PROC process_cmd(c:PTR TO cmd)
  DEF mode, track, t, o, l

  IF c.currenttrack THEN trck('currenttrack', cd.currenttrack())
  IF c.discchanged  THEN bool('discchanged', cd.discchanged())
  IF c.discinserted THEN bool('discinserted', cd.discinserted())
  IF c.eject        THEN cd.eject()
  IF c.ejected      THEN bool('ejected', cd.ejected())
  IF c.help         THEN help()
  IF c.info         THEN FOR track := 1 TO cd.tracks() DO trackinfo(track)
  IF c.insert       THEN cd.insert()
  IF c.length       THEN time('length', cd.length())
  IF c.location     THEN time('location', cd.location())
  IF c.pause        THEN cd.pause()
  IF c.paused       THEN bool('paused', cd.paused())
  IF c.play         THEN bool('play()', cd.play(gettime(c.arg1), gettime(c.arg2)))
  IF c.playing      THEN bool('playing', cd.playing())
  IF c.quit         THEN quit := TRUE
  IF c.spindown     THEN cd.spindown()
  IF c.spinning     THEN bool('spinning', cd.spinning())
  IF c.spinup       THEN cd.spinup()
  IF c.stop         THEN cd.stop()
  IF c.trackinfo    THEN trackinfo(Val(c.arg1))
  IF c.tracks       THEN trck('tracks', cd.tracks())
  IF c.unpause      THEN cd.unpause()
  IF c.waitfordisc  THEN cd.waitfordisc()

  IF c.playtrack
    IF track := Val(c.arg1)
      t,o,l := cd.trackinfo(track); cd.play(o, l)
    ELSE
      cd.play(0, cd.length())
    ENDIF
  ENDIF

  IF c.search
    mode := IF c.fwd  THEN CDSEARCH_FWD  ELSE IF
               c.back THEN CDSEARCH_BACK ELSE CDSEARCH_STOP
    mode := cd.search(mode)
    Vprintf('search() = \s\n', [SEARCHMODE(mode)])
  ENDIF
ENDPROC




PROC help()
  PutStr('Commands:\n'+
    'play <start> <length>  - plays <length> of CD from <start>\n'+
    'stop                   - stop playing\n'+
    'pause,unpause          - change pause mode\n'+
    'search [fwd|back]      - enter/exit search mode\n'+
    'spindown, spinup       - turn disc motor on/off\n'+
    'eject,insert           - eject or insert CD drawer (some models only)\n\n'
  )

  PutStr('Status commands:\n'+
    'currenttrack           - prints current playing track\n'+
    'discchanged            - prints TRUE if disc has been changed\n'+
    'discinserted           - prints TRUE if a disc is currently inserted\n'+
    'ejected                - prints TRUE if CD drawer/door is open\n'+
    'info                   - prints CDs table of contents\n'+
    'length                 - prints length of CD in minutes/seconds/frames\n'+
    'location               - prints current playing location on CD\n'+
    'paused                 - prints TRUE if currently in pause mode\n'+
    'playing                - prints TRUE if currently playing\n'+
    'spinning               - prints TRUE if disc motor is running\n'+
    'trackinfo <track>      - prints info about track <track>\n'+
    'tracks                 - prints number of tracks on the CD\n\n'
  )

  PutStr('Misc:\n'+
    'playtrack [track]      - plays [track] or whole CD\n'+
    'waitfordisc            - wait until a valid CD is inserted\n'+
    'help                   - prints this screen \n'+
    'quit, exit             - end the program\n\n'
  )
ENDPROC

PROC explain_cd_exception()
  SELECT exception
  CASE CDPERR_INIT;		PutStr('Initialisation error.\n')
  CASE CDPERR_OPENDEV;		PutStr('Cannot open CD device: ')
  CASE CDPERR_DEVICE;		PutStr('I/O error with CD device: ')
  DEFAULT;			Vprintf('Unknown exception $\h\n', {exception})
  ENDSELECT

  SELECT exceptioninfo
  CASE CDERR_OPENFAIL;		PutStr('device/unit failed to open\n')
  CASE CDERR_ABORTED;		PutStr('request terminated early\n')
  CASE CDERR_NOCMD;		PutStr('command not supported by device\n')
  CASE CDERR_BADLENGTH;		PutStr('invalid length (IO_LENGTH/IO_OFFSET)\n')
  CASE CDERR_BADADDRESS;	PutStr('invalid address (IO_DATA misaligned)\n')
  CASE CDERR_UNITBUSY;		PutStr('device opens ok, but unit is busy\n')
  CASE CDERR_SELFTEST;		PutStr('hardware failed self-test\n')
  CASE CDERR_NOTSPECIFIED;	PutStr('general catchall\n')
  CASE CDERR_NOSECHDR;		PutStr('couldn\at even find a sector\n')
  CASE CDERR_BADSECPREAMBLE;	PutStr('sector looked wrong\n')
  CASE CDERR_BADSECID;		PutStr('sector looked wrong\n')
  CASE CDERR_BADHDRSUM;		PutStr('header had incorrect checksum\n')
  CASE CDERR_BADSECSUM;		PutStr('data had incorrect checksum\n')
  CASE CDERR_TOOFEWSECS;	PutStr('couldn\at find enough sectors\n')
  CASE CDERR_BADSECHDR;		PutStr('sector looked wrong\n')
  CASE CDERR_WRITEPROT;		PutStr('can\at write to a protected disk\n')
  CASE CDERR_NODISK;		PutStr('no disk in the drive\n')
  CASE CDERR_SEEKERROR;		PutStr('couldn\at find track 0\n')
  CASE CDERR_NOMEM;		PutStr('ran out of memory\n')
  CASE CDERR_BADUNITNUM;	PutStr('asked for a unit > NUMUNITS\n')
  CASE CDERR_BADDRIVETYPE;	PutStr('not a drive cd.device understands\n')
  CASE CDERR_DRIVEINUSE;	PutStr('someone else allocated the drive\n')
  CASE CDERR_POSTRESET;		PutStr('user hit reset; awaiting doom\n')
  CASE CDERR_BADDATATYPE;	PutStr('data on disk is wrong type\n')
  CASE CDERR_INVALIDSTATE;	PutStr('invalid cmd under current conditions\n')
  CASE CDERR_PHASE;		PutStr('illegal or unexpected SCSI phase\n')
  CASE CDERR_NOBOARD;		PutStr('open failed for non-existant board\n')
  DEFAULT;			Vprintf('unknown reason \d\n', {exceptioninfo})
  ENDSELECT
ENDPROC



-> converts a string in the form 'mm:ss:ff', 'mm:ss' or 'mm:'
-> into an LSN timevalue
PROC gettime(str)
  DEF m=0, s=0, f=0

  WHILE (str[] >= "0") AND (str[] <= "9") DO m := m * 10 + (str[]++ - "0")
  IF str[]++ <> ":" THEN RETURN CDTIME_INVALID
  WHILE (str[] >= "0") AND (str[] <= "9") DO s := s * 10 + (str[]++ - "0")
  IF str[] = ":"; str++
    WHILE (str[] >= "0") AND (str[] <= "9") DO f := f * 10 + (str[]++ - "0")
  ENDIF
  IF str[] <> "\0" THEN RETURN CDTIME_INVALID

  IF (s >= 60) OR (f >= 75) THEN RETURN CDTIME_INVALID
ENDPROC maketime(m, s, f)


-> clears [sze] bytes starting from [mem], returns [mem]
PROC clr(mem:PTR TO CHAR, sze)
  DEF end; end := mem + sze
  WHILE mem < end DO mem[]++ := 0
ENDPROC mem - sze
