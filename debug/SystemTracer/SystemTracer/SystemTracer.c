           
/* SYSTEM TRACER V1.0   written by Guido Burkard */
/* --------------------------------------------- */

#define		UP		65		/* Special Editor Codes     */
#define		DOWN		66
#define		RIGHT		67
#define		LEFT		68

#define		CR		13
#define		SPACE		32
#define		DEL		127
#define		BS		8
#define		ESC		27
#define		HELP		63
#define		LF		10
#define		FF		12
#define		FKEYS		47
#define		TAB		9

#define		TOP		20
#define		BOTTOM		2
#define		PGUP		17
#define		PGDOWN		26
#define		DELIN		24
#define		BOL		1
#define		EOL		19

char spaces[80] = "                                                                              ";
char back[80];
char string[320];
char buffer[320];
char execname[9] = "ExecBase";
char gfxname[8] = "GfxBase";
char intuitionname[14] = "IntuitionBase";
char mode;
char tag[25] = "SYSTEM TRACER STRUCTURE ";
char adrquest[11] = "Address: $";
char insert_string[27] = "/* insert own data here */";
char insert_string2[23] = "; insert own data here";
char save_structure[17] = "Save structure: ";
char no_such_structure[20] = "No such structure.\n";
char filename_quest[11] = "Filename: ";
char even_string[6] = "\neven";
char comma[3] = ", ";
char ioname[]= "raw:0/0/640/200/SystemTracer V1.0   written by Guido Burkard";
char title[]="\n    **** SYSTEM TRACER ****\nwritten in 1990 by Guido Burkard\n\n";
char user_break[]="*** user break\n";
char help_text1[]="Command help:\nn new(next) structure\np previous structure\nc close window(hit HELP to re-open)\no open library\ns system (hex/dec)\nl list structure\nw write structure to memory\nr read structure from mem\n";
char help_text2[]="e edit structure entry\nm monitor mem\nd disk operations\nf free structure mem\nt type string to mem\nu untype(free) string mem\nh,? help\nx,q exit\nuse CTRL to pause, SHIFT to break output\n\n";

struct IntuitionBase *IntuitionBase;

unsigned int file,io;

#define	DECIMAL		10			/* Modes	*/
#define	HEXADECIMAL	16

#define	BYTE		1			/* Types	*/
#define	UBYTE		2
#define	WORD		3
#define	UWORD		4
#define	LONG		5
#define	ULONG		6
#define	STRING		7
#define	STRINGPTR	8
#define	STRUCTURE	9
#define	STRUCTUREPTR	10

#define	STACKSIZE	64			/* Stack	*/

struct
{
	unsigned int nr;
	long address;
	char *name;
	int index;
} stack[STACKSIZE];

#define ENTRYSIZE	825

struct						/* Structure-entries	*/
{
	unsigned char type;
	unsigned int dimension;
	char name[16];
	unsigned int pointer;
} entry[ENTRYSIZE] =

