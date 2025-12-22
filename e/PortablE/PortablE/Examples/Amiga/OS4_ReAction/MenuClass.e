/* An AmigaOS4.1FE SDK example converted to PortablE.
   From SDK:Examples/GUI/MenuClass/MenuClass.c
*/
OPT POINTER, PREPROCESS
MODULE 'exec', 'dos', 'intuition'
MODULE 'diskfont', 'utility', 'window', 'layout' /*, 'button', 'bitmap'*/
MODULE 'target/reaction/reaction_macros', 'graphics/text', 'classes/window', 'gadgets/layout', 'gadgets/button', 'images/bitmap'

ENUM MID_PROJECT = 1,  /* Zero is an invalid value for a menu ID */
	MID_OPEN,
	MID_SAVE,
	MID_SAVEAS,
	MID_ICONIFY,
	MID_ABOUT,
	MID_QUIT,
	
	MID_EXTRAS,
	MID_SUBMENU,
	MID_TOGGLEIMAGE,
	MID_SHOWMENU,
	MID_HIDEMENU,
	MID_SHOWITEMS,
	MID_HIDEITEMS,
	MIDMAX
CONST MID_AUTO_BASE = 1000

TYPE PTIO IS PTR TO INTUIOBJECT

RAISE "LIB" IF OpenLibrary() = NIL

CONST BUFFER_SIZE = 128

