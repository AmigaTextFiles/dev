OPT MODULE,PREPROCESS

MODULE 'exec/interrupts', 'exec/io', 'exec/ports', 'exec/nodes', 'devices/cd', 'other/ecode'

-> errors
EXPORT ENUM CDPERR_INIT="cdpa", CDPERR_OPENDEV, CDPERR_DEVICE

-> types returned by trackinfo()
EXPORT ENUM CDTRACK_INVALID = -1, CDTRACK_AUDIO, CDTRACK_DATA

-> anything that returns a timevalue but can fail
EXPORT CONST CDTIME_INVALID = -1

-> maximum number of entries in TOC
CONST MAX_TOC = 100

PROC docmd(io:PTR TO iostd, command, data=NIL, length=0, offset=0)
  io.command := command
  io.data    := data
  io.length  := length
  io.offset  := offset
  DoIO(io)
  IF io.error THEN Throw(CDPERR_DEVICE, signed_char(io.error))
ENDPROC io.actual

-> signed_char() sign-extends a byte value
PROC signed_char(x) IS IF x < 128 THEN x ELSE x - 256


/****** cdplayer.m/--overview-- *******************************************
* 
*   PURPOSE
*	To provide an interface to the cd.device for playing Audio CDs.
* 
*   OVERVIEW
*	This  object  simulates the high-level idea of 'CD Controls', such
*	as  play(),  pause(), stop() and so on. It also allows querying of
*	the  CD  drive, such as whether the door is open or if the disc is
*	spinning.
*	
*	Audio  play  is,  of  course,  asynchronous,  and the audio can be
*	manipulated while play is in progress.
*
*	Construction and destruction:
*	  open(), end()
*	
*	CD Controls:
*	  play(), stop(), search()
*
*	CD State controls:
*	  pause(), unpause(), paused() - pause control
*	  eject(), insert(), ejected() - door control
*	  spinup(), spindown(), spinning() - motor control
*	  playing(), location()
*
*	Disc information:
*	  discchanged(), discinserted(), waitfordisc()
*
*	Track information:
*	  length(), tracks(), trackinfo(), currenttrack()
*
*	Timing specifications
*
*	    Audio CDs are marked in minutes, seconds and frames. There are
*	    75 frames in a second, and 60 seconds in a minute.
*	
*	    To work with Audio CDs, there must be some way of representing
*	    a  time  values.  Time values are used to specify positions on
*	    the  CD,  offsets  from the beginning of the CD or tracks, the
*	    length of tracks, the total time on the CD, amounts of time to
*	    be played, and so on.
*	
*	    There  are two standard ways to represent time values for CDs.
*	    One  is  called  'LSN  format',  where LSN stands for 'Logical
*	    Sector  Numbers'.  LSN  format  is  basically a mass number of
*	    frames,  where  a  minute  is  4500 frames, and a second is 75
*	    frames.  The  advantage  of  this  format is that times can be
*	    worked  with  like  normal numbers. You can add them, subtract
*	    them and compare them with normal number math.
*	
*	    The  other standard time representation is 'MSF format', where
*	    MSF  stands  for  'Minutes,  Seconds,  Frames'. Just as an LSN
*	    value  is  an unsigned 32-bit LONG value, so is an MSF value -
*	    but  each  byte  of  the  LONG is used individually to store a
*	    minute  count,  second  count,  and  a  frame  count. The most
*	    significant  byte is unused, the next most significant byte is
*	    a number from 0 to 255 representing the number of minutes, the
*	    next  byte is a number from 0 to 59 representing the number of
*	    seconds,  and  the least significant byte holds a value from -
*	    to 74 containing a number of frames.
*	
*	    A  fair  analogy for MSF format would be the well known Binary
*	    Coded  Decimal  (BCD) format supported by most processors. The
*	    numbers   cannot  be  added  or  manipulated  without  special
*	    instructions,  and  'invalid'  values  are  possible,  but the
*	    values  themselves  are  more  readable  and 'splittable' than
*	    normal integers.
*	
*	    Before an argument breaks out, it must be said that this class
*	    always  uses  LSN format time values - in all instances. It is
*	    far  more  practical  to  do  so  than  to support MSF format.
*	    However,  there are two functions to provide the functionality
*	    inherent  in  the MSF format. maketime() will take a number of
*	    minutes,  seconds  and frames, and create an LSN format number
*	    from  them.  timeval()  will  take  an  LSN format number, and
*	    return a number of minutes, seconds and frames.
*
*	    The unit of time value measurement is referred to as 'frames'.
*	
*	Error handling
*
*	    When  the  functions of the cdplayer object mention 'failure',
*	    'errors'  and  so  on,  they  refer to logical errors that the
*	    functions specifically expect and report. However, they do not
*	    expect  I/O  errors  with  the  CD  device.  If  the CD device
*	    returns an errors, the exception CDPERR_DEVICE will be thrown,
*	    and the device error will be in exceptioninfo. In their normal
*	    operation,  the  functions  do  not cause or expect any device
*	    errors. However, events beyond their control can cause them.
*	    In practise, it is very difficult to cause them.
*
****************************************************************************
*
*
*/

