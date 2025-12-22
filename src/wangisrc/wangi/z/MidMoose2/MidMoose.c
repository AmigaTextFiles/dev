#include "gst.c"

extern struct Library *CxBase = NULL;
extern struct Library *IconBase = NULL;

#define VERSION "2.1"
#define DEF_DOWNKEY "rawkey lcommand z"
#define DEF_UPKEY "rawkey lcommand upstroke z"
#define DEF_RDOWNKEY "rawkey lcommand repeat z"
#define DEF_CXPRI 0
#define PREFS_DOWNKEY prefs.downkey
#define PREFS_UPKEY prefs.upkey
#define PREFS_RDOWNKEY prefs.rdownkey
#define PREFS_CXPRI prefs.cxpri

struct Prefs {
	STRPTR downkey;
	STRPTR upkey;
	STRPTR rdownkey;
	LONG   cxpri;
};

struct Prefs prefs = {DEF_DOWNKEY, DEF_UPKEY, DEF_RDOWNKEY, DEF_CXPRI};

struct NewBroker newbroker = {
	NB_VERSION,
	"MidMoose",
	"MidMoose "VERSION" ©1994-95 Lee Kindness",
	"Middle mouse button emulation.",
	NBU_UNIQUE | NBU_NOTIFY,
	0, 127, 0, 0
};

char vertag[] = "$VER: MidMoose "VERSION" "__AMIGADATE__;

