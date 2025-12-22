OPT MODULE

EXPORT PROC getSign(number)
 MOVEQ   #1,D0
 TST.L   number
 BPL.S   quit
 MOVEQ   #-1,D0
quit:
ENDPROC D0