EXPORT OBJECT cdplayer PRIVATE
  sigbit   -> signal bit used for waitfordisc()
  thisdisc -> the disc reported when we last called discnum()

  -> device IO resources
  port, playport, opendev, playopendev
  io:PTR TO iostd, playio:PTR TO iostd

  -> Table of Contents (TOC) state
  toc[MAX_TOC]:ARRAY OF cdtoc, disctoc
ENDOBJECT

/****** cdplayer.m/open *******************************************
*
*   NAME
*	cdplayer.open() -- Constructor.
*
*   SYNOPSIS
*	open()
*	open(device)
*	open(device, unit)
*
*   FUNCTION
*	Initialises  an  instance  of the cdplayer class. Raises exception
*	CDPERR_INIT if it cannot allocate required memory and resources.
*
*	By  default, this opens "cd.device" unit 0. You can change this by
*	passing  an  alternate  device name. Similarly, you can provide an
*	alternate  unit  to  open. This option should be made available to
*	the user if at all possible. Note that the device opened *must* be
*	compatible  to  the  cd.device  interface  -  scsi.device  is  not
*	acceptable,  even  though  many  CD-ROMs  are  controlled with the
*	scsi.device, in that case they must be sent SCSI commands.
*
*	If  opening the device fails, CDPERR_OPENDEV will be thrown, along
*	with the OpenDevice() error code.
*
*   INPUTS
*	device - device to be opened, default is 'cd.device'
*	unit   - unit of device to be opened, default is 0.
*   
*   SEE ALSO
*	end()
*
****************************************************************************
*
*
*/

EXPORT PROC open(device=NIL, unit=0) OF cdplayer
  IF device = NIL THEN device := 'cd.device'

  self.opendev     := -1
  self.playopendev := -1

  -> allocate a signal bit for waitfordisc(), etc
  self.sigbit := AllocSignal(-1)
  IF self.sigbit = -1 THEN Raise(CDPERR_INIT)

  ->--- open device for an IORequest to send status and update commands.
  ->--- open device again for an IORequest to send 'play' commands.

  self.port     := CreateMsgPort()
  self.playport := CreateMsgPort()
  IF (self.port = NIL) OR (self.playport = NIL) THEN Raise(CDPERR_INIT)

  self.io     := CreateIORequest(self.port, SIZEOF iostd)
  self.playio := CreateIORequest(self.playport, SIZEOF iostd)
  IF (self.io = NIL) OR (self.playio = NIL) THEN Raise(CDPERR_INIT)

  self.opendev     := OpenDevice(device, unit, self.io, 0)
  self.playopendev := OpenDevice(device, unit, self.playio, 0)

  IF self.opendev <> 0 THEN Throw(CDPERR_OPENDEV, self.opendev)
  IF self.playopendev <> 0 THEN Throw(CDPERR_OPENDEV, self.playopendev)

  -> use the playio IORequest _at least once_
  docmd(self.playio, CD_CHANGESTATE)

  -> ensure that first call to discchanged() returns FALSE if no disc has
  -> been changed, and that first call to readtoc() always reads the TOC.
  self.discchanged()
  self.disctoc := self.thisdisc - 1
