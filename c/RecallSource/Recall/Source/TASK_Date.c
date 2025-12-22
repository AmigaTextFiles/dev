/*
 *	File:					TASK_Date.c
 *	Description:	Window for calendar
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_DATE_C
#define	TASK_DATE_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System_Prefs.h"
#include "MainMenu.h"
#include <clib/alib_stdio_protos.h>

/*** DEFINES *************************************************************************/
#define	DD_MM_YY					1
#define	MM_DD_YY					2
#define	YY_MM_DD					3

#define	DEFYEAR						1988	// 31
#define	DEFMONTH					8
#define	DEFYEAR2					1985	// 30
#define	DEFMONTH2					4
#define	DEFYEAR3					1988	// 29
#define	DEFMONTH3					2
#define	DEFDAY						0

#define	HOURBOT						-1
#define	HOURTOP						23
#define	MINUTEBOT					-1
#define	MINUTETOP					59

#define	GID_SUNDAY				100
#define	GID_MONDAY				101
#define	GID_TUESDAY				102
#define	GID_WEDNESDAY			103
#define	GID_THURSDAY			104
#define	GID_FRIDAY				105
#define	GID_SATURDAY			106
#define	GID_WHENDATE			107
#define	GID_MONTH					108
#define	GID_YEAR					109
#define	GID_DATEPERIOD		110
#define	GID_DATEREPEAT		111
#define	GID_WHENTIME			112
#define	GID_HOUR					113
#define	GID_MINUTES				114
#define	GID_TIMEPERIOD		115
#define	GID_TIMEREPEAT		116
#define GID_DATEPOPUP			117
#define	GID_DAY						118

/*** GLOBALS *************************************************************************/
struct egTask			dateTask;
struct DateNode		*datenode,
									*olddatenode,
									tmpdatenode;
struct Node				*datebuffer;
struct List				*datelist;
UBYTE							dateformat,
									dateformatsplit[2]=".\0";

char	*whencl[]={"","","",NULL},
			*monthcl[]={"","","","","","","","","","","","","",NULL};

WORD	lweekdayssize, rweekdayssize,
			timesize, periodsize, monthsize,
			dateMgroup, dateRgroup,
			daysize;

struct Gadget		*DSG=NULL;
struct egGadget	*whenstring,
								*whendate,
								*month,
								*year,
								*dateperiod,
								*daterepeat,
								*weekdaygadgets[7],
								*whentime,
								*hour,
								*minutes,
								*timeperiod,
								*timerepeat,
								*datetext,
								*datepopup,
								*dategroup,
								*weekgroup,
								*timegroup;

void UpdateCalendar(BYTE disable);

/*** FUNCTIONS ***********************************************************************/

