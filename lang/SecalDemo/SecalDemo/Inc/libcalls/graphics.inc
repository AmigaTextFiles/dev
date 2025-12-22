pattern BltBitMap(_srcBitMap,_xSrc,_ySrc,_destBitMap,_xDest,_yDest,_xSize,_ySize,_minterm,_mask,_tempA) is
	push d2\d3\d4\d5\d6\d7\a2\a6;
	safe a0:=_srcBitMap; d0.l:=_xSrc; d1.l:=_ySrc; a1:=_destBitMap; d2.l:=_xDest; d3.l:=_yDest; d4.l:=_xSize; d5.l:=_ySize; d6.l:=_minterm; d7.l:=_mask; a2:=_tempA;;
	a6:=GfxBase; jsr [a6-30];
	pop d2\d3\d4\d5\d6\d7\a2\a6;
endp;															# BLTBITMAP

pattern BltTemplate(_source,_xSrc,_srcMod,_destRP,_xDest,_yDest,_xSize,_ySize) is
	push d2\d3\d4\d5\a6;
	safe a0:=_source; d0.l:=_xSrc; d1.l:=_srcMod; a1:=_destRP; d2.l:=_xDest; d3.l:=_yDest; d4.l:=_xSize; d5.l:=_ySize;;
	a6:=GfxBase; jsr [a6-36];
	pop d2\d3\d4\d5\a6;
endp;															# BLTTEMPLATE

pattern ClearEOL(_rp) is
	push a6;
	a1:=_rp;
	a6:=GfxBase; jsr [a6-42];
	pop a6;
endp;															# CLEAREOL

pattern ClearScreen(_rp) is
	push a6;
	a1:=_rp;
	a6:=GfxBase; jsr [a6-48];
	pop a6;
endp;															# CLEARSCREEN

pattern TextLength(_rp,_string,_count) is
	push a6;
	safe a1:=_rp; a0:=_string; d0.l:=_count;;
	a6:=GfxBase; jsr [a6-54];
	pop a6;
endp;															# TEXTLENGTH

pattern Text(_rp,_string,_count) is
	push a6;
	safe a1:=_rp; a0:=_string; d0.l:=_count;;
	a6:=GfxBase; jsr [a6-60];
	pop a6;
endp;															# TEXT

pattern SetFont(_rp,_textFont) is
	push a6;
	safe a1:=_rp; a0:=_textFont;;
	a6:=GfxBase; jsr [a6-66];
	pop a6;
endp;															# SETFONT

pattern OpenFont(_textAttr) is
	push a6;
	a0:=_textAttr;
	a6:=GfxBase; jsr [a6-72];
	pop a6;
endp;															# OPENFONT

pattern CloseFont(_textFont) is
	push a6;
	a1:=_textFont;
	a6:=GfxBase; jsr [a6-78];
	pop a6;
endp;															# CLOSEFONT

pattern AskSoftStyle(_rp) is
	push a6;
	a1:=_rp;
	a6:=GfxBase; jsr [a6-84];
	pop a6;
endp;															# ASKSOFTSTYLE

pattern SetSoftStyle(_rp,_style,_enable) is
	push a6;
	safe a1:=_rp; d0.l:=_style; d1.l:=_enable;;
	a6:=GfxBase; jsr [a6-90];
	pop a6;
endp;															# SETSOFTSTYLE

pattern AddBob(_bob,_rp) is
	push a6;
	safe a0:=_bob; a1:=_rp;;
	a6:=GfxBase; jsr [a6-96];
	pop a6;
endp;															# ADDBOB

pattern AddVSprite(_vSprite,_rp) is
	push a6;
	safe a0:=_vSprite; a1:=_rp;;
	a6:=GfxBase; jsr [a6-102];
	pop a6;
endp;															# ADDVSPRITE

pattern DoCollision(_rp) is
	push a6;
	a1:=_rp;
	a6:=GfxBase; jsr [a6-108];
	pop a6;
endp;															# DOCOLLISION

pattern DrawGList(_rp,_vp) is
	push a6;
	safe a1:=_rp; a0:=_vp;;
	a6:=GfxBase; jsr [a6-114];
	pop a6;
endp;															# DRAWGLIST

pattern InitGels(_head,_tail,_gelsInfo) is
	push a2\a6;
	safe a0:=_head; a1:=_tail; a2:=_gelsInfo;;
	a6:=GfxBase; jsr [a6-120];
	pop a2\a6;
endp;															# INITGELS

pattern InitMasks(_vSprite) is
	push a6;
	a0:=_vSprite;
	a6:=GfxBase; jsr [a6-126];
	pop a6;
endp;															# INITMASKS

pattern RemIBob(_bob,_rp,_vp) is
	push a2\a6;
	safe a0:=_bob; a1:=_rp; a2:=_vp;;
	a6:=GfxBase; jsr [a6-132];
	pop a2\a6;
endp;															# REMIBOB

pattern RemVSprite(_vSprite) is
	push a6;
	a0:=_vSprite;
	a6:=GfxBase; jsr [a6-138];
	pop a6;
endp;															# REMVSPRITE

pattern SetCollision(_num,_routine,_gelsInfo) is
	push a6;
	safe d0.l:=_num; a0:=_routine; a1:=_gelsInfo;;
	a6:=GfxBase; jsr [a6-144];
	pop a6;
endp;															# SETCOLLISION

pattern SortGList(_rp) is
	push a6;
	a1:=_rp;
	a6:=GfxBase; jsr [a6-150];
	pop a6;
