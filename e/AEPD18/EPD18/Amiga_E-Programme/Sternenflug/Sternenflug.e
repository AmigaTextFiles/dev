/*

    Sternenflug in E

    © Marcel Bennicke 1994

	begonnen: 14.10.1994
	letzte Ä: 19.10.1994

*/

MODULE 'intuition/intuition','intuition/screens','mathtrans',
		'exec/memory','reqtools','libraries/reqtools','utility/tagitem'


ENUM E_NONE,E_WIN,E_LIB,E_MEM

CONST	BACKGROUND = 1, STARS = 2


DEF	erlist:PTR TO LONG,sin:PTR TO INT,cos:PTR TO INT,
	wi:PTR TO window,arrays=NIL,ende=FALSE,
	
	menus,anzstring[20]:STRING,drehstring[20]:STRING,

	w:PTR TO INT,		/* Flugwinkel */
	r:PTR TO INT,		/* Radius */
	a:PTR TO INT,		/* Beschleunigung */
	v:PTR TO INT,		/* Geschwindigkeit */
	pxs:PTR TO INT,pys:PTR TO INT,	/* Punktkoordinaten */
	v0=1200					/* Anfangsgeschwindigkeit */


PROC main() HANDLE
	RAISE	E_WIN IF OpenW()=NIL

DEF	anzahl,drehung,i,
	msg:PTR TO intuimessage,class,code,
	maxx,maxy,rmax,xhalb,yhalb,diff


	IF (reqtoolsbase:=OpenLibrary('reqtools.library',0))=NIL THEN Raise(E_LIB)

	setup()

	anzahl:=30
	StringF(anzstring,'Sternanzahl   [\d]',anzahl)
	drehung:=0
	StringF(drehstring,'Drehgeschw.   [\d]',drehung)

	IF allocArrays(anzahl)=FALSE THEN Raise(E_NONE)

	menus:=[NIL,5,0,120,10,MENUENABLED,'Einstellungen',
			[[NIL,0,10,200,10,ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP,0,[2,1,0,0,1,NIL,drehstring,NIL]:intuitext,NIL,"D",NIL,NIL]:menuitem,
			0,0,200,10,ITEMTEXT OR COMMSEQ OR ITEMENABLED OR HIGHCOMP,0,[2,1,0,0,1,NIL,anzstring,NIL]:intuitext,NIL,"A",NIL,NIL]:menuitem,
			0,0,0,0]:menu
	

	wi:=OpenW(0,11,200,100,IDCMP_CLOSEWINDOW OR IDCMP_NEWSIZE OR IDCMP_MENUPICK,
		WFLG_GIMMEZEROZERO OR WFLG_ACTIVATE OR $F,'Sternenflug in "E"   ©1994 M. Bennicke',NIL,WBENCHSCREEN,NIL)

	SetRast(stdrast,BACKGROUND)
	SetMenuStrip(wi,menus)

	Rnd(Abs(RndQ(-1)))
	maxx:=wi.gzzwidth-1
	maxy:=wi.gzzheight-1
	xhalb:=maxx/2
	yhalb:=maxy/2
	rmax:=sqrt((xhalb*xhalb)+(yhalb*yhalb))

	werteSetzen(anzahl,xhalb,yhalb)

	SetAPen(stdrast,STARS)

	REPEAT
		SetRast(stdrast,BACKGROUND)

		FOR i:=0 TO anzahl-1
			diff:=Shr(v[i],10)
