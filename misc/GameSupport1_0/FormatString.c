#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/locale.h>
#include <proto/utility.h>

#include "Global.h"

/************************************************************************/

struct String
{
  char *String;
  ULONG Length;
  ULONG Index;
};

/************************************************************************/

#include "StaticSavedsAsmD0A3.h"
#include "StaticSavedsAsmA0A1.h"

/************************************************************************/
/*									*/
/* Interface RawDoFmt() to a Hook function				*/
/*									*/
/************************************************************************/

STATIC_SAVEDS_ASM_D0A3(void,Raw_Hook,char,c,struct Hook *,Hook)

{
  CallHookPkt(Hook,NULL,(APTR)c);
}


/************************************************************************/
/*									*/
/* Output a character into the self-extending string			*/
/*									*/
/************************************************************************/

STATIC_SAVEDS_ASM_A0A1(void,Hook_OutputChar_String,struct Hook *,Hook,char,c)

{
  struct String *String;

  String=(struct String *)Hook->h_Data;
  if (String->Index==String->Length)
    {
      char *NewString;

      if ((NewString=GS_MemoryAlloc(String->Length+128)))
	{
	  if (String->String)
	    {
	      CopyMemQuick(String->String,NewString,String->Length);
	    }
	}
      GS_MemoryFree(String->String);
      String->String=NewString;
      String->Length+=128;
    }
  if (String->String)
    {
      String->String[String->Index++]=c;
    }
}

/************************************************************************/
/*									*/
/* Render a character into a rastport					*/
/*									*/
/************************************************************************/

STATIC_SAVEDS_ASM_A0A1(void,Hook_OutputChar_Draw,struct Hook *,Hook,char,c)

{
#ifndef __GNUC__
  char t;

  if ((t=c))
    {
      Text((struct RastPort *)Hook->h_Data,&t,1);
    }
#else
  if (c)
    {
      Text((struct RastPort *)Hook->h_Data,&c,1);
    }
#endif
}

/************************************************************************/
/*									*/
/* Measure the width of a character					*/
/*									*/
/************************************************************************/

STATIC_SAVEDS_ASM_A0A1(void,Hook_OutputChar_Width,struct Hook *,Hook,char,c)

{
#ifndef __GNUC__
  char t;

  if ((t=c))
    {
      Hook->h_SubEntry=(ULONG (*)())(((ULONG)Hook->h_SubEntry)+TextLength((struct RastPort *)Hook->h_Data,&t,1));
    }
#else
  if (c)
    {
      Hook->h_SubEntry=(ULONG (*)())(((ULONG)Hook->h_SubEntry)+TextLength((struct RastPort *)Hook->h_Data,&c,1));
    }
#endif
}

/****** gamesupport.library/GS_FormatString ******************************
*
*    NAME
*	GS_FormatString -- sprintf() with unlimited string size
*
*    SYNOPSIS
*	String = GS_FormatString(FormatString, Parameters, Length, Locale)
*	  d0                         a0            a1        a2      a3
*
*	char *GS_FormatString(const char *, const void *, ULONG *,
*	                      const struct Locale *);
*
*    FUNCTION
*	This function works like sprintf(), but it creates it's own
*	string. Therefore the length of the resulting string is not
*	limited.
*
*    INPUTS
*	FormatString - A format string for FormatString()
*	Parameters   - The parameter list
*	Length       - Optional pointer to an ULONG receiving strlen()
*	Locale       - A pointer to a locale
*
*    NOTE
*	If Locale==NULL or locale.library could not be opened,
*	RawDoFmt() will be used to format the string.
*
*    RESULT
*	String - the resulting string, or NULL if not enough memory.
*	         Call GS_MemoryFree() to free the string.
*
*************************************************************************/

SAVEDS_ASM_A0A1A2A3(char *,LibGS_FormatString,char *,Template,void *,Parameters,ULONG *,Length,struct Locale *,Locale)

{
  struct String String;
  struct Hook Hook;

  String.String=NULL;
  String.Length=0;
  String.Index=0;
  Hook.h_Data=&String;
  Hook.h_Entry=(ULONG (*)())Hook_OutputChar_String;
  if (Locale!=NULL && LocaleBase!=NULL)
    {
      FormatString(Locale,Template,Parameters,&Hook);
    }
  else
    {
      RawDoFmt(Template,Parameters,Raw_Hook,&Hook);
    }
  if (Length && String.String)
    {
      *Length=String.Index-1;
    }
  return String.String;
}

/************************************************************************/
/*									*/
/* Format a date if locale.library is not available			*/
/*									*/
/************************************************************************/

