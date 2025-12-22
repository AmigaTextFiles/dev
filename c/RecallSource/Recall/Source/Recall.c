/*
 *	File:					Recall.c
 *	Description:	Runs through a project of events set by Recall Preferences
 *								and displays them according to their types.
 *	Version:			3.0
 *	Author:				Ketil Hunn
 *	Mail:					Ketil.Hunn@hiMolde.no
 *
 *	Copyright © 1993,1994,1995 Ketil Hunn.
 *
 */

#define	AREXX	0

#define	FailAlert(m)	myAlert(RECOVERY_ALERT, GetString(&li, m), 0)

#define	RECALL_CHECKER	1

/*** PRIVATE INCLUDES ****************************************************************/
#include <exec/types.h>
#include <exec/alerts.h>
#include <dos/datetime.h>
#include <dos/notify.h>
#include <dos/dostags.h>
#include <devices/timer.h>
#include <libraries/locale.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <libraries/commodities.h>

#define  CATCOMP_NUMBERS
#include "Recall_locale.h"

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/commodities_protos.h>
#include <clib/wb_protos.h>
#include <clib/icon_protos.h>
#include <clib/dos_protos.h>
#include <clib/alib_stdio_protos.h>
#include <clib/locale_protos.h>
#include <clib/Macros.h>

#include <clib/reqtools_protos.h>
#include <libraries/reqtools.h>

/**** PROTOTYPES *********************************************************************/
char *CatSingleEventTexts(struct QuickNode *quicknode, char *text);
char *CatGroupEventsTexts(struct Node *innode, short type, char *text);
LONG ShowRequest(	UBYTE *screenname,
									UBYTE *text,
									UBYTE *buttons,
									BOOL	centre,
									UBYTE *params);
BOOL CheckProject(struct List *list, BOOL startup);
void SendTimeIO(struct timerequest *timerIO, ULONG secs, ULONG micros);
void SynchronizeTimer(void);
__asm __saveds LONG myAlert(register __d0 ULONG alertType,
														register __a0 UBYTE *msg,
														register __d1	ULONG timeout);

/**** GLOBALS ***********************************************************************/
struct IntuitionBase	*IntuitionBase;
struct Library				*IconBase,		*LocaleBase,	*IFFParseBase,
											*UtilityBase,	*TimerBase,		*CxBase;
struct ReqToolsBase 	*ReqToolsBase=NULL;

struct LocaleInfo			li;
struct List						*eventlist, *quicklist;
UBYTE									title[40];
struct timerequest		*timerIO;
struct MsgPort				*timerport;
BYTE									stayresident, usereqtools;
ULONG									buffersize;

/*************************************************************************************/

#include "Version.h"
#include "Recall_rev.h"
//#include "myinclude:myDebug.c"
#include "myinclude:execute.c"
#include "hotkey.c"
#include "DateList.h"
#include "ProjectIO.h"
#include "CalcField.h"
#include "CheckDateTime.h"
#include "myinclude:myTooltypeArgs.h"
#include "myinclude:GetDir.c"

/*************************************************************************************/

static const char version[]=VERSTAG;

