/*
NES Sprite Tools.
Public domain source code.
by Bob Rost
*/

#include <stdio.h>
#include "BMPImage.h"
#include <vector>
#include <math.h>

#define Fail(er) {printf("%s\n",er);return 0;}

// Matthew Conte's NES Palette
unsigned char palette_conte[64][3] =
{
   {0x80,0x80,0x80}, {0x00,0x00,0xBB}, {0x37,0x00,0xBF}, {0x84,0x00,0xA6},
   {0xBB,0x00,0x6A}, {0xB7,0x00,0x1E}, {0xB3,0x00,0x00}, {0x91,0x26,0x00},
   {0x7B,0x2B,0x00}, {0x00,0x3E,0x00}, {0x00,0x48,0x0D}, {0x00,0x3C,0x22},
   {0x00,0x2F,0x66}, {0x00,0x00,0x00}, {0x05,0x05,0x05}, {0x05,0x05,0x05},

   {0xC8,0xC8,0xC8}, {0x00,0x59,0xFF}, {0x44,0x3C,0xFF}, {0xB7,0x33,0xCC},
   {0xFF,0x33,0xAA}, {0xFF,0x37,0x5E}, {0xFF,0x37,0x1A}, {0xD5,0x4B,0x00},
   {0xC4,0x62,0x00}, {0x3C,0x7B,0x00}, {0x1E,0x84,0x15}, {0x00,0x95,0x66},
   {0x00,0x84,0xC4}, {0x11,0x11,0x11}, {0x09,0x09,0x09}, {0x09,0x09,0x09},

   {0xFF,0xFF,0xFF}, {0x00,0x95,0xFF}, {0x6F,0x84,0xFF}, {0xD5,0x6F,0xFF},
   {0xFF,0x77,0xCC}, {0xFF,0x6F,0x99}, {0xFF,0x7B,0x59}, {0xFF,0x91,0x5F},
   {0xFF,0xA2,0x33}, {0xA6,0xBF,0x00}, {0x51,0xD9,0x6A}, {0x4D,0xD5,0xAE},
   {0x00,0xD9,0xFF}, {0x66,0x66,0x66}, {0x0D,0x0D,0x0D}, {0x0D,0x0D,0x0D},

   {0xFF,0xFF,0xFF}, {0x84,0xBF,0xFF}, {0xBB,0xBB,0xFF}, {0xD0,0xBB,0xFF},
   {0xFF,0xBF,0xEA}, {0xFF,0xBF,0xCC}, {0xFF,0xC4,0xB7}, {0xFF,0xCC,0xAE},
   {0xFF,0xD9,0xA2}, {0xCC,0xE1,0x99}, {0xAE,0xEE,0xB7}, {0xAA,0xF7,0xEE},
   {0xB3,0xEE,0xFF}, {0xDD,0xDD,0xDD}, {0x11,0x11,0x11}, {0x11,0x11,0x11}
};


// Loopy's NES Palette
unsigned char palette_loopy[64][3] =
{
{117,117,117},{39,27,143},{0,0,171},{71,0,159},
{143,0,119},{171,0,19},{167,0,0},{127,11,0},
{67,47,0},{0,71,0},{0,81,0},{0,63,23},
{27,63,95},{0,0,0},{0,0,0},{0,0,0},

{188,188,188},{0,115,239},{35,59,239},{131,0,243},
{191,0,191},{231,0,91},{219,43,0},{203,79,15},
{139,115,0},{0,151,0},{0,171,0},{0,147,59},
{0,131,139},{0,0,0},{0,0,0},{0,0,0},

{255,255,255},{63,191,255},{95,151,255},{167,139,253},
{247,123,255},{255,119,183},{255,119,99},{255,155,59},
{243,191,63},{131,211,19},{79,223,75},{88,248,152},
{0,235,219},{0,0,0},{0,0,0},{0,0,0},

{255,255,255},{171,231,255},{199,215,255},{215,203,255},
{255,199,255},{255,199,219},{255,191,179},{255,219,171},
{255,231,163},{227,255,163},{171,243,191},{179,255,207},
{159,255,243},{0,0,0},{0,0,0},{0,0,0}
};


