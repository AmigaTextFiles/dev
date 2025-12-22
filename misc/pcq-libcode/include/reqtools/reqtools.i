{ Reqtools library copyright Nico Francois}

{Conversion to Pascal © 1991 Richard Waspe}
{Conversion to PCQ    © 1992 Michael Glew}

{$I "Include:Intuition/IntuitionBase.i"}
{$I "Include:Graphics/Text.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Reqtools/Utility.i"}

Const
	REQTOOLNAME	= "reqtools.library";
	REQTOOLSVERSION	= 37;

Type
	ReqToolsBaseType = Record
		LibNode		: Library;
		Flags		: byte;
		Pad		: Array [0..2] of byte;
		SegList		: Address;
		IntuitionBase	: LibraryPtr;
		GfxBase		: LibraryPtr;
		DOSBase		: LibraryPtr;
		GadToolsBase	: LibraryPtr;
		UtilityBase	: LibraryPtr
	End;

	ReqToolsBasePtrType	= ^ReqToolsBaseType;

var
	reqToolsBase	: ReqToolsBasePtrType;

Const
	RT_FILEREQ	: Integer	= 0;
	RT_REQINFO	: Integer	= 1;
	RT_FONTREQ	: Integer	= 2;

{*** File Requester ***}

Type
	FileRequester	= Record
		ReqPos		: Integer;
		LeftOffset	: Short;
		TopOffset	: Short;
		Flags		: Integer;
		Hook		: HookPtr;
		Dir		: String;
		MatchPat	: String;
		DefaultFont	: TextFontPtr;
		WaitPointer	: Integer
	End;
	FileRequesterPtr = ^FileRequester;

	FileList	= Record
		Next	: ^FileList;
		StrLen	: Integer;
		Name	: String
	End;
	FileListPtr = ^FileList;

{*** Font Requester ***}

	FontRequester	= Record
		ReqPos		: Integer;
		LeftOffset	: Short;
		TopOffset	: Short;
		Flags		: Integer;
		Hook		: HookPtr;
		Attr		: TextAttrPtr;
		DefaultFont	: TextFontPtr;
		WaitPointer	: Integer
	End;

{*** Requester Info ***}

	ReqInfo	= Record
		ReqPos		: Integer;
		LeftOffset	: Short;
		TopOffset	: Short;
		Width		: Integer;
		ReqTitle	: String;
		Flags		: Integer;
		DefaultFont	: TextFontPtr;
		WaitPointer	: Integer
	End;

{*** Handler Info ***)

	HandlerInfo	= Record
		private1	: Integer;
		WaitMask	: Integer;
		DoNotWait	: Integer
	End;

Const
	CALL_HANDLER		= $80000000;

{*** TAGS ***}

