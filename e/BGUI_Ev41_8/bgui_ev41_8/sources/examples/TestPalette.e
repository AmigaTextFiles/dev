/*
**      TestPalette.e
**
**      (C) Copyright 1995 Jaba Development.
**      (C) Copyright 1995 Jan van den Baard.
**          All Rights Reserved.
**
**      Heavely modified by Dominique Dutoit, 5/1/96
**      Updated on 11-Aug-96
**      Updated on 01-Feb-97 : You need BGUI 41.8 to run this example!!!
*/

OPT OSVERSION=37
OPT PREPROCESS

MODULE 'libraries/bgui',
	   'libraries/bguim',
	   'libraries/gadtools',
	   'bgui',
	   'tools/boopsi',
	   'tools/installhook',
	   'utility/tagitem',
	   'utility/hooks',
	   'intuition/classes',
	   'intuition/classusr',
	   'intuition/gadgetclass',
	   'intuition/intuition',
	   'intuition',
	   'exec/types',
	   'amigalib/boopsi'

DEF     mybuttonclass:PTR TO iclass
/*
 *      Object ID's.
 */
CONST   ID_QUIT= 1,
		ID_FRAME=2,
		ID_SFRAME=3,
		ID_LABEL=4,
		ID_SLABEL=5

/*
 *  The button we use is a very simple subclass from the
 *  BGUI buttonclass to accept only drops from the four
 *  paletteclass objects in this demo or from other palette
 *  class objects from another task or window when they have
 *  the same ID as we use here.
 */
PROC mybuttondispatch( cl:PTR TO iclass, obj:PTR TO object, bmsg )
	DEF rc, pen, tag, i, j, imsg:msg
	DEF gad:PTR TO gadget, dragmsg:PTR TO bmDragMsg, dragpnt:PTR TO bmDragPoint

	imsg := bmsg
	i := imsg.methodid

	SELECT i
		CASE    BASE_DRAGQUERY
				/*
				 *  We only accept drops from our paletteclass objects.
				 *  The test here is a bit simple but this way it does
				 *  allow for drops from another task. Just run this demo
				 *  twice and DragNDrop from one window to another.
				 */
				dragpnt := imsg
				gad := dragpnt.source
				IF ( gad.gadgetid >= ID_FRAME ) AND ( gad.gadgetid <= ID_SLABEL )
					rc := BQR_ACCEPT
				ELSE
					rc := BQR_REJECT
				ENDIF

		CASE    BASE_DROPPED
				/*
				 *  Get the pen from the object.
				 */
				dragmsg := imsg
				GetAttr( PALETTE_CurrentColor, dragmsg.source, {pen} )

				/*
				 *  Let's see what has been dropped...
				 */
				gad := dragmsg.source
				j := gad.gadgetid
				SELECT j
					CASE    ID_FRAME
							tag := FRM_BackPen

					CASE    ID_SFRAME
							tag := FRM_SelectedBackPen

					CASE    ID_LABEL
							tag := LAB_Pen

					CASE    ID_SLABEL
							tag := LAB_SelectedPen

				ENDSELECT

				/*
				 *  Set the pen. The superclass will force
				 *  a refresh on the object when the drop has
				 *  been made.
				 */
				SetAttrsA( obj, [ tag, pen, TAG_END ] )
				rc := 1

		DEFAULT
				rc := doSuperMethodA( cl, obj, bmsg )

	ENDSELECT
ENDPROC rc

/*
 *  Setup our button class.
 */
PROC makemybuttonclass()
	DEF cl:PTR TO iclass, super:PTR TO iclass

	/*
	 * Get a pointer to our superclass.
	 */
	IF ( super := BgUI_GetClassPtr( BGUI_BUTTON_GADGET ))
		/*
		 * Make our class.
		 */
		 IF ( cl := MakeClass( NIL, NIL, super, 0, 0 ))
			 /*
			  * Setup our dispatcher.
			  */
			installhook( cl.dispatcher, {mybuttondispatch} )
		 ENDIF
	 ENDIF
ENDPROC cl

