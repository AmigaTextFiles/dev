	IFND	MCC_HTMLVIEW_I
MCC_HTMLVIEW_I	SET	1

**	Assembler version by Ilkka Lehtoranta (1 Dec 1999)

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC

;#define MUIC_HTMLview   "HTMLview.mcc"
;#define HTMLviewObject  MUI_NewObject(MUIC_HTMLview

HTMLview_ID	EQU	$ad003000

MUIM_HTMLview_ExtMessage		EQU	HTMLview_ID+1	; Private
MUIM_HTMLview_GotoURL			EQU	HTMLview_ID+2
MUIM_HTMLview_Period			EQU	HTMLview_ID+3	; Private
MUIA_HTMLview_Title			EQU	HTMLview_ID+4
MUIA_HTMLview_Contents			EQU	HTMLview_ID+5
MUIA_HTMLview_CurrentURL		EQU	HTMLview_ID+7
MUIM_HTMLview_LoadImages		EQU	HTMLview_ID+8	; Private
MUIM_HTMLview_AddPart			EQU	HTMLview_ID+10	; Private
MUIM_HTMLview_DrawImages		EQU	HTMLview_ID+11	; Private
MUIA_HTMLview_LoadHook			EQU	HTMLview_ID+12
MUIM_HTMLview_Abort			EQU	HTMLview_ID+13
MUIM_HTMLview_VLink			EQU	HTMLview_ID+14
MUIA_HTMLview_ClickedURL		EQU	HTMLview_ID+15
MUIM_HTMLview_Parsed			EQU	HTMLview_ID+16
MUIM_HTMLview_PrivateGotoURL		EQU	HTMLview_ID+18	; Private
MUIM_HTMLview_AbortAll			EQU	HTMLview_ID+19	; Private
MUIM_HTMLview_LookupFrame		EQU	HTMLview_ID+20	; Private
MUIA_HTMLview_Target			EQU	HTMLview_ID+21
MUIA_HTMLview_FrameName			EQU	HTMLview_ID+22	; Private
MUIA_HTMLview_MarginWidth		EQU	HTMLview_ID+23	; Private
MUIA_HTMLview_MarginHeight		EQU	HTMLview_ID+24	; Private
MUIM_HTMLview_Reload			EQU	HTMLview_ID+25
MUIM_HTMLview_StartParser		EQU	HTMLview_ID+26	; Private
MUIM_HTMLview_HandleEvent		EQU	HTMLview_ID+27	; Private
MUIM_HTMLview_RemoveChildren		EQU	HTMLview_ID+28	; Private
MUIA_HTMLview_IPC			EQU	HTMLview_ID+29
MUIA_HTMLview_DiscreteInput		EQU	HTMLview_ID+30
MUIM_HTMLview_Search			EQU	HTMLview_ID+31
MUIA_HTMLview_IntuiTicks		EQU	HTMLview_ID+32	; Private
MUIA_HTMLview_Prop_HDeltaFactor		EQU	HTMLview_ID+33
MUIA_HTMLview_Prop_VDeltaFactor		EQU	HTMLview_ID+34
MUIA_HTMLview_Scrollbars		EQU	HTMLview_ID+35
MUIM_HTMLview_StartRefreshTimer		EQU	HTMLview_ID+36	; Private
MUIM_HTMLview_Refresh			EQU	HTMLview_ID+38	; Private
MUIM_HTMLview_GetContextInfo		EQU	HTMLview_ID+39
MUIM_HTMLview_HitTest			EQU	HTMLview_ID+40	; Private
MUIA_HTMLview_URL			EQU	HTMLview_ID+41
MUIA_HTMLview_Qualifier			EQU	HTMLview_ID+42
MUIA_HTMLview_ImageLoadHook		EQU	HTMLview_ID+44
MUIM_HTMLview_AnimTick			EQU	HTMLview_ID+45	; Private
MUIM_HTMLview_AddSingleAnim		EQU	HTMLview_ID+48	; Private
MUIA_HTMLview_ImagesInDecodeQueue	EQU	HTMLview_ID+49
MUIM_HTMLview_FlushImage		EQU	HTMLview_ID+50
MUIA_HTMLview_SharedData		EQU	HTMLview_ID+51	; Private
MUIM_HTMLview_ServerRequest		EQU	HTMLview_ID+52	; Private
MUIA_HTMLview_PageID			EQU	HTMLview_ID+53
MUIM_HTMLview_PauseAnims		EQU	HTMLview_ID+54	; Sort of private, called
MUIM_HTMLview_ContinueAnims		EQU	HTMLview_ID+55	; for MUIA_Window_Activate
MUIM_HTMLview_Post			EQU	HTMLview_ID+56	; Private, or...?
MUIA_HTMLview_InstanceData		EQU	HTMLview_ID+57	; Very very private ;-)