void MyFormatDate(const char *Template, ULONG TimeStamp, struct Hook *Hook)

{
  struct ClockData ClockData;

  Amiga2Date(TimeStamp,&ClockData);
  if (Template!=NULL)
    {
      do
	{
	  if (*Template=='%')
	    {
	      Template++;
	      switch (*Template)
		{
		case 'a':
		  {
		    char *t;

		    t="SunMonTueWedThuFriSat"+3*ClockData.wday;
		    RawDoFmt("%3.3s",&t,Raw_Hook,Hook);
		  }
		  break;

		case 'A':
		  {
		    static char *Weekday[7]=
		      {
			"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
		      };

		    RawDoFmt("%s",&Weekday[ClockData.wday],Raw_Hook,Hook);
		  }
		  break;

		case 'b':
		case 'h':
		  {
		    char *t;

		    t="JanFebMarAprMayJunJulAugSepOctNovDec"+3*(ClockData.month-1);
		    RawDoFmt("%3.3s",&t,Raw_Hook,Hook);
		  }
		  break;

		case 'B':
		  {
		    static char *Month[12]=
		      {
			"January", "February", "March", "April", "May", "June", "July",
			"August","September", "October", "November", "December"
		      };

		    RawDoFmt("%s",&Month[ClockData.month-1],Raw_Hook,Hook);
		  }
		  break;

		case 'c':
		  MyFormatDate("%a %b %d %H:%M:%S:%Y",TimeStamp,Hook);
		  break;

		case 'C':
		  MyFormatDate("%a %b %e %T %Z %Y",TimeStamp,Hook);
		  break;

		case 'd':
		  RawDoFmt("%02u",&ClockData.mday,Raw_Hook,Hook);
		  break;

		case 'D':
		case 'x':
		  MyFormatDate("%m/%d/%y",TimeStamp,Hook);
		  break;

		case 'e':
		  RawDoFmt("%2u",&ClockData.mday,Raw_Hook,Hook);
		  break;

		case 'H':
		  RawDoFmt("%02u",&ClockData.hour,Raw_Hook,Hook);
		  break;

		case 'I':
		  {
		    UWORD Hour;

		    Hour=ClockData.hour;
		    if (Hour>12)
		      {
			Hour-=12;
		      }
		    else if (Hour==0)
		      {
			Hour=12;
		      }
		    RawDoFmt("%02u",&Hour,Raw_Hook,Hook);
		  }
		  break;

		case 'm':
		  RawDoFmt("%02u",&ClockData.month,Raw_Hook,Hook);
		  break;

		case 'M':
		  RawDoFmt("%02u",&ClockData.min,Raw_Hook,Hook);
		  break;

		case 'n':
		  CallHookPkt(Hook,NULL,(APTR)'\n');
		  break;

		case 'p':
		  RawDoFmt((ClockData.hour<12 ? "AM" : "PM"),NULL,Raw_Hook,Hook);
		  break;

		case 'q':
		  RawDoFmt("%u",&ClockData.hour,Raw_Hook,Hook);
		  break;

		case 'Q':
		  {
		    UWORD Hour;

		    Hour=ClockData.hour;
		    if (Hour>12)
		      {
			Hour-=12;
		      }
		    else if (Hour==0)
		      {
			Hour=12;
		      }
		    RawDoFmt("%u",&Hour,Raw_Hook,Hook);
		  }
		  break;

		case 'r':
		  MyFormatDate("%I:%M:%S %p",TimeStamp,Hook);
		  break;

		case 'R':
		  MyFormatDate("%H:%M",TimeStamp,Hook);
		  break;

		case 'S':
		  RawDoFmt("%02u",&ClockData.sec,Raw_Hook,Hook);
		  break;

		case 't':
		  CallHookPkt(Hook,NULL,(APTR)'\t');
		  break;

		case 'T':
		case 'X':
		  MyFormatDate("%H:%M:%S",TimeStamp,Hook);
		  break;

		case 'w':
		  RawDoFmt("%u",&ClockData.wday,Raw_Hook,Hook);
		  break;

		case 'y':
		  {
		    UWORD Year;

		    Year=ClockData.year%100;
		    RawDoFmt("%02u",&Year,Raw_Hook,Hook);
		  }
		  break;

		case 'Y':
		  RawDoFmt("%04u",&ClockData.year,Raw_Hook,Hook);
		  break;

		case '\0':
		  Template--;
		  /* fall through */

		default:
		  CallHookPkt(Hook,NULL,(APTR)*Template);
		}
	    }
	  else
	    {
	      CallHookPkt(Hook,NULL,(APTR)*Template);
	    }
	  Template++;
	}
      while (*Template!='\0');
    }
  CallHookPkt(Hook,NULL,(APTR)'\0');
}

