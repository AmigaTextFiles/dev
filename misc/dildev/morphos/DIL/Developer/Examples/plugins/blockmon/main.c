/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include "include.h"

//------------------------------------------------------------------------------

//Sync functions
static Control *InitControl(void);
static void ExitControl(Control *control);

static void BuildSettings(Settings *settings);

static BOOL InitENV(DILParams *params);
static void ExitENV(DILParams *params);

static BOOL StartProcess(DILParams *params);
static void StopProcess(DILParams *params);
static void _process(void);

//Async functions
static BOOL InitLibraries(void);
static void ExitLibraries(void);
static BOOL InitApplication(DILParams *params);
static void ExitApplication(DILParams *params);

//-----------------------------------------------------------------------------
//Default plugin functions
//-----------------------------------------------------------------------------

static const struct TagItem tags[] =
{
	{ DILI_Name,			(ULONG)NAME_LONG },
	{ DILI_Version,		(ULONG)VERSION },
	{ DILI_Revision,		(ULONG)REVISION },
	{ DILI_OS,				(ULONG)"MorphOS" },
	{ DILI_CodeType,		(ULONG)"PPC" },
	{ DILI_SaneID,			(ULONG)DIL_SANEID }, /* (1.1) */
	{ DILI_Intervention, (ULONG)FALSE },
	{ DILI_GenerateSeed, (ULONG)FALSE },
	{ DILI_Description,  (ULONG)DESC },
	{ DILI_Author,       (ULONG)AUTHOR },
	{ DILI_Copyright,    (ULONG)COPY },
	{ DILI_License,      (ULONG)LICENCE },
	{ DILI_URL,          (ULONG)URL },
	{ 0ul, 0ul }
};
    
struct TagItem *dilGetInfo(void)
{
   return ((struct TagItem *)tags);
}

//-----------------------------------------------------------------------------

BOOL dilSetup(void)
{
	DILParams *params = (APTR)REG_A0;

	if ((params->p_User = InitControl())) //save pointer to p_User, never use a global here, cos it's a lib
   {
		if (InitENV(params))
		{
			if (StartProcess(params))
				return TRUE;
			
         ExitENV(params);
		}
		ExitControl(params->p_User);
   }
   return FALSE;
}

void dilCleanup(void)
{
	DILParams *params = (APTR)REG_A0;
	
	StopProcess(params);
	
	ExitENV(params);
	ExitControl(params->p_User); //we stored Control * in p_User
}

//-----------------------------------------------------------------------------

BOOL dilProcess(void)
{
	DILPlugin *p = (APTR)REG_A0;
   Control *control = p->p_Params->p_User;
	static ProcessMsg msg;

	memclr(&msg, sizeof(msg));
	msg.p_Msg.mn_Node.ln_Type = NT_MESSAGE;
	msg.p_Msg.mn_ReplyPort = control->c_ReplyPort;
	msg.p_Msg.mn_Length = sizeof(ProcessMsg);
   msg.p_Plugin = p;

	//send msg
	Forbid();
	PutMsg(control->c_SigPort, &msg.p_Msg);
	Permit();

	//send signal to process the msg
	Signal(control->c_SigTask, SIGBREAKF_CTRL_F);
	
	//wait for done
	WaitPort(control->c_ReplyPort);
   GetMsg(control->c_ReplyPort);
   return TRUE;
}

//-----------------------------------------------------------------------------
//Sync functions
//------------------------------------------------------------------------------
/*
__inline static double _sin(double x)
{
	double value;

	__asm ("fsin%.x %1,%0"
		: "=f" (value)
		: "f" (x));
	return value;
}

__inline static double _cos(double x)
{
	double value;

	__asm ("fcos%.x %1,%0"
		: "=f" (value)
		: "f" (x));
	return value;
}
*/

static Control *InitControl(void)
{
   Control *control;

	if ((control = AllocVec(sizeof(Control), MEMF_PUBLIC | MEMF_CLEAR)))
   {
		if ((control->c_SigPort = CreateMsgPort()))
		{
			if ((control->c_ReplyPort = CreateMsgPort()))
			{
				if ((control->c_Pool = CreatePool(MEMF_PUBLIC | MEMF_CLEAR | MEMF_SEM_PROTECTED, 32768, 32768)))
				{
					control->c_Self = SysBase->ThisTask;
					
               _NewList(&control->c_List);

					control->c_SinTable = AllocVP(control, sizeof(DOUBLE) * (DEG_360 + 1));
					control->c_CosTable = AllocVP(control, sizeof(DOUBLE) * (DEG_360 + 1));

					if (control->c_SinTable && control->c_CosTable)
					{
						register DOUBLE rad;
						register LONG i;

						for (i = DEG_360; i >= 0; i--) {
							rad = (i - DEG_180) * PI / DEG_180;

							control->c_SinTable[DEG_360 - i]	= sin(rad);
							control->c_CosTable[DEG_360 - i]	= cos(rad);
						}

						BuildSettings(&control->c_Settings);
                  return control;
					}
					DeletePool(control->c_Pool);
				}
				DeleteMsgPort(control->c_ReplyPort);
			}
			DeleteMsgPort(control->c_SigPort);
		}
      FreeVec(control);
	}
	return NULL;
}

