*   AIDE 2.12, an environment for ACE
*   Copyright (C) 1995/97 by Herbert Breuer
*		  1997/99 by Daniel Seifert
*
*                 contact me at: dseifert@berlin.sireco.net
*
*                                Daniel Seifert
*                                Elsenborner Weg 25
*                                12621 Berlin
*                                GERMANY
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 2 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, write to the
*          Free Software Foundation, Inc., 59 Temple Place, 
*          Suite 330, Boston, MA  02111-1307  USA

*--------------------------------------
* IntuiNewScreenStruktur
*--------------------------------------
_ScreenTags
		dc.l    SA_Left,0
		dc.l    SA_Top,0
		dc.l    SA_Width,640
		dc.l    SA_Height,-1
		dc.l    SA_Depth,2
		dc.l    SA_DetailPen,2
		dc.l    SA_BlockPen,1
		dc.l    SA_Title,_ScreenTitle
		dc.l    SA_Font,_ThinpazAttr
		dc.l    SA_Type,PUBLICSCREEN
		dc.l    SA_Behind,True
		dc.l    SA_DisplayID,HIRES_KEY
		dc.l    SA_PubName,_ScreenTitle
		dc.l    SA_Pens,_Pens
		dc.l    SA_PubSig
SigNummer
		dc.l    0
		dc.l    SA_ErrorCode,ScreenOpenError
		dc.l    TAG_DONE

_ScreenTitle    dc.b    "AIDE Screen",0
		even

_Pens   	dc.w    -1,0

ScreenOpenError dc.l    0

ScreenSignal    dc.l    0
*--------------------------------------
* IntuiNewWindowStruktur
*--------------------------------------
_NewWindow      dc.w    29      	; LeftEdge
		dc.w    0       	; TopEdge
		dc.w    582     	; Width
		dc.w    194     	; Height
		dc.b    2       	; DetailPen
		dc.b    1       	; BlockPen
		dc.l    0       	; IDCMP
		dc.l    0       	; Flags
		dc.l    0       	; Gadgets
		dc.l    0       	; Checkmark
		dc.l    0       	; Title
		dc.l    0       	; Screen
		dc.l    0       	; BitMap
		dc.w    100     	; MinWidth
		dc.w    100     	; MinHeight
		dc.w    -1      	; MaxWidth
		dc.w    -1      	; MaxHeight
		dc.w    0       	; Type
		dc.l    0       	; Extension
*--------------------------------------
MainWinLeftEdge dc.w    29
MainWinTopEdge  dc.w    0
MainWinWidth    dc.w    582
MainWinHeight   dc.w    194

_MainWinTitle   dc.b "AIDE Main Window",0
		even
*--------------------------------------
_MsgWinTitle    dc.b "AIDE Message Window",0
		even
*--------------------------------------
_InputWinTitle  dc.b "AIDE Input Window",0
		even
*--------------------------------------
_SetupWinTitle  dc.b "AIDE Setup Window",0
		even
*--------------------------------------
* Window- und IDCMPFlags
*-----------------------
MainWinFlags    dc.l    WFLG_DRAGBAR!WFLG_DEPTHGADGET!WFLG_CLOSEGADGET!WFLG_ACTIVATE!WFLG_GIMMEZEROZERO
MainWinIDCMP    dc.l    IDCMP_GADGETDOWN!IDCMP_GADGETUP!IDCMP_MENUPICK!IDCMP_CLOSEWINDOW!IDCMP_REFRESHWINDOW
*--------------------------------------
MsgWinFlags     dc.l    WFLG_RMBTRAP!WFLG_DRAGBAR!WFLG_DEPTHGADGET!WFLG_CLOSEGADGET!WFLG_ACTIVATE!WFLG_GIMMEZEROZERO
MsgWinIDCMP     dc.l    IDCMP_GADGETUP!IDCMP_CLOSEWINDOW
*--------------------------------------
SetupWinFlags   dc.l    WFLG_RMBTRAP!WFLG_DRAGBAR!WFLG_DEPTHGADGET!WFLG_CLOSEGADGET!WFLG_ACTIVATE!WFLG_GIMMEZEROZERO
SetupWinIDCMP   dc.l    IDCMP_GADGETDOWN!IDCMP_GADGETUP!IDCMP_CLOSEWINDOW!IDCMP_REFRESHWINDOW!IDCMP_MOUSEBUTTONS
*--------------------------------------
* IntuiTextStruktur
*------------------
Ausgabe_Ts      INTUITEXT       0,0,1,0,0,0,0,0
*--------------------------------------
* NewGadgetStruktur fuer GadToolGadgets
*-------------------------------------
NewGad  	NEWGADGET       0,0,0,0,0,0,0,0
*--------------------------------------
* TagItems für GadToolGadgets
*----------------------------
EnableTags
		dc.l    GA_Disabled,0
		dc.l    0
DisableTags
		dc.l    GA_Disabled,1
		dc.l    0
BorderTags
		dc.l    GT_VisualInfo,0
		dc.l    0,0     	;fuer GTBB_Recessed
		dc.l    0
