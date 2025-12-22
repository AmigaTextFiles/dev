
#ifndef GREQUESTDISPLAY_H
#define GREQUESTDISPLAY_H

#ifdef GAMIGA

#include <exec/types.h>

#ifdef GAMIGA_PPC
#include <powerup/ppcproto/exec.h>
#include <powerup/ppcproto/asl.h>
#else
#include <proto/exec.h>
#include <proto/asl.h>
#endif

#endif

#define	RD_DESWIDTH	0x00000010	/* Most wanted Width, Height & BitsPerPixel */
#define	RD_DESHEIGHT	0x00000011
#define RD_DESDEPTH	0x00000012
#define RD_MINWIDTH	0x00000020	/* Minumum Width, Height & BitsPerPixel */
#define RD_MINHEIGHT	0x00000021
#define RD_MINDEPTH	0x00000022
#define RD_MAXWIDTH	0x00000030	/* Maximum Width, Height & BitsPerPixel */
#define RD_MAXHEIGHT	0x00000031
#define RD_MAXDEPTH	0x00000032

class GRequestDisplay : public GObject
{
public:
	GRequestDisplay(GTagItem *TagList);	//GTagItem *TagList[]);
	~GRequestDisplay();
	
	BOOL RequestNewDisplayMode(GTagItem *TagList);

	class GRequestDisplay *NextGRequestDisplay;
	ULONG Width, Height;	// last selected
	UWORD Depth;
	BOOL Status;	// Was it cancelled(FALSE) or accepted(TRUE) on the last pop-up?
#ifdef GAMIGA
	struct ScreenModeRequester *ScrModeRequester;
#endif
#ifdef GDIRECTX
#endif

private:
	ULONG DesWidth, DesHeight;	// these are also the DEFAULT settings, so be careful!
	UWORD DesDepth;
	ULONG MinWidth, MinHeight;
	UWORD MinDepth;
	ULONG MaxWidth, MaxHeight;
	UWORD MaxDepth;
};

#endif /* GREQUESTDISPLAY_H */