OPT NATIVE, PREPROCESS
MODULE 'target/libraries/mui'
MODULE 'target/utility/hooks','target/graphics/gfx', 'target/exec/types', 'target/intuition/classusr'
{#include <mui/NList_mcc.h>}
NATIVE {MUI_NList_MCC_H} CONST

/***************************************************************************

 NList.mcc - New List MUI Custom Class
 Registered MUI class, Serial Number: 1d51 0x9d510030 to 0x9d5100A0
                                           0x9d5100C0 to 0x9d5100FF

 Copyright (C) 1996-2001 by Gilles Masson
 Copyright (C) 2001-2005 by NList Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 NList classes Support Site:  http://www.sf.net/projects/nlist-classes

 $Id: NList_mcc.h 232 2007-10-09 07:30:32Z damato $

***************************************************************************/

/* MUI Prop and Scroller classes stuff which is still not in libraries/mui.h  (in MUI3.8) */
/* it gives to the prop object it's increment value */
NATIVE {MUIA_Prop_DeltaFactor} CONST MUIA_Prop_DeltaFactor = $80427C5E


NATIVE {MUIC_NList} CONST
#define MUIC_NList muic_nlist
STATIC muic_nlist = 'NList.mcc'

NATIVE {NListObject} CONST
#define NListObject Mui_NewObject(MUIC_NList


/* Attributes */

NATIVE {MUIA_NList_TypeSelect}               CONST MUIA_NList_TypeSelect               = $9d510030 /* GM  is.  LONG              */
NATIVE {MUIA_NList_Prop_DeltaFactor}         CONST MUIA_NList_Prop_DeltaFactor         = $9d510031 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_Horiz_DeltaFactor}        CONST MUIA_NList_Horiz_DeltaFactor        = $9d510032 /* GM  ..gn LONG              */

NATIVE {MUIA_NList_Horiz_First}              CONST MUIA_NList_Horiz_First              = $9d510033 /* GM  .sgn LONG              */
NATIVE {MUIA_NList_Horiz_Visible}            CONST MUIA_NList_Horiz_Visible            = $9d510034 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_Horiz_Entries}            CONST MUIA_NList_Horiz_Entries            = $9d510035 /* GM  ..gn LONG              */

NATIVE {MUIA_NList_Prop_First}               CONST MUIA_NList_Prop_First               = $9d510036 /* GM  .sgn LONG              */
NATIVE {MUIA_NList_Prop_Visible}             CONST MUIA_NList_Prop_Visible             = $9d510037 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_Prop_Entries}             CONST MUIA_NList_Prop_Entries             = $9d510038 /* GM  ..gn LONG              */

NATIVE {MUIA_NList_TitlePen}                 CONST MUIA_NList_TitlePen                 = $9d510039 /* GM  isg  LONG              */
NATIVE {MUIA_NList_ListPen}                  CONST MUIA_NList_ListPen                  = $9d51003a /* GM  isg  LONG              */
NATIVE {MUIA_NList_SelectPen}                CONST MUIA_NList_SelectPen                = $9d51003b /* GM  isg  LONG              */
NATIVE {MUIA_NList_CursorPen}                CONST MUIA_NList_CursorPen                = $9d51003c /* GM  isg  LONG              */
NATIVE {MUIA_NList_UnselCurPen}              CONST MUIA_NList_UnselCurPen              = $9d51003d /* GM  isg  LONG              */
NATIVE {MUIA_NList_InactivePen}              CONST MUIA_NList_InactivePen              = $9d5100C1 /* GM  isg  LONG              */

NATIVE {MUIA_NList_ListBackground}           CONST MUIA_NList_ListBackground           = $9d51003e /* GM  isg  LONG              */
NATIVE {MUIA_NList_TitleBackground}          CONST MUIA_NList_TitleBackground          = $9d51003f /* GM  isg  LONG              */
NATIVE {MUIA_NList_SelectBackground}         CONST MUIA_NList_SelectBackground         = $9d510040 /* GM  isg  LONG              */
NATIVE {MUIA_NList_CursorBackground}         CONST MUIA_NList_CursorBackground         = $9d510041 /* GM  isg  LONG              */
NATIVE {MUIA_NList_UnselCurBackground}       CONST MUIA_NList_UnselCurBackground       = $9d510042 /* GM  isg  LONG              */
NATIVE {MUIA_NList_InactiveBackground}       CONST MUIA_NList_InactiveBackground       = $9d5100C2 /* GM  isg  LONG              */

NATIVE {MUIA_NList_MultiClick}               CONST MUIA_NList_MultiClick               = $9d510043 /* GM  ..gn LONG              */

NATIVE {MUIA_NList_DefaultObjectOnClick}     CONST MUIA_NList_DefaultObjectOnClick     = $9d510044 /* GM  is.  BOOL              */
NATIVE {MUIA_NList_ActiveObjectOnClick}      CONST MUIA_NList_ActiveObjectOnClick      = $9d5100C3 /* GM  is.  BOOL              */

NATIVE {MUIA_NList_ClickColumn}              CONST MUIA_NList_ClickColumn              = $9d510045 /* GM  ..g  LONG              */
NATIVE {MUIA_NList_DefClickColumn}           CONST MUIA_NList_DefClickColumn           = $9d510046 /* GM  isg  LONG              */
NATIVE {MUIA_NList_DoubleClick}              CONST MUIA_NList_DoubleClick              = $9d510047 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_DragType}                 CONST MUIA_NList_DragType                 = $9d510048 /* GM  isg  LONG              */
NATIVE {MUIA_NList_Input}                    CONST MUIA_NList_Input                    = $9d510049 /* GM  isg  BOOL              */
NATIVE {MUIA_NList_MultiSelect}              CONST MUIA_NList_MultiSelect              = $9d51004a /* GM  is.  LONG              */
NATIVE {MUIA_NList_SelectChange}             CONST MUIA_NList_SelectChange             = $9d51004b /* GM  ...n BOOL              */

