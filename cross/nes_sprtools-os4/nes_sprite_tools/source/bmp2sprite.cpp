/*
NES Sprite Tools.
Public domain source code.
by Bob Rost
*/

#include <stdio.h>
#include "BMPImage.h"

#define fail(s) {printf(s);return 0;}
#define failarg(s,a) {printf(s,a); return 0;}

int main(int argn, char **argv)
{
	//check we have a valid bitmap
	if (argn!=3) failarg("  Usage: %s [input.bmp] [output.bmp]\n", argv[0]);
	BMPImage bmp(argv[1]);
	if (!bmp.IsValid()) failarg("  Could not load image '%s'\n", argv[1]);
	
	//make sure it's a multiple of 8x16
	if (bmp.GetWidth()%8!=0 || bmp.GetHeight()%16!=0)
		fail("  Image must be a multiple of 8x16 pixels\n");

	
	//create output bitmap
	int wtiles = bmp.GetWidth() / 8;
	int htiles = bmp.GetHeight() / 8;
	BMPImage bmp2;
	bmp2.Resize(wtiles*htiles*8, 8);

	//copy image data
	int tilenum = 0;
	for (int xtile = 0; xtile < wtiles; xtile++)
	for (int ytile = 0; ytile < htiles; ytile++)
	{
		for (int y=0;y<8;y++)
		for (int x=0;x<8;x++)
		{
			Color c = bmp.GetColor(xtile*8 + x, ytile*8 + y);
			bmp2.SetColor(tilenum*8 + x, y, c);
		}
		tilenum++;
	}

	//write output file
	if (!bmp2.Write(argv[2]))
		printf("Could not write file '%s'\n", argv[2]);
	else
		printf("Wrote '%s' (%ix%i)\n", argv[2], bmp2.GetWidth(), bmp2.GetHeight());
	return 0;
}
