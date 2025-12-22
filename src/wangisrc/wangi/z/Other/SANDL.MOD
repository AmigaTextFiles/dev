MODULE SnakesAndLadders;

FROM InOut IMPORT WriteInt, WriteString, WriteLn, ReadString, ReadCard, WriteCard; 
FROM RandGen IMPORT Random,Randomize;


TYPE
	String = ARRAY [1..255] OF CHAR;

VAR
	PlayerName: ARRAY [1..6] OF String;
	PlayerPosition: ARRAY [1..6] OF CARDINAL;
	PlayerLocked: ARRAY [1..6] OF INTEGER;
	Board: ARRAY [1..50] OF CARDINAL;
	dummy: String;
	NumberOfPlayers: CARDINAL;

(* 0 = null space    1-100 = teleport to that square  101 = start  102 = finish *)
(* 103 = lock until correct dice throw   104 = miss a turn *)

PROCEDURE SetupGameBoard;
BEGIN
	Board	[1]	:=	101;
        Board   [2]     :=      0;
        Board   [3]     :=      0;
        Board   [4]     :=      0;
        Board   [5]     :=      34;
        Board   [6]     :=      0;
        Board   [7]     :=      0;
        Board   [8]     :=      0;
        Board   [9]     :=      0;
        Board   [10]    :=      0;
        Board   [11]    :=      0;
        Board   [12]    :=      0;
        Board   [13]    :=      0;
        Board   [14]    :=      0;
        Board   [15]    :=      0;
        Board   [16]    :=      0;
        Board   [17]    :=      0;
        Board   [18]    :=      0;
        Board   [19]    :=      0;
        Board   [20]    :=      0;
        Board   [21]    :=      0;
        Board   [22]    :=      0;
        Board   [23]    :=      0;
        Board   [24]    :=      0;
        Board   [25]    :=      0;
        Board   [26]    :=      0;
        Board   [27]    :=      0;
        Board   [28]    :=      0;
        Board   [29]    :=      0;
        Board   [30]    :=      0;
        Board   [31]    :=      0;
        Board   [32]    :=      0;
        Board   [33]    :=      0;
        Board   [34]    :=      0;
        Board   [35]    :=      0;
        Board   [36]    :=      0;
        Board   [37]    :=      0;
        Board   [38]    :=      0;
        Board   [39]    :=      15;
        Board   [40]    :=      0;
        Board   [41]    :=      0;
        Board   [42]    :=      0;
        Board   [43]    :=      0;
        Board   [44]    :=      0;
        Board   [45]    :=      0;
        Board   [46]    :=      0;
        Board   [47]    :=      0;
        Board   [48]    :=      0;
	Board   [49]	:=	0;
	Board   [50]    :=      102;
END SetupGameBoard;

