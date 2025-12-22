/*------------------------------------------------------------------------**
**P-O Yliniemi (24-Dec-94) gadutil.library example translated into AmigaE **
**                                      by  Terje Pedersen  18-Jan-96     **
** Compiled with Amiga v3.2a											  **
** 		ec BetterTest.e													  **
**------------------------------------------------------------------------*/
OPT PREPROCESS

MODULE 	'gadutil','libraries/gadutil',
		'intuition/intuition','intuition/gadgetclass','intuition/screens',
		'libraries/gadtools',
		'graphics/text',
		'exec/execbase','exec/lists','exec/ports',
		'utility/tagitem'

DEF appStrings,layoutmenutags,stdGTTags,stdButtonTags,
	stdGadTags,nextDriveGad,prevDriveGad,driveGad,cycleText,
	driveGTTags,reqGad,checkBoxGad,fileNameGad,integerGad,
	driveMxGad,sliderGad,sliderGTTags,listViewGad,
	scrollGad,scrollGTTags,paletteGad,paletteGTTags,gadgets,myNewMenu,
	layoutTags[6]:ARRAY OF tagitem,lVGTTags[3]:ARRAY OF tagitem,
	mXGadGTTags[4]:ARRAY OF tagitem

DEF	farright,farbottom,gadutilbase,
	screen:PTR TO screen,main_win:PTR TO window,priv_info

CONST 	DRIVE_MX_GAD=11,
 		LEFT_OFFSET=6,
		TOP_OFFSET=3

/*--------------------- Start of localized data --------------------------*/

ENUM 	MSG_NEXTDRIVE,
		MSG_PREVDRIVE,
		MSG_DRIVE,
		MSG_CHECKME,
		MSG_REQUESTER,
		MSG_FILENAME,
		MSG_INTEGER,
		MSG_DRAGME,
		MSG_SCROLLME,
		MSG_SELECTITEM,
		MSG_SELECTCOL
ENUM	MNU_1_TITLE=100,
		MNI_1_IT1,
		MNI_1_IT2,
		MNI_1_IT3,
		MNS_1_IT3_1,
		MNS_1_IT3_2,
		MNI_1_IT4

#define catalogname 'BetterTest.catalog'
#define UNSIGNED(x) ((x) AND $FFFF)

/*---------------------- End of localized data ---------------------------*/

