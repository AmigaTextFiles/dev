/* Backgammon for AmiSlate v1.1! */
/* This program should be run on a screen with at least 8 colors */

/* v1.1 : fixed a glitch that would sometimes leave a little garbage on
          the screen after a spike redraw. */
          
/* Get our host's name--always given as first argument when run from Amislate */
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx backgammon.rexx <REXXPORTNAME>"
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
	RemoteRexxCommand '"'||"Would you like to play backgammon?"||'"' "slaterexx:backgammon.rexx"
	
        waitevent stem handshake. MESSAGE
        if (handshake.message == 0) then 
        do
            call SetStatus("Backgammon Game Refused")
            lock off
            exit 0
        end
    end

call SetStatus("Beginning Backgammon...")

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
        GlobData.slots.[slotnum]         : array of slotstates (0..23) (int, > 0 = Pl1 pieces, < 0 = Pl-1 pieces)
					 : note: slot -1 is player 1's "out" pile, and slot 24 is player -1's "out" pile.
	GlobData.die.[dienum]            : the current number on each of the four die.  Usually only 0 & 1 are used,			

	(game state)
	GlobData.turn			 : whose turn it is
	GlobData.exited.[playernum]      : number of pieces that have been taken off the board for player [playernum]
	GlobData.localplayer 	         : which player is on local machine; 0 if both are
 	(color info)
	GlobData.PieceColor.[playernum]  : color of pieces for this player
	GlobData.SpikeColor.[playernum]  : spike color, alternates

*/

/* --------------------------------------------------------------- */
/* procedure HandleEvents 					   */
/* --------------------------------------------------------------- */
HandleEvents: procedure expose GlobData. AMessage.

SetSquare = -10
BReversed = 0
BNeedsToRoll = 1
BMustForfeit = 0

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

/* Turn on help */
BHelp = 1

do while(1)
    waitevent stem event. RESIZE MOUSEDOWN MOUSEUP TOOLSELECT MESSAGE DISCONNECT

    if (event.type == AMessage.QUIT) then exit 0
    
    if (event.type == AMessage.DISCONNECT) then do
    	call SetStatus("Connection broken--both players now local.")
    	GlobData.localplayer = 0
    	end
   
    if (event.type == AMessage.MESSAGE) then do
    	/* parse the message */
    	if (left(event.message,1) = "G") then do
    		/* It's our move! */
		BNeedsToRoll = 1
		BMustForfeit = 0
		call NextTurn
		end
	else do
		parse var event.message rfrom rto
		call MovePiece((rfrom+0), (rto+0), 0)  /* update our internals--the (+0) forces the vars back into numeric format */
		end
	end

    if (event.type == AMessage.RESIZE) then do
		if ((GlobData.localplayer == GlobData.turn)|(GlobData.localplayer == 0)) then do
			call SetGlobalData
			call DrawBoard
			if (BMustForfeit == 1) then call ShowCantMove
		end
		else do
			/* else just update our internal vars */
			call SetGlobalData
		end
		/* call UpdateStatus */
	end
    
    if ((event.type == AMessage.MOUSEDOWN)&((GlobData.turn = GlobData.localplayer)|(GlobData.localplayer == 0))) then do
    	whatclicked = ParseMouseClick(event.x, event.y)
	if (SetSquare == -10) then do
		if (whatclicked == 25) then 
			if (BNeedsToRoll == 1) then do
				call Roll
				BNeedsToRoll = 0
				/* Check to see if we can move */
				can = CanMove()
				if (can == 0) then do
					call ShowCantMove
					BMustForfeit = 1
					end
				end
			else do
				if (BMustForfeit == 1) then do
					/* Cancels rest of turn! */
					BNeedsToRoll = 1
					BMustForfeit = 0
					if (localplayer ~= 0) then sendmessage G
					call NextTurn
					end
				end
		else 
		/* Nothing was clicked before, mark this square? */
		if ((BMustForfeit = 0)&(BNeedsToRoll = 0)&(whatclicked < 25)&((GlobData.slots.whatclicked * GlobData.turn) > 0)) then do
			if (PieceCanMove(whatclicked) == 1) then do
				call HiliteTopPiece(whatclicked)
				if (BHelp == 1) then call ShowMoves(whatclicked)
				BReversed = ~BReversed
				SetSquare = whatclicked
				end
				else DisplayBeep LOCAL
			end
		end
	else do
		/* Already had one clicked, now either cancel it or move? */
		if (whatclicked == SetSquare) then do
			/* cancel the piece-move! */
			if (BReversed == 1) then call HiliteTopPiece(whatclicked)
			if (BHelp == 1) then call ClearArrows
			BReversed = 0
			SetSquare = -10
			end
		else do
			dietouse = MoveOkay(SetSquare, whatclicked,1) 
			if (dietouse > -1) then do
				if (BHelp == 1) then call ClearArrows
				call MovePiece(SetSquare, whatclicked, 1)
				BReversed = 0
				SetSquare = -10
				GlobData.die.dietouse = 0
				call DrawDie(dietouse)
				if ((GlobData.die.0 == 0)&(GlobData.die.1 == 0)&(GlobData.die.2 == 0)&(GlobData.die.3 == 0)) then do
					BNeedsToRoll = 1
					BMustForfeit = 0
					if (localplayer ~= 0) then sendmessage G
					call NextTurn
					end
				else do
					/* Check to see if we can still move */
					can = CanMove()
					if (can == 0) then do
						call ShowCantMove
						BMustForfeit = 1
						end
					end
				end
				else DisplayBeep LOCAL
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
	GlobData.Turn = -GlobData.Turn
	do i = 0 to 3 
		GlobData.die.i = 0
		end

	/* local game code */
	if (Globdata.localplayer == 0) then do
		call DrawCup(0)
		if (GlobData.turn == 1) then 
			call SetStatus("Player 1, it's your turn to roll.")
		else
			call SetStatus("Player 2, it's your turn to roll.")
		return 1
		end
	
	/* two machine game code */
	if (GlobData.turn == GlobData.localplayer) then do
		call DrawCup(0)
		if (GlobData.turn == 1) then 
			call SetStatus("Player 1, it's your turn to roll.")
		else
			call SetStatus("Player 2, it's your turn to roll.")
		end
	else do
		call SetStatus("Wait for other player to move.")
		end
	return 1
	
		

