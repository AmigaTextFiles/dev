#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef UTILITY_UTILITY_H
#include <utility/utility.h>
#endif

#include <proto/iffparse.h>

#define MYLIB_GRAPHICS
#include <MyLib.h>

#include "SPRT.h"

#define SPRTF_NOMASKDATA	(1<<10)

/************************************************************************/

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

struct Sprite
{
  struct BitMap Bitmap;
  WORD Width, Height;
  ULONG OriginalColorCount;
  ULONG *OriginalColorTable;	/* the color table read from the file */
  ULONG ColorCount;
  ULONG *ColorTable;		/* our optimized color table */
};

struct OriginalSprite
{
  struct OriginalSprite *Next;
  UWORD Flags;

  UWORD Number;
  char *Label;

  char *Filename;		/* from the sprite description file */
  ULONG Width;			/* 0 -> anything is allowed */
  ULONG Height;

  struct Sprite *Sprite;
};

struct ReflectedSprite
{
  struct ReflectedSprite *Next;
  UWORD Flags;

  UWORD Number;
  char *Label;

  union
    {
      char *Label;
      void *Original;
    } Source;
};

/************************************************************************/

struct Library *IFFParseBase;
struct GfxBase *GfxBase;
struct DosLibrary *DOSBase;
struct UtilityBase *UtilityBase;

static void *MemoryPool;
static void *ChipPool;

static char *FilePattern;
static char *LabelPattern;

static struct OriginalSprite *OriginalSprites;
static struct ReflectedSprite *ReflectedSprites;

static ULONG TotalColorCount;
static ULONG *TotalColorMap;

/************************************************************************/
/*									*/
/* Memory allocation							*/
/*									*/
/************************************************************************/

static void *Malloc(ULONG Size)

{
  ULONG *Memory;

  if (!(Memory=AllocPooled(MemoryPool,Size)))
    {
      PError(0,NULL);
    }
  return Memory;
}

/************************************************************************/
/*									*/
/* Allocate a bitplane							*/
/*									*/
/************************************************************************/

static PLANEPTR AllocBitplane(struct BitMap *Bitmap)

{
  PLANEPTR Plane;

  if (!(Plane=AllocPooled(ChipPool,Bitmap->Rows*Bitmap->BytesPerRow)))
    {
      PError(0,NULL);
    }
  return Plane;
}

/************************************************************************/
/*									*/
/* Write the IFF sprite file						*/
/*									*/
/************************************************************************/

static INLINE int WriteSprites(const char *Filename)