PROC initialize()

	appStrings:=[
		MSG_NEXTDRIVE, '_Next drive',
		MSG_PREVDRIVE, '_Prev drive',
		MSG_DRIVE, '_Drive',
		MSG_CHECKME, 'C_heck me:',
		MSG_REQUESTER, '_Requester',
		MSG_FILENAME, '_Filename:',
		MSG_INTEGER, '_Integer:',
		MSG_DRAGME, 'Dra_g me:',
		MSG_SCROLLME, 'Scr_oll me:',
		MSG_SELECTITEM, '_Select an item:',
		MSG_SELECTCOL, 'Select _Color:',
		MNU_1_TITLE, ' \\Project',
		MNI_1_IT1, 'O\\Open...',
		MNI_1_IT2, 'S\\Save',
		MNI_1_IT3, ' \\Print',
		MNS_1_IT3_1, ' \\Draft',
		MNS_1_IT3_2, ' \\NLQ',
		MNI_1_IT4, 'Q\\Quit']:appstring

	layoutmenutags:=[GTMN_NEWLOOKMENUS,TRUE,TAG_DONE]:tagitem

	stdGTTags:=[GT_UNDERSCORE,"_",TAG_DONE]:tagitem
	stdButtonTags:=[GU_Flags,PLACETEXT_IN,GU_LabelHotkey,TRUE,TAG_DONE]:tagitem
	stdGadTags:=[GU_LabelHotkey,TRUE,TAG_DONE]:tagitem

	nextDriveGad:=[
		GU_GadgetKind,BUTTON_KIND,GU_LocaleText,MSG_NEXTDRIVE,
		GU_Left,LEFT_OFFSET,GU_Top,TOP_OFFSET,
		GU_AutoHeight,4,GU_AutoWidth,20,
		TAG_MORE,stdButtonTags]:tagitem

	prevDriveGad:=[
		GU_GadgetKind,	BUTTON_KIND,	GU_LocaleText,	MSG_PREVDRIVE,
		GU_DupeWidth,	MSG_NEXTDRIVE,	GU_LeftRel,	MSG_NEXTDRIVE,
		GU_AddLeft,	INTERWIDTH,	TAG_MORE, stdButtonTags]:tagitem

	driveGad:=[
		GU_GadgetKind,	CYCLE_KIND,	GU_LocaleText,	MSG_DRIVE,
		GU_TopRel,	MSG_PREVDRIVE,	GU_AddTop,		INTERHEIGHT,
		GU_Flags,	PLACETEXT_LEFT,	TAG_MORE, stdGadTags]:tagitem

	cycleText:=['DF0:', 'DF1:', 'DF2:', 'DF3:', NIL]
	driveGTTags:=[GTCY_LABELS, cycleText, TAG_MORE, stdGTTags]:tagitem

	reqGad:=[
		GU_GadgetKind,	BUTTON_KIND,	GU_LocaleText,	MSG_REQUESTER,
		GU_TopRel,	MSG_DRIVE,	GU_AddTop,	INTERHEIGHT,
		TAG_MORE, stdButtonTags]:tagitem

	checkBoxGad:=[
		GU_Width,	CHECKBOX_WIDTH,	GU_Height,	CHECKBOX_HEIGHT,
		GU_GadgetKind,	CHECKBOX_KIND,	GU_LocaleText,	MSG_CHECKME,
		GU_AlignRight,	MSG_NEXTDRIVE,	GU_Flags,	PLACETEXT_LEFT,
		TAG_MORE, stdGadTags]:tagitem

	fileNameGad:=[
		GU_GadgetKind,	STRING_KIND,	GU_TopRel,	MSG_REQUESTER,
		GU_LocaleText,	MSG_FILENAME,	GU_AutoHeight,	4,
		GU_AlignLeft,	MSG_CHECKME,	GU_AlignRight,	DRIVE_MX_GAD,
		GU_AddTop,	INTERHEIGHT,	GU_AddWidth,	4,
		TAG_MORE, stdGadTags]:tagitem

	integerGad:=[
		GU_GadgetKind,	INTEGER_KIND,	GU_TopRel,	MSG_FILENAME,
		GU_LocaleText,	MSG_INTEGER,	GU_AddTop,	INTERHEIGHT,
		TAG_MORE, stdGadTags]:tagitem

	driveMxGad:=[
		GU_GadgetKind,	MX_KIND,		GU_AlignTop,	MSG_NEXTDRIVE,
		GU_Width,		MX_WIDTH,		GU_Height,		MX_HEIGHT,
		GU_AdjustTop,	2,				GU_Flags,		PLACETEXT_LEFT OR NG_HIGHLABEL,
		GU_LeftRel,		MSG_PREVDRIVE,	GU_AddLeftChar,	7,
		GU_GadgetText,	'Driv_e',		GU_LabelHotkey,	TRUE,
		TAG_DONE]:tagitem

	mXGadGTTags:=[
		GTMX_LABELS,cycleText,GTMX_SPACING,2,
		GTMX_ACTIVE,2,TAG_DONE]:tagitem

	sliderGad:=[
		GU_GadgetKind,	SLIDER_KIND,	GU_AlignLeft,	MSG_FILENAME,
		GU_AlignRight,	MSG_FILENAME,	GU_AutoHeight,	4,
		GU_TopRel,		MSG_INTEGER,	GU_AddTop,		INTERHEIGHT,
		GU_AddWidth,	-13,			GU_Flags,		PLACETEXT_LEFT,
		GU_LocaleText,	MSG_DRAGME,	TAG_MORE,stdGadTags]:tagitem

	sliderGTTags:=[
		GTSL_MIN,		-50,			GTSL_MAX,	50,
		GTSL_LEVEL,		10,				GTSL_MAXLEVELLEN, 3,
		GTSL_LEVELFORMAT, '%3ld',
		GTSL_LEVELPLACE, PLACETEXT_RIGHT,
		TAG_MORE,stdGTTags]:tagitem

	listViewGad:=[
		GU_GadgetKind,	LISTVIEW_KIND,	GU_AlignTop,	MSG_DRIVE,
		GU_AlignBottom,	MSG_INTEGER,	GU_LocaleText,	MSG_SELECTITEM,
		GU_LeftRel,	MSG_INTEGER,	GU_Columns,	26,
		GU_Flags,	PLACETEXT_ABOVE OR NG_HIGHLABEL,
		GU_AddLeft,	10, TAG_MORE, stdGadTags]:tagitem

	lVGTTags:=[
		GTLV_LABELS,NIL,GTLV_SHOWSELECTED,-1,
		TAG_MORE, stdGTTags]:tagitem

	scrollGad:=[
		GU_GadgetKind,	SCROLLER_KIND,	GU_LocaleText,	MSG_SCROLLME,
		GU_AlignLeft,	MSG_DRAGME,	GU_AlignRight,	MSG_INTEGER,
		GU_TopRel,	MSG_DRAGME,	GU_AddTop,	INTERHEIGHT,
		GU_Flags,	PLACETEXT_LEFT,	GU_AddWidth,	20,
		GU_DupeHeight,	MSG_DRAGME,	TAG_MORE, stdGadTags]:tagitem

	scrollGTTags:=[
		GTSC_TOP,		110,	GTSC_TOTAL,		9,
		GTSC_VISIBLE,	5,		GTSC_ARROWS,	16,
		TAG_MORE, stdGTTags]:tagitem

	paletteGad:=[
		GU_GadgetKind,	PALETTE_KIND,	GU_LocaleText,	MSG_SELECTCOL,
		GU_LeftRel,	MSG_SCROLLME,	GU_AddLeft,	INTERWIDTH,
		GU_Flags,	PLACETEXT_ABOVE OR NG_HIGHLABEL,
		GU_TopRel,	MSG_SELECTITEM,	GU_AdjustTop,	INTERHEIGHT,
		GU_AlignBottom,	MSG_SCROLLME,	GU_AlignRight,	MSG_SELECTITEM,
		TAG_MORE, stdGadTags]:tagitem

	paletteGTTags:=[
		GTPA_DEPTH,	2,		GTPA_INDICATORWIDTH,	36,
		TAG_MORE, stdGTTags]:tagitem

	gadgets:=[
		MSG_NEXTDRIVE,	nextDriveGad,	stdGTTags,			NIL,
		MSG_PREVDRIVE,	prevDriveGad,	stdGTTags,			NIL,
		MSG_DRIVE,		driveGad,		driveGTTags,		NIL,
		MSG_REQUESTER,	reqGad,			stdGTTags,			NIL,
		MSG_CHECKME,	checkBoxGad,	stdGTTags,			NIL,
		MSG_FILENAME,	fileNameGad,	stdGTTags,			NIL,
		MSG_INTEGER,	integerGad,		stdGTTags,			NIL,
		DRIVE_MX_GAD,	driveMxGad,		mXGadGTTags,		NIL,
		MSG_DRAGME,		sliderGad,		sliderGTTags,		NIL,
		MSG_SELECTITEM,	listViewGad,	lVGTTags,			NIL,
		MSG_SCROLLME,	scrollGad,		scrollGTTags,		NIL,
		MSG_SELECTCOL,	paletteGad,		paletteGTTags,		NIL,
		-1,		NIL,		NIL,		NIL]:layoutgadget

	myNewMenu:=[
		NM_TITLE,	0,	MNU_1_TITLE,	0,	0,	0,	0,	/* | Project |	*/
		NM_ITEM,	0,	MNI_1_IT1,		0,	0,	0,	1,	/* Open [O]		*/
		NM_ITEM,	0,	MNI_1_IT2,		0,	0,	0,	2,	/* Save [S]		*/
		NM_ITEM,	0,	NM_BARLABEL,	0,	0,	0,	0,	/* -----------	*/
	  	NM_ITEM,	0,	MNI_1_IT3,		0,	0,	0,	0,	/* Print...		*/
	   	NM_SUB,		0,	MNS_1_IT3_1,	0,	0,	0,	3,	/*      Draft	*/
	   	NM_SUB,		0,	MNS_1_IT3_2,	0,	0,	0,	4,	/*      NLQ		*/
	  	NM_ITEM,	0,	NM_BARLABEL,	0,	0,	0,	0,	/* -----------	*/
	  	NM_ITEM,	0,	MNI_1_IT4,		0,	0,	0,	5,	/* Quit [Q]		*/
	 	NM_END,		0,	NIL,			0,	0,	0,	0]:newmenu

	layoutTags:=[
		GU_RightExtreme, 	{farright},
		GU_LowerExtreme, 	{farbottom},
		GU_DefTextAttr,		0,
		GU_Catalog,			0,
		GU_AppStrings, 		appStrings,
		TAG_DONE]:tagitem

