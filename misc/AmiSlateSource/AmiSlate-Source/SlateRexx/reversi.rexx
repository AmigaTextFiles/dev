/* Reversi for AmiSlate v1.0! */
/* This program should be run on a screen with at least 8 colors */

/* Get our host's name--always given as first argument when run from Amislate */
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx reversi.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end
	
/* Send all commands to this host */
address (CommandPort) 
options results

lock ON

/* See if we're connected */
GetRemoteStateAttrs stem rstateattrs.
if (rstateattrs.mode > -1) then do
		/* Parse command line argument to see if we've been activated by 
		   a remote request or a local user */
		check = upper(left(ActiveString,3))
		if (upper(left(ActiveString,3)) ~= 'RE') then 
			GlobData.localplayer = 1
		else
			GlobData.localplayer = -1
		end
	else do
		GlobData.localplayer = 0	/* i.e. we're both players */
		end
		
if (GlobData.localplayer > 0) then do
	call SetStatus("Requesting game from remote user... please wait.")
	RemoteRexxCommand '"'||"Would you like to play Reversi?"||'"' "slaterexx:reversi.rexx"
	
        waitevent stem handshake. MESSAGE
        if (handshake.message == 0) then 
        do
            call SetStatus("Reversi Game Refused")
            lock off
            exit 0
        end
    end

call SetStatus("Beginning Reversi...")

call ResetGameState
call SetGlobalData
if (GlobData.localplayer >= 0) then call DrawBoard

call NextTurn
call HandleEvents

lock OFF
exit 0

/* Global Data structure:

	GlobData.Xspace.[step] (int)     : horizontal pixel offsets to the center of each coord (0-16)
	GlobData.XSize	(int)		 : total width of each element
	GlobData.Yspace.[step] (int)     : vertical pixel offsets to the center of each coord (0-16)
	GlobData.YSize	(int)		 : total height of each element

	(board state)
	GlobData.board.[0..8].[0..8]     : two-dimensional board array
	
	(game state)
	GlobData.turn			 : whose turn it is
	GlobData.localplayer 	         : which player is on local machine; 0 if both are

 	(color info)
	GlobData.PieceColor.[playernum]  : color of pieces for this player

*/

/* --------------------------------------------------------------- */
/* procedure HandleEvents 					   */
/* --------------------------------------------------------------- */
HandleEvents: procedure expose GlobData. AMessage.

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

do while(1)
    waitevent stem event. RESIZE MOUSEDOWN MOUSEUP TOOLSELECT MESSAGE DISCONNECT

    if (event.type == AMessage.QUIT) then exit 0
    
    if (event.type == AMessage.DISCONNECT) then do
    	call SetStatus("Connection broken--both players now local.")
    	GlobData.localplayer = 0
    	end
   
    if (event.type == AMessage.MESSAGE) then do
		parse var event.message rx ry
		call PlaceMove((rx+0), (ry+0), 0)  /* update our internals--the (+0) forces the vars back into numeric format */
		call NextTurn
		end

    if (event.type == AMessage.RESIZE) then do
		if ((GlobData.localplayer == GlobData.turn)|(GlobData.localplayer == 0)) then do
			cturn = GlobData.turn
			call SetGlobalData
			call DrawBoard
			call ColorBorder(GlobData.PieceColor.cturn)
			call SetStatus("_LAST")
		end
		else do
			/* else just update our internal vars */
			call SetGlobalData
			call SetStatus("_LAST")
		end
	end
    
    if ((event.type == AMessage.MOUSEDOWN)&((GlobData.turn = GlobData.localplayer)|(GlobData.localplayer == 0))) then do
    	whatclickedx = ChopRange(trunc((event.x-GlobData.BORDER_H)/(GlobData.XSize)),0,7)
    	whatclickedy = ChopRange(trunc((event.y-GlobData.BORDER_V)/(GlobData.YSize)),0,7)   	
    	if (MoveOkay(whatclickedx, whatclickedy) == 1) then do
    		call PlaceMove(whatclickedx, whatclickedy, 1)
    		if (localplayer ~= 0) then call TransmitMove(whatclickedx, whatclickedy)
    		call NextTurn
    		end
	end
    end
    return 1


