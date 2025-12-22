Unit GenerateLotteryNums;

INTERFACE

Uses
	Exec, Intuition;

Const	
	NUM_NUMS   = 6; { amount of numbers to choose }
	NUM_BOARDS = 5; { number of boards }
	
Type
	pBoard = ^tBoard;
	tBoard = Array[1..NUM_NUMS] of Integer;
	
	pBoards = ^tBoards;
	tBoards = Record
		bo_Nums  : Array[1..NUM_BOARDS] of tBoard;
		bo_Weeks : Byte;
	End;

Procedure InitGLN;
Procedure RandomBoard(VAR b : tBoard);
Procedure RandomBoards(VAR b : tBoards);
Procedure ClearBoard(VAR b : tBoard);
Procedure ClearBoards(VAR b : tBoards);
Procedure SortBoard(VAR b : tBoard);
Procedure SortBoards(VAR b : tBoards);
Procedure SetWeeks(VAR b : tBoards; n : LONG);
Function  GetWeeks(VAR b : tBoards): LONG;

IMPLEMENTATION

Procedure InitGLN;

Begin
	Randomize;
End;


Procedure RandomBoard;

Var
	n, y, 
	tmp   : LONG;
	Again : Boolean;
	
Begin
	For n := 1 to NUM_NUMS do begin
		Again := True;
		While Again do begin
			Again := False;
			tmp := Random(50);
			{ Check for duplicates }
			If tmp = 0 then
				Again := True
			else begin
				For y := 1 to NUM_NUMS do
					If tmp = b[y] then Again := True;
			End;
		End;
		b[n] := tmp;
	End;
	SortBoard(b);
End;


Procedure RandomBoards;
		
Var
	n : Integer;
	
Begin
	For n := 1 to NUM_BOARDS do
		RandomBoard(b.bo_Nums[n]);
End;


Procedure ClearBoard(VAR b : tBoard);

Var
	n : Integer;
	
Begin
	For n := 1 to NUM_NUMS do
		b[n] := 0;
End;


Procedure ClearBoards(VAR b : tBoards);

Var
	n : Integer;
	
Begin
	For n := 1 to NUM_BOARDS do
		ClearBoard(b.bo_Nums[n]);
	b.bo_Weeks := 1;
End;


Procedure SortBoard;

Var
	ob : tBoard;
	pass, minindex, j : Integer;
	
Begin
	For pass := 1 to NUM_NUMS do begin
		MinIndex := 1;
		For j := 2 to NUM_NUMS do begin
			If b[j] < b[minindex] then
				minindex := j;
		End;
		ob[pass] := b[minindex];
		b[minindex] := MaxInt;
	End;
	b := ob;
End;

Procedure SortBoards(VAR b : tBoards);

Var
	n : Integer;
	
Begin
	For n := 1 to NUM_BOARDS do
		SortBoard(b.bo_Nums[n]);
End;

Procedure SetWeeks;

Begin
	If (n > 0) and (n < 9) then
		b.bo_weeks := n
	else
		b.bo_weeks := 1;
End;

Function GetWeeks;

Begin
	GetWeeks := b.bo_Weeks;
End;

End.


	