{
	STRUCTURE,	1,	"LibNode        ",1,	/* 0 ExecBase	*/
	UWORD,		1,	"SoftVer        ",0,
	WORD,		1,	"LowMemChkSum   ",0,
	ULONG,		1,	"ChkBase        ",0,
	LONG,		1,	"ColdCapture    ",0,
	LONG,		1,	"CoolCapture    ",0,
	LONG,		1,	"WarmCapture    ",0,
	LONG,		1,	"SysStkUpper    ",0,
	LONG,		1,	"SysStkLower    ",0,
	ULONG,		1,	"MaxLocMem      ",0,
	LONG,		1,	"DebugEntry     ",0,
	LONG,		1,	"DebugData      ",0,
	LONG,		1,	"AlertData      ",0,
	LONG,		1,	"MaxExtMem      ",0,
	UWORD,		1,	"ChkSum         ",0,
	STRUCTURE,	16,	"IntVects       ",4,
	STRUCTUREPTR,	1,	"ThisTask       ",5,
	ULONG,		1,	"IdleCount      ",0,
	ULONG,		1,	"DispCount      ",0,
	UWORD,		1,	"Quantum        ",0,
	UWORD,		1,	"Elapsed        ",0,
	UWORD,		1,	"SysFlags       ",0,
	BYTE,		1,	"IDNestCnt      ",0,
	BYTE,		1,	"TDNestCnt      ",0,
	UWORD,		1,	"AttnFlags      ",0,
	UWORD,		1,	"AttnResched    ",0,
	LONG,		1,	"ResModules     ",0,
	LONG,		1,	"TaskTrapCode   ",0,
	LONG,		1,	"TaskExceptCode ",0,
	LONG,		1,	"TaskExitCode   ",0,
	ULONG,		1,	"TaskSigAlloc   ",0,
	UWORD,		1,	"TaskTrapAlloc  ",0,
	STRUCTURE,	1,	"MemList        ",3,
	STRUCTURE,	1,	"ResourceList   ",3,
	STRUCTURE,	1,	"DeviceList     ",3,
	STRUCTURE,	1,	"IntrList       ",3,
	STRUCTURE,	1,	"LibList        ",3,
	STRUCTURE,	1,	"PortList       ",3,
	STRUCTURE,	1,	"TaskReady      ",3,
	STRUCTURE,	1,	"TaskWait       ",3,
	STRUCTURE,	5,	"SoftInts       ",6,
	LONG,		4,	"LastAlert      ",0,
	UBYTE,		1,	"VBlankFrequency",0,
	UBYTE,		1,	"PowerSupplyFreq",0,
	STRUCTURE,	1,	"SemaphoreList  ",3,
	LONG,		1,	"KickMemPtr     ",0,
	LONG,		1,	"KickTagPtr     ",0,
	LONG,		1,	"KickCheckSum   ",0,
	UBYTE,		5,	"ExecBaseReserve",0,
	UBYTE,		20,	"ExecBaseNewRese",0,

	STRUCTURE,	1,	"lib_Node       ",2,	/* 1 Library	*/
	UBYTE,		1,	"lib_Flags      ",0,
	UBYTE,		1,	"lib_pag        ",0,
	UWORD,		1,	"lib_NegSize    ",0,
	UWORD, 		1,	"lib_PosSize    ",0,
	UWORD, 		1,	"lib_Version    ",0,
	UWORD, 		1,	"lib_Revision   ",0,
	STRINGPTR,	1,	"lib_IdString   ",0,
	ULONG, 		1,	"lib_Sum        ",0,
	UWORD, 		1,	"lib_OpenCnt    ",0,

	STRUCTUREPTR,	1,	"ln_Succ        ",1,	/* 2 Node	*/
	STRUCTUREPTR,	1,	"ln_Pred        ",1,
	UBYTE,		1,	"ln_Type        ",0,
	BYTE,		1,	"ln_Pri         ",0,
	STRINGPTR,	1,	"ln_Name        ",0,

	STRUCTUREPTR,	1,	"lh_Head        ",2,	/* 3 List	*/
	STRUCTUREPTR,	1,	"lh_Tail        ",2,
	STRUCTUREPTR,	1,	"lh_TailPred    ",2,
	UBYTE,		1,	"lh_Type        ",0,
	UBYTE,		1,	"l_pad          ",0,

	LONG,		1,	"iv_Data        ",0,	/* 4 IntVector	*/
	LONG,		1,	"iv_Code        ",0,
	STRUCTUREPTR,	1,	"iv_Node        ",2,

	STRUCTURE,	1,	"tc_Node        ",2,	/* 5 Task	*/
	UBYTE,		1,	"tc_Flags       ",0,
	UBYTE,		1,	"tc_State       ",0,
	BYTE,		1,	"tc_IDNestCnt   ",0,
	BYTE,		1,	"tc_TDNestCnt   ",0,
	ULONG,		1,	"tc_SigAlloc    ",0,
	ULONG,		1,	"tc_SigWait     ",0,
	ULONG,		1,	"tc_SigRecvd    ",0,
	ULONG,		1,	"tc_SigExcept   ",0,
	UWORD,		1,	"tc_TrapAlloc   ",0,
	UWORD,		1,	"tc_TrapAble    ",0,
	LONG,		1,	"tc_ExceptData  ",0,
	LONG,		1,	"tc_ExceptCode  ",0,
	LONG,		1,	"tc_TrapData    ",0,
	LONG,		1,	"tc_TrapCode    ",0,
	LONG,		1,	"tc_SPReg       ",0,
	LONG,		1,	"tc_SPLower     ",0,
	LONG,		1,	"tc_SPUpper     ",0,
	LONG,		1,	"tc_Switch      ",0,
	LONG,		1,	"tc_Launch      ",0,
	STRUCTURE,	1,	"tc_MemEntry    ",3,
	LONG,		1,	"tc_UserData    ",0,
	
	STRUCTURE,	1,	"sh_List        ",3,	/* 6 SoftIntList*/
	UWORD,		1,	"sh_pad         ",0,

	STRUCTURE,	1,	"LibNode        ",1,	/* 7 IntuitionBase*/
	STRUCTURE,	1,	"ViewLord       ",8,
	STRUCTUREPTR,	1,	"ActiveWindow   ",9,
	STRUCTUREPTR,	1,	"ActiveScreen   ",10,
	STRUCTUREPTR,	1,	"FirstScreen    ",10,
	ULONG,		1,	"Flags          ",0,
	WORD,		1,	"MouseY         ",0,
	WORD,		1,	"MouseX         ",0,
	ULONG,		1,	"Seconds        ",0,
	ULONG,		1,	"Micros         ",0,
	WORD,		1,	"MinXMouse      ",0,
	WORD,		1,	"MaxXMouse      ",0,
	WORD,		1,	"MinYMouse      ",0,
	WORD,		1,	"MaxYMouse      ",0,
	ULONG,		1,	"StartSecs      ",0,
	ULONG,		1,	"StartMicros    ",0,
	STRUCTUREPTR,	1,	"SysBase        ",0,
	STRUCTUREPTR,	1,	"GfxBase        ",11,
	LONG,		1,	"LayersBase     ",0,
	LONG,		1,	"ConsoleDevice  ",0,
	LONG,		1,	"APointer       ",0,
	BYTE,		1,	"APtrHeight     ",0,
	BYTE,		1,	"APtrWidth      ",0,
	BYTE,		1,	"AXOffset       ",0,
	BYTE,		1,	"AYOffset       ",0,
	UWORD,		1,	"MenuDrawn      ",0,
	UWORD,		1,	"MenuSelected   ",0,
	UWORD,		1,	"OptionList     ",0,
	STRUCTURE,	1,	"MenuRPort      ",12,
	STRUCTURE,	1,	"MenuTmpRas     ",13,
	STRUCTURE,	1,	"ItemCRect      ",14,
	STRUCTURE,	1,	"SubCRect       ",14,
	STRUCTURE,	1,	"IBitMap        ",15,
	STRUCTURE,	1,	"SBitMap        ",15,
	STRUCTURE,	1,	"InputRequest   ",16,
	STRUCTURE,	1,	"InputInterrupt ",17,
	STRUCTUREPTR,	1,	"EventKey       ",18,
	STRUCTUREPTR,	1,	"IEvents        ",19,
	WORD,		1,	"EventCount     ",0,
	STRUCTURE,	4,	"IEBuffer       ",19,
	STRUCTUREPTR,	1,	"ActiveGadget   ",20,
	STRUCTUREPTR,	1,	"ActivePInfo    ",21,
	STRUCTUREPTR,	1,	"ActiveImage    ",22,
	STRUCTURE,	1,	"GadgetEnv      ",23,
	STRUCTURE,	1,	"GadgetInfo     ",24,
	STRUCTURE,	1,	"KnobOffset     ",25,
	STRUCTUREPTR,	1,	"getOKWindow    ",9,
	STRUCTUREPTR,	1,	"getOKMessage   ",26,
	UWORD,		1,	"setWExcept     ",0,
	UWORD,		1,	"GadgetReturn   ",0,
	UWORD,		1,	"StateReturn    ",0,
	STRUCTUREPTR,	1,	"RP             ",12,
	STRUCTURE,	1,	"ITmpRas        ",13,
	STRUCTUREPTR,	1,	"OldClipRegion  ",27,
	STRUCTURE,	1,	"OldScroll      ",25,
	STRUCTURE,	1,	"IFrame         ",29,
	WORD,		1,	"hthick         ",0,
	WORD,		1,	"vthick         ",0,
	LONG,		1,	"frameChange    ",0,
	LONG,		1,	"sizeDrag       ",0,
	STRUCTURE,	1,	"FirstPt        ",25,
	STRUCTURE,	1,	"OldPt          ",25,
	STRUCTUREPTR,	16,	"SysGadgets     ",20,
	STRUCTUREPTR,	2,	"CheckImage     ",22,
	STRUCTUREPTR,	2,	"AmigaIcon      ",22,
	UWORD,		8,	"apattern       ",0,
	UWORD,		4,	"bpattern       ",0,
	LONG,		1,	"IPointer       ",0,
	BYTE,		1,	"IPtrHeight     ",0,
	BYTE,		1,	"IPtrWidth      ",0,
	BYTE,		1,	"IXOffset       ",0,
	BYTE,		1,	"IYOffset       ",0,
	LONG,		1,	"DoubleSeconds  ",0,
	LONG,		1,	"DoubleMicros   ",0,
	BYTE,		2,	"WBorLeft       ",0,
	BYTE,		2,	"WBorTop        ",0,
	BYTE,		2,	"WBorRight      ",0,
	BYTE,		2,	"WBorBottom     ",0,
	BYTE,		2,	"BarVBorder     ",0,
	BYTE,		2,	"BarHBorder     ",0,
	BYTE,		2,	"MenuVBorder    ",0,
	BYTE,		2,	"MenuHBorder    ",0,
	UWORD,		1,	"color0         ",0,
	UWORD,		1,	"color1         ",0,
	UWORD,		1,	"color2         ",0,
	UWORD,		1,	"color3         ",0,
	UWORD,		1,	"color17        ",0,
	UWORD,		1,	"color18        ",0,
	UWORD,		1,	"color19        ",0,
	STRUCTURE,	1,	"SysFont        ",30,
	STRUCTUREPTR,	1,	"Preferences    ",31,
	LONG,		1,	"Echoes         ",0,
	WORD,		1,	"ViewInitX      ",0,
	WORD,		1,	"ViewInitY      ",0,
	WORD,		1,	"CursorDX       ",0,
	WORD,		1,	"CursorDY       ",0,
	STRUCTUREPTR,	1,	"KeyMap         ",32,
	WORD,		1,	"MouseYMinimum  ",0,
	WORD,		1,	"ErrorX         ",0,
	WORD,		1,	"ErrorY         ",0,
	STRUCTURE,	1,	"IOExcess       ",33,
	WORD,		1,	"HoldMinYMouse  ",0,
	STRUCTUREPTR,	1,	"WBPort         ",35,
	STRUCTUREPTR,	1,	"iqd_FNKUHDPort ",35,
	STRUCTURE,	1,	"WBMessage      ",26,
	STRUCTUREPTR,	1,	"HitScreen      ",10,
	STRUCTUREPTR,	1,	"SimpleSprite   ",36,
	STRUCTUREPTR,	1,	"AttachedSSprite",36,
	BYTE,		1,	"GotSprite1     ",0,
	STRUCTURE,	1,	"SemaphoreList  ",3,
	STRUCTURE,	7,	"ISemaphore     ",37,
	WORD,		1,	"MaxDisplayH.ght",0,
	WORD,		1,	"MaxDisplayRow  ",0,
	WORD,		1,	"MaxDisplayWidth",0,
	ULONG,		7,	"Reserved       ",0,

	STRUCTUREPTR,	1,	"ViewPort       ",38,	/* 8 View */
	STRUCTUREPTR,	1,	"LOFCprList     ",40,
	STRUCTUREPTR,	1,	"SHFCprList     ",40,
	WORD, 		1,	"DyOffset       ",0,
	WORD, 		1,	"DxOffset       ",0,
	UWORD,		1,	"Modes          ",0,

	STRUCTUREPTR,	1,	"NextWindow     ",9,	/* 9 Window */
	WORD,		1,	"LeftEdge       ",0,
	WORD,		1,	"TopEdge        ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,
	WORD,		1,	"MouseY         ",0,
	WORD,		1,	"MouseX         ",0,
	WORD,		1,	"MinWidth       ",0,
	WORD,		1,	"MinHeight      ",0,
	UWORD,		1,	"MaxWidth       ",0,
	UWORD,		1,	"MaxHeight      ",0,
	ULONG,		1,	"Flags          ",0,
	STRUCTUREPTR,	1,	"MenuStrip      ",41,
	STRINGPTR, 	1,	"Title          ",0,
	STRUCTUREPTR,	1,	"FirstRequest   ",43,
	STRUCTUREPTR,	1,	"DMRequest      ",43,
	WORD,		1,	"ReqCount       ",0,
	STRUCTUREPTR,	1,	"WScreen        ",10,
	STRUCTUREPTR,	1,	"RPort          ",12,
	BYTE,		1,	"BorderLeft     ",0,
	BYTE,		1,	"BorderTop      ",0,
	BYTE,		1,	"BorderRight    ",0,
	BYTE,		1,	"BorderBottom   ",0,
	STRUCTUREPTR,	1,	"BorderRPort    ",12,
	STRUCTUREPTR,	1,	"FirstGadget    ",20,
	STRUCTUREPTR,	1,	"Parent         ",9,
	STRUCTUREPTR,	1,	"Descendant     ",9,
	LONG,		1,	"Pointer        ",0,
	BYTE,		1,	"PtrHeight	",0,
	BYTE,		1,	"PtrWidth       ",0,
	BYTE,		1,	"XOffset        ",0,
	BYTE,		1,	"YOffset        ",0,
	ULONG,		1,	"IDCMPFlags     ",0,
	STRUCTUREPTR,	1,	"UserPort       ",35,
	STRUCTUREPTR,	1,	"WindowPort     ",35,
	STRUCTUREPTR,	1,	"MessageKey     ",26,
	UBYTE,		1,	"DetailPen      ",0,
	UBYTE,		1,	"BlockPen       ",0,
	STRUCTUREPTR,	1,	"CheckMark      ",22,
	STRINGPTR,	1,	"ScreenTitle    ",0,
	WORD,		1,	"GZZMouseX      ",0,
	WORD,		1,	"GZZMouseY      ",0,
	WORD,		1,	"GZZWidth       ",0,
	WORD,		1,	"GZZHeight      ",0,
	LONG,		1,	"ExtData        ",0,
	LONG,		1,	"UserData       ",0,
	STRUCTUREPTR,	1,	"WLayer         ",44,
	STRUCTUREPTR,	1,	"IFont          ",45,

	STRUCTUREPTR,	1,	"NextScreen     ",10,	/* 10 Screen */
	STRUCTUREPTR,	1,	"FirstWindow    ",9,
	WORD,		1,	"LeftEdge       ",0,
	WORD,		1,	"TopEdge        ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,
	WORD,		1,	"MouseY         ",0,
	WORD,		1,	"MouseX         ",0,
	UWORD,		1,	"Flags          ",0,
	STRINGPTR,	1,	"Title		",0,
	STRINGPTR,	1,	"DefaultTitle   ",0,
	BYTE,		1,	"BarHeight      ",0,
	BYTE,		1,	"BarVBorder     ",0,
	BYTE,		1,	"BarHBorder     ",0,
	BYTE,		1,	"MenuVBorder    ",0,
	BYTE,		1,	"MenuHBorder    ",0,
	BYTE,		1,	"WBorTop        ",0,
	BYTE,		1,	"WBorLeft       ",0,
	BYTE,		1,	"WBorRight      ",0,
	BYTE,		1,	"WBorBottom     ",0,
	STRUCTUREPTR,	1,	"Font           ",30,
	STRUCTURE,	1,	"ViewPort       ",38,
	STRUCTURE,	1,	"RastPort       ",12,
	STRUCTURE,	1,	"BitMap         ",15,
	STRUCTURE,	1,	"LayerInfo      ",46,
	STRUCTUREPTR,	1,	"FirstGadget    ",20,
	UBYTE,		1,	"DetailPen      ",0,
	UBYTE,		1,	"BlockPen       ",0,
	UWORD,		1,	"SaveColor0     ",0,
	STRUCTUREPTR,	1,	"BarLayer       ",44,
	LONG,		1,	"ExtData        ",0,
	LONG,		1,	"UserData       ",0,

	STRUCTURE,	1,	"LibNode        ",1,	/* 11 GfxBase */
	STRUCTUREPTR,	1,	"ActiView       ",8,
	STRUCTUREPTR,	1,	"copinit        ",47,
	LONG,		1,	"cia            ",0,
	LONG,		1,	"blitter        ",0,
	LONG,		1,	"LOFlist        ",0,
	LONG,		1,	"SHFlist        ",0,
	LONG,		1,	"blthd          ",0,
	LONG,		1,	"blttl          ",0,
	LONG,		1,	"bsblthd        ",0,
	LONG,		1,	"bsblttl        ",0,
	STRUCTURE,	1,	"vbsrv          ",17,
	STRUCTURE,	1,	"timsrv         ",17,
	STRUCTURE,	1,	"bltsrv         ",17,
	STRUCTURE,	1,	"TextFonts      ",3,
	STRUCTUREPTR,	1,	"DefaultFont    ",45,
	UWORD,		1,	"Modes          ",0,
	BYTE,		1,	"VBlank         ",0,
	BYTE,		1,	"Debug          ",0,
	WORD,		1,	"BeamSync       ",0,
	WORD,		1,	"system_bplcon0 ",0,
	UBYTE,		1,	"SpriteReserved ",0,
	UBYTE,		1,	"bytereserved   ",0,
	UWORD,		1,	"Flags          ",0,
	WORD,		1,	"BlitLock       ",0,
	WORD,		1,	"BlitNest       ",0,
	STRUCTURE,	1,	"BlitWaitQ      ",3,
	STRUCTUREPTR,	1,	"BlitOwner      ",5,
	STRUCTURE,	1,	"TOF_WaitQ      ",3,
	UWORD,		1,	"DisplayFlags   ",0,
	STRUCTUREPTR,	1,	"SimpleSprites  ",36,
	UWORD,		1,	"MaxDisplayRow  ",0,
	UWORD,		1,	"MaxDisplayCol  ",0,
	UWORD,		1,	"NormalDisplayRs",0,
	UWORD,		1,	"NormalDisplayCs",0,
	UWORD,		1,	"NormalDPMX     ",0,
	UWORD,		1,	"NormalDPMY     ",0,
	STRUCTUREPTR,	1,	"LastChanceMem  ",37,
	UWORD,		1,	"LCMptr         ",0,
	UWORD,		1,	"MicrosPerLine  ",0,
	ULONG,		2,	"reserved       ",0,

	STRUCTUREPTR,	1,	"Layer          ",44,   /* 12 RastPort */
	STRUCTUREPTR,	1,	"BitMap         ",15,
	LONG,		1,	"AreaPtrn       ",0,
	STRUCTUREPTR,	1,	"TmpRas         ",13,
	STRUCTUREPTR,	1,	"AreaInfo       ",48,
	STRUCTUREPTR,	1,	"GelsInfo       ",49,
	UBYTE,		1,	"Mask           ",0,
	BYTE,		1,	"FgPen          ",0,
	BYTE,		1,	"BgPen          ",0,
	BYTE,		1,	"AOlPen         ",0,
	BYTE,		1,	"DrawMode       ",0,
	BYTE,		1,	"AreaPtSz       ",0,
	BYTE,		1,	"linpatcnt      ",0,
	BYTE,		1,	"dummy          ",0,
	UWORD,		1,	"Flags          ",0,
	UWORD,		1,	"LinePtrn       ",0,
	WORD,		1,	"cp_x           ",0,
	WORD,		1,	"cp_y           ",0,
	UBYTE,		8,	"minterms	",0,
	WORD,		1,	"PenWidth       ",0,
	WORD,		1,	"PenHeight      ",0,
	STRUCTUREPTR,	1,	"Font           ",45,
	UBYTE,		1,	"AlgoStyle      ",0,
	UBYTE,		1,	"TxFlags        ",0,
	UWORD,		1,	"TxHeight       ",0,
	UWORD,		1,	"TxWidth        ",0,
	UWORD,		1,	"TxBaseline     ",0,
	WORD,		1,	"TxSpacing      ",0,
	LONG,		1,	"RP_User        ",0,
	ULONG,		2,	"longreserved   ",0,
	UWORD,		7,	"wordreserved   ",0,
	UBYTE,		8,	"reserved       ",0,

	LONG,		1,	"RasPtr         ",0,	/* 13 TmpRas */
	LONG,		1,	"Size           ",0,

	STRUCTUREPTR,	1,	"Next           ",14,	/* 14 ClipRect */
	STRUCTUREPTR,	1,	"prev           ",14,
	STRUCTUREPTR,	1,	"lobs           ",44,
	STRUCTUREPTR,	1,	"BitMap         ",15,
	STRUCTURE,	1,	"bounds         ",50,
	STRUCTUREPTR,	1,	"_p1            ",14,
	STRUCTUREPTR,	1,	"_p2            ",14,
	LONG,		1,	"reserved       ",0,
	LONG,		1,	"Flags          ",0, /* only V1.1 */

	UWORD,		1,	"BytesPerRow    ",0,	/* 15 BitMap	*/
	UWORD,		1,	"Rows           ",0,
	UBYTE,		1,	"Flags          ",0,
	UBYTE,		1,	"Depth          ",0,
	UWORD,		1,	"pad            ",0,
	LONG,		8,	"Planes         ",0,

	STRUCTURE,	1,	"io_Message     ",51, /* 16 IOStdReq */
	STRUCTUREPTR,	1,	"io_Device      ",52,
	STRUCTUREPTR,	1,	"io_Unit        ",53,
	UWORD,		1,	"io_Command     ",0,
	UBYTE,		1,	"io_Flags       ",0,
	BYTE,		1,	"io_Error       ",0,	
	ULONG,		1,	"io_Actual      ",0,
	ULONG,		1,	"io_Length      ",0,
	LONG,		1,	"io_Data        ",0,
	ULONG,		1,	"io_Offset      ",0,

	STRUCTURE,	1,	"is_Node        ",2,	/* 17 Interrupt	*/
	LONG,		1,	"is_Data        ",0,
	LONG,		1,	"is_Code        ",0,

	STRUCTUREPTR,	1,	"NextRemember   ",18,   /* 18 Remember */
	ULONG,		1,	"RememberSize   ",0,
	LONG,		1,	"Memory         ",0,

	STRUCTUREPTR,	1,	"ie_NextEvent   ",19,   /* 19 InputEvent */
	UBYTE,		1,	"ie_Class       ",0,
	UBYTE,		1,	"ie_SubClass    ",0,
	UWORD,		1,	"ie_Code        ",0,
	UWORD,		1,	"ie_Qualifier   ",0,	
	WORD,		1,	"ie_x(ie_addrhi)",0,
	WORD,		1,	"ie_y(ie_addrlo)",0,
	STRUCTURE,	1,	"ie_TimeStamp   ",34,

	STRUCTUREPTR,	1,	"NextGadget     ",20,	/* 20 Gadget */
	WORD,		1,	"LeftEdge       ",0,
	WORD,		1,	"TopEdge        ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,
	UWORD,		1,	"Flags          ",0,
	UWORD,		1,	"Activation     ",0,
	UWORD,		1,	"GadgetType     ",0,
	LONG,		1,	"GadgetRender   ",0,
	LONG,		1,	"SelectRender   ",0,
	STRUCTUREPTR,	1,	"GadgetText     ",54,	
	LONG,		1,	"MutualExclude  ",0,
	LONG,		1,	"SpecialInfo    ",0,
	UWORD,		1,	"GadgetID       ",0,
	LONG,		1,	"UserData       ",0,

	UWORD,		1,	"Flags          ",0,	/* 21 PropInfo */
	UWORD,		1,	"HorizPot       ",0,
	UWORD,		1,	"VertPot        ",0,
	UWORD,		1,	"HorizBody      ",0,
	UWORD,		1,	"VertBody       ",0,
	UWORD,		1,	"CWidth         ",0,
	UWORD,		1,	"CHeight        ",0,
	UWORD,		1,      "HPotRes        ",0,
	UWORD,		1,      "VPotRes        ",0,
	UWORD,		1,	"LeftBorder     ",0,
	UWORD,		1,	"TopBorder      ",0,

	WORD,		1,	"LeftEdge       ",0,	/* 22 Image  */	
	WORD,		1,	"TopEdge        ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,
	WORD,		1,	"Depth          ",0,
	LONG,		1,	"ImageData      ",0,
	UBYTE,		1,	"PlanePick      ",0,
	UBYTE,		1,	"PlaneOnOff     ",0,
	STRUCTUREPTR,	1,	"NextImage      ",22,

	STRUCTUREPTR,	1,	"ge_Screen      ",10,	/* 23 GListEnv */
	STRUCTUREPTR,	1, 	"ge_Window      ",9,
	STRUCTUREPTR,	1,	"ge_Requester   ",43,
	STRUCTUREPTR,	1,	"ge_RastPort    ",12,
	STRUCTUREPTR,	1,	"ge_Layer       ",44,
	STRUCTUREPTR,	1,	"ge_GZZLayer    ",44,
	STRUCTURE,	1,	"ge_Pens        ",55,
	STRUCTURE,	1,	"ge_Domain      ",29,
	STRUCTURE,	1,	"ge_GZZdims     ",29,

	STRUCTUREPTR,	1,	"gi_Environ     ",23,   /* 24 GadgetInfo */
	STRUCTUREPTR,	1,	"gi_Gadget      ",20,
	STRUCTURE,	1,	"gi_Box         ",29,
	STRUCTURE,	1,	"gi_Container	",29,
	STRUCTUREPTR,	1,	"gi_Layer       ",44,
	STRUCTURE,	1,	"gi_NewKnob     ",29,

	WORD,		1,	"X              ",0,	/* 25 Point */
	WORD,		1,	"Y              ",0,

	STRUCTURE,	1,	"ExecMessage    ",51, /* 26 IntuiMessage*/
	ULONG,		1,	"Class          ",0,
	UWORD,		1,	"Code           ",0,
	UWORD,		1,	"Qualifier      ",0,
	LONG,		1,	"IAddress       ",0,
	WORD,		1,	"MouseX         ",0,
	WORD,		1,	"MouseY         ",0,
	ULONG,		1,	"Seconds        ",0,
	ULONG,		1,	"Micros         ",0,
	STRUCTUREPTR,	1,	"IDCMPWindow    ",9,
	STRUCTUREPTR,	1,	"SpecialLink    ",26,

	STRUCTURE,	1,	"bounds         ",50, /* 27 Region */
	STRUCTUREPTR,	1,	"RegionRectangle",28,

	STRUCTUREPTR,	1,	"Next           ",28,	/* 28 RegionRectangle*/
	STRUCTUREPTR,	1,	"Prev           ",28,
	STRUCTURE,	1,	"bounds         ",50,

	WORD,		1,	"Left           ",0,	/* 29 IBox */
	WORD,		1,	"Top            ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,

	STRINGPTR,	1,	"ta_Name        ",0,	/* 30 TextAttr	*/
	UWORD,		1,	"ta_YSize       ",0,
	UBYTE,		1,	"ta_Style       ",0,
	UBYTE,		1,	"ta_Flags	",0,

	BYTE,		1,	"FontHeight     ",0,	/* 31 Preferences */
	UBYTE,		1,	"PrinterPort    ",0,
	UWORD,		1,	"BaudRate       ",0,
	STRUCTURE,	1,	"KeyRptSpeed    ",34,
	STRUCTURE,	1,	"KeyRptDelay    ",34,
	STRUCTURE,	1,	"DoubleClick    ",34,
	UWORD,		36,	"PointerMatrix  ",0,
	BYTE,		1,	"XOffset        ",0,
	BYTE,		1,	"YOffset        ",0,
	UWORD,		1,	"color17        ",0,
	UWORD,		1,	"color18        ",0,
	UWORD,		1,	"color19        ",0,
	UWORD,		1,	"PointerTicks   ",0,
	UWORD,		1,	"color0         ",0,
	UWORD,		1,	"color1         ",0,
	UWORD,		1,	"color2         ",0,
	UWORD,		1,	"color3         ",0,
	BYTE,		1,	"ViewXOffset    ",0,
	BYTE,		1,	"ViewYOffset    ",0,
	WORD,		1,	"ViewInitX      ",0,
	WORD,		1,	"ViewInitY      ",0,
	WORD,		1,	"EnableCLI      ",0,
	UWORD,		1,	"PrinterType    ",0,
	STRING,		1,	"PrinterFilename",30,
	UWORD,		1,	"PrintPitch     ",0,
	UWORD,		1,	"PrintQuality   ",0,
	UWORD,		1,	"PrintSpacing   ",0,
	UWORD,		1,	"PrintLeftMargin",0,
	UWORD,		1,	"PrintRightMarg.",0,
	UWORD,		1,	"PrintImage     ",0,
	UWORD,		1,	"PrintAspect    ",0,
	UWORD,		1,	"PrintShade     ",0,
	WORD,		1,	"PrintThreshold ",0,
	UWORD,		1,	"PaperSize      ",0,
	UWORD,		1,	"PaperLength    ",0,
	UWORD,		1,	"PaperType      ",0,
	UBYTE,		1,	"SerRWBits      ",0,
	UBYTE,		1,	"SerStopBuf     ",0,
	UBYTE,		1,	"SerParShk      ",0,
	UBYTE,		1,	"LaceWB         ",0,
	STRING,		1,	"WorkName       ",30,
	BYTE,		1,	"RowSizeChange  ",0,
	BYTE,		1,	"ColumnSizeChnge",0,
	BYTE,		14,	"padding        ",0,

	LONG,		1,	"km_LoKeyMapTps ",0,	/* 32 KeyMap */
	LONG,		1,	"km_LoKeyMap    ",0,
	LONG,		1,	"km_LoCapsable  ",0,
	LONG,		1,	"km_LoRepeatable",0,
	LONG,		1,	"km_HiKeyMapTps ",0,
	LONG,		1,	"km_HiKeyMap    ",0,
	LONG,		1,	"km_HiCapsable  ",0,
	LONG,		1,	"km_HiRepeatable",0,

	STRUCTURE,	1,	"tr_node        ",56,	/* 33 timerequest*/
	STRUCTURE,	1,	"tr_time        ",34,

	ULONG,		1,	"tv_secs        ",0,	/* 34 timeval	*/
	ULONG,		1,	"tv_micro       ",0,

	STRUCTURE,	1,	"mp_Node        ",2,	/* 35 MsgPort	*/
	UBYTE,		1,	"mp_Flags       ",0,
	UBYTE,		1,	"mp_SigBit      ",0,
	STRUCTUREPTR,	1,	"mp_SigTask     ",5,
	STRUCTURE,	1,	"mp_MsgList     ",3,

	LONG,		1,	"posctldata     ",0,	/* 36 SimpleSprite	*/
	UWORD,		1,	"height         ",0,
	UWORD,		1,	"x              ",0,
	UWORD,		1,	"y              ",0,
	UWORD,		1,	"num            ",0,

	STRUCTURE,	1,	"ss_Link        ",2,	/* 37 SignalSemaphore */
	WORD,		1,	"ss_NestCount   ",0,
	STRUCTURE,	1,	"ss_WaitQueue   ",57,
	STRUCTURE,	1,	"ss_MultipleLink",38,
	STRUCTUREPTR,	1,	"ss_Owner       ",5,
	WORD,		1,	"ss_QueueCount  ",0,

	STRUCTURE,	1,	"sr_Link        ",58, /* 38 SemaphoreRequest */
	STRUCTUREPTR,	1,	"sr_Waiter      ",5,

	STRUCTUREPTR,	1,	"Next           ",39,	/* 39 ViewPort */
	STRUCTUREPTR,	1,	"ColorMap       ",63,
	STRUCTUREPTR,	1,	"DspIns         ",59,
	STRUCTUREPTR,	1,	"SprIns         ",59,
	STRUCTUREPTR,	1,	"ClrIns         ",59,
	STRUCTUREPTR,	1,	"UCopIns        ",60,
	WORD,		1,	"DWidth         ",0,
	WORD,		1,	"DHeight        ",0,
	WORD,		1,	"DxOffset       ",0,
	WORD,		1,	"DyOffset       ",0,
	UWORD,		1,	"Modes          ",0,
	UBYTE,		1,	"SpritePri      ",0,
	UBYTE,		1,	"reserved       ",0,
	STRUCTUREPTR,	1,	"RasInfo        ",62,

	STRUCTUREPTR,	1,	"Next           ",40,	/* 40 cprlist */
	LONG,		1,	"start          ",0,
	WORD,		1,	"MaxCount       ",0,

	STRUCTUREPTR,	1,	"NextMenu       ",41,	/* 41 Menu	*/
	WORD,		1,	"LeftEdge       ",0,
	WORD,		1,	"TopEdge        ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,
	UWORD,		1,	"Flags          ",0,
	STRINGPTR,	1,	"MenuName       ",0,
	STRUCTUREPTR,	1,	"FirstItem      ",42,
	WORD,		1,	"JazzX          ",0,
	WORD,		1,	"JazzY          ",0,
	WORD,		1,	"BeatX          ",0,
	WORD,		1,	"BeatY          ",0,

	WORD,		1,	"LeftEdge       ",0,	/* 42 MenuItem	*/
	WORD,		1,	"TopEdge        ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,
	UWORD,		1,	"Flags          ",0,
	LONG,		1,	"MutualExclude  ",0,
	LONG,		1,	"ItemFill       ",54,
	LONG,		1,	"SelectFill     ",54,
	BYTE,		1,	"Command        ",0,
	STRUCTUREPTR,	1,	"SubItem        ",42,
	UWORD,		1,	"NextSelect     ",0,

	STRUCTUREPTR,	1,	"OlderRequest   ",43,	/* 43 Requester */
	WORD,		1,	"LeftEdge       ",0,
	WORD,		1,	"TopEdge        ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Height         ",0,
	WORD,		1,	"RelLeft        ",0,
	WORD,		1,	"RelTop         ",0,
	STRUCTUREPTR,	1,	"ReqGadget      ",20,
	STRUCTUREPTR,	1,	"ReqBorder      ",64,
	STRUCTUREPTR,	1,	"ReqText        ",54,
	UWORD,		1,	"Flags          ",0,
	UBYTE,		1,	"BackFill       ",0,
	STRUCTUREPTR,	1,	"ReqLayer       ",44,
	UBYTE,		32,	"ReqPad1        ",0,
	STRUCTUREPTR,	1,	"ImageBMap      ",15,
	STRUCTUREPTR,	1,	"RWindow        ",9,
	UBYTE,		36,	"ReqPad2        ",0,

	STRUCTUREPTR,	1,	"front          ",44,	/* 44 Layer */
	STRUCTUREPTR,	1,	"back           ",44,
	STRUCTUREPTR,	1,	"ClipRect       ",14,
	STRUCTUREPTR,	1,	"rp             ",12,
	STRUCTURE,	1,	"bounds         ",50,
	UBYTE,		4,	"reserved       ",0,
	UWORD,		1,	"priority       ",0,
	UWORD,		1,	"Flags          ",0,
	STRUCTUREPTR,	1,	"SuperBitMap    ",15,
	STRUCTUREPTR,	1,	"SuperClipRect  ",14,
	STRUCTUREPTR,	1,	"Window         ",9,
	WORD,		1,	"Scroll_X       ",0,
	WORD,		1,	"Scroll_Y       ",0,
	STRUCTUREPTR,	1,	"cr             ",14,
	STRUCTUREPTR,	1,	"cr2            ",14,
	STRUCTUREPTR,	1,	"crnew          ",14,
	STRUCTUREPTR,	1,	"SuprSavClpRects",14,
	STRUCTUREPTR,	1,	"_cliprects     ",14,
	STRUCTUREPTR,	1,	"LayerInfo      ",46,
	STRUCTURE,	1,	"Lock           ",37,
	UBYTE,		8,	"reserved3      ",0,
	STRUCTUREPTR,	1,	"ClipRegion     ",27,
	STRUCTUREPTR,	1,	"saveClipRects  ",27,
	UBYTE,		22,	"reserved2      ",0,
	STRUCTUREPTR,	1,	"DamageList     ",27,

	STRUCTURE,	1,	"tf_Message     ",51,	/* 45 TextFont*/
	UWORD,		1,	"tf_YSize       ",0,
	UBYTE,		1,	"tf_Style       ",0,
	UBYTE,		1,	"tf_Flags       ",0,
	UWORD,		1,	"tf_XSize       ",0,
	UWORD,		1,	"tf_Baseline    ",0,
	UWORD,		1,	"tf_BoldSmear   ",0,
	UWORD,		1,	"tf_Accessors   ",0,
	UBYTE,		1,	"tf_LoChar      ",0,
	UBYTE ,		1,	"tf_HiChar      ",0,
	LONG,		1,	"tf_CharData    ",0,
	UWORD,		1,	"tf_Modulo      ",0,
	LONG,		1,	"tf_CharLoc     ",0,
	LONG,		1,	"tf_CharSpace   ",0,
	LONG,		1,	"tf_CharKern    ",0,

	STRUCTUREPTR,	1,	"top_layer      ",44,	/* 46 Layer_Info */
	STRUCTUREPTR,	1,	"check_lp       ",44,
	STRUCTUREPTR,	1,	"obs            ",44,
	STRUCTURE,	1,	"FreeClipRects  ",57,
	STRUCTURE,	1,	"Lock           ",37,
	STRUCTURE,	1,	"gs_Head        ",3,
	LONG,		1,	"longreserved   ",0,
	UWORD,		1,	"Flags          ",0,
	BYTE,		1,	"fatten_count   ",0,
	BYTE,		1,	"LockLayersCount",0,
	UWORD,		1,	"Lay.I_xtra_size",0,
	LONG,		1,	"blitbuff       ",0,
	LONG,		1,	"LayerInfo_extra",0,

	UWORD,		4,	"diagstrt       ",0,	/* 47 copinit	*/
	UWORD,		40,	"sprstrtup      ",0,
	UWORD,		2,	"sprstop        ",0,

	LONG,		1,	"VctrTbl        ",0,	/* 48 AreaInfo */
	LONG,		1,	"VctrPtr        ",0,
	LONG,		1,	"FlagTbl        ",0,
	LONG,		1,	"FlagPtr        ",0,
	WORD,		1,	"Count          ",0,
	WORD,		1,	"MaxCount       ",0,
	WORD,		1,	"FirstX         ",0,
	WORD,		1,	"FirstY         ",0,

	BYTE,		1,	"sprRsrvd       ",0,	/* 49 GelsInfo */
	UBYTE,		1,	"Flags          ",0,
	STRUCTUREPTR,	1,	"gelHead        ",65,
	STRUCTUREPTR,	1,	"gelTail        ",65,
	LONG,		1,	"nextLine       ",0,
	LONG,		1,	"lastColor      ",0,
	LONG,		1,	"collHandler    ",0,
	WORD,		1,	"leftmost       ",0,
	WORD,		1,	"rightmost      ",0,
	WORD,		1,	"topmost        ",0,
	WORD,		1,	"bottommost     ",0,
	LONG,		1,	"firstBlissObj  ",0,
	LONG,		1,	"lastBlissObj   ",0,

	WORD,		1,	"MinX           ",0,	/* 50 Rectangle */
	WORD,		1,	"MinY           ",0,
	WORD,		1,	"MaxX           ",0,
	WORD,		1,	"MaxY           ",0,
	
	STRUCTURE,	1,	"mn_Node        ",2,	/* 51 Message */
	STRUCTUREPTR,	1,	"mn_ReplyPort   ",35,
	UWORD,		1,	"mn_Length      ",0,

	STRUCTURE,	1,	"dd_Library     ",2,	/* 52 Device */

	STRUCTUREPTR,	1,	"unit_MsgPort   ",35,	/* 53 Unit */
	UBYTE,		1,	"unit_flags     ",0,
	UBYTE,		1,	"unit_pad       ",0,
	UWORD,		1,	"unit_OpenCnt   ",0,

	UBYTE,		1,	"FrontPen       ",0,	/* 54 IntuiText */
	UBYTE,		1,	"BackPen        ",0,	
	UBYTE,		1,	"DrawMode       ",0,
	WORD,		1,	"LeftEdge       ",0,
	WORD,		1,	"TopEdge        ",0,
	STRUCTUREPTR,	1,	"ITextFont      ",30,
	STRINGPTR,	1,	"IText          ",0,
	STRUCTUREPTR,	1,	"NextText       ",54,

	UBYTE,		1,	"DetailPen      ",0,	/* 55 PenPair */
	UBYTE,		1,	"BlockPen       ",0,

	STRUCTURE,	1,	"io_Message     ",51,	/* 56 IORequest */
	STRUCTUREPTR,	1,	"io_Device      ",52,
	STRUCTUREPTR,	1,	"io_Unit        ",53,
	UWORD,		1,	"io_Command     ",0,
	UBYTE,		1,	"io_Flags       ",0,
	BYTE,		1,	"io_Error       ",0,

	STRUCTUREPTR,	1,	"mlh_Head       ",58,	/* 57 MinList	*/
	STRUCTUREPTR,	1,	"mlh_Tail       ",58,
	STRUCTUREPTR,	1,	"mlh_TailPred   ",58,

	STRUCTUREPTR,	1,	"mln_Succ       ",58,	/* 58 MinNode	*/
	STRUCTUREPTR,	1,	"mln_Pred       ",58,

	STRUCTUREPTR,	1,	"Next           ",59,	/* 59 CopList 	*/
	STRUCTUREPTR,	1,	"_CopList       ",59,
	STRUCTUREPTR,	1,	"_ViewPort      ",39,
	STRUCTUREPTR,	1,	"CopIns         ",61,
	STRUCTUREPTR,	1,	"CopPtr         ",61,
	LONG,		1,	"CopLStart      ",0,
	LONG,		1,	"CopSStart      ",0,
	WORD,		1,	"Count          ",0,
	WORD,		1,	"MaxCount       ",0,
	WORD,		1,	"DyOffset       ",0,

	STRUCTUREPTR,	1,	"Next           ",60,	/* 60 UCopList	*/
	STRUCTUREPTR,	1,	"FirstCopList   ",59,
	STRUCTUREPTR,	1,	"CopList        ",59,

	WORD,		1,	"OpCode         ",0,	/* 61 CopIns	*/
	WORD,		1,	"VWaitPos_DstAdr",0,
	WORD,		1,	"HWaitPos_DstDat",0,

	STRUCTUREPTR,	1,	"Next           ",62,	/* 62 RasInfo	*/
	STRUCTUREPTR,	1,	"BitMap         ",15,
	WORD,		1,	"RxOffset       ",0,
	WORD,		1,	"RyOffset       ",0,

	UBYTE,		1,	"Flags          ",0,	/* 63 ColorMap	*/
	UBYTE,		1,	"Type           ",0,
	UWORD,		1,	"Count          ",0,
	LONG,		1,	"ColorTable     ",0,

	WORD,		1,	"LeftEdge       ",0,	/* 64 Border	*/
	WORD,		1,	"TopEdge        ",0,
	UBYTE,		1,	"FrontPen       ",0,
	UBYTE,		1,	"BackPen        ",0,
	UBYTE,		1,	"DrawMode       ",0,
	BYTE,		1,	"Count          ",0,
	LONG,		1,	"XY             ",0,
	STRUCTUREPTR,	1,	"NextBorder     ",64,

	STRUCTUREPTR,	1,	"NextVSprite    ",65,	/* 65 VSprite	*/
	STRUCTUREPTR,	1,	"PrevVSprite    ",65,
	STRUCTUREPTR,	1,	"DrawPath       ",65,
	STRUCTUREPTR,	1,	"ClearPath      ",65,
	WORD,		1,	"OldY           ",0,
	WORD,		1,	"OldX           ",0,
	WORD,		1,	"Flags          ",0,
	WORD,		1,	"Y              ",0,
	WORD,		1,	"X              ",0,
	WORD,		1,	"Height         ",0,
	WORD,		1,	"Width          ",0,
	WORD,		1,	"Depth          ",0,
	WORD,		1,	"MeMask         ",0,
	WORD,		1,	"HitMask        ",0,
	LONG,		1,	"ImageData      ",0,
	LONG,		1,	"BorderLine     ",0,
	LONG,		1,	"CollMask       ",0,
	LONG,		1,	"SprColors      ",0,
	STRUCTUREPTR,	1,	"VSBob          ",66,
	BYTE,		1,	"PlanePick      ",0,
	BYTE,		1,	"PlaneOnOff     ",0,
	WORD,		1,	"VUserExt       ",0,

	WORD,		1,	"Flags          ",0,	/* 66 Bob	*/
	LONG,		1,	"SaveBuffer     ",0,
	LONG,		1,	"ImageShadow    ",0,
	STRUCTUREPTR,	1,	"Before         ",66,
	STRUCTUREPTR,	1,	"After          ",66,
	STRUCTUREPTR,	1,	"BobVSprite     ",65,
	STRUCTUREPTR,	1,	"BobComp        ",67,
	STRUCTUREPTR,	1,	"DBuffer        ",68,
	WORD,		1,	"BUserExt       ",0,

	WORD,		1,	"Flags          ",0,	/* 67 AnimComp	*/
	WORD,		1,	"Timer          ",0,
	WORD,		1,	"TimeSet        ",0,
	STRUCTUREPTR,	1,	"NextComp       ",67,
	STRUCTUREPTR,	1,	"PrevComp       ",67,
	STRUCTUREPTR,	1,	"NextSeq        ",67,
	STRUCTUREPTR,	1,	"PrevSeq        ",67,
	LONG,		1,	"AnimCRoutine   ",0,
	WORD,		1,	"YTrans         ",0,
	WORD,		1,	"XTrans         ",0,
	STRUCTUREPTR,	1,	"HeadOb         ",69,
	STRUCTUREPTR,	1,	"AnimBob        ",66,

	WORD,		1,	"BufY           ",0,	/* 68 DBufPacket*/
	WORD,		1,	"BufX           ",0,	
	STRUCTUREPTR,	1,	"BufPath        ",65,
	LONG,		1,	"BufBuffer      ",0,

	STRUCTUREPTR,	1,	"NextOb         ",69,	/* 69 AnimOb	*/
	STRUCTUREPTR,	1,	"PrevOb         ",69,
	LONG,		1,	"Clock          ",0,
	WORD,		1,	"AnOldY         ",0,
	WORD,		1,	"AnOldX         ",0,
	WORD,		1,	"AnY            ",0, 
	WORD,		1,	"AnX            ",0, 
	WORD,		1,	"YVel           ",0,
	WORD,		1,	"XVel           ",0,
	WORD,		1,	"YAccel         ",0,
	WORD,		1,	"XAccel         ",0,
	WORD,		1,	"RingYTrans     ",0,
	WORD,		1,	"RingXTrans     ",0,
	LONG,		1,	"AnimORoutine   ",0,
	STRUCTUREPTR,	1,	"HeadComp       ",67,
	WORD,		1,	"AUserExt       ",0

};
	
