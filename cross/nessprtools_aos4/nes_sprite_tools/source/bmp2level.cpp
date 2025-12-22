/*
NES Sprite Tools.
Public domain source code.
by Bob Rost
*/

#include <stdio.h>
#include "BMPImage.h"
#include <vector>

#define Fail(er) {printf("%s\n",er);return 0;}
#define FailInput(err) {printf("%s\n",err);return false;}
#define SafeDelete(ptr) {if (ptr!=NULL) delete ptr;}

struct SubPalette
{
	Color data[4];
	Color operator[](int i) const {return data[i];}
	void Set(int i, Color c) {data[i] = c;}
	const Color& Get(int i) const {return data[i];}
	bool Contains(const Color &c) const
	{
		if (data[0]==c || data[1]==c || data[2]==c || data[3]==c)
			return true;
		return false;
	}
};

const Color black(0,0,0);
const Color white(255,255,255);
const Color red(255,0,0);
const Color blue(0,0,255);
const Color green(0,255,0);
const Color yellow(255,255,0);
const Color magenta(255,0,255);
const Color cyan (0,255,255);
const SubPalette global_palette = {black, white, red, blue};

struct Tile
{
	Color data[16][16];
	Tile(){}
	Color Get(int x, int y) const {return data[x][y];}
	void Set(int x, int y, Color c) {data[x][y] = c;}
	bool operator==(const Tile &t)
	{
		for(int y=0;y<16;y++)
		for(int x=0;x<16;x++)
			if (data[x][y]!=t.data[x][y]) return false;
		return true;
	}
	bool operator!=(const Tile &t)
	{
		for(int y=0;y<16;y++)
		for(int x=0;x<16;x++)
			if (data[x][y]!=t.data[x][y]) return true;
		return false;
	}
};

Tile ApplyPalette(const Tile &source, const SubPalette &p)
{
	Tile dest;
	for (int y=0; y < 16; y++)
	for (int x=0; x < 16; x++)
	{
		Color c = source.Get(x,y);
		if (c == global_palette[0]) dest.Set(x,y,p[0]);
		else if (c == global_palette[1]) dest.Set(x,y,p[1]);
		else if (c == global_palette[2]) dest.Set(x,y,p[2]);
		else if (c == global_palette[3]) dest.Set(x,y,p[3]);
		else dest.Set(x,y,cyan); //error pixel
	}
	return dest;
}

bool IsBlank(const Tile &t, Color &c)
{
	c = t.Get(0,0);
	for (int y=0;y<16;y++)
	for (int x=0;x<16;x++)
		if (t.Get(x,y)!=c) return false;
	return true;
}

struct TilePal
{
	int tile, pal;
	TilePal():tile(0),pal(0){}
	TilePal(int t, int p):tile(t),pal(p){}
	void Set(int t, int p){tile=t; pal=p;}
};

class NesLevel
{
	public:
		NesLevel(){collision_data=NULL; special_data=NULL; map_data=NULL;}
		~NesLevel(){SafeDelete(collision_data);SafeDelete(special_data);SafeDelete(map_data)}
		bool Load(const char*,const char*,const char*,const char*,const char*);
		bool CreateMapData();
		bool CreateCollisionData();
		bool CreateSpecialData();
		bool Output(const char*);

	private:
		bool OutputMajorColumnOrder(const char*);
		bool OutputMemoryOrder(const char*);

		bool LoadPalette();
		bool VerifyPatternTable();
		bool IsValid();
		bool FindMatchingTile(int x, int y, TilePal&);
		Tile MakeTile(int x, int y, const BMPImage&);
		void SetMapData(int x, int y, TilePal tp);
		void SetCollisionData(int x, int y, bool);
		void SetSpecialData(int x, int y, int value);
		int GetSpecialData(int x, int y);
		bool GetCollisionData(int x, int y);
		unsigned char GetTile(int x, int y);
		int GetTilePalette(int x, int y);
		unsigned char GetAttributeByte(int x, int y); //x,y upper left tile of quad

		BMPImage map;
		BMPImage paletteimg;
		BMPImage pattern_table;
		BMPImage collision;
		BMPImage special;
		int image_width, image_height;
		int mapw, maph;
		SubPalette palette[4];	
		bool *collision_data;
		int *special_data;
		TilePal *map_data;
};