MxTags
		dc.l    GTMX_Labels,0
		dc.l    GTMX_Active,0
		dc.l    LAYOUTA_Spacing,0
		dc.l    GA_Disabled,0
		dc.l    0
CycleTags
		dc.l    GTCY_Labels,0
		dc.l    GTCY_Active,0
		dc.l    GA_Disabled,0
		dc.l    0
CheckBoxTags
		dc.l    GTCB_Checked,0
		dc.l    GA_Disabled,0
		dc.l    0
*--------------------------------------
_CompileWinGadList
		dc.l    0

CompileGadText  dc.b    "Stop",0
		even

_CompileWinGadgetPtr
		dc.l    0
		dc.l    0

_CompileWinGadgetTexte
		dc.l    CompileGadText
		dc.l    0
*--------------------------------------
_GadgetPtr_SetupWin
		ds.l    50
*--------------------------------------
StrGad  	STRINGGAD       0,0,0,0,0,0,0,StrGadInfo,0

StrGadInfo      STRINGINFO      Eingabe,Undo,0,0,ExStrGadStr,0

Eingabe 	ds.b    256
Undo    	ds.b    256
*--------------------------------------
Scroller	PROPGAD 	AvailGad01,556,77,6,86,ScrollerBuffer,0,ScrollerInfo,36

ScrollerInfo    PROPGADINFO     $10+13,0,$FFFF

ScrollerBuffer  ds.l    	3
*--------------------------------------
AvailGad01      NEWTOGGLEBOOLGAD	AvailGad02,388,076,160,8,0,37
AvailGad02      NEWTOGGLEBOOLGAD	AvailGad03,388,084,160,8,0,38
AvailGad03      NEWTOGGLEBOOLGAD	AvailGad04,388,092,160,8,0,39
AvailGad04      NEWTOGGLEBOOLGAD	AvailGad05,388,100,160,8,0,40
AvailGad05      NEWTOGGLEBOOLGAD	AvailGad06,388,108,160,8,0,41
AvailGad06      NEWTOGGLEBOOLGAD	AvailGad07,388,116,160,8,0,42
AvailGad07      NEWTOGGLEBOOLGAD	AvailGad08,388,124,160,8,0,43
AvailGad08      NEWTOGGLEBOOLGAD	AvailGad09,388,132,160,8,0,44
AvailGad09      NEWTOGGLEBOOLGAD	AvailGad10,388,140,160,8,0,45
AvailGad10      NEWTOGGLEBOOLGAD	AvailGad11,388,148,160,8,0,46
AvailGad11      NEWTOGGLEBOOLGAD		 0,388,156,160,8,0,47
*--------------------------------------
SetupStrGad01   	STRINGGAD       SetupStrGad02,014,028,132,08,$600,3,SetupStrGadInfo01,22
SetupStrGad02   	STRINGGAD       SetupStrGad03,014,055,132,08,$600,3,SetupStrGadInfo02,23
SetupStrGad03   	STRINGGAD       SetupStrGad04,014,082,132,08,$600,3,SetupStrGadInfo03,24
SetupStrGad04   	STRINGGAD       SetupStrGad05,014,109,132,08,$600,3,SetupStrGadInfo04,25
SetupStrGad05   	STRINGGAD       SetupStrGad06,014,136,132,08,$600,3,SetupStrGadInfo05,26
SetupStrGad06   	STRINGGAD       SetupStrGad07,014,163,132,08,$600,3,SetupStrGadInfo06,27

SetupStrGad07   	STRINGGAD       SetupStrGad08,178,028,132,08,$600,3,SetupStrGadInfo07,28
SetupStrGad08   	STRINGGAD       SetupStrGad09,178,055,132,08,$600,3,SetupStrGadInfo08,29
SetupStrGad09   	STRINGGAD       SetupStrGad10,178,082,132,08,$600,3,SetupStrGadInfo09,30
SetupStrGad10   	STRINGGAD       SetupStrGad11,178,109,132,08,$600,3,SetupStrGadInfo10,31
SetupStrGad11   	STRINGGAD       SetupStrGad12,178,136,132,08,$600,3,SetupStrGadInfo11,32
SetupStrGad12   	STRINGGAD       SetupStrGad13,178,163,132,08,$600,3,SetupStrGadInfo12,33

SetupStrGad13   	STRINGGAD       SetupStrGad14,342,028,132,08,$600,3,SetupStrGadInfo13,34
SetupStrGad14   	STRINGGAD       SetupStrGad15,342,055,132,08,$600,3,SetupStrGadInfo14,35
SetupStrGad15   	STRINGGAD       SetupStrGad16,342,082,132,08,$600,3,SetupStrGadInfo15,36
SetupStrGad16   	STRINGGAD       SetupStrGad17,342,109,132,08,$600,3,SetupStrGadInfo16,37
SetupStrGad17   	STRINGGAD       SetupStrGad18,342,136,132,08,$600,3,SetupStrGadInfo17,38
SetupStrGad18   	STRINGGAD       	    0,342,163,132,08,$600,3,SetupStrGadInfo18,29

