/* SelectIcons.e
 * Come realizzare l'effetto del rettangolo di selezione
 * delle icone come sul Workbench
 * Scritto da Marco Talamelli 03-11-95
 */

MODULE 	'exec/ports','intuition/intuition','intuition/screens','tools/macros'

PROC main( )

DEF	x:PTR TO INT,
	y:PTR TO INT,
	class,
	code,
	imsg:PTR TO intuimessage,
	win:PTR TO window,
	scr:PTR TO screen,
   	pattern = $ff00, 
	newpat = $ff00,
   	done = TRUE,
	first = TRUE,
	rect[10]:ARRAY OF INT

rect:=[ 0, 0, 1, 0, 1, 1, 0, 1, 0, 0 ]:INT

   IF scr := LockPubScreen(NIL)

      IF win := OpenWindowTagList( NIL, [ WA_PUBSCREEN, scr,
   					WA_TITLE,        'SelectIcons Demo del 03.11.95',
   					WA_GADGETS,      NIL,
   					WA_AUTOADJUST,   TRUE,
   					WA_WIDTH,        scr.width,
   					WA_INNERHEIGHT,  scr.height,
   					WA_DRAGBAR,      TRUE,
   					WA_DEPTHGADGET,  TRUE,
   					WA_ACTIVATE,     TRUE,
   					WA_CLOSEGADGET,  TRUE,
   					WA_FLAGS,        WFLG_REPORTMOUSE,
   					WA_IDCMP,       IDCMP_CLOSEWINDOW OR
                    					IDCMP_MOUSEBUTTONS OR
                    					IDCMP_MOUSEMOVE OR
                    					IDCMP_INTUITICKS,
   					NIL,         NIL])

   setdrpt( win.rport, pattern )
   SetDrMd( win.rport, 2 )

   WHILE done
      Wait(Shl(1, win.userport.sigbit))

      WHILE imsg := GetMsg( win.userport )
         class := imsg.class
         code := imsg.code
         SELECT class
            CASE  IDCMP_INTUITICKS
                  IF first=FALSE
                     Move( win.rport, rect[0], rect[1] )
                     PolyDraw( win.rport, 5, rect )

                     newpat := Shr(pattern,4)
                     newpat := newpat OR Shl(( pattern AND $000f ), 12)
                     pattern := newpat
                     setdrpt( win.rport, pattern )

                     Move( win.rport, rect[0], rect[1] )
                     PolyDraw( win.rport, 5, rect )
                     ENDIF

            CASE  IDCMP_CLOSEWINDOW
                  done := FALSE

            CASE  IDCMP_MOUSEBUTTONS
                  SELECT  code
                     CASE  SELECTUP
                           first := TRUE
                           Move( win.rport, rect[0], rect[1] )
                           PolyDraw( win.rport, 5, rect )

                     CASE  SELECTDOWN
                           IF  first
                              rect[0] := x
                              rect[6] := x
                              rect[8] := x
                              rect[1] := y
                              rect[3] := y
                              rect[9] := y

                              rect[2] := x
                              rect[4] := x
                              rect[5] := y
                              rect[7] := y

                              first := FALSE

                              Move( win.rport, rect[0], rect[1] )
                              ENDIF
                     ENDSELECT

            CASE  IDCMP_MOUSEMOVE
                  IF first=FALSE
                     rect[2] := x
                     rect[4] := x
                     rect[5] := y
                     rect[7] := y

                     Move( win.rport, rect[0], rect[1] )
                     PolyDraw( win.rport, 5, rect )

                     x := imsg.mousex
                     y := imsg.mousey

                     rect[2] := x
                     rect[4] := x
                     rect[5] := y
                     rect[7] := y

                     Move( win.rport, rect[0], rect[1] )
                     PolyDraw( win.rport, 5, rect )
                  ELSE
                     x := imsg.mousex
                     y := imsg.mousey
                     ENDIF
            ENDSELECT
         ReplyMsg( imsg )
         ENDWHILE
      ENDWHILE
      UnlockPubScreen( NIL, scr )
         CloseWindow( win )
         ENDIF
      ENDIF
ENDPROC
