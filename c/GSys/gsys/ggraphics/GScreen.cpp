
/* Author Anders Kjeldsen */

#ifndef GSCREEN_CPP
#define GSCREEN_CPP

#include "ggraphics/GScreen.h"
#include "gsystem/GObject.cpp"
#include "ggraphics/GRequestDisplay.cpp"

#ifdef GAMIGA

#ifdef GAMIGA_PPC
#ifndef CyberGfxBase
struct Library *CyberGfxBase = NULL;
#endif
#endif

#ifndef IntuitionBase
struct IntuitionBase *IntuitionBase = NULL;
#endif

#ifndef AslBase
struct Library *AslBase = NULL;
#endif

#ifndef GfxBase
struct GfxBase *GfxBase = NULL;
#endif

//#ifndef DOSBase
//struct DosLibrary *DOSBase = NULL;
//#endif

#ifndef GadToolsBase
struct Library *GadToolsBase = NULL;
#endif


ULONG GfxLibs = 0;
BOOL InitGfx()
{
//	if ( GfxLibs == 0 )
//	{
		if (!CyberGfxBase) CyberGfxBase = (struct Library *)OpenLibrary((unsigned char *)"cybergraphics.library", NULL);
		if (CyberGfxBase)
		{
			if (!IntuitionBase) IntuitionBase = (struct IntuitionBase *)OpenLibrary((unsigned char *)"intuition.library", NULL);
			if (IntuitionBase)
			{
				if (!AslBase) AslBase = OpenLibrary((unsigned char *)"asl.library", NULL);
				if (AslBase)
				{
					if (!GfxBase) GfxBase = (struct GfxBase *)OpenLibrary((unsigned char *)"graphics.library",NULL);
					if (GfxBase)
					{
						if (DOSBase)
						{
							if (!GadToolsBase) GadToolsBase = (struct Library *)OpenLibrary((unsigned char *)"gadtools.library",NULL);
							if (GadToolsBase)
							{
								GfxLibs++;
								return TRUE;
							}
						}
					}
				}
			}
		}
//	}
	return FALSE;
}

BOOL DeInitGfx()
{
//	if ( GfxLibs == 1 )
//	{
		if (CyberGfxBase)
		{
			CloseLibrary(CyberGfxBase);
			CyberGfxBase = NULL;
		}
		if (IntuitionBase)
		{
			CloseLibrary((struct Library *)IntuitionBase);
			IntuitionBase = NULL;
		}
		if (AslBase)
		{
			CloseLibrary((struct Library *)AslBase);
			AslBase = NULL;
		}
		if (GfxBase)
		{
			CloseLibrary((struct Library *)GfxBase);	
			GfxBase = NULL;
		}
		if (DOSBase)
		{
//			FreeDosObject( DOS_FIB, (void *) FileInfoBlock);
		}
		if (GadToolsBase)
		{
			CloseLibrary(GadToolsBase);
			GadToolsBase = NULL;
		}
//	}
//	GfxLibs--;
	return TRUE;
}

