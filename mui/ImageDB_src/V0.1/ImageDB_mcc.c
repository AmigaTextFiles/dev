/*-------------------------------------------------
  Name: ImageDB.mcc
  Version: 0.1
  Date: 26.12.2000
  Author: Bodmer Stephan (sbodmer@lsi-media.ch)
  Note: MUI Custom class for Image Database
	using guigfx.library
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

#include <proto/muimasternew.h>

#include <mui/ImageDB_mcc.h>

#include "ImageDB.h"

#include "ImageDB_mcc_lib.h"

#include <mui/MCCLib.c>

// #define DEBUG
#define DEBUGCON    "CON:0/0/400/200/ImageDB.mcc"

// unsigned long __stack ={320000};

//--- Sharedvariables between ---
struct Library *GuiGFXBase=NULL;

extern struct GLImage *ImageDB_MUI_LoadImage(BPTR , char *, int , int, int);
extern struct GLImage *ImageDB_MUI_ScaleImage(BPTR, struct GLImage *, int, int, int);
extern void ImageDB_MUI_DeleteImage(BPTR, struct GLImage *);

//------------------------------ MISCELENOUS INTERNAL FUNCTION ------------------------

/***************************************************************************************/
/*                       LIBRARIES INIT FUNCTION                                       */
/***************************************************************************************/
static BOOL ClassInitFunc(const struct Library *const base) {
    GuiGFXBase=(struct Library *) OpenLibrary((UBYTE *)"guigfx.library",1L);
    if (GuiGFXBase==NULL) return FALSE;
    return TRUE;
}
static void ClassExitFunc(const struct Library *const base) {
    CloseLibrary(GuiGFXBase);
}

/*****************************************************************************************/
/*                                MUI CUSTOM CLASS                                       */
/*****************************************************************************************/
/*-----------------------------------------
  OM_NEW method
-------------------------------------------*/
ULONG ImageDB_mNew (struct IClass *cl, Object *obj, struct opSet *msg ) {
    struct Data *data=NULL;

    if (!(obj= (Object *) DoSuperMethodA(cl,obj,(Msg) msg))) {
    // puts("Error creating new object");
    return 0;
    };
    data=(struct Data *) INST_DATA(cl,obj);

    #ifdef DEBUG
    data->fh=Open( DEBUGCON ,MODE_NEWFILE);
    FPrintf(data->fh,"---IMAGEDB OBJECT---\n");
    FPrintf(data->fh,"Version:" VERSIONSTR "\n");
    FPrintf(data->fh,"GuiGFXBase:%lu\n",GuiGFXBase);
    #endif

    /*
    if (GuiGFXBase==NULL) {
	MUI_Request (NULL,NULL,0,"GuiGFX Error","Ok","Can't open guigfx.library !!!\n");
	#ifdef DEBUG
	Close(data->fh);
	#endif
	return NULL;
    };
    */

    //--- initialize list stuff ---
    NewList((struct List *) &data->bitmaplist);
    NewList((struct List *) &data->imagelist);
    data->numbitmap=0;
    data->numimage=0;

    //--- Default
    data->App=NULL;

    //--- initialize object attributs from tags ---
    msg->MethodID = OM_SET;
    DoMethodA(obj, (Msg) msg);
    msg->MethodID = OM_NEW;

    return (ULONG) obj;
}

/*---------------------
  OM_DISPOSE
-----------------------*/
ULONG ImageDB_mDispose (struct IClass *cl, Object *obj, Msg msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *ie=NULL;

    #ifdef DEBUG
    FPrintf(data->fh,"mDispose\n");
    // Delay(100);
    #endif

    while (ie=RemHead(&data->imagelist)) {
	#ifdef DEBUG
	// FPrintf(data->fh,"Freed image:%s\n",(char *) ie->id);
	#endif
	ImageDB_MUI_DeleteImage(data->fh,ie->glimage);
	FreeVec(ie->glimage);
	FreeVec(ie);
	Delay(5);
    };
    
    // puts("before dosuper");
    #ifdef DEBUG
    Close(data->fh);
    #endif
    return (DoSuperMethodA(cl,obj,(Msg) msg));
}

