/*
NES Sprite Tools.
Public domain source code.
by Bob Rost
*/

#include <stdio.h>
#include "BMPImage.h"

Color GetNesColor(int c)
{
	static Color black(0,0,0);
	static Color white(255,255,255);
	static Color red(255,0,0);
	static Color blue(0,0,255);
	if (c==0) return black;
	if (c==1) return white;
	if (c==2) return red;
	if (c==3) return blue;
	return black;
}

bool ReadChr(BMPImage &bmp, const char *filename)
{
	//Read raw CHR file
	FILE *fp = fopen(filename,"r");
	if (fp==NULL) return false;
	uchar *chrmap = new uchar[4096];
	if (fread(chrmap, 1, 4096, fp)<4096)
	{
		delete chrmap;
		return false;
	}
	bmp.Resize(128,128);

	//Convert to image map
	for (int sprite = 0; sprite < 256; sprite++)
	for (int row = 0; row < 8; row++)
	{
		//couldn't think of a better var name than potato
		uchar potato1 = chrmap[sprite*16 + row];
		uchar potato2 = chrmap[sprite*16 + row + 8];

		int destx = (sprite % 16) * 8;
		int desty = (sprite / 16) * 8 + row;
		for (int x = 7; x >= 0; x--)
		{
			int chrval = (potato1 & 1) + (potato2 & 1)*2;
			bmp.SetColor(destx+x, desty, GetNesColor(chrval));
			potato1 /= 2;
			potato2 /= 2;
		}
	}
	delete chrmap;
	return true;
}


#define fail(s) {printf(s);return 0;}
#define failarg(s,a) {printf(s,a); return 0;}
#define failarg2(s,a,b) {printf(s,a,b); return 0;}

int main(int argn, char **argv)
{
	//check we have a valid bitmap
	if (argn!=3) failarg("  Usage: %s [input.chr] [output.bmp]\n", argv[0]);
	BMPImage bmp;
	if (!ReadChr(bmp, argv[1])) fail("Error reading CHR file\n");
	if (!bmp.Write(argv[2])) failarg("Error writing image '%s'\n", argv[2]);
	printf("Image '%s' created successfully\n", argv[2]);
	return 0;
}