// Chris Covell's NES Palette
unsigned char palette_covell[64][3] =
{
	{109,109,109},{0,44,150},{0,10,161},{50,0,132},
	{145,0,74},{188,0,26},{173,2,0},{122,13,0},
	{72,32,0},{8,51,0},{2,55,0},{0,53,31},
	{0,47,82},{0,0,0},{2,2,2},{2,2,2},

	{188,188,188},{0,100,255},{20,66,255},{111,38,249},
	{231,32,167},{255,27,61},{255,21,0},{205,34,0},
	{184,78,0},{37,109,0},{2,125,0},{0,119,66},
	{0,136,194},{20,20,20},{4,4,4},{4,4,4},

	{255,255,255},{8,207,255},{85,146,255},{203,109,255},
	{255,51,240},{255,77,121},{255,117,35},{255,139,10},
	{249,175,20},{142,221,7},{28,237,37},{6,237,148},
	{2,250,255},{74,74,74},{6,6,6},{6,6,6},

	{255,255,255},{150,251,255},{165,232,255},{210,156,231},
	{255,152,248},{255,156,165},{255,201,161},{255,235,150},
	{255,245,139},{207,227,131},{150,233,160},{146,239,210},
	{136,255,251},{214,214,214},{9,9,9},{9,9,9},

};

unsigned char nes_palette[64][3];

void LoadPalette(int p)
{
	//2 = conte, 1=loopy, other=covell
	for(int x=0;x<64;x++)
	for(int y=0;y<3;y++)
	{
		if (p == 2)
			nes_palette[x][y] = palette_conte[x][y];
		else if (p==1)
			nes_palette[x][y] = palette_loopy[x][y];
		else
			nes_palette[x][y] = palette_covell[x][y];
	}
}

struct SubPalette
{
	Color data[4];
	Color operator[](int i) const {return data[i];}
	void Set(int i, Color c) {data[i] = c;}
};

unsigned char NintendoColor(const Color &c)
{
	unsigned char nearest_color = 0;
	float nearest_distance = 256.0f;
	float r=c.r, g=c.g, b=c.b;

	for (unsigned char i=0; i < 64; i++)
	{
		float nr=nes_palette[i][0];
		float ng=nes_palette[i][1];
		float nb=nes_palette[i][2];
		if (r==nr && g==ng && b==nb)
			return i;
		float distance = (fabs(r-nr) + fabs(g-ng) + fabs(b-nb)) / 3.0f;
		if (distance < nearest_distance)
		{
			nearest_color = i;
			nearest_distance = distance;
		}
	}	
	return nearest_color;
}

void PrintHex(unsigned char i)
{
	unsigned char low=i%16;
	unsigned char high=(i/16)%16;
	printf("$%c%c",
		(high < 10 ? high+'0' : high-10+'a'),
		(low < 10 ? low+'0' : low-10+'a'));		
}

int main(int argn, char **argv)
{
	if (argn!=2 && argn!=3 && argn!=4)
	{
		printf("Usage: %s [optional palette] [input.bmp] [optional output.dat]\n", argv[0]);
		printf("  You may specific a source system palette with one of these flags:\n");
		printf("     -covell      Use Chris Covell's palette (default)\n");
		printf("     -conte       Use Matthew Conte's palette\n");
		printf("     -loopy       Use Loopy's palette\n");
		printf("  input bitmap must be 16x1 or 16x2 pixels\n");
		printf("  every 4th entry (beginning with 0) must mirror, as in the NES\n");
		printf("  if no output is specified, it will output to stdout\n");
		return 0;
	}

	int which_palette = 0; //covell
	int file_argv = 1;

	if (!strcmp(argv[1],"-covell"))
	{
		which_palette = 0;
		file_argv = 2;
	}
	else if (!strcmp(argv[1],"-conte"))
	{
		which_palette = 2;
		file_argv = 2;
	}
	else if (!strcmp(argv[1],"-loopy"))
	{
		which_palette = 1;
		file_argv = 2;
	}
	int output_argv = 0;
	if (argn == file_argv+2)
		output_argv = file_argv+1;
	LoadPalette(which_palette);
	
	BMPImage input(argv[file_argv]);
	if (!input.IsValid()) Fail("Error opening input bitmap");
	int w = input.GetWidth();
	int h = input.GetHeight();
	if (w!=16 || (h!=1 && h!=2)) Fail("Input bitmap must be 16x1 or 16x2 pixels");

	unsigned char output_palette[32];
	for (int y=0; y<h; y++)
	for (int x=0; x<16; x++)
		output_palette[x+16*y] = NintendoColor(input.GetColor(x,y));

	if (output_argv==0) //output to stdout
	{		
		for (int y=0; y<h; y++)
		for (int x=0; x<16; x++)
		{
			if (x==0) printf("  data ");
			PrintHex(output_palette[x+16*y]);
			if (x!=15) printf(",");
			else printf("\n");
		}
	}
	else //output to file
	{
		FILE *fp = fopen(argv[output_argv], "wb");
		if (fp==NULL) Fail("Error creating output file");
		fwrite(output_palette, 1, 16*h, fp);
		fclose(fp);
	}
	
	return 0;
}