endp;															# SORTGLIST

pattern AddAnimOb(_anOb,_anKey,_rp) is
	push a2\a6;
	safe a0:=_anOb; a1:=_anKey; a2:=_rp;;
	a6:=GfxBase; jsr [a6-156];
	pop a2\a6;
endp;															# ADDANIMOB

pattern Animate(_anKey,_rp) is
	push a6;
	safe a0:=_anKey; a1:=_rp;;
	a6:=GfxBase; jsr [a6-162];
	pop a6;
endp;															# ANIMATE

pattern GetGBuffers(_anOb,_rp,_flag) is
	push a6;
	safe a0:=_anOb; a1:=_rp; d0.l:=_flag;;
	a6:=GfxBase; jsr [a6-168];
	pop a6;
endp;															# GETGBUFFERS

pattern InitGMasks(_anOb) is
	push a6;
	a0:=_anOb;
	a6:=GfxBase; jsr [a6-174];
	pop a6;
endp;															# INITGMASKS

pattern DrawEllipse(_rp,_xCenter,_yCenter,_a,_b) is
	push d2\d3\a6;
	safe a1:=_rp; d0.l:=_xCenter; d1.l:=_yCenter; d2.l:=_a; d3.l:=_b;;
	a6:=GfxBase; jsr [a6-180];
	pop d2\d3\a6;
endp;															# DRAWELLIPSE

pattern AreaEllipse(_rp,_xCenter,_yCenter,_a,_b) is
	push d2\d3\a6;
	safe a1:=_rp; d0.l:=_xCenter; d1.l:=_yCenter; d2.l:=_a; d3.l:=_b;;
	a6:=GfxBase; jsr [a6-186];
	pop d2\d3\a6;
endp;															# AREAELLIPSE

pattern LoadRGB4(_vp,_colors,_count) is
	push a6;
	safe a0:=_vp; a1:=_colors; d0.l:=_count;;
	a6:=GfxBase; jsr [a6-192];
	pop a6;
endp;															# LOADRGB4

pattern InitRastPort(_rp) is
	push a6;
	a1:=_rp;
	a6:=GfxBase; jsr [a6-198];
	pop a6;
endp;															# INITRASTPORT

pattern InitVPort(_vp) is
	push a6;
	a0:=_vp;
	a6:=GfxBase; jsr [a6-204];
	pop a6;
endp;															# INITVPORT

pattern MrgCop(_view) is
	push a6;
	a1:=_view;
	a6:=GfxBase; jsr [a6-210];
	pop a6;
endp;															# MRGCOP

pattern MakeVPort(_view,_vp) is
	push a6;
	safe a0:=_view; a1:=_vp;;
	a6:=GfxBase; jsr [a6-216];
	pop a6;
endp;															# MAKEVPORT

pattern LoadView(_view) is
	push a6;
	a1:=_view;
	a6:=GfxBase; jsr [a6-222];
	pop a6;
endp;															# LOADVIEW

pattern WaitBlit is
	push a6;
	a6:=GfxBase; jsr [a6-228];
	pop a6;
endp;															# WAITBLIT

pattern SetRast(_rp,_pen) is
	push a6;
	safe a1:=_rp; d0.l:=_pen;;
	a6:=GfxBase; jsr [a6-234];
	pop a6;
endp;															# SETRAST

pattern gfxMove(_rp,_x,_y) is
	push a6;
	safe a1:=_rp; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-240];
	pop a6;
endp;															# GFXMOVE

pattern Draw(_rp,_x,_y) is
	push a6;
	safe a1:=_rp; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-246];
	pop a6;
endp;															# DRAW

pattern AreaMove(_rp,_x,_y) is
	push a6;
	safe a1:=_rp; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-252];
	pop a6;
endp;															# AREAMOVE

pattern AreaDraw(_rp,_x,_y) is
	push a6;
	safe a1:=_rp; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-258];
	pop a6;
endp;															# AREADRAW

pattern AreaEnd(_rp) is
	push a6;
	a1:=_rp;
	a6:=GfxBase; jsr [a6-264];
	pop a6;
endp;															# AREAEND

pattern WaitTOF is
	push a6;
	a6:=GfxBase; jsr [a6-270];
	pop a6;
endp;															# WAITTOF

pattern QBlit(_blit) is
	push a6;
	a1:=_blit;
	a6:=GfxBase; jsr [a6-276];
	pop a6;
endp;															# QBLIT

pattern InitArea(_areaInfo,_vectorBuffer,_maxVectors) is
	push a6;
	safe a0:=_areaInfo; a1:=_vectorBuffer; d0.l:=_maxVectors;;
	a6:=GfxBase; jsr [a6-282];
	pop a6;
endp;															# INITAREA

pattern SetRGB4(_vp,_index,_red,_green,_blue) is
	push d2\d3\a6;
	safe a0:=_vp; d0.l:=_index; d1.l:=_red; d2.l:=_green; d3.l:=_blue;;
	a6:=GfxBase; jsr [a6-288];
	pop d2\d3\a6;
endp;															# SETRGB4

pattern QBSBlit(_blit) is
	push a6;
	a1:=_blit;
	a6:=GfxBase; jsr [a6-294];
	pop a6;
endp;															# QBSBLIT

pattern BltClear(_memBlock,_byteCount,_flags) is
	push a6;
	safe a1:=_memBlock; d0.l:=_byteCount; d1.l:=_flags;;
	a6:=GfxBase; jsr [a6-300];
	pop a6;
