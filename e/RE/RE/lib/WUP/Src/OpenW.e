OPT	NOEXE,NOHEAD,CPU='WUP'

MODULE	'intuition','intuition/intuition'

PROC OpenW(x,y,wi,he,idcmp,flags,title,screen,stype,gadgets,tags)(L)
  DEF	window:PTR TO Window
  window:=OpenWindowTags(NIL,
    WA_Left,x,
    WA_Top,y,
    WA_Width,wi,
    WA_Height,he,
    WA_IDCMP,idcmp,
    WA_Flags,flags,
    WA_Title,title,
    IF screen<>0 THEN WA_CustomScreen ELSE TAG_IGNORE,screen,
    ->stype not (yet) implemented
    WA_Gadgets,gadgets,
    TAG_MORE,tags,
    TAG_END)
  IF window THEN stdrast:=window.RPort
ENDPROC window

