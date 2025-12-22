/*
**
** Copyright © 1996-1997,1999 Dipl.-Inform. Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MonthNavigator_mcc.h 16.7 (12.12.99)
**
*/

 #ifndef MUI_MONTHNAVIGATOR_MCC_H
   #ifndef EXEC_TYPES_H
     #include <exec/types.h>
   #endif

   #define MUI_MONTHNAVIGATOR_MCC_H

   #define MUIC_MonthNavigator "MonthNavigator.mcc"
   #define MonthNavigatorObject	MUI_NewObject(MUIC_MonthNavigator

   #define MUIA_MonthNavigator_ShowWeekdayNames		0x81ee0005
   #define MUIA_MonthNavigator_ShowWeekNumbers		0x81ee0006
   #define MUIA_MonthNavigator_InputMode		0x81ee0009
   #define MUIA_MonthNavigator_UseFrames		0x81ee000a
   #define MUIA_MonthNavigator_ShowInvisibles		0x81ee000b
   #define MUIA_MonthNavigator_WeekdayNamesSpacing	0x81ee000c
   #define MUIA_MonthNavigator_WeekNumbersSpacing	0x81ee000d
   #define MUIA_MonthNavigator_LineWeekdayNames		0x81ee000e
   #define MUIA_MonthNavigator_LineWeekNumbers		0x81ee000f
   #define MUIA_MonthNavigator_Draggable		0x81ee0012
   #define MUIA_MonthNavigator_Dropable			0x81ee0014
   #define MUIA_MonthNavigator_ShowLastMonthDays	0x81ee0017
   #define MUIA_MonthNavigator_ShowNextMonthDays	0x81ee0018
   #define MUIA_MonthNavigator_MonthAdjust		0x81ee0019
   #define MUIA_MonthNavigator_FixedTo6Rows		0x81ee0033
   #define MUIA_MonthNavigator_Layout			0x81ee0034

   #define MUIM_MonthNavigator_Update			0x81ee0010
   #define MUIM_MonthNavigator_Mark			0x81ee0030
   #define MUIM_MonthNavigator_DragQuery		0x81ee0031
   #define MUIM_MonthNavigator_DragDrop			0x81ee0032

   struct MUIP_MonthNavigator_Update
    {
     ULONG MethodID;
    };
   struct MUIP_MonthNavigator_Mark
    {
     ULONG					 MethodID;
     LONG					 Year;
     ULONG					 Month;
     ULONG					 Day;
     Object					*dayobj;
    };
   struct MUIP_MonthNavigator_DragQuery
    {
     ULONG					 MethodID;
     LONG					 Year;
     ULONG					 Month;
     ULONG					 Day;
     Object					*dayobj;
     Object					*obj;
    };
   struct MUIP_MonthNavigator_DragDrop
    {
     ULONG					 MethodID;
     LONG					 Year;
     ULONG					 Month;
     ULONG					 Day;
     Object					*dayobj;
     Object					*obj;
    };

   #define MUIV_MonthNavigator_InputMode_None		0
   #define MUIV_MonthNavigator_InputMode_RelVerify	1
   #define MUIV_MonthNavigator_InputMode_Immediate	2

   #define MUIV_MonthNavigator_Layout_American		0
   #define MUIV_MonthNavigator_Layout_European		1

   #define MUIV_MonthNavigator_ShowMDays_No		0
   #define MUIV_MonthNavigator_ShowMDays_OnlyFillUp	1
   #define MUIV_MonthNavigator_ShowMDays_Yes		2

   #define MUICFG_MonthNavigator_TodayUnderline		0x81ee002c
   #define MUICFG_MonthNavigator_TodayBold		0x81ee002d
   #define MUICFG_MonthNavigator_TodayItalic		0x81ee002e
   #define MUICFG_MonthNavigator_TodayAlignment		0x81ee002f
   #define MUICFG_MonthNavigator_TodayBackground	0x81ee001d
   #define MUICFG_MonthNavigator_TodayPen		0x81ee001e
   #define MUICFG_MonthNavigator_TodayShortHelp		0x81ee001f

   #ifdef MUI_OBSOLETE
     #define MUIA_MonthNavigator_MarkHook	0x81ee0013
     #define MUIA_MonthNavigator_DragQueryHook	0x81ee0015
     #define MUIA_MonthNavigator_DragDropHook	0x81ee0016

     #define MUIV_MonthNavigator_MarkHook_HiToday	1
     #define MUIV_MonthNavigator_MarkDay_Version	1
     struct MUIS_MonthNavigator_MarkDay
      {
       ULONG	Version;
       LONG	Year;
       UWORD	Month;
       UWORD	Day;

       STRPTR	PreParse;
       ULONG	Background;
       STRPTR	ShortHelp;
       BOOL	Disabled;
      };
   #endif
 #endif
