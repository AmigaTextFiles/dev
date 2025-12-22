#ifndef INTUITION_IMAGECLASS_H
#include <intuition/imageclass.h>
#endif

#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/iffparse.h>
#include <proto/graphics.h>
#include <proto/intuition.h>

#include "Global.h"
#include "SPRT.h"

#define SPRTF_FREE		(1<<10)

/************************************************************************/

struct Global
{
  struct Library *LibBase;
  BPTR File;
  struct Screen *Screen;

  LONG Error;

  struct Window *Window;
  Object *FrameImage;
  Object *RectImage;

  UWORD MaxWidth;
  UWORD SpriteCount;
  UWORD SpritesDone;
};

#define IFFParseBase	(Global->LibBase)

/************************************************************************/

struct SetInfo
{
  ULONG Number;			/* the ordinal number of the sprite set */
  ULONG ColorCount;		/* how many colors did we want? */
  ULONG DistinctColors;		/* how many colors did we get? */
};

struct OriginalSprite
{
  struct BitMap Bitmap;
  WORD Width, Height;
};

struct BMHD
{
  UWORD Width, Height;
  WORD Left, Top;
  UBYTE Depth;
  UBYTE Masking;
  UBYTE Compression;
  UBYTE Pad;
  UWORD TransparentColor;
  UBYTE XAspect, YAspect;
  WORD PageWidth, PageHeight;
};

/************************************************************************/
/*									*/
/* Create a 32 bit word from a byte					*/
/*									*/
/************************************************************************/

static INLINE ULONG Extend32(UBYTE Byte)

{
  union
    {
      ULONG Long;
      UBYTE Byte[4];
    } Conv;

  Conv.Byte[0]=Conv.Byte[1]=Conv.Byte[2]=Conv.Byte[3]=Byte;
  return Conv.Long;
}

/************************************************************************/
/*									*/
/* Close the progress window						*/
/*									*/
/************************************************************************/

static INLINE void CloseProgressWindow(struct Global *Global)

{
  if (Global->RectImage)
    {
      if (Global->FrameImage)
	{
	  if (Global->Window)
	    {
	      CloseWindow(Global->Window);
	      Global->Window=NULL;
	    }
	  DisposeObject(Global->FrameImage);
	  Global->FrameImage=NULL;
	}
      DisposeObject(Global->RectImage);
      Global->RectImage=NULL;
    }
}

/************************************************************************/
/*									*/
/* Create thw progress window						*/
/*									*/
/************************************************************************/

static INLINE void CreateProgressWindow(struct Global *Global, const char *Gamename)

{
  struct DrawInfo *DrawInfo;

  Global->FrameImage=NULL;
  Global->RectImage=NULL;
  Global->Window=NULL;

  if ((DrawInfo=GetScreenDrawInfo(Global->Screen)))
    {
      static struct TagItem ConstantImageTags[]=
	{
	  {IA_Recessed, TRUE},
	  {IA_EdgesOnly, TRUE},
	  {TAG_DONE}
	};

      struct TagItem Tags[7];
      struct TextFont *Font;

      Font=DrawInfo->dri_Font;

      Tags[0].ti_Tag=IA_Width;
      Tags[0].ti_Data=16*Font->tf_YSize;
      Tags[1].ti_Tag=IA_Height;
      Tags[1].ti_Data=3*Font->tf_YSize/2;
      Tags[2].ti_Tag=IA_Top;
      Tags[2].ti_Data=Font->tf_YSize/2;
      Tags[3].ti_Tag=IA_Left;
      Tags[3].ti_Data=Font->tf_XSize;
      Tags[4].ti_Tag=IA_FGPen;
      Tags[4].ti_Data=DrawInfo->dri_Pens[FILLPEN];
      Tags[5].ti_Tag=IA_BGPen;
      Tags[5].ti_Data=DrawInfo->dri_Pens[BACKGROUNDPEN];
      Tags[6].ti_Tag=TAG_MORE;
      Tags[6].ti_Data=(ULONG)ConstantImageTags;
      Global->MaxWidth=Tags[0].ti_Data;
      if ((Global->RectImage=NewObjectA(NULL,"fillrectclass",Tags)))
	{
	  if ((Global->FrameImage=NewObjectA(NULL,"frameiclass",Tags)))
	    {
	      static const struct TagItem ConstantWindowTags[]=
		{
		  {WA_Flags, (WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_NOCAREREFRESH | WFLG_RMBTRAP | WFLG_SMART_REFRESH)},
		  {WA_BusyPointer, TRUE},
		  {TAG_DONE}
		};

	      {
		struct IBox RectIBox;
		struct IBox FrameIBox;
		struct impFrameBox impFrameBox;

		RectIBox.Left=Tags[3].ti_Data;
		RectIBox.Top=Tags[2].ti_Data;
		RectIBox.Width=Tags[0].ti_Data;
		RectIBox.Height=Tags[1].ti_Data;
		impFrameBox.MethodID=IM_FRAMEBOX;
		impFrameBox.imp_FrameBox=&FrameIBox;
		impFrameBox.imp_ContentsBox=&RectIBox;
		impFrameBox.imp_DrInfo=DrawInfo;
		impFrameBox.imp_FrameFlags=0;
		DoMethodA(Global->FrameImage,&impFrameBox);

		Tags[3].ti_Data=FrameIBox.Left;
		Tags[2].ti_Data=FrameIBox.Top;
		Tags[0].ti_Data=FrameIBox.Width;
		Tags[1].ti_Data=FrameIBox.Height;
		Tags[4].ti_Tag=TAG_DONE;
	      }
	      SetAttrsA(Global->FrameImage,Tags);

	      Tags[0].ti_Tag=WA_InnerWidth;
	      Tags[0].ti_Data+=2*Tags[3].ti_Data;
	      Tags[1].ti_Tag=WA_InnerHeight;
	      Tags[1].ti_Data+=2*Tags[2].ti_Data;
	      Tags[2].ti_Tag=WA_CustomScreen;
	      Tags[2].ti_Data=(ULONG)Global->Screen;
	      Tags[3].ti_Tag=WA_Title;
	      Tags[3].ti_Data=(ULONG)Gamename;
	      Tags[4].ti_Tag=TAG_MORE;
	      Tags[4].ti_Data=(ULONG)ConstantWindowTags;
	      if ((Global->Window=OpenWindowTagList(NULL,Tags)))
		{
		  DrawImage(Global->Window->RPort,(struct Image *)Global->FrameImage,
			    Global->Window->BorderLeft,Global->Window->BorderTop);
		}
	    }
	}
      FreeScreenDrawInfo(Global->Screen,DrawInfo);
    }
}

