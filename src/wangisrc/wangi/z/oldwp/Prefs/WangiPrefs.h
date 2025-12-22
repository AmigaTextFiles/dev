{$DEFINE PREFSEDITOR}

TYPE
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
		arg_FileName,
		arg_DirPart,
		arg_FilePart : String;
	End;
	
Const
	{ constants fo ipc_Type }
	IPC_SENDSIZES    = 1;
	IPC_REQUESTSIZES = 3;

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
	MI_OPEN = 1;
	MI_APPE = 2;
	MI_SAVA = 3;
	MI_TEST = 4;
	MI_INFO = 5;
	MI_QUIT = 6;
	MI_RDEF = 7;
	MI_REST = 8;
	
	{ Setting identifiers }
	C_FONT = 0;
	C_STIT = 1;
	C_WTIT = 2;
	C_POSI = 3;
	LabMax = 3;
	
	

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
	PREFSNAME     : string[14] = 'S:Wangi.prefs';
	vi            : pointer = NIL;
	TheWindow     : pWindow = NIL;
	CurrentTop    : Longint = 0;
	CurrentOrd    : Longint = -1;
	Listviewrows  : Longint = 20;
	ZoomSizes     : Array[0..3] of Integer = (-1,-1,200,0);
	RememberKey   : pRemember = NIL;
	Curset        : LONG = 0;
	BF_W  = 10;
	BF_H  =  5;
	BBF_H = 20;
    
Var
	CurrentList : pList;
	
function  CStrConstPtrAR(rk : ppRemember; s : string) : pointer; Forward;
{$I Config.PAS }

{ global variables }      
Var
	reg          : tKey;
	SetList      : pList;
	Gads         : Array [G_NI..G_CC] Of pGadget;
	Gadgetflags  : tNewGadget;
	My_Font      : tTextAttr;
	Sizes        : Array[1..23] Of Integer;
	DummyReq     : tRequester;
	WindowIDCMP  : LONG;
	CurrentNode  : pMyNode;
	pred, succ, 
	tmpnode, 
	newnode      : pMyNode;
	i, oldord    : longint;
	wl           : pointer;
	tl           : long;
	V39          : Boolean;
	menuStrip    : pMenu;
	Labs         : Array[0..LabMax] of STRPTR;
	V            : tProgVars;
	bf           : tBackFill;
	aw           : pAppWindow;
	AppPort      : pMsgPort;
	
{ FORWARD our functions and procedures }

Function  GadEDWindow(Left, Top : Integer; node : pMyNode) : Boolean; Forward;
Procedure PosWindow(Left, Top : Integer); Forward;
Function  Add_Name(name : string) : pMyNode; Forward;
Procedure DetachObjectList; Forward;
Procedure AttachObjectList; Forward;
Procedure SortGadgetFunc; Forward;
Function  CalcDown(across : integer; gad : pGadget; win : pWindow) : Longint; Forward;
Procedure InitCD; Forward;
Procedure Close_Window; Forward;
Procedure HandleIDCMP; Forward;
Procedure main; Forward;
Function  open_window : Boolean; Forward;
Function  Open_Libs : Boolean; Forward;
Procedure Close_Libs; Forward;
Procedure DisableGadget(g : pGadget; w : pWindow; Disable : byte); Forward;
Function  Execsynch(cmd : STRPTR) : Boolean; Forward;
Function  UpperStr(s:String):String;Forward;

{$I Version.h            }
{$I Tooltype.PAS         }
{$I List.PAS             }
{$I Library.PAS          }
{$I Window_Main.PAS      }
{$I Window_GadgetED.PAS  }
{$I Window_Pos.PAS       }