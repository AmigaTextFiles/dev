/* $VER: EDTShow_Source 0.5 (10.09.93) Colin Bell
** I can be contacted at fidonet #3:714/909.4#
**
** E picture viewer. USES WB3.0's DATATYPES.LIBRARY
**
** THIS CODE IS COPYRIGHT 1993 COLIN BELL. YOU MAY USE ANY OF
** THIS CODE IN YOUR OWN UTILITIES BUT YOU MUST GIVE ME CREDIT.
** THIS CODE MAY NOT BE SOLD OR USED IN ANY SHAREWARE OR
** COMMERCIAL VENTURE WITHOUT WRITTEN PERMISSION FROM THE AUTHOR.
** THIS CODE CARRIES NO WARRANTIES WHATSOEVER. USE AT YOUR OWN RISK.
**  This code is loosely based on a C example source by CBM.
**
** This program is nowhere near a complete program & is released as 
** example code to show WB3's great datatypes features etc.
**
** *****SHOWS IFF,JPG,GIF,BMP,PCX *********************************
** *****SAVES IFF (YOU MAY USE THIS AS A SIMPLE PIC CONVERTER)*****
** *****ALLOWS YOU TO CHANGE THE SCREENMODE BEFORE THE SAVE********
** (if you have all the datatypes installed)
**
** To Compile type: EPP dt5 EDTView
**					EC      EDTView
** NOTE: I use some PMODULES to include WB3 constants. When the WB3 
** EModules come out, use the following & remove the PMODULES.
**
** MODULE 'datatypes/datatypes', datatypes/datatypesclass',
**        'datatypes/pictureclass'
**
** Also note, My ASL requester uses the proper code unlike the example
** provided with E which uses OBSOLETE lib calls  8-)
*/


MODULE 'dos/dos', 'exec/memory', 'exec/libraries', 'graphics/gfx'
MODULE 'Asl', 'libraries/Asl', 'intuition/screens', 'graphics/rastport'
MODULE 'libraries/gadtools', 'gadtools', 'exec/ports', 'intuition/intuition'
MODULE 'datatypes'              /*MY VERSION. INCLUDED WITH THIS SOURCE*/

/*
** AS THERE ARE NO WB3 MODULES FOR E YET, THESE CONTAIN SOME DATATYPES
** CONSTANTS AND ARE LINKED IN WITH EPP (E PRE PROCESSOR BY BARRY WILLS)
** HEY BARRY, Why does EPP pop WB to the front?? I compile on CED's screen!
*/

PMODULE 'pmodules:dtconsts'	/*These are included with the source*/
PMODULE 'pmodules:dtOBJs'

CONST	GTMN_NEWLOOKMENUS = GT_TAGBASE+67 /*WB3 newlookmenus tag*/
CONST	WA_NEWLOOKMENUS = WA_MENUHELP+1
ENUM	LOAD,SAVE                         /*For my ASL requester*/
CONST	SA_INTERLEAVED = SA_FULLPALETTE+7 /*interleaved screen tag*/
CONST	OBP_PRECISION = $84000000
CONST	PRECISION_EXACT	= -1
CONST	PRECISION_IMAGE	= 0
CONST	PRECISION_ICON = 16
CONST	PRECISION_GUI = 32

DEF dtf:PTR TO dtframebox,fri:PTR TO frameinfo,o
DEF fullpath[255]:STRING,visual	
DEF bm=NIL:PTR TO bitmap,modeid=NIL
DEF	wnd:PTR TO window,menustrip,class,code,iaddr
DEF scr=NIL:PTR TO screen,cregs=NIL,scrflag=0,ret=0
DEF port:PTR TO mp
DEF dpen,bpen
OPT OSVERSION=39	/* OS 3.0 *ONLY* */

/************************************************************************/
PROC main()
DEF numcolors=NIL
DEF bmhd=NIL:PTR TO bitmapheader, s
DEF gpl:PTR TO gplayout,pen
VOID '$VER: EDTShow 0.5 (10.09.93) Colin Bell'

/*Do ASL file requester and join path/name*/
getfile(LOAD,'Select Picture to load',0) 

