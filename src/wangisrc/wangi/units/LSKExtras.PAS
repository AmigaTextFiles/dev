UNIT LSKExtras;

INTERFACE

USES Intuition, Graphics, Exec, Gadtools, Utility;

Procedure ErrorExit(InitMsg, Errortxt : string);

Function RetrieveStr(p : pointer) : string;

Procedure DisableGadget(g : pGadget; w : pWindow; Disable : byte);

function CStrConstPtr(s : string) : pointer;

Function LockFrontPubScr(VAR Screen  : pScreen) : String;

Procedure UnlockFrontPubScr(pubname : string; Screendef : pScreen);

Procedure DisableWindow(w : pWindow; req : pRequester;  waitpointer : pointer);

Procedure EnableWindow(w : pWindow; req : pRequester; IDCMP : LONG);

IMPLEMENTATION

Procedure ErrorExit;

VAR
	ReqIT   : array [1..2] of tIntuiText;
	ReqOk   : tIntuiText;
	ReqStrs : array[1..3] of string;
	z : integer;
	OKRes : boolean;

begin
	ReqStrs[1] := InitMsg;
	ReqStrs[2] := Errortxt;
	ReqStrs[3] := 'Exit'#0;
	for z := 1 to 2 do begin
    	with ReqIT[z] do begin
      	FrontPen  := 0;
      	BackPen   := 1;
      	DrawMode  := JAM1;
      	LeftEdge  := 1;
      	TopEdge   := (10 * z);
      	ITextFont := NIL;
      	IText     := @ReqStrs[z,1];
      	if z < 2 then NextText  := @ReqIT[z+1] else NextText := NIL;
    	end;
   end;
	with ReqOk do begin
    	FrontPen  := 0;
    	BackPen   := 1;
    	DrawMode  := JAM1;
    	LeftEdge  := 2;
    	TopEdge   := 2;
    	ITextFont := NIL;
    	IText     := @ReqStrs[3,1];
    	NextText  := NIL
  	end;
	OKRes := AutoRequest(NIL, @ReqIT[1], NIL, @ReqOk, 0, 0, IntuiTextLength(@ReqIT[2]) + 40, 80);
																		{ sizes needed by v34 }
end;

Function RetrieveStr;
Type
  a = Packed Array [0..255] Of Char;     { fills a string with the }
Var                                      { contents of the string  }
  i    : Integer;                        { pointed at              }
  sptr : ^a;                             { (from HSPC init.unit)   }
  s    : string;
Begin
  sptr := p;
  s := '';
  i := 0;
  While sptr^[i] <> #0 Do Begin
    s := s + sptr^[i];
    inc(i)
  End;
  RetrieveStr := s
End;

Procedure DisableGadget;

VAR Dis_Tags : array[0..1] of tTagItem;

begin
	Dis_Tags[0].ti_Tag  := GA_Disabled;
	Dis_Tags[0].ti_Data := Disable;
	Dis_Tags[1].ti_Tag  := TAG_END;
	GT_SetGadgetAttrsA(g,w,NIL,@Dis_Tags);
end;

function CStrConstPtr;
type a = packed array [0..255] of char;
var  p : ^a;
begin
  s := s + #0;                         { Make "C" string }
  getmem(p, length(s));                { Get some mem for it }
  move(s[1], p^, length(s));           { Move s into newly alloc'd mem }
  CStrConstPtr := p                    { Return the pointer }
end;




Function LockFrontPubScr;
VAR
	LockKey     : Longint;
	My_Node     : pPubScreenNode;
	PS_List     : pList;
	 
CONST
	name : string = 'error';

begin
	LockKey := LockIBase(0);
	screen := IntuitionBase^.ActiveScreen;
	PS_List := LockPubScreenList;
	My_Node := pPubScreenNode(PS_List^.lh_Head);
	While My_Node^.psn_Node.ln_Succ <> NIL Do Begin
		If my_Node^.psn_Screen = screen Then
			Name := retrievestr(My_Node^.psn_Node.ln_Name);
		My_Node := pPubScreenNode(My_Node^.psn_Node.ln_Succ);
	End;
	UnLockPubScreenList;
	UnlockIBase(LockKey);
	If name = 'error' Then Begin
		screen := lockPubScreen(NIL);
		LockFrontPubScr := '***LSK FPS ERROR';
   	If screen = NIL Then begin
   		ErrorExit('** LSK Pub Screen broker Failure **','Failed to lock public screen'#0);
   		halt(0);
   	end; 
   End Else Begin
		name := name + #0;
   	screen := lockPubScreen(@Name[1]);
   	LockFrontPubScr := name; 
   	If screen = NIL Then begin
			ErrorExit('** LSK Pub Screen broker Failure **','Failed to lock public screen'#0);
			halt(0);
		end;
	End;
	
end;



Procedure UnlockFrontPubScr;

begin
	If pubname = '***LSK FPS ERROR' Then begin
   	UnlockPubScreen(NIL, screendef);
   end Else begin
		UnlockPubScreen(@PubName[1], screendef);
	end;
end;

Procedure DisableWindow;

VAR result : boolean;

begin
	result := ModifyIDCMP(w,IDCMP_REFRESHWINDOW);
	(* Block window input *)
	result := Request(req,w);
	(* Set wait pointer *)
 	(*if (OSV39)
	 *	SetWindowPointer(w,WA_BusyPointer,TRUE,TAG_DONE);
	 * else
	 * not yet, only got v37 defines *)
	SetPointer(w,WaitPointer,16,16,-6,0);
end;


Procedure EnableWindow;

VAR result : boolean;

begin
	(* if (OSV39)
	 *  SetWindowPointer(w,TAG_DONE);
    * else
    * not yet, only got v37 defines *)
	ClearPointer(w);
	(* Enable window input *)
	EndRequest(req,w);
	(* Enable IDCMP *)
	result := ModifyIDCMP(w,idcmp);
end;

end.