/*---------------
  OM_SET
-----------------*/
ULONG ImageDB_mSet(struct IClass *cl, Object *obj, struct opSet *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct TagItem *tags=NULL,*tag=NULL;

    for (tags=((struct opSet *) msg)->ops_AttrList;tag=NextTagItem(&tags);) {
	// puts("In mSet tag loop");
	switch (tag->ti_Tag) {
	    case MUIA_ImageDB_Application:
		data->App=(int) tag->ti_Data;
		break;
	};
    };
    return (DoSuperMethodA(cl,obj,(Msg) msg));
}
/*-------------
  OM_GET
---------------*/
ULONG ImageDB_mGet(struct IClass *cl, Object *obj, struct opGet *msg) {
#define STORE *(msg->opg_Storage)
    struct Data *data=(struct Data *) INST_DATA(cl,obj);

    switch(msg->opg_AttrID) {
    case MUIA_ImageDB_Application:
	STORE = (ULONG) data->App;
	return TRUE;
    case MUIA_ImageDB_GuiGFXBase:
	STORE = (ULONG) GuiGFXBase;
	return TRUE;
    case MUIA_Version:
	STORE = (ULONG) VERSION ;
	return TRUE;
    case MUIA_Revision:
	STORE = (ULONG) REVISION ;
	return TRUE;
    };
    return (DoSuperMethodA(cl,obj,(Msg) msg));
#undef STORE
}

/*****************************************************************************************/
/*                          LIST HANDLING FUNCTION                                       */
/*****************************************************************************************/

ULONG ImageDB_mRemoveImage(struct IClass *cl, Object *obj, struct MUIP_ImageDB_RemoveImage *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *ie=NULL;
    struct GLImage *glimage=NULL;

    ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) msg->source);
    if (ie) {
	Remove(&ie->node);
	data->numimage--;
	glimage=ie->glimage;
	FreeVec(ie);
	return (ULONG) glimage;
    };
    return NULL;
}


ULONG ImageDB_mDeleteImage(struct IClass *cl, Object *obj, struct MUIP_ImageDB_DeleteImage *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *ie=NULL;

    ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) msg->id);
    if (ie) {
	#ifdef DEBUG
	// FPrintf(data->fh,"Deleting image:%s\n",msg->id);
	#endif
	Remove(&ie->node);
	data->numimage--;
	ImageDB_MUI_DeleteImage(data->fh,ie->glimage);
	FreeVec(ie->glimage);
	FreeVec(ie);
	return TRUE;
    } else {
	return FALSE;
    };
}


ULONG ImageDB_mScaleImage(struct IClass *cl, Object *obj, struct MUIP_ImageDB_ScaleImage *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *ie=NULL,*nie=NULL;
    struct GLImage *glimage=NULL;
    int rep=0;

    #ifdef DEBUG
    FPrintf(data->fh,"mScaleImage source:%s\n",msg->source);
    #endif

    ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) msg->source);
    if (ie) {
	glimage=ImageDB_MUI_ScaleImage(data->fh,ie->glimage,msg->width,msg->height,msg->flipxy);
	if (glimage) {
	    //--- Delete old id if the same
	    ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) msg->newid);
	    if (ie) {
		#ifdef DEBUG
		FPrintf(data->fh,"Deleting old image\n");
		#endif
		Remove(&ie->node);
		data->numimage--;
		ImageDB_MUI_DeleteImage(data->fh,ie->glimage);
		FreeVec(ie->glimage);
		FreeVec(ie);
	    };

	    //--- Insert a new image
	    nie=(struct ImageDB_MUI_ImageEntry *) AllocVec(sizeof(struct ImageDB_MUI_ImageEntry),MEMF_CLEAR);
	    nie->glimage=glimage;
	    strcpy(nie->id,msg->newid);
	    nie->node.ln_Name=nie->id;
	    Enqueue((struct List *) &data->imagelist, &nie->node);
	    data->numimage++;
	    #ifdef DEBUG
	    // FPrintf(data->fh,"new image added\n");
	    // FPrintf(data->fh,"new size %ldx%ld\n",nie->glimage->width,nie->glimage->height);
	    #endif
	    return (ULONG) nie->glimage;
	} else {
	MUI_Request (data->App,NULL,0,"Error","Ok","Couldn't rescale image\n");
	};
    } else {
	#ifdef DEBUG
	FPrintf(data->fh,"source was not found\n");
	#endif
    };
    return NULL;
}