IF ^fullpath <> NIL	

 	IF dtbase:=(OpenLibrary('datatypes.library',39))

		WriteF('\s.\n',fullpath) /*show filename*/

		/*obtain a pointer to the picture object*/
		IF 	(o:=NewDTObjectA(fullpath,[DTA_SOURCETYPE,DTST_FILE,
									  DTA_GROUPID,GID_PICTURE,
									  PDTA_REMAP,FALSE,NIL]))
			
		/*get some mem for these structures*/

			dtf:=New(SIZEOF dtframebox)
			fri:=New(SIZEOF frameinfo)
		
			dtf.dtf_methodid:=DTM_FRAMEBOX
			dtf.dtf_frameinfo:=fri
			dtf.dtf_contentsinfo:=fri
			dtf.dtf_sizeframeinfo:=SIZEOF frameinfo	
		
/*domethoda(obj,msg) is MY ASM written version of the amiga.lib function*/
/*I hope a new version of E can link with amiga.lib coz this took me    */
/*2 days to bloody work out. `o' is the object from NewDTObjecta */
/*This first call to domethod gets info on the picture*/

			IF (domethoda(o,dtf)) 
				/*Display the info obtained*/
				WriteF('PropFlags  : 0x\h\n',fri.propertyflags)
				WriteF('Redbits    : \d\n',fri.redbits)
				WriteF('Bluebits   : \d\n',fri.bluebits)
				WriteF('Greenbits  : \d\n',fri.greenbits)
				WriteF('Width      : \d\n',fri.width)
				WriteF('Height     : \d\n',fri.height)
				WriteF('Depth      : \d\n',fri.depth)		
			ENDIF	

			gpl:=New(SIZEOF gplayout)
			gpl.gplmi:=DTM_PROCLAYOUT
			gpl.ginfo:=NIL
			gpl.initial:=1

/* this next part gives us the modeid, the color regs, the number of  colours,
** a bitmapheader, and a bitmap structure including the bitmap. 
** In other words, It loads in, and converts whatever file format. 
** I call it "The BIGGY"  8-)
*/
					/*layout object*/
			IF (domethoda(o,gpl))

				GetDTAttrs(o,
							[PDTA_MODEID,{modeid},
							PDTA_CREGS,{cregs},
							PDTA_NUMCOLORS,{numcolors},
							PDTA_BITMAPHEADER,{bmhd},
							PDTA_BITMAP,{bm},NIL])


			  REPEAT
/*				WriteF('ModeID:    : 0x\h\n',modeid)*/
			    scrflag:=0 
				IF (bm)  /*if we got a bitmap*/
						
					IF scr:=openscr()	/*open screen*/

						IF (cregs)

							docregs(numcolors)	/*set color registers*/			


/*There must be a better way to set menu pens????????*/
/*I AM USING FindColor HERE*/
							MOVE.L	scr,A0
							LEA		44(A0),A0
							MOVE.L	4(A0),A3
							MOVEQ	#0,D0
							MOVE.L	#$FFFFFFFF,D1
							MOVE.L	#$FFFFFFFF,D2
							MOVE.L	#$FFFFFFFF,D3
							MOVE.L	numcolors,D4
							MOVEA.L	gfxbase,A6
							JSR		-1008(A6)	
							MOVE.L	D0,dpen

							MOVE.L	scr,A0
							LEA		44(A0),A0
							MOVE.L	4(A0),A3
							MOVEQ	#0,D0
							MOVEQ	#0,D1
							MOVEQ	#0,D2
							MOVEQ	#0,D3
							MOVE.L	numcolors,D4
							MOVEA.L	gfxbase,A6
							JSR		-1008(A6)	
							MOVE.L	D0,bpen

							IF (wnd:=domainwindow(scr))
							/*Wait for user & do whats requested*/
								waitandact()
								closew(wnd)
							ENDIF
						ENDIF
					CloseScreen(scr)
					ELSE
						WriteF('Could not open Screen\n')
					ENDIF
				ELSE
					WriteF('Got no bitmap\n')
				ENDIF
			  UNTIL (scrflag = 0)

			ELSE
				WriteF('2nd domethod failed')
			ENDIF
	
			DisposeDTObject(o)
	
		ELSE
			WriteF('DT Object failed\n Unknown file format?\n')
		ENDIF								

		CloseLibrary(dtbase)
	ELSE
	WriteF('Cannot open datatypes.library\n')
	ENDIF	
	