ENDPROC


/****** cdplayer.m/end *******************************************
*
*   NAME
*	cdplayer.end() -- Destructor.
*
*   SYNOPSIS
*	end()
*
*   FUNCTION
*	Frees resources used by an instance of the cdplayer class.
*
*   SEE ALSO
*	new()
*
****************************************************************************
*
*
*/

EXPORT PROC end() OF cdplayer
  IF self.playopendev = 0
    self.stop()
    CloseDevice(self.playio)
  ENDIF

  IF self.opendev = 0 THEN CloseDevice(self.io)

  IF self.playio THEN DeleteIORequest(self.playio)
  IF self.io     THEN DeleteIORequest(self.io)

  IF self.playport THEN DeleteMsgPort(self.playport)
  IF self.port     THEN DeleteMsgPort(self.port)

  IF self.sigbit <> -1 THEN FreeSignal(self.sigbit)
ENDPROC




->-----------------------------------------------------------------------------
->--- cd player interface -----------------------------------------------------
->-----------------------------------------------------------------------------

/****** cdplayer.m/play ******************************************
*
*   NAME
*	cdplayer.play() -- play audio on the CD.
*
*   SYNOPSIS
*	playing := play(offset, length)
*
*   FUNCTION
*	Attempts to start playing a specified area of the CD.
*
*	If  any  previous play request is still running, it is immediately
*	stopped, regardless of whether this new request succeeds.
*
*	There  must  be  a  valid CD in the drive, and the area you select
*	must  be  within  the  bounds  of  the disc, otherwise an error is
*	returned.  Similarly,  failure occurs if the CD drive reports that
*	the disc is currently playing, but it is not us who is playing it.
*
*	If  successful, a CD play request will be issued, and the CD drive
*	should  begin asynchronously playing the specified audio area. Any
*	errors with the CD drive playing will not be reported.
*
*	Play continues until one of the following occurs:
*	- play reaches the end of the selected area.
*	- you stop() the CD, or play() a new area.
*	- you eject() the CD, or the user ejects it himself.
*	- you search() backwards to a point before play started.
*
*   INPUTS
*	offset - the  location  on  the  CD  from  which you want to start
*	         playing.
*
*	length - the  duration  for  which  the play should last. The area
*	         played  is therefore from (offset) to (offset+length).
*
*   RESULT
*	playing - TRUE if succeeded, FALSE for failure
*
*   NOTE
*	You are not currently prohibited from playing data tracks, which
*	sound rather unpleasent. This may change in future.
*
*   SEE ALSO
*	stop(), pause(), search(), playing()
*
******************************************************************************
*
*/

EXPORT PROC play(offset, length) OF cdplayer
->  DEF n, t, s, l

  -> stop any current play request
  self.stop()

  -> we fail if there isn't a CD in the drive
  IF self.discinserted() = FALSE THEN RETURN FALSE

  -> we fail if the CD is playing but it is not us that is doing it.
  IF self.status(CDSTSF_PLAYING) THEN RETURN FALSE

  -> only play valid parts of the of CD
  IF (offset < 0) OR (length < 1) OR ((offset + length) > self.length())
    RETURN FALSE
  ENDIF

->-> do not play data tracks
->FOR n := 1 TO self.tracks()
->  t, s, l := self.trackinfo(n)
->  IF (t = CDTRACK_DATA) AND overlap(offset, s, length, l) THEN RETURN FALSE
->ENDFOR

  self.playio.command := CD_PLAYLSN
  self.playio.data    := NIL
  self.playio.offset  := offset
  self.playio.length  := length
  SendIO(self.playio)
ENDPROC TRUE

-> overlap() returns true if x->(x+xl) overlaps y->(y+yl)
->PROC overlap(x, y, xl, yl) IS
->  IF x = y THEN TRUE ELSE IF x > y THEN (y+yl) > x ELSE (x+xl) > y
  