__asm ULONG RenderDateTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message)
{
	geta4();
	{
		UWORD	periodwidth, tmp1, tmp2,
					integerwidth=egTextWidth(eg, "44444")+EG_StringBorder;
		BYTE	flag=(datenode==NULL),
					sundayfirst=(locale && !ISBITSET(locale->loc_CalendarType, CT_7MON));
		register BYTE		thickframe=!egIsDisplay(mainTask.screen, DIPF_IS_LACE);

#ifdef MYDEBUG_H
	DebugOut("RenderDateWindow");
#endif

		egCreateContext(eg, &dateTask);

		whenstring=egCreateGadget(eg,
									EG_Window,			dateTask.window,
									EG_GadgetKind,	TEXT_KIND,
									EG_TextAttr,		fontattr,
									EG_PlaceWindowLeft, TRUE,
									EG_PlaceWindowTop,	TRUE,
									EG_Flags,				0,
									EG_LeftEdge,		LeftMargin,
									EG_TopEdge,			TopMargin,
									EG_Width,				dateTask.window->Width-LeftMargin-RightMargin-EG_PopupWidth-1,
									EG_DefaultHeight,	TRUE,
									EG_GadgetText,	NULL,
									EG_GadgetID,		0,
									EG_HelpNode,		"Whenstring",
									GTTX_Border,		TRUE,
									GTTX_Text,			(datenode ? datenode->nn_Node.ln_Name: NULL),
									GA_Disabled,		flag,
									TAG_END);
		datepopup=egCreateGadget(eg,
									EG_GadgetKind,		EG_POPUP_KIND,
									EG_LeftEdge,			X2(whenstring)+1,
									EG_DefaultHeight,	TRUE,
									EG_DefaultWidth,	TRUE,
									EG_GadgetID,			GID_DATEPOPUP,
									EG_HelpNode,			"DatePopup",
									GA_Disabled,			(eventnode==NULL | DIRTYPE),
									TAG_END);

		/* DATEGROUP */
		periodwidth=egTextWidth(eg, egGetString(MSG__DATEPERIOD));
		whendate=egCreateGadget(eg,
									EG_GadgetKind,	CYCLE_KIND,
									EG_LeftEdge,		LeftMargin+GBL,
									EG_PlaceBelow,	whenstring,
									EG_VSpace,			GBT+GadDefHeight/2,
									EG_Width,				dateMgroup-GBL-GBR,
									EG_DefaultHeight,	TRUE,
									EG_GadgetText,	NULL,
									EG_GadgetID,		GID_WHENDATE,
									EG_HelpNode,		"Tuning",
									EG_VanillaKey,	egFindVanillaKey(egGetString(MSG__DATE)),
									GTCY_Labels,		whencl,
									GTCY_Active,		(datenode ? datenode->whendate: 0),
									GA_Disabled,		flag,
									TAG_END);
		dateperiod=egCreateGadget(eg,
									EG_GadgetKind,	INTEGER_KIND,
									EG_LeftEdge,		X1(whendate)+periodwidth+EG_LabelSpace,
									EG_PlaceWindowBottom,	TRUE,
									EG_VSpace,			-GBB,
									EG_Width,				integerwidth,
									EG_GadgetText,	egGetString(MSG__DATEPERIOD),
									EG_GadgetID,		GID_DATEPERIOD,
									EG_Flags,				PLACETEXT_LEFT,
									EG_HelpNode,		"Period",
									GTIN_MaxChars,	3,
									GTIN_Number,		(datenode ? datenode->dateperiod: 0),
									GA_Disabled,		(datenode ? (datenode->whendate==EXACT):TRUE),
									TAG_END);
		daterepeat=egCreateGadget(eg,
									EG_AlignRight,	whendate,
									EG_GadgetText,	egGetString(MSG__DATEREPEAT),
									EG_GadgetID,		GID_DATEREPEAT,
									GTIN_MaxChars,	3,
									GTIN_Number,		(datenode ? datenode->daterepeat: 0),
									EG_HelpNode,		"Repeat",
									GA_Disabled,		(datenode ? (datenode->whendate==EXACT):TRUE),
									TAG_END);
		month=egCreateGadget(eg,
									EG_GadgetKind,	CYCLE_KIND,
									EG_AlignLeft,		whendate,
									EG_GadgetText,	NULL,
									EG_PlaceOver,		dateperiod,
									EG_Width,				monthsize,
									EG_GadgetID,		GID_MONTH,
									EG_HelpNode,		"SetMonth",
									GTCY_Labels,		monthcl,
									GTCY_Active,		(datenode ? datenode->month: 0),
									GA_Disabled,		flag,
									TAG_END);
		year=egCreateGadget(eg,
									EG_GadgetKind,	INTEGER_KIND,
									EG_Width,				X2(whendate)-X2(month)-eg->HSpace,
									EG_AlignRight,	daterepeat,
									EG_GadgetID,		GID_YEAR,
									EG_HelpNode,		"SetYear",
									GTIN_MaxChars,	4,
									GTIN_Number,		(datenode ? datenode->year: 0),
									GA_Disabled,		flag,
									TAG_END);
		dategroup=egCreateGadget(eg,
									EG_GadgetKind,	EG_GROUP_KIND,
									EG_LeftEdge,		LeftMargin,
									EG_TopEdge,			tmp1=Y1(whendate)-GBT,
									EG_Width,				X2(whendate)+GBR-LeftMargin,
									EG_Height,			Y2(dateperiod)+GBB-tmp1,
									EG_Title,				egGetString(MSG__DATE),
									EG_ThickFrame,	thickframe,
									EG_Shadow,			TRUE,
									EG_Font,				font,
									TAG_DONE);

		weekdaygadgets[MONDAY]=egCreateGadget(eg,
									EG_GadgetKind,	CHECKBOX_KIND,
									EG_DefaultWidth,	TRUE,
									EG_DefaultHeight,	TRUE,
									EG_LeftEdge,		X2(datepopup)-dateRgroup+GBL,
									EG_AlignTop,		whendate,
									EG_GadgetText,	egGetString(MSG__MONDAY),
									EG_GadgetID,		GID_MONDAY,
									EG_Flags,				PLACETEXT_RIGHT,
									EG_HelpNode,		"SetWeekdays",
									GTCB_Checked,		(datenode ? ISBITSET(datenode->weekdays, FMONDAY): FALSE),
									GA_Disabled,		flag,
									TAG_END);
		weekdaygadgets[TUESDAY]=egCreateGadget(eg,
									EG_AlignLeft,		weekdaygadgets[MONDAY],
									EG_GadgetText,	egGetString(MSG__TUESDAY),
									EG_PlaceBelow,	weekdaygadgets[MONDAY],
									EG_GadgetID,		GID_TUESDAY,
									GTCB_Checked,		(datenode ? ISBITSET(datenode->weekdays, FTUESDAY): FALSE),
									GA_Disabled,		flag,
									TAG_END);
		weekdaygadgets[WEDNESDAY]=egCreateGadget(eg,
									EG_PlaceBelow,	weekdaygadgets[TUESDAY],
									EG_GadgetText,	egGetString(MSG__WEDNESDAY),
									EG_GadgetID,		GID_WEDNESDAY,
									GTCB_Checked,		(datenode ? ISBITSET(datenode->weekdays, FWEDNESDAY): FALSE),
									GA_Disabled,		flag,
									TAG_END);
		weekdaygadgets[THURSDAY]=egCreateGadget(eg,
									EG_PlaceBelow,	weekdaygadgets[WEDNESDAY],
									EG_GadgetText,	egGetString(MSG__THURSDAY),
									EG_GadgetID,		GID_THURSDAY,
									GTCB_Checked,		(datenode ? ISBITSET(datenode->weekdays, FTHURSDAY): FALSE),
									GA_Disabled,		flag,
									TAG_END);
		weekdaygadgets[FRIDAY]=egCreateGadget(eg,
									EG_AlignTop,		whendate,
									EG_LeftEdge,		X2(datepopup)-GBR-rweekdayssize-EG_LabelSpace-CheckboxWidth,
									EG_GadgetText,	egGetString(MSG__FRIDAY),
									EG_GadgetID,		GID_FRIDAY,
									GTCB_Checked,		(datenode ? ISBITSET(datenode->weekdays, FFRIDAY): FALSE),
									GA_Disabled,		flag,
									TAG_END);
		weekdaygadgets[SATURDAY]=egCreateGadget(eg,
									EG_PlaceBelow,	weekdaygadgets[FRIDAY],
									EG_GadgetText,	egGetString(MSG__SATURDAY),
									EG_GadgetID,		GID_SATURDAY,
									GTCB_Checked,		(datenode ? ISBITSET(datenode->weekdays, FSATURDAY): FALSE),
									GA_Disabled,		flag,
									TAG_END);
		weekdaygadgets[SUNDAY]=egCreateGadget(eg,
									EG_PlaceBelow,	weekdaygadgets[SATURDAY],
									EG_GadgetText,	egGetString(MSG__SUNDAY),
									EG_GadgetID,		GID_SUNDAY,
									GTCB_Checked,		(datenode ? ISBITSET(datenode->weekdays, FSUNDAY): FALSE),
									GA_Disabled,		flag,
									TAG_END);
		weekgroup=egCreateGadget(eg,
									EG_GadgetKind,	EG_GROUP_KIND,
									EG_LeftEdge,		tmp1=X1(weekdaygadgets[MONDAY])-GBL,
									EG_TopEdge,			tmp2=Y1(weekdaygadgets[MONDAY])-GBT,
									EG_Width,				X2(datepopup)-tmp1,
									EG_Height,			Y2(weekdaygadgets[THURSDAY])+GBB-tmp2,
									EG_Title,				egGetString(MSG_WEEKDAYS),
									EG_ThickFrame,	thickframe,
									EG_Shadow,			TRUE,
									EG_Font,				font,
									TAG_DONE);

		/* TIMEGROUP */
		timeperiod=egCreateGadget(eg,
									EG_GadgetKind,	INTEGER_KIND,
									EG_LeftEdge,		X1(weekdaygadgets[MONDAY])+periodwidth+EG_LabelSpace,
									EG_AlignTop,		dateperiod,
									EG_DefaultHeight,	TRUE,
									EG_Width,				integerwidth,
									EG_GadgetText,	egGetString(MSG__TIMEPERIOD),
									EG_GadgetID,		GID_TIMEPERIOD,
									EG_Flags,				0,
									EG_HelpNode,		"Period",
									GTIN_MaxChars,	3,
									GTIN_Number,		(datenode ? datenode->timeperiod: 0),
									GA_Disabled,		(datenode ? (datenode->whentime==EXACT):TRUE),
									TAG_END);
		timerepeat=egCreateGadget(eg,
									EG_AlignRight,	datepopup,
									EG_HSpace,			-GBR,
									EG_GadgetText,	egGetString(MSG__TIMEREPEAT),
									EG_GadgetID,		GID_TIMEREPEAT,
									EG_HelpNode,		"Repeat",
									GTIN_MaxChars,	3,
									GTIN_Number,		(datenode ? datenode->timerepeat: 0),
									GA_Disabled,		(datenode ? (datenode->whentime==EXACT):TRUE),
									TAG_END);
		minutes=egCreateGadget(eg,
									EG_GadgetKind,	SLIDER_KIND,
									EG_GadgetText,	egGetString(MSG__MINUTES),
									EG_Width,				X2(timerepeat)-timesize-EG_LabelSpace-X1(weekdaygadgets[MONDAY]),
									EG_DefaultHeight,	TRUE,
									EG_AlignRight,	timerepeat,
									EG_PlaceOver,		timerepeat,
									EG_GadgetID,		GID_MINUTES,
									EG_HelpNode,		"SetTime",
									GTSL_Min,				MINUTEBOT,
									GTSL_Max,				MINUTETOP,
									GTSL_Level,			(datenode ? datenode->minutes: MINUTEBOT),
									GA_Disabled,		flag,
									TAG_END);
		hour=egCreateGadget(eg,
									EG_PlaceOver,		minutes,
									EG_GadgetText,	egGetString(MSG__HOUR),
									EG_GadgetID,		GID_HOUR,
									GTSL_Min,				HOURBOT,
									GTSL_Max,				HOURTOP,
									GTSL_Level,			(datenode ? datenode->hour: HOURBOT),
									GA_Disabled,		flag,
									TAG_END);
		whentime=egCreateGadget(eg,
									EG_GadgetKind,	CYCLE_KIND,
									EG_AlignLeft,		weekdaygadgets[MONDAY],
									EG_Width,				X2(datepopup)-X1(weekdaygadgets[MONDAY])-GBR,
									EG_DefaultHeight,	TRUE,
									EG_PlaceOver,		hour,
									EG_GadgetText,	NULL,
									EG_GadgetID,		GID_WHENTIME,
									EG_HelpNode,		"Tuning",
									EG_VanillaKey,	egFindVanillaKey(egGetString(MSG__TIME)),
									GTCY_Labels,		whencl,
									GTCY_Active,		(datenode ? datenode->whentime: 0),
									GA_Disabled,		flag,
									TAG_END);
		timegroup=egCreateGadget(eg,
									EG_GadgetKind,	EG_GROUP_KIND,
									EG_LeftEdge,		X1(weekgroup),
									EG_TopEdge,			tmp1=Y1(whentime)-GBT,
									EG_Width,				W(weekgroup),
									EG_Height,			Y2(timeperiod)+GBB-tmp1,
									EG_Title,				egGetString(MSG__TIME),
									EG_ThickFrame,	thickframe,
									EG_Shadow,			TRUE,
									EG_Font,				font,
									TAG_DONE);
		{
			struct egGadget	*daygads[7];
			STRPTR days[7];
			register BYTE i;
			register WORD	ypos=Y2(whendate)+GadVSpace,
										pos[7],
										size[7];

			if(sundayfirst)
			{
				days[0]=egGetString(MSG_SUN);
				days[1]=egGetString(MSG_MON);
				days[2]=egGetString(MSG_TUE);
				days[3]=egGetString(MSG_WED);
				days[4]=egGetString(MSG_THU);
				days[5]=egGetString(MSG_FRI);
				days[6]=egGetString(MSG_SAT);
			}
			else
			{
				days[0]=egGetString(MSG_MON);
				days[1]=egGetString(MSG_TUE);
				days[2]=egGetString(MSG_WED);
				days[3]=egGetString(MSG_THU);
				days[4]=egGetString(MSG_FRI);
				days[5]=egGetString(MSG_SAT);
				days[6]=egGetString(MSG_SUN);
			}

			size[0]=size[1]=size[2]=size[3]=size[4]=size[5]=size[6]=daysize;
			egSpreadGadgets(pos, size, X1(whendate), X2(whendate), 7L, TRUE);

			for(i=0; i<7; i++)
				daygads[i]=egCreateGadget(eg,
																	EG_GadgetKind,			TEXT_KIND,
																	EG_GadgetText,			NULL,
																	EG_LeftEdge,				pos[i],
																	EG_TopEdge,					ypos,
																	EG_Width,						daysize,
																	EG_Height,					GadDefHeight,
																	GTTX_Text,					days[i],
																	GTTX_CopyText,			TRUE,
																	GTTX_Justification,	GTJ_CENTER,
																	TAG_DONE);
		}

		if(DSG=(struct Gadget *)NewObject(DSGClass, NULL,
						GA_Top,							tmp1=Y2(whendate)+GadVSpace+GadDefHeight,
						GA_Left,						X1(whendate),
						GA_Width,						W(whendate),
						GA_Height,					Y1(month)-GadVSpace-tmp1,
						GA_ID,							GID_DAY,
						ICA_TARGET,					ICTARGET_IDCMP,
						DSG_YEAR,						(datenode ? datenode->year : DEFYEAR),
						DSG_MONTH,					(datenode ? datenode->month: DEFMONTH),
						DSG_DAY,						(datenode ? datenode->day  : DEFDAY),
						DSG_TEXTFONT,				font,
						DSG_FIXEDPOSITION,	FALSE,
				    DSG_SUNDAYFIRST,		sundayfirst,
						GA_Disabled,				flag,
						TAG_DONE))
		{
     	AddGList(dateTask.window, DSG, -1, -1, NULL);
			RefreshGList(DSG, dateTask.window, NULL, 1);
		}

		return 1L;
	}
}