/************************************************************************/
/*									*/
/* Increase the sprite count for the progress window			*/
/* Update the progress window						*/
/*									*/
/************************************************************************/

static void UpdateProgressWindow(struct Global *Global)

{
  struct TagItem RectTags[2];

  Global->SpritesDone++;
  RectTags[0].ti_Tag=IA_Width;
  RectTags[0].ti_Data=Global->MaxWidth*Global->SpritesDone/Global->SpriteCount;
  RectTags[1].ti_Tag=TAG_DONE;
  SetAttrsA(Global->RectImage,RectTags);
  if (AttemptLockLayerRom(Global->Window->RPort->Layer))
    {
      DrawImage(Global->Window->RPort,(struct Image *)Global->RectImage,
		Global->Window->BorderLeft,Global->Window->BorderTop);
      UnlockLayerRom(Global->Window->RPort->Layer);
    }
}

/************************************************************************/
/*									*/
/*									*/
/************************************************************************/

static void ExpandCMAP(UBYTE *ColorByte, struct GS_ColorDef *ColorDef)

{
  struct GS_Color *Color;
  ULONG ColorCount;

  Color=ColorDef->Colors;
  ColorCount=ColorDef->ColorCount;
  while (ColorCount)
    {
      Color->Red=Extend32(*(ColorByte++));
      Color->Green=Extend32(*(ColorByte++));
      Color->Blue=Extend32(*(ColorByte++));
      Color++;
      ColorCount--;
    }
}

/************************************************************************/
/*									*/
/* Look at all sprite sets and return some information about them.	*/
/* We must have locked the PaletteExtra, to avoid race-conditions.	*/
/*									*/
/************************************************************************/

static INLINE struct SetInfo *GetSetInfo(struct Global *Global, ULONG *SetCount)