#define		STRUCTURESIZE	70

struct			/* Structures	*/
{
	char name[16];
	unsigned int entries;
	unsigned int first_entry;
} structure[STRUCTURESIZE] =

{
	"ExecBase       ",50,0,
	"Library        ",10,50,
	"Node           ",5,60,
	"List           ",5,65,
	"IntVector      ",3,70,
	"Task           ",22,73,
	"SoftIntList    ",2,95,
	"IntuitionBase  ",115,97,
	"View           ",6,212,
	"Window         ",48,218,
	"Screen         ",32,266,
	"GfxBase        ",41,298,
	"RastPort       ",32,339,
	"TmpRas         ",2,371,
	"ClipRect       ",8,373,	/* 9 for V1.1 ! */
	"BitMap         ",6,382,
	"IOStdReq       ",10,388,
        "Interrupt      ",3,398,
	"Remember       ",3,401,
        "InputEvent     ",8,404,
	"Gadget         ",15,412,
	"PropInfo       ",11,427,
	"Image          ",9,438,
	"GListEnv       ",9,447,
	"GadgetInfo     ",6,456,
	"Point          ",2,462,
	"IntuiMessage   ",11,464,
	"Region         ",2,475,
	"RegionRectangle",3,477,
	"IBox           ",4,480,
	"TextAttr       ",4,484,
	"Preferences    ",44,488,
	"KeyMap         ",8,532,
	"timerequest    ",2,540,
	"timeval        ",2,542,
	"MsgPort        ",5,544,
	"SimpleSprite   ",5,549,
	"SignalSemaphore",6,554,
	"SemaphoreReq.st",2,560,
	"ViewPort       ",14,562,
	"cprlist        ",3,576,
	"Menu           ",12,579,
	"MenuItem       ",11,591,
	"Requester      ",17,602,
	"Layer          ",25,619,
	"TextFont       ",15,644,
	"Layer_Info     ",13,659,
	"copinit        ",3,672,
	"AreaInfo       ",8,675,
	"GelsInfo       ",13,683,
	"Rectangle      ",4,696,
	"Message        ",3,700,
	"Device         ",1,703,
	"Unit           ",4,704,
	"IntuiText      ",8,708,
	"PenPair        ",2,716,
	"IORequest      ",6,718,
	"MinList        ",3,724,
	"MinNode        ",2,727,
	"CopList        ",10,729,
	"UCopList       ",3,739,
	"CopIns         ",3,742,
	"RasInfo        ",4,745,
	"ColorMap       ",4,749,
	"Border         ",8,753,
	"VSprite        ",22,761,
	"Bob            ",9,783,
	"AnimComp       ",12,792,
	"DBufPacket     ",4,804,
	"AnimOb         ",16,808
};

