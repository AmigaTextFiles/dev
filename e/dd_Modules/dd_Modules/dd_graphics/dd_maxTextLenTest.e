MODULE '*dd_maxTextLen'

MODULE 'graphics/text'

PROC main()
  DEF textfont,x
  IF textfont:=OpenFont(['topaz.font',8,0,0]:textattr)
    x:=maxTextLen(['New',
                   'Top',
                   'Bottom',
                   'Edit...'],textfont)
    Delay(200)
    CloseFont(textfont)
  ENDIF
  PrintF('max=\d\n',x)
ENDPROC