{
  struct SetInfo *SetInfo;

  SetInfo=NULL;
  if (Seek(Global->File,0,OFFSET_BEGINNING)!=-1)
    {
      struct IFFHandle *IFFHandle;

      if ((IFFHandle=AllocIFF()))
	{
	  LONG ErrorCode;

	  IFFHandle->iff_Stream=Global->File;
	  InitIFFasDOS(IFFHandle);
	  if (!(ErrorCode=OpenIFF(IFFHandle,IFFF_READ)))
	    {
	      if (!(ErrorCode=StopOnExit(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('F','O','R','M'))) &&
		  !(ErrorCode=PropChunk(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('C','M','A','P'))))
		{
		  ULONG Count;
		  ULONG ArraySize;

		  Count=0;
		  ArraySize=0;
		  do
		    {
		      ErrorCode=ParseIFF(IFFHandle,IFFPARSE_SCAN);
		      if (ErrorCode==IFFERR_EOC)
			{
			  if (ArraySize==Count)
			    {
			      struct SetInfo *NewSetInfo;

			      ArraySize+=16;
			      if (!(NewSetInfo=GS_MemoryRealloc(SetInfo,ArraySize*sizeof(*NewSetInfo))))
				{
				  GS_MemoryFree(SetInfo);
				  ErrorCode=ERROR_NO_FREE_STORE;
				}
			      SetInfo=NewSetInfo;
			    }
			  if (SetInfo)
			    {
			      struct StoredProperty *CMAP;

			      SetInfo[Count].Number=Count;
			      SetInfo[Count].ColorCount=0;
			      SetInfo[Count].DistinctColors=0;
			      if ((CMAP=FindProp(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('C','M','A','P'))))
				{
				  struct GS_ColorDef *Colors;
				  ULONG ColorCount;

				  if ((ColorCount=CMAP->sp_Size/3))
				    {
				      if ((Colors=GS_MemoryAlloc(sizeof(*Colors)+(ColorCount)*sizeof(struct GS_Color))))
					{
					  Colors->ColorCount=ColorCount;
					  SetInfo[Count].ColorCount=ColorCount;
					  ExpandCMAP(CMAP->sp_Data,Colors);
					  if (GS_AllocateColors(Global->Screen,Colors,0))
					    {
					      SetInfo[Count].DistinctColors=Colors->DistinctColors;
					      GS_FreeColors(Global->Screen,Colors);
					    }
					  else if (ErrorCode=IoErr())
					    {
					      GS_MemoryFree(SetInfo);
					      SetInfo=NULL;
					    }
					  GS_MemoryFree(Colors);
					}
				      else
					{
					  GS_MemoryFree(SetInfo);
					  SetInfo=NULL;
					  ErrorCode=ERROR_NO_FREE_STORE;
					}
				    }
				}
			      Count++;
			    }
			}
		      else if (ErrorCode!=IFFERR_EOF)
			{
			  GS_MemoryFree(SetInfo);
			  SetInfo=NULL;
			}
		    }
		  while (SetInfo && ErrorCode!=IFFERR_EOF);
		  if (SetInfo)
		    {
		      *SetCount=Count;
		    }
		  else if (ErrorCode==IFFERR_EOF && !Count)
		    {
		      ErrorCode=ERROR_OBJECT_WRONG_TYPE;
		    }
		}
	      CloseIFF(IFFHandle);
	    }
	  if (!SetInfo)
	    {
	      Global->Error=ErrorCode;
	    }
	  FreeIFF(IFFHandle);
	}
      else
	{
	  Global->Error=ERROR_NO_FREE_STORE;
	}
    }
  else
    {
      Global->Error=IoErr();
    }
  return SetInfo;
}

/************************************************************************/
/*									*/
/* Select the sprite set to use						*/
/*									*/
/************************************************************************/

static INLINE struct SetInfo *SelectSet(struct Global *Global, struct SetInfo *SetInfo, ULONG SetCount)

{
  struct SetInfo *BestSet;
  ULONG BestIndex;

  BestIndex=0;
  BestSet=SetInfo;
  while (SetCount)
    {
      ULONG Index;

      Index=65536*SetInfo->DistinctColors*SetInfo->DistinctColors/SetInfo->ColorCount;
      if (Index>BestIndex)
	{
	  BestIndex=Index;
	  BestSet=SetInfo;
	}
      SetInfo++;
      SetCount--;
    }
  return BestSet;
}

/************************************************************************/
/*									*/
/* Find the selected FORM SPRT						*/
/*									*/
/************************************************************************/

static INLINE LONG FindSet(struct Global *Global, struct IFFHandle *IFFHandle, struct SetInfo *SetInfo)

{
  LONG Error;
  ULONG Count;

  Error=StopChunk(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('F','O','R','M'));
  Count=FALSE;
  while (!Error)
    {
      if (!(Error=ParseIFF(IFFHandle,IFFPARSE_SCAN)))
	{
	  if (Count==SetInfo->Number)
	    {
	      break;
	    }
	  Count++;
	}
    }
  if (Error)
    {
      Global->Error=Error;
    }
  return Error;
}

/************************************************************************/
/*									*/
/* Create the sprite array						*/
/*									*/
/************************************************************************/

static INLINE struct GS_Sprites *InitSpriteArray(struct Global *Global, struct IFFHandle *IFFHandle, struct SetInfo *SetInfo)

