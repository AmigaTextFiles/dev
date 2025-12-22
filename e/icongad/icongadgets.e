;/*
	
	ec icongadgets.e
	run icongadgets
	quit
	
	An easy way to have a nice button bank using icons. Will Harwood.

	Hello! I have been trying for ages to find a simple way of getting a bank
	of image buttons for any programs I might feel like writing. I searched in vain for
	a gadtools command or tag, but then I downloaded a tiny bit of code by Marco 
	Talamelli called ShowIcon and I thought YES! My search is at an end! Once it
	actually worked (see Bugs) I thought to myself, "if only I had found this on the
	Aminet, how much easier my life would have been...", so here it is.

	It also shows using easyrequest, standard intuimessage reading techniques, setting
	the busy pointer on v39+ machines, changing window titles... Beginners: mess about
	with this code as much as possible to learn how it works, because there is no better 
	way of learning a language than crashing your machine.
		
	Since this file was the result of about half an hours typing and a free download
	from the Aminet (isn't Swansea uni nice?), I can hardly start going on about copyrights
	and all that shit, but I will say that if anyone finds this ditty useful then I
	would appreciate an E-mail to lift my spirits in these dark student days of bank loans
	and getting rat-arsed every night (oh it's such a drag ;). And there has to be some-
	one else at Swansea who programs in E, yes? hello? You are not alone?

	The source is pretty self explanatory (and like I know what I'm talking about...), and
	can be dropped almost verbatim into what ever program you chose to write. 

	Requires:
	
		WB 3.0
		Amiga E (I compiled this on 3.2e, but it should work on anything =>3.0)

	To compile and run:
	
		Open a shell window and type icongadgets.e

	Author:
	
		I am ('97 - '00) studying Computer Science at Swansea University, and I would like
		to hear from anyone who is interested in [Amiga] E, or indeed anything from Britpop
		to HIGNFY (I hate loading Pegasus to find that I have no E-mails...). I am espec-
		ially interested in hearing from anyone who can tell me a neat way of loading the
		icon images into a bitmap (i.e. not grabbing the gfx straight off the window), or
		doing the same with datatypes?
		
		(this address is okay until June '98)
		
			Will Harwood
			134 Hendrefoelan Student Village,
			Sketty,
			Swansea,
			SA2 7QG
			UK

		or...
		
			Will Harwood
			618 Dorchester Road,
			Weymouth,
			Dorset.
			DT3 5LH
			UK
		
		E-mail:		
	
		I am but a number...
	
			147800.97@swansea.ac.uk
	
	Bugs:
	
		Just the one, try changing the starting index for objects[] to 0 like it's 
		supposed to be (i.e. change max=1 to max=0 and FOR n:=1 to FOR n:=0) and then 
		watch as it crashes when it Free'sDiskObject. WHY?
		
	Problems:
	
		I suppose it's a fairly inefficient method in terms of disk space and loading time,
		but you can't have everything.
		
 */


MODULE	'workbench/workbench',
			'exec/ports',
			'icon',
			'intuition/screens', 'intuition/intuition',
			'gadtools', 'libraries/gadtools'


CONST MAX_BUTTONS=20, QUIT=21, ABOUT=22		/* gadtools id's should be >MAX_BUTTONS or you
																could end up with two buttons having the same
																id */


PROC main() HANDLE
	DEF win=NIL:PTR TO window, glist=NIL, objects[MAX_BUTTONS]:ARRAY OF diskobject, max=1, n,
		 screen=NIL:PTR TO screen, vi=NIL, gad, x=5, h, w
	
	/* Open libraries */
	IF NIL=(gadtoolsbase:=OpenLibrary('gadtools.library', 39)) THEN 
		Throw("lib", 'main: Could not open gadtools library')
	IF NIL=(iconbase:=OpenLibrary('icon.library', 0)) THEN
		Throw("lib", 'main: Could not open the icon library')
	
	/* grab the public screen and get some visual info */
	IF NIL=(screen:=LockPubScreen(NIL)) THEN Throw("scr", 'main: Could not lock the public screen')
	IF NIL=(vi:=GetVisualInfoA(screen, NIL)) THEN Throw("vi", 'main: Could not getvisualinfo')

	/* create gadget list */
	IF NIL=(gad:=CreateContext({glist})) THEN Throw("gad", 'main: Could not create context')

	/* add some gadtools gadgets */
	gad:=CreateGadgetA(BUTTON_KIND, gad,
                    [5, 69,
                     100, 11,
                     'Quit', NIL,
                     QUIT, 0,
                     vi, NIL]:newgadget,
                    [NIL])

	gad:=CreateGadgetA(BUTTON_KIND, gad,
                    [295, 69,
                     100, 11,
                     'About', NIL,
                     ABOUT, 0,
                     vi, NIL]:newgadget,
                    [NIL])
	
	
	IF NIL=(win:=OpenWindowTagList(0, 
				[WA_INNERWIDTH, 400, WA_INNERHEIGHT, 80,
				 WA_FLAGS, WFLG_GIMMEZEROZERO OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET,
				 WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP OR BUTTONIDCMP OR IDCMP_REFRESHWINDOW,
				 WA_GADGETS, glist,
				 WA_TITLE, 'Icons as gadgets example by Will Harwood',
				 WA_SCREENTITLE, 'Will Harwood, 147800.97@swansea.ac.uk',
				 WA_PUBSCREEN, screen,
				 NIL])) THEN Throw("win", 'main: Could not open window')

 	/* add some buttons: Change the names to any icons (minus .info) you like. */
	w, h:=addiconbutton(win, objects[max], 'Workbench:prefs/ScreenMode', max++, x, 0)
	w, h:=addiconbutton(win, objects[max], 'Workbench:prefs/Font', max++, x:=x+w, 0)
	w, h:=addiconbutton(win, objects[max], 'Workbench:prefs/WBPattern', max++, x:=x+w, 0)
	w, h:=addiconbutton(win, objects[max], 'Workbench:prefs/Time', max++, x:=x+w, 0)
	w, h:=addiconbutton(win, objects[max], 'Workbench:prefs/Locale', max++, x:=x+w, 0)
	w, h:=addiconbutton(win, objects[max], 'Workbench:prefs/Input', max++, x:=x+w, 0)

	/* redraw everything */
	RefreshWindowFrame(win)
	
	REPEAT
	UNTIL handle(win)


