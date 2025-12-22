
#ifndef GBITMAP_CPP
#define GBITMAP_CPP

#include "ggraphics/GBitMap.h"
#include "gsystem/GObject.cpp"

GBitMap::GBitMap(ULONG BMWidth, ULONG BMHeight, UWORD BMDepth)
{
	memset((void *)this, 0, sizeof (this));

	Width = BMWidth;
	Height = BMHeight;
	Depth = BMDepth;

#ifdef GAMIGA
	if (AmigaBitMap = AllocBitMap(Width, Height, Depth, BMF_CLEAR | BMF_MINPLANES, NULL) )
	{
		Valid = TRUE;
	}
#endif
#ifdef GDIRECTX
	feil her
#endif

	if ( (Depth == 8) && Valid )
	{
		Palette = new ULONG[256];
		if (!Palette) Valid = FALSE;
	}
	if (Parent) Parent->InsertGBitMap(this);
}

GBitMap::GBitMap(ULONG BMWidth, ULONG BMHeight, UWORD BMDepth, class GBuffer *GBuf)
{
	memset((void *)this, 0, sizeof (this));

	Width = BMWidth;
	Height = BMHeight;
	Depth = BMDepth;


#ifdef GAMIGA
	if ( AmigaBitMap = AllocBitMap(Width, Height, Depth, BMF_CLEAR | BMF_MINPLANES, NULL) )
	{
		Valid = TRUE;
	}
#endif
#ifdef GDIRECTX
	feil her
#endif

	if (Valid)
	{
		APTR Src = GBuf->LockBuf();
		APTR Dest = LockGBitMap();
		ULONG Size = Width*Height*Depth/8;
		memcpy(Dest, Src, Size);
		UnLockGBitMap();
		GBuf->UnLockBuf();

		if ( Depth == 8 )
		{
			Palette = new ULONG[256];
			if (!Palette) Valid = FALSE;
		}
	}
	if (Parent) Parent->InsertGBitMap(this);
}

GBitMap::GBitMap(class GBuffer *GBuf)
{
	memset((void *)this, 0, sizeof (this));

/*
	ULONG *Buf = (APTR) GBuf->LockBuf();
	if ( Buf[0] == (ULONG) ((ULONG *)&"SIZE"[0]) )
	{
		Width = Buf[1];
		Height = Buf[2];
		Depth = Buf[3];
		Buf+=16;

#ifdef GAMIGA
		if ( AmigaBitMap = AllocBitMap(Width, Height, Depth, BMF_CLEAR | BMF_MINPLANES, NULL) )
		{
			Valid = TRUE;
		}
#endif
#ifdef GDIRECTX
		feil her
#endif

		if ( Buf[0] == (ULONG) ((ULONG *)&"PALE"[0]) )
		{
			Palette = new ULONG[256];
			SetPalette(&Buf[1], 0, 0, 256);
			Buf+=257;	
		}

		if ( Buf[0] == (ULONG) ((ULONG *)&"PALE"[0]) )
		{
			APTR Dest = LockGBitMap();			
			memcpy(Dest, (APTR)Buf, Width*Height*Depth/8);
			UnLockGBitMap();
		}
	}
	GBuf->UnLockBuf();
*/

	if (Parent) Parent->InsertGBitMap(this);
}


GBitMap::~GBitMap()
{
	if (Parent)
	{
#ifdef GAMIGA
		if (AmigaBitMap)
		{
			FreeBitMap(AmigaBitMap);
		}
#endif
		if (Palette) delete Palette;
		Parent->RemoveGBitMap(this);
	}
}

void PasteGBuffer(class GBuffer *GBuffer, ULONG SX, ULONG SY, UWORD SBPP, ULONG SBytesPerRow, ULONG DX, ULONG DY, ULONG Wid, ULONG Hei, ULONG *Pal)
{
	// unused atm
}

#define PTGB_SIZE 1	// stores Width, Height(HE), Depth(DE) 16 bytes (SIZE)
#define PTGB_PAL 2	// stores the Palette 256*4 bytes (PALE)

class GBuffer *PasteToGBuffer(ULONG Flags)
{
/*
	ULONG Size = NULL;
	BOOL SIZE= FALSE;
	BOOL PAL = FALSE;
	if (Flags & PTGB_SIZE)
	{	
		SIZE = TRUE;
		Size += 16;
	}
	if (Flags & PTGB_PAL)
	{
		PAL = TRUE;
		Size += 1028;
	}
	Size+= Width*Height*Depth/8+4;

	class GBuffer *DestBuf = new GBuffer(Size, FileName)

	ULONG *Buf = (ULONG *)DestBuf->LockBuf();
	if (SIZE)
	{
		Buf[0] = ((ULONG *)&"SIZE"[0]);
		Buf[1] = Width;
		Buf[2] = Height;
		Buf[3] = (ULONG) Depth;
		Buf+=4;
	}
	if (PAL && Palette)
	{
		Buf[0] = ((ULONG *)&"PALE"[0]);
		Buf+=1;
		ULONG c;
		for (c=0; c<256; c++)
		{
			Buf[i] = Palette[i];
		}
		Buf+=256;
	}

	APTR Src = LockGBitMap();
	if (Src)
	{
		Buf[0] = ((ULONG *)&"BMAP"[0]);
		Buf+=1;
		memcpy((APTR)Buf, Src, Width*Height*Depth/8 );
	}
	else
	{
		UnLockGBitMap();
		GBuf->UnLockBuf();
		delete DestBuf;
		return FALSE;
	}

	UnLockGBitMap();
	DestBuf->UnLockBuf();
	return DestBuf;
*/
	return NULL;
}
	
