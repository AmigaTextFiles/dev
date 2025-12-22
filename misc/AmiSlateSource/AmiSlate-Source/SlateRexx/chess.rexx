/* Chess for AmiSlate v1.0! */
/* This program should be run on a screen with at least 8 colors */

/* Constants for use with AmiSlate's ARexx interface */
AMode.DOT      =  0 
AMode.PEN      =  1 
AMode.LINE     =  2 
AMode.CIRCLE   =  3 
AMode.SQUARE   =  4 
AMode.POLY     =  5 
AMode.FLOOD    =  6 
AMode.DTEXT    =  7 

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

ACTIVE  = 1
PASSIVE = 0

/* Chess specific constants */
GlobData.HILITEPEN = 2
GlobData.SQUAREPEN1 = 3		/* It would probably be better to get these */
GlobData.SQUAREPEN2 = 4		/* dynamically, wouldn't it? */
GlobData.SIDE1PEN   = 2
GlobData.SIDE2PEN   = 1
GlobData.moverr = "No error"

piece.BLANK  = 0
piece.PAWN   = 1
piece.ROOK   = 2
piece.KNIGHT = 4
piece.BISHOP = 8
piece.QUEEN  = 16
piece.KING   = 32

/* Defaults */
BInitialSquareSet = 0

/* Get our host's name--always given as first argument when run from Amislate */
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx chess.rexx <REXXPORTNAME>"
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
GlobData.ToolBarHeight = 0

/* Check to see which tool is selected, whether we are connected */
GlobData.BFlood = 0
GetStateAttrs stem stateattrs.

if (stateattrs.mode > 1) then GlobData.BFlood = 1

/* Parse command line argument to see if we've been activated by 
   a remote request or a local user */
check = upper(left(ActiveString,3))
if (upper(left(ActiveString,3)) ~= 'RE') then 
	do
		GlobData.BActive = 1
	end
	else
	do	
		GlobData.BActive = 0
	end

/* See if we're connected */
GetRemoteStateAttrs stem rstateattrs.

if (rstateattrs.mode > -1) then 
	do
		GlobData.BConnectMode = 1
	end
	else
	do
		GlobData.BConnectMode = 0
	end
	
'lock on'			/* keep user from drawing */
'lockpalette on'		/* match colors, if possible */

success = InitChessArray()

/* Initiator goes first */
GlobData.turn = ACTIVE


/* Handshaking for two-computer game */
if (GlobData.BConnectMode = 1) then 
do
    if (GlobData.BActive == 1) then 
    do
    	SetWindowTitle '"'||"Requesting game from remote user"||'"' 
	RemoteRexxCommand '"'||"Would you like to play chess?"||'"' "slaterexx:chess.rexx"
	
        waitevent stem handshake. MESSAGE
        if (handshake.message == 0) then 
        do
            SetWindowTitle '"'||"Chess Game Refused"||'"'
            exit
        end
	success = DrawChessBoard()
	SetRemoteWindowTitle '"'||"Their turn (White)"||'"'
    end
    else
    do
    	/* Examine window to get dimensions */
	GetWindowAttrs stem winattrs.
   	GlobData.BoardWidth = winattrs.width  - 58
   	GlobData.BoardHeight= winattrs.height - 53 - GlobData.ToolBarHeight
    end
end
else 
do
    success = DrawChessBoard()
end        

/* If we're in line mode, tell the remote client */
if (GlobData.BActive == 1) then sendmessage "*****"||GlobData.BFlood



success = UpdateStatus()
do while(1)
    waitevent stem event. RESIZE MOUSEDOWN MOUSEUP TOOLSELECT MESSAGE DISCONNECT
	
    if (event.type == AMessage.DISCONNECT) then GlobData.BConnectMode = 0
	if (event.type == AMessage.QUIT) then exit
	if (event.type == AMessage.RESIZE) then do
		if ((GlobData.BActive == 1)|(GlobData.BConnectMode == 0)) then do
		   success = DrawChessBoard()
		end
		else do
		   /* Just examine window to get new dimensions */
		   GetWindowAttrs stem winattrs.
		   GlobData.BoardWidth = winattrs.width  - 58
		   GlobData.BoardHeight= winattrs.height - 53 - GlobData.ToolBarHeight
		end
 	        success = UpdateStatus()
	end

    if (event.type == AMessage.MESSAGE) then do
        success = ParseMove(event.message)
        if (success == 1) then do
             GlobData.turn = GlobData.BActive
             success = UpdateStatus()
             end
        end
        
	if ((event.type = AMessage.TOOLSELECT)&(GlobData.BActive == 1)) then do
		BOldFlood = GlobData.BFlood
		if (event.code1 < 1) then GlobData.BFlood = 0
		if (event.code1 >= 1) then GlobData.BFlood = 1
		if ((event.code1 = 7)|(GlobData.BFlood ~= BOldFlood)) then do
			success = DrawChessBoard()
			sendmessage "*****"||GlobData.BFlood
			end
		end

	if (((event.type = AMessage.MOUSEDOWN)|((event.type = AMessage.MOUSEUP)&(BInitialSquareSet = 1)))&((GlobData.turn = GlobData.BActive)|(GlobData.BConnectMode = 0))) then do
		xtemp = event.x
		SelectChessSquareX = -1
		do while (xtemp > 0)
			xtemp = xtemp - trunc(GlobData.BoardWidth / 8)
			SelectChessSquareX = SelectChessSquareX + 1
			end
		ytemp = event.y
		SelectChessSquareY = -1
		do while (ytemp > GlobData.ToolBarHeight)
			ytemp = ytemp - trunc(GlobData.BoardHeight / 8)
			SelectChessSquareY = SelectChessSquareY + 1
			end

        ThisSquare = ChessBoard.SelectChessSquareX.SelectChessSquareY        
        if (((GlobData.turn == ACTIVE)&(ThisSquare > 0))|((GlobData.turn == PASSIVE)&(ThisSquare < 0))|(BInitialSquareSet == 1)) then do
   
       		/* HiLite selected square */
    		success = SelectChessSquare(SelectChessSquareX, SelectChessSquareY, GlobData.HILITEPEN)
    
     		if (BInitialSquareSet = 0) then do
    			BInitialSquareSet = 1
    			SelectedSquareX = SelectChessSquareX
    			SelectedSquareY = SelectChessSquareY
    			end
    		else do
    			/* De-HiLite old square */
    			sqc = SquareColor(SelectedSquareX, SelectedSquareY)
    			success = SelectChessSquare(SelectedSquareX, SelectedSquareY, sqc)
    		
    			/* De-HiLite this square--move done! */	
    			sqc = SquareColor(SelectChessSquareX, SelectChessSquareY)
    			success = SelectChessSquare(SelectChessSquareX,SelectChessSquareY, sqc)
    
    			BInitialSquareSet = 0

			GlobData.moverr = "No error"

			moveResult = MovePiece(SelectedSquareX, SelectedSquareY, SelectChessSquareX, SelectChessSquareY)
			if (moveResult > 0) then do
    			    szSendString = "1" || selectedSquareX || SelectedSquareY || SelectChessSquareX || SelectChessSquareY || moveResult
    			    sendmessage szSendString
    			    if (GlobData.turn == 1) then do
    			        GlobData.turn = 0
    			        end
    			    else do
    			        GlobData.turn = 1
    			        end
    			    success = UpdateStatus()
    			    end
    			else do
    			    SetWindowTitle '"'||"Error: "|| GlobData.moverr || '"'
    			    DisplayBeep
	    		    end
        		end
	    	end
	    end
	end