endp;															# BLTCLEAR

pattern RectFill(_rp,_xMin,_yMin,_xMax,_yMax) is
	push d2\d3\a6;
	safe a1:=_rp; d0.l:=_xMin; d1.l:=_yMin; d2.l:=_xMax; d3.l:=_yMax;;
	a6:=GfxBase; jsr [a6-306];
	pop d2\d3\a6;
endp;															# RECTFILL

pattern BltPattern(_rp,_mask,_xMin,_yMin,_xMax,_yMax,_maskBPR) is
	push d2\d3\d4\a6;
	safe a1:=_rp; a0:=_mask; d0.l:=_xMin; d1.l:=_yMin; d2.l:=_xMax; d3.l:=_yMax; d4.l:=_maskBPR;;
	a6:=GfxBase; jsr [a6-312];
	pop d2\d3\d4\a6;
endp;															# BLTPATTERN

pattern ReadPixel(_rp,_x,_y) is
	push a6;
	safe a1:=_rp; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-318];
	pop a6;
endp;															# READPIXEL

pattern WritePixel(_rp,_x,_y) is
	push a6;
	safe a1:=_rp; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-324];
	pop a6;
endp;															# WRITEPIXEL

pattern Flood(_rp,_mode,_x,_y) is
	push d2\a6;
	safe a1:=_rp; d2.l:=_mode; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-330];
	pop d2\a6;
endp;															# FLOOD

pattern PolyDraw(_rp,_count,_polyTable) is
	push a6;
	safe a1:=_rp; d0.l:=_count; a0:=_polyTable;;
	a6:=GfxBase; jsr [a6-336];
	pop a6;
endp;															# POLYDRAW

pattern SetAPen(_rp,_pen) is
	push a6;
	safe a1:=_rp; d0.l:=_pen;;
	a6:=GfxBase; jsr [a6-342];
	pop a6;
endp;															# SETAPEN

pattern SetBPen(_rp,_pen) is
	push a6;
	safe a1:=_rp; d0.l:=_pen;;
	a6:=GfxBase; jsr [a6-348];
	pop a6;
endp;															# SETBPEN

pattern SetDrMd(_rp,_drawMode) is
	push a6;
	safe a1:=_rp; d0.l:=_drawMode;;
	a6:=GfxBase; jsr [a6-354];
	pop a6;
endp;															# SETDRMD

pattern InitView(_view) is
	push a6;
	a1:=_view;
	a6:=GfxBase; jsr [a6-360];
	pop a6;
endp;															# INITVIEW

pattern CBump(_copList) is
	push a6;
	a1:=_copList;
	a6:=GfxBase; jsr [a6-366];
	pop a6;
endp;															# CBUMP

pattern CMove(_copList,_destination,_data) is
	push a6;
	safe a1:=_copList; d0.l:=_destination; d1.l:=_data;;
	a6:=GfxBase; jsr [a6-372];
	pop a6;
endp;															# CMOVE

pattern CWait(_copList,_v,_h) is
	push a6;
	safe a1:=_copList; d0.l:=_v; d1.l:=_h;;
	a6:=GfxBase; jsr [a6-378];
	pop a6;
endp;															# CWAIT

pattern VBeamPos is
	push a6;
	a6:=GfxBase; jsr [a6-384];
	pop a6;
endp;															# VBEAMPOS

pattern InitBitMap(_bitMap,_depth,_width,_height) is
	push d2\a6;
	safe a0:=_bitMap; d0.l:=_depth; d1.l:=_width; d2.l:=_height;;
	a6:=GfxBase; jsr [a6-390];
	pop d2\a6;
endp;															# INITBITMAP

pattern ScrollRaster(_rp,_dx,_dy,_xMin,_yMin,_xMax,_yMax) is
	push d2\d3\d4\d5\a6;
	safe a1:=_rp; d0.l:=_dx; d1.l:=_dy; d2.l:=_xMin; d3.l:=_yMin; d4.l:=_xMax; d5.l:=_yMax;;
	a6:=GfxBase; jsr [a6-396];
	pop d2\d3\d4\d5\a6;
endp;															# SCROLLRASTER

pattern WaitBOVP(_vp) is
	push a6;
	a0:=_vp;
	a6:=GfxBase; jsr [a6-402];
	pop a6;
endp;															# WAITBOVP

pattern GetSprite(_sprite,_num) is
	push a6;
	safe a0:=_sprite; d0.l:=_num;;
	a6:=GfxBase; jsr [a6-408];
	pop a6;
endp;															# GETSPRITE

pattern FreeSprite(_num) is
	push a6;
	d0.l:=_num;
	a6:=GfxBase; jsr [a6-414];
	pop a6;
endp;															# FREESPRITE

pattern ChangeSprite(_vp,_sprite,_newData) is
	push a2\a6;
	safe a0:=_vp; a1:=_sprite; a2:=_newData;;
	a6:=GfxBase; jsr [a6-420];
	pop a2\a6;
endp;															# CHANGESPRITE

pattern MoveSprite(_vp,_sprite,_x,_y) is
	push a6;
	safe a0:=_vp; a1:=_sprite; d0.l:=_x; d1.l:=_y;;
	a6:=GfxBase; jsr [a6-426];
	pop a6;
endp;															# MOVESPRITE

pattern LockLayerRom(_layer) is
	push a5\a6;
	a5:=_layer;
	a6:=GfxBase; jsr [a6-432];
	pop a5\a6;
endp;															# LOCKLAYERROM

