/*
NES Sprite Tools.
Public domain source code.
by Bob Rost
*/

#include <stdio.h>
#include "BMPImage.h"

int GetNesColor(const Color c)
{
	static Color black(0,0,0);
	static Color white(255,255,255);
	static Color red(255,0,0);
	static Color blue(0,0,255);
	if (c==black) return 0;
	if (c==white) return 1;
	if (c==red) return 2;
	if (c==blue) return 3;
	return -1;
}

bool WriteChr(unsigned char *imagemap, const char *filename)
{
	unsigned char c;
	FILE *f=fopen(filename,"w");
	if(f == NULL) return false;
	for(int j = 0; j < 128; j+=8)
	for(int i = 0; i < 128; i+=8)
	{
		//low bit
		for(int y=j; y < j+8; y++)
		{
			c=0;
			for(int x=i; x < i+8; x++)
			{
				c*=2;
				c+=(imagemap[y*128+x]&1);
			}
			putc(c,f);
		}
		//high bit
		for(int y=j; y < j+8; y++)
		{
			c=0;
			for(int x=i; x < i+8; x++)
			{
				c*=2;
				c+=((imagemap[y*128+x]>>1)&1);
			}
			putc(c,f);
		}
	}
	fclose(f);
	return true;
}

bool MakeChr(BMPImage &bmp, const char *filename)
{
	unsigned char *imagemap = new unsigned char[128*128];
	for (int y=0; y < 128; y++)
	for (int x=0; x < 128; x++)
	{
		int c = GetNesColor(bmp.GetColor(x,y));
		if (c < 0)
		{
			printf("Invalid color. Colors must be:\n  black(000000), white(ffffff), red(ff0000), blue(0000ff)");
			return false;
		}
		imagemap[y*128 + x] = c;
	}
	if (!WriteChr(imagemap, filename)) return false;
	return true;
}


#define fail(s) {printf(s);return 0;}
#define failarg(s,a) {printf(s,a); return 0;}
#define failarg2(s,a,b) {printf(s,a,b); return 0;}

int main(int argn, char **argv)
{
	//check we have a valid bitmap
	if (argn!=3) failarg("  Usage: %s [input.bmp] [output.bmp]\n", argv[0]);
	BMPImage bmp(argv[1]);
	if (!bmp.IsValid()) failarg("  Could not load image '%s'\n", argv[1]);
	
	//make sure it's 128x128 pixels
	if (bmp.GetWidth()!=128 || bmp.GetHeight()!=128)
		failarg2("Image size must be 128x128. Input image is %ix%i\n", bmp.GetWidth(),bmp.GetHeight());

	//create pattern table and write chr
	if (!MakeChr(bmp, argv[2]))
		printf("Error creating CHR file\n");
	else printf("CHR created successfully\n");
	return 0;
}