/*			WritePixel(stdrast,pxs[i],pys[i]) */
			RectFill(stdrast,pxs[i],pys[i],pxs[i]+diff,pys[i]+Shr(diff,1))
		ENDFOR

		FOR i:=0 TO anzahl-1
			pxs[i]:=xhalb+Shr(r[i]*sin[w[i]],10)
			pys[i]:=yhalb+Shr(r[i]*cos[w[i]],10)
	
			r[i]:=r[i]+Shr(v[i],10)
			v[i]:=Shr(Mul(v[i],a[i]),10)

			w[i]:=(w[i]+drehung) AND 511

			IF r[i]>rmax
				w[i]:=Rnd(512)
				r[i]:=Rnd(8)
				v[i]:=v0
				a[i]:=1060+Rnd(200)
			ENDIF
		ENDFOR

		msg:=GetMsg(wi.userport)
		IF msg<>NIL
			class:=msg.class
			code:=msg.code
			ReplyMsg(msg)

			SELECT class
				CASE IDCMP_CLOSEWINDOW; ende:=TRUE

				CASE IDCMP_NEWSIZE
					SetRast(stdrast,BACKGROUND)
					maxx:=wi.gzzwidth-1
					maxy:=wi.gzzheight-1
					xhalb:=maxx/2
					yhalb:=maxy/2
					rmax:=sqrt((xhalb*xhalb)+(yhalb*yhalb))

				CASE IDCMP_MENUPICK
					SELECT code
						CASE $F800
							neueAnzahl({anzahl},xhalb,yhalb)
							StringF(anzstring,'Sternanzahl   [\d]',anzahl)

						CASE $F820
							RtGetLongA({drehung},'Drehgeschwindigkeit',NIL,
								[RT_REQPOS,REQPOS_POINTER,
								RT_UNDERSCORE,"_",
								RT_LOCKWINDOW,TRUE,
								RTGL_MIN,-40,
								RTGL_MAX,40,
								RTGL_SHOWDEFAULT,TRUE,
								RTGL_GADFMT,'_Setzen|_Abbruch',
								RTGL_TEXTFMT,'Vollkreis = 512 Winkelschritte',
								TAG_DONE])
								StringF(drehstring,'Drehgeschw.   [\d]',drehung)
					ENDSELECT
			ENDSELECT
		ENDIF

	UNTIL ende
	
	closeall()
EXCEPT
	IF exception<>E_NONE THEN request(erlist[exception],'Abbruch',NIL)
	closeall()
ENDPROC


PROC neueAnzahl(an,xh,yh)
	DEF neuanz,ret

	neuanz:=^an

	ret:=RtGetLongA({neuanz},'Anzahl eingeben!',NIL,
		[RT_REQPOS,REQPOS_POINTER,
		RT_UNDERSCORE,"_",
		RT_LOCKWINDOW,TRUE,
		RTGL_MIN,5,
		RTGL_SHOWDEFAULT,TRUE,
		RTGL_GADFMT,'_Setzen|_Abbruch',
		TAG_DONE])

	IF ret<>0
		FreeRemember(arrays,TRUE)
		IF allocArrays(neuanz)
			werteSetzen(neuanz,xh,yh)
		ELSE
			ende:=TRUE
		ENDIF
		^an:=neuanz
	ENDIF
ENDPROC 


PROC werteSetzen(an,xh,yh)
	DEF i

	FOR i:=0 TO an-1
		w[i]:=Rnd(512)
		r[i]:=Rnd(8)
		v[i]:=v0
		a[i]:=1024+Rnd(150)
	ENDFOR

	FOR i:=0 TO an-1
		pxs[i]:=xh+Shr(r[i]*sin[w[i]],10)
		pys[i]:=yh+Shr(r[i]*cos[w[i]],10)
	ENDFOR
ENDPROC


PROC allocArrays(an) HANDLE
	RAISE	E_MEM IF AllocRemember()=NIL

	DEF s=TRUE

	arrays:=NIL
	w:=AllocRemember(arrays,an*2,MEMF_CLEAR)
	r:=AllocRemember(arrays,an*2,MEMF_CLEAR)
	a:=AllocRemember(arrays,an*2,MEMF_CLEAR)
	v:=AllocRemember(arrays,an*2,MEMF_CLEAR)
	pxs:=AllocRemember(arrays,an*2,MEMF_CLEAR)
	pys:=AllocRemember(arrays,an*2,MEMF_CLEAR)
