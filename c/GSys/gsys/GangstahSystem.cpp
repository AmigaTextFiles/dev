
#define GAMIGA
#ifdef __PPC__
#define GAMIGA_PPC	// må være i tillegg til GAMIGA
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#ifdef __GNUC__

#else

#endif

#include "gsystem/GFile.cpp"
#include "ggraphics/GScreen.cpp"

void main(int argc,char *argv[])
{
	GScreen *myscr = new GScreen(320, 200, 24);
	GFile *file = new GFile("etc:fun/donut24.dat");

	if ( file && file->IsErrorFree() )
	{
		myscr->AttachOwnPixelArray();
		ULONG *bmap = myscr->GetOwnPixelArray();

		ULONG bmap2[256*256*2];
		file->FileRead((void *)&bmap2, 256*256*4);

		for (int y = 0; y < 256; y++)
		{
			for (int x = 0; x < 256; x++)
			{
				bmap[(y*320)+x] = bmap2[(y*256)+x];
			}
		}

		myscr->LoadPixelArray();

		while ( SMSG_LMD != myscr->CheckScreenMsgs() )
		{
		}
	}
	delete file;
	delete myscr;

} // end of program
