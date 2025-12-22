MODULE 'sven/random'

PROC main()
  Delay(50)
  auto_init()
  REPEAT
    WriteF('Seed : \d\n',calc_seedQ())
  UNTIL Mouse()=1
ENDPROC