ULONG ImageDB_mGetImage(struct IClass *cl, Object *obj, struct MUIP_ImageDB_GetImage *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *ie=NULL;

    ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) msg->id);
    if (ie) {
	return (ULONG) ie->glimage;
    };
    return NULL;
}

ULONG ImageDB_mGetName(struct IClass *cl, Object *obj, struct MUIP_ImageDB_GetName *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *current=NULL;

    for (current=(struct ImageDB_MUI_ImageEntry *) data->imagelist.lh_Head;current->node.ln_Succ;current=(struct ImageDB_MUI_ImageEntry *) current->node.ln_Succ) {
	if (current->glimage==(struct GLImage *) msg->source) {
	    return (ULONG) current->id;
	};
    };
    return NULL;
}

/*
ULONG ImageDB_mGetTexture(struct IClass *cl, Object *obj, struct MUIP_ImageDB_GetTexture *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_TextureEntry *te=NULL;

    te=(struct ImageDB_MUI_TextureEntry *) FindName(&data->texturelist,(UBYTE *) msg->id);
    if (te) {
    return (ULONG) te->gltexture;
    };
    return NULL;
}
*/

ULONG ImageDB_mInitImage(struct IClass *cl, Object *obj, struct MUIP_ImageDB_InitImage *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *ie=NULL,*nie=NULL;

    if (msg->what==NULL) return NULL;
    /*
    //--- Check if id exist
    ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) msg->id);
    if (ie) {
    Remove(&ie->node);
    data->numimage--;
    FreeVec(ie->glimage->image);
    FreeVec(ie->glimage);
    FreeVec(ie);
    };

    nie=(struct ImageDB_MUI_ImageEntry *) AllocVec(sizeof(struct ImageDB_MUI_ImageEntry),MEMF_CLEAR);
    nie->glimage=AllocVec(sizeof(struct GLImage),MEMF_CLEAR);
    
    if (msg->mode==MUIV_ImageDB_InitImage_Set) {
    struct GLImage *glimage=(struct GLImage *) msg->what;

    nie->glimage->width=glimage->width;
    nie->glimage->height=glimage->height;
    nie->glimage->component=glimage->component;
    nie->glimage->image=glimage->image;
    }
    else if (msg->mode==MUIV_ImageDB_InitImage_Copy) {
    struct GLImage *glimage=(struct GLImage *) msg->what;

    nie->glimage->width=glimage->width;
    nie->glimage->height=glimage->height;
    nie->glimage->component=glimage->component;
    nie->glimage->image=(UBYTE *) AllocVec(nie->glimage->width*nie->glimage->height*nie->glimage->component,MEMF_CLEAR);
    if (glimage->image) {
	CopyMem(glimage->image,nie->glimage->image,nie->glimage->width*nie->glimage->height*nie->glimage->component);
    };
    }
    else if(msg->mode==MUIV_ImageDB_InitImage_Allocate) {
    struct GLImage *glimage=(struct GLImage *) msg->what;

    nie->glimage->width=glimage->width;
    nie->glimage->height=glimage->height;
    nie->glimage->component=glimage->component;
    nie->glimage->image=(UBYTE *) AllocVec(nie->glimage->width*nie->glimage->height*nie->glimage->component,MEMF_CLEAR);
    }
    else {
    FreeVec(nie);
    return NULL;
    };
    strcpy(nie->id,msg->id);
    nie->node.ln_Name=(char *) nie->id;
    Enqueue((struct List *) &data->imagelist,&nie->node);
    data->numimage++;
    */
    return (ULONG) nie->glimage;
}