exit



/* --------------------------------------------------------------- */
/* procedure MovePiece						   */
/* --------------------------------------------------------------- */
MovePiece: procedure expose ChessBoard. piece. PiecePosX. PiecePosY. GlobData.
	parse arg OldX, OldY, X, Y
	
	if (CheckMove(OldX, OldY, X, Y, 1) == 0) then do
		return 0	
		end
		
	/* Special case for castling--king moves to earlier square */
	if (abs(ChessBoard.OldX.OldY) == Piece.King) then do
		if ((OldX == 3)&(X == 0)) then X = 1
		if ((OldX == 3)&(X == 7)) then X = 6
		end
				
	if (UpdatePiecePos(OldX, OldY, X, Y) == 0) then do
		EasyRequest Chess_Error "555:UPP_failed" Okay
		return 0
		end	
	
	/* Was there a death here?  If so, remove dying piece */
	if (ChessBoard.X.Y ~= Piece.BLANK) then do
		VictimPiece = GetPiecePos(X, Y)
		if (VictimPiece > 0) then do
			PiecePosX.1.VictimPiece = 9999
			PiecePosY.1.VictimPiece = 9999
			end
		else do
			VictimPiece = abs(VictimPiece)
			PiecePosX.2.VictimPiece = 9999
			PiecePosY.2.VictimPiece = 9999
			end
		end

	returnresult = 1
	
	/* Check for pawn promotion */
	if (((Y == 7)&(ChessBoard.OldX.OldY == Piece.PAWN))|((Y == 0)&(ChessBoard.OldX.OldY == -Piece.PAWN))) then do
	    	if (ChessBoard.OldX.OldY = Piece.PAWN) then do
	    		tSide = 1
	    		end
	    	else do
	    		tSide = -1
	    	end
	    	
	    	EasyRequest '"'||"Your pawn is getting a promotion!"||'"' '"'||"What do you want to promote your pawn to?"||'"' "Queen|Rook|Bishop|Knight"
		if (rc == 0) then ChessBoard.OldX.OldY = tSide * Piece.Knight
		if (rc == 1) then ChessBoard.OldX.OldY = tSide * Piece.Queen
		if (rc == 2) then ChessBoard.OldX.OldY = tSide * Piece.Rook
		if (rc == 3) then ChessBoard.OldX.OldY = tSide * Piece.Bishop
		returnresult = rc + 2	/* For transmission */
	end
	
	ChessBoard.X.Y = ChessBoard.OldX.OldY  			/* Then put the piece in the new spot! */
	ChessBoard.OldX.OldY = Piece.BLANK
	
	success=DrawPiece(OldX, OldY, ChessBoard.OldX.OldY, GlobData.BFlood)
	success=DrawPiece(X, Y, ChessBoard.X.Y, GlobData.BFlood)
					
	return returnresult


/* --------------------------------------------------------------- */
/* procedure MoveCreatesCheck				           */
/*								   */
/* This procedure will determine if the move (OldX,OldY)->(X,Y)    */
/* will get the piece at CheckX, CheckY into danger (i.e. check    */
/* for a king, etc. ) without affecting the board	   	   */
/* --------------------------------------------------------------- */
MoveCreatesCheck: procedure expose ChessBoard. piece. PiecePosX. PiecePosY. 
	parse arg OldX, OldY, X, Y, CheckX, CheckY
	
	if (ChessBoard.OldX.OldY == Piece.BLANK) then do
		EasyRequest Chess_Error "MoveCreatesCheck:_Bad_Attacker!" Okay
		return 1
		end
	
	AttackerPiece = ChessBoard.OldX.OldY
	AttackerID = GetPiecePos(OldX, OldY)
	if (AttackerID == 0) then do
		EasyRequest Chess_Error "MoveCreatesCheck:_Anonymous_Attacker!" Okay
		return 1
		end
	if (AttackerID < 0) then do
		AttackerID = abs(AttackerID)
		nAttackerSide = 2
		end
	else do
		nAttackerSide = 1
		end
			
	TargetPiece = ChessBoard.X.Y
	TargetID    = 0			/* Default = unset/error */	
	if (TargetPiece ~= Piece.BLANK) then do
	TargetID = GetPiecePos(X,Y)
	if (TargetID == 0) then do
		EasyRequest Chess_Error "MoveCreatesCheck:_Anonymous_defender!" Okay
		return 1
		end
	if (TargetID < 0) then do
		TargetID = abs(TargetID)
		nTargetSide = 2
		end
	else do
		nTargetSide = 1
		end
	PiecePosX.nTargetSide.TargetID = 9999
	PiecePosY.nTargetSide.TargetID = 9999
	end

	/* Move the attacker, on both arrays */
        PiecePosX.nAttackerSide.AttackerID = X
        PiecePosY.nAttackerSide.AttackerID = Y
	ChessBoard.X.Y = AttackerPiece  			/* Then put the piece in the new spot! */

	/* Erase the attacker from his old position */
	ChessBoard.OldX.OldY = Piece.BLANK

	/* Now see if we have a check situation */
	returnFlag = IsInCheck(CheckX,CheckY)
	
	/* Clean up from our little sim -- move piece back and replace victim */
	ChessBoard.OldX.OldY = AttackerPiece
	PiecePosX.nAttackerSide.AttackerID = OldX
	PiecePosY.nAttackerSide.AttackerID = OldY
	
	ChessBoard.X.Y = TargetPiece
	if (TargetID ~= 0) then do
		PiecePosX.nTargetSide.TargetID = X
		PiecePosY.nTargetSide.TargetID = Y
		end
	
	return ReturnFlag
	

	