ELSE	
	WriteF('Need a pic name\n')
ENDIF

ENDPROC 
/*************************************************************************/
PROC showerror(id)	/*though, i've never used it yet*/

DEF msg[80]:STRING

	IF id
		IF (id < 2000)
			PrintFault(id,' Error Code: ')
		ELSE
			WriteF(GetDTString(id))
		ENDIF
	ENDIF
ENDPROC
/************************************************************************/
/*Put up an ASL filerequester*/

PROC	getfile(mode,tbar,w)   /*LOAD or SAVE, Title, Window*/
DEF	fflags=0
DEF req:PTR TO filerequestr

	IF (mode = SAVE) THEN fflags:=FILF_SAVE

IF aslbase:=OpenLibrary('asl.library',39)
    IF req:=AllocAslRequest(ASL_FILEREQUEST,NIL)

      IF AslRequest(req,[ASL_HAIL,tbar,ASL_FUNCFLAGS,fflags,ASL_WINDOW,w,
						ASL_HEIGHT,300,ASL_PATTERN,'#?',NIL])
		makefullpath(req.dir,req.file)
      ENDIF
      FreeAslRequest(req)
    ELSE
      WriteF('Could not open filerequester!\n')
    ENDIF
	CloseLibrary(aslbase)
ELSE
	WriteF('Could not open asl.library!\n')
ENDIF

ENDPROC 
/************************************************************************/
/* takes a dir & a filename. And joins them adding a / when needed*/
PROC makefullpath(dir,file)          
	
DEF col,c[2]:STRING

	MidStr(c,dir,((StrLen(dir))-1),1)     /*Get last character in string*/

	/* if dir=0 is like cmp.l #0,A0, if ^dir=0 is like cmp.l #0,(A0)  */
                                       
	IF (^dir=0) AND (^file=0)
		
	ELSEIF ^dir=0 OR (col:=StrCmp(c,':',1)) OR (col:=StrCmp(c,'/',1))
		StringF(fullpath,'\s\s',dir,file)
	ELSE /*otherwise, insert a "/" inbetween */
		StringF(fullpath,'\s/\s',dir,file)
	ENDIF
ENDPROC	
/************************************************************************/
/* THE AMIGA.LIB FUNCTION DoMethodA  REWRITTEN FOR E */

PROC	domethoda(obj,msg)	/*Object to perform method on*/
							/*Msg to perform on object*/
		MOVE.L	obj,A2
		MOVE.L	A2,D0
		BEQ.S	cmnullreturn
		MOVE.L	msg,A1
		MOVE.L	-4(A2),A0
		PEA		cmreturn(PC)
		MOVE.L	8(A0),-(A7)
		RTS
cmreturn:
		UNLK	A5	/*I want to keep D0 so return myself */
		RTS
cmnullreturn:	/*This converts to	MOVEQ 	#0,D0	*/
				/*					UNLK	A5		*/
				/*					RTS				*/
ENDPROC	
/*****************************************************/
PROC domainwindow(scr)
DEF g,menus:PTR TO newmenu,sigbit

IF (wnd:=OpenWindowTagList(NIL,[WA_WIDTH,fri.width,WA_HEIGHT,fri.height,
						WA_BACKDROP,TRUE,WA_BORDERLESS,TRUE,
						WA_CUSTOMSCREEN,scr,WA_SUPERBITMAP,bm,
						WA_NEWLOOKMENUS,FALSE,WA_DETAILPEN,bpen,WA_BLOCKPEN,dpen,
						WA_IDCMP,IDCMP_MENUPICK,WA_ACTIVATE,TRUE,NIL]))=NIL THEN RETURN 0
IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN 0

IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN 0

