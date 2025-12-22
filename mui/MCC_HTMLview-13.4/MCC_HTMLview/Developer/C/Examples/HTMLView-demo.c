/*
** Example code for HTMLview.mcc. (Compiles with StormC.)
** $VER: HTMLview-demo.c V0.1 (07-Aug-98)
**
** Questions concerning this source: ole_f@post3.tele.dk
** Questions concerning HTMLview.mcc: duff@diku.dk
**
** Find the latest version of HTMLview.mcc at Allan Odgaard's homepage
** http://www.diku.dk/students/duff/
*/

/* ANSI C */
#include <stdio.h>
#include <string.h>

/* MUI */
#include <libraries/mui.h>
#include <proto/muimaster.h>

/* ASL */
#include <libraries/asl.h>

/* Exec */
#include <exec/exec.h>

/* Protos */
#include <clib/alib_protos.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/intuition.h>

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif
#define REG(x) register __ ## x

/* MCC_HTMLview */
#include <mui/HTMLview_mcc.h>

/* Some structures for the demo */
struct HistoryItem { char *URL; char *Target; };
struct HTMLviewer_Data
{
	struct FileRequester *ASLreq;
	char **Visited;
	int VisitedPosition;
	struct HistoryItem **History;
	int HistoryPosition;
};
struct MUIP_HTMLviewer_ClickedURL { APTR MethodID; char *NewURL; };

/* MUIMaster library base */
struct Library *MUIMasterBase;

/* Our HTMLview subclass */
struct MUI_CustomClass *CL_HTMLviewer;

/* Tags */
#define MUISERIALNR_HTMLVIEVER 1
#define TAGBASE_HTMLVIEVER (TAG_USER | (MUISERIALNR_HTMLVIEVER << 16))
enum
{
	MUIM_HTMLviewer_OpenFile = TAGBASE_HTMLVIEVER,
	MUIM_HTMLviewer_ClickedURL,
	MUIM_HTMLviewer_Back
};

/*
** The "VLinks" and history lists are plain lists, no neat binary trees
** or similar here. Sorry about that, but this source should only serve a
** teaching purpose on HTMLview.mcc, not in general programming.
**
** Number of "VLinks" that we will remember */
#define VLINKSIZE 50
/* Max number of elements in our history */
#define HISTORYSIZE 50

/* The classic help function */
ULONG DoSuperNew(struct IClass *cl,Object *obj,ULONG tag1,...)
{
	return(DoSuperMethod(cl,obj,OM_NEW,&tag1,NULL));
}

/* Frees a history item */
void FreeHistoryItem(struct HistoryItem *FreeMe)
{
	if(FreeMe)
	{
		FreeVec(FreeMe->URL);
		if(FreeMe->Target)
			FreeVec(FreeMe->Target);
		FreeVec(FreeMe);
	}
	return;
}

/* The procedure which will be called by the load task. Simple, right?
** Please note: The built-in LoadFunc in HTMLview is smarter (uses
** asyncio.library if present, for example), so this one serves only a
** teaching purpose. */
ULONG __saveds HTMLviewer_LoadFunc(REG(a0) struct Hook *h,REG(a1) struct HTMLview_LoadMsg *lmsg,REG(a2) Object *obj)
{
	FILE *fp = (FILE *)lmsg->lm_Userdata; // Our file handle

	switch(lmsg->lm_Type)
	{
		case HTMLview_Open: /* Just open the file */
			{
				char *filename = lmsg->lm_Open.URL;
				if(!strncmp(filename,"file://",7))
					filename += 7;
				return((ULONG)(lmsg->lm_Userdata = fopen(filename,"r")));
			}
		case HTMLview_Close: /* And close it again */
			fclose(fp);
			break;
		case HTMLview_Read: /* Read from the file */
			return(fread(lmsg->lm_Read.Buffer,1,lmsg->lm_Read.Size,fp));
	}
	return(0);
}

