/* Checkers for AmiSlate v1.0! */
/* This program should be run on a screen with at least 4 colors */

/* Get our host's name--always given as first argument when run from Amislate */
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx checkers.rexx <REXXPORTNAME>"
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
	RemoteRexxCommand '"'||"Would you like to play Checkers?"||'"' "slaterexx:Checkers.rexx"
	
        waitevent stem handshake. MESSAGE
        if (handshake.message == 0) then 
        do
            call SetStatus("Checkers Game Refused")
            lock off
            exit 0
        end
    end

call SetStatus("Beginning Checkers...")

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

fromx = -1
fromy = -1
jumponlymode = 0

do while(1)
    waitevent stem event. RESIZE MOUSEDOWN MOUSEUP TOOLSELECT MESSAGE DISCONNECT

    if (event.type == AMessage.QUIT) then exit 0
    
    if (event.type == AMessage.DISCONNECT) then do
    	call SetStatus("Connection broken--both players now local.")
    	GlobData.localplayer = 0
    	end
   
    if (event.type == AMessage.MESSAGE) then do
		parse var event.message fx fy tx ty
		if (fx = -1) then 
			call NextTurn
		else 
			call PlaceMove((fx+0), (fy+0), (tx+0), (ty+0), 0)  /* update our internals--the (+0) forces the vars back into numeric format */
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
    	if (fromx >= 0) then do
    		if ((whatclickedx == fromx)&(whatclickedy == fromy)) then do
    			/* cancel that move! */
    			call HilitePiece(fromx, fromy)
    			fromx = -1
    			fromy = -1
    			if (jumponlymode > 0) then do
    				/* that's all for the move then */
    				jumponlymode = 0
    				call NextTurn
    				if (localplayer ~= 0) then call TransmitMove(-1, -1, -1, -1)
    				end
    			end
    		else do
    			if (MoveOkay(fromx, fromy, whatclickedx, whatclickedy) == 1) then do
    				if (localplayer ~= 0) then call TransmitMove(fromx, fromy, whatclickedx, whatclickedy)
    				if (PlaceMove(fromx, fromy, whatclickedx, whatclickedy, 1) == 2) then do
    					call HilitePiece(whatclickedx, whatclickedy)
    					jumponlymode = jumponlymode + 1
    					call TellExtraJump(jumponlymode)
    					fromx = whatclickedx
    					fromy = whatclickedy
    					end
    				else do
    					if (localplayer ~= 0) then call TransmitMove(-1, -1, -1, -1)
    					jumponlymode = 0
    					call NextTurn
	    				fromx = -1
    					fromy = -1
    					end
    				end 
    				else DisplayBeep LOCAL
    			end 
    		end
    	else do
    		if ((GlobData.board.whatclickedx.whatclickedy * GlobData.turn) > 0) then do
    			fromx = whatclickedx
    			fromy = whatclickedy
    			call HilitePiece(fromx, fromy)
    			end
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
		if (localplayer ~= 0) then TransmitMove(-1,-1,-1,-1)
		call NextTurn	/* recursive! :) */
		return 1
		end

	/* local game code */
	if (Globdata.localplayer == 0) then do
		call SetStatus(player.cturn || ", it's your turn to move a checker.")
		call ColorBorder(GlobData.PieceColor.cturn)
		return 1
		end
	
	/* two machine game code */
	if (GlobData.turn == GlobData.localplayer) then do
		call SetStatus(player.cturn || ", it's your turn to move a checker.")
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
	
	return 1


