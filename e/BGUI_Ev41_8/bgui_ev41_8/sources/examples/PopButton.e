/*
**         File: PopButton.e
**    Copyright: Copyright © 1995 Jaba Development.
**               Copyright © 1995 Jan van den Baard.
**               Copyright © 1996 Dominique Dutoit
**               All Rights Reserved.
**
*/

OPT OSVERSION=37
OPT PREPROCESS

MODULE 'libraries/bgui', 'libraries/bguim'
MODULE 'intuition/intuition', 'intuition/gadgetclass', 'utility/tagitem', 'bgui'
MODULE 'tools/boopsi', 'intuition/screens'

CONST ID_QUIT = 1, ID_POPMENU1 = 2, ID_POPMENU2 = 3, ID_POPMENU3 = 4, ID_POPMENU4 = 5

DEF project:popMenu, edit:popMenu, exclude:popMenu, able:popMenu
/*
**  Put up a simple requester.
**/
PROC req( win:PTR TO window, gadgets, body:PTR TO CHAR, args )
	DEF flags
	flags   := BREQF_LOCKWINDOW OR BREQF_CENTERWINDOW OR BREQF_AUTO_ASPECT OR BREQF_FAST_KEYS
ENDPROC BgUI_RequestA( win, [ flags, NIL, gadgets, body, NIL, NIL, "_", 0, NIL, 0]:bguiRequest, args)