SetupStrGadInfo01       STRINGINFO      SetupStrGadPuffer01,SetupUndoPuffer01,79,0,ExStrGadStr,0
SetupStrGadInfo02       STRINGINFO      SetupStrGadPuffer02,SetupUndoPuffer02,79,0,ExStrGadStr,0
SetupStrGadInfo03       STRINGINFO      SetupStrGadPuffer03,SetupUndoPuffer03,79,0,ExStrGadStr,0
SetupStrGadInfo04       STRINGINFO      SetupStrGadPuffer04,SetupUndoPuffer04,79,0,ExStrGadStr,0
SetupStrGadInfo05       STRINGINFO      SetupStrGadPuffer05,SetupUndoPuffer05,79,0,ExStrGadStr,0
SetupStrGadInfo06       STRINGINFO      SetupStrGadPuffer06,SetupUndoPuffer06,79,0,ExStrGadStr,0
SetupStrGadInfo07       STRINGINFO      SetupStrGadPuffer07,SetupUndoPuffer07,79,0,ExStrGadStr,0
SetupStrGadInfo08       STRINGINFO      SetupStrGadPuffer08,SetupUndoPuffer08,79,0,ExStrGadStr,0
SetupStrGadInfo09       STRINGINFO      SetupStrGadPuffer09,SetupUndoPuffer09,79,0,ExStrGadStr,0
SetupStrGadInfo10       STRINGINFO      SetupStrGadPuffer10,SetupUndoPuffer10,79,0,ExStrGadStr,0
SetupStrGadInfo11       STRINGINFO      SetupStrGadPuffer11,SetupUndoPuffer11,79,0,ExStrGadStr,0
SetupStrGadInfo12       STRINGINFO      SetupStrGadPuffer12,SetupUndoPuffer12,79,0,ExStrGadStr,0
SetupStrGadInfo13       STRINGINFO      SetupStrGadPuffer13,SetupUndoPuffer13,79,0,ExStrGadStr,0
SetupStrGadInfo14       STRINGINFO      SetupStrGadPuffer14,SetupUndoPuffer14,79,0,ExStrGadStr,0
SetupStrGadInfo15       STRINGINFO      SetupStrGadPuffer15,SetupUndoPuffer15,79,0,ExStrGadStr,0
SetupStrGadInfo16       STRINGINFO      SetupStrGadPuffer16,SetupUndoPuffer16,79,0,ExStrGadStr,0
SetupStrGadInfo17       STRINGINFO      SetupStrGadPuffer17,SetupUndoPuffer17,79,0,ExStrGadStr,0
SetupStrGadInfo18       STRINGINFO      SetupStrGadPuffer18,SetupUndoPuffer18,79,0,ExStrGadStr,0

SetupStrGadPuffer01     ds.b    82
SetupStrGadPuffer02     ds.b    82
SetupStrGadPuffer03     ds.b    82
SetupStrGadPuffer04     ds.b    82
SetupStrGadPuffer05     ds.b    82
SetupStrGadPuffer06     ds.b    82
SetupStrGadPuffer07     ds.b    82
SetupStrGadPuffer08     ds.b    82
SetupStrGadPuffer09     ds.b    82
SetupStrGadPuffer10     ds.b    82
SetupStrGadPuffer11     ds.b    82
SetupStrGadPuffer12     ds.b    82
SetupStrGadPuffer13     ds.b    82
SetupStrGadPuffer14     ds.b    82
SetupStrGadPuffer15     ds.b    82
SetupStrGadPuffer16     ds.b    82
SetupStrGadPuffer17     ds.b    82
SetupStrGadPuffer18     ds.b    82

SetupUndoPuffer01       ds.b    82
SetupUndoPuffer02       ds.b    82
SetupUndoPuffer03       ds.b    82
SetupUndoPuffer04       ds.b    82
SetupUndoPuffer05       ds.b    82
SetupUndoPuffer06       ds.b    82
SetupUndoPuffer07       ds.b    82
SetupUndoPuffer08       ds.b    82
SetupUndoPuffer09       ds.b    82
SetupUndoPuffer10       ds.b    82
SetupUndoPuffer11       ds.b    82
SetupUndoPuffer12       ds.b    82
SetupUndoPuffer13       ds.b    82
SetupUndoPuffer14       ds.b    82
SetupUndoPuffer15       ds.b    82
SetupUndoPuffer16       ds.b    82
SetupUndoPuffer17       ds.b    82
SetupUndoPuffer18       ds.b    82

*--------------------------------------
* STRUCTURE StringExtend,0
*    ; display specifications
*    APTR	sex_Font	; must be an open Font (not TextAttr)
*    STRUCT	sex_Pens,2	; color of text/background
*    STRUCT	sex_ActivePens,2 ; colors when gadget is active
*
*    ; edit specifications
*    ULONG	sex_InitialModes ; initial mode flags, below
*    APTR	sex_EditHook	; if non-NULL, must supply WorkBuffer
*    APTR	sex_WorkBuffer	; must be as large as StringInfo.Buffer
*
*    STRUCT	sex_Reserved,16	; set to 0
* LABEL	sex_SIZEOF
*--------------------------------------

ExStrGadStr

	dc.l	0
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	2
	ds.l	16

*--------------------------------------
