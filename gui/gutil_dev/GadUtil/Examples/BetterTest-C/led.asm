   xdef  _LightState
   xdef  _ToggleLED

   section  code
_LightState:
   tst.w 6(sp)    ; Check state
   beq.s setoff
   bclr  #1,$bfe001
   rts
setoff:
   bset  #1,$bfe001
   rts

_ToggleLED:
   bchg  #1,$bfe001
   rts
   end
