USES Intuition, Exec, Amiga, AmigaDOS, Graphics, Gadtools, Utility;

{$F-,I-,R-,S-,V-,M 4,1,2,15}

TYPE
	pPSNode = ^tPSNode;
	tPSNode = Record
		ps_succ, ps_pred : pPSNode;
		Pad1 : byte;
		Pad2 : shortint;
		ps_Name : STRPTR;
	end;

VAR
	node       : pPSNode;
	RDArgs     : pRDArgs;
	popset, 
	shanset, OK: Boolean;
	buf, front : string[140];
	
Const 
	Head       : String[10]    = 'Publican'#0;
	Version    : String[24] = 'Publican 1.6 (01.10.94)'#0;
	ScreenList : pList = NIL;
	remK       : pRemember = NIL;
	
function CStrConstPtrAR(rk : ppRemember; s : String) : STRPTR;

var  p : STRPTR;
begin
  s := s + #0;                                    { Make "C" string }
  p := AllocRemember(rk, length(s), MEMF_CLEAR);  { Get some mem for it }
  move(s[1], p^, length(s));                      { Move s into newly alloc'd mem }
  CStrConstPtrAR := p                               { Return the pointer }
end;



Function GetPubScreenList(VAR rk : pRemember; VAR Front : String;
													VAR n : Integer) : pList;

VAR
	node    : pPSNode;
	pubnode : pPubScreenNode;
	PS_List : pList;
	OutList : pList;
	scrlock : LONG;
	n2      : Integer;
	def, buf: String;

begin
	Front := '';
	n2 := 0;
	GetDefaultPubScreen(@buf);
	def := PtrToPas(@buf);
	
	OutList := AllocRemember(@rk, sizeof(tList), MEMF_CLEAR);
	if OutList <> NIL then begin
		NewList(OutList);
		PS_List := LockPubScreenList;
		pubnode := pPubScreenNode(PS_List^.lh_Head);
		While pubnode^.psn_Node.ln_Succ <> NIL Do Begin
			node := AllocRemember(@rk, Sizeof(tPSNode), MEMF_CLEAR);
			if node <> NIL then begin
				node^.ps_Name := CStrConstPtrAR(@rk, PtrToPas(pubnode^.psn_Node.ln_Name));
				AddTail(OutList,pNode(node));
			end;
			if PtrToPas(pubnode^.psn_Node.ln_Name) = def then
				n := n2;
				
			ScrLock := LockIBase(0);
			if pubnode^.psn_Screen = IntuitionBase^.ActiveScreen then
				Front := PtrToPas(pubnode^.psn_Node.ln_Name);
			UnLockIBase(ScrLock);
			
			inc(n2);
			pubnode := pPubScreenNode(pubnode^.psn_Node.ln_Succ);
		End;
		UnLockPubScreenList;
	end;
	GetPubScreenList := OutList;
end;



Procedure FreePubScreenList(VAR List : pList; VAR rk : pRemember);

begin
	If rk <> NIL then
		FreeRemember(@rk, True);
	rk := NIL;
	List := NIL;
end;

Procedure GetPubFlags(VAR pop, shan : Boolean);

VAR
	Oldmodes : LONG;
	
begin
	oldmodes := SetPubScreenModes(0);
	if oldmodes and SHANGHAI <> 0 then 
		shan := true
	else
		shan := false;
	if oldmodes and POPPUBSCREEN <> 0 then
		pop := true
	else
		pop := false;
	oldmodes := SetPubScreenModes(oldmodes);
end;

Procedure TogglePubFlags(pop, shan : Boolean);

VAR
	flags : LONG;
	
begin
	flags := SetPubScreenModes(0);
	if shan then
		flags := flags xor SHANGHAI;
	if pop then 
		flags := flags xor POPPUBSCREEN;
	flags := SetPubScreenModes(flags);
end;

Procedure SetPubFlags(pop, shan : Boolean);

VAR
	flags : LONG;
	
begin
	flags := SetPubScreenModes(0);
	if shan then
		flags := flags|SHANGHAI
	else
		flags := flags and (NOT SHANGHAI);
	if pop then 
		flags := flags|POPPUBSCREEN
	else
		flags := flags and (NOT POPPUBSCREEN);
	flags := SetPubScreenModes(flags);
end;
	
Procedure WBMain;

VAR
	t           : Array[1..21] of LONG;
	sampTxt     : tIntuiText;
	screendef   : pScreen;
	pgad, glist, 
	gadcode,
	LVgad,
	POPgad,
	SHANgad     : pGadget;
	vi          : pointer;
	My_Font     : pTextAttr;
	gadgetFlags : tNewGadget;
	win         : pWindow;
	TBS, gadW, 
	selected, y : Integer;
	ExitFlag    : Boolean;
	dummy, 
	msgclass, 
	msgcode     : LONG;
	message     : pIntuiMessage;
	Node        : pPSNode;
	numticks    : 0..21;
	
	

CONST   {                          |         |         |         |         |}
	LVTxt : String[26]   = 'Available Public Screens'#0;
	PopTxt : String[38]  = 'Pop public screens to front'#0;
	shanTxt : String[42] = 'Shanghai windows to default public screen'#0;
	titTxt : String[28]  = 'Publican 1.5 ©Lee Kindness.'#0;
	LV = 1;
	POP = 2;
	SHAN = 3;
	Zoom : Array[0..3] of Integer = (-1,-1,150,0);
	
	
Procedure UpDateWin;

begin
	{ detach list }
	t[1] := GTLV_Labels;
	t[2] := -1;
	t[3] := TAG_END;
	GT_SetGadgetAttrsA(LVgad, win, NIL, @T);

	FreePubScreenList(ScreenList, remk);
	{ get new list of public screens }
	ScreenList := GetPubScreenList(remk, front, selected);

	{ update LV }
	t[1] := GTLV_Labels;
	t[2] := LONG(ScreenList);
	t[3] := GTLV_Selected;
	t[4] := selected;
	t[5] := TAG_END;
	GT_SetGadgetAttrsA(LVgad, win, NIL, @T);

	{ get pub screen flags }
	GetPubFlags(popset, shanset);
											
	{ update CB gadgets }
	t[1] := GTCB_Checked;
	t[2] := ord(popset);
	t[3] := TAG_END;
	GT_SetGadgetAttrsA(POPgad, win, NIL, @T);
	t[2] := ord(shanset);
	GT_SetGadgetAttrsA(SHANgad, win, NIL, @T);
end;
										
										
begin
	glist := NIL;
	GadToolsBase := OpenLibrary('gadtools.library',36);
	if (GadToolsBase <> NIL) then begin
		ScreenList := GetPubScreenList(remk, front, selected);
		GetPubFlags(popset, shanset);
		
		ScreenDef := LockPubScreen(NIL);

		{ Get visual info and create context }
		vi := GetVisualInfoA(screendef, NIL);
		If vi <> NIL Then begin
			pGad := CreateContext(@glist);
			If pGad <> NIL Then begin
				
				TBS := screendef^.WBorTop + (screendef^.Font^.ta_YSize + 1);
				Zoom[3] := TBS;
				My_Font := Screendef^.Font;
				Samptxt.ITextFont := My_Font;
				Samptxt.IText := @shantxt[1];
				gadW := IntuiTextLength(@Samptxt)+((TBS+1)*2)+16;
			
				t[1] := GTLV_Labels;
				t[2] := LONG(ScreenList);
				t[3] := GTLV_Selected;
				t[4] := selected;
				t[5] := GTLV_ShowSelected;
				t[6] := 0;
				t[7] := TAG_END;

				With GadgetFlags Do Begin
					ng_TextAttr   := My_Font;
					ng_LeftEdge   := Screendef^.WBorLeft+8;
					ng_TopEdge    := (TBS*2)+6;
					ng_Width      := gadW;
					ng_Height     := (TBS+1)*4;
					ng_GadgetText := @LVTxt[1];
					ng_VisualInfo := vi;
					ng_GadgetID   := LV;
					ng_Flags      := PLACETEXT_ABOVE;
				End;
				{ create gadgets }
				LVgad := CreateGadgetA(LISTVIEW_KIND, pgad, @Gadgetflags, @t);
				
				t[1] := GTCB_Checked;
				t[2] := ord(popset);
				t[3] := $80080044; { GTCB_Scaled }
				t[4] := True_;
				t[5] := TAG_END;

				With GadgetFlags Do Begin
					if GadToolsBase^.lib_Version >= 39 then
						ng_TopEdge    := LVgad^.TopEdge+LVgad^.Height+4
					else
						ng_TopEdge  := LVgad^.TopEdge+LVgad^.Height+6+TBS;
					ng_Width      := (TBS+1)*2;
					ng_Height     := TBS+1;
					ng_GadgetText := @PopTxt[1];
					ng_GadgetID   := POP;
					ng_Flags      := PLACETEXT_RIGHT;
				End;
				{ create gadgets }
				POPgad := CreateGadgetA(CHECKBOX_KIND, LVgad, @Gadgetflags, @t);
				
				t[2] := ord(shanset);
				
				With GadgetFlags Do Begin
					ng_TopEdge    := ng_TopEdge+ng_Height+4;
					ng_GadgetText := @shanTxt[1];
					ng_GadgetID   := SHAN;
				End;
				{ create gadgets }
				SHANgad := CreateGadgetA(CHECKBOX_KIND, POPgad, @Gadgetflags, @t);
				
								
				t[1]  := WA_Left;
				t[2]  := 0;
				t[3]  := WA_Top;
				t[4]  := TBS;
				t[5]  := WA_IDCMP;
				t[6]  := IDCMP_INTUITICKS|CHECKBOXIDCMP|BUTTONIDCMP|LISTVIEWIDCMP|
									IDCMP_MOUSEBUTTONS|IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW;
				t[7]  := WA_Gadgets;
				t[8]  := LONG(glist);
				t[9]  := WA_ScreenTitle;
				t[10] := LONG(@titTxt[1]);
				t[11] := WA_Title;
				t[12] := LONG(@titTxt[1]);
				t[13] := WA_InnerWidth;
				t[14] := GadW+16;
				t[15] := WA_Height;
				t[16] := shangad^.TopEdge+shangad^.Height+8;
				t[17] := WA_Flags;
				t[18] := WFLG_DRAGBAR|WFLG_SIMPLE_REFRESH|WFLG_ACTIVATE|WFLG_RMBTRAP|
									WFLG_DEPTHGADGET|WFLG_CLOSEGADGET;
				t[19] := WA_Zoom;
				t[20] := LONG(@Zoom);
				t[21] := TAG_END;
				
				win := OpenWindowTagList(NIL, @t);
				if win <> NIL then begin
					GT_RefreshWindow(win, NIL);
					
					numticks := 1;
					exitflag := false;
					While Not exitflag Do Begin
						dummy    := Wait(BitMask(Win^.UserPort^.MP_SIGBIT));
						message  := GT_GetIMsg(Win^.userPort);
						while message <> NIL do begin
							MsgClass := message^.Class;
							MsgCode  := message^.Code;
							if MsgClass = IDCMP_GADGETUP then begin
								GadCode  := pGadget(message^.IAddress);
							end;
							GT_ReplyIMsg(message);
							Case MsgClass Of
							
								IDCMP_MOUSEBUTTONS : Begin
									if MsgCode = MENUUP then
										ZipWindow(Win);
								End;
								
								IDCMP_INTUITICKS : Begin
									inc(numTicks);
									if numticks = 20 then begin
										UpDateWin;
										numticks := 1;
									End;
								End;
							
								IDCMP_CLOSEWINDOW : ExitFlag := True;
							
								IDCMP_REFRESHWINDOW : begin
									GT_BeginRefresh(Win);
									GT_EndRefresh(Win, True);
								end;
								
								IDCMP_GADGETUP : Begin       
									Case gadcode^.GadgetID Of
										LV : begin
											Node := pPSNode(ScreenList^.lh_Head);
											For y := 1 to msgcode do
											Node := pPSNode(Node^.ps_Succ);
											SetDefaultPubScreen(node^.ps_Name);
										end;
										POP : begin
											if gadcode^.Flags and GFLG_SELECTED <> 0 then 
												popset := True
											else
												popset := False;
											SetPubFlags(popset, shanset);
										end;
										SHAN : begin
											if gadcode^.Flags and GFLG_SELECTED <> 0 then 
												shanset := True
											else
												shanset := False;
											SetPubFlags(popset, shanset);
										end;   
									end;
								end; 
							End; {case}
							message  := GT_GetIMsg(Win^.userPort);
						end;
					End; {while}
					CloseWindow(win);
				end;
				FreeGadgets(glist);
			end;
			FreeVisualInfo(vi);
		end;
		UnlockPubScreen(NIL, screendef);
		FreePubScreenList(ScreenList, remk);
		CloseLibrary(pLibrary(GadToolsBase));
	end;
end;

	
Function CLIMain : Integer;
	
CONST
	RD_Array : Array[0..6] of LongInt = (0);
	POPPUB = 0;
	SHANG  = 1;
	LIST   = 2;
	EVAR   = 3;
	GLOBAL = 4;
	GUI    = 5;
	PUBSCR = 6;
	err : ShortInt = 0;

Var 
	junk : integer;
	Template : String;
	Flags : LONG;
	
	
Begin
	template := 
'P=POPPUBSCREEN/S,S=SHANGHAI/S,L=LIST/S,VAR=VARIABLE/K,GLOBAL/S,GUI/S,DPS=PUBSCREEN=PUBSCR/K/F'#0;
	RDArgs := ReadArgs(@Template[1],@RD_Array, NIL);
	If RDArgs <> NIL then begin
		ScreenList := GetPubScreenList(remk, front, junk);
				
		{ set public screen flags }
		TogglePubFlags(Boolean(RD_Array[POPPUB]), Boolean(RD_Array[SHANG]));
				
		{ set default public screen }
		if RD_Array[PUBSCR] <> 0 then
			SetDefaultPubScreen(STRPTR(RD_Array[PUBSCR]));
					
		{ show pubscreen list and flags }
		if Boolean(RD_Array[LIST]) then begin
			Writeln('Public screen list:');
			node := pPSNode(ScreenList^.lh_Head);
			While Node^.ps_Succ <> NIL do begin
				Writeln(PtrToPas(Node^.ps_Name));
				Node := node^.ps_succ;
			end;
			Writeln;
			Writeln('Default public screen:');
			GetDefaultPubScreen(@buf);
			Writeln(PtrToPas(@buf));
			if front <> '' then begin
				Writeln;
				Writeln('Front public screen:');
				Writeln(front);
			End;
			Writeln;
			Writeln('Public screen flags:');
			GetPubFlags(popset, shanset);
			Writeln('POPPUBSCREEN : ',popset);
			Writeln('SHANGHAI : ',shanset);
		end;
		
		if RD_Array[EVAR] <> 0 then begin
			if RD_Array[GLOBAL] <> 0 then
				flags := GVF_GLOBAL_ONLY
			else
				flags := GVF_LOCAL_ONLY;
			OK := SetVar(STRPTR(RD_Array[EVAR]), @Front[1], length(front), flags);
		End;
						
		if (RD_Array[0] = 0) and (RD_Array[1] = 0) and (RD_Array[2] = 0) 
		and (RD_Array[3] = 0) and (RD_Array[4] = 0) and (RD_Array[5] = 0) 
		and (RD_Array[6] = 0) then
			Write(front);
				
		{ free memory allocated }
		FreePubScreenList(ScreenList, remk);
		
		{ if GUI switch specified then open window }
		if RD_Array[GUI] <> 0 then
			WBMain;

		FreeArgs(RDArgs);
	end;
	CLIMain := IOErr;
end;				
					
begin
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',36));
	if (IntuitionBase <> NIL) then begin
		If CmdLinePtr.Len >= 1 then begin
			{ from CLI }
			if pDosLibrary(DOSBase)^.dl_Lib.lib_Version >= 36 then
				OK := PrintFault(CLIMain, @Head[1]);
		end else
			{ from WB }
			WBMain;
		CloseLibrary(pLibrary(IntuitionBase));
	end;
end.
				
												