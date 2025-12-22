#include <exec/memory.h>
// #include <libraries/Picasso96.h>
#include <guigfx/guigfx.h>

#include <proto/exec.h>
// #include <proto/Picasso96.h>
#include <proto/graphics.h>
#include <proto/guigfx.h>
#include <proto/intuition.h>
#include <proto/utility.h>

#include <mui/ImageDB_mcc.h>

#include "ImageDB.h"

#define DEBUG

extern struct Library *GuiGFXBase;

/*
//--- Load an image throu ImageManger library/DT and convert it to GL image ---
struct GLImage *GLArea_MUI_LoadImage(BPTR fh, char *filename) {
    APTR memory=NULL;
    struct BitMap *p96bm=NULL;
    struct GLImage *glimage=AllocVec(sizeof(struct GLImage),MEMF_CLEAR);
    struct Library *ImageManagerBase=NULL;
    struct RastPort rp;
    Object **chain=NULL;

    #ifdef DEBUG
    FPrintf(fh,"LoadImage\n");
    #endif
    ImageManagerBase=(struct Library *) OpenLibrary((UBYTE *)"ImageManager.library",0L);
    #ifdef DEBUG
    FPrintf(fh,"ImageManagerBase:%lu\n",ImageManagerBase);
    #endif

    //--- Get size
    glimage->width=320;
    glimage->height=240;
    glimage->component=3;
    // #ifdef DEBUG
    // FPrintf(fh,"width:%ld height:%ld depth:%ld\n",glimage->width,glimage->height,bmh->bmh_Depth);
    // #endif
    p96bm=p96AllocBitMap(glimage->width,glimage->height,24,BMF_USERPRIVATE,NULL,RGBFB_R8G8B8);
    InitRastPort(&rp);
    rp.BitMap=p96bm;
    #ifdef DEBUG
    FPrintf(fh,"Allocate 24bit P96BitMap:%ld\n",p96bm);
    #endif
    // wbclone=OpenScreenTags(NULL,
    //                       SA_Title, "WB Clone",
			   // SA_DisplayID, 0x50011000,
			   // SA_Behind, TRUE,
			   // SA_Draggable, FALSE,
			   // SA_Width, wbscreen->Width,
			   // SA_Height, wbscreen->Height,
			   // SA_Depth, 8,
			   // SA_Parent, wbscreen,
    //                       SA_LikeWorkbench, TRUE,
			   // SA_Quiet, TRUE,
    //                       TAG_DONE);
    chain = IM_CreateChain(0L,
			    IMC_NewObject, "File",
				TAG_DONE,
			    IMC_NewObject, "Decoder",
				TAG_DONE,
			    IMC_NewObject, "ScaleX",
				IMA_ScaleX_Width, 320,
				TAG_DONE,
			    IMC_NewObject, "ScaleY",
				IMA_ScaleY_Height, 240,
				TAG_DONE,
			    // IMC_NewObject, "Container",
			    //         IMA_Container_Screen, scr,
			    //         TAG_DONE,
			    // IMC_NewObject, "Probe",
			    //         IMA_Probe_NewFrameHook, &MyHook,
			    //         IMA_Probe_ReceiveDataHook, &MyHook,
			    //         TAG_DONE,
			    IMC_NewObject, "Raster",
				IMA_Raster_RastPort, &rp,
				TAG_DONE,
			    IMC_EndChain);

    if (chain) {
	DoMethod(chain[0], IMM_File_Load, filename);
	glimage->image=(UBYTE *) AllocVec(glimage->width*glimage->height*glimage->component,MEMF_CLEAR);
	memory=p96GetBitMapAttr(p96bm,P96BMA_MEMORY);
	if (memory) {
	    CopyMem(memory,glimage->image,glimage->width*glimage->height*glimage->component);
	};
	IM_DeleteChain(chain);
	p96FreeBitMap(p96bm);
    };
    CloseLibrary(ImageManagerBase);
    return glimage;
   // DisposeDTObject((Object *) dto);
   // DoMethod((Object *) MyApp->GLAR_Preview, MUIM_GLArea_LoadImage, "test image to load");
}
*/