GScreen::GScreen(class GRequestDisplay *GRequestDisplay)
{
	memset((void *)this, 0, sizeof (GScreen));

	Own24BitPixelArray = NULL;
//	BackupGBitMap = NULL;
	AmigaScreen = NULL;
	AmigaWindow = NULL;
	AmigaVisualInfo = NULL;	

	DDBytesPix = NULL;
	DDBytesRow = NULL;
	DDPxlFmt = NULL;
	DDBuffer = NULL;

	InitGfx();

	if (GRequestDisplay)
	{
		if (GRequestDisplay->Status)
		{
			printf(" OK!\n");
			if (GRequestDisplay->Depth >= 8)
			{
				if (AmigaScreen = OpenScreenTags(
					NULL,
					SA_Left, 0,
					SA_Top, 0,
					SA_Width, GRequestDisplay->Width,
					SA_Height, GRequestDisplay->Height,
					SA_Depth, GRequestDisplay->Depth,
					SA_DetailPen, 1,
					SA_BlockPen, 2,
					SA_Title, NULL,
					SA_ShowTitle, FALSE,
					SA_Draggable, FALSE,
					SA_Quiet, TRUE,
					SA_DisplayID, GRequestDisplay->ScrModeRequester->sm_DisplayID,
					SA_Type, CUSTOMSCREEN,
					TAG_DONE))
				{
					ScrWidth = AmigaScreen->Width;
					ScrHeight = AmigaScreen->Height;
					ScrDepth = GRequestDisplay->Depth;

					if (AmigaWindow = OpenWindowTags(NULL,
						WA_Left, 0,
						WA_Top, 0,
						WA_Width, ScrWidth,
						WA_Height, ScrHeight,
						WA_DetailPen, 1,
						WA_BlockPen, 2,
						WA_IDCMP, MENUPICK | MOUSEBUTTONS | REFRESHWINDOW | MOUSEMOVE | INTUITICKS,
						WA_Flags, WFLG_BACKDROP | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_BORDERLESS,
						WA_Gadgets, NULL,
						WA_Title, NULL,
						WA_MinWidth, ScrWidth,
						WA_MaxWidth, ScrWidth,
						WA_MinHeight, ScrHeight,
						WA_MaxHeight, ScrHeight,
						WA_Checkmark, NULL,
						WA_ScreenTitle, NULL,
						WA_SuperBitMap, NULL,
						WA_CustomScreen, (ULONG) AmigaScreen,
						TAG_DONE))
					{
						if ( AmigaVisualInfo = GetVisualInfo(AmigaScreen, TAG_DONE) )
						{
//							BackupGBitMap = new GBitMap(ScrWidth, ScrHeight, ScrDepth);
							
//							if (BackupGBitMap->Valid)
//							{
								AmigaScreenBuffer[0] = AllocScreenBuffer(AmigaScreen, NULL, SB_SCREEN_BITMAP);
								AmigaScreenBuffer[1] = AllocScreenBuffer(AmigaScreen, NULL, NULL); //SB_COPY_BITMAP

								DispPort=CreateMsgPort();
								WritePort=CreateMsgPort();

								if ( (DispPort && WritePort) && (AmigaScreenBuffer[0] && AmigaScreenBuffer[1]) )
								{
									if (WaitWrite)
									{
										AmigaScreenBuffer[0]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=WritePort;
										AmigaScreenBuffer[1]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=WritePort;
									}
									else
									{
										AmigaScreenBuffer[0]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=NULL;
										AmigaScreenBuffer[1]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=NULL;
									}

									SafeToWrite=TRUE;

									if (WaitWrite)
									{
										AmigaScreenBuffer[0]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=DispPort;
										AmigaScreenBuffer[1]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=DispPort;
									}
									else
									{
										AmigaScreenBuffer[0]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=NULL;
										AmigaScreenBuffer[1]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=NULL;
									}

									SafeToSwap=1;
									CurBuffer=1;
//									Valid = TRUE;
								}
								else
								{
									printf("could not allocate dbuffer screenbuffers\n");
								}
//							}
						}
					}				
				}
			}
		}
	}
}