class GBitMap *GBitMap::ScaleBitMap(ULONG OffsetX, ULONG OffsetY, ULONG SrcWidth, ULONG SrcHeight, ULONG NewWidth, ULONG NewHeight)
{
#ifdef GAMIGA
	if (Parent)
	{
		LastScaledGBitMap = new GBitMap(NewWidth, NewHeight, Depth);
		if (LastScaledGBitMap)
		{
			Parent->BitScaleArgs.bsa_SrcX = OffsetX;
			Parent->BitScaleArgs.bsa_SrcY = OffsetY;

			Parent->BitScaleArgs.bsa_SrcWidth = SrcWidth;
			Parent->BitScaleArgs.bsa_SrcHeight = SrcHeight;

			Parent->BitScaleArgs.bsa_XSrcFactor = SrcWidth;
			Parent->BitScaleArgs.bsa_YSrcFactor = SrcHeight;

			Parent->BitScaleArgs.bsa_DestX = 0;
			Parent->BitScaleArgs.bsa_DestY = 0;

			Parent->BitScaleArgs.bsa_DestWidth = NewWidth;
			Parent->BitScaleArgs.bsa_DestHeight = NewHeight;

			Parent->BitScaleArgs.bsa_XDestFactor = NewWidth;
			Parent->BitScaleArgs.bsa_YDestFactor = NewHeight;

			Parent->BitScaleArgs.bsa_SrcBitMap = AmigaBitMap;
			Parent->BitScaleArgs.bsa_DestBitMap = LastScaledGBitMap->AmigaBitMap;

			Parent->BitScaleArgs.bsa_Flags = NULL;

			BitMapScale(&Parent->BitScaleArgs);

			return LastScaledGBitMap;
		}
		else
		{
			#ifdef GDEBUG
			printf("Attempt to open a GBitMap-object failed!\n");
			#endif
			return NULL;
		}
	}
	else
	{
	#ifdef GDEBUG
	printf("BitMapScale needs GSystem\n");
	#endif
	return NULL;
	}
#endif
}

APTR GBitMap::LockGBitMap()
{
#ifdef GAMIGA
	ULONG DDWidth = NULL;
	ULONG DDHeight = NULL;

	struct TagItem LBMTags[] =
	{
		LBMI_WIDTH, (ULONG)&DDWidth,
		LBMI_HEIGHT, (ULONG)&DDHeight,
		LBMI_PIXFMT, (ULONG)&DDPxlFmt,
		LBMI_BYTESPERPIX, (ULONG)&DDBytesPix,
		LBMI_BYTESPERROW, (ULONG)&DDBytesRow,
		LBMI_BASEADDRESS, (ULONG)&DDBuffer,
		TAG_DONE,
	};

	if (CyberGfxBase)
	{
		if ( GetCyberMapAttr(AmigaBitMap, CYBRMATTR_ISCYBERGFX ) )
		{
			Handle = LockBitMapTagList((APTR) AmigaBitMap, LBMTags);
			if (Handle) return DDBuffer;
		}
	}
	return NULL;
#endif
}

void GBitMap::UnLockGBitMap()
{
#ifdef GAMIGA
	if (Handle)
	{
		UnLockBitMap(Handle);
		Handle = NULL;
	}
#endif
}

/*
*  SetTrueColorPalette()
*  Sets the palette to a 323 TrueColor palette, which is a bad-quality truecolor table
*/

void GBitMap::SetTrueColorPalette()
{
	ULONG color;
	for (color=0; color<256; color++)
	{
		Palette[color] = ((color&0x1f)<<11) | ((color&0xe7)<<5) | (color&0x7);
	}
}

void GBitMap::SetPalette(ULONG *Pal, ULONG FirstSCol, ULONG FirstDCol, ULONG Colors)
{
	if (Palette)
	{

//	if ((FirstCol+Colors) < 256)
//	{
		ULONG color;
		ULONG *PalD = (ULONG *) &Palette[FirstDCol];
		ULONG *PalS = (ULONG *) &Pal[FirstSCol];
		for (color=0; color<Colors; color++)
		{
			PalD[color] = PalS[color];
		}
	}
	else printf("No Palette!\n");
}



#endif /* ifndef GBITMAP_CPP */