{
  struct StoredProperty *SPRTProperty;
  struct GS_Sprites *Sprites;
  LONG ErrorCode;

  Sprites=NULL;
  ErrorCode=IFFERR_MANGLED;
  if ((SPRTProperty=FindProp(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('S','P','R','T'))))
    {
      ULONG SpriteCount;

      if ((SpriteCount=SPRTProperty->sp_Size/sizeof(struct SPRT)))
	{
	  struct StoredProperty *CMAPProperty;

	  Global->SpriteCount=SpriteCount;
	  if ((CMAPProperty=FindProp(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('C','M','A','P'))))
	    {
	      ULONG ColorCount;

	      ColorCount=CMAPProperty->sp_Size/3;
	      if (ColorCount==SetInfo->ColorCount)
		{
		  if ((Sprites=GS_MemoryAlloc(sizeof(struct GS_Sprites)+
					      sizeof(struct GS_Color)*ColorCount+
					      sizeof(struct GS_Sprite)*SpriteCount)))
		    {
		      Sprites->SpriteCount=SpriteCount;
		      Sprites->Colors.ColorCount=ColorCount;
		      Sprites->Sprites=(struct Sprite *)&Sprites->Colors.Colors[ColorCount];
		      {
			struct SPRT *SPRT;
			struct GS_Sprite *Sprite;
			
			SPRT=SPRTProperty->sp_Data;
			Sprite=Sprites->Sprites;
			while (SpriteCount)
			  {
			    Sprite->Image=NULL;
			    Sprite->Mask=NULL;
			    Sprite->Width=SPRT->Original;
			    Sprite->Height=0;
			    Sprite->Flags=SPRT->Flags;
			    Sprite++;
			    SPRT++;
			    SpriteCount--;
			  }
		      }
		      ExpandCMAP(CMAPProperty->sp_Data,&Sprites->Colors);
		      if ((GS_AllocateColors(Global->Screen,&Sprites->Colors,0)))
			{
			  ErrorCode=0;
			  if (Sprites->Colors.DistinctColors!=SetInfo->DistinctColors)
			    {
			      ErrorCode=0;
			      GS_FreeSprites(Sprites,Global->Screen);
			      Sprites=NULL;
			    }
			}
		      else
			{
			  ErrorCode=IoErr();
			  GS_FreeSprites(Sprites,Global->Screen);
			  Sprites=NULL;
			}
		    }
		  else
		    {
		      ErrorCode=ERROR_NO_FREE_STORE;
		    }
		}
	    }
	}
    }
  if (ErrorCode)
    {
      Global->Error=ErrorCode;
    }
  return Sprites;
}

/************************************************************************/
/*									*/
/* Take an ILBM CMAP and return a table of pens				*/
/*									*/
/************************************************************************/

static INLINE LONG *GetPens(struct Global *Global, const struct StoredProperty *CMAP, const struct GS_Sprites *Sprites)

{
  ULONG ColorCount;
  LONG *Pens;

  ColorCount=CMAP->sp_Size/3;
  if ((Pens=GS_MemoryAlloc(ColorCount*sizeof(*Pens))))
    {
      UBYTE *ColorByte;
      LONG *Pen;

      ColorByte=CMAP->sp_Data;
      Pen=Pens;
      while (ColorCount)
	{
	  ULONG Red, Green, Blue;
	  ULONG i;

	  Red=Extend32(*(ColorByte++));
	  Green=Extend32(*(ColorByte++));
	  Blue=Extend32(*(ColorByte++));
	  for (i=0;
	       i<Sprites->Colors.ColorCount &&
	       (Sprites->Colors.Colors[i].Red!=Red ||
		Sprites->Colors.Colors[i].Green!=Green ||
		Sprites->Colors.Colors[i].Blue!=Blue);
	       i++)
	    ;
	  if (i==Sprites->Colors.ColorCount)
	    {
	      Global->Error=IFFERR_MANGLED;
	      GS_MemoryFree(Pens);
	      return NULL;
	    }
	  else
	    {
	      *(Pen++)=Sprites->Colors.Colors[i].Pen;
	    }
	  ColorCount--;
	}
    }
  else
    {
      Global->Error=ERROR_NO_FREE_STORE;
    }
  return Pens;
}

/************************************************************************/
/*									*/
/* Read an ILBM and remap it						*/
/*									*/
/************************************************************************/

static INLINE LONG ReadILBM(struct Global *Global, struct IFFHandle *IFFHandle, struct GS_Sprite *Sprite, struct GS_Sprites *Sprites)

