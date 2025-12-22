	IFND	MUI_NLIST_MCC_I
MUI_NLIST_MCC_I	SET	1

*  NList.mcc (c) Copyright 1996-1997 by Gilles Masson
*  Registered MUI class, Serial Num: 1d51     0x9d510030 to 0x9d51009F / 0x9d5100C0 to 0x9d5100FF
*  *** use only YOUR OWN Serial Number for your public custom class ***
*  NList_mcc.h
*
*  Assembler version by Ilkka Lehtoranta (29-Nov-99)

* MUI Prop and Scroller classes stuff which is still not in libraries/mui.h  (in MUI3.8)
* it gives to the prop object it's increment value
	IFND	MUIA_Prop_DeltaFactor
MUIA_Prop_DeltaFactor	EQU	$80427C5E
	ENDC

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

;#define MUIC_NList "NList.mcc"
;#define NListObject MUI_NewObject(MUIC_NList


* Attributes *

MUIA_NList_TypeSelect		EQU	$9d510030 ; GM  is.  LONG
MUIA_NList_Prop_DeltaFactor	EQU	$9d510031 ; GM  ..gn LONG
MUIA_NList_Horiz_DeltaFactor	EQU	$9d510032 ; GM  ..gn LONG

MUIA_NList_Horiz_First		EQU	$9d510033 ; GM  .sgn LONG
MUIA_NList_Horiz_Visible	EQU	$9d510034 ; GM  ..gn LONG
MUIA_NList_Horiz_Entries	EQU	$9d510035 ; GM  ..gn LONG

MUIA_NList_Prop_First		EQU	$9d510036 ; GM  .sgn LONG
MUIA_NList_Prop_Visible		EQU	$9d510037 ; GM  ..gn LONG
MUIA_NList_Prop_Entries		EQU	$9d510038 ; GM  ..gn LONG

MUIA_NList_TitlePen		EQU	$9d510039 ; GM  isg  LONG
MUIA_NList_ListPen		EQU	$9d51003a ; GM  isg  LONG
MUIA_NList_SelectPen		EQU	$9d51003b ; GM  isg  LONG
MUIA_NList_CursorPen		EQU	$9d51003c ; GM  isg  LONG
MUIA_NList_UnselCurPen		EQU	$9d51003d ; GM  isg  LONG

MUIA_NList_ListBackground	EQU	$9d51003e ; GM  isg  LONG
MUIA_NList_TitleBackground	EQU	$9d51003f ; GM  isg  LONG
MUIA_NList_SelectBackground	EQU	$9d510040 ; GM  isg  LONG
MUIA_NList_CursorBackground	EQU	$9d510041 ; GM  isg  LONG
MUIA_NList_UnselCurBackground	EQU	$9d510042 ; GM  isg  LONG

MUIA_NList_MultiClick		EQU	$9d510043 ; GM  ..gn LONG

MUIA_NList_DefaultObjectOnClick	EQU	$9d510044 ; GM  is.  BOOL

MUIA_NList_ClickColumn		EQU	$9d510045 ; GM  ..g  LONG
MUIA_NList_DefClickColumn	EQU	$9d510046 ; GM  isg  LONG
MUIA_NList_DoubleClick		EQU	$9d510047 ; GM  ..gn LONG
MUIA_NList_DragType		EQU	$9d510048 ; GM  isg  LONG
MUIA_NList_Input		EQU	$9d510049 ; GM  isg  BOOL
MUIA_NList_MultiSelect		EQU	$9d51004a ; GM  is.  LONG
MUIA_NList_SelectChange		EQU	$9d51004b ; GM  ...n BOOL

