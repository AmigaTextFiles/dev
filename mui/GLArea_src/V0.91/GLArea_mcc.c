/*-------------------------------------------------
  Name: GLArea.mcc
  Version: 0.91
  Date: 27.1.2001
  Author: Bodmer Stephan (sbodmer@lsi-media.ch)
  Note: MUI Custom class for an OpenGL area
	GCC port
	StormMesa version
	Signal version
	MUILib supported for the lib init
	TaskList handling vias Exec list
	No more direct context in threaded mode
	Messages area available at bottom
---------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <exec/exec.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <dos/exall.h>
#include <libraries/mui.h>

#include <proto/alib.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include <proto/muimaster.h>
#include <proto/Amigamesa.h>

#include <mui/GLArea_mcc.h>

#include "GLArea.h"

#include "GLArea_mcc_lib.h"

#include <mui/MCCLib.c>

// #define DEBUG
#define DEBUGCON    "CON:"

// unsigned long __stack ={320000};

//--- Sharedvariables between ---
int sh_muinum=0;
int sh_rendernum=0;
struct SignalSemaphore sema={0};
struct Data *sh_data=NULL;
struct MinList GLArea_TaskList;
BPTR gfh=NULL;

struct Library *ImageManagerBase=NULL;

extern int GLArea_InitFunc(struct GLContext *glcontext);
// extern int GLArea_DrawImage(struct GLContext *glcontext, struct GLImage *glimage);

//--- Subtask
extern void GLArea_MUI_RenderingSubtask();

//--------------------------------------- MISCELENOUS INTERNAL FUNCTION ------------------------
/*
ULONG GLArea_mUpdateGauge(struct IClass *cl, Object *obj) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    double xmax=0.0;

    if (data->Max!=0) {
	// xmax=IEEESPDiv((float) _mwidth(obj),(float) data->Max)*data->Level;
	// printf("UPDATE GAUGE:%f\n",_mwidth(obj)/data->Max);
    }
    else {
	xmax=0;
    };
    #ifdef DEBUG
    // FPrintf(data->fh,"Update Gauge value:%ld new pos:%d\n",data->Level,(int) xmax);
    #endif
    if (data->Gauge) {
	SetAPen(_rp(obj),2);
	RectFill(_rp(obj),_mleft(obj),_mtop(obj)+_mheight(obj)-2,_mleft(obj)+xmax,_mtop(obj)+_mheight(obj)-1);
    };
    // RectFill(_rp(obj),_mleft(obj),_mtop(obj),xmax,2);
    return 1;
}
*/
/***************************************************************************************/
/*                       LIBRARIES INIT FUNCTION                                       */
/***************************************************************************************/
static BOOL ClassInitFunc(const struct Library *const base) {

    #ifdef DEBUG
    gfh=Open(DEBUGCON "0/0/400/100/GLArea.mcc",MODE_NEWFILE);
    FPrintf(gfh,"Version:" VERSIONSTR "\n");
    #endif

    NewList((struct List *) &GLArea_TaskList);
    InitSemaphore(&sema);
    //--- Very first object ---
    #ifdef DEBUG
    FPrintf(gfh,"!!! global task list initalised !!!\n");
    #endif

    return TRUE;
}
static void ClassExitFunc(const struct Library *const base) {

    #ifdef DEBUG
    Close(gfh);
    #endif
    // CloseLibrary((struct Library *) MathIeeeSingBasBase);
};