/* --------------------------------------------------------------- */
/* procedure UpdatePiecePos			                   */
/* --------------------------------------------------------------- */
UpdatePiecePos: procedure expose ChessBoard. PiecePosX. PiecePosY.
	parse arg OldX, OldY, X, Y
	
	ThisPiece = GetPiecePos(OldX, OldY)
	
	if (ThisPiece == 0) then do
		EasyRequest Chess_Error "UpdatePiecePos:update_empty_square?_huh?" Okay
		return 0
		end
		
	if (ThisPiece > 0) then do
		PiecePosX.1.ThisPiece = X
		PiecePosY.1.ThisPiece = Y
		return 1
		end
	else do
		ThisPiece = abs(ThisPiece)
		PiecePosX.2.ThisPiece = X
		PiecePosY.2.ThisPiece = Y
		return 1
		end
	
	EasyRequest Chess_Error "UpdatePiecePos_error-not_found" Okay
	return 0




/* --------------------------------------------------------------- */
/* procedure GetPiecePos   				           */
/*								   */
/* Given a set of co-ordinates, this function returns the PiecePos */
/* index/ID of the piece there.  Positive values is for Side1 (top */
/* and negative values are for side2 (bottom).  0 = blank/error.   */
/* --------------------------------------------------------------- */
GetPiecePos: procedure expose PiecePosX. PiecePosY. ChessBoard.
	parse arg X, Y
	
	if ((ChessBoard.X.Y == 0)|(X < 0)|(X > 7)|(Y < 0)|(Y > 7)) then return 0
		
	if (ChessBoard.X.Y > 0) then do
		pi = 1
		do while (pi < 17)
			if ((PiecePosX.1.pi == X)&(PiecePosY.1.pi == Y)) then do
				return pi
				end
			pi = pi + 1
			end
		end
	else do
		pi = 1
		do while (pi < 17)
			if ((PiecePosX.2.pi == X)&(PiecePosY.2.pi == Y)) then do
				return -pi
				end
			pi = pi + 1
			end
		end
	return 0


/* --------------------------------------------------------------- */
/* procedure InternalMove   					   */
/*								   */
/* Updates all necessary piece movement vars in memory only 	   */
/*								   */
/* --------------------------------------------------------------- */
InternalMove: procedure expose ChessBoard. piece. PiecePosX. PiecePosY.
	parse arg XFrom, YFrom, XTo, YTo

	if (UpdatePiecePos(XFrom, YFrom, XTo, YTo) == 0) then do
		EasyRequest Chess_Error "997:UPP_failed" Okay
		return 0
		end	
	ChessBoard.XTo.YTo = ChessBoard.XFrom.YFrom
	ChessBoard.XFrom.YFrom = Piece.BLANK
	return 1



/* --------------------------------------------------------------- */
/* procedure CastleOkay   					   */
/*								   */
/* returns 1 if the castling move is okay, else zero  	   	   */
/*								   */
/* --------------------------------------------------------------- */
CastleOkay: procedure expose ChessBoard. piece. PiecePosX. PiecePosY. GlobData.
	parse arg XFrom, YFrom, XTo, YTo

	GlobData.moverr = "Can't castle from there"

	/* Only can castle from King's starting position */
	if (XFrom != 3) then do
		GlobData.moverr = "Can't castle after king has moved"
		return 0
		end
		
	if (YFrom != YTo) then return 0
		
	/* First thing: determine what side we're on */
	if (ChessBoard.XFrom.YFrom < 0) then do
		SideToCheck = 2
		if (YFrom != 7) then return 0
		end
	else do
		SideToCheck = 1
		if (YFrom != 0) then return 0
		end
		
	/* can't castle if king has already moved */
	if (ChessBoard.KingMoved.SideToCheck == 1) then do
		GlobData.moverr = "Can't castle after king has moved"
		return 0
		end
	
	LeftOrRight = 0			/* Default = error */
	if (XTo == 0) then do
		LeftOrRight = 1		/* Left */
		NewRookX = 2
		NewKingX = 1
		/* Can't castle if rook has moved */
		if (ChessBoard.LeftRookMoved.SideToCheck == 1) then do
			GlobData.moverr = "Can't castle after rook has moved"
			return 0
			end
		end
	if (XTo == 7) then do
		LeftOrRight = 2 	/* Right */
		NewRookX = 5
		NewKingX = 6
		/* Can't castle if rook has moved */
		if (ChessBoard.RightRookMoved.SideToCheck == 1) then do
			GlobData.moverr = "Can't castle after rook has moved"
			return 0
			end
		end		
	if (LeftOrRight == 0) then do
		GlobData.moverr = "You should never see this error"
		return 0	/* This should never happen */
		end	
	
	/* Make sure all spaces between king and rook are clear */
	if (GlideOK(XFrom,YFrom,XTo,YTo) == 0) then do
		GlobData.moverr = "There are pieces between king and rook"
		return 0
		end
		
	/* Can't castle out of check */
	if (IsInCheck(XFrom,YFrom) == 1) then do
		GlobData.moverr = "Can't castle out of check"
		return 0
		end
	
	/* Move rook to new position, in my head anyway */
	if (InternalMove(XTo, YTo, newRookX, YTo) == 0) then return 0
	
	/* Move king to new position, in my head anyway */
	if (InternalMove(XFrom, YFrom, newKingX, YFrom) == 0) then return 0

	/* See if this causes check */
	if (IsInCheck(newKingX,YFrom) == 1) then do
		/* oops, would be a move into check.  No can do! */
		/* So move everything back! */

		/* Move rook back to old position, in my head anyway */
		if (InternalMove(newRookX, YTo, XTo, YTo) == 0) then return 0
		
		/* Move king back to old position, in my head anyway */
		if (InternalMove(newKingX, YFrom, XFrom, YFrom) == 0) then return 0

		GlobData.moverr = "Can't castle into check"
		
		/* and fail */
		return 0
		end
		
	/* If we're here, then the castle is acceptable.  Put the king
	   back for now--it'll be moved by the normal turn--but we'll 
	   move the rook ourselves! */
	
	/* Move king back to old position, in my head anyway */
	if (InternalMove(newKingX, YFrom, XFrom, YFrom) == 0) then return 0
	
	/* Display and transmit the rook's move */
	
	/* Erase old rook */
	success = DrawPiece(XTo, YTo, ChessBoard.XTo.YTo, GlobData.BFlood)
	
	/* Draw new rook */
	success = DrawPiece(newRookX, YTo, ChessBoard.newRookX.YTo, GlobData.BFlood)
	
	/* Transmit move -- 2 means don't lose turn yet */
	szSendString = "2" || XTo || YTo || newRookX || YTo || "0"
    	sendmessage szSendString

	return 1
	

