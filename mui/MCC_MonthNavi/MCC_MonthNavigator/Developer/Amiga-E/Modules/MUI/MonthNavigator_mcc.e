/*
**
** Copyright © 1996-1997,1999 Dipl.-Inform. Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MonthNavigator_mcc.e 16.7 (06.06.99)
**
** Amiga-E interface model by Oskar Sundberg <gary@canit.se>
**
*/

 OPT MODULE
 OPT EXPORT
 OPT PREPROCESS

 #ifndef MUI_MONTHNAVIGATOR_MCC_H
   #define MUI_MONTHNAVIGATOR_MCC_H

   #define MUIC_MonthNavigator	'MonthNavigator.mcc'
   #define MonthNavigatorObject Mui_NewObjectA(MUIC_MonthNavigator,[TAG_IGNORE,0

   CONST MUIA_MonthNavigator_ShowWeekdayNames		= $81ee0005
   CONST MUIA_MonthNavigator_ShowWeekNumbers		= $81ee0006
   CONST MUIA_MonthNavigator_Input			= $81ee0009
   CONST MUIA_MonthNavigator_UseFrames			= $81ee000a
   CONST MUIA_MonthNavigator_ShowInvisibles		= $81ee000b
   CONST MUIA_MonthNavigator_WeekdayNamesSpacing	= $81ee000c
   CONST MUIA_MonthNavigator_WeekNumbersSpacing 	= $81ee000d
   CONST MUIA_MonthNavigator_LineWeekdayNames		= $81ee000e
   CONST MUIA_MonthNavigator_LineWeekNumbers		= $81ee000f
   CONST MUIA_MonthNavigator_Draggable			= $81ee0012
   CONST MUIA_MonthNavigator_MarkHook			= $81ee0013
   CONST MUIA_MonthNavigator_Dropable			= $81ee0014
   CONST MUIA_MonthNavigator_DragQueryHook		= $81ee0015
   CONST MUIA_MonthNavigator_DragDropHook		= $81ee0016
   CONST MUIA_MonthNavigator_ShowLastMonthDays		= $81ee0017
   CONST MUIA_MonthNavigator_ShowNextMonthDays		= $81ee0018
   CONST MUIA_MonthNavigator_MonthAdjust		= $81ee0019
   CONST MUIA_MonthNavigator_FixedTo6Rows		= $81ee0033
   CONST MUIA_MonthNavigator_Layout			= $81ee0034


   CONST MUIM_MonthNavigator_Update			= $81ee0010
   CONST MUIM_MonthNavigator_Mark			= $81ee0030
   CONST MUIM_MonthNavigator_DragQuery			= $81ee0031
   CONST MUIM_MonthNavigator_DragDrop			= $81ee0032

   CONST MUICFG_MonthNavigator_TodayUnderline		= $81ee002c
   CONST MUICFG_MonthNavigator_TodayBold		= $81ee002d
   CONST MUICFG_MonthNavigator_TodayItalic		= $81ee002e
   CONST MUICFG_MonthNavigator_TodayAlignment		= $81ee002f
   CONST MUICFG_MonthNavigator_TodayBackground		= $81ee001d
   CONST MUICFG_MonthNavigator_TodayPen 		= $81ee001e
   CONST MUICFG_MonthNavigator_TodayShortHelp		= $81ee001f


   OBJECT muip_monthnavigator_update
     methodid	: LONG
   ENDOBJECT

   OBJECT muip_monthnavigator_mark
     methodid	: LONG
     year	: LONG
     month	: LONG
     day	: LONG
     dayobj	: object
   ENDOBJECT

   OBJECT muip_monthnavigator_dragquery
     methodid	: LONG
     year	: LONG
     month	: LONG
     day	: LONG
     dayobj	: object
     obj	: object
   ENDOBJECT

   OBJECT muip_monthnavigator_dragdrop
     methodid	: LONG
     year	: LONG
     month	: LONG
     day	: LONG
     dayobj	: object
     obj	: object
   ENDOBJECT

   #define MUIV_MonthNavigator_InputMode_None		0
   #define MUIV_MonthNavigator_InputMode_RelVerify	1
   #define MUIV_MonthNavigator_InputMode_Immediate	2

   #define MUIV_MonthNavigator_Layout_American		0
   #define MUIV_MonthNavigator_Layout_European		1

   #define MUIV_MonthNavigator_ShowMDays_No		0
   #define MUIV_MonthNavigator_ShowMDays_OnlyFillUp	1
   #define MUIV_MonthNavigator_ShowMDays_Yes		2

   #define MUIV_MonthNavigator_MarkHook_HiToday 	1

   #define MUIV_MonthNavigator_MarkDay_Version		1
   OBJECT muis_monthnavigator_markday
     version	: LONG
     year	: LONG
     month	: INT
     day	: INT

     preparse	: PTR TO CHAR
     background : LONG
     shorthelp	: PTR TO CHAR
     disabled	: INT
   ENDOBJECT

 #endif