MUIA_NList_Active		EQU	$9d51004c ; GM  isgn LONG
MUIA_NList_AdjustHeight		EQU	$9d51004d ; GM  i..  BOOL
MUIA_NList_AdjustWidth		EQU	$9d51004e ; GM  i..  BOOL
MUIA_NList_AutoVisible		EQU	$9d51004f ; GM  isg  BOOL
MUIA_NList_CompareHook		EQU	$9d510050 ; GM  is.  struct Hook *
MUIA_NList_ConstructHook	EQU	$9d510051 ; GM  is.  struct Hook *
MUIA_NList_DestructHook		EQU	$9d510052 ; GM  is.  struct Hook *
MUIA_NList_DisplayHook		EQU	$9d510053 ; GM  is.  struct Hook *
MUIA_NList_DragSortable		EQU	$9d510054 ; GM  isg  BOOL
MUIA_NList_DropMark		EQU	$9d510055 ; GM  ..g  LONG
MUIA_NList_Entries		EQU	$9d510056 ; GM  ..gn LONG
MUIA_NList_First		EQU	$9d510057 ; GM  isgn LONG
MUIA_NList_Format		EQU	$9d510058 ; GM  isg  STRPTR
MUIA_NList_InsertPosition	EQU	$9d510059 ; GM  ..gn LONG
MUIA_NList_MinLineHeight	EQU	$9d51005a ; GM  is.  LONG
MUIA_NList_MultiTestHook	EQU	$9d51005b ; GM  is.  struct Hook *
MUIA_NList_Pool			EQU	$9d51005c ; GM  i..  APTR
MUIA_NList_PoolPuddleSize	EQU	$9d51005d ; GM  i..  ULONG
MUIA_NList_PoolThreshSize	EQU	$9d51005e ; GM  i..  ULONG
MUIA_NList_Quiet		EQU	$9d51005f ; GM  .s.  BOOL
MUIA_NList_ShowDropMarks	EQU	$9d510060 ; GM  isg  BOOL
MUIA_NList_SourceArray		EQU	$9d510061 ; GM  i..  APTR *
MUIA_NList_Title		EQU	$9d510062 ; GM  isg  char *
MUIA_NList_Visible		EQU	$9d510063 ; GM  ..g  LONG
MUIA_NList_CopyEntryToClipHook	EQU	$9d510064 ; GM  is.  struct Hook *
MUIA_NList_KeepActive		EQU	$9d510065 ; GM  .s.  Obj *
MUIA_NList_MakeActive		EQU	$9d510066 ; GM  .s.  Obj *
MUIA_NList_SourceString		EQU	$9d510067 ; GM  i..  char *
MUIA_NList_CopyColumnToClipHook	EQU	$9d510068 ; GM  is.  struct Hook *
MUIA_NList_ListCompatibility	EQU	$9d510069 ; GM  ...  OBSOLETE
MUIA_NList_AutoCopyToClip	EQU	$9d51006A ; GM  is.  BOOL
MUIA_NList_TabSize		EQU	$9d51006B ; GM  isg  ULONG
MUIA_NList_SkipChars		EQU	$9d51006C ; GM  isg  char *
MUIA_NList_DisplayRecall	EQU	$9d51006D ; GM  .g.  BOOL
MUIA_NList_PrivateData		EQU	$9d51006E ; GM  isg  APTR
MUIA_NList_EntryValueDependent	EQU	$9d51006F ; GM  isg  BOOL

MUIA_NList_StackCheck		EQU	$9d510097 ; GM  i..  BOOL
MUIA_NList_WordSelectChars	EQU	$9d510098 ; GM  isg  char *
MUIA_NList_EntryClick		EQU	$9d510099 ; GM  ..gn LONG
MUIA_NList_DragColOnly		EQU	$9d51009A ; GM  isg  LONG
MUIA_NList_TitleClick		EQU	$9d51009B ; GM  isgn LONG
MUIA_NList_DropType		EQU	$9d51009C ; GM  ..g  LONG
MUIA_NList_ForcePen		EQU	$9d51009D ; GM  isg  LONG
MUIA_NList_SourceInsert		EQU	$9d51009E ; GM  i..  struct MUIP_NList_InsertWrap *
MUIA_NList_TitleSeparator	EQU	$9d51009F ; GM  isg  BOOL