NATIVE {MUIA_NList_Active}                   CONST MUIA_NList_Active                   = $9d51004c /* GM  isgn LONG              */
NATIVE {MUIA_NList_AdjustHeight}             CONST MUIA_NList_AdjustHeight             = $9d51004d /* GM  i..  BOOL              */
NATIVE {MUIA_NList_AdjustWidth}              CONST MUIA_NList_AdjustWidth              = $9d51004e /* GM  i..  BOOL              */
NATIVE {MUIA_NList_AutoVisible}              CONST MUIA_NList_AutoVisible              = $9d51004f /* GM  isg  BOOL              */
NATIVE {MUIA_NList_CompareHook}              CONST MUIA_NList_CompareHook              = $9d510050 /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_ConstructHook}            CONST MUIA_NList_ConstructHook            = $9d510051 /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_DestructHook}             CONST MUIA_NList_DestructHook             = $9d510052 /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_DisplayHook}              CONST MUIA_NList_DisplayHook              = $9d510053 /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_DragSortable}             CONST MUIA_NList_DragSortable             = $9d510054 /* GM  isg  BOOL              */
NATIVE {MUIA_NList_DropMark}                 CONST MUIA_NList_DropMark                 = $9d510055 /* GM  ..g  LONG              */
NATIVE {MUIA_NList_Entries}                  CONST MUIA_NList_Entries                  = $9d510056 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_First}                    CONST MUIA_NList_First                    = $9d510057 /* GM  isgn LONG              */
NATIVE {MUIA_NList_Format}                   CONST MUIA_NList_Format                   = $9d510058 /* GM  isg  STRPTR            */
NATIVE {MUIA_NList_InsertPosition}           CONST MUIA_NList_InsertPosition           = $9d510059 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_MinLineHeight}            CONST MUIA_NList_MinLineHeight            = $9d51005a /* GM  is.  LONG              */
NATIVE {MUIA_NList_MultiTestHook}            CONST MUIA_NList_MultiTestHook            = $9d51005b /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_Pool}                     CONST MUIA_NList_Pool                     = $9d51005c /* GM  i..  APTR              */
NATIVE {MUIA_NList_PoolPuddleSize}           CONST MUIA_NList_PoolPuddleSize           = $9d51005d /* GM  i..  ULONG             */
NATIVE {MUIA_NList_PoolThreshSize}           CONST MUIA_NList_PoolThreshSize           = $9d51005e /* GM  i..  ULONG             */
NATIVE {MUIA_NList_Quiet}                    CONST MUIA_NList_Quiet                    = $9d51005f /* GM  .s.  BOOL              */
NATIVE {MUIA_NList_ShowDropMarks}            CONST MUIA_NList_ShowDropMarks            = $9d510060 /* GM  isg  BOOL              */
NATIVE {MUIA_NList_SourceArray}              CONST MUIA_NList_SourceArray              = $9d510061 /* GM  i..  APTR *            */
NATIVE {MUIA_NList_Title}                    CONST MUIA_NList_Title                    = $9d510062 /* GM  isg  char *            */
NATIVE {MUIA_NList_Visible}                  CONST MUIA_NList_Visible                  = $9d510063 /* GM  ..g  LONG              */
NATIVE {MUIA_NList_CopyEntryToClipHook}      CONST MUIA_NList_CopyEntryToClipHook      = $9d510064 /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_KeepActive}               CONST MUIA_NList_KeepActive               = $9d510065 /* GM  .s.  Obj *             */
NATIVE {MUIA_NList_MakeActive}               CONST MUIA_NList_MakeActive               = $9d510066 /* GM  .s.  Obj *             */
NATIVE {MUIA_NList_SourceString}             CONST MUIA_NList_SourceString             = $9d510067 /* GM  i..  char *            */
NATIVE {MUIA_NList_CopyColumnToClipHook}     CONST MUIA_NList_CopyColumnToClipHook     = $9d510068 /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_ListCompatibility}        CONST MUIA_NList_ListCompatibility        = $9d510069 /* GM  ...  OBSOLETE          */
NATIVE {MUIA_NList_AutoCopyToClip}           CONST MUIA_NList_AutoCopyToClip           = $9d51006A /* GM  is.  BOOL              */
NATIVE {MUIA_NList_TabSize}                  CONST MUIA_NList_TabSize                  = $9d51006B /* GM  isg  ULONG             */
NATIVE {MUIA_NList_SkipChars}                CONST MUIA_NList_SkipChars                = $9d51006C /* GM  isg  char *            */
NATIVE {MUIA_NList_DisplayRecall}            CONST MUIA_NList_DisplayRecall            = $9d51006D /* GM  .g.  BOOL              */
NATIVE {MUIA_NList_PrivateData}              CONST MUIA_NList_PrivateData              = $9d51006E /* GM  isg  APTR              */
NATIVE {MUIA_NList_EntryValueDependent}      CONST MUIA_NList_EntryValueDependent      = $9d51006F /* GM  isg  BOOL              */

NATIVE {MUIA_NList_StackCheck}               CONST MUIA_NList_StackCheck               = $9d510097 /* GM  i..  BOOL              */
NATIVE {MUIA_NList_WordSelectChars}          CONST MUIA_NList_WordSelectChars          = $9d510098 /* GM  isg  char *            */
NATIVE {MUIA_NList_EntryClick}               CONST MUIA_NList_EntryClick               = $9d510099 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_DragColOnly}              CONST MUIA_NList_DragColOnly              = $9d51009A /* GM  isg  LONG              */
NATIVE {MUIA_NList_TitleClick}               CONST MUIA_NList_TitleClick               = $9d51009B /* GM  isgn LONG              */
NATIVE {MUIA_NList_DropType}                 CONST MUIA_NList_DropType                 = $9d51009C /* GM  ..g  LONG              */
NATIVE {MUIA_NList_ForcePen}                 CONST MUIA_NList_ForcePen                 = $9d51009D /* GM  isg  LONG              */
NATIVE {MUIA_NList_SourceInsert}             CONST MUIA_NList_SourceInsert             = $9d51009E /* GM  i..  struct MUIP_NList_InsertWrap *   */
NATIVE {MUIA_NList_TitleSeparator}           CONST MUIA_NList_TitleSeparator           = $9d51009F /* GM  isg  BOOL              */

NATIVE {MUIA_NList_AutoClip}                 CONST MUIA_NList_AutoClip                 = $9d5100C0 /* GM  isg  BOOL              */

NATIVE {MUIA_NList_SortType2}                CONST MUIA_NList_SortType2                = $9d5100ED /* GM  isgn LONG              */
NATIVE {MUIA_NList_TitleClick2}              CONST MUIA_NList_TitleClick2              = $9d5100EE /* GM  isgn LONG              */
NATIVE {MUIA_NList_TitleMark2}               CONST MUIA_NList_TitleMark2               = $9d5100EF /* GM  isg  LONG              */
NATIVE {MUIA_NList_MultiClickAlone}          CONST MUIA_NList_MultiClickAlone          = $9d5100F0 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_TitleMark}                CONST MUIA_NList_TitleMark                = $9d5100F1 /* GM  isg  LONG              */
NATIVE {MUIA_NList_DragSortInsert}           CONST MUIA_NList_DragSortInsert           = $9d5100F2 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_MinColSortable}           CONST MUIA_NList_MinColSortable           = $9d5100F3 /* GM  isg  LONG              */
NATIVE {MUIA_NList_Imports}                  CONST MUIA_NList_Imports                  = $9d5100F4 /* GM  isg  LONG              */
NATIVE {MUIA_NList_Exports}                  CONST MUIA_NList_Exports                  = $9d5100F5 /* GM  isg  LONG              */
NATIVE {MUIA_NList_Columns}                  CONST MUIA_NList_Columns                  = $9d5100F6 /* GM  isgn BYTE *            */
NATIVE {MUIA_NList_LineHeight}               CONST MUIA_NList_LineHeight               = $9d5100F7 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_ButtonClick}              CONST MUIA_NList_ButtonClick              = $9d5100F8 /* GM  ..gn LONG              */
NATIVE {MUIA_NList_CopyEntryToClipHook2}     CONST MUIA_NList_CopyEntryToClipHook2     = $9d5100F9 /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_CopyColumnToClipHook2}    CONST MUIA_NList_CopyColumnToClipHook2    = $9d5100FA /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_CompareHook2}             CONST MUIA_NList_CompareHook2             = $9d5100FB /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_ConstructHook2}           CONST MUIA_NList_ConstructHook2           = $9d5100FC /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_DestructHook2}            CONST MUIA_NList_DestructHook2            = $9d5100FD /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_DisplayHook2}             CONST MUIA_NList_DisplayHook2             = $9d5100FE /* GM  is.  struct Hook *     */
NATIVE {MUIA_NList_SortType}                 CONST MUIA_NList_SortType                 = $9d5100FF /* GM  isgn LONG              */