{
  struct StoredProperty *BMHDProperty;

  if ((BMHDProperty=FindProp(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('B','M','H','D'))))
    {
      if ((BMHDProperty->sp_Size==sizeof(struct BMHD)))
	{
	  struct BMHD *BMHD;
	  const struct StoredProperty *CMAP;

	  BMHD=BMHDProperty->sp_Data;
	  if ((CMAP=FindProp(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('C','M','A','P'))) || BMHD->Depth==1)
	    {
	      struct BitMap *Image;
	      WORD Bytes;

	      /* read the image into a native Amiga bitmap */
	      Bytes=((BMHD->Width+15)/16)*2;
	      if ((Image=AllocBitMap(Bytes*8,BMHD->Height,BMHD->Depth,0,NULL)))
		{
		  WORD Row;

		  for (Row=0; Global->Error==0 && Row<BMHD->Height; Row++)
		    {
		      WORD Plane;

		      for (Plane=0; Image && Plane<BMHD->Depth; Plane++)
			{
			  Global->Error=MyReadChunkBytes(IFFParseBase,
							 IFFHandle,
							 ((UBYTE *)Image->Planes[Plane])+
							 Row*Image->BytesPerRow,
							 Bytes);
			}
		    }
		  if (Global->Error==0)
		    {
		      Sprite->Width=BMHD->Width;
		      Sprite->Height=BMHD->Height;
		      if (CMAP)
			{
			  LONG *Pens;

			  assert(!(Sprite->Flags & SPRTF_NOIMAGE));
			  if ((Pens=GetPens(Global,CMAP,Sprites)))
			    {
			      struct DrawInfo *DrawInfo;

			      if ((DrawInfo=GetScreenDrawInfo(Global->Screen)))
				{
				  ULONG Depth;
				  struct BitMap PlaneBitmap;

				  Depth=DrawInfo->dri_Depth;
				  InitBitMap(&PlaneBitmap,1,Image->BytesPerRow*8,Image->Rows);

				  /* copy & remap the image */
				  if ((Sprite->Image=AllocBitMap(Sprite->Width, Sprite->Height, Depth,
								 BMF_INTERLEAVED | BMF_CLEAR,
								 Global->Screen->RastPort.BitMap)))
				    {
				      struct BitMap *Temp;

				      PlaneBitmap.Depth=Depth;
				      if ((Temp=AllocBitMap(Sprite->Width, Sprite->Height, Depth,
							    BMF_INTERLEAVED, Global->Screen->RastPort.BitMap)))
					{
					  ULONG Color;
					  struct RastPort RastPort;

					  InitRastPort(&RastPort);
					  RastPort.BitMap=Temp;
					  for (Color=(Sprite->Flags & SPRTF_NOMASK) ? 0 : 1;
					       Color<CMAP->sp_Size/3;
					       Color++)
					    {
					      WORD Plane;

					      SetRast(&RastPort,Pens[Color]);
					      for (Plane=Image->Depth; Plane--;)
						{
						  WORD i;

						  for (i=Depth; i--;)
						    {
						      PlaneBitmap.Planes[i]=Image->Planes[Plane];
						    }
						  if (Color & (1<<Plane))
						    {
						      /* AND */
						      BltBitMap(&PlaneBitmap,0,0,Temp,0,0,
								Sprite->Width,Sprite->Height,0x80,0xff,NULL);
						    }
						  else
						    {
						      /* MASK */
						      BltBitMap(&PlaneBitmap,0,0,Temp,0,0,
								Sprite->Width,Sprite->Height,0x20,0xff,NULL);
						    }
						}
					      /* OR */
					      BltBitMap(Temp,0,0,Sprite->Image,0,0,
							Sprite->Width,Sprite->Height,0xe0,0xff,NULL);
					    }
					  WaitBlit();
					  FreeBitMap(Temp);
					}
				      else
					{
					  Global->Error=ERROR_NO_FREE_STORE;
					}
				      if (Global->Error!=0)
					{
					  FreeBitMap(Sprite->Image);
					  Sprite->Image=NULL;
					}
				    }
				  else
				    {
				      Global->Error=ERROR_NO_FREE_STORE;
				    }

				  /* create the mask */
				  if (Global->Error==0 && !(Sprite->Flags & SPRTF_NOMASK))
				    {
				      WORD MaskDepth;

				      if (GetBitMapAttr(Sprite->Image,BMA_FLAGS) & BMF_STANDARD)
					{
					  WORD Plane;

					  if ((Sprite->Mask=AllocBitMap(Sprite->Width, Sprite->Height, 1, 0, NULL)))
					    {
					      for (Plane=1; Plane<Depth; Plane++)
						{
						  Sprite->Mask->Planes[Plane]=Sprite->Mask->Planes[0];
						}
					      Sprite->Mask->Depth=Depth;
					      MaskDepth=1;
					      PlaneBitmap.Depth=1;
					    }
					}
				      else
					{
					  if ((Sprite->Mask=AllocBitMap(Sprite->Width, Sprite->Height, Depth,
									BMF_INTERLEAVED,
									Global->Screen->RastPort.BitMap)))
					    {
					      MaskDepth=Depth;
					      PlaneBitmap.Depth=Depth;
					    }
					}
				      if (Sprite->Mask!=NULL)
					{
					  WORD Plane;

					  for (Plane=0; Plane<Image->Depth; Plane++)
					    {
					      WORD i;

					      for (i=0; i<MaskDepth; i++)
						{
						  PlaneBitmap.Planes[i]=Image->Planes[Plane];
						}
					      if (Plane)
						{
						  BltBitMap(&PlaneBitmap,0,0,Sprite->Mask,0,0,
							    Sprite->Width,Sprite->Height,0xe0,0xff,NULL);
						}
					      else
						{
						  BltBitMap(&PlaneBitmap,0,0,Sprite->Mask,0,0,
							    Sprite->Width,Sprite->Height,0xc0,0xff,NULL);
						}
					    }
					}
				      else
					{
					  Global->Error=ERROR_NO_FREE_STORE;
					}
				    }
				  FreeScreenDrawInfo(Global->Screen,DrawInfo);
				}
			      else
				{
				  Global->Error=ERROR_NO_FREE_STORE;
				}
			      GS_MemoryFree(Pens);
			    }
			}
		      else
			{
			  assert(Sprite->Flags & SPRTF_NOIMAGE);
			  Sprite->Image=Image;
			  Image=NULL;
			}
		    }
		  WaitBlit();
		  FreeBitMap(Image);
		}
	      else
		{
		  Global->Error=ERROR_NO_FREE_STORE;
		}
	    }
	  else
	    {
	      Global->Error=IFFERR_MANGLED;
	    }
	}
      else
	{
	  Global->Error=IFFERR_MANGLED;
	}
    }
  else
    {
      Global->Error=IFFERR_MANGLED;
    }
  return Global->Error;
}