EXCEPT
	IF arrays<>NIL
		FreeRemember(arrays,TRUE)
		arrays:=NIL
	ENDIF
	request(erlist[exception],'Abbruch',NIL)
	s:=FALSE
ENDPROC s


PROC request(body,gad,args) HANDLE
	RAISE E_NONE IF RtAllocRequestA()=NIL

	DEF ergebnis,ir:PTR TO rtreqinfo

	IF AvailMem(MEMF_CHIP)<50 THEN Raise(E_NONE)

	ir:=RtAllocRequestA(RT_REQINFO,NIL)

	ergebnis:=RtEZRequestA(body,gad,ir,args,
			[RT_UNDERSCORE,"_",
			RT_REQPOS,REQPOS_POINTER,
			RTEZ_FLAGS,EZREQF_CENTERTEXT,
			RTEZ_REQTITLE,'Information',
			TAG_DONE])

	RtFreeRequest(ir)
EXCEPT
	ergebnis:=0
ENDPROC ergebnis


PROC sqrt(rad)
	DEF erg

	MOVE.L	rad,D0

	/* bin wurzel2 aus Amiga-Magazin Sonderheft 2 */

	MOVE.L	#$40000000,D1
	MOVE.L	#$30000000,D7
start2:
	LSR.L	#1,D1
	EOR.L	D7,D1
	CMP.L	D1,D0
	BMI.S	loop2
	SUB.L	D1,D0
	OR.L	D7,D1
loop2:
	LSR.L	#2,D7
	BCC.S	start2
	LSR		#1,D1

	MOVE.L	D1,erg
ENDPROC erg


PROC closeall()
	IF arrays<>NIL THEN FreeRemember(arrays,TRUE)
	IF wi<>NIL
		ClearMenuStrip(wi)
		CloseW(wi)
	ENDIF
	IF reqtoolsbase<>NIL THEN CloseLibrary(reqtoolsbase)
ENDPROC


