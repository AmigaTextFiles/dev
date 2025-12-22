MODULE 'graphics/monitor','graphics/view','utility/tagitem'

CONST	COPPER_MOVE=0,
		COPPER_WAIT=1,
		CPRNXTBUF=2,
		CPR_NT_LOF=$8000,
		CPR_NT_SHT=$4000,
		CPR_NT_SYS=$2000

OBJECT CopIns
	OpCode:WORD,
// a) next two WORDs are unioned with "nxtlist:PTR TO coplist"
	VWaitPos|DestAddr:WORD,
	HWaitPos|DestData:WORD

#define VWAITPOS vwaitpos
#define DESTADDR vwaitpos
#define HWAITPOS hwaitpos
#define DESTDATA hwaitpos

OBJECT CprList|cprlist
	Next:PTR TO cprlist,
	start:PTR TO UWORD,
	MaxCount:WORD

OBJECT CopList
	Next:PTR TO CopList,
	_CopList:PTR TO CopList,
	_ViewPort:PTR TO ViewPort,
	CopIns:PTR TO CopIns,
	CopPtr:PTR TO CopIns,
	CopLStart:PTR TO UWORD,
	CopSStart:PTR TO UWORD,
	Count:WORD,
	MaxCount:WORD,
	DyOffset:WORD,
  Cop2Start:PTR TO UWORD,
  Cop3Start:PTR TO UWORD,
  Cop4Start:PTR TO UWORD,
  Cop5Start:PTR TO UWORD,
  SLRepeat:UWORD,
	Flags:UWORD

CONST	EXACT_LINE=1,
		HALF_LINE=2

OBJECT UCopList
	Next:PTR TO UCopList,
	FirstCopList:PTR TO CopList,
	CopList:PTR TO CopList

OBJECT CopInit|copinit
	vsync_hblank[2]:UWORD,
	diagstrt[12]:UWORD,
	fm0[2]:UWORD,
	diwstart[10]:UWORD,
	bplcon2[2]:UWORD,
	sprfix[16]:UWORD,
	sprstrtup[32]:UWORD,
	wait14[2]:UWORD,
	norm_hblank[2]:UWORD,
	jump[2]:UWORD,
	wait_forever[6]:UWORD,
	sprstop[8]:UWORD