/************************************************************************/
/*									*/
/* Read the original sprites from the selected set.			*/
/* This returns the full sprite array, but only the original sprites	*/
/* are already initialized.						*/
/* The reflected sprites will have Width=Source				*/
/*									*/
/************************************************************************/

static INLINE struct GS_Sprites *ReadOriginalSprites(struct Global *Global, struct SetInfo *SetInfo)

{
  struct GS_Sprites *Sprites;

  Sprites=NULL;
  if (Seek(Global->File,0,OFFSET_BEGINNING)!=-1)
    {
      struct IFFHandle *IFFHandle;

      if ((IFFHandle=AllocIFF()))
	{
	  LONG Error;

	  IFFHandle->iff_Stream=Global->File;
	  InitIFFasDOS(IFFHandle);
	  if (!(Error=OpenIFF(IFFHandle,IFFF_READ)))
	    {
	      if (!(Error=FindSet(Global,IFFHandle,SetInfo)))
		{
		  static struct {ULONG Type; ULONG ID;} PropArray[]=
		    {
		      {MAKE_ID('S','P','R','T'),MAKE_ID('C','M','A','P')},
		      {MAKE_ID('S','P','R','T'),MAKE_ID('S','P','R','T')},
		      {MAKE_ID('I','L','B','M'),MAKE_ID('B','M','H','D')},
		      {MAKE_ID('I','L','B','M'),MAKE_ID('C','M','A','P')}
		    };

		  if (!(Error=PropChunks(IFFHandle,(ULONG *)PropArray,ARRAYSIZE(PropArray))) &&
		      !(Error=StopChunk(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('B','O','D','Y'))) &&
		      !(Error=StopOnExit(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('F','O','R','M'))))
		    {
		      ULONG OriginalCount;

		      OriginalCount=0;
		      do
			{
			  Error=ParseIFF(IFFHandle,IFFPARSE_SCAN);
			  if (Error==0)
			    {
			      struct ContextNode *ContextNode;

			      ContextNode=CurrentChunk(IFFHandle);
			      if (ContextNode->cn_Type==MAKE_ID('I','L','B','M') && ContextNode->cn_ID==MAKE_ID('B','O','D','Y'))
				{
				  if (OriginalCount==0)
				    {
				      Sprites=InitSpriteArray(Global,IFFHandle,SetInfo);
				    }
				  if (Sprites)
				    {
				      ULONG i;

				      for (i=0; i<Sprites->SpriteCount; i++)
					{
					  if (!Sprites->Sprites[i].Image &&
					      (Sprites->Sprites[i].Flags & SPRTF_ORIGINAL) &&
					      (Sprites->Sprites[i].Width==OriginalCount))
					    {
					      if (!ReadILBM(Global,IFFHandle,&Sprites->Sprites[i],Sprites))
						{
						  Sprites->Sprites[i].Flags|=SPRTF_FREE;
						  UpdateProgressWindow(Global);
						}
					      else
						{
						  Error=Global->Error;
						}
					      break;
					    }
					}
				    }
				  OriginalCount++;
				}
			    }
			}
		      while (Sprites && !Error);
		      if (Sprites && Error!=IFFERR_EOC)
			{
			  GS_FreeSprites(Sprites,Global->Screen);
			  Sprites=NULL;
			}
		    }
		}
	      CloseIFF(IFFHandle);
	    }
	  if (!Sprites)
	    {
	      Global->Error=Error;
	    }
	  FreeIFF(IFFHandle);
	}
      else
	{
	  Global->Error=ERROR_NO_FREE_STORE;
	}
    }
  else
    {
      Global->Error=IoErr();
    }
  return Sprites;
}

/************************************************************************/
/*									*/
/* Make the reflected sprites						*/
/*									*/
/************************************************************************/

static INLINE struct GS_Sprites *MakeReflectedSprites(struct Global *Global, struct GS_Sprites *Sprites)