GScreen::GScreen(ULONG Width, ULONG Height, UWORD Depth)
{
	memset((void *)this, 0, sizeof (GScreen));
	
/*
	Own24BitPixelArray = NULL;
	BackupGBitMap = NULL;
	AmigaScreen = NULL;
	AmigaWindow = NULL;
	AmigaVisualInfo = NULL;	
	DDBytesPix = NULL;
	DDBytesRow = NULL;
	DDPxlFmt = NULL;
	DDBuffer = NULL;
*/
	InitGfx();

	if (Depth >= 8)
	{
		if (Width)
		{
			if (Height)
			{
				ULONG ModeID = BestCModeIDTags( CYBRBIDTG_Depth, Depth,
								CYBRBIDTG_NominalWidth, Width,
								CYBRBIDTG_NominalHeight, Height,
								TAG_DONE );

				if (AmigaScreen = OpenScreenTags(
					NULL,
					SA_Left, 0,
					SA_Top, 0,
					SA_Width, Width,
					SA_Height, Height,
					SA_Depth, Depth,
					SA_DetailPen, 1,
					SA_BlockPen, 2,
					SA_Title, NULL,
					SA_ShowTitle, FALSE,
					SA_Draggable, FALSE,
					SA_Quiet, TRUE,
					SA_DisplayID, ModeID,
					SA_Type, CUSTOMSCREEN,
					TAG_DONE))
				{
					ScrWidth = AmigaScreen->Width;
					ScrHeight = AmigaScreen->Height;
					ScrDepth = Depth;

					if (AmigaWindow = OpenWindowTags(NULL,
						WA_Left, 0,
						WA_Top, 0,
						WA_Width, ScrWidth,
						WA_Height, ScrHeight,
						WA_DetailPen, 1,
						WA_BlockPen, 2,
						WA_IDCMP, MENUPICK | MOUSEBUTTONS | REFRESHWINDOW | MOUSEMOVE | INTUITICKS,
						WA_Flags, WFLG_BACKDROP | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_BORDERLESS,
						WA_Gadgets, NULL,
						WA_Title, NULL,
						WA_MinWidth, ScrWidth,
						WA_MaxWidth, ScrWidth,
						WA_MinHeight, ScrHeight,
						WA_MaxHeight, ScrHeight,
						WA_Checkmark, NULL,
						WA_ScreenTitle, NULL,
						WA_SuperBitMap, NULL,
						WA_CustomScreen, (ULONG) AmigaScreen,
						TAG_DONE))
					{
						if ( AmigaVisualInfo = GetVisualInfo(AmigaScreen, TAG_DONE) )
						{
//							BackupGBitMap = new GBitMap(ScrWidth, ScrHeight, ScrDepth);
							
//							if (BackupGBitMap->Valid)
//							{
								if ( AmigaScreenBuffer[0] = AllocScreenBuffer(AmigaScreen, NULL, SB_SCREEN_BITMAP) )
								{
									if ( AmigaScreenBuffer[1] = AllocScreenBuffer(AmigaScreen, NULL, NULL) )
									{

										DispPort=CreateMsgPort();
										WritePort=CreateMsgPort();

										if ( (DispPort && WritePort) )
										{
											if (WaitWrite)
											{
												AmigaScreenBuffer[0]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=WritePort;
												AmigaScreenBuffer[1]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=WritePort;
											}
											else
											{
												AmigaScreenBuffer[0]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=NULL;
												AmigaScreenBuffer[1]->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort=NULL;
											}

											SafeToWrite=TRUE;

											if (WaitWrite)
											{
												AmigaScreenBuffer[0]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=DispPort;
												AmigaScreenBuffer[1]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=DispPort;
											}
											else
											{
												AmigaScreenBuffer[0]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=NULL;
												AmigaScreenBuffer[1]->sb_DBufInfo->dbi_DispMessage.mn_ReplyPort=NULL;
											}
											SafeToSwap=1;
											CurBuffer=1;
//											Valid = TRUE;
										}
										else
										{
											printf("could not allocate dbuffer screenbuffers\n");
										}
									}
								}
//							}
						}
					}				
				}
			}
		}
	}
}

GScreen::~GScreen()
{
		if (AmigaScreen)
		{
			if (Own24BitPixelArray)
			{
				free((APTR)Own24BitPixelArray);	
			}

			if (AmigaScreenBuffer[0])
			{
//				if ( ChangeScreenBuffer(AmigaScreen, AmigaScreenBuffer[0]) )
//				{
//					AmigaScreen->RastPort.BitMap = AmigaScreenBuffer[0]->sb_BitMap;
//				}

				FreeScreenBuffer(AmigaScreen, AmigaScreenBuffer[0]);
			}
			if (AmigaScreenBuffer[1])
			{
				FreeScreenBuffer(AmigaScreen, AmigaScreenBuffer[1]);
			}

			if (AmigaWindow)
			{
				CloseWindow(AmigaWindow);
				AmigaWindow = NULL;
			}
			if (AmigaVisualInfo)
			{
				FreeVisualInfo(AmigaVisualInfo);
				AmigaVisualInfo = NULL;
			}

			CloseScreen(AmigaScreen);
			AmigaScreen = NULL;

//			if (BackupGBitMap)
//			{
//				printf("delete BackupGBitMap\n");
//				delete BackupGBitMap;
//				printf("BackupGBitMapOK\n");
//			}
		}
	DeInitGfx();
}

#endif

ULONG GScreen::GetWidth()
{ 
	if ( IsErrorFree() )
	{
#ifdef GAMIGA
		return (ULONG) AmigaScreen->Width;
#endif
	}
	else return NULL;
}

ULONG GScreen::GetHeight()
{
	if ( IsErrorFree() )
	{
#ifdef GAMIGA
		return (ULONG) AmigaScreen->Height;
#endif
	}
	else return NULL;
}

