Program MacCash;

Uses
	Exec, Intuition, Graphics, AmigaPrinter, GadTools, CStrConstPtr, Amiga,
	Utility, DiskFont, AmigaDos, Icon, Workbench, 
	GenerateLotteryNums, EnableDisableWindow;
	
Const
	G_CC  =  0; { Gadget ids }
	G_BLV =  1;
	G_N1  =  2;
	G_N2  =  3;
	G_N3  =  4;
	G_N4  =  5;
	G_N5  =  6;
	G_N6  =  7;
	G_NW  =  8;
	G_RB  =  9;
	G_RA  = 10;
	G_CB  = 11;
	G_CA  = 12;
	G_ST  = 13;
	G_NI  = 14;
	
	{ menu ids }
	M_PN   = 1;
	M_INFO = 2;
	M_QUIT = 3;
	
	BM_WID =  123;
	BM_LEN =  195;
	PR_WID = 3250;
	PR_LEN = 4937;
	
	ves : String[29] = '$VER: MacCash 1.3 (09.07.95)'#0;
	
	BoardNamesA : Array[1..NUM_BOARDS] of String[7] = ('Board A',
	                                                   'Board B',
	                                                   'Board C',
	                                                   'Board D',
	                                                   'Board E',
	                                                   'Board F',
	                                                   'Board G');
	
Type
	tProgVars = Record
		arg_ps : String;
	End;
	GadA = Array[G_CC..G_NI] of pGadget;
	tNumInfo = Record
		ni_Mean,
		ni_Median,
		ni_Variance,
		ni_SD,
		ni_Range,
		ni_IQR : String[20];
	End;
	
{$I ToolType.PAS}
	
Var
	font     : tTextAttr;
	txtfont  : pTextFont;
	lvlabs   : Array[0..NUM_BOARDS] of STRPTR;
	weeklabs : Array[0..8] of STRPTR;
	lvlist   : pList;
	
(*****************************************************************************
 * A little routine to fill in the members of a NewMenu struct
 *
 * Cheat & use a bit of assembler to get direct access to the embedded
 * string constants
 *)
procedure nm(var mnm: tNewMenu;
	nmType: byte;
	nmLabel: string;
	nmCommKey: string;
	nmFlags: word;
	nmMutualExclude: longint;
	nmUserData: LONG); assembler;
asm
	move.l	mnm,a0                                    { address of the element }
	move.b	nmType,tNewMenu.nm_Type(a0)                        { copy the type }

	move.l	nmLabel,a1                      { the address of the Pascal string }
	tst.b	(a1)+                     { check for zero length & skip length byte }
	bne		@1                                      { if not zero, nothing to do }
	move.l	#NM_BARLABEL,a1              { substitute empty strings with a bar }
@1:	move.l	a1,tNewMenu.nm_Label(a0)                    { store the C string }

	move.l	nmCommKey,a1                                { same for the CommKey }
	tst.b	(a1)+
	bne		@2
	suba.l	a1,a1                                { use nil if the empty string }
@2:	move.l	a1,tNewMenu.nm_CommKey(a0)
                                                      { the remaining fields }
	move.w	nmFlags,tNewMenu.nm_Flags(a0)
	move.l	nmMutualExclude,tNewMenu.nm_MutualExclude(a0)
	move.l	nmUserData,tNewMenu.nm_UserData(a0)
end;

(****************************************************************************)
Function OpenMainWindow(VAR Args : tProgVars; 
                        VAR vi   : Pointer;
                        VAR G    : GadA;
                        VAR rk   : pRemember;
                        VAR b    : tBoards;
                        VAR ms   : pMenu) : pWindow;

CONST
	XSPACE =  8; { Horizontal space between gadgets }
	YSPACE =  4; { Vertical spacing between gadgets }
	S_TBS  =  0;
	S_CW   =  1;
	S_LB   =  2;
	S_GH   =  3;
	
