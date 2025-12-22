pattern InitLayers(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-30];
	pop a6;
endp;															# INITLAYERS

pattern CreateUpfrontLayer(_li,_bm,_x0,_y0,_x1,_y1,_flags,_bm2) is
	push d2\d3\d4\a2\a6;
	safe a0:=_li; a1:=_bm; d0.l:=_x0; d1.l:=_y0; d2.l:=_x1; d3.l:=_y1; d4.l:=_flags; a2:=_bm2;;
	a6:=LayersBase; jsr [a6-36];
	pop d2\d3\d4\a2\a6;
endp;															# CREATEUPFRONTLAYER

pattern CreateBehindLayer(_li,_bm,_x0,_y0,_x1,_y1,_flags,_bm2) is
	push d2\d3\d4\a2\a6;
	safe a0:=_li; a1:=_bm; d0.l:=_x0; d1.l:=_y0; d2.l:=_x1; d3.l:=_y1; d4.l:=_flags; a2:=_bm2;;
	a6:=LayersBase; jsr [a6-42];
	pop d2\d3\d4\a2\a6;
endp;															# CREATEBEHINDLAYER

pattern UpfrontLayer(_dummy,_layer) is
	push a6;
	safe a0:=_dummy; a1:=_layer;;
	a6:=LayersBase; jsr [a6-48];
	pop a6;
endp;															# UPFRONTLAYER

pattern BehindLayer(_dummy,_layer) is
	push a6;
	safe a0:=_dummy; a1:=_layer;;
	a6:=LayersBase; jsr [a6-54];
	pop a6;
endp;															# BEHINDLAYER

pattern MoveLayer(_dummy,_layer,_dx,_dy) is
	push a6;
	safe a0:=_dummy; a1:=_layer; d0.l:=_dx; d1.l:=_dy;;
	a6:=LayersBase; jsr [a6-60];
	pop a6;
endp;															# MOVELAYER

pattern SizeLayer(_dummy,_layer,_dx,_dy) is
	push a6;
	safe a0:=_dummy; a1:=_layer; d0.l:=_dx; d1.l:=_dy;;
	a6:=LayersBase; jsr [a6-66];
	pop a6;
endp;															# SIZELAYER

pattern ScrollLayer(_dummy,_layer,_dx,_dy) is
	push a6;
	safe a0:=_dummy; a1:=_layer; d0.l:=_dx; d1.l:=_dy;;
	a6:=LayersBase; jsr [a6-72];
	pop a6;
endp;															# SCROLLLAYER

pattern BeginUpdate(_l) is
	push a6;
	a0:=_l;
	a6:=LayersBase; jsr [a6-78];
	pop a6;
endp;															# BEGINUPDATE

pattern EndUpdate(_layer,_flag) is
	push a6;
	safe a0:=_layer; d0.l:=_flag;;
	a6:=LayersBase; jsr [a6-84];
	pop a6;
endp;															# ENDUPDATE

pattern DeleteLayer(_dummy,_layer) is
	push a6;
	safe a0:=_dummy; a1:=_layer;;
	a6:=LayersBase; jsr [a6-90];
	pop a6;
endp;															# DELETELAYER

pattern LockLayer(_dummy,_layer) is
	push a6;
	safe a0:=_dummy; a1:=_layer;;
	a6:=LayersBase; jsr [a6-96];
	pop a6;
endp;															# LOCKLAYER

pattern UnlockLayer(_layer) is
	push a6;
	a0:=_layer;
	a6:=LayersBase; jsr [a6-102];
	pop a6;
endp;															# UNLOCKLAYER

pattern LockLayers(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-108];
	pop a6;
endp;															# LOCKLAYERS

pattern UnlockLayers(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-114];
	pop a6;
endp;															# UNLOCKLAYERS

pattern LockLayerInfo(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-120];
	pop a6;
endp;															# LOCKLAYERINFO

pattern SwapBitsRastPortClipRect(_rp,_cr) is
	push a6;
	safe a0:=_rp; a1:=_cr;;
	a6:=LayersBase; jsr [a6-126];
	pop a6;