static void ExitControl(Control *control)
{
	if (control) {
		if (control->c_SigPort) DeleteMsgPort(control->c_SigPort);
		if (control->c_ReplyPort) DeleteMsgPort(control->c_ReplyPort);
		if (control->c_Pool) {
			/*Entry *entry, *tmp;

			ForeachNodeSafe(&control->c_List, entry, tmp)
				FreeVP(control, entry);

			FreeVP(control, control->c_SinTable);
			FreeVP(control, control->c_CosTable);*/
			
         DeletePool(control->c_Pool);
		}
      FreeVec(control);
	}
}

//------------------------------------------------------------------------------

static void BuildSettings(Settings *settings)
{
	static struct {
		LONG id;
		BOOL bold, italic;
		char *color;
	} bip_init[] = {
		{ BIP_Stats_R, 0, 0, "rff0000" },
		{ BIP_Stats_G, 0, 0, "r00ff00" },
		{ BIP_Stats_B, 0, 0, "r0000ff" },
		{ -1l,         0, 0, NULL }
	};
	LONG i = 0l;

	memclr(settings, sizeof(Settings));

	while (bip_init[i].color) {
		settings->s_Bold[bip_init[i].id] = bip_init[i].bold;
		settings->s_Italic[bip_init[i].id] = bip_init[i].italic;
		strcpy(settings->s_PenSpec[bip_init[i].id].buf, bip_init[i].color);
		i++;
	}
	for (i = 0l; i < CF_END; i++) {
		settings->s_ColumnFlags[i] = ~0ul;
		clrb(settings->s_ColumnFlags[i], 31);
	}
}

//------------------------------------------------------------------------------

static BOOL InitENV(DILParams *params)
{
   Control *control = params->p_User;
	Settings *settings = &control->c_Settings;
	UBYTE tmp[1024], *fn;
	BOOL result = FALSE;

	if (!params->p_PDPString)
		return result;

	strcpy(tmp, params->p_PDPString);
	AddPart(tmp, NAME_SHORT, sizeof(tmp));
	if (CheckCreateDir(tmp)) {
		AddPart(tmp, "cache", sizeof(tmp));
		if (CheckCreateDir(tmp)) {
			if (!(settings->s_PathCache = AllocStrcln(control, tmp)))
				return result;
		} else
			return result;
	} else
		return result;

	strcpy(tmp, params->p_PDPString);
	AddPart(tmp, NAME_SHORT, sizeof(tmp));
	AddPart(tmp, "config", sizeof(tmp));
	if (CheckCreateDir(tmp)) {
		if (!(settings->s_PathConfig = AllocStrcln(control, tmp)))
			return result;
	} else
		return result;

	result = TRUE;
	strcpy(tmp, settings->s_PathConfig);
	AddPart(tmp, FMT_CONFIG_CACHEMAXLENGTH, sizeof(tmp));
	
	if ((fn = AllocSPrintf(control, tmp, params->p_DILUnit))) {
		ULONG cml = 0ul;

		if (LoadDecimal(fn, &cml))
			settings->s_CacheMaxLength = cml;
		else {
			settings->s_CacheMaxLength = CACHE_MAXLENGTH;

			if (!SaveDecimal(fn, settings->s_CacheMaxLength))
				result = FALSE;
      }
		FreeSPrintf(control, fn);
	} else
		result = FALSE;

	return result;
}

static void ExitENV(DILParams *params)
{
   Control *control = params->p_User;
	Settings *settings = &control->c_Settings;

	FreeStrcln(control, settings->s_PathCache);
	FreeStrcln(control, settings->s_PathConfig);
}

//------------------------------------------------------------------------------

static BOOL StartProcess(DILParams *params)
{
   Control *control = params->p_User;
	static StartProcessMsg msg;
	UBYTE *pn;

	memclr(&msg, sizeof(msg));
	msg.sp_Msg.mn_Node.ln_Type = NT_MESSAGE;
	msg.sp_Msg.mn_ReplyPort = control->c_ReplyPort;
	msg.sp_Msg.mn_Length = sizeof(StartProcessMsg);
	
	msg.sp_Params = params;
   msg.sp_Error = TRUE;

	if ((pn = AllocSPrintf(control, FMT_PROCESS, params->p_DILUnit))) {
		if ((control->c_SigTask = (struct Task *)CreateNewProcTags(
			NP_CodeType, CODETYPE_PPC,
			NP_Name, (ULONG)pn,
			NP_Entry, (ULONG)_process,
			NP_Priority, (ULONG)1,
		TAG_DONE))) {
			PutMsg(&((struct Process *)control->c_SigTask)->pr_MsgPort, &msg.sp_Msg);
			WaitPort(control->c_ReplyPort);
			GetMsg(control->c_ReplyPort);
		}
	}
	return (msg.sp_Error ? FALSE : TRUE);
}