IF (menustrip:=CreateMenusA([NM_TITLE,0,'Project',0,0,0,0,
							NM_ITEM,0,'About','A',0,0,3,
							NM_ITEM,0,'Mode','M',0,0,1,
							NM_ITEM,0,'Save','S',0,0,2,
							NM_ITEM,0,'Quit','Q',0,0,4,
                            NM_END,0,NIL,0,0,0,0]:newmenu,NIL))=NIL THEN RETURN 0
IF (LayoutMenusA(menustrip,visual,[GTMN_NEWLOOKMENUS,FALSE,NIL]))=NIL THEN RETURN 0

IF (SetMenuStrip(wnd,menustrip))=NIL THEN RETURN 0				

ScreenToFront(scr)
ENDPROC wnd						
/***********************************************************************/
PROC closew(wnd)

IF (menustrip)				 
	ClearMenuStrip(wnd)
	FreeMenus(menustrip)
ENDIF

IF (visual) THEN FreeVisualInfo(visual)

IF (gadtoolsbase) THEN CloseLibrary(gadtoolsbase)

ScreenToBack(scr)
IF (wnd) THEN CloseWindow(wnd)

ENDPROC
/*******************************************************/
PROC	waitandact()
DEF	done=0
DEF msg:PTR TO intuimessage,type
		port:=wnd.userport
		WHILE	done = 0
			Wait(Shl(1,port.sigbit))
			WHILE ((done)=NIL) AND (msg:=GetMsg(port))
				code:=msg.code
				iaddr:=msg.iaddress
				class:=msg.class
				SELECT  class
				CASE IDCMP_MENUPICK
					done:=handlemenus()
				ENDSELECT
				ReplyMsg(msg)
			ENDWHILE
									
		ENDWHILE
ENDPROC
/*****************************************************/
PROC	handlemenus()	/*menunumber*/
DEF	item:PTR TO menuitem,userdat
		ret:=0
	WHILE ((code <> 0)AND(ret = 0)AND(code <> MENUNULL))
	
		item:=ItemAddress(menustrip,code)

/*have to do this in ASM as I can't think how to now & its so simple anyway*/
/*34(a0) is outside the normal menu structure*/

		MOVE.L	item,A0
		MOVE.L	34(A0),D0	/*This is userdata as contained in gt macro*/
		MOVE.L	D0,userdat

		SELECT	userdat
			CASE 1
				screenmode()
                ret:=1
			CASE 2
				savepic()
				ret:=0
			CASE 3
				doabout()
				ret:=0
			CASE 4
				ret:=1
			CASE 5
				ret:=0
		ENDSELECT

		code:=item.nextselect

	ENDWHILE
ENDPROC ret
/*****************************************************/
PROC	doabout()
/*EasyRequestArgs(window,easyStruct,idcmpPtr,args)(a0/a1/a2/a3)*/
DEF	gargs[150]:STRING
	StringF(gargs,'EDTView 0.5 By C.Bell\nFile: \s\nWidth: \d Height: \d\nDepth: \d ModeID 0x\h',fullpath,fri.width,fri.height,fri.depth,modeid)
	ScreenToBack(scr)
 	EasyRequestArgs(NIL,[20,0,0,gargs,'Cool Bananas'],0,NIL)
    ScreenToFront(scr)
ENDPROC
/*****************************************************/
/*****************************************************/
/*This routine saves the picture as an IFF ILBM*/
/*ITt MAY be possible to save GIF,JPG etc. Need the 3.1 RKM's though 8-)*/

PROC	savepic()
DEF	fh, dtw:PTR TO dtwrite

	getfile(SAVE,'Select file to save',NIL)

	IF ^fullpath <> NIL	

		/*If we have changed screenmode, set this*/

		SetDTAttrs(o,0,0,[PDTA_MODEID,modeid])

		/*open file, domethod (write), close file*/

		fh:=Open(fullpath,NEWFILE)
		dtw:=New(SIZEOF dtwrite)
		dtw.dtw_methodid:=DTM_WRITE
		dtw.dtw_filehandle:=fh
		dtw.dtw_ginfo:=NIL
		dtw.dtw_mode:=0
		domethoda(o,dtw)
		Close(fh)
	ELSE
		WriteF('File save failed')
	ENDIF