void print()
{
	write(io,buffer,strlen(buffer));
}

int InputStr(max,lln,edit)			/* Input Routine:	    */					
int max;					/* max chars		    */
int lln;					/* lln: chrs yet existing   */
int edit;
{	
	char buf,dummy;
	int pos=0;

	if (lln) { write(io,string,lln); write(io,back,lln-pos); }	

	while(1)		
	{
		read(io,&buf,1);		/* Read one Character	    */

		if (buf < 32)		/* Command Keys 1  (<32)    */
		{
			if (buf == CR) 
			{
				write(io,"\n",1);
				string[lln] = 0;
				return(lln);	/* Return	    */
			}
			if (buf == BS)	/* Backspace Routine	    */
			{
				int i;
	
				if (pos == 0)
				{
					if (edit==0) continue;
					buf = BS;
					return(lln);
				}

				pos--;
				lln--;
				for(i=pos;i<=lln;i++) string[i]=string[i+1];
				write(io,back,1);
				write(io,&string[pos],lln-pos);
				write(io,spaces,1);
				write(io,back,lln-pos+1);
				continue;
			}
			if (buf == ESC)
			{	
				if ((edit==0)&&((pos)||(lln))) continue;
				return(lln);
			}
			if (edit == 0) continue;
			if ((buf == TAB)&&(pos+5<max))
			{
				int i,newpos;

				newpos = pos+5-pos%5;

				if (newpos>lln) 
				{
					for(i=lln;i<=newpos;i++) string[i]=SPACE;
					lln = newpos;
				}
				write(io,&string[pos],newpos-pos);
				pos = newpos;
				continue;
			}
			if (buf == DELIN) return(lln);
			if (buf == BOL) return(lln);
			if (buf == EOL) return(lln);
			if (buf == TOP) return(lln);
			if (buf == BOTTOM) return(lln);
			if (buf == PGUP) return(lln);
			if (buf == PGDOWN) return(lln);
			continue;		/* Read next character	    */
		}
		if (buf > 126)		/* Command Keys	2 (>126)    */
		{
			if (buf == DEL)	/* Delete	    */
			{
				int i;
				
				if (pos==lln) return(lln);
				lln--;
				for(i=pos;i<=lln;i++) string[i]=string[i+1];
				write(io,&string[pos],lln-pos);
				write(io,spaces,1);
				write(io,back,lln-pos+1);
				continue;
			}
			if (buf == 155)	/* Special Code		    */
			{
				read(io,&buf,1);	/* Read again(part2)*/
				if(buf == LEFT)	/* Cursor left	    */
				{
					if (pos<1) 
					{
						if (edit) return(lln);
						continue;
					}
					pos--;
					buf = BS;
					write(io,&buf,1);
					continue;
				}	
				if(buf == RIGHT)	/* Cursor right	    */
				{
					if (pos == lln) 
					{
						if (edit) return(lln);
						continue;
					}
					write(io,&string[pos],1);
					pos++;
					continue;
				}
				if(buf == UP) 		/* CRSR up  */
				{
					if (edit) return(lln);
					continue;
				}
				if(buf == DOWN) 		/* CRSR down*/
				{
					if (edit) return(lln);
					continue;
				}
				read(io,&dummy,1);	/* F-Keys & HELP    */
				if (((pos)||(lln))&&(edit==0)) continue;
				return(lln);
			}
			continue;
		}

		if (lln<max)
		{
		if (pos==lln)			/* Append	            */
		{
			string[pos] = buf;
			pos++;
			lln++;
			write(io,&buf,1);
		}
		else 					/* Insert	    */
		{
			int i;

			pos++;
			lln++;
			for (i=lln;i>=pos;i--) string[i]=string[i-1];
			string[pos-1] = buf;
			write(io,&string[pos-1],lln-pos+1);
			buf = BS;
			for (i=1;i<=lln-pos;i++) write(io,&buf,1);
		}
		}
	}
}