int main(int argc, char **argv)
{
	/* open libraries */
	if( (CxBase = OpenLibrary("commodities.library", 36)) &&
	    (IconBase = OpenLibrary("icon.library", 36)) )
	{
		/* create a message port */
		if( newbroker.nb_Port = CreateMsgPort() )
		{
			CxObj *broker;
			struct RDArgs *rdargs = NULL;
			struct DiskObject *dobj = NULL;
			
			/* Get tooltypes */
			if (argc ? FALSE : TRUE) {
				BPTR oldcd;
				struct WBStartup *wbs;
				#define PROGNAME wbs->sm_ArgList->wa_Name
				#define PDIRLOCK wbs->sm_ArgList->wa_Lock
				wbs = (struct WBStartup *)argv;
				/* Run from WB */
				oldcd = CurrentDir(PDIRLOCK);
				if (dobj = GetDiskObject(PROGNAME)) {
					STRPTR s;
					PREFS_DOWNKEY = FindToolType(dobj->do_ToolTypes, "UPKEY");
					PREFS_UPKEY = FindToolType(dobj->do_ToolTypes, "DOWNKEY");
					PREFS_RDOWNKEY = FindToolType(dobj->do_ToolTypes, "RDOWNKEY");
					if( s = FindToolType(dobj->do_ToolTypes, "CX_PRIORITY") )
						StrToLong(s, &PREFS_CXPRI);
				}
				CurrentDir(oldcd);
			} else {
				#define OPT_UPKEY 0
				#define OPT_DOWNKEY 1
				#define OPT_RDOWNKEY 2
				#define OPT_CXPRI 3
				LONG args[4] = {0, 0, 0, 0};
				#define TEMPLATE "UPKEY/K,DOWNKEY/K,RDOWNKEY/K,CX_PRIORITY/K/N"
				/* Run from Shell */
				if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL)) {
					if (args[OPT_UPKEY]) {
						PREFS_UPKEY = (STRPTR)args[OPT_UPKEY];
					}
					if (args[OPT_DOWNKEY]) {
						PREFS_DOWNKEY = (STRPTR)args[OPT_DOWNKEY];
					}
					if (args[OPT_RDOWNKEY]) {
						PREFS_RDOWNKEY = (STRPTR)args[OPT_RDOWNKEY];
					}
					if( args[OPT_CXPRI] ) 
						PREFS_CXPRI = *((LONG *)args[OPT_CXPRI]);
				}
			}
			if( PREFS_CXPRI > 127 )
				PREFS_CXPRI = 127;
			if( PREFS_CXPRI < -128 )
				PREFS_CXPRI = -128;
			
			newbroker.nb_Pri = PREFS_CXPRI;
		
			/* create a CX broker */
			if( broker = CxBroker(&newbroker, NULL) )
			{
				CxObj *DownFilter, *UpFilter, *RDownFilter;
				/* create 2 filters */
				if( (DownFilter = CxFilter(PREFS_DOWNKEY)) && 
				    (UpFilter = CxFilter(PREFS_UPKEY)) &&
				    (RDownFilter = CxFilter(PREFS_RDOWNKEY)) )
				{
					struct InputEvent *Downie, *Upie;
					/* Add the filters to the brokwrs list */
					AttachCxObj(broker, DownFilter);
					AttachCxObj(broker, UpFilter);
					AttachCxObj(broker, RDownFilter);
					
					/* Alloc the translation input events */
					if( (Downie = AllocVec(sizeof(struct InputEvent), MEMF_CLEAR)) && 
					    (Upie = AllocVec(sizeof(struct InputEvent), MEMF_CLEAR)) )
					{
						CxObj *DownTrans, *UpTrans, *RDownTrans;
						/* init. the translation input events */
						Downie->ie_Class = IECLASS_RAWMOUSE;
						Downie->ie_Code = IECODE_MBUTTON;
						Downie->ie_Qualifier = IEQUALIFIER_MIDBUTTON;
						Upie->ie_Class = IECLASS_RAWMOUSE;
						Upie->ie_Code = IECODE_MBUTTON | IECODE_UP_PREFIX;
					
						/* create translators */
						if( (DownTrans = CxTranslate(Downie)) && 
						    (UpTrans = CxTranslate(Upie)) &&
						    (RDownTrans = CxTranslate(NULL)) )
						{
							/* attach the translators to the filters */
							AttachCxObj(DownFilter, DownTrans);
							AttachCxObj(UpFilter, UpTrans);
							AttachCxObj(RDownFilter, RDownTrans);
							
							/* check for errors */
							if( (!CxObjError(DownFilter)) &&
							    (!CxObjError(UpFilter)) &&
							    (!CxObjError(RDownFilter)) )
							{
								CxMsg *msg;
								ULONG sigrcvd, msgid, msgtype, cxsigflag;
								BOOL cont = TRUE;
								/* turn on the broker */
								ActivateCxObj(broker, 1L);
								
								cxsigflag = 1L << newbroker.nb_Port->mp_SigBit;
								
								/* process messages */
								while(cont)
								{
									sigrcvd = Wait(SIGBREAKF_CTRL_C | cxsigflag);
									while( msg = (CxMsg *)GetMsg(newbroker.nb_Port) )
									{
										msgid = CxMsgID(msg);
										msgtype = CxMsgType(msg);
										ReplyMsg((struct Message *)msg);
										if( msgtype == CXM_COMMAND )
										{
											switch(msgid)
											{
												case CXCMD_DISABLE:
													ActivateCxObj(broker, 0L);
													break;
												case CXCMD_ENABLE:
													ActivateCxObj(broker, 1L);
													break;
												case CXCMD_KILL:
													cont = FALSE;
													break;
												case CXCMD_UNIQUE:
													cont = FALSE;
													break;
											}
										}
									}
									if( sigrcvd & SIGBREAKF_CTRL_C )
										cont = FALSE;
								}
							}
						}
						/* free the translation input events */
						FreeVec(Upie);
						FreeVec(Downie);
					}
				}
				/* free the broker */
				DeleteCxObjAll(broker);
			}
			/* Free dobj/rdargs */
			if( dobj )
				FreeDiskObject(dobj);
			if( rdargs )
				FreeArgs(rdargs);

			/* free the port */
			DeletePort(newbroker.nb_Port);
		}
		/* close libraries */
		CloseLibrary(IconBase);
		CloseLibrary(CxBase);
	}
	return 0;
}