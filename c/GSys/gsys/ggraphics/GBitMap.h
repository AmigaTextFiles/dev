
#ifndef GBITMAP_H
#define GBITMAP_H

#ifdef GAMIGA
#include <exec/types.h>
#include <cybergraphics/cybergraphics.h>

#ifdef GAMIGA_PPC
#include <powerup/ppcproto/exec.h>
#include <powerup/ppcproto/dos.h>
#include <powerup/ppcproto/graphics.h>
#include <powerup/ppcproto/intuition.h>
#include <powerup/ppcproto/gadtools.h>
#include <powerup/ppcproto/cybergraphics.h>
#else
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/cybergraphics.h>
#endif

#include "gststem/GObject.h"

#endif // GAMIGA

class GBitMap : public Object
{
public:
	GBitMap(ULONG BMWidth, ULONG BMHeight, UWORD BMDepth);
	GBitMap(ULONG BMWidth, ULONG BMHeight, UWORD BMDepth, class GBuffer *GBuf);
	GBitMap(class GBuffer *GBuf); 			// requires that it has been pasted before
	~GBitMap();
	
	BOOL IsValid() { return Valid; };
	ULONG GetWidth() { return Width; };
	ULONG GetHeight() { return Height; };
	UWORD GetDepth() { return Depth; };
	ULONG *GetPalette() { return Palette; };
	ULONG GetColor(ULONG Col) { return Palette[Col]; };
	STRPTR GetFileName() { return &FileName[0]; };
	BOOL IsLoaded() { return Loaded; };
	class GBitMap *GetNextGBitMap() { return NextGBitMap; };
	class GBitMap *GetLastScaledGBitMap() { return LastScaledGBitMap; };

	void UploadBitMap() {};
	void FreeUploadedBitMap() {};
	
// Misc
	void PasteGBuffer(class GBuffer *GBuffer, ULONG SX, ULONG SY, UWORD SBPP, ULONG SBytesPerRow, ULONG DX, ULONG DY, ULONG Wid, ULONG Hei);
	class GBuffer *PasteToGBuffer();

// Methods for GBitmap handling
	class GBitMap *ScaleBitMap(ULONG OffsetX, ULONG OffsetY, ULONG SrcWidth, ULONG SrcHeight, ULONG NewWidth, ULONG NewHeight);

// Methods for palettes in 8Bit-modes
	void SetTrueColorPalette();
	void SetPalette(ULONG *Pal, ULONG FirstSCol, ULONG FirstDCol, ULONG Colors);

// Methods for using Direct Rendering(draw)
	APTR	LockGBitMap();
	void	UnLockGBitMap();

	BOOL 	Valid;
	class	GBitMap *NextGBitMap;
	class	GBitMap *LastScaledGBitMap; /* Avoid using it, as it can point to NOTHING */
	ULONG	Width, Height;
	UWORD	Depth;
	ULONG	*Palette;		/* In case it's a 8bit BitMap */
	char	FileName[256];
	BOOL	Loaded;

	APTR	Handle;		/* DD = Used for Direct Rendering(Draw) */
	ULONG	DDBytesPix;
	ULONG	DDBytesRow;
	ULONG	DDPxlFmt;
	APTR	DDBuffer;

private:

#ifdef GAMIGA
	struct	BitMap *AmigaBitMap;
#endif

};

#endif