long AddUpAddress(nr,address,entries,index)
unsigned int nr;
long address;
unsigned int entries;
int index;
{
	unsigned int endx,x,y,i;

	if (index<0) index=0;
	for(x=structure[nr].first_entry,y=0;y<=entries;x++,y++)
	{
		endx = (y==entries) ? index : entry[x].dimension;
		for(i=0;i<endx;i++) 
		{
			switch(entry[x].type)
			{
				case BYTE:
				case UBYTE:	address += 1;
						break;
				case WORD:
				case UWORD:	address += 2;
						break;
				case LONG:
				case ULONG:
				case STRUCTUREPTR:
				case STRINGPTR:	address += 4;
						break;
				case STRING:	address += entry[x].pointer;
						break;
				case STRUCTURE:	address = AddUpAddress(entry[x].pointer,address,structure[entry[x].pointer].entries,0);
						break;
			}
		}
	}
	return(address);
}

long DisplayStructure(nr,address,name,index)
unsigned int nr;
long address;
char *name;
int index;
{
	int c,e,i,l,error=0;
	long iaddress,k;

	iaddress = address;

	if (index == -1) sprintf(buffer,"\nSTRUCT %s %s\n",structure[nr].name,name);
	if (index != -1) sprintf(buffer,"\nSTRUCT %s %s[%02d]\n",structure[nr].name,name,index);
	print();
	for(e=structure[nr].first_entry,c=0; c<structure[nr].entries; c++,e++)
	{
		if (entry[e].dimension==1)
		{
			while(peek(0xbfec01) == 57);	/* CTRL-> wait	*/
			if ((peek(0xbfec01) == 63)||(peek(0xbfec01) == 62))
			{
				write(io,user_break,strlen(user_break));
				error=1;
				break;
			}
			switch(entry[e].type)
			{
				case BYTE:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d BYTE    %s     = $%02x\n",address,address-iaddress,c,entry[e].name,peek(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d BYTE    %s     = %03d\n",address,address-iaddress,c,entry[e].name,peek(address));
						print();
						address += 1;
						break;
				case UBYTE:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d UBYTE   %s     = $%02x\n",address,address-iaddress,c,entry[e].name,peek(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d UBYTE   %s     = %03u\n",address,address-iaddress,c,entry[e].name,(unsigned char)peek(address));
						print();
						address += 1;
						break;
				case WORD:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d WORD    %s     = $%04x\n",address,address-iaddress,c,entry[e].name,peekw(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d WORD    %s     = %05d\n",address,address-iaddress,c,entry[e].name,peekw(address));
						print();
						address += 2;
						break;
				case UWORD:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d UWORD   %s     = $%04x\n",address,address-iaddress,c,entry[e].name,peekw(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d UWORD   %s     = %05u\n",address,address-iaddress,c,entry[e].name,(unsigned int)peekw(address));
						print();
						address += 2;
						break;
				case LONG:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d LONG    %s     = $%08x\n",address,address-iaddress,c,entry[e].name,peekl(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d LONG    %s     = %010d\n",address,address-iaddress,c,entry[e].name,peekl(address));
						print();
						address += 4;
						break;
				case ULONG:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d ULONG   %s     = $%08x\n",address,address-iaddress,c,entry[e].name,peekl(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d ULONG   %s     = %010u\n",address,address-iaddress,c,entry[e].name,(unsigned long)peekl(address));
						print();
						address += 4;
						break;
				case STRUCTURE:	sprintf(buffer,"$%08x $%04x %02d STRUCT  %s  %s\n",address,address-iaddress,c,structure[entry[e].pointer].name,entry[e].name);print();
						address = AddUpAddress(entry[e].pointer,address,structure[entry[e].pointer].entries,0);
						break;
				case STRINGPTR: for(k=peekl(address),l=0;(l<320)&&(peek(k));k++,l++);
						strncpy(string,peekl(address),l);
						string[l] = 0;
						sprintf(buffer,"$%08x $%04x %02d STRING *%s     = $%08x \"%s\"\n",address,address-iaddress,c,entry[e].name,peekl(address),string);print();
						address += 4;
						break;
				case STRUCTUREPTR: 
						sprintf(buffer,"$%08x $%04x %02d STRUCT  %s *%s     = $%08x\n",address,address-iaddress,c,structure[entry[e].pointer].name,entry[e].name,peekl(address));print();
						address += 4;
						break;
				case STRING:	strncpy(string,address,entry[e].pointer);
						poke(string+(entry[e].pointer),0);
						sprintf(buffer,"$%08x $%04x %02d STRING  %s     = \"%s\"\n",address,address-iaddress,c,entry[e].name,string);print();
						address += entry[e].pointer;
						break;

			}
		}
		if (entry[e].dimension>1) for(i=0;i<entry[e].dimension;i++)
		{
			while(peek(0xbfec01) == 57);	/* CTRL-> wait	*/
			if ((peek(0xbfec01) == 63)||(peek(0xbfec01) == 62))
			{
				write(io,user_break,strlen(user_break));
				error=1;
				break;
			}
			switch(entry[e].type)
			{
				case BYTE:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d BYTE    %s[%02d] = $%02x\n",address,address-iaddress,c,entry[e].name,i,peek(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d BYTE    %s[%02d] = %03d\n",address,address-iaddress,c,entry[e].name,i,peek(address));
						print();
						address += 1;
						break;
				case UBYTE:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d UBYTE   %s[%02d] = $%02x\n",address,address-iaddress,c,entry[e].name,i,peek(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d UBYTE   %s[%02d] = %03u\n",address,address-iaddress,c,entry[e].name,i,(unsigned char)peek(address));
						print();
						address += 1;
						break;
				case WORD:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d WORD    %s[%02d] = $%04x\n",address,address-iaddress,c,entry[e].name,i,peekw(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d WORD    %s[%02d] = %05d\n",address,address-iaddress,c,entry[e].name,i,peekw(address));
						print();
						address += 2;
						break;
				case UWORD:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d UWORD   %s[%02d] = $%04x\n",address,address-iaddress,c,entry[e].name,i,peekw(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d UWORD    %s[%02d] = %05u\n",address,address-iaddress,c,entry[e].name,i,(unsigned int)peekw(address));
						print();
						address += 2;
						break;
				case LONG:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d LONG    %s[%02d] = $%08x\n",address,address-iaddress,c,entry[e].name,i,peekl(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d LONG    %s[%02d] = %010d\n",address,address-iaddress,c,entry[e].name,i,peekl(address));
						print();
						address += 4;
						break;
				case ULONG:	if (mode == HEXADECIMAL)sprintf(buffer,"$%08x $%04x %02d ULONG   %s[%02d] = $%08x\n",address,address-iaddress,c,entry[e].name,i,peekl(address));
						if (mode == DECIMAL)	sprintf(buffer,"$%08x $%04x %02d ULONG   %s[%02d] = %010u\n",address,address-iaddress,c,entry[e].name,i,(unsigned long)peekl(address));
						print();
						address += 4;
						break;
				case STRUCTURE:	sprintf(buffer,"$%08x $%04x %02d STRUCT  %s  %s[%02d]\n",address,address-iaddress,c,structure[entry[e].pointer].name,entry[e].name,i);print();
						address = AddUpAddress(entry[e].pointer,address,structure[entry[e].pointer].entries,0);
						break;
				case STRINGPTR:	for(k=address,l=0;(l<320)&&(peek(k));k++,l++);
						strncpy(string,peekl(address),l);
						string[l] = 0;
						sprintf(buffer,"$%08x $%04x %02d STRING *%s[%02d] = $%08x \"%s\"\n",address,address-iaddress,c,entry[e].name,i,peekl(address),string);print();
						address += 4;
						break;
				case STRUCTUREPTR: 
						sprintf(buffer,"$%08x $%04x %02d STRUCT  %s *%s[%02d] = $%08x\n",address,address-iaddress,c,structure[entry[e].pointer].name,entry[e].name,i,peekl(address));print();
						address += 4;
						break;
				case STRING:	strncpy(string,address,entry[e].pointer);
						poke(string+entry[e].pointer,0);
						sprintf(buffer,"$%08x $%04x %02d STRING  %s[%02d] = \"%s\"\n",address,address-iaddress,c,entry[e].name,i,string);print();
						address += entry[e].pointer;
						break;

			}
		}
		if (error) break;
	}
	return(address);
}