MUIA_NList_SortType2		EQU	$9d5100ED ; GM  isgn LONG
MUIA_NList_TitleClick2		EQU	$9d5100EE ; GM  isgn LONG
MUIA_NList_TitleMark2		EQU	$9d5100EF ; GM  isg  LONG
MUIA_NList_MultiClickAlone	EQU	$9d5100F0 ; GM  ..gn LONG
MUIA_NList_TitleMark		EQU	$9d5100F1 ; GM  isg  LONG
MUIA_NList_DragSortInsert	EQU	$9d5100F2 ; GM  ..gn LONG
MUIA_NList_MinColSortable	EQU	$9d5100F3 ; GM  isg  LONG
MUIA_NList_Imports		EQU	$9d5100F4 ; GM  isg  LONG
MUIA_NList_Exports		EQU     $9d5100F5 ; GM  isg  LONG
MUIA_NList_Columns		EQU	$9d5100F6 ; GM  isgn BYTE *
MUIA_NList_LineHeight		EQU	$9d5100F7 ; GM  ..gn LONG
MUIA_NList_ButtonClick		EQU	$9d5100F8 ; GM  ..gn LONG
MUIA_NList_CopyEntryToClipHook2	EQU	$9d5100F9 ; GM  is.  struct Hook *
MUIA_NList_CopyColumnToClipHook2	EQU	$9d5100FA ; GM  is.  struct Hook *
MUIA_NList_CompareHook2		EQU	$9d5100FB ; GM  is.  struct Hook *
MUIA_NList_ConstructHook2	EQU	$9d5100FC ; GM  is.  struct Hook *
MUIA_NList_DestructHook2	EQU	$9d5100FD ; GM  is.  struct Hook *
MUIA_NList_DisplayHook2		EQU	$9d5100FE ; GM  is.  struct Hook *
MUIA_NList_SortType		EQU	$9d5100FF ; GM  isgn LONG


MUIA_NLIMG_EntryCurrent		EQU	MUIA_NList_First   ; LONG (special for nlist custom image object)
MUIA_NLIMG_EntryHeight		EQU	MUIA_NList_Visible ; LONG (special for nlist custom image object)

MUIA_NList_VertDeltaFactor	EQU	MUIA_NList_Prop_DeltaFactor   ; OBSOLETE NAME
MUIA_NList_HorizDeltaFactor	EQU	MUIA_NList_Horiz_DeltaFactor  ; OBSOLETE NAME


* Attributes special datas *

MUIV_NList_TypeSelect_Line	EQU	0
MUIV_NList_TypeSelect_Char	EQU	1

MUIV_NList_Font			EQU	-20
MUIV_NList_Font_Little		EQU	-21
MUIV_NList_Font_Fixed		EQU	-22

MUIV_NList_ConstructHook_String	EQU	-1
MUIV_NList_DestructHook_String	EQU	-1

MUIV_NList_Active_Off		EQU     -1
MUIV_NList_Active_Top		EQU	-2
MUIV_NList_Active_Bottom	EQU	-3
MUIV_NList_Active_Up		EQU	-4
MUIV_NList_Active_Down		EQU	-5
MUIV_NList_Active_PageUp	EQU	-6
MUIV_NList_Active_PageDown	EQU	-7

MUIV_NList_First_Top		EQU	-2
MUIV_NList_First_Bottom		EQU	-3
MUIV_NList_First_Up		EQU	-4
MUIV_NList_First_Down		EQU	-5
MUIV_NList_First_PageUp		EQU	-6
MUIV_NList_First_PageDown	EQU	-7
MUIV_NList_First_Up2		EQU	-8
MUIV_NList_First_Down2		EQU	-9
MUIV_NList_First_Up4		EQU	-10
MUIV_NList_First_Down4		EQU	-11

MUIV_NList_Horiz_First_Start	EQU	-2
MUIV_NList_Horiz_First_End	EQU	-3
MUIV_NList_Horiz_First_Left	EQU	-4
MUIV_NList_Horiz_First_Right	EQU	-5
MUIV_NList_Horiz_First_PageLeft	EQU	-6
MUIV_NList_Horiz_First_PageRight	EQU	-7
MUIV_NList_Horiz_First_Left2	EQU	-8
MUIV_NList_Horiz_First_Right2	EQU	-9
MUIV_NList_Horiz_First_Left4	EQU	-10
MUIV_NList_Horiz_First_Right4	EQU	-11

MUIV_NList_MultiSelect_None	EQU	0
MUIV_NList_MultiSelect_Default	EQU	1
MUIV_NList_MultiSelect_Shifted	EQU	2
MUIV_NList_MultiSelect_Always	EQU	3

MUIV_NList_Insert_Top		EQU	0
MUIV_NList_Insert_Active	EQU	-1
MUIV_NList_Insert_Sorted	EQU	-2
MUIV_NList_Insert_Bottom	EQU	-3