bool NesLevel::Load(const char *mapname, const char *patname, const char *palname,
	const char *collisionname, const char *specialname)
{
	map.Load(mapname);
	pattern_table.Load(patname);
	paletteimg.Load(palname);
	collision.Load(collisionname);
	special.Load(specialname);
	return IsValid();
}

Tile NesLevel::MakeTile(int x, int y, const BMPImage &img)
{
	Tile t;
	int mx=x*16, my=y*16;
	for (int j=0; j<16; j++)
	for (int i=0; i<16; i++)
		t.Set(i,j,img.GetColor(mx+i,my+j));
	return t;
}

//compare full color tile to 
bool NesLevel::FindMatchingTile(int x, int y, TilePal &tp)
{
	Tile source = MakeTile(x,y,map);
	for (int patterny = 0; patterny < 16; patterny++)
	for (int patternx = 0; patternx < 16; patternx++)
	{
		Tile pattern_tile = MakeTile(patternx,patterny,pattern_table);
		for (int pal=0; pal < 4; pal++)
			if (ApplyPalette(pattern_tile, palette[pal]) == source)
			{
				tp.tile = patterny*32 + patternx*2;
				tp.pal = pal;
				//tp.Set(patterny*32 + patternx*2, pal);
				return true;
			}
	}
	return false;
}

void NesLevel::SetMapData(int x, int y, TilePal value)
{
	if (map_data == NULL) return;
	map_data[y*mapw + x] = value;
	//printf("(%i,%i): palette %i\n", x,y, value.pal);
}

void NesLevel::SetCollisionData(int x, int y, bool value)
{
	if (collision_data == NULL) return;
	collision_data[y*mapw + x] = value;
}

void NesLevel::SetSpecialData(int x, int y, int value)
{
	if (special_data == NULL) return;
	special_data[y*mapw + x] = value;
}

int NesLevel::GetSpecialData(int x, int y)
{
	if (special_data == NULL) return 0;
	if (x<0 || x>=mapw) return 0;
	if (y<0 || y>=maph) return false;
	return special_data[y*mapw + x];
}

bool NesLevel::GetCollisionData(int x, int y)
{
	if (x>=mapw || y>=maph) return false;
	return collision_data[y*mapw + x];
}

unsigned char NesLevel::GetTile(int x, int y)
{
	if (x>=mapw || y>=maph) return 0;
	return (unsigned char)map_data[y*mapw + x].tile;
}

int NesLevel::GetTilePalette(int x, int y)
{
	if (x>=mapw || y>=maph) return 0;
	return map_data[y*mapw + x].pal;
}

//x, y is the upper left tile of the quad
unsigned char NesLevel::GetAttributeByte(int x, int y)
{
	int upleft = GetTilePalette(x, y);
	int upright = GetTilePalette(x+1, y);
	int downleft = GetTilePalette(x, y+1);
	int downright = GetTilePalette(x+1, y+1);
	int attrib = upleft + upright*4 + downleft*16 + downright*64;
	return (unsigned char)attrib;
}

bool NesLevel::CreateMapData()
{
	TilePal tp;
	for (int y=0; y<maph; y++)
	for (int x=0; x<mapw; x++)
	{
		if (!FindMatchingTile(x,y,tp))
		{
			printf("Major tile (%i,%i) does not match pattern table\n", x,y);
			return false;
		}
		SetMapData(x,y,tp);
	}
	return true;
}

bool NesLevel::CreateCollisionData()
{
	Color c;
	for (int y=0; y<maph; y++)
	for (int x=0; x<mapw; x++)
	{
		if (!IsBlank(MakeTile(x,y,collision),c))
		{
			printf("Major collision tile (%i,%i) is not a solid color\n", x,y);
			return false;
		}
		if (c == black) SetCollisionData(x,y,false);
		else if (c==white) SetCollisionData(x,y,true);
		else
		{
			printf("Major collision tile (%i,%i) must be black or white\n",x,y);
			return false;
		}
	}
	return true;
}

