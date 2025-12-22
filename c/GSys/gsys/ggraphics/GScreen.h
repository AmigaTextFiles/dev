

#ifndef GSCREEN_H
#define GSCREEN_H

#ifdef GAMIGA

#include <exec/types.h>
#include <exec/memory.h>
#include <cybergraphics/cybergraphics.h>

/*
#ifdef GAMIGA_PPC
#include <powerup/ppcproto/exec.h>
#include <powerup/ppcproto/dos.h>
#include <powerup/ppcproto/graphics.h>
#include <powerup/ppcproto/intuition.h>
#include <powerup/ppcproto/gadtools.h>
#include <powerup/ppcproto/asl.h>
#include <powerup/ppcproto/cybergraphics.h>
#else
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/asl.h>
#include <proto/cybergraphics.h>
#endif
*/
#endif

__inline UWORD G24to16(ULONG x)
{
	return  ( ((x>>19)&0x1f)<<11 ) | ( ((x>>10)&0x3f)<<5 ) | (x>>3)&0x1f;
}
__inline UBYTE G24to8(ULONG x)	// 323
{
	return  ( ((x>>21)&0x7)<<5 ) | ( ((x>>14)&0x3)<<3 ) | (x>>5)&0x7;
}
__inline UWORD G8to16(UBYTE x)
{
	return ( ((x>>5)<<11) | ( ((x>>3)&0x3)<<5) | x&0x7 );
}

class GScreen : public GObject
{
public:
	GScreen(class GRequestDisplay *GRequestDisplay);
	GScreen(ULONG Width, ULONG Height, UWORD Depth);	/* åpner en skjerm med en BESTEMT størrelse */
	~GScreen();

// Get (and Set)
//	BOOL IsValid() { return Valid; };
	ULONG GetWidth();
	ULONG GetHeight();
	UWORD GetDepth();

// Methods for screen-updating and doublebuffering
	void WaitSafeToWrite();
	void SwapScreenBuffers();

// Methods for palettes in 8Bit-modes
	void SetTrueColorPalette();

// Methods for using own PixelArrays and/or directdraw
	BOOL AttachOwnPixelArray();
	void LoadPixelArray();
	void LoadPixelArrayDirect();
//	void FreeFixedBackup() {};
	ULONG *GetOwnPixelArray();	// { return Own24BitPixelArray; };

// Methods for direct draw
	APTR LockScreen();		// for direct draw
	void UnLockScreen();		// used after drawing
	ULONG GetDDBytesPix() { return DDBytesPix; };
	ULONG GetDDBytesRow() { return DDBytesRow; };
	ULONG GetDDPxlFmt() { return DDPxlFmt; };
	APTR GetDDBuffer() { return DDBuffer; };

// Silly Methots
//	void PutPixel(ULONG X, ULONG Y, UBYTE Pen);
	void PutPixel(ULONG X, ULONG Y, ULONG RGB);
	void DrawLine(class GVertex *P1, class GVertex *P2, UBYTE Pen);
//	void DrawLine(x1, y1, x2, y2, UBYTE Pen);
	void DrawLine(int x1, int y1, int x2, int y2, UBYTE Pen);

	struct Screen *GetAmyScreen() { return AmigaScreen; };
	void *GetAmyVI() { return AmigaVisualInfo; };

// Misc Methods
	ULONG CheckScreenMsgs();

	WORD GetMouseX();
	WORD GetMouseY();


// Objects, Variables etc.
	ULONG	ScrWidth;
	ULONG	ScrHeight;
	UWORD	ScrDepth;

	ULONG	*Own24BitPixelArray;	/* 24(32)bit: 00RRGGBB */

	ULONG	DDBytesPix;
	ULONG	DDBytesRow;
	ULONG	DDPxlFmt;
	APTR	DDBuffer;
private:

#ifdef GAMIGA
	struct Screen *AmigaScreen;
	struct Window *AmigaWindow;
	struct ScreenBuffer *AmigaScreenBuffer[2];
	struct MsgPort *DispPort, *WritePort;
	APTR AmigaVisualInfo;
	BOOL SafeToSwap, SafeToWrite, WaitSwap, WaitWrite;
	LONG CurBuffer;
	APTR Handle;
	struct IntuiMessage *AmigaWinMsg;
#endif

#ifdef GWINDOWS
	feil her
#endif

};

#endif /* ifndef GSCREEN_H */