{
  struct IFFHandle *IFFHandle;
  int RC;

  RC=FALSE;
  if ((IFFHandle=AllocIFF()))
    {
      if ((IFFHandle->iff_Stream=Open(Filename,MODE_NEWFILE)))
	{
	  LONG ErrorCode;

	  InitIFFasDOS(IFFHandle);
	  if (!(ErrorCode=OpenIFF(IFFHandle,IFFF_WRITE)))
	    {
	      struct OriginalSprite *Original;

	      RC=TRUE;
	      if (!(ErrorCode=PushChunk(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('F','O','R','M'),IFFSIZE_UNKNOWN)) &&
		  !(ErrorCode=PushChunk(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('S','P','R','T'),IFFSIZE_UNKNOWN)))
		{
		  ULONG SpriteNumber;

		  for (SpriteNumber=0; !ErrorCode; SpriteNumber++)
		    {
		      struct OriginalSprite *Original;
		      ULONG OriginalNumber;

		      for (Original=OriginalSprites, OriginalNumber=0;
			   Original && Original->Number!=SpriteNumber;
			   Original=Original->Next, OriginalNumber++)
			;
		      if (Original)
			{
			  struct SPRT Data;

			  Data.Original=OriginalNumber;
			  Data.Flags=Original->Flags;
			  ErrorCode=WriteChunkBytes(IFFHandle,&Data,sizeof(Data));
			  if (ErrorCode==sizeof(Data))
			    {
			      ErrorCode=0;
			    }
			  else if (ErrorCode>=0)
			    {
			      ErrorCode=IFFERR_WRITE;
			    }
			}
		      else
			{
			  struct ReflectedSprite *Reflected;

			  for (Reflected=ReflectedSprites;
			       Reflected && Reflected->Number!=SpriteNumber;
			       Reflected=Reflected->Next)
			    ;
			  if (Reflected)
			    {
			      struct SPRT Data;

			      Data.Original=((struct OriginalSprite *)(Reflected->Source.Original))->Number;
			      Data.Flags=Reflected->Flags;
			      ErrorCode=WriteChunkBytes(IFFHandle,&Data,sizeof(Data));
			      if (ErrorCode==sizeof(Data))
				{
				  ErrorCode=0;
				}
			      else if (ErrorCode>=0)
				{
				  ErrorCode=IFFERR_WRITE;
				}
			    }
			  else
			    {
			      break;
			    }
			}
		    }
		  if (!ErrorCode &&
		      !(ErrorCode=PopChunk(IFFHandle)) &&	/* SPRT */
		      !(ErrorCode=PushChunk(IFFHandle,MAKE_ID('S','P','R','T'),MAKE_ID('C','M','A','P'),3*TotalColorCount)))
		    {
		      {
			ULONG i;

			for (i=0; !ErrorCode && i<TotalColorCount; i++)
			  {
			    ErrorCode=WriteChunkBytes(IFFHandle,((UBYTE *)&TotalColorMap[i])+1,3);
			    if (ErrorCode==3)
			      {
				ErrorCode=0;
			      }
			    else if (ErrorCode>=0)
			      {
				ErrorCode=IFFERR_WRITE;
			      }
			  }
		      }
		      if (!ErrorCode &&
			  !(ErrorCode=PopChunk(IFFHandle)))	/* CMAP */
			{
			  for (Original=OriginalSprites; !ErrorCode && Original; Original=Original->Next)
			    {
			      if (!(ErrorCode=PushChunk(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('F','O','R','M'),IFFSIZE_UNKNOWN)) &&
				  !(ErrorCode=PushChunk(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('B','M','H','D'),sizeof(struct BMHD))))
				{
				  struct BMHD BMHD;

				  BMHD.Width=Original->Sprite->Width;
				  BMHD.Height=Original->Sprite->Height;
				  BMHD.Left=0;
				  BMHD.Top=0;
				  for (BMHD.Depth=1; (1<<BMHD.Depth)<Original->Sprite->ColorCount; BMHD.Depth++)
				    ;
				  BMHD.Masking=(Original->Flags & SPRTF_NOMASK) ? 0 : 2;
				  BMHD.Compression=0;
				  BMHD.Pad=0;
				  BMHD.TransparentColor=0;
				  BMHD.XAspect=1;
				  BMHD.YAspect=1;
				  BMHD.PageWidth=Original->Sprite->Bitmap.BytesPerRow*8;
				  BMHD.PageHeight=Original->Sprite->Bitmap.Rows;
				  ErrorCode=WriteChunkBytes(IFFHandle,&BMHD,sizeof(BMHD));
				  if (ErrorCode==sizeof(BMHD))
				    {
				      if (!(ErrorCode=PopChunk(IFFHandle)))	/* BMHD */
					{
					  if (Original->Sprite->ColorCount)
					    {
					      if (!(ErrorCode=PushChunk(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('C','M','A','P'),Original->Sprite->ColorCount*3)))
						{
						  ULONG i;

						  for (i=0; !ErrorCode && i<Original->Sprite->ColorCount; i++)
						    {
						      ErrorCode=WriteChunkBytes(IFFHandle,((UBYTE *)&Original->Sprite->ColorTable[i])+1,3);
						      if (ErrorCode==3)
							{
							  ErrorCode=0;
							}
						      else if (ErrorCode>=0)
							{
							  ErrorCode=IFFERR_WRITE;
							}
						    }
						  if (!ErrorCode)
						    ErrorCode=PopChunk(IFFHandle);	/* CMAP */
						}
					    }
					  if (!ErrorCode &&
					      !(ErrorCode=PushChunk(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('B','O','D','Y'),Original->Sprite->Bitmap.Rows*Original->Sprite->Bitmap.BytesPerRow*BMHD.Depth)))
					    {
					      WORD Row;

					      for (Row=0; !ErrorCode && Row<Original->Sprite->Bitmap.Rows; Row++)
						{
						  WORD Plane;

						  for (Plane=0; !ErrorCode && Plane<BMHD.Depth; Plane++)
						    {
						      ErrorCode=WriteChunkBytes(IFFHandle,((UBYTE *)Original->Sprite->Bitmap.Planes[Plane])+Row*Original->Sprite->Bitmap.BytesPerRow,Original->Sprite->Bitmap.BytesPerRow);
						      if (ErrorCode==Original->Sprite->Bitmap.BytesPerRow)
							{
							  ErrorCode=0;
							}
						      else if (ErrorCode>=0)
							{
							  ErrorCode=IFFERR_WRITE;
							}
						    }
						}
					      if (!ErrorCode && !(ErrorCode=PopChunk(IFFHandle)))	/* BODY */
						{
						  ErrorCode=PopChunk(IFFHandle);	/* ILBM */
						}
					    }
					}
				    }
				  else if (ErrorCode>=0)
				    {
				      ErrorCode=IFFERR_WRITE;
				    }
				}
			    }
			}
		    }
		  if (!ErrorCode)
		    {
		      ErrorCode=PopChunk(IFFHandle);	/* SPRT */
		    }
		}
	      CloseIFF(IFFHandle);
	    }
	  if (ErrorCode)
	    {
	      VFPrintf(StdErr,"IFF error %ld\n",&ErrorCode);
	      RC=FALSE;
	    }
	  if (!Close(IFFHandle->iff_Stream))
	    {
	      PError(0,Filename);
	      RC=FALSE;
	    }
	  if (RC)
	    {
	      SetProtection(Filename,FIBF_EXECUTE);
	    }
	  else
	    {
	      DeleteFile(Filename);
	    }
	}
      else
	{
	  PError(0,Filename);
	}
      FreeIFF(IFFHandle);
    }
  return RC;
}

/************************************************************************/
/*									*/
/* Make a colormap of ALL colors					*/
/*									*/
/************************************************************************/

static INLINE int MakeColormap(void)

{
  struct OriginalSprite *Original;

  for (Original=OriginalSprites; Original; Original=Original->Next)
    {
      TotalColorCount+=Original->Sprite->ColorCount;
    }
  if (!(TotalColorMap=Malloc(TotalColorCount*sizeof(*TotalColorMap))))
    {
      return FALSE;
    }
  TotalColorCount=0;
  for (Original=OriginalSprites; Original; Original=Original->Next)
    {
      ULONG Color;

      for (Color=(Original->Flags & SPRTF_NOMASK) ? 0 : 1; Color<Original->Sprite->ColorCount; Color++)
	{
	  ULONG i;

	  for (i=0;
	       i<TotalColorCount && (TotalColorMap[i]<Original->Sprite->ColorTable[Color]);
	       i++)
	    ;
	  if (i==TotalColorCount || TotalColorMap[i]!=Original->Sprite->ColorTable[Color])
	    {
	      ULONG j;

	      for (j=TotalColorCount; j>i; j--)
		{
		  TotalColorMap[j]=TotalColorMap[j-1];
		}
	      TotalColorMap[i]=Original->Sprite->ColorTable[Color];
	      TotalColorCount++;
	    }
	}
    }
  return TRUE;
}