/*
ULONG ImageDB_mInitTexture(struct IClass *cl, Object *obj, struct MUIP_ImageDB_InitTexture *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_TextureEntry *te=NULL,*nte=NULL;

    if (msg->what==NULL) return NULL;

    //--- Check if id exist
    te=(struct ImageDB_MUI_TextureEntry *) FindName(&data->texturelist,(UBYTE *) msg->id);
    if (te) {
    Remove(&te->node);
    data->numtexture--;
    FreeVec(te->gltexture->image);
    FreeVec(te->gltexture);
    FreeVec(te);
    };

    nte=(struct ImageDB_MUI_TextureEntry *) AllocVec(sizeof(struct ImageDB_MUI_TextureEntry),MEMF_CLEAR);
    nte->gltexture=AllocVec(sizeof(struct GLTex),MEMF_CLEAR);
    if (msg->mode==MUIV_ImageDB_InitTexture_Set) {
    struct GLTex *gltexture=(struct GLTex *) msg->what;

    nte->gltexture->width=gltexture->width;
    nte->gltexture->height=gltexture->height;
    nte->gltexture->component=gltexture->component;
    nte->gltexture->image=gltexture->image;
    }
    else if (msg->mode==MUIV_ImageDB_InitTexture_Copy) {
    struct GLTex *gltexture=(struct GLTex *) msg->what;

    nte->gltexture->width=gltexture->width;
    nte->gltexture->height=gltexture->height;
    nte->gltexture->component=gltexture->component;
    nte->gltexture->image=(UBYTE *) AllocVec(nte->gltexture->width*nte->gltexture->height*nte->gltexture->component,MEMF_CLEAR);
    if (gltexture->image) {
	CopyMem(gltexture->image,nte->gltexture->image,nte->gltexture->width*nte->gltexture->height*nte->gltexture->component);
    };
    }
    else if (msg->mode==MUIV_ImageDB_InitTexture_Allocate) {
    struct GLTex *gltexture=(struct GLTex *) msg->what;

    nte->gltexture->width=gltexture->width;
    nte->gltexture->height=gltexture->height;
    nte->gltexture->component=gltexture->component;
    nte->gltexture->image=(UBYTE *) AllocVec(nte->gltexture->width*nte->gltexture->height*nte->gltexture->component,MEMF_CLEAR);
    }
    else if (msg->mode==MUIV_ImageDB_EntryType_Image) {
    struct GLImage *glimage=(struct GLImage *) msg->what;
    struct ImageDB_MUI_ImageEntry *ie=NULL;
    int nwidth=1,nheight=1;

    do { nwidth*=2; } while (nwidth<glimage->width);
    do { nheight*=2; } while (nheight<glimage->height);

    if ((nwidth!=glimage->width)||
	(nheight!=glimage->height)) {
	struct MUIP_ImageDB_ScaleImage smsg={MUIM_ImageDB_ScaleImage,"-1",glimage,nwidth,nheight};

	glimage=(struct GLImage *) ImageDB_mScaleImage(cl,obj,&smsg);
    };

    if (glimage) {
	nte->gltexture->width=glimage->width;
	nte->gltexture->height=glimage->height;
	nte->gltexture->component=glimage->component;
	nte->gltexture->image=(UBYTE *) AllocVec(nte->gltexture->width*nte->gltexture->height*nte->gltexture->component,MEMF_CLEAR);
	if (glimage->image) {
	CopyMem(glimage->image,nte->gltexture->image,nte->gltexture->width*nte->gltexture->height*nte->gltexture->component);
	};
	ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) "-1");
	if (ie) {
	#ifdef DEBUG
	// FPrintf(data->fh,"Deleting temp entry -1\n");
	#endif
	Remove(&ie->node);
	data->numimage--;
	FreeVec(ie->glimage->image);
	FreeVec(ie->glimage);
	FreeVec(ie);
	};
    }
    else {
	FreeVec(nte);
	return NULL;
    };
    }
    else {
    FreeVec(nte);
    return NULL;
    };
    if (nte->gltexture->glid==0) glGenTextures(1,&nte->gltexture->glid);
    strcpy(nte->id,msg->id);
    nte->node.ln_Name=(char *) nte->id;
    Enqueue((struct List *) &data->texturelist,&nte->node);
    data->numtexture++;

    //--- bind GL texture
    // nte->gltexture->glid=glid;
    #ifdef DEBUG
    // FPrintf(data->fh,"name:%ld\n",nte->gltexture->glid);
    #endif
    if (data->SingleTask==TRUE) {
    ImageDB_MUI_InitGLTexture(&data->glcontext,nte->gltexture);
    }
    else {
    data->data=(ULONG) nte->gltexture;
    data->command=GLAREA_INITTEXTURE;
    data->result=GLAREA_ERROR;
    Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
    Wait(data->sharedlist->sigmask);
    };
    return (ULONG) nte->gltexture;
}
*/