void Entry(address,e,nr,idx)
long address;
unsigned int e;
unsigned int nr;
int idx;
{
	long e_long,len;
	unsigned long e_ulong;
	int e_word;
	unsigned int e_uword;
	int e_byte;			/* has to be int (for hex use) */
	unsigned int e_ubyte;

	switch(mode)
	{
		case DECIMAL: switch(entry[structure[nr].first_entry+e].type)
		{
			case BYTE:	if (idx>=0) sprintf(buffer,"$%08x BYTE %s[%d] = ",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x BYTE %s = ",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%d",&e_byte);
					poke(address,e_byte);
					break;
			case UBYTE:	if (idx>=0) sprintf(buffer,"$%08x UBYTE %s[%d] = ",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x UBYTE %s = ",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%d",&e_ubyte);
					poke(address,e_ubyte);
					break;
			case WORD:	if (idx>=0) sprintf(buffer,"$%08x WORD %s[%d] = ",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x WORD %s = ",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%d",&e_word);
					pokew(address,e_word);
					break;
			case UWORD:	if (idx>=0) sprintf(buffer,"$%08x UWORD %s[%d] = ",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x UWORD %s = ",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%d",&e_uword);
					pokew(address,e_uword);
					break;
			case LONG:	if (idx>=0) sprintf(buffer,"$%08x LONG %s[%d] = ",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x LONG %s = ",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%ld",&e_long);
					pokel(address,e_long);
					break;
			case ULONG:	if (idx>=0) sprintf(buffer,"$%08x ULONG %s[%d] = ",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x ULONG %s = ",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%ld",&e_ulong);
					pokel(address,e_ulong);
					break;
			case STRUCTURE: if (idx>=0) sprintf(buffer,"$%08x STRUCTURE %s %s[%d] =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x STRUCTURE %s %s =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name);
					print();
					WriteStructure(entry[structure[nr].first_entry+e].pointer,address);
					sprintf(buffer,"          STRUCTURE END.\n");print();
					break;
			case STRING:	if (idx>=0) sprintf(buffer,"$%08x STRING %s[%d] (%d chars) = ",address,entry[structure[nr].first_entry+e].name,idx,entry[structure[nr].first_entry+e].pointer);
					if (idx<0) sprintf(buffer,"$%08x STRING %s (%d chars) = ",address,entry[structure[nr].first_entry+e].name,entry[structure[nr].first_entry+e].pointer);
					print();
					InputStr(80,0,0); sscanf(string,"%320s",string);
					strncpy(address,string,entry[structure[nr].first_entry+e].pointer);
					break;	
			case STRUCTUREPTR: 
					if (idx>=0) sprintf(buffer,"$%08x STRUCTURE %s *%s[%d] =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x STRUCTURE %s *%s =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name);
					print();
					sprintf(buffer,"Mode (a)llocate/(o)verwrite/(p)oint: ");print();
					while(1)
					{
						InputStr(80,0,0); sscanf(string,"%c",&string[310]);
						if((string[310]=='a')||(string[310]=='o')||(string[310]=='p'))break;
					}
					switch(string[310])
					{
						case 'a':	sprintf(buffer,"Memory parameters= $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_ulong);
								if (!(e_long=AllocMem(AddUpAddress(nr,0l,structure[nr].entries,-1),e_ulong)))
								{
									sprintf(buffer,"Sorry, out of memory.\n");print();
									break;
								}
								WriteStructure(nr,e_long);
								sprintf(buffer,"          STRUCTURE END.\n");print();
								pokel(address,e_long);
								break;
						case 'o':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								WriteStructure(nr,e_long);
								sprintf(buffer,"          STRUCTURE END.\n");print();
								pokel(address,e_long);
								break;
						case 'p':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								pokel(address,e_long);
								break;
					}
					break;
			case STRINGPTR:
					if (idx>=0) sprintf(buffer,"$%08x STRING *%s[%d] =\n",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x STRING *%s =\n",address,entry[structure[nr].first_entry+e].name);
					print();
					sprintf(buffer,"Mode (a)llocate/(o)verwrite/(p)oint: ");print();
					while(1)
					{
						InputStr(80,0,0); sscanf(string,"%c",&string[310]);
						if((string[310]=='a')||(string[310]=='o')||(string[310]=='p'))break;
					}
					switch(string[310])
					{
						case 'a':	sprintf(buffer,"Memory parameters= $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_ulong);
								sprintf(buffer,"String length= ");print();
								InputStr(80,0,0); sscanf(string,"%ld",&len);
								if (!(e_long=AllocMem(len,e_ulong)))
								{
									sprintf(buffer,"Sorry, out of memory.\n");print();
									break;
								}
								WriteString(len,e_long);
								pokel(address,e_long);
								break;
						case 'o':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								WriteString(strlen(e_long),e_long);
								pokel(address,e_long);
								break;
						case 'p':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								pokel(address,e_long);
								break;
					}
					break;
		}
		break;
		case HEXADECIMAL: switch(entry[structure[nr].first_entry+e].type)
		{
			case BYTE:	if (idx>=0) sprintf(buffer,"$%08x BYTE %s[%d] = $",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x BYTE %s = $",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%x",&e_byte);
					poke(address,e_byte);
					break;
			case UBYTE:	if (idx>=0) sprintf(buffer,"$%08x UBYTE %s[%d] = $",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x UBYTE %s = $",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%x",&e_ubyte);
					poke(address,e_ubyte);
					break ;
			case WORD:	if (idx>=0) sprintf(buffer,"$%08x WORD %s[%d] = $",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x WORD %s = $",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%x",&e_word);
					pokew(address,e_word);
					break;
			case UWORD:	if (idx>=0) sprintf(buffer,"$%08x UWORD %s[%d] = $",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x UWORD %s = $",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%x",&e_uword);
					pokew(address,e_uword);
					break;
			case LONG:	if (idx>=0) sprintf(buffer,"$%08x LONG %s[%d] = $",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x LONG %s = $",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%lx",&e_long);
					pokel(address,e_long);
					break;
			case ULONG:	if (idx>=0) sprintf(buffer,"$%08x ULONG %s[%d] = $",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x ULONG %s = $",address,entry[structure[nr].first_entry+e].name);
					print();
					InputStr(80,0,0); sscanf(string,"%lx",&e_ulong);
					pokel(address,e_ulong);
					break;
			case STRUCTURE: if (idx>=0) sprintf(buffer,"$%08x STRUCTURE %s %s[%d] =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x STRUCTURE %s %s =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name);
					print();
					WriteStructure(entry[structure[nr].first_entry+e].pointer,address);
					sprintf(buffer,"          STRUCTURE END.\n");print();
					break;
			case STRING:	if (idx>=0) sprintf(buffer,"$%08x STRING %s[%d] (%d chars) = ",address,entry[structure[nr].first_entry+e].name,idx,entry[structure[nr].first_entry+e].pointer);
					if (idx<0) sprintf(buffer,"$%08x STRING %s (%d chars) = ",address,entry[structure[nr].first_entry+e].name,entry[structure[nr].first_entry+e].pointer);
					print();
					InputStr(80,0,0); sscanf(string,"%320s",string);
					strncpy(address,string,entry[structure[nr].first_entry+e].pointer);
					break;	
			case STRUCTUREPTR: 
					if (idx>=0) sprintf(buffer,"$%08x STRUCTURE %s *%s[%d] =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x STRUCTURE %s *%s =\n",address,structure[entry[structure[nr].first_entry+e].pointer].name,entry[structure[nr].first_entry+e].name);
					print();
					sprintf(buffer,"Mode (a)llocate/(o)verwrite/(p)oint: ");print();
					while(1)
					{
						InputStr(80,0,0); sscanf(string,"%c",&string[310]);
						if((string[310]=='a')||(string[310]=='o')||(string[310]=='p'))break;
					}
					switch(string[310])
					{
						case 'a':	sprintf(buffer,"Memory parameters= $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_ulong);
								if (!(e_long=AllocMem(AddUpAddress(nr,0l,structure[nr].entries,-1),e_ulong)))
								{
									sprintf(buffer,"Sorry, out of memory.\n");print();
									break;
								}
								WriteStructure(nr,e_long);
								sprintf(buffer,"          STRUCTURE END.\n");print();
								pokel(address,e_long);
								break;
						case 'o':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								WriteStructure(nr,e_long);
								sprintf(buffer,"          STRUCTURE END.\n");print();
								pokel(address,e_long);
								break;
						case 'p':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								pokel(address,e_long);
								break;
					}
					break;
			case STRINGPTR:
					if (idx>=0) sprintf(buffer,"$%08x STRING *%s[%d] =\n",address,entry[structure[nr].first_entry+e].name,idx);
					if (idx<0) sprintf(buffer,"$%08x STRING *%s =\n",address,entry[structure[nr].first_entry+e].name);
					print();
					sprintf(buffer,"Mode (a)llocate/(o)verwrite/(p)oint: ");print();
					while(1)
					{
						InputStr(80,0,0); sscanf(string,"%c",&string[310]);
						if((string[310]=='a')||(string[310]=='o')||(string[310]=='p'))break;
					}
					switch(string[310])
					{
						case 'a':	sprintf(buffer,"Memory parameters= $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_ulong);
								sprintf(buffer,"String length= ");print();
								InputStr(80,0,0); sscanf(string,"%ld",&len);
								if (!(e_long=AllocMem(len+1,e_ulong)))
								{
									sprintf(buffer,"Sorry, out of memory.\n");print();
									break;
								}
								WriteString(len,e_long);
								pokel(address,e_long);
								break;
						case 'o':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								WriteString(strlen(e_long),e_long);
								pokel(address,e_long);
								break;
						case 'p':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&e_long);
								pokel(address,e_long);
								break;
					}
					break;
		}
	}	
}

WriteString(len,address)
{
	sprintf(buffer,"String (max. %d chars) =",len);print();
	InputStr(80,0,0); sscanf(string,"%s",string);
	strncpy(address,string,strlen(string)>len ? len : strlen(string));
	poke(address+(strlen(string)>len ? len : strlen(string)),0);
}

WriteStructure(nr,address)
unsigned int nr;
long address;
{
	int i,j;

	for (i=0;i<structure[nr].entries;i++)
	{
		switch(entry[structure[nr].first_entry+i].dimension)
		{
			case 1:	Entry(AddUpAddress(nr,address,i,-1),i,nr,-1);
				break;
			default:for(j=0;j<entry[structure[nr].first_entry+i].dimension;j++) Entry(AddUpAddress(nr,address,i,j),i,nr,j);
				break;
		}
	}
}

main(argc,argv)
int argc;
char *argv[];
{
	long address,newaddress,gfxbase,intuitionbase,execbase,para,len;
	unsigned int nr,e,stackptr;
	int index,idx,i,j,k,xit;
	char c[80];
	char *name;

	mode = HEXADECIMAL;
	stackptr = 0;

	for(i=0;i<80;i++) back[i]=BS;

	nr = 0;					/* Init for Exec	*/
	address = execbase = peekl(4);
	name = execname;
	index = -1;

	execbase = peekl(4);
	IntuitionBase = (struct IntuitionBase *)(intuitionbase = OpenLibrary("intuition.library",0L));
	gfxbase = OpenLibrary("graphics.library",0L);

	for(i=1;i<argc;i++)
	{
		if (!strcmp(argv[i],"-bg")) 
		{
			while(peek(0xbfec01)>>1 != 32) Delay(60);
			break;
		}
		printf("Use the -bg option to start SystemTracer in the background.\n");
		exit(1);
	}
	
	if (peekw(peekl(intuitionbase+0x38)+0xe)==256L)	/* PAL Res. ?	*/
	{
		ioname[13] = '5';
		ioname[14] = '6';
	}

	io = open(ioname,2);
	if (io<3)
	{
		printf ("Unable to open window.\n");
		exit(1);
	}
	
	write(io,title,strlen(title));

	xit=0;
	while(xit==0)
	{
		sprintf(buffer,">> ");print();
		InputStr(10,0,0);
		switch(string[0])
		{
			case 'l':	DisplayStructure(nr,address,name,index);
					break;
			case 'n':	sprintf(buffer,"Entry number: ");print();
					InputStr(80,0,0); sscanf(string,"%d",&e);
					if(e>=structure[nr].entries)
					{
						sprintf(buffer,"Non-existent entry.\n");print();
						break;
					}
					stack[stackptr].index = index;
					index = -1;
					if(entry[structure[nr].first_entry+e].dimension > 1)
					{
						index=0;
						sprintf(buffer,"Index: ");print();
						InputStr(80,0,0); sscanf(string,"%d",&index);
						if(index>entry[structure[nr].first_entry+e].dimension-1)
						{
							sprintf(buffer,"Non-existent index.\n");print();
							break;
						}
					}
					switch(entry[structure[nr].first_entry+e].type)
					{
						case STRUCTUREPTR:	newaddress = peekl(AddUpAddress(nr,address,e,index));
									if (newaddress == 0)
									{
										sprintf(buffer,"Structure pointer is NULL.\n");print();
										break;
									}
									stack[stackptr].address = address;
									stack[stackptr].name=name;
									stack[stackptr].nr=nr;
									if(++stackptr>=STACKSIZE)
									{
										sprintf(buffer,"stack lost.\n");print();
										stackptr=0;
									}
									address = newaddress;
									name = entry[structure[nr].first_entry+e].name;
									nr = entry[structure[nr].first_entry+e].pointer;
									DisplayStructure(nr,address,name,index);
									break;
						case STRUCTURE:		stack[stackptr].address = address;
									stack[stackptr].name=name;
									stack[stackptr].nr=nr;
									if(++stackptr>=STACKSIZE)
									{
										sprintf(buffer,"stack lost.\n");print();
										stackptr=0;
									}
									address = AddUpAddress(nr,address,e,index);
									name = entry[structure[nr].first_entry+e].name;
									nr = entry[structure[nr].first_entry+e].pointer;
									DisplayStructure(nr,address,name,index);
									break;
						default:		sprintf(buffer,"Not a structure.\n");print();
									break;
					}
					break;
			case 'o':	sprintf(buffer,"\n");print();
					sprintf(buffer," -0- exec.library\n");print();
					sprintf(buffer," -1- intuition.library\n");print();
					sprintf(buffer," -2- graphics.library\n");print();
					sprintf(buffer,"\n Open which ? ");print();
					InputStr(80,0,0); sscanf(string,"%d",&newaddress);
					switch(newaddress)
					{
						case 0:		nr = 0;
								address = execbase;
								name = execname;
								index = -1;
								DisplayStructure(nr,address,name,index);
								break;
						case 1:		address = intuitionbase;
								nr = 7;
								name = intuitionname;
								index = -1;
								DisplayStructure(nr,address,name,index);
								break;
						case 2:		address = gfxbase;
								nr = 11;
								name = gfxname;
								index = -1;
								DisplayStructure(nr,address,name,index);
								break;
						default:	sprintf(buffer,"Non-existent choice.\n");print();
					}
					break;
			case 's':	if (mode == DECIMAL)
					{
						mode=HEXADECIMAL;
						sprintf(buffer,"mode is now hexadecimal.\n");print();
						break;
					}
					if (mode == HEXADECIMAL)
					{
						mode=DECIMAL;
						sprintf(buffer,"mode is now decimal.\n");print();
						break;
					}
			case 'p':	if (stackptr == 0)
					{
						sprintf(buffer,"There is nothing on the stack.\n");print();
						break;
					}
					stackptr--;
					address=stack[stackptr].address;
					nr=stack[stackptr].nr;
					name=stack[stackptr].name;
					index=stack[stackptr].index;
					DisplayStructure(nr,address,name,index);
					break;

			case 'e':	sprintf(buffer,"Entry number: ");print();
					InputStr(80,0,0); sscanf(string,"%d",&e);
					if(e>=structure[nr].entries)
					{
						sprintf(buffer,"Non-existent entry.\n");print();
						break;
					}
					idx = -1;
					if(entry[structure[nr].first_entry+e].dimension > 1)
					{
						idx=0;
						sprintf(buffer,"Index: ");print();
						InputStr(80,0,0); sscanf(string,"%d",&idx);
						if(idx>entry[structure[nr].first_entry+e].dimension-1)
						{
							sprintf(buffer,"Non-existent index.\n");print();
							break;
						}
					}
					Entry(AddUpAddress(nr,address,e,idx),e,nr,idx);
					break;
			case 'r':	sprintf(buffer,"Structure: ");print();
					InputStr(80,0,0); sscanf(string,"%16s",c);
					for(i=0;i<STRUCTURESIZE;i++) if(!(strncmp(c,structure[i].name,strlen(c)))) break;
					if (i==STRUCTURESIZE)
					{
						sprintf(buffer,no_such_structure);print();
						break;
					}
					sprintf(buffer,adrquest);print();
					InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
					DisplayStructure(i,newaddress,"",-1);
					break;
			case 'w':
					sprintf(buffer,"Mode (a)llocate/(o)verwrite: ");print();
					while(1)
					{
						InputStr(80,0,0); sscanf(string,"%c",&c[70]);
						if((c[70]=='a')||(c[70]=='o'))break;
					}
					sprintf(buffer,"Structure: ");print();
					InputStr(80,0,0); sscanf(string,"%16s",c);
					for(i=0;i<STRUCTURESIZE;i++) if(!(strncmp(c,structure[i].name,strlen(c)))) break;
					if (i==STRUCTURESIZE)
					{
						sprintf(buffer,no_such_structure);print();
						break;
					}
					switch(c[70])
					{
						case 'a':	sprintf(buffer,"Memory parameters= $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&para);
								if (!(newaddress=AllocMem(AddUpAddress(i,0l,structure[i].entries,-1),para)))
								{
									sprintf(buffer,"Sorry, out of memory.\n");print();
									break;
								}
								WriteStructure(i,newaddress);
								sprintf(buffer,"Your structure is at $%08x.\n",newaddress);print();
								break;
						case 'o':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								WriteStructure(i,newaddress);
								break;
					}
					break;
			case 'f':	sprintf(buffer,"Free structure: ");print();
					InputStr(80,0,0); sscanf(string,"%16s",c);
					for(i=0;i<STRUCTURESIZE;i++) if(!(strncmp(c,structure[i].name,strlen(c)))) break;
					if (i==STRUCTURESIZE)
					{
						sprintf(buffer,no_such_structure);print();
						break;
					}
					sprintf(buffer,adrquest);print();
					InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
					FreeMem(newaddress,AddUpAddress(i,0l,structure[i].entries),-1);
					sprintf(buffer,"Memory is now free.\n");print();
					break;
			case 'u':	sprintf(buffer,"Free string length: ");print();
					InputStr(80,0,0); sscanf(string,"%ld",&para);
					sprintf(buffer,adrquest);print();
					InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
					FreeMem(newaddress,para);
					sprintf(buffer,"Memory is now free.\n");print();
					break;
			case 't':
					sprintf(buffer,"Mode (a)llocate/(o)verwrite: ");print();
					while(1)
					{
						InputStr(80,0,0); sscanf(string,"%c",&c[70]);
						if((c[70]=='a')||(c[70]=='o'))break;
					}
					switch(c[70])
					{
						case 'a':	sprintf(buffer,"Memory parameters= $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&para);
								sprintf(buffer,"Length= ");print();
								InputStr(80,0,0); sscanf(string,"%ld",&len);
								if (!(newaddress=AllocMem(len+1,para)))
								{
									sprintf(buffer,"Sorry, out of memory.\n");print();
									break;
								}
								WriteString(len,newaddress);
								sprintf(buffer,"Your string is at $%08x.\n",newaddress);print();
								break;
						case 'o':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								WriteString(strlen(newaddress),newaddress);
								break;
					}
					break;
			case 'm':	sprintf(buffer,"Address= $");print();
					InputStr(80,0,0); sscanf(string,"%x",&newaddress);
					while(1)
					{			
						while(peek(0xbfec01) == 57);	/* CTRL-> wait	*/
						if ((peek(0xbfec01) == 63)||(peek(0xbfec01) == 62))
						{
							write(io,user_break,strlen(user_break));
							break;
						}
						para=newaddress;
						sprintf(buffer,"$%08x ",newaddress);
						for (i=0;i<16;i++) sprintf(buffer,"%s %02x",buffer,peek(para++));
						print();
						for(para=newaddress,i=0;i<16;i++,para++)
						{
							if ((peek(para)>31)&&(peek(para)<127)) buffer[i]=peek(para);
							if ((peek(para)<32)||(peek(para)>126)) buffer[i]='.';
						}
						buffer[16] = 10;
						write(io,buffer,17);
						newaddress+=16;
					}
					break;
			case 'd':	sprintf(buffer,"Disk operations: (l)oad structure\n");print();
					sprintf(buffer,"                 (s)ave structure\n");print();
					sprintf(buffer,"                 save structure as (a)ssembler code\n");print();
					sprintf(buffer,"                 save structure as (c) code\n");print();
					sprintf(buffer,"                 save (m)emory\n");print();
					sprintf(buffer,"                 load m(e)mory\n");print();
					sprintf(buffer,"\ndisk>> ");print();
					InputStr(80,0,0); sscanf(string,"%s",c);
					switch(c[0])
					{
						case 'l':
								sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								sprintf(buffer,filename_quest);print();
								InputStr(80,0,0); sscanf(string,"%s",string);
								file=open(string,2);
								if (file<3)
								{
									sprintf(buffer,"Error opening file.\n");print();
									break;
								}
								read(file,string,24);
								string[24]=0;
								if ( strcmp(tag,string) != 0)
								{
									sprintf(buffer,"No System Tracer structure file.\n");print();
									close(file);
									break;
								}
								read(file,c,16);
								c[16]=0;
								for(i=0;i<STRUCTURESIZE;i++) if(!(strcmp(c,structure[i].name))) break;
								if (i==STRUCTURESIZE)
								{
									sprintf(buffer,no_such_structure);print();
									break;
								}
								read(file,newaddress,AddUpAddress(i,0l,structure[i].entries,-1));
								close(file);
								sprintf(buffer,"Structure loaded.\n");print();
								break;
						
						case 's':	sprintf(buffer,save_structure);print();
								InputStr(80,0,0); sscanf(string,"%16s",c);
								for(i=0;i<STRUCTURESIZE;i++) if(!(strncmp(c,structure[i].name,strlen(c)))) break;
								if (i==STRUCTURESIZE)
								{
									sprintf(buffer,no_such_structure);print();
									break;
								}
								sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								sprintf(buffer,filename_quest);print();
								InputStr(80,0,0); sscanf(string,"%s",string);
								file=creat(string,0);
								if (file<3)
								{
									sprintf(buffer,"Error opening file.\n");print();
									break;
								}
								write(file,tag,24);
								write(file,structure[i].name,16);
								write(file,newaddress,AddUpAddress(i,0l,structure[i].entries,-1));
								close(file);
								sprintf(buffer,"Structure saved.\n");print();
								break;
						case 'c':	sprintf(buffer,save_structure);print();
								InputStr(80,0,0); sscanf(string,"%16s",c);
								for(i=0;i<STRUCTURESIZE;i++) if(!(strncmp(c,structure[i].name,strlen(c)))) break;
								if (i==STRUCTURESIZE)
								{
									sprintf(buffer,no_such_structure);print();
									break;
								}
								sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								sprintf(buffer,filename_quest);print();
								InputStr(80,0,0); sscanf(string,"%s",string);
								file=creat(string,0);
								if (file<3)
								{
									sprintf(buffer,"Error opening file.\n");print();
									break;
								}
								write(file,"struct\n{\n",9);
								for(j=structure[i].first_entry;j<structure[i].first_entry+structure[i].entries;j++)
								{
									switch(entry[j].type)
									{
										case BYTE:
												write(file,"\tchar ",6);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case UBYTE:
												write(file,"\tunsigned char ",15);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case WORD:
												write(file,"\tint ",5);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case UWORD:	
												write(file,"\tunsigned int ",14);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case LONG:	
												write(file,"\tlong ",6);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case ULONG:	
												write(file,"\tunsigned long ",15);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case STRUCTURE:	
												write(file,"\tstruct ",8);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case STRING:	
												write(file,"\tchar ",6);
												write(file,entry[j].name,strlen(entry[j].name));
												sprintf (string,"[%d]",entry[j].pointer);
												write(file,string,strlen(string));
												break;
										case STRUCTUREPTR:
												write(file,"\tstruct *",9);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
										case STRINGPTR:	
												write(file,"\tchar *",7);
												write(file,entry[j].name,strlen(entry[j].name));
												break;
									}
									if (entry[j].dimension>1)
									{
										sprintf (string,"[%d]",entry[j].dimension);
										write(file,string,strlen(string));
									}
									write(file,";\n",2);	
								}
								write(file,"} ",2);
								write(file,structure[i].name,15);
								write(file," =\n{\n\t",6);
								for(j=structure[i].first_entry,k=0;k<structure[i].entries;j++,k++)
								{
									if (entry[j].dimension == 1) switch(entry[j].type)
									{
										case ULONG:
										case LONG:	sprintf (string,"0x%08lx",peekl(AddUpAddress(i,address,k,-1)));
												write(file,string,strlen(string));
												break;	
										case UWORD:	
										case WORD:	sprintf (string,"0x%04x",peekw(AddUpAddress(i,address,k,-1)));
												write(file,string,strlen(string));
												break;	
										case UBYTE:
										case BYTE:	sprintf (string,"0x%02x",peek(AddUpAddress(i,address,k,-1)));
												write(file,string,strlen(string));
												break;
										case STRUCTURE: write(file,insert_string,strlen(insert_string));
												break;
										case STRUCTUREPTR:write(file,insert_string,strlen(insert_string));
												sprintf (string,"  0x%08lx",peekl(AddUpAddress(i,address,k,-1)));
												write(file,string,strlen(string));
												break;
										case STRING:	sprintf (string,"\"%s\"",AddUpAddress(i,address,k,-1));
												write(file,string,strlen(string));
												break;
										case STRINGPTR:	sprintf (string,"\"%s\"",peekl(AddUpAddress(i,address,k,-1)));
												write(file,string,strlen(string));
												break;
									}
									if (entry[j].dimension > 1) for(idx=0;idx<entry[j].dimension;idx++)
									{
									switch(entry[j].type)
									{
										case ULONG:
										case LONG:	sprintf (string,"0x%08lx",peekl(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												break;	
										case UWORD:	
										case WORD:	sprintf (string,"0x%04x",peekw(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												break;	
										case UBYTE:
										case BYTE:	sprintf (string,"0x%02x",peek(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												break;
										case STRUCTURE: if (idx==0) write(file,insert_string,strlen(insert_string));
												break;
										case STRUCTUREPTR:if (idx ==0) write(file,insert_string,strlen(insert_string));
												sprintf (string,"  0x%08lx",peekl(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												break;
										case STRING:	sprintf (string,"\"%s\"",AddUpAddress(i,address,k,idx));
												write(file,string,strlen(string));
												break;
										case STRINGPTR:	sprintf (string,"\"%s\"",peekl(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												break;
									}
									if((idx+1)<entry[j].dimension) write(file,", ",2);
									}
									if((k+1)<structure[i].entries) write(file,",\n\t",3);
								}
								write(file,"\n}\n",3);
								close(file);
								sprintf(buffer,"Structure saved.\n");print();
								break;
						case 'a':	sprintf(buffer,save_structure);print();
								InputStr(80,0,0); sscanf(string,"%16s",c);
								for(i=0;i<STRUCTURESIZE;i++) if(!(strncmp(c,structure[i].name,strlen(c)))) break;
								if (i==STRUCTURESIZE)
								{
									sprintf(buffer,no_such_structure);print();
									break;
								}
								sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								sprintf(buffer,filename_quest);print();
								InputStr(80,0,0); sscanf(string,"%s",string);
								file=creat(string,0);
								if (file<3)
								{
									sprintf(buffer,"Error opening file.\n");print();
									break;
								}
								strcpy(c,structure[i].name);
								if (c[14]=' ') poke(strchr(c,' '),0);
								write(file,c,strlen(c));
								write(file,":\n",2);
								for(j=structure[i].first_entry,k=0;k<structure[i].entries;j++,k++)
								{
									strcpy(c,entry[j].name);
									if (c[14]=' ') poke(strchr(c,' '),0);

									for (idx=0;idx<entry[j].dimension;idx++)
									{
									switch(entry[j].type)
									{
										case BYTE: case UBYTE:
												if (idx==0) write(file,c,strlen(c));
												if (idx==0) write(file,":\tdc.b ",7);
												sprintf (string,"$%02x",peek(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												if (idx==entry[j].dimension-1) write(file,even_string,strlen(even_string));
												break;
										case WORD: case UWORD:
												
												if (idx==0) write(file,c,strlen(c));
												if (idx==0) write(file,":\tdc.w ",7);
												sprintf (string,"$%04x",peekw(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												break;
										case LONG: case ULONG:	
												if (idx==0) write(file,c,strlen(c));
												if (idx==0) write(file,":\tdc.l ",7);
												sprintf (string,"$%08lx",peekl(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												break;
										case STRUCTURE:	if (idx==0) write(file,c,strlen(c));
												if (idx==0) write(file,":\t",2);
												if (idx==entry[j].dimension-1)write(file,insert_string2,strlen(insert_string2));
												break;
										case STRING:	
												if (idx==0) write(file,c,strlen(c));
												if (idx==0) write(file,":\tdc.b ",7);
												sprintf (string,"'%s'",AddUpAddress(i,address,k,idx));
												write(file,string,strlen(string));
												if (idx==entry[j].dimension-1)write(file,even_string,strlen(even_string));
												break;
										case STRUCTUREPTR:
												if (idx==0) write(file,c,strlen(c));
												if (idx==0) write(file,":\tdc.l ",7);
												sprintf (string,"$%08lx",peekl(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												if (idx==entry[j].dimension-1) write(file,insert_string2,strlen(insert_string2));
												break;
										case STRINGPTR:	
												if (idx==0) write(file,c,strlen(c));
												if (idx==0) write(file,":\tdc.l ",7);
												sprintf (string,"$%08lx",peekl(AddUpAddress(i,address,k,idx)));
												write(file,string,strlen(string));
												if (idx==entry[j].dimension-1) write(file,insert_string2,strlen(insert_string2));
												break;
									}
									if (idx==entry[j].dimension-1) write(file,"\n",1);
									if (idx<entry[j].dimension-1) write(file,comma,2);
									}
								}
								close(file);
								sprintf(buffer,"Structure saved.\n");print();
								break;
						case 'e':	sprintf(buffer,adrquest);print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								sprintf(buffer,filename_quest);print();
								InputStr(80,0,0); sscanf(string,"%s",string);
								file=open(string,2);
								if (file<3)
								{
									sprintf(buffer,"Error opening file.\n");print();
									break;
								}
								for(para=0;read(file,newaddress++,1);para++);
								sprintf(buffer,"Loaded $%08lx bytes (%08lx-%08lx).\n",para,newaddress-para,newaddress);print();
								close(file);
								break;
						case 'm':	sprintf(buffer,"Start address: $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&newaddress);
								sprintf(buffer,"End address: $");print();
								InputStr(80,0,0); sscanf(string,"%lx",&para);
								sprintf(buffer,filename_quest);print();
								InputStr(80,0,0); sscanf(string,"%s",string);
								file=creat(string,0);
								if (file<3)
								{
									sprintf(buffer,"Error opening file.\n");print();
									break;
								}
								write(file,address,para-newaddress);
								sprintf(buffer,"Saved %08lx bytes.\n",para-newaddress);print();
								close(file);
								break;
						default:	break;
					}
					break;
			case 'c':	close(io);
					while(peek(0xbfec01)>>1 != 32) Delay(60);
					WBenchToFront();
					io=open(ioname,2);
					write(io,title,strlen(title));
					break;
			case 'h':
			case '?':	write(io,help_text1,strlen(help_text1));
					write(io,help_text2,strlen(help_text2));
					break;
			case 'x':	xit=1;break;
			case 'q':	xit=1;break;
			default:	sprintf(buffer,"???\n");print();
					break;
		}
	}
	close(io);
	CloseLibrary(intuitionbase);
	CloseLibrary(gfxbase);
}