ENDPROC

/*-----------------------------------------------------------------*/


PROC main() HANDLE
DEF glist:PTR TO gadget,liblist:PTR TO execbase,menustrip:PTR TO menu

	initialize()
	
	liblist:=execbase
	liblist:=liblist.liblist
	lVGTTags[].data:=liblist

	IF (gadutilbase:=OpenLibrary('gadutil.library',0))=NIL THEN Raise('Could not open gadutil.library')
	layoutTags[3].data:=Gu_OpenCatalog(catalogname,0)

	IF (screen:=LockPubScreen(NIL))=NIL THEN Raise('Could not lock screen')
	layoutTags[2].data:=screen.font

	IF (priv_info:=Gu_LayoutGadgetsA({glist}, gadgets, screen, layoutTags))=NIL THEN Raise('Layoutgadgets')

	main_win:=OpenWindowTagList(NIL,[
				WA_LEFT,	0,
				WA_TOP,		screen.font::textattr.ysize + 3,
				WA_INNERWIDTH, farright + LEFT_OFFSET,
				WA_INNERHEIGHT, farbottom + TOP_OFFSET,
				WA_IDCMP,	LISTVIEWIDCMP OR IDCMP_MENUPICK OR CYCLEIDCMP OR
							IDCMP_REFRESHWINDOW OR IDCMP_CLOSEWINDOW OR
							IDCMP_VANILLAKEY OR IDCMP_RAWKEY,
				WA_FLAGS,	WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
							WFLG_CLOSEGADGET OR WFLG_ACTIVATE OR
							WFLG_SMART_REFRESH OR WFLG_REPORTMOUSE,
				WA_GADGETS, glist,	
				WA_NEWLOOKMENUS,TRUE,
				WA_TITLE,	'GadUtil library test',
				TAG_DONE])

	IF main_win=NIL THEN Raise('Could not open window')

	Gu_RefreshWindow(main_win, NIL)
	IF (menustrip:=Gu_CreateLocMenuA(myNewMenu,priv_info,NIL,layoutmenutags))=NIL THEN Raise('menu')
	IF (SetMenuStrip(main_win, menustrip))=NIL THEN Raise('Setmenustrip')

	process_window_events(main_win, menustrip)
	
	Raise(0)