{
  int Changed;

  do
    {
      ULONG i;
      struct GS_Sprite *Sprite;

      Changed=FALSE;
      Sprite=Sprites->Sprites;
      i=Sprites->SpriteCount;
      while (i)
	{
	  if (!Sprite->Image)
	    {
	      struct GS_Sprite *Source;

	      Source=&Sprites->Sprites[Sprite->Width];
	      if (Source->Image)
		{
		  assert(!(Sprite->Flags & SPRTF_ORIGINAL));
		  if (Source->Flags & SPRTF_NOIMAGE)
		    {
		      Sprite->Flags|=SPRTF_NOIMAGE;
		    }
		  if (Source->Flags & SPRTF_NOMASK)
		    {
		      Sprite->Flags|=SPRTF_NOMASK;
		    }
		  if (Sprite->Flags & (SPRTF_VERTICAL | SPRTF_HORIZONTAL | SPRTF_COPY))
		    {
		      WORD Width, Height;
		      ULONG Depth;

		      Sprite->Flags|=SPRTF_FREE;
		      if ((Sprite->Flags & SPRTF_HORIZONTAL) && (Sprite->Flags & SPRTF_VERTICAL))
			{
			  Width=Source->Height;
			  Height=Source->Width;
			}
		      else
			{
			  Width=Source->Width;
			  Height=Source->Height;
			}
		      Depth=GetBitMapAttr(Source->Image,BMA_DEPTH);
		      if ((Sprite->Image=AllocBitMap(Width,Height,Depth,BMF_INTERLEAVED,
						     Global->Screen->RastPort.BitMap)))
			{
			  ULONG MaskStandard;

			  if (Source->Mask)
			    {
			      MaskStandard=GetBitMapAttr(Sprite->Image,BMA_FLAGS) & BMF_STANDARD;
			      if (MaskStandard)
				{
				  if ((Sprite->Mask=AllocBitMap(Width,Height,1,0,NULL)))
				    {
				      WORD Plane;

				      for (Plane=1; Plane<Depth; Plane++)
					{
					  Sprite->Mask->Planes[Plane]=Sprite->Mask->Planes[0];
					}
				    }
				}
			      else
				{
				  Sprite->Mask=AllocBitMap(Width,Height,Depth,BMF_INTERLEAVED,
							   Global->Screen->RastPort.BitMap);
				}
			      if (!Sprite->Mask)
				{
				  Global->Error=ERROR_NO_FREE_STORE;
				  GS_FreeSprites(Sprites,Global->Screen);
				  return NULL;
				}
			    }
#ifdef DEBUG
			  else
			    {
			      assert(!Sprite->Mask);
			    }
#endif
			  if ((Sprite->Flags & SPRTF_HORIZONTAL) && (Sprite->Flags & SPRTF_VERTICAL))
			    {
			      WORD Row;

			      for (Row=0; Row<Width; Row++)
				{
				  WORD Column;

				  for (Column=0; Column<Height; Column++)
				    {
				      BltBitMap(Source->Image,Column,Row,Sprite->Image,Row,Column,1,1,0xc0,0xff,NULL);
				      if (Sprite->Mask)
					{
					  BltBitMap(Source->Mask,Column,Row,Sprite->Mask,Row,Column,1,1,0xc0,0xff,NULL);
					}
				    }
				}
			    }
			  else if (Sprite->Flags & SPRTF_VERTICAL)
			    {
			      WORD Column;

			      for (Column=0; Column<Width; Column++)
				{
				  BltBitMap(Source->Image,Column,0,Sprite->Image,Width-Column-1,0,1,Height,0xc0,0xff,NULL);
				  if (Sprite->Mask)
				    {
				      BltBitMap(Source->Mask,Column,0,Sprite->Mask,Width-Column-1,0,1,Height,0xc0,0xff,NULL);
				    }
				}
			    }
			  else if (Sprite->Flags & SPRTF_HORIZONTAL)
			    {
			      WORD Row;

			      for (Row=0; Row<Height; Row++)
				{
				  BltBitMap(Source->Image,0,Row,Sprite->Image,0,Height-Row-1,Width,1,0xc0,0xff,NULL);
				  if (Sprite->Mask)
				    {
				      BltBitMap(Source->Mask,0,Row,Sprite->Mask,0,Height-Row-1,Width,1,0xc0,0xff,NULL);
				    }
				}
			    }
			  else if (Sprite->Flags & SPRTF_COPY)
			    {
			      BltBitMap(Source->Image,0,0,Sprite->Image,0,0,Width,Height,0xc0,0xff,NULL);
			      if (Sprite->Mask)
				{
				  BltBitMap(Source->Mask,0,0,Sprite->Mask,0,0,Width,Height,0xc0,0xff,NULL);
				}
			    }
			  if (Sprite->Mask && MaskStandard)
			    {
			      Sprite->Mask->Depth=Depth;
			    }
			  Sprite->Width=Width;
			  Sprite->Height=Height;
			  UpdateProgressWindow(Global);
			  Changed=TRUE;
			}
		      else
			{
			  Global->Error=ERROR_NO_FREE_STORE;
			  GS_FreeSprites(Sprites,Global->Screen);
			  return NULL;
			}
		    }
		  else
		    {
		      Sprite->Width=Source->Width;
		      Sprite->Height=Source->Height;
		      Sprite->Image=Source->Image;
		      Sprite->Mask=Source->Mask;
		      Sprite->Flags=Source->Flags & ~SPRTF_FREE;
		      UpdateProgressWindow(Global);
		      Changed=TRUE;
		    }
		}
	    }
	  Sprite++;
	  i--;
	}
    }
  while (Changed);
  return Sprites;
}