__asm ULONG CloseDateTask(register __a0 struct Hook *hook,
													register __a2 APTR	      object,
													register __a1 APTR	      message)
{
	geta4();

	if(DSG)
	{
		RemoveGList(dateTask.window, DSG, -1);
		DisposeObject(DSG);
		DSG=NULL;
	}

	return 1L;
}

__asm ULONG OpenDateTask(	register __a0 struct Hook *hook,
													register __a2 APTR	      object,
													register __a1 APTR	      message)
{
#ifdef MYDEBUG_H
	DebugOut("OpenDateTask");
#endif

	geta4();
	{
		WORD	minwidth, minheight, calendarsize, weekdayssize,
					integerwidth=egTextWidth(eg, "44444");


		whencl[0]=egGetString(MSG_EXACT);
		whencl[1]=egGetString(MSG_BEFORE);
		whencl[2]=egGetString(MSG_AFTER);

		monthcl[0]=egGetString(MSG_ANYMONTH);
		monthcl[1]=egGetString(MSG_JANUARY);
		monthcl[2]=egGetString(MSG_FEBRUARY);
		monthcl[3]=egGetString(MSG_MARCH);
		monthcl[4]=egGetString(MSG_APRIL);
		monthcl[5]=egGetString(MSG_MAY);
		monthcl[6]=egGetString(MSG_JUNE);
		monthcl[7]=egGetString(MSG_JULY);
		monthcl[8]=egGetString(MSG_AUGUST);
		monthcl[9]=egGetString(MSG_SEPTEMBER);
		monthcl[10]=egGetString(MSG_OCTOBER);
		monthcl[11]=egGetString(MSG_NOVEMBER);
		monthcl[12]=egGetString(MSG_DECEMBER);

		periodsize=	GBL+egTextWidth(eg, egGetString(MSG__DATEPERIOD))+
								egTextWidth(eg, egGetString(MSG__DATEREPEAT))+
								(integerwidth+EG_StringBorder+EG_LabelSpace)*2+GadHSpace+GBR;

		monthsize=egMaxLen(eg,	egGetString(MSG_ANYMONTH),
														egGetString(MSG_JANUARY),
														egGetString(MSG_FEBRUARY),
														egGetString(MSG_MARCH),
														egGetString(MSG_APRIL),
														egGetString(MSG_MAY),
														egGetString(MSG_JUNE),
														egGetString(MSG_JULY),
														egGetString(MSG_AUGUST),
														egGetString(MSG_SEPTEMBER),
														egGetString(MSG_OCTOBER),
														egGetString(MSG_NOVEMBER),
														egGetString(MSG_DECEMBER),
														NULL)+EG_CycleWidth;
		daysize=egMaxLen(eg,		egGetString(MSG_MON),
														egGetString(MSG_TUE),
														egGetString(MSG_WED),
														egGetString(MSG_THU),
														egGetString(MSG_FRI),
														egGetString(MSG_SAT),
														egGetString(MSG_SUN),
														NULL);
		daysize=MAX(daysize, (egTextWidth(eg, "0123456789")/10)*2+GadHInside);
		calendarsize=MAX(daysize*7, periodsize);
		dateMgroup=MAX(calendarsize, periodsize);
		dateMgroup=(dateMgroup/7)*7+GBL+GBR;

		lweekdayssize=egMaxLen(eg,	egGetString(MSG__MONDAY),
																egGetString(MSG__TUESDAY),
																egGetString(MSG__WEDNESDAY),
																egGetString(MSG__THURSDAY),
																NULL);
		rweekdayssize=egMaxLen(eg,	egGetString(MSG__FRIDAY),
																egGetString(MSG__SATURDAY),
																egGetString(MSG__SUNDAY),
																NULL);
		
		weekdayssize=GBL+CheckboxWidth+EG_LabelSpace+lweekdayssize+GadHSpace+
								 CheckboxWidth+EG_LabelSpace+rweekdayssize+GBR;
		dateRgroup=MAX(periodsize, weekdayssize);

		timesize=egMaxLen(eg,	egGetString(MSG__HOUR),
													egGetString(MSG__MINUTES),
													NULL);

		minwidth=LeftMargin+dateMgroup+LeftMargin+dateRgroup+RightMargin;
		minheight=GBT+GBB+TopMargin+BottomMargin2+GadDefHeight+FontHeight+
									MAX(GadDefHeight*10+GadVSpace*5,
											GBT+GBB+GadDefHeight*2+CheckboxHeight+SliderHeight*2+GadVSpace*9+FontHeight*2);

		if(egOpenTask(&dateTask,
											WA_Title,						egGetString(MSG_DATES),
											WA_Width,						minwidth,
											WA_Height,					minheight,
											WA_AutoAdjust,			TRUE,
											WA_Activate,				TRUE,
											WA_DragBar,					TRUE,
											WA_DepthGadget,			TRUE,
											WA_CloseGadget,			TRUE,
											WA_NewLookMenus,		TRUE,
											WA_SimpleRefresh,		env.simplerefresh,
											WA_MenuHelp,				TRUE,
											WA_PubScreen,				mainTask.screen,
											EG_LendMenu,				mainMenu,
											EG_IDCMP,						IDCMP_MENUPICK|
																					IDCMP_CLOSEWINDOW|
																					IDCMP_IDCMPUPDATE|
																					CHECKBOXIDCMP|
																					CYCLEIDCMP|
																					IDCMP_MOUSEMOVE|
																					IDCMP_MOUSEBUTTONS|
																					SLIDERIDCMP|
																					BUTTONIDCMP,
											EG_OpenFunc,				(ULONG)OpenDateTask,
											EG_CloseFunc,				(ULONG)CloseDateTask,
											EG_RenderFunc,			(ULONG)RenderDateTask,
											EG_HandleFunc,			(ULONG)HandleDateTask,
											EG_IconifyGadget,		TRUE,
											EG_InitialCentre,		TRUE,
											TAG_END))
		{
			olddatenode=NODATE;
			return TRUE;
		}
	}
	return FALSE;
}

