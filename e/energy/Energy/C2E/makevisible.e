/*
 * makevisible.e - mostra la caratteristica di SPOS_MAKEVISIBLE
 *
 *  Marco Talamelli 22-10-1995
 *
 * Apre uno schermo sovradimensionato autoscroll.  Usa il mouse per disegnare
 * un rettangolo sullo schermo.  Allora, usare il mouse per scrollare lo schermo
 * ovunque ti piace.  Premere qualsiasi key per muovere il rettangolo disegnato
 * in vista usando ScreenPosition( sc, SPOS_MAKEVISIBLE, ... ).
 *
 * La caratteristica di SPOS_MAKEVISIBLE può essere utile per assicurare che
 * certe aree sono visibili, per esempio il cursore di un Word-Processor.
 *
 * Premi "Q" o <Esc> per uscire.
 *
 */

OPT PREPROCESS

MODULE 	'intuition/intuition',  -> Intuition data structures and tags
       	'intuition/screens',    -> Screen data structures and tags
       	'graphics/modeid',      -> Release 2 Amiga display mode ID's
       	'exec/memory',          -> Memory flags
       	'graphics/gfx',         -> Bitmap and other structures
       	'graphics/rastport',    -> RastPort and other structures
       	'graphics/view',        -> ViewPort and other structures
	'intuition/iobsolete',
	'graphics/gfxmacros',
	'exec/ports'

ENUM ERR_NONE, ERR_SCRN, ERR_WIN, AREAOUTLINE = 8

RAISE ERR_SCRN   IF OpenScreenTagList()=NIL,
      ERR_WIN    IF OpenWindowTagList()=NIL

PROC main() HANDLE

  DEF 	win=NIL:PTR TO window,
	finito = TRUE,
	dragging = FALSE,
	scr=NIL:PTR TO screen,
	disegna:rectangle,
	trascina:rectangle,
	imsg:PTR TO intuimessage,
	class,code

  -> E-Nota: E apre automaticamente le librerie Intuition e Graphics

  scr:=OpenScreenTagList(NIL,
                        [SA_DISPLAYID,  LORES_KEY,
			SA_OVERSCAN, OSCAN_TEXT,
					/*  Altri tags possono andare qui: */
			SA_WIDTH, 900,
			SA_HEIGHT, 600,
			SA_DEPTH, 2,
			SA_AUTOSCROLL, 1,
			SA_PENS,[0,1,1,2,1,3,2,0,2,1,2,1,-1]:INT,
			SA_TITLE, 'Disegna un rettangolo con il mouse. Scrolla lo schermo. Premi un key per riportarlo in vista. <Esc> per uscire.',
                         NIL])
  win:=OpenWindowTagList(NIL,
                        [WA_BORDERLESS, TRUE,
			WA_BACKDROP, TRUE,
			WA_IDCMP, MOUSEBUTTONS OR VANILLAKEY,
			WA_NOCAREREFRESH, TRUE,
			WA_ACTIVATE, TRUE,
			WA_SMARTREFRESH, TRUE,
			WA_CUSTOMSCREEN, scr,
                         		NIL])

    disegna.minx := 20
    disegna.miny := 20
    disegna.maxx := 150
    disegna.maxy := 100

    SetABPenDrMd( win.rport, 3, 0, RP_COMPLEMENT )
    SetOPen(win.rport,1)
    RectFill( win.rport, disegna.minx, disegna.miny,
	disegna.maxx, disegna.maxy )

    WHILE finito

	Wait( Shl(1,win.userport.sigbit))
	WHILE  imsg := GetMsg( win.userport )

	class:=imsg.class
	code:=imsg.code
	    SELECT class

	    CASE VANILLAKEY
			SELECT code
				CASE "Q";	finito := FALSE
				CASE "q";	finito := FALSE
				CASE 27;	finito := FALSE
			DEFAULT
ScreenPosition( scr, SPOS_MAKEVISIBLE,disegna.minx, disegna.miny,disegna.maxx, disegna.maxy )
			ENDSELECT

	    CASE MOUSEBUTTONS

		    IF ( imsg.mousex < 0 ) THEN imsg.mousex := 0
		    IF ( imsg.mousex >= scr.width ) THEN imsg.mousex := scr.width - 1
		    IF ( imsg.mousey < 0 ) THEN imsg.mousey := 0
		    IF ( imsg.mousey >= scr.height ) THEN imsg.mousey := scr.height - 1

		    IF ( code = SELECTDOWN )
			dragging := TRUE
			trascina.minx := imsg.mousex
			trascina.miny := imsg.mousey

		    ELSEIF (( code = SELECTUP ) AND ( dragging ))

			dragging := FALSE
			IF ( imsg.mousex > trascina.minx )
			    trascina.maxx := imsg.mousex
			ELSE

			    trascina.maxx := trascina.minx
			    trascina.minx := imsg.mousex
			ENDIF
			IF ( imsg.mousey > trascina.miny )

			    trascina.maxy := imsg.mousey

			ELSE
			    trascina.maxy := trascina.miny
			    trascina.miny := imsg.mousey
			ENDIF
			SetOPen( win.rport, 0 )
			RectFill( win.rport, disegna.minx, disegna.miny,
			    disegna.maxx, disegna.maxy )

			    disegna.minx := trascina.minx
			    disegna.miny := trascina.miny
			    disegna.maxx := trascina.maxx
			    disegna.maxy := trascina.maxy

			SetOPen( win.rport, 1 )
			RectFill( win.rport, disegna.minx, disegna.miny,
			    disegna.maxx, disegna.maxy )
		    ENDIF

	    ENDSELECT
	    ReplyMsg( imsg )
	ENDWHILE
    ENDWHILE

EXCEPT DO
  IF win THEN CloseWindow(win)
  IF scr THEN CloseScreen(scr)
    SELECT exception
      CASE ERR_SCRN;   request('Errore: Fallito nel aprire lo schermo personale\n','Uscita',NIL)
      CASE ERR_WIN;    request('Errore: Fallito nel aprire la finestra\n','Uscita',NIL)
    ENDSELECT
ENDPROC

PROC request(corpo,gadget,argomenti)
ENDPROC EasyRequestArgs(0,[20,0,0,corpo,gadget],0,argomenti)