/************************************************************************/
/*									*/
/* Remap the sprite to the new colortable				*/
/*									*/
/************************************************************************/

static INLINE void RemapColors(struct OriginalSprite *OriginalSprite)

{
  struct Sprite *Sprite;

  Sprite=OriginalSprite->Sprite;
  if (Sprite->ColorCount)
    {
      struct RastPort RastPort;
      WORD y;

      if ((OriginalSprite->Flags & SPRTF_NOMASK) && !(OriginalSprite->Flags & SPRTF_NOMASKDATA))
	{
	  Sprite->ColorTable[0]=Sprite->ColorTable[--Sprite->ColorCount];
	}
      if (OriginalSprite->Flags & SPRTF_NOIMAGE)
	{
	  Sprite->ColorCount=0;
	}
      InitRastPort(&RastPort);
      RastPort.BitMap=&Sprite->Bitmap;
      for (y=0; y<Sprite->Height; y++)
	{
	  WORD x;

	  for (x=0; x<Sprite->Width; x++)
	    {
	      ULONG Pixel;
	      ULONG NewPixel;

	      Pixel=ReadPixel(&RastPort,x,y);
	      if ((OriginalSprite->Flags & SPRTF_NOMASKDATA) || Pixel)
		{
		  if (OriginalSprite->Flags & SPRTF_NOIMAGE)
		    {
		      NewPixel=1;
		    }
		  else
		    {
		      for (NewPixel=(OriginalSprite->Flags & SPRTF_NOMASK) ? 0 : 1;
			   Sprite->ColorTable[NewPixel]!=Sprite->OriginalColorTable[Pixel];
			   NewPixel++)
			;
		      assert(NewPixel<Sprite->ColorCount);
		    }
		}
	      else
		{
		  NewPixel=0;
		}
	      SetABPenDrMd(&RastPort,NewPixel,NewPixel,JAM1);
	      WritePixel(&RastPort,x,y);
	    }
	}
      
      if (!(OriginalSprite->Flags & SPRTF_NOMASK))
	{
	  Sprite->ColorTable[0]=Sprite->ColorTable[1];
	}
    }
}

/************************************************************************/
/*									*/
/* Make sure we don't load the same sprite file twice			*/
/*									*/
/************************************************************************/

static INLINE int RemoveDoubleFiles(void)

{
  struct OriginalSprite **Original;

  for (Original=&OriginalSprites; *Original; Original=&(*Original)->Next)
    {
      struct OriginalSprite **Sprite;

      for (Sprite=&(*Original)->Next; *Sprite; Sprite=&(*Sprite)->Next)
	{
	  if (!strcmp((*Original)->Filename,(*Sprite)->Filename))
	    {
	      if ((*Sprite)->Width==(*Original)->Width && (*Sprite)->Height==(*Original)->Height)
		{
		  struct ReflectedSprite *Reflected;

		  if ((Reflected=Malloc(sizeof(*Reflected))))
		    {
		      Reflected->Flags=SPRTF_ORIGINAL;
		      Reflected->Label=(*Sprite)->Label;
		      Reflected->Source.Original=*Original;
		      Reflected->Next=ReflectedSprites;
		      ReflectedSprites=Reflected;
		      *Original=(*Original)->Next;
		    }
		  else
		    {
		      return FALSE;
		    }
		}
	      else
		{
		  VFPrintf(StdErr,"Mismatched width/height for \x22%s\x22\n",&(*Original)->Filename);
		  return FALSE;
		}
	    }
	}
    }
  return TRUE;
}

/************************************************************************/
/*									*/
/* Make the graph							*/
/*									*/
/************************************************************************/

static INLINE int MakeGraph(void)

{
  struct ReflectedSprite *ReflectedSprite;
  int RC;

  RC=TRUE;
  for (ReflectedSprite=ReflectedSprites; ReflectedSprite; ReflectedSprite=ReflectedSprite->Next)
    {
      struct OriginalSprite *Original;

      for (Original=OriginalSprites;
	   Original && (!Original->Label || strcmp(ReflectedSprite->Source.Label,Original->Label));
	   Original=Original->Next)
	;
      if (Original)
	{
	  ReflectedSprite->Source.Original=Original;
	}
      else
	{
	  struct ReflectedSprite *Reflected;

	  for (Reflected=ReflectedSprites;
	       Reflected && (!Reflected->Label || strcmp(ReflectedSprite->Source.Label,Reflected->Label));
	       Reflected=Reflected->Next)
	    ;
	  if (Reflected)
	    {
	      ReflectedSprite->Source.Original=Reflected;
	    }
	  else
	    {
	      VFPrintf(StdErr,"Label \x22%s\x22 not found\n",&ReflectedSprite->Source.Label);
	      RC=FALSE;
	    }
	}
    }
  return RC;
}

/************************************************************************/
/*									*/
/* Remove double colors from colortable					*/
/*									*/
/************************************************************************/

static INLINE void RemoveDoubleColors(struct OriginalSprite *OriginalSprite)

{
  struct Sprite *Sprite;
  ULONG i;

  Sprite=OriginalSprite->Sprite;
  for (i=(OriginalSprite->Flags & SPRTF_NOMASKDATA) ? 1 : 2; i<Sprite->ColorCount; i++)
    {
      if (Sprite->ColorTable[i-1]==Sprite->ColorTable[i])
	{
	  ULONG j;

	  Sprite->ColorCount--;
	  for (j=i; j<Sprite->ColorCount; j++)
	    {
	      Sprite->ColorTable[j]=Sprite->ColorTable[j+1];
	    }
	  i--;
	}
    }
}

