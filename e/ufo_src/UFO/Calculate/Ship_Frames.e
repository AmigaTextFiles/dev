-> PreCalculate - shipframes
PROC main()
  DEF i,
      amt_frames=31,
      online=13,
      line=0,
      xpos=0,
      sizex=45,
      sizey=25,
      addx=0,
      addy=0


  WriteF('  shipframes:=[')
  FOR i:=0 TO amt_frames
    IF xpos=online
      INC line
      xpos:=0
      WriteF('\n               ')
    ENDIF
    WriteF('\d[3],\d[3], ',(xpos*sizex)+(addx*xpos),(line*sizey)+addy)
    INC xpos
  ENDFOR
  WriteF('-1,-1]:framelist\n')
ENDPROC
