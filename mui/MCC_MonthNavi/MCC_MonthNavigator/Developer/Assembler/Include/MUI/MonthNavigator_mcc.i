**
** Copyright © 1996-1997,1999 Dipl.-Inform. Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MonthNavigator_mcc.i 16.7 (06.06.99)
**

   IFND MUI_MONTHNAVIGATOR_I
MUI_MONTHNAVIGATOR_I	SET 1

** In case user forgets that this .i includes data

	bra end_of_monthnavigator_i

** Attributes

MUIA_MonthNavigator_ShowWeekdayNames	EQU $81ee0005
MUIA_MonthNavigator_ShowWeekNumbers	EQU $81ee0006
MUIA_MonthNavigator_Input		EQU $81ee0009
MUIA_MonthNavigator_UseFrames		EQU $81ee000a
MUIA_MonthNavigator_ShowInvisibles	EQU $81ee000b
MUIA_MonthNavigator_WeekdayNamesSpacing	EQU $81ee000c
MUIA_MonthNavigator_WeekNumbersSpacing	EQU $81ee000d
MUIA_MonthNavigator_LineWeekdayNames	EQU $81ee000e
MUIA_MonthNavigator_LineWeekNumbers	EQU $81ee000f
MUIA_MonthNavigator_Draggable		EQU $81ee0012
MUIA_MonthNavigator_MarkHook		EQU $81ee0013
MUIA_MonthNavigator_Dropable		EQU $81ee0014
MUIA_MonthNavigator_DragQueryHook	EQU $81ee0015
MUIA_MonthNavigator_DragDropHook	EQU $81ee0016
MUIA_MonthNavigator_ShowLastMonthDays	EQU $81ee0017
MUIA_MonthNavigator_ShowNextMonthDays	EQU $81ee0018
MUIA_MonthNavigator_MonthAdjust		EQU $81ee0019
MUIA_MonthNavigator_FixedTo6Rows	EQU $81ee0033
MUIA_MonthNavigator_Layout		EQU $81ee0034


MUIM_MonthNavigator_Update		EQU $81ee0010
MUIM_MonthNavigator_Mark		EQU $81ee0030
MUIM_MonthNavigator_DragQuery		EQU $81ee0031
MUIM_MonthNavigator_DragDrop		EQU $81ee0032

MUICFG_MonthNavigator_TodayUnderline	EQU $81ee002c
MUICFG_MonthNavigator_TodayBold		EQU $81ee002d
MUICFG_MonthNavigator_TodayItalic	EQU $81ee002e
MUICFG_MonthNavigator_TodayAlignment	EQU $81ee002f
MUICFG_MonthNavigator_TodayBackground	EQU $81ee001d
MUICFG_MonthNavigator_TodayPen		EQU $81ee001e
MUICFG_MonthNavigator_TodayShortHelp	EQU $81ee001f


	STRUCTURE MUIP_MonthNavigator_Update,0
	  ULONG MUIP_MonthNavigator_Update_MethodID
	  LABEL MUIP_MonthNavigator_Update_SIZE

	STRUCTURE MUIP_MonthNavigator_Mark,0
	  ULONG MUIP_MonthNavigator_Mark_MethodID
	  LONG  MUIP_MonthNavigator_Mark_Year
	  ULONG MUIP_MonthNavigator_Mark_Month
	  ULONG MUIP_MonthNavigator_Mark_Day
	  APTR  MUIP_MonthNavigator_Mark_dayobj
	  LABEL MUIP_MonthNavigator_Mark_SIZE

	STRUCTURE MUIP_MonthNavigator_DragQuery,0
	  ULONG MUIP_MonthNavigator_DragQuery_MethodID
	  LONG  MUIP_MonthNavigator_DragQuery_Year
	  ULONG MUIP_MonthNavigator_DragQuery_Month
	  ULONG MUIP_MonthNavigator_DragQuery_Day
	  APTR  MUIP_MonthNavigator_DragQuery_dayobj
	  APTR  MUIP_MonthNavigator_DragQuery_obj
	  LABEL MUIP_MonthNavigator_DragQuery_SIZE

	STRUCTURE MUIP_MonthNavigator_DragDrop,0
	  ULONG MUIP_MonthNavigator_DragDrop_MethodID
	  LONG  MUIP_MonthNavigator_DragDrop_Year
	  ULONG MUIP_MonthNavigator_DragDrop_Month
	  ULONG MUIP_MonthNavigator_DragDrop_Day
	  APTR  MUIP_MonthNavigator_DragDrop_dayobj
	  APTR  MUIP_MonthNavigator_DragDrop_obj
	  LABEL MUIP_MonthNavigator_DragDrop_SIZE

MUIV_MonthNavigator_InputMode_None		SET 0
MUIV_MonthNavigator_InputMode_RelVerify		SET 1
MUIV_MonthNavigator_InputMode_Immediate		SET 2

MUIV_MonthNavigator_Layout_American		SET 0
MUIV_MonthNavigator_Layout_European		SET 1

MUIV_MonthNavigator_ShowMDays_No		SET 0
MUIV_MonthNavigator_ShowMDays_OnlyFillUp	SET 1
MUIV_MonthNavigator_ShowMDays_Yes		SET 2

MUIV_MonthNavigator_MarkHook_HiToday		SET 1

MUIV_MonthNavigator_MarkDay_Version		SET 1

	STRUCTURE MUIS_MonthNavigator_MarkDay,0
	  ULONG  MUIS_MonthNavigator_MarkDay_Version
	  LONG   MUIS_MonthNavigator_MarkDay_Year
	  USHORT MUIS_MonthNavigator_MarkDay_Month
	  USHORT MUIS_MonthNavigator_MarkDay_Day

	  APTR   MUIS_MonthNavigator_MarkDay_PreParse
	  ULONG  MUIS_MonthNavigator_MarkDay_Background
	  APTR   MUIS_MonthNavigator_MarkDay_ShortHelp
	  BOOL   MUIS_MonthNavigator_MarkDay_Disabled

	  LABEL MUIS_MonthNavigator_MarkDay_SIZE

** Pointers for strings

MUIC_MonthNavigator	dc.l MUIC_MonthNavigator_s

** Strings

MUIC_MonthNavigator_s	dc.b "MonthNavigator.mcc",0,0

end_of_monthnavigator_i

   ENDC ; MUI_MONTHNAVIGATOR_I