/* --------------------------------------------------------------- */
/* procedure NextTurn						   */
/* 								   */
/* --------------------------------------------------------------- */
NextTurn: procedure expose GlobData.
	/* Swap turns */
	GlobData.turn = -GlobData.turn

	negone = -1
	player.1 = "Player 1"
	player.negone = "Player 2"
	cturn = GlobData.turn
		
	call SetStatus("Just a sec...")
	if (GlobData.turn == GlobData.localplayer) then call ColorBorder(0)
	
	/* Check to see if the new player has a move available */
	if (CanMove() == 0) then do
		call SetStatus("Sorry, " || player.cturn || ", but you must forfeit your turn.")
		call Delay(100)
		call NextTurn	/* recursive! :) */
		return 1
		end

	/* local game code */
	if (Globdata.localplayer == 0) then do
		call SetStatus(player.cturn || ", it's your turn to place a stone.")
		call ColorBorder(GlobData.PieceColor.cturn)
		return 1
		end
	
	/* two machine game code */
	if (GlobData.turn == GlobData.localplayer) then do
		call SetStatus(player.cturn || ", it's your turn to place a stone.")
		call ColorBorder(GlobData.PieceColor.cturn)
		end	
	else call SetStatus("Wait for other player to move.")	
	return 1


/* --------------------------------------------------------------- */
/* procedure ColorBorder					   */
/* 								   */
/* Colors the border the color indicated in the param 		   */
/*								   */
/* --------------------------------------------------------------- */
ColorBorder: procedure expose GlobData.
	parse arg color
	
	SetFPen color
	
	/* Fill each side of the border with a square */
	/* rely on AmiSlate's clipping to deal with extra material */
	square 0 0 10000 (GlobData.YSpace.0)-1 FILL
	square 0 0 (GlobData.XSpace.0)-1 10000 FILL
	square (GlobData.XSpace.8)+1 0 10000 10000 FILL
	square 0 (GlobData.YSpace.8)+1 10000 10000 FILL
	return 1
	

/* --------------------------------------------------------------- */
/* procedure CanMove						   */
/* 								   */
/* Returns 1 if there is a move available for the current player   */
/* else 0							   */
/* 								   */
/* --------------------------------------------------------------- */
CanMove: procedure expose GlobData.
	
	num1 = 0
	num2 = 0
	negone = -1
	
	do i = 0 to 7
		do j = 0 to 7
		 	if (GlobData.board.i.j == 1) then 
		 		num1 = num1 + 1
		 	else 
		 		if (GlobData.board.i.j == -1) then num2 = num2 + 1

			if (MoveOkay(i,j) == 1) then return 1
		end
	end
	
	/* If we got here there must not be an available move. */
	/* If it's because the board is filled, then the game is over! */
	if ((num1 + num2) == 64) then do
		if (num1 > num2) then do
			call ColorBorder(GlobData.PieceColor.1)
			call GameWon("Player 1")
			end
		else if (num1 < num2) then do
			call ColorBorder(GlobData.PieceColor.negone)
			call GameWon("Player 2")
			end
		else do
			call ColorBorder(0)
			call GameWon("Tie")
			end
		end

	/* If it's because one of the players has no pieces left, then 
	   the game is also over! */
	if (num1 == 0) then do
		call ColorBorder(GlobData.PieceColor.negone)
		call GameWon("Player 2")
		end
	if (num2 == 0) then do
		call ColorBorder(GlobData.PieceColor.1)
		call GameWon("Player 1")
		end
		
	/* otherwise there just wasn't a move available */
	return 0


/* --------------------------------------------------------------- */
/* procedure GameWon						   */
/* 								   */
/* displays a message saying who won, based on the arg, and exits. */
/*								   */
/* --------------------------------------------------------------- */
GameWon: procedure
	parse arg winner
	
	if (winner == "Tie") then winstring = "The game ends in a tie."
	else winstring = winner || " has won the game!"
	
	EasyRequest "Winner!" '"'||winstring||'"' "Okay"
	call SetStatus("Game over.  Rerun script to play again.")
	lock off
	exit 0
	

/* --------------------------------------------------------------- */
/* procedure PlaceMove						   */
/* 								   */
/* does a move by placing a piece at (x,y) and turning over all    */
/* appropriate pieces						   */
/*								   */
/* --------------------------------------------------------------- */
PlaceMove: procedure expose GlobData.
	parse arg x,y, draw
	
	GlobData.board.x.y = GlobData.turn
	if (draw == 1) then call DrawPiece(x,y, draw)
	if (BracketAvailable(x,y,-1,-1)) then call DrawBracket(x,y,-1,-1, draw)
	if (BracketAvailable(x,y,0,-1))  then call DrawBracket(x,y,0,-1, draw)
	if (BracketAvailable(x,y,1,-1))  then call DrawBracket(x,y,1,-1, draw)
	if (BracketAvailable(x,y,1,0))   then call DrawBracket(x,y,1,0, draw)
	if (BracketAvailable(x,y,1,1))   then call DrawBracket(x,y,1,1, draw)
	if (BracketAvailable(x,y,0,1))   then call DrawBracket(x,y,0,1, draw)
	if (BracketAvailable(x,y,-1,1))  then call DrawBracket(x,y,-1,1, draw)
	if (BracketAvailable(x,y,-1,0))  then call DrawBracket(x,y,-1,0, draw)
	return 1