endp;															# SWAPBITSRASTPORTCLIPRECT

pattern WhichLayer(_li,_x,_y) is
	push a6;
	safe a0:=_li; d0.l:=_x; d1.l:=_y;;
	a6:=LayersBase; jsr [a6-132];
	pop a6;
endp;															# WHICHLAYER

pattern UnlockLayerInfo(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-138];
	pop a6;
endp;															# UNLOCKLAYERINFO

pattern NewLayerInfo is
	push a6;
	a6:=LayersBase; jsr [a6-144];
	pop a6;
endp;															# NEWLAYERINFO

pattern DisposeLayerInfo(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-150];
	pop a6;
endp;															# DISPOSELAYERINFO

pattern FattenLayerInfo(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-156];
	pop a6;
endp;															# FATTENLAYERINFO

pattern ThinLayerInfo(_li) is
	push a6;
	a0:=_li;
	a6:=LayersBase; jsr [a6-162];
	pop a6;
endp;															# THINLAYERINFO

pattern MoveLayerInFrontOf(_layer_to_move,_other_layer) is
	push a6;
	safe a0:=_layer_to_move; a1:=_other_layer;;
	a6:=LayersBase; jsr [a6-168];
	pop a6;
endp;															# MOVELAYERINFRONTOF

pattern InstallClipRegion(_layer,_region) is
	push a6;
	safe a0:=_layer; a1:=_region;;
	a6:=LayersBase; jsr [a6-174];
	pop a6;
endp;															# INSTALLCLIPREGION

pattern MoveSizeLayer(_layer,_dx,_dy,_dw,_dh) is
	push d2\d3\a6;
	safe a0:=_layer; d0.l:=_dx; d1.l:=_dy; d2.l:=_dw; d3.l:=_dh;;
	a6:=LayersBase; jsr [a6-180];
	pop d2\d3\a6;
endp;															# MOVESIZELAYER

pattern CreateUpfrontHookLayer(_li,_bm,_x0,_y0,_x1,_y1,_flags,_hook,_bm2) is
	push d2\d3\d4\a2\a3\a6;
	safe a0:=_li; a1:=_bm; d0.l:=_x0; d1.l:=_y0; d2.l:=_x1; d3.l:=_y1; d4.l:=_flags; a3:=_hook; a2:=_bm2;;
	a6:=LayersBase; jsr [a6-186];
	pop d2\d3\d4\a2\a3\a6;
endp;															# CREATEUPFRONTHOOKLAYER

pattern CreateBehindHookLayer(_li,_bm,_x0,_y0,_x1,_y1,_flags,_hook,_bm2) is
	push d2\d3\d4\a2\a3\a6;
	safe a0:=_li; a1:=_bm; d0.l:=_x0; d1.l:=_y0; d2.l:=_x1; d3.l:=_y1; d4.l:=_flags; a3:=_hook; a2:=_bm2;;
	a6:=LayersBase; jsr [a6-192];
	pop d2\d3\d4\a2\a3\a6;
endp;															# CREATEBEHINDHOOKLAYER

pattern InstallLayerHook(_layer,_hook) is
	push a6;
	safe a0:=_layer; a1:=_hook;;
	a6:=LayersBase; jsr [a6-198];
	pop a6;
endp;															# INSTALLLAYERHOOK

pattern InstallLayerInfoHook(_li,_hook) is
	push a6;
	safe a0:=_li; a1:=_hook;;
	a6:=LayersBase; jsr [a6-204];
	pop a6;
endp;															# INSTALLLAYERINFOHOOK

pattern SortLayerCR(_layer,_dx,_dy) is
	push a6;
	safe a0:=_layer; d0.l:=_dx; d1.l:=_dy;;
	a6:=LayersBase; jsr [a6-210];
	pop a6;
endp;															# SORTLAYERCR

pattern DoHookClipRects(_hook,_rport,_rect) is
	push a2\a6;
	safe a0:=_hook; a1:=_rport; a2:=_rect;;
	a6:=LayersBase; jsr [a6-216];
	pop a2\a6;
endp;															# DOHOOKCLIPRECTS

