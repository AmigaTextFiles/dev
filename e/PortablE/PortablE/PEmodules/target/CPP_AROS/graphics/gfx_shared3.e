OPT NATIVE
MODULE 'target/graphics/gfx_shared2', 'target/graphics/gfx_shared4'
MODULE 'target/exec/lists', 'target/exec/ports', 'target/exec/semaphores', 'target/utility/hooks', 'target/exec/types'

NATIVE {Layer_Info} OBJECT layer_info
    {top_layer}	top_layer	:PTR TO layer
    {check_lp}	check_lp	:PTR TO layer
    {obs}	obs	:PTR TO cliprect
    {FreeClipRects}	freecliprects	:PTR TO cliprect

    {PrivateReserve1}	privatereserve1	:VALUE
    {PrivateReserve2}	privatereserve2	:VALUE

    {Lock}	lock	:ss
    {gs_Head}	gs_head	:mlh

    {PrivateReserve3}	privatereserve3	:INT
    {PrivateReserve4}	privatereserve4	:PTR

    {Flags}	flags	:UINT
    {fatten_count}	fatten_count	:BYTE
    {LockLayersCount}	locklayerscount	:BYTE
    {PrivateReserve5}	privatereserve5	:INT
    {BlankHook}	blankhook	:PTR
    {LayerInfo_extra}	layerinfo_extra	:PTR
ENDOBJECT


NATIVE {Layer} OBJECT layer
    {front}	front	:PTR TO layer
    {back}	back	:PTR TO layer
    {ClipRect}	cliprect	:PTR TO cliprect
    {rp}	rp	:PTR TO rastport
    {bounds.MinX}	minx	:INT
    {bounds.MinY}	miny	:INT
    {bounds.MaxX}	maxx	:INT
    {bounds.MaxY}	maxy	:INT

    {parent}	reserved	:PTR TO layer 	    	    	/* PRIVATE !!! */
    {priority}	priority	:UINT
    {Flags}	flags	:UINT

    {SuperBitMap}	superbitmap	:PTR TO bitmap
    {SuperClipRect}	supercliprect	:PTR TO cliprect

    {Window}	window	:APTR
    {Scroll_X}	scroll_x	:INT
    {Scroll_Y}	scroll_y	:INT

    {cr}	cr	:PTR TO cliprect
    {cr2}	cr2	:PTR TO cliprect
    {crnew}	crnew	:PTR TO cliprect
    {SuperSaveClipRects}	supersavercliprects	:PTR TO cliprect
    {_cliprects}	cliprects_	:PTR TO cliprect

    {LayerInfo}	layerinfo	:PTR TO layer_info
    {Lock}	lock	:ss
    {BackFill}	backfill	:PTR TO hook
    {VisibleRegion}	reserved1	:PTR TO region 	    	/* PRIVATE !!! */
    {ClipRegion}	clipregion	:PTR TO region
    {saveClipRects}	savecliprects	:PTR TO region

    {Width}	width	:INT
    {Height}	height	:INT

    {shape}	shape	:PTR TO region	    	    	/* PRIVATE !!! */
    {shaperegion}	shaperegion	:PTR TO region  	    	/* PRIVATE !!! */
    {visibleshape}	visibleshape	:PTR TO region 	    	/* PRIVATE !!! */

    {nesting}	nesting	:UINT	    	    	/* PRIVATE !!! */
    {SuperSaveClipRectCounter}	supersavecliprectcounter	:UBYTE	/* PRIVATE !!! */
    {visible}	visible	:UBYTE	    	    	/* PRIVATE !!! */

    {reserved2}	reserved2[2]	:ARRAY OF UBYTE 

    {DamageList}	damagelist	:PTR TO region
ENDOBJECT

NATIVE {ClipRect} OBJECT cliprect
    {Next}	next	:PTR TO cliprect
    {prev}	prev	:PTR TO cliprect
    {lobs}	lobs	:PTR TO layer
    {BitMap}	bitmap	:PTR TO bitmap
    {bounds.MinX}	minx	:INT
    {bounds.MinY}	miny	:INT
    {bounds.MaxX}	maxx	:INT
    {bounds.MaxY}	maxy	:INT

    {_p1}	p1_	:PTR
    {_p2}	p2_	:PTR
    {reserved}	reserved	:VALUE
    {Flags}	flags	:VALUE