/* --------------------------------------------------------------- */
/* procedure MoveOkay						   */
/* 								   */
/* returns 1 if move is acceptable, or -1 if it is illegal.	   */
/* 								   */
/* --------------------------------------------------------------- */
MoveOkay: procedure expose GlobData.
	parse arg x, y

	negone = -1
	
	/* first rule: you can only place a stone where there isn't one */
	if (GlobData.board.x.y ~= 0) then return 0
	
	/* The only other rule: there must be a "bracket pair" in a direction */

	/* Try north first */
	if (BracketAvailable(x,y,0,-1)  == 1) then return 1
	if (BracketAvailable(x,y,0,1)   == 1) then return 1
	if (BracketAvailable(x,y,-1,0)  == 1) then return 1
	if (BracketAvailable(x,y,1,0)   == 1) then return 1
	if (BracketAvailable(x,y,-1,-1) == 1) then return 1
	if (BracketAvailable(x,y,1,-1)  == 1) then return 1
	if (BracketAvailable(x,y,-1,1)  == 1) then return 1
	if (BracketAvailable(x,y,1,1)   == 1) then return 1
	
	/* No move available */	
	return 0
	

/* --------------------------------------------------------------- */
/* procedure BracketAvailable					   */
/*								   */
/* Searches for an "us-them[...-them]-us" pattern in the direction */
/* indicated by dx and dy. 					   */
/*								   */
/* --------------------------------------------------------------- */
BracketAvailable: procedure expose GlobData.
	parse arg x,y,dx,dy
	
	/* default */
	BFoundMiddle = 0
	
	/* move off of the square-in-question... */
	x = x + dx
	y = y + dy
	
	do while ((x>=0)&(y>=0)&(x<=7)&(y<=7))
		/* We hit a blank--no end on our bracket */
		if (GlobData.board.x.y == 0) then return 0
		
		/* We hit our own piece--okay iff we saw theirs beforehand */
		if (GlobData.board.x.y == GlobData.turn) then return BFoundMiddle

		/* We hit their piece--make a note of it */
		if (GlobData.board.x.y == -GlobData.turn) then BFoundMiddle = 1

		/* advance to next square */
		x = x + dx
		y = y + dy
		end
	
	/* Nope, ran off board */	
	return 0
	


/* --------------------------------------------------------------- */
/* procedure DrawBracket					   */
/*								   */
/* Flips the counters for all of the other side's pieces in the    */
/* given bracket. 						   */
/*								   */
/* --------------------------------------------------------------- */
DrawBracket: procedure expose GlobData.
	parse arg x,y,dx,dy,draw
		
	/* move off of the square-in-question... */
	x = x + dx
	y = y + dy

	do while ((x>=0)&(y>=0)&(x<=7)&(y<=7))	
		/* We hit our own piece--we're all done */
		if (GlobData.board.x.y == GlobData.turn) then return 1

		/* We hit their piece--flip it! */
		if (GlobData.board.x.y == -GlobData.turn) then do
			GlobData.board.x.y = GlobData.turn
			if (draw == 1) then call DrawPiece(x,y,draw)
			end

		/* advance to next square */
		x = x + dx
		y = y + dy
		end

	/* Nope, ran off board */
	return 0
	

/* --------------------------------------------------------------- */
/* procedure ResetGameState					   */
/* --------------------------------------------------------------- */
ResetGameState: procedure expose GlobData.
	negone = -1;
	
	GlobData.turn = -1;
	
	/* first clear the board */
	do i = 0 to 7
		do j = 0 to 7
			GlobData.board.i.j = 0
		end
	end

	/* then add in initial pieces */
	GlobData.board.3.3 = 1
	GlobData.board.4.4 = 1
	GlobData.board.4.3 = -1
	GlobData.board.3.4 = -1
	return 1

