OPT PREPROCESS

MODULE  'commodities', 'libraries/commodities', 'exec/ports', 'icon', 'amigalib/argarray', 'dos/dos',
'intuition/intuition', 'intuition/intuitionbase', 'intuition/screens', 'graphics/text'

ENUM TILE=0, HORTILE, VERTILE, CASCADE, CLOSE, MINIMIZE, MAXIMIZE, MOVEDOWN, MOVEUP, MOVELEFT,MOVERIGHT, RCASCADE

DEF pat[100]:STRING
DEF winwidth=NIL, winheight=NIL

PROC main()
	DEF filter[20]:ARRAY OF LONG, sender[20]:ARRAY OF LONG, translate[20]:ARRAY OF LONG
	DEF msg, msgid, msgtype, sig
	DEF end=FALSE, ttypes, i, error=FALSE
	DEF broker, port:PTR TO mp
	IF (iconbase:=OpenLibrary('icon.library', 36))
		IF (cxbase:=OpenLibrary('commodities.library', 37))
			IF (ttypes:=argArrayInit())
				winwidth:=argInt(ttypes,'WINWIDTH',160)
				winheight:=argInt(ttypes,'WINHEIGHT',80)
				IF (port:=CreateMsgPort())
					IF (broker:=CxBroker([NB_VERSION,0,
						'WinMan','Window Manager','makes managing windows a little bit easier',
						NBU_NOTIFY OR NBU_UNIQUE,
						0,argInt(ttypes,'CX_PRIORITY',0),0,port,0]:newbroker,NIL))
						-> setup amigados wildcard matching
						ParsePattern(argString(ttypes,'PATTERN','~(Workbench)'),pat,100)
						/* set up filters */
						filter[0]:=CxFilter(argString(ttypes,'TILE','RAWKEY CONTROL SHIFT T'))
						filter[1]:=CxFilter(argString(ttypes,'HORTILE','RAWKEY CONTROL SHIFT H'))
						filter[2]:=CxFilter(argString(ttypes,'VERTILE','RAWKEY CONTROL SHIFT V'))
						filter[3]:=CxFilter(argString(ttypes,'CASCADE','RAWKEY CONTROL SHIFT C'))
						filter[4]:=CxFilter(argString(ttypes,'CLOSE','RAWKEY CONTROL SHIFT K'))
						filter[5]:=CxFilter(argString(ttypes,'MINIMIZE','RAWKEY CONTROL SHIFT M'))
						filter[6]:=CxFilter(argString(ttypes,'MAXIMIZE','RAWKEY CONTROL SHIFT N'))
						filter[7]:=CxFilter(argString(ttypes,'MOVEDOWN','RAWKEY CONTROL SHIFT DOWN'))
						filter[8]:=CxFilter(argString(ttypes,'MOVEUP','RAWKEY CONTROL SHIFT UP'))
						filter[9]:=CxFilter(argString(ttypes,'MOVELEFT','RAWKEY CONTROL SHIFT LEFT'))
						filter[10]:=CxFilter(argString(ttypes,'MOVERIGHT','RAWKEY CONTROL SHIFT RIGHT'))
						filter[11]:=CxFilter(argString(ttypes,'RCASCADE','RAWKEY CONTROL SHIFT R'))
						/* attach filters to broker */
						FOR i:=0 TO 11 DO AttachCxObj(broker,filter[i])
						/* make a sender for all of the filters */
						FOR i:=0 TO 11
							sender[i]:=CxSender(port,i)
							AttachCxObj(filter[i],sender[i])
							translate[i]:=CxTranslate(NIL)
							AttachCxObj(filter[i],translate[i])
							IF CxObjError(filter[i])<>FALSE THEN error:=TRUE
						ENDFOR
						IF error=FALSE
							ActivateCxObj(broker,TRUE)
							WHILE end=FALSE
								sig:=Wait(SIGBREAKF_CTRL_C OR Shl(1,port.sigbit))
								IF sig AND SIGBREAKF_CTRL_C
									end:=TRUE
								ELSE
									WHILE (msg:=GetMsg(port))
										msgid:=CxMsgID(msg)
										msgtype:=CxMsgType(msg)
										ReplyMsg(msg)
										SELECT msgtype
										CASE CXM_COMMAND
											SELECT msgid
											CASE CXCMD_DISABLE
												ActivateCxObj(broker,FALSE)
											CASE CXCMD_ENABLE
												ActivateCxObj(broker,TRUE)
											CASE CXCMD_KILL
												end:=TRUE
											ENDSELECT
										CASE CXM_IEVENT
											SELECT msgid
											CASE TILE
												tile()
											CASE HORTILE
												tile(1)
											CASE VERTILE
												tile(2)
											CASE CASCADE
												cascade()
											CASE CLOSE
												close()
											CASE MINIMIZE
												size(0)
											CASE MAXIMIZE
												size(1)
											CASE MOVEDOWN
												move(1)
											CASE MOVEUP
												move(0)
											CASE MOVELEFT
												move(2)
											CASE MOVERIGHT
												move(3)
											CASE RCASCADE
												cascade(1)
											ENDSELECT
										ENDSELECT
									ENDWHILE
								ENDIF
							ENDWHILE
							DeleteCxObjAll(broker)
						ENDIF
					ENDIF
					DeleteMsgPort(port)
				ENDIF
				argArrayDone()
			ENDIF
			CloseLibrary(cxbase)
		ENDIF
		CloseLibrary(iconbase)
	ENDIF
