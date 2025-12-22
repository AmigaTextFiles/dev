{PCQ Include file for GEngine.library v1.0}


{$I "Include:Exec/Libraries.i"}
{$I "Include:Graphics/Text.i"}
{$I "Include:Graphics/View.i"}
{$I "Include:Graphics/RastPort.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Utils/GE_Hooks.i"}
{$I "Include:Libraries/GE_MemPools.i"}

Type

 GEBase = Record
      eb_LibN : Library;
      eb_Flags,
      eb_pad	: Byte;
      eb_SysLib,
      eb_DosLib,
      eb_MathLib,
      eb_GraphLib,
      eb_IntuiLib,
      eb_SegList: Address;
      eb_Prefs : Address;
      eb_Hook1,
      eb_Hook2 : HookPtr;
      eb_ObjPool: GE_MemPoolPtr; {Object Memory Pool}
      eb_ClassTree: AVLNodePtr; {Public classes AVLTree}
      eb_WinList : MinList; {List of windows with objects attached}
 end;

 GEBasePtr = ^GEBase;

 CTriplet = Array[1..3] of Integer;

 GPreferences = Record
	gp_Flags : Integer;
	gp_WnFont,
	gp_SmFont,
	gp_BgFont: TextAttrPtr;
	gp_BkgCol,
	gp_TxtCol,
	gp_ShiCol,
	gp_HShCol,
	gp_DrkCol,
	gp_HDkCol,
	gp_HglCol,
	gp_SltCol: CTriplet; {Default Colors}
	gp_BtStyle,   {Default Button Style}
	gp_BtBackPen, {Default Button BackGround Pen}
	gp_BtPresPen, {Default Button BackGround Pen in recessed State}
	gp_Reserved1: Short;
	gp_BtTxtFont: TextAttrPtr; {Default Text Button Font}
	gp_SlStyle,   {Default Slider Knob Style}
	gp_SlCStyle,  {Default Slider Container Style}
	gp_SlArrPosition, {Default Arrow Position}
	gp_Reserved2: Short;
	gp_SlTxtFont: TextAttrPtr; {Default Font for inside sliders text}
	gp_StStyle: Short; {Default String gadget style}
 end;

 GPreferencesPtr = ^GPreferences;

{ Pen-Info, contiene informacion sobre la paleta}
{Basado en DrawInfo}

  PenInfo = Record
		PI_Version : Short; {Version}
		PI_Flags   : Short; {Flags}
		PI_Pad1	   : Short;
		PI_NumPens : Short; {Numero de pens}
		PI_PenArray: Address; {Puntero a arreglo shorts}
		PI_ColorMap: ColorMapPtr; {ColorMap}
		PI_Reserved: Array[1..8] of Integer;
	    end;

  PenInfoPtr = ^PenInfo;

CONST
{Pen names}

  BKGPEN = 0;
  TXTPEN = 1;
  SHIPEN = 2;
  HSHPEN = 3;
  DRKPEN = 4;
  HDKPEN = 5;
  HGHPEN = 6;
  SLTPEN = 7;

VAR
 GEngineBase: GEBasePtr;

Procedure RGBtoHSL(R,G,B:Integer; VAR H,S,L:Short);
External;

Function GetFreePen(Vp:ViewPortPtr):Short;
External;

Function GetClosestPen(Vp:ViewPortPtr; r,g,b:Integer):Short;
External;

Function Look4Color(Vp:ViewPortPtr;r,g,b:Integer):Short;
External;

Function GetBestPen(Vp:ViewPortPtr; r,g,b:Integer):Short;
External;

Function AllocGRPort(Width,Height,Depth:Short):RastPortPtr;
External;

Procedure FreeGRPort(RP:RastPortPtr);
External;

Function GetPenInfo(Sc:ScreenPtr):PenInfoPtr;
External;

Procedure FreePenInfo(PI:PenInfoPtr);
External;

Function CModulo(X,Y:Real):Real;
External;

Function CAlpha(X,Y:Real):Real;
External;