/* --------------------------------------------------------------- */
/* procedure SetGlobalData					   */
/* --------------------------------------------------------------- */
SetGlobalData: procedure expose GlobData.
	negone = -1
	
	/* constants */
	GlobData.BORDER_H = 5
	GlobData.BORDER_V = 10
	
	/* Check to see whether we are connected */
   	GetWindowAttrs stem winattrs.
   	BoardWidth = winattrs.width  - 58 - (GlobData.BORDER_H*2)
   	BoardHeight= winattrs.height - 55 - (GlobData.BORDER_V*2)

	/* Set up offsets */
	DO i=0 to 8
	  GlobData.Xspace.i = trunc(BoardWidth  * i / 8) + GlobData.BORDER_H
	  GlobData.Yspace.i = trunc(BoardHeight * i / 8) + GlobData.BORDER_V
	  end

	GlobData.XSize = trunc(BoardWidth / 8)
	GlobData.YSize = trunc(BoardHeight / 8)

   	if (winattrs.depth < 2) then do
		EasyRequest Reversi_Error '"'||"You need at least a 4-color screen to play Reversi!"||'"' '"'||"Abort Reversi"||'"'
		call SetStatus("Reversi game exited.")
		lock off
		exit 0
		end 

	GlobData.PieceColor.1 = 2
	GlobData.PieceColor.negone = 3
	return 1


/* --------------------------------------------------------------- */
/* procedure DrawBoard                                             */
/* --------------------------------------------------------------- */
DrawBoard: procedure expose GlobData.
	SetFColor 0 0 0		/* Get a black pen */

	Clear

	SetWindowTitle '"' || "Hang on, drawing the board..." || '"'

	SetFPen 1
	do i = 0 to 8
		line GlobData.XSpace.i GlobData.YSpace.0 GlobData.XSpace.i GlobData.YSpace.8
		line GlobData.XSpace.0 GlobData.YSpace.i GlobData.XSpace.8 GlobData.YSpace.i
		end
		
	do i = 0 to 7
		do j = 0 to 7
			if (GlobData.Board.i.j ~= 0) then call DrawPiece(i,j)
			end
		end
		
	call SetStatus("_LAST")
	return 1


/* Draws the piece listed at coords xc, yc */
DrawPiece: procedure expose GlobData.
	parse arg xc, yc

	piece = GlobData.board.xc.yc
	if (piece == 0) then return 0
	
	/* Draw the piece in the square on the LOWER RIGHT of this intersection */
	cx = MidwayBetween(xc,xc+1,X)
	cy = MidwayBetween(yc,yc+1,Y)	
	
	SetFPen GlobData.PieceColor.piece
	circle cx cy trunc(GlobData.XSize/3) trunc(GlobData.YSize/3) FILL
	SetFPen 1
	circle cx cy trunc(GlobData.XSize/3) trunc(GlobData.YSize/3) 
	return 1



SetStatus: procedure
	parse arg newstatus
	
	if (newstatus == "_LAST") then do
		SetWindowTitle '"' || getclip("PrevString") || '"'
		end
	else do
		call setclip("PrevString",newstatus)
		SetWindowTitle '"' || newstatus || '"'
	end
	return 1
	

	
	
	

/* Returns the point midway between two coords */
MidWayBetween: procedure expose GlobData.
	parse arg left, right, XorY

	if (XorY = X) then 
		return trunc((GlobData.XSpace.left + GlobData.XSpace.right)/2)
	else	
		return trunc((GlobData.YSpace.left + GlobData.YSpace.right)/2)

ChopRange: procedure
	parse arg myval, lo, hi
	if (myval < lo) then return lo
	if (myval > hi) then return hi
	return myval
	
	
/* --------------------------------------------------------------- */
/* procedure CheckForWin                                           */
/* --------------------------------------------------------------- */
CheckForWin: procedure expose GlobData.
	winner = nobody
	negone = -1
	
	if (GlobData.exited.1 == 15) then winner = "Player 1"
	else if (GlobData.exited.negone == 15) then winner = "Player 2"
	
	/* nobody one yet */
	if (winner == nobody) then return 1
	
	EasyRequest "Winner!" '"'||winner||" has won the game!"||'"' "Okay"
	call SetStatus("Game Over.  Rerun the script to play again.")
	lock off
	exit
	return 0
	
		
/* Transmit our move to our opponent */
TransmitMove: procedure 
	parse arg x, y
	
	sstring = '"' || x || " " || y || '"'
	sendmessage sstring
	return 1
	