PROC setup()
	erlist:=['Alles OK',
			'Window konnte nicht geöffnet werden!',
			'Die reqtools.library konnte\nnicht geöffnet werden.',
			'Kein Speicher mehr vorhanden!']

	sin:=[$0006,$0013,$001F,$002C,$0039,$0045,$0052,$005E,$006B,$0077,
	$0084,$0090,$009C,$00A9,$00B5,$00C2,$00CE,$00DA,$00E6,$00F3,
	$00FF,$010B,$0117,$0123,$012F,$013B,$0147,$0153,$015F,$016B,
	$0176,$0182,$018E,$0199,$01A5,$01B0,$01BB,$01C7,$01D2,$01DD,
	$01E8,$01F3,$01FE,$0209,$0214,$021F,$0229,$0234,$023E,$0248,
	$0253,$025D,$0267,$0271,$027B,$0285,$028E,$0298,$02A2,$02AB,
	$02B4,$02BE,$02C7,$02D0,$02D9,$02E1,$02EA,$02F2,$02FB,$0303,
	$030B,$0314,$031C,$0323,$032B,$0333,$033A,$0342,$0349,$0350,
	$0357,$035E,$0364,$036B,$0372,$0378,$037E,$0384,$038A,$0390,
	$0395,$039B,$03A0,$03A6,$03AB,$03B0,$03B4,$03B9,$03BE,$03C2,
	$03C6,$03CA,$03CE,$03D2,$03D6,$03D9,$03DD,$03E0,$03E3,$03E6,
	$03E8,$03EB,$03EE,$03F0,$03F2,$03F4,$03F6,$03F8,$03F9,$03FA,
	$03FC,$03FD,$03FE,$03FE,$03FF,$0400,$0400,$0400,$0400,$0400,
	$0400,$03FF,$03FE,$03FE,$03FD,$03FC,$03FA,$03F9,$03F8,$03F6,
	$03F4,$03F2,$03F0,$03EE,$03EB,$03E8,$03E6,$03E3,$03E0,$03DD,
	$03D9,$03D6,$03D2,$03CE,$03CA,$03C6,$03C2,$03BE,$03B9,$03B4,
	$03B0,$03AB,$03A6,$03A0,$039B,$0395,$0390,$038A,$0384,$037E,
	$0378,$0372,$036B,$0364,$035E,$0357,$0350,$0349,$0342,$033A,
	$0333,$032B,$0323,$031C,$0314,$030B,$0303,$02FB,$02F2,$02EA,
	$02E1,$02D9,$02D0,$02C7,$02BE,$02B4,$02AB,$02A2,$0298,$028E,
	$0285,$027B,$0271,$0267,$025D,$0253,$0248,$023E,$0234,$0229,
	$021F,$0214,$0209,$01FE,$01F3,$01E8,$01DD,$01D2,$01C7,$01BB,
	$01B0,$01A5,$0199,$018E,$0182,$0176,$016B,$015F,$0153,$0147,
	$013B,$012F,$0123,$0117,$010B,$00FF,$00F3,$00E6,$00DA,$00CE,
	$00C2,$00B5,$00A9,$009C,$0090,$0084,$0077,$006B,$005E,$0052,
	$0045,$0039,$002C,$001F,$0013,$0006,$FFFA,$FFED,$FFE1,$FFD4,
	$FFC7,$FFBB,$FFAE,$FFA2,$FF95,$FF89,$FF7C,$FF70,$FF64,$FF57,
	$FF4B,$FF3E,$FF32,$FF26,$FF1A,$FF0D,$FF01,$FEF5,$FEE9,$FEDD,
	$FED1,$FEC5,$FEB9,$FEAD,$FEA1,$FE95,$FE8A,$FE7E,$FE72,$FE67,
	$FE5B,$FE50,$FE45,$FE39,$FE2E,$FE23,$FE18,$FE0D,$FE02,$FDF7,
	$FDEC,$FDE1,$FDD7,$FDCC,$FDC2,$FDB8,$FDAD,$FDA3,$FD99,$FD8F,
	$FD85,$FD7B,$FD72,$FD68,$FD5E,$FD55,$FD4C,$FD42,$FD39,$FD30,
	$FD27,$FD1F,$FD16,$FD0D,$FD05,$FCFD,$FCF5,$FCEC,$FCE4,$FCDD,
	$FCD5,$FCCD,$FCC6,$FCBE,$FCB7,$FCB0,$FCA9,$FCA2,$FC9C,$FC95,
	$FC8E,$FC88,$FC82,$FC7C,$FC76,$FC70,$FC6B,$FC65,$FC60,$FC5A,
	$FC55,$FC50,$FC4C,$FC47,$FC42,$FC3E,$FC3A,$FC36,$FC32,$FC2E,
	$FC2A,$FC27,$FC23,$FC20,$FC1D,$FC1A,$FC18,$FC15,$FC12,$FC10,
	$FC0E,$FC0C,$FC0A,$FC08,$FC07,$FC06,$FC04,$FC03,$FC02,$FC02,
	$FC01,$FC00,$FC00,$FC00,$FC00,$FC00,$FC00,$FC01,$FC02,$FC02,
	$FC03,$FC04,$FC06,$FC07,$FC08,$FC0A,$FC0C,$FC0E,$FC10,$FC12,
	$FC15,$FC18,$FC1A,$FC1D,$FC20,$FC23,$FC27,$FC2A,$FC2E,$FC32,
	$FC36,$FC3A,$FC3E,$FC42,$FC47,$FC4C,$FC50,$FC55,$FC5A,$FC60,
	$FC65,$FC6B,$FC70,$FC76,$FC7C,$FC82,$FC88,$FC8E,$FC95,$FC9C,
	$FCA2,$FCA9,$FCB0,$FCB7,$FCBE,$FCC6,$FCCD,$FCD5,$FCDD,$FCE4,
	$FCEC,$FCF5,$FCFD,$FD05,$FD0E,$FD16,$FD1F,$FD28,$FD30,$FD39,
	$FD42,$FD4C,$FD55,$FD5E,$FD68,$FD72,$FD7B,$FD85,$FD8F,$FD99,
	$FDA3,$FDAD,$FDB8,$FDC2,$FDCC,$FDD7,$FDE1,$FDEC,$FDF7,$FE02,
	$FE0D,$FE18,$FE23,$FE2E,$FE39,$FE45,$FE50,$FE5B,$FE67,$FE72,
	$FE7E,$FE8A,$FE95,$FEA1,$FEAD,$FEB9,$FEC5,$FED1,$FEDD,$FEE9,
	$FEF5,$FF01,$FF0D,$FF1A,$FF26,$FF32,$FF3E,$FF4B,$FF57,$FF64,
	$FF70,$FF7C,$FF89,$FF95,$FFA2,$FFAE,$FFBB,$FFC7,$FFD4,$FFE1,
	$FFED,$FFFA]:INT


	cos:=[$0400,$0400,$0400,$03FF,$03FE,$03FE,$03FD,$03FC,$03FA,$03F9,
	$03F8,$03F6,$03F4,$03F2,$03F0,$03EE,$03EB,$03E8,$03E6,$03E3,
	$03E0,$03DD,$03D9,$03D6,$03D2,$03CE,$03CA,$03C6,$03C2,$03BE,
	$03B9,$03B4,$03B0,$03AB,$03A6,$03A0,$039B,$0395,$0390,$038A,
	$0384,$037E,$0378,$0372,$036B,$0364,$035E,$0357,$0350,$0349,
	$0342,$033A,$0333,$032B,$0323,$031C,$0314,$030B,$0303,$02FB,
	$02F2,$02EA,$02E1,$02D9,$02D0,$02C7,$02BE,$02B4,$02AB,$02A2,
	$0298,$028E,$0285,$027B,$0271,$0267,$025D,$0253,$0248,$023E,
	$0234,$0229,$021F,$0214,$0209,$01FE,$01F3,$01E8,$01DD,$01D2,
	$01C7,$01BB,$01B0,$01A5,$0199,$018E,$0182,$0176,$016B,$015F,
	$0153,$0147,$013B,$012F,$0123,$0117,$010B,$00FF,$00F3,$00E6,
	$00DA,$00CE,$00C2,$00B5,$00A9,$009C,$0090,$0084,$0077,$006B,
	$005E,$0052,$0045,$0039,$002C,$001F,$0013,$0006,$FFFA,$FFED,
	$FFE1,$FFD4,$FFC7,$FFBB,$FFAE,$FFA2,$FF95,$FF89,$FF7C,$FF70,
	$FF64,$FF57,$FF4B,$FF3E,$FF32,$FF26,$FF1A,$FF0D,$FF01,$FEF5,
	$FEE9,$FEDD,$FED1,$FEC5,$FEB9,$FEAD,$FEA1,$FE95,$FE8A,$FE7E,
	$FE72,$FE67,$FE5B,$FE50,$FE45,$FE39,$FE2E,$FE23,$FE18,$FE0D,
	$FE02,$FDF7,$FDEC,$FDE1,$FDD7,$FDCC,$FDC2,$FDB8,$FDAD,$FDA3,
	$FD99,$FD8F,$FD85,$FD7B,$FD72,$FD68,$FD5E,$FD55,$FD4C,$FD42,
	$FD39,$FD30,$FD27,$FD1F,$FD16,$FD0D,$FD05,$FCFD,$FCF5,$FCEC,
	$FCE4,$FCDD,$FCD5,$FCCD,$FCC6,$FCBE,$FCB7,$FCB0,$FCA9,$FCA2,
	$FC9C,$FC95,$FC8E,$FC88,$FC82,$FC7C,$FC76,$FC70,$FC6B,$FC65,
	$FC60,$FC5A,$FC55,$FC50,$FC4C,$FC47,$FC42,$FC3E,$FC3A,$FC36,
	$FC32,$FC2E,$FC2A,$FC27,$FC23,$FC20,$FC1D,$FC1A,$FC18,$FC15,
	$FC12,$FC10,$FC0E,$FC0C,$FC0A,$FC08,$FC07,$FC06,$FC04,$FC03,
	$FC02,$FC02,$FC01,$FC00,$FC00,$FC00,$FC00,$FC00,$FC00,$FC01,
	$FC02,$FC02,$FC03,$FC04,$FC06,$FC07,$FC08,$FC0A,$FC0C,$FC0E,
	$FC10,$FC12,$FC15,$FC18,$FC1A,$FC1D,$FC20,$FC23,$FC27,$FC2A,
	$FC2E,$FC32,$FC36,$FC3A,$FC3E,$FC42,$FC47,$FC4C,$FC50,$FC55,
	$FC5A,$FC60,$FC65,$FC6B,$FC70,$FC76,$FC7C,$FC82,$FC88,$FC8E,
	$FC95,$FC9C,$FCA2,$FCA9,$FCB0,$FCB7,$FCBE,$FCC6,$FCCD,$FCD5,
	$FCDD,$FCE4,$FCEC,$FCF5,$FCFD,$FD05,$FD0E,$FD16,$FD1F,$FD28,
	$FD30,$FD39,$FD42,$FD4C,$FD55,$FD5E,$FD68,$FD72,$FD7B,$FD85,
	$FD8F,$FD99,$FDA3,$FDAD,$FDB8,$FDC2,$FDCC,$FDD7,$FDE1,$FDEC,
	$FDF7,$FE02,$FE0D,$FE18,$FE23,$FE2E,$FE39,$FE45,$FE50,$FE5B,
	$FE67,$FE72,$FE7E,$FE8A,$FE95,$FEA1,$FEAD,$FEB9,$FEC5,$FED1,
	$FEDD,$FEE9,$FEF5,$FF01,$FF0D,$FF1A,$FF26,$FF32,$FF3E,$FF4B,
	$FF57,$FF64,$FF70,$FF7C,$FF89,$FF95,$FFA2,$FFAE,$FFBB,$FFC7,
	$FFD4,$FFE1,$FFED,$FFFA,$0006,$0013,$001F,$002C,$0039,$0045,
	$0052,$005E,$006B,$0077,$0084,$0090,$009C,$00A9,$00B5,$00C2,
	$00CE,$00DA,$00E6,$00F3,$00FF,$010B,$0117,$0123,$012F,$013B,
	$0147,$0153,$015F,$016B,$0176,$0182,$018E,$0199,$01A5,$01B0,
	$01BC,$01C7,$01D2,$01DD,$01E8,$01F3,$01FE,$0209,$0214,$021F,
	$0229,$0234,$023E,$0248,$0253,$025D,$0267,$0271,$027B,$0285,
	$028E,$0298,$02A2,$02AB,$02B4,$02BE,$02C7,$02D0,$02D9,$02E1,
	$02EA,$02F3,$02FB,$0303,$030B,$0314,$031C,$0323,$032B,$0333,
	$033A,$0342,$0349,$0350,$0357,$035E,$0364,$036B,$0372,$0378,
	$037E,$0384,$038A,$0390,$0395,$039B,$03A0,$03A6,$03AB,$03B0,
	$03B4,$03B9,$03BE,$03C2,$03C6,$03CA,$03CE,$03D2,$03D6,$03D9,
	$03DD,$03E0,$03E3,$03E6,$03E8,$03EB,$03EE,$03F0,$03F2,$03F4,
	$03F6,$03F8,$03F9,$03FA,$03FC,$03FD,$03FE,$03FE,$03FF,$0400,
	$0400,$0400]:INT

ENDPROC
