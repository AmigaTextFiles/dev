;/*

	ec iconsasgads.e
	run iconsasgads
	quit
	
	Having worked out the basics in icongads, this is my attempt to neaten it into a general
	purpose module INCLUDING code for MUI/Windows-a-like gadget help. WH.
	
	25/10/97  icongads
	26/10/97  Modified and modularised source into newicongads.
	27/10/97  Moved icon and info code into separate modules
	29/10/97	 Tiny improvements, and uploaded it to the Aminet (if Swansea's network hasn't
				 gone down again...)

	
	notes:= Checking and exiting as we go is a lot more readable than huge nested if then else's!

			  I have started the icon.nnn arrays at index 1 rather than 0 because it crashes (or
			  at least did) when even I tried to FreeDiskObject a diskobject with an index of 0.
			  Why I have no idea, but it's hardly a major problem... I hope.

			  If the source looks messy, try changing to a tab size of 3 and reloading.

	
	Requires:
	
		WB 3.0+
		Amiga E (I compiled it on 3.2e, though any version >=3.0 should work)
			  	

	Distribution:
	
		Everything here is PD and so you can use it for whatever you like. However, I would
	appreciate an E-mail if you've found it useful (or if I've made any mistakes), but as
	always it is up to you. 
	
	
	Disclaimer:
	
		It's not my fault blaa-blaa-blaaa.


	Bugs and improvements:
	
		see notes:
		Using fontx as a global variable is a little lazy...
		It could pretty easily be modified to scan the Workbench:Prefs/ directory and
		bring up a dock of preference programs. The point in doing so is doubtful though,
		given the volume of dock programs there are around.
	
	
	Author:
	
		I'm ('97-'00) taking a Degree in Computer Science at Swansea University, and am
	interested in hearing from any one about Amiga E, or indeed anything from Britpop
	to HIGNFY (I hate loading Pegasus to find I have no E-mails...).
	

	Term time address (until June '98):
	
		Will Harwood,
		134 Hendrefoelan Student Village,
		Sketty,
		Swansea.
		SA2 7QG
		U.K.
	
	Home address (this is certain to get to me, but will take longer in term time):
	
		Will Harwood,
		618 Dorchester Road,
		Weymouth,
		Dorset.
		DT3 5LH
		U.K.
	
	E-mail (in term time only):
		
		147800.97@swansea.ac.uk

	
	Help:
	
		Does anyone out there know a neat (i.e. not grabbing the image straight from the
	window) way of loading an icon or datatype picture into a bitmap? Any number of
	programs do it, but I can't for the life of me find out how. HELP!


	Humourous and Overly Long Quote:
	
		"It is amazing how good governments are, given their track record in almost every other
	field, at hushing up things like alien encounters.
		One reason may be that the aliens themselves are too embarrasses to talk about it.
		It's not known why most of the space-going races of the Universe want to undertake
	rummaging in Earthling underwear as a prelude to formal contact. But representatives
	of several hundred alien races have taken to hanging out, unsuspected by one another, in
	rural corners of the planet and, as a result of this, keep on abducting other would-be
	abductees. Some have been in fact abducted while waiting to carry out an abduction
	on a couple of other aliens trying to abduct the aliens who were, as a result of 
	misunderstood instructions, trying to form cattle into circles and mutilate crops.
		The planet Earth is now banned to all alien races until they can compare notes
	and find out how many, if any, real humans thay have actually got. It is gloomily
	suspected that there is only one - who is big, hairy and has very large feet.
		The truth may be out there, but the lies are in your head."
		
					- Hogfather, by the greater deity of humourous writing, Terry Pratchett
	

	Humourless Finish:
	
		Please excuse my spelling/grammar as English is my first language.


	*/

MODULE	'workbench/workbench',
			'exec/ports',
			'icon',
			'intuition/screens', 'intuition/intuition',
			'gadtools', 'libraries/gadtools',
			'graphics/text', 'graphics/gfxbase',
			'*gadgetinfo',
			'*icongadgets'



ENUM GAD_TIME=1, GAD_SCREENMODE, GAD_WBPATTERN, GAD_FONT, GAD_LOCALE, GAD_INPUT,
	  GAD_QUIT, GAD_ABOUT, GAD_ICONTROL, GAD_PRINTER, GAD_PRINTERGFX, GAD_SERIAL,
	  GAD_POINTER,
	  MAX_GADGETS


/*-- Define these objects here AS WELL so we know they are initialised to zero --*/
DEF icon=NIL:PTR TO icongadgets,
	 info=NIL:PTR TO gadgetinfo

DEF gadgets[MAX_GADGETS]:ARRAY OF LONG

DEF fontx=6

