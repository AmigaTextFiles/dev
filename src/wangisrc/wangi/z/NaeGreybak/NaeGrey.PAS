Program NaeGrey;

{$F-,I-,R-,S-,V-,M 1,1,1,1}

Uses
	Exec, Intuition, Graphics, Utility, AmigaDos, Amiga, CStrConstPtr;
	
Const
	VERSION : String[29] = '$VER: NaeGrey 1.1 (13.04.95)'#0;
	BANNER  : String[29] = ' ©Lee Kindness... Wangi!!'#10#10#0;
	ON_TXT  = #9#9'border blank on'#10;
	OFF_TXT = #9#9'border blank off'#10;

(***************************************************************************)

Procedure CopyPubScreenList(rk : ppRemember; VAR list : pList);

Var
	pubn,
	node : pNode;
	publ : pList;
	
Begin
	{ Lock the system list }
	publ := LockPubScreenList;
	If publ <> NIL Then Begin
		{ Copy the name of each screen }
		pubn := publ^.lh_Head;
		While pubn^.ln_Succ <> NIL Do Begin
			node := AllocRemember(rk, Sizeof(tNode), MEMF_CLEAR);
			If node <> NIL Then Begin
				node^.ln_Name := CSCPAR(rk, PtrToPas(pubn^.ln_Name));
				AddTail(list, node);
			End;
			pubn := pubn^.ln_Succ;
		End;
	End;
	{ Release lock }
	UnlockPubScreenList;
End;
(***************************************************************************)

Procedure Main;

Const
	TEMPLATE   : String[44] = 'SCREEN/M,ALL/S,BLACK=ON/S,GREY=OFF/S,QUIET/S'#0;
	OPT_SCREEN = 0;
	OPT_ALL    = 1;
	OPT_ON     = 2;
	OPT_OFF    = 3;
	OPT_QUIET  = 4;

Type
	Bopts = (TOGGLE, ON, OFF);
	{ For handling the SCREEN/M option... }
	pLargeA = ^tLargeA;
	tLargeA = Array[0..300] of STRPTR;
	pData   = ^tData;
	tData   = Record
		t       : Array[0..6] Of LONG;
		scrn    : pScreen;
		cmap    : pColorMap;
		err,
		imm     : LONG;
		rk      : pRemember;
		node    : pNode;
		list    : pList;
		RDArgs  : pRDArgs;
		la      : pLargeA;
		n       : Integer;
		change  : BOpts;
		quiet,
		rethink : Boolean;
		args    : Array[OPT_SCREEN..OPT_QUIET] Of LONG;
	End;
	
Var
	data : pData;
	