ENDPROC
/*****************************************************/
/* Do a screenmode requester. Do it on WB so we can see 
** it if pens are bad. Not sure if the way it saves ham
** mode is right. But it works. 8-)
*/
PROC	screenmode()
DEF req:PTR TO filerequestr,ham=0


IF aslbase:=OpenLibrary('asl.library',39)
    IF req:=AllocAslRequest(ASL_SCREENMODEREQUEST,NIL)

	WbenchToFront()

/*these tags are in my pmodules as they are 2.1+ */

      IF AslRequest(req,[ASL_HAIL,'Choose new screenmode',ASL_WINDOW,0,
						ASLSM_DOWIDTH,TRUE,ASLSM_DOHEIGHT,TRUE,
						ASLSM_DOOVERSCANTYPE,TRUE,ASL_HEIGHT,300,
						ASLSM_INITIALDISPLAYID,modeid,
						ASLSM_INITIALDISPLAYWIDTH,scr.width,
						ASLSM_INITIALDISPLAYHEIGHT,scr.height,NIL])
/*Keep ham bit if its there*/
						ham:=And($800,modeid)					
/*and OR it back in*/
						modeid:=Or(ham,req.reserved1)
					scrflag:=1 /*set this so that repeat until loop loops*/
						ret:=1
						WriteF('ModeID:    : 0x\h\n',modeid)
	  
      ENDIF  
	FreeAslRequest(req)
    ELSE
      WriteF('Could not open filerequester!\n')
    ENDIF
	CloseLibrary(aslbase)
ELSE
	WriteF('Could not open asl.library!\n')
ENDIF

ENDPROC
/*****************************************************/
/* HMM, I had to write this in ASM coz I could not get OpenScreenTagList
** to work with E !!!!!!  Maybe it's just me
*/
PROC  openscr()
DEF s
		MOVE.L	intuitionbase,A6
		SUBA.L	A0,A0
		MOVE.L	#0,-(A7)
		MOVE.L	#TRUE,-(A7)
		MOVE.L	#SA_AUTOSCROLL,-(A7)
		MOVE.L	#TRUE,-(A7)
		MOVE.L	#SA_BEHIND,-(A7)
		MOVE.L	#TRUE,-(A7)
		MOVE.L	#SA_QUIET,-(A7)
		MOVE.L	#FALSE,-(A7)
		MOVE.L	#SA_SHOWTITLE,-(A7)
		MOVE.L	modeid,-(A7)
		MOVE.L	#SA_DISPLAYID,-(A7)
		MOVE.L	fri,A2
		MOVE.L	20(A2),-(A7)
		MOVE.L	#SA_DEPTH,-(A7)
		MOVE.L	16(A2),-(A7)
		MOVE.L	#SA_HEIGHT,-(A7)
		MOVE.L	12(A2),-(A7)
		MOVE.L	#SA_WIDTH,-(A7)
		MOVE.L	#TRUE,-(A7)
		MOVE.L	#SA_INTERLEAVED,-(A7)
		MOVE.L	#OSCAN_MAX,-(A7)
		MOVE.L	#SA_OVERSCAN,-(A7)

		MOVE.L	A7,A1
		JSR		-612(A6)
		MOVE.L	D0,s
		ADDA.L	#84,A7

ENDPROC	s
/***********************************************************/
/* This routine sets all the pen colors using SetRGB32 and had to be done 
** in ASM due to no WB3 Emodules
*/
PROC docregs(numcolors)		/*set color registers*/
	
	MOVEQ	#0,D4	
	MOVE.L	numcolors,D5
rgbloop:
	MOVEA.L	scr,A0
	LEA		44(A0),A0		/*Viewport*/
	MOVE.L	D4,D0
	MULU	#12,D0
	MOVEA.L	cregs,A3
	MOVE.L	0(A3,D0.L),D1
	MOVE.L	4(A3,D0.L),D2
	MOVE.L	8(A3,D0.L),D3
	MOVE.L	D4,D0
	MOVE.L	gfxbase,A6
	JSR		-852(A6)		/*SetRGB32*/
	ADDQ.L	#1,D4			/*step1 */
	CMP.L	D4,D5
	BNE.S	rgbloop	
ENDPROC
/****************************************************************/