PROC main()
	 DEF window
	 DEF wo_window, go_quit, go_b, go_pal[ 4 ]:ARRAY OF LONG
	 DEF signal = 0, rc, a
	 DEF defpens[ 4 ]:ARRAY OF LONG
	 DEF running = TRUE

	 defpens := [ 0, 3, 1, 1]

	 /*
	 **      Open BGUI.
	 **/
	 IF ( bguibase := OpenLibrary( BGUINAME, BGUIVERSION ))
			 /*
			  * And our drop-buton class.
			  */
			  IF ( mybuttonclass := makemybuttonclass() )
			  /*
			   * I assume a depth of three
			   * (8 colors) here for simplicity.
			   */
			   FOR a := 0 TO 3
				   go_pal[ a ] := PaletteObject,
										FRM_Type,             FRTYPE_BUTTON,
										FRM_Recessed,         TRUE,
										PALETTE_Depth,        3,
										PALETTE_CurrentColor, defpens[ a ],
										GA_ID,                a + 2,
										BT_DragObject,        TRUE,
									EndObject
			   ENDFOR
			   /*
			   **  Create the window object.
			   **/
			   wo_window := WindowObject,
					 WINDOW_Title,           'PaletteClass Demo',
					 WINDOW_SmartRefresh,    TRUE,
					 WINDOW_RMBTrap,         TRUE,
					 WINDOW_AutoAspect,      TRUE,
					 WINDOW_AutoKeyLabel,    TRUE,
					 WINDOW_IDCMP,           IDCMP_MOUSEMOVE,
					 WINDOW_MasterGroup,
						 VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
							 GROUP_BackFill,    SHINE_RASTER,
								 StartMember,
									 InfoFixed( NIL, '\ecAs you can see the colors of the below button\nare normal but when you change the colors with\nthe palette objects the colors of the button change.\n\nYou can also pickup the color and drop it onto the\nbutton. \ebDragNDrop\en in action.', NIL, 8 ),
								 EndMember,
								 StartMember,
									 HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
										 FRM_Type,          FRTYPE_BUTTON,
										 FRM_Recessed,      TRUE,
										 StartMember, go_b := NewObjectA( mybuttonclass, NIL,
																		 [ FRM_Type,         FRTYPE_BUTTON,
																		   LAB_Label,        'Palette Demo',
																		   BT_DropObject,    TRUE,
																		   TAG_END] ), EndMember,
									 EndObject, FixMinHeight,
								 EndMember,
								 StartMember,
									 HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
										 FRM_Type,           FRTYPE_BUTTON,
										 FRM_Recessed,       TRUE,
										 StartMember,
											 VGroupObject, Spacing( 4 ),
												 LAB_Label,  'Background:',
												 LAB_Place,  PLACE_ABOVE,
												 StartMember, go_pal[ 0 ], EndMember,
												 StartMember, go_pal[ 1 ], EndMember,
											 EndObject,
										 EndMember,
										 StartMember,
											 VGroupObject, Spacing( 4 ),
												 LAB_Label,  'Label:',
												 LAB_Place,  PLACE_ABOVE,
												 StartMember, go_pal[ 2 ], EndMember,
												 StartMember, go_pal[ 3 ], EndMember,
											 EndObject,
										 EndMember,
									 EndObject,
								 EndMember,
								 StartMember,
									 HGroupObject,
										 VarSpace( DEFAULT_WEIGHT ),
										 StartMember, go_quit := KeyButton( '_Quit', ID_QUIT ), EndMember,
										 VarSpace( DEFAULT_WEIGHT ),
									 EndObject, FixMinHeight,
								 EndMember,
						 EndObject,
			   EndObject

			   /*
			   **      Object created OK?
			   **/
			   IF ( wo_window )
				  AddMap( go_pal[ 0 ], go_b, [ PALETTE_CurrentColor, FRM_BackPen,        TAG_END ] )
				  AddMap( go_pal[ 1 ], go_b, [ PALETTE_CurrentColor, FRM_SelectedBackPen,TAG_END ] )
				  AddMap( go_pal[ 2 ], go_b, [ PALETTE_CurrentColor, LAB_Pen,            TAG_END ] )
				  AddMap( go_pal[ 3 ], go_b, [ PALETTE_CurrentColor, LAB_SelectedPen,    TAG_END ] )
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
			   FreeClass( mybuttonclass )
		  ELSE
			  WriteF( 'Unable to create custom class\n' )
		  ENDIF
		  CloseLibrary(bguibase)
	 ELSE
		 WriteF( 'Unable to open the bgui.library\n' )
	 ENDIF
ENDPROC NIL
