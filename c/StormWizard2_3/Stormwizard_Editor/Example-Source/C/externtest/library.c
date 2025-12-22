#include	<clib/alib_protos.h>
#include	<string.h>

#include	<exec/exec.h>
#include	<exec/memory.h>
#include	<exec/libraries.h>

#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>

#include	<pragma/exec_lib.h>
#include	<pragma/gadtools_lib.h>
#include	<pragma/graphics_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/layers_lib.h>
#include	<pragma/utility_lib.h>

#include	<graphics/clip.h>
#include	<graphics/rastport.h>

#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>
#include	<intuition/imageclass.h>

#include	<utility/utility.h>
#include	<libraries/wizard.h>

#include	"/wizardextern.h"

BOOL intern_init(void);
void intern_expunge(void);

BOOL intern_initlibs(void);
void intern_closelibs(void);

#pragma libbase Library

#define _LibNameString "testclass.library"
#define _LibVersionString "testclass.library V 1.0 (26.08.1996)"

extern ULONG HookEntry();

struct Library	*GfxBase;
struct Library	*IntuitionBase;
struct Library	*LayersBase;
struct Library	*UtilityBase;

#define ABS(a) (((a)>0)?(a):(-a))
#define MAX(a,b) (((a)>(b))?(a):(b))
#define MIN(a,b) (((a)<(b))?(a):(b))

// Init() ***********************************************************

void INIT_9_OpenLibs(void)
{
	GfxBase=OpenLibrary("graphics.library",37);
	IntuitionBase=OpenLibrary("intuition.library",37);
	LayersBase=OpenLibrary("layers.library",37);
	UtilityBase=OpenLibrary("utility.library",37);
};

// Exit() ***********************************************************

void EXIT_9_CloseLibs(void)
{
	CloseLibrary(GfxBase);
	CloseLibrary(IntuitionBase);
	CloseLibrary(LayersBase);
	CloseLibrary(UtilityBase);
};

// Dispatcher *******************************************************

struct testclass_Data
{
	BOOL Active;

	UWORD	MinWidth;
	UWORD	MinHeight;

	STRPTR Label;
	struct TextFont *Font;

	struct Rectangle ClipRectangle;
};




// button_KeyTest() *************************************************

ULONG testclass_KeyTest(struct IClass *class,struct Gadget *gad,
					struct testclass_Data *instdata,struct WizardKeyTest *msg)
{
	ULONG retval=FALSE;

/*	struct TagItem tags[2]; */

	if (!(gad->Flags&GFLG_DISABLED))
	{
		if (msg->wpkt_Key==*instdata->Label)
		{
			retval=TRUE;
			msg->wpkt_ActivateGadget=NULL;

/*			tags[0].ti_Tag=GA_ID;
			tags[0].ti_Data=gad->GadgetID;
			tags[1].ti_Tag=TAG_DONE;
*/
			DisplayBeep(NULL);

/*			DoSuperMethod(class,(Object *)gad,OM_NOTIFY,tags,msg->wpkt_GInfo,0); */
		}

	}

	return(retval);
};

// Render() *********************************************************

void testclass_Render(struct Gadget *obj,struct gpRender *msg,
											struct testclass_Data *instdata)
{
	struct Region *newregion;
	struct Region *oldregion;

	struct GadgetInfo	 *GInfo=msg->gpr_GInfo;
	struct DrawInfo *DrInfo=GInfo->gi_DrInfo;
	struct RastPort *RPort=msg->gpr_RPort;


	if ((newregion=NewRegion()))
	{
		OrRectRegion(newregion,&instdata->ClipRectangle);

		if (GInfo->gi_Window->Flags&WFLG_WINDOWREFRESH)
		{
			EndUpdate(GInfo->gi_Layer,FALSE);

			oldregion=InstallClipRegion(GInfo->gi_Layer,newregion);

			BeginUpdate(GInfo->gi_Layer);
		}
		else
			oldregion=InstallClipRegion(GInfo->gi_Layer,newregion);

		SetAPen(RPort,2);

		RectFill(RPort,obj->LeftEdge,obj->TopEdge,obj->LeftEdge+obj->Width-1,obj->TopEdge+obj->Height-1);

		SetAPen(RPort,1);
		SetDrMd(RPort,JAM1);

		SetFont(RPort,instdata->Font);

		Move(RPort,obj->LeftEdge,obj->TopEdge+instdata->Font->tf_Baseline+2);
		Text(RPort,instdata->Label,strlen(instdata->Label));

		InstallClipRegion(GInfo->gi_Layer,oldregion);

		DisposeRegion(newregion);
	}
};

// RenderClip() *****************************************************

void testclass_RenderClip(Object *obj,struct testclass_Data *instdata,struct WizardRenderClip *msg)
{
	struct Rectangle OldRectangle;

	OldRectangle=instdata->ClipRectangle;

	instdata->ClipRectangle.MinX=MAX(msg->wprc_ClipRectangle.MinX,
												OldRectangle.MinX);
	instdata->ClipRectangle.MinY=MAX(msg->wprc_ClipRectangle.MinY,
												OldRectangle.MinY);
	instdata->ClipRectangle.MaxX=MIN(msg->wprc_ClipRectangle.MaxX,
												OldRectangle.MaxX);
	instdata->ClipRectangle.MaxY=MIN(msg->wprc_ClipRectangle.MaxY,
												OldRectangle.MaxY);

	DoMethod(obj,GM_RENDER,msg->wprc_GInfo,msg->wprc_RPort,GREDRAW_REDRAW);

	instdata->ClipRectangle=OldRectangle;
}