/*****************************************************************************************/
/*                                MUI CUSTOM CLASS                                       */
/*****************************************************************************************/
/*-----------------------------------------
  OM_NEW method
-------------------------------------------*/
ULONG GLArea_mNew (struct IClass *cl, Object *obj, struct opSet *msg ) {
    struct GLArea_MUI_ListEntry *current=(struct GLArea_MUI_ListEntry *) GLArea_TaskList.mlh_Head,*newnode=NULL;
    struct Data *data=NULL;
    struct Library *glBase=NULL;
    struct Library *gluBase=NULL;
    struct Library *glutBase=NULL;
    struct glreg gl_reg;
    struct glureg glu_reg;
    struct glutreg glut_reg;
    struct Task *thistask=FindTask(NULL);
    char temp[255];
    BOOL exist=FALSE;

    if (!(obj= (Object *) DoSuperMethodA(cl,obj,(Msg) msg))) {
	// puts("Error creating new object");
	return 0;
    };
    data=(struct Data *) INST_DATA(cl,obj);

    sh_muinum=sh_muinum+1;
    #ifdef DEBUG
    sprintf(temp, DEBUGCON "%ld/%ld/400/200/GLArea object:%ld\n",(sh_muinum*20),((sh_muinum*20)+300),sh_muinum);
    data->fh=Open(temp,MODE_NEWFILE);
    FPrintf(data->fh,"---GLAREA OBJECT---\n");
    // FPrintf(data->fh,"mNew\n");
    #endif

    //------ context --------
    data->glcontext.context=NULL;
    data->glcontext.gl_Base=NULL;
    data->glcontext.glu_Base=NULL;
    data->glcontext.glut_Base=NULL;
    data->glcontext.glarea=obj;
    data->glcontext.fh=NULL;
    data->glcontext.spare=NULL;
    data->thread=NULL;
    data->maintask=FindTask(NULL);
    // data->renderport=NULL;

    //------- Functions ----------
    data->drawfunc=NULL;
    data->drawfunc2=NULL;
    data->drawpostfunc=NULL;
    data->mousedownfunc=NULL;
    data->mousemovefunc=NULL;
    data->mouseupfunc=NULL;
    data->resetfunc=NULL;
    data->initfunc=NULL;
    
    //-------- Attributs -----------
    data->Buffered=TRUE;
    data->FullScreen=FALSE;
    data->Threaded=TRUE;
    data->Status=-1;
    data->msgheight=0;
    data->SingleTask=FALSE;

    data->ehnode.ehn_Priority=0;
    data->ehnode.ehn_Flags=0;
    data->ehnode.ehn_Events=IDCMP_MOUSEBUTTONS;
    data->ehnode.ehn_Object=obj;
    data->ehnode.ehn_Class=cl;
    data->MinHeight=60;data->MaxHeight=600;data->DefHeight=240;
    data->MinWidth=80;data->MaxWidth=800;data->DefWidth=320;

    msg->MethodID = OM_SET;
    DoMethodA(obj, (Msg) msg);
    msg->MethodID = OM_NEW;

    data->Status=MUIV_GLArea_NotActive;

    while (current) {
	if (current->task==thistask) {
	    exist=TRUE;
	    break;
	};
	current=(struct GLArea_MUI_ListEntry *) current->node.mln_Succ;
    };

    if (exist==FALSE) {
	#ifdef DEBUG
	// FPrintf(data->fh,"===>Init listentry for this task\n");
	// FPrintf(data->fh,"Task:%s\n",thistask->tc_Node.ln_Name);
	#endif
	newnode=(struct GLArea_MUI_ListEntry *) AllocVec(sizeof(struct GLArea_MUI_ListEntry),MEMF_FAST|MEMF_CLEAR);
	newnode->muinum=1;
	newnode->retsignal=0;
	newnode->task=thistask;
	AddTail((struct List *) &GLArea_TaskList,(struct Node *) newnode);
	current=newnode;

	//--- Open global GL bases
	glBase=OpenLibrary("agl.library",0);
	if (glBase==NULL) {
	    #ifdef DEBUG
	    FPrintf(data->fh,"Failed to open 'agl.library'\n");
	    #endif
	    return NULL;
	    _LibExtFunc();
	};
	gluBase=OpenLibrary("aglu.library",0);
	if (gluBase==NULL) {
	    #ifdef DEBUG
	    FPrintf(data->fh,"Failed to open 'aglu.library'\n");
	    #endif
	    return NULL;
	    _LibExtFunc();
	};
	glutBase=OpenLibrary("aglut.library",0);
	if (glutBase==NULL) {
	    #ifdef DEBUG
	    FPrintf(data->fh,"Failed to open 'aglut.library'\n");
	    #endif
	    return NULL;
	    _LibExtFunc();
	};
	CacheClearU();
	gl_reg.size = (int)sizeof(struct glreg);
	gl_reg.func_exit = (void *) _LibExtFunc;
	registerGL(&gl_reg);
	glu_reg.size = (int)sizeof(struct glureg);
	glu_reg.glbase = glBase;
	registerGLU(&glu_reg);
	glut_reg.size = (int)sizeof(struct glutreg);
	glut_reg.func_exit = (void *) _LibExtFunc;
	glut_reg.glbase = glBase;
	glut_reg.glubase = gluBase;
	registerGLUT(&glut_reg);
	current->gl_Base=glBase;
	current->glu_Base=gluBase;
	current->glut_Base=glutBase;
	current->retsignal=AllocSignal(-1);
	current->sigmask=(1<<current->retsignal);
	data->sharedlist=current;
	data->glcontext.gl_Base=glBase;
	data->glcontext.glu_Base=gluBase;
	data->glcontext.glut_Base=glutBase;

	#ifdef DEBUG
	// FPrintf(data->fh,"Global glBase:%ld gluBase:%ld glutBase:%ld\n",
	//        (ULONG) data->sharedlist->gl_Base, (ULONG) data->sharedlist->glu_Base, (ULONG) data->sharedlist->glut_Base);
	// FPrintf(data->fh,"Signalmask:%lu\n",data->sharedlist->sigmask);
	// FPrintf(data->fh,"Current:%ld\n",data->sharedlist->muinum);
	#endif
    }
    else {
	current->muinum++;
	data->sharedlist=current;
	data->glcontext.gl_Base=current->gl_Base;
	data->glcontext.glu_Base=current->glu_Base;
	data->glcontext.glut_Base=current->glut_Base;
    };

    if (data->SingleTask==FALSE) {
	sh_rendernum++;
	sprintf(temp,"%s_%ld",SUBTASKNAME,sh_rendernum);
	#ifdef DEBUG
	FPrintf(data->fh,"Spawning subprocess:%s\n",temp);
	#endif
	ObtainSemaphore(&sema);
	sh_data=data;
	// #ifdef DEBUG
	data->thread=CreateNewProcTags(NP_Name,(ULONG) temp,
				       NP_Priority, -1,
				       NP_Entry, (ULONG) GLArea_MUI_RenderingSubtask,
				       NP_StackSize, 128000,
				       TAG_DONE);
	/*
	#else
	data->thread=(struct Process *) CreateTask(temp,-1,GLArea_MUI_RenderingSubtask,128000);
	#endif
	*/
	//------- Wait for the reply of my subtask ----------
	Wait(data->sharedlist->sigmask);
	ReleaseSemaphore(&sema);
	#ifdef DEBUG
	// FPrintf(data->fh,"Received dummy confirmatrion\n");
	#endif
    };
    // puts("Init sucessful in mNew");
    #ifdef DEBUG
    // FPrintf(data->fh,"<=mNew\n");
    #endif
    return (ULONG) obj;
}
/*------------------------
  MUIM_Setup method
--------------------------*/
ULONG GLArea_mSetup (struct IClass *cl, Object *obj, Msg msg ) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    char temp[255];
    // int num=0;

    // puts("In mSetup");
    #ifdef DEBUG
    // FPrintf(data->fh,"mSetup\n");
    #endif
    if (!(DoSuperMethodA(cl,obj,msg))) return FALSE;

    data->x=0;data->dx=0;
    data->y=0;data->dy=0;
    data->down=FALSE;
    data->glcontext.app=(APTR) _app(obj);
    data->glcontext.glarea=(APTR) obj;
    DoMethod(_win(obj), MUIM_Window_AddEventHandler, (struct MUI_EventHandlerNode *) &data->ehnode);

    //------ Init shared variable ----
    // sh_listentry=data->sharedlist;

    //------ Create Sub process -----------
    /*
    if (data->SingleTask==FALSE) {
	sh_rendernum++;
	sprintf(temp,"%s_%ld",SUBTASKNAME,sh_rendernum);
	#ifdef DEBUG
	// FPrintf(data->fh,"rendernum:%ld\n",sh_rendernum);
	FPrintf(data->fh,"Spawning subprocess:%s\n",temp);
	#endif
	data->thread=CreateNewProcTags(NP_Name,(ULONG) temp,
				       NP_Priority, -1,
				       NP_Entry, (ULONG) GLArea_MUI_RenderingSubtask,
				       NP_StackSize, 320000,
				       TAG_DONE);

	//------- Wait for the reply of my subtask ----------
	Wait(data->sharedlist->sigmask);
	data->renderport=sh_renderport;

	#ifdef DEBUG
	FPrintf(data->fh,"My renderport:%ld\n",data->renderport);
	#endif
	data->glmsg.mn_ReplyPort=data->sharedlist->glareaport;
    }
    else {
	//--- Single task ---

    };
    */
    return TRUE;
}
/*-----------------------------
  MUIM_AskMinMax
-------------------------------*/
ULONG GLArea_mAskMinMax(struct IClass *cl, Object *obj, struct MUIP_AskMinMax *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    #ifdef DEBUG
    // FPrintf(data->fh,"mAskMinMax %ld %ld\n",data->DefWidth,data->DefHeight);
    #endif
    DoSuperMethodA(cl,obj,(Msg) msg);
    msg->MinMaxInfo->MinWidth+=data->MinWidth;
    msg->MinMaxInfo->DefWidth+=data->DefWidth;
    msg->MinMaxInfo->MaxWidth+=data->MaxWidth;

    msg->MinMaxInfo->MinHeight+=data->MinHeight;
    msg->MinMaxInfo->DefHeight+=data->DefHeight;
    msg->MinMaxInfo->MaxHeight+=data->MaxHeight;
    return TRUE;
}
/*----------------------------
  MUIM_Show
------------------------------*/
ULONG GLArea_mShow (struct IClass *cl, Object *obj, Msg msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;
    ULONG store=0;
    struct TagItem contexttags[12];
    data->glcontext.fh=data->fh;

    // data->sharedlist->glcontext.glarea=obj;
    // GetAttr(MUIA_Font, (Object *) _app(obj), &store);
    SetFont(_rp(obj), _font(_app(obj)));
    // puts("mShow");
    #ifdef DEBUG
    // FPrintf(data->fh,"=>mShow\n");
    #endif
    if (data->SingleTask==FALSE) {
	data->command=GLAREA_SHOWME;
	Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	Wait(data->sharedlist->sigmask);
	if (data->result==GLAREA_ERROR) {
	    MUI_Request (_app(obj),_win(obj),0,"About","Ok","Error opening StormMesa context\n");
	};
    }
    else {
	#ifdef DEBUG
	// FPrintf(data->fh,"Creating singletask context\n");
	#endif

	//----------- Direct MUI draw context -------------
	data->glcontext.context=AmigaMesaCreateContextTags(AMA_RGBMode,TRUE,
								   AMA_Left, _mleft(data->glcontext.glarea),
								   AMA_Bottom, _window(obj)->Height-(_mtop(obj)+_mheight(obj))+data->msgheight,
								   AMA_Width, _mwidth(obj),
								   AMA_Height, _mheight(obj)-data->msgheight,
								   AMA_RastPort, (ULONG) _rp(obj),
								   AMA_Screen, (ULONG) _screen(obj),
								   AMA_DoubleBuf, data->Buffered,
								   AMA_AlphaFlag, TRUE,
								   // AMA_Forbid3DHW, TRUE,
								   AMA_DirectRender, TRUE,
								   AMA_Fullscreen, data->FullScreen,
								   TAG_DONE);
	// data->sharedlist->glcontext.context=data->context;
    
	//--- Display message
	if (data->msgheight>=8) {
	    // Move(_rp(obj),
	    // Text(_rp(obj),"Drawing",7);
	};

	if (data->glcontext.context) {
	    AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);
	    if (data->initfunc) {
		data->initfunc(&data->glcontext);
	    };
	    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
	}
	else {
	    // puts("direct context error");
	    MUI_Request (_app(obj),_win(obj),0,"About","Ok","Error opening StormMesa context\n");
	    #ifdef DEBUG
	    FPrintf(data->fh,"StormMesa context NULL !!! \n");
	    #endif
	    RectFill(_rp(obj),
		     _left(obj),_top(obj),
		     _right(obj),_bottom(obj));
	    Move(_rp(obj),_left(obj),_top(obj)+10);
	    SetAPen(_rp(obj),10);
	    Text(_rp(obj),"StormMesa library error",23);
	    return FALSE;
	};
    };
    #ifdef DEBUG
    // FPrintf(data->fh,"<=mShow\n");
    #endif
    return (DoSuperMethodA(cl,obj,msg));
    // return FALSE;
}
/*------------------
  MUIM_Draw
--------------------*/
ULONG GLArea_mDraw(struct IClass *cl, Object *obj, struct MUIP_Draw *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;
    char temp[255];
    int num=0;
    data->glcontext.fh=data->fh;

    #ifdef DEBUG
    // FPrintf(data->fh,"=>mDraw\n");
    // Delay(100);
    #endif
    //--- slow down the process
    DoSuperMethodA(cl,obj,(Msg) msg);

    if (data->SingleTask==FALSE) {
	if (data->Status==MUIV_GLArea_Busy) {
	    #ifdef DEBUG
	    // FPrintf(data->fh,"Render is busy, break it via signal\n");
	    #endif
	    Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
	    Wait(data->sharedlist->sigmask);
	    // data->Status=MUIV_GLArea_Ready;
	    #ifdef DEBUG
	    // FPrintf(data->fh,"received confirmation\n");
	    #endif
	};

	data->command=DRAWME;
	// PutMsg(data->renderport,(struct Message *) data);
	Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	// WaitPort(data->sharedlist->glareaport);
	Wait(data->sharedlist->sigmask);
	// data=(struct Data *) GetMsg(data->sharedlist->glareaport);
	if (data->result==GLAREA_ERROR) {
	    MUI_Request(_app(obj),_win(obj),0,"GLArea error","Hmmm...",
			"Some error happened during rendering\n\n"
			"For more information contact your system adminstrator ;^)\n");
	};
	// else {
	//    data->Status=data->result;
	// };
    }
    else {
	AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);
	if (data->drawfunc) {
	    data->drawfunc(&data->glcontext);
	    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
	    data->Status=MUIV_GLArea_Ready;
	    data->result=GLAREA_OK;
	    data->command=GLAREA_NOTHING;
	};
    };
    // puts("Out of mDraw");
    #ifdef DEBUG
    // FPrintf(data->fh,"<=mDraw\n");
    #endif
    return TRUE;
}
/*------------------
  MUIM_Hide
--------------------*/
ULONG GLArea_mHide (struct IClass *cl, Object *obj, Msg msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;
    data->glcontext.fh=data->fh;

    #ifdef DEBUG
    // FPrintf(data->fh,"=>mHide\n");
    #endif
    if (data->SingleTask==FALSE) {
	if (data->Status==MUIV_GLArea_Busy) {
	    #ifdef DEBUG
	    // FPrintf(data->fh,"Render is busy, break it via signal\n");
	    #endif
	    Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
	    Wait(data->sharedlist->sigmask);
	    #ifdef DEBUG
	    // FPrintf(data->fh,"received confirmation\n");
	    #endif
	};
	data->command=HIDEME;
	Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	Wait(data->sharedlist->sigmask);
    }
    else {
	if (data->glcontext.context) {
	    AmigaMesaDestroyContext(data->glcontext.context);
	    data->glcontext.context=NULL;
	};
    };
    #ifdef DEBUG
    // FPrintf(data->fh,"<=mHide\n");
    #endif
    return (DoSuperMethodA(cl,obj,msg));
    // return TRUE;
}
/*------------------------
  MUIM_Cleanup
--------------------------*/
ULONG GLArea_mCleanup (struct IClass *cl, Object *obj, Msg msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);

    DoMethod(_win(obj),MUIM_Window_RemEventHandler,&data->ehnode);
    return (DoSuperMethodA(cl,obj,msg));
}
/*---------------------
  OM_DISPOSE
-----------------------*/
ULONG GLArea_mDispose (struct IClass *cl, Object *obj, Msg msg) {
    struct Task *thistask=FindTask(NULL);
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct GLArea_MUI_ImageEntry *ie=NULL;
    struct GLArea_MUI_TextureEntry *te=NULL;

    #ifdef DEBUG
    // FPrintf(data->fh,"mDispose\n");
    #endif
    sh_muinum--;
    data->sharedlist->muinum--;

    if (data->SingleTask==FALSE) {
	data->command=KILLME;
	Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	#ifdef DEBUG
	// FPrintf(data->fh,"Sending KIILME ok\n");
	#endif
	Wait(data->sharedlist->sigmask);
	sh_rendernum--;
    };

    if (data->sharedlist->muinum==0) {
	FreeSignal(data->sharedlist->retsignal);
	CloseLibrary(data->sharedlist->gl_Base);
	CloseLibrary(data->sharedlist->glu_Base);
	CloseLibrary(data->sharedlist->glut_Base);
	Remove(data->sharedlist);
	FreeVec(data->sharedlist);
    };

    // puts("before dosuper");
    #ifdef DEBUG
    Close(data->fh);
    #endif
    return (DoSuperMethodA(cl,obj,(Msg) msg));
}