UWORD GScreen::GetDepth()
{
	if ( IsErrorFree() )
	{
#ifdef GAMIGA
		return AmigaScreen->RastPort.BitMap->Depth;
#endif
	}
	else return NULL;
}


void GScreen::WaitSafeToWrite()
{
#ifdef GAMIGA
	if (WaitWrite)
	{
		if (!SafeToWrite)
		{
			while ( !GetMsg(WritePort) )
			Wait(1L<<(WritePort->mp_SigBit));
		        SafeToWrite=1;
      		}
	}
#endif
}


void GScreen::SwapScreenBuffers()
{
#ifdef GAMIGA

	SafeToSwap=1;

	if ( ChangeScreenBuffer(AmigaScreen, AmigaScreenBuffer[CurBuffer]) )
	{
		SafeToSwap=0;
		SafeToWrite=0;
		CurBuffer ^= 1;  /* toggle buffer */
//		AmigaScreen->RastPort.BitMap = AmigaScreenBuffer[CurBuffer]->sb_BitMap;
	}
#endif

}

APTR GScreen::LockScreen()
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
		if ( GetCyberMapAttr(AmigaScreenBuffer[CurBuffer]->sb_BitMap, CYBRMATTR_ISCYBERGFX ) )
		{
			Handle = LockBitMapTagList((APTR) AmigaScreenBuffer[CurBuffer]->sb_BitMap, LBMTags);
			if (Handle) return DDBuffer;
		}
	}
	return NULL;
#endif
}

void GScreen::UnLockScreen()
{
#ifdef GAMIGA
	if (Handle)
	{
		UnLockBitMap(Handle);
		Handle = NULL;
		DDBuffer = NULL;
	}
#endif
}

BOOL GScreen::AttachOwnPixelArray()
{
	if ( IsErrorFree() )
	{
		Own24BitPixelArray = new ULONG[GetWidth() * GetHeight()];
		if (Own24BitPixelArray) return TRUE;
	}
	return FALSE;
}

void GScreen::LoadPixelArray()
{
	if ( IsErrorFree() )
	{
//		WaitSafeToWrite();	// should not be here
		if ( Own24BitPixelArray )
		{
#ifdef GAMIGA
		WritePixelArray(Own24BitPixelArray, (UWORD) 0, (UWORD) 0, (UWORD) ScrWidth*4, (struct RastPort *)&AmigaScreen->RastPort, (UWORD) 0, (UWORD) 0, (UWORD) ScrWidth, (UWORD) ScrHeight, (UBYTE) RECTFMT_ARGB);
#endif
//		SwapScreenBuffers();	// should not be here
		}
	}
}

void GScreen::LoadPixelArrayDirect()
{
	WaitSafeToWrite();

	APTR DrwBuf;
	if ( DrwBuf = LockScreen() )
	{
		ULONG *SrcBuf = Own24BitPixelArray;

		if (DDBytesPix == 4)
		{
			ULONG *Pix32 = (ULONG *)DDBuffer;
			int x,y;
			for (y=0; y<ScrHeight; y++)
			{
				for (x=0; x<ScrWidth; x++)
				{
					Pix32[0] = SrcBuf[0];
					Pix32++;
					SrcBuf++;
				}	
			}
		}
	}

	UnLockScreen();
	SwapScreenBuffers();	
}

ULONG *GScreen::GetOwnPixelArray()
{
	if ( IsErrorFree() )
	{
		return Own24BitPixelArray;
	}
	else return NULL;
}


/*
*  SetTrueColorPalette()
*  Sets the palette to a 323 TrueColor palette, which is a bad-quality truecolor table
*/

void GScreen::SetTrueColorPalette()
{
	ULONG color;
	for (color=0; color<256; color++)
	{
#ifdef GAMIGA
		ULONG r, g, b;
		r = (color>>5)<<29;
		g = (color>>3)<<30;
		b = color<<29;
		SetRGB32(&AmigaScreen->ViewPort, color, r, g, b);
#endif
	}
}

//LoadRGB4(&ActionScr->ViewPort, (UWORD *)&SetPal_Action, 256);