// Dispatcher der Buttonklasse **************************************

ULONG testclass_Dispatcher(IClass *class,Object *obj,Msg msg)
{
	ULONG retval=NULL;

	struct testclass_Data *instdata;

	struct TagItem *tags;
	struct DrawInfo *drinfo;

	switch (msg->MethodID)
	{
		case OM_NEW:

			if ((retval=DoSuperMethodA(class,obj,msg)))
			{
				instdata=INST_DATA(class,retval);

				tags=((struct opSet *)msg)->ops_AttrList;

				drinfo=(struct DrawInfo *)GetTagData(GA_DrawInfo,NULL,tags);

				instdata->Label=(STRPTR)GetTagData(WGA_Label,(ULONG)"",tags);
				instdata->Font=(struct TextFont *)GetTagData(WGA_TextFont,(ULONG)drinfo->dri_Font,tags);

				instdata->MinWidth=GetTagData(WGA_MinWidth,0,tags);
				instdata->MinHeight=instdata->Font->tf_YSize+4;
			}
			break;

		case OM_DISPOSE:

			DoSuperMethodA(class,obj,msg);
			break;

		case OM_GET:

			retval=TRUE;
			instdata=INST_DATA(class,obj);

			switch (((struct opGet *)msg)->opg_AttrID)
			{
				case WGA_MinWidth:
					*(((struct opGet *)msg)->opg_Storage)=(ULONG)instdata->MinWidth;
					break;
				case WGA_MinHeight:
					*(((struct opGet *)msg)->opg_Storage)=(ULONG)instdata->MinHeight;
					break;

				default:
					retval=DoSuperMethodA(class,obj,msg);
			}
			break;

		case WEXTERNM_LAYOUT:

			instdata=INST_DATA(class,obj);

			instdata->ClipRectangle=((struct WizardLayout *)msg)->wpl_ClipRectangle;

			((struct Gadget *)obj)->LeftEdge=((struct WizardLayout *)msg)
									->wpl_Bounds.Left;

			((struct Gadget *)obj)->TopEdge=((((struct WizardLayout *)msg)
									->wpl_Bounds.Height-instdata->MinHeight)>>1)+
									((struct WizardLayout *)msg)->wpl_Bounds.Top;

			((struct Gadget *)obj)->Width=((struct WizardLayout *)msg)
									->wpl_Bounds.Width;

			((struct Gadget *)obj)->Height=instdata->MinHeight;

			instdata->ClipRectangle=((struct WizardLayout *)msg)
									->wpl_ClipRectangle;

			retval=DoSuperMethodA(class,obj,msg);

			break;


		case WEXTERNM_UPDATEPAGE:

			instdata=INST_DATA(class,obj);

			instdata->Active=((struct WizardUpdatePage *)msg)->wpup_Active;
			break;

		default:

			instdata=INST_DATA(class,obj);

			if (instdata->Active)
				switch(msg->MethodID)
				{
					case OM_SET:
					case OM_UPDATE:

						retval=DoSuperMethodA(class,obj,msg);
						break;

					case GM_HITTEST:

						retval=GMR_GADGETHIT;
						break;

					case GM_HELPTEST:

						retval=DoSuperMethodA(class,obj,msg);
						break;

					case GM_GOACTIVE:

						DisplayBeep(NULL);

						retval=GMR_NOREUSE;

						break;

					case GM_GOINACTIVE:

						break;

					case GM_HANDLEINPUT:
						break;

					case GM_RENDER:

						testclass_Render((struct Gadget *)obj,(struct gpRender *)msg,instdata);
						break;

					case WEXTERNM_RENDERCLIP:

						testclass_RenderClip(obj,instdata,(struct WizardRenderClip *)msg);

						retval=0;
						break;

					default:
						retval=DoSuperMethodA(class,obj,msg);
						break;

				}
			else
				switch(msg->MethodID)
				{
					case OM_SET:
					case OM_UPDATE:

						retval=DoSuperMethodA(class,obj,msg);
						break;

					case GM_HELPTEST:
						break;

					case GM_GOACTIVE:
						retval=GMR_NOREUSE;
						break;

					default:
						retval=DoSuperMethodA(class,obj,msg);
						break;
				}
	}

	return(retval);
};


// MakeClass() ****************************************************

struct IClass *privat_MakeClass(register __a0 struct IClass *parentclass)
{
	struct IClass *myclass;

	if ((myclass=MakeClass(0,0,parentclass,sizeof(testclass_Data),0)))
	{
		myclass->cl_Dispatcher.h_Entry=HookEntry;
		myclass->cl_Dispatcher.h_SubEntry=((ULONG(*)())&testclass_Dispatcher);
	}

	return(myclass);
};

// FreeClass() ***************************************************

void privat_FreeClass(register __a0 struct IClass *myclass)
{
	FreeClass(myclass);
};