/****** gamesupport.library/GS_FormatDate ********************************
*
*    NAME
*	GS_FormatDate -- FormatDate() with unlimited string size
*
*    SYNOPSIS
*	String = GS_FormatDate(Template, TimeStamp, Length, Locale)
*	  d0                      a0         d0       a1      a2
*
*	char *GS_FormatDate(const char *, ULONG, ULONG *,
*	                    const struct Locale *);
*
*    FUNCTION
*	This function prints a date/time to a string.
*
*    INPUTS
*	Locale    - A pointer to a locale
*	Template  - A format string for FormatDate()
*	TimeStamp - The date/time to output
*
*    NOTE
*	If Locale==NULL or locale.library could not be opened,
*	a builtin formatter will be used to format the date.
*	The following commands are supported by this formatter:
*	%a %A %b %B %c %C %d %D %e %h %H %I %m %M %n %p %q %Q
*	%r %R %S %t %T %w %x %X %y %Y
*
*    RESULT
*	String - the resulting string, or NULL if not enough memory.
*	         Call GS_MemoryFree() to free the string.
*
*************************************************************************/

SAVEDS_ASM_D0A0A1A2(char *,LibGS_FormatDate,ULONG,TimeStamp,char *,Template,ULONG *,Length,struct Locale *,Locale)

{
  struct String String;
  struct Hook Hook;

  String.String=NULL;
  String.Length=0;
  String.Index=0;
  Hook.h_Data=&String;
  Hook.h_Entry=(ULONG (*)())Hook_OutputChar_String;
  if (Locale!=NULL && LocaleBase!=NULL)
    {
      struct DateStamp DateStamp;

      DateStamp.ds_Days=TimeStamp/(60*60*24);
      TimeStamp=TimeStamp%(60*60*24);
      DateStamp.ds_Minute=TimeStamp/60;
      TimeStamp=TimeStamp%60;
      DateStamp.ds_Tick=TimeStamp*TICKS_PER_SECOND;
      FormatDate(Locale,Template,&DateStamp,&Hook);
    }
  else
    {
      MyFormatDate(Template,TimeStamp,&Hook);
    }
  if (Length && String.String)
    {
      *Length=String.Index-1;
    }
  return String.String;
}

/****** gamesupport.library/GS_DrawString ********************************
*
*    NAME
*	GS_DrawString -- draw a string into a rastport
*
*    SYNOPSIS
*	GS_DrawString(Template, Parameters, RastPort, Locale)
*	                a0          a1        a2        a3
*
*	void GS_DrawString(const char *, const void *, struct RastPort *,
*	                   const struct Locale *);
*
*    FUNCTION
*	Draw a string into a rastport, using a formatting template.
*
*    INPUTS
*	Template     - the formatting template for FormatString()
*	Parameters   - the parameter list
*	RastPort     - the destination rastport
*	Locale       - the locale to use
*
*    NOTE
*	If Locale==NULL or locale.library could not be opened,
*	RawDoFmt() will be used to format the string.
*
*************************************************************************/

SAVEDS_ASM_A0A1A2A3(void,LibGS_DrawString,char *,Template,void *,Parameters,struct RastPort *,RastPort,struct Locale *,Locale)

{
  struct Hook Hook;

  Hook.h_Data=RastPort;
  Hook.h_Entry=(ULONG (*)())Hook_OutputChar_Draw;
  if (Locale!=NULL && LocaleBase!=NULL)
    {
      FormatString(Locale,Template,Parameters,&Hook);
    }
  else
    {
      RawDoFmt(Template,Parameters,Raw_Hook,&Hook);
    }
}

/****** gamesupport.library/GS_DrawDate **********************************
*
*    NAME
*	GS_DrawDate -- draw a date into a rastport
*
*    SYNOPSIS
*	GS_DrawString(Template, TimeStamp, RastPort, Locale)
*	                a0          d0        a1       a2
*
*	void GS_DrawDate(const char *, ULONG, struct RastPort *,
*	                 const struct Locale *);
*
*    FUNCTION
*	Draw a date into a rastport.
*
*    INPUTS
*	Template     - the formatting template for FormatDate()
*	TimeStamp    - the time/date
*	RastPort     - the destination rastport
*	Locale       - the locale to use
*
*    NOTE
*	If Locale==NULL or locale.library could not be opened,
*	a builtin formatter will be used to format the date.
*	The following commands are supported by this formatter:
*	%a %A %b %B %c %C %d %D %e %h %H %I %m %M %n %p %q %Q
*	%r %R %S %t %T %w %x %X %y %Y
*
*************************************************************************/

