	IFND DPKERNEL_PREFS_I
DPKERNEL_PREFS_I SET  1

**
**  $VER: prefs.i V2.0
**
**  GMS Preferences
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND	DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

****************************************************************************
* Screen Preferences

OCS = 0
ECS = 1
AGA = 2

GB_NONE       = 0  ;Different graphics boards.
GB_PICCOLO    = 1
GB_CYBERVIS64 = 2
GB_SPECTRUM   = 3
GB_PICASSO    = 4
GB_RETINA     = 5
GB_MERLIN     = 6
GB_HARLEQUIN  = 7
GB_OPALVISION = 8

SCR_PAL     = 0    ;Type of mode promotion.
SCR_NTSC    = 1
SCR_DBLPAL  = 2
SCR_DBLNTSC = 3
SCR_VGA     = 4

TO_WINDOW   = 0    ;Screen switching method.
TO_SCREEN   = 1

    STRUCTURE	ScreenPrefs,0
	LONG	SPF_VERSION        ;"SCR1"
	WORD	SPF_ChipSet        ;OCS/ECS/AGA
	WORD	SPF_ModePromote    ;None/NTSC/PAL/DBLNTSC/DBLPAL/VGA
	WORD	SPF_GfxBoard       ;Gfx board setting.
	WORD	SPF_TopOfScrX      ;Top corner of screen, X.
	WORD	SPF_TopOfScrY      ;Top corner of screen, Y.
	WORD	SPF_ScrSwitch      ;Screen Switch to window or screen.
	WORD	SPF_ScrWidth       ;The width of the visible screen.
	WORD	SPF_ScrHeight      ;The height of the visible screen.
	WORD	SPF_Planes         ;The amount of planes in the screen.
	LONG	SPF_Attrib         ;Special Attributes...
	WORD	SPF_ScrMode        ;Screen mode...
	WORD	SPF_ScrType        ;ILBM/Planar/Chunky?
	APTR	SPF_C2PFile        ;C2P file.
	APTR	SPF_Palette        ;Pointer to 24 bit palette.
	WORD	SPF_OwnBlitter     ;0 = FALSE, 1 = TRUE

****************************************************************************
* Master Preferences

   STRUCTURE	MasterPrefs,0
	LONG	GEN_VERSION        ;"GEN1"
	APTR	GEN_JoyKeys        ;Pointer to emulation keys.
	WORD	GEN_JoyType1       ;Type of Joystick in port 1.
	WORD	GEN_JoyType2       ;Type of Joystick in port 2.
	WORD	GEN_JoyType3       ;Type of Joystick in port 3.
	WORD	GEN_JoyType4       ;Type of Joystick in port 4.
	WORD	GEN_Language       ;Language
	WORD	GEN_UserPri        ;User priority
	WORD	GEN_Tracking       ;Resource tracking on/off.
	LONG	GEN_XPK            ;XPK cruncher name.
	WORD	GEN_ButtonTime
	WORD	GEN_MoveTime
	;Struct JoyKeys Keys[4]
	;Extra data here...

   STRUCTURE	JoyKeys,0
	BYTE	JK_Left
	BYTE	JK_Right
	BYTE	JK_Up
	BYTE	JK_Down
	BYTE	JK_Fire1
	BYTE	JK_Fire2
	BYTE	JK_Fire3
	BYTE	JK_Fire4
	BYTE	JK_Fire5
	BYTE	JK_Fire6
	BYTE	JK_Fire7
	BYTE	JK_Fire8
	BYTE	JK_ZIn
	BYTE	JK_ZOut
	WORD	JK_QualMask        ;Qualifier Mask.
	LABEL	JK_SIZEOF

	ENDC	;DPKERNEL_PREFS_I