/************************************************************************/
/*									*/
/* Sort the colortable							*/
/*									*/
/************************************************************************/

static INLINE void SortColors(struct OriginalSprite *OriginalSprite)

{
  struct Sprite *Sprite;
  ULONG i;

  Sprite=OriginalSprite->Sprite;
  for (i=(OriginalSprite->Flags & SPRTF_NOMASKDATA) ? 0 : 1; i<Sprite->ColorCount; i++)
    {
      ULONG j;

      for (j=i+1; j<Sprite->ColorCount; j++)
	{
	  if (Sprite->ColorTable[i]>Sprite->ColorTable[j])
	    {
	      ULONG h;

	      h=Sprite->ColorTable[i];
	      Sprite->ColorTable[i]=Sprite->ColorTable[j];
	      Sprite->ColorTable[j]=h;
	    }
	}
    }
}

/************************************************************************/
/*									*/
/* Remove unused colors.						*/
/* This must be called before any of the other optimization functions.	*/
/*									*/
/* Does some integrity checks, too.					*/
/*									*/
/************************************************************************/

static INLINE int RemoveUnusedColors(struct OriginalSprite *OriginalSprite)

{
  struct Sprite *Sprite;

  Sprite=OriginalSprite->Sprite;
  if (Sprite->ColorCount)
    {
      struct RastPort RastPort;
      ULONG i;
      WORD y;

      InitRastPort(&RastPort);
      RastPort.BitMap=&Sprite->Bitmap;
      for (y=0; y<Sprite->Height; y++)
	{
	  WORD x;

	  for (x=0; x<Sprite->Width; x++)
	    {
	      ULONG Pixel;

	      Pixel=ReadPixel(&RastPort,x,y);
	      if (Pixel>Sprite->ColorCount)
		{
		  VFPrintf(StdErr,"Used color not defined in colortable\n",NULL);
		  return FALSE;
		}
	      Sprite->ColorTable[Pixel]|=1<<31;
	    }
	}
      for (i=(OriginalSprite->Flags & SPRTF_NOMASKDATA) ? 0 : 1; i<Sprite->ColorCount; i++)
	{
	  if (!(Sprite->ColorTable[i]&(1<<31)))
	    {
	      Sprite->ColorTable[i]=Sprite->ColorTable[--Sprite->ColorCount];
	      i--;
	    }
	  else
	    {
	      Sprite->ColorTable[i]&=~(1<<31);
	    }
	}
    }
  return TRUE;
}

/************************************************************************/
/*									*/
/* Read an IFF-ILBM image and return it					*/
/*									*/
/************************************************************************/

static INLINE struct Sprite *ReadSprite(struct OriginalSprite *OriginalSprite, const char *Name)

