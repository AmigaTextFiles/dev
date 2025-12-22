Program WangiPad;
{SF-,I-,R-,S-,V-}
{$M 4,1,1,15}

Uses
	Exec, Intuition, GadTools, Utility, Graphics, Diskfont, 
	Icon, WBStart, KeyFile, Amiga, AmigaDos, DOS, Reqtools, 
	WorkBench, Commodities, Rexx, Timer, PathList;

Type	
	pEnDisWin = ^tEnDisWin;
	tEnDisWin = Record
		edw_req : pRequester;
		edw_oldwidth,
		edw_oldheight : LONG;
	End;
	
	pIPCMsg = ^tIPCMsg;
	tIPCMsg = record
		ipc_Msg    : tMessage; { system message structure                   }
		ipc_Type,              { type of message                            }
		ipc_Left,              { dimension of window if type = IPC_SENDSIZE }
		ipc_Top,
		ipc_Width,
		ipc_Height : LONG
	End;
	
	tProgVars = Record
		arg_From,
		arg_Hotkey,
		arg_PrefEd : String[180];
		arg_Pri,
		arg_LevelT : LONG;
	End;
	
Const
	{ constants fo ipc_Type }
	IPC_SENDSIZES    = 1;
	IPC_NEWPREFS     = 2;
	IPC_REQUESTSIZES = 3;
	grk   : pRemember = NIL;
	prk   : pRemember = NIL;
	opened : Boolean = True;
	secs  : LONG = 0;
	mics  : LONG = 0;
	G_NI  = 0;
	G_LV  = 1;
	G_CC  = 2;
	
	TBS     = 0;
	S_Gad_H = 1;
	
	M_PREF  = 4;
	M_ABOUT = 5;
	M_HIDE  = 2;
	M_QUIT  = 3;
	
	ERROR_LOSTPREFS = 'Can''t find preference program';
	ERROR_WB        = 'launching Workbench program';
	ERROR_SHELL     = 'launching Shell program';
	ERROR_NOTWB2    = 'Drag ''n'' Drop requires Workbench 3, sorry';

	
	
Var
	Reg         : tKey;
	CurrentList : pList;
	S           : Array[0..1] of LONG;
	G           : Array[G_NI..G_CC] of pGadget;
	vi          : Pointer;
	My_Font     : tTextAttr;
	menustrip   : pMenu;
	OK          : Boolean;
	oldsecs, 
	oldmics,
	oldlvord,
	LVRows,
	currenttop  : LONG;
	aw          : pAppWindow;
	AppPort, CxPort,
	WangiPort, NotifyPort,
	WBMPort,
	timerport   : pMsgPort;
	broker, filter,
	sender,
	translate   : pCxObj;
	nr          : pNotifyRequest;
	V           : tProgVars;
	HidenPos    : Array[1..4] of LONG;
	tio         : pTimeRequest;
	gp          : pPathList;
	wbmlist : tMinList;
	
function CStrConstPtrAR(rk : ppRemember; s : String) : STRPTR;
VAR
	p : STRPTR;
