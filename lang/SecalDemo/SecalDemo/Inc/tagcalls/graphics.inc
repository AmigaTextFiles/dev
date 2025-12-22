pattern AllocSpriteData(_bm, ...) is
	push a2\a6;
	push.l ...;
	safe a2:=_bm; a1:=sp;;
	a6:=GfxBase; jsr [a6-1020];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# ALLOCSPRITEDATA

pattern BestModeID( ...) is
	push a6;
	push.l ...;
	a0:=sp;
	a6:=GfxBase; jsr [a6-1050];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# BESTMODEID

pattern ChangeExtSprite(_vp,_oldsprite,_newsprite, ...) is
	push a2\a3\a6;
	push.l ...;
	safe a0:=_vp; a1:=_oldsprite; a2:=_newsprite; a3:=sp;;
	a6:=GfxBase; jsr [a6-1026];
	sp:=sp+countof(...)<<2;
	pop a2\a3\a6;
endp;															# CHANGEEXTSPRITE

pattern ExtendFontTags(_font, ...) is
	push a6;
	push.l ...;
	safe a0:=_font; a1:=sp;;
	a6:=GfxBase; jsr [a6-816];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# EXTENDFONTTAGS

pattern GetExtSprite(_ss, ...) is
	push a2\a6;
	push.l ...;
	safe a2:=_ss; a1:=sp;;
	a6:=GfxBase; jsr [a6-930];
	sp:=sp+countof(...)<<2;
	pop a2\a6;
endp;															# GETEXTSPRITE

pattern GetRPAttrs(_rp, ...) is
	push a6;
	push.l ...;
	safe a0:=_rp; a1:=sp;;
	a6:=GfxBase; jsr [a6-1044];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# GETRPATTRS

pattern ObtainBestPen(_cm,_r,_g,_b, ...) is
	push d2\d3\a6;
	push.l ...;
	safe a0:=_cm; d1.l:=_r; d2.l:=_g; d3.l:=_b; a1:=sp;;
	a6:=GfxBase; jsr [a6-840];
	sp:=sp+countof(...)<<2;
	pop d2\d3\a6;
endp;															# OBTAINBESTPEN

pattern SetRPAttrs(_rp, ...) is
	push a6;
	push.l ...;
	safe a0:=_rp; a1:=sp;;
	a6:=GfxBase; jsr [a6-1038];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETRPATTRS

pattern VideoControlTags(_colorMap, ...) is
	push a6;
	push.l ...;
	safe a0:=_colorMap; a1:=sp;;
	a6:=GfxBase; jsr [a6-708];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# VIDEOCONTROLTAGS

