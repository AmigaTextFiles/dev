USES Exec, Intuition, utility, Amiga, gadtools, graphics, 
		DiskFont, AmigaDOS, Reqtools, Rexx, Trackdisk, Input, 
		Datatypes, DataTypesClass, CStrConstPtr;

TYPE
	pMyNode = ^tMyNode;
	tMyNode = record
		LSK_Node     : tNode; { system node structure }
		LSK_Name     : string[31];
		LSK_Cmd      : Array[0..1] of string[181];
		LSK_Key      : string[2];
		LSK_RexxCmd  : string[180];
		LSK_RexxPort : String[25];
		LSK_Stack,
		LSK_Priority : LongInt;
		LSK_Output   : String[181];
		LSK_ASynch   : Boolean;
		LSK_Quit     : Boolean;
		LSK_NewShell : Boolean;
		LSK_ShellFrom,
		LSK_ShellWin : String[80];
	end;
	
	tPointerArray = Array[0..36] of Word;
	pPointerArray = ^tPointerArray;
	
CONST
	
 { size labels } 

	S_WB_T  = 1; { WB borders, top          }
	S_WB_L  = 2; { left,                    }
	S_WB_R  = 3; { right,                   }
	S_WB_B  = 4; { bottom.                  }
	GAD_W  = 5;  { width of a gadget        }
	GAD_H  = 6;  { height of a gadget       }
	TBS = 6;     { Size of window title bar }
	

{defaut path and name of our prefs file}

	PREFSNAME  : string[80] = 'Startup-Menu.prefs';
	PREFSDIRH  : string[80] = 'S:';
	vi         : pointer = NIL;
	TheWindow  : pWindow = NIL;
	TheScreen  : pScreen = NIL;
	MyPens : Array[0..8] of Word = ($FFFF); { Get default }
	FORCEQ    : Boolean = False;
	RememberKey: pRemember = NIL;
	dto : Pointer = NIL;
	ZoomS : Array[0..3] of Integer = (-1,-1,150,0);

         
Var
	Window2 : pWindow;
	GList, pGad  : pGadget;
	Gadgetflags  : tNewGadget;
	MyTextFont   : pTextFont;
	Sizes        : Array[1..6] Of Integer;
	WindowIDCMP,
	Base         : LONG;
	CurrentList  : pList;
	tmpstr       : string;
	DummyReq     : tRequester;
	waitpointer  : pPointerArray;
	
{ Procedures and Functions }

Function  ReadConfigFile(FName : string) : Boolean; Forward;
Procedure SendARexxCommand(command, destport : string); Forward;
Function  HandleIDCMP : ShortInt; Forward;
Function  StartCLIProgram(node : pMyNode) : Boolean; Forward;
Function  Open_Libs : Boolean; Forward;
Procedure Close_Libs; Forward;
Procedure Close_Screen; Forward;
Function  Open_Screen : pScreen; Forward;
Function  GetWitComment : String; Forward;
Procedure ScrollText(RPort : pRastPort;  L, B, W, H : Long; 
	VAR count : integer; txt : string); Forward;
Procedure Main; Forward;
Procedure ToggleClick(state : Boolean); Forward;
Procedure Close_Window; Forward;
Function  UnderIfThere(s : string; ch : char):string; Forward;
Procedure RefreshWin; Forward;
Function  open_window : pWindow; Forward;
Procedure DisableWindow(w : pWindow; req : pRequester;  waitpointer : pointer); Forward;
Procedure EnableWindow(w : pWindow; req : pRequester; IDCMP : LONG); Forward;
Function  UpperStr(S : String) : String; Forward;
Procedure ToggleWildStar(State : Boolean); Forward;
Procedure TogglePubFlags(shang, poppub : Boolean); Forward;
Function  OpenDTWin(fn : STRPTR) : pWindow; Forward;
Procedure CloseDTWin(VAR win : pWindow); Forward;


{ include files }

{$I Version.h      }
                   {sI Reg.PAS        }
{$I Config.PAS     }
{$I ARexx.PAS      }
{$I LogFile.PAS    }
{$I IDCMP.PAS      }
{$I LaunchProgram.PAS }
{$I Library.PAS    }
{$I Screen.PAS     }
{$I ScrollText.PAS }
{$I StopClick.PAS  }
{$I Window.PAS     }
{$I WildStar.PAS   }
{$I PubFlags.PAS   }
{$I Window_DT.PAS  }