(* ################################################################## *)
(* # Prints some white space to break up the text a little          # *)
(* ################################################################## *)

PROCEDURE WhiteSpace;
BEGIN
	WriteLn;
	WriteString('***********************************************************');
	WriteLn;
END WhiteSpace;

PROCEDURE FinishTheGame;
BEGIN
END FinishTheGame;

(* ################################################################## *)
(* # Find out the number of people that want to play the game       # *)
(* ################################################################## *)

PROCEDURE GetNumberOfPlayers;

VAR
	ValidInput: BOOLEAN;
BEGIN
	ValidInput:=FALSE;
	WhiteSpace;
	REPEAT
		WriteString('Enter the number of playerz (2-6) :');
		ReadCard(NumberOfPlayers);
		IF (NumberOfPlayers >1) AND (NumberOfPlayers <7) THEN ValidInput:=TRUE
		ELSE 
			WriteString ('Sorry, the number of players must be 2-6..  ');
			WriteLn;
			WriteString ('Please re-enter');
			WriteLn;
			WriteLn;
		END;
	UNTIL ValidInput=TRUE;
END GetNumberOfPlayers;


(* ################################################################## *)
(* # Gets a name for each of the players. Names stored in an array  # *)
(* ################################################################## *)

PROCEDURE GetPlayerNames;

VAR
	Loop: CARDINAL;
BEGIN
	WhiteSpace;
	WriteString ('Before you can play, I need to know what you are called.');
	WriteLn; 
	WriteString ('What can I call you?');
	WriteLn;
	FOR Loop:=1 TO NumberOfPlayers DO
		WriteString ('Player ');
		WriteInt (Loop,1);
		WriteString (', please enter your name :');
		ReadString (PlayerName[Loop]);
	END;
	WriteLn;
	WriteString ('OK, that seems to be all of you... lets get on with the game.');
	WriteLn;
END GetPlayerNames;


(* ################################################################## *)
(* # Displays a bit of info about the game before the player throws # *)
(* ################################################################## *)

PROCEDURE DisplayPlayerInfo(PlayerNum : CARDINAL);

BEGIN
	WhiteSpace;
	WriteString (PlayerName[PlayerNum]);
	WriteString (' its you to play!');
	WriteLn;
	WriteLn;
	WriteString ('Let us see.. at the moment youre on square ');
	WriteInt (PlayerPosition[PlayerNum]+1,1);
	WriteString(', just ');
	WriteInt (50-(PlayerPosition[PlayerNum]+1),2);
	WriteString (' squares to go!');
	WriteLn;
	WriteLn;
END DisplayPlayerInfo;
	

(* ################################################################## *)
(* # Checks to see how far away the player is from the end of game  # *)
(* ################################################################## *)

PROCEDURE CheckForPlayerNearEnd(PlayerNum : CARDINAL);
BEGIN
	IF (50-(PlayerPosition[PlayerNum]+1) < 7) THEN
		WriteString ('Hey! You only need to throw a ');
		WriteInt (50-(PlayerPosition[PlayerNum]+1),1);
		WriteString (' to finish!');
		WriteLn;
	END;
END CheckForPlayerNearEnd;
	
(* ################################################################## *)
(* # If the player lands on a teleporter square, this routine finds # *)
(* # out what type of teleport it is and prints an appropriate msg. # *)
(* ################################################################## *)

PROCEDURE TeleportPlayer(PlayerNum : CARDINAL);
BEGIN
	WriteString('the square holds one of those fangled teleporter thing...');
	WriteLn;
	WriteString('You step gingerly onto the Teleporter platform and...');
	WriteLn;
	IF (Board[PlayerPosition[PlayerNum]] < PlayerPosition[PlayerNum])
	THEN
		WriteString('OH NOOOOOOO! Youve been teleported back to square ');
	ELSE	
		WriteString('YEEEEAAAAAAAAH! Youve been teleported forward to ');
	END;
	WriteInt(Board[PlayerPosition[PlayerNum]],2);
	WriteString('!');
	WriteLn;
	PlayerPosition[PlayerNum]:=Board[PlayerPosition[PlayerNum]];
END TeleportPlayer;
	   
PROCEDURE LockPlayer(PlayerNum : CARDINAL);
VAR
	LockValue : CARDINAL;

BEGIN
	WriteString ('it is one of those awful locking squares!');
	WriteLn;
	WriteString ('This square will not let you out until you roll a ');
	LockValue:=Random(6)+1;
	PlayerLocked[PlayerNum]:=LockValue;
	WriteInt(LockValue,1);
	WriteLn;
	WriteString ('Annoying isnt it? =8*)');
	WriteLn;
END LockPlayer;

PROCEDURE MissATurn(PlayerNum : CARDINAL);
BEGIN
	WriteString('that you will have to MISS A TURN!'); 
	WriteLn;
	WriteString('What a personal disaster!');
	WriteLn;
	PlayerLocked[PlayerNum]:=7;
END MissATurn;

(* ################################################################## *)
(* # When the player moves, this routine determines what type of    # *)
(* # square the player has moved onto and prints an appropriate msg # *)
(* ################################################################## *)

PROCEDURE CheckForGameEvent(PlayerNum : CARDINAL);

VAR 
	SquareType : INTEGER;

BEGIN
	SquareType:=Board[PlayerPosition[PlayerNum]];
	WriteString ('You walk forward to the square and notice that ');
	IF (SquareType=0) THEN WriteString(' it is just an ordinary square.'); END;
	IF (SquareType=101) THEN  WriteString(' it is the FINISH! You have won!'); 
				  FinishTheGame;
	END;
	IF (SquareType>1) AND (SquareType<50) THEN TeleportPlayer(PlayerNum); END;
	IF (SquareType=103) THEN LockPlayer(PlayerNum); END;
	IF (SquareType=104) THEN MissATurn(PlayerNum); END;
	
END CheckForGameEvent;

(* ################################################################## *)
(* # Routine to throw the dice and move the player on the correct   # *)
(* # number of spaces.                                              # *)
(* ################################################################## *)
        
PROCEDURE MovePlayer(PlayerNum: CARDINAL);
        
VAR
        DiceRoll: CARDINAL;
        Dummy: String;
BEGIN
        DiceRoll:=Random(6)+1;
        WriteString ('Press <Return> to throw the dice please ');
        WriteString (PlayerName[PlayerNum]);
        WriteString ('!');
        WriteLn;
        ReadString(Dummy);
        WriteString('The dice rattles around and ends up on a ');
        WriteInt(DiceRoll,1);
        WriteLn;
        WriteLn;
        PlayerPosition[PlayerNum]:=PlayerPosition[PlayerNum]+DiceRoll;  
        CheckForGameEvent(PlayerNum);
END MovePlayer;




PROCEDURE CheckForMissedTurn(PlayerNum: CARDINAL);
BEGIN
        IF (PlayerLocked[PlayerNum]<7) THEN MovePlayer(PlayerNum); END;
        WriteString('YOU HAD TO MISS THIS TURN! SORRY =8*0');
        WriteLn;
        PlayerLocked[PlayerNum]:=0;
END CheckForMissedTurn;
	
(* ################################################################## *)
(* # Main program - puts all the events in the right order to play  # *)
(* ################################################################## *)

PROCEDURE PlayTheGame;

VAR
	CurrentPlayer: CARDINAL;
	GameOver: BOOLEAN;
BEGIN
	CurrentPlayer:=1;
	GameOver:=FALSE;
	REPEAT
		DisplayPlayerInfo(CurrentPlayer);
		CheckForPlayerNearEnd(CurrentPlayer);
		CheckForMissedTurn(CurrentPlayer);		
		CurrentPlayer:=CurrentPlayer+1;
		IF CurrentPlayer > NumberOfPlayers THEN CurrentPlayer:=1; END;
	UNTIL GameOver=TRUE;
END PlayTheGame;



BEGIN
	SetupGameBoard;
	GetNumberOfPlayers;
	GetPlayerNames;
	PlayTheGame;
END SnakesAndLadders.
