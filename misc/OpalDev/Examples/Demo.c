/* A simple test/demo for the opal.library.
 * Written by Martin Boyd, Opalvision Australia.
 */


#include "opal/opallib.h"
#include "stdlib.h"
#include "stdio.h"
#include "clib/macros.h"

#ifndef	AZTEC_C
#include <proto/all.h>
#endif

struct OpalBase *OpalBase;
struct OpalScreen *OScrn;

char FileName1[30];
char FileName2[30];

void Stencil_Square (int x,int y,int w,int h);

void main (int argc,char *argv[])
{
   register int x,y;
   register long i,j,k;
   int XSquares,YSquares;
   long Err,PixelsLeft,SquaresLeft;


	OpalBase = (struct OpalBase *) OpenLibrary ("opal.library",0L);
	if (OpalBase==0L)
		{ printf ("Can't open opal.library\n");
		  exit (0);
		}

	printf ("For this demo I will need 2 lo-res, non-interlaced  images..\n");
	printf ("FileName of Image1:");
	fflush (stdout);
	scanf ("%s", FileName1);
	printf ("FileName of Image2:");
	fflush (stdout);
	scanf ("%s", FileName2);

	Err = LoadIFF24 (NULL,FileName1,FORCE24);
	if (Err < OL_ERR_MAXERR)
		{ printf ("Error loading file!!");
		  CloseLibrary ((struct Library *)OpalBase);
		  exit (10);
		}

/* Start with frame 1 and put second image in frame 0. This enables
 * the playfield stencil (which is in frame 0) to be changed
 * later on
 */

	OScrn = (struct OpalScreen *)Err;
	WriteFrame24 (1);
	DisplayFrame24 (1);
	RegWait24 ();
	PaletteMap24 (TRUE);
	RegWait24 ();
	OScrn->PixelReadMask = 0;	/* Clear Pixel Read Mask so that */
	UpdateRegs24();			/* update will not be visible. */
	RegWait24();
	Refresh24();			/* Write image into frame buffer */
	AutoSync24 (TRUE);
	OScrn->PixelReadMask = 0xff;	/* Reset pixel read mask 	*/
	FadeIn24 (200L);		/* Fade 'er in			*/

	for (i=0; i<OScrn->Modulo; i++)		/* do a bit of scrolling	*/
		Scroll24 (1L,0L);
	for (i=0; i<OScrn->Modulo; i++)
		Scroll24 (-1L,0L);

	Delay (25L);

	j = MIN (OScrn->Height,OScrn->LastCoProIns);
	for (; j>0; j--)
		{ OScrn->AddressReg = OScrn->Modulo*j + 3;
		  for (i=0; i<j; i++)
			OScrn->CoProData[i] &= ~ADDLOAD;
		  for (i=j; i<OScrn->LastCoProIns; i++)
			OScrn->CoProData[i] |= ADDLOAD;
		  RegWait24();
		  UpdateCoPro24 ();
		}
	Delay (25L);

	for (j=1; j<OScrn->LastCoProIns; j++)
		{ OScrn->AddressReg = OScrn->Modulo*j + 3;
		  for (i=0; i<OScrn->LastCoProIns; i++)
			OScrn->CoProData[i] |= ADDLOAD;
		  for (i=j; i<OScrn->LastCoProIns; i=i+j)
			OScrn->CoProData[i] &= ~ADDLOAD;
		  RegWait24();
		  UpdateCoPro24 ();
		}
	OScrn->AddressReg = 0;
	SetLoadAddress24();
	RegWait24 ();

/* Now load the second image into frame 0.
 */

	WriteFrame24 (0);
	DisplayFrame24 (0);
	Err = LoadIFF24 (OScrn,FileName2,FORCE24);
	if (Err < OL_ERR_MAXERR)
		{ printf ("Error loading file!!");
		  CloseScreen24 ();
		  CloseLibrary ((struct Library *)OpalBase);
		  exit (10);
		}
	Refresh24();
	Delay (50L);
	ClearPFStencil24 (OScrn);
	UpdatePFStencil24 ();
	UpdateDelay24 (0L);
	Delay (1L);
	DualPlayField24 ();

	OScrn->Pen_R = 1;

	XSquares = (OScrn->Width+15)/16;
	YSquares = (OScrn->Height+15)/16;
	srand (12345678L);
	SquaresLeft = XSquares*YSquares;
	while (SquaresLeft)
		{ x = ((float)rand () * XSquares)/RAND_MAX;
		  y = ((float)rand () * YSquares)/RAND_MAX;
		  x = x * 16;
		  y = y * 16;
		  if (!ReadPFPixel24 (OScrn,x,y))
			{ SquaresLeft--;
			  Stencil_Square (x,y,16,16);
			}
		}

	OScrn->Pen_R = 0;
	PixelsLeft = (long)OScrn->Width * OScrn->Height;
	for (j=0; j<10; j++)
		for (i=0; i<30000; i++)
			{ x = ((float)rand () * OScrn->Width)/RAND_MAX;
			  y = ((float)rand () * OScrn->Height)/RAND_MAX;
			  if (ReadPFPixel24 (OScrn,x,y))
				{ PixelsLeft--;
				  WritePFPixel24 (OScrn,x,y);
				}
			}

	OScrn->Pen_R = 1;
	for (k=0; k<YSquares/2; k++)
		{ for (i=0; i<XSquares; i++)
			{ Stencil_Square ((int)i*16,(int)k*32,16,16);
			  Delay(1L);
			}
		  for (i=XSquares-1; i>=0; i--)
			{ Stencil_Square ((int)i*16,((int)k*32)+16,16,16);
			  Delay(1L);
			}
		}

	FadeOut24 (200L);
	CloseScreen24 ();
	CloseLibrary ((struct Library *)OpalBase);
}

void Stencil_Square (int x,int y,int w,int h)
{
   register int i,j;

	w = w + x;
	h = h + y;
	for (j=y; j<h; j++)
		for (i=x; i<w; i++)
			WritePFPixel24 (OScrn,i,j);
}