NATIVE {MUIA_NList_KeyUpFocus}               CONST MUIA_NList_KeyUpFocus               = $9d5100C4 /* GM  isg. Object *          */
NATIVE {MUIA_NList_KeyDownFocus}             CONST MUIA_NList_KeyDownFocus             = $9d5100C5 /* GM  isg. Object *          */
NATIVE {MUIA_NList_KeyLeftFocus}             CONST MUIA_NList_KeyLeftFocus             = $9d5100C6 /* GM  isg. Object *          */
NATIVE {MUIA_NList_KeyRightFocus}            CONST MUIA_NList_KeyRightFocus            = $9d5100C7 /* GM  isg. Object *          */


NATIVE {MUIA_NLIMG_EntryCurrent}             CONST MUIA_NLIMG_EntryCurrent             = MUIA_NList_First   /* LONG (special for nlist custom image object) */
NATIVE {MUIA_NLIMG_EntryHeight}              CONST MUIA_NLIMG_EntryHeight              = MUIA_NList_Visible /* LONG (special for nlist custom image object) */

NATIVE {MUIA_NList_VertDeltaFactor}          CONST MUIA_NList_VertDeltaFactor          = MUIA_NList_Prop_DeltaFactor   /* OBSOLETE NAME */
NATIVE {MUIA_NList_HorizDeltaFactor}         CONST MUIA_NList_HorizDeltaFactor         = MUIA_NList_Horiz_DeltaFactor  /* OBSOLETE NAME */

/* Attributes special datas */
NATIVE {MUIV_NList_TypeSelect_Line}        CONST MUIV_NList_TypeSelect_Line        = 0
NATIVE {MUIV_NList_TypeSelect_Char}        CONST MUIV_NList_TypeSelect_Char        = 1

NATIVE {MUIV_NList_Font}                 CONST MUIV_NList_Font                 = -20
NATIVE {MUIV_NList_Font_Little}          CONST MUIV_NList_Font_Little          = -21
NATIVE {MUIV_NList_Font_Fixed}           CONST MUIV_NList_Font_Fixed           = -22

NATIVE {MUIV_NList_ConstructHook_String}  CONST MUIV_NList_ConstructHook_String  = -1
NATIVE {MUIV_NList_DestructHook_String}   CONST MUIV_NList_DestructHook_String   = -1

NATIVE {MUIV_NList_Active_Off}            CONST MUIV_NList_Active_Off            = -1
NATIVE {MUIV_NList_Active_Top}            CONST MUIV_NList_Active_Top            = -2
NATIVE {MUIV_NList_Active_Bottom}         CONST MUIV_NList_Active_Bottom         = -3
NATIVE {MUIV_NList_Active_Up}             CONST MUIV_NList_Active_Up             = -4
NATIVE {MUIV_NList_Active_Down}           CONST MUIV_NList_Active_Down           = -5
NATIVE {MUIV_NList_Active_PageUp}         CONST MUIV_NList_Active_PageUp         = -6
NATIVE {MUIV_NList_Active_PageDown}       CONST MUIV_NList_Active_PageDown       = -7

NATIVE {MUIV_NList_First_Top}             CONST MUIV_NList_First_Top             = -2
NATIVE {MUIV_NList_First_Bottom}          CONST MUIV_NList_First_Bottom          = -3
NATIVE {MUIV_NList_First_Up}              CONST MUIV_NList_First_Up              = -4
NATIVE {MUIV_NList_First_Down}            CONST MUIV_NList_First_Down            = -5
NATIVE {MUIV_NList_First_PageUp}          CONST MUIV_NList_First_PageUp          = -6
NATIVE {MUIV_NList_First_PageDown}        CONST MUIV_NList_First_PageDown        = -7
NATIVE {MUIV_NList_First_Up2}             CONST MUIV_NList_First_Up2             = -8
NATIVE {MUIV_NList_First_Down2}           CONST MUIV_NList_First_Down2           = -9
NATIVE {MUIV_NList_First_Up4}            CONST MUIV_NList_First_Up4            = -10
NATIVE {MUIV_NList_First_Down4}          CONST MUIV_NList_First_Down4          = -11

NATIVE {MUIV_NList_Horiz_First_Start}     CONST MUIV_NList_Horiz_First_Start     = -2
NATIVE {MUIV_NList_Horiz_First_End}       CONST MUIV_NList_Horiz_First_End       = -3
NATIVE {MUIV_NList_Horiz_First_Left}      CONST MUIV_NList_Horiz_First_Left      = -4
NATIVE {MUIV_NList_Horiz_First_Right}     CONST MUIV_NList_Horiz_First_Right     = -5
NATIVE {MUIV_NList_Horiz_First_PageLeft}  CONST MUIV_NList_Horiz_First_PageLeft  = -6
NATIVE {MUIV_NList_Horiz_First_PageRight} CONST MUIV_NList_Horiz_First_PageRight = -7
NATIVE {MUIV_NList_Horiz_First_Left2}     CONST MUIV_NList_Horiz_First_Left2     = -8
NATIVE {MUIV_NList_Horiz_First_Right2}    CONST MUIV_NList_Horiz_First_Right2    = -9
NATIVE {MUIV_NList_Horiz_First_Left4}    CONST MUIV_NList_Horiz_First_Left4    = -10
NATIVE {MUIV_NList_Horiz_First_Right4}   CONST MUIV_NList_Horiz_First_Right4   = -11

NATIVE {MUIV_NList_MultiSelect_None}       CONST MUIV_NList_MultiSelect_None       = 0
NATIVE {MUIV_NList_MultiSelect_Default}    CONST MUIV_NList_MultiSelect_Default    = 1
NATIVE {MUIV_NList_MultiSelect_Shifted}    CONST MUIV_NList_MultiSelect_Shifted    = 2
NATIVE {MUIV_NList_MultiSelect_Always}     CONST MUIV_NList_MultiSelect_Always     = 3

NATIVE {MUIV_NList_Insert_Top}             CONST MUIV_NList_Insert_Top             = 0
NATIVE {MUIV_NList_Insert_Active}         CONST MUIV_NList_Insert_Active         = -1
NATIVE {MUIV_NList_Insert_Sorted}         CONST MUIV_NList_Insert_Sorted         = -2
NATIVE {MUIV_NList_Insert_Bottom}         CONST MUIV_NList_Insert_Bottom         = -3
NATIVE {MUIV_NList_Insert_Flag_Raw}       CONST MUIV_NList_Insert_Flag_Raw       = 1 SHL 0

NATIVE {MUIV_NList_Remove_First}           CONST MUIV_NList_Remove_First           = 0
NATIVE {MUIV_NList_Remove_Active}         CONST MUIV_NList_Remove_Active         = -1
NATIVE {MUIV_NList_Remove_Last}           CONST MUIV_NList_Remove_Last           = -2
NATIVE {MUIV_NList_Remove_Selected}       CONST MUIV_NList_Remove_Selected       = -3

NATIVE {MUIV_NList_Select_Off}             CONST MUIV_NList_Select_Off             = 0
NATIVE {MUIV_NList_Select_On}              CONST MUIV_NList_Select_On              = 1
NATIVE {MUIV_NList_Select_Toggle}          CONST MUIV_NList_Select_Toggle          = 2
NATIVE {MUIV_NList_Select_Ask}             CONST MUIV_NList_Select_Ask             = 3

NATIVE {MUIV_NList_GetEntry_Active}       CONST MUIV_NList_GetEntry_Active       = -1
NATIVE {MUIV_NList_GetEntryInfo_Line}     CONST MUIV_NList_GetEntryInfo_Line     = -2

NATIVE {MUIV_NList_Select_Active}         CONST MUIV_NList_Select_Active         = -1
NATIVE {MUIV_NList_Select_All}            CONST MUIV_NList_Select_All            = -2