VAR
	t      : Array[0..20] of LONG;     { tags                         }
	m      : Array[0..10] of tNewMenu; { for init. of menu            }
	screen : pScreen;                  { the screen we are opening on }
	w      : pWindow;                  { the window we are creating   }
	ng     : tNewGadget;               { to setup gadgets             }
	S      : Array[0..3] of LONG;      { various sizes                }
	n      : Integer;
	nd     : pNode;
	ts     : String;
	mm     : Array[0..5] of tNewMenu;
	ok     : Boolean;
	
Begin
	w := NIL;
	
	{ init menus }
	nm(mm[0], NM_TITLE, 'Project'#0, '', 0, 0, 0);
	nm(mm[1], NM_ITEM , 'Print Numbers'#0, 'N'#0, 0, 0, M_PN);
	nm(mm[2], NM_ITEM , 'About...'#0, '?'#0, 0, 0, M_INFO);
	nm(mm[3], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[4], NM_ITEM , 'Quit'#0, 'Q'#0, 0, 0, M_QUIT);
	nm(mm[5], NM_END , '', '', 0, 0, 0);

	{ Lock the screen }
	If Args.arg_ps = '' then
		screen := LockPubScreen(NIL)
	else begin
		Args.arg_ps := Args.arg_ps + #0;
		screen := LockPubScreen(@Args.arg_ps[1]);
		If Screen = NIL then
			screen := LockPubScreen(NIL);
	End;
	If screen <> NIL then begin
		{ Get visual info }
		vi := GetVisualInfoA(screen, NIL);
		If vi <> NIL Then begin
			{ create context }
			G[G_NI] := NIL;
			G[G_CC] := CreateContext(@G[G_NI]);
			If G[G_CC] <> NIL Then begin
				
				forbid;
				{ convert textfont to a textattr }
				With font, GfxBase^.DefaultFont^ do begin
					ta_Name  := CSCPAR(@rk, PtrToPas(tf_Message.mn_Node.ln_Name));
					ta_YSize := tf_YSize;
					ta_Style := tf_Style;
					ta_Flags := tf_Flags;
				End;
				permit;
				txtfont := OpenDiskFont(@font);
				
				{ Get some size info }
				{ size of top border }
				S[S_TBS] := screen^.WBorTop + screen^.Font^.ta_YSize + 1;
				{ pixel width of a character, were using the default monospace font }
				{ it is far to much hastle to ude the screen font }
				S[S_CW] := TxtFont^.tf_XSize;
				{ primary gadget height }
				S[S_GH] := TxtFont^.tf_YSize + 4;
				{ left border size }
				S[S_LB] := screen^.WBorLeft;

				{ Make the gadgets }
				With ng do begin
					ng_LeftEdge   := S[S_LB] + XSPACE;
					ng_TopEdge    := S[S_TBS] + YSPACE;
					ng_Width      := S[S_CW] * 7 * NUM_NUMS;
					ng_Height     := ((S[S_GH] - 4) * (NUM_BOARDS+1)) + 4;
					ng_GadgetText := NIL{CSCPAR(@rk, 'Boards')};
					ng_TextAttr   := @font;
					ng_GadgetID   := G_BLV;
					ng_Flags      := 0;
					ng_VisualInfo := vi;
					ng_UserData   := NIL;
				End;
				ts := '    0   0   0   0   0   0';
				For n := 1 To NUM_BOARDS Do Begin
					lvlabs[n-1] := CSCPAR(@rk, BoardNamesA[n] + ts);
				End;
				lvlist := AllocRemember(@rk, Sizeof(tList), MEMF_CLEAR);
				if lvlist = NIL then Halt;
				NewList(lvlist);
				For n := 0 to NUM_BOARDS-1 do begin
					nd := AllocRemember(@rk, Sizeof(tNode), MEMF_CLEAR);
					if nd <> NIL then begin
						nd^.ln_Name := lvlabs[n];
						AddTail(lvlist, nd);
					End;
				End;
				t[0] := GTLV_Labels;
				t[1] := LONG(lvlist);
				t[2] := GTLV_ShowSelected;
				t[3] := 0;
				t[4] := GTLV_Selected;
				t[5] := 0;
				t[6] := TAG_END;
				G[ng.ng_GadgetID] := CreateGadgetA(LISTVIEW_KIND, G[ng.ng_GadgetID-1], @ng, @t); 
				
				With ng do begin	
					ng_TopEdge := ng_TopEdge + ng_Height + YSPACE;
					If GadToolsBase^.lib_Version < 39 then
						ng_TopEdge := ng_TopEdge + S[S_GH];
					ng_Width := S[S_CW] * 7;
					ng_Height := S[S_GH];
					ng_GadgetText := NIL; 
				End;
				t[0] := GTIN_MaxChars;
				t[1] := 2;
				t[2] := STRINGA_Justification;
				t[3] := GACT_STRINGCENTER;
				t[4] := STRINGA_ReplaceMode;
				t[5] := False_;
				t[6] := TAG_END;
				For n := G_N1 to G_N6 do begin
					ng.ng_GadgetID := n;
					ng.ng_UserData := Pointer(n - G_N1 + 1);
					G[ng.ng_GadgetID] := CreateGadgetA(INTEGER_KIND, G[ng.ng_GadgetID-1], @ng, @t);
					With ng do
						ng_LeftEdge := ng_LeftEdge + ng_Width;
				End;
				
				weeklabs[0] := CSCPAR(@rk, '1');
				weeklabs[1] := CSCPAR(@rk, '2');
				weeklabs[2] := CSCPAR(@rk, '3');
				weeklabs[3] := CSCPAR(@rk, '4');
				weeklabs[4] := CSCPAR(@rk, '5');
				weeklabs[5] := CSCPAR(@rk, '6');
				weeklabs[6] := CSCPAR(@rk, '7');
				weeklabs[7] := CSCPAR(@rk, '8');
				weeklabs[8] := NIL;
				t[0] := GTCY_Labels;
				t[1] := LONG(@weeklabs);
				t[2] := TAG_END;
				With ng do begin
					ng_TopEdge    := ng_TopEdge + S[S_GH] + YSPACE;
					ng_LeftEdge   := S[S_LB] + XSPACE + (17 * S[S_CW]);
					ng_Width      := (S[S_CW] * 7 * NUM_NUMS) - (17 * S[S_CW]);
					ng_GadgetText := CSCPAR(@rk, 'Number of Draws');
					ng_Flags      := PLACETEXT_LEFT;
					ng_GadgetID   := G_NW;
				End;
				G[ng.ng_GadgetID] := CreateGadgetA(CYCLE_KIND, G[ng.ng_GadgetID-1], @ng, @t);
				
				With ng do begin
					ng_TopEdge    := S[S_TBS] + YSPACE;
					ng_Height     := (G[ng_GadgetID]^.TopEdge + G[ng_GadgetID]^.Height - 
					                 ng_TopEdge - (4 * YSPACE)) div 5;
					ng_LeftEdge   := ng_LeftEdge + ng_Width + XSPACE;
					ng_Width      := S[S_CW] * 25;
					ng_GadgetText := CSCPAR(@rk, 'Random Current Board');
					ng_Flags      := 0;
					ng_GadgetID   := G_RB;
				End;
				G[ng.ng_GadgetID] := CreateGadgetA(BUTTON_KIND, G[ng.ng_GadgetID-1], @ng, NIL);
				
				With ng do begin
					ng_TopEdge    := ng_TopEdge + ng_Height + YSPACE;
					ng_GadgetText := CSCPAR(@rk, 'Random All Boards');
					ng_GadgetID   := G_RA;
				End;
				G[ng.ng_GadgetID] := CreateGadgetA(BUTTON_KIND, G[ng.ng_GadgetID-1], @ng, NIL);
				
				With ng do begin
					ng_TopEdge    := ng_TopEdge + ng_Height + YSPACE;
					ng_GadgetText := CSCPAR(@rk, 'Clear Current Board');
					ng_GadgetID   := G_CB;
				End;
				G[ng.ng_GadgetID] := CreateGadgetA(BUTTON_KIND, G[ng.ng_GadgetID-1], @ng, NIL);

				With ng do begin
					ng_TopEdge    := ng_TopEdge + ng_Height + YSPACE;
					ng_GadgetText := CSCPAR(@rk, 'Clear All Boards');
					ng_GadgetID   := G_CA;
				End;
				G[ng.ng_GadgetID] := CreateGadgetA(BUTTON_KIND, G[ng.ng_GadgetID-1], @ng, NIL);
				
				With ng do begin
					ng_TopEdge    := ng_TopEdge + ng_Height + YSPACE;
					ng_GadgetText := CSCPAR(@rk, 'Statistics for Board');
					ng_GadgetID   := G_ST;
				End;
				G[ng.ng_GadgetID] := CreateGadgetA(BUTTON_KIND, G[ng.ng_GadgetID-1], @ng, NIL);

				If G[G_NI] <> NIL then begin
					t[ 0] := WA_Left;
					t[ 1] := 40;
					t[ 2] := WA_Top;
					t[ 3] := 20;
					t[ 4] := WA_InnerWidth;
					t[ 5] := ng.ng_LeftEdge + ng.ng_Width + XSPACE - S[S_LB];
					t[ 6] := WA_InnerHeight;
					t[ 7] := G[G_NW]^.TopEdge + G[G_NW]^.Height + YSPACE - S[S_TBS];
					t[ 8] := WA_Flags;
					t[ 9] := WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_ACTIVATE
					         |WFLG_SIMPLE_REFRESH|WFLG_NEWLOOKMENUS;
					t[10] := WA_Gadgets;
					t[11] := LONG(G[G_NI]);
					t[12] := WA_PubScreen;
					t[13] := LONG(screen);
					t[14] := WA_IDCMP;
					t[15] := LISTVIEWIDCMP|INTEGERIDCMP|IDCMP_CLOSEWINDOW|
					         IDCMP_MENUPICK|IDCMP_REFRESHWINDOW;
					t[16] := WA_Title;
					t[17] := LONG(CSCPAR(@rk, 'MacCash -- Generate and Print UK Lottery Numbers'));
					t[18] := WA_ScreenTitle;
					t[19] := LONG(CSCPAR(@rk, 'MacCash ©Lee Kindness'));
					t[20] := TAG_END;
					w := OpenWindowTagList(NIL, @t);
					If w <> NIL then begin
						ms := CreateMenusA(@mm, NIL);
						if ms <> NIL then begin
							t[0] := GTMN_NewLookMenus;
							t[1] := True_;
							t[2] := TAG_END;
							if LayoutMenusA(ms,vi,@t) then
								OK := SetMenuStrip(w,ms);
						End;
						GT_RefreshWindow(w, NIL);
					End;
				End;
			End;
		End;
		UnLockPubScreen(NIL, Screen);
	End;
	{ Return result }
	OpenMainWindow := w;
End {OpenMainWindow};

(****************************************************************************)
Procedure CloseMainWindow(VAR w  : pWindow; 
                          VAR vi : Pointer;
                          VAR G  : GadA;
                          VAR ms : pMenu);

Begin
	if ms <> NIL then begin
		ClearMenuStrip(w);
		FreeMenus(ms);
		ms := NIL;
	end;
	CloseWindow(w);
	w := NIL;
	FreeGadgets(G[G_NI]);
	FreeVisualInfo(vi);
	vi := NIL;
	CloseFont(txtFont);
End;

(****************************************************************************)
Procedure AttachObjectList(VAR g    : pGadget;
                           VAR w    : pWindow;
                           VAR list : pList);

VAR 
	t : array[0..2] of LONG;

begin
	t[0] := GTLV_Labels;
	t[1] := LONG(List);
	t[2] := TAG_END;
	GT_SetGadgetAttrsA(g, w, NIL, @t);
end;

(****************************************************************************)
Procedure DetachObjectList(VAR g    : pGadget;
                           VAR w    : pWindow;
                           VAR list : pList);

VAR 
	t : array[0..2] of LONG;

begin
	t[0] := GTLV_Labels;
	t[0] := -1;
	t[1] := TAG_END;
	GT_SetGadgetAttrsA(g, w, NIL, @t);
end;


(****************************************************************************)
Procedure GetInfo(VAR b : tBoard;
                  VAR i : tNumInfo);
Var
	sumx, sumx2,
	Mean, Median,
	Variance, SD,
	Range, IQR : Real;
	n          : Integer;
	                  
Begin
	sumx := 0;
	sumx2 := 0;
	For n := 1 to NUM_NUMS do begin
		sumx := sumx + b[n];
		sumx2 := sumx2 + sqr(b[n]);
	End;
	
	Mean := sumx / NUM_NUMS;
	Median := (b[3] + b[4]) / 2;
	Variance := (sumx2 - (sqr(sumx) / NUM_NUMS)) / (NUM_NUMS - 1);
	SD := sqrt(Variance);
	Range := b[6] - b[1];
	IQR := (b[5] + ((b[6] - b[5]) * 0.75)) - (b[1] + ((b[2] - b[1]) * 0.75));
	
	Str(Mean:0:3, i.ni_Mean);
	Str(Median:0:3, i.ni_Median);
	Str(Variance:0:3, i.ni_Variance);
	Str(SD:0:3, i.ni_SD);
	Str(Range:0:3, i.ni_Range);
	Str(IQR:0:3, i.ni_IQR);
	
	i.ni_Mean := i.ni_Mean + #0;
	i.ni_Median := i.ni_Median + #0;
	i.ni_Variance := i.ni_Variance + #0;
	i.ni_SD := i.ni_SD + #0;
	i.ni_Range := i.ni_Range + #0;
	i.ni_IQR := i.ni_IQR + #0;
End;

(****************************************************************************)
Procedure FormatNodeName(    node   : pNode;
                         VAR b      : tBoard;
                             ord    : Integer;
                         VAR rk     : pRemember);
                         
Var
	ts, 
	ts2 : String;
	n   : Integer;
	
Begin
	ts := BoardNamesA[ord] + ' ';
	For n := 1 to NUM_NUMS do begin
		Str(b[n]:2, ts2);
		ts := ts + '  ' + ts2;
	End;
	node^.ln_Name := CSCPAR(@rk, ts);
End;

(****************************************************************************)
Procedure ShowInfo(VAR b   : tBoards;
                       ord : Integer;
                   VAR w   : pWindow;
                   VAR rk  : pRemember);
                   
Var
	y  : LONG;
	ez : pEasyStruct;
	i  : tNumInfo;
	n  : tNode;
	al : Array[1..7] Of STRPTR;
                   
Begin
	ez := AllocVec(Sizeof(tEasyStruct), MEMF_CLEAR);
	if ez <> NIL then begin
		GetInfo(b.bo_Nums[ord], i);
		FormatNodeName(@n, b.bo_Nums[ord], ord, rk);
		With ez^ do begin
			es_StructSize := Sizeof(tEasyStruct);
			es_Title := CSCPAR(@rk, 'Board Statistics');
			es_TextFormat := CSCPAR(@rk, 
			   '%s'#10#10+
			   'Mean : %s'#10+
			   'Median : %s'#10+
			   'Variance : %s'#10+
			   'Standard deviation : %s'#10+
			   'Range : %s'#10+
			   'Interquartile Range : %s'#10);
			es_GadgetFormat := CSCPAR(@rk, 'Ok');
		End;
		al[1] := n.ln_Name;
		al[2] := @i.ni_Mean[1];
		al[3] := @i.ni_Median[1];
		al[4] := @i.ni_Variance[1];
		al[5] := @i.ni_SD[1];
		al[6] := @i.ni_Range[1];
		al[7] := @i.ni_IQR[1];
		y := EasyRequestArgs(w, ez, NIL, @al);
		FreeVec(ez);
	End;
End;
		

(****************************************************************************)
Procedure Handle_RandomBoard(VAR g      : pGadget;
                             VAR w      : pWindow;
                             VAR list   : pList;
                             VAR ord    : LONG;
                             VAR b      : tBoard;
                             VAR rk     : pRemember);

Var
	node : pNode;
	n    : Integer;
	
begin
	DetachObjectList(g, w, list);
	node := list^.lh_Head;
	For n := 2 to ord do 
		node := node^.ln_Succ;
	RandomBoard(b);
	FormatNodeName(node, b, ord, rk);
	AttachObjectList(g, w, list);
End;

(****************************************************************************)
Procedure Handle_ClearBoard(VAR g      : pGadget;
                            VAR w      : pWindow;
                            VAR list   : pList;
                            VAR ord    : LONG;
                            VAR b  : tBoard;
                            VAR rk : pRemember);

Var
	node : pNode;
	n    : Integer;
	
begin
	DetachObjectList(g, w, list);
	node := list^.lh_Head;
	For n := 2 to ord do 
		node := node^.ln_Succ;
	ClearBoard(b);
	FormatNodeName(node, b, ord, rk);
	AttachObjectList(g, w, list);
End;

(****************************************************************************)
Procedure Handle_InfoMenu(VAR w  : pWindow;
                          VAR rk : pRemember);

Var
	ez : pEasyStruct;
	y  : LONG;
	al : Array[0..1] of LONG;
	
Begin
	ez := AllocRemember(@rk, Sizeof(tEasyStruct), MEMF_CLEAR);
	if ez <> NIL then begin
		With ez^ do begin
			es_StructSize :=  Sizeof(tEasyStruct);
			es_Title := CSCPAR(@rk, 'MacCash Information');
			es_TextFormat := CSCPAR(@rk,
			 'MacCash Copyright ©Lee Kindness.'#10+
			 '%s'#10+
			 ''#10+
			 'Run out of birthdays? Use MacCash to Generate your numbers...'#10+
			 'Read "MacCash.doc" for more information'#10+
			 ''#10+
			 'Comments to:'#10+
			 ' Lee Kindness'#10+
			 ' 8 Craigmarn Road'#10+
			 ' Portlethen Village'#10+
			 ' Aberdeen AB1 4QR'#10+
			 ' SCOTLAND'#10#10+
			 '%s'#10);
			es_GadgetFormat := CSCPAR(@rk, 'Ok');
		End;
		al[0] := LONG(@ves[6]);
		al[1] := LONG(CSCPAR(@rk, 'wangi@fido.zetnet.co.uk'));
		y := EasyRequestArgs(w, ez, NIL, @al);
	End;
End;


(****************************************************************************)
Function WriteString(VAR f : BPTR; 
                     s     : String) : Boolean;
VAR
	err : LONG;
	
begin
	S := S+#10+#0; { add EOL and null term. }
	err := FPuts(f,@s[1]);
	if err = 0 then
		WriteString := True
	else
		WriteString := False;
End;


(****************************************************************************)
Procedure Handle_PrintNumbers(VAR w    : pWindow;
                              VAR b    : tBoards;
                              VAR list : pList;
                              VAR rk   : pRemember);

Var
	node    : pNode;
	out     : BPTR;
	Ok, Ok2 : Boolean;
	n       : LONG;
	ez      : pEasyStruct;
	s       : String[20];
	
Begin
	Ok := False;
	out := Open(CSCPAR(@rk, 'PRT:'), MODE_NEWFILE);
	if Out <> NULL then begin
		If WriteString(out, 'Lottery Numbers, generated by MacCash (c)Lee Kindness.') then begin
			if WriteString(out, '') then begin
				Ok := WriteString(out, '');
				Ok := WriteString(out, '');
				Ok := True;
				node := list^.lh_Head;
				n := 0;
				while (node^.ln_Succ <> NIL) and (Ok) do begin
					n := n + 1;
					If (b.bo_Nums[n,1] <> 0) and 
					   (b.bo_Nums[n,2] <> 0) and
					   (b.bo_Nums[n,3] <> 0) and
					   (b.bo_Nums[n,4] <> 0) and
					   (b.bo_Nums[n,5] <> 0) and
					   (b.bo_Nums[n,6] <> 0) then
						Ok := WriteString(out,PtrToPas(node^.ln_Name));
					node := node^.ln_Succ;
				End;
				Ok := WriteString(out, '');
				Str(b.bo_Weeks, s);
				s := 'For ' + s + ' draw(s)'; 
				Ok := WriteString(out, s);
			End;
		End;
		Ok2 := AmigaDos.Close_(out);
	End;
	If Ok = False then begin
		ez := AllocVec(Sizeof(tEasyStruct), MEMF_CLEAR);
		If ez <> NIL then begin
			with ez^ do begin
				es_StructSize :=  Sizeof(tEasyStruct);
				es_Title := CSCPAR(@rk, 'Shrub');
				es_TextFormat := CSCPAR(@rk,'Error Printing');
				es_GadgetFormat := CSCPAR(@rk,'Ok');
			End;
			n := EasyRequestArgs(w, ez, NIL, NIL);
			FreeVec(ez);
		End;
	End;
End;


(****************************************************************************)
Procedure Handle_IGadUpdate(VAR b    : tBoard;
                                ord  : Integer;
                            VAR w    : pWindow;
                            VAR G    : GadA;
                                list : pList;
                            VAR rk   : pRemember);
                          
Var
	t    : Array[1..3] Of LONG;
	n    : Integer;
	node : pNode;

Begin
	SortBoard(b);
	t[1] := GTIN_Number;
	t[3] := TAG_DONE;
	For n := 1 to NUM_NUMS do begin
		t[2] := b[n];
		GT_SetGadgetAttrsA(G[G_N1-1+n], w, NIL, @t);
	End;
	DetachObjectList(G[G_BLV], w, list);
	node := list^.lh_Head;
	For n := 2 to ord do 
		node := node^.ln_Succ;
	FormatNodeName(node, b, ord, rk);
	AttachObjectList(g[G_BLV], w, list);
End;


(****************************************************************************)
Procedure Handle_Events(VAR w  : pWindow; 
                        VAR b  : tBoards;
                        VAR G  : GadA;
                        VAR ms : pMenu;
                        VAR rk : pRemember);

Var
	msg      : pIntuiMessage;
	MsgClass, 
	MsgCode,
	dummy,
	blvord,
	n, j,
	GadID,
	lval,
	UData    : LONG;
	exitflag,
	Ok       : Boolean;
	key      : Pointer;
	item     : pMenuItem;
	
Begin
	blvord := 1;
	ExitFlag := False;
	While Not exitflag Do Begin
		dummy := Wait(BitMask(w^.UserPort^.MP_SIGBIT));
		msg   := GT_GetIMsg(w^.userPort);
		while msg <> NIL do begin
			MsgClass := msg^.Class;
			MsgCode  := msg^.Code;
			If MsgClass = IDCMP_GADGETUP Then begin
				GadID    := pGadget(msg^.IAddress)^.GadgetID;
				If GadID IN [G_N1, G_N2, G_N3, G_N4, G_N5, G_N6] Then Begin
					UData := LONG(pGadget(msg^.IAddress)^.UserData);
					lval  :=  pStringInfo(pGadget(msg^.IAddress)^.SpecialInfo)^.LongInt_;
				End;
			End;
			GT_ReplyIMsg(msg);
			Case MsgClass of
				IDCMP_CLOSEWINDOW : Exitflag := True;
				IDCMP_REFRESHWINDOW : Begin
					GT_BeginRefresh(w);
					GT_EndRefresh(w, True);
				End;
				IDCMP_MENUPICK : begin
					While (msgcode <> MENUNULL) do begin
						item := ItemAddress(ms, msgcode);
						Case LONG(GTMENUITEM_USERDATA(item)) of
							M_PN   : Begin
								key := DisableWindow(w);
								Handle_PrintNumbers(w, b ,lvlist, rk);
								EnableWindow(w, key);
							End;
							M_INFO : Begin
								key := DisableWindow(w);
								Handle_InfoMenu(w, rk);
								EnableWindow(w, key);
							End;
							M_QUIT : ExitFlag := True;
						End;
						msgcode := item^.NextSelect;
					End;
				End;
				IDCMP_GADGETUP : Case GadID of
					G_BLV : Begin
						blvord := msgcode + 1;
						Handle_IGadUpdate(b.bo_Nums[blvord], blvord, w, G, lvlist, rk);
					End;
					G_N1, G_N2, G_N3, G_N4, G_N5, G_N6 : Begin
						Ok := True;
						For n := 1 to NUM_NUMS do
						  	If b.bo_Nums[blvord,n] = Lval then ok := false;
						If (Lval > 0) And (Lval < 50) And Ok Then
							b.bo_Nums[blvord, UData] := Lval;
						Handle_IGadUpdate(b.bo_Nums[blvord], blvord, w, G, lvlist, rk);
					End;
					G_NW : b.bo_Weeks := msgcode + 1;
					G_RB : Begin
						key := DisableWindow(w);
						Handle_RandomBoard(G[G_BLV], w, lvlist, blvord, b.bo_Nums[blvord], rk);
						Handle_IGadUpdate(b.bo_Nums[blvord], blvord, w, G, lvlist, rk);
						EnableWindow(w, key);
					End;
					G_RA : Begin
						key := DisableWindow(w);
						For n := 1 to NUM_BOARDS do begin
							Handle_RandomBoard(G[G_BLV], w, lvlist, n, b.bo_Nums[n], rk);
							delay(1);
						End;
						Handle_IGadUpdate(b.bo_Nums[blvord], blvord, w, G, lvlist, rk);
						EnableWindow(w, key);
					End;
					G_CB : Begin
						key := DisableWindow(w); 
						Handle_ClearBoard(G[G_BLV], w, lvlist, blvord, b.bo_Nums[blvord], rk);
						Handle_IGadUpdate(b.bo_Nums[blvord], blvord, w, G, lvlist, rk);
						EnableWindow(w, key);
					End;
					G_CA : Begin
						key := DisableWindow(w); 
						For n := 1 to NUM_BOARDS do
							Handle_ClearBoard(G[G_BLV], w, lvlist, n, b.bo_Nums[n], rk);
						Handle_IGadUpdate(b.bo_Nums[blvord], blvord, w, G, lvlist, rk);
						EnableWindow(w, key);
					End;
					G_ST : Begin
						key := DisableWindow(w); 
						ShowInfo(b, blvord, w, rk); 
						EnableWindow(w, key);
					End;

				End;
			End;
			msg := GT_GetIMsg(w^.userPort);
		End;
	End;
End;

(****************************************************************************)
Function Open_Libraries : Boolean;

Begin
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',36));
	GadToolsBase  := OpenLibrary('gadtools.library',36);
	GfxBase       := pGfxBase(OpenLibrary('graphics.library',0));
	DiskFontBase  := OpenLibrary('diskfont.library',0);
	IconBase      := OpenLibrary('icon.library',0);
	If (IntuitionBase <> NIL) and
	   (GadToolsBase <> NIL) and
	   (GfxBase <> NIL) and
	   (DiskFontBase <> NIL) and
	   (IconBase <> NIL) Then 
		Open_Libraries := True
	Else
		Open_Libraries := False;
End;

(****************************************************************************)
Procedure Close_Libraries;

Begin
	CloseLibrary(pLibrary(IconBase));
	CloseLibrary(pLibrary(DiskFontBase));
	CloseLibrary(pLibrary(GfxBase));
	CloseLibrary(pLibrary(GadToolsBase));
	CloseLibrary(pLibrary(IntuitionBase));
End;
	
Procedure Main;

Var
	V  : tProgVars;
	G  : GadA;
	w  : pWindow;
	rk : pRemember;
	vi : Pointer;
	b  : tBoards;
	ms : pMenu;
	
Begin
	rk := NIL;
	If Open_Libraries then begin
		InitGLN;
		ClearBoards(b);
		GetToolTypes(V);
		w := OpenMainWindow(V, vi, G, rk, b, ms);
		If w <> NIL then begin
			Handle_Events(w, b, G, ms, rk);
			CloseMainWindow(w, vi, G, ms);
		End;
	FreeRemember(@rk, True);
	Close_Libraries;
	End;
End {MacCash};

Begin main End.