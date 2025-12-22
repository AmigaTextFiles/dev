/* E-Audio demo
   By Peter Gordon

   This is pish!!
   
   To test it out, just compile this and type:
   
   eaudio <filename>
   
   And any mousebutton exits :)
   
   Byee!
*/

MODULE  '*eaudio'

PROC main()
  DEF sample,samplen
  sample, samplen:=loadRaw(arg)
  IF(sample)
    playData(sample,samplen,13964,CHAN_LEFT2+CHAN_RIGHT1,64)
    WaitTOF()
    exitLoop(CHAN_LEFT2+CHAN_RIGHT1)
    REPEAT;UNTIL Mouse()
    stopChannels(CHAN_LEFT2+CHAN_RIGHT1+CHAN_LEFT1)
    Dispose(sample)
  ENDIF
ENDPROC