ENDOBJECT


NATIVE {AreaInfo} OBJECT areainfo
    {VctrTbl}	vctrtbl	:PTR TO INT
    {VctrPtr}	vctrptr	:PTR TO INT
    {FlagTbl}	flagtbl	:PTR TO BYTE
    {FlagPtr}	flagptr	:PTR TO BYTE
    {Count}	count	:INT
    {MaxCount}	maxcount	:INT
    {FirstX}	firstx	:INT
    {FirstY}	firsty	:INT
ENDOBJECT

NATIVE {GelsInfo} OBJECT gelsinfo
    {sprRsrvd}	sprrsrvd	:BYTE
    {Flags}	flags	:UBYTE
    {gelHead}	gelhead	:PTR TO vs
    {gelTail}	geltail	:PTR TO vs
    {nextLine}	nextline	:PTR TO INT
    {lastColor}	lastcolor	:ARRAY OF PTR TO INT
    {collHandler}	collhandler	:PTR TO colltable
    {leftmost}	leftmost	:INT
    {rightmost}	rightmost	:INT
    {topmost}	topmost	:INT
    {bottommost}	bottommost	:INT
    {firstBlissObj}	firstblissobj	:APTR
    {lastBlissObj}	lastblissobj	:APTR
ENDOBJECT

NATIVE {TmpRas} OBJECT tmpras
    {RasPtr}	rasptr	:PTR TO BYTE
    {Size}	size	:VALUE
ENDOBJECT

NATIVE {RastPort} OBJECT rastport
    {Layer}	layer	:PTR TO layer
    {BitMap}	bitmap	:PTR TO bitmap
    {AreaPtrn}	areaptrn	:NATIVE {const UWORD*} PTR TO UINT
    {TmpRas}	tmpras	:PTR TO tmpras
    {AreaInfo}	areainfo	:PTR TO areainfo
    {GelsInfo}	gelsinfo	:PTR TO gelsinfo
    {Mask}	mask	:UBYTE
    {FgPen}	fgpen	:BYTE
    {BgPen}	bgpen	:BYTE
    {AOlPen}	aolpen	:BYTE
    {DrawMode}	drawmode	:BYTE
    {AreaPtSz}	areaptsz	:BYTE
    {linpatcnt}	linpatcnt	:BYTE
    {dummy}	dummy	:BYTE
    {Flags}	flags	:UINT
    {LinePtrn}	lineptrn	:UINT
    {cp_x}	cp_x	:INT
    {cp_y}	cp_y	:INT
    {minterms}	minterms[8]	:ARRAY OF UBYTE
    {PenWidth}	penwidth	:INT
    {PenHeight}	penheight	:INT
    {Font}	font	:PTR TO textfont
    {AlgoStyle}	algostyle	:UBYTE
    {TxFlags}	txflags	:UBYTE
    {TxHeight}	txheight	:UINT
    {TxWidth}	txwidth	:UINT
    {TxBaseline}	txbaseline	:UINT
    {TxSpacing}	txspacing	:INT
    {RP_User}	rp_user	:PTR TO APTR
    {longreserved}	longreserved[2]	:ARRAY OF ULONG
    {wordreserved}	wordreserved[7]	:ARRAY OF UINT
    {reserved}	reserved[8]	:ARRAY OF UBYTE
ENDOBJECT


NATIVE {TextFont} OBJECT textfont
    {tf_Message}	mn	:mn
    {tf_YSize}	ysize	:UINT
    {tf_Style}	style	:UBYTE
    {tf_Flags}	flags	:UBYTE
    {tf_XSize}	xsize	:UINT
    {tf_Baseline}	baseline	:UINT
    {tf_BoldSmear}	boldsmear	:UINT
    {tf_Accessors}	accessors	:UINT
    {tf_LoChar}	lochar	:UBYTE
    {tf_HiChar}	hichar	:UBYTE
    {tf_CharData}	chardata	:APTR
    {tf_Modulo}	modulo	:UINT
    {tf_CharLoc}	charloc	:APTR
    {tf_CharSpace}	charspace	:APTR
    {tf_CharKern}	charkern	:APTR
ENDOBJECT