pattern UnlockLayerRom(_layer) is
	push a5\a6;
	a5:=_layer;
	a6:=GfxBase; jsr [a6-438];
	pop a5\a6;
endp;															# UNLOCKLAYERROM

pattern SyncSBitMap(_layer) is
	push a6;
	a0:=_layer;
	a6:=GfxBase; jsr [a6-444];
	pop a6;
endp;															# SYNCSBITMAP

pattern CopySBitMap(_layer) is
	push a6;
	a0:=_layer;
	a6:=GfxBase; jsr [a6-450];
	pop a6;
endp;															# COPYSBITMAP

pattern OwnBlitter is
	push a6;
	a6:=GfxBase; jsr [a6-456];
	pop a6;
endp;															# OWNBLITTER

pattern DisownBlitter is
	push a6;
	a6:=GfxBase; jsr [a6-462];
	pop a6;
endp;															# DISOWNBLITTER

pattern InitTmpRas(_tmpRas,_buffer,_size) is
	push a6;
	safe a0:=_tmpRas; a1:=_buffer; d0.l:=_size;;
	a6:=GfxBase; jsr [a6-468];
	pop a6;
endp;															# INITTMPRAS

pattern AskFont(_rp,_textAttr) is
	push a6;
	safe a1:=_rp; a0:=_textAttr;;
	a6:=GfxBase; jsr [a6-474];
	pop a6;
endp;															# ASKFONT

pattern AddFont(_textFont) is
	push a6;
	a1:=_textFont;
	a6:=GfxBase; jsr [a6-480];
	pop a6;
endp;															# ADDFONT

pattern RemFont(_textFont) is
	push a6;
	a1:=_textFont;
	a6:=GfxBase; jsr [a6-486];
	pop a6;
endp;															# REMFONT

pattern AllocRaster(_width,_height) is
	push a6;
	safe d0.l:=_width; d1.l:=_height;;
	a6:=GfxBase; jsr [a6-492];
	pop a6;
endp;															# ALLOCRASTER

pattern FreeRaster(_p,_width,_height) is
	push a6;
	safe a0:=_p; d0.l:=_width; d1.l:=_height;;
	a6:=GfxBase; jsr [a6-498];
	pop a6;
endp;															# FREERASTER

pattern AndRectRegion(_region,_rectangle) is
	push a6;
	safe a0:=_region; a1:=_rectangle;;
	a6:=GfxBase; jsr [a6-504];
	pop a6;
endp;															# ANDRECTREGION

pattern OrRectRegion(_region,_rectangle) is
	push a6;
	safe a0:=_region; a1:=_rectangle;;
	a6:=GfxBase; jsr [a6-510];
	pop a6;
endp;															# ORRECTREGION

pattern NewRegion is
	push a6;
	a6:=GfxBase; jsr [a6-516];
	pop a6;
endp;															# NEWREGION

pattern ClearRectRegion(_region,_rectangle) is
	push a6;
	safe a0:=_region; a1:=_rectangle;;
	a6:=GfxBase; jsr [a6-522];
	pop a6;
endp;															# CLEARRECTREGION

pattern ClearRegion(_region) is
	push a6;
	a0:=_region;
	a6:=GfxBase; jsr [a6-528];
	pop a6;
endp;															# CLEARREGION

pattern DisposeRegion(_region) is
	push a6;
	a0:=_region;
	a6:=GfxBase; jsr [a6-534];
	pop a6;
endp;															# DISPOSEREGION

pattern FreeVPortCopLists(_vp) is
	push a6;
	a0:=_vp;
	a6:=GfxBase; jsr [a6-540];
	pop a6;
endp;															# FREEVPORTCOPLISTS

pattern FreeCopList(_copList) is
	push a6;
	a0:=_copList;
	a6:=GfxBase; jsr [a6-546];
	pop a6;
endp;															# FREECOPLIST

pattern ClipBlit(_srcRP,_xSrc,_ySrc,_destRP,_xDest,_yDest,_xSize,_ySize,_minterm) is
	push d2\d3\d4\d5\d6\a6;
	safe a0:=_srcRP; d0.l:=_xSrc; d1.l:=_ySrc; a1:=_destRP; d2.l:=_xDest; d3.l:=_yDest; d4.l:=_xSize; d5.l:=_ySize; d6.l:=_minterm;;
	a6:=GfxBase; jsr [a6-552];
	pop d2\d3\d4\d5\d6\a6;
endp;															# CLIPBLIT

pattern XorRectRegion(_region,_rectangle) is
	push a6;
	safe a0:=_region; a1:=_rectangle;;
	a6:=GfxBase; jsr [a6-558];
	pop a6;
endp;															# XORRECTREGION

pattern FreeCprList(_cprList) is
	push a6;
	a0:=_cprList;
	a6:=GfxBase; jsr [a6-564];
	pop a6;
endp;															# FREECPRLIST

pattern GetColorMap(_entries) is
	push a6;
	d0.l:=_entries;
	a6:=GfxBase; jsr [a6-570];
	pop a6;
endp;															# GETCOLORMAP

pattern FreeColorMap(_colorMap) is
	push a6;
	a0:=_colorMap;
	a6:=GfxBase; jsr [a6-576];
	pop a6;
endp;															# FREECOLORMAP

pattern GetRGB4(_colorMap,_entry) is
	push a6;
	safe a0:=_colorMap; d0.l:=_entry;;
	a6:=GfxBase; jsr [a6-582];
	pop a6;
endp;															# GETRGB4

