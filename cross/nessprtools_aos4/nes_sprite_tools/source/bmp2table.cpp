/*
NES Sprite Tools.
Public domain source code.
by Bob Rost
*/

#include <stdio.h>
#include "BMPImage.h"
#include <vector>

#define Fail(er) {printf("%s\n",er);return 0;}

struct SubPalette
{
	Color data[4];
	Color operator[](int i) const {return data[i];}
	void Set(int i, Color c) {data[i] = c;}
};

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

//typedef struct Color[4] SubPalette;
//typedef struct Color[8][8] Tile;

const Color black(0,0,0);
const Color white(255,255,255);
const Color red(255,0,0);
const Color blue(0,0,255);
const Color error_color(0,255,255);
const SubPalette global_palette = {black, white, red, blue};

std::vector<struct SubPalette> palettes;
std::vector<struct Tile> tiles;
std::vector<struct Tile> output_tiles;


Tile TransformPalette(const Tile &source, const SubPalette &p)
{
	Tile dest;
	for (int y=0; y < 8; y++)
	for (int x=0; x < 8; x++)
	{
		Color c = source.Get(x,y);
		if (c == p[0]) dest.Set(x,y,global_palette[0]);
		else if (c == p[1]) dest.Set(x,y,global_palette[1]);
		else if (c == p[2]) dest.Set(x,y,global_palette[2]);
		else if (c == p[3]) dest.Set(x,y,global_palette[3]);
		else dest.Set(x,y,error_color); //error pixel
	}
	return dest;
}

bool MatchPalette(const Tile &t, const SubPalette &p)
{
	for (int y=0; y < 8; y++)
	for (int x=0; x < 8; x++)
	{
		Color c = t.Get(x,y);
		if (c!=p[0] && c!=p[1] && c!=p[2] && c!=p[3])
			return false;
	}
	return true;
}

bool ConvertTiles()
{
	if (tiles.size()!=256 || output_tiles.size()!=0) return false;
	for (int tilenum = 0; tilenum < 256; tilenum++)
	{
		std::vector<Tile> transforms;
		for (int pal = 0; pal<palettes.size(); pal++)
			if (MatchPalette(tiles[tilenum], palettes[pal]))
				transforms.push_back(TransformPalette(tiles[tilenum],palettes[pal]));
		if (transforms.size() == 1)
			output_tiles.push_back(transforms[0]);
		else if (transforms.size() == 0)
		{
			printf("Tile %i does not match any available palettes\n", tilenum);
			return false;
		}
		else //matches multiple
		{
			bool ambiguous = false;
			for (int i=1; i<transforms.size(); i++)
				if (transforms[i]!=transforms[0])
					ambiguous = true;
			if (ambiguous)
				printf("Warning: Tile %i has ambiguous palette match. Using first available.\n",tilenum);
			//else printf("Tile %i matches multiple, non-ambiguous\n",tilenum);
			output_tiles.push_back(transforms[0]);
		}
	}
	return true;
}

bool WriteTiles(const char *filename)
{
	if (output_tiles.size()!=256) return false;
	BMPImage img(128,128);
	int curr_tile = 0;
	for (int tiley = 0; tiley < 128; tiley += 8)
	for (int tilex = 0; tilex < 128; tilex += 8)
	{
		Tile t = output_tiles[curr_tile];
		for (int y=0; y < 8; y++)
		for (int x=0; x < 8; x++)
			img.SetColor(tilex+x, tiley+y, t.Get(x,y));
		curr_tile++;
	}
	return img.Write(filename);
}

void LoadTiles(const BMPImage &img)
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
	printf("Read %i tiles\n", tiles.size());
}

bool LoadPalettes(const BMPImage &palimg)
{
	int width = palimg.GetWidth();
	int height = palimg.GetHeight();
	if (width <= 0 || height <= 0) return false;
	if (width % 4 != 0) return false;

	for (int row=0; row < height; row++)
	for (int col=0; col < width; col+=4)
	{
		SubPalette p;
		p.Set(0, palimg.GetColor(col,row));
		p.Set(1, palimg.GetColor(col+1,row));
		p.Set(2, palimg.GetColor(col+2,row));
		p.Set(3, palimg.GetColor(col+3,row));
		palettes.push_back(p);
	}
	printf("Read %i sub palettes\n", palettes.size());
	return true;
}

int main(int argn, char **argv)
{
	if (argn != 4)
	{
		printf("Usage: %s [input.bmp] [palette.bmp] [output.bmp]\n", argv[0]);
		printf("  input bitmap must be 128x128 pixels\n");
		printf("  palette must be a multiple of 4x1 pixels, to be read row-order\n");
		printf("  output will be a 4-color NES pattern table\n");
		return 0;
	}

	BMPImage input(argv[1]);
	if (!input.IsValid()) Fail("Error opening input bitmap");
	if (input.GetWidth()!=128 || input.GetHeight()!=128) Fail("Input bitmap must be 128x128 pixels");
	BMPImage inpal(argv[2]);
	if (!inpal.IsValid()) Fail("Error opening palette bitmap");
	if (!LoadPalettes(inpal)) Fail("Palette image must be a multiple of 4x1 pixels");

	LoadTiles(input);
	if (!ConvertTiles()) Fail("Error converting tiles to 4-color");
	if (!WriteTiles(argv[3])) Fail("Error writing output bitmap");

	return 0;
}
