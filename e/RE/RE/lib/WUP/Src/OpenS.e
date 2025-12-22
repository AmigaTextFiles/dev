OPT	NOEXE,NOHEAD,CPU='WUP'

MODULE	'intuition','intuition/screens','utility/tagitem'

PROC OpenS(wi,he,depth,id,title,tags)
  DEF	screen:PTR TO Screen
  screen:=OpenScreenTags(NIL,
    SA_Width,wi,
    SA_Height,he,
    SA_Depth,depth,
    SA_DisplayID,id,
    SA_Title,title,
    TAG_MORE,tags,
    TAG_END)
ENDPROC screen