PROC main() RETURNS ret
	DEF windowobj:PTIO, layoutobj:PTIO, displayobj:PTIO
	DEF menustripobj:PTIO
	DEF project_menuobj:PTIO, parent:PTIO, obj:PTIO
	DEF showmenu_itemobj:PTIO, hidemenu_itemobj:PTIO
	DEF showitems_itemobj:PTIO, hideitems_itemobj:PTIO
	DEF imageobj[2]:ARRAY OF PTIO
	DEF tta:PTR TO ttextattr
	DEF dri:PTR TO drawinfo
	DEF scr:PTR TO screen
	DEF win:PTR TO window
	DEF port:PTR TO mp
	DEF which_image
	DEF waitmask, input, id
	DEF code:INT
	DEF buffer[BUFFER_SIZE]:ARRAY OF CHAR
	DEF label:STRPTR
	DEF hidden:BOOL
	DEF done:BOOL
	
	which_image := 0
	id := MID_AUTO_BASE
	done := FALSE
	
	ret := RETURN_ERROR
	
	diskfontbase := OpenLibrary('diskfont.library', 0)
	utilitybase := OpenLibrary('utility.library', 0)
	windowbase := OpenLibrary('window.class', 0)
	layoutbase := OpenLibrary('gadgets/layout.gadget', 0)
	
	IF (intuitionbase.version > 54) OR ((intuitionbase.version = 54) AND (intuitionbase.revision >= 6)) = FALSE
		Print('This program requires at least version 54.6 of intuition.library.\n')
		RETURN
	ENDIF
	
	port := AllocSysObject(ASOT_PORT,NILA)
	
	IF scr := LockPubScreen('Workbench')
		/* Load a couple of images, to be freed manually
		 * on program termination.
		 */
		imageobj[0] := menuImage('flaggreen',scr)  !!PTR!!PTR TO INTUIOBJECT
		imageobj[1] := menuImage('flagyellow',scr) !!PTR!!PTR TO INTUIOBJECT
		
		/* Try defining slightly bigger version of the
		 * Workbench screen's current font, to be used
		 * as the font for a menu item.
		 */
		IF dri := GetScreenDrawInfo(scr)
			tta := ObtainTTextAttr(dri.font)
			IF tta THEN tta.ysize := tta.ysize + 10
			FreeScreenDrawInfo(scr,dri)
		ENDIF
		
		/* Build the whole menu tree. By assigning an ID
		 * also to the menu title objects, we allow the
		 * user to ask for help on them as well, instead
		 * of only being able to do so on the menu items.
		 *
		 * Also, for the sake of this example, we assign
		 * automatically generated non-zero IDs to some
		 * items we don't need to properly identify when
		 * they get selected.
		 */
		menustripobj := MStrip,
			MA_ADDCHILD, MTitle('Project'),
				MA_ID, MID_PROJECT,
				MA_ADDCHILD, MItem('O|Open...'),
					MA_ID, MID_OPEN,
					MA_IMAGE, menuImage('open',scr),
				MEnd,
				
				MA_ADDCHILD, MSeparator,
				MEnd,
				
				MA_ADDCHILD, MItem('S|Save'),
					MA_ID, MID_SAVE,
					MA_IMAGE, menuImage('save',scr),
				MEnd,
				
				MA_ADDCHILD, MItem('A|Save as...'),
					MA_ID, MID_SAVEAS,
					MA_IMAGE, menuImage('saveas',scr),
				MEnd,
				
				MA_ADDCHILD, MSeparator,
				MEnd,
				
				MA_ADDCHILD, MItem('I|Iconify'),
					MA_ID, MID_ICONIFY,
					MA_IMAGE, menuImage('iconify',scr),
				MEnd,
				
				MA_ADDCHILD, MItem('?|About...'),
					MA_ID, MID_ABOUT,
					MA_IMAGE, menuImage('info',scr),
				MEnd,
				
				MA_ADDCHILD, MSeparator,
				MEnd,
				
				MA_ADDCHILD, MItem('Q|Quit'),
					MA_ID, MID_QUIT,
					MA_IMAGE, menuImage('quit',scr),
				MEnd,
			MEnd,
			
			MA_ADDCHILD, MTitle('Extras'),
				MA_ID, MID_EXTRAS,
				MA_ADDCHILD, MItem('Sub-menu example'),
					MA_ID, MID_SUBMENU,
					MA_ADDCHILD, MItem('As you can'),
						MA_ID, id++,
					MEnd,
					MA_ADDCHILD, MItem('see from'),
						MA_ID, id++,
						MA_ADDCHILD, MItem('this example,'),
							MA_ID, id++,
						MEnd,
						MA_ADDCHILD, MItem('there is'),
							MA_ID, id++,
							MA_ADDCHILD, MItem('virtually no'),
								MA_ID, id++,
							MEnd,
							MA_ADDCHILD, MItem('limit to'),
								MA_ID, id++,
								MA_ADDCHILD, MItem('how many sub-menu'),
									MA_ID, id++,
								MEnd,
								MA_ADDCHILD, MItem('levels you can'),
									MA_ID, id++,
									MA_ADDCHILD, MItem('have with'),
										MA_ID, id++,
									MEnd,
									MA_ADDCHILD, MItem('Intuition'),
										MA_ID, id++,
										MA_ADDCHILD, MItem('when using its new'),
											MA_ID, id++,
										MEnd,
										MA_ADDCHILD, MItem('BOOPSI menu class.'),
											MA_ID, id++,
											MA_TEXTATTR, tta,
										MEnd,
									MEnd,
								MEnd,
							MEnd,
						MEnd,
					MEnd,
				MEnd,
				
				MA_ADDCHILD, MSeparator,
				MEnd,
				
				MA_ADDCHILD, MItem('Toggle this image'),
					MA_ID, MID_TOGGLEIMAGE,
					MA_IMAGE, imageobj[which_image],
					MA_FREEIMAGE, FALSE,
				MEnd,
				
				MA_ADDCHILD, MSeparator,
				MEnd,
				
				MA_ADDCHILD, MItem('Show Project menu'),
					MA_ID, MID_SHOWMENU,
					MA_HIDDEN, TRUE,
				MEnd,
				
				MA_ADDCHILD, MItem('Hide Project menu'),
					MA_ID, MID_HIDEMENU,
				MEnd,
				
				MA_ADDCHILD, MSeparator,
				MEnd,
				
				MA_ADDCHILD, MItem('Show dummy items'),
					MA_ID, MID_SHOWITEMS,
					MA_HIDDEN, TRUE,
				MEnd,
				
				MA_ADDCHILD, MItem('Hide dummy items'),
					MA_ID, MID_HIDEITEMS,
				MEnd,
				
				MA_ADDCHILD, MSeparator,
				MEnd,
				
				MA_ADDCHILD, MItem('Dummy item #1'),
					MA_ID, id++,
				MEnd,
				
				MA_ADDCHILD, MItem('Dummy item #2'),
					MA_ID, id++,
				MEnd,
				
				MA_ADDCHILD, MItem('Dummy item #3'),
					MA_ID, id++,
				MEnd,
			MEnd,
		MEnd
		
		UnlockPubScreen(NILA,scr)
	ENDIF
	
	layoutobj := VGroupObject,
		LAYOUT_DEFERLAYOUT, TRUE,
		LAYOUT_SPACEOUTER, TRUE,
		LAYOUT_FIXEDVERT, FALSE,
		LAYOUT_ADDCHILD, displayobj := ButtonObject,
			GA_READONLY, TRUE,
		ButtonEnd,
		CHILD_WEIGHTEDHEIGHT, 0,
		
		LAYOUT_ADDCHILD, HGroupObject,
			LAYOUT_EVENSIZE, TRUE,
			LAYOUT_HORIZALIGNMENT, LALIGN_CENTER,
			LAYOUT_ADDCHILD, ButtonObject,
				GA_ID, 1,
				GA_RELVERIFY, TRUE,
				GA_TEXT, 'Quit test',
			ButtonEnd,
			CHILD_WEIGHTEDWIDTH, 0,
		EndGroup,
		CHILD_WEIGHTEDHEIGHT, 0,
		CHILD_MINWIDTH, 350,
	EndGroup
	
	windowobj := WindowObject,
		WA_PUBSCREENNAME, 'Workbench',
		WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP OR IDCMP_MENUPICK OR IDCMP_MENUHELP,
		WA_ACTIVATE, TRUE,
		WA_CLOSEGADGET, TRUE,
		WA_TITLE, 'BOOPSI menu class test',
		WA_DRAGBAR, TRUE,
		WA_DEPTHGADGET, TRUE,
		WA_SIZEGADGET, TRUE,
		WA_MENUHELP, TRUE,
		
		WINDOW_POSITION, WPOS_CENTERSCREEN,
		WINDOW_ICONIFYGADGET, port<>NIL,
		WINDOW_POPUPGADGET, TRUE,
		WINDOW_JUMPSCREENSMENU, TRUE,
		WINDOW_APPPORT, port,
		WINDOW_PARENTGROUP, layoutobj,
		WINDOW_MENUSTRIP, menustripobj,
	WindowEnd
	
	IF menustripobj
		project_menuobj := IdoMethod(menustripobj,MM_FINDID,0,MID_PROJECT) !!PTR!!PTR TO INTUIOBJECT
		showmenu_itemobj := IdoMethod(menustripobj,MM_FINDID,0,MID_SHOWMENU) !!PTR!!PTR TO INTUIOBJECT
		hidemenu_itemobj := IdoMethod(menustripobj,MM_FINDID,0,MID_HIDEMENU) !!PTR!!PTR TO INTUIOBJECT
		showitems_itemobj := IdoMethod(menustripobj,MM_FINDID,0,MID_SHOWITEMS) !!PTR!!PTR TO INTUIOBJECT
		hideitems_itemobj := IdoMethod(menustripobj,MM_FINDID,0,MID_HIDEITEMS) !!PTR!!PTR TO INTUIOBJECT
	ENDIF
	
	IF windowobj
		IF win := RA_OpenWindow(windowobj)
			GetAttr(WINDOW_SIGMASK,windowobj,ADDRESSOF waitmask)
			
			/* Event handling */

			WHILE done = FALSE
				Wait(waitmask)
				
				WHILE (input := RA_HandleInput(windowobj,ADDRESSOF code)) <> WMHI_LASTMSG
					SELECT input AND WMHI_CLASSMASK
						CASE WMHI_CLOSEWINDOW
							done := TRUE
							
						CASE WMHI_ICONIFY
							RA_Iconify(windowobj)
							
						CASE WMHI_UNICONIFY
							win := RA_OpenWindow(windowobj)
							GetAttr(WINDOW_SIGMASK,windowobj,ADDRESSOF waitmask)
							IF win = NIL THEN done := TRUE
							
						CASE WMHI_JUMPSCREEN
							RA_CloseWindow(windowobj)
							win := RA_OpenWindow(windowobj)
							GetAttr(WINDOW_SIGMASK,windowobj,ADDRESSOF waitmask)
							IF win
								ScreenToFront(win.wscreen)
							ELSE
								done := TRUE
							ENDIF
							
						CASE WMHI_MENUPICK
							id := NO_MENU_ID
							
							WHILE (id := IdoMethod(menustripobj,MM_NEXTSELECT,0,id)) <> NO_MENU_ID
								obj := IdoMethod(menustripobj,MM_FINDID,0,id) !!PTR!!PTR TO INTUIOBJECT
								
								IF obj
									GetAttr(MA_LABEL,obj,ADDRESSOF label)
									IF InStr(label,'|') <> -1 THEN label := label + (2*SIZEOF CHAR)
									SnPrintf(buffer,BUFFER_SIZE,'Menu selection: "\s"',label)
									SetGadgetAttrsA(displayobj !!PTR!!PTR TO gadget,win,NIL,[GA_TEXT,buffer,TAG_END]:tagitem)
								ENDIF
								
								SELECT MIDMAX OF id
									CASE MID_ICONIFY
										RA_Iconify(windowobj)
										
									CASE MID_QUIT
										done := TRUE
										
									CASE MID_TOGGLEIMAGE
										which_image := 1 - which_image
										SetAttrsA(obj,[MA_IMAGE,imageobj[which_image],TAG_END]:tagitem)
										
									CASE MID_SHOWMENU, MID_HIDEMENU
										hidden := (id = MID_HIDEMENU)
										IF showmenu_itemobj THEN SetAttrsA(showmenu_itemobj,[MA_HIDDEN,NOT hidden,TAG_END]:tagitem)
										IF hidemenu_itemobj THEN SetAttrsA(hidemenu_itemobj,[MA_HIDDEN,hidden,TAG_END]:tagitem)
										IF project_menuobj  THEN SetAttrsA(project_menuobj, [MA_HIDDEN,hidden,TAG_END]:tagitem)
										
									CASE MID_SHOWITEMS, MID_HIDEITEMS
										hidden := (id = MID_HIDEITEMS)
										IF showitems_itemobj THEN SetAttrsA(showitems_itemobj,[MA_HIDDEN,NOT hidden,TAG_END]:tagitem)
										IF hideitems_itemobj THEN SetAttrsA(hideitems_itemobj,[MA_HIDDEN,hidden,TAG_END]:tagitem)
										
										GetAttr(MA_PARENT,showitems_itemobj,ADDRESSOF parent)
										obj := hideitems_itemobj
										
										WHILE obj := IdoMethod(parent,MM_NEXTCHILD,0,obj) !!PTR!!PTR TO INTUIOBJECT
											SetAttrsA(obj,[MA_HIDDEN,hidden,TAG_END]:tagitem)
										ENDWHILE
								ENDSELECT
							ENDWHILE
							
						CASE WMHI_MENUHELP
							GetAttr(MA_MENUHELPID,menustripobj,ADDRESSOF id)
							
							IF id <> NO_MENU_ID
								obj := IdoMethod(menustripobj,MM_FINDID,0,id) !!PTR!!PTR TO INTUIOBJECT
								
								IF obj
									GetAttr(MA_LABEL,obj,ADDRESSOF label)
									IF InStr(label,'|') <> -1 THEN label := label + (2*SIZEOF CHAR)
									SnPrintf(buffer,BUFFER_SIZE,'Help requested for: "%s"',label)
									SetGadgetAttrsA(displayobj !!PTR!!PTR TO gadget,win,NIL,[GA_TEXT,buffer,TAG_END]:tagitem)
								ENDIF
							ELSE
								AstrCopy(buffer,'HELP requested while no menu or item was selected',BUFFER_SIZE)
								SetGadgetAttrsA(displayobj !!PTR!!PTR TO gadget,win,NIL,[GA_TEXT,buffer,TAG_END]:tagitem)
							ENDIF
							
						CASE WMHI_GADGETUP
							SELECT id := (input AND WMHI_GADGETMASK)
								CASE 1
									done := TRUE
							ENDSELECT
					ENDSELECT
				ENDWHILE
			ENDWHILE
		ENDIF
	ENDIF
	
	ret := RETURN_OK