bool NesLevel::CreateSpecialData()
{
	Color c;
	for (int y=0; y<maph; y++)
	for (int x=0; x<mapw; x++)
	{
		if (!IsBlank(MakeTile(x,y,special),c))
		{
			printf("Major special tile (%i,%i) is not a solid color\n", x,y);
			return false;
		}
		if (c==black) SetSpecialData(x,y,0);
		else if (c==white) SetSpecialData(x,y,1);
		else if (c==red) SetSpecialData(x,y,2);
		else if (c==blue) SetSpecialData(x,y,3);
		else if (c==green) SetSpecialData(x,y,4);
		else if (c==yellow) SetSpecialData(x,y,5);
		else if (c==magenta) SetSpecialData(x,y,6);
		else if (c==cyan) SetSpecialData(x,y,7);
		else
		{
			printf("Major special tile (%i,%i) is an unsupported color (%i,%i,%i)\n",
				x,y,c.r,c.g,c.b);
			return false;
		}
	}
	return true;
}

bool NesLevel::LoadPalette()
{
	Color base_color = paletteimg.GetColor(0,0);
	for(int i=0; i<16; i++)
		palette[i/4].Set(i%4, paletteimg.GetColor(i,0));
	for (int i=0;i<4;i++)
		if (palette[i].data[0]!=base_color) return false;
	for (int pal=0; pal<4; pal++)
	{
		for(int col=0; col<4; col++)
		{
			Color c=palette[pal][col];
			printf("(%i,%i,%i)  ", c.r, c.g, c.b);
		}
		printf("\n");
	}
	return true;
}

bool NesLevel::VerifyPatternTable()
{
	for(int y=0; y<128; y++)
	for(int x=0; x<128; x++)
		if (!global_palette.Contains(pattern_table.GetColor(x,y))) return false;
	return true;
}

bool NesLevel::IsValid()
{
	if (!map.IsValid()) FailInput("Error loading map image");
	if (!paletteimg.IsValid()) FailInput("Error loading palette image");
	if (!pattern_table.IsValid()) FailInput("Error loading pattern table image");
	if (!collision.IsValid()) FailInput("Error loading collision image");
	if (!special.IsValid()) FailInput("Error loading special data image");
	image_width = map.GetWidth();
	image_height = map.GetHeight();
	if (image_height % 16 != 0) FailInput("Map height must be multiple of 16 pixels");
	if (image_width % 32 != 0) FailInput("Map width must be multiple of 32 pixels");
	mapw = image_width / 16;
	maph = image_height / 16;
	if (paletteimg.GetWidth()!=16) FailInput("Palette must be 16 pixels wide");
	if (pattern_table.GetWidth()!=128 || pattern_table.GetHeight()!=128)
		FailInput("Pattern table must be 16 pixels wide");
	if (collision.GetWidth()!=image_width || collision.GetHeight()!=image_height)
		FailInput("Collision map must be same size as level map");
	if (special.GetWidth()!=image_width || special.GetHeight()!=image_height)
		FailInput("Special map must be same size as level map");
	if (!LoadPalette()) FailInput("Palette does not mirror entry 0");
	if (!VerifyPatternTable()) FailInput("Pattern table does not obey 4-color restriction");
	collision_data = new bool[mapw*maph];
	special_data = new int[mapw*maph];
	map_data = new TilePal[mapw*maph];
	return true;
}

bool NesLevel::Output(const char *filename)
{
	//return OutputMajorColumnOrder(filename);
	return OutputMemoryOrder(filename);
}