/****** cdplayer.m/stop ******************************************
*
*   NAME
*	cdplayer.stop() -- stop any currently running play request.
*
*   SYNOPSIS
*	stop()
*
*   FUNCTION
*	Stops playing the CD.
*
*   SEE ALSO
*	play(), pause()
*
******************************************************************************
*
*/

EXPORT PROC stop() OF cdplayer
  IF self.playing()
    AbortIO(self.playio)
    WaitIO(self.playio)
  ENDIF
ENDPROC


/****** cdplayer.m/playing ******************************************
*
*   NAME
*	cdplayer.playing() -- report if we are playing the CD.
*
*   SYNOPSIS
*	playing := playing()
*
*   FUNCTION
*	Reports  on  whether  or  not there is a play request in progress.
*	That is, whether or not we are playing the CD.
*
*   RESULT
*	playing - TRUE if play is in progress, FALSE otherwise.
*
*   SEE ALSO
*	play(), stop()
*
******************************************************************************
*
*/

EXPORT PROC playing() OF cdplayer IS
  IF self.playopendev = 0 THEN (CheckIO(self.playio) = NIL) ELSE FALSE



/****** cdplayer.m/search ******************************************
*
*   NAME
*	cdplayer.search() -- search CD in 'scan mode' while playing.
*
*   SYNOPSIS
*	oldmode := search(mode)
*
*   FUNCTION
*	Allows  a  playing  CD to play in 'fast forward' or 'fast reverse'
*	modes.  If,  in  these modes, the position of play goes beyond the
*	boundaries selected in the original call to play(), then play will
*	finish.  If  play is currently paused(), the search mode will take
*	effect when the play is unpaused().
*
*   INPUTS
*	mode - one of the following modes:
*	       CDSEARCH_STOP - turn off search mode
*	       CDSEARCH_FWD  - enter 'fast forward' mode
*	       CDSEARCH_BACK - enter 'fast reverse' mode
*
*   RESULT
*	oldmode - the previous state - one of the above 3 modes.
*
*   SEE ALSO
*	play()
*
******************************************************************************
*
*/

EXPORT CONST CDSEARCH_STOP = CDMODE_NORMAL
EXPORT CONST CDSEARCH_FWD  = CDMODE_FFWD
EXPORT CONST CDSEARCH_BACK = CDMODE_FREV

EXPORT PROC search(mode) OF cdplayer IS docmd(self.io, CD_SEARCH, NIL, mode)



->-----------------------------------------------------------------------------
->--- track support -----------------------------------------------------------
->-----------------------------------------------------------------------------

/* PRIVATE METHOD: read_ok := readtoc()
 *
 * reads the TOC if it hasn't already been read for this disc
 * returns TRUE if it succeeds in reading the TOC, otherwise FALSE
 */
PROC readtoc() OF cdplayer
  IF self.discinserted() = FALSE THEN RETURN FALSE
  IF self.disctoc = self.discnum() THEN RETURN TRUE
  docmd(self.io, CD_TOCLSN, self.toc, MAX_TOC, 0)
  self.disctoc := self.discnum()
ENDPROC TRUE


/****** cdplayer.m/length ******************************************
*
*   NAME
*	cdplayer.length() -- report the running time for the CD.
*
*   SYNOPSIS
*	length := length()
*
*   FUNCTION
*	Returns the length in time of the CD currently inserted.
*
*   RESULT
*	length - A time value in frames, or CDTIME_INVALID in error.
*
*   SEE ALSO
*	tracks()
*
******************************************************************************
*
*/

EXPORT PROC length() OF cdplayer IS 
  IF self.readtoc() THEN self.toc[0].summary.leadout.lsn ELSE CDTIME_INVALID


/****** cdplayer.m/tracks ******************************************
*
*   NAME
*	cdplayer.tracks() -- report the number of tracks on the CD.
*
*   SYNOPSIS
*	tracks := tracks()
*
*   FUNCTION
*	Returns  the  total number of tracks on the CD. The result is also
*	the track number of the last track (the first track is always 1).
*
*   RESULT
*	tracks - the number of tracks, or CDTRACK_INVALID in error.
*
*   SEE ALSO
*	length()
*
******************************************************************************
*
*/