const
	RT_TagBase		= $80000000;

	RT_Window		= $80000001;
	RT_IDCMPFlags		= $80000002;
	RT_ReqPos		= $80000003;
	RT_LeftOffset		= $80000004;
	RT_TopOffset		= $80000005;
	RT_PubScrName		= $80000006;
	RT_Screen		= $80000007;
	RT_ReqHandler		= $80000008;
	RT_DefaultFont		= $80000009;
	RT_WaitPointer		= $8000000A;

	RTEZ_ReqTitle		= $80000014;
	RTEZ_Flags		= $80000016;
	RTEZ_DefaultResponse	= $80000017;

	RTGL_Min		= $8000001E;
	RTGL_Max		= $8000001F;
	RTGL_Width		= $80000020;
	RTGL_ShowDefault	= $80000021;

	RTGS_Width		= RTGL_Width;
	RTGS_AllowEmpty		= $80000050;

	RTFI_Flags		= $80000028;
	RTFI_Height		= $80000029;
	RTFI_OkText		= $8000002A;

	RTFO_Flags		= RTFI_Flags;
	RTFO_Height		= RTFI_Height;
	RTFO_OkText		= RTFI_OkText;
	RTFO_SampleHeight	= $8000003C;
	RTFO_MinHeight		= $8000003D;
	RTFO_MaxHeight		= $8000003E;

	RTFI_Dir		= $80000032;
	RTFI_MatchPat		= $80000033;
	RTFI_AddEntry		= $80000034;
	RTFI_RemoveEntry	= $80000035;

	RTFO_FontName		= $8000003F;
	RTFO_FontHeight		= $80000040;
	RTFO_FontStyle		= $80000041;
	RTFO_FontFlags		= $80000042;

	RTPA_Color		= $80000046;
	RTRH_EndRequest		= $8000003C;

	REQPOS_POINTER		= 0;
	REQPOS_CENTERWIN	= 1;
	REQPOS_CENTERSCR	= 2;
	REQPOS_TOPLEFTWIN	= 3;
	REQPOS_TOPLEFTSCR	= 4;

	FREQB_NOBUFFER		= 2;
	FREQF_NOBUFFER		= 4;
	FREQB_DOWILDFUNC	= 11;
	FREQF_DOWILDFUNC	= 2048;
	FREQB_MULTISELECT	= 0;
	FREQF_MULTISELECT	= 1;
	FREQB_SAVE		= 1;
	FREQF_SAVE		= 2;
	FREQB_NOFILES		= 3;
	FREQF_NOFILES		= 8;
	FREQB_PATGAD		= 4;
	FREQF_PATGAD		= 16;
	FREQB_SELECTDIRS	= 12;
	FREQF_SELECTDIRS	= 4096;
	FREQB_FIXEDWIDTH	= 5;
	FREQF_FIXEDWIDTH	= 32;
	FREQB_COLORFONTS	= 6;
	FREQF_COLORFONTS	= 64;
	FREQB_CHANGEPALETTE	= 7;
	FREQF_CHANGEPALETTE	= 128;
	FREQB_LEAVEPALETTE	= 8;
	FREQF_LEAVEPALETTE	= 256;
	FREQB_SCALE		= 9;
	FREQF_SCALE		= 512;
	FREQB_STYLE		= 10;
	FREQF_STYLE		= 1024;

	EZREQB_NORETURNKEY	= 0;
	EZREQF_NORETURNKEY	= 1;
	EZREQB_LAMIGAQUAL	= 1;
	EZREQF_LAMIGAQUAL	= 2;
	EZREQB_CENTERTEXT	= 2;
	EZREQF_CENTERTEXT	= 4;

	REQHOOK_WILDFILE	= 0;
	REQHOOK_WILDFONT	= 1;

Function AllocRequestA(type_:Integer;taglist:Address):FileRequesterPtr;