MUIV_NList_Remove_First		EQU	0
MUIV_NList_Remove_Active	EQU	-1
MUIV_NList_Remove_Last		EQU	-2
MUIV_NList_Remove_Selected	EQU	-3

MUIV_NList_Select_Off		EQU	0
MUIV_NList_Select_On		EQU	1
MUIV_NList_Select_Toggle	EQU     2
MUIV_NList_Select_Ask		EQU	3

MUIV_NList_GetEntry_Active	EQU	-1
MUIV_NList_GetEntryInfo_Line	EQU	-2

MUIV_NList_Select_Active	EQU	-1
MUIV_NList_Select_All		EQU	-2

MUIV_NList_Redraw_Active	EQU	-1
MUIV_NList_Redraw_All		EQU	-2
MUIV_NList_Redraw_Title		EQU	-3

MUIV_NList_Move_Top		EQU	0
MUIV_NList_Move_Active		EQU	-1
MUIV_NList_Move_Bottom		EQU	-2
MUIV_NList_Move_Next		EQU	-3 ; only valid for second parameter (and not with Move_Selected)
MUIV_NList_Move_Previous	EQU	-4 ; only valid for second parameter (and not with Move_Selected)
MUIV_NList_Move_Selected	EQU	-5 ; only valid for first parameter

MUIV_NList_Exchange_Top		EQU	0
MUIV_NList_Exchange_Active	EQU	-1
MUIV_NList_Exchange_Bottom	EQU	-2
MUIV_NList_Exchange_Next	EQU	-3 ; only valid for second parameter
MUIV_NList_Exchange_Previous	EQU	-4 ; only valid for second parameter

MUIV_NList_Jump_Top		EQU	0
MUIV_NList_Jump_Active		EQU	-1
MUIV_NList_Jump_Bottom		EQU	-2
MUIV_NList_Jump_Up		EQU	-4
MUIV_NList_Jump_Down		EQU	-3

MUIV_NList_NextSelected_Start	EQU	-1
MUIV_NList_NextSelected_End	EQU	-1

MUIV_NList_PrevSelected_Start	EQU	-1
MUIV_NList_PrevSelected_End	EQU	-1

MUIV_NList_DragType_None	EQU	0
MUIV_NList_DragType_Default	EQU	1
MUIV_NList_DragType_Immediate	EQU	2
MUIV_NList_DragType_Borders	EQU	3
MUIV_NList_DragType_Qualifier	EQU	4

MUIV_NList_CopyToClip_Active	EQU	-1
MUIV_NList_CopyToClip_Selected	EQU	-2
MUIV_NList_CopyToClip_All	EQU	-3
MUIV_NList_CopyToClip_Entries	EQU	-4
MUIV_NList_CopyToClip_Entry	EQU	-5
MUIV_NList_CopyToClip_Strings	EQU	-6
MUIV_NList_CopyToClip_String	EQU	-7

MUIV_NList_CopyTo_Active	EQU	-1
MUIV_NList_CopyTo_Selected	EQU	-2
MUIV_NList_CopyTo_All		EQU	-3
MUIV_NList_CopyTo_Entries	EQU	-4
MUIV_NList_CopyTo_Entry		EQU	-5

MUIV_NLCT_Success		EQU	0
MUIV_NLCT_OpenErr		EQU	1
MUIV_NLCT_WriteErr		EQU	2
MUIV_NLCT_Failed		EQU	3

MUIV_NList_ForcePen_On		EQU	1
MUIV_NList_ForcePen_Off		EQU	0
MUIV_NList_ForcePen_Default	EQU	-1

MUIV_NList_DropType_Mask	EQU	$00FF
MUIV_NList_DropType_None	EQU	0
MUIV_NList_DropType_Above	EQU	1
MUIV_NList_DropType_Below	EQU	2
MUIV_NList_DropType_Onto	EQU	3

MUIV_NList_DoMethod_Active	EQU	-1
MUIV_NList_DoMethod_Selected	EQU	-2
MUIV_NList_DoMethod_All		EQU	-3

MUIV_NList_DoMethod_Entry	EQU	-1
MUIV_NList_DoMethod_Self	EQU	-2
MUIV_NList_DoMethod_App		EQU	-3