begin
  s := s + #0;                                   { Make "C" string               }
  p := AllocRemember(rk, length(s), MEMF_CLEAR); { Get some mem for it           }
  move(s[1], p^, length(s));                     { Move s into newly alloc'd mem }
  CStrConstPtrAR := p;                           { Return the pointer            }
end;

Procedure TellError(txt : String);

Var
	gad, tit : String;
	ret      : Longint;
	ez       : pEasyStruct;
	
Begin
	gad := 'Ok'#0;
	tit := 'WangiPad Error'#0;
	txt := 'Error ' + txt;
	If CmdLinePtr.Len >= 1 then begin
		txt := txt + #10#0;
		ret := FPuts(Output_,@txt[1]);
	End else begin
		txt := txt + #0;
		If IntuitionBase <> NIL then begin
			ez := AllocVec(Sizeof(tEasyStruct),MEMF_CLEAR);
			if ez <> NIL then begin
				with ez^ do begin
					es_StructSize := Sizeof(tEasyStruct);
					es_Title := @tit[1];
					es_TextFormat := @txt[1];
					es_GadgetFormat := @gad[1];
				End;
				ret := EasyRequestArgs(NIL, ez, NIL, NIL);
				FreeVec(ez);
			End;
		End;
	End;
End;
		

Function PutArgs(cmd : String; am : pAppMessage) : String; Forward;

{$I Version.H      }
{$I Config.PAS     }
{$I ToolType.PAS   }
{$I Window.PAS     }
{$I ARexx.PAS      }
{$I ProcessMsg.PAS }


Procedure Main;
Var
	Win   : pWindow;
	owp   : Pointer;

Begin
	if pLibrary(SysBase)^.lib_Version < 37 then begin
		Halt;
	End;
	IntuitionBase := NIL;
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',36));
	If IntuitionBase <> NIL then begin
		GadToolsBase := OpenLibrary('gadtools.library', 36);
		If GadToolsBase <> NIL then begin
			GfxBase := pGfxBase(OpenLibrary('graphics.library',0));
			If GfxBase <> NIL then begin
				WorkbenchBase := OpenLibrary('workbench.library',36);
				If WorkbenchBase <> NIL then begin
					CxBase := OpenLibrary('commodities.library', 37);
					If CxBase <> NIL then begin
						DiskFontBase := OpenLibrary('diskfont.library',0);
						If DiskfontBase <> NIL then begin
							IconBase := OpenLibrary('icon.library',0);
							If IconBase <> NIL then begin
								ReqtoolsBase := pReqtoolsBase(OpenLibrary('reqtools.library',38));
								RexxSysBase := pRxsLib(OpenLibrary('rexxsyslib.library',0));
	
								GetToolTypes(v);
		
								if ReadConfigFile(V.arg_From,LM_LOAD,prk) then begin
									ReadKeyFile(reg, 'S:WangiPad.key');
									Win := OpenTheWindow;
									if Win <> NIL then begin
										owp := pProcess(ThisTask)^.pr_WindowPtr;
										pProcess(ThisTask)^.pr_WindowPtr := Win;
										If InitCx then begin
											If AddAppWin(win) then begin
												If InitIPC then begin
													If InitNotify then begin
														If InitTimer then begin
															If InitWBMenus then begin
																InitPathList(gp);
																InitMenus(win);
																ProcessWindowEvents(win);
																FreeMenus(win);
																FreePathList(gp);
																FreeWBMenus;
															End;
															CloseTimer;
														End else TellError('13');
														RemoveNotify;
													End else TellError('12'); 
													RemoveIPC;
												End else TellError('11');
												RemoveAppWin;
											End else TellError('10');
											RemoveCx;
										End else TellError('9');
										pProcess(ThisTask)^.pr_WindowPtr := owp;
										CloseTheWindow(win);
										CloseFont(CD.cd_TFont);
									End else TellError('8');
								End else TellError('7 - Unable to load preference file.');
								FreeRemember(@grk, True);
								FreeRemember(@prk, True);
								
								{ Close all system modules }
								CloseLibrary(pLibrary(RexxSysBase));
								CloseLibrary(pLibrary(ReqtoolsBase));
								CloseLibrary(pLibrary(IconBase));
							End else TellError('6');
							CloseLibrary(pLibrary(DiskFontBase));
						End else TellError('5');
						CloseLibrary(pLibrary(CxBase));
					End else TellError('4');
					CloseLibrary(pLibrary(WorkbenchBase));
				End else TellError('3');
				CloseLibrary(pLibrary(GfxBase));
			End else TellError('2');
			CloseLibrary(pLibrary(GadToolsBase));
		End else TellError('1');
		CloseLibrary(pLibrary(IntuitionBase));
	End;
End;

Begin Main End.