pattern ScrollVPort(_vp) is
	push a6;
	a0:=_vp;
	a6:=GfxBase; jsr [a6-588];
	pop a6;
endp;															# SCROLLVPORT

pattern UCopperListInit(_uCopList,_n) is
	push a6;
	safe a0:=_uCopList; d0.l:=_n;;
	a6:=GfxBase; jsr [a6-594];
	pop a6;
endp;															# UCOPPERLISTINIT

pattern FreeGBuffers(_anOb,_rp,_flag) is
	push a6;
	safe a0:=_anOb; a1:=_rp; d0.l:=_flag;;
	a6:=GfxBase; jsr [a6-600];
	pop a6;
endp;															# FREEGBUFFERS

pattern BltBitMapRastPort(_srcBitMap,_xSrc,_ySrc,_destRP,_xDest,_yDest,_xSize,_ySize,_minterm) is
	push d2\d3\d4\d5\d6\a6;
	safe a0:=_srcBitMap; d0.l:=_xSrc; d1.l:=_ySrc; a1:=_destRP; d2.l:=_xDest; d3.l:=_yDest; d4.l:=_xSize; d5.l:=_ySize; d6.l:=_minterm;;
	a6:=GfxBase; jsr [a6-606];
	pop d2\d3\d4\d5\d6\a6;
endp;															# BLTBITMAPRASTPORT

pattern OrRegionRegion(_srcRegion,_destRegion) is
	push a6;
	safe a0:=_srcRegion; a1:=_destRegion;;
	a6:=GfxBase; jsr [a6-612];
	pop a6;
endp;															# ORREGIONREGION

pattern XorRegionRegion(_srcRegion,_destRegion) is
	push a6;
	safe a0:=_srcRegion; a1:=_destRegion;;
	a6:=GfxBase; jsr [a6-618];
	pop a6;
endp;															# XORREGIONREGION

pattern AndRegionRegion(_srcRegion,_destRegion) is
	push a6;
	safe a0:=_srcRegion; a1:=_destRegion;;
	a6:=GfxBase; jsr [a6-624];
	pop a6;
endp;															# ANDREGIONREGION

pattern SetRGB4CM(_colorMap,_index,_red,_green,_blue) is
	push d2\d3\a6;
	safe a0:=_colorMap; d0.l:=_index; d1.l:=_red; d2.l:=_green; d3.l:=_blue;;
	a6:=GfxBase; jsr [a6-630];
	pop d2\d3\a6;
endp;															# SETRGB4CM

pattern BltMaskBitMapRastPort(_srcBitMap,_xSrc,_ySrc,_destRP,_xDest,_yDest,_xSize,_ySize,_minterm,_bltMask) is
	push d2\d3\d4\d5\d6\a2\a6;
	safe a0:=_srcBitMap; d0.l:=_xSrc; d1.l:=_ySrc; a1:=_destRP; d2.l:=_xDest; d3.l:=_yDest; d4.l:=_xSize; d5.l:=_ySize; d6.l:=_minterm; a2:=_bltMask;;
	a6:=GfxBase; jsr [a6-636];
	pop d2\d3\d4\d5\d6\a2\a6;
endp;															# BLTMASKBITMAPRASTPORT

pattern graphicsPrivate1 is
	push a6;
	a6:=GfxBase; jsr [a6-642];
	pop a6;
endp;															# GRAPHICSPRIVATE1

pattern graphicsPrivate2 is
	push a6;
	a6:=GfxBase; jsr [a6-648];
	pop a6;
endp;															# GRAPHICSPRIVATE2

pattern AttemptLockLayerRom(_layer) is
	push a5\a6;
	a5:=_layer;
	a6:=GfxBase; jsr [a6-654];
	pop a5\a6;
endp;															# ATTEMPTLOCKLAYERROM

pattern GfxNew(_gfxNodeType) is
	push a6;
	d0.l:=_gfxNodeType;
	a6:=GfxBase; jsr [a6-660];
	pop a6;
endp;															# GFXNEW

pattern GfxFree(_gfxNodePtr) is
	push a6;
	a0:=_gfxNodePtr;
	a6:=GfxBase; jsr [a6-666];
	pop a6;
endp;															# GFXFREE

pattern GfxAssociate(_associateNode,_gfxNodePtr) is
	push a6;
	safe a0:=_associateNode; a1:=_gfxNodePtr;;
	a6:=GfxBase; jsr [a6-672];
	pop a6;
endp;															# GFXASSOCIATE

pattern BitMapScale(_bitScaleArgs) is
	push a6;
	a0:=_bitScaleArgs;
	a6:=GfxBase; jsr [a6-678];
	pop a6;
endp;															# BITMAPSCALE

pattern ScalerDiv(_factor,_numerator,_denominator) is
	push d2\a6;
	safe d0.l:=_factor; d1.l:=_numerator; d2.l:=_denominator;;
	a6:=GfxBase; jsr [a6-684];
	pop d2\a6;
endp;															# SCALERDIV

pattern gfxTextExtent(_rp,_string,_count,_textExtent) is
	push a2\a6;
	safe a1:=_rp; a0:=_string; d0.l:=_count; a2:=_textExtent;;
	a6:=GfxBase; jsr [a6-690];
	pop a2\a6;
endp;															# GFXTEXTEXTENT