/* --------------------------------------------------------------- */
/* procedure Roll						   */
/* 								   */
/* --------------------------------------------------------------- */
Roll: procedure expose GlobData.

	/* First clear the die area */
	cturn = GlobData.turn
	SetFPen GlobData.PieceColor.cturn
	square GlobData.XSpace.7+1 GlobData.YSpace.6+1 GlobData.XSpace.9-1 GlobData.YSpace.10-1 FILL

	GlobData.die.0 = random(1,6,time('s'))
	GlobData.die.1 = random(1,6,time('s')+500)
	
	call DrawDie(0)
	call DrawDie(1)
	
	if (GlobData.die.0 == GlobData.die.1) then do
		call SetStatus("You rolled a double!")

		GlobData.die.2 = GlobData.die.1
		GlobData.die.3 = GlobData.die.1
	
		call DrawDie(2)
		call DrawDie(3)	
		end
	else do
		if (GlobData.turn == 1) then 
			call SetStatus("Player 1, move your pieces")
		else
			call SetStatus("Player 2, move your pieces")
		end
	return 1		

	

/* --------------------------------------------------------------- */
/* procedure MovePiece						   */
/* 								   */
/* --------------------------------------------------------------- */
MovePiece: procedure expose GlobData.
	parse arg from, to, showgfx
		
	origfrom = GlobData.slots.from
	negone = -1
	
	/* If it's a two machine game, tell the other machine what we're doing */
	if ((showgfx == 1)&(GlobData.localplayer ~= 0)) then call TransmitMove(from, to)
	
	/* First remove the piece from the old spike and redraw it */
	call RemovePiece(from, GlobData.turn, showgfx)

	/* If the piece is moving "off the board", count it up */
	if (to == 24) then do
		/* Piece exited the board for player 1 */
		GlobData.exited.1 = (GlobData.exited.1) + 1
		call CheckForWin
		return 1
		end
	else if (to == -1) then do
		/* Piece exited the board for player 1 */
		GlobData.exited.negone = (GlobData.exited.negone) + 1
		call CheckForWin
		return 1
		end		

	/* Now add/replace our piece to the to spike */
	if ((origfrom * GlobData.slots.to) < 0) then do
		/* a piece got killed! */
		call SetStatus("Bump!  Ahahahahaha!!!!")
		if (GlobData.localplayer ~= 0) then DisplayBeep REMOTE
		if (GlobData.slots.to < 0) then 
			call AddPiece(24, -1, showgfx)
		else 
			call AddPiece(-1, 1, showgfx)
			
		GlobData.slots.to = 0
		end

	call AddPiece(to, GlobData.turn, showgfx)
	return 1



