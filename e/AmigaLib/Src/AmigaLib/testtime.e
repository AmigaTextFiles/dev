MODULE 'amigalib/time'

PROC main()
  DEF error
  WriteF('Just going to delay for 20 secs...\n')
  error:=timeDelay(0, 20, 0)
  WriteF(IF error THEN 'Ack! Something went wrong.\n' ELSE 'Done!\n')
ENDPROC
