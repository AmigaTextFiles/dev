/* TicTacToe for AmiSlate v1.0! */

/* Constants for use with AmiSlate's ARexx interface */
AMode.DOT      =  0 
AMode.PEN      =  1 
AMode.LINE     =  2 
AMode.CIRCLE   =  3 
AMode.SQUARE   =  4 
AMode.POLY     =  5 
AMode.FLOOD    =  6 
AMode.CLEAR    =  7 

AMessage.TIMEOUT     = 1	/* No events occurred in specified time period */
AMessage.MESSAGE     = 2	/* Message recieved from remote Amiga */
AMessage.MOUSEDOWN   = 4	/* Left mouse button press in drawing area */
AMessage.MOUSEUP     = 8	/* Left mouse button release in drawing area */
AMessage.RESIZE      = 16	/* Window was resized--time to redraw screen? */ 
AMessage.QUIT        = 32	/* AmiSlate is shutting down */
AMessage.CONNECT     = 64	/* Connection established */
AMessage.DISCONNECT  = 128	/* Connection broken */
AMessage.TOOLSELECT  = 256	/* Tool Selected */
AMessage.COLORSELECT = 512	/* Palette Color selected */
AMessage.KEYPRESS    = 1024	/* Key pressed */
AMessage.MOUSEMOVE   = 2048     /* Mouse was moved */

/* Get our host's name--always given as first argument when run from Amislate */
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx tictactoe.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end

/* Send all commands to this host */
address (CommandPort) 


options results

/* Reserves pixels for a future toolbar -- currently, none */
ToolBarHeight = 0

/* Check to see which tool is selected, whether we are connected */
BFlood = 0

/* Parse command line argument to see if we've been activated by 
   a remote request or a local user */
check = upper(left(ActiveString,3))
if (upper(left(ActiveString,3)) ~= 'RE') then 
	do
		BActive = 1
	end
	else
	do	
		BActive = 2
	end

/* See if we're connected */
GetRemoteStateAttrs stem rstateattrs.

if (rstateattrs.mode > -1) then 
	do
		BConnectMode = 1
	end
	else
	do
		BConnectMode = 0
	end
	
/* Disable drawing */
lock on

/* Initialize TicTacToe board */
success = InitTTTArray()

/* Initiator (X) goes first */
turn = 1
moves = 0

/* Handshaking for two-computer game */
if (BConnectMode = 1) then 
do
    if (BActive == 1) then 
    do

    	SetWindowTitle '"'||"Requesting game from remote user"||'"' 
	RemoteRexxCommand '"'||"Would you like to play TicTacToe?"||'"' "slaterexx:TicTacToe.rexx"
	
        waitevent stem handshake. MESSAGE
        if (handshake.message == 0) then 
        do
            SetWindowTitle '"'||"TicTacToe Game Refused"||'"'
            exit
        end
	success = DrawTTTBoard()
    end
    else
    do
    	/* Examine window to get dimensions */
	GetWindowAttrs stem winattrs.
   	BoardWidth = winattrs.width  - 58
   	BoardHeight= winattrs.height - 53 - ToolBarHeight
    end
end
else 
do
    success = DrawTTTBoard()
end        

