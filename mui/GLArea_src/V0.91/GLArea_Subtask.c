/*-------------------------------------------------
  Note: MUI Custom class subtask for an OpenGL area
--------------------------------------------------------*/
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

#include <proto/muimasternew.h>
#include <proto/Amigamesa.h>

#include <mui/GLArea_mcc.h>

#include "GLArea.h"

// #define DEBUG
#define DEBUGCON    "CON:"

//--- Shared variables between ---
extern int sh_muinum;
extern int sh_rendernum;
extern struct Data *sh_data;
extern struct MinList GLArea_TaskList;
extern BPTR gfh;

extern void _LibExtFunc();

/****************************************************************************************/
/*                                      RENDERING SUBTASK                               */
/****************************************************************************************/
void GLArea_MUI_RenderingSubtask() {
    char temp[255];
    BOOL quit=TRUE;
    BPTR fh=NULL;
    struct Library *glBase=NULL;
    struct Library *gluBase=NULL;
    struct Library *glutBase=NULL;
    struct glreg gl_reg;
    struct glureg glu_reg;
    struct glutreg glut_reg;
    struct Data *data=NULL;
    ULONG sig=0;

    struct Library *DOSBase=NULL;
    struct IntuitionBase *IntuitionBase=NULL;

    DOSBase=(struct Library *) OpenLibrary(DOSNAME,0L);
    IntuitionBase=(struct IntuitionBase *) OpenLibrary("intuition.library",0L);

    //---------- Get shared variable ---------------
    data=sh_data;
    #ifdef DEBUG
    sprintf(temp, DEBUGCON "%ld/%ld/400/200/Subtask:%ld\n",(sh_rendernum*20),(sh_rendernum*20),sh_rendernum);
    fh=Open(temp,MODE_NEWFILE);
    FPrintf(fh,"---RENDERING SUBTASK---\n");
    #endif

    glBase=OpenLibrary("agl.library",0);
    if (glBase==NULL) {
       #ifdef DEBUG
       FPrintf(fh,"Failed to open 'agl.library'\n");
       #endif
       // _LibExtFunc();
    };

    gluBase=OpenLibrary("aglu.library",0);
    if (gluBase==NULL) {
	#ifdef DEBUG
	FPrintf(fh,"Failed to open 'aglu.library'\n");
	#endif
	// _LibExtFunc();
    };
    glutBase=OpenLibrary("aglut.library",0);
    if (glutBase==NULL) {
	#ifdef DEBUG
	FPrintf(fh,"Failed to open 'aglut.library'\n");
	#endif
	// _LibExtFunc();
    };

    CacheClearU();
    gl_reg.size = (int)sizeof(struct glreg);
    gl_reg.func_exit = (void *)_LibExtFunc;
    // puts("before registerGL");
    registerGL(&gl_reg);
    // puts("after registerGL");
    glu_reg.size = (int)sizeof(struct glureg);
    glu_reg.glbase = glBase;
    registerGLU(&glu_reg);
    glut_reg.size = (int)sizeof(struct glutreg);
    glut_reg.func_exit = (void *) _LibExtFunc;
    glut_reg.glbase = glBase;
    glut_reg.glubase = gluBase;
    registerGLUT(&glut_reg);

    data->glcontext.gl_Base=glBase;
    data->glcontext.glu_Base=gluBase;
    data->glcontext.glut_Base=glutBase;

    #ifdef DEBUG
    // FPrintf(fh,"glBase:%ld gluBase:%ld glutBase:%ld\n",(ULONG) glBase, (ULONG) gluBase, (ULONG) glutBase);
    #endif
   
    //--- Send confimration back ---
    Signal(data->maintask,data->sharedlist->sigmask);
    #ifdef DEBUG
    // FPrintf(fh,"Dummy confirmation send, signal:%lu\n",data->sharedlist->sigmask);
    #endif

    while(quit) {
	// fprintf(fd,"Waiting msg...\n");
	#ifdef DEBUG
	// FPrintf(fh,"Waiting signal...\n");
	#endif
	sig=Wait(SIGBREAKF_CTRL_D|data->sharedlist->sigmask|SIGBREAKF_CTRL_C);

	//--- Check which signal has arrived ---
	if ((sig&SIGBREAKF_CTRL_C)==SIGBREAKF_CTRL_C) {
	    #ifdef DEBUG
	    FPrintf(fh,"SIGBREAKF_CTRL_C received\n");
	    #endif
	    Close(fh);
	    quit=FALSE;
	}
	else if ((sig&SIGBREAKF_CTRL_D)==SIGBREAKF_CTRL_D) {
	    #ifdef DEBUG
	    FPrintf(fh,"SIGBREAKF_CTRL_D received\n");
	    #endif
	    Signal(data->maintask,data->sharedlist->sigmask);
	}
	else {
	    data->glcontext.fh=fh;
	    if (data->command==GLAREA_SHOWME) {
		#ifdef DEBUG
		// FPrintf(fh,"SHOWME\n");
		#endif
		data->glcontext.context=AmigaMesaCreateContextTags(AMA_RGBMode,TRUE,
								   AMA_Left, _mleft(data->glcontext.glarea),
								   AMA_Bottom, _window(data->glcontext.glarea)->Height-(_mtop(data->glcontext.glarea)+_mheight(data->glcontext.glarea))+data->msgheight,
								   AMA_Width, _mwidth(data->glcontext.glarea),
								   AMA_Height, _mheight(data->glcontext.glarea)-data->msgheight,
								   AMA_RastPort, (ULONG) _rp(data->glcontext.glarea),
								   AMA_Screen, (ULONG) _screen(data->glcontext.glarea),
								   AMA_DoubleBuf, data->Buffered,
								   AMA_AlphaFlag, TRUE,
								   // AMA_Forbid3DHW, TRUE,
								   AMA_DirectRender, TRUE,
								   AMA_Fullscreen, data->FullScreen,
								   TAG_DONE);

		if (data->glcontext.context) {
		    struct GLArea_MUI_TextureEntry *current=NULL;
		    int i=0;

		    AmigaMesaMakeCurrent(data->glcontext.context,data->glcontext.context->buffer);

		    if (data->initfunc) {
			data->initfunc(&data->glcontext);
		    };
		    if (data->Buffered) {
			AmigaMesaSwapBuffers(data->glcontext.context);
		    };
		    data->result=GLAREA_OK;
		    data->command=GLAREA_NOTHING;
		}
		else {
		    #ifdef DEBUG
		    FPrintf(fh,"StormMesa context NULL !!! \n");
		    #endif
		    RectFill(_rp(data->glcontext.glarea),
			     _left(data->glcontext.glarea),_top(data->glcontext.glarea),
			     _right(data->glcontext.glarea),_bottom(data->glcontext.glarea));
		    Move(_rp(data->glcontext.glarea),_left(data->glcontext.glarea),_top(data->glcontext.glarea)+10);
		    SetAPen(_rp(data->glcontext.glarea),10);
		    Text(_rp(data->glcontext.glarea),"StormMesa library error",23);
		    data->result=GLAREA_ERROR;
		    data->command=GLAREA_NOTHING;
		};
		Signal(data->maintask,data->sharedlist->sigmask);

	    }
	    else if (data->command==HIDEME) {
		#ifdef DEBUG
		// FPrintf(fh,"HIDEME\n");
		#endif
		AmigaMesaDestroyContext(data->glcontext.context);
		data->glcontext.context=NULL;
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		Signal(data->maintask,data->sharedlist->sigmask);
		#ifdef DEBUG
		// FPrintf(fh,"hideme message send back via signal\n");
		#endif
	    }
	    else if (data->command==INITME) {
		#ifdef DEBUG
		// FPrintf(fh,"INITME\n");
		#endif
		if (data->initfunc) {
		    // AmigaMesaMakeCurrent(context,context->buffer);
		    data->initfunc(&data->glcontext);
		};
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		// ReplyMsg((struct Message *) lglmsg);
		Signal(data->maintask,data->sharedlist->sigmask);
	    }
	    else if (data->command==RESETME) {
		#ifdef DEBUG
		// FPrintf(fh,"RESETME\n");
		#endif
		if (data->resetfunc) {
		    // AmigaMesaMakeCurrent(context,context->buffer);
		    data->resetfunc(&data->glcontext);
		};
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		Signal(data->maintask,data->sharedlist->sigmask);
	    }
	    else if (data->command==GLAREA_MOUSEDOWN) {
		#ifdef DEBUG
		// FPrintf(fh,"MOUSEDOWN\n");
		#endif
		if (data->mousedownfunc) {
		    data->mousedownfunc(data->x,data->y,&data->glcontext);
		    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
		};
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		Signal(data->maintask,data->sharedlist->sigmask);
	    }
	    else if (data->command==GLAREA_MOUSEUP) {
		#ifdef DEBUG
		// FPrintf(fh,"MOUSEUP\n");
		#endif
		if (data->mouseupfunc) {
		    data->mouseupfunc(data->x,data->y,&data->glcontext);
		    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
		};
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		Signal(data->maintask,data->sharedlist->sigmask);
	    }
	    else if (data->command==GLAREA_MOUSEMOVE) {
		#ifdef DEBUG
		// FPrintf(fh,"MOUSEMOVE\n");
		#endif

		if (data->mousemovefunc) {
		    data->mousemovefunc(data->dx,data->dy,&data->glcontext);
		    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
		};
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		Signal(data->maintask,data->sharedlist->sigmask);
	    }
	    else if (data->command==DRAWME) {
		int breaked=0;

		#ifdef DEBUG
		// FPrintf(fh,"DRAWME\n");
		#endif
		if (data->drawfunc) {
			// AmigaMesaMakeCurrent(context,context->buffer);
			//--------- Threaded rendering ------------
			if (data->Threaded) {
			    //--- Copy the drawfun reference
			    PF localdrawfunc=data->drawfunc;

			    //---- Reply directly, so the MUI object could continue
			    data->Status=MUIV_GLArea_Busy;
			    Signal(data->maintask,data->sharedlist->sigmask);

			    //---- Call the drawing function
			    breaked=localdrawfunc(&data->glcontext);

			    //---- Buffered rendering
			    glFlush();
			    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
			}
			//-------- No threaded rendering ---------
			else {
			    #ifdef DEBUG
			    // FPrintf(fh,"No threading rendering\n");
			    #endif
			    breaked=data->drawfunc(&data->glcontext);
			    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
			};
		};

		if (breaked==0) {
		    if (data->drawpostfunc) {
			breaked=data->drawpostfunc(&data->glcontext);
		    };
		};

		data->Status=MUIV_GLArea_Ready;
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		#ifdef DEBUG
		// FPrintf(fh,"changed status to Ready\n");
		#endif
		if ((data->Threaded==FALSE)||(breaked)||(data->drawfunc==NULL)) {
		    Signal(data->maintask,data->sharedlist->sigmask);
		};
	    }
	    //------------ NOT YET WORKING -----------
	    /*
	    else if (data->command==GLAREA_DRAWTHIS) {
		#ifdef DEBUG
		FPrintf(fh,"DRAWTHIS\n");
		#endif
		if (data->drawfunc2) {
			// AmigaMesaMakeCurrent(context,context->buffer);
			//--------- Threaded rendering ------------
			if (data->Threaded) {
			    // PF mydrawfunc=data->drawfunc;
			    // BOOL buffered=data->Buffered;
			    int breaked=0;

			    //---- Reply directly, so the MUI object could continue
			    data->result=MUIV_GLArea_Busy;
			    Signal(data->maintask,data->sharedlist->sigmask);

			    //---- Call the drawing function
			    breaked=data->drawfunc2(&data->glcontext);

			    //---- Buffered rendering
			    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);

			    //---- Check if a break signal war received
			    if (breaked){
				// fprintf(fd,"breaked\n");
				// fprintf(fd,"sending dummy confimration signal\n");
				Signal(data->maintask,data->sharedlist->sigmask);
			    }
			    else {
				// fprintf(fd,"sending to muiapp the ready\n");
				DoMethod((Object *) data->glcontext.app,MUIM_Application_PushMethod,(Object *) data->glcontext.glarea,
					 3,MUIM_Set,MUIA_GLArea_Status, MUIV_GLArea_Ready);
			    };
			}
			//-------- No threaded rendering ---------
			// For non threaded rendering it's better to use the
			// direct context of the object
			else {
			    #ifdef DEBUG
			    FPrintf(fh,"No threading rendering\n");
			    #endif
			    data->drawfunc2(&data->glcontext);
			    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
			    data->result=MUIV_GLArea_Ready;
			    Signal(data->maintask,data->sharedlist->sigmask);
			};
		}
		else {
		    data->result=MUIV_GLArea_Ready;
		    Signal(data->maintask,data->sharedlist->sigmask);
		};
	    }
	    */
	    //---------- DrawImage function ---------------
	    else if (data->command==GLAREA_DRAWIMAGE) {
		int breaked=0;
		#ifdef DEBUG
		// FPrintf(fh,"DRAWIMAGE\n");
		#endif
		if (data->data) {
			//--------- Threaded rendering ------------
			if (data->Threaded) {
			    data->Status=MUIV_GLArea_Busy;
			    Signal(data->maintask,data->sharedlist->sigmask);
			    breaked=GLArea_DrawImage(&data->glcontext, (struct GLImage *) data->data);
			    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
			}
			//-------- No threaded rendering ---------
			else {
			    breaked=GLArea_DrawImage(&data->glcontext,(struct GLImage *) data->data);
			    if (data->Buffered) AmigaMesaSwapBuffers(data->glcontext.context);
			};
		};
		data->Status=MUIV_GLArea_Ready;
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		if ((data->Threaded==FALSE)||(breaked)||(data->drawfunc==NULL)) {
		    Signal(data->maintask,data->sharedlist->sigmask);
		};
	    }
	    //---------- Force buffer swapping -------------
	    else if (data->command==SWAPME) {
		/*
		if (glcontext.context) {
		    // AmigaMesaMakeCurrent(context,context->buffer);
		    if (lglmsg->Buffered==TRUE) {
			AmigaMesaSwapBuffers(glcontext.context);
		    };
		    lglmsg->result=GLAREA_OK;
		    ReplyMsg((struct Message *) lglmsg);
		}
		else {
		    lglmsg->result=GLAREA_ERROR;
		    ReplyMsg((struct Message *) lglmsg);
		};
		*/
	    }
	    /*
	    else if (data->command==INITTEXTURE) {

	    }
	    */
	    //----------- Quit subprocess --------------
	    else if (data->command==KILLME) {
		#ifdef DEBUG
		// FPrintf(fh,"KILLME\n");
		#endif
		if (data->glcontext.context) {
		    AmigaMesaDestroyContext(data->glcontext.context);
		    data->glcontext.context=NULL;
		};
		#ifdef DEBUG
		Close(fh);
		#endif
		data->result=GLAREA_OK;
		data->command=GLAREA_NOTHING;
		Signal(data->maintask,data->sharedlist->sigmask);
		quit=FALSE;
	    }
	    else {
		#ifdef DEBUG
		FPrintf(fh,"!!! Other command recerived !!!\n");
		#endif
	    };
	};
    };

    // Delay(1000);
    // DeleteMsgPort(renderport);
    // CloseStormMesaLibs(&glBase,&gluBase,&glutBase);

    if (glBase) CloseLibrary(glBase);
    if (gluBase) CloseLibrary(gluBase);
    if (glutBase) CloseLibrary(glutBase);

    if (IntuitionBase) CloseLibrary((struct Library *) IntuitionBase);
    if (DOSBase) CloseLibrary(DOSBase);
    #ifdef DEBUG
    // fprintf(fd,"glbase=%d\n",glBase);
    // FPrintf(fh,"SUBTASK END\n");
    // Delay(300);
    // Close(fd);

    // Close(fh);
    #endif
}
/*
void RenderingSubtask() {
    // FILE *fd=NULL;
    PF mydrawfunc=currentdatas->drawfunc;
    APTR mymuiapp=currentdatas->app;
    APTR mymuiobj=currentdatas->me;
    BOOL mybuffered=currentdatas->Buffered;
    AmigaMesaContext mycontext=currentdatas->context;
    struct Library *glBase=currentdatas->gl_Base;
    struct Library *gluBase=currentdatas->glu_Base;
    struct Library *glutBase=currentdatas->glut_Base;

    puts("in subtask");
    printf("SUBTASK BASE:%x %x %x\n",glBase,gluBase,glutBase);
    // args=GetArgStr();
    // sscanf(args,"%ld %ld\n",mydrawfunc,mycontext);
    // fd=fopen("CON:0/300/400/400/Subtask","w");
    // fprintf(fd,"In subtask\n");
    // fprintf(fd,"test:%ld %ld\n",mydrawfunc,mycontext);
    // fprintf(fd,"before calling drawfunc\n");
    AmigaMesaMakeCurrent(mycontext,mycontext->buffer);
    mydrawfunc();
    if (mybuffered) AmigaMesaSwapBuffers(mycontext);
    printf("after drawfunc\n");
    DoMethod((Object *) mymuiapp,MUIM_Application_PushMethod,(Object *) mymuiobj,
	      3,MUIM_Set,MUIA_GLArea_Status, READY);
    // printf("after the pushmetod\n");
    // fprintf(fd,"try to exit subtask\n");
    // Delay(100);
    // fclose(fd);
    // EXIT_8_OpenLibs();
    // CloseStormMesaLibs(glBase,gluBase,glutBase);
    puts("end of subtask");
}
*/
