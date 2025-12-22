{$DEFINE PREFSEDITOR}

TYPE
	pMyNode = ^tMyNode;
	tMyNode = record
		LSK_Node     : tNode; { system node structure }
		LSK_Name     : string[31];
		LSK_Cmd      : array[0..1] of string[181];
		LSK_Key      : string[2];
		LSK_RexxCmd  : string[180];
		LSK_RexxPort : String[25];
		LSK_Stack,
		LSK_Priority : LongInt;
		LSK_ASynch   : Boolean;
		LSK_OutPut   : String[180];
		LSK_Quit     : Boolean;
		LSK_NewShell : Boolean;
		LSK_ShellFrom,
		LSK_ShellWin : String[80];
	end;

CONST

	{ Gadget ID's }
	G_NI        = 1; { NULL initialised gadget   }
	{ Button gadgets }
	G_B_TOP     = 2;
	G_B_UP      = 3;
	G_B_DOWN    = 4;
	G_B_BOTTOM  = 5;
	G_B_SORT    = 6;
	G_B_NEW     = 7;
	G_B_REMOVE  = 8;
	G_B_COPY    = 9;
	G_B_SAVE    = 10;
	G_B_CANCEL  = 11;
	{ listview gadget }
	G_LV        = 12;
	G_C_SET     = 13;
	{ CreateContext() gadget }
	G_CC        = 14; 
	
	{ Menu identifiers }
	MM_PROJ = 0;
	MI_OPEN = 0;
	MI_SAVA = 1;
	MI_TEST = 2;
	MI_INFO = 4;
	MI_QUIT = 6;
	MM_EDIT = 1;
	MI_RDEF = 0;
	MI_REST = 1;
	
	{ Setting identifiers }
	C_REXX = 0;
	C_FONT = 1;
	C_PALT = 2;
	C_QUAL = 3;
	C_SCRN = 4;
	C_SMID = 5;
	C_SFNT = 6;
	C_SYSS = 7;
	C_TITL = 8;
	LabMax = 8;
	
	

	{ size labels }

	S_Gad_H   = 1;
	S_G1_L    = 2;
	S_G2_L    = 3;
	S_G3_L    = 4;
	S_WB_T    = 6;
	S_WB_L    = 7;
	S_WB_R    = 8;
	S_WB_B    = 9;
	S_G1_W    = 10;
	S_G2_W    = 11;
	S_G3_W    = 12;
	S_G_H     = 13;
	S_LV_H    = 14;
	TBS       = 15;
	extra     = 16;
	S_SCRID_W = 17;
	TxtWin_L  = 18;
	RexxWin_L = 19;
	Synch_W   = 20;
	SOTxt_W   = 21;
	QTxt_W    = 22;
	S_CM_W    = 23;

	G_B_BOTTOMtxt : string[8]  = '_Bottom'#0;
	G_B_TOPtxt    : string[5]  = '_Top'#0;
	G_B_UPtxt     : string[4]  = '_Up'#0;
	G_B_DOWNtxt   : string[6]  = 'Do_wn'#0;
	G_B_SORTtxt   : string[5]  = 'Sort'#0;
	G_B_NEWtxt    : string[5]  = '_New'#0;
	G_B_REMOVEtxt : string[8]  = 'Remo_ve'#0;
	G_B_COPYtxt   : string[6]  = 'Cop_y'#0;
	G_B_SAVEtxt   : string[6]  = '_Save'#0;
	G_B_CANCELtxt : string[8]  = '_Cancel'#0;
	Sampstr       : string[25] = 'XxXxXxXxXxXxXxXxXxXxXxX'#0;
	SampStr2      : String[5] = '337'#0;
	PREFSNAME     : string[18] = 'Startup-Menu.prefs';
	PREFSDIRH     : string[02] = 'S:';
	vi            : pointer = NIL;
	TheWindow     : pWindow = NIL;
	CurrentTop    : Longint = 0;
	CurrentOrd    : Longint = -1;
	Listviewrows  : Longint = 20;
	ZoomSizes     : Array[0..3] of Integer = (-1,-1,200,0);
	RememberKey   : pRemember = NIL;
	Curset        : LONG = 0;
   
{ global variables }      
Var
	SetList      : pList;
	Gads         : Array [G_NI..G_CC] Of pGadget;
	Gadgetflags  : tNewGadget;
	My_Font      : tTextAttr;
	Sizes        : Array[1..23] Of Integer;
	DummyReq     : tRequester;
	WindowIDCMP  : LONG;
	CurrentList  : pList;
	CurrentNode  : pMyNode;
	pred, succ, 
	tmpnode, 
	newnode      : pMyNode;
	i, oldord    : longint;
	wl           : pointer;
	tl           : long;
	V39          : Boolean;
	menuStrip    : pMenu;
	Labs         : Array[0..9] of STRPTR;
	
{ FORWARD our functions and procedures }

Function  GadEDWindow(Left, Top : Integer; node : pMyNode; RexxWished : Boolean) : Boolean; Forward;
Function  Add_Name(name : string) : pMyNode; Forward;
Procedure DetachObjectList; Forward;
Procedure AttachObjectList; Forward;
Procedure SortGadgetFunc; Forward;
Function  CalcDown(across : integer; gad : pGadget; win : pWindow) : Longint; Forward;
Procedure RexxEDWin(Left, Top : Integer; VAR Cmd1, RexxPort1, CMD2, 
	RexxPort2, Cmd3, RexxPort3 : string; VAR RexxWished : Boolean); Forward;
Procedure InitCD; Forward;
Procedure Close_Window; Forward;
Procedure HandleIDCMP; Forward;
Procedure main; Forward;
Procedure SysOptWin(Left, Top : Integer); Forward;
Procedure QualWin(Left, Top : Integer); Forward;
Procedure RefreshWin(Window : pWindow); Forward;
Function  open_window : Boolean; Forward;
Function  Open_Libs : Boolean; Forward;
Procedure Close_Libs; Forward;
Procedure DisableGadget(g : pGadget; w : pWindow; Disable : byte); Forward;
function  CStrConstPtrAR(rk : ppRemember; s : string) : pointer; Forward;
Function  Execsynch(cmd : STRPTR) : Boolean; Forward;
Function  UpperStr(s:String):String;Forward;
Procedure SWWindow(Left, Top : Integer); Forward;

{$I Version.h            }
                          {sI Reg.PAS              }
{$I Config.PAS           }
{$I List.PAS             }
{$I Library.PAS          }
{$I Window_Main.PAS      }
{$I Window_GadgetED.PAS  }
{$I Window_Rexx.PAS      }
{$I Window_SysOpt.PAS    }
{$I Window_Qualifier.PAS }
{$I Window_S+W.PAS        }