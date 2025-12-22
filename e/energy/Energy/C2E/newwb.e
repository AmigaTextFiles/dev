/*
		Nome del programma . . . WBench Creator ( NewWb.e )
		Autore . . . . . . . . . Marco Talamelli
		Linguaggio . . . . . . . Amiga E
		Hardware . . . . . . . . Amiga in qualsiasi configurazione
*/

MODULE 	'exec/types',
	'intuition/intuition',
	'dos/dos',
	'exec/ports',
	'intuition/iobsolete',
	'graphics/view',
	'intuition/screens'

DEF	screen:PTR TO screen,scr:PTR TO screen,
	window:PTR TO window,
	newscr:ns,
	newwin:nw,
	view:PTR TO view,
	vp:PTR TO viewport

PROC main()

DEF	c,s,a,w,o,n,l

	/* Ricava la view */
	view:=ViewAddress()

        	SELECT arg
			/* Uso */
			CASE '?'
				uso()
				
			/* Apre una finestra CLI */
			CASE 's'
				s:=1

			/* Carica il Workbench */
			CASE 'w'
				w:=1
						
			/* Rende attivo il nuovo workbench screen */
			CASE '0' /* Chiude subito il vecchio workbench screen */
				c:=1

			CASE '1' /* Aspetta che l'utente chiuda il vecchio WB screen */
				a:=1
			
			/* Interlacciato */
			CASE 'l'
				newscr.viewmodes:=V_HIRES OR V_LACE
				newscr.height:=512
				l:=1
				
			/* 8 colori */
			CASE 'c'
				newscr.depth:=3
				
			/* Screen NTSC  */
			CASE 'n'
				newscr.height:=200
				n:=1;
				
			/* Overscan */
			CASE 'o'
				newscr.width:=704
				newscr.height:=283
				o:=1
		ENDSELECT

	/* Imposta le dimensioni dello schermo secondo le opzioni scelte */
	IF (n AND l)	THEN  newscr.height:=400
	IF (l AND o)	THEN  newscr.height:=566
	IF (n AND o)	THEN  newscr.height:=241
	IF (n AND l AND o)THEN  newscr.height:=482

	/* Apre la window per chiudere lo screen sul vecchio screen */
	IF (a) THEN window:=OpenWindow([485,0,100,10, 0,1,CLOSEWINDOW,
	WINDOWCLOSE OR ACTIVATE,NIL,NIL,'Close WB',NIL,NIL,
	0,0,0,0,WBENCHSCREEN]:nw)

	/* Apre il nuovo Workbench */
	screen:=OpenScreen([0,0,640,256,2,0,1,V_HIRES,WBENCHSCREEN,NIL,
	'WBench Creator 1.0 - by Marco Talamelli - ',NIL,NIL]:ns)

	vp:=screen.viewport /* Ricava la viewport dello screen */

/* Se si vuole uno screen overscan, il nuovo screen è centrato sul monitor */
	IF (o)
		view.dxoffset:=110
		view.dyoffset:=27
		RemakeDisplay()
	ENDIF
	
	/* Se si sono usate le opzioni S o W vengono eseguiti i comandi 
       Loadwb o newcli nel nuovo screen */
	IF (w) THEN Execute('Loadwb',0,0)
	IF (s) THEN Execute('Newcli',0,0)
	
	IF (arg<>a)
		/* Puntatore allo screen in cui deve comparire la finestra */
		newwin.screen:=screen
		window:=OpenWindow([485,0,100,10, 0,1,CLOSEWINDOW,
	WINDOWCLOSE OR ACTIVATE,NIL,NIL,'Close WB',NIL,NIL,
	0,0,0,0,WBENCHSCREEN]:nw) /* Apre la finestra */

		/* Aspetta che l'utente selezioni il close gadget e chiude window
           e screen */
		Wait(Shl(1,window.userport.sigbit)) 
		CloseWindow(window)
		CloseScreen(screen)
	ELSE
		/* Chiude il vecchio screen aspettando che l'utente selezioni il 
			close gadget se si è usata l'opzione 1 */
		IF (arg<>c) THEN Wait(Shl(1,window.userport.sigbit))
		scr:=window.wscreen
		CloseWindow(window)
		CloseScreen(scr)
	ENDIF
ENDPROC

PROC uso()

	WriteF(' Workbench Creator v1.0 - by Marco Talamelli. \n\n')
	WriteF(' Uso: \n\n')
	WriteF('   NewWB s w 0 1 l c n o \n\n')
	WriteF(' s = NewCLI nel nuovo screen.\n')
	WriteF(' w = LoadWB nel nuovo screen.\n')
	WriteF(' 0 = Il nuovo screen è attivo e il vecchio è chiuso.\n')
	WriteF(' 1 = Il nuovo screen è attivo e il vecchio può essere chiuso dall\autente.\n')
	WriteF(' l = Nuovo screen interlacciato.\n')
	WriteF(' c = Nuovo screen 8 colori.\n')
	WriteF(' n = Nuovo screen NTSC.\n')
	WriteF(' o = Nuovo screen overscan.\n\n')
ENDPROC