{
  struct Sprite *Sprite;
  struct IFFHandle *IFFHandle;

  Sprite=NULL;
  if ((IFFHandle=AllocIFF()))
    {
      if ((IFFHandle->iff_Stream=Open(Name,MODE_OLDFILE)))
	{
	  LONG ErrorCode;

	  InitIFFasDOS(IFFHandle);
	  if (!(ErrorCode=OpenIFF(IFFHandle,IFFF_READ)))
	    {
	      static ULONG PropArray[][2]=
		{
		  {MAKE_ID('I','L','B','M'),MAKE_ID('B','M','H','D')},
		  {MAKE_ID('I','L','B','M'),MAKE_ID('C','M','A','P')}
		};

	      if (!(ErrorCode=PropChunks(IFFHandle,(ULONG *)PropArray,ARRAYSIZE(PropArray))))
		{
		  if (!(ErrorCode=StopChunk(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('B','O','D','Y'))))
		    {
		      if (!(ErrorCode=ParseIFF(IFFHandle,IFFPARSE_SCAN)))
			{
			  struct StoredProperty *BMHDProperty;

			  BMHDProperty=FindProp(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('B','M','H','D'));
			  if (BMHDProperty)
			    {
			      ULONG ColorCount;
			      struct StoredProperty *CMAPProperty;
			      WORD Depth;

			      CMAPProperty=FindProp(IFFHandle,MAKE_ID('I','L','B','M'),MAKE_ID('C','M','A','P'));
			      if (CMAPProperty)
				{
				  if (OriginalSprite->Flags & SPRTF_NOIMAGE)
				    {
				      ColorCount=0;
				      CMAPProperty=NULL;
				    }
				  else
				    {
				      ColorCount=CMAPProperty->sp_Size/3;
				    }
				}
			      else
				{
				  ColorCount=0;
				  OriginalSprite->Flags|=SPRTF_NOIMAGE;
				}
			      Depth=((struct BMHD *)BMHDProperty->sp_Data)->Depth;
			      switch (((struct BMHD *)BMHDProperty->sp_Data)->Masking)
				{
				case 0:
				  OriginalSprite->Flags|=SPRTF_NOMASKDATA | SPRTF_NOMASK;
				  break;

				case 1:
				  Depth++;
				  break;

				case 2:
				  break;

				default:
				  VFPrintf(StdErr,"Masking method not supported\n",NULL);
				  break;
				}
			      if (Depth<=8)
				{
				  if ((Sprite=Malloc(sizeof(*Sprite)+(2*(ColorCount+1))*sizeof(ULONG))))
				    {
				      {
					WORD Plane;

					for (Plane=0; Plane<8; Plane++)
					  {
					    Sprite->Bitmap.Planes[Plane]=NULL;
					  }
				      }
				      Sprite->OriginalColorCount=ColorCount;
				      Sprite->ColorCount=ColorCount;
				      Sprite->Width=((struct BMHD *)BMHDProperty->sp_Data)->Width;
				      Sprite->Height=((struct BMHD *)BMHDProperty->sp_Data)->Height;
				      Sprite->OriginalColorTable=(ULONG *)(Sprite+1);
				      Sprite->ColorTable=Sprite->OriginalColorTable+ColorCount+1;
				      InitBitMap(&Sprite->Bitmap, Depth, Sprite->Width, Sprite->Height);

				      {
					WORD Plane;

					for (Plane=0; Sprite && Plane<Depth; Plane++)
					  {
					    if (!(Sprite->Bitmap.Planes[Plane]=AllocBitplane(&Sprite->Bitmap)))
					      {
						Sprite=NULL;
					      }
					  }
				      }

				      /* copy the color table */
				      if (Sprite && CMAPProperty)
					{
					  ULONG i;
					  UBYTE *Colors;

					  Colors=CMAPProperty->sp_Data;
					  for (i=0; i<ColorCount; i++)
					    {
					      union
						{
						  struct
						    {
						      UBYTE Pad;
						      UBYTE Red, Green, Blue;
						    } RGB;
						  ULONG Value;
						} Color;

					      Color.RGB.Red=*(Colors++);
					      Color.RGB.Green=*(Colors++);
					      Color.RGB.Blue=*(Colors++);
					      Color.RGB.Pad=0;
					      Sprite->OriginalColorTable[i]=Color.Value;
					      Sprite->ColorTable[i]=Color.Value;
					    }
					}

				      /* Read the image */
				      {
					WORD Row;

					for (Row=0; Sprite && Row<Sprite->Height; Row++)
					  {
					    WORD Plane;

					    for (Plane=0; Plane<Depth; Plane++)
					      {
						UBYTE *Data;

						Data=(((UBYTE *)Sprite->Bitmap.Planes[Plane])+
						      Row*Sprite->Bitmap.BytesPerRow);
						switch (((struct BMHD *)BMHDProperty->sp_Data)->Compression)
						  {
						  case 0:
						    {
						      ErrorCode=ReadChunkBytes(IFFHandle,Data,Sprite->Bitmap.BytesPerRow);
						      if (ErrorCode==Sprite->Bitmap.BytesPerRow)
							{
							  ErrorCode=0;
							}
						      else
							{
							  Sprite=NULL;
							}
						    }
						    break;

						  case 1:
						    {
						      UWORD Count;

						      Count=0;
						      while (Sprite && Count<Sprite->Bitmap.BytesPerRow)
							{
							  BYTE n;

							  ErrorCode=ReadChunkBytes(IFFHandle,&n,1);
							  if (ErrorCode==1)
							    {
							      ErrorCode=0;
							      if (n>=0)
								{
								  ErrorCode=ReadChunkBytes(IFFHandle,Data+Count,n+1);
								  if (ErrorCode==n+1)
								    {
								      ErrorCode=0;
								      Count+=n+1;
								    }
								  else
								    {
								      Sprite=NULL;
								    }
								}
							      else if (n!=-128)
								{
								  UBYTE Byte;

								  ErrorCode=ReadChunkBytes(IFFHandle,&Byte,1);
								  if (ErrorCode==1)
								    {
								      ErrorCode=0;
								      for (n=-n; n>=0; n--)
									{
									  Data[Count++]=Byte;
									}
								    }
								  else
								    {
								      Sprite=NULL;
								    }
								}
							    }
							  else
							    {
							      Sprite=NULL;
							    }
							}
						    }
						    break;

						  default:
						    {
						      VFPrintf(StdErr,"Compression method not supported\n",NULL);
						      Sprite=NULL;
						    }
						    break;
						  }
					      }
					  }
				      }

				      if (Sprite)
					{
					  OriginalSprite->Sprite=Sprite;

					  /* change the mask, if necessary */
					  switch(((struct BMHD *)BMHDProperty->sp_Data)->Masking)
					    {
					    case 1:
					      {
						struct RastPort RastPort;
						WORD y;

						Sprite->ColorTable[Sprite->ColorCount++]=Sprite->ColorTable[0];
						Sprite->OriginalColorTable[Sprite->OriginalColorCount++]=Sprite->OriginalColorTable[0];
						InitRastPort(&RastPort);
						RastPort.BitMap=&Sprite->Bitmap;
						for (y=0; y<Sprite->Height; y++)
						  {
						    WORD x;

						    for (x=0; x<Sprite->Width; x++)
						      {
							ULONG Pixel;

							Pixel=ReadPixel(&RastPort,x,y);
							if (Pixel & (1<<(Sprite->Bitmap.Depth-1)))
							  {
							    Pixel &=~ (1<<(Sprite->Bitmap.Depth-1));
							    if (Pixel==0)
							      {
								Pixel=Sprite->ColorCount-1;
							      }
							  }
							else
							  {
							    Pixel=0;
							  }
							SetABPenDrMd(&RastPort,Pixel,Pixel,JAM1);
							WritePixel(&RastPort,x,y);
						      }
						  }
					      }
					      break;

					    case 2:
					      {
						ULONG TransparentColor;

						if ((TransparentColor=((struct BMHD *)BMHDProperty->sp_Data)->TransparentColor))
						  {
						    struct RastPort RastPort;
						    WORD y;

						    Sprite->ColorTable[TransparentColor]=Sprite->ColorTable[0];
						    Sprite->OriginalColorTable[TransparentColor]=Sprite->OriginalColorTable[0];
						    InitRastPort(&RastPort);
						    RastPort.BitMap=&Sprite->Bitmap;
						    for (y=0; y<Sprite->Height; y++)
						      {
							WORD x;

							for (x=0; x<Sprite->Width; x++)
							  {
							    ULONG Pixel;

							    Pixel=ReadPixel(&RastPort,x,y);
							    if (Pixel==TransparentColor)
							      {
								SetABPenDrMd(&RastPort,0,0,JAM1);
								WritePixel(&RastPort,x,y);
							      }
							    else if (Pixel==0)
							      {
								SetABPenDrMd(&RastPort,
									     TransparentColor,
									     TransparentColor,
									     JAM1);
								WritePixel(&RastPort,x,y);
							      }
							  }
						      }
						  }
					      }
					      break;
					    }
					}
				    }
				}
			    }
			}
		    }
		}
	      CloseIFF(IFFHandle);
	    }
	  Close(IFFHandle->iff_Stream);
	  if (ErrorCode)
	    {
	      VFPrintf(StdErr,"IFF error: %ld\n",&ErrorCode);
	    }
	}
      else
	{
	  PError(0,Name);
	}
      FreeIFF(IFFHandle);
    }
  return Sprite;
}

