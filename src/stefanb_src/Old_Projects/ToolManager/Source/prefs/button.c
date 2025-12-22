/*
 * button.c  V2.1
 *
 * requester image button code
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* Button image (static) */
__chip static const UWORD FReqImageData[]={
                                           0x03C0,
                                           0x0420,
                                           0xF810,
                                           0xFC10,
                                           0xC3F0,
                                           0xC010,
                                           0xC010,
                                           0xC010,
                                           0xC010,
                                           0xFFF0
                                          };
static struct BitMap FReqImageBitMap={2,10,0,8,0,
                                      (PLANEPTR) FReqImageData,
                                      (PLANEPTR) FReqImageData,
                                      (PLANEPTR) FReqImageData,
                                      (PLANEPTR) FReqImageData,
                                      (PLANEPTR) FReqImageData,
                                      (PLANEPTR) FReqImageData,
                                      (PLANEPTR) FReqImageData,
                                      (PLANEPTR) FReqImageData,};

/* Button image (dynamic) */
static ULONG ChipDataSize;
static struct BitMap BitMap;
static struct Image ButtonImage1;
static struct Image ButtonImage2;

/* Calculate requester button image */
BOOL CalcReqButtonImage(void)
{
 struct DrawInfo *dri;

 if (dri=GetScreenDrawInfo(PublicScreen)) {
  ULONG gheight=ScreenFont->tf_YSize+INTERHEIGHT+2;
  ULONG gdepth=dri->dri_Depth;
  UBYTE *chipdata;

  /* Calculate byte count for chip data (Image data are UWORDs!) */
  ChipDataSize=(REQBUTTONWIDTH+15)/16*2*2*gheight*gdepth;

  /* Allocate memory for image */
  if (chipdata=AllocMem(ChipDataSize,MEMF_PUBLIC|MEMF_CLEAR|MEMF_CHIP)) {
   ULONG planemask=(1L << gdepth)-1;
   ULONG yoff=(gheight-10)/2;

   /* Init Image structure */
   ButtonImage1.LeftEdge=0;
   ButtonImage1.TopEdge=0;
   ButtonImage1.Width=REQBUTTONWIDTH;
   ButtonImage1.Height=gheight;
   ButtonImage1.Depth=gdepth;
   ButtonImage1.PlanePick=planemask;
   ButtonImage1.PlaneOnOff=0;
   ButtonImage1.NextImage=NULL;
   ButtonImage2=ButtonImage1;
   ButtonImage1.ImageData=(UWORD *) chipdata;
   ButtonImage2.ImageData=(UWORD *) (chipdata+ChipDataSize/2);

   /* Init graphics structures */
   InitBitMap(&BitMap,gdepth,REQBUTTONWIDTH,gheight);
   InitRastPort(&TmpRastPort);
   TmpRastPort.BitMap=&BitMap;

   /* Set plane pointers */
   {
    int i;
    ULONG off=ChipDataSize/gdepth/2;
    UBYTE *pl=(UBYTE *) ButtonImage1.ImageData;

    for (i=0; i<gdepth; i++, pl+=off) BitMap.Planes[i]=pl;
   }

   /* Draw button image (deselected state) */
   SetRast(&TmpRastPort,dri->dri_Pens[BACKGROUNDPEN]);
   DrawBevelBox(&TmpRastPort,0,0,REQBUTTONWIDTH,gheight,GT_VisualInfo,ScreenVI,
                                                        TAG_DONE);
   BltBitMap(&FReqImageBitMap,0,0,&BitMap,4,yoff,12,10,ANBC,planemask,NULL);
   BltBitMap(&FReqImageBitMap,0,0,&BitMap,4,yoff,12,10,ABC|ABNC|ANBC,
             dri->dri_Pens[TEXTPEN],NULL);

   /* Set plane pointers */
   {
    int i;
    ULONG off=ChipDataSize/gdepth/2;
    UBYTE *pl=(UBYTE *) ButtonImage2.ImageData;

    for (i=0; i<gdepth; i++, pl+=off) BitMap.Planes[i]=pl;
   }

   /* Draw button image (selected state) */
   SetRast(&TmpRastPort,dri->dri_Pens[FILLPEN]);
   DrawBevelBox(&TmpRastPort,0,0,REQBUTTONWIDTH,gheight,GT_VisualInfo,ScreenVI,
                                                        GTBB_Recessed,FALSE,
                                                        TAG_DONE);
   BltBitMap(&FReqImageBitMap,0,0,&BitMap,4,yoff,12,10,ANBC,planemask,NULL);
   BltBitMap(&FReqImageBitMap,0,0,&BitMap,4,yoff,12,10,ABC|ABNC|ANBC,
             dri->dri_Pens[FILLTEXTPEN],NULL);

   /* All OK! */
   FreeScreenDrawInfo(PublicScreen,dri);
   return(TRUE);
  }
  FreeScreenDrawInfo(PublicScreen,dri);
 }
 return(FALSE);
}

/* Free button images */
void FreeReqButtonImage(void)
{
 FreeMem(ButtonImage1.ImageData,ChipDataSize);
}

/* Init requester button */
void InitReqButtonGadget(struct Gadget *g)
{
 g->Flags=GFLG_GADGHIMAGE|GFLG_GADGIMAGE;
 g->Activation=GACT_RELVERIFY;
 g->GadgetType|=GTYP_BOOLGADGET;
 g->GadgetRender=&ButtonImage1;
 g->SelectRender=&ButtonImage2;
}