NATIVE {MUIV_NList_Redraw_Active}         CONST MUIV_NList_Redraw_Active         = -1
NATIVE {MUIV_NList_Redraw_All}            CONST MUIV_NList_Redraw_All            = -2
NATIVE {MUIV_NList_Redraw_Title}          CONST MUIV_NList_Redraw_Title          = -3
NATIVE {MUIV_NList_Redraw_Selected}       CONST MUIV_NList_Redraw_Selected       = -4
NATIVE {MUIV_NList_Redraw_VisibleCols}    CONST MUIV_NList_Redraw_VisibleCols    = -5

NATIVE {MUIV_NList_Move_Top}               CONST MUIV_NList_Move_Top               = 0
NATIVE {MUIV_NList_Move_Active}           CONST MUIV_NList_Move_Active           = -1
NATIVE {MUIV_NList_Move_Bottom}           CONST MUIV_NList_Move_Bottom           = -2
NATIVE {MUIV_NList_Move_Next}             CONST MUIV_NList_Move_Next             = -3 /* only valid for second parameter (and not with Move_Selected) */
NATIVE {MUIV_NList_Move_Previous}         CONST MUIV_NList_Move_Previous         = -4 /* only valid for second parameter (and not with Move_Selected) */
NATIVE {MUIV_NList_Move_Selected}         CONST MUIV_NList_Move_Selected         = -5 /* only valid for first parameter */

NATIVE {MUIV_NList_Exchange_Top}           CONST MUIV_NList_Exchange_Top           = 0
NATIVE {MUIV_NList_Exchange_Active}       CONST MUIV_NList_Exchange_Active       = -1
NATIVE {MUIV_NList_Exchange_Bottom}       CONST MUIV_NList_Exchange_Bottom       = -2
NATIVE {MUIV_NList_Exchange_Next}         CONST MUIV_NList_Exchange_Next         = -3 /* only valid for second parameter */
NATIVE {MUIV_NList_Exchange_Previous}     CONST MUIV_NList_Exchange_Previous     = -4 /* only valid for second parameter */

NATIVE {MUIV_NList_Jump_Top}               CONST MUIV_NList_Jump_Top               = 0
NATIVE {MUIV_NList_Jump_Active}           CONST MUIV_NList_Jump_Active           = -1
NATIVE {MUIV_NList_Jump_Bottom}           CONST MUIV_NList_Jump_Bottom           = -2
NATIVE {MUIV_NList_Jump_Up}               CONST MUIV_NList_Jump_Up               = -4
NATIVE {MUIV_NList_Jump_Down}             CONST MUIV_NList_Jump_Down             = -3

NATIVE {MUIV_NList_NextSelected_Start}    CONST MUIV_NList_NextSelected_Start    = -1
NATIVE {MUIV_NList_NextSelected_End}      CONST MUIV_NList_NextSelected_End      = -1

NATIVE {MUIV_NList_PrevSelected_Start}    CONST MUIV_NList_PrevSelected_Start    = -1
NATIVE {MUIV_NList_PrevSelected_End}      CONST MUIV_NList_PrevSelected_End      = -1

NATIVE {MUIV_NList_DragType_None}          CONST MUIV_NList_DragType_None          = 0
NATIVE {MUIV_NList_DragType_Default}       CONST MUIV_NList_DragType_Default       = 1
NATIVE {MUIV_NList_DragType_Immediate}     CONST MUIV_NList_DragType_Immediate     = 2
NATIVE {MUIV_NList_DragType_Borders}       CONST MUIV_NList_DragType_Borders       = 3
NATIVE {MUIV_NList_DragType_Qualifier}     CONST MUIV_NList_DragType_Qualifier     = 4

NATIVE {MUIV_NList_CopyToClip_Active}     CONST MUIV_NList_CopyToClip_Active     = -1
NATIVE {MUIV_NList_CopyToClip_Selected}   CONST MUIV_NList_CopyToClip_Selected   = -2
NATIVE {MUIV_NList_CopyToClip_All}        CONST MUIV_NList_CopyToClip_All        = -3
NATIVE {MUIV_NList_CopyToClip_Entries}    CONST MUIV_NList_CopyToClip_Entries    = -4
NATIVE {MUIV_NList_CopyToClip_Entry}      CONST MUIV_NList_CopyToClip_Entry      = -5
NATIVE {MUIV_NList_CopyToClip_Strings}    CONST MUIV_NList_CopyToClip_Strings    = -6
NATIVE {MUIV_NList_CopyToClip_String}     CONST MUIV_NList_CopyToClip_String     = -7

NATIVE {MUIV_NList_CopyTo_Active}         CONST MUIV_NList_CopyTo_Active         = -1
NATIVE {MUIV_NList_CopyTo_Selected}       CONST MUIV_NList_CopyTo_Selected       = -2
NATIVE {MUIV_NList_CopyTo_All}            CONST MUIV_NList_CopyTo_All            = -3
NATIVE {MUIV_NList_CopyTo_Entries}        CONST MUIV_NList_CopyTo_Entries        = -4
NATIVE {MUIV_NList_CopyTo_Entry}          CONST MUIV_NList_CopyTo_Entry          = -5

NATIVE {MUIV_NLCT_Success}                 CONST MUIV_NLCT_Success                 = 0
NATIVE {MUIV_NLCT_OpenErr}                 CONST MUIV_NLCT_OpenErr                 = 1
NATIVE {MUIV_NLCT_WriteErr}                CONST MUIV_NLCT_WriteErr                = 2
NATIVE {MUIV_NLCT_Failed}                  CONST MUIV_NLCT_Failed                  = 3

NATIVE {MUIV_NList_ForcePen_On}            CONST MUIV_NList_ForcePen_On            = 1
NATIVE {MUIV_NList_ForcePen_Off}           CONST MUIV_NList_ForcePen_Off           = 0
NATIVE {MUIV_NList_ForcePen_Default}      CONST MUIV_NList_ForcePen_Default      = -1

NATIVE {MUIV_NList_DropType_Mask}          CONST MUIV_NList_DropType_Mask          = $00FF
NATIVE {MUIV_NList_DropType_None}          CONST MUIV_NList_DropType_None          = 0
NATIVE {MUIV_NList_DropType_Above}         CONST MUIV_NList_DropType_Above         = 1
NATIVE {MUIV_NList_DropType_Below}         CONST MUIV_NList_DropType_Below         = 2
NATIVE {MUIV_NList_DropType_Onto}          CONST MUIV_NList_DropType_Onto          = 3

NATIVE {MUIV_NList_DoMethod_Active}       CONST MUIV_NList_DoMethod_Active       = -1
NATIVE {MUIV_NList_DoMethod_Selected}     CONST MUIV_NList_DoMethod_Selected     = -2
NATIVE {MUIV_NList_DoMethod_All}          CONST MUIV_NList_DoMethod_All          = -3

NATIVE {MUIV_NList_DoMethod_Entry}        CONST MUIV_NList_DoMethod_Entry        = -1
NATIVE {MUIV_NList_DoMethod_Self}         CONST MUIV_NList_DoMethod_Self         = -2
NATIVE {MUIV_NList_DoMethod_App}          CONST MUIV_NList_DoMethod_App          = -3

NATIVE {MUIV_NList_EntryValue}             CONST MUIV_NList_EntryValue             = (MUIV_TriggerValue+$100)
NATIVE {MUIV_NList_EntryPosValue}          CONST MUIV_NList_EntryPosValue          = (MUIV_TriggerValue+$102)
NATIVE {MUIV_NList_SelfValue}              CONST MUIV_NList_SelfValue              = (MUIV_TriggerValue+$104)
NATIVE {MUIV_NList_AppValue}               CONST MUIV_NList_AppValue               = (MUIV_TriggerValue+$106)