/* --------------------------------------------------------------- */
/* procedure CheckMove   					   */
/* --------------------------------------------------------------- */
CheckMove: procedure expose ChessBoard. piece. PiecePosX. PiecePosY. GlobData.
	parse arg XFrom, YFrom, XTo, YTo, BCheckForCheck
	
	/* A move off of the board is illegal */
	if ((XTo < 0)|(XTo > 7)|(YTo < 0)|(YTo > 7)) then do
		GlobData.moverr = "Can't move off of board"
		return 0
		end
		
	/* A move from off of the board is illegal */
	if ((XFrom < 0)|(XFrom > 7)|(YFrom < 0)|(YFrom > 7)) then do
		GlobData.moverr = "Can't move from off of board"
		return 0
		end
		
	/* Blanks can't move */
	if (ChessBoard.XFrom.YFrom == Piece.BLANK) then do
		GlobData.moverr = "Can't move a blank square"
		return 0
		end

	
	/* A move to the same spot we're on is illegal */
	if ((XFrom == XTo)&(YFrom == YTo)) then do
		GlobData.moverr = "Can't move onto yourself"
		return 0
		end

	/* A move onto one of your own pieces is illegal */
	if ((ChessBoard.XTo.YTo * ChessBoard.XFrom.YFrom) > 0) then do
		/* except when you're castling */
		if (((ChessBoard.XTo.YTo == Piece.Rook)&(ChessBoard.XFrom.YFrom == Piece.King))|((ChessBoard.XTo.YTo == -Piece.Rook)&(ChessBoard.XFrom.YFrom == -Piece.King))) then do
		     /* nothing right now, we'll check for castling later */
		     end 
		else do
		     GlobData.moverr = "Can't attack your own piece"
		     return 0
		     end
	end
	
	/* Rules for the PAWN */	
	if (abs(ChessBoard.XFrom.YFrom) == Piece.PAWN) then do
		GlobData.moverr = "Bad pawn move"
		if (ChessBoard.XFrom.YFrom < 0) then do
			PawnMoveDir = -1 
			end
			else PawnMoveDir = 1
		if ((XTo == XFrom)&(ChessBoard.XTo.YTo ~= Piece.BLANK)) then do
			GlobData.moverr = "Pawn can't attack forward"
		 	return 0
		 	end
		if ((XTo == XFrom)&(abs(YFrom - YTo) == 2)) then do
			/* First move for a pawn can be two spaces, if both spaces are blank */
			Ytemp = YFrom+PawnMoveDir
			if ((ChessBoard.XFrom.Ytemp) ~= Piece.BLANK) then return 0
			if ((YFrom == 1)&(PawnMoveDir ~= 1)) then return 0
			if ((YFrom == 6)&(PawnMoveDir ~= -1)) then return 0
			if ((YFrom ~= 1)&(YFrom ~= 6)) then return 0
			end
		else do
			if (YTo ~= (YFrom + PawnMoveDir)) then return 0
			if (abs(XFrom - XTo) > 1) then return 0
			if ((abs(XFrom - XTo) == 1)&(ChessBoard.XTo.YTo == Piece.BLANK)) then return 0	
			end
		end 
	
	/* Rules for the ROOK */
	if (abs(ChessBoard.XFrom.YFrom) == Piece.ROOK) then do
		if ((XFrom ~= XTo)&(YFrom ~= YTo)) then do
			GlobData.moverr = "Rook must move horizontally or vertically"
			return 0
			end
		if (GlideOK(XFrom,YFrom,XTo,YTo) == 0) then do
			GlobData.moverr = "Move is blocked"
			return 0
			end
		end
		
	/* Rules for the KNIGHT */
	if (abs(ChessBoard.XFrom.YFrom) == Piece.KNIGHT) then do
		GlobData.moverr = "Bad knight move"
		if (((abs(XFrom - XTo) ~= 2)|(abs(YFrom - YTo) ~= 1))&((abs(XFrom - XTo) ~= 1)|(abs(YFrom - YTo) ~= 2))) then return 0
		end
		
	/* Rules for the BISHOP */
	if (abs(ChessBoard.XFrom.YFrom) == Piece.BISHOP) then do
		if (abs(XFrom - XTo) ~= abs(YFrom - YTo)) then do
			GlobData.moverr = "Bishop must move diagonally"
			return 0
			end
		if (GlideOK(XFrom,YFrom,XTo,YTo) == 0) then do
			GlobData.moverr = "Move is blocked"
			return 0
			end
		end

	/* Rules for the QUEEN */
	if (abs(ChessBoard.XFrom.YFrom) == Piece.QUEEN) then do
		if ((abs(XFrom - XTo) ~= abs(YFrom - YTo))&((XFrom ~= XTo)&(YFrom ~= YTo))) then do
			GlobData.moverr = "Queen must move in a straight line"
			return 0
			end
		if (GlideOK(XFrom,YFrom,XTo,YTo) == 0) then do
			GlobData.moverr = "Move is blocked"
			return 0
			end
		end

	/* Rules for the KING */
	if (abs(ChessBoard.XFrom.YFrom) == Piece.KING) then do
		if (((ChessBoard.XTo.YTo == Piece.ROOK)&(ChessBoard.XFrom.YFrom == Piece.KING))|((ChessBoard.XTo.YTo == -Piece.ROOK)&(ChessBoard.XFrom.YFrom == -Piece.KING)))
		   then do
		    	if (CastleOkay(XFrom,YFrom,XTo,YTo) == 0) then return 0
		    	end
		   else do
			if ((abs(XTo - XFrom) > 1)|(abs(YTo - YFrom) > 1)) then do
				GlobData.moverr = "King can only move 1 square"
				return 0
				end
		   end
	end
	
	if (BCheckForCheck == 0) then return 1
	
	/* Get king's co-ordinates */
	if (Chessboard.XFrom.YFrom > 0) then do
		KingPosX = PiecePosX.1.1
		KingPosY = PiecePosY.1.1		
		end
	else do
		KingPosX = PiecePosX.2.1
		KingPosY = PiecePosY.2.1
		end

	/* If king is moving, check were he WILL be, not where he IS */
	if (abs(ChessBoard.XFrom.YFrom) == Piece.KING) then do
		KingPosX = XTo
		KingPosY = YTo
		end
		
	if (MoveCreatesCheck(XFrom, YFrom, XTo, YTo, KingPosX, KingPosY) == 1) then do
		if (abs(ChessBoard.XFrom.YFrom) == Piece.KING) then do
				GlobData.moverr = "Move would put you in check"
			end
			else do
				GlobData.moverr = "Move does not remove you from check"
			end
		return 0
		end
			
	/* If we passed all these tests, we're ok */		

	/* If it's a rook or a king, set the appropriate moved flag */
	if (ChessBoard.XFrom.YFrom == Piece.King) then ChessBoard.KingMoved.1 = 1
	if (ChessBoard.XFrom.YFrom == -Piece.King) then ChessBoard.KingMoved.2 = 1
	
	if (ChessBoard.XFrom.YFrom == Piece.Rook) then do
		if ((XFrom == 0)&(YFrom == 0)) then ChessBoard.LeftRookMoved.1 = 1
		if ((XFrom == 7)&(YFrom == 0)) then ChessBoard.RightRookMoved.1 = 1
		end
	if (ChessBoard.XFrom.YFrom == -Piece.Rook) then do
		if ((XFrom == 0)&(YFrom == 7)) then ChessBoard.LeftRookMoved.2 = 1
		if ((XFrom == 7)&(YFrom == 7)) then ChessBoard.RightRookMoved.2 = 1
		end
					
	return 1
	
	
	
