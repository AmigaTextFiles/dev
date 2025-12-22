#include <exec/types.h>
#include <libraries/locale.h>
#include <utility/hooks.h>

APTR               MultiDesktopBase;
struct LocaleBase *LocaleBase;
struct Locale     *Locale;

/* ---- Hook-Zeichenkopierroutine */
ULONG CopyProc(hook,obj,msg)
 struct Hook *hook;
 ULONG        obj;
 ULONG        msg;
{
 UBYTE *buffer;

 buffer=hook->h_Data;
 buffer[0]=(UBYTE)msg;
 hook->h_Data=(ULONG)buffer+1L;
}

/* ---- String-Formatierung */
void LocaleSFormat(buffer,formatString,args)
 UBYTE *buffer;
 UBYTE *formatString;
 ULONG *args;
{
 struct Hook hook;

 if(Locale!=NULL)
  {
   InitHook(&hook,CopyProc,buffer);
   FormatString(Locale,formatString,args,&hook);
  }
 else
   strcpy(buffer,"«No Locale V38!»");
}

/* ---- Datums-Formatierung */
void LocaleDFormat(buffer,formatString,date)
 UBYTE            *buffer;
 UBYTE            *formatString;
 struct DateStamp *date;
{
 struct Hook hook;

 if(Locale!=NULL)
  {
   InitHook(&hook,CopyProc,buffer);
   FormatDate(Locale,formatString,date,&hook);
  }
 else
   strcpy(buffer,"«No Locale V38»");
}

void main()
{
 ULONG array[5];
 UBYTE str[512];
 struct DateStamp ds;

 DateStamp(&ds);
 MultiDesktopBase=OpenLibrary("multidesktop.library",0L);
 if(MultiDesktopBase!=NULL) {
 LocaleBase=OpenLibrary("locale.library",38);
 if(LocaleBase)
  {
   Locale=OpenLocale(NULL);
   if(Locale)
    {
     puts("Start...");


     array[0]=12345678;
     array[1]=87654321;
     array[2]=7466;
     array[3]=226433;
     LocaleSFormat(&str,"Test %lD - %lD - %lD - %lD\n",&array);
     printf(">> %s\n",&str);

     LocaleDFormat(&str,"%d %m %Y\n",&ds);
     printf(">> %s\n",&str);

     puts("Ende.");
     CloseLocale(Locale);
    }
   CloseLibrary(LocaleBase);
  }
 CloseLibrary(MultiDesktopBase); }
}