/************************************************************************/
/*									*/
/* Read the sprite files						*/
/*									*/
/************************************************************************/

static INLINE int ReadSprites(void)

{
  struct OriginalSprite *Original;

  for (Original=OriginalSprites; Original; Original=Original->Next)
    {
      char Filename[1024];
      struct Sprite *Sprite;

      SPrintf(Filename,FilePattern,Original->Filename);
      if ((Sprite=ReadSprite(Original,Filename)))
	{
	  if (Original->Flags & SPRTF_NOIMAGE)
	    {
	    }
	  else
	    {
	      if (RemoveUnusedColors(Original))
		{
		  SortColors(Original);
		  RemoveDoubleColors(Original);
		  RemapColors(Original);
		}
	      else
		{
		  return FALSE;
		}
	    }
	  Original->Flags&=~SPRTF_NOMASKDATA;
	}
      else
	{
	  return FALSE;
	}
      if (CheckSignal(SIGBREAKF_CTRL_C))
	{
	  PError(ERROR_BREAK,NULL);
	  return FALSE;
	}
    }
  return TRUE;
}

/************************************************************************/
/*									*/
/* Output the header file						*/
/*									*/
/************************************************************************/

static INLINE int CreateHeaderFile(const char *Filename)

{
  int RC;

  RC=FALSE;
  if (Filename)
    {
      BPTR File;

      if ((File=Open(Filename,MODE_NEWFILE)))
	{
	  struct DateStamp TheStamp;

	  DateStamp(&TheStamp);
	  if (!FPuts(File,
		     "/* This file was created automatically.	*/\n"
		     "/* Do not edit.				*/\n\n") &&
	      VFPrintf(File,"#ifndef SPRITE_%lu_%lu_%lu\n",&TheStamp)!=-1 &&
	      VFPrintf(File,"#define SPRITE_%lu_%lu_%lu\n\n",&TheStamp)!=-1)
	    {
	      RC=TRUE;
	      {
		struct OriginalSprite *Original;

		for (Original=OriginalSprites; RC && Original; Original=Original->Next)
		  {
		    if (Original->Label && Original->Label[0] && Original->Label[0]!='_')
		      {
			if (FPuts(File,"#define ") ||
			    VFPrintf(File,LabelPattern,&Original->Label)==-1 ||
			    VFPrintf(File," %u\n",&Original->Number)==-1)
			  {
			    RC=FALSE;
			  }
		      }
		  }
	      }
	      {
		struct ReflectedSprite *Reflected;

		for (Reflected=ReflectedSprites; RC && Reflected; Reflected=Reflected->Next)
		  {
		    if (Reflected->Label && Reflected->Label[0] && Reflected->Label[0]!='_')
		      {
			if (FPuts(File,"#define ") ||
			    VFPrintf(File,LabelPattern,&Reflected->Label)==-1 ||
			    VFPrintf(File," %u\n",&Reflected->Number)==-1)
			  {
			    RC=FALSE;
			  }
		      }
		  }
	      }
	      if (RC)
		{
		  if (VFPrintf(File,"\n#endif  /* SPRITE_%lu_%lu_%lu */\n",&TheStamp)==-1)
		    {
		      RC=FALSE;
		    }
		}
	      if (!RC)
		{
		  PError(0,Filename);
		}
	    }
	  if (!Close(File) && RC)
	    {
	      PError(0,Filename);
	      RC=FALSE;
	    }
	  if (!RC)
	    {
	      DeleteFile(Filename);
	    }
	  else
	    {
	      SetProtection(Filename,FIBF_EXECUTE);
	    }
	}
      else
	{
	  PError(0,Filename);
	}
    }
  else
    {
      RC=TRUE;
    }
  return RC;
}

/************************************************************************/
/*									*/
/* Read the sprite description file					*/
/*									*/
/* The following line formats are allowed:				*/
/* empty line								*/
/* # comment line							*/
/* FILEPATTERN/K,LABELPATTERN/K						*/
/* FILE/A,WIDTH/N,HEIGHT/N,NOIMAGE/S,NOMASK/S,LABEL/K			*/
/* REFLECT/K,DIAGONAL/S,VERTICAL/S,HORIZONTAL/S,ALIAS/S,COPY/S,LABEL/K	*/
/*									*/
/************************************************************************/

