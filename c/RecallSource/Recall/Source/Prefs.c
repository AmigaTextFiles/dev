/*
 *	File:					Prefs.c
 *	Description:	Main program
 *	Version:			3.1
 *	Author:				Ketil Hunn
 *	Mail:					Ketil.Hunn@hiMolde.no
 *
 *	Copyright © 1993,1994,1995 Ketil Hunn.
 *
 */

/*** INCLUDES ************************************************************************/
#include "System_Prefs.h"
#include "HandleModules.h"
#include "PrefsIO.h"
#include "myinclude:Execute.h"
#include "Dirs.h"
#include "makekey:UnlockKey.h"

/*** DEFINES *************************************************************************/
#define	EVENTSEMAPHORE	"Recall_eventlist"

#define	DD_MM_YY					1
#define	MM_DD_YY					2
#define	YY_MM_DD					3

/*** GLOBALS *************************************************************************/
static const char version[]=VERSTAG;

struct MsgPort *ioport;

BYTE keyok=FALSE;
struct Key	key;

struct SignalSemaphore	*eventsemaphore;

Class *DSGClass;

/*** FUNCTIONS ***********************************************************************/
/*
UBYTE *myGetDateFormat(struct Locale *locale)
{
	register UBYTE	format[MAXCHARS]="%1$s ",
									*lf=locale->loc_ShortDateTimeFormat;
	register BYTE count=0;

	while(*lf!='\0')
	{
		if(*lf=='e' | *lf=='d')
			strcat(format, "%2$s");
		else if(*lf=='m' | *lf=='b')
			strcat(format, "%3$s");
		else if(*lf=='y' | *lf=='Y')
			strcat(format, "%4$s");
		else if((*lf=='/' | *lf=='-' | *lf=='.') & count<2)
		{
			UBYTE tmp[MAXCHARS];

			strcpy(tmp, lf);
			tmp[1]='\0';
			strcat(format, tmp);
			++count;
		}
		*lf++;
	}
	strcat(format, " - ");

	return format;
}
*/

void myGetDateFormat(struct Locale *locale)
{
	register UBYTE	*lf=locale->loc_ShortDateTimeFormat,
									count=1;

	while(*lf!='\0' && count<3)
	{
		if(*lf=='e' | *lf=='d')
			dateformat=count++;
		else if(*lf=='m' | *lf=='b')
			count++;
		else if(*lf=='y' | *lf=='Y')
			count++;
		else if((*lf=='/' | *lf=='-' | *lf=='.'))
			dateformatsplit[0]=*lf;
		*lf++;
	}
}

int main(int argc, char **argv)
{
	if(OpenResources())
	{
		NameFromLock(GetProgramDir(), startdir, MAXCHARS-1);

		GetTooltypes(argc, argv);

		if(LoadKey(&key, KEYFILE))
			keyok=IsKeyValid(&key);

		Forbid();
		ioport=FindPort(RECALL_PORT);
		Permit();
		if(ioport)
;//			FailRequest(NULL, MSG_ALREADYRESIDENT, NULL);
		else
		{
			if(ioport=CreatePort(RECALL_PORT, 1))
			{
				if(OpenGUIEnvironment(&mainTask, &textTask, &dateTask, &attribTask, &findTask, &aboutTask, NULL))
				{
					dateformat=DD_MM_YY;
					if(LocaleBase)
						myGetDateFormat(locale);

					strcpy(guifile, ENVARCGUIFILE);
					ReadEnv(&env, guifile);

					if(eventsemaphore=(struct SignalSemaphore *)
											AllocVec(sizeof(struct SignalSemaphore), MEMF_CLEAR|MEMF_PUBLIC))
					{
						eventsemaphore->ss_Link.ln_Name=EVENTSEMAPHORE;
						AddSemaphore(eventsemaphore);

						if(CreateWBStartPort())
						{
							if(eventlist=rootlist=InitList())
							{
								if(dirlist=InitList())
								{
									if(DSGClass=initDateSelectorGadClass())
									{
//										if(EasyRexxBase)
//											macro=AllocARexxMacro(TAG_DONE);
										AllocMainMenu();

										OpenMainTask(NULL, NULL, NULL);
										if(textTask.status)
											OpenTextTask(NULL, NULL, NULL);
										if(dateTask.status)
											OpenDateTask(NULL, NULL, NULL);
										if(findTask.status)
											OpenFindTask(NULL, NULL, NULL);
//										if(assignTask.status)
//											OpenAssignTask(NULL, NULL, NULL);
										if(aboutTask.status | keyok==FALSE)
											OpenAboutTask(NULL, NULL, NULL);

										ReadProject(eventlist, project, TRUE);

										UpdateMainMenu();
										while(egTaskActive(&mainTask)) // | !ER_SAFETOQUIT(context))
										{
											egWait(eg, 0L); //ER_SIGNAL(context));
					
//											ER_SETSIGNALS(context, signal);
//											if(signal & ER_SIGNAL(context))
//												myHandleARexx(context);
										}
										RemoveNode(eventbuffer);
										RemoveNode(datebuffer);
										FreeMainMenu();
//										if(EasyRexxBase)
//											FreeARexxMacro(macro);
										freeDateSelectorGadClass(DSGClass);
									}
									FreeList(dirlist);
								}
								FreeList(rootlist);
							}
							CloseWBStartPort();
						}
						RemSemaphore(eventsemaphore);
						ObtainSemaphore(eventsemaphore);
						ReleaseSemaphore(eventsemaphore);
						FreeVec(eventsemaphore);
					}
					else
						FailAlert(MSG_OUTOFMEMORY);

					CloseGUIEnvironment();
				}
				DeletePort(ioport);
			}
		}
	}
	CloseResources();
	return 0;
}
