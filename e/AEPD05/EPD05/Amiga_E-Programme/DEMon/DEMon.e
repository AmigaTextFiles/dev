/*

TABSIZE = 4

DEMon V1.0
Mein erstes richtiges E-Programm. Nimm meins oder keins.
*/

ENUM NONE,ER_OPENGADTOOLS,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,ER_MENUS, ER_TRACKDISK


MODULE	'devices/trackdisk','dos/dos','exec/devices','exec/io','exec/memory',
		'exec/nodes','exec/ports','gadtools','graphics/text',
		'intuition/gadgetclass','intuition/intuition','intuition/screens',
		'libraries/gadtools','ReqTools','utility/tagitem'

ENUM	BLOCKGADGET,BLOCKMEHR,BLOCKWENIGER,DF0GADGET,DF1GADGET,DF2GADGET,
		DF3GADGET,OFFSETWECHSELN

CONST	FIRST_HALF=0,SECOND_HALF=1,ANZAHL_GADGETS=8,
		OFFSET_X=10,OFFSET_Y=5

DEF meinwin:PTR TO window,intmessage:PTR TO intuimessage,
    meincode,meineklasse,laufwerksnummer,blocknummer,
    blockpuffer[512]:STRING,displaymode,nummer_editbyte,davor,
	tabelle[16]:STRING, block_changed,scr:PTR TO screen,
	prog_version[33]:STRING,
	meinegadgetid,
	sinfo:PTR TO stringinfo,
	ioreq:PTR TO ioexttd,
	zahl_x, zkette_x[80]:STRING,
	vinfo=NIL,menu,ok_to_quit,
	gadliste[ANZAHL_GADGETS]:ARRAY OF gadget,
	gad: PTR TO gadget,
	meineiaddress:PTR TO gadget,
	blockgadget:PTR TO gadget,
	laufwerk0gadget:PTR TO gadget,
	laufwerk1gadget:PTR TO gadget,
	laufwerk2gadget:PTR TO gadget,
	laufwerk3gadget:PTR TO gadget,
	blockmehrgadget:PTR TO gadget,
	blockwenigergadget:PTR TO gadget,
	offsetwechselngadget:PTR TO gadget,
	laufwerksname[4]:STRING,
	displayinformation

PROC main() HANDLE
  gadliste := NIL /* wichtig */
  displayinformation := FALSE
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',37)) = 0
    WriteF('reqtools.library V37 konnte nicht geöffnet werden!\n')
    RETURN(20)
  ENDIF
  IF(gadtoolsbase := OpenLibrary('gadtools.library', 37)) = NIL THEN Raise(ER_OPENGADTOOLS)
  IF(scr := LockPubScreen('Workbench')) = NIL THEN Raise(ER_WB)
  IF(vinfo := GetVisualInfoA(scr, NIL)) = NIL THEN Raise(ER_VISUAL)
  IF (gad := CreateContext({gadliste})) = NIL THEN Raise(ER_CONTEXT)
  IF (menu := CreateMenusA([NM_TITLE,0,'Project',0,0,0,0,
	NM_ITEM,	0,	'Laden',		0,	0,0,0,
	NM_SUB,		0,	'Block',		'l',0,0,0,
	NM_SUB,		0,	'Datei',		0,	0,0,0,
	NM_ITEM, 	0,	'Speichern',	0,	0,0,0,
	NM_SUB,		0,	'Block',		's',0,0,0,
	NM_SUB,		0,	'Datei',		0,	0,0,0,
	NM_ITEM,	0,	NM_BARLABEL,	0,	0,0,0,
	NM_ITEM,	0,	'Ende',			'E',0,0,0,
	NM_TITLE,	0,	'Verschiedenes',0,	0,0,0,
	NM_ITEM,	0,	'Suchen',		'S',0,0,0,
	NM_ITEM,	0,	'Editieren',	'e',0,0,0,
	NM_ITEM,	0,	'Offset wechseln',0,0,0,0,
	0,0,0,0,0,0,0]:newmenu,NIL)) = NIL THEN Raise(ER_MENUS)
  IF LayoutMenusA(menu,vinfo,NIL)=FALSE THEN Raise(ER_MENUS)

  StrCopy(laufwerksname, 'DF0:', ALL) /* s. Laufwerkgaddies */

  gad := CreateGadgetA(INTEGER_KIND,gad,
  [255,OFFSET_Y+190,56,12,'Block',['topaz.font',8,0,0]:textattr,BLOCKGADGET,0,vinfo,0]:newgadget,
  [GTIN_NUMBER,0,GTIN_MAXCHARS,4,0])
  blockgadget := gad

  gad := CreateGadgetA(BUTTON_KIND,gad,
  [315,OFFSET_Y+190,21,12,'+',['topaz.font',8,0,0]:textattr,BLOCKMEHR,0,vinfo,0]:newgadget,
  0)
  blockmehrgadget := gad

  gad := CreateGadgetA(BUTTON_KIND,gad,
  [340,OFFSET_Y+190,21,12,'-',['topaz.font',8,0,0]:textattr,BLOCKWENIGER,0,vinfo,0]:newgadget,
  [0])
  blockwenigergadget := gad

  gad := CreateGadgetA(BUTTON_KIND,gad,
  [143,OFFSET_Y+190,38,12,'DF3:',['topaz.font',8,0,0]:textattr,DF3GADGET,0,vinfo,0]:newgadget,
  0)
  laufwerk3gadget := gad

  gad := CreateGadgetA(BUTTON_KIND,gad,
  [103,OFFSET_Y+190,38,12,'DF2:',['topaz.font',8,0,0]:textattr,DF2GADGET,0,vinfo,0]:newgadget,
  0)
  laufwerk2gadget := gad

  gad := CreateGadgetA(BUTTON_KIND,gad,
  [63,OFFSET_Y+190,38,12,'DF1:',['topaz.font',8,0,0]:textattr,DF1GADGET,0,vinfo,0]:newgadget,
  0)
  laufwerk1gadget := gad

  gad := CreateGadgetA(BUTTON_KIND,gad,
  [23,OFFSET_Y+190,38,12,'DF0:',['topaz.font',8,0,0]:textattr,DF0GADGET,0,vinfo,0]:newgadget,
  0)
  laufwerk0gadget := gad


  gad := CreateGadgetA(BUTTON_KIND,gad,
  [545,OFFSET_Y+190,21,12,'Offset wechseln',['topaz.font',8,0,0]:textattr,OFFSETWECHSELN,PLACETEXT_LEFT,vinfo,0]:newgadget,
  [0])
  offsetwechselngadget := gad

  meinwin:=OpenWindowTagList(NIL,[WA_HEIGHT,250,
  WA_WIDTH,640,
  WA_IDCMP,(IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY OR IDCMP_MENUPICK OR IDCMP_MENUHELP OR IDCMP_GADGETUP OR IDCMP_REFRESHWINDOW),
  WA_TITLE,'DEMon1.0b',
  WA_CLOSEGADGET,TRUE,
  WA_DEPTHGADGET,TRUE,
  WA_DRAGBAR,TRUE,
  WA_MENUHELP,TRUE,
  WA_GADGETS,gadliste,
  WA_ACTIVATE,TRUE])

  	DrawBevelBoxA(meinwin.rport,OFFSET_X-2,OFFSET_Y+10,392,135,[GT_VISUALINFO,vinfo,0])