__asm ULONG HandleDateTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message)
{
	UWORD id;
	struct IntuiMessage *msg;

	geta4();
	msg=(struct IntuiMessage *)hook->h_Data;

	switch(msg->Class)
	{
		case IDCMP_MENUPICK:
			HandleMainMenu(&dateTask, msg->Code);
			break;

		case IDCMP_CLOSEWINDOW:
			egCloseTask(&dateTask);
			break;

		case IDCMP_IDCMPUPDATE:
			switch(GetTagData(GA_ID, 0, msg->IAddress))
			{
				case GID_DAY:
					if(datenode)
					{
						ULONG day;

						GetAttr(DSG_DAY, DSG, &day);
						datenode->day=day;
						SetWhenString(datenode, TRUE);
					}
					break;
			}
			break;
		case IDCMP_MOUSEMOVE:
		case IDCMP_GADGETDOWN:
		case IDCMP_GADGETUP:
			switch(id=((struct Gadget *)msg->IAddress)->GadgetID)
			{
				case GID_DATEPOPUP:
					GetDateNode();
					break;
				case GID_HOUR:
					if(datenode->hour!=(short)msg->Code)
					{
						datenode->hour=(short)msg->Code;
						SetWhenString(datenode, TRUE);
					}
					break;
				case GID_MINUTES:
					if(datenode->minutes!=(short)msg->Code)
					{
						datenode->minutes=(short)msg->Code;
						SetWhenString(datenode, TRUE);
					}
					break;
				case GID_WHENTIME:
					datenode->whentime=msg->Code;
					UpdateWhentimeLinks(!datenode);
					SetWhenString(datenode, TRUE);
					break;
				case GID_TIMEPERIOD:
					datenode->timeperiod=Number(timeperiod);
					break;
				case GID_TIMEREPEAT:
					datenode->timerepeat=Number(timerepeat);
					break;
				case GID_WHENDATE:
					datenode->whendate=msg->Code;
					UpdateWhendateLinks(!datenode);
					SetWhenString(datenode, TRUE);
					break;
				case GID_MONTH:
					datenode->month=(short)msg->Code;
					UpdateCalendar(FALSE);
					SetWhenString(datenode, TRUE);
					break;
				case GID_YEAR:
					if(datenode->year!=Number(year))
					{
						datenode->year=Number(year);
						UpdateCalendar(FALSE);
						SetWhenString(datenode, TRUE);
					}
					break;
				case GID_DATEPERIOD:
					datenode->dateperiod=Number(dateperiod);
					break;
				case GID_DATEREPEAT:
					datenode->daterepeat=Number(daterepeat);
					break;
				case GID_SUNDAY:
					IFTRUESETBIT(msg->Code, datenode->weekdays, FSUNDAY);
					break;
				case GID_MONDAY:
					IFTRUESETBIT(msg->Code, datenode->weekdays, FMONDAY);
					break;
				case GID_TUESDAY:
					IFTRUESETBIT(msg->Code, datenode->weekdays, FTUESDAY);
					break;
				case GID_WEDNESDAY:
					IFTRUESETBIT(msg->Code, datenode->weekdays, FWEDNESDAY);
					break;
				case GID_THURSDAY:
					IFTRUESETBIT(msg->Code, datenode->weekdays, FTHURSDAY);
					break;
				case GID_FRIDAY:
					IFTRUESETBIT(msg->Code, datenode->weekdays, FFRIDAY);
					break;
				case GID_SATURDAY:
					IFTRUESETBIT(msg->Code, datenode->weekdays, FSATURDAY);
					break;
					break;
			}
			if(id!=GID_DATEPOPUP)
				++env.changes;
			break;
	}
	return 1L;
}