bool NesLevel::OutputMemoryOrder(const char *filename)
{
	if ((mapw!=32 && mapw!=16) || (maph!=15))
	{
		printf("Cannot output memory order:\n   Map major block size must be 16x15 or 32x15\n");
		return false;
	}
	
	printf("Outputting %s of PPU memory\n", (mapw==16?"1 screen":"2 screens"));
	int datasize = 1024 + (mapw==32 ? 1024 : 0) + 512;
	datasize += 512; //max size for special data
	unsigned char *outdata = new unsigned char[datasize];
	int bytes_to_write = 0;
	for (int startx = 0; startx < mapw; startx+=16)
	{
		//write name table
		printf("starting name table at byte %i\n", bytes_to_write);
		for (int y=0; y<15; y++)
		{
			for (int x=0; x<16; x++)
			{
				outdata[bytes_to_write++] = GetTile(startx + x,y);
				outdata[bytes_to_write++] = GetTile(startx + x,y)+1;
			}
			for (int x=0; x<16; x++)
			{
				outdata[bytes_to_write++] = GetTile(startx + x,y)+16;
				outdata[bytes_to_write++] = GetTile(startx + x,y)+17;
			}
		}

		printf("starting attrib table at byte %i\n", bytes_to_write);
		//write attrib table
		for (int y=0; y<8; y++)
		for (int x=0; x<8; x++)
			outdata[bytes_to_write++] = GetAttributeByte(startx + x*2, y*2);
	}

	printf("starting collision data at byte %i\n", bytes_to_write);
	//output full collision data
	for (int y=0; y<16; y++)
	for (int x=0; x<mapw; x++)
		outdata[bytes_to_write++] = (GetCollisionData(x,y) ? 1 : 0);
	
	printf("starting special data at byte %i\n", bytes_to_write);
	//output special data
	int special_bytes = 0;
	for (int y=0; y<16; y++)
	for (int x=0; x<mapw; x++)
	{
		int val = GetSpecialData(x,y);
		if (val != 0)
		{
			outdata[bytes_to_write++] = (unsigned char)val;
			outdata[bytes_to_write++] = (unsigned char)x;
			outdata[bytes_to_write++] = (unsigned char)y;
		}
	}
	outdata[bytes_to_write++] = 0; //special data end flag

	printf("Total data size: %i bytes\n", bytes_to_write);
	FILE *fp = fopen(filename, "wb");
	int bytes_written = fwrite(outdata, 1, bytes_to_write, fp);
	if (fp != NULL) fclose(fp);
	delete outdata;
	if (bytes_written < bytes_to_write) return false;
	return true;
}

bool NesLevel::OutputMajorColumnOrder(const char *filename)
{
	int major_columns = mapw / 2;
	int attrib_height = (maph + 1) / 2;
	int datasize = mapw*maph + major_columns*attrib_height;
	unsigned char *outdata = new unsigned char[datasize];
	
	printf ("Outputting %i major columns (%i*2 blocks, %i attrib bytes)\n",
		major_columns, maph, attrib_height);
	int bytes_to_write = 0;
	for (int col=0; col<major_columns; col++)
	{
		//first tile column
		for (int y=0;y<maph;y++)
			outdata[bytes_to_write++] = GetTile(col*2,y);
		//second tile column
		for (int y=0;y<maph;y++)
			outdata[bytes_to_write++] = GetTile(col*2+1,y);
		//attrib byte column
		for (int y=0;y<attrib_height;y++)
			outdata[bytes_to_write++] = GetAttributeByte(col*2,y*2);
	}

	printf("Total data size: %i bytes\n", bytes_to_write);
	FILE *fp = fopen(filename, "wb");
	int bytes_written = fwrite(outdata, 1, bytes_to_write, fp);
	if (fp != NULL) fclose(fp);
	delete outdata;
	if (bytes_written < bytes_to_write) return false;
	return true;
}


int main(int argn, char **argv)
{
	if (argn != 7)
	{
		//map palette collision special
		printf("Usage: %s [map.bmp] [pattern.bmp] [palette.bmp]\n        [collision.bmp] [special.bmp] [output.dat]\n", argv[0]);
		printf("  map bitmap must be a multiple of 16x16 pixels (4-square compression used)\n");
		printf("  palette must be 16 pixels wide. the first row will be used\n");
		printf("  output will be a 4-color NES pattern table\n");
		return 0;
	}

	NesLevel level;
	if (!level.Load(argv[1],argv[2],argv[3],argv[4],argv[5]))
		Fail("Error initializing with input images");
	if (!level.CreateMapData()) Fail("Error creating map data");
	if (!level.CreateCollisionData()) Fail("Error creating collision data");
	if (!level.CreateSpecialData()) Fail("Error creating special data");
	if (!level.Output(argv[6])) Fail("Error outputting level data");
	return 0;
}
