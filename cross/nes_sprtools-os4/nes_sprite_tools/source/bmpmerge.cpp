/*
NES Sprite Tools.
Public domain source code.
by Bob Rost
*/

#include <stdio.h>
#include "BMPImage.h"
#include <vector>

#define Fail(er) {printf("%s\n",er);return 0;}

struct Tile
{
	Color data[8][8];
	Tile(){}
	Color Get(int x, int y) const {return data[x][y];}
	void Set(int x, int y, Color c) {data[x][y] = c;}
	bool operator!=(const Tile &t)
	{
		for(int y=0;y<8;y++)
		for(int x=0;x<8;x++)
			if (data[x][y]!=t.data[x][y]) return true;
		return false;
	}
};

const Color black(0,0,0);
std::vector<struct Tile> tiles1, tiles2;

bool IsBlank(const Tile &t)
{
	Color c = t.Get(0,0);
	for (int y=0;y<8;y++)
	for (int x=0;x<8;x++)
		if (t.Get(x,y)!=c) return false;
	return true;
}

bool WriteTiles(const char *filename)
{
	if (tiles1.size()!=256) return false;
	BMPImage img(128,128);
	int curr_tile = 0;
	for (int tiley = 0; tiley < 128; tiley += 8)
	for (int tilex = 0; tilex < 128; tilex += 8)
	{
		Tile t = tiles1[curr_tile];
		for (int y=0; y < 8; y++)
		for (int x=0; x < 8; x++)
			img.SetColor(tilex+x, tiley+y, t.Get(x,y));
		curr_tile++;
	}
	return img.Write(filename);
}

void LoadTiles(const BMPImage &img, std::vector<struct Tile> &tiles)
{
	for(int tiley = 0; tiley < 128; tiley += 8)
	for(int tilex = 0; tilex < 128; tilex += 8)
	{
		Tile t;
		for (int y=0; y < 8; y++)
		for (int x=0; x < 8; x++)
			t.Set(x,y, img.GetColor(tilex+x, tiley+y));
		tiles.push_back(t);
	}
}

void MergeTiles()
{
	if (tiles1.size() != tiles2.size() || tiles1.size()!=256)
	{
		printf("Woah, this should never happen! Alert the author.\nError merging tiles\n");
		return;
	}
	for(int i=0; i<256; i++)
	{
		bool blank1 = IsBlank(tiles1[i]);
		bool blank2 = IsBlank(tiles2[i]);
		if (blank1 && !blank2)
			tiles1[i] = tiles2[i];
		else if (!blank1 && !blank2)
			printf("Warning: Tile %i is non-blank in both images. Using image 1.\n", i);
	}
}

int main(int argn, char **argv)
{
	if (argn != 4)
	{
		printf("Usage: %s [input1.bmp] [input2.bmp] [output.bmp]\n", argv[0]);
		printf("  input bitmaps must be 128x128 pixels\n");
		return 0;
	}

	BMPImage input1(argv[1]);
	if (!input1.IsValid()) Fail("Error opening first input bitmap");
	if (input1.GetWidth()!=128 || input1.GetHeight()!=128) Fail("Input bitmaps must be 128x128 pixels");
	BMPImage input2(argv[2]);
	if (!input2.IsValid()) Fail("Error opening second input bitmap");
	if (input2.GetWidth()!=128 || input2.GetHeight()!=128) Fail("Input bitmaps must be 128x128 pixels");

	LoadTiles(input1,tiles1);
	LoadTiles(input2,tiles2);
	MergeTiles();
	if (!WriteTiles(argv[3])) Fail("Error writing output bitmap");

	return 0;
}