void GetFirstDate(void)
{
#ifdef MYDEBUG_H
	DebugOut("GetFirstDate");
#endif

	if(	eventnode &&
			(datelist=(eventnode->nn_Node.ln_Type==REC_DIR ? NULL:eventnode->datelist)) &&
			(datenode=(struct DateNode *)GetHead(datelist)))
		;
	else
	{
		datelist=NULL;
		datenode=NULL;
	}
}

void UpdateDateTask(void)
{
	if(dateTask.window)
	{
		register BYTE flag=(datenode==NULL);
		register BYTE i,j;

		if(olddatenode!=datenode)
		{
		if(flag)
		{
//			if(ISBITCLEARED(dateTask.flags, TASK_BLOCKED))
//				egLockTask(&dateTask, TAG_DONE);
			memset(&tmpdatenode, 0, sizeof(struct DateNode));
			tmpdatenode.hour		=HOURBOT;
			tmpdatenode.minutes	=MINUTEBOT;
		}
		else
		{
//			if(ISBITSET(dateTask.flags, TASK_BLOCKED))
//				egUnlockTask(&dateTask, TAG_DONE);
			CopyMem(datenode, &tmpdatenode, sizeof(struct DateNode));
		}

//		if(ISBITCLEARED(dateTask.flags, TASK_BLOCKED))
			{
				if(tmpdatenode.weekdays!=(flag ? tmpdatenode.weekdays:datenode->weekdays))
					for(i=0, j=1; i<7; i++, j*=2)
						egSetGadgetAttrs(	weekdaygadgets[i], dateTask.window, NULL,
															GTCB_Checked,	ISBITSET(tmpdatenode.weekdays, j),
															GA_Disabled,	flag,
															TAG_DONE);

				egSetGadgetAttrs(whenstring, dateTask.window, NULL,
													GTTX_Text,	tmpdatenode.nn_Node.ln_Name,
													TAG_DONE);

				egSetGadgetAttrs(datepopup, dateTask.window, NULL,
														GA_Disabled,	(eventnode==NULL | DIRTYPE),
														TAG_DONE);

				egSetGadgetAttrs(whendate, dateTask.window, NULL,
														GA_Disabled,	flag,
														GTCY_Active,	tmpdatenode.whendate,
														TAG_DONE);
				egSetGadgetAttrs(whentime, dateTask.window, NULL,
														GA_Disabled,	flag,
														GTCY_Active,	tmpdatenode.whentime,
														TAG_DONE);
				egSetGadgetAttrs(hour, dateTask.window, NULL,
														GTSL_Level,		tmpdatenode.hour,
														GA_Disabled,	flag,
														TAG_DONE);
				egSetGadgetAttrs(minutes, dateTask.window, NULL,
														GTSL_Level,		tmpdatenode.minutes,
														GA_Disabled,	flag,
														TAG_DONE);
				egSetGadgetAttrs(month, dateTask.window, NULL,
														GTCY_Active,	tmpdatenode.month,
														GA_Disabled,	flag,
														TAG_DONE);
				egSetGadgetAttrs(year, dateTask.window, NULL,
														GTIN_Number,	tmpdatenode.year,
														GA_Disabled,	flag,
														TAG_DONE);
				UpdateCalendar(flag);
				UpdateWhendateLinks(flag);
				UpdateWhentimeLinks(flag);
			}
			olddatenode=datenode;
		}
	}
}

