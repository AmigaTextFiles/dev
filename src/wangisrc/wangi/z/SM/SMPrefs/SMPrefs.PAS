Program SMPrefs(input, output);

{$F+,I-,R-,S-,V-,M 4,1,2,15}

Uses Exec, Intuition, utility, gadtools, graphics, DiskFont, 
ASL, AmigaDOS, Amiga, IFFParse, ReqTools, Input, DOS, Datatypes, Modeid;

{$I SMPrefs.h }


{ Init the global CData structure, what does the C stand for?? }   
Procedure InitCD;

begin
	CD.cd_FontName      := 'topaz.font'#0;
	CD.cd_Font.ta_Name  := @CD.cd_FontName[1];
	CD.cd_Font.ta_YSize := 8;
	CD.cd_Font.ta_Style := FS_NORMAL;
	CD.cd_Font.ta_Flags := FPF_ROMFONT;
	CD.cd_SFont := CD.cd_Font;
	CD.cd_SFontName     := 'topaz.font'#0;
	CD.cd_SFont.ta_Name  := @CD.cd_SFontName[1];
	CD.cd_ModeID        := HIRES_KEY;
	if (GfxBase^.DisplayFlags and NTSC) = NTSC then
		CD.cd_ModeID      := NTSC_MONITOR_ID|HIRES_KEY;
	if (GfxBase^.DisplayFlags and PAL) = PAL then
		CD.cd_ModeID      := PAL_MONITOR_ID|HIRES_KEY; 
	CD.cd_Across        := 1;
	CD.cd_Down          := 1;
	CD.cd_ScrTit        := 'Startup-Menu ©Lee Kindness';
	CD.cd_WinTit        := 'Pick One...'; 
	CD.cd_Pal[0]        := $AAA;
	CD.cd_Pal[1]        := $000;
	CD.cd_Pal[2]        := $FFF;
	CD.cd_Pal[3]        := $CB4;
	CD.cd_ScrW          := 640;
	CD.cd_ScrH          := 200;
	CD.cd_WitTxt        := '';
	CD.cd_RexxCmd1      := 'id SM_INITIAL';
	CD.cd_Rexxport1     := 'PLAY';
	CD.cd_RexxCmd2      := 'id SM_EXIT';
	CD.cd_RexxPort2     := 'PLAY';
	CD.cd_RexxCmd3      := 'id SM_PRECMD';
	CD.cd_RexxPort3     := 'PLAY';
	CD.cd_Wit           := True;
	CD.cd_Rexx          := True;
	CD.cd_ScrT          := 0;
	CD.cd_WildStar      := False;
	CD.cd_Shanghai      := True;
	CD.cd_PopPubScr     := True;
	CD.cd_Quals         := 0;
	CD.cd_Wait          := 0;
	CD.cd_Flush         := True;
	CD.cd_Test          := False;
	CD.cd_DT            := '';
	CD.cd_DTImmed       := True;
	CD.cd_DTRepeat      := True;
	CD.cd_ScrDepth      := 2;
	CD.cd_NoClick       := True;
	CD.cd_App           := APP_ALL;
end;

{ close the window and free related structures }
Procedure Close_Window;

Begin
	if MenuStrip <> NIL then begin
		ClearMenuStrip(TheWindow);
		FreeMenus(MenuStrip);
	end;
	CloseWindow(TheWindow);
	FreeGadgets(gads[G_NI]);
	FreeVisualInfo(vi);
End;

{ The main IDCMP loop }
Procedure HandleIDCMP;

Const
	exitflag : Boolean  = False; 
	small    : Boolean  = False;
	CurrentSecs : Long = 0;
	CurrentMics : Long = 0;
	NewSecs : Long = 0;
	NewMics : Long = 0;
   
Var 
	dummy      : longint;
	Tags       : Array[0..8] Of tTagItem;
	message    : pIntuiMessage;
	MsgClass, osm, oss : LongInt;
	MsgCode    : Word;
	gadcode    : pGadget;
	StrInfo    : pStringInfo;
	OKRes,cont : boolean;
	i          : Longint;
	lr, sr     : pFileRequester;
	cfile, cdir: String;
	t          : array[0..1] of tTagItem;
	menunumber,INum, MNum : Word;
	Item       : pMenuItem;
	