success = UpdateStatus()
do while(1)	
    waitevent stem event. RESIZE MOUSEUP MESSAGE TOOLSELECT DISCONNECT QUIT
	if ((event.type == AMessage.TOOLSELECT)&(event.code1 = AMode.CLEAR)) then do
		SetWindowTitle '"'||"Starting New Game"||'"'
		success = InitTTTArray()
		success = DrawTTTBoard()
		
		/* Tell partner that the board has been cleared */
		if (BConnectMode == 1) then SendMessage 99
		end
		
	if (event.type == AMessage.DISCONNECT) then BConnectMode = 0
	if (event.type == AMessage.QUIT) then exit
	if (event.type == AMessage.RESIZE) then do
		if ((BActive == 1)|(BConnectMode == 0)) then do
		   success = DrawTTTBoard()
		end
		else do
		   /* Just examine window to get new dimensions */
		   GetWindowAttrs stem winattrs.
		   BoardWidth = winattrs.width  - 58
		   BoardHeight= winattrs.height - 53 - ToolBarHeight
		end
 	        success = UpdateStatus()
	end
		
	if (event.type == AMessage.MESSAGE) then do
		if (event.message == 99) then do
				success = InitTTTArray()
				success = UpdateStatus()
			end
			else do
				if (turn ~= BActive) then success = ParseMove(event.message)
			end
        	end
        	
	if ((moves < 9)&((event.type == AMessage.MOUSEUP)&((turn == BActive)|(BConnectMode == 0)))) then 
	do
		xx = 3 	/* default */
		if (event.x < (2*(BoardWidth / 3))) then xx = 2
		if (event.x < (BoardWidth / 3)) then xx = 1
		
		yy = 3 	/* default */
		if (event.y < (2*(BoardHeight / 3))) then yy = 2
		if (event.y < (BoardHeight / 3)) then yy = 1
		
		if (TTTBoard.xx.yy > 0) then do
			SetWindowTitle '"'||"You can't move there!"||'"'
			end
		else do
			success = DoMove(xx,yy)
			end
	end
end

exit

/* --------------------------------------------------------------- */
/* procedure DoMove						   */
/* --------------------------------------------------------------- */
DoMove: procedure expose TTTBoard. turn moves BConnectMode BActive BoardWidth BoardHeight ToolBarHeight
	parse arg xx,yy 
	
	TTTBoard.xx.yy = turn 

	if ((BConnectMode == 0)|(turn == BActive)) then success = DrawMove(xx,yy)
	if ((BConnectMode == 1)&(turn == BActive)) then do
		message = xx||yy
		SendMessage message
		end	
				
	if (turn == 1) then do
		turn = 2
		end
		else do
		turn = 1
		end
	moves=moves+1
	success = CheckForWins()
	if ((success > 0)|(moves>=9)) then do
		moves = 9 /* disallow more movement */
		if (success == 1) then SetWindowTitle '"'||"X's won!  Click CLR to play again" ||'"'
		if (success == 2) then SetWindowTitle '"'||"O's won!  Click CLR to play again" ||'"'
		if (success == 0) then SetWindowTitle '"'||"Cat's game!  Click CLR to play again" ||'"'
		end
		else do
		success = UpdateStatus()
		end
	return 1
	

