CONST	SUSERFLAGS=$FF,
		VSF_VSPRITE=1,
		VSF_SAVEBACK=2,
		VSF_OVERLAY=4,
		VSF_MUSTDRAW=8,
		VSF_BACKSAVED=$100,
		VSF_BOBUPDATE=$200,
		VSF_GELGONE=$400,
		VSF_VSOVERFLOW=$800,
		BUSERFLAGS=$FF,
		BF_SAVEBOB=1,
		BF_BOBISCOMP=2,
		BF_BWAITING=$100,
		BF_BDRAWN=$200,
		BF_BOBSAWAY=$400,
		BF_BOBNIX=$800,
		BF_SAVEPRESERVE=$1000,
		BF_OUTSTEP=$2000,
		ANFRACSIZE=6,
		ANIMHALF=$20,
		RINGTRIGGER=1

OBJECT VSprite|VS
	NextVSprite:PTR TO VS,
	PrevVSprite:PTR TO VS,
	DrawPath:PTR TO VS,
	ClearPath:PTR TO VS,
	OldY:WORD,
	OldX:WORD,
	Flags|VSFlags:WORD,
	Y:WORD,
	X:WORD,
	Height:WORD,
	Width:WORD,
	Depth:WORD,
	MeMask:WORD,
	HitMask:WORD,
	ImageData:PTR TO WORD,
	BorderLine:PTR TO WORD,
	CollMask:PTR TO WORD,
	SprColors:PTR TO WORD,
	VSBob:PTR TO Bob,
	PlanePick:BYTE,
	PlaneOnOff:BYTE,
	VUserExt:LONG

OBJECT Bob
	Flags|BobFlags:WORD,
	SaveBuffer:PTR TO WORD,
	ImageShadow:PTR TO WORD,
	Before:PTR TO Bob,
	After:PTR TO Bob,
	BobVSprite:PTR TO VS,
	BobComp:PTR TO AC,
	DBuffer:PTR TO DBP,
	BUserExt:LONG

OBJECT AnimComp|AC
	Flags|CompFlags:WORD,
	Timer:WORD,
	TimeSet:WORD,
	NextComp:PTR TO AC,
	PrevComp:PTR TO AC,
	NextSeq:PTR TO AC,
	PrevSeq:PTR TO AC,
	AnimCRoutine:LONG,
	YTrans:WORD,
	XTrans:WORD,
	HeadOb:PTR TO AO,
	AnimBob:PTR TO Bob

OBJECT AnimOb|AO
	NextOb:PTR TO AO,
	PrevOb:PTR TO AO,
	Clock:LONG,
	AnOldY:WORD,
	AnOldX:WORD,
	AnY:WORD,
	AnX:WORD,
	YVel:WORD,
	XVel:WORD,
	YAccel:WORD,
	XAccel:WORD,
	RingYTrans:WORD,
	RingXTrans:WORD,
	AnimORoutine:LONG,
	HeadComp:PTR TO AC,
	AUserExt:LONG

OBJECT DBufPacket|DBP
	BufY:WORD,
	BufX:WORD,
	BufPath:PTR TO VS,
	BufBuffer:PTR TO WORD,
	BufPlanes:PTR TO LONG
/*
#define InitAnimate(animKey) PutLong(animKey,NIL)
#define RemBob(b)            PutInt(b, Int(b) OR BF_BOBSAWAY)
*/
CONST	B2NORM=0,
		B2SWAP=1,
		B2BOBBER=2

// Um, this was in 'graphics/view'
OBJECT collTable|CollTable
	collPtrs[16]:LONG