PROC main()
	 DEF window
	 DEF wo_window, go_quit, go_pmb, go_pmb1, go_pmb2, go_pmb3
	 DEF signal = 0, rc, tmp=0, txt:PTR TO CHAR
	 DEF running = TRUE, about:PTR TO CHAR

	 about :=  ISEQ_C + 'This demonstrates the usage of the ' + ISEQ_B + 'PopButtonClass\n' + ISEQ_N +
			   'When you click inside the above popmenu buttons a small\n'+
			   'popup-menu will appear which you can choose from.\n\n'+
			   'You can also key-activate the menus and browse though the\n'+
			   'items using the cursor up and down keys. Return or Enter\n'+
			   'acknowledges the selection and escape cancels it.'

	 /*
	  * Menu entries.
	  */
	 project := [ 'New',          0, 0,
				  'Open...',      0, 0,
				  PMB_BARLABEL,  0, 0,
				  'Save',         0, 0,
				  'Save As...',   0, 0,
				  PMB_BARLABEL,  0, 0,
				  'Print',        0, 0,
				  'Print As...',  0, 0,
				  PMB_BARLABEL,  0, 0,
				  'About...',     0, 0,
				  PMB_BARLABEL,  0, 0,
				  'Quit',         0, 0,
				  NIL,    0, 0 ]:popMenu

	 edit := [    'Cut',          0, 0,
				  'Copy',         0, 0,
				  'Paste',        0, 0,
				  PMB_BARLABEL,  0, 0,
				  'Erase',        0, 0,
				  NIL,    0, 0 ]:popMenu

	 /*
	  * This menu has checkable items and mutual exclusion.
	  *
	  * The first item will mutually-exclude the last
	  * four items and any of the last four items will
	  * mutually-exclude the first item.
	  */
	 exclude := [   'Uncheck below',        PMF_CHECKIT,                    Shl(1,2) OR Shl(1,3) OR Shl(1,4) OR Shl(1,5),
					PMB_BARLABEL,     0,          0,
					'Item 1',               PMF_CHECKIT OR PMF_CHECKED,        Shl(1,0),
					'Item 2',               PMF_CHECKIT OR PMF_CHECKED,        Shl(1,0),
					'Item 3',               PMF_CHECKIT OR PMF_CHECKED,        Shl(1,0),
					'Item 4',               PMF_CHECKIT OR PMF_CHECKED,        Shl(1,0),
					NIL,       0,          0]:popMenu
	 /*
	  * This menu has two items that enable the other
	  * when selected. (NMC)
	  */
	 able := [  'Enable below',      0,    0,
				'Enable above',      PMF_DISABLED,  0,
				NIL,       0,    0 ]:popMenu

	 /*
	 **      Open BGUI.
	 **/

	 IF ( bguibase := OpenLibrary( BGUINAME, BGUIVERSION ))
		/*
		* Create the popmenu buttons.
		*/
		go_pmb  := PopButtonObject,
				   PMB_MenuEntries,  project,
				   /*
					*         Let this one activate
					*         the About item.
					*/
				   PMB_PopPosition,  9,
				   LAB_Label,        '_Project',
				   LAB_Underscore,   "_",
				   GA_ID,            ID_POPMENU1,
				EndObject;

		go_pmb1 := PopButtonObject,
				   PMB_MenuEntries,  edit,
				   LAB_Label,        '_Edit',
				   LAB_Underscore,   "_",
				   GA_ID,            ID_POPMENU2,
				EndObject;

		go_pmb2 := PopButtonObject,
				   PMB_MenuEntries,  exclude,
				   LAB_Label,        'E_xclude',
				   LAB_Underscore,   "_",
				   GA_ID,            ID_POPMENU3,
				EndObject;

		go_pmb3 := PopButtonObject,
				   PMB_MenuEntries,  able,   /* NMC */
				   /*
					*         Make this menu always
					*         appear below the label
					*/
				   PMB_PopPosition,  -1,
				   LAB_Label,        'E_nable',
				   LAB_Underscore,   "_",
				   GA_ID,            ID_POPMENU4,
				EndObject;

		/*
		* Create the window object.
		*/
		wo_window := WindowObject,
		   WINDOW_Title,        'PopButtonClass Demo',
		   WINDOW_AutoAspect,   TRUE,
		   WINDOW_SmartRefresh, TRUE,
		   WINDOW_RMBTrap,      TRUE,
		   WINDOW_AutoKeyLabel, TRUE,
		   WINDOW_MasterGroup,
			  VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
				 GROUP_BackFill,         SHINE_RASTER,
				 StartMember,
					HGroupObject, Spacing( 4 ), HOffset( 6 ), VOffset( 4 ),
					   NeXTFrame,
					   FRM_BackDriPen,         FILLPEN,
					   StartMember, go_pmb, FixMinWidth, EndMember,
					   StartMember, VertSeparator, EndMember,
					   StartMember, go_pmb1, FixMinWidth, EndMember,
					   StartMember, VertSeparator, EndMember,
					   StartMember, go_pmb2, FixMinWidth, EndMember,
					   StartMember, VertSeparator, EndMember,
					   StartMember, go_pmb3, FixMinWidth, EndMember,   /* NMC */
					   StartMember, VertSeparator, EndMember,    /* NMC */
					EndObject, FixMinHeight,
				 EndMember,
				 StartMember,
					InfoFixed( NIL, about, NIL, 7 ),
				 EndMember,

				 StartMember,
					HGroupObject,
					   VarSpace( DEFAULT_WEIGHT ),
					   StartMember, go_quit := PrefButton('_Quit', ID_QUIT), EndMember,
					   VarSpace( DEFAULT_WEIGHT ),
					EndObject, FixMinHeight,
				 EndMember,
			  EndObject,
		EndObject
		/*
		**      Object created OK?
		**/
		IF ( wo_window )
		   IF ( window := WindowOpen( wo_window ) )
			  GetAttr( WINDOW_SigMask, wo_window, {signal} )
				  WHILE running = TRUE
						Wait( signal )
						WHILE ( rc := HandleEvent( wo_window )) <> WMHI_NOMORE
							  SELECT rc
									 CASE    WMHI_CLOSEWINDOW
											 running := FALSE
									 CASE    ID_QUIT
											 running := FALSE

									 CASE    ID_POPMENU4
											 GetAttr( PMB_MenuNumber, go_pmb3, {tmp} )
											 domethod( go_pmb3, [ PMBM_ENABLE_ITEM, Eor(tmp,1), TAG_END ])
											 domethod( go_pmb3, [ PMBM_DISABLE_ITEM, tmp, TAG_END ])
											 txt := able[ tmp ].label
											 def( window, txt, tmp )

									 CASE    ID_POPMENU3
											 GetAttr( PMB_MenuNumber, go_pmb2, {tmp} )
											 txt := exclude[ tmp ].label
											 def( window, txt, tmp )

									 CASE    ID_POPMENU2
											 GetAttr( PMB_MenuNumber, go_pmb1, {tmp} )
											 txt := edit[ tmp ].label
											 def( window, txt, tmp )

									 CASE    ID_POPMENU1
											 GetAttr( PMB_MenuNumber, go_pmb, {tmp} )
											 SELECT tmp
												CASE  9
												   req( window, '_OK', ISEQ_C +  ISEQ_B + 'PopButtonClass DEMO\n' + ISEQ_N + '(C) Copyright 1995 Jaba Development.', NIL )

												CASE  11
												   running := FALSE

												DEFAULT
												   txt := project[ tmp ].label
												   def( window, txt, tmp )
											 ENDSELECT
							  ENDSELECT
						ENDWHILE
				  ENDWHILE
		   ELSE
			  WriteF( 'Unable to open the window\n' )
		   ENDIF
		   DisposeObject( wo_window )
		ELSE
		   WriteF( 'Unable to create a window object\n' )
		ENDIF
		CloseLibrary(bguibase)
	 ELSE
		 WriteF( 'Unable to open the bgui.library\n' )
	 ENDIF
ENDPROC NIL

PROC def( window, txt, tmp ) IS req( window, '_OK', ISEQ_C + 'Selected Item \d <' + ISEQ_B + '\s' + ISEQ_N + '>', [ tmp, txt, NIL ] )