NATIVE {MUIV_NList_ColWidth_All}          CONST MUIV_NList_ColWidth_All          = -1
NATIVE {MUIV_NList_ColWidth_Default}      CONST MUIV_NList_ColWidth_Default      = -1
NATIVE {MUIV_NList_ColWidth_Get}          CONST MUIV_NList_ColWidth_Get          = -2

NATIVE {MUIV_NList_ContextMenu_Default}    CONST MUIV_NList_ContextMenu_Default    = $9d510031
NATIVE {MUIV_NList_ContextMenu_TopOnly}    CONST MUIV_NList_ContextMenu_TopOnly    = $9d510033
NATIVE {MUIV_NList_ContextMenu_BarOnly}    CONST MUIV_NList_ContextMenu_BarOnly    = $9d510035
NATIVE {MUIV_NList_ContextMenu_Bar_Top}    CONST MUIV_NList_ContextMenu_Bar_Top    = $9d510037
NATIVE {MUIV_NList_ContextMenu_Always}     CONST MUIV_NList_ContextMenu_Always     = $9d510039
NATIVE {MUIV_NList_ContextMenu_Never}      CONST MUIV_NList_ContextMenu_Never      = $9d51003b

NATIVE {MUIV_NList_Menu_DefWidth_This}     CONST MUIV_NList_Menu_DefWidth_This     = $9d51003d
NATIVE {MUIV_NList_Menu_DefWidth_All}      CONST MUIV_NList_Menu_DefWidth_All      = $9d51003f
NATIVE {MUIV_NList_Menu_DefOrder_This}     CONST MUIV_NList_Menu_DefOrder_This     = $9d510041
NATIVE {MUIV_NList_Menu_DefOrder_All}      CONST MUIV_NList_Menu_DefOrder_All      = $9d510043
NATIVE {MUIV_NList_Menu_Default_This}      CONST MUIV_NList_Menu_Default_This      = MUIV_NList_Menu_DefWidth_This
NATIVE {MUIV_NList_Menu_Default_All}       CONST MUIV_NList_Menu_Default_All       = MUIV_NList_Menu_DefWidth_All

NATIVE {MUIV_NList_SortType_None}          CONST MUIV_NList_SortType_None          = $F0000000
NATIVE {MUIV_NList_SortTypeAdd_None}       CONST MUIV_NList_SortTypeAdd_None       = $00000000
NATIVE {MUIV_NList_SortTypeAdd_2Values}    CONST MUIV_NList_SortTypeAdd_2Values    = $80000000
NATIVE {MUIV_NList_SortTypeAdd_4Values}    CONST MUIV_NList_SortTypeAdd_4Values    = $40000000
NATIVE {MUIV_NList_SortTypeAdd_Mask}       CONST MUIV_NList_SortTypeAdd_Mask       = $C0000000
NATIVE {MUIV_NList_SortTypeValue_Mask}     CONST MUIV_NList_SortTypeValue_Mask     = $3FFFFFFF

NATIVE {MUIV_NList_Sort3_SortType_Both}    CONST MUIV_NList_Sort3_SortType_Both    = $00000000
NATIVE {MUIV_NList_Sort3_SortType_1}       CONST MUIV_NList_Sort3_SortType_1       = $00000001
NATIVE {MUIV_NList_Sort3_SortType_2}       CONST MUIV_NList_Sort3_SortType_2       = $00000002

NATIVE {MUIV_NList_Quiet_None}             CONST MUIV_NList_Quiet_None             = 0
NATIVE {MUIV_NList_Quiet_Full}            CONST MUIV_NList_Quiet_Full            = -1
NATIVE {MUIV_NList_Quiet_Visual}          CONST MUIV_NList_Quiet_Visual          = -2

NATIVE {MUIV_NList_Imports_Active}         CONST MUIV_NList_Imports_Active         = 1 SHL 0
NATIVE {MUIV_NList_Imports_Selected}       CONST MUIV_NList_Imports_Selected       = 1 SHL 1
NATIVE {MUIV_NList_Imports_First}          CONST MUIV_NList_Imports_First          = 1 SHL 2
NATIVE {MUIV_NList_Imports_ColWidth}       CONST MUIV_NList_Imports_ColWidth       = 1 SHL 3
NATIVE {MUIV_NList_Imports_ColOrder}       CONST MUIV_NList_Imports_ColOrder       = 1 SHL 4
NATIVE {MUIV_NList_Imports_TitleMark}      CONST MUIV_NList_Imports_TitleMark      = 1 SHL 7
NATIVE {MUIV_NList_Imports_Cols}           CONST MUIV_NList_Imports_Cols           = $000000F8
NATIVE {MUIV_NList_Imports_All}            CONST MUIV_NList_Imports_All            = $0000FFFF

NATIVE {MUIV_NList_Exports_Active}         CONST MUIV_NList_Exports_Active         = 1 SHL 0
NATIVE {MUIV_NList_Exports_Selected}       CONST MUIV_NList_Exports_Selected       = 1 SHL 1
NATIVE {MUIV_NList_Exports_First}          CONST MUIV_NList_Exports_First          = 1 SHL 2
NATIVE {MUIV_NList_Exports_ColWidth}       CONST MUIV_NList_Exports_ColWidth       = 1 SHL 3
NATIVE {MUIV_NList_Exports_ColOrder}       CONST MUIV_NList_Exports_ColOrder       = 1 SHL 4
NATIVE {MUIV_NList_Exports_TitleMark}      CONST MUIV_NList_Exports_TitleMark      = 1 SHL 7
NATIVE {MUIV_NList_Exports_Cols}           CONST MUIV_NList_Exports_Cols           = $000000F8
NATIVE {MUIV_NList_Exports_All}            CONST MUIV_NList_Exports_All            = $0000FFFF

NATIVE {MUIV_NList_TitleMark_ColMask}      CONST MUIV_NList_TitleMark_ColMask      = $000000FF
NATIVE {MUIV_NList_TitleMark_TypeMask}     CONST MUIV_NList_TitleMark_TypeMask     = $F0000000
NATIVE {MUIV_NList_TitleMark_None}         CONST MUIV_NList_TitleMark_None         = $F0000000
NATIVE {MUIV_NList_TitleMark_Down}         CONST MUIV_NList_TitleMark_Down         = $00000000
NATIVE {MUIV_NList_TitleMark_Up}           CONST MUIV_NList_TitleMark_Up           = $80000000
NATIVE {MUIV_NList_TitleMark_Box}          CONST MUIV_NList_TitleMark_Box          = $40000000
NATIVE {MUIV_NList_TitleMark_Circle}       CONST MUIV_NList_TitleMark_Circle       = $C0000000

NATIVE {MUIV_NList_TitleMark2_ColMask}     CONST MUIV_NList_TitleMark2_ColMask     = $000000FF
NATIVE {MUIV_NList_TitleMark2_TypeMask}    CONST MUIV_NList_TitleMark2_TypeMask    = $F0000000
NATIVE {MUIV_NList_TitleMark2_None}        CONST MUIV_NList_TitleMark2_None        = $F0000000
NATIVE {MUIV_NList_TitleMark2_Down}        CONST MUIV_NList_TitleMark2_Down        = $00000000
NATIVE {MUIV_NList_TitleMark2_Up}          CONST MUIV_NList_TitleMark2_Up          = $80000000
NATIVE {MUIV_NList_TitleMark2_Box}         CONST MUIV_NList_TitleMark2_Box         = $40000000
NATIVE {MUIV_NList_TitleMark2_Circle}      CONST MUIV_NList_TitleMark2_Circle      = $C0000000