static INLINE int ReadSpriteDesc(const char *Name)

{
  BPTR Filehandle;
  int RC;

  RC=FALSE;
  if ((Filehandle=Open(Name,MODE_OLDFILE)))
    {
      ULONG SpriteNumber;
      LONG c;

      SpriteNumber=0;
      do
	{
	  /* skip whitespace */
	  do
	    {
	      c=FGetC(Filehandle);
	    }
	  while (c==' ' || c=='\t' || c=='\n');

	  /* comment? */
	  if (c=='#')
	    {
	      do
		{
		  c=FGetC(Filehandle);
		}
	      while (c!='\n' && c!=-1);
	    }
	  else if (c!=-1)
	    {
	      LONG FilePos;

	      UnGetC(Filehandle,c);
	      c=FilePos=Seek(Filehandle,0,OFFSET_CURRENT);

	      if (c!=-1)
		{
		  BPTR OldInput;
		  struct RDArgs *RDArgs;
		  union
		    {
		      struct
			{
			  char *FilePattern;
			  char *LabelPattern;
			} Type1;
		      struct
			{
			  char *Source;
			  LONG Alias;
			  LONG Vertical;
			  LONG Horizontal;
			  LONG Diagonal;
			  LONG Copy;
			  char *Label;
			} Type2;
		      struct
			{
			  char *Filename;
			  LONG *Width;
			  LONG *Height;
			  LONG NoImage;
			  LONG NoMask;
			  char *Label;
			} Type3;
		    } Arguments;

		  OldInput=SelectInput(Filehandle);
		  if ((RDArgs=ReadArgs("FILEPATTERN/K/A,LABELPATTERN/K/A",(LONG *)&Arguments.Type1,NULL)))
		    {
		      if (!FilePattern)
			{
			  if ((FilePattern=Malloc(strlen(Arguments.Type1.FilePattern)+1)))
			    {
			      strcpy(FilePattern,Arguments.Type1.FilePattern);
			      if ((LabelPattern=Malloc(strlen(Arguments.Type1.LabelPattern)+1)))
				{
				  strcpy(LabelPattern,Arguments.Type1.LabelPattern);
				}
			      else
				{
				  c=-1;
				}
			    }
			  else
			    {
			      c=-1;
			    }
			}
		      else
			{
			  VFPrintf(StdErr,"Only one FILEPATTERN/LABELPATTERN line allowed\n",NULL);
			  c=-1;
			}
		    }
		  else
		    {
		      c=Seek(Filehandle,FilePos,OFFSET_BEGINNING);
		      if (c!=-1)
			{
			  Arguments.Type2.Vertical=Arguments.Type2.Horizontal=Arguments.Type2.Diagonal=Arguments.Type2.Copy=FALSE;
			  Arguments.Type2.Label=NULL;
			  if ((RDArgs=ReadArgs("REFLECT/K/A,ALIAS/S,VERTICAL/S,HORIZONTAL/S,"
					       "DIAGONAL/S,COPY/S,LABEL/K",(LONG *)&Arguments.Type2,NULL)))
			    {
			      struct ReflectedSprite *ReflectedSprite;

			      if ((ReflectedSprite=Malloc(sizeof(*ReflectedSprite)+strlen(Arguments.Type2.Source)+1)))
				{
				  int Count;

				  ReflectedSprite->Flags=0;
				  ReflectedSprite->Number=SpriteNumber++;
				  ReflectedSprite->Source.Label=(char *)(ReflectedSprite+1);
				  strcpy(ReflectedSprite->Source.Label,Arguments.Type2.Source);
				  Count=0;
				  if (Arguments.Type2.Vertical)
				    {
				      ReflectedSprite->Flags|=SPRTF_VERTICAL;
				      Count++;
				    }
				  if (Arguments.Type2.Horizontal)
				    {
				      ReflectedSprite->Flags|=SPRTF_HORIZONTAL;
				      Count++;
				    }
				  if (Arguments.Type2.Diagonal)
				    {
				      ReflectedSprite->Flags|=SPRTF_VERTICAL | SPRTF_HORIZONTAL;
				      Count++;
				    }
				  if (Arguments.Type2.Copy)
				    {
				      ReflectedSprite->Flags|=SPRTF_COPY;
				      Count++;
				    }
				  if (Count<=1)
				    {
				      ReflectedSprite->Next=ReflectedSprites;
				      ReflectedSprites=ReflectedSprite;
				      if (Arguments.Type2.Label)
					{
					  if ((ReflectedSprite->Label=Malloc(strlen(Arguments.Type2.Label)+1)))
					    {
					      strcpy(ReflectedSprite->Label,Arguments.Type2.Label);
					    }
					  else
					    {
					      c=-1;
					    }
					}
				      else
					{
					  ReflectedSprite->Label=NULL;
					}
				    }
				  else
				    {
				      VFPrintf(StdErr,"Only one of HORIZONTAL, VERTICAL or DIAGONAL is allowed\n",NULL);
				      c=-1;
				    }
				}
			      else
				{
				  c=-1;
				}
			    }
			  else
			    {
			      c=Seek(Filehandle,FilePos,OFFSET_BEGINNING);
			      if (c!=-1)
				{
				  Arguments.Type3.Width=Arguments.Type3.Height=NULL;
				  Arguments.Type3.Label=NULL;
				  Arguments.Type3.NoImage=FALSE;
				  Arguments.Type3.NoMask=FALSE;
				  if ((RDArgs=ReadArgs("FILENAME/A,WIDTH/N,HEIGHT/N,NOIMAGE=MASKONLY/S,NOMASK=IMAGEONLY/S,LABEL/K",
						       (LONG *)&Arguments.Type3,NULL)))
				    {
				      struct OriginalSprite *OriginalSprite;

				      if ((Arguments.Type3.Width && !*Arguments.Type3.Width) ||
					  (Arguments.Type3.Height && !*Arguments.Type3.Height))
					{
					  VFPrintf(StdErr,"Width/Height zero is not allowed\n",NULL);
					  c=-1;
					}
				      else if ((OriginalSprite=Malloc(sizeof(*OriginalSprite)+strlen(Arguments.Type3.Filename)+1)))
					{
					  OriginalSprite->Flags=SPRTF_ORIGINAL;
					  if (Arguments.Type3.NoImage)
					    {
					      OriginalSprite->Flags|=SPRTF_NOIMAGE;
					    }
					  if (Arguments.Type3.NoMask)
					    {
					      OriginalSprite->Flags|=SPRTF_NOMASK;
					    }
					  OriginalSprite->Number=SpriteNumber++;
					  OriginalSprite->Filename=(char *)(OriginalSprite+1);
					  strcpy(OriginalSprite->Filename,Arguments.Type3.Filename);
					  if (Arguments.Type3.Width)
					    OriginalSprite->Width=*Arguments.Type3.Width;
					  else
					    OriginalSprite->Width=0;
					  if (Arguments.Type3.Height)
					    OriginalSprite->Height=*Arguments.Type3.Height;
					  else
					    OriginalSprite->Height=0;
					  OriginalSprite->Next=OriginalSprites;
					  OriginalSprites=OriginalSprite;
					  if (Arguments.Type3.Label)
					    {
					      if ((OriginalSprite->Label=Malloc(strlen(Arguments.Type3.Label)+1)))
						{
						  strcpy(OriginalSprite->Label,Arguments.Type3.Label);
						}
					      else
						{
						  c=-1;
						}
					    }
					  else
					    {
					      OriginalSprite->Label=NULL;
					    }
					}
				      else
					{
					  c=-1;
					}
				    }
				  else
				    {
				      VFPrintf(StdErr,"Invalid sprite description file\n",NULL);
				    }
				}
			      else
				{
				  PError(0,Name);
				}
			    }
			}
		      else
			{
			  PError(0,Name);
			}
		    }
		  FreeArgs(RDArgs);
		  SelectInput(OldInput);
		}
	      else
		{
		  PError(0,Name);
		}
	    }
	  else
	    {
	      if (IoErr())
		{
		  PError(0,Name);
		}
	      else
		{
		  RC=TRUE;
		}
	    }
	}
      while (c!=-1);
      Close(Filehandle);
    }
  else
    {
      PError(0,Name);
    }
  return RC;
}