ENDPROC

PROC tile(tiletype=NIL)
	DEF wn:PTR TO window, sn:PTR TO screen, ib:PTR TO intuitionbase, nw:PTR TO window
	DEF i=1, wnno=NIL, end=FALSE
	DEF x=NIL, y=NIL
	DEF xx=NIL, yy=NIL
	DEF xa, yu
	Forbid()
	ib:=intuitionbase
	sn:=ib.activescreen
	wn:=sn.firstwindow
	WHILE wn
		IF (wn.flags AND WFLG_BACKDROP) OR (MatchPattern(pat,wn.title)=0) THEN wnno--
		wnno++
		wn:=wn.nextwindow
	ENDWHILE
	WHILE end=FALSE
		IF (i*i>wnno) OR (i*i=wnno)
			end:=TRUE
			x:=i
			y:=i
		ELSEIF ((i+1)*i>wnno) OR ((i+1)*i=wnno)
			end:=TRUE
			x:=i+1
			y:=i
		ELSE
			end:=FALSE
			i++
		ENDIF
	ENDWHILE
	IF tiletype=1
		x:=1
		y:=wnno
	ELSEIF tiletype=2
		x:=wnno
		y:=1
	ENDIF
	ib:=intuitionbase
	sn:=ib.activescreen
	wn:=sn.firstwindow
	end:=FALSE
	xa:=sn.width/x
	yu:=(sn.height-sn.barvborder-sn.barheight)/y
	WHILE end=FALSE
		IF wn.parent THEN wn:=wn.parent ELSE end:=TRUE
	ENDWHILE
	Permit()
	WHILE wn
		nw:=wn.descendant
		IF (wn.flags AND WFLG_BACKDROP) OR (MatchPattern(pat,wn.title)=0)
			-> xx--
			IF tiletype=1
				yy--
			ELSEIF tiletype=2
				xx--
			ELSEIF tiletype=0
				xx--
			ENDIF
		ELSE
			MoveWindow(wn,-wn.leftedge,-wn.topedge)
			SizeWindow(wn,-wn.width+xa,-wn.height+yu)
			MoveWindow(wn,xx*xa,yy*yu+sn.barheight+sn.barvborder)
			IF tiletype=2 THEN WindowToBack(wn) ELSE WindowToFront(wn)
		ENDIF
		wn:=nw
		IF tiletype=0
			xx++
			IF xx=x
				xx:=0
				yy++
			ENDIF
		ELSEIF tiletype=1
			yy++
		ELSEIF tiletype=2
			xx++
		ENDIF
	ENDWHILE
	-> Permit()
ENDPROC

PROC cascade(cascadetype=0)
	DEF ib:PTR TO intuitionbase, sn:PTR TO screen, wn:PTR TO window, nw:PTR TO window
	DEF x, y
	Forbid()
	ib:=intuitionbase
	sn:=ib.activescreen
	wn:=ib.activewindow
	nw:=wn
	x:=(IF cascadetype=0 THEN 0 ELSE 640)
	y:=sn.barheight+sn.barvborder
	Permit()
	Forbid()
	ib:=intuitionbase
	wn:=ib.activewindow
	nw:=wn
	Permit()
	WHILE nw
		IF wn.parent THEN wn:=wn.parent
		nw:=wn.parent
	ENDWHILE
	WHILE wn
		IF (wn.flags AND WFLG_BACKDROP) OR (MatchPattern(pat,wn.title)=0)
			wn:=wn.descendant
		ELSE
			nw:=wn.descendant
			MoveWindow(wn,-wn.leftedge,-wn.topedge)
			SizeWindow(wn,-wn.width+winwidth,-wn.height+winheight)
			MoveWindow(wn,(IF cascadetype=0 THEN x ELSE x-winwidth),y)
			WindowToFront(wn)
			x:=(IF cascadetype=0 THEN x+wn.borderleft ELSE x-wn.borderright)
			y:=y+wn.bordertop
			wn:=nw
		ENDIF
	ENDWHILE