/* --------------------------------------------------------------- */
/* procedure CheckForWins					   */
/* --------------------------------------------------------------- */
CheckForWins: procedure expose TTTBoard. BoardWidth BoardHeight ToolBarHeight turn BActive BConnectMode

	i=1
	do while (i<4)
		if ((TTTBoard.i.1==1)&(TTTBoard.i.2==1)&(TTTBoard.i.3==1)) then do
			if ((turn == BActive)|(BConnectMode == 0)) then do
				SetFColor 15 15 15 notbackground
				BHeight = BoardHeight - ToolBarHeight
				if (i==1) then barleft = trunc(BoardWidth*.13)
				if (i==2) then barleft = trunc(BoardWidth*.47)
				if (i==3) then barleft = trunc(BoardWidth*.82)
				square barleft ToolBarHeight+trunc(BHeight*.05) (barleft+trunc(BoardWidth*.05)) (ToolBarHeight+trunc(BHeight*.95)) fill
				SetFColor 0 0 0 notbackground
				square barleft ToolBarHeight+trunc(BHeight*.05) (barleft+trunc(BoardWidth*.05)) (ToolBarHeight+trunc(BHeight*.95))
				end
			return 1
			end
			
		if ((TTTBoard.i.1==2)&(TTTBoard.i.2==2)&(TTTBoard.i.3==2)) then do
			if ((turn == BActive)|(BConnectMode == 0)) then do
				SetFColor 15 15 15 notbackground
				BHeight = BoardHeight - ToolBarHeight
				if (i==1) then barleft = trunc(BoardWidth*.13)
				if (i==2) then barleft = trunc(BoardWidth*.47)
				if (i==3) then barleft = trunc(BoardWidth*.82)
				square barleft ToolBarHeight+trunc(BHeight*.05) (barleft+trunc(BoardWidth*.05)) (ToolBarHeight+trunc(BHeight*.95)) fill
				SetFColor 0 0 0 notbackground
				square barleft ToolBarHeight+trunc(BHeight*.05) (barleft+trunc(BoardWidth*.05)) (ToolBarHeight+trunc(BHeight*.95))
				end
			return 2
			end
			
		i = i + 1
		end
	i=1
	do while (i<4)
		if ((TTTBoard.1.i==1)&(TTTBoard.2.i==1)&(TTTBoard.3.i==1)) then do
			if ((turn == BActive)|(BConnectMode == 0)) then do
				SetFColor 15 15 15 notbackground
				BHeight = BoardHeight - ToolBarHeight
				if (i==1) then bartop = trunc((BHeight*.13)+ToolBarHeight)
				if (i==2) then bartop = trunc((BHeight*.47)+ToolBarHeight)
				if (i==3) then bartop = trunc((BHeight*.82)+ToolBarHeight)
				square trunc(BoardWidth*.05) bartop trunc(BoardWidth*.95) (bartop+trunc(BHeight/20)) fill
				SetFColor 0 0 0 notbackground
				square trunc(BoardWidth*.05) bartop trunc(BoardWidth*.95) (bartop+trunc(BHeight/20))
				end
			return 1
			end

		if ((TTTBoard.1.i==2)&(TTTBoard.2.i==2)&(TTTBoard.3.i==2)) then do
			if ((turn == BActive)|(BConnectMode == 0)) then do
				SetFColor 15 15 15 notbackground
				BHeight = BoardHeight - ToolBarHeight
				if (i==1) then bartop = trunc((BHeight*.13)+ToolBarHeight)
				if (i==2) then bartop = trunc((BHeight*.47)+ToolBarHeight)
				if (i==3) then bartop = trunc((BHeight*.82)+ToolBarHeight)
				square trunc(BoardWidth*.05) bartop trunc(BoardWidth*.95) (bartop+trunc(BHeight/20)) fill
				SetFColor 0 0 0 notbackground
				square trunc(BoardWidth*.05) bartop trunc(BoardWidth*.95) (bartop+trunc(BHeight/20))
				end
			return 2
			end
			
		i = i + 1
		end

	if ((TTTBoard.1.1==1)&(TTTBoard.2.2==1)&(TTTBoard.3.3==1)) then do
		n = DrawDiagWinLine(1)
		return 1
		end
		
	if ((TTTBoard.1.1==2)&(TTTBoard.2.2==2)&(TTTBoard.3.3==2)) then do
		n = DrawDiagWinLine(1)
		return 2
		end
		
	if ((TTTBoard.3.1==1)&(TTTBoard.2.2==1)&(TTTBoard.1.3==1)) then do
		n = DrawDiagWinLine(0)
		return 1
		end
		
	if ((TTTBoard.3.1==2)&(TTTBoard.2.2==2)&(TTTBoard.1.3==2)) then do
		n = DrawDiagWinLine(0)
		return 2
		end
	
	return 0