/************************************************************************/
/*									*/
/*									*/
/************************************************************************/

int AmigaMain(void)

{
  int RC;

  RC=RETURN_CATASTROPHY;
  if (!WorkbenchMessage)
    {
      if ((DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",ROM_VERSION)))
	{
	  if ((UtilityBase=(struct UtilityBase *)OpenLibrary("utility.library",ROM_VERSION)))
	    {
	      if ((GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",ROM_VERSION)))
		{
		  RC=RETURN_FAIL;
		  ErrorHandle();
		  if ((MemoryPool=CreatePool(0,8192,8192)))
		    {
		      if ((ChipPool=CreatePool(0,16384,16384)))
			{
			  if ((IFFParseBase=OpenLibrary("iffparse.library",36)))
			    {
			      struct RDArgs *RDArgs;
			      struct
				{
				  const char *DescFile;
				  const char *ListFile;
				  const char *HeaderFile;
				  const char *SpriteDir;
				} Arguments;

			      Arguments.DescFile="";
			      Arguments.HeaderFile=NULL;
			      Arguments.ListFile=NULL;
			      if ((RDArgs=ReadArgs("DESCFILE/A,LISTFILE,HEADERFILE,SPRITEDIR",(long *)&Arguments,NULL)))
				{
				  if (ReadSpriteDesc(Arguments.DescFile))
				    {
				      if (CreateHeaderFile(Arguments.HeaderFile))
					{
					  if (Arguments.ListFile)
					    {
					      BPTR DirLock;

					      if ((DirLock=Lock(Arguments.SpriteDir,SHARED_LOCK)))
						{
						  DirLock=CurrentDir(DirLock);
						  RC=ReadSprites();
						  UnLock(CurrentDir(DirLock));
						  if (RC &&
						      MakeGraph() &&
						      RemoveDoubleFiles() &&
						      MakeColormap() &&
						      WriteSprites(Arguments.ListFile))
						    {
						      RC=RETURN_OK;
						    }
						  else
						    {
						      RC=RETURN_FAIL;
						    }
						}
					      else
						{
						  PError(0,Arguments.SpriteDir);
						}
					    }
					  else
					    {
					      RC=RETURN_OK;
					    }
					}
				    }
				  FreeArgs(RDArgs);
				}
			      else
				{
				  PError(0,NULL);
				}
			      CloseLibrary(IFFParseBase);
			    }
			  else
			    {
			      VFPrintf(StdErr,"Unable to open iffparse.library V36 or newer\n",NULL);
			    }
			  DeletePool(ChipPool);
			}
		      else
			{
			  PError(0,NULL);
			}
		      DeletePool(MemoryPool);
		    }
		  else
		    {
		      PError(0,NULL);
		    }
		  CloseStdErr();
		  CloseLibrary(&GfxBase->LibNode);
		}
	      CloseLibrary(&UtilityBase->ub_LibNode);
	    }
	  CloseLibrary(&DOSBase->dl_lib);
	}
    }
  return RC;
}
