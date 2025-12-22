/*
**
** Copyright © 1996-1997,1999 Dipl.-Inform. Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MonthNavigator.rexx 16.7 (06.06.99)
**
** Experimental version, please report bugs/improvements!
*/

MUIC_MonthNavigator = "MonthNavigator.mcc"
/*#define MonthNavigatorObject	MUI_NewObject(MUIC_MonthNavigator*/

MUIA_MonthNavigator_ShowWeekdayNames	= 0x81ee0005
MUIA_MonthNavigator_ShowWeekNumbers	= 0x81ee0006
MUIA_MonthNavigator_InputMode		= 0x81ee0009
MUIA_MonthNavigator_UseFrames		= 0x81ee000a
MUIA_MonthNavigator_ShowInvisibles	= 0x81ee000b
MUIA_MonthNavigator_WeekdayNamesSpacing = 0x81ee000c
MUIA_MonthNavigator_WeekNumbersSpacing	= 0x81ee000d
MUIA_MonthNavigator_LineWeekdayNames	= 0x81ee000e
MUIA_MonthNavigator_LineWeekNumbers	= 0x81ee000f
MUIA_MonthNavigator_Draggable		= 0x81ee0012
MUIA_MonthNavigator_MarkHook		= 0x81ee0013
MUIA_MonthNavigator_Dropable		= 0x81ee0014
/*MUIA_MonthNavigator_DragQueryHook	= 0x81ee0015*/
/*MUIA_MonthNavigator_DragDropHook	= 0x81ee0016*/
MUIA_MonthNavigator_ShowLastMonthDays	= 0x81ee0017
MUIA_MonthNavigator_ShowNextMonthDays	= 0x81ee0018
MUIA_MonthNavigator_MonthAdjust 	= 0x81ee0019
MUIA_MonthNavigator_FixedTo6Rows	= 0x81ee0033
MUIA_MonthNavigator_Layout		= 0x81ee0034


MUIM_MonthNavigator_Update		= 0x81ee0010 /* struct MUIP_MonthNavigator_Update    {ULONG MethodID;}; */
MUIM_MonthNavigator_Mark		= 0x81ee0030 /* struct MUIP_MonthNavigator_Mark      {ULONG MethodID; LONG Year; ULONG Month; ULONG Day; Object *dayobj;}; */
MUIM_MonthNavigator_DragQuery		= 0x81ee0031 /* struct MUIP_MonthNavigator_DragQuery {ULONG MethodID; LONG Year; ULONG Month; ULONG Day; Object *dayobj; Object *obj;}; */
MUIM_MonthNavigator_DragDrop		= 0x81ee0032 /* struct MUIP_MonthNavigator_DragQuery {ULONG MethodID; LONG Year; ULONG Month; ULONG Day; Object *dayobj; Object *obj;}; */

MUIV_MonthNavigator_InputMode_None		= 0
MUIV_MonthNavigator_InputMode_RelVerify 	= 1
MUIV_MonthNavigator_InputMode_Immediate 	= 2

MUIV_MonthNavigator_Layout_American		= 0
MUIV_MonthNavigator_Layout_European		= 1

MUIV_MonthNavigator_ShowMDays_No		= 0
MUIV_MonthNavigator_ShowMDays_OnlyFillUp	= 1
MUIV_MonthNavigator_ShowMDays_Yes		= 2

MUIV_MonthNavigator_MarkHook_HiToday		= 1

/*MUIV_MonthNavigator_MarkDay_Version		= 1*/
/*
struct MUIS_MonthNavigator_MarkDay
 {
  ULONG  Version;
  LONG	 Year;
  UWORD  Month;
  UWORD  Day;

  STRPTR PreParse;
  ULONG  Background;
  STRPTR ShortHelp;
  BOOL	 Disabled;
 };
*/

MUICFG_MonthNavigator_TodayUnderline		= 0x81ee002c
MUICFG_MonthNavigator_TodayBold 		= 0x81ee002d
MUICFG_MonthNavigator_TodayItalic		= 0x81ee002e
MUICFG_MonthNavigator_TodayAlignment		= 0x81ee002f
MUICFG_MonthNavigator_TodayBackground		= 0x81ee001d
MUICFG_MonthNavigator_TodayPen			= 0x81ee001e
MUICFG_MonthNavigator_TodayShortHelp		= 0x81ee001f