pattern TextFit(_rp,_string,_strLen,_textExtent,_constrainingExtent,_strDirection,_constrainingBitWidth,_constrainingBitHeight) is
	push d2\d3\a2\a3\a6;
	safe a1:=_rp; a0:=_string; d0.l:=_strLen; a2:=_textExtent; a3:=_constrainingExtent; d1.l:=_strDirection; d2.l:=_constrainingBitWidth; d3.l:=_constrainingBitHeight;;
	a6:=GfxBase; jsr [a6-696];
	pop d2\d3\a2\a3\a6;
endp;															# TEXTFIT

pattern GfxLookUp(_associateNode) is
	push a6;
	a0:=_associateNode;
	a6:=GfxBase; jsr [a6-702];
	pop a6;
endp;															# GFXLOOKUP

pattern VideoControl(_colorMap,_tagarray) is
	push a6;
	safe a0:=_colorMap; a1:=_tagarray;;
	a6:=GfxBase; jsr [a6-708];
	pop a6;
endp;															# VIDEOCONTROL

pattern OpenMonitor(_monitorName,_displayID) is
	push a6;
	safe a1:=_monitorName; d0.l:=_displayID;;
	a6:=GfxBase; jsr [a6-714];
	pop a6;
endp;															# OPENMONITOR

pattern CloseMonitor(_monitorSpec) is
	push a6;
	a0:=_monitorSpec;
	a6:=GfxBase; jsr [a6-720];
	pop a6;
endp;															# CLOSEMONITOR

pattern FindDisplayInfo(_displayID) is
	push a6;
	d0.l:=_displayID;
	a6:=GfxBase; jsr [a6-726];
	pop a6;
endp;															# FINDDISPLAYINFO

pattern NextDisplayInfo(_displayID) is
	push a6;
	d0.l:=_displayID;
	a6:=GfxBase; jsr [a6-732];
	pop a6;
endp;															# NEXTDISPLAYINFO

pattern graphicsPrivate3 is
	push a6;
	a6:=GfxBase; jsr [a6-738];
	pop a6;
endp;															# GRAPHICSPRIVATE3

pattern graphicsPrivate4 is
	push a6;
	a6:=GfxBase; jsr [a6-744];
	pop a6;
endp;															# GRAPHICSPRIVATE4

pattern graphicsPrivate5 is
	push a6;
	a6:=GfxBase; jsr [a6-750];
	pop a6;
endp;															# GRAPHICSPRIVATE5

pattern GetDisplayInfoData(_handle,_buf,_size,_tagID,_displayID) is
	push d2\a6;
	safe a0:=_handle; a1:=_buf; d0.l:=_size; d1.l:=_tagID; d2.l:=_displayID;;
	a6:=GfxBase; jsr [a6-756];
	pop d2\a6;
endp;															# GETDISPLAYINFODATA

pattern FontExtent(_font,_fontExtent) is
	push a6;
	safe a0:=_font; a1:=_fontExtent;;
	a6:=GfxBase; jsr [a6-762];
	pop a6;
endp;															# FONTEXTENT

pattern ReadPixelLine8(_rp,_xstart,_ystart,_width,_array,_tempRP) is
	push d2\a2\a6;
	safe a0:=_rp; d0.l:=_xstart; d1.l:=_ystart; d2.l:=_width; a2:=_array; a1:=_tempRP;;
	a6:=GfxBase; jsr [a6-768];
	pop d2\a2\a6;
endp;															# READPIXELLINE8

pattern WritePixelLine8(_rp,_xstart,_ystart,_width,_array,_tempRP) is
	push d2\a2\a6;
	safe a0:=_rp; d0.l:=_xstart; d1.l:=_ystart; d2.l:=_width; a2:=_array; a1:=_tempRP;;
	a6:=GfxBase; jsr [a6-774];
	pop d2\a2\a6;
endp;															# WRITEPIXELLINE8

pattern ReadPixelArray8(_rp,_xstart,_ystart,_xstop,_ystop,_array,_temprp) is
	push d2\d3\a2\a6;
	safe a0:=_rp; d0.l:=_xstart; d1.l:=_ystart; d2.l:=_xstop; d3.l:=_ystop; a2:=_array; a1:=_temprp;;
	a6:=GfxBase; jsr [a6-780];
	pop d2\d3\a2\a6;
endp;															# READPIXELARRAY8

pattern WritePixelArray8(_rp,_xstart,_ystart,_xstop,_ystop,_array,_temprp) is
	push d2\d3\a2\a6;
	safe a0:=_rp; d0.l:=_xstart; d1.l:=_ystart; d2.l:=_xstop; d3.l:=_ystop; a2:=_array; a1:=_temprp;;
	a6:=GfxBase; jsr [a6-786];
	pop d2\d3\a2\a6;
endp;															# WRITEPIXELARRAY8

pattern GetVPModeID(_vp) is
	push a6;
	a0:=_vp;
	a6:=GfxBase; jsr [a6-792];
	pop a6;
endp;															# GETVPMODEID

pattern ModeNotAvailable(_modeID) is
	push a6;
	d0.l:=_modeID;
	a6:=GfxBase; jsr [a6-798];
	pop a6;
endp;															# MODENOTAVAILABLE

pattern WeighTAMatch(_reqTextAttr,_targetTextAttr,_targetTags) is
	push a2\a6;
	safe a0:=_reqTextAttr; a1:=_targetTextAttr; a2:=_targetTags;;
	a6:=GfxBase; jsr [a6-804];
	pop a2\a6;
endp;															# WEIGHTAMATCH