/* hex: 8,15 - 400,150 */
  	DrawBevelBoxA(meinwin.rport,(OFFSET_X+480-8),OFFSET_Y+10,(16*8)+12,135,[GT_VISUALINFO,vinfo,0])
/* ascii: 472,15 - 622,150 */
  	DrawBevelBoxA(meinwin.rport,OFFSET_X-2,OFFSET_Y+186,(640-8-OFFSET_X-8),20,[GT_VISUALINFO,vinfo,0])
/* gadgets: 8,191 - 622,211*/
  	DrawBevelBoxA(meinwin.rport,OFFSET_X-2,OFFSET_Y+150,(640-8-OFFSET_X-8),32,[GT_VISUALINFO,vinfo,0])
/* information: 8,155 - 622,187*/


  IF SetMenuStrip(meinwin,menu)=FALSE THEN Raise(ER_MENUS)
  Gt_RefreshWindow(meinwin,NIL)

  ioreq := trackdisk_open(3)
  IF(ioreq > 0)
	laufwerksname[2] := "3"
	trackdisk_close(ioreq)
  ELSE
	Gt_SetGadgetAttrsA(laufwerk3gadget,meinwin,0,[GA_DISABLED,TRUE] ) /* aus das ding */
  ENDIF
  ioreq := trackdisk_open(2)
  IF(ioreq > 0)
	laufwerksname[2] := "2"
	trackdisk_close(ioreq)
  ELSE
	Gt_SetGadgetAttrsA(laufwerk2gadget,meinwin,0,[GA_DISABLED,TRUE] ) /* aus das ding */
  ENDIF
  ioreq := trackdisk_open(1)
  IF(ioreq > 0)
	laufwerksname[2] := "1"
	trackdisk_close(ioreq)
  ELSE
	Gt_SetGadgetAttrsA(laufwerk1gadget,meinwin,0,[GA_DISABLED,TRUE] ) /* aus das ding */
  ENDIF
  ioreq := trackdisk_open(0)
  IF(ioreq > 0)
	laufwerksname[2] := "0"
	trackdisk_close(ioreq)
  ELSE
	Gt_SetGadgetAttrsA(laufwerk0gadget,meinwin,0,[GA_DISABLED,TRUE] ) /* aus das ding */
  ENDIF

  displayinformation := TRUE /* zeig's mir */

  ioreq := trackdisk_open(laufwerksname[2]-"0")
/* laufwerksname = das letzte vorhandene Laufwerk( von 3 nach 0 ) */
  Inhibit(laufwerksname,DOSTRUE)
  

