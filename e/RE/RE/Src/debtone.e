/*
Plays a beep (translated from Developer kit by Marco Antoniazzi)
usage from CLI: debtone period duration (eg. debtone 500 100)
Note: duration depends on hardware speed
*/

MODULE 'hardware/custom',
       'hardware/dmabits'

PROC main()
  DEF a,b
  a,b:=Val(arg)
  b:=Val(arg+b+1) ->very minimal parsing ;)
  PrintF('period:\d duration:\d\n',a,b)
  debtone(a,b)
ENDPROC

->plays a beep bashing the hardware (useful for debug pourposes when PrintF-ing is not possible)
PROC debtone(period,delay)
  DEF cust:PTR TO Custom->,delay
  
  cust:=$dff000 ->CUSTOMADDR
  cust.aud.per:=period
  cust.aud.ptr:=8
  cust.aud.len:=2
  cust.aud.vol:=64
  cust.dmacon:=DMAF_SETCLR+DMAF_AUD0+DMAF_AUD1+DMAF_MASTER  -> start dma sound
  delay:=delay*100000
  WHILE delay DO delay-- -> busy loop
->  Delay(delay)
  cust.aud.vol:=0
  cust.dmacon:=DMAF_AUD0+DMAF_AUD1  -> turn off sound
  delay:=10000
  WHILE delay DO delay-- -> busy loop
->  Delay(10) -> be silent for a little

ENDPROC