NATIVE {MUIV_NList_SetColumnCol_Default}  CONST MUIV_NList_SetColumnCol_Default  = -1

NATIVE {MUIV_NList_GetPos_Start}          CONST MUIV_NList_GetPos_Start          = -1
NATIVE {MUIV_NList_GetPos_End}            CONST MUIV_NList_GetPos_End            = -1

NATIVE {MUIV_NList_SelectChange_Flag_Multi} CONST MUIV_NList_SelectChange_Flag_Multi = 1 SHL 0

NATIVE {MUIV_NList_UseImage_All}         CONST MUIV_NList_UseImage_All         = (-1)

/* Structs */

NATIVE {BitMapImage} OBJECT bitmapimage
  {control}	control	:ULONG   /* should be == to MUIM_NList_CreateImage for a valid BitMapImage struct */
  {width}	width	:INT     /* if control == MUIA_Image_Spec then obtainpens is a pointer to an Object */
  {height}	height	:INT
  {obtainpens}	obtainpens	:PTR TO INT
  {mask}	mask	:PLANEPTR
  {imgbmp}	imgbmp	:bitmap
  {flags}	flags	:VALUE
ENDOBJECT


NATIVE {MUI_NList_TestPos_Result} OBJECT mui_nlist_testpos_result
  {entry}	entry	:VALUE   /* number of entry, -1 if mouse not over valid entry */
  {column}	column	:INT  /* numer of column, -1 if no valid column */
  {flags}	flags	:UINT   /* not in the list, see below */
  {xoffset}	xoffset	:INT /* x offset in column */
  {yoffset}	yoffset	:INT /* y offset of mouse click from center of line */
  {preparse}	preparse	:INT     /* 2 if in column preparse string, 1 if in entry preparse string, else 0 */
  {char_number}	char_number	:INT  /* the number of the clicked char in column, -1 if no valid */
  {char_xoffset}	char_xoffset	:INT /* x offset of mouse clicked from left of char if positive */
ENDOBJECT                    /* and left of next char if negative. If there is no char there */
                      /* negative if from left of first char else from right of last one */

NATIVE {MUI_NLPR_ABOVE}  CONST MUI_NLPR_ABOVE  = 1 SHL 0
NATIVE {MUI_NLPR_BELOW}  CONST MUI_NLPR_BELOW  = 1 SHL 1
NATIVE {MUI_NLPR_LEFT}   CONST MUI_NLPR_LEFT   = 1 SHL 2
NATIVE {MUI_NLPR_RIGHT}  CONST MUI_NLPR_RIGHT  = 1 SHL 3
NATIVE {MUI_NLPR_BAR}    CONST MUI_NLPR_BAR    = 1 SHL 4  /* if between two columns you'll get the left
                                   column number of both, and that flag */
NATIVE {MUI_NLPR_TITLE}  CONST MUI_NLPR_TITLE  = 1 SHL 5  /* if clicked on title, only column, xoffset and yoffset (and MUI_NLPR_BAR)
                                    are valid (you'll get MUI_NLPR_ABOVE too) */
NATIVE {MUI_NLPR_ONTOP}  CONST MUI_NLPR_ONTOP  = 1 SHL 6  /* it is on title/half of first visible entry */


NATIVE {MUI_NList_GetEntryInfo} OBJECT mui_nlist_getentryinfo
  {pos}	pos	:VALUE             /* num of entry you want info about */
  {line}	line	:VALUE            /* real line number */
  {entry_pos}	entry_pos	:VALUE       /* entry num of returned entry ptr */
  {entry}	entry	:APTR           /* entry pointer */
  {wrapcol}	wrapcol	:VALUE         /* NOWRAP, WRAPCOLx, or WRAPPED|WRAPCOLx */
  {charpos}	charpos	:VALUE         /* start char number in string (unused if NOWRAP) */
  {charlen}	charlen	:VALUE         /* string lenght (unused if NOWRAP) */
ENDOBJECT

NATIVE {NOWRAP}          CONST NOWRAP          = $00
NATIVE {WRAPCOL0}        CONST WRAPCOL0        = $01
NATIVE {WRAPCOL1}        CONST WRAPCOL1        = $02
NATIVE {WRAPCOL2}        CONST WRAPCOL2        = $04
NATIVE {WRAPCOL3}        CONST WRAPCOL3        = $08
NATIVE {WRAPCOL4}        CONST WRAPCOL4        = $10
NATIVE {WRAPCOL5}        CONST WRAPCOL5        = $20
NATIVE {WRAPCOL6}        CONST WRAPCOL6        = $40
NATIVE {WRAPPED}         CONST WRAPPED         = $80


NATIVE {MUI_NList_GetSelectInfo} OBJECT mui_nlist_getselectinfo
  {start}	start	:VALUE        /* num of first selected *REAL* entry/line (first of wrapped from which start is issued) */
  {end}	end	:VALUE          /* num of last selected *REAL* entry/line (first of wrapped from which start is issued) */
  {num}	num	:VALUE          /* not used */
  {start_column}	start_column	:VALUE /* column of start of selection in 'start' entry */
  {end_column}	end_column	:VALUE   /* column of end of selection in 'end' entry */
  {start_pos}	start_pos	:VALUE    /* char pos of start of selection in 'start_column' entry */
  {end_pos}	end_pos	:VALUE      /* char pos of end of selection in 'end_column' entry */
  {vstart}	vstart	:VALUE       /* num of first visually selected entry */
  {vend}	vend	:VALUE         /* num of last visually selected entry */
  {vnum}	vnum	:VALUE         /* number of visually selected entries */
ENDOBJECT
/* NOTE that vstart==start, vend==end in all cases if no wrapping is used */

/* Methods */