begin
{$A
	move.l	a6,-(sp)
	lea	$8(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,d0
	move.l	_reqToolsBase,a6
	jsr	-$1E(a6)
	move.l	(sp)+,a6
}
end;

Procedure FreeRequest(req:Address);

begin
{$A
	move.l	a6,-(sp)
	move.l	$8(sp),a1
	move.l	_reqToolsBase,a6
	jsr	-$24(a6)
	move.l	(sp)+,a6
}
end;

Procedure FreeReqBuffer(req:Address);

begin
{$A
	move.l	a6,-(sp)
	move.l	$8(sp),a1
	move.l	_reqToolsBase,a6
	jsr	-$2A(a6)
	move.l	(sp)+,a6
}
end;

Procedure ChangeReqAttrA(req,taglist:Address);

begin
{$A
	move.l	a6,-(sp)
	movem.l	$8(sp),a0-a1
	move.l	_reqToolsBase,a6
	jsr	-$30(a6)
	move.l	(sp)+,a6
}
end;

Function FileRequestA(filereq,file_,title,taglist:Address):Integer;

begin
{$A
	movem.l	a2-a3/a6,-(sp)
	lea	$10(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a3
	move.l	(a6)+,a2
	move.l	(a6)+,a1
	move.l	_reqToolsBase,a6
	jsr	-$36(a6)
	movem.l	(sp)+,a2-a3/a6
}
end;

Procedure FreeFileList(filelist:Address);

begin
{$A
	move.l	a6,-(sp)
	move.l	$8(sp),a0
	move.l	_reqToolsBase,a6
	jsr	-$3C(a6)
	move.l	(sp)+,a6
}
end;

Function EZRequestA(bodyfmt,gadfmt,reqinfo,argarray,taglist:Address):Integer;

begin
{$A
	movem.l	a2-a4/a6,-(sp)
	lea	$14(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a4
	move.l	(a6)+,a3
	move.l	(a6)+,a2
	move.l	(a6)+,a1
	move.l	_reqToolsBase,a6
	jsr	-$42(a6)
	movem.l	(sp)+,a2-a4/a6
}
end;

Function GetStringA(buffer:Address;maxchars:Integer;
			title,reqinfo,taglist:Address):Integer;

begin
{$A
	movem.l	a2-a3/a6,-(sp)
	lea	$10(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a3
	move.l	(a6)+,a2
	move.l	(a6)+,d0
	move.l	(a6)+,a1
	move.l	_reqToolsBase,a6
	jsr	-$48(a6)
	movem.l	(sp)+,a2-a3/a6
}
end;

Function GetLongA(longptr,title,reqinfo,taglist:Address):Integer;

begin
{$A
	movem.l	a2-a3/a6,-(sp)
	lea	$10(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a3
	move.l	(a6)+,a2
	move.l	(a6)+,a1
	move.l	_reqToolsBase,a6
	jsr	-$4E(a6)
	movem.l	(sp)+,a2-a3/a6
}
end;

Function FontRequestA(fontreq,title,taglist:Address):Integer;

begin
{$A
	movem.l	a3/a6,-(sp)
	lea	$C(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a3
	move.l	(a6)+,a1
	move.l	_reqToolsBase,a6
	jsr	-$60(a6)
	movem.l	(sp)+,a3/a6
}
end;

Function PaletteRequestA(title,reqinfo,taglist:Address):Integer;

begin
{$A
	movem.l	a2-a3/a6,-(sp)
	lea	$10(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,a3
	move.l	(a6)+,a2
	move.l	_reqToolsBase,a6
	jsr	-$66(a6)
	movem.l	(sp)+,a2-a3/a6
}
end;

Function ReqHandlerA(handlerinfo:Address;sigs:Integer;
			taglist:Address):Integer;

begin
{$A
	move.l	a6,-(sp)
	lea	$8(sp),a6
	move.l	(a6)+,a0
	move.l	(a6)+,d0
	move.l	(a6)+,a1
	move.l	_reqToolsBase,a6
	jsr	-$6C(a6)
	move.l	(sp)+,a6
}
end;

Function SetWaitPointer(window:Address):Integer;

begin
{$A
	move.l	a6,-(sp)
	move.l	$8(sp),a0
	move.l	_reqToolsBase,a6
	jsr	-$72(a6)
	move.l	(sp)+,a6
}
end;

Function GetVScreenSize(screen,widthptr,heightptr:Address):Integer;

begin
{$A
	movem.l	a2/a6,-(sp)
	lea	$C(sp),a6
	move.l	(a6)+,a2
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	_reqToolsBase,a6
	jsr	-$78(a6)
	movem.l	(sp)+,a2/a6
}
end;

Function SetReqPosition(reqpos:Integer;
			newwindow,screen,window:Address): Integer;

begin
{$A
	movem.l	a2/a6,-(sp)
	lea	$C(sp),a6
	move.l	(a6)+,a2
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	(a6)+,d0
	move.l	_reqToolsBase,a6
	jsr	-$7E(a6)
	movem.l	(sp)+,a2/a6
}
end;

Function Spread(posarray,sizearray:Address;
			length,min,max,num:Integer):Integer;

begin
{$A
	movem.l	d3/a6,-(sp)
	lea	$C(sp),a6
	move.l	(a6)+,d3
	move.l	(a6)+,d2
	move.l	(a6)+,d1
	move.l	(a6)+,d0
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	_reqToolsBase,a6
	jsr	-$84(a6)
	movem.l	(sp)+,d3/a6
}
end;

Function ScreenToFrontSafely(screen:Address):Integer;

begin
{$A
	move.l	a6,-(sp)
	move.l	$8(sp),a0
	move.l	_reqToolsBase,a6
	jsr	-$8A(a6)
	move.l	(sp)+,a6
}
end;

Procedure EZrequest(a,b:string;X,y:Address);

begin
{$A
	movem.l	a2/a3/a4/a6,-(a7)
	move.l	_reqToolsBase,a6
	movem.l	20(a7),a1/a2/a3
	move.l	32(a7),a0
	lea		36(a7),a4
	jsr		-$42(a6)
	movem.l	(a7)+,a2/a3/a4/a6
}
end;