ULONG ImageDB_mLoadImage(struct IClass *cl, Object *obj, struct MUIP_ImageDB_LoadImage *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct ImageDB_MUI_ImageEntry *ie=NULL,*nie=NULL;
    struct GLImage *glimage=NULL;
    struct BitMapHeader *bmh;
    struct Node *newnode=NULL;

    #ifdef DEBUG
    FPrintf(data->fh,"mLoadImage image:%s\n",(char *) msg->filename);
    #endif

    if (GuiGFXBase==NULL) {
	MUI_Request (data->App,NULL,0,"Error","Ok","Couldn't open guigfx.library\n");
	return NULL;
    };

    glimage=ImageDB_MUI_LoadImage (data->fh,msg->filename,msg->width,msg->height,msg->flipxy);
    if (glimage) {
	//--- Create new List entry
	nie=(struct ImageDB_MUI_ImageEntry *) AllocVec(sizeof(struct ImageDB_MUI_ImageEntry),MEMF_CLEAR);
	nie->glimage=glimage;
	strcpy(nie->id,msg->id);
	nie->node.ln_Name=(char *) nie->id;

	//--- Check if replace it
	ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) msg->id);
	if (ie) {
	    #ifdef DEBUG
	    FPrintf(data->fh,"Deleting old image\n");
	    #endif
	    Remove(&ie->node);
	    data->numimage--;
	    ImageDB_MUI_DeleteImage(data->fh,ie->glimage);
	    FreeVec(ie->glimage);
	    FreeVec(ie);
	};
	#ifdef DEBUG
	// FPrintf(data->fh,"Inserting %s !!!\n",(char *) msg->id);
	#endif
	Enqueue((struct List *) &data->imagelist,&nie->node);
	data->numimage++;
	#ifdef DEBUG
	// FPrintf(data->fh,"Returning correct struct glimage *\n");
	#endif
	return (ULONG) nie->glimage;
    } else {
	MUI_Request (data->App,NULL,0,"Error","Ok","Couldn't generate OpenGL image structure\n");
	FreeVec(nie);
	return NULL;
    };
    return NULL;
}

/*
ULONG ImageDB_mLoadTexture(struct IClass *cl, Object *obj, struct MUIP_ImageDB_LoadTexture *msg) {
    struct Data *data=(struct Data *) INST_DATA(cl,obj);
    struct Library *glBase=data->glcontext.gl_Base;
    struct Library *gluBase=data->glcontext.glu_Base;
    struct Library *glutBase=data->glcontext.glut_Base;
    struct ImageDB_MUI_TextureEntry *te=NULL,*nte=NULL;
    struct ImageDB_MUI_ImageEntry *ie=NULL;
    struct MUIP_ImageDB_LoadImage lmsg={MUIM_ImageDB_LoadImage,msg->filename,"-1"};
    struct GLImage *glimage=NULL;
    struct Node *newnode=NULL;
    int nwidth=1,nheight=1;

    #ifdef DEBUG
    FPrintf(data->fh,"Loading texture file:%s\n",(char *) msg->filename);
    #endif
    glimage=(struct GLImage *) ImageDB_mLoadImage(cl,obj,&lmsg);
    if (glimage) {
    //--- Find new pow(2) with and height ---
    do { nwidth*=2;} while (nwidth<glimage->width);
    do { nheight*=2;} while (nheight<glimage->height);

    if ((nwidth!=glimage->width)||
	(nheight!=glimage->height)) {
	struct MUIP_ImageDB_ScaleImage smsg={MUIM_ImageDB_ScaleImage,"-1",glimage,nwidth,nheight};
	glimage=(struct GLImage *) ImageDB_mScaleImage(cl,obj,&smsg);
    };

    if (glimage) {
	#ifdef DEBUG
	// FPrintf(data->fh,"Success !!!\n");
	// FPrintf(data->fh,"New size:%ld %ld\n",glimage->width,glimage->height);
	#endif
	//--- Check if replace it
	te=(struct ImageDB_MUI_TextureEntry *) FindName(&data->texturelist,(UBYTE *) msg->id);
	if (te) {
	#ifdef DEBUG
	// FPrintf(data->fh,"Deleting old texture\n");
	#endif
	Remove(&te->node);
	data->numtexture--;
	if (te->gltexture->glid!=0) glDeleteTextures(1,te->gltexture->glid);
	FreeVec(te->gltexture->image);
	FreeVec(te->gltexture);
	FreeVec(te);
	};
	nte=(struct ImageDB_MUI_TextureEntry *) AllocVec(sizeof(struct ImageDB_MUI_TextureEntry),MEMF_CLEAR);
	strcpy(nte->id,msg->id);
	nte->node.ln_Name=(char *) nte->id;
	ie=(struct ImageDB_MUI_ImageEntry *) FindName(&data->imagelist,(UBYTE *) "-1");
	Remove(&ie->node);
	data->numimage--;
	nte->gltexture=AllocVec(sizeof(struct GLTex),MEMF_CLEAR);
	nte->gltexture->width=ie->glimage->width;
	nte->gltexture->height=ie->glimage->height;
	nte->gltexture->component=ie->glimage->component;
	nte->gltexture->image=ie->glimage->image;
	glGenTextures(1,&nte->gltexture->glid);
	FreeVec(ie->glimage);
	FreeVec(ie);

	#ifdef DEBUG
	// FPrintf(data->fh,"Inserting texture:%s id:%ld !!!\n",(char *) msg->id,nte->gltexture->glid);
	#endif
	Enqueue((struct List *) &data->texturelist,&nte->node);
	data->numtexture++;

	if (data->SingleTask==TRUE) {
	ImageDB_MUI_InitGLTexture(&data->glcontext,nte->gltexture);
	}
	else {
	data->data=(ULONG) nte->gltexture;
	data->command=GLAREA_INITTEXTURE;
	data->result=GLAREA_ERROR;
	Signal(&(data->thread->pr_Task),data->sharedlist->sigmask);
	Wait(data->sharedlist->sigmask);
	};
	return (ULONG) nte->gltexture;
    }
    else {
	#ifdef DEBUG
	FPrintf(data->fh,"image couldn't be rescaled to a multiple of 2 !!!\n");
	#endif
	return NULL;
    };
    };
    return NULL;
}
*/