void UpdateCalendar(BYTE disable)
{
	if(DSG && olddatenode!=datenode)
	{
		register WORD year=DEFYEAR, month=DEFMONTH, day=DEFDAY;

		if(datenode)
		{
			if(tmpdatenode.year>1977 && tmpdatenode.year<2100)
				year=tmpdatenode.year;
			if(tmpdatenode.month>0 && tmpdatenode.month<13)
				month=tmpdatenode.month;
			day=tmpdatenode.day;

			if(year==DEFYEAR & month!=DEFMONTH)
				switch(month)
				{
					case 1:
					case 3:
					case 5:
					case 7:
					case 8:
					case 10:
					case 12:
						year=DEFYEAR;
						month=DEFMONTH;
						break;
					case 2:
						year=DEFYEAR3;
						month=DEFMONTH3;
						break;
					default:
						year=DEFYEAR2;
						month=DEFMONTH2;
						break;
				}
			else if((year==DEFYEAR & month==DEFMONTH) | (year!=DEFYEAR & month==DEFMONTH))
			{
				year=DEFYEAR;
				month=DEFMONTH;
			}
		}

		{
			ULONG	oldday, oldmonth, oldyear;
			register BYTE		olddisable=ISBITSET(DSG->Flags, GFLG_DISABLED);

			GetAttr(DSG_DAY,	DSG, &oldday);
			GetAttr(DSG_MONTH,DSG, &oldmonth);
			GetAttr(DSG_YEAR,	DSG, &oldyear);

			if(oldday!=day | oldmonth!=month | oldyear!=year | disable!=olddisable)
				SetGadgetAttrs(	DSG, dateTask.window, NULL,
												DSG_DAY,			day,
												DSG_MONTH,		month,
												DSG_YEAR,			year,
												GA_Disabled,	disable,
												TAG_DONE);
		}
	}
}