ULONG GLArea_mRedraw(struct IClass *cl, Object *obj) {
    // struct Data *data=NULL;
    // puts("mRedraw");
    // data=(struct Data *) INST_DATA(cl,obj);
    // SwitchLibBase(data);
    // if (data->glcontext.context) {
    struct MUIP_Draw msg={MUIM_Draw,MADF_DRAWOBJECT};
    return GLArea_mDraw(cl,obj,&msg);
    // };
}

/*---------------
  OM_SET
-----------------*/
ULONG GLArea_mSet(struct IClass *cl, Object *obj, struct opSet *msg) {
    // puts("in mSet");
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct TagItem *tags=NULL,*tag=NULL;

    for (tags=((struct opSet *) msg)->ops_AttrList;tag=NextTagItem(&tags);) {
	// puts("In mSet tag loop");
	switch (tag->ti_Tag) {
	    case MUIA_GLArea_Buffered:
		data->Buffered=(BOOL) tag->ti_Data;
		break;
	    case MUIA_GLArea_FullScreen:
		data->FullScreen=(BOOL) tag->ti_Data;
		break;
	    case MUIA_GLArea_Threaded:
		data->Threaded=(BOOL) tag->ti_Data;
		break;
	    case MUIA_GLArea_SingleTask:
		if (data->Status==-1) {
		    data->SingleTask=(BOOL) tag->ti_Data;
		};
		break;
	    /*
	    case MUIA_GLArea_Status:
		data->Status=(int) tag->ti_Data;
		// puts("STATUS updated");
		break;
	    */
	    case MUIA_GLArea_MinWidth:
		data->MinWidth=(int) tag->ti_Data;
		break;
	    case MUIA_GLArea_MaxWidth:
		data->MaxWidth=(int) tag->ti_Data;
		break;
	    case MUIA_GLArea_DefWidth:
		data->DefWidth=(int) tag->ti_Data;
		break;
	    case MUIA_GLArea_MinHeight:
		data->MinHeight=(int) tag->ti_Data;
		break;
	    case MUIA_GLArea_MaxHeight:
		data->MaxHeight=(int) tag->ti_Data;
		break;
	    case MUIA_GLArea_DefHeight:
		data->DefHeight=(int) tag->ti_Data;
		break;
	    case MUIA_GLArea_DrawFunc:
		data->drawfunc=(PF) tag->ti_Data;
		break;
	    case MUIA_GLArea_DrawFunc2:
		data->drawfunc2=(PF) tag->ti_Data;
		break;
	    case MUIA_GLArea_DrawPostFunc:
		data->drawpostfunc=(PF) tag->ti_Data;
		break;
	    case MUIA_GLArea_MouseDownFunc:
		data->mousedownfunc=(PFD) tag->ti_Data;
		break;
	    case MUIA_GLArea_MouseMoveFunc:
		data->mousemovefunc=(PFD) tag->ti_Data;
		break;
	    case MUIA_GLArea_MouseUpFunc:
		data->mouseupfunc=(PFD) tag->ti_Data;
		break;
	    case MUIA_GLArea_ResetFunc:
		data->resetfunc=(PF) tag->ti_Data;
		break;
	    case MUIA_GLArea_MsgHeight:
		data->msgheight=(int) tag->ti_Data;
		break;
	    case MUIA_GLArea_InitFunc:
		if (tag->ti_Data==MUIV_GLArea_InitFunc_Standard) {
		    data->initfunc=GLArea_InitFunc;
		    /*
		    #ifdef DEBUG
		    FPrintf(data->fh,"InitFunc = -1\n");
		    #endif
		    */
		}
		else {
		    data->initfunc=(PF*) tag->ti_Data;
		};
		break;
	};
    };
    return (DoSuperMethodA(cl,obj,(Msg) msg));
}
/*-------------
  OM_GET
---------------*/
ULONG GLArea_mGet(struct IClass *cl, Object *obj, struct opGet *msg) {
#define STORE *(msg->opg_Storage)
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Task *thistask=FindTask(NULL);
    struct GLArea_MUI_TaskData *td=(struct GLArea_MUI_TaskData *) thistask->tc_UserData;

    switch(msg->opg_AttrID) {
	case MUIA_GLArea_Buffered:
		STORE = (ULONG) data->Buffered;
		return TRUE;
	case MUIA_GLArea_FullScreen:
		STORE = (ULONG) data->FullScreen;
		return TRUE;
	case MUIA_GLArea_Threaded:
		STORE = (ULONG) data->Threaded;
		return TRUE;
	case MUIA_GLArea_Status:
		STORE = (ULONG) data->Status;
		return TRUE;
	/*
	case MUIA_GLArea_Gauge:
		STORE = (ULONG) data->Gauge;
		return TRUE;
	case MUIA_GLArea_GaugeLevel:
		STORE = (ULONG) data->Level;
		return TRUE;
	case MUIA_GLArea_GaugeMax:
		STORE = (ULONG) data->Max;
		return TRUE;
	*/
	case MUIA_GLArea_MinWidth:
		STORE = (ULONG) data->MinWidth;
		return TRUE;
	case MUIA_GLArea_MaxWidth:
		STORE = (ULONG) data->MaxWidth;
		return TRUE;
	case MUIA_GLArea_DefWidth:
		STORE = (ULONG) data->DefWidth;
		return TRUE;
	case MUIA_GLArea_MinHeight:
		STORE = (ULONG) data->MinHeight;
		return TRUE;
	case MUIA_GLArea_MaxHeight:
		STORE = (ULONG) data->MaxHeight;
		return TRUE;
	case MUIA_GLArea_DefHeight:
		STORE = (ULONG) data->DefHeight;
		return TRUE;
	case MUIA_GLArea_DrawFunc:
		STORE = (ULONG) data->drawfunc;
		return TRUE;
	case MUIA_GLArea_DrawFunc2:
		STORE = (ULONG) data->drawfunc2;
		return TRUE;
	case MUIA_GLArea_DrawPostFunc:
		STORE = (ULONG) data->drawpostfunc;
		return TRUE;
	case MUIA_GLArea_InitFunc:
		if (data->initfunc==GLArea_InitFunc) {
		    STORE = (ULONG) -1;
		}
		else {
		    STORE = (ULONG) data->initfunc;
		};
		return TRUE;
	case MUIA_GLArea_ResetFunc:
		STORE = (ULONG) data->resetfunc;
		return TRUE;
	case MUIA_GLArea_MouseDownFunc:
		STORE = (ULONG) data->mousedownfunc;
		return TRUE;
	case MUIA_GLArea_MouseUpFunc:
		STORE = (ULONG) data->mouseupfunc;
		return TRUE;
	case MUIA_GLArea_MouseMoveFunc:
		STORE = (ULONG) data->mousemovefunc;
		return TRUE;
	case MUIA_GLArea_glBase:
		STORE = (ULONG) data->glcontext.gl_Base;
		return TRUE;
	case MUIA_GLArea_gluBase:
		STORE = (ULONG) data->glcontext.glu_Base;
		return TRUE;
	case MUIA_GLArea_glutBase:
		STORE = (ULONG) data->glcontext.glut_Base;
		return TRUE;
	/*
	case MUIA_GLArea_Active:
		if (data->context) {STORE=(ULONG) TRUE;}
		else {STORE=(ULONG) FALSE;};
		return TRUE;
	*/
	case MUIA_GLArea_DeltaX:
		STORE=(ULONG) data->dx;
		return TRUE;
	case MUIA_GLArea_DeltaY:
		STORE=(ULONG) data->dy;
		return TRUE;
	case MUIA_GLArea_Context:
		STORE=(ULONG) data->glcontext.context;
		return TRUE;
	case MUIA_Version:
		STORE=(ULONG) VERSION ;
		return TRUE;
	case MUIA_Revision:
		STORE=(ULONG) REVISION ;
		return TRUE;
    };
    return (DoSuperMethodA(cl,obj,(Msg) msg));
#undef STORE
}
/*------------------
   MUIM_HandleEvent
--------------------*/
ULONG GLArea_mHandleEvent (struct IClass *cl, Object *obj, struct MUIP_HandleEvent *msg) {
    #define _between(a,x,b) ((x)>=(a) && (x)<=(b))
    #define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) && _between(_mtop(obj),(y),_mbottom(obj)))

    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;
    int x=0,y=0;
    data->glcontext.fh=data->fh;

    //------------------------- Break a current drawing --------------------------------
    if (msg->imsg) {
	if ((_isinobject(msg->imsg->MouseX,msg->imsg->MouseY))||(data->down==TRUE)){
	    switch (msg->imsg->Class) {
		case IDCMP_MOUSEBUTTONS:
		    // puts("MouseButtons");
		    if (msg->imsg->Code==SELECTDOWN) {
			// puts("Down");
			data->x=msg->imsg->MouseX-(_mleft(obj));
			data->y=msg->imsg->MouseY-(_mtop(obj));
			data->dx=0;
			data->dy=0;
			data->down=TRUE;
			DoMethod(_win(obj),MUIM_Window_RemEventHandler, &data->ehnode);
			data->ehnode.ehn_Events|=IDCMP_MOUSEMOVE;
			DoMethod(_win(obj),MUIM_Window_AddEventHandler, &data->ehnode);

			if (data->SingleTask==FALSE) {
			    if (data->Status==MUIV_GLArea_Busy) {
				// printf("Render is busy\n");
				// printf("trying to break it\n");
				Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
				Wait(data->sharedlist->sigmask);
				// data->Status=MUIV_GLArea_Ready;
				// printf("received confirmation\n");
			    };
			    if (data->mousedownfunc) {
				// data->x= data->x-(_mleft(obj));
				// data->y= data->y-(_mtop(obj));
				// FPrintf(data->fh,"x:%ld y:%ld\n",data->x,data->y);
				data->command=GLAREA_MOUSEDOWN;
				// PutMsg(data->renderport,(struct Message *) data);
				Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
				Wait(data->sharedlist->sigmask);
				// WaitPort(data->sharedlist->glareaport);
				// data=(struct Data *) GetMsg(data->sharedlist->glareaport);
			    };
			}
			else {
			    if (data->mousedownfunc) {
				// #ifdef DEBUG
				// FPrintf(data->fh,"Direct MOUSEDOWN\n");
				// #endif
				// data->x= data->x-(_mleft(obj));
				// data->y= data->y-(_mtop(obj));
				AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);
				data->mousedownfunc(data->x,data->y,&data->glcontext);
				if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
			    };
			};

			// printf("finished drawing mousedown\n");
		    }
		    else {
			// puts("Up");
			data->x= msg->imsg->MouseX-(_mleft(obj));
			data->y= msg->imsg->MouseY-(_mtop(obj));
			data->down=FALSE;
			DoMethod(_win(obj),MUIM_Window_RemEventHandler, &data->ehnode);
			data->ehnode.ehn_Events=IDCMP_MOUSEBUTTONS;
			DoMethod(_win(obj),MUIM_Window_AddEventHandler, &data->ehnode);
			/*
			#ifdef DEBUG
			FPrintf(data->fh,"EvenHandler passed\n");
			#endif
			Delay(100);
			*/
			if (data->SingleTask==FALSE) {
			    if (data->mouseupfunc) {
				// data->x= msg->imsg->MouseX-(_mleft(obj));
				// data->y= msg->imsg->MouseY-(_mtop(obj));
				// FPrintf(data->fh,"x:%ld y:%ld\n",data->x,data->y);
				data->command=GLAREA_MOUSEUP;
				// PutMsg(data->renderport,(struct Message *) data);
				Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
				Wait(data->sharedlist->sigmask);
				// WaitPort(data->sharedlist->glareaport);
				// data=(struct Data *) GetMsg(data->sharedlist->glareaport);
				// data->mouseupfunc(x,y,&data->sharedlist->glcontext);
				// GLArea_mDraw(cl,obj,MADF_DRAWOBJECT);
				GLArea_mRedraw(cl,obj);
			    };
			}
			else {
			    if (data->mouseupfunc) {
				AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);
				data->mouseupfunc(data->x,data->y,&data->glcontext);
				if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
				GLArea_mRedraw(cl,obj);
			    };
			};
			// GLArea_mRedraw(cl,obj);
		    };
		    break;

		case IDCMP_MOUSEMOVE:
		    // puts("MouseMove");
		    if (data->down) {
			data->dx=data->x-(msg->imsg->MouseX-(_mleft(obj)));
			data->dy=data->y-(msg->imsg->MouseY-(_mtop(obj)));
			// printf("dx=%d dy=%d\n",data->dx,data->dy);
			// FPrintf(data->fh,"dx:%ld dy:%ld\n",data->dx,data->dy);
			if (data->SingleTask==FALSE) {
			    if (data->mousemovefunc) {
				// puts("before calling mousemove");
				data->command=GLAREA_MOUSEMOVE;
				Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
				Wait(data->sharedlist->sigmask);
				// PutMsg(data->renderport,(struct Message *) data);
				// WaitPort(data->sharedlist->glareaport);
				// data=(struct Data *) GetMsg(data->sharedlist->glareaport);
			    };
			    // data->mousemovefunc(data->dx,data->dy,&data->sharedlist->glcontext);
			    // puts("ok");
			    // if (data->Buffered) AmigaMesaSwapBuffers(data->context);
			    // puts("swapped");
			}
			else {
			    #ifdef DEBUG
			    // FPrintf(data->fh,"Direct MOUSEMOVE\n");
			    #endif
			    if (data->mousemovefunc) {
				AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);
				data->mousemovefunc(data->dx,data->dy,&data->glcontext);
				if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
			    };
			};
		    };
		    // puts("finished");
		    break;
	    }; // end switch
	    // puts("Event eat");
	    return MUI_EventHandlerRC_Eat;
	}; // end if _isinbibject
    }; // end msg->imsg
    // puts("Not in GLArea zone");
    return FALSE;
}