/* --------------------------------------------------------------- */
/* procedure RemovePiece					   */
/* --------------------------------------------------------------- */
RemovePiece: procedure expose GlobData.	
	parse arg from, which, showgfx
	
	GlobData.slots.from = GlobData.slots.from - which	
	if (showgfx == 1) then call DrawSpike(from)
	return 1
	
	
/* --------------------------------------------------------------- */
/* procedure AddPiece						   */
/* --------------------------------------------------------------- */
AddPiece: procedure expose GlobData.
	parse arg to, which, showgfx
	
	GlobData.slots.to = GlobData.slots.to + which
	if (showgfx == 1) then call DrawPiece(to, GlobData.PieceColor.which, abs(GlobData.slots.to), 0)
	return 1
	

/* --------------------------------------------------------------- */
/* procedure MoveOkay						   */
/* 								   */
/* returns the index of the die to use if the move is acceptable,  */
/* or -1 if it is illegal. 					   */
/* 								   */
/* --------------------------------------------------------------- */
MoveOkay: procedure expose GlobData.
	parse arg from, to, CountExits

	negone = -1
	numsquares = abs(to-from)
		
	/* Side specific rules! */
	if (GlobData.slots.from < 0) then do
		/* no moving backwards */
		if (to > from) then return -1

		/* no moving anyone else if we have a guy "out" */
		if ((GlobData.slots.24 ~= 0)&(from ~= 24)) then return -1

		/* No moves into the "out" unless all of our pieces are (exited or in the last quad) */
		/* Also, we can't exit on a roll larger than necessary *unless* there is no other use for that roll. */
		if (to <= -1) then do
			disttoexit = from + 1

			/* If we're not checking for exits, return failure now */
			if (CountExits == 0) then do
				/* Still need to watch for an exact out! */
				do checkdie = 0 to 3 
					if (GlobData.die.checkdie == disttoexit) then 
						if (CanMoveOut(1) == 1) then return checkdie
					end				
				return -1
				end				
			
			/* Otherwise check to see if we can move out */
			if (CanMoveOut(-1) == 0) then return -1
			else do
				do checkdie = 0 to 3 
					if (GlobData.die.checkdie == disttoexit) then return checkdie
					end
				do checkdie = 0 to 3
					if (GlobData.die.checkdie > disttoexit) then do
						if (CanExitOnExtra(GlobData.die.checkdie) == 1) then return checkdie
						end
					end
				/* default: can't move out */
				return -1
				end
			end
		end
	else do
		/* no moving backwards */
		if (to < from) then return -1

		/* no moving anyone else if we have a guy "out" */
		if ((GlobData.slots.negone ~= 0)&(from ~= -1)) then return -1

		/* No moves into the "out" unless all of our pieces are (exited or in the last quad) */
		if (to >= 24) then do
			disttoexit = 24 - from

			/* If we're not checking for exits, return failure now */
			if (CountExits == 0) then do
				/* Still need to watch for an exact out! */
				do checkdie = 0 to 3 
					if (GlobData.die.checkdie == disttoexit) then 
						if (CanMoveOut(1) == 1) then return checkdie
					end				
				return -1
				end
				
			/* Otherwise check to see if we can move out */
			if (CanMoveOut(1) == 0) then 
				return -1 
			else do
				do checkdie = 0 to 3
					if (GlobData.die.checkdie == disttoexit) then return checkdie
					end
				do checkdie = 0 to 3
					if (GlobData.die.checkdie > disttoexit) then do
						if (CanExitOnExtra(GlobData.die.checkdie) == 1) then return checkdie
						end
					end
				/* default: can't move out */
				return -1
				end
			end
		end
	
	/* first get this into absolute numbers */
	if (GlobData.slots.from < 0) then do
		fromsq = -(GlobData.slots.from)
		tosq   = -(GlobData.slots.to)
		end
	else do
		fromsq = GlobData.slots.from
		tosq   = GlobData.slots.to
		end
	
	/* At this point: fromsq > 0 */
	if (tosq < -1) then return -1
	
	/* Make sure this move is available on one of the die */
	diefound = -1
	do i = 0 to 3
		if (GlobData.die.i == numsquares) then diefound = i
		end
	
	return diefound
	
	
	