void ImageDB_MUI_DeleteImage(BPTR fh, struct GLImage *glimage) {
    #ifdef DEBUG
    FPrintf(fh,"Deleting picture\n");
    // Delay(100);
    #endif
    DeletePicture(glimage->picture);
}

struct GLImage *ImageDB_MUI_LoadImage(BPTR fh, char *filename, int width, int height, int flipxy) {
    BOOL rep=FALSE;
    APTR picture=NULL,data=NULL;
    int count=0;

    #ifdef DEBUG
    FPrintf(fh,"LoadImage\n");
    // FPrintf(fh,"ImageManagerBase:%lu\n",ImageManagerBase);
    #endif

    rep=IsPicture(filename,NULL);
    if (rep==TRUE) {
	struct GLImage *glimage=AllocVec(sizeof(struct GLImage),MEMF_CLEAR);
	glimage->picture=LoadPicture(filename,
			    // GGFX_ErrorCode, &errcode,
			    TAG_DONE);

	count=GetPictureAttrs(glimage->picture,
			PICATTR_Width, &glimage->width,
			PICATTR_Height, &glimage->height,
			PICATTR_PixelFormat, &glimage->format);
	#ifdef DEBUG
	FPrintf(fh,"Default %ldx%ld fmt:%ld\n",glimage->width,glimage->height,glimage->format);
	#endif
	//--- Sale image to the wanted size
	if ((width!=MUIV_ImageDB_Scale_Default)&&
	    (height!=MUIV_ImageDB_Scale_Default)) {
	    rep=DoPictureMethod(glimage->picture, PICMTHD_SCALE,
				width, height);

	}
	else if (width!=MUIV_ImageDB_Scale_Default) {
	    rep=DoPictureMethod(glimage->picture, PICMTHD_SCALE,
				width, glimage->height);
	}
	else if (height!=MUIV_ImageDB_Scale_Default) {
	    rep=DoPictureMethod(glimage->picture, PICMTHD_SCALE,
				glimage->width, height);
	};

	if (flipxy&MUIF_ImageDB_FlipX) {
	    /*
	    UBYTE *buffer=AllocVec(glimage->width*glimage->height*3,MEMF_CLEAR);
	    UBYTE *currentbuffer=buffer+((glimage->width-1)*3);
	    UBYTE *currentimage=glimage->image;
	    int rowsize=glimage->width*3,i=0;
	    for (i=0;i<glimage->height;i++) {
		for (j=0;j<glimage->width;j++) {
		    CopyMem(currentimage,currentbuffer,3);
		    currentbuffer=currentbuffer-3;
		    currentimage=currentimage+3;
	    };
	    FreeVec(glimage->image);
	    glimage->image=buffer;
	    */
	    #ifdef DEBUG
	    FPrintf(fh,"Flipping X\n");
	    #endif
	    rep=DoPictureMethod(glimage->picture, PICMTHD_FLIPX,);
	    if (rep==FALSE) {
		#ifdef DEBUG
		FPrintf(fh,"ERROR\n");
		#endif
		FreeVec(glimage);
		return NULL;
	    };
	    
	};
	if (flipxy&MUIF_ImageDB_FlipY) {
	    /*
	    UBYTE *buffer=AllocVec(glimage->width*glimage->height*3,MEMF_CLEAR);
	    UBYTE *currentbuffer=buffer;
	    UBYTE *currentimage=glimage->image+((glimage->height-1)*glimage->width*3);
	    int rowsize=glimage->width*3,i=0;

	    for (i=0;i<glimage->height;i++) {
		CopyMem(currentimage,currentbuffer,rowsize);
		currentbuffer=currentbuffer+rowsize;
		currentimage=currentimage-rowsize;
	    };
	    FreeVec(glimage->image);
	    glimage->image=buffer;
	    */
	    #ifdef DEBUG
	    FPrintf(fh,"Flipping Y\n");
	    #endif
	    rep=DoPictureMethod(glimage->picture, PICMTHD_FLIPY);
	    if (rep==FALSE)  {
		#ifdef DEBUG
		FPrintf(fh,"ERROR\n");
		#endif
		FreeVec(glimage);
		return NULL;
	    };
	    
	};
	if (glimage->format!=PIXFMT_RGB_24) {
	    rep=DoPictureMethod(glimage->picture, PICMTHD_RENDER ,
				PIXFMT_RGB_24);
	};
	count=GetPictureAttrs(glimage->picture,
			PICATTR_Width, &glimage->width,
			PICATTR_Height, &glimage->height,
			PICATTR_PixelFormat, &glimage->format);
	#ifdef DEBUG
	FPrintf(fh,"New %ldx%ld fmt:%ld\n",glimage->width,glimage->height,glimage->format);
	#endif
	count=GetPictureAttrs(glimage->picture,
			PICATTR_RawData, &data);
	glimage->image= (UBYTE *) AllocVec(glimage->width*glimage->height*3,MEMF_CLEAR);
	CopyMemQuick(data,glimage->image,glimage->width*glimage->height*3);
	// glimage->image= (UBYTE *) data;
	return glimage;
    }
    else {
	#ifdef DEBUG
	FPrintf(fh,"It's not a picture\n");
	#endif
	return NULL;
    };
}