EXPORT PROC tracks() OF cdplayer IS
  IF self.readtoc() THEN self.toc[0].summary.lasttrack ELSE 0


/****** cdplayer.m/trackinfo ******************************************
*
*   NAME
*	cdplayer.trackinfo() -- retrieve information about a track.
*
*   SYNOPSIS
*	type, offset, length := trackinfo(track)
*
*   FUNCTION
*	Retrieves  information  from  the  table  of  contents  (TOC)  the
*	requested track on the CD in the drive. This data is simplified to
*	just 'track type', position on the disc, and running time.
*
*   INPUTS
*	track - the  track to get information about. Must be between 1 and
*	        tracks(), otherwise an error will occur.
*
*   RESULT
*	type   - Will be one of the following three types:
*
*	         CDTRACK_INVALID:
*	         An  error has occured. For example, there may be no valid
*	         disc  in  the  drive, or the track you requested does not
*	         exist. In this case, the other results returned will also
*	         be invalid.
*
*	         CDTRACK_DATA:
*	         The track is certainly valid, however you should not play
*	         it as it is actually CD-ROM data, not an audio track.
*
*	         CDTRACK_AUDIO:
*	         The track is both valid and playable.
*
*	offset - The position in frames where the track begins on the CD.
*
*	length - The running time of the track, in frames.
*
*   SEE ALSO
*	tracks(), play()
*
******************************************************************************
*
*/

#define ISDATA(trk) (self.toc[trk].entry.ctladr AND CTLADR_CTLMASK) = CTL_DATA

#define TRACKPOS(track) (                       \
    IF (track) > self.toc[0].summary.lasttrack  \
    THEN self.toc[0].summary.leadout.lsn        \
    ELSE self.toc[track].entry.position.lsn     \
  )

PROC trackinfo(track) OF cdplayer
  DEF offset

  -> only proceed if TOC is read and track requested is valid
  IF self.readtoc() AND (track >= 1) AND (track <= self.tracks()) THEN
    RETURN IF ISDATA(track) THEN CDTRACK_DATA ELSE CDTRACK_AUDIO,
           offset := TRACKPOS(track), TRACKPOS(track+1) - offset

ENDPROC CDTRACK_INVALID, CDTIME_INVALID, CDTIME_INVALID


/****** cdplayer.m/location *******************************************
*
*   NAME
*       cdplayer.location() -- report current location of laser on the CD.
*
*   SYNOPSIS
*       position := location()
*
*   FUNCTION
*	Returns  the  latest known position of play on the CD. The CD must
*	be playing, but it does not matter if play is paused or searching.
*
*   RESULT
*	position - CDTIME_INVALID  if  the  CD is not playing, otherwise a
*	           time offset in frames from the start of the disc.
*
*   SEE ALSO
*       play(), playing(), currenttrack()
*
****************************************************************************
*
*
*/

PROC location() OF cdplayer
  DEF qcode:qcode

  IF self.playing() = FALSE THEN RETURN CDTIME_INVALID
  docmd(self.io, CD_QCODELSN, qcode)
ENDPROC qcode.diskposition.lsn


/****** cdplayer.m/currenttrack *******************************************
*
*   NAME
*       cdplayer.currenttrack() -- report track being played.
*
*   SYNOPSIS
*       track := currenttrack()
*
*   FUNCTION
*	Returns  the  latest known currently playing track. The CD must be
*	playing, but it does not matter if play is paused or searching.
*
*   RESULT
*	track - CDTRACK_INVALID  if  the  CD is not playing, otherwise the
*	        track number.
*
*   SEE ALSO
*       play(), playing(), location()
*
****************************************************************************
*
*
*/

PROC currenttrack() OF cdplayer
  DEF qcode:qcode

  IF self.playing() = FALSE THEN RETURN CDTRACK_INVALID
  docmd(self.io, CD_QCODELSN, qcode)
ENDPROC qcode.track




->-----------------------------------------------------------------------------
->--- disc support ------------------------------------------------------------
->-----------------------------------------------------------------------------

/* PRIVATE METHOD: discnum := discnum()
 *
 * returns the current disc change value
 */