/* --------------------------------------------------------------- */
/* procedure GlideOK   						   */
/* --------------------------------------------------------------- */
GlideOK:	procedure expose ChessBoard. piece.
	parse arg XFrom, YFrom, XTo, YTo
	
	xd = 0
	yd = 0
		
	if ((XTo - XFrom) > 0) then xd = 1
	if ((XTo - XFrom) < 0) then xd = -1
	if ((YTo - YFrom) > 0) then yd = 1
	if ((YTo - YFrom) < 0) then yd = -1

	x = XFrom + xd	/* Start scanning after where piece already is */
	y = YFrom + yd
	
	xgoal = XTo 
	ygoal = YTo 
	
	do while ((x ~= xgoal)|(y ~= ygoal))
		if (ChessBoard.x.y ~= Piece.BLANK) then return 0
		if ((x<0)|(y<0)|(x>7)|(y>7)) then do
			EasyRequest Chess_Error "Glide_error!" Okay
			return 0
			end
		x = x + xd
		y = y + yd
		end
		
	return 1
	

/* --------------------------------------------------------------- */
/* procedure IsInCheck						   */
/* 								   */
/* returns 1 if the given square is in danger, otherwise 0         */
/* --------------------------------------------------------------- */
IsInCheck: procedure expose ChessBoard. PiecePosX. PiecePosY. piece.
	parse arg X, Y
		
	
	if (ChessBoard.X.Y == 0) then do
		EasyRequest Chess_Error "IsInCheck_:_Square_is_empty!" Okay
		return 0
		end
		
	if (ChessBoard.X.Y > 0) then SideToCheck = 2
	if (ChessBoard.X.Y < 0) then SideToCheck = 1
	
	pi = 1
	do while (pi < 17)
		if (CheckMove(PiecePosX.SideToCheck.pi,PiecePosY.SideToCheck.pi,X,Y,0) == 1) then return 1
		pi = pi + 1
	end
	return 0