int main(int argc, char **argv)
{
	struct Message	*msg;
	UBYTE						**ttypes,
									defproject[MAXCHARS];
	ULONG						waitsecs;

	struct NotifyRequest	*notifyrequest;
	ULONG									notifysignal;
/*
	if(argc>0)
		shellopen=TRUE;
	else
		shellopen=FALSE;
*/
	if(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library", LIBVER))
	{
		if(IFFParseBase=OpenLibrary("iffparse.library", LIBVER))
		{
			if(IconBase=OpenLibrary("icon.library", LIBVER))
			{
				if(UtilityBase=OpenLibrary("utility.library", LIBVER))
				{
					if(CxBase=OpenLibrary("commodities.library", LIBVER))
					{
						if(timerport=CreateMsgPort())
						{
							if(timerIO=(struct timerequest *)CreateExtIO(timerport, sizeof(struct timerequest)))
							{
								if(0==(OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *)timerIO, 0L)))
								{
									TimerBase=(struct Library *)timerIO->tr_node.io_Device;

									ttypes=ArgArrayInit(argc, argv);

									{
										UBYTE startdir[MAXCHARS];

										GetCurrentDir(startdir, MAXCHARS-1);
										AddPart(startdir, PREFSFILE, MAXCHARS-1);
										strcpy(defproject, ArgString(ttypes,	FROM_TOOLTYPE, startdir));
									}
									waitsecs			=(ULONG)ArgInt(ttypes,	WAIT_TOOLTYPE, DEFAULTWAIT);
									buffersize		=(ULONG)ArgInt(ttypes,	BUFFERSIZE_TOOLTYPE, DEFAULTBUFFER);
									stayresident	=ArgBool(ttypes, STAYRESIDENT_TOOLTYPE);
									usereqtools		=ArgBool(ttypes, USEREQTOOLS_TOOLTYPE);

#ifdef MYDEBUG_H
	debugarg=1+ArgBool(ttypes,	DEBUG_TOOLTYPE);
#endif

									if(LocaleBase=OpenLibrary("locale.library", 38L))
									{
										UBYTE language[MAXCHARS];

										strcpy(language, ArgString(ttypes, LANGUAGE_TOOLTYPE, "*"));
										li.li_LocaleBase = LocaleBase;
										li.li_Catalog=OpenCatalog(NULL, RECALLCATALOG,
																						  (*language=='*' ? TAG_IGNORE: OC_Language),	language,
																							OC_Version, CATVERSION,
																						  TAG_DONE);
									}
									{
										struct DateTime dt;
										char date[LEN_DATSTRING];

										DateStamp(&dt.dat_Stamp);
										dt.dat_Format	 = 4;
										dt.dat_Flags	 = NULL;
										dt.dat_StrDay  = NULL;
										dt.dat_StrDate = date;
										dt.dat_StrTime = NULL;

										DateToStr(&dt);
										strcpy(title, PROGNAME " " VERS "  ");
										strcat(title, date);
									}
									if(CreateWBStartPort())
									{
										if(quicklist=InitList())
										{
											if(eventlist=InitList())
											{
												ReadIFF(eventlist, defproject);
												if(usereqtools)
													ReqToolsBase=(struct ReqToolsBase *)OpenLibrary(REQTOOLSNAME, REQTOOLSVERSION);
												if(notifyrequest=(struct NotifyRequest *)AllocVec(sizeof(struct NotifyRequest), MEMF_CLEAR))
												{
													if(-1!=(notifysignal=AllocSignal(-1L)))
													{
														notifyrequest->nr_Name	=defproject;
														notifyrequest->nr_Flags	=NRF_SEND_SIGNAL;
														notifyrequest->nr_stuff.nr_Signal.nr_Task=(struct Task *)FindTask(NULL);
														notifyrequest->nr_stuff.nr_Signal.nr_SignalNum=notifysignal;

														if(StartNotify(notifyrequest)==DOSTRUE)
														{
															CxObj						*broker;
															CxMsg						*cxmsg;
															struct MsgPort	*brokerport;

															struct NewBroker newbroker=
															{
																NB_VERSION,
																PROGNAME,
																PROGNAME " V" VERS " " COPYRIGHT,
																NULL,
																0,
																0,0,0,0
															};

															newbroker.nb_Descr=GetString(&li, MSG_DESCRIPTION);
															if(brokerport=CreateMsgPort())
															{
																newbroker.nb_Port=brokerport;
																newbroker.nb_Pri=(BYTE)ArgInt(ttypes, "CX_PRIORITY", 0);
																if(broker=CxBroker(&newbroker, NULL))
																{
																	ULONG	signal;
																	BYTE	done=FALSE, saved=FALSE;
																	LONG	active=1L;

																	ActivateCxObj(broker, active);
																	if(CheckProject(quicklist, TRUE))
																	{
																		WriteIFF(eventlist, defproject);
																		saved=TRUE;
																	}
																	if(stayresident)
																		SendTimeIO(timerIO, waitsecs, 0);

																	if(WBStartApps>0 | stayresident==TRUE)
																		while(!done)
																		{
																			signal=Wait(SIGBREAKF_CTRL_C					|
																									1L<<brokerport->mp_SigBit |
																									1L<<timerport->mp_SigBit	|
																									WBStartPortSignal					|
																									1L<<notifysignal);

																			if(signal & WBStartPortSignal)
																				CleanUpWBStart();
																			else if(signal & 1L<<notifysignal)
																			{
																				if(saved==FALSE)
																				{
																					ClearList(eventlist);
																					ClearList(quicklist);
																					ReadIFF(eventlist, defproject);
																					CreateQuickList(quicklist, eventlist);
																				}
																				saved=FALSE;
																			}
																			else if(signal & 1L<<timerport->mp_SigBit)
																			{
																				GetMsg(timerport);
																				WaitIO(timerIO);
																				if(active)
																				{
																					if(CheckProject(quicklist, FALSE))
																					{
																						WriteIFF(eventlist, defproject);
																						saved=TRUE;
																					}
																					if(stayresident)
																						SendTimeIO(timerIO, waitsecs, 0);
																				}
																			}
																			else if(signal & 1L<<brokerport->mp_SigBit)
																			{
																				ULONG type, id;
																				cxmsg=(CxMsg *)GetMsg(brokerport);
																				type=CxMsgType(cxmsg);
																				id=CxMsgID(cxmsg);
																				ReplyMsg((struct Message *)cxmsg);

																				if(type==CXM_COMMAND)
																				{
																					switch(id)
																					{
																						case CXCMD_DISABLE:
																							ActivateCxObj(broker, active=0L);
																							if(stayresident)
																							{
																								AbortIO(timerIO);
																								WaitIO(timerIO);
																							}
																							break;
																						case CXCMD_ENABLE:
																							ActivateCxObj(broker, active=1L);
																							if(stayresident)
																								SendTimeIO(timerIO, waitsecs, 0);
																							break;
																						case CXCMD_KILL:
																							if(WBStartApps)
																								myEasyRequest(NULL,
																															PROGNAME " " VERS,
																															GetString(&li, MSG_STILLACTIVE),
																															GetString(&li, MSG_OK),
																															(APTR)WBStartApps);
																							else
																								done=TRUE;
																							break;
																						}
																					}
																				}
																				else if(signal & SIGBREAKF_CTRL_C)
																					done=TRUE;

																				if(WBStartApps==0 & stayresident==FALSE)
																					done=TRUE;
																		}
																		DeleteCxObjAll(broker);
																	}
																	if(stayresident)
																	{
																		AbortIO(timerIO);
																		WaitIO(timerIO);
																	}
																	while(msg=GetMsg(brokerport))
																		ReplyMsg(msg);
																	DeleteMsgPort(brokerport);
																}
																EndNotify(notifyrequest);
															}
															FreeSignal(notifysignal);
														}
														FreeVec(notifyrequest);
													}
													else
														FailAlert(MSG_OUTOFMEMORY);
												if(ReqToolsBase)
													CloseLibrary((struct Library *)ReqToolsBase);
												FreeList(eventlist);
											}
											FreeList(quicklist);
										}
										CloseWBStartPort();
									}
									if(LocaleBase)
									{
										CloseCatalog(li.li_Catalog);
										CloseLibrary(LocaleBase);
									}
									ArgArrayDone();
									CloseDevice((struct IORequest *)timerIO);
								}
								DeleteExtIO((struct IORequest *)timerIO);
							}
							while(msg=GetMsg(timerport))
								ReplyMsg(msg);
							DeleteMsgPort(timerport);
						}
						CloseLibrary(CxBase);
					}
					CloseLibrary(UtilityBase);
				}
				CloseLibrary(IconBase);
			}
			CloseLibrary(IFFParseBase);
		}
		CloseLibrary((struct Library *)IntuitionBase);
	}
	return 0;
}