PROC discnum() OF cdplayer IS docmd(self.io, CD_CHANGENUM)


/****** cdplayer.m/waitfordisc ******************************************
*
*   NAME
*	cdplayer.waitfordisc() -- efficiently wait for a disc to be ready.
*
*   SYNOPSIS
*	waitfordisc()
*
*   FUNCTION
*	Will  wait indefinately until a readable disc is inserted into the
*	drive. A more efficent form of "REPEAT UNTIL discinserted()".
*
*   SEE ALSO
*	discinserted()
*
******************************************************************************
*
*/

EXPORT PROC waitfordisc() OF cdplayer
  DEF int:is

  -> if a disc is already inserted, return immediately
  IF self.discinserted() THEN RETURN

  -> as we need to use the 'play' IO request for some asynchronous IO
  -> (CD_ADDCHANGEINT), we must kill off any current usage of that
  -> request.
  self.stop()

  -> initialise disc-change interrupt
  int.ln.succ := NIL
  int.ln.pred := NIL
  int.ln.type := NT_INTERRUPT
  int.ln.pri  := 0
  int.ln.name := NIL
  int.data    := [FindTask(NIL), Shl(1, self.sigbit)]
  int.code    := eCodeSoftInt({intsig})

  -> install interrupt - if successful, we will be Signal()ed every time
  -> a disc-change occurs.
  self.playio.command := CD_ADDCHANGEINT
  self.playio.data    := int
  self.playio.length  := SIZEOF is
  SendIO(self.playio)

  -> we wait and loop until a disc is inserted.
  -> the waiting mechanism is either to wait for a disc-change signal
  -> provided by our interrupt, or wait for one frame if the interrupt
  -> did not install.
  REPEAT
    IF CheckIO(self.playio) THEN WaitTOF() ELSE Wait(Shl(1, self.sigbit))
  UNTIL self.discinserted()

  -> we now remove the disc-change interrupt, if it was installed
  IF CheckIO(self.playio) = NIL
    docmd(self.playio, CD_REMCHANGEINT, int, SIZEOF is)
  ENDIF

  -> free memory used for interrupt-code stub
  eCodeDispose(int.code)  
ENDPROC

-> this is executed by the CHANGEINT. using the data array, it signals us.
PROC intsig(data:PTR TO LONG) IS Signal(data[0], data[1])


/****** cdplayer.m/discinserted ******************************************
*
*   NAME
*	cdplayer.discinserted() -- report if a disc is in the drive.
*
*   SYNOPSIS
*	inserted := discinserted()
*
*   FUNCTION
*	Reports if a readable disc is ready and in the CD drive.
*
*   RESULT
*	inserted - TRUE if a disc is inserted, FALSE otherwise.
*
*   NOTE
*	Discs  may  be  removed at any time, even just after this call has
*	returned TRUE! A TRUE result from this function is no guarantee of
*	permanent disc availability.
*
*   SEE ALSO
*	discchanged(), waitfordisc()
*
******************************************************************************
*
*/

EXPORT PROC discinserted() OF cdplayer IS (docmd(self.io, CD_CHANGESTATE) = 0)


/****** cdplayer.m/discchanged ******************************************
*
*   NAME
*	cdplayer.discchanged() -- report if disc has been changed.
*
*   SYNOPSIS
*	changed := discchanged()
*
*   FUNCTION
*	This function returns TRUE if the disc in the CD drive has changed
*	since  you last called this function. To help you, the function is
*	called  automatically  on  your  behalf  when you first create the
*	cdplayer object.
*
*   RESULT
*	changed - TRUE if the disc in the CD drive has changed since this
*	          function was last called, FALSE otherwise.
*
*   NOTE
*	A disc change does not imply that there is a disc in the drive!
*
*   SEE ALSO
*	discinserted(), waitfordisc()
*
******************************************************************************
*
*/

EXPORT PROC discchanged() OF cdplayer
  DEF olddisc
  olddisc := self.thisdisc
  self.thisdisc := self.discnum()
ENDPROC olddisc <> self.thisdisc