void UpdateWhendateLinks(BYTE flag)
{
	egSetGadgetAttrs(dateperiod, dateTask.window, NULL,
											GTIN_Number,	tmpdatenode.dateperiod,
											GA_Disabled,	flag ? TRUE: tmpdatenode.whendate==EXACT,
											TAG_DONE);
	egSetGadgetAttrs(daterepeat, dateTask.window, NULL,
											GTIN_Number,	tmpdatenode.daterepeat,
											GA_Disabled,	flag ? TRUE: tmpdatenode.whendate==EXACT,
											TAG_DONE);
}

void UpdateWhentimeLinks(BYTE flag)
{
	egSetGadgetAttrs(timeperiod, dateTask.window, NULL,
											GTIN_Number,	tmpdatenode.timeperiod,
											GA_Disabled,	flag ? TRUE: tmpdatenode.whentime==EXACT,
											TAG_DONE);
	egSetGadgetAttrs(timerepeat, dateTask.window, NULL,
											GTIN_Number,	tmpdatenode.timerepeat,
											GA_Disabled,	flag ? TRUE: tmpdatenode.whentime==EXACT,
											TAG_DONE);
}

void SetWhenString(struct DateNode *datenode, BYTE update)
{
	register char datestring[60], tmp[30];

	if(datenode)
	{
		if(datenode->day==0 && datenode->month==0 && datenode->year==0)
			sprintf(datestring, "%s - ", egGetString(MSG_DAILY));
		else
		{
			register char day[3], month[3], year[5];
			STRPTR dateformatstring="%s %s%s%s%s%s - ";

			sprintf(day, (datenode->day==0 ? "**" : "%02ld"), datenode->day);
			sprintf(month, (datenode->month==0 ? "**": "%02ld"), datenode->month);

			if(datenode->year>999)
				sprintf(year,"%ld",datenode->year);
			else if(datenode->year==0)
				strcpy(year,"****");
			else if(datenode->year<10)
				sprintf(year,"***%ld",datenode->year);
			else if(datenode->year<100)
				sprintf(year,"**%ld",datenode->year);
			else
				sprintf(year,"*%ld",datenode->year);

			switch(dateformat)
			{
				case DD_MM_YY:
					sprintf(datestring, dateformatstring, whencl[datenode->whendate],
																								day,
																								dateformatsplit,
																								month,
																								dateformatsplit,
																								year);
					break;
				case MM_DD_YY:
					sprintf(datestring, dateformatstring, whencl[datenode->whendate],
																								month,
																								dateformatsplit,
																								day,
																								dateformatsplit,
																								year);
					break;
				case YY_MM_DD:
					sprintf(datestring, dateformatstring, whencl[datenode->whendate],
																								year,
																								dateformatsplit,
																								month,
																								dateformatsplit,
																								day);
					break;
			}
		}

		if(datenode->hour==NONE && datenode->minutes==NONE)
			sprintf(tmp, "%s", egGetString(MSG_ALLDAY));
		else
		{
			register char hh[3], mm[3];

			sprintf(hh,(datenode->hour==NONE ? "**": "%02ld") ,datenode->hour);
			sprintf(mm, (datenode->minutes==NONE ? "**" : "%02ld"), datenode->minutes);
			sprintf(tmp, "%s %s:%s", whencl[datenode->whentime], hh, mm);
		}
		RenameNode((struct Node *)datenode, strcat(datestring, tmp));

		if(update)
			egSetGadgetAttrs(whenstring, dateTask.window, NULL,
												GTTX_Text, datestring,
												TAG_DONE);
	}
}