/* viele Initialisierungen */
  StrCopy(prog_version,'$VER: DEMon 1.0b von Glotter Giger',ALL)
  blocknummer := 0
  laufwerksnummer := 0
  ok_to_quit := FALSE
  displaymode := FIRST_HALF /* erste Hälfte des Blocks darstellen */
  SetAPen( meinwin.rport, 1 ) /* kein editing */
  nummer_editbyte := -1
  davor := -1
  StrCopy(tabelle,'0123456789ABCDEF',ALL)

  trackdisk_readblock(ioreq,0)
  trackdisk_motor(ioreq,FALSE)
  displayblock( blockpuffer )
  printinformation('DEMon 1.0b von Glotter Giger','Limitierte Veröffentlichung für Jörg Wach','Help = Tastaturbelegung')
    
  REPEAT
  	DrawBevelBoxA(meinwin.rport,OFFSET_X-2,OFFSET_Y+10,392,135,[GT_VISUALINFO,vinfo,0])
/* hex: 8,15 - 400,150 */
  	DrawBevelBoxA(meinwin.rport,(OFFSET_X+480-8),OFFSET_Y+10,(16*8)+12,135,[GT_VISUALINFO,vinfo,0])
/* ascii: 472,15 - 622,150 */
  	DrawBevelBoxA(meinwin.rport,OFFSET_X-2,OFFSET_Y+186,(640-8-OFFSET_X-8),20,[GT_VISUALINFO,vinfo,0])
/* gadgets: 8,191 - 622,211*/
  	DrawBevelBoxA(meinwin.rport,OFFSET_X-2,OFFSET_Y+150,(640-8-OFFSET_X-8),32,[GT_VISUALINFO,vinfo,0])
/* information: 8,155 - 622,187*/

    WaitPort(meinwin.userport)
    intmessage := Gt_GetIMsg(meinwin.userport)
    meincode := intmessage.code
    meineklasse := intmessage.class
	meineiaddress := intmessage.iaddress
	meinegadgetid := meineiaddress.gadgetid
    Gt_ReplyIMsg(intmessage)
	SELECT meineklasse
	  CASE IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(meinwin)
        Gt_EndRefresh(meinwin,TRUE)
	  CASE IDCMP_GADGETUP
		SELECT meinegadgetid
		  sinfo := meineiaddress.specialinfo
		  CASE BLOCKGADGET
			blocknummer := sinfo.longint
			IF(blocknummer>1759) THEN blocknummer := 1759
			IF(blocknummer<0) THEN blocknummer := 0
			printinformation('Alles OK',0,0)
		  CASE BLOCKMEHR
			IF (ioreq < 0)
			  printinformation('Fehler bei trackdisk_open()!','Bitte anderes Laufwerk wählen',0)
			ELSE
			  sinfo := blockgadget.specialinfo
			  blocknummer := sinfo.longint+1
			  IF(blocknummer>1759) THEN blocknummer := 1759
			  Gt_SetGadgetAttrsA(blockgadget,meinwin,0,[GTIN_NUMBER,blocknummer])
			  handle_menus(%0000000000000000) /* 0 0 0 = block laden*/
			ENDIF
		  CASE BLOCKWENIGER
			IF (ioreq < 0)
			  printinformation('Fehler bei trackdisk_open()!','Bitte anderes Laufwerk wählen',0)
			ELSE
			  sinfo := blockgadget.specialinfo
			  blocknummer := sinfo.longint-1
			  IF(blocknummer<0) THEN blocknummer := 0
			  Gt_SetGadgetAttrsA(blockgadget,meinwin,0,[GTIN_NUMBER,blocknummer])
			  handle_menus(%0000000000000000) /* 0 0 0 = blockladen*/
			ENDIF

		  CASE DF0GADGET
			jumptodrive(0)
		  CASE DF1GADGET
			jumptodrive(1)
		  CASE DF2GADGET
			jumptodrive(2)
		  CASE DF3GADGET
			jumptodrive(3)


		  CASE OFFSETWECHSELN
			handle_menus(%0000000001000001)
		ENDSELECT
	  CASE IDCMP_MENUHELP
		RtEZRequestA('Leider noch nicht implementiert!','Schade',0,0,0)
		WriteF('Menuhelp,Message->Code = \d\n',meincode)
	  CASE IDCMP_CLOSEWINDOW
		IF (block_changed = TRUE) 
		  handle_menus(%0000000001100000)
		  /* ähem, da wird's behandelt, Menü 0, Item 3, Subitem 0 == Ende */
		ELSE
		  ok_to_quit := TRUE
		ENDIF
	  CASE IDCMP_MENUPICK
		IF (ioreq < 0)
		  printinformation('ioreq nicht korrekt!','Bitte anderes Laufwerk wählen',0)
		ELSE
		  handle_menus(meincode)
		ENDIF
	  CASE IDCMP_RAWKEY
		SELECT meincode
		  CASE 68
			handle_menus(%0000000000100001) /* Menü 1, Punkt 1, 0 */
		  CASE 76 /* arrowup */
			IF ((nummer_editbyte>15) AND (nummer_editbyte > -1)) THEN nummer_editbyte := (nummer_editbyte-16)
			hilitebyte(blockpuffer,nummer_editbyte)
		  CASE 77
		/* arrowdown */
			IF ((nummer_editbyte<=239) AND (nummer_editbyte > -1)) THEN nummer_editbyte := (nummer_editbyte+16)
			hilitebyte(blockpuffer,nummer_editbyte)
		  CASE 78
		/* arrow right  */
			IF ((nummer_editbyte<255) AND (nummer_editbyte > -1)) THEN nummer_editbyte++
			hilitebyte(blockpuffer,nummer_editbyte)
		  CASE 79
		/* arrow left */
			IF ((nummer_editbyte>0) AND (nummer_editbyte > -1)) THEN nummer_editbyte--
			hilitebyte(blockpuffer,nummer_editbyte)
          CASE 80
			handle_menus(%0000000000000001) /* dreckig, dreckig */
		  CASE 81
			displaymode := FIRST_HALF
			displayblock(blockpuffer) /* komplett neu darstellen */
			hilitebyte(blockpuffer,nummer_editbyte)
		  CASE 82
			displaymode := SECOND_HALF
			displayblock(blockpuffer)
			hilitebyte(blockpuffer,nummer_editbyte)
		  CASE 83
			IF(nummer_editbyte > -1)
			  editbyte(blockpuffer,nummer_editbyte)
			  hilitebyte(blockpuffer,nummer_editbyte)
			ELSE
			  RtEZRequestA('Nur im\nEditier-Modus!','\aTschuldigung',0,0,0)
			ENDIF
		  CASE 95
			userhelp()
		  DEFAULT
        ENDSELECT
	ENDSELECT
  UNTIL (ok_to_quit = TRUE)
  IF meinwin THEN ClearMenuStrip(meinwin)
  IF menu THEN FreeMenus(menu)
  IF vinfo THEN FreeVisualInfo(vinfo)
  IF( ioreq > 0 )
	trackdisk_close(ioreq)
	Inhibit(laufwerksname,DOSFALSE)
  ENDIF

  CloseWindow(meinwin)