SAVEDS_ASM_D0A0A1A2(void,LibGS_DrawDate,ULONG,TimeStamp,char *,Template,struct RastPort *,RastPort,struct Locale *,Locale)

{
  struct Hook Hook;

  Hook.h_Data=RastPort;
  Hook.h_Entry=(ULONG (*)())Hook_OutputChar_Draw;
  if (Locale!=NULL && LocaleBase!=NULL)
    {
      struct DateStamp DateStamp;

      DateStamp.ds_Days=TimeStamp/(60*60*24);
      TimeStamp=TimeStamp%(60*60*24);
      DateStamp.ds_Minute=TimeStamp/60;
      TimeStamp=TimeStamp%60;
      DateStamp.ds_Tick=TimeStamp*TICKS_PER_SECOND;
      FormatDate(Locale,Template,&DateStamp,&Hook);
    }
  else
    {
      MyFormatDate(Template,TimeStamp,&Hook);
    }
}

/****** gamesupport.library/GS_StringWidth *******************************
*
*    NAME
*	GS_StringWidth -- measure pixel width of a string
*
*    SYNOPSIS
*	Width = GS_StringWidth(Template, Parameters, RastPort, Locale)
*	 d0                      a0          a1        a2        a3
*
*	WORD GS_StringWidth(const char *, const void *, struct RastPort *,
*	                    const struct Locale *);
*
*    FUNCTION
*	Measure the width of the resulting string.
*
*    INPUTS
*	Template     - the formatting template for FormatString()
*	Parameters   - the parameter list
*	RastPort     - the destination rastport
*	Locale       - the locale to use
*
*    NOTE
*	If Locale==NULL or locale.library could not be opened,
*	RawDoFmt() will be used to format the string.
*
*************************************************************************/

SAVEDS_ASM_A0A1A2A3(WORD,LibGS_StringWidth,char *,Template,void *,Parameters,struct RastPort *,RastPort,struct Locale *,Locale)

{
  struct Hook Hook;

  Hook.h_Data=RastPort;
  Hook.h_Entry=(ULONG (*)())Hook_OutputChar_Width;
  Hook.h_SubEntry=0;
  if (Locale!=NULL && LocaleBase!=NULL)
    {
      FormatString(Locale,Template,Parameters,&Hook);
    }
  else
    {
      RawDoFmt(Template,Parameters,Raw_Hook,&Hook);
    }
  return (WORD)Hook.h_SubEntry;
}

/****** gamesupport.library/GS_DateWidth *********************************
*
*    NAME
*	GS_DateWidth -- measure pixel width of a date
*
*    SYNOPSIS
*	Width = GS_DateWidth(Template, TimeStamp, RastPort, Locale)
*	 d0                    a0          d0        a1       a2
*
*	WORD GS_DateWidth(const char *, ULONG, struct RastPort *,
*	                  const struct Locale *);
*
*    FUNCTION
*	Measure the pixel width of a date.
*
*    INPUTS
*	Template     - the formatting template for FormatDate()
*	TimeStamp    - the time/date
*	RastPort     - the destination rastport
*	Locale       - the locale to use
*
*    NOTE
*	If Locale==NULL or locale.library could not be opened,
*	a builtin formatter will be used to format the date.
*	The following commands are supported by this formatter:
*	%a %A %b %B %c %C %d %D %e %h %H %I %m %M %n %p %q %Q
*	%r %R %S %t %T %w %x %X %y %Y
*
*************************************************************************/

SAVEDS_ASM_D0A0A1A2(WORD,LibGS_DateWidth,ULONG,TimeStamp,char *,Template,struct RastPort *,RastPort,struct Locale *,Locale)

{
  struct Hook Hook;

  Hook.h_Data=RastPort;
  Hook.h_Entry=(ULONG (*)())Hook_OutputChar_Width;
  Hook.h_SubEntry=0;
  if (Locale!=NULL && LocaleBase!=NULL)
    {
      struct DateStamp DateStamp;

      DateStamp.ds_Days=TimeStamp/(60*60*24);
      TimeStamp=TimeStamp%(60*60*24);
      DateStamp.ds_Minute=TimeStamp/60;
      TimeStamp=TimeStamp%60;
      DateStamp.ds_Tick=TimeStamp*TICKS_PER_SECOND;
      FormatDate(Locale,Template,&DateStamp,&Hook);
    }
  else
    {
      MyFormatDate(Template,TimeStamp,&Hook);
    }
  return (WORD)Hook.h_SubEntry;
}