/*********************
 * Method Dispatcher *
 *********************/
#ifdef __GNUC__
ULONG Dispatcher (struct IClass *cl __asm("a0"), Object *obj __asm("a2"), Msg msg __asm("a1")) {
#else
ULONG Dispatcher (register __a0 struct IClass *cl,
	     register __a2 Object *obj ,
	     register __a1 Msg msg ) {

#endif
    // puts("In Dispatcher");
    switch (msg->MethodID) {
	case OM_NEW:return (ImageDB_mNew (cl,obj,(struct opSet *) msg));break;
	case OM_DISPOSE:return (ImageDB_mDispose (cl,obj,msg));break;
	case OM_SET:return (ImageDB_mSet (cl,obj,(struct opSet *) msg));break;
	case OM_GET:return (ImageDB_mGet (cl,obj,(struct opGet *) msg));break;

	case MUIM_ImageDB_DeleteImage:return (ImageDB_mDeleteImage(cl,obj,(struct MUIP_ImageDB_DeleteImage *) msg));break;
	case MUIM_ImageDB_GetImage:return (ImageDB_mGetImage(cl,obj,(struct MUIP_ImageDB_GetImage *) msg));break;
	case MUIM_ImageDB_GetName:return (ImageDB_mGetName(cl,obj,(struct MUIP_ImageDB_GetName *) msg));break;
	// case MUIM_ImageDB_GetTexture:return (ImageDB_mGetTexture(cl,obj,(struct MUIP_ImageDB_GetTexture *) msg));break;
	// case MUIM_ImageDB_InitImage:return (ImageDB_mInitImage(cl,obj,(struct MUIP_ImageDB_InitImage *) msg));break;
	// case MUIM_ImageDB_InitTexture:return (ImageDB_mInitTexture(cl,obj,(struct MUIP_ImageDB_InitTexture *) msg));break;
	case MUIM_ImageDB_LoadImage:return (ImageDB_mLoadImage(cl,obj,(struct MUIP_ImageDB_LoadImage *) msg));break;
	// case MUIM_ImageDB_LoadTexture:return (ImageDB_mLoadTexture(cl,obj,(struct MUIP_ImageDB_LoadTexture *) msg));break;
	case MUIM_ImageDB_RemoveImage:return (ImageDB_mRemoveImage(cl,obj,(struct MUIP_ImageDB_RemoveImage *) msg));break;
	case MUIM_ImageDB_ScaleImage:return (ImageDB_mScaleImage(cl,obj,(struct MUIP_ImageDB_ScaleImage *) msg));break;
    };
    // puts("No found MethodID");
    return (DoSuperMethodA(cl,obj,msg));
}