/* Erst NACH Fensterschließen freigeben, da die Bereiche schon mit dem
   zumachen des Fensters evtl. frei sind. Danke Jörg!*/

  IF gadliste THEN FreeGadgets(gadliste)

  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)

  CloseLibrary(reqtoolsbase)
  RETURN(0)
EXCEPT
  CloseLibrary(reqtoolsbase)
  IF(ioreq > 0)
	trackdisk_close(ioreq)
	Inhibit(laufwerksname,DOSFALSE)
  ENDIF
  IF meinwin THEN ClearMenuStrip(meinwin)
  IF menu THEN FreeMenus(menu)
  IF vinfo THEN FreeVisualInfo(vinfo)
  IF(meinwin) THEN CloseWindow(meinwin)
  IF gadliste THEN FreeGadgets(gadliste)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  WriteF('Fehler Nummer %d\n',exception)
  CleanUp(20) 

ENDPROC


PROC displayblock(puffer)
DEF s[2]:STRING,c1,c2,zeile,spalte,i,offset

  SetAPen(meinwin.rport,1)

  SELECT displaymode
	CASE FIRST_HALF
	  offset := 0
	CASE SECOND_HALF
	  offset := 256
  ENDSELECT

  spalte := 0
  zeile := 0
  FOR i := 0 TO 255
    IF (i/16)*16 = i
      zeile++ /* bildschirmzeile, erste erhöhung bei i=0 */
      spalte := 0
    ELSE
      spalte++
    ENDIF
    c2 := puffer[i+offset]
    c1 := (c2/16)
    c2 := c2-(c1*16)
    s[0] := tabelle[c1]
    s[1] := tabelle[c2]

    Move(meinwin.rport,OFFSET_X+6+(spalte*3*8),OFFSET_Y+12+(zeile*8))
    Text(meinwin.rport,s,2)
	s[0] := puffer[i+offset]
	IF (((s[0] >= 0) AND (s[0] <= 31)) OR ((s[0] >= (128+0)) AND (s[0] <=(128+31))))
		s[0] := "."
	ENDIF
	Move(meinwin.rport,OFFSET_X+480+(spalte*8),OFFSET_Y+12+(zeile*8))
	Text(meinwin.rport,s,1)

  ENDFOR
ENDPROC

/* loadblock dateiname,puffer
	lade datei in puffer der größe 512
*/
PROC loadblock(dateiname, puffer)
DEF handle, laufvar
  handle := Open(dateiname, MODE_OLDFILE)
  /* hier fehlerabfrage */
  FOR laufvar := 0 TO 511
	puffer[laufvar] := Inp(handle)
  ENDFOR
  Close(handle)
  block_changed := FALSE