EXCEPT
	IF exception THEN WriteF('\s\n',exception)
	IF main_win
		IF menustrip
			ClearMenuStrip(main_win)
			Gu_FreeMenus(menustrip)
		ENDIF
		CloseWindow(main_win)
	ENDIF
	IF priv_info THEN Gu_FreeLayoutGadgets(priv_info)
	IF screen THEN UnlockPubScreen(NIL, screen)
	IF (layoutTags[3].data) THEN Gu_CloseCatalog(layoutTags[3].data)
	IF gadutilbase THEN CloseLibrary(gadutilbase)
ENDPROC

PROC process_window_events(win:PTR TO window,menuStrip:PTR TO menu)
DEF imsg:PTR TO intuimessage,gad:PTR TO gadget,tempgad:PTR TO gadget,
	item:PTR TO menuitem,going=TRUE,menunumber,coords,class,id,itemnum

	WHILE going
		Wait(Shl(1,win.userport::mp.sigbit))

		WHILE (going AND (imsg:=Gu_GetIMsg(win.userport)))
			class:=imsg.class
			SELECT class
			CASE IDCMP_GADGETUP
				toggleLED()
				gad:=imsg.iaddress
				id:=gad.gadgetid
				SELECT id
				CASE MSG_NEXTDRIVE
					IF (tempgad:=Gu_GetGadgetPtr(DRIVE_MX_GAD, gadgets))
						IF (mXGadGTTags[2].data<3) 
							mXGadGTTags[2].data:=mXGadGTTags[2].data+1
						ELSE
							mXGadGTTags[2].data:=0
						ENDIF
						Gu_SetGadgetAttrsA(tempgad, win, NIL, mXGadGTTags[2])
					ENDIF
				CASE MSG_PREVDRIVE
					IF (tempgad:=Gu_GetGadgetPtr(DRIVE_MX_GAD, gadgets))
						IF (mXGadGTTags[2].data>0)
							mXGadGTTags[2].data:=mXGadGTTags[2].data-1
						ELSE
							mXGadGTTags[2].data:=3
						ENDIF
						Gu_SetGadgetAttrsA(tempgad, win, NIL, mXGadGTTags[2])
					ENDIF
				CASE MSG_REQUESTER
					Gu_BlockInput(win)
					Delay(50)
					Gu_FreeInput(win)
				CASE MSG_DRIVE 
					toggleLED()
				ENDSELECT

			CASE IDCMP_GADGETDOWN
				gad:=imsg.iaddress
				IF (gad.gadgetid = DRIVE_MX_GAD) THEN mXGadGTTags[2].data:=imsg.code

			CASE IDCMP_MOUSEMOVE
				IF (tempgad:=Gu_GetGadgetPtr(MSG_SELECTITEM, gadgets))
					coords:=(Shl(imsg.mousex,16) OR imsg.mousey)
					IF (Gu_CoordsInGadBox(coords,tempgad)) THEN toggleLED()
				ENDIF

			CASE IDCMP_MENUPICK
      			-> E-Note: convert message code to an unsigned INT
				menunumber:=UNSIGNED(imsg.code)
				WHILE (menunumber<>MENUNULL) AND going
					item:=ItemAddress(menuStrip, menunumber)
					
					itemnum:=ITEMNUM(menunumber)
					IF itemnum=5 THEN going:=FALSE

      			-> E-Note: convert message code to an unsigned INT
					menunumber:=UNSIGNED(item.nextselect)
				ENDWHILE

			CASE IDCMP_CLOSEWINDOW
				going:=FALSE

			CASE IDCMP_REFRESHWINDOW
				Gu_BeginRefresh(win)
				Gu_EndRefresh(win, TRUE)
			ENDSELECT
			Gu_ReplyIMsg(imsg);
		ENDWHILE
	ENDWHILE
ENDPROC

PROC toggleLED()
	BCHG #1,$bfe001
ENDPROC
