MODULE 'dos/datetime'

PROC main()
  DEF sd[16]:STRING,st[16]:STRING,dt:DateTime
  DateStamp(dt.Stamp)
  dt.StrDate:=sd
  dt.StrTime:=st
  IF DateToStr(dt) THEN WriteF('\s \s\n',sd,st)
ENDPROC