EXCEPT DO

	IF exception THEN PrintF('\h \s\n', exception, exceptioninfo)

	/* close gui */
	IF win THEN CloseWindow(win)
	IF glist THEN FreeGadgets(glist)
	IF vi THEN FreeVisualInfo(vi)
	IF screen THEN UnlockPubScreen(NIL, screen)
	
	/* free buttons */
	FOR n:=1 TO max-1
		IF objects[n] THEN FreeDiskObject(objects[n])
	ENDFOR
	
	/* close libraries */
	IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
	IF iconbase THEN CloseLibrary(iconbase)
ENDPROC

PROC addiconbutton(win:PTR TO window, object:PTR TO diskobject, iconname, n, x, y)
	IF NIL=(object:=GetDiskObject(iconname)) THEN Throw("icon", 'addiconbutton: Could not GetGiskObject')
	/* change gadget attributes here. I *think* it's safe to do this, at least it doesn't
		crash... */
	object.gadget.leftedge:=x
	object.gadget.topedge:=y
	object.gadget.gadgetid:=n
	AddGadget(win, object.gadget, NIL)
	/* pass back the width and height so we can fit the gadgets in properly */
ENDPROC object.gadget.width, object.gadget.height

PROC handle(win:PTR TO window)
	DEF msg:PTR TO intuimessage, class, code, gadget:PTR TO gadget, quit=0, id, str[200]:STRING,
		 signals
	
	signals:=Wait(Shl(1, win.userport.sigbit))
	
	IF Shl(1, win.userport.sigbit) AND signals
		WHILE msg:=Gt_GetIMsg(win.userport)
			class:=msg.class
			code:=msg.code
			gadget:=msg.iaddress
			id:=gadget.gadgetid
			Gt_ReplyIMsg(msg)
			
			SELECT class
		   CASE IDCMP_REFRESHWINDOW
         	Gt_BeginRefresh(win)
       		Gt_EndRefresh(win, TRUE)
			CASE IDCMP_CLOSEWINDOW
				quit:=TRUE
			CASE IDCMP_GADGETUP
				IF id=QUIT
					quit:=TRUE
				ELSEIF id=ABOUT
					/* put up a busy pointer with a slight delay (to see why comment the delay
						tags) */
					SetWindowPointerA(win, [WA_BUSYPOINTER, TRUE, WA_POINTERDELAY, TRUE, NIL])
					SetWindowTitles(win, '-- About --', -1)
					EasyRequestArgs(0, 
						[SIZEOF easystruct, 0, 
						 'icongadgets', 
						 'A little example of how you CAN EASILY have\ngadtools image buttons\n\nWill Harwood, 147800.97@swansea.ac.uk', 
						 'Yep'], 0, NIL)	
					/* reset the pointer back to normal */
					SetWindowPointerA(win, [WA_BUSYPOINTER, FALSE, NIL])
					SetWindowTitles(win, 'Icons as gadgets example by Will Harwood', -1)
				ELSE
					/* better than printf */
					StringF(str, 'icon gadget \d clicked', id)
					SetWindowTitles(win, str, -1)
				ENDIF
			CASE IDCMP_VANILLAKEY
				SELECT 256 OF code
				CASE 27, "q", "Q", "å"		/* this should be every variety of quit there is */
					quit:=TRUE
				ENDSELECT
			ENDSELECT
		ENDWHILE
	ENDIF
ENDPROC quit