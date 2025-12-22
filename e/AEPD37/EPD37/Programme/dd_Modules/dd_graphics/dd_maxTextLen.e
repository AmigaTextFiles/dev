OPT MODULE

MODULE 'graphics/text'
MODULE 'graphics/rastport'

EXPORT PROC maxTextLen(stringlist:PTR TO LONG,textfont:PTR TO textfont)
  DEF rastport:rastport,x,max=0
  InitRastPort(rastport)
  SetFont(rastport,textfont)
  ForAll({x},stringlist,`max:=Max(max,TextLength(rastport,x,StrLen(x))))
ENDPROC max