PROC main() HANDLE
	DEF screen=NIL:PTR TO screen, vi=0, gad, glist=NIL, w, h, win=NIL:PTR TO window, x=0,
		 gfx:PTR TO gfxbase

	/*- open libraries -*/
	IF NIL=(gadtoolsbase:=OpenLibrary('gadtools.library', 39)) THEN 
		Throw("lib", 'main: Could not open gadtools library')
	IF NIL=(iconbase:=OpenLibrary('icon.library', 0)) THEN
		Throw("lib", 'main: Could not open the icon library')

	/*- Let's get fontx -*/
	gfx:=gfxbase
   fontx:=gfx.defaultfont.xsize

	/*- Get screen -*/
	IF NIL=(screen:=LockPubScreen(NIL)) THEN Throw("scr", 'main: Could not lock the public screen')
	IF NIL=(vi:=GetVisualInfoA(screen, NIL)) THEN Throw("vi", 'main: Could not getvisualinfo')

	/*- Allocate gadget list plus a couple of gadgets (as per normal) -*/
	IF NIL=(gad:=CreateContext({glist})) THEN Throw("gad", 'main: Could not create context')

	gadgets[GAD_QUIT]:=(gad:=CreateGadgetA(BUTTON_KIND, gad,
                    [5, 69,
                     100, 11,
                     'Quit', NIL,
                     GAD_QUIT, 0,
                     vi, NIL]:newgadget,
                    [NIL]))

	gadgets[GAD_ABOUT]:=(gad:=CreateGadgetA(BUTTON_KIND, gad,
                    [295, 69,
                     100, 11,
                     'About', NIL,
                     GAD_ABOUT, 0,
                     vi, NIL]:newgadget,
                    [NIL]))

	/*- open the window -*/
	IF NIL=(win:=OpenWindowTagList(0, 
				[WA_INNERWIDTH, 400, WA_INNERHEIGHT, 80,
				 WA_FLAGS, WFLG_GIMMEZEROZERO OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
				 			  WFLG_REPORTMOUSE OR WFLG_RMBTRAP OR WFLG_ACTIVATE,
				 WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP OR BUTTONIDCMP OR IDCMP_REFRESHWINDOW OR
				 			  IDCMP_GADGETHELP OR IDCMP_MOUSEMOVE OR IDCMP_MOUSEBUTTONS OR IDCMP_INTUITICKS OR
				 			  IDCMP_INACTIVEWINDOW,
				 WA_GADGETS, glist,
				 WA_TITLE, 'Icons as gadgets example by Will Harwood',
				 WA_SCREENTITLE, 'Will Harwood, 147800.97@swansea.ac.uk',
				 WA_PUBSCREEN, screen,
				 NIL])) THEN Throw("win", 'main: Could not open window')

	/*- Initiate the gadgetinfo object -*/
	init_gadgetinfo(win)

	/*- add gadgetinfo's to the About and Quit buttons -*/
	add_gadgetinfo(GAD_ABOUT, 'About the program, author and distribution')
	add_gadgetinfo(GAD_QUIT, 'Quits the program')

	/*- Allocate and initiate the icongadget object -*/
	init_icongadgets(win)

	/*- Add the icon buttons. Automatically adds gadgetinfo. -*/
 	w, h:=add_icongadget(GAD_TIME, 'Workbench:prefs/Time', 'The time preference program', x:=x+w, 0)
 	w, h:=add_icongadget(GAD_SCREENMODE, 'Workbench:prefs/ScreenMode', 'The ScreenMode preference program', x, 0)
 	w, h:=add_icongadget(GAD_WBPATTERN, 'Workbench:prefs/WBPattern', 'The WBPattern preference program', x:=x+w, 0)
 	w, h:=add_icongadget(GAD_FONT, 'Workbench:prefs/Font', 'The Font preference program', x:=x+w, 0)
 	w, h:=add_icongadget(GAD_LOCALE, 'Workbench:prefs/Locale', 'The Locale preference program', x:=x+w, 0)
 	w, h:=add_icongadget(GAD_INPUT, 'Workbench:prefs/Input', 'The Input preference program', x:=x+w, 0)

	w, h:=add_icongadget(GAD_ICONTROL, 'Workbench:Prefs/IControl', 'The IControl preference program', x:=w, h)
	w, h:=add_icongadget(GAD_PRINTER, 'Workbench:Prefs/Printer', 'The Printer preference program', x:=x+w, h)
	w, h:=add_icongadget(GAD_PRINTERGFX, 'Workbench:Prefs/PrinterGFX', 'The PrinterGFX preference program', x:=x+w, h)
	w, h:=add_icongadget(GAD_SERIAL, 'Workbench:Prefs/Serial', 'The Serial preference program', x:=x+w, h)
	w, h:=add_icongadget(GAD_POINTER, 'Workbench:Prefs/Pointer', 'The Pointer preference program', x:=x+w, h)

	/*- redraw -*/
	RefreshWindowFrame(win)

	/*- The main loop repeats until handle returns true -*/
	REPEAT
	UNTIL handle(win)
	
