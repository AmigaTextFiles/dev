/**************************************
 *                                    *
 *         MimeEditor-demo.c          *
 *                                    *
 * By Ole Friis <ole_f@post3.tele.dk> *
 *    Use it for whatever you like    *
 *                                    *
 * Written in StormC. Might require   *
 * slight modifications for other     *
 * compilers.                         *
 **************************************/

// Include files
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include <clib/alib_protos.h>
#include <datatypes/datatypesclass.h>
#include <exec/exec.h>
#include <exec/types.h>
#include <proto/datatypes.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/muimaster.h>
#include <proto/utility.h>
#include <proto/graphics.h>
#include <utility/utility.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>

#include <libraries/asl.h>
#include <libraries/mui.h>
#include <clib/muimaster_protos.h>
#include <mui/TextEditor_mcc.h>
#include <mui/Toolbar_mcc.h>
#include <mui/BetterString_mcc.h>
#include <mui/MimeEditor_mcc.h>

#define REG(x) register __ ## x

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

// Tags
#define MUISERIALNR_OLE 1
#define TAGBASE_OLE			(TAG_USER | (MUISERIALNR_OLE << 16))
enum
{
	MUIM_EditorWindow_OpenFile = TAGBASE_OLE,
	MUIM_EditorWindow_SaveFile,
	MUIM_EditorWindow_ReplyFile,
	MUIM_EditorWindow_ForwardFile,
	MUIM_EditorWindow_Finish,
	MUIM_EditorWindow_Changed,
	MUIA_EditorWindow_FileName,
	MUIA_EditorWindow_ReplyFile,
	MUIA_EditorWindow_ForwardFile,
	MUIA_EditorWindow_MainWindow,
};

#define MyButtonObject(name,key)\
		TextObject,\
				ButtonFrame,\
				MUIA_Text_Contents, name,\
				MUIA_Text_PreParse, "\33c",\
				MUIA_Text_HiChar  , key,\
				MUIA_ControlChar  , key,\
				MUIA_InputMode    , MUIV_InputMode_RelVerify,\
				MUIA_Background   , MUII_ButtonBack,\
				MUIA_CycleChain   , 1

struct EditorWindow_Data
{
	char	*FileName;
	struct FileRequester *AslStructure;
	Object	*GR_MimeEditor;
};

struct Library *MUIMasterBase;
struct Library *UtilityBase;

struct MUI_CustomClass *CL_EditorWindow;
APTR MemoryPool;

struct MUIP_EditorWindow_Finish
{
	ULONG MethodID;
	ULONG EndMode;
};

struct MUIP_EditorWindow_SaveFile
{
	ULONG MethodID;
	char  *FileName;
};

struct MUIP_EditorWindow_ReplyFile
{
	ULONG MethodID;
	char  *FileName;
};

struct MUIP_EditorWindow_OpenFile
{
	ULONG	MethodID;
	char	*FileName;
};

// ************************
// *    Help functions    *
// ************************
ULONG DoSuperNew(struct IClass *cl,Object *obj,ULONG tag1,...)
{
	return(DoSuperMethod(cl,obj,OM_NEW,&tag1,NULL));
}

Object *xget(Object *obj,ULONG attribute)
{
	Object *x;
	get(obj,attribute,&x);
	return(x);
}

void StrDup(char **NewString,char *FromString)
{
	if(FromString)
	{
		if(*NewString = (char *)AllocPooled(MemoryPool,strlen(FromString)+1))
			strcpy(*NewString,FromString);
	}
	else
		*NewString = 0;
}

void FreeString(char *FreeMe)
{
	if(FreeMe)
		FreePooled(MemoryPool,FreeMe,strlen(FreeMe)+1);
}

// Calls ASL, returns the selected file name:
char *CallAsl(struct FileRequester *fr,struct Window *w,ULONG DoSaveMode,char *TitleText)
{
	// Show the ASL requester
	if(MUI_AslRequestTags(fr,
		ASLFR_Window, w,
		ASLFR_DoSaveMode, DoSaveMode,
		ASLFR_TitleText, TitleText,
		TAG_END))
	{
		int    PathNameLength;
		char   *TempFileName;

		// Be sure we allocate enough memory
		PathNameLength = strlen(fr->fr_Drawer)+strlen(fr->fr_File) + 5;
		if(TempFileName = AllocPooled(MemoryPool,PathNameLength))
		{
			char *FileName;

			// Put the correct path and file name into the string
			strcpy (TempFileName,fr->fr_Drawer);
			AddPart(TempFileName,fr->fr_File  ,PathNameLength);

			// Now allocate a correctly sized piece of memory
			if(FileName = AllocPooled(MemoryPool,strlen(TempFileName)+1))
			{
				strcpy(FileName,TempFileName);
				FreePooled(MemoryPool,TempFileName,PathNameLength);

				return(FileName);
			}
			FreePooled(MemoryPool,TempFileName,PathNameLength);
		}
	}
	return(0);
}