// Personnal methods
ULONG GLArea_mInit(struct IClass *cl, Object *obj) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;
    data->glcontext.fh=data->fh;
    // data->sharedlist->glcontext.context=data->context;
    // data->sharedlist->glcontext.glarea=obj;

    // puts("mInit");
    if (data->SingleTask==FALSE) {
	if (data->Status==MUIV_GLArea_Busy) {
	    // puts("break send");
	    Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
	    Wait(data->sharedlist->sigmask);
	    // data->Status=MUIV_GLArea_Ready;
	};
	data->command=INITME;
	Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	Wait(data->sharedlist->sigmask);
	// PutMsg(data->renderport,(struct Message *) data);
	// WaitPort(data->sharedlist->glareaport);
	// GetMsg(data->sharedlist->glareaport);
	data->Status=MUIV_GLArea_Ready;
    }
    else {
	if (data->glcontext.context) {
	    AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);
	    if (data->initfunc) {
		data->initfunc(&data->glcontext);
	    };
	// if (data->drawfunc) GLArea_mDraw(cl,obj,NULL);
	    return TRUE;
	};
    };
    return FALSE;
}

ULONG GLArea_mRefresh(struct IClass *cl, Object *obj) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    // SwitchLibBase(data);
    /*
    if (data->Status==READY) {
	return GLArea_mDraw(cl,obj,NULL);
    };
    */
    return FALSE;
}
ULONG GLArea_mBreak(struct IClass *cl, Object *obj) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    // printf("mBreak\n");
    if (data->SingleTask==FALSE) {
	// if (data->Threaded) {
	if (data->Status==MUIV_GLArea_Busy) {
		// printf("break send\n");
		Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
		Wait(data->sharedlist->sigmask);
		// data->Status=MUIV_GLArea_Ready;
	};
	// };
    };
    return TRUE;
}
ULONG GLArea_mCurrent(struct IClass *cl, Object *obj) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;

    /*
    if (data->context) {
	AmigaMesaMakeCurrent(data->context,data->context->buffer);
	return TRUE;
    };
    */
    return FALSE;
}
ULONG GLArea_mReset(struct IClass *cl, Object *obj) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;
    data->glcontext.fh=data->fh;
    // data->sharedlist->glcontext.context=data->context;
    // data->sharedlist->glcontext.glarea=obj;

    if (data->SingleTask==FALSE) {
	// if (data->Threaded) {
	    if (data->Status==MUIV_GLArea_Busy) {
		// puts("break send");
		Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
		Wait(data->sharedlist->sigmask);
		// data->Status=MUIV_GLArea_Ready;
	    };
	    data->command=RESETME;
	    Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	    Wait(data->sharedlist->sigmask);
	    // PutMsg(data->renderport,(struct Message *) data);
	    // WaitPort(data->sharedlist->glareaport);
	    // GetMsg(data->sharedlist->glareaport);
	    data->Status=MUIV_GLArea_Ready;
	// };

    }
    else {
	if (data->glcontext.context) {
	    AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);
	    if (data->resetfunc) {
		data->resetfunc(&data->glcontext);
	    };
	    // if (data->drawfunc) GLArea_mDraw(cl,obj,NULL);
	    return TRUE;
	};
    };
    return FALSE;
}
ULONG GLArea_mSwap(struct IClass *cl, Object *obj) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;

    // puts("in mSwap");
    /*
    if (data->Threaded) {
	if (data->Status==BUSY) {
	    Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
	    Wait(data->sharedlist->sigmask);
	    data->Status=READY;
	};
	data->command=SWAPME;
	PutMsg(data->renderport,(struct Message *) data);
	WaitPort(data->sharedlist->glareaport);
	data=(struct Data *) GetMsg(data->sharedlist->glareaport);
    };
    if (data->context) {
	    AmigaMesaMakeCurrent(data->context,data->context->buffer);
	    AmigaMesaSwapBuffers(data->context);
    };
    */
    return FALSE;
}