/* --------------------------------------------------------------- */
/* procedure HiliteTopPiece					   */
/* --------------------------------------------------------------- */
HiliteTopPiece: procedure expose GlobData.
	parse arg spikenum

	cturn = GlobData.turn
	
	call DrawPiece(spikenum, GlobData.PieceColor.cturn, abs(GlobData.slots.spikenum), 1)
	return 1



/* --------------------------------------------------------------- */
/* procedure ParseMouseClick 					   */
/*								   */
/* returns (-1)-(24) if a stack was clicked, or 25 if the center   */
/* dice/cup area was clicked 					   */
/*								   */
/* --------------------------------------------------------------- */
ParseMouseClick: procedure expose GlobData.
	parse arg xp, yp
	
	/* figure out vertical zone */
	yZone = 1	/* default */
	if (yp < GlobData.YSpace.6) then yZone = 0
	if (yp > GlobData.YSpace.10) then yZone = 2
	
	/* figure out horizontal zone */
	xZone = 1	/* default */
	if (xp < GlobData.XSpace.7) then xZone = 0
	if (xp > GlobData.XSpace.9) then xZone = 2
	
	/* are we in the dice/cup zone? */
	if (xZone == 1) then do
	   if (yZone == 0) then return -1
	   if (yZone == 1) then return 25
	   return 24
	   end
	else do
	   /* force into yzone 0 or 2 */
	   if (yp < GlobData.YSpace.8) then 
	   	yzone = 0 
	   else 
	   	yzone = 2
	   end
	   
	/* Must be a regular stack--get the horizontal offset */	
	if (xZone == 0) then offset = (xp-(GlobData.XSize/2)) / GlobData.XSize	     
	if (xZone == 2) then offset = ((xp-GlobData.XSpace.9-(GlobData.XSize/2)) / GlobData.XSize)
	
	offset = trunc(offset)	
	if (offset < 0) then offset = 0
	if (offset > 5) then offset = 5

	if ((xZone = 0)&(yZone = 0)) then return 11-offset
	if ((xZone = 2)&(yZone = 0)) then return 5-offset
	if ((xZone = 0)&(yZone = 2)) then return 12+offset
	if ((xZone = 2)&(yZone = 2)) then return 18+offset
	return -55


/* --------------------------------------------------------------- */
/* procedure ResetGameState					   */
/* --------------------------------------------------------------- */
ResetGameState: procedure expose GlobData.
	negone = -1;
	
	DO i = -1 to 24
		GlobData.slots.i = 0	/* first clear the board */
	end

	/* initial board config */
	GlobData.slots.0 = 2
	GlobData.slots.5 = -5
	GlobData.slots.7 = -3
	GlobData.slots.11 = 5
	GlobData.slots.12 = -5
	GlobData.slots.16 = 3
	GlobData.slots.18 = 5
	GlobData.slots.23 = -2


/* Setup to test end game -- dont use
GlobData.slots.6 = -1
GlobData.slots.5 = -2
GlobData.slots.4 = -2
GlobData.slots.3 = -5
GlobData.slots.2 = -1
GlobData.slots.1 = -3
GlobData.slots.0 = -1

GlobData.slots.15 = 1
GlobData.slots.18 = 2
GlobData.slots.19 = 2
GlobData.slots.20 = 5
GlobData.slots.21 = 1
GlobData.slots.22 = 3
GlobData.slots.23 = 1
*/

	GlobData.slots.negone = 0
	GlobData.slots.24 = 0

	GlobData.out.1 = 0
	GlobData.out.negone = 0

	GlobData.die.0 = 0
	GlobData.die.1 = 0
	GlobData.die.2 = 0
	GlobData.die.3 = 0

	GlobData.exited.1 = 0
	GlobData.exited.negone = 0
	
	GlobData.turn	= -1;

	return 1