NATIVE {MUIM_NList_Clear}              CONST MUIM_NList_Clear              = $9d510070 /* GM */
NATIVE {MUIM_NList_CreateImage}        CONST MUIM_NList_CreateImage        = $9d510071 /* GM */
NATIVE {MUIM_NList_DeleteImage}        CONST MUIM_NList_DeleteImage        = $9d510072 /* GM */
NATIVE {MUIM_NList_Exchange}           CONST MUIM_NList_Exchange           = $9d510073 /* GM */
NATIVE {MUIM_NList_GetEntry}           CONST MUIM_NList_GetEntry           = $9d510074 /* GM */
NATIVE {MUIM_NList_Insert}             CONST MUIM_NList_Insert             = $9d510075 /* GM */
NATIVE {MUIM_NList_InsertSingle}       CONST MUIM_NList_InsertSingle       = $9d510076 /* GM */
NATIVE {MUIM_NList_Jump}               CONST MUIM_NList_Jump               = $9d510077 /* GM */
NATIVE {MUIM_NList_Move}               CONST MUIM_NList_Move               = $9d510078 /* GM */
NATIVE {MUIM_NList_NextSelected}       CONST MUIM_NList_NextSelected       = $9d510079 /* GM */
NATIVE {MUIM_NList_Redraw}             CONST MUIM_NList_Redraw             = $9d51007a /* GM */
NATIVE {MUIM_NList_Remove}             CONST MUIM_NList_Remove             = $9d51007b /* GM */
NATIVE {MUIM_NList_Select}             CONST MUIM_NList_Select             = $9d51007c /* GM */
NATIVE {MUIM_NList_Sort}               CONST MUIM_NList_Sort               = $9d51007d /* GM */
NATIVE {MUIM_NList_TestPos}            CONST MUIM_NList_TestPos            = $9d51007e /* GM */
NATIVE {MUIM_NList_CopyToClip}         CONST MUIM_NList_CopyToClip         = $9d51007f /* GM */
NATIVE {MUIM_NList_UseImage}           CONST MUIM_NList_UseImage           = $9d510080 /* GM */
NATIVE {MUIM_NList_ReplaceSingle}      CONST MUIM_NList_ReplaceSingle      = $9d510081 /* GM */
NATIVE {MUIM_NList_InsertWrap}         CONST MUIM_NList_InsertWrap         = $9d510082 /* GM */
NATIVE {MUIM_NList_InsertSingleWrap}   CONST MUIM_NList_InsertSingleWrap   = $9d510083 /* GM */
NATIVE {MUIM_NList_GetEntryInfo}       CONST MUIM_NList_GetEntryInfo       = $9d510084 /* GM */
NATIVE {MUIM_NList_QueryBeginning}     CONST MUIM_NList_QueryBeginning     = $9d510085 /* Obsolete */
NATIVE {MUIM_NList_GetSelectInfo}      CONST MUIM_NList_GetSelectInfo      = $9d510086 /* GM */
NATIVE {MUIM_NList_CopyTo}             CONST MUIM_NList_CopyTo             = $9d510087 /* GM */
NATIVE {MUIM_NList_DropType}           CONST MUIM_NList_DropType           = $9d510088 /* GM */
NATIVE {MUIM_NList_DropDraw}           CONST MUIM_NList_DropDraw           = $9d510089 /* GM */
NATIVE {MUIM_NList_RedrawEntry}        CONST MUIM_NList_RedrawEntry        = $9d51008a /* GM */
NATIVE {MUIM_NList_DoMethod}           CONST MUIM_NList_DoMethod           = $9d51008b /* GM */
NATIVE {MUIM_NList_ColWidth}           CONST MUIM_NList_ColWidth           = $9d51008c /* GM */
NATIVE {MUIM_NList_ContextMenuBuild}   CONST MUIM_NList_ContextMenuBuild   = $9d51008d /* GM */
NATIVE {MUIM_NList_DropEntryDrawErase} CONST MUIM_NList_DropEntryDrawErase = $9d51008e /* GM */
NATIVE {MUIM_NList_ColToColumn}        CONST MUIM_NList_ColToColumn        = $9d51008f /* GM */
NATIVE {MUIM_NList_ColumnToCol}        CONST MUIM_NList_ColumnToCol        = $9d510091 /* GM */
NATIVE {MUIM_NList_Sort2}              CONST MUIM_NList_Sort2              = $9d510092 /* GM */
NATIVE {MUIM_NList_PrevSelected}       CONST MUIM_NList_PrevSelected       = $9d510093 /* GM */
NATIVE {MUIM_NList_SetColumnCol}       CONST MUIM_NList_SetColumnCol       = $9d510094 /* GM */
NATIVE {MUIM_NList_Sort3}              CONST MUIM_NList_Sort3              = $9d510095 /* GM */
NATIVE {MUIM_NList_GetPos}             CONST MUIM_NList_GetPos             = $9d510096 /* GM */
NATIVE {MUIM_NList_SelectChange}       CONST MUIM_NList_SelectChange       = $9d5100A0 /* GM */
NATIVE {MUIM_NList_Construct}          CONST MUIM_NList_Construct          = $9d5100A1 /* GM */
NATIVE {MUIM_NList_Destruct}           CONST MUIM_NList_Destruct           = $9d5100A2 /* GM */
NATIVE {MUIM_NList_Compare}            CONST MUIM_NList_Compare            = $9d5100A3 /* GM */
NATIVE {MUIM_NList_Display}            CONST MUIM_NList_Display            = $9d5100A4 /* GM */
NATIVE {MUIM_NList_GoActive}           CONST MUIM_NList_GoActive           = $9d5100A5 /* GM */
NATIVE {MUIM_NList_GoInactive}         CONST MUIM_NList_GoInactive         = $9d5100A6 /* GM */


NATIVE {MUIP_NList_Clear} OBJECT muip_nlist_clear
	{MethodID}	methodid	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_CreateImage} OBJECT muip_nlist_createimage
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_DeleteImage} OBJECT muip_nlist_deleteimage
	{MethodID}	methodid	:ULONG
	{listimg}	listimg	:APTR
ENDOBJECT

NATIVE {MUIP_NList_Exchange} OBJECT muip_nlist_exchange
	{MethodID}	methodid	:ULONG
	{pos1}	pos1	:VALUE
	{pos2}	pos2	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_GetEntry} OBJECT muip_nlist_getentry
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{entry}	entry	:PTR TO APTR
ENDOBJECT

NATIVE {MUIP_NList_Insert} OBJECT muip_nlist_insert
	{MethodID}	methodid	:ULONG
	{entries}	entries	:PTR TO APTR
	{count}	count	:VALUE
	{pos}	pos	:VALUE
	{flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_InsertSingle} OBJECT muip_nlist_insertsingle
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{pos}	pos	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_Jump} OBJECT muip_nlist_jump
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_Move} OBJECT muip_nlist_move
	{MethodID}	methodid	:ULONG
	{from}	from	:VALUE
	{to}	to	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_NextSelected} OBJECT muip_nlist_nextselected
	{MethodID}	methodid	:ULONG
	{pos}	pos	:PTR TO VALUE
ENDOBJECT

NATIVE {MUIP_NList_Redraw} OBJECT muip_nlist_redraw
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_Remove} OBJECT muip_nlist_remove
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_Select} OBJECT muip_nlist_select
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{seltype}	seltype	:VALUE
	{state}	state	:PTR TO VALUE
ENDOBJECT

NATIVE {MUIP_NList_Sort} OBJECT muip_nlist_sort
	{MethodID}	methodid	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_TestPos} OBJECT muip_nlist_testpos
	{MethodID}	methodid	:ULONG
	{x}	x	:VALUE
	{y}	y	:VALUE
	{res}	res	:PTR TO mui_nlist_testpos_result
ENDOBJECT

NATIVE {MUIP_NList_CopyToClip} OBJECT muip_nlist_copytoclip
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{clipnum}	clipnum	:ULONG
	{entries}	entries	:PTR TO APTR
	{hook}	hook	:PTR TO hook
ENDOBJECT

NATIVE {MUIP_NList_UseImage} OBJECT muip_nlist_useimage
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{imgnum}	imgnum	:VALUE
	{flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_ReplaceSingle} OBJECT muip_nlist_replacesingle
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{pos}	pos	:VALUE
	{wrapcol}	wrapcol	:VALUE
	{align}	align	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_InsertWrap} OBJECT muip_nlist_insertwrap
	{MethodID}	methodid	:ULONG
	{entries}	entries	:PTR TO APTR
	{count}	count	:VALUE
	{pos}	pos	:VALUE
	{wrapcol}	wrapcol	:VALUE
	{align}	align	:VALUE
	{flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_InsertSingleWrap} OBJECT muip_nlist_insertsinglewrap
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{pos}	pos	:VALUE
	{wrapcol}	wrapcol	:VALUE
	{align}	align	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_GetEntryInfo} OBJECT muip_nlist_getentryinfo
	{MethodID}	methodid	:ULONG
	{res}	res	:PTR TO mui_nlist_getentryinfo
ENDOBJECT

