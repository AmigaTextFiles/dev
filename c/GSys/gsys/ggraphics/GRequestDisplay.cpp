
#ifndef GREQUESTDISPLAY_CPP
#define GREQUESTDISPLAY_CPP

#include "ggraphics/GRequestDisplay.h"
#include "gsystem/GObject.cpp"

GRequestDisplay::GRequestDisplay(GTagItem *TagList)
{
		/* Default settigns */
		DesWidth = 640;
		DesHeight = 480;
		DesDepth = 24;

		MinWidth = 320;
		MinHeight = 200;
		MinDepth = 16;

		MaxWidth = 1280;
		MaxHeight = 1024;
		MaxDepth = 24;

		Depth = 0;
		Height = 0;
		Width = 0;

		NextGRequestDisplay = NULL;

#ifdef GAMIGA
		ScrModeRequester = NULL;
#endif

		while (TagList->TagItem)
		{
			switch (TagList->TagItem)
			{
				case RD_DESWIDTH:
					DesWidth = TagList->TagData;
				break;
				case RD_DESHEIGHT:
					DesHeight = TagList->TagData;
				break;
				case RD_DESDEPTH:
					DesDepth = TagList->TagData;
				break;	

				case RD_MINWIDTH:
					MinWidth = TagList->TagData;
				break;
				case RD_MINHEIGHT:
					MinHeight = TagList->TagData;
				break;
				case RD_MINDEPTH:
					MinDepth = TagList->TagData;
				break;

				case RD_MAXWIDTH:
					MaxWidth = TagList->TagData;
				break;
				case RD_MAXHEIGHT:
					MaxHeight = TagList->TagData;
				break;
				case RD_MAXDEPTH:
					MaxDepth = TagList->TagData;
				break;
			}
			TagList++;
		}
#ifdef GAMIGA

		if (ScrModeRequester = (struct ScreenModeRequester *)AllocAslRequestTags(ASL_ScreenModeRequest,
			ASLSM_Window, NULL,
			ASLSM_PubScreenName, NULL,
			ASLSM_Screen, NULL,
			ASLSM_PrivateIDCMP, FALSE,
			ASLSM_TitleText, (ULONG) ((char *) "Please Select ScreenMode"),
			ASLSM_InitialWidth, 256,
			ASLSM_InitialHeight, 200,
			ASLSM_InitialDisplayWidth, DesWidth,
			ASLSM_InitialDisplayHeight, DesHeight,
			ASLSM_InitialDisplayDepth, DesDepth,
			ASLSM_DoWidth, TRUE,
			ASLSM_DoHeight, TRUE,
			ASLSM_DoDepth, TRUE,
			ASLSM_MinWidth, MinWidth,
			ASLSM_MinHeight, MinHeight,
			ASLSM_MinDepth, MinDepth,
			ASLSM_MaxWidth, MaxWidth,
			ASLSM_MaxHeight, MaxHeight,
			ASLSM_MaxDepth, MaxDepth,
			TAG_DONE))
		{
			if (AslRequest((APTR)ScrModeRequester, NULL))
			{

				Width = ScrModeRequester->sm_DisplayWidth;
				Height = ScrModeRequester->sm_DisplayHeight;
				Depth = ScrModeRequester->sm_DisplayDepth;
				Status = TRUE;
			}
			else
			{
				Status = FALSE;
				Width = 0;
				Height = 0;
				Depth = 0;
			}
		}
		else Status = FALSE;
#endif

#ifdef GDIRECTX
#endif

}

GRequestDisplay::~GRequestDisplay()
{
#ifdef GAMIGA
	if (ScrModeRequester) FreeAslRequest((APTR)ScrModeRequester);
#endif
#ifdef GDIRECTX
#endif
}


BOOL GRequestDisplay::RequestNewDisplayMode(GTagItem *TagList)
{
	/* Default settigns */
	DesWidth = 640;
	DesHeight = 480;
	DesDepth = 24;

	MinWidth = 320;
	MinHeight = 200;
	MinDepth = 16;

	MaxWidth = 1280;
	MaxHeight = 1024;
	MaxDepth = 24;

	while (TagList->TagItem)
	{
		switch (TagList->TagItem)
		{
			case RD_DESWIDTH:
				DesWidth = TagList->TagData;
			break;
			case RD_DESHEIGHT:
				DesHeight = TagList->TagData;
			break;
			case RD_DESDEPTH:
				DesDepth = TagList->TagData;
			break;

			case RD_MINWIDTH:
				MinWidth = TagList->TagData;
			break;
			case RD_MINHEIGHT:
				MinHeight = TagList->TagData;
			break;
			case RD_MINDEPTH:
				MinDepth = TagList->TagData;
			break;

			case RD_MAXWIDTH:
				MaxWidth = TagList->TagData;
			break;
			case RD_MAXHEIGHT:
				MaxHeight = TagList->TagData;
			break;
			case RD_MAXDEPTH:
				MaxDepth = TagList->TagData;
			break;
		}
		TagList++;
	}

#ifdef GAMIGA

	if (AslRequestTags((APTR)ScrModeRequester,
		ASLSM_InitialDisplayWidth, DesWidth,
		ASLSM_InitialDisplayHeight, DesHeight,
		ASLSM_InitialDisplayDepth, DesDepth,
		ASLSM_MinWidth, MinWidth,
		ASLSM_MinHeight, MinHeight,
		ASLSM_MinDepth, MinDepth,
		ASLSM_MaxWidth, MaxWidth,
		ASLSM_MaxHeight, MaxHeight,
		ASLSM_MaxDepth, MaxDepth,
		TAG_DONE))
	{

		Width = ScrModeRequester->sm_DisplayWidth;
		Height = ScrModeRequester->sm_DisplayHeight;
		Depth = ScrModeRequester->sm_DisplayDepth;
		return TRUE;
	}
	else return FALSE;
#endif

#ifdef GDIRECTX
#endif

}

#endif /* GREQUESTDISPLAY_CPP */