/* --------------------------------------------------------------- */
/* procedure SetGlobalData					   */
/* --------------------------------------------------------------- */
SetGlobalData: procedure expose GlobData.
	negone = -1
	
	/* Check to see whether we are connected */
   	GetWindowAttrs stem winattrs.
   	BoardWidth = winattrs.width  - 58
   	BoardHeight= winattrs.height - 55

	/* Set up offsets */
	fStep = 1/16
	DO i=0 to 16 
	  GlobData.Xspace.i = trunc(BoardWidth * (fStep * i))
	  GlobData.Yspace.i = trunc(BoardHeight * (fStep * i))
	  end

	GlobData.XSize = trunc(BoardWidth / 16)
	GlobData.YSize = trunc(BoardHeight / 16)

   	if (winattrs.depth < 3) then do
		EasyRequest BackGammon_Error '"'||"You need at least a 8-color screen to play backgammon!"||'"' '"'||"Abort Backgammon"||'"'
		call SetStatus("Backgammon game exited.")
		lock off
		exit 0
		end 

	GlobData.SpikeColor.1 = 2
	GlobData.SpikeColor.negone = 7
	GlobData.PieceColor.1 = 4
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
	square GlobData.Xspace.0 GlobData.Yspace.0 GlobData.XSpace.16 GlobData.YSpace.16
	Do i = -1 to 24
		call DrawSpike(i)
		end

	SetFPen 1
	line GlobData.Xspace.7 GlobData.Yspace.0 GlobData.XSpace.7 GlobData.YSpace.16
	line GlobData.Xspace.9 GlobData.Yspace.0 GlobData.XSpace.9 GlobData.YSpace.16
	square GlobData.XSpace.7 GlobData.YSpace.6 GlobData.XSpace.9 GlobData.YSpace.10	
		
	if ((GlobData.die.0 + GlobData.die.1 + GlobData.die.2 + GlobData.die.3) > 0)  then do
		cturn = GlobData.turn
		bgcol = GlobData.PieceColor.cturn
		SetFPen bgcol
		square GlobData.XSpace.7+1 GlobData.YSpace.6+1 GlobData.XSpace.9-1 GlobData.YSpace.10-1 FILL
		Do i = 0 to 3 
			call DrawDie(i)
			end
		end
	else call DrawCup(0)

	call SetStatus("_LAST")
	return 1


