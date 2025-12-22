MODULE	'intuition/intuition','utility/tagitem','graphics/text'

ENUM	NO,UP,DO,LE,RI,UL,UR,DL,DR,LU,LD

PROC DrawMap(w:PTR TO Window,map:PTR TO CHAR,wi,he,le)
	DEF	x,y,c,s:PTR TO CHAR
	map:=map+le*wi*he
	s:=' '
	FOR y:=0 TO he-1
		FOR x:=0 TO wi-1
			s[0]:=map[y*wi+x]

			SELECT s[0]
			CASE "#"
				c:=2
			CASE ".","&","<",">"
				c:=4
			CASE "+","/",34,"*"
				c:=5
			CASE "~"
				c:=3
			DEFAULT
				c:=6
			ENDSELECT

			PrintIText(w.RPort,[c,1,1,0,0,['topaz.font',8,FS_NORMAL,FPF_ROMFONT]:TextAttr,s,NIL]:IntuiText,x*8+16,y*8+16)

		ENDFOR
	ENDFOR
ENDPROC

PROC Game(w:PTR TO Window,map:PTR TO CHAR,wi,he,le)
	DEF	x=0,y=0,msg:PTR TO IntuiMessage,run=TRUE,tmp="@":UBYTE,go,nx=0,ny=0,
			str:PTR TO CHAR
	tmp:=:map[le*wi*he+y*wi+x]			// put man
	DrawMap(w,map,wi,he,le)
	WHILE run
		WaitPort(w.UserPort)
		IF msg:=GetMsg(w.UserPort)
			SELECT msg.Class
			CASE IDCMP_VANILLAKEY
				go:=NO
				SELECT msg.Code
				CASE "8";	go:=UP
				CASE "4";	go:=LE
				CASE "6";	go:=RI
				CASE "2";	go:=DO
				CASE "7";	go:=UL
				CASE "9";	go:=UR
				CASE "1";	go:=DL
				CASE "3";	go:=DR
				CASE "<";	go:=LU
				CASE ">";	go:=LD
				CASE "o";	OpenDoor(map,x,y,wi,he,le)
				CASE "c";	CloseDoor(map,x,y,wi,he,le)
				ENDSELECT
				IF go
					tmp:=:map[le*wi*he+y*wi+x]		// get man
					SELECT go
					CASE UP;	ny:=y-1
					CASE DO;	ny:=y+1
					CASE LE;	nx:=x-1
					CASE RI;	nx:=x+1
					CASE UL;	ny:=y-1;	nx:=x-1
					CASE UR;	ny:=y-1;	nx:=x+1
					CASE DL;	ny:=y+1;	nx:=x-1
					CASE DR;	ny:=y+1;	nx:=x+1
					CASE LU;	IF map[le*wi*he+y*wi+x]="<" THEN le--
					CASE LD;	IF map[le*wi*he+y*wi+x]=">" THEN le++
					ENDSELECT
					IF nx<0  THEN nx:=0				// bounds
					IF ny<0  THEN ny:=0
					IF nx>15 THEN nx:=15
					IF ny>15 THEN ny:=15
					SELECT map[le*wi*he+ny*wi+nx]
					CASE "#","+";	nx:=x;	ny:=y
					CASE "~";		str:='HEEELP!   '
					CASE "&";		str:='STATUE    '
					CASE 34;			str:='BOOK      '
					CASE "/";		str:='DOOR      '
					CASE "*";		str:='STONE     '
					CASE "<";		str:='UPSTAIRS  '
					CASE ">";		str:='DOWNSTAIRS'
					DEFAULT;			str:='          '
					ENDSELECT
					x:=nx
					y:=ny
					tmp:=:map[le*wi*he+y*wi+x]		// put man
				ENDIF
				DrawMap(w,map,wi,he,le)
				PrintIText(w.RPort,[2,0,1,0,0,NIL,str,NIL]:IntuiText,0,0)
			CASE IDCMP_CLOSEWINDOW
				run:=FALSE
			ENDSELECT
			ReplyMsg(msg)
		ENDIF
	ENDWHILE
ENDPROC

PROC OpenDoor(map:PTR TO CHAR,x,y,wi,he,le)
	DEF	door=0,dx,dy,i,j
	map:=map+le*wi*he
	FOR j:=-1 TO 1
		FOR i:=-1 TO 1
			IF map[(y+j)*wi+x+i]="+"
				door++
				dx:=x+i
				dy:=y+j
			ENDIF
		ENDFOR
	ENDFOR
	IF door=1
		map[dy*wi+dx]:="/"
	ENDIF
ENDPROC

PROC CloseDoor(map:PTR TO CHAR,x,y,wi,he,le)
	DEF	door=0,dx,dy,i,j
	map:=map+le*wi*he
	FOR j:=-1 TO 1
		FOR i:=-1 TO 1
			IF map[(y+j)*wi+x+i]="/"
				door++
				dx:=x+i
				dy:=y+j
			ENDIF
		ENDFOR
	ENDFOR
	IF door=1
		map[dy*wi+dx]:="+"
	ENDIF
ENDPROC

PROC main()
	DEF	map:PTR TO CHAR,w:PTR TO Window
	map:=
		'................'+
		'.........######.'+
		'..#####..#>...#.'+
		'..#...#..#....#.'+
		'..#...#..##/###.'+
		'..###.#.........'+
		'....#.+.........'+
		'....###.........'+
		'................'+
		'................'+
		'................'+
		'..".....~~......'+
		'..#+#..~&~~.....'+
		'..#>#..~~~~.....'+
		'..###.~~~~~.....'+
		'.......~~~~.....'+

		'################'+
		'################'+
		'#####....+<...##'+
		'#.#...####....##'+
		'#.#...#####/####'+
		'#+###.###......#'+
		'#..##.#........#'+
		'#.#####........#'+
		'#.+............#'+
		'####...........#'+
		'#..+...........#'+
		'#.###...****...#'+
		'#.#.#.*****....#'+
		'#.#<#..*****...#'+
		'#.+.#.******...#'+
		'################'

	IF w:=OpenWindowTags(NIL,
			WA_InnerWidth,20*8,
			WA_InnerHeight,20*8,
			WA_Title,'Dungeon by MarK',
			WA_Flags,WFLG_ACTIVATE|WFLG_RMBTRAP|WFLG_GIMMEZEROZERO|WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET,
			WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_VANILLAKEY,
			TAG_END)
		EasyRequestArgs(w,[SIZEOF_EasyStruct,0,'ADOM request',
			'This is only small example in PowerD v0.12\n'+
			'based on Great free game A.D.O.M. (see AmiNet)\n\n'+
			'Control:\n'+
			'use numeric keyboard for moving\n'+
			'"<" go up, only possible on "<" char on the map\n'+
			'">" go down, only possible on ">" char on the map\n'+
			'"o" and "c" to open/close near door\n\n'+
			'       Bye, MarK',
			'OK']:EasyStruct,0,NIL)
		Game(w,map,16,16,0)
		CloseWindow(w)
	ENDIF
ENDPROC
