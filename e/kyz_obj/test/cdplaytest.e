-> mini CD³² CD player - joypad controlled, no output
->
-> play - play/pause/unpause
-> blue - stop/spindown
-> red  - restart current track
-> click left/right shoulder - skip track back/forward
-> left/right on directional pad - search back/forward

MODULE '*cdplayer', 'lowlevel', 'libraries/lowlevel'

DEF cd=NIL:PTR TO cdplayer, list[100]:ARRAY OF CHAR, listpos,
    playing, startplay, searching = FALSE, direction,
    playbtn = 0, bluebtn = 0, greybtn = 0, redbtn = 0

PROC main() HANDLE
  IF lowlevelbase := OpenLibrary('lowlevel.library', 40)
    NEW cd.open()
    mainloop()
  ENDIF
EXCEPT DO
  END cd
  CloseLibrary(lowlevelbase)
ENDPROC

PROC mainloop()
  DEF c1, c2, control

  stop()

  REPEAT
    WaitTOF()
    c1 := ReadJoyPort(0)
    c2 := ReadJoyPort(1)

    control := (IF c1 AND JP_TYPE_GAMECTLR THEN c1 ELSE 0) OR
               (IF c2 AND JP_TYPE_GAMECTLR THEN c2 ELSE 0)

    check_buttons(control)

    IF startplay AND cd.discinserted() THEN start_play()
    IF playing
      IF cd.discinserted() = FALSE THEN stop()
      IF cd.playing() = FALSE THEN advance_play()
    ENDIF

  UNTIL CtrlC()
ENDPROC

->------------------------------------------------------------------------------

CONST PLAY    = JPF_BUTTON_PLAY
CONST RED     = JPF_BUTTON_RED
CONST BLUE    = JPF_BUTTON_BLUE
CONST FORWARD = JPF_BUTTON_FORWARD
CONST REVERSE = JPF_BUTTON_REVERSE
CONST LEFT    = JPF_JOY_LEFT
CONST RIGHT   = JPF_JOY_RIGHT

PROC check_buttons(c)
  -> if play button pressed, try to start play.
  -> if already playing, it toggles pause

  IF button(c AND PLAY, {playbtn})
    IF playing THEN toggle_pause() ELSE startplay := TRUE
  ENDIF

  -> if blue is pressed, stop play. if already stopped, turn off motor
  IF button(c AND BLUE, {bluebtn})
    IF playing THEN stop() ELSE cd.spindown()
  ENDIF

  -> if a shoulder button is pressed, skip forward or back (if playing)
  IF button(c AND (FORWARD OR REVERSE), {greybtn})
    IF playing THEN IF c AND REVERSE THEN prev() ELSE next(FALSE)
  ENDIF

  -> red restarts the current track
  IF button(c AND RED, {redbtn})
    IF playing THEN play()
  ENDIF

  -> if left/right is pressed, search forward or back (if playing)
  IF c AND (LEFT OR RIGHT)
    IF playing AND (searching = FALSE)
      searching := TRUE
      direction := IF c AND LEFT THEN CDSEARCH_BACK ELSE CDSEARCH_FWD
      cd.search(direction)
    ENDIF
  ELSE
    IF searching THEN cd.search(CDSEARCH_STOP) BUT searching := FALSE
  ENDIF
ENDPROC

PROC start_play()
  -> request to start play has been made. we try to get a list of playable
  -> tracks. if there are some, we can enter playmode
  IF make_list() THEN cd.unpause() BUT play()
  startplay := FALSE
ENDPROC

PROC advance_play()
  -> play will have stopped either because we have reached the end of
  -> the track, or reached the start of the track (via backwards search)
  -> if we reached the start, turn off search mode and play the track again.
  -> otherwise, play the next track

  IF searching AND (direction = CDSEARCH_BACK)
    cd.search(CDSEARCH_STOP); play()
  ELSE
    next(TRUE)
  ENDIF
ENDPROC

->------------------------------------------------------------------------------

PROC make_list()
  -> build a list of all audio tracks on the CD
  -> return TRUE if there are any audio tracks on the CD
  DEF m=0, n

  FOR n := 1 TO cd.tracks() DO IF
    cd.trackinfo(n) = CDTRACK_AUDIO THEN list[m++] := n

  list[m] := 0 -> null-terminate after last entry in list
  listpos := 0 -> set list pointer to start of list
ENDPROC (m > 0)

PROC prev()
  -> play previous track (if at first track, play first track again)
  IF listpos-- < 0 THEN listpos := 0; play()
ENDPROC

PROC next(stop_at_end)
  -> play next track in list. if stop_at_end set then stop after final track
  -> otherwise play final track again
  listpos++
  IF list[listpos] THEN play() ELSE IF
    stop_at_end THEN stop() ELSE listpos-- BUT play()
ENDPROC

PROC play()
  -> play currently selected track
  DEF type, offset, length
  type, offset, length := cd.trackinfo(list[listpos])
  playing := TRUE
  cd.play(offset, length)
ENDPROC

PROC stop() IS cd.stop() BUT playing := FALSE

PROC toggle_pause() IS IF cd.paused() THEN cd.unpause() ELSE cd.pause()

PROC button(b, s)
  -> tests against a particular joypad buttonset. Only returns TRUE on the
  -> initial press of the button(s), and button(s) must be released before
  -> pressing again returns TRUE
  IF b; IF ^s = 0; ^s := 1; RETURN TRUE; ENDIF; ELSE; ^s := 0; ENDIF
ENDPROC FALSE