->-----------------------------------------------------------------------------
->--- state information -------------------------------------------------------
->-----------------------------------------------------------------------------

/* PRIVATE METHOD: flagset := status(flags)
 *
 * returns true if a particular status flag is set
 */
PROC status(flags) OF cdplayer
  DEF cdinfo:cdinfo
  docmd(self.io, CD_INFO, cdinfo, SIZEOF cdinfo)
ENDPROC (cdinfo.status AND flags) <> 0


/****** cdplayer.m/pause *******************************************
*
*   NAME
*       cdplayer.pause() -- put CD player in pause mode.
*
*   SYNOPSIS
*       pause()
*
*   FUNCTION
*       If the CD player is currently playing, it will be paused. If it is
*       not playing, it will pause when the next play() is issued.
*
*   SEE ALSO
*       unpause(), paused()
*
****************************************************************************
*
*
*/
/****** cdplayer.m/unpause *******************************************
*
*   NAME
*       cdplayer.unpause() -- take CD player out of pause mode.
*
*   SYNOPSIS
*       unpause()
*
*   FUNCTION
*       If the CD player is currently playing, it will be paused. If it is
*       not playing, it will pause when the next play() is issued.
*
*   SEE ALSO
*     pause(), paused()
*
****************************************************************************
*
*
*/
/****** cdplayer.m/paused *******************************************
*
*   NAME
*       cdplayer.paused() -- report if CD player is paused.
*
*   SYNOPSIS
*       paused := paused()
*
*   FUNCTION
*       Returns the state of the 'pause button' in the CD player.
*
*   RESULT
*       Returns TRUE if in pause mode, otherwise FALSE.
*
*   SEE ALSO
*     pause(), unpause()
*
****************************************************************************
*
*
*/

EXPORT PROC pause()   OF cdplayer IS docmd(self.io, CD_PAUSE, NIL, 1)
EXPORT PROC unpause() OF cdplayer IS docmd(self.io, CD_PAUSE, NIL, 0)
EXPORT PROC paused()  OF cdplayer IS self.status(CDSTSF_PAUSED)


/****** cdplayer.m/spinup *******************************************
*
*   NAME
*	cdplayer.spinup() -- turn the CD motor on.
*
*   SYNOPSIS
*	spinup()
*
*   FUNCTION
*	Turns the CD motor on. If the CD player was playing when the
*	motor was spun down, it will continue where it left off.
*
*   NOTE
*	The CD motor automatically turns itself on if it recieves any
*	request to read data/audio from the drive while it is off.
*
*   SEE ALSO
*	spindown(), spinning()
*
****************************************************************************
*
*
*/
/****** cdplayer.m/spindown *******************************************
*
*   NAME
*	cdplayer.spindown() -- turn the CD motor off.
*
*   SYNOPSIS
*	spindown()
*
*   FUNCTION
*	Turns  the CD motor off. If the CD player is currently playing, it
*	will stop until the motor is turned back on again.
*
*   SEE ALSO
*	spinup(), spinning()
*
****************************************************************************
*
*
*/
/****** cdplayer.m/spinning *******************************************
*
*   NAME
*	cdplayer.spinning() -- report if CD motor is running.
*
*   SYNOPSIS
*	spinning := spinning()
*
*   FUNCTION
*	Reports the current state of the CD motor.
*
*   RESULT
*	Returns TRUE if the motor is spinning, FALSE otherwise.
*
*   SEE ALSO
*	spinup(), spindown()
*
****************************************************************************
*
*
*/

EXPORT PROC spinup()   OF cdplayer IS docmd(self.io, CD_MOTOR, NIL, 1)
EXPORT PROC spindown() OF cdplayer IS docmd(self.io, CD_MOTOR, NIL, 0)
EXPORT PROC spinning() OF cdplayer IS self.status(CDSTSF_SPIN)