MUIV_NList_EntryValue		EQU     (MUIV_TriggerValue+$100)
MUIV_NList_EntryPosValue	EQU	(MUIV_TriggerValue+$102)
MUIV_NList_SelfValue		EQU	(MUIV_TriggerValue+$104)
MUIV_NList_AppValue		EQU	(MUIV_TriggerValue+$106)

MUIV_NList_ColWidth_All		EQU	-1
MUIV_NList_ColWidth_Default	EQU	-1
MUIV_NList_ColWidth_Get		EQU	-2

MUIV_NList_ContextMenu_Default	EQU	$9d510031
MUIV_NList_ContextMenu_TopOnly	EQU	$9d510033
MUIV_NList_ContextMenu_BarOnly	EQU	$9d510035
MUIV_NList_ContextMenu_Bar_Top	EQU	$9d510037
MUIV_NList_ContextMenu_Always	EQU	$9d510039
MUIV_NList_ContextMenu_Never	EQU	$9d51003b

MUIV_NList_Menu_DefWidth_This	EQU	$9d51003d
MUIV_NList_Menu_DefWidth_All	EQU	$9d51003f
MUIV_NList_Menu_DefOrder_This	EQU	$9d510041
MUIV_NList_Menu_DefOrder_All	EQU	$9d510043
MUIV_NList_Menu_Default_This	EQU	MUIV_NList_Menu_DefWidth_This
MUIV_NList_Menu_Default_All	EQU	MUIV_NList_Menu_DefWidth_All

MUIV_NList_SortType_None	EQU	$F0000000
MUIV_NList_SortTypeAdd_None	EQU	$00000000
MUIV_NList_SortTypeAdd_2Values	EQU	$80000000
MUIV_NList_SortTypeAdd_4Values	EQU	$40000000
MUIV_NList_SortTypeAdd_Mask	EQU	$C0000000
MUIV_NList_SortTypeValue_Mask	EQU	$3FFFFFFF

MUIV_NList_Sort3_SortType_Both	EQU	$00000000
MUIV_NList_Sort3_SortType_1	EQU	$00000001
MUIV_NList_Sort3_SortType_2	EQU	$00000002

MUIV_NList_Quiet_None		EQU	0
MUIV_NList_Quiet_Full		EQU	-1
MUIV_NList_Quiet_Visual		EQU	-2

MUIV_NList_Imports_Active	EQU	(1 << 0)
MUIV_NList_Imports_Selected	EQU	(1 << 1)
MUIV_NList_Imports_First	EQU	(1 << 2)
MUIV_NList_Imports_ColWidth	EQU	(1 << 3)
MUIV_NList_Imports_ColOrder	EQU	(1 << 4)
MUIV_NList_Imports_TitleMark	EQU	(1 << 7)
MUIV_NList_Imports_Cols		EQU	$000000F8
MUIV_NList_Imports_All		EQU	$0000FFFF

MUIV_NList_Exports_Active	EQU	(1 << 0)
MUIV_NList_Exports_Selected	EQU	(1 << 1)
MUIV_NList_Exports_First	EQU	(1 << 2)
MUIV_NList_Exports_ColWidth	EQU	(1 << 3)
MUIV_NList_Exports_ColOrder	EQU	(1 << 4)
MUIV_NList_Exports_TitleMark	EQU	(1 << 7)
MUIV_NList_Exports_Cols		EQU	$000000F8
MUIV_NList_Exports_All		EQU	$0000FFFF

MUIV_NList_TitleMark_ColMask	EQU	$000000FF
MUIV_NList_TitleMark_TypeMask	EQU	$F0000000
MUIV_NList_TitleMark_None	EQU	$F0000000
MUIV_NList_TitleMark_Down	EQU	$00000000
MUIV_NList_TitleMark_Up		EQU	$80000000
MUIV_NList_TitleMark_Box	EQU	$40000000
MUIV_NList_TitleMark_Circle	EQU	$C0000000

MUIV_NList_TitleMark2_ColMask	EQU	$000000FF
MUIV_NList_TitleMark2_TypeMask	EQU	$F0000000
MUIV_NList_TitleMark2_None	EQU	$F0000000
MUIV_NList_TitleMark2_Down	EQU	$00000000
MUIV_NList_TitleMark2_Up	EQU	$80000000
MUIV_NList_TitleMark2_Box	EQU	$40000000
MUIV_NList_TitleMark2_Circle	EQU	$C0000000