struct GLImage *ImageDB_MUI_ScaleImage(BPTR fh, struct GLImage *source, int width, int height, int flipxy) {
    struct GLImage *glimage=AllocVec(sizeof(struct GLImage),MEMF_CLEAR);
    BOOL rep;
    int count=0,data=0;

    #ifdef DEBUG
    FPrintf(fh,"ScaleImage\n");
    #endif
    glimage->picture=ClonePicture(source->picture,
				  GGFX_DestWidth, width,
				  GGFX_DestHeight, height);
    if (glimage->picture) {
	if (flipxy&MUIF_ImageDB_FlipX) {
	    #ifdef DEBUG
	    FPrintf(fh,"Flipping X\n");
	    #endif
	    rep=DoPictureMethod(glimage->picture, PICMTHD_FLIPX);
	    if (rep==FALSE) {
		#ifdef DEBUG
		FPrintf(fh,"ERROR\n");
		#endif
		FreeVec(glimage);
		return NULL;
	    };
	};
	if (flipxy&MUIF_ImageDB_FlipY) {
	    #ifdef DEBUG
	    FPrintf(fh,"Flipping Y\n");
	    #endif
	    rep=DoPictureMethod(glimage->picture, PICMTHD_FLIPY);
	    if (rep==FALSE) {
		#ifdef DEBUG
		FPrintf(fh,"ERROR\n");
		#endif
		FreeVec(glimage);
		return NULL;
	    };
	};
	if (glimage->format!=PIXFMT_RGB_24) {
	    rep=DoPictureMethod(glimage->picture, PICMTHD_RENDER ,
				PIXFMT_RGB_24);
	};
	count=GetPictureAttrs(glimage->picture,
			      PICATTR_Width, &glimage->width,
			      PICATTR_Height, &glimage->height,
			      PICATTR_PixelFormat, &glimage->format);
	#ifdef DEBUG
	FPrintf(fh,"New %ldx%ld fmt:%ld\n",glimage->width,glimage->height,glimage->format);
	#endif
	count=GetPictureAttrs(glimage->picture,
			      PICATTR_RawData, &data);
	glimage->image= (UBYTE *) data;
	return glimage;
    }
    else {
	FreeVec(glimage);
	return NULL;
    };
}