ENDPROC

PROC saveblock(dateiname, puffer)
DEF handle, laufvar
  handle := Open(dateiname,MODE_NEWFILE)
  FOR laufvar := 0 TO 511
	Out(handle,puffer[laufvar])
  ENDFOR
  Close(handle)
  block_changed := FALSE
ENDPROC

/* hilitebyte
   druckt das nummer-te zeichen im puffer in farbe 2
*/
PROC hilitebyte(puffer,nummer)
DEF c1,c2,s[2]:STRING,zeile,spalte,offset

  SELECT displaymode
	CASE FIRST_HALF
	  offset := 0
	CASE SECOND_HALF
	  offset := 256
  ENDSELECT

/* zuerst das hilite-byte normal überschreiben */
  IF davor > -1
	  zeile := davor/16
	  spalte := davor-(zeile*16)
	  SetAPen(meinwin.rport,1)
	/* HEX */
	  c2 := puffer[davor+offset]
	  c1 := (c2/16)
	  c2 := c2-(c1*16)
	  s[0] := tabelle[c1]
	  s[1] := tabelle[c2]
	  Move(meinwin.rport,OFFSET_X+6+(spalte*3*8),OFFSET_Y+12+8+(zeile*8))
	  Text(meinwin.rport,s,2)
	/* ASCII */
	  s[0] := puffer[davor+offset]
	  IF (((s[0] >= 0) AND (s[0] <= 31)) OR ((s[0] >= (128+0)) AND (s[0] <= (128+31))))
		s[0] := "."
	  ENDIF
	  Move(meinwin.rport,OFFSET_X+480+(spalte*8),OFFSET_Y+12+8+(zeile*8))
	  Text(meinwin.rport,s,1)
  ENDIF

  SELECT nummer
	CASE -1
	  printinformation('Editieren nicht möglich','RETURN drücken, um Editieren zu beginnen/beenden',0)
	DEFAULT /* byte hiliten */
	  SetAPen(meinwin.rport,2)
	  zeile := nummer/16
	  spalte := nummer-(zeile*16)
	/* erst Zeichen links als HEX ausgeben */
	  c2 := puffer[nummer+offset]
	  c1 := (c2/16)
	  c2 := c2-(c1*16)
	  s[0] := tabelle[c1]
	  s[1] := tabelle[c2]
	  Move(meinwin.rport,OFFSET_X+6+(spalte*3*8),OFFSET_Y+12+8+(zeile*8))
	  Text(meinwin.rport,s,2)
	/* jetzt rechts das ASCII-Zeichen ausgeben */
	  s[0] := puffer[nummer+offset]
	  IF (((s[0] >= 0) AND (s[0] <= 31)) OR ((s[0] >= (128+0)) AND (s[0] <= (128+31))))
		s[0] := "."
	  ENDIF
	  Move(meinwin.rport,OFFSET_X+480+(spalte*8),OFFSET_Y+12+8+(zeile*8))
	  Text(meinwin.rport,s,1)
  ENDSELECT
  davor := nummer
ENDPROC

PROC editbyte(blockpuffer,bytenummer)
DEF puffer[9]:STRING,readvar,nummer,offset
  SELECT displaymode
	CASE FIRST_HALF
	  offset := 0
	CASE SECOND_HALF
	  offset := 256
  ENDSELECT

  RtGetStringA(puffer,9,'Zahleingabe HEX=$.. DEC=... BIN=%......',0,0)
  nummer := Val(puffer, {readvar})
  IF(((nummer = 0) AND (readvar = 0)) OR (nummer > 255) OR (nummer < 0))
	RtEZRequestA('Falsche Eingabe!','\aTschuldigung',0,0,0)
  ELSE
	blockpuffer[bytenummer+offset] := nummer
	block_changed := TRUE
  ENDIF
ENDPROC

PROC userhelp()
  RtEZRequestA('Dmon V1.0b von Glotter Giger\n'+
'LIMITIERTE VERÖFFENTLICHUNG FÜR JÖRG WACH\n'+
'Tastaturbelegung:\n\n'+
'F1      -- Zeichenkette auf aktueller Diskette suchen\n'+
'F2      -- die ersten 256 Byte des Blockinhalts darstellen\n'+
'F3      -- die letzten 256 Byte des Blockinhalts darstellen\n'+
'F4      -- im Editier-Modus: aktuelles Byte verändern\n'+
'Return  -- zwischen Darstellung und Editieren umschalten\n'+
'Cursor  -- aktuelles Byte wechseln\n'+
'Help    -- dieser EZReq' ,'Interessant!',0,0,0)
ENDPROC

