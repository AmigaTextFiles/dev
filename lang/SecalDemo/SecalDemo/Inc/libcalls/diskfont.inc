pattern OpenDiskFont(_textAttr) is
	push a6;
	a0:=_textAttr;
	a6:=DiskfontBase; jsr [a6-30];
	pop a6;
endp;															# OPENDISKFONT

pattern dfontAvailFonts(_buffer,_bufBytes,_flags) is
	push a6;
	safe a0:=_buffer; d0.l:=_bufBytes; d1.l:=_flags;;
	a6:=DiskfontBase; jsr [a6-36];
	pop a6;
endp;															# DFONTAVAILFONTS

pattern NewFontContents(_fontsLock,_fontName) is
	push a6;
	safe a0:=_fontsLock; a1:=_fontName;;
	a6:=DiskfontBase; jsr [a6-42];
	pop a6;
endp;															# NEWFONTCONTENTS

pattern DisposeFontContents(_fontContentsHeader) is
	push a6;
	a1:=_fontContentsHeader;
	a6:=DiskfontBase; jsr [a6-48];
	pop a6;
endp;															# DISPOSEFONTCONTENTS

pattern NewScaledDiskFont(_sourceFont,_destTextAttr) is
	push a6;
	safe a0:=_sourceFont; a1:=_destTextAttr;;
	a6:=DiskfontBase; jsr [a6-54];
	pop a6;
endp;															# NEWSCALEDDISKFONT