FINALLY
	PrintException()
	
	IF win THEN RA_CloseWindow(windowobj)
	IF windowobj THEN DisposeObject(windowobj)
	
	IF menustripobj THEN DisposeObject(menustripobj)
	
	IF imageobj[0] THEN DisposeObject(imageobj[0])
	IF imageobj[1] THEN DisposeObject(imageobj[1])
	
	IF tta THEN FreeTTextAttr(tta)
	
	IF port THEN FreeSysObject(ASOT_PORT,port)
	
	IF diskfontbase THEN CloseLibrary(diskfontbase)
	IF utilitybase THEN CloseLibrary(utilitybase)
	IF windowbase THEN CloseLibrary(windowbase)
	IF layoutbase THEN CloseLibrary(layoutbase)
ENDPROC

PROC menuImage(name:ARRAY OF CHAR, screen:PTR TO screen) RETURNS image:PTR TO image
	DEF prev_win:APTR, dir:BPTR, prev_dir:BPTR
	DEF name_s:STRING, name_g:STRING, len
	DEF imageobj:PTR TO INTUIOBJECT
	
	len := StrLen(name)
	NEW name_s[len + 3]
	NEW name_g[len + 3]
	
	IF (name_s <> NILS) AND (name_g <> NILS)
		StrCopy(name_s,name)
		StrAdd( name_s,'_s')
		
		StrCopy(name_g,name)
		StrAdd( name_g,'_g')
		
		prev_win := SetProcWindow(-1 !!VALUE!!APTR)  /* Disable requesters */
		dir := Lock('TBIMAGES:',SHARED_LOCK)
		SetProcWindow(prev_win)				/* Re-enable requesters */
		
		IF dir <> ZERO
			prev_dir := CurrentDir(dir)
			
			imageobj := NewObjectA(NIL,'bitmap.image',[BITMAP_SOURCEFILE, name,
			                                           BITMAP_SELECTSOURCEFILE, name_s,
			                                           BITMAP_DISABLEDSOURCEFILE, name_g,
			                                           BITMAP_SCREEN, screen,
			                                           BITMAP_MASKING, TRUE,
			                                           TAG_END]:tagitem)
			image := imageobj !!PTR!!PTR TO image
			
			IF image THEN SetAttrsA(imageobj, [IA_HEIGHT, image.height + 2, TAG_END]:tagitem)
			
			CurrentDir(prev_dir)
			UnLock(dir)
		ENDIF
	ENDIF
FINALLY
	END name_s, name_g
ENDPROC