PROC handle_menus(code)
DEF titel,item,subitem,gadnummer,zkette[50]:STRING

  titel := (code AND %11111) /* Bits 0-4 */
  item := ((code/32) AND %111111) /* Bits 5-11 */
  subitem := ((code/2048) AND %11111) /* Bits 11-15 */

  IF (code < 65535)
	SELECT titel

	  CASE 0 /* Project */
		SELECT item

		  CASE 0	/* Menü 0, Punkt 0: Laden */
			IF(trackdisk_diskindrive(ioreq)) /* Diskette ist drin */
			  SELECT subitem

				CASE 0	/* Block */
				  IF (block_changed = TRUE)
					gadnummer := RtEZRequestA('HALT!!! Veränderungen am Pufferinhalt wurden noch nicht gesichert!',
					'Erst sichern|Macht nix|Abbrechen',0,0,0)
					SELECT gadnummer

					  CASE 2
						do_load_block()
					  CASE 1
						RtGetStringA(zkette,50,'Dateiname:',0,0)
						IF(zkette[0] > 0) /* Name gewählt */
						  printinformation('Speichere Blockinhalt',0,0)
						  saveblock(zkette,blockpuffer)
						ELSE
						  printinformation('Speichere Puffer NICHT','Block wird jedoch geladen',0)
						ENDIF
						do_load_block()

					ENDSELECT
				  ELSE /* (block_changed = FALSE) */
					do_load_block()
				  ENDIF
				CASE 1 /* Datei */
				  IF (block_changed = FALSE)
					RtGetStringA(zkette,50,'Dateiname:',0,0)
					loadblock(zkette, blockpuffer)
					displayblock(blockpuffer)
					hilitebyte(blockpuffer,nummer_editbyte)
				  ELSE
					gadnummer := RtEZRequestA('HALT!!! Veränderungen am Pufferinhalt wurden noch nicht gesichert!',
					'Macht nix|Abbrechen', 0,0,0)
					IF(gadnummer = 1)
					  RtGetStringA(zkette,50,'Dateiname:',0,0)
					  loadblock(zkette,blockpuffer)
					  displayblock(blockpuffer)
					  hilitebyte(blockpuffer,nummer_editbyte)
					ENDIF
				  ENDIF

			  ENDSELECT
			ELSE
			  RtEZRequestA('Bitte erst eine Diskette einlegen...','Gern!',0,0,0)
			ENDIF
		  CASE 1	/* Menü 0, Punkt 1: Speichern */
			IF(trackdisk_diskindrive(ioreq) AND (trackdisk_diskprotected(ioreq)=FALSE))
			  SELECT subitem

				CASE 0	/* Block */
				  IF (block_changed = TRUE)
					do_save_block()
				  ELSE
					RtEZRequestA('Inhalt wurde nicht verändert!', 'Nicht speichern', 0,0,0)
				  ENDIF
				CASE 1	/* Datei */
				  RtGetStringA(zkette,50,'Dateiname:',0,0)
				  IF(zkette[0] >0) /* Name gewählt */
					RtEZRequestA('Speichere Blockinhalt','Aha',0,0,0)
					saveblock(zkette,blockpuffer)
				  ELSE
					RtEZRequestA('Speichere Blockinhalt NICHT!','Soso',0,0,0)
				  ENDIF

			  ENDSELECT
			ELSE
			  RtEZRequestA('Bitte erst eine Diskette einlegen','Gern!',0,0,0)
			ENDIF

		  CASE 3	/* Menü 0, Punkt 3: Ende */
			IF (block_changed = TRUE)
			  gadnummer := RtEZRequestA('HALT!!! Veränderungen am Pufferinhalt wurden noch nicht gesichert!',
			  'Erst sichern|Macht nix|Abbrechen', 0,0,0)
			  SELECT gadnummer

				CASE 0
				  ok_to_quit := FALSE
				CASE 2
				  ok_to_quit := TRUE /* bye, tschüss */
				CASE 1
				  RtEZRequestA('Schreib Block zurück','#?%$',0,0,0)
				  do_save_block()

			  ENDSELECT
			ELSE /* (block_changed = FALSE) */
			  ok_to_quit := TRUE
			ENDIF

		ENDSELECT
	  CASE 1 /* Verschiedenes */
		SELECT item /* Menü 1, Punkt 0: Suchen */

		  CASE 0
			IF(ioreq > 0)
			  RtGetStringA(zkette_x,80,'Zeichenkette eingeben:',0,0)
			  sinfo := blockgadget.specialinfo
			  zahl_x := RtEZRequestA('Ab welchem Block soll gesucht werden?','Block 0|Von hier', 0,0,0)
			  IF(zahl_x = 1)
				searchforstring(ioreq,zkette_x,0)
			  ELSE
				searchforstring(ioreq,zkette_x,sinfo.longint)
			  ENDIF
			ELSE
			  printinformation('ioreq nicht korrekt','Bitte anderes Laufwerk wählen',0)
			ENDIF
		  CASE 1 /* Editieren */
			IF(nummer_editbyte = -1)
			  nummer_editbyte := 0
			  printinformation('Editieren ist nun möglich','Pfeiltasten - Byte wechseln','F4 - Byte verändern')
			ELSE
			  nummer_editbyte := -1
			ENDIF
			hilitebyte(blockpuffer,nummer_editbyte)
		  CASE 2 /* Offset wechseln */
			IF (ioreq < 0)
			  printinformation('Fehler bei trackdisk_open()!','Bitte anderes Laufwerk wählen',0)
			ELSE
			  IF(displaymode = FIRST_HALF)
				displaymode :=  SECOND_HALF
				printinformation('Offset des Blocks wird gewechselt','Sie sehen nun die zweite Hälfte','Bytes 256 bis 511')
			  ELSEIF(displaymode = SECOND_HALF)
				displaymode := FIRST_HALF
				printinformation('Offset des Blocks wird gewechselt','Sie sehen nun die erste Hälfte','Bytes 0 bis 255')
			  ENDIF
			  displayblock(blockpuffer)
			  displayinformation := FALSE /* nur vorübergehend so */
			  hilitebyte(blockpuffer,nummer_editbyte)
			  displayinformation := TRUE /* versprochen, wird anders demnächst */
			ENDIF			
		ENDSELECT

	ENDSELECT
  ELSE
	NOP
  ENDIF
