Program DQua;

   
Uses Exec, Intuition, utility, gadtools, graphics, AmigaDOS, LSKExtras, Amiga;

Const
   
   LLGad    = 1; { NULL initialised gadget   }
   CCGad    = 2; { CreateContext() gadget    }
   STRGad_A = 3; { `a' string gadget         }
   STRGad_B = 4; { `b' string gadget         }
   STRGad_C = 5; { `c' string gadget         }
   Abt_Gad  = 6; { about, ?, gadget          }
   BUTGad_S = 7; { Solve gadget              }
   Eqn_Disp = 8; { Gadget with displays Eq'n }
   
   BorTop = 1; BorLeft = 2; BorRight = 3; BorBottom = 4;
   DispBB_H = 5; EqBB_H = 6; BB_L = 7; BB_W = 8; StrG_W = 9; GadTxt_W = 10;
   XSze = 11; TBS = 12; Abt_W = 13;
   
   Vers       : string = '$VER: DQua v1.2 © Lee S Kindness 06.09.94'#0;
   Win_Title  : string = 'DQua v1.2'#0;
   Scr_Title  : string = 'DQua, the de-quaderator. ©94 Lee Kindness'#0;
   fontname   : string = 'topaz.font'#0;
   gad1text   : string = '_a :'#0;
   gad2text   : string = '_b :'#0;
   gad3text   : string = '_c :'#0;
   butgadtext : string = '_Solve'#0;
   AbtGStr    : string = '_?'#0;
   defnum     : string = '1'#0;
   infotext   : string = ' ax² + bx + c = 0'#0;
   SampStr    : string = 'b : '#0;
   SampOut    : string = 'Imaginary roots at 0.000000098'#0;
   visualinf  : pointer = NIL;
   TheWindow  : pWindow = NIL;

         
Var
   Gads           : Array [LLGad..Eqn_Disp] Of pGadget;
   Gadgetflags    : tNewGadget;
   My_Font        : tTextAttr;
   BevelTags      : Array[1..3] Of tTagItem;
   Sizes          : Array[1..13] Of Integer;
   

   
{ ===================================================================== } 


{ ===================================================================== }

Procedure ErrExit(Errortxt : string; ExitCode : integer);

Begin
	ErrorExit('** DQua Error **'#0, Errortxt);
	CloseLibrary(pLibrary(IntuitionBase));
	If GadToolsBase <> NIL then CloseLibrary(pLibrary(GadtoolsBase));
	If TheWindow <> NIL then CloseWindow(TheWindow);
	If gads[LLGad] <> NIL then FreeGadgets(gads[LLGad]);
	If VisualInf <> NIL then FreeVisualInfo(VisualInf);
	Halt(exitcode);
end;

{ ===================================================================== }

Procedure open_libs; { open used libraries }


Begin
	IntuitionBase := NIL;
   IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',34));
   if IntuitionBase = NIL then halt(122);
   If IntuitionBase^.LibNode.lib_Version < 36 Then
    	ErrExit('Intuition library v36 (2.0) required'#0, 122);

   GadToolsBase := NIL;
   GadToolsBase  := pLibrary(Openlibrary('gadtools.library',36)); 
   If GadtoolsBase = NIL Then
		ErrExit('GadTools library v36 (2.0) required'#0, 122);
End;
  
{ ===================================================================== }

Procedure displayBevelboxes;  { used to display and refresh the boxes }
Begin                         { output                                }
     
   DrawBevelBoxA(TheWindow^.RPort, Sizes[BB_L], Sizes[TBS] + 4 + Sizes[EqBB_H], Sizes[BB_W], Sizes[DispBB_H], @Beveltags);
End;

{ ===================================================================== }

Procedure setupbevelBoxes;  { set up boxes }
Begin
   Beveltags[1].ti_Tag  := GT_VisualInfo;
   BevelTags[1].ti_Data := LONG(VisualInf);
   BevelTags[2].ti_Tag  := GTBB_Recessed;
   BevelTags[2].ti_Data := True_;
   BevelTags[3].ti_Tag  := TAG_END;
End;

{ ===================================================================== }
Procedure open_window;

Const
	PubName : string = 'error';
	
Var 
	Window_Tags : Array[0..17] Of tTagItem;
   Gadget_Tags : Array[0..2] Of tTagItem;
   sampTxt     : tIntuiText;
	screendef   : pScreen;
	LockKey     : Longint;
	PS_List     : pList;
	My_Node     : pPubScreenNode;
   
Begin
   gads[LLGad]  := NIL; 
{ Get visual info and create context }
	LockKey := LockIBase(0);
	screendef := IntuitionBase^.ActiveScreen;
	
	PS_List := LockPubScreenList;
	My_Node := pPubScreenNode(PS_List^.lh_Head);
	While My_Node^.psn_Node.ln_Succ <> NIL Do Begin
		If my_Node^.psn_Screen = screendef Then
			PubName := ptrtopas(My_Node^.psn_Node.ln_Name);
		My_Node := pPubScreenNode(My_Node^.psn_Node.ln_Succ);
	End;
	UnLockPubScreenList;
	UnlockIBase(LockKey);
	
	If pubname = 'error' Then Begin
		screendef := lockPubScreen(NIL);
   	If screendef = NIL Then
   		ErrExit('Failed to lock public screen'#0, 0); 
   End Else Begin
		pubname := pubname + #0;
   	screendef := lockPubScreen(@PubName[1]);
   	If screendef = NIL Then 
			ErrExit('Failed to lock public screen'#0, 0);
	End;
   VisualInf := GetVisualInfoA(screendef, NIL);
   If visualinf = NIL Then
      ErrExit('Failed to get visual info'#0, 0);
   Gads[CCGad] := CreateContext(@gads[LLGad]);
   If Gads[CCGad] = NIL Then
      ErrExit('Failed to create context'#0, 0);
      
{ Get some data from the screen }

	My_Font := Screendef^.Font^;
	
   Sizes[TBS]       := screendef^.WBorTop + (screendef^.Font^.ta_YSize + 1);
   Sizes[XSze]      := Sizes[TBS] + 1;
   sizes[BorTop]    := Screendef^.WBorTop;
   sizes[BorLeft]   := Screendef^.WBorLeft;
   sizes[BorRight]  := Screendef^.WBorRight;
   sizes[BorBottom] := Screendef^.WBorBottom;
	Sizes[StrG_W]    := My_Font.ta_YSize * 12;
	Sizes[DispBB_H]  := (Sizes[XSze] * 3) + 8;
	Sizes[EqBB_H]    := Sizes[XSze] ;
	Samptxt.ITextFont := @My_Font;
	Samptxt.IText := @Sampstr[1];
	Sizes[GadTxt_W]  := IntuiTextLength(@Samptxt) + 10;
	Samptxt.IText := @SampOut[1];
	Sizes[BB_W]      := IntuiTextLength(@Samptxt) + 4;
	Samptxt.IText := @AbtGStr[1];
	Sizes[Abt_W]     := IntuiTextLength(@Samptxt);
	Sizes[BB_L]      := Sizes[BorLeft] + Sizes[Gadtxt_W] + Sizes[StrG_W] + 4;
	
{ Initilise gadget structures }
   Gadget_Tags[0].ti_Tag  := GTST_String;
   Gadget_Tags[0].ti_Data := LONG(@defnum[1]);
   Gadget_Tags[1].ti_Tag  := GT_UnderScore;
   Gadget_Tags[1].ti_Data := LONG('_');
   Gadget_Tags[2].ti_Tag  := TAG_END;
   
   With GadgetFlags Do Begin
      ng_TextAttr   := @My_Font;
      ng_LeftEdge   := sizes[BorLeft] + Sizes[GadTxt_W];
      ng_TopEdge    := Sizes[TBS] + 2;
      ng_Width      := Sizes[StrG_W];
      ng_Height     := Sizes[XSze];
      ng_GadgetText := @gad1text[1];
      ng_VisualInfo := VisualInf;
      ng_GadgetID   := STRGad_A;
   End;
   
{ create gadgets }
   Gads[STRGad_A] := CreateGadgetA(STRING_KIND, Gads[CCGad], @Gadgetflags, @Gadget_Tags);
   With GadgetFlags Do Begin
      ng_TopEdge    := ng_TopEdge + Sizes[XSze] + 2;
      ng_GadgetText := @gad2text[1];
      ng_GadgetID   := STRGad_B;
   End;

   Gads[STRGad_B] := CreateGadgetA(STRING_KIND, Gads[STRGad_A], @Gadgetflags, @Gadget_Tags);
   With GadgetFlags Do Begin
      ng_TopEdge    := ng_TopEdge + Sizes[XSze] + 2;
      ng_GadgetText := @gad3text[1];
      ng_GadgetID   := STRGad_C;
   End;

   Gads[STRGad_C] := CreateGadgetA(STRING_KIND, Gads[STRGad_B], @Gadgetflags, @Gadget_Tags);
   With gadgetflags Do Begin
   	ng_LeftEdge   := Sizes[BorLeft] + 4;
      ng_TopEdge    := ng_TopEdge + Sizes[XSze] + 2;
      ng_Width      := Sizes[Abt_W];
      ng_Height     := (Sizes[EqBB_H] + Sizes[DispBB_H] + Sizes[TBS] + 6 + Sizes[BorBottom]) - ng_TopEdge - 4;
      ng_GadgetText := @AbtGStr[1];
      ng_GadgetID   := Abt_Gad;
   End;
	Gadget_Tags[0].ti_Tag  := TAG_IGNORE;
   Gads[Abt_Gad] := CreateGadgetA(BUTTON_KIND, Gads[STRGad_C], @Gadgetflags, @Gadget_Tags);
   With gadgetflags Do Begin
   	ng_LeftEdge   := Sizes[BorLeft] + Sizes[Abt_W] + 8;
      ng_Width      := Sizes[BB_L] - Sizes[BorLeft] - 12 - sizes[Abt_W];
      ng_Height     := (Sizes[EqBB_H] + Sizes[DispBB_H] + Sizes[TBS] + 6 + Sizes[BorBottom]) - ng_TopEdge - 4;
      ng_GadgetText := @butgadtext[1];
      ng_GadgetID   := BUTGad_S;
   End;
	Gads[BUTGad_S] := CreateGadgetA(BUTTON_KIND, Gads[Abt_Gad], @Gadgetflags, @Gadget_Tags);
   
   With GadgetFlags Do Begin
   	ng_LeftEdge   := Sizes[BB_L];
   	ng_TopEdge    := Sizes[TBS] + 2;
   	ng_Width      := Sizes[BB_W];
   	ng_Height     := Sizes[EqBB_H];
   	ng_GadgetText := NIL;
   	ng_GadgetID   := Eqn_Disp;
   End;
	Gadget_Tags[0].ti_Tag  := GTTX_Text;
	Gadget_Tags[0].ti_Data := LONG(@infotext[1]);
   Gadget_Tags[1].ti_Tag  := GTTX_Border;
	Gadget_Tags[1].ti_Data := True_;

   Gads[Eqn_Disp] := CreateGadgetA(TEXT_KIND, Gads[BUTGad_S], @Gadgetflags, @Gadget_Tags);	
   
   If Gads[CCGad] = NIL Then
      ErrExit('Failed to create gadgets'#0, 0);
   
{ window structure }
	Window_Tags[0].ti_Tag  := WA_Left;
   Window_Tags[0].ti_Data := screendef^.MouseX - ((Sizes[BB_L] + Sizes[BB_W] + Sizes[BorRight] + 6) div 2);
   Window_Tags[1].ti_Tag  := WA_Top;
   Window_Tags[1].ti_Data := Screendef^.MouseY - ((Sizes[EqBB_H] + Sizes[DispBB_H] + Sizes[TBS] + 6) div 2);
   Window_Tags[2].ti_Tag  := WA_Width;
   Window_Tags[2].ti_Data := Sizes[BB_L] + Sizes[BB_W] + Sizes[BorRight] + 6;
   Window_Tags[3].ti_Tag  := WA_Height;
   Window_Tags[3].ti_Data := Sizes[EqBB_H] + Sizes[DispBB_H] + Sizes[TBS] + 6 + Sizes[BorBottom];
   Window_Tags[4].ti_Tag  := WA_Title;
   Window_Tags[4].ti_Data := LONG(@Win_Title[1]); 
   Window_Tags[5].ti_Tag  := WA_IDCMP;
   Window_Tags[5].ti_Data := IDCMP_CLOSEWINDOW Or INTEGERIDCMP 
		Or IDCMP_REFRESHWINDOW Or BUTTONIDCMP 
		Or IDCMP_MOUSEBUTTONS Or IDCMP_VANILLAKEY;
   Window_Tags[6].ti_Tag  := WA_CloseGadget;
   Window_Tags[6].ti_Data := True_;
   Window_Tags[7].ti_Tag  := WA_DragBar;
   Window_Tags[7].ti_Data := True_;
   Window_Tags[8].ti_Tag  := WA_DepthGadget;
   Window_Tags[8].ti_Data := True_;
   Window_Tags[9].ti_Tag  := WA_AutoAdjust;
   Window_Tags[9].ti_Data := True_;
   Window_Tags[10].ti_Tag := WA_Activate;
   Window_Tags[10].ti_Data:= True_;
   Window_Tags[11].ti_Tag := WA_Gadgets;
   Window_Tags[11].ti_Data:= LONG(gads[LLGad]);
   Window_Tags[12].ti_Tag := WA_SimpleRefresh;
   Window_Tags[12].ti_Data:= True_;
   Window_Tags[13].ti_Tag := WA_RMBTrap;
   Window_Tags[13].ti_Data:= True_;
   Window_Tags[14].ti_Tag := WA_PubScreenName;
   Window_Tags[14].ti_Data:= LONG(@pubname[1]);
   Window_Tags[15].ti_Tag := WA_PubScreenFallBack;
   Window_Tags[15].ti_Data:= True_; 
 	Window_Tags[16].ti_Tag := WA_ScreenTitle;
   Window_Tags[16].ti_Data:= LONG(@Scr_Title[1]);
   Window_Tags[17].ti_Tag := TAG_DONE;
   
   TheWindow := OpenWindowTaglist(NIL,@Window_Tags);
   If TheWindow = NIL Then 
   	ErrExit('Failed to create window'#0, 206);
   setupbevelboxes;
   displaybevelboxes;   
   GT_RefreshWindow(TheWindow, NIL);
   
   If pubname = 'error' Then UnlockPubScreen(NIL, screendef)
   Else UnlockPubScreen(@PubName[1], screendef);
End;

{ ===================================================================== }

Procedure Close_Libs;   { close all opened libs }

Begin
   CloseLibrary(pLibrary(IntuitionBase));
   CloseLibrary(pLibrary(GadtoolsBase));
End;

{ ===================================================================== }

Procedure Close_Window;

Begin
   CloseWindow(TheWindow);       { close window and free gadgets and }
   FreeGadgets(gads[LLGad]);     { visualinfo                        }
   FreeVisualInfo(VisualInf);
End;

{ ===================================================================== }


{ ===================================================================== }
Procedure HandleIDCMP;

Type
	strarray = Array[1..3] Of string;
	Tag2     = Array[0..1] Of tTagItem;
	
Const
   exitflag : Boolean  = False;
   small    : Boolean  = False;
   NumStrs  : shortint = 3;
   
Var dummy     : longint;           { the main loop of the program. }
   defnumTag  : tag2;              { monitors IDCMP messages and   }
   message    : pIntuiMessage;     { responds as appropriate       }
   MsgClass   : LongInt;
   MsgCode    : Word;
   gadcode    : pGadget;
   out        : strarray;
   clearblock : tImage;
   outformat  : tIntuiText;
   d, a ,b,
   c, a2      : Extended; { real }
   StrInfo    : pStringInfo;
   tempint    : Array[1..4] Of longint;
   OKRes      : boolean;
	AboutReq   : array [0..9] of tIntuiText;  { Texts for "About" requester }
	AboutReqOk : tIntuiText;                   { "Ok" in "About" requester }
	AboutStrs  : array[0..9] of string;
	i          : byte;
	
	{ MidMoose change check start ***** }
   qual : LONG;
   { END **** }

{ ==== }
Procedure CalcDundA2(Var a,b,c,a2,d : Real);      

Begin
   a2 := 2*a;
   d := Sqr(b) - 4*a*c;       { calculate discriminate, the core of the program } 
End;

{ ==== }

Procedure OneRoot(c,b : Real; Var result : strarray; Var choices : shortint);

Var
   numstr : string;
   
Begin
   str((-c/b):10:4, numstr);
   result[1] := 'One root at ' + numstr + #0;
   choices := 1;
End;

{ ==== }

Procedure EqualRoots(b,a2 : Real; Var result : strarray; Var choice : shortint);

Var
   numstr : string;
   
Begin
   str((-b/a2):10:4, numstr);
   result[1] := 'Repeated (equal) roots at '#0;
   result[2] := '    ' + numstr + #0;
   choice := 2;
End;

{ ==== }

Procedure RealRoots(b,a2,d : Real; Var result : strarray; Var choice : shortint);

Var
   numstr, numstr2 : string;
   
Begin
   str(((-b+Sqrt(d))/a2):10:4, numstr);
   str(((-b-sqrt(d))/a2):10:4, numstr2);
   result[1] := 'Real roots at ' + numstr + #0;
   result[2] := 'and           ' + numstr2 + #0;
   choice := 2;
End;

{ ==== }

Procedure ImaginaryRoots(b,d,a2 : Real; Var result : strarray; Var choice : shortint);

Var
   numstr, numstr2, numstr3 : string;
   
Begin
   str((-b/a2):10:4, numstr);
   str((Sqrt(-d)/a2):10:4, numstr2);
   str((-sqrt(-d)/a2):10:4, numstr3);
   result[1] := 'Imaginary roots at ' + #0;
   result[2] := '    ' + numstr + numstr2 + #0;
   result[3] := 'and ' + numstr + numstr3 + #0;
   choice := 3;
End;

{ ==== }

Procedure printtext(Var strings : strarray; choice : shortint);

Var
	Temp, n : shortint;
   y       : Integer;
   
Begin
   DrawImage(TheWindow^.RPort, @clearblock, 0, 0);
   For n := 1 To choice Do Begin
      y := (Sizes[XSze] * (n-1) + (n * 2));
      outformat.Itext := @strings[n,1];
      PrintIText(TheWindow^.RPort, @outformat, 4, y);  
   End;
End;  

{ ==== }

Procedure CheckNum(Var num : Real; Var gadg : pGadget; 
               tags : tag2; strpointer : pointer);
               
Var
   tempstr : string;
   temp    : Real;
   errornum: Integer;
   
Begin
   tempstr := PtrToPas(StrPointer);
   Val(tempstr, temp, errornum);
   If errornum <> 0 Then Begin
      GT_SetGadgetAttrsA(gadg, TheWindow, NIL, @tags);
      num := 1;
      DisplayBeep(NIL);
   End Else 
      num := temp;
End;

Procedure CalcLoop;
begin
	StrInfo := Gads[CCGad]^.NextGadget^.SpecialInfo;
	CheckNum(a, Gads[STRGad_A], defnumtag, strinfo^.buffer);
	StrInfo := Gads[CCGad]^.NextGadget^.NextGadget^.SpecialInfo;
	CheckNum(b, Gads[STRGad_B], defnumtag, strinfo^.buffer);
	StrInfo := Gads[CCGad]^.NextGadget^.NextGadget^.NextGadget^.SpecialInfo;
	CheckNum(c, Gads[STRGad_C], defnumtag, strinfo^.buffer);
	CalcDundA2(a,b,c,a2,d);
	If a = 0 Then Begin
		oneroot(c,b,out, NumStrs);
		Printtext(out,NumStrs); 
	End Else Begin
		If d = 0 Then Begin
			equalroots(b,a2,out,NumStrs);
			Printtext(out,NumStrs); 
		End Else Begin
			If d > 0 Then Begin
				realroots(b,a2,d,out,numstrs);
				Printtext(out,NumStrs);
			End Else Begin 
				imaginaryroots(b,d,a2,out,numstrs);
				Printtext(out,NumStrs);
			End; {else}
		End; {else}
	End; {else}
End; 


Begin
	AboutStrs[0] := 'DQua version 1.2 (06.09.94)'#0;
	AboutStrs[1] := 'Written by Lee Kindness '#0;
	AboutStrs[2] := 'using Highspeed Pascal.'#0;
	AboutStrs[3] := ''#0;
	AboutStrs[4] := 'Comments to :'#0;
	AboutStrs[5] := '8 Craigmarn Rd.'#0;
	AboutStrs[6] := 'Portlethen Village'#0;
	AboutStrs[7] := 'ABERDEEN AB1 4QR'#0;
	AboutStrs[8] := 'SCOTLAND'#0;
	AboutStrs[9] := 'Resume'#0;
	
	for i := 0 to 9 do
    with AboutReq[i] do begin
      FrontPen  := 0;
      BackPen   := 1;
      DrawMode  := JAM1;
      LeftEdge  := 0;
      TopEdge   := (Sizes[XSze] * i) + 0;
      ITextFont := @My_Font;
      IText     := @AboutStrs[i,1];
      if i < 8 then NextText  := @AboutReq[i+1] else NextText := NIL
    end;
	with AboutReqOk do begin
    FrontPen  := 0;
    BackPen   := 1;
    DrawMode  := JAM1;
    LeftEdge  := 0;                     { Position relative to gadget }
    TopEdge   := 0;
    ITextFont := @My_Font;
    IText     := @AboutStrs[9,1];
    NextText  := NIL
  end;
  
   With outformat Do Begin
      FrontPen := 1;
      DrawMode := JAM1;
      LeftEdge := Sizes[BB_L];
      TopEdge  := Sizes[TBS] + 4 + Sizes[EqBB_H];
      ITextFont:= @My_Font;
      IText    := NIL;
      NextText := NIL;
   End;
   With clearblock Do Begin
      LeftEdge   := Sizes[BB_L] + Sizes[BorLeft];
      TopEdge    := Sizes[TBS] + 4 + Sizes[EqBB_H] + Sizes[BorTop];
      Width      := Sizes[BB_W] - Sizes[BorLeft] - Sizes[BorRight];
      Height     := Sizes[DispBB_H] - Sizes[BorBottom] - Sizes[BorTop];
      Depth      := 0;
      ImageData  := NIL;
      PlanePick  := 0;
      PlaneOnOff := 0;
      NextImage  := NIL;
   End;
   out[1] := '                              '#0;
   out[2] := '                              '#0;
   out[3] := '                              '#0;
   defnumtag[0].ti_Tag  := GTST_String;
   defnumtag[0].ti_Data := LONG(@defnum[1]);
   defnumtag[1].ti_Tag  := TAG_END;
   tempint[4] := TheWindow^.Height;
   While Not exitflag Do Begin
      dummy    := Wait(BitMask(TheWindow^.UserPort^.MP_SIGBIT));
      message  := GT_GetIMsg(TheWindow^.userPort);
      while message <> NIL do begin
      	MsgClass := message^.Class;
      	MsgCode  := message^.Code;
      	GadCode  := pGadget(message^.IAddress);      	
      	
      	{ MidMoose change check start ***** }
      	qual := message^.Qualifier;
      	{ END **** }
      				
     		GT_ReplyIMsg(message);
      	Case MsgClass Of
      	
         	IDCMP_REFRESHWINDOW : Begin
            	GT_BeginRefresh(TheWindow);
            	Printtext(out,NumStrs);
            	displaybevelboxes;
            	GT_EndRefresh(TheWindow, True);
         	End;
         	
         	IDCMP_MOUSEBUTTONS : Begin
      			Case MsgCode Of
      				
      				MENUUP : Begin
      					tempint[1] := TheWindow^.LeftEdge;
    	 	 				tempint[2] := TheWindow^.TopEdge;
     		 				tempint[3] := TheWindow^.Width;
     		 				If Small Then Begin
      						ChangeWindowBox(TheWindow, tempint[1], tempint[2], tempint[3], Tempint[4]);
      						Small := False;
      					End Else Begin
      						ChangeWindowBox(TheWindow, tempint[1], tempint[2], tempint[3], Sizes[TBS]);
      						Small := True;
      					End;
      				End;
      			End;
      		End;
      		
         	IDCMP_CLOSEWINDOW : exitflag := True;
         	
         	IDCMP_GADGETUP : Begin
         			StrInfo  := gadcode^.SpecialInfo;
            	Case gadcode^.GadgetID Of
               	STRGad_A : Begin
                  	CheckNum(a, Gads[STRGad_A], defnumtag, strinfo^.buffer);
                  	OKRes := ActivateGadget(Gads[STRGad_B], TheWindow, NIL);
               	End;
               	STRGad_B : Begin
                  	CheckNum(b, Gads[STRGad_B], defnumtag, strinfo^.buffer);
                  	OKRes := ActivateGadget(Gads[STRGad_C], TheWindow, NIL);
               	End;
               	STRGad_C : Begin
                  	CheckNum(c, Gads[STRGad_C], defnumtag, strinfo^.buffer);
                  	OKRes := ActivateGadget(Gads[STRGad_A], TheWindow, NIL);
               	End;
               	BUTGad_S : CalcLoop;
               	Abt_Gad  : OKRes := AutoRequest(TheWindow, @AboutReq[0], NIL, @AboutReqOk, 0, 0, 320, 155);
            	End; {case}
            end;
            
            IDCMP_VANILLAKEY : begin
            	case chr(msgcode) of
            		'S','s' : CalcLoop;
            		'A','a' : OKRes := ActivateGadget(Gads[STRGad_A], TheWindow, NIL);
            		'B','b' : OKRes := ActivateGadget(Gads[STRGad_B], TheWindow, NIL);
            		'C','c' : OKRes := ActivateGadget(Gads[STRGad_C], TheWindow, NIL);
            		'/','?' : OKRes := AutoRequest(TheWindow, @AboutReq[0], NIL, @AboutReqOk, 0, 0, 0, 0);
            end;
            end; 
         End; {case}
				message  := GT_GetIMsg(TheWindow^.userPort);
      End;
   End; {while}
End;
{ ==== Main Procedure ================================================= }

Procedure main;

Begin
   Open_Libs;
   Open_Window;
   HandleIDCMP;
   close_Window;
   Close_Libs;
End;

{ =================================================================== }

Begin
main
End.

      
      