MUIV_NList_SetColumnCol_Default	EQU	-1

MUIV_NList_GetPos_Start	EQU	-1
MUIV_NList_GetPos_End	EQU	-1


* Structs *

	ENDASM
struct BitMapImage
{
  ULONG    control;   ; should be == to MUIM_NList_CreateImage for a valid BitMapImage struct */
  WORD     width;     ; if control == MUIA_Image_Spec then obtainpens is a pointer to an Object */
  WORD     height;
  WORD    *obtainpens;
  PLANEPTR mask;
  struct BitMap imgbmp;
  LONG     flags;
};


struct MUI_NList_TestPos_Result
{
  LONG  entry;   ; number of entry, -1 if mouse not over valid entry */
  WORD  column;  ; numer of column, -1 if no valid column */
  UWORD flags;   ; not in the list, see below */
  WORD  xoffset; ; x offset in column */
  WORD  yoffset; ; y offset of mouse click from center of line */
  WORD  preparse;     ; 2 if in column preparse string, 1 if in entry preparse string, else 0 */
  WORD  char_number;  ; the number of the clicked char in column, -1 if no valid */
  WORD  char_xoffset; ; x offset of mouse clicked from left of char if positive */
};      	      ; and left of next char if negative. If there is no char there */
		      ; negative if from left of first char else from right of last one */
	ASM

MUI_NLPR_ABOVE	EQU     (1<<0)
MUI_NLPR_BELOW	EQU	(1<<1)
MUI_NLPR_LEFT	EQU	(1<<2)
MUI_NLPR_RIGHT	EQU	(1<<3)
MUI_NLPR_BAR	EQU	(1<<4)  ; if between two columns you'll get the left
			; column number of both, and that flag