ENDPROC

PROC do_save_block()

  IF(ioreq > 0)
	trackdisk_writeblock(ioreq, blocknummer)
	trackdisk_motor(ioreq,FALSE)
	block_changed := FALSE
  ELSE
	printinformation('ioreq nicht korrekt','Bitte anderes Laufwerk wählen','Block nicht gespeichert')
  ENDIF


ENDPROC

PROC do_load_block()

  IF(ioreq > 0)
	trackdisk_readblock(ioreq, blocknummer)
	trackdisk_motor(ioreq,FALSE)
	block_changed := FALSE
  ELSE
	printinformation('ioreq nicht korrekt','Bitte anderes Laufwerk wählen','Block wurde NICHT geladen')
  ENDIF
  displayblock(blockpuffer)
  hilitebyte(blockpuffer,nummer_editbyte)

ENDPROC


/*
Ein schnuckeliger Set von trackdisk-routinen

trackdisk_open(ioexttd)
 Device öffnen, mit Fehler
trackdisk_close(ioexttd)
 Device schließen
trackdisk_motor(ioexttd,bool)
 Motor an/aus
trackdisk_readblock(ioexttd,blocknummer)
 lies den angegebenen Block in BLOCKPUFFER
trackdisk_writeblock(ioexttd,blocknummer)
 schreibt den Block aus BLOCKPUFFER
*/




PROC trackdisk_open(laufwerksnummer)
DEF ioreq:PTR TO ioexttd,meinport:mp,fehler

  IF((laufwerksnummer < 0) OR (laufwerksnummer >3))
	printinformation('Fehler in trackdisk_open()','Laufwerksnummer zu klein/groß','Bitte anderes Laufwerk wählen')
    RETURN(-1)
  ELSE
	meinport := CreateMsgPort()
	IF (meinport = NIL)
  	  printinformation('Fehler in trackdisk_open()','Fehler bei CreateMsgPort()','Wahrscheinlich Speichermangel')
	  RETURN(-2)
	ENDIF
	ioreq := CreateIORequest(meinport, SIZEOF ioexttd)
	IF (ioreq = NIL)
	  printinformation('Fehler in trackdisk_open()','Fehler bei CreateIORequest','???')
	  DeleteMsgPort(meinport)
	  RETURN(-3)
	ENDIF
	fehler := OpenDevice('trackdisk.device',laufwerksnummer,ioreq,0)
	IF(fehler)
	  printinformation('Fehler in trackdisk_open()','OpenDevice() schlug fehl!','Falsche Parameter ???')
	  DeleteIORequest(ioreq)
	  DeleteMsgPort(meinport)
	  RETURN(-4)
	ELSE
	  RETURN(ioreq)
	ENDIF
  ENDIF
ENDPROC

PROC trackdisk_close(ioreq)
DEF ioreq2:PTR TO ioexttd,ios:iostd,nn:mn

  ioreq2 := ioreq
  CloseDevice(ioreq)
  DeleteIORequest(ioreq)
  ios := ioreq2.iostd
  nn := ios.mn
  DeleteMsgPort(nn.replyport)
  ioreq := 0

ENDPROC

PROC trackdisk_motor(ior,flag)
DEF ios:iostd,io2:PTR TO ioexttd
  io2 := ior
  ios := io2.iostd
  IF flag THEN ios.length := 1 ELSE ios.length := 0
  ios.command := TD_MOTOR
  DoIO(ior)
ENDPROC


PROC trackdisk_getchangenum(ior)
DEF io2:PTR TO ioexttd,ios:iostd
  io2:=ior			/* merkwürdig, sonst kann man nicht zugreifen */
  ios := io2.iostd
  ios.command := TD_CHANGENUM
  DoIO(ior)
  RETURN ios.actual
ENDPROC