pattern EraseRect(_rp,_xMin,_yMin,_xMax,_yMax) is
	push d2\d3\a6;
	safe a1:=_rp; d0.l:=_xMin; d1.l:=_yMin; d2.l:=_xMax; d3.l:=_yMax;;
	a6:=GfxBase; jsr [a6-810];
	pop d2\d3\a6;
endp;															# ERASERECT

pattern ExtendFont(_font,_fontTags) is
	push a6;
	safe a0:=_font; a1:=_fontTags;;
	a6:=GfxBase; jsr [a6-816];
	pop a6;
endp;															# EXTENDFONT

pattern StripFont(_font) is
	push a6;
	a0:=_font;
	a6:=GfxBase; jsr [a6-822];
	pop a6;
endp;															# STRIPFONT

pattern CalcIVG(_v,_vp) is
	push a6;
	safe a0:=_v; a1:=_vp;;
	a6:=GfxBase; jsr [a6-828];
	pop a6;
endp;															# CALCIVG

pattern AttachPalExtra(_cm,_vp) is
	push a6;
	safe a0:=_cm; a1:=_vp;;
	a6:=GfxBase; jsr [a6-834];
	pop a6;
endp;															# ATTACHPALEXTRA

pattern ObtainBestPenA(_cm,_r,_g,_b,_tags) is
	push d2\d3\a6;
	safe a0:=_cm; d1.l:=_r; d2.l:=_g; d3.l:=_b; a1:=_tags;;
	a6:=GfxBase; jsr [a6-840];
	pop d2\d3\a6;
endp;															# OBTAINBESTPENA

pattern graphicsPrivate6 is
	push a6;
	a6:=GfxBase; jsr [a6-846];
	pop a6;
endp;															# GRAPHICSPRIVATE6

pattern SetRGB32(_vp,_n,_r,_g,_b) is
	push d2\d3\a6;
	safe a0:=_vp; d0.l:=_n; d1.l:=_r; d2.l:=_g; d3.l:=_b;;
	a6:=GfxBase; jsr [a6-852];
	pop d2\d3\a6;
endp;															# SETRGB32

pattern GetAPen(_rp) is
	push a6;
	a0:=_rp;
	a6:=GfxBase; jsr [a6-858];
	pop a6;
endp;															# GETAPEN

pattern GetBPen(_rp) is
	push a6;
	a0:=_rp;
	a6:=GfxBase; jsr [a6-864];
	pop a6;
endp;															# GETBPEN

pattern GetDrMd(_rp) is
	push a6;
	a0:=_rp;
	a6:=GfxBase; jsr [a6-870];
	pop a6;
endp;															# GETDRMD

pattern GetOutlinePen(_rp) is
	push a6;
	a0:=_rp;
	a6:=GfxBase; jsr [a6-876];
	pop a6;
endp;															# GETOUTLINEPEN

pattern LoadRGB32(_vp,_table) is
	push a6;
	safe a0:=_vp; a1:=_table;;
	a6:=GfxBase; jsr [a6-882];
	pop a6;
endp;															# LOADRGB32

pattern SetChipRev(_want) is
	push a6;
	d0.l:=_want;
	a6:=GfxBase; jsr [a6-888];
	pop a6;
endp;															# SETCHIPREV

pattern SetABPenDrMd(_rp,_apen,_bpen,_drawmode) is
	push d2\a6;
	safe a1:=_rp; d0.l:=_apen; d1.l:=_bpen; d2.l:=_drawmode;;
	a6:=GfxBase; jsr [a6-894];
	pop d2\a6;
endp;															# SETABPENDRMD

pattern GetRGB32(_cm,_firstcolor,_ncolors,_table) is
	push a6;
	safe a0:=_cm; d0.l:=_firstcolor; d1.l:=_ncolors; a1:=_table;;
	a6:=GfxBase; jsr [a6-900];
	pop a6;
endp;															# GETRGB32

pattern graphicsPrivate7 is
	push a6;
	a6:=GfxBase; jsr [a6-906];
	pop a6;
endp;															# GRAPHICSPRIVATE7

pattern graphicsPrivate8 is
	push a6;
	a6:=GfxBase; jsr [a6-912];
	pop a6;
endp;															# GRAPHICSPRIVATE8

pattern AllocBitMap(_sizex,_sizey,_depth,_flags,_friend_bitmap) is
	push d2\d3\a6;
	safe d0.l:=_sizex; d1.l:=_sizey; d2.l:=_depth; d3.l:=_flags; a0:=_friend_bitmap;;
	a6:=GfxBase; jsr [a6-918];
	pop d2\d3\a6;
endp;															# ALLOCBITMAP

pattern FreeBitMap(_bm) is
	push a6;
	a0:=_bm;
	a6:=GfxBase; jsr [a6-924];
	pop a6;
endp;															# FREEBITMAP

pattern GetExtSpriteA(_ss,_tags) is
	push a2\a6;
	safe a2:=_ss; a1:=_tags;;
	a6:=GfxBase; jsr [a6-930];
	pop a2\a6;
endp;															# GETEXTSPRITEA

pattern CoerceMode(_vp,_monitorid,_flags) is
	push a6;
	safe a0:=_vp; d0.l:=_monitorid; d1.l:=_flags;;
	a6:=GfxBase; jsr [a6-936];
	pop a6;
endp;															# COERCEMODE

pattern ChangeVPBitMap(_vp,_bm,_db) is
	push a2\a6;
	safe a0:=_vp; a1:=_bm; a2:=_db;;
	a6:=GfxBase; jsr [a6-942];
	pop a2\a6;