/* --------------------------------------------------------------- */
/* procedure DrawDiagWinLine					   */
/*								   */
/* Draws a diagonal win line.  If TLtoBR is 1, draws it from the   */
/* top left to the bottom right.  Otherwise, draws it from the     */
/* bottom left to the top right.  				   */
/*								   */
/* --------------------------------------------------------------- */
DrawDiagWinLine: procedure expose BActive turn BoardWidth BoardHeight ToolBarHeight TTTBoard.
	parse arg TLtoBR

	cur = 0
	maxcur = trunc(BoardWidth * .025)
	BHeight = BoardHeight - ToolBarHeight
	startX = trunc(BoardWidth * 0.05)
	
	if (TLtoBR == 1) then do
		startY = trunc(BHeight * .1) + ToolBarHeight
		dY = -1
		end
	else do	
		startY = trunc(BHeight * .05) + trunc((BHeight*.83)+ToolBarHeight)
		dY = 1
		end
	
	setfcolor 15 15 15 notbackground
	endX = startX + trunc(BoardWidth * .83)
	endY = startY + trunc((-dY)*trunc(BHeight * .83))

	osX = startX
	osY = startY
	oeX = endX
	oeY = endY
	
	do while (cur < maxcur)
		line startX startY endX endY
		line (startX+1) startY (endX+1) endY

		startX = startX + 1
		startY = startY + dY
		endX = endX + 1
		endY = endY + dY
		cur = cur + 1
		end
		
	setfcolor 0 0 0 notbackground 
	line oeX+1 oeY endx+1 endy
	line osX osY startX startY

	line startx starty endX endY
	line osX osY oeX oeY
	
	return 1

	
	
/* --------------------------------------------------------------- */
/* procedure DrawMove						   */
/* --------------------------------------------------------------- */
DrawMove: procedure expose BActive turn BoardWidth BoardHeight ToolBarHeight TTTBoard.
	parse arg xx,yy

	if (TTTBoard.xx.yy == 0) then return 1
	
	BHeight = BoardHeight - ToolBarHeight
	
	if (yy == 1) then do
		ytop = ToolBarHeight
		ybot = trunc(BHeight*.3)+ToolBarHeight
		end
		
	if (yy == 2) then do
		ytop = trunc(BHeight*.36)+ToolBarHeight
		ybot = trunc(BHeight*.63)+ToolBarHeight
		end
		
	if (yy == 3) then do
		ytop = trunc(BHeight*.69)+ToolBarHeight 
		ybot = trunc(BHeight*.99)+ToolBarHeight
		end
		
	if (xx == 1) then do
		xleft = 1
		xright = trunc(BoardWidth*.3)
		end
		
	if (xx == 2) then do
		xleft = trunc(BoardWidth*.36)
		xright = trunc(BoardWidth*.63)
		end
		
	if (xx == 3) then do
		xleft = trunc(BoardWidth*.69)
		xright = trunc(BoardWidth*.99)
		end
		
/*	square xleft ytop xright ybot fill */
	if (TTTBoard.xx.yy == 1) then do
		penreset
		height = ybot - ytop
		width  = xright - xleft
		th = 3

		SetFColor 0 0 0 notbackground
		pen trunc(xleft+(width/th)) 	ytop
		pen trunc(xleft+(width/2)) 	trunc(ytop+(height/th))
		pen trunc(xright-(width/th)) 	ytop
		pen xright 			trunc(ytop+(height/th))
		pen trunc(xright-(width/th)) 	trunc(ytop+(height/2))
		pen xright 			trunc(ybot-(height/th))
		pen trunc(xright-(width/th)) 	ybot
		pen trunc(xright-(width/2)) 	trunc(ybot-(height/th))
		pen trunc(xleft+(width/th)) 	ybot
		pen xleft 			trunc(ybot-(height/th))
		pen trunc(xleft+(width/th)) 	trunc(ybot-(height/2))
		pen xleft 			trunc(ytop+(height/th))
		pen trunc(xleft+(width/th))	ytop

		SetFColor 15 0 0 notbackground
		
		flood trunc((xleft + xright)/2) trunc((ytop + ybot)/2)
		end
	else do
		SetFColor 0 0 0 notbackground
		circle trunc((xleft+xright)/2) trunc((ytop+ybot)/2) trunc((xright - xleft)/2) trunc((ybot - ytop)/2)
		circle trunc((xleft+xright)/2) trunc((ytop+ybot)/2) trunc((xright - xleft)/3) trunc((ybot - ytop)/3)

		SetFColor 0 15 0 notbackground
		flood trunc(((xleft+xright)/2)+((xleft-xright)/2.5)) trunc((ytop+ybot)/2)
		end
	return 1
	
		


