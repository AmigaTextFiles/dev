-> PreCalculate - xadd & yadd (shipadd[]:PTR TO LIST)

PROC main()
  DEF rangle,step,rframe,xadd,
      yadd,arcconst,arcangle,
      max_frame,i,
      s1[5]:STRING,
      s2[5]:STRING

  max_frame:=32
  step:=11.25  -> NOTE! 360/AntFrames

  WriteF('  shipadd:=[')
  FOR i:=0 TO (max_frame-1)
    rframe:=i!

    rangle:=!step*rframe
    IF rangle=0.0
      arcangle:=0.0
      JUMP noangle
    ENDIF
    arcconst:=!180.00/rangle
    arcangle:=!3.14/arcconst

    noangle:
    xadd:=Fcos(arcangle)
    yadd:=Fsin(arcangle)
    xadd:=(xadd*-1.0)
    yadd:=(yadd*-1.0)

    IF i=(max_frame-1)
      WriteF('\s,\s]\n',RealF(s1,xadd,2),RealF(s2,yadd,2))
    ELSE
      WriteF('\s,\s, ',RealF(s1,xadd,2),RealF(s2,yadd,2))
    ENDIF
  ENDFOR
ENDPROC