/* --------------------------------------------------------------- */
/* procedure DrawSpike                                             */
/* --------------------------------------------------------------- */
DrawSpike: procedure expose GlobData.
	parse arg spikenum

	negone = -1

	/* Figure out what color to draw the spike as */
	spikecol = GlobData.SpikeColor.1
	if ((spikenum // 2) == 1) then spikecol = GlobData.SpikeColor.negone

	/* Figure out what color to draw any pieces as */
	piececol = GlobData.PieceColor.1
	numpieces  = GlobData.slots.spikenum
	if (numpieces < 0) then do
		piececol = GlobData.PieceColor.negone
		numpieces = -numpieces
		end

	/* Figure out our coords */
	baseofspike = getSpikeBase(spikenum)
	topofspike = getSpikeTop(spikenum)
	spikecenter = getSpikecenter(spikenum)

	/* First blank out the area we are to draw on */
	wid = trunc(GlobData.XSize/3)
	BaseOfSpikeCoord = GlobData.YSpace.baseofspike + getSpikeDir(spikenum)
	TopOfSpikeCoord = GlobData.Yspace.topofspike 
	if ((spikenum == -1)|(spikenum == 24)) then TopOfSpikeCoord = TopOfSpikeCoord - getSpikeDir(spikenum)
	/* extra is the few more pixels on the left we add in to ensure that any extra layers are erased */
	extra = trunc((trunc(abs((GlobData.slots.spikenum)/5))+1)*(GlobData.XSize/10))
	SetFPen 0	
	square (GlobData.Xspace.spikecenter)-wid-extra BaseOfSpikeCoord (GlobData.Xspace.spikecenter)+wid TopOfSpikeCoord FILL

	SetFPen 1
	if ((spikenum >= 0) & (spikenum <= 23)) then do
	  /* Draw the spike */
	  line (GlobData.Xspace.spikecenter)-wid BaseOfSpikeCoord GlobData.Xspace.spikecenter TopOfSpikeCoord
	  line (GlobData.Xspace.spikecenter)+wid BaseOfSpikeCoord GlobData.Xspace.spikecenter TopOfSpikeCoord
	
	  /* calculate circle coords */
	  cx = trunc(GlobData.XSize / 4)
	  cy = trunc(GlobData.YSize / 2)

	  SetFPen spikecol	
	  flood GlobData.Xspace.spikecenter trunc((BaseOfSpikeCoord + TopOfSpikeCoord)/2)
	  circle GlobData.Xspace.spikecenter TopOfSpikeCoord cx cy FILL
	  SetFPen 1
	  circle GlobData.Xspace.spikecenter TopOfSpikeCoord cx cy 
	  end

	/* Draw pieces if any */
	if (numpieces > 0) then do 
		do i=1 to numpieces 
			call DrawPiece(spikenum, piececol, i, 0) 
			end
		end
	return 1	


/* Draws a piece on the spikenum spike, in pen piecepen, at position piecenum (where 0 is the 
   base of the spike, and 5 is the top */
DrawPiece: procedure expose GlobData.
	parse arg spikenum, piecepen, piecenum, BXor

	dx = 0
	dy = 0
	
	/* Additional rows if piecenum is > 5 */
	do while (piecenum > 5)
		piecenum = piecenum - 5
		dx = dx - GlobData.XSize/10
		dy = dy - GlobData.YSize/10
		end

	dx = trunc(dx)
	dy = trunc(dy)
	
	cx = getSpikeCenter(spikenum)
	cy = getSpikeBase(spikenum) + (getSpikeDir(spikenum) * piecenum)

	rx = trunc(GlobData.XSize / 3)
	ry = trunc(GlobData.YSize / 2)


	if (BXor == 0) then do
		SetFPen piecepen
		circle (GlobData.Xspace.cx + dx) (GlobData.Yspace.cy + dy) rx ry FILL
		SetFPen 1
		circle (GlobData.Xspace.cx + dx) (GlobData.Yspace.cy + dy) rx ry 
		end
	else circle (GlobData.Xspace.cx + dx) (GlobData.Yspace.cy + dy) rx ry FILL XOR
	
	return 1


/* Draws a cup indicating that a player may roll.  The cup is drawn with the color
   indicated by (cupcolor) */
DrawCup: procedure expose GlobData.
	parse arg BXor 
	
	negone = -1

	left = trunc((GlobData.XSpace.7 + GlobData.XSpace.8)/2)
	right = trunc((GlobData.XSpace.8 + GlobData.XSpace.9)/2)

	top = trunc((GlobData.YSpace.6 + GlobData.YSpace.7)/2)
	bottom = trunc((GlobData.YSpace.9 + GlobData.YSpace.10)/2)
	
	if (BXor == 1) then do
		square left top right bottom XOR FILL
		return 1
		end
	
	/* Clear the whole area */
	SetFPen 0
	square GlobData.XSpace.7+1 GlobData.YSpace.6+1 GlobData.XSpace.9-1 GlobData.YSpace.10-1 FILL

	ctr = trunc((right+left)/2)
	midht  = trunc(GlobData.YSize/2)

	SetFPen 1
	circle ctr top+midht trunc((right-left)/2) midht FILL
	line left top+midht left bottom-midht
	line right top+midht right bottom-midht
	circle ctr bottom-midht trunc((right-left)/2) midht
			
	/* Fill it in */
	currentturn = GlobData.turn
	setFPen GlobData.PieceColor.currentturn
	square left+1 top+midht+midht+2 right-1 bottom-midht FILL	
	flood ctr bottom-midht+1
	flood ctr top+midht+midht+1 
	return 1



/* Draws dice number (dieindex) to show the number indicated in GlobData.die.(dieindex) */
DrawDie: procedure expose GlobData.
	parse arg dieindex

	left = 7
	top = 7
	if (dieindex >= 2) then top = top + 1
	if (dieindex == 1) then left = left + 1
	if (dieindex == 3) then left = left + 1

	/* convert to "real" coordinates */
	left = GlobData.Xspace.left
	top  = GlobData.Yspace.top

	/* shrink it 25% */
	width = trunc(GlobData.XSize * 0.75)
	height = trunc(GlobData.YSize * 0.75)

	/* and recenter it by moving it down&right 12.5% */
	left = left + trunc(GlobData.XSize * 0.125)
	top  = top  + trunc(GlobData.YSize * 0.125)

	/* now calculate the right and bottom edges */
	right = left + width
	bottom = top + height

	/* number to show on the die */
	num = GlobData.die.dieindex

	/* if it's unset, just erase the area */
	if (num < 1) then do
		/* Calculate background color = player's piece color */
		cturn = GlobData.turn
		SetFPen GlobData.PieceColor.cturn
		square left top right bottom FILL
		return 1
		end

	/* start with blank die */
	SetFColor 15 15 15
	square left top right bottom FILL
	SetFPen 1
	square left top right bottom 

	dotrx = trunc(width/12)		/* radii of dot */
	dotry = trunc(height/12)
	dx = trunc(width / 4)		/* offset from center dot */
	dy = trunc(height / 4)

	x2 = trunc((right + left)/2)
	y2 = trunc((bottom + top)/2)

	x1 = x2 - dx
	x3 = x2 + dx
	y1 = y2 - dy
	y3 = y2 + dy

	if (num == 1) then do
		circle x2 y2 dotrx dotry FILL
		end		
	else if (num == 2) then do
		circle x1 y1 dotrx dotry FILL
		circle x3 y3 dotrx dotry FILL
		end		
	else if (num == 3) then do
		circle x1 y1 dotrx dotry FILL
		circle x2 y2 dotrx dotry FILL
		circle x3 y3 dotrx dotry FILL
		end		
	else if (num == 4) then do
		circle x1 y1 dotrx dotry FILL
		circle x1 y3 dotrx dotry FILL
		circle x3 y1 dotrx dotry FILL
		circle x3 y3 dotrx dotry FILL
		end		
	else if (num == 5) then do
		circle x1 y1 dotrx dotry FILL
		circle x1 y3 dotrx dotry FILL
		circle x3 y1 dotrx dotry FILL
		circle x3 y3 dotrx dotry FILL
		circle x2 y2 dotrx dotry FILL
		end		
	else if (num == 6) then do
		circle x1 y1 dotrx dotry FILL
		circle x1 y2 dotrx dotry FILL
		circle x1 y3 dotrx dotry FILL
		circle x3 y1 dotrx dotry FILL
		circle x3 y2 dotrx dotry FILL
		circle x3 y3 dotrx dotry FILL
		end		
	return 1



/* Returns the horizontal coordinate number of a spike, given the spike index number */
getSpikeCenter: procedure 
	parse arg spikenum

	if (spikenum == -1) then return 8
	if (spikenum == 24) then return 8

	if (spikenum <= 5) then do
		/* in the upper right quadrant */
		return 15-spikenum
	end
	else if (spikenum <= 11) then do
		/* in the upper left quadrant */
		return (6-spikenum)+6
	end
	else if (spikenum <= 17) then do
		/* in the lower left quadrant */
		return (spikenum-17)+6
	end
	else do
		/* in the lower right quadrant */
		return (spikenum-18)+10
	end

/* returns the base coordinate of a spike */
getSpikeBase: procedure
	parse arg spikenum

	if (spikenum > 11) then
		return 16
	else
		return 0

/* returns the top coordinate of a spike */
getSpikeTop: procedure
	parse arg spikenum

	if (spikenum > 11) then
		return 10
	else
		return 6

/* returns 1 if the spike hangs down, else -1 if it pokes up */
getSpikeDir: procedure
	parse arg spikenum

	if (spikenum > 11) then do
		return -1
		end
	else do
		return 1
		end


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
	

/* draws an x over the dice for now */	
ShowCantMove: procedure expose GlobData.
	SetFPen 1
	line GlobData.XSpace.7+1 GlobData.YSpace.6+1 GlobData.XSpace.9-1 GlobData.YSpace.10-1
	line  GlobData.XSpace.9-1 GlobData.YSpace.6+1 GlobData.XSpace.7+1 GlobData.YSpace.10-1 
	call SetStatus("Sorry, you can't move!  Click on the dice to continue")
	return 1


	
/* returns 1 if a move is available, else returns 0 */
CanMove: procedure expose GlobData.
	do i = -1 to 24
		if (PieceCanMove(i) == 1) then return 1
		end 			     
	return 0
	

/* returns 1 if the piece on slot i can move, else 0 */
PieceCanMove: procedure expose GlobData.
	parse arg from
	
	if ((GlobData.slots.from * GlobData.turn) <= 0) then return 0	
	
	do d = 0 to 3
		if (GlobData.die.d > 0) then do
			if (MoveOkay(from,from+(GlobData.die.d * GlobData.turn),1) ~= -1) then return 1
			end  
		end          
	return 0
	
	
/* returns 1 if a player can move a piece "out" to the given exit, else 0 */
CanMoveOut: procedure expose GlobData.
	parse arg playernum

	sum = GlobData.exited.playernum
	
	if (playernum == -1) then 
		do i = 0 to 5
			if (GlobData.slots.i < 0) then sum = sum - GlobData.slots.i
			end
	else if (playernum == 1) then
		do i = 18 to 23
			if (GlobData.slots.i > 0) then sum = sum + GlobData.slots.i
			end
			
	if (sum == 15) then return 1
	return 0

			
/* Draws arrows for possible moves for this piece */		
ShowMoves: procedure expose GlobData.
	parse arg from
	
	do d = 0 to 3
		if (GlobData.die.d > 0) then do
			if (MoveOkay(from,from+(GlobData.die.d * GlobData.Turn),1) ~= -1) then call DrawArrow(from+(GlobData.die.d * GlobData.Turn))
			end  
		end          
	return 1

/* Draw an arrow pointing to the specified spike */
DrawArrow: procedure expose GlobData.
	parse arg spikenum
	
	spikenum = ChopRange(spikenum,-1,24)
	
	hcoord = getSpikeCenter(spikenum)
	vcoord = getSpikeTop(spikenum) + getSpikeDir(spikenum)

	/* Special cases! */
	if (spikenum = -1) then	vcoord = 5
	if (spikenum = 24) then vcoord = 11
		
	SetFPen 1	
	circle GlobData.XSpace.hcoord GlobData.YSpace.vcoord trunc(GlobData.XSize/10) trunc(GlobData.YSize/10) FILL
	return 1
	

/* Clears all arrows from the board */	
ClearArrows: procedure expose GlobData.
	
	SetFPen 0
	
	/* right portion! */
	topofrect     = MidWayBetween(6,7,Y) + 1
	bottomofrect  = MidWayBetween(9,10,Y) - 1
	leftofrect    = MidWayBetween(9,10,X) + 1
	rightofrect   = MidWayBetween(15,16,X) - 1
	square leftofrect topofrect rightofrect bottomofrect FILL
	
	/* left portion! */
	leftofrect    = MidWayBetween(0,1,X)
	rightofrect  = MidWayBetween(6,7,X)
	square leftofrect topofrect rightofrect bottomofrect FILL 
	
	/* special cases! */
	circle GlobData.XSpace.8 GlobData.YSpace.5  trunc(GlobData.XSize/10) trunc(GlobData.YSize/10) FILL
	circle GlobData.XSpace.8 GlobData.YSpace.11 trunc(GlobData.XSize/10) trunc(GlobData.YSize/10) FILL 
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
	parse arg from, to
	
	sstring = '"' || from || " " || to || '"'
	sendmessage sstring
	return 1
	
/* This function determines whether or not a piece may exit using
   a given die number (that is larger than needed to get to the exit).  
   It will return 1 iff there is no way to use that same die number
   to move any other piece anywhere else. */
CanExitOnExtra: procedure expose GlobData.
	parse arg dienum
	
	/* Only check valid die */
	if (dienum <= 0) then return 0
		
	do i = 0 to 23
		if (((GlobData.slots.i)*(GlobData.turn)) > 0) then do
			if (MoveOkay(i, i+(dienum*GlobData.turn), 0) ~= -1) then return 0
			end
		end
	return 1	/* no moves in --> can move out */