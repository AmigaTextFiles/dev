(*
 * Shrub... HSPascal source
 *
 * ©Lee Kindness
 *
 * Shrub.pas
 *
 *)
Program Shrub;
{$F-,I-,R-,S-,V-,M 25,1,3,15}

Uses
	Exec, Intuition, GadTools, Utility, Graphics, 
	Amiga, AmigaDos, Asl, DOS, Icon, WorkBench, Reqtools;

Type
	pTreeHandle = ^tTreeHandle;
	tTreeHandle = Record
		th_List : pList;      { list of objects in the directory }
		th_Rk   : pRemember;  { keeps track of allocations       }
		th_Name : STRPTR;     { name of current file object      }
		th_Loc  : BPTR;       { lock on current directory        }
	End;
	
	tProgVars = Record
		arg_Dir,
		arg_Pub,
		arg_STxt,
		arg_Viewer : String;
		arg_Left,
		arg_Top,
		arg_Width,
		arg_Height : Long;
		arg_fld,
		arg_saveicons,
		arg_showicons,
		arg_showodc,
		arg_infoodc : Boolean;
	End;
	
	pmn = ^tmn;
	tmn = Record
		ln_Succ         : pmn;
		ln_Pred         : pmn;
		ln_AbsNameSize  : byte;
		ln_DirEntryType : shortint;
		ln_Name         : STRPTR;
		ln_NumSTxt      : byte;
	end;
	
	pEnDisWin = ^tEnDisWin;
	tEnDisWin = Record
		edw_req : pRequester;
		edw_oldwidth,
		edw_oldheight : LONG;
	End;
	
	
	
Const
	ves : String[28] = '$VER: Shrub 1.14 (25.04.95)'#0;
	
	cdir  : String = '';
	grk   : pRemember = NIL;
	th    : pTreeHandle = NIL;
	empty : Boolean = True;
	w2    : pWindow = NIL;
	secs  : LONG = 0;
	mics  : LONG = 0;
	cnode : pmn = NIL;
	ValidPattern : Boolean = False;
	G_NI  = 0;
	G_LV  = 1;
	G_DIR = 2;
	G_CC  = 3;
	DEFTITLE = 'Shrub ©Lee Kindness.';
	MININFOVER = 39;
	
	M_DIR    = 12;
	M_SAVE   =  1;
	M_INFO   =  2;
	M_PRINT  = 10;
	M_ABOUT  =  3;
	M_QUIT   =  4;
	M_SHOWDC = 14;
	M_INFODC = 15;
	M_FIND   = 11;
	M_FINDNEXT=13;
	M_SICO   =  5; { save icons? }
	M_SHOW   =  6; { show icons }
	M_FLD    =  7; { follow linked drawers }
	M_SODC   =  8; { show on double click }
	M_IODC   =  9; { info on double click }
	
	MN_INFO     = 1;
	MN_SAVAS    = 3;
	MN_PRINT    = 5;
	MN_FIND     = 0;
	MN_FINDNEXT = 1;
	
	TBS     = 0;
	S_Gad_H = 1;
	
	VIEW_ACTION_INFO = 1;
	VIEW_ACTION_SHOW = 2;
	
	FIND_ITEM = 1;
	FIND_NEXTITEM = 2;	
	
Var
	al          : Array[0..3] of LONG;
	S           : Array[0..1] of LONG;
	gadgetflags : tNewGadget;
	G           : Array[G_NI..G_CC] of pGadget;
	vi          : Pointer;
	My_Font     : tTextAttr;
	tf          : pTextFont;
	menustrip   : pMenu;
	OK          : Boolean;
	numf, numd, 
	tnumf       : LONG;
	arg         : tProgVars;
	proc        : pProcess;
	oldwp       : pWindow;
	aw          : pAppWindow;
	AppPort     : pMsgPort;
	oldsecs, 
	oldmics     : LONG;
	wintitle,
	scrtitle    : String;
	SearchText,
	buf         : String;
	SKey        : Packed Array[0..513] of Char;
	
function CStrConstPtrAR(rk : ppRemember; s : String) : STRPTR;
VAR
	p : STRPTR;
begin
  s := s + #0;                                   { Make "C" string               }
  p := AllocRemember(rk, length(s), MEMF_CLEAR); { Get some mem for it           }
  move(s[1], p^, length(s));                     { Move s into newly alloc'd mem }
  CStrConstPtrAR := p;                           { Return the pointer            }
end;

Procedure Main; Forward;
Function  OpenTheWindow : pWindow; Forward;
Procedure ProcessWindowEvents(VAR w : pWindow); Forward;
Procedure CloseTheWindow(w : pWindow); Forward;
Function  AllocTree(th : pTreeHandle) : pTreeHandle; Forward;
Procedure FreeTree(VAR th : pTreeHandle); Forward;
Procedure FormatName(DirLevel : Byte; dt : LONG; th : pTreeHandle); Forward;
Procedure CreateTree(th : pTreeHandle; Initial : Boolean); Forward;
Procedure StripFileNameToDir(VAR obj : String); Forward;
Procedure EnableMenuItems(w : pWindow); Forward;

{$I Window.PAS     }
{$I TreeIt.Pas     }
{$I ToolType.PAS   }
{$I ProcessMsg.PAS }


Procedure Main;
Var
	Win : pWindow;

Begin
	if pLibrary(SysBase)^.lib_Version < 36 then begin
		Halt;
	End;
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',36));
	GadToolsBase := OpenLibrary('gadtools.library', 36);
	AslBase := OpenLibrary('asl.library',36);
	IconBase := OpenLibrary('icon.library',36);
	WorkbenchBase := OpenLibrary('workbench.library',36);
	GfxBase := pGfxBase(OpenLibrary('graphics.library',36));
	ReqtoolsBase := pReqtoolsBase(OpenLibrary('reqtools.library',38));
	If (intuitionBase <> NIL) and (GadToolsBase <> NIL) and (AslBase <> NIL) 
	and (IconBase <> NIL) and (WorkbenchBase <> NIL) and (GfxBase <> NIL) and (ReqToolsBase <> NIL) then begin
		th := AllocTree(th);
		if th <> NIL then begin
			GetToolTypes(arg);
			if arg.arg_Dir <> '' then begin
				th^.th_Loc := Lock(CStrConstPtrAR(@th^.th_RK, arg.arg_Dir), ACCESS_READ);
				if th^.th_Loc <> NULL then begin
					CreateTree(th, True);
					cdir := FExpandLock(th^.th_Loc);
				End else begin
					DisplayBeep(NIL);
					th^.th_Loc := NULL;
				End;	
			End;				
			Win := OpenTheWindow;
			if Win <> NIL then begin
				AddAppWin(win);
				ProcessWindowEvents(win);
				RemoveAppWin;
				CloseTheWindow(win);
			End;
			FreeTree(th);
		End;
		FreeRemember(@grk, True);
		CloseLibrary(pLibrary(GfxBase));
		CloseLibrary(pLibrary(ReqtoolsBase));
		CloseLibrary(pLibrary(WorkbenchBase));
		CloseLibrary(pLibrary(IconBase));
		CloseLibrary(pLibrary(AslBase));
		CloseLibrary(pLibrary(GadToolsBase));
		CloseLibrary(pLibrary(IntuitionBase));
	End;
End;

Begin Main End.