NATIVE {MUIP_NList_QueryBeginning} OBJECT muip_nlist_querybeginning
	{MethodID}	methodid	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_GetSelectInfo} OBJECT muip_nlist_getselectinfo
	{MethodID}	methodid	:ULONG
	{res}	res	:PTR TO mui_nlist_getselectinfo
ENDOBJECT

NATIVE {MUIP_NList_CopyTo} OBJECT muip_nlist_copyto
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{filename}	filename	:ARRAY OF CHAR
	{result}	result	:PTR TO APTR
	{entries}	entries	:PTR TO APTR
ENDOBJECT

NATIVE {MUIP_NList_DropType} OBJECT muip_nlist_droptype
	{MethodID}	methodid	:ULONG
	{pos}	pos	:PTR TO VALUE
	{type}	type	:PTR TO VALUE
	{minx}	minx	:VALUE
	{maxx}	maxx	:VALUE
	{miny}	miny	:VALUE
	{maxy}	maxy	:VALUE
	{mousex}	mousex	:VALUE
	{mousey}	mousey	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_DropDraw} OBJECT muip_nlist_dropdraw
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{type}	type	:VALUE
	{minx}	minx	:VALUE
	{maxx}	maxx	:VALUE
	{miny}	miny	:VALUE
	{maxy}	maxy	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_RedrawEntry} OBJECT muip_nlist_redrawentry
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
ENDOBJECT

NATIVE {MUIP_NList_DoMethod} OBJECT muip_nlist_domethod
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{DestObj}	destobj	:APTR
	{FollowParams}	followparams	:ULONG /* ... */ 
ENDOBJECT

NATIVE {MUIP_NList_ColWidth} OBJECT muip_nlist_colwidth
	{MethodID}	methodid	:ULONG
	{col}	col	:VALUE
	{width}	width	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_ContextMenuBuild} OBJECT muip_nlist_contextmenubuild
	{MethodID}	methodid	:ULONG
	{mx}	mx	:VALUE
	{my}	my	:VALUE
	{pos}	pos	:VALUE
	{column}	column	:VALUE
	{flags}	flags	:VALUE
	{ontop}	ontop	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_DropEntryDrawErase} OBJECT muip_nlist_dropentrydrawerase
	{MethodID}	methodid	:ULONG
	{type}	type	:VALUE
	{drawpos}	drawpos	:VALUE
	{erasepos}	erasepos	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_ColToColumn} OBJECT muip_nlist_coltocolumn
	{MethodID}	methodid	:ULONG
	{col}	col	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_ColumnToCol} OBJECT muip_nlist_columntocol
	{MethodID}	methodid	:ULONG
	{column}	column	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_Sort2} OBJECT muip_nlist_sort2
	{MethodID}	methodid	:ULONG
	{sort_type}	sort_type	:VALUE
	{sort_type_add}	sort_type_add	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_PrevSelected} OBJECT muip_nlist_prevselected
	{MethodID}	methodid	:ULONG
	{pos}	pos	:PTR TO VALUE
ENDOBJECT

NATIVE {MUIP_NList_SetColumnCol} OBJECT muip_nlist_setcolumncol
	{MethodID}	methodid	:ULONG
	{column}	column	:VALUE
	{col}	col	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_Sort3} OBJECT muip_nlist_sort3
	{MethodID}	methodid	:ULONG
	{sort_type}	sort_type	:VALUE
	{sort_type_add}	sort_type_add	:VALUE
	{which}	which	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_GetPos} OBJECT muip_nlist_getpos
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{pos}	pos	:PTR TO VALUE
ENDOBJECT

NATIVE {MUIP_NList_SelectChange} OBJECT muip_nlist_selectchange
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{state}	state	:VALUE
	{flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_Construct} OBJECT muip_nlist_construct
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{pool}	pool	:APTR
ENDOBJECT

NATIVE {MUIP_NList_Destruct} OBJECT muip_nlist_destruct
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{pool}	pool	:APTR
ENDOBJECT

NATIVE {MUIP_NList_Compare} OBJECT muip_nlist_compare
	{MethodID}	methodid	:ULONG
	{entry1}	entry1	:APTR
	{entry2}	entry2	:APTR
	{sort_type1}	sort_type1	:VALUE
	{sort_type2}	sort_type2	:VALUE
ENDOBJECT

NATIVE {MUIP_NList_Display} OBJECT muip_nlist_display
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{entry_pos}	entry_pos	:VALUE
	{strings}	strings	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR
	{preparses}	preparses	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

NATIVE {MUIP_NList_GoActive} OBJECT muip_nlist_goactive
	{MethodID}	methodid	:ULONG
ENDOBJECT

NATIVE {MUIP_NList_GoInactive} OBJECT muip_nlist_goinactive
	{MethodID}	methodid	:ULONG
ENDOBJECT


NATIVE {DISPLAY_ARRAY_MAX} CONST DISPLAY_ARRAY_MAX = 64

NATIVE {ALIGN_LEFT}      CONST ALIGN_LEFT      = $0000
NATIVE {ALIGN_CENTER}    CONST ALIGN_CENTER    = $0100
NATIVE {ALIGN_RIGHT}     CONST ALIGN_RIGHT     = $0200
NATIVE {ALIGN_JUSTIFY}   CONST ALIGN_JUSTIFY   = $0400


/*  Be carrefull ! the 'sort_type2' member don't exist in releases before 19.96
 *  where MUIM_NList_Sort3, MUIA_NList_SortType2, MUIA_NList_TitleClick2 and
 *  MUIA_NList_TitleMark2 have appeared !
 *  You can safely use get(obj,MUIA_NList_SortType2,&st2) instead if you are not
 *  sure of the NList.mcc release which is used.
 */
NATIVE {NList_CompareMessage} OBJECT nlist_comparemessage
  {entry1}	entry1	:APTR
  {entry2}	entry2	:APTR
  {sort_type}	sort_type	:VALUE
  {sort_type2}	sort_type2	:VALUE
ENDOBJECT

NATIVE {NList_ConstructMessage} OBJECT nlist_constructmessage
  {entry}	entry	:APTR
  {pool}	pool	:APTR
ENDOBJECT

NATIVE {NList_DestructMessage} OBJECT nlist_destructmessage
  {entry}	entry	:APTR
  {pool}	pool	:APTR
ENDOBJECT

NATIVE {NList_DisplayMessage} OBJECT nlist_displaymessage
  {entry}	entry	:APTR
  {entry_pos}	entry_pos	:VALUE
  {strings}	strings[DISPLAY_ARRAY_MAX]	:ARRAY OF ARRAY OF CHAR
  {preparses}	preparses[DISPLAY_ARRAY_MAX]	:ARRAY OF ARRAY OF CHAR
ENDOBJECT

NATIVE {NList_CopyEntryToClipMessage} OBJECT nlist_copyentrytoclipmessage
  {entry}	entry	:APTR
  {entry_pos}	entry_pos	:VALUE
  {str_result}	str_result	:ARRAY OF CHAR
  {column1}	column1	:VALUE
  {column1_pos}	column1_pos	:VALUE
  {column2}	column2	:VALUE
  {column2_pos}	column2_pos	:VALUE
  {column1_pos_type}	column1_pos_type	:VALUE
  {column2_pos_type}	column2_pos_type	:VALUE
ENDOBJECT

NATIVE {NList_CopyColumnToClipMessage} OBJECT nlist_copycolumntoclipmessage
  {string}	string	:ARRAY OF CHAR
  {entry_pos}	entry_pos	:VALUE
  {str_result}	str_result	:ARRAY OF CHAR
  {str_pos1}	str_pos1	:VALUE
  {str_pos2}	str_pos2	:VALUE
ENDOBJECT