ULONG GLArea_mDrawThisFunc(struct IClass *cl, Object *obj, struct MUIP_GLArea_DrawThisFunc *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    PF *olddrawfunc=data->drawfunc;
    BOOL res=TRUE;

    #ifdef DEBUG
    // FPrintf(data->fh,"=>mDrawThisFunc\n");
    // FPrintf(data->fh,"new:%ld\n",(PF*) msg->drawthisfunc);
    // FPrintf(data->fh,"old:%ld\n",(PF*) data->drawfunc);
    #endif
    /*
    data->drawfunc2=data->drawfunc;
    data->drawfunc=(PF*) msg->drawthisfunc;
    res=GLArea_mDraw(cl,obj,NULL);
    data->drawfunc=(PF*) data->drawfunc2;
    */
    // puts("Out of mDraw");
    #ifdef DEBUG
    // FPrintf(data->fh,"<=mDrawThisFunc\n");
    #endif
    return res;
}

ULONG  GLArea_mDrawImage(struct IClass *cl, Object *obj, struct MUIP_GLArea_DrawImage *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct GLArea_MUI_ImageEntry *ie=NULL;
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;

    if (data->SingleTask==FALSE) {
	if (data->Status==MUIV_GLArea_Busy) {
	    Signal(&(data->thread->pr_Task),SIGBREAKF_CTRL_D);
	    Wait(data->sharedlist->sigmask);
	};
	data->command=GLAREA_DRAWIMAGE;
	data->data=(ULONG) msg->source;
	Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	Wait(data->sharedlist->sigmask);
    }
    else {
	if (data->data) {
	    GLArea_DrawImage(&data->glcontext,(struct GLImage *) msg->source);
	    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
	};
	data->Status=MUIV_GLArea_Ready;
	data->result=GLAREA_OK;
	data->command=GLAREA_NOTHING;
    };
    return TRUE;
}