/*
BOOL GScreen::InsertGImage(class GImage *GImage)
{
	if (GImage)
	{
		if (FirstGImageToDraw)
		{
			class GImage *CurrentGImage = FirstGImageToDraw->NextGImageZ;
			class GImage *PreviousGImage = FirstGImageToDraw;
			while (CurrentGImage->ZPosition < GImage)
			{
				PreviousGImage = CurrentGImage;
				CurrentGImage = CurrentGImage->NextGImageZ;
			}
			GImage->NextGImageZ = CurrentGImage;
			PreviousGImage->NextGImageZ = GImage;
			return TRUE;
		}
		else
		{
			FirstGImageToDraw = GImage;
			GImage->NextGImageZ = NULL;
			return TRUE;
		}
	}
}
*/

void GScreen::PutPixel(ULONG X, ULONG Y, ULONG RGB)
{
#ifdef GAMIGA
	if (AmigaScreen)
	{
	//	SetAPen(&AmigaScreen->RastPort, (UBYTE) RGB);
	//	WritePixel(&AmigaScreen->RastPort, X, Y);
	//	printf("WriteRGBPixel(&AmigaScreen->RastPort, X, Y, RGB)\n");
		if (Handle && DDBuffer)
		{
			if (DDBytesPix == 4)
			{
				ULONG *Pixels = (ULONG *)DDBuffer;
				Pixels[ X + (Y * ScrWidth) ] = RGB;
			}
			else if (DDBytesPix == 2)
			{
				UWORD *Pixels = (UWORD *)DDBuffer;
				Pixels[ X + (Y * ScrWidth) ] = G24to16(RGB);
			}
			else if (DDBytesPix == 1)
			{
				UBYTE *Pixels = (UBYTE *)DDBuffer;
				Pixels[ X + (Y * ScrWidth) ] = G24to8(RGB);
			}
		}
		else if (CyberGfxBase) WriteRGBPixel(&AmigaScreen->RastPort, X, Y, RGB);

	}
#endif
}

/*
void GScreen::DrawLine(class GVertex *P1, class GVertex *P2, UBYTE Pen)
{

#ifdef GAMIGA
	SetAPen(&AmigaScreen->RastPort, Pen);
	Move(&AmigaScreen->RastPort, (WORD) P1->Z + ScrWidth/2, (WORD) P1->Y + ScrHeight/2);
	Draw(&AmigaScreen->RastPort, (WORD) P2->Z + ScrWidth/2, (WORD) P2->Y + ScrHeight/2);
#endif
}

*/

void GScreen::DrawLine(int x1, int y1, int x2, int y2, UBYTE Pen)
{
	SetAPen(&AmigaScreen->RastPort, Pen);
	Move(&AmigaScreen->RastPort, x1, y1);
	Draw(&AmigaScreen->RastPort, x2, y2);
}




#define	SMSG_LMU	0x00011000	/* Screen Message: Left Mouse Button released */
#define	SMSG_LMD	0x00012000	/* Screen Message: Left Mouse Button pressed */
#define	SMSG_RMU	0x00021000	/* Screen Message: Right Mouse Button released */
#define	SMSG_RMD	0x00022000	/* Screen Message: Right Mouse Button pressed */

ULONG GScreen::CheckScreenMsgs()
{
	ULONG RETURN = NULL;
	if ((AmigaWinMsg = (struct IntuiMessage *) (GT_GetIMsg(AmigaWindow->UserPort))))
	{
	ULONG imsgCode = AmigaWinMsg->Code;
	ULONG imsgClass = AmigaWinMsg->Class;

	switch(imsgClass)
		{
			case IDCMP_MOUSEBUTTONS:

			switch (imsgCode)
			{
				case SELECTDOWN:
					RETURN = SMSG_LMD;
				break;

				case SELECTUP:
					RETURN = SMSG_LMU;
				break;

				case MENUDOWN:
					RETURN = SMSG_RMD;
				break;

				case MENUUP:
					RETURN = SMSG_RMU;
				break;
			}
			break;

		}
		GT_ReplyIMsg(AmigaWinMsg);
	}
	return RETURN;
}

/* GetMouseX() & GetMouseY() returns the mousepointer-coordinates on the screen */

WORD GScreen::GetMouseX()
{
#ifdef GAMIGA
	return AmigaScreen->MouseX;
#endif

}

WORD GScreen::GetMouseY()
{
#ifdef GAMIGA
	return AmigaScreen->MouseY;
#endif

}




#endif /* ifndef GSCREENMET */