/* --------------------------------------------------------------- */
/* procedure 							   */
/* --------------------------------------------------------------- */
InitChessArray: procedure expose ChessBoard. piece. PiecePosX. PiecePosY.

   /* Set special castling info for both sides */
   ChessBoard.KingMoved.1 = 0
   ChessBoard.KingMoved.2 = 0
   ChessBoard.LeftRookMoved.1  = 0
   ChessBoard.RightRookMoved.1 = 0
   ChessBoard.LeftRookMoved.2  = 0
   ChessBoard.RightRookMoved.2 = 0
   
   /* Set Kings */
   ChessBoard.3.0 = Piece.KING
   ChessBoard.3.7 = -Piece.KING

   /* Set king position markers */
   PiecePosX.1.1 = 3
   PiecePosY.1.1 = 0
   PiecePosX.2.1 = 3
   PiecePosY.2.1 = 7

   /* Set Queens */
   ChessBoard.4.0 = Piece.QUEEN
   ChessBoard.4.7 = -Piece.QUEEN

   /* Set queen position markers */
   PiecePosX.1.2 = 4
   PiecePosY.1.2 = 0
   PiecePosX.2.2 = 4
   PiecePosY.2.2 = 7

   /* Set rooks */
   ChessBoard.0.0 = Piece.ROOK
   ChessBoard.7.0 = Piece.ROOK
   ChessBoard.0.7 = -Piece.ROOK
   ChessBoard.7.7 = -Piece.ROOK

   /* Set rook position markers */
   PiecePosX.1.3 = 0
   PiecePosY.1.3 = 0
   PiecePosX.1.4 = 7
   PiecePosY.1.4 = 0
   
   PiecePosX.2.3 = 0
   PiecePosY.2.3 = 7
   PiecePosX.2.4 = 7
   PiecePosY.2.4 = 7
   
   /* Set knights */
   ChessBoard.1.0 = Piece.KNIGHT
   ChessBoard.6.0 = Piece.KNIGHT
   ChessBoard.1.7 = -Piece.KNIGHT
   ChessBoard.6.7 = -Piece.KNIGHT

   /* Set knight position markers */
   PiecePosX.1.5 = 1
   PiecePosY.1.5 = 0
   PiecePosX.1.6 = 6
   PiecePosY.1.6 = 0
   
   PiecePosX.2.5 = 1
   PiecePosY.2.5 = 7
   PiecePosX.2.6 = 6
   PiecePosY.2.6 = 7

   /* Set bishops */
   ChessBoard.2.0 = Piece.BISHOP
   ChessBoard.5.0 = Piece.BISHOP
   ChessBoard.2.7 = -Piece.BISHOP
   ChessBoard.5.7 = -Piece.BISHOP

   /* Set bishop position markers */
   PiecePosX.1.7 = 2
   PiecePosY.1.7 = 0
   PiecePosX.1.8 = 5
   PiecePosY.1.8 = 0
   
   PiecePosX.2.7 = 2
   PiecePosY.2.7 = 7
   PiecePosX.2.8 = 5
   PiecePosY.2.8 = 7   

   /* Set rows of pawns */
   jx = 0
   do while (jx < 8)
   	ChessBoard.jx.1 = Piece.PAWN
   	ppTemp = jx + 9
   	PiecePosX.1.ppTemp = jx
   	PiecePosY.1.ppTemp = 1
	jx = jx + 1
   	end
   
   jx = 0
   do while (jx < 8)
    ChessBoard.jx.6 = -1		/* - means bottom team */
   	ppTemp = jx + 9
   	PiecePosX.2.ppTemp = jx
   	PiecePosY.2.ppTemp = 6
	jx = jx + 1
    end
  
   /* Center of board is all blanks */
   jy = 2
   do while (jy < 6)
	jx = 0
	do while (jx < 8)
		ChessBoard.jx.jy = Piece.BLANK
		jx = jx + 1
	end
	jy = jy + 1
   end

   return 1



/* --------------------------------------------------------------- */
/* procedure DrawChessBoard					   */
/* --------------------------------------------------------------- */
DrawChessBoard: procedure expose ChessBoard. GlobData. piece.

   /* Say what we're doing */
   SetWindowTitle '"'||"Drawing Chess Board, Please Wait"||'"'
   SetRemoteWindowTitle '"'||"Drawing Chess Board, Please Wait"||'"'

   /* Examine window to get dimensions */
   GetWindowAttrs stem winattrs.
   GlobData.BoardWidth = winattrs.width  - 58
   GlobData.BoardHeight= winattrs.height - 53 - GlobData.ToolBarHeight
   if (winattrs.depth < 2) then do
	EasyRequest Chess_Error '"'||"You need at least a 4-color screen to play chess!"||'"' '"'||"Abort Chess"||'"'
	SetWindowTitle '"'||"Chess game exited."||'"'
	exit 0
	end 
   if (winattrs.depth = 2) then GlobData.SQUAREPEN2 = 0		/* keep it within our palette range! */

   /* Clear Screen */
   clear
   jy = 0
   do while (jy < 8)
    jx = 0
	do while (jx < 8)
		success = DrawPiece(jx, jy, ChessBoard.jx.jy, GlobData.BFlood)
		jx = jx + 1
	end
	jy = jy + 1
   end

   return 1
	
/* --------------------------------------------------------------- */
/* procedure SquareColor					   					   */
/*								   								   */
/* Given the X,Y co-ordinates (0-7,0-7) of a chess square, return  */
/* its pen color.						     					   */
/* --------------------------------------------------------------- */
SquareColor: procedure expose GlobData.
	parse arg XX, YY

if ((XX+ YY)/2) = trunc((XX + YY)/2) then
    return GlobData.SQUAREPEN1
else
    return GlobData.SQUAREPEN2 


/* --------------------------------------------------------------- */
/* procedure SelectChessSquare					   */
/* --------------------------------------------------------------- */
SelectChessSquare: procedure expose GlobData.
	parse arg ChessSquareSelectX, ChessSquareSelectY, PenToSelectWith

   xleft   = trunc(GlobData.BoardWidth / 8) * ChessSquareSelectX
   ytop    = (trunc(GlobData.BoardHeight / 8) * ChessSquareSelectY) + GlobData.ToolBarHeight
   xright  = xleft + trunc(GlobData.BoardWidth / 8)
   ybottom = ytop + trunc(GlobData.BoardHeight / 8)

   setfpen PenToSelectWith
   square xleft ytop (xright-1) (ybottom-1)
   return 1