// **************************
// *   Editorwindow class   *
// **************************
ULONG EditorWindow_Finish(struct IClass *cl,Object *obj,struct MUIP_EditorWindow_Finish *msg)
{
	DoMethod(_app(obj),MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	return(0);
}

// Frees the resources taken up by the object
ULONG EditorWindow_FreeResources(Object *obj, struct EditorWindow_Data *data)
{
	FreeString(data->FileName);
	return(0);
}

ULONG EditorWindow_SaveFile(struct IClass *cl,Object *obj,struct MUIP_EditorWindow_SaveFile *msg)
{
	struct EditorWindow_Data *data = INST_DATA(cl,obj);
	struct Window *w;
	char *FileName;
	char *ExtraHeaders[] = { "X-MIME-Editor: MimeEditor.mcc demo", NULL };

	// Show the ASL requester
	get(obj,MUIA_Window_Window,&w);
	FileName = CallAsl(data->AslStructure,w,TRUE,"Please select destination file");

	if(FileName)
	{
		// See if the user chose the same file, which he mustn't!
		if(data->FileName)
		{
			if(strcmp(FilePart(FileName),FilePart(data->FileName)) == 0)
			{
				MUI_RequestA(xget(obj,MUIA_ApplicationObject),
					obj,0,"File name conflict","*_Ok",
					"You must not save under the same file name as\n"
					"the message you are editing. This is because of\n"
					"some tricky routines ;-)\n",0);
				FreeString(FileName);
				return(0);
			}
		}
		// Let the EditParts object handle the rest:
		DoMethod(data->GR_MimeEditor,MUIM_MimeEditor_SaveFile,FileName,
				"Anybody <marsman@moon.com>",ExtraHeaders);
		FreeString(FileName);
	}
	return(0);
}

ULONG EditorWindow_OpenFile(struct IClass *cl,Object *obj,struct MUIP_EditorWindow_OpenFile *msg)
{
	struct EditorWindow_Data *data = INST_DATA(cl,obj);
	char *FileName;
	struct Window *w;

	// Show the ASL requester
	get(obj,MUIA_Window_Window,&w);
	FileName = CallAsl(data->AslStructure,w,FALSE,"Please select MIME file to edit");

	if(FileName)
	{
		// Free the structures etc. which the current MIME file takes:
		EditorWindow_FreeResources(obj,data);
		data->FileName = FileName;
		// Now that data->FileName is correct, let the EditParts object
		// handle the rest:
		return(DoMethod(data->GR_MimeEditor,MUIM_MimeEditor_OpenFile,FileName,NULL,NULL,NULL));
	}
	return(FALSE);
}

ULONG EditorWindow_ReplyFile(struct IClass *cl,Object *obj,struct MUIP_EditorWindow_ReplyFile *msg)
{
	struct EditorWindow_Data *data = INST_DATA(cl,obj);
	char *FileName;
	struct Window *w;

	// Show the ASL requester
	get(obj,MUIA_Window_Window,&w);
	FileName = CallAsl(data->AslStructure,w,FALSE,"Please select MIME file to reply to");

	if(FileName)
	{
		// Free the structures etc. which the current MIME file takes:
		EditorWindow_FreeResources(obj,data);
		data->FileName = FileName;
		// Now that data->FileName is correct, let the EditParts object
		// handle the rest:
		return(DoMethod(data->GR_MimeEditor,MUIM_MimeEditor_OpenFile,data->FileName,"> ",
			"%n wrote the following on the %d:\n\n","\n-- \nKind regards,\nOle"));
	}
	return(FALSE);
}

ULONG EditorWindow_Init(struct IClass *cl,Object *obj,struct opSet *msg)
{
	Object	*GR_MimeEditor;
	Object	*BT_EditFile;
	Object	*BT_ReplyFile;
	Object	*BT_SaveFile;
	struct  FileRequester *AslStructure;

	// Initialize ASL structure:
	AslStructure = MUI_AllocAslRequestTags(ASL_FileRequest,
		ASLFR_DoPatterns, TRUE,
		ASLFR_RejectIcons, TRUE,
		TAG_END);
	if(!AslStructure) return(NULL);

	obj = (Object *)DoSuperNew(cl,obj,
		MUIA_Window_ID, MAKE_ID('E','D','I','T'),
		MUIA_Window_Title, "MimeEditor-demo...",
		WindowContents, VGroup,
			Child, GR_MimeEditor = MimeEditorObject,
				MUIA_MimeEditor_IconDrawer,"PROGDIR:Images/",
				MUIA_MimeEditor_To,"Who knows?",
				MUIA_MimeEditor_Subject,"Wakey-wakey",
				End,
			Child, HGroup,
				Child, BT_EditFile  = MyButtonObject("Edit file" ,'e'),End,
				Child, BT_ReplyFile = MyButtonObject("Reply file",'r'),End,
				Child, BT_SaveFile  = MyButtonObject("Save file" ,'s'),End,
				End,
			End,
		End;

	if(obj)
	{
		struct EditorWindow_Data *data = INST_DATA(cl,obj);

		data->GR_MimeEditor = GR_MimeEditor;
		data->FileName      = 0;

		DoMethod(GR_MimeEditor,MUIM_MimeEditor_InsertText,"\n-- \nKind regards,\nOle");

		data->AslStructure = AslStructure;

		// Open file requester when the "Edit file", "Reply file", and
		// "Save file" buttons are pressed:
		DoMethod(BT_EditFile ,MUIM_Notify,MUIA_Pressed,FALSE,obj,1,MUIM_EditorWindow_OpenFile );
		DoMethod(BT_ReplyFile,MUIM_Notify,MUIA_Pressed,FALSE,obj,1,MUIM_EditorWindow_ReplyFile);
		DoMethod(BT_SaveFile ,MUIM_Notify,MUIA_Pressed,FALSE,obj,1,MUIM_EditorWindow_SaveFile );

		// Close on window close request
		DoMethod(obj,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,obj,1,MUIM_EditorWindow_Finish);
	}
	else
		DisplayBeep(0);

	return((ULONG)obj);
}

ULONG EditorWindow_Cleanup(struct IClass *cl,Object *obj,Msg msg)
{
	struct EditorWindow_Data *data = INST_DATA(cl,obj);

	EditorWindow_FreeResources(obj,data);
	MUI_FreeAslRequest(data->AslStructure);
	return(DoSuperMethodA(cl,obj,msg));
}

ULONG __saveds EditorWindow_Dispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{
	switch(msg->MethodID)
	{
		case OM_NEW:						return(EditorWindow_Init     (cl,obj,(APTR)msg));
		case OM_DISPOSE:					return(EditorWindow_Cleanup  (cl,obj,(APTR)msg));
		case MUIM_EditorWindow_OpenFile:	return(EditorWindow_OpenFile (cl,obj,(APTR)msg));
		case MUIM_EditorWindow_ReplyFile:	return(EditorWindow_ReplyFile(cl,obj,(APTR)msg));
		case MUIM_EditorWindow_Finish:		return(EditorWindow_Finish   (cl,obj,(APTR)msg));
		case MUIM_EditorWindow_SaveFile:	return(EditorWindow_SaveFile (cl,obj,(APTR)msg));
	}
	return(DoSuperMethodA(cl,obj,msg));
}

// **************************
// *    Main() functions    *
// **************************
int wbmain(struct WBStartup *wbstart)
{
	ULONG ReturnCode = RETURN_OK;
	struct StackSwapStruct stackswap;
	struct Task *mytask = FindTask(NULL);
	ULONG stacksize = (ULONG)mytask->tc_SPUpper - (ULONG)mytask->tc_SPLower + 8196;
	void *newstack = AllocVec(stacksize, 0L);

	// Create a bigger stack:
	stackswap.stk_Lower = newstack;
	stackswap.stk_Upper = (ULONG)newstack+stacksize;
	stackswap.stk_Pointer = (void *)stackswap.stk_Upper;
	if(newstack)
	{
		StackSwap(&stackswap);

		// Create memory pool
		if(MemoryPool = CreatePool(MEMF_CLEAR,4096,2048))
		{
			// Open shared libraries
			UtilityBase   = OpenLibrary(UTILITYNAME   ,0             );
			MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN);
			if(UtilityBase && MUIMasterBase)
			{
				if(CL_EditorWindow= MUI_CreateCustomClass(NULL,MUIC_Window,NULL,sizeof(struct EditorWindow_Data),EditorWindow_Dispatcher))
				{
					Object *app;
					Object *EditorWindow;

					app = ApplicationObject,
						MUIA_Application_Title, "MimeEditor.mcc demo",
						MUIA_Application_Author, "Leon Woestenberg & Ole Friis Østergaard",
						MUIA_Application_Copyright, "© 1997 Leon Woestenberg & Ole Friis Østergaard",
						MUIA_Application_Description, "Small example of the MimeEditor custom class",
						MUIA_Application_Version, "$VER: MimeEditor.mcc demo 1.0 (27.01.98)",
						SubWindow,
							EditorWindow = NewObject(CL_EditorWindow->mcc_Class,NULL,TAG_DONE),
						End;

					if(app)
					{
						ULONG signals;

						set(EditorWindow,MUIA_Window_Open,TRUE);
						while(DoMethod(app,MUIM_Application_NewInput,&signals) != MUIV_Application_ReturnID_Quit)
						{
							if(signals)
							{
								signals=Wait(signals | SIGBREAKF_CTRL_C);
								if(signals & SIGBREAKF_CTRL_C) break;
							}
						}

						// Delete app object
						MUI_DisposeObject(app);
					}
					else ReturnCode = RETURN_FAIL;

					MUI_DeleteCustomClass(CL_EditorWindow);
				}
				else ReturnCode = RETURN_FAIL;
			}
			else ReturnCode = RETURN_FAIL;

			// Close shared libraries
			if(UtilityBase  ) CloseLibrary(UtilityBase  );
			if(MUIMasterBase) CloseLibrary(MUIMasterBase);

			// Delete our memory pool
			DeletePool(MemoryPool);
		}
		// Swap back the stack
		StackSwap(&stackswap);
		FreeVec(newstack);
	}
	else
		ReturnCode = RETURN_FAIL;

	return(ReturnCode);
}

int main(void)
{
	return(wbmain(NULL));
}