Begin
	data := AllocVec(Sizeof(tData), MEMF_CLEAR);
	If data <> NIL Then Begin
		With data^ do Begin
			change := TOGGLE;
			Quiet := False;
			rk := NIL;
			IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library', 36));
			GfxBase := pGfxBase(OpenLibrary('graphics.library',36));
			If (IntuitionBase <> NIL) and (GfxBase <> NIL) and (pLibrary(DOSBase)^.lib_Version >= 36) Then Begin
				{ Libraries opened ok... }
				{ Parse options... }
				If CmdLinePtr.Len >= 1 then begin
					{ Launched from Shell }
					RDArgs := ReadArgs(@TEMPLATE[1], @args, NIL);
					If RDArgs <> NIL Then Begin
						If args[OPT_SCREEN] <> 0 Then Begin
							{ copy the list of screen names into list }
							la := pLargeA(args[OPT_SCREEN]);
							n := 0;
							list := AllocRemember(@rk, Sizeof(tList), MEMF_CLEAR);
							if list <> NIL Then Begin
								Newlist(list);
								While la^[n] <> NIL do Begin
									node := AllocRemember(@rk, sizeof(tNode), MEMF_CLEAR);
									If node <> NIL Then Begin
										node^.ln_Name := CSCPAR(@rk, PtrToPas(la^[n]));
										AddTail(list, node);
									End;
									inc(n);
								End;
							End;
						End Else Begin
							{ default to OPT_ALL }
							list := AllocRemember(@rk, Sizeof(tList), MEMF_CLEAR);
							if list <> NIL Then Begin
								Newlist(list);
								{ Copy the list of public screens }
								CopyPubScreenList(@rk, list);
							End;
						End;
						If args[OPT_ON] <> 0 Then
							{ turn on black border }
							change := ON;
						If args[OPT_OFF] <> 0 Then
							{ turn off the black border }
							change := OFF;
						If args[OPT_QUIET] <> 0 Then
							quiet := True;
						FreeArgs(RDArgs);
					End;
				End Else Begin
					{ Launched from Workbench }
					{ We don't parse tooltypes... just assume OPT_ALL and change = ON }
					list := AllocRemember(@rk, Sizeof(tList), MEMF_CLEAR);
					if list <> NIL Then Begin
						Newlist(list);
						{ Copy the list of public screens }
						CopyPubScreenList(@rk, list);
					End;
					Quiet := True;
					change := ON;
				End;
				If NOT Quiet Then Begin
					err := PutStr(@VERSION[7]);
					err := PutStr(@BANNER[1]);
				End;
				{ Go thru the list of screens, changing the border status... }
				rethink := False;
				node := list^.lh_Head;
				While node^.ln_Succ <> NIL Do Begin
					{ Get the screen }
					scrn := LockPubScreen(node^.ln_Name);
					If scrn <> NIL Then Begin
						{ ...and get its colormap }
						cmap := scrn^.ViewPort.ColorMap;
						{ findout if blanking is on or off... }
						t[0] := VTAG_BORDERBLANK_GET;
						t[1] := 0;
						t[2] := VTAG_END_CM;
						t[4] := TAG_DONE;
						If VideoControl(cmap, @t) = 0 Then Begin
							{ and determine what to do... }
							Case change Of
								ON     : t[0] := VTAG_BORDERBLANK_SET;
								OFF    : t[0] := VTAG_BORDERBLANK_CLR;
								TOGGLE : Case t[0] Of
									VTAG_BORDERBLANK_SET : t[0] := VTAG_BORDERBLANK_CLR;
									VTAG_BORDERBLANK_CLR : t[0] := VTAG_BORDERBLANK_SET;
								End;
								else t[0] := -1;
							End;
							If t[0] <> -1 Then Begin
								imm := -1;
								If pLibrary(GfxBase)^.lib_Version >= 39 Then
									t[2] := VTAG_IMMEDIATE
								Else
									t[2] := TAG_IGNORE;
								t[3] := LONG(@imm);
								t[4] := VTAG_END_CM;
								t[6] := TAG_DONE;
								If (VideoControl(cmap, @t) = 0) and (NOT Quiet) Then Begin
									Case t[0] Of
										VTAG_BORDERBLANK_SET : err := PutStr(CSCPAR(@rk, PtrToPas(node^.ln_Name)+ON_TXT));
										VTAG_BORDERBLANK_CLR : err := PutStr(CSCPAR(@rk, PtrToPas(node^.ln_Name)+OFF_TXT));
									End;
								End;
								If imm <> 0 Then Begin
									{ manually update changes... }
									err := MakeScreen(scrn);
									rethink := True;
								End;
							End;
						End;
						UnlockPubScreen(NIL, scrn);
					End else
						err := PutStr(CSCPAR(@rk, PtrToPas(node^.ln_Name)+#9#9'Can''t lock screen'#10));
					node := node^.ln_Succ;
				End;
				If rethink Then
					err := RethinkDisplay;
				FreeRemember(@rk, True);
				CloseLibrary(pLibrary(GfxBase));
				CloseLibrary(pLibrary(IntuitionBase));
			End;
		End;
		FreeVec(Data);
	End;
End;

Begin Main End.