/* --------------------------------------------------------------- */
/* procedure ParseMove						   */
/* --------------------------------------------------------------- */
ParseMove: procedure expose ChessBoard. piece. PiecePosX. PiecePosY. GlobData.
	parse arg MoveString
	
   /* parses a move of the form MABCD0 , where 
   	M = checkcode, A = X1, B = Y1, C = X2, D = Y2.  No checking needs to
   	be done on the move, as that will all have been done before allowing
   	it to be sent */   
	
   leftpart = left(MoveString,3)
   rightpart = right(MoveString,3)

   checkcode = left(leftpart,1)
   promcode = right(rightpart,1)

   /* Special case:  If the message is of the form *****N, then N is
      the new value for BFlood */
   if (checkcode == '*') then do
   	GlobData.BFlood = promcode
   	return 2	/* means stick around for another move */
   	end
   	
   /* If its my turn, then he don't get to move! */
   if (GlobData.turn == GlobData.BActive) then return 0

   leftpart = right(leftpart,2)
   rightpart = left(rightpart,2)
   
   mx1 = left(leftpart,1)
   my1 = right(leftpart,1)
   mx2 = left(rightpart,1)
   my2 = right(rightpart,1)
   
   if (UpdatePiecePos(mx1, my1, mx2, my2) == 0) then do
   	EasyRequeset Chess_Error "555:_UPP_failed" Okay
   	return 0
   	end	

   /* Was there a death here?  If so, remove dying piece */
   if (ChessBoard.mx2.my2 ~= Piece.BLANK) then do
   	VictimPiece = GetPiecePos(mx2, my2)
	if (VictimPiece > 0) then do
		PiecePosX.1.VictimPiece = 9999
		PiecePosY.1.VictimPiece = 9999
		end
	else do
		VictimPiece = abs(VictimPiece)
		PiecePosX.2.VictimPiece = 9999
		PiecePosY.2.VictimPiece = 9999
		end
	end
	
   /* See if there was a pawn promotion on this move */
   if (promcode > 1) then do
   	/* Get side code */
	if (ChessBoard.mx1.my1 > 0) then do
		tSide = 1
		end
	else do
		tSide = -1
		end
   	if (promcode == 2) then ChessBoard.mx1.my1 = Piece.KNIGHT * tSide
   	if (promcode == 3) then ChessBoard.mx1.my1 = Piece.QUEEN  * tSide
   	if (promcode == 4) then ChessBoard.mx1.my1 = Piece.ROOK   * tSide
   	if (promcode == 5) then ChessBoard.mx1.my1 = Piece.BISHOP * tSide
   	say "promotion to "promcode
   	end
   	
   ChessBoard.mx2.my2 = ChessBoard.mx1.my1  /* Then put the piece in the new spot! */
   ChessBoard.mx1.my1 = Piece.BLANK
   
   return checkcode
   



/* --------------------------------------------------------------- */
/* procedure UpdateStatus                      					   */
/* --------------------------------------------------------------- */
UpdateStatus: procedure expose GlobData. ACTIVE PASSIVE
	
    /* Say whose turn it is */
    if (GlobData.turn ~= GlobData.BActive) then LocalOrRemote = "It's Their turn" 
    if ((GlobData.BConnectMode == 0)|(GlobData.turn == GlobData.BActive)) then LocalOrRemote = "It's Your turn"

    if (GlobData.turn == ACTIVE) then do
        LocalOrRemote = '"' || LocalOrRemote || " (White)" || '"'
        end
        else do
        LocalOrRemote = '"' || LocalOrRemote || " (Black)" || '"'
        end
        	
    SetWindowTitle LocalOrRemote
    return 1
    