ENDPROC

PROC close()
	DEF ib:PTR TO intuitionbase, sn:PTR TO screen, wn:PTR TO window, nw:PTR TO window
	DEF port:PTR TO mp, msg:PTR TO intuimessage
	Forbid()
	ib:=intuitionbase
	sn:=ib.activescreen
	wn:=ib.activewindow
	nw:=wn
	WHILE nw
		IF wn.parent THEN wn:=wn.parent
		nw:=nw.parent
	ENDWHILE
	IF (port:=CreateMsgPort())
		IF (msg:=New(SIZEOF intuimessage))
			WHILE wn
				msg.class:=$200
				msg.code:=0
				msg.qualifier:=$FFFF
				msg.iaddress:=$1
				msg.execmessage.length:=$20
				msg.execmessage.replyport:=port
				msg.idcmpwindow:=wn
				nw:=wn.descendant
				IF (wn.flags AND WFLG_BACKDROP) OR (MatchPattern(pat,wn.title)=0)
					wn:=nw
				ELSE
					PutMsg(wn.userport,msg)
					Wait(Shl(1,port.sigbit))
					GetMsg(port)
					wn:=nw
				ENDIF
			ENDWHILE
		ENDIF
		Permit()
		DeleteMsgPort(port)
	ENDIF
ENDPROC

PROC size(type)
	DEF ib:PTR TO intuitionbase, sn:PTR TO screen, wn:PTR TO window, nw:PTR TO window
	Forbid()
	ib:=intuitionbase
	wn:=ib.activewindow
	nw:=wn
	sn:=ib.activescreen
	WHILE nw
		nw:=nw.parent
		IF wn.parent THEN wn:=wn.parent
	ENDWHILE
	Permit()
	WHILE wn
		nw:=wn.descendant
		IF (wn.flags AND WFLG_BACKDROP) OR (MatchPattern(pat,wn.title)=0)
			wn:=nw
		ELSE
			IF type=0
				SizeWindow(wn,-wn.width,-wn.height)
			ELSEIF type=1
				MoveWindow(wn,-wn.leftedge,-wn.topedge)
				SizeWindow(wn,sn.width-wn.width,sn.height-wn.height)
			ENDIF
			wn:=nw
		ENDIF
	ENDWHILE
ENDPROC

PROC move(type=0)
	DEF ib:PTR TO intuitionbase, sn:PTR TO screen, wn:PTR TO window, nw:PTR TO window
	DEF xa=0, yu=0, xw=0, yh=0, wnno=0
	Forbid()
	ib:=intuitionbase
	sn:=ib.activescreen
	wn:=ib.activewindow
	nw:=wn
	wn:=sn.firstwindow
	WHILE wn
		wnno++
		IF (wn.flags AND WFLG_BACKDROP) OR (MatchPattern(pat,wn.title)=0) THEN wnno--
		wn:=wn.nextwindow
	ENDWHILE
	wn:=nw
	WHILE nw
		IF wn.parent THEN wn:=wn.parent
		nw:=nw.parent
	ENDWHILE
	IF type=1
		xw:=sn.width/wnno
		yh:=50
		yu:=sn.height-yh
		xa:=0
	ELSEIF type=0
		xw:=sn.width/wnno
		yh:=50
		yu:=sn.barheight+sn.barvborder
		xa:=0
	ELSEIF type=2
		xw:=100
		xa:=0
		yh:=(sn.height-sn.barheight-sn.barvborder)/wnno
		yu:=sn.barheight+sn.barvborder
	ELSEIF type=3
		xw:=100
		xa:=sn.width-xw
		yh:=(sn.height-sn.barheight-sn.barvborder)/wnno
		yu:=sn.barheight+sn.barvborder
	ENDIF
	Permit()
	WHILE wn
		nw:=wn.descendant
		IF (wn.flags AND WFLG_BACKDROP) OR (MatchPattern(pat,wn.title)=0)
			wn:=nw
		ELSE
			MoveWindow(wn,-wn.leftedge,-wn.topedge)
			SizeWindow(wn,-wn.width+xw,-wn.height+yh)
			MoveWindow(wn,xa,yu)
			WindowToFront(wn)
			IF type=1
				xa:=xa+xw
			ELSEIF type=0
				xa:=xa+xw
			ELSEIF type=2
				yu:=yu+yh
			ELSEIF type=3
				yu:=yu+yh
			ENDIF
			wn:=nw
		ENDIF
	ENDWHILE
ENDPROC