MUIV_HTMLview_Scrollbars_Auto		EQU	0
MUIV_HTMLview_Scrollbars_Yes		EQU	1
MUIV_HTMLview_Scrollbars_No		EQU	2
MUIV_HTMLview_Scrollbars_HorizAuto	EQU	3

MUIA_ScrollGroup_HTMLview		EQU	$ad003100

* Structures *

	ENDASM
struct MUIP_HTMLview_FlushImage
{
	ULONG MethodID;
	STRPTR URL;
};
	ASM

MUIV_HTMLview_FlushImage_All		EQU	0
MUIV_HTMLview_FlushImage_Displayed	EQU	1
MUIV_HTMLview_FlushImage_Nondisplayed	EQU	2

	ENDASM
struct MUIP_HTMLview_GetContextInfo
{
	ULONG MethodID;
	LONG X, Y;
};

struct MUIR_HTMLview_GetContextInfo
{
	STRPTR URL, Target, Img, Frame, Background;
	Object *FrameObj;
	ULONG ImageWidth, ImageHeight, ImageSize, ImageOffsetX, ImageOffsetY;
	STRPTR ImageAltText;
};

struct MUIP_HTMLview_GotoURL
{
	ULONG MethodID;
	STRPTR URL, Target;
};

struct MUIP_HTMLview_AddPart
{
	ULONG MethodID;
	STRPTR File;
};

struct MUIP_HTMLview_VLink
{
	ULONG MethodID;
	STRPTR URL;
};

struct MUIP_HTMLview_Parsed
{
	ULONG MethodID;
	ULONG Parsed;
};

struct MUIP_HTMLview_Search
{
	ULONG MethodID;
#ifdef String
	STRPTR SearchString;
#else
	STRPTR String;
#endif
	ULONG Flags;
};
	ASM

MUIF_HTMLview_Search_CaseSensitive	EQU	(1 << 0)
MUIF_HTMLview_Search_DOSPattern		EQU	(1 << 1)
MUIF_HTMLview_Search_Backwards		EQU	(1 << 2)
MUIF_HTMLview_Search_FromTop		EQU	(1 << 3)
MUIF_HTMLview_Search_Next		EQU	(1 << 4)

	STRUCTURE HTMLview_LoadMsg,0
	LONG	lm_Type
	LABEL	lm_Buffer	; Read, Write
	APTR	lm_URL		; Open
	LABEL	lm_Size		; Read, Write
	ULONG	lm_Flags	; Open
	ULONG	lm_PageID
	APTR	lm_Userdata
	APTR	lm_App
	ULONG	lm_PostLength
	APTR	lm_EncodingType

lm_Open		EQU	lm_Buffer
lm_Read		EQU	lm_Buffer
lm_Write	EQU	lm_Buffer
lm_Close	EQU	lm_Buffer


MUIF_HTMLview_LoadMsg_Reload		EQU	(1 << 0)
MUIF_HTMLview_LoadMsg_Document		EQU	(1 << 1)
MUIF_HTMLview_LoadMsg_Image		EQU	(1 << 2)
MUIF_HTMLview_LoadMsg_Post		EQU	(1 << 3)
MUIF_HTMLview_LoadMsg_Script		EQU	(1 << 4)
MUIF_HTMLview_LoadMsg_Stylesheet	EQU	(1 << 5)
MUIF_HTMLview_LoadMsg_MainObject	EQU	(1 << 6)

HTMLview_Open	EQU	0
HTMLview_Read	EQU	1
HTMLview_Close	EQU	2
HTMLview_Write	EQU	3

	ENDC	; HTMLVIEW_MCC_I