/* Override the HTMLview_GotoURL so that we can update our link histories */
ULONG HTMLviewer_GotoURL(struct IClass *cl,Object *obj,struct MUIP_HTMLview_GotoURL *msg)
{
	struct HTMLviewer_Data *data = (struct HTMLviewer_Data *)INST_DATA(cl,obj);
	char *NewLink;
	int i;

	/* Insert the new link in the history */
	if(NewLink = (char *)AllocVec(strlen(msg->URL)+1,NULL))
	{
		char *NewTarget = 0;
		struct HistoryItem *NewItem;

		strcpy(NewLink,msg->URL);
		/* Copy the target too */
		if(msg->Target)
		{
			/* It isn't dangerous if our AllocVec() fails here. If so, we just
			** get a NULL as Target, which is quite harmless. */
			if(NewTarget = (char *)AllocVec(strlen(msg->Target)+1,NULL))
				strcpy(NewTarget,msg->Target);
		}

		if(NewItem = (struct HistoryItem *)AllocVec(sizeof(struct HistoryItem),NULL))
		{
			/* Update the list position, cycle the buffer if we get too far */
			i = ++data->HistoryPosition;
			if(i >= HISTORYSIZE)
				i = data->HistoryPosition = 0;

			/* Free an existing entry? */
			FreeHistoryItem(data->History[i]);
			/* Now insert the new entry */
			NewItem->URL = NewLink;
			NewItem->Target = NewTarget;
			data->History[i] = NewItem;
		}
		else
		{
			FreeVec(NewLink);
			if(NewTarget)
				FreeVec(NewTarget);
		}
	}

	/* Insert the new link in the VLink list? */
	if(!DoMethod(obj,MUIM_HTMLview_VLink,msg->URL))
	{
		if(NewLink = (char *)AllocVec(strlen(msg->URL)+1,NULL))
		{
			strcpy(NewLink,msg->URL);

			/* Update the list position, cycle the buffer if we get too far */
			i = ++data->VisitedPosition;
			if(i >= VLINKSIZE)
				i = data->VisitedPosition = 0;

			/* Free an existing entry? */
			if(data->Visited[i])
				FreeVec(data->Visited[i]);
			/* Now insert the new entry */
			data->Visited[i] = NewLink;
		}
	}
	/* Now, let the superclass handle the loading! */
	return(DoSuperMethodA(cl,obj,(Msg)msg));
}

/* See if a link is in our VLink history */
ULONG HTMLviewer_VLink(struct IClass *cl,Object *obj,struct MUIP_HTMLview_VLink *msg)
{
	struct HTMLviewer_Data *data = (struct HTMLviewer_Data *)INST_DATA(cl,obj);
	int i;

	/* Just search in our plain list */
	for(i=0 ; i < VLINKSIZE ; i++)
	{
		if(data->Visited[i] && !strcmp(data->Visited[i],msg->URL))
			return(TRUE);
	}
	return(FALSE);
}

/* This method is called whenever the user presses a link */
ULONG HTMLviewer_ClickedURL(struct IClass *cl,Object *obj,struct MUIP_HTMLviewer_ClickedURL *msg)
{
	struct HTMLviewer_Data *data = (struct HTMLviewer_Data *)INST_DATA(cl,obj);
	ULONG target;

	get(obj,MUIA_HTMLview_Target,&target);
	DoMethod(obj,MUIM_HTMLview_GotoURL,msg->NewURL,target);
	return(0);
}

/* This method is called when the user presses the "Back" button */
ULONG HTMLviewer_Back(struct IClass *cl,Object *obj,Msg msg)
{
	struct HTMLviewer_Data *data = (struct HTMLviewer_Data *)INST_DATA(cl,obj);
	int i,oldpos;

	oldpos = data->HistoryPosition;
	/* Update the list position, cycle in the list if needed */
	i = oldpos-1;
	if(i < 0)
		i = HISTORYSIZE-1;

	/* See if we do have any history */
	if(!data->History[i])
		return(0);

	/* Free the current page from the list */
	FreeHistoryItem(data->History[oldpos]);
	data->History[oldpos] = 0;

	/* Load the last page, but only through our superclass. If our subclass
	** knows about this call, it will add the "Back" page to the history list... */
	DoSuperMethod(cl,obj,MUIM_HTMLview_GotoURL,data->History[i]->URL,data->History[i]->Target);

	data->HistoryPosition = i;
	return(0);
}