ULONG datehelp(struct Hook *hook, VOID *o, VOID *m)
{
	struct IntuiMessage *msg;

	geta4();

	msg=(struct IntuiMessage *)hook->h_Data;
	if(msg->Class==IDCMP_RAWKEY & msg->Code==95)
		if(egShowAmigaGuide(eg, "DateWindow"))
		{
		 	ULONG signal=Wait(eg->AmigaGuideSignal);

			if(signal & eg->AmigaGuideSignal)
				egHandleAmigaGuide(eg);
		}
	return 1;
}

void GetDateNode(void)
{
	struct ListviewRequester	*datereq;

	if(datereq=mrAllocRequest(MR_ListviewRequest,
								MR_Window,					dateTask.window,
								MR_TextAttr,				mainTask.screen->Font,
								MRLV_DropDown,			TRUE,
								MR_Gadgets,					egGetString(MSG_DATEPOPUPGADGETS),
								MR_SimpleRefresh,		TRUE,
								TAG_DONE))
	{
		register UWORD ret, oldselectednum=datereq->selectednum;
		register struct Node *oldnode=datereq->selectednode;

		ret=mrRequest(datereq,
								MR_InitialLeftEdge,	dateTask.window->LeftEdge+LeftMargin,
								MR_InitialTopEdge,	dateTask.window->TopEdge+Y2(whenstring),
								MR_InitialWidth,		W(whenstring)+EG_PopupWidth+1,
								MR_InitialPercentV,	20,
								MRLV_Labels,				datelist,
								MR_IntuiMsgFunc,		datehelp,
								TAG_DONE);
		if(ret==0)
		{
			datereq->selectednum=oldselectednum;
			datereq->selectednode=oldnode;
			return;
		}

		if(datereq->selectednode)
			datenode=(struct DateNode *)datereq->selectednode;
		switch(ret)
		{
			case 2:
				NewDate();
				datereq->selectednum=Count(datelist)-1;
				break;
			case 3:
				break;
			case 4:
				CutDate();
				break;
			case 5:
				PasteDate();
				break;
		}
		UpdateDateTask();

		mrFreeRequest(datereq);
	}
	else
		FailRequest(textTask.window, MSG_OUTOFMEMORY, NULL);
}

void NewDate(void)
{
	char newdate[MAXCHARS];

	sprintf(newdate, "%s - %s", egGetString(MSG_DAILY), egGetString(MSG_ALLDAY));
	datenode=AddDateNode(datelist, NULL, newdate);
	++env.changes;
}

void CopyDate(void)
{
	if(datenode)
	{
		datenode=(struct DateNode *)CutNode(datelist, &datebuffer, datenode);
		++env.changes;
	}
}

void CutDate(void)
{
	if(datenode)
		CopyNode(datelist, &datebuffer, (struct Node *)datenode);
}

void PasteDate(void)
{
	if(datebuffer!=NULL)
	{
		datenode=(struct DateNode *)PasteNode(datelist, datebuffer, datenode);
		++env.changes;
	}
}
#endif