endp;															# CHANGEVPBITMAP

pattern ReleasePen(_cm,_n) is
	push a6;
	safe a0:=_cm; d0.l:=_n;;
	a6:=GfxBase; jsr [a6-948];
	pop a6;
endp;															# RELEASEPEN

pattern ObtainPen(_cm,_n,_r,_g,_b,_f) is
	push d2\d3\d4\a6;
	safe a0:=_cm; d0.l:=_n; d1.l:=_r; d2.l:=_g; d3.l:=_b; d4.l:=_f;;
	a6:=GfxBase; jsr [a6-954];
	pop d2\d3\d4\a6;
endp;															# OBTAINPEN

pattern GetBitMapAttr(_bm,_attrnum) is
	push a6;
	safe a0:=_bm; d1.l:=_attrnum;;
	a6:=GfxBase; jsr [a6-960];
	pop a6;
endp;															# GETBITMAPATTR

pattern AllocDBufInfo(_vp) is
	push a6;
	a0:=_vp;
	a6:=GfxBase; jsr [a6-966];
	pop a6;
endp;															# ALLOCDBUFINFO

pattern FreeDBufInfo(_dbi) is
	push a6;
	a1:=_dbi;
	a6:=GfxBase; jsr [a6-972];
	pop a6;
endp;															# FREEDBUFINFO

pattern SetOutlinePen(_rp,_pen) is
	push a6;
	safe a0:=_rp; d0.l:=_pen;;
	a6:=GfxBase; jsr [a6-978];
	pop a6;
endp;															# SETOUTLINEPEN

pattern SetWriteMask(_rp,_msk) is
	push a6;
	safe a0:=_rp; d0.l:=_msk;;
	a6:=GfxBase; jsr [a6-984];
	pop a6;
endp;															# SETWRITEMASK

pattern SetMaxPen(_rp,_maxpen) is
	push a6;
	safe a0:=_rp; d0.l:=_maxpen;;
	a6:=GfxBase; jsr [a6-990];
	pop a6;
endp;															# SETMAXPEN

pattern SetRGB32CM(_cm,_n,_r,_g,_b) is
	push d2\d3\a6;
	safe a0:=_cm; d0.l:=_n; d1.l:=_r; d2.l:=_g; d3.l:=_b;;
	a6:=GfxBase; jsr [a6-996];
	pop d2\d3\a6;
endp;															# SETRGB32CM

pattern ScrollRasterBF(_rp,_dx,_dy,_xMin,_yMin,_xMax,_yMax) is
	push d2\d3\d4\d5\a6;
	safe a1:=_rp; d0.l:=_dx; d1.l:=_dy; d2.l:=_xMin; d3.l:=_yMin; d4.l:=_xMax; d5.l:=_yMax;;
	a6:=GfxBase; jsr [a6-1002];
	pop d2\d3\d4\d5\a6;
endp;															# SCROLLRASTERBF

pattern FindColor(_cm,_r,_g,_b,_maxcolor) is
	push d2\d3\d4\a3\a6;
	safe a3:=_cm; d1.l:=_r; d2.l:=_g; d3.l:=_b; d4.l:=_maxcolor;;
	a6:=GfxBase; jsr [a6-1008];
	pop d2\d3\d4\a3\a6;
endp;															# FINDCOLOR

pattern graphicsPrivate9 is
	push a6;
	a6:=GfxBase; jsr [a6-1014];
	pop a6;
endp;															# GRAPHICSPRIVATE9

pattern AllocSpriteDataA(_bm,_tags) is
	push a2\a6;
	safe a2:=_bm; a1:=_tags;;
	a6:=GfxBase; jsr [a6-1020];
	pop a2\a6;
endp;															# ALLOCSPRITEDATAA

pattern ChangeExtSpriteA(_vp,_oldsprite,_newsprite,_tags) is
	push a2\a3\a6;
	safe a0:=_vp; a1:=_oldsprite; a2:=_newsprite; a3:=_tags;;
	a6:=GfxBase; jsr [a6-1026];
	pop a2\a3\a6;
endp;															# CHANGEEXTSPRITEA

pattern FreeSpriteData(_sp) is
	push a2\a6;
	a2:=_sp;
	a6:=GfxBase; jsr [a6-1032];
	pop a2\a6;
endp;															# FREESPRITEDATA

pattern SetRPAttrsA(_rp,_tags) is
	push a6;
	safe a0:=_rp; a1:=_tags;;
	a6:=GfxBase; jsr [a6-1038];
	pop a6;
endp;															# SETRPATTRSA

pattern GetRPAttrsA(_rp,_tags) is
	push a6;
	safe a0:=_rp; a1:=_tags;;
	a6:=GfxBase; jsr [a6-1044];
	pop a6;
endp;															# GETRPATTRSA

pattern BestModeIDA(_tags) is
	push a6;
	a0:=_tags;
	a6:=GfxBase; jsr [a6-1050];
	pop a6;
endp;															# BESTMODEIDA

pattern WriteChunkyPixels(_rp,_xstart,_ystart,_xstop,_ystop,_array,_bytesperrow) is
	push d2\d3\d4\a2\a6;
	safe a0:=_rp; d0.l:=_xstart; d1.l:=_ystart; d2.l:=_xstop; d3.l:=_ystop; a2:=_array; d4.l:=_bytesperrow;;
	a6:=GfxBase; jsr [a6-1056];
	pop d2\d3\d4\a2\a6;
endp;															# WRITECHUNKYPIXELS