Procedure InfoGadFunc; Forward;
Procedure GetTitles; Forward;
Procedure GetPal; Forward;
Function GetSCRID : LongInt; Forward;
Procedure TopGadFunc; Forward;
Procedure UpGadFunc; Forward;
Procedure DownGadFunc; Forward;
Procedure BottomGadFunc; Forward;
Procedure NewGadFunc; Forward;
Procedure RemoveGadFunc; Forward;
Procedure CopyGadFunc; Forward;
Procedure SaveGadFunc; Forward;
Procedure SaveAsGadFunc; Forward;
Procedure NewListFunc; Forward;
Procedure LoadGadFunc; Forward;
Procedure LVGadFunc; Forward;
Procedure FontGadFunc(Scroll : Boolean); Forward;
Procedure TestGadFunc; Forward;
{$I IDCMP.PAS }

Begin
	osm := 0;
	oss := 0;
	currentnode := NIL;
	Tags[0].ti_Tag  := ASLFR_TitleText;
	Tags[0].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Locate the prefs file'));
	Tags[1].ti_Tag  := ASLFR_InitialFile;
	Tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, PREFSNAME));
	Tags[2].ti_Tag  := ASLFR_InitialDrawer;
	Tags[2].ti_Data := long(CStrConstPtrAR(@RememberKey, PREFSDIRH));
	Tags[3].ti_Tag  := ASLFR_Window;
	Tags[3].ti_Data := long(TheWindow);
	Tags[4].ti_Tag  := ASLFR_Flags2;
	Tags[4].ti_Data := FRF_REJECTICONS;
	Tags[5].ti_Tag  := ASLFR_Flags1;
	Tags[5].ti_Data := FRF_DOPATTERNS;
	Tags[6].ti_Tag  := ASLFR_InitialPattern;
	Tags[6].ti_Data := LONG(CStrConstPtrAR(@RememberKey, '#?.prefs'));
	Tags[7].ti_Tag  := TAG_DONE;

	lr := AllocASLRequest(ASL_FileRequest, @Tags[0]);
	
	Tags[0].ti_Tag  := ASLFR_TitleText;
	Tags[0].ti_Data := LONG(CStrConstPtrAR(@RememberKey, 'Save prefs file as'));
	Tags[1].ti_Tag  := ASLFR_InitialFile;
	Tags[1].ti_Data := LONG(CStrConstPtrAR(@RememberKey, PREFSNAME));
	Tags[2].ti_Tag  := ASLFR_InitialDrawer;
	Tags[2].ti_Data := long(CStrConstPtrAR(@RememberKey, PREFSDIRH));
	Tags[3].ti_Tag  := ASLFR_Window;
	Tags[3].ti_Data := long(TheWindow);
	Tags[4].ti_Tag  := ASLFR_Flags2;
	Tags[4].ti_Data := FRF_REJECTICONS;
	Tags[5].ti_Tag  := TAG_DONE;
	
	sr := AllocASLRequest(ASL_FileRequest, @Tags[0]);

	t[0].ti_Tag  := RT_Window;
	t[0].ti_Data := LONG(TheWindow);
	t[1].ti_Tag  := TAG_END;
	
	While Not exitflag Do Begin
		dummy    := Wait(BitMask(TheWindow^.UserPort^.MP_SIGBIT));
		message  := GT_GetIMsg(TheWindow^.userPort);
		While message <> NIL do begin
			MsgClass := message^.Class;
			MsgCode  := message^.Code;
			if MsgClass = IDCMP_GADGETUP then begin
				GadCode  := pGadget(message^.IAddress);
				StrInfo  := gadcode^.SpecialInfo;
			end;
			NewSecs  := message^.Seconds;
			NewMics  := message^.Micros;
			GT_ReplyIMsg(message);
			Case MsgClass Of
			
				IDCMP_CLOSEWINDOW : ExitFlag := True;
					
				IDCMP_REFRESHWINDOW : RefreshWin(TheWindow);
					
				IDCMP_MENUPICK : Begin
					MenuNumber := MsgCode;
					While (menunumber <> MENUNULL) and (ExitFlag = False) do begin
						Item := ItemAddress(MenuStrip, menunumber); 
						MNum := MENUNUM(menunumber);  
						INum := ITEMNUM(menunumber);
						CASE MNum of 
							MM_PROJ : begin
								CASE INum of
									MI_OPEN : LoadGadFunc;
									MI_SAVA : SaveAsGadFunc;
									MI_TEST : TestGadFunc;
									MI_INFO : InfoGadFunc;
									MI_QUIT : ExitFlag := True;
								End;
							End;
							MM_EDIT : begin
								Case INum of
									MI_RDEF : NewListFunc;
									MI_REST : begin
										DetachObjectList;
										OKRes := ReadConfigFile('S:Startup-Menu.prefs');
										if OKRes then begin  
											CurrentNode := NIL;
											CurrentOrd := -1;
											currenttop := 0;
											DisableObjectGadgets(TRUE_);
										end else begin
											DisplayBeep(NIL);
											NewListFunc;
										End;
										AttachObjectList;
									End;
								End;
							End;
						end;
						menunumber := item^.NextSelect;
					end;
				end;       
					
				IDCMP_GADGETUP : Begin       
					Case gadcode^.GadgetID Of         
						G_B_TOP     : TopGadFunc;
						G_B_UP      : UpGadFunc;
						G_B_DOWN    : DownGadFunc;
						G_B_BOTTOM  : BottomGadFunc;
						G_B_SORT    : SortGadgetFunc;
						G_B_NEW     : NewGadFunc;
						G_B_REMOVE  : RemoveGadFunc;
						G_B_COPY    : CopyGadFunc;
						G_B_SAVE    : SaveGadFunc;
						G_B_CANCEL  : exitflag := True;                               
						G_LV        : LVGadFunc;
						G_C_SET     : begin
							If DoubleClick(oss, osm, NewSecs, NewMics) then begin
								if MsgCode = CurSet then begin
									Case curset of 
										C_REXX : Begin
											wl := Pointer(rtLockWindow(TheWindow));
											RexxEDWin(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS], 
												CD.cd_RexxCmd1,CD.cd_RexxPort1,
												CD.cd_RexxCmd2,CD.cd_RexxPort2,
												CD.cd_RexxCmd3,CD.cd_RexxPort3, CD.cd_Rexx);
											rtUnLockWindow(TheWindow, wl);
										end;
										C_FONT : FontGadFunc(false);
										C_PALT : GetPal;
										C_QUAL : Begin          
											wl := Pointer(rtLockWindow(TheWindow));
											QualWin(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS]);
											rtUnLockWindow(TheWindow, wl);
										end;
										C_SCRN : Begin          
											wl := Pointer(rtLockWindow(TheWindow));
											SWWindow(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS]);
											rtUnLockWindow(TheWindow, wl);
										end;
										C_SMID : CD.cd_ModeID := GetSCRID;
										C_SFNT : FontGadFunc(true);
										C_SYSS : Begin          
											wl := Pointer(rtLockWindow(TheWindow));
											SysOptWin(TheWindow^.LeftEdge+5, TheWindow^.TopEdge+Sizes[TBS]);
											rtUnLockWindow(TheWindow, wl);
										end;
										C_TITL : GetTitles;
									End;
								End;
							End;
							CurSet := MsgCode;
							oss := NewSecs;
							osm := NewMics;
						End;
					End; {case}
				end;
	           
				IDCMP_VANILLAKEY : begin
					case chr(msgcode) of
						'N','n' : NewGadFunc;
						'T','t' : TopGadFunc;
						'U','u' : UpGadFunc;
						'W','w' : DownGadFunc;
						'B','b' : BottomGadFunc;
						'V','v' : RemoveGadFunc;
						'Y','y' : CopyGadFunc;
						'S','s' : SaveGadFunc;
						'C','c' : exitflag := True;
					end;
				end; 
			End; {case}
			message  := GT_GetIMsg(TheWindow^.userPort);
		End;
	End; {while}
	   
	FreeAslRequest(lr);
	FreeAslRequest(sr);
End;
	
{ ===================================================================== }
	
	{ 
	 * Main Procedure 
	 }
	
Procedure main;
	
VAR
	nl, oldlock : BPTR;
	
Begin
	If Open_Libs then begin
		If pExecBase(SysBase)^.LibNode.lib_Version >= 39 then 
			V39 := True
		else
			V39 := False;
	 
		nl := Lock(CStrConstPtrAR(@RememberKey, PREFSDIRH), ACCESS_READ);
		oldlock := currentdir(nl);
	
		if NOT ReadConfigFile(PREFSNAME) then begin
			currentlist := pList(AllocRemember(@RememberKey, sizeof(tList), MEMF_CLEAR|MEMF_PUBLIC));
			newlist(currentlist);
			InitCD;  
		end;
		CurrentNode := NIL;
		oldlock := currentdir(oldlock);
		unlock(nl);
	       
		if Open_Window then begin
			HandleIDCMP;
			Close_window;
		end;
		FreeRemember(@RememberKey, True);
	end;
	Close_Libs;
end;
	
{ ===================================================================== }  
begin
main; 
end.
{ ===================================================================== }