/* --------------------------------------------------------------- */
/* procedure DrawPiece   										   */
/* --------------------------------------------------------------- */
DrawPiece: procedure expose GlobData. piece.
	parse arg X, Y, PieceCode, BFlood
	
	/* Decode PieceCode */
	PieceColor = GlobData.SIDE1PEN
	
	if (PieceCode < 0) then do
		PieceCode = abs(PieceCode)
		PieceColor = GlobData.SIDE2PEN
		end
	
	/* Get co-ords of our square */
	xleft   = trunc(GlobData.BoardWidth / 8) * X
	ytop    = (trunc(GlobData.BoardHeight / 8) * Y) + GlobData.ToolBarHeight
	xd      = trunc(GlobData.BoardWidth / 8) - 1
	yd      = trunc(GlobData.BoardHeight/ 8) - 1
	xright  = xleft + xd
	ybottom = ytop + yd
	xcenter = (xleft + trunc(xd/2)) 
	ycenter = (ytop + trunc(yd/2)) 
	
	/* First thing we need to do is erase the square */
	sqc = SquareColor(X, Y)
	setfpen sqc
	square xleft ytop xright ybottom fill

	/* If we're doing a filled mode draw, then outline in the other team's color */
	if (BFlood > 0) then do
        	if (PieceColor == GlobData.SIDE1PEN) then do
        	    OutlineColor = GlobData.SIDE2PEN
        	    end 
        	else do
        	    OutlineColor = GlobData.SIDE1PEN
        	    end
        	end
        	else do
        	    OutlineColor = PieceColor
        	end             

	/* Set color to appropriate side */
	setfpen OutlineColor
    	
	if (PieceCode == piece.PAWN) then do
		penreset
		pen (xleft+trunc(xd*.56))  (ytop+trunc(yd*.47))
		pen (xleft+trunc(xd*.6))   (ytop+trunc(yd*.8)) 
		pen (xleft+trunc(xd*.65))  (ytop+trunc(yd*.9)) 
		pen (xleft+trunc(xd*.35))  (ytop+trunc(yd*.9)) 
		pen (xleft+trunc(xd*.4))   (ytop+trunc(yd*.8)) 
		pen (xleft+trunc(xd*.44))  (ytop+trunc(yd*.47))
		if BFlood > 0 then do
	        	setfpen PieceColor
			    circle (xleft+trunc(xd*.5)) (ytop+trunc(yd*.38)) (trunc(xd*.16)) (trunc(yd*.16)) fill
	            	setfpen OutlineColor
	            	end
		circle (xleft+trunc(xd*.5)) (ytop+trunc(yd*.38)) (trunc(xd*.16)) (trunc(yd*.16))

	        if BFlood > 0 then do
        	    setfpen PieceColor
            	    flood xcenter (ytop + trunc(yd * .8))
            	    end
	end
	else if (PieceCode == piece.ROOK) then do
		penreset
		pen (xleft+trunc(xd*.3))   (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.4))   (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.4))   (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.45))  (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.45))  (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.55))  (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.55))  (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.6))   (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.6))   (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.7))   (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.7))   (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.6))   (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.6))   (ytop+trunc(yd*.7))
		pen (xleft+trunc(xd*.75))  (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.25))  (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.4))   (ytop+trunc(yd*.7))
		pen (xleft+trunc(xd*.4))   (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.3))   (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.3))   (ytop+trunc(yd*.2))
    		setfpen PieceColor
		if BFlood > 0 then flood (xleft+trunc(xd*.5)) (ytop + trunc(yd*.5))
	end 
	else if (PieceCode == piece.KNIGHT) then do
		penreset 
		pen (xleft+trunc(xd*.3))  (ytop+trunc(yd*.2))
	        pen (xleft+trunc(xd*.3))  (ytop+trunc(yd*.10))
	        pen (xleft+trunc(xd*.33)) (ytop+trunc(yd*.19))
		pen (xleft+trunc(xd*.6))  (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.7))  (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.65)) (ytop+trunc(yd*.45))
		pen (xleft+trunc(xd*.5))  (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.5))  (ytop+trunc(yd*.5))
		pen (xleft+trunc(xd*.6))  (ytop+trunc(yd*.6))
		pen (xleft+trunc(xd*.75)) (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.25)) (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.3))  (ytop+trunc(yd*.8))
		pen (xleft+trunc(xd*.3))  (ytop+trunc(yd*.7))
		pen (xleft+trunc(xd*.2))  (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.3))  (ytop+trunc(yd*.2))
	    	setfpen PieceColor
		if BFlood > 0 then flood (xleft+trunc(xd*.5)) (ytop+trunc(yd*.75))
		setfpen OutlineColor
		circle (xleft+trunc(xd*.55)) (ytop+trunc(yd*.3)) trunc(xd/20) trunc(yd/20) fill
	end
	else if (PieceCode == piece.BISHOP) then do
		penreset
		pen (xleft+trunc(xd*.48))  (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.4))   (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.45))  (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.35))  (ytop+trunc(yd*.7))
		pen (xleft+trunc(xd*.35))  (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.65))  (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.65))  (ytop+trunc(yd*.7))
		pen (xleft+trunc(xd*.55))  (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.6))   (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.52))  (ytop+trunc(yd*.2))
		if BFlood > 0 then do
        	setfpen PieceColor
			circle (xleft+trunc(xd*.5)) (ytop+trunc(yd*.2)) trunc(xd*.08) trunc(yd*.08) fill
			setfpen OutlineColor
			end
		circle (xleft+trunc(xd*.5)) (ytop+trunc(yd*.2)) trunc(xd*.08) trunc(yd*.08)
	        if BFlood > 0 then do
        	    setfpen PieceColor
   		    flood (xleft+trunc(xd*.5)) (ytop+trunc(yd*.8))
	            end
	end
	else if (PieceCode == piece.QUEEN) then do
		penreset
		pen (xleft+trunc(xd*.4)) (ytop+trunc(yd*.1))
		pen (xleft+trunc(xd*.6)) (ytop+trunc(yd*.1))
		pen (xleft+trunc(xd*.7)) (ytop+trunc(yd*.15))
		pen (xleft+trunc(xd*.6)) (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.6)) (ytop+trunc(yd*.7))
		pen (xleft+trunc(xd*.8)) (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.2)) (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.4)) (ytop+trunc(yd*.7))
		pen (xleft+trunc(xd*.4)) (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.3)) (ytop+trunc(yd*.15))
		pen (xleft+trunc(xd*.4)) (ytop+trunc(yd*.1))
	    	setfpen PieceColor
		if BFlood > 0 then flood (xleft+trunc(xd*.5)) (ytop + trunc(yd*.75))
	end
	else if (PieceCode == piece.KING) then do
		penreset
		pen (xleft+trunc(xd*.47)) (ytop+trunc(yd*.1))
		pen (xleft+trunc(xd*.53)) (ytop+trunc(yd*.1))
		pen (xleft+trunc(xd*.53)) (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.57)) (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.57)) (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.53)) (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.53)) (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.6))  (ytop+trunc(yd*.5))
		pen (xleft+trunc(xd*.55)) (ytop+trunc(yd*.6))
		pen (xleft+trunc(xd*.6))  (ytop+trunc(yd*.8))
		pen (xleft+trunc(xd*.7))  (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.3))  (ytop+trunc(yd*.9))
		pen (xleft+trunc(xd*.4))  (ytop+trunc(yd*.8))
		pen (xleft+trunc(xd*.45)) (ytop+trunc(yd*.6))
		pen (xleft+trunc(xd*.4))  (ytop+trunc(yd*.5))
		pen (xleft+trunc(xd*.47)) (ytop+trunc(yd*.4))
		pen (xleft+trunc(xd*.47)) (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.43)) (ytop+trunc(yd*.3))
		pen (xleft+trunc(xd*.43)) (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.47)) (ytop+trunc(yd*.2))
		pen (xleft+trunc(xd*.47)) (ytop+trunc(yd*.1))
    		setfpen PieceColor
		if BFlood > 0 then flood (xleft+trunc(xd*.5)) (ytop+trunc(yd*.7))
	end
	return 1