/*********************
 * Method Dispatcher *
 *********************/
ULONG Dispatcher (struct IClass *cl __asm("a0"), Object *obj __asm("a2"), Msg msg __asm("a1")) {
    switch (msg->MethodID) {
	case OM_NEW:return (GLArea_mNew (cl,obj,(struct opSet *) msg));break;
	case OM_DISPOSE:return (GLArea_mDispose (cl,obj,msg));break;
	case OM_SET:return (GLArea_mSet (cl,obj,(struct opSet *) msg));break;
	case OM_GET:return (GLArea_mGet (cl,obj,(struct opGet *) msg));break;

	case MUIM_Setup:return (GLArea_mSetup(cl,obj,msg));break;
	case MUIM_Cleanup:return (GLArea_mCleanup(cl,obj,msg));break;
	case MUIM_Show:return (GLArea_mShow(cl,obj,msg));break;
	case MUIM_Hide:return (GLArea_mHide(cl,obj,msg));break;
	case MUIM_AskMinMax:return (GLArea_mAskMinMax(cl,obj,(struct MUIP_AskMinMax *) msg));break;
	case MUIM_Draw:return (GLArea_mDraw(cl,obj,(struct MUIP_Draw *) msg));break;
	case MUIM_HandleEvent:return (GLArea_mHandleEvent(cl,obj,(struct MUIP_HandleEvent *) msg));break;

	case MUIM_GLArea_Break:return (GLArea_mBreak(cl,obj));break;
	case MUIM_GLArea_DrawImage:return (GLArea_mDrawImage(cl,obj,(struct MUIP_GLArea_DrawImage *) msg));break;
	case MUIM_GLArea_DrawThisFunc:return (GLArea_mDrawThisFunc(cl,obj,(struct MUIP_GLArea_DrawThisFunc *) msg));break;
	case MUIM_GLArea_Init:return (GLArea_mInit(cl,obj));break;
	case MUIM_GLArea_MakeCurrent:return (GLArea_mCurrent(cl,obj));break;
	case MUIM_GLArea_Redraw:return (GLArea_mRedraw(cl,obj));break;
	case MUIM_GLArea_Refresh:return (GLArea_mRefresh(cl,obj));break;
	case MUIM_GLArea_Reset:return (GLArea_mReset(cl,obj));break;
	case MUIM_GLArea_Swap:return (GLArea_mSwap(cl,obj));break;
	
    };
    // puts("No found MethodID");
    return (DoSuperMethodA(cl,obj,msg));
}

