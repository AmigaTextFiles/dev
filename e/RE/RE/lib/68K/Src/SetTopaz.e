/*
*/
OPT NOHEAD,NOEXE
MODULE 'graphics','graphics/text'
PROC SetTopaz(size)
  DEF font
  IF font:=OpenFont(['topaz.font',size,0,0]:TextAttr) THEN SetFont(stdrast,font)
ENDPROC