/* --------------------------------------------------------------- */
/* procedure UpdateStatus					   */
/* --------------------------------------------------------------- */
UpdateStatus: procedure expose BActive turn BConnectMode moves

	if (moves > 8) then do
		SetWindowTitle '"'||"Game Over, click CLR to play again"||'"'
		return 1
		end
		
	if ((BActive == turn)|(BConnectMode == 0)) then do
		if (turn == 1) then SetWindowTitle '"'||"It's Your Turn, Player X"||'"'
		if (turn == 2) then SetWindowTitle '"'||"It's Your Turn, Player O"||'"'
	end
	else
	do
		if (turn == 1) then SetWindowTitle '"'||"It's Their Turn (Player X)"||'"'
		if (turn == 2) then SetWindowTitle '"'||"It's Their Turn (Player O)"||'"'
	end
	
	return 1

/* --------------------------------------------------------------- */
/* procedure InitTTTArray					   */
/* --------------------------------------------------------------- */
InitTTTArray: procedure expose TTTBoard. moves turn
	TTTBoard.1.1 = 0
	TTTBoard.1.2 = 0
	TTTBoard.1.3 = 0
	TTTBoard.2.1 = 0
	TTTBoard.2.2 = 0
	TTTBoard.2.3 = 0
	TTTBoard.3.1 = 0
	TTTBoard.3.2 = 0
	TTTBoard.3.3 = 0
	turn  = 1
	moves = 0
	return 1
	

/* --------------------------------------------------------------- */
/* procedure DrawTTTBoard					   */
/* --------------------------------------------------------------- */
DrawTTTBoard: procedure expose TTTBoard. BoardWidth BoardHeight ToolBarHeight turn BActive moves BConnectMode

   /* Say what we're doing */
   SetWindowTitle '"'||"Drawing TicTacToe board, Please Wait"||'"'
   SetRemoteWindowTitle '"'||"Drawing TicTacToe board, Please Wait"||'"'
   
   /* Examine window to get dimensions */
   GetWindowAttrs stem winattrs.
   BoardWidth = winattrs.width  - 58
   BoardHeight= winattrs.height - 53

   /* Clear Screen */
   clear

   /* Draw Board */
   SetFColor 0 0 0 notbackground

   /* Height of Board */
   BHeight = BoardHeight - ToolBarHeight   
   
   square (trunc(BoardWidth*.31)) ToolBarHeight (trunc(BoardWidth*.35)) BoardHeight fill
   square (trunc(BoardWidth*.64)) ToolBarHeight (trunc(BoardWidth*.68)) BoardHeight fill
   square 0 (trunc(BHeight*.31)+ToolBarHeight) BoardWidth (trunc(BHeight*.35)+ToolBarHeight) fill
   square 0 (trunc(BHeight*.64)+ToolBarHeight) BoardWidth (trunc(BHeight*.68)+ToolBarHeight) fill
   
   success=DrawMove(1,1)
   success=DrawMove(2,1)
   success=DrawMove(3,1)
   success=DrawMove(1,2)
   success=DrawMove(2,2)
   success=DrawMove(3,2)
   success=DrawMove(1,3)
   success=DrawMove(2,3)
   success=DrawMove(3,3)

   success=CheckForWins()
   if (success == 0) then success=UpdateStatus()
   return 1
   

/* --------------------------------------------------------------- */
/* procedure ParseMove						   */
/* --------------------------------------------------------------- */
ParseMove: procedure expose TTTBoard. BoardWidth BoardHeight ToolBarHeight turn moves BActive BConnectMode
	parse arg message

	xx=left(message,1)
	yy=right(message,1)

	if ((xx>3)||(xx<0)|(yy>3)||(yy<0)) then do
		SetWindowTitle '"'||"TicTacToe Transmission Trouble :("||'"'
		return 0
		end
		
	if (TTTBoard.xx.yy > 0) then do
		EasyRequest '"'||"TicTacToe Message"||'"' '"'||"Your opponent is cheating (" || xx yy TTTBoard.xx.yy || ") !"||'"' '"'||"What a maroon"||'"'
	end
	else do
		success=DoMove(xx,yy) 
	end
	return 1