/* --------------------------------------------------------------- */
/* procedure PieceCanJump					   */
/* 								   */
/* Returns 1 if there is a jump available for the piece at the     */
/* give spot, else returns 0 					   */
/* 								   */
/* --------------------------------------------------------------- */
PieceCanJump: procedure expose GlobData.
	parse arg fx, fy
	
	if (MoveOkay(fx,fy,fx+2,fy+2) == 1) then return 1
	if (MoveOkay(fx,fy,fx-2,fy+2) == 1) then return 1
	if (MoveOkay(fx,fy,fx+2,fy-2) == 1) then return 1
	if (MoveOkay(fx,fy,fx-2,fy-2) == 1) then return 1
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
/* returns 2 if the piece should be given the option of another    */
/* jump after this one. 					   */
/*								   */
/* --------------------------------------------------------------- */
PlaceMove: procedure expose GlobData.
	parse arg fx, fy, tx, ty, draw
	
	negone = -1
	piece = GlobData.board.fx.fy
	GlobData.board.fx.fy = 0

	/* If it wasn't a king, check to see if it needs to be kinged */
	if (((piece == 1)&(ty == 7))|((piece == -1)&(ty == 0))) then piece = piece * 2

	GlobData.board.tx.ty = piece

	if (draw == 1) then do
		call DrawPiece(fx, fy)
		call DrawPiece(tx, ty)
		end
	
	/* check to see if it was a jump */
	if (abs(tx-fx) > 1) then do
		mx = (tx+fx)%2
		my = (ty+fy)%2
		GlobData.board.mx.my = 0
		if (draw == 1) then call DrawPiece(mx, my)

		/* decrement appropriate piece-counter */
		opponent = -GlobData.turn
		GlobData.pieces.opponent = GlobData.pieces.opponent - 1

		/* check for a win */
		if (GlobData.pieces.1 == 0) then do
			call ColorBorder(GlobData.PieceColor.1)
			call GameWon("Player 1")
			end
		else if (GlobData.pieces.negone == 0) then do
			call ColorBorder(GlobData.PieceColor.negone)
			call GameWon("Player 2")
			end
			
		/* Can we jump again? */
		if (PieceCanJump(tx,ty) == 1) then return 2
		end
	
	return 1


/* --------------------------------------------------------------- */
/* procedure MoveOkay						   */
/* 								   */
/* returns 1 if move is acceptable, or -1 if it is illegal.	   */
/* 								   */
/* --------------------------------------------------------------- */
MoveOkay: procedure expose GlobData.
	parse arg fx, fy, tx, ty

	negone = -1
	
	/* First rule: all moves on the board */
	if ((fx < 0)|(fy < 0)|(fx > 7)|(fy > 7)|(tx < 0)|(ty < 0)|(tx > 7)|(ty > 7)) then return 0
	
	/* Must be moving our own piece */
	if ((GlobData.board.fx.fy * GlobData.turn) <= 0) then return 0

	/* Place we move to must be empty */
	if (GlobData.board.tx.ty ~= 0) then return 0
	
	/* If it is a regular piece, is it in the right direction? */
	if (abs(GlobData.board.fx.fy) == 1) then do
		if ((GlobData.turn == 1)&(fy > ty)) then return 0
		if ((GlobData.turn == -1)&(fy < ty)) then return 0
		end
	
	/* No moving too far! */
	if (abs(tx-fx) > 2) then return 0
	if (abs(ty-fy) > 2) then return 0
	
	/* must be diagonal */
	if (abs(tx-fx) ~= abs(ty-fy)) then return 0
	
	/* If it is a jump, make sure there is someone there to jump */	
	if (abs(tx-fx) > 1) then do
		mx = (fx+tx)%2
		my = (fy+ty)%2
		if (GlobData.board.mx.my * GlobData.turn >= 0) then return 0
		end
				
	/* No move available */	
	return 1
	
	

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

	/* then add in initial pieces --play on color 3 */
	do i = 0 to 2
		do j = 0 to 3
			x = j*2
			if (i==1) then x = x + 1
			GlobData.board.x.i = 1
			xx = 7 - x
			yy = i + 5
			GlobData.board.xx.yy = -1
			end
		end	
	
	GlobData.pieces.1 = 12
	GlobData.pieces.negone = 12
	
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
		EasyRequest Checkers_Error '"'||"You need at least a 4-color screen to play Checkers!"||'"' '"'||"Abort Checkers"||'"'
		call SetStatus("Checkers game exited.")
		lock off
		exit 0
		end 

	GlobData.PieceColor.1 = 1
	GlobData.PieceColor.negone = 2
	GlobData.OutlineColor.1 = 2
	GlobData.OutlineColor.negone = 1
	return 1


