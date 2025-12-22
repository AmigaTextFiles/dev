OPT PREPROCESS

MODULE '*testspeed'
MODULE '*bitmagic'

CONST LOTS_OF_TIMES=100000

#define def_byteswap(a) (Shl((a AND $00FF),8) OR Shr((a AND $FF00),8))

PROC main()
  test({swapproc}, 'Swap bytes using procedure',     LOTS_OF_TIMES)
  test({swapasm},  'Swap bytes using asm procedure', LOTS_OF_TIMES)
  test({swapdef},  'Swap bytes using #define',       LOTS_OF_TIMES)
ENDPROC

PROC swapproc()
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
  proc_byteswap($CAFE)
ENDPROC

PROC swapasm()
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
  pcint($CAFE)
ENDPROC

PROC swapdef()
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
  def_byteswap($CAFE)
ENDPROC

PROC proc_byteswap(a)
  DEF hi,lo,ret
  hi:=a AND $FF00
  lo:=a AND $00FF
  ret:=Shl(lo,8) OR Shr(hi,8)
ENDPROC ret

