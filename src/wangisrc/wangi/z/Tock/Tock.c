/***************************************************************************
 * Tock.c
 *
 * Tock, Copyright ©1995 Lee Kindness.
 *
 * This source is for example purposes...
 *
 */

/* All our includes are in this file */
#include "gst.c"

/* Version stuff... */
#include "Tock_rev.h"

/* Libraries used, don't auto open them SAS/C :) */
extern struct Library *IntuitionBase = NULL;
extern struct Library *CxBase = NULL;
extern struct Library *GadToolsBase = NULL;
extern struct Library *LocaleBase = NULL;

struct Data
{
	struct Library       *d_IntuitionBase,
	                     *d_CxBase,
 	                     *d_GadToolsBase,
 	                     *d_LocaleBase,
 	ULONG                 d_Secs;         /* Update every x seconds */
 	STRPTR                d_ScreenName;   /* Open on screen with this name */
 	struct Window        *d_Window;       /* The created window */
 	WORD                  d_Width,        /* Width of window, -1 = autosize */
 	                      d_TopEdge,      /* Position of topedge */
 	                      d_LeftEdge;     /* Position of leftedge */
	Struct List           d_Formats;      /* List of Locale format templates */
	struct Locale        *d_Locale;       /* Locale in use */
	struct NotifyRequest *d_OurPrefN,     /* Notification of our prefs change */
	                     *d_SysPrefN;     /* Systems prefs change */
};

#define ln_Format ln_Name
 	


struct Data *OpenLibs(void);
void CloseLibs(struct Data *);


char vertag[] = VERSTAG;

/***************************************************************************
 * main() --
 */
int main(int argc, char **argv)
{
	int ret = RETURN_FAIL;
	BOOL Active = TRUE;
	
	/* check version */
	if (OpenLibs()) 
	{
		struct NewBroker nb = 
		{
			NB_VERSION,
			"Tock",
			VERS " (" DATE ") by Lee Kindness",
			"locale-tasTic clOCK ;)",
			NBU_UNIQUE | NBU_NOTIFY,
			COF_SHOW_HIDE,
			-1,
			NULL,
			0
		};
		CxObj *broker;
		nb.nb_Pri = 0;
				
		if ((nb.nb_Port = CreateMsgPort()) && (broker = CxBroker(&nb, NULL))) 
		{
			ULONG sig, sret;
			BOOL finished;
			
			ActivateCxObj(broker, 1L);
			
			ret = RETURN_OK;
			
			finished = FALSE;
			sig = 1 << nb.nb_Port->mp_SigBit;
					
			do 
			{
				sret = Wait(SIGBREAKF_CTRL_C | sig);
				if (sret & sig) 
				{
					CxMsg *msg;
					while(msg = (CxMsg *)GetMsg(nb.nb_Port)) 
					{
						switch(CxMsgType(msg)) 
						{
							case CXM_COMMAND:
								switch(CxMsgID(msg)) 
								{
									case CXCMD_DISABLE:
										ActivateCxObj(broker, 0L);
										Active = FALSE;
										break;
									case CXCMD_ENABLE:
										ActivateCxObj(broker, 1L);
										Active = TRUE;
										break;
									case CXCMD_KILL:
										finished = TRUE;
										break;
									//case CXCMD_UNIQUE:
									//	finished = ShowWindow();
									//	break;
									//case CXCMD_APPEAR:
									//	finished = ShowWindow();
									//	break;
								}
								break;
						}
						ReplyMsg((struct Message *)msg);
					}
				}
				if (sret & SIGBREAKF_CTRL_C)
					finished = TRUE;
			} while (!finished);
			
			ActivateCxObj(broker, 0L);
			DeleteCxObj(broker);
			DeletePort(nb.nb_Port);
		}
	}
	CloseLibs();
	return(ret);
}


/***************************************************************************
 * OpenLibs() -- Open all used libraries
 */
BOOL OpenLibs(void)
{
	struct Data *d = NULL;
	
	if( d = AllocVec(sizeof(struct Data), MEMF_CLEAR) )
	{
		d->d_IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 37);
		d->d_CxBase = OpenLibrary("commodities.library", 37);
		d->d_GadToolsBase = OpenLibrary("gadtools.library", 37);
		d->d_LocaleBase = (struct LocaleBase *)OpenLibrary("locale.library", 38);
		ret = ((d->d_IntuitionBase) && 
		       (d->d_CxBase) && 
		       (d->d_GadToolsBase) &&
		       (d->d_LocaleBase));
	return(ret);
}


/***************************************************************************
 * CloseLibs() -- Close all libraries
 */
void CloseLibs(void)
{
	if (LocaleBase)
		CloseLibrary((struct Library *)LocaleBase);
	if (GadToolsBase)
		CloseLibrary(GadToolsBase);
	if (CxBase)
		CloseLibrary(CxBase);
	if (IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
}