/* Open an ASL requester and let the user open a file */
ULONG HTMLviewer_OpenFile(struct IClass *cl,Object *obj,Msg msg)
{
	struct HTMLviewer_Data *data = (struct HTMLviewer_Data *)INST_DATA(cl,obj);

	if(!data->ASLreq)
	{
		/* Allocate an ASL requester */
		data->ASLreq = (struct FileRequester *)MUI_AllocAslRequestTags(ASL_FileRequest,
			ASLFR_TitleText,"Open an HTML file",
			ASLFR_DoPatterns,TRUE,
			ASLFR_InitialPattern,"#?.(html|htm)",
			ASLFR_RejectIcons,TRUE,
			TAG_END);
	}

	if(data->ASLreq)
	{
		/* Open the requester */
		if(MUI_AslRequestTags(data->ASLreq,TAG_END))
		{
			int FileNameLength;
			char *FileName;

			FileNameLength = strlen(data->ASLreq->fr_Drawer)+strlen(data->ASLreq->fr_File)+20;
			if(FileName = (char *)AllocVec(FileNameLength,0))
			{
				sprintf(FileName,"file://%s",data->ASLreq->fr_Drawer);
				AddPart(FileName+7,data->ASLreq->fr_File,FileNameLength-7);
				DoMethod(obj,MUIM_HTMLview_GotoURL,FileName,NULL);
				FreeVec(FileName);
			}
		}
	}
	return(0);
}

/* Initialize our object and data */
ULONG HTMLviewer_Init(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct HistoryItem **History;

	if(History = (struct HistoryItem **)AllocVec(HISTORYSIZE*sizeof(struct HistoryItem *),MEMF_CLEAR))
	{
		char **Visited;

		if(Visited = (char **)AllocVec(VLINKSIZE*sizeof(char *),MEMF_CLEAR))
		{
			static const struct Hook HTMLviewer_LoadHook = { { 0,0 }, (VOID *)HTMLviewer_LoadFunc,NULL,NULL };

			obj = (Object *)DoSuperNew(cl,obj,
				ReadListFrame,
				MUIA_HTMLview_LoadHook,&HTMLviewer_LoadHook,
				TAG_MORE,msg->ops_AttrList);

			if(obj)
			{
				struct HTMLviewer_Data *data = (struct HTMLviewer_Data *)INST_DATA(cl,obj);

				data->ASLreq = 0;
				data->History = History;
				data->Visited = Visited;
				data->HistoryPosition = 0;
				data->VisitedPosition = 0;

				/* Get notified when a URL is clicked, so that we can fetch the new page */
				DoMethod(obj,MUIM_Notify,MUIA_HTMLview_ClickedURL,MUIV_EveryTime,obj,2,MUIM_HTMLviewer_ClickedURL,MUIV_TriggerValue);
				return((ULONG)obj);
			}
			FreeVec(Visited);
		}
		FreeVec(History);
	}
	DisplayBeep(0);
	return((ULONG)0);
}

/* Clean up the mess we have created... */
ULONG HTMLviewer_Cleanup(struct IClass *cl,Object *obj,Msg msg)
{
	struct HTMLviewer_Data *data = (struct HTMLviewer_Data *)INST_DATA(cl,obj);
	int i;

	/* Free the ASL requester */
	if(data->ASLreq)
		MUI_FreeAslRequest(data->ASLreq);

	/* Free the history list */
	for(i=0; i < HISTORYSIZE; i++)
		FreeHistoryItem(data->History[i]);
	FreeVec(data->History);

	/* Free the VLink list */
	for(i=0; i < VLINKSIZE; i++)
	{
		if(data->Visited[i])
			FreeVec(data->Visited[i]);
	}
	FreeVec(data->Visited);

	/* And leave the rest to the superclass */
	return(DoSuperMethodA(cl,obj,msg));
}

/* Dispatcher for the HTMLview subclass */
ULONG __saveds HTMLviewer_Dispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{
	switch(msg->MethodID)
	{
		case OM_NEW:						return(HTMLviewer_Init      (cl,obj,(struct opSet *)msg));
		case OM_DISPOSE:					return(HTMLviewer_Cleanup   (cl,obj,msg));
		case MUIM_HTMLviewer_OpenFile:		return(HTMLviewer_OpenFile  (cl,obj,msg));
		case MUIM_HTMLviewer_ClickedURL:	return(HTMLviewer_ClickedURL(cl,obj,(struct MUIP_HTMLviewer_ClickedURL *)msg));
		case MUIM_HTMLviewer_Back:			return(HTMLviewer_Back      (cl,obj,msg));
		/* Override some methods */
		case MUIM_HTMLview_GotoURL:			return(HTMLviewer_GotoURL   (cl,obj,(struct MUIP_HTMLview_GotoURL *)msg));
		case MUIM_HTMLview_VLink:			return(HTMLviewer_VLink     (cl,obj,(struct MUIP_HTMLview_VLink *)msg));
	}
	return(DoSuperMethodA(cl,obj,msg));
}

