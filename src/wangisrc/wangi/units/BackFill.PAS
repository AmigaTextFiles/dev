unit Backfill;

(*
 * Unit Backfill
 * Uses boopsi image classes to implement window edge backfills, similar
 * to those around system easyrequesters.
 * 
 *)

INTERFACE

Uses
	Exec, Intuition, Graphics, Utility;
	
Type
	pFillData = ^tFillData;
	tFillData = Array[0..2] of Word;
	pBackFill = ^tBackFill;
	tBackFill = Record
		bf_OuterFill,              { -|           }
		bf_Innerbevel : Pointer;   {  |- Private! }
		bf_Pattern    : pFillData; { -|           }
	End;
	
Procedure DrawBackFill(bf : tBackFill; Win : pWindow);
Procedure InitBackFill(VAR bf : tBackFill;
                       Win : pWindow;
                       Left, Top, 
                       Width, Height, 
                       IWidth, IUHeight, ILHeight,
                       FGPen, BGPen, Mode: LONG);
Procedure FreeBackFill(bf : tBackFill);

IMPLEMENTATION

Procedure DrawBackFill;

Begin
	{ Draw the two images }
	If bf.bf_OuterFill <> NIL then
		DrawImageState(Win^.RPort, pImage(bf.bf_OuterFill), 0, 0, IDS_NORMAL, NIL);
	If bf.bf_InnerBevel <> NIL then
		DrawImageState(Win^.RPort, pImage(bf.bf_InnerBevel), 0, 0, IDS_NORMAL, NIL);
End;

Procedure InitBackFill;

Var
	patt  : Array[0..3] of Word;
	t     : Array[0..18] of LONG;
	cname : String;

Begin
	bf.bf_OuterFill := NIL;
	bf.bf_InnerBevel := NIL;
	bf.bf_Pattern := AllocVec(Sizeof(tFilldata), MEMF_CLEAR);
	if bf.bf_Pattern <> NIL then begin
		bf.bf_Pattern^[0] := $5555; { 0101010101010101 }
		bf.bf_Pattern^[1] := $AAAA; { 1010101010101010 }
		bf.bf_Pattern^[2] := 0;
		t[ 0] := IA_Left;
		t[ 1] := Left;
		t[ 2] := IA_Top;
		t[ 3] := Top;
		t[ 4] := IA_Width;
		t[ 5] := Width;
		t[ 6] := IA_Height;
		t[ 7] := Height;
		t[ 8] := IA_Mode;
		t[ 9] := Mode;
		t[10] := IA_APattern;
		t[11] := LONG(bf.bf_Pattern);
		t[12] := IA_APatSize;
		t[13] := 1;
		t[14] := IA_FGPen;
		t[15] := FGPen;
		t[16] := IA_BGPen;
		t[17] := BGPen;
		t[18] := TAG_DONE;
		cname := FILLRECTCLASS+#0;
		bf.bf_OuterFill := NewObjectA(NIL, @cname[1], @t);
		
		t[ 0] := IA_Left;
		t[ 1] := Left+IWidth;
		t[ 2] := IA_Top;
		t[ 3] := Top+IUHeight;
		t[ 4] := IA_Width;
		t[ 5] := Width-(2*IWidth);
		t[ 6] := IA_Height;
		t[ 7] := Height-IUHeight-ILHeight;
		t[ 8] := IA_Recessed;
		t[ 9] := True_;
		t[10] := TAG_DONE;
		cname := FRAMEICLASS+#0;
		bf.bf_InnerBevel := NewObjectA(NIL, @cname[1], @t);
	End;
	
	DrawBackFill(bf, Win);
End;

Procedure FreeBackFill;

Begin
	DisposeObject(bf.bf_InnerBevel);
	DisposeObject(bf.bf_OuterFill);
	If bf.bf_Pattern <> NIL then
		FreeVec(bf.bf_Pattern);
End;
	
End.