MUI_NLPR_TITLE	EQU	(1<<5)  ; if clicked on title, only column, xoffset and yoffset (and MUI_NLPR_BAR)
			;are valid (you'll get MUI_NLPR_ABOVE too)
MUI_NLPR_ONTOP	EQU	(1<<6)  ; it is on title/half of first visible entry


	ENDASM
struct MUI_NList_GetEntryInfo
{
  LONG pos;     	; num of entry you want info about */
  LONG line;    	; real line number */
  LONG entry_pos;       ; entry num of returned entry ptr */
  APTR entry;   	; entry pointer */
  LONG wrapcol; 	; NOWRAP, WRAPCOLx, or WRAPPED|WRAPCOLx */
  LONG charpos; 	; start char number in string (unused if NOWRAP) */
  LONG charlen; 	; string lenght (unused if NOWRAP) */
};
	ASM

NOWRAP		EQU	$00
WRAPCOL0	EQU	$01
WRAPCOL1	EQU	$02
WRAPCOL2	EQU	$04
WRAPCOL3	EQU	$08
WRAPCOL4	EQU	$10
WRAPCOL5	EQU	$20
WRAPCOL6	EQU	$40
WRAPPED		EQU	$80

	ENDASM
struct MUI_NList_GetSelectInfo
{
  LONG start;        ; num of first selected *REAL* entry/line (first of wrapped from which start is issued) */
  LONG end;          ; num of last selected *REAL* entry/line (first of wrapped from which start is issued) */
  LONG num;          ; not used */
  LONG start_column; ; column of start of selection in 'start' entry */
  LONG end_column;   ; column of end of selection in 'end' entry */
  LONG start_pos;    ; char pos of start of selection in 'start_column' entry */
  LONG end_pos;      ; char pos of end of selection in 'end_column' entry */
  LONG vstart;       ; num of first visually selected entry */
  LONG vend;         ; num of last visually selected entry */
  LONG vnum;         ; number of visually selected entries */
};
* NOTE that vstart==start, vend==end in all cases if no wrapping is used */
	ASM

* Methods *

MUIM_NList_Clear		EQU	$9d510070 ; GM
MUIM_NList_CreateImage		EQU	$9d510071 ; GM
MUIM_NList_DeleteImage		EQU	$9d510072 ; GM
MUIM_NList_Exchange		EQU	$9d510073 ; GM
MUIM_NList_GetEntry		EQU	$9d510074 ; GM
MUIM_NList_Insert		EQU	$9d510075 ; GM
MUIM_NList_InsertSingle		EQU	$9d510076 ; GM
MUIM_NList_Jump			EQU	$9d510077 ; GM
MUIM_NList_Move			EQU	$9d510078 ; GM
MUIM_NList_NextSelected		EQU	$9d510079 ; GM
MUIM_NList_Redraw		EQU	$9d51007a ; GM
MUIM_NList_Remove		EQU	$9d51007b ; GM
MUIM_NList_Select		EQU	$9d51007c ; GM
MUIM_NList_Sort			EQU	$9d51007d ; GM
MUIM_NList_TestPos		EQU	$9d51007e ; GM
MUIM_NList_CopyToClip		EQU	$9d51007f ; GM
MUIM_NList_UseImage		EQU	$9d510080 ; GM
MUIM_NList_ReplaceSingle	EQU	$9d510081 ; GM
MUIM_NList_InsertWrap		EQU	$9d510082 ; GM
MUIM_NList_InsertSingleWrap	EQU	$9d510083 ; GM
MUIM_NList_GetEntryInfo		EQU	$9d510084 ; GM
MUIM_NList_QueryBeginning	EQU	$9d510085 ; Obsolete
MUIM_NList_GetSelectInfo	EQU	$9d510086 ; GM
MUIM_NList_CopyTo		EQU	$9d510087 ; GM
MUIM_NList_DropType		EQU	$9d510088 ; GM
MUIM_NList_DropDraw		EQU	$9d510089 ; GM
MUIM_NList_RedrawEntry		EQU	$9d51008a ; GM
MUIM_NList_DoMethod		EQU	$9d51008b ; GM
MUIM_NList_ColWidth		EQU	$9d51008c ; GM
MUIM_NList_ContextMenuBuild	EQU	$9d51008d ; GM
MUIM_NList_DropEntryDrawErase	EQU	$9d51008e ; GM
MUIM_NList_ColToColumn		EQU     $9d51008f ; GM
MUIM_NList_ColumnToCol		EQU	$9d510091 ; GM
MUIM_NList_Sort2		EQU	$9d510092 ; GM
MUIM_NList_PrevSelected		EQU	$9d510093 ; GM
MUIM_NList_SetColumnCol		EQU	$9d510094 ; GM
MUIM_NList_Sort3		EQU	$9d510095 ; GM
MUIM_NList_GetPos		EQU	$9d510096 ; GM
	ENDASM
struct  MUIP_NList_Clear	      { ULONG MethodID; };
struct  MUIP_NList_CreateImage        { ULONG MethodID; Object *obj; ULONG flags; };
struct  MUIP_NList_DeleteImage        { ULONG MethodID; APTR listimg; };
struct  MUIP_NList_Exchange           { ULONG MethodID; LONG pos1; LONG pos2; };
struct  MUIP_NList_GetEntry           { ULONG MethodID; LONG pos; APTR *entry; };
struct  MUIP_NList_Insert             { ULONG MethodID; APTR *entries; LONG count; LONG pos; };
struct  MUIP_NList_InsertSingle       { ULONG MethodID; APTR entry; LONG pos; };
struct  MUIP_NList_Jump 	      { ULONG MethodID; LONG pos; };
struct  MUIP_NList_Move 	      { ULONG MethodID; LONG from; LONG to; };
struct  MUIP_NList_NextSelected       { ULONG MethodID; LONG *pos; };
struct  MUIP_NList_Redraw             { ULONG MethodID; LONG pos; };
struct  MUIP_NList_Remove             { ULONG MethodID; LONG pos; };
struct  MUIP_NList_Select             { ULONG MethodID; LONG pos; LONG seltype; LONG *state; };
struct  MUIP_NList_Sort 	      { ULONG MethodID; };
struct  MUIP_NList_TestPos            { ULONG MethodID; LONG x; LONG y; struct MUI_NList_TestPos_Result *res; };
struct  MUIP_NList_CopyToClip         { ULONG MethodID; LONG pos; ULONG clipnum; APTR *entries; struct Hook *hook; };
struct  MUIP_NList_UseImage           { ULONG MethodID; Object *obj; LONG imgnum; ULONG flags; };
struct  MUIP_NList_ReplaceSingle      { ULONG MethodID; APTR entry; LONG pos; LONG wrapcol; LONG align; };
struct  MUIP_NList_InsertWrap         { ULONG MethodID; APTR *entries; LONG count; LONG pos; LONG wrapcol; LONG align; };
struct  MUIP_NList_InsertSingleWrap   { ULONG MethodID; APTR entry; LONG pos; LONG wrapcol; LONG align; };
struct  MUIP_NList_GetEntryInfo       { ULONG MethodID; struct MUI_NList_GetEntryInfo *res; };
struct  MUIP_NList_QueryBeginning     { ULONG MethodID; };
struct  MUIP_NList_GetSelectInfo      { ULONG MethodID; struct MUI_NList_GetSelectInfo *res; };
struct  MUIP_NList_CopyTo             { ULONG MethodID; LONG pos; char *filename; APTR *result; APTR *entries; };
struct  MUIP_NList_DropType           { ULONG MethodID; LONG *pos; LONG *type; LONG minx, maxx, miny, maxy; LONG mousex, mousey; };
struct  MUIP_NList_DropDraw           { ULONG MethodID; LONG pos; LONG type; LONG minx, maxx, miny, maxy; };
struct  MUIP_NList_RedrawEntry        { ULONG MethodID; APTR entry; };
struct  MUIP_NList_DoMethod           { ULONG MethodID; LONG pos; APTR DestObj; ULONG FollowParams; /* ... */  };
struct  MUIP_NList_ColWidth           { ULONG MethodID; LONG col; LONG width; };
struct  MUIP_NList_ContextMenuBuild   { ULONG MethodID; LONG mx; LONG my; LONG pos; LONG column; LONG flags; LONG ontop; };
struct  MUIP_NList_DropEntryDrawErase { ULONG MethodID; LONG type; LONG drawpos; LONG erasepos; };
struct  MUIP_NList_ColToColumn        { ULONG MethodID; LONG col; };
struct  MUIP_NList_ColumnToCol        { ULONG MethodID; LONG column; };
struct  MUIP_NList_Sort2	      { ULONG MethodID; LONG sort_type; LONG sort_type_add; };
struct  MUIP_NList_PrevSelected       { ULONG MethodID; LONG *pos; };
struct  MUIP_NList_SetColumnCol       { ULONG MethodID; LONG column; LONG col; };
struct  MUIP_NList_Sort3	      { ULONG MethodID; LONG sort_type; LONG sort_type_add; LONG which; };
struct  MUIP_NList_GetPos             { ULONG MethodID; APTR entry; LONG *pos; };
	ASM


DISPLAY_ARRAY_MAX	EQU	64

ALIGN_LEFT	EQU	$0000
ALIGN_CENTER	EQU	$0100
ALIGN_RIGHT	EQU	$0200
ALIGN_JUSTIFY	EQU	$0400


*  Be carrefull ! the 'sort_type2' member don't exist in releases before 19.96
*  where MUIM_NList_Sort3,MUIA_NList_SortType2,MUIA_NList_TitleClick2 and
*  MUIA_NList_TitleMark2 have appeared !
*  You can safely use get(obj,MUIA_NList_SortType2,&st2) instead if you are not
*  sure of the NList.mcc release which is used.

	ENDASM
struct NList_CompareMessage
{
  APTR entry1;
  APTR entry2;
  LONG sort_type;
  LONG sort_type2;
};

struct NList_ConstructMessage
{
  APTR entry;
  APTR pool;
};

struct NList_DestructMessage
{
  APTR entry;
  APTR pool;
};

struct NList_DisplayMessage
{
  APTR entry;
  LONG entry_pos;
  char *strings[DISPLAY_ARRAY_MAX];
  char *preparses[DISPLAY_ARRAY_MAX];
};

struct NList_CopyEntryToClipMessage
{
  APTR entry;
  LONG entry_pos;
  char *str_result;
  LONG column1;
  LONG column1_pos;
  LONG column2;
  LONG column2_pos;
  LONG column1_pos_type;
  LONG column2_pos_type;
};

struct NList_CopyColumnToClipMessage
{
  char *string;
  LONG entry_pos;
  char *str_result;
  LONG str_pos1;
  LONG str_pos2;
};
	ASM

	ENDC	; MUI_NLIST_MCC_I