PROC trackdisk_readblock(ior,nummer)
DEF io2:PTR TO ioexttd,ios:iostd,slabelpuffer[16]:STRING
  io2 := ior
  ios := io2.iostd
  io2.count := trackdisk_getchangenum(ior)
  ios.offset := nummer*512 /*Block 0*/
  ios.data := blockpuffer
  ios.length := TD_SECTOR
  io2.seclabel := slabelpuffer
  ios.command := ETD_READ
  DoIO(ior)
ENDPROC


PROC trackdisk_writeblock(ior,nummer)
DEF io2:PTR TO ioexttd,ios:iostd,slabelpuffer[16]:STRING,laufvar
  FOR laufvar := 0 TO 15 DO slabelpuffer[laufvar]:=0
    
  io2 := ior
  ios := io2.iostd
  io2.count := trackdisk_getchangenum(ior)
  ios.offset := nummer*512 /*Block 0*/
  ios.data := blockpuffer
  ios.length := TD_SECTOR
  io2.seclabel := slabelpuffer
  ios.command := ETD_WRITE
  DoIO(ior)
  ios.command := ETD_UPDATE /* sofort abspeichern */
  DoIO(ior)
ENDPROC

PROC searchforstring(ioreq,s,blocknr)
/* in jeweils einem Block wird gesucht, d.h. String, die über Blockgrenzen
laufen, werden nicht gefunden, ab blocknr */
DEF speicher[512]:STRING, stringfound, nr_alt

  sinfo := blockgadget.specialinfo
  nr_alt := sinfo.longint

  blocknr := blocknr-1
  REPEAT
	blocknr := blocknr+1
	Gt_SetGadgetAttrsA(blockgadget,meinwin,0,[GTIN_NUMBER,blocknr])
	trackdisk_readblock(ioreq,blocknr)
	StrCopy(speicher,blockpuffer,512)
	stringfound := InStr(speicher,s,0)
  UNTIL ((stringfound > -1) OR (blocknr = 1759))
  trackdisk_motor(ioreq,FALSE)

  IF(stringfound > -1) THEN displaymode := FIRST_HALF  
  IF(stringfound > 255) THEN displaymode := SECOND_HALF
  IF(stringfound > -1)
	nummer_editbyte := stringfound
	displayblock(blockpuffer)
	hilitebyte(blockpuffer,nummer_editbyte)
  ELSE
	RtEZRequestA('Nicht gefunden!','Tss...',0,0,0)
	Gt_SetGadgetAttrsA(blockgadget,meinwin,0,[GTIN_NUMBER,nr_alt] ) /* blocknummer wieder zurücksetzen */
	trackdisk_readblock(ioreq,nr_alt)
	displayblock(blockpuffer)
  ENDIF

  trackdisk_motor(ioreq,FALSE)
ENDPROC

PROC trackdisk_diskindrive(ior)
/* ist eine Diskette im Laufwerk ? */
DEF io2:PTR TO ioexttd,ios:iostd

  io2 := ior
  ios := io2.iostd
  ios.command := TD_CHANGESTATE
  DoIO(ior)
  IF(ios.actual = 0) THEN RETURN(TRUE) ELSE RETURN(FALSE)

ENDPROC

PROC trackdisk_diskprotected(ior)
/* ist die Diskette schreibgeschützt ? */
DEF io2:PTR TO ioexttd,ios:iostd
    
  io2 := ior
  ios := io2.iostd
  ios.command := TD_PROTSTATUS
  DoIO(ior)
  RETURN(ios.actual)

ENDPROC

PROC printinformation(s1,s2,s3)
/*Informationsbox: 8,155 - 630,187*/
  IF displayinformation
	SetAPen(meinwin.rport,0)
	RectFill(meinwin.rport,10,157,628,185)
	SetAPen(meinwin.rport,1)
	Move(meinwin.rport,8+4,155+2+6) /*ystart bei 157, 6 ist baseline*/
	Text(meinwin.rport,s1,StrLen(s1))
	Move(meinwin.rport,8+4,155+2+6+8)
	Text(meinwin.rport,s2,StrLen(s2))
	Move(meinwin.rport,8+4,155+2+6+16)
	Text(meinwin.rport,s3,StrLen(s3))
  ENDIF
ENDPROC

PROC jumptodrive(nummer)
DEF msg[15]:STRING
  StrCopy(msg,'Wechsel zu DF :',ALL)
  IF(ioreq > 0)
	trackdisk_close(ioreq)
	Inhibit(laufwerksname,DOSFALSE) /* freigeben */
  ENDIF
  ioreq := trackdisk_open(nummer)
  IF (ioreq < 0)
	printinformation('Fehler bei trackdisk_open()!','Bitte anderes Laufwerk wählen',0)
  ELSE /* falls erfolgreich, belegen */
	laufwerksname[2] := nummer+"0" /* dfX: */
	Inhibit(laufwerksname,DOSTRUE)
	msg[13]:=nummer+"0"
	printinformation('Alles OK',msg,'Blockinhalt unverändert')
  ENDIF
ENDPROC