EXCEPT DO
	/*- Print the error, if there has been one -*/
	IF exception THEN PrintF('\h \s\n', exception, exceptioninfo)

	/*- Close the gui -*/
	IF win THEN CloseWindow(win)
	IF glist THEN FreeGadgets(glist)
	IF vi THEN FreeVisualInfo(vi)
	IF screen THEN UnlockPubScreen(NIL, screen)

	/*- Free the icon gadgets -*/
	end_icongadgets()
	/*- Free the icon info stuff -*/
	end_gadgetinfo()
	
	/*- close libraries and end -*/
	IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
	IF iconbase THEN CloseLibrary(iconbase)
ENDPROC

/*- A standard intuition message handler -*/
PROC handle(win:PTR TO window)
	DEF msg:PTR TO intuimessage, class, code, gadget:PTR TO gadget, quit=0,
		 signals, id
	
	signals:=Wait(Shl(1, win.userport.sigbit))
	
	IF Shl(1, win.userport.sigbit) AND signals
		WHILE msg:=Gt_GetIMsg(win.userport)
			class:=msg.class
			code:=msg.code
			gadget:=msg.iaddress
			id:=gadget.gadgetid
			Gt_ReplyIMsg(msg)

			SELECT class
			CASE IDCMP_MOUSEMOVE
				/*-- We have to tell gadgetinfo.m that the mouse has moved, and provide it the mouse
					  coords (if you aren't using a WFLG_GIMMEZEROZERO screen then this will be win.
					  mousex, win.mousey) so it can check whether we are over a gadget. There is probably
					  an IDCMP tag which will do tell me this... ---*/
				set_gadgetinfo(win, win.gzzmousex, win.gzzmousey)
				
			CASE IDCMP_INTUITICKS
				/*-- Tell gadgetinfo.m that a tick (about 1/10 of a second) has gone by). These are
					  the only things you have to add to the handler code to get it working! ---*/
				do_gadgetinfo(-2)
				
		   CASE IDCMP_REFRESHWINDOW
         	Gt_BeginRefresh(win)
       		Gt_EndRefresh(win, TRUE)

			CASE IDCMP_CLOSEWINDOW
				quit:=TRUE

			CASE IDCMP_GADGETUP
				SELECT id
				CASE GAD_ABOUT
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
				
				CASE GAD_QUIT
					quit:=TRUE
	
				/*-- The gadgetinfo code could quite easily be extended to do this automatically
					  (adding a loadprog string into the object, forinstance). 
					    If you only want one program to run at a time, then change the Execute()
					  line to something like this:
					  
							  SetWindowPointerA(win, [WA_BUSYPOINTER, TRUE, NIL])
							  Execute('workbench:prefs/time', 0, 0)
							  SetWindowPointerA(win, [WA_BUSYPOINTER, FALSE, NIL])
				   --*/

				CASE GAD_TIME
					Execute('run workbench:prefs/time', 0, 0)

				CASE GAD_SCREENMODE
					Execute('run workbench:prefs/screenmode', 0, 0)
			
				CASE GAD_WBPATTERN
					Execute('run workbench:prefs/wbpattern', 0, 0)

				CASE GAD_FONT
					Execute('run workbench:prefs/font', 0, 0)

				CASE GAD_LOCALE
					Execute('run workbench:prefs/locale', 0, 0)

				CASE GAD_INPUT
					Execute('run workbench:prefs/input', 0, 0)

				CASE GAD_PRINTER
					Execute('run workbench:prefs/Printer', 0, 0)

				CASE GAD_PRINTERGFX
					Execute('run workbench:prefs/printergfx', 0, 0)

				CASE GAD_SERIAL
					Execute('run workbench:prefs/serial', 0, 0)

				CASE GAD_ICONTROL
					Execute('run workbench:prefs/Icontrol', 0, 0)

				CASE GAD_POINTER
					Execute('run workbench:prefs/pointer', 0, 0)

				ENDSELECT
				
			CASE IDCMP_VANILLAKEY
				SELECT 256 OF code
				CASE 27, "q", "Q", "å"		/* this should be every variety of quit there is */
					quit:=TRUE
				ENDSELECT

			ENDSELECT
		ENDWHILE
	ENDIF
ENDPROC quit
