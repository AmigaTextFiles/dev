/* A test of pAmigaGraphics
*/
MODULE 'exec', '*pAmigaDos', '*pAmigaGraphics', '*pAmigaIntuition'
MODULE 'wb'

PROC new()
	workbenchbase := OpenLibrary('workbench.library', 39)
	IF workbenchbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(workbenchbase)
ENDPROC

/*****************************/

PROC main()
	DEF title:ARRAY OF CHAR, message:ARRAY OF CHAR
	DEF lines:OWNS STRING
	DEF scr:PTR TO screen, width, height, font:PTR TO textfont, border
	DEF win:PTR TO window, originX, originY, wasNotOnFrontScreen:BOOL
	
	DEF winMsg:PTR TO intuimessage, winSignal, quit:BOOL
	DEF appPort:PTR TO mp, appSignal, appWin:PTR TO appwindow, appMsg:PTR TO appmessage, i, wbargPath:OWNS STRING
	DEF signal, class, code
	
	appPort := NIL
	appWin := NIL
	
	border := 5
	title := 'title bar'
	message := 'This is a message\nLine two\nLine three'
	
	->split message into lines
	lines := formatLinesOfText(message)
	
	->open suitably sized window
	scr := LockPubScreen(NILA)
	font := scr.rastport.font
	
	width, height := sizeOfText(lines, font)
	width  := width  + (2 * border)
	height := height + (2 * border)
	
	win, originX, originY, wasNotOnFrontScreen := openWindow(width, height, title, scr, IDCMP_CLOSEWINDOW, WFLG_CLOSEGADGET)
	IF win
		winSignal := 1 SHL win.userport.sigbit
		SetFont(win.rport, font)
		
		appPort := CreateMsgPort()
		appSignal := 1 SHL appPort.sigbit
		appWin := AddAppWindowA(1 /*id*/, 0 /*userdata*/, win, appPort, NILA)
	ENDIF
	
	UnlockPubScreen(NILA, scr) ; scr := NIL
	
	->render lines into window
	IF win
		SetAPen(win.rport, 1)
		SetBPen(win.rport, 0)
		drawText(lines, win.rport, originX + border, originY + border)
		
		quit := FALSE
		REPEAT
			->WaitPort(win.userport)
			signal := Wait(winSignal OR appSignal)
			
			IF signal AND winSignal
				WHILE winMsg := GetMsg(win.userport) !!PTR
					class := winMsg.class
					code  := winMsg.code
					ReplyMsg(winMsg.execmessage) ; winMsg := NIL
					
					IF class = IDCMP_CLOSEWINDOW THEN quit := TRUE
				ENDWHILE
			ENDIF
			
			IF signal AND appSignal
				WHILE appMsg := GetMsg(appPort) !!PTR
					IF appMsg.type = AMTYPE_APPWINDOW
						FOR i := 0 TO appMsg.numargs - 1
							wbargPath := pathOfWbArg(appMsg.arglist[i])
							Print('appwin file \d is "\s"\n', i, wbargPath)
							END wbargPath
						ENDFOR
					ENDIF
					
					ReplyMsg(appMsg.message)
				ENDWHILE
			ENDIF
		UNTIL quit
	ENDIF
FINALLY
	IF exception THEN Print('Exception!\n')
	
	IF appWin THEN RemoveAppWindow(appWin)
	IF win THEN win := closeWindow(win, wasNotOnFrontScreen)
	IF appPort
		WHILE appMsg := GetMsg(appPort) !!PTR DO IF appMsg.message.ln.type = NT_MESSAGE THEN ReplyMsg(appMsg.message)
		DeleteMsgPort(appPort)
	ENDIF
	END lines
	END wbargPath
ENDPROC