/****** cdplayer.m/eject *******************************************
*
*   NAME
*	cdplayer.eject() -- open the CD drawer/door.
*
*   SYNOPSIS
*	eject()
*
*   FUNCTION
*	Requests the CD drive to open its drawer or door.
*
*   NOTE
*	You  must have a CD drive with a motorized drawer or door for this
*       call to work. The CD³² drive throws IO error CDERR_NOCMD.
*
*   SEE ALSO
*	insert(), ejected()
*
****************************************************************************
*
*
*/
/****** cdplayer.m/insert *******************************************
*
*   NAME
*	cdplayer.insert() -- close the CD drawer/door.
*
*   SYNOPSIS
*	insert()
*
*   FUNCTION
*	Requests the CD drive to close its drawer or door.
*
*   NOTE
*	You  must have a CD drive with a motorized drawer or door for this
*       call to work. The CD³² drive throws IO error CDERR_NOCMD.
*
*   SEE ALSO
*	eject(), ejected()
*
****************************************************************************
*
*
*/
/****** cdplayer.m/ejected *******************************************
*
*   NAME
*	cdplayer.ejected() -- report if CD drawer/door is open.
*
*   SYNOPSIS
*	door_open := ejected()
*
*   FUNCTION
*	Reports the current state of the CD drawer or door.
*
*   RESULT
*	Returns TRUE if the door is open, FALSE otherwise.
*
*   NOTE
*	Cartridge-based CD drives do not normally report being 'open'.
*
*   SEE ALSO
*	eject(), insert()
*
****************************************************************************
*
*
*/

EXPORT PROC eject()   OF cdplayer IS docmd(self.io, CD_EJECT, NIL, 1)
EXPORT PROC insert()  OF cdplayer IS docmd(self.io, CD_EJECT, NIL, 0)
EXPORT PROC ejected() OF cdplayer IS self.status(CDSTSF_CLOSED) = 0




->-----------------------------------------------------------------------------
->--- time support ------------------------------------------------------------
->-----------------------------------------------------------------------------

/****** cdplayer.m/maketime ******************************************
*
*   NAME
*	maketime() -- Create an LSN time value.
*
*   SYNOPSIS
*	time := maketime()
*	time := maketime(minutes)
*	time := maketime(minutes, seconds)
*	time := maketime(minutes, seconds, frames)
*
*   FUNCTION
*	Creates an LSN time value from the 3 component parts, for use with
*	the  cdplayer class. Any component part you do not specify will be
*	assumed to be zero.
*
*   INPUTS
*	minutes - A number of minutes of time
*	seconds - A number of seconds of time
*	frames  - A number of frames (1/75 s) of time
*
*	Parameters you do not specify will be assumed to be zero.
*	
*   RESULT
*	time - a  time  value  in a suitable form for adding, subtracting,
*	       comparing, and passing to cdplayer functions.
*
*   NOTE
*	This is not a member function of the cdplayer class.
*
*   SEE ALSO
*	timeval()
*	
******************************************************************************
*
*/

EXPORT PROC maketime(minutes=0, seconds=0, frames=0) IS
  Mul(minutes, 75*60) + Mul(seconds, 75) + frames


/****** cdplayer.m/timeval ******************************************
*
*   NAME
*	timeval() -- Break an LSN time value into its component parts.
*
*   SYNOPSIS
*	minutes, seconds, frames := timeval(time)
*	
*   FUNCTION
*	Breaks an integral LSN time value into a number of minutes,
*	seconds and frames (1/75 s).
*	
*   INPUTS
*	time - an LSN time value that you have calculated or recieved from
*	       a function in the cdplayer class. For correct operation, it
*	       should  range  between  0 and about 80*60*75 (the '80' is a
*	       nominal  value  for the maximum number of minutes likely to
*	       be represented on a CD.
*	
*   RESULT
*	minutes - the number of whole minutes in the time (from 0 to 80)
*	seconds - the number of whole seconds in the time (from 0 to 59)
*	frames  - the number of frames left (from 0 to 75)
*	
*   NOTE
*	This is not a member function of the cdplayer class.
*
*   SEE ALSO
*	maketime()
*
******************************************************************************
*
*/

EXPORT PROC timeval(frames)
  DEF minutes, seconds
  frames, minutes := Mod(frames, 60*75)
  frames, seconds := Mod(frames, 75)
ENDPROC minutes, seconds, frames