static void StopProcess(DILParams *params)
{
   Control *control = params->p_User;

	if (control->c_SigTask) {
		//send the abort signal
		Signal(control->c_SigTask, SIGBREAKF_CTRL_C);
	
		//wait for the done signal
		while (!(SetSignal(0ul, SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C))
			Delay(5);
   }
}

//------------------------------------------------------------------------------
//Async functions
//------------------------------------------------------------------------------

struct GfxBase       *GfxBase       = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Library 		*IconBase 	   = NULL;
struct Library 		*MUIMasterBase = NULL;

//------------------------------------------------------------------------------

#define MINSYS 37l
#define MINMUI 20l //MUIMASTER_VLATEST

#define INTUITIONNAME "intuition.library"

#define INITLIB(lib, type, name, version) \
	if (!(lib = (type)OpenLibrary(name, version))) { \
		kprintf("InitLibraries() Can't open "name" v%ld\n", version); \
		ExitLibraries(); return FALSE; }

#define EXITLIB(lib) \
	if (lib) CloseLibrary((struct Library *)lib);

static BOOL InitLibraries(void)
{
	INITLIB(GfxBase, struct GfxBase *, GRAPHICSNAME, MINSYS)
	INITLIB(IntuitionBase, struct IntuitionBase *, INTUITIONNAME, MINSYS)
	INITLIB(IconBase, struct Library *, ICONNAME, MINSYS)
	INITLIB(MUIMasterBase, struct Library *, MUIMASTER_NAME, MINMUI)
   return TRUE;
}

static void ExitLibraries(void)
{
	EXITLIB(MUIMasterBase)
	EXITLIB(IconBase)
	EXITLIB(IntuitionBase)
	EXITLIB(GfxBase)
}

//------------------------------------------------------------------------------

static BOOL InitApplication(DILParams *params)
{
   Control *control = params->p_User;

	if (InitCustomClasses(control))
	{
		if ((control->c_APP = _ApplicationObject,
			MUIA_Application_Params, params,
		End))
      {
			if (DoMethod(control->c_APP, MUIM_Application_Init))
				return TRUE;

			MUI_DisposeObject(control->c_APP);
		}
		ExitCustomClasses(control);
   }
	return FALSE;
}

static void ExitApplication(DILParams *params)
{
   Control *control = params->p_User;

	if (control->c_APP) {
		struct DiskObject *dob;
		
      get(control->c_APP, MUIA_Application_DiskObject, &dob);
		if (dob) FreeDiskObject(dob);

		DoMethod(control->c_APP, MUIM_Application_Exit);
		MUI_DisposeObject(control->c_APP);
	}
	ExitCustomClasses(control);
}

//------------------------------------------------------------------------------

static void _process(void)
{
	struct ExecBase *SysBase = *(struct ExecBase **)4;
	struct Process *proc = (struct Process *)SysBase->ThisTask;
   DILParams *params;
   Control *control;
	StartProcessMsg *msg;

   WaitPort(&proc->pr_MsgPort);
	msg = (StartProcessMsg *)GetMsg(&proc->pr_MsgPort);
	params = msg->sp_Params;
   control = params->p_User;

	if (!InitLibraries()) {
		Forbid(); ReplyMsg(&msg->sp_Msg);
		return;
	}
   if (!InitApplication(params)) {
		ExitLibraries();
		Forbid(); ReplyMsg(&msg->sp_Msg);
		return;
	}
   //send positive reply
	msg->sp_Error = FALSE;
	ReplyMsg(&msg->sp_Msg);
			
	{
		BOOL running = TRUE;

		while (running) {
			ULONG event, sigs, recv = 0ul;
			
			event = DoMethod(control->c_APP, MUIM_Application_NewInput, &sigs);
			//if (event == MUIV_) {}
			
         if (sigs) {
				setf(sigs, SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_F);
				recv = Wait(sigs);
			}
			
			if (issetf(recv, SIGBREAKF_CTRL_C))
            running = FALSE;
			else if (issetf(recv, SIGBREAKF_CTRL_F))
         {
				if (!IsMsgPortEmpty(control->c_SigPort))
				{
					struct MCC_Application_Data *ad = INST_DATA(OCLASS(control->c_APP), control->c_APP);
					struct MCC_Main_Data *md = INST_DATA(OCLASS(ad->mcc_main), ad->mcc_main);
					ProcessMsg *msg;

					set(control->c_APP, MUIA_Application_Sleep, TRUE);
					
               while	((msg = (ProcessMsg *)GetMsg(control->c_SigPort))) {
						DoMethod(md->mcc_display, MUIM_Display_Update, msg->p_Plugin);
						ReplyMsg(&msg->p_Msg);
					}
               set(control->c_APP, MUIA_Application_Sleep, FALSE);
				}
			}
			clrf(sigs, SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_F);
		}
	}

   ExitApplication(params);
	ExitLibraries();

	//send the done signal
	Signal(control->c_Self, SIGBREAKF_CTRL_C);
}

//------------------------------------------------------------------------------

