/* --------------------------------------------------------------- */
/* procedure DrawBoard                                             */
/* --------------------------------------------------------------- */
DrawBoard: procedure expose GlobData.
	SetFColor 0 0 0		/* Get a black pen */

	Clear

	SetWindowTitle '"' || "Hang on, drawing the board..." || '"'

	do i = 0 to 7
		do j = 0 to 7
			call DrawPiece(i,j)
			end
		end
		
	call SetStatus("_LAST")
	return 1


/* XORs the given piece */
HiLitePiece: procedure expose GlobData.
	parse arg xc, yc
	
	/* Draw the piece in the square on the LOWER RIGHT of this intersection */
	cx = MidwayBetween(xc,xc+1,X)
	cy = MidwayBetween(yc,yc+1,Y)	
	circle cx cy trunc(GlobData.XSize/3) trunc(GlobData.YSize/3) FILL XOR
	return 1

	
/* Draws the piece listed at coords xc, yc */
DrawPiece: procedure expose GlobData.
	parse arg xc, yc

	isking = 0
	piece = GlobData.board.xc.yc
	
	if (abs(piece) == 2) then do
		piece = piece % 2
		isking = 1
		end
		
	/* Draw the square in the correct background color */
	if ((xc//2) == (yc//2)) then 
		SetFPen 3
	else
		SetFPen 0

	nx = xc + 1
	ny = yc + 1		

	square GlobData.XSpace.xc+1 GlobData.YSpace.yc+1 GlobData.XSpace.nx-1 GlobData.YSpace.ny-1 FILL	

	SetFPen 1
	square GlobData.XSpace.xc GlobData.YSpace.yc GlobData.XSpace.nx GlobData.YSpace.ny

	/* If there's no piece here, we're done */
	if (piece == 0) then return 0
	
	/* Draw the piece in the square on the LOWER RIGHT of this intersection */
	cx = MidwayBetween(xc,nx,X)
	cy = MidwayBetween(yc,ny,Y)	
	
	SetFPen GlobData.PieceColor.piece
	circle cx cy GlobData.XSize%3 GlobData.YSize%3 FILL
	SetFPen GlobData.OutlineColor.piece
	circle cx cy GlobData.XSize%3 GlobData.YSize%3 
	
	/* Draw a crown if it's a king */
	if (isking == 1) then do
		left  = cx - (GlobData.XSize%6)
		right = cx + (GlobData.XSize%6)
		top   = cy - (GlobData.YSize%6)
		bottom= cy + (GlobData.YSize%6)
		width = right - left
		height= bottom - top
		
		/* Draw outline of crown */
		penreset
		pen left top
		pen (left + (width%5)) bottom
		pen (right - (width%5)) bottom
		pen right top
		pen (right - (width%3)) (top+(height%2))
		pen (left + (width%2)) (top+(height%4))
		pen (left + (width%3)) (top+(height%2))
		pen left top
		
		/* fill it */
		flood (left + (width%2)) (bottom-1)
		
		end
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
	parse arg fx, fy, tx, ty
	
	sstring = '"' || fx || " " || fy || " " || tx || " " || ty || '"'
	sendmessage sstring
	return 1
	


TellExtraJump: procedure
	parse arg jumpnum
	
	if (jumpnum == 1) then x = "double"
	if (jumpnum == 2) then x = "triple"
	if (jumpnum == 3) then x = "quadruple"
	if (jumpnum == 4) then x = "quintuple"
	if (jumpnum == 5) then x = "sextuple"
	if (jumpnum == 6) then x = "septuple"
	if (jumpnum == 7) then x = "octuple"
	if (jumpnum >= 8) then x = "maliciously"
	
	call SetStatus("You may " || x || " jump if you wish.")
	return 1
	