/* Main function */
void main(void)
{
	Object *app;
	Object *WI_Main;
	Object *BT_Load;
	Object *BT_Abort;
	Object *BT_Reload;
	Object *BT_Back;
	Object *HV_Viewer;
	Object *SB_Bottom;
	Object *SB_Right;
	Object *TX_URL;
	struct RDArgs *args;
	LONG argarray[1] = {0};

	ULONG sigs = 0;
	ULONG res = 5;

	/* Let us make sure we have enough stack space - we'll add 8kb to the stack */
	struct StackSwapStruct stackswap;
	struct Task *mytask   = FindTask(NULL);
	ULONG  stacksize      = (ULONG)mytask->tc_SPUpper-(ULONG)mytask->tc_SPLower+8192;
	APTR   newstack       = AllocVec(stacksize, 0L);

	stackswap.stk_Lower   = newstack;
	stackswap.stk_Upper   = (ULONG)newstack+stacksize;
	stackswap.stk_Pointer = (APTR)stackswap.stk_Upper;

	if(newstack)
	{
		StackSwap(&stackswap);

		if(MUIMasterBase = OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))
		{
			if(CL_HTMLviewer = MUI_CreateCustomClass(NULL,MUIC_HTMLview,NULL,sizeof(struct HTMLviewer_Data),HTMLviewer_Dispatcher))
			{
				app = ApplicationObject,
					MUIA_Application_Title      , "HTMLview-Demo",
					MUIA_Application_Version    , "$VER: HTMLview-Demo V1.0 (11-Aug-98)",
					MUIA_Application_Copyright  , "©1998 Ole Friis",
					MUIA_Application_Author     , "Ole Friis",
					MUIA_Application_Description, "HTMLview.mcc demo program",
					MUIA_Application_Base       , "HTMLVIEWDEMO",
					SubWindow, WI_Main = WindowObject,
						MUIA_Window_ID, MAKE_ID('M','A','I','N'),
						MUIA_Window_UseRightBorderScroller,TRUE,
						MUIA_Window_UseBottomBorderScroller,TRUE,
						WindowContents, VGroup,
							Child, HGroup,
								Child, TX_URL = TextObject,
									TextFrame,
									MUIA_Weight,300,
									End,
								Child, BT_Load = SimpleButton("_Open"),
								Child, BT_Abort = SimpleButton("_Abort"),
								Child, BT_Reload = SimpleButton("_Reload"),
								Child, BT_Back = SimpleButton("_Back"),
								End,
							Child, HGroup,
								Child, HV_Viewer = (Object *)NewObject(CL_HTMLviewer->mcc_Class,NULL,TAG_DONE),
								Child, SB_Right = ScrollbarObject,
									MUIA_Prop_UseWinBorder,MUIV_Prop_UseWinBorder_Right,
									End,
								End,
							Child, SB_Bottom = ScrollbarObject,
								MUIA_Group_Horiz,TRUE,
								MUIA_Prop_UseWinBorder,MUIV_Prop_UseWinBorder_Bottom,
								End,
							End,
						End,
					End;

				if(app)
				{
					ULONG open;

					/* Get notified on window close request */
					DoMethod(WI_Main,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

					/* The various buttons */
					DoMethod(BT_Load  ,MUIM_Notify,MUIA_Pressed,FALSE,HV_Viewer,1,MUIM_HTMLviewer_OpenFile);
					DoMethod(BT_Abort ,MUIM_Notify,MUIA_Pressed,FALSE,HV_Viewer,1,MUIM_HTMLview_Abort);
					DoMethod(BT_Reload,MUIM_Notify,MUIA_Pressed,FALSE,HV_Viewer,1,MUIM_HTMLview_Reload);
					DoMethod(BT_Back  ,MUIM_Notify,MUIA_Pressed,FALSE,HV_Viewer,1,MUIM_HTMLviewer_Back);

					/* The "You're over this URL" text field */
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_HTMLview_CurrentURL,MUIV_EveryTime,TX_URL,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue);

					/* Window title */
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_HTMLview_Title,MUIV_EveryTime,WI_Main,3,MUIM_Set,MUIA_Window_Title,MUIV_TriggerValue);

					/* The scrollbar in the right window border */
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_Virtgroup_Height,MUIV_EveryTime,SB_Right,3,MUIM_NoNotifySet,MUIA_Prop_Entries,MUIV_TriggerValue);
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_Virtgroup_Top   ,MUIV_EveryTime,SB_Right,3,MUIM_NoNotifySet,MUIA_Prop_First  ,MUIV_TriggerValue);
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_Height          ,MUIV_EveryTime,SB_Right,3,MUIM_NoNotifySet,MUIA_Prop_Visible,MUIV_TriggerValue);
					DoMethod(SB_Right ,MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,HV_Viewer,3,MUIM_NoNotifySet,MUIA_Virtgroup_Top,MUIV_TriggerValue);

					/* The scrollbar in the bottom window border */
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_Virtgroup_Width,MUIV_EveryTime,SB_Bottom,3,MUIM_NoNotifySet,MUIA_Prop_Entries,MUIV_TriggerValue);
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_Virtgroup_Left ,MUIV_EveryTime,SB_Bottom,3,MUIM_NoNotifySet,MUIA_Prop_First  ,MUIV_TriggerValue);
					DoMethod(HV_Viewer,MUIM_Notify,MUIA_Width          ,MUIV_EveryTime,SB_Bottom,3,MUIM_NoNotifySet,MUIA_Prop_Visible,MUIV_TriggerValue);
					DoMethod(SB_Bottom,MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,HV_Viewer,3,MUIM_NoNotifySet,MUIA_Virtgroup_Left,MUIV_TriggerValue);

					/* Make the HTMLview object the default object */
					set(WI_Main,MUIA_Window_DefaultObject,HV_Viewer);

					/* Set some standard "Hello" text */
					set(HV_Viewer,MUIA_HTMLview_Contents,
						"<HTML><HEAD><TITLE>HTMLview demo</TITLE></HEAD><BODY>"
						"<H1>HTMLview demo</H1>"
						"This is a simple demonstration of the HTMLview MUI "
						"custom class. Please press any of the buttons above "
						"to open HTML files etc.<P>"
						"From CLI, you can start the demo with a URL as parameter, "
						"e.g.:<BR><BR>"
						"<TT>HTMLview-demo file://work:HTML/My_File.html</TT><BR><BR>"
						"Please note that this program is only a small demo, not "
						"an entire browser, although it can be used as a small "
						"&quot;discount HTML viewer&quot;. Feel free to improve "
						"on the HTMLview-demo.c source yourself and add better "
						"history, AppWindow support, more colorful buttons, "
						"pulldown menues, network support, ..."
						"</BODY></HTML>");

					/* See if we have any command-line parameters */
					if(args = ReadArgs("URL/F",argarray,NULL))
					{
						/* Yup, open an URL */
						if(argarray[0] && strlen((STRPTR)argarray[0]))
							DoMethod(HV_Viewer,MUIM_HTMLview_GotoURL,argarray[0],NULL);
						FreeArgs(args);
					}

					/* Open the window */
					set(WI_Main,MUIA_Window_Open,TRUE);
					get(WI_Main,MUIA_Window_Open,&open);
					if(open)
					{
						res = 0;
						while(DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
						{
							if(sigs)
							{
								sigs = Wait(sigs | SIGBREAKF_CTRL_C);

								/* Quit when receiving break from console */
								if(sigs & SIGBREAKF_CTRL_C)
									break;
							}
						}
					}
					MUI_DisposeObject(app);
				}
				MUI_DeleteCustomClass(CL_HTMLviewer);
			}
			CloseLibrary(MUIMasterBase);
		}
		StackSwap(&stackswap);
		FreeVec(newstack);
	}
	exit(res);
}

/* StormC specific */
void wbmain(void)
{
	main();
}
