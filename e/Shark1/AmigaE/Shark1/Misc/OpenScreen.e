MODULE 'intuition/screens',
       'graphics/view'

ENUM ERR_NONE, ERR_SCRN

RAISE ERR_SCRN IF OpenS()=NIL

PROC main() HANDLE

  DEF my_screen=NIL:PTR TO screen

  my_screen:=OpenS(640,
                   STDSCREENHEIGHT,
                   2,
                   V_HIRES,
                   'My Screen',
                  [SA_PENS, [-1]:INT,
                   SA_DETAILPEN, 0,
                   SA_BLOCKPEN,  1,
                   NIL])
  Delay(200)
EXCEPT DO
  IF my_screen THEN CloseS(my_screen)
  SELECT exception
  CASE ERR_SCRN; WriteF('Error: Failed to open custom screen\n')
  ENDSELECT
ENDPROC