/****** gamesupport.library/GS_LoadSprites *******************************
*
*   NAME
*	GS_LoadSprites -- load the sprites
*
*   SYNOPSIS
*	Sprites = GS_LoadSprites(Gamename,Screen)
*	   d0                       a0      a1
*
*	GS_Sprites *GS_LoadSprites(const char *, struct Screen *);
*
*   FUNCTION
*	Read a sprite file and return a set of bitmaps.
*
*   INPUTS
*	Gamename     - the name of the game. GS_LoadSprites() will append
*	               ".sprites" to get the filename
*	Screen       - the screen that we want to open on.
*
*   RESULT
*	Sprites - a pointer to a (read-only) structure containing
*	          the colormap and the image/mask bitmaps.
*	          If NULL, IoErr() will return more information.
*	          If IoErr()>0, then it is a dos error. <0 means IFF error.
*
*   NOTE
*	A normal sprite is returned as a friend-bitmap.
*	The mask is a friend-bitmap, too!
*
*   NOTE
*	A sprite with no CMAP and depth 1 is not remapped. Instead,
*	only a BMF_STANDARD image is returned, so you can pass
*	this to BltTemplate().
*
*	Sprites are not shared (because there is no IsFriendBitmap()
*	function).
*
*	Sigh. I wish Commodore (or whoever owns the Amiga these days)
*	would finally redesign all these broken gfx calls.
*	graphics.library is not really something that you could
*	show around without being ashamed. :(
*
*************************************************************************/

SAVEDS_ASM_A0A1(struct GS_Sprites *,LibGS_LoadSprites,char *,Gamename,struct Screen *,Screen)

{
  struct GS_Sprites *Sprites;
  struct Global TheGlobal;

  Sprites=NULL;
  TheGlobal.SpritesDone=0;
  TheGlobal.Screen=Screen;
  TheGlobal.Error=0;
  if ((TheGlobal.LibBase=OpenLibrary(IFFParseName,36)))
    {
      char *Filename;

      {
	char *Name;

	Name=Gamename;
	Filename=GS_FormatString("PROGDIR:%s.sprites",&Name,NULL,NULL);
      }
      if (Filename!=NULL)
	{
	  if ((TheGlobal.File=Open(Filename,MODE_OLDFILE)))
	    {
	      struct SetInfo *SetInfo;
	      ULONG SetCount;

	      CreateProgressWindow(&TheGlobal,Gamename);
	      ObtainSemaphore(&Screen->ViewPort.ColorMap->PalExtra->pe_Semaphore);
	      if ((SetInfo=GetSetInfo(&TheGlobal,&SetCount)))
		{
		  struct SetInfo *TheSet;

		  TheSet=SelectSet(&TheGlobal,SetInfo,SetCount);
		  if ((Sprites=ReadOriginalSprites(&TheGlobal,TheSet)))
		    {
		      Sprites=MakeReflectedSprites(&TheGlobal,Sprites);
		    }
		  GS_MemoryFree(SetInfo);
		}
	      ReleaseSemaphore(&Screen->ViewPort.ColorMap->PalExtra->pe_Semaphore);
	      CloseProgressWindow(&TheGlobal);
	      Close(TheGlobal.File);
	    }
	  else
	    {
	      TheGlobal.Error=IoErr();
	    }
	  GS_MemoryFree(Filename);
	}
      else
	{
	  TheGlobal.Error=ERROR_NO_FREE_STORE;
	}
      CloseLibrary(TheGlobal.LibBase);
    }
  SetIoErr(TheGlobal.Error);
  return Sprites;
}

/****** gamesupport.library/GS_FreeSprites *******************************
*
*   NAME
*	GS_FreeSprites -- free sprites loaded with GS_LoadSprites
*
*   SYNOPSIS
*	GS_FreeSprites(Sprites, Screen);
*	                  a0      a1
*
*	void GS_FreeSprites(struct GS_Sprites *, struct Screen *);
*
*   FUNCTION
*	Free the sprites. Call this when you're done with them.
*	The recommended usage is to close the window first, to make
*	sure that the colors are no longer visible.
*
*   INPUTS
*	Sprites - the sprites returned from GS_LoadSprites(). NULL
*	          is valid.
*	Screen  - the screen that we used to allocate the sprites
*
*   RESULT
*	More free memory. More free colors (possibly).
*
*************************************************************************/

SAVEDS_ASM_A0A1(void,LibGS_FreeSprites,struct GS_Sprites *,Sprites,struct Screen *,Screen)

{
  if (Sprites)
    {
      ULONG i;
      struct GS_Sprite *Sprite;

      GS_FreeColors(Screen,&Sprites->Colors);
      Sprite=Sprites->Sprites;
      i=Sprites->SpriteCount;
      while (i)
	{
	  if (Sprite->Flags & SPRTF_FREE)
	    {
	      if (Sprite->Image)
		{
		  if (Sprite->Mask)
		    {
		      if (GetBitMapAttr(Sprite->Image,BMA_FLAGS) & BMF_STANDARD)
			{
			  Sprite->Mask->Depth=1;
			}
		      FreeBitMap(Sprite->Mask);
		    }
		  FreeBitMap(Sprite->Image);
		}
	    }
	  Sprite++;
	  i--;
	}
      GS_MemoryFree(Sprites);
    }
}
