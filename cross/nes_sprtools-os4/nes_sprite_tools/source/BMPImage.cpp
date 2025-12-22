/*
BMP Image handler.
Public domain source code.
by Bob Rost
*/

#include "BMPImage.h"
#include <string.h>

BMPImage::BMPImage()
{
	width = height = 0;
	pixels = NULL;
}

BMPImage::BMPImage(const char *filename)
{
	width = height = 0;
	pixels = NULL;
	if ((fp = fopen(filename,"r"))==NULL) return;
	if (ReadHeader() && ReadInfoHeader() && ReadPalette() && ReadImage())
	{
		fclose(fp);
		return; //success!
	}
	//not so success...
	fclose(fp);
	width = height = 0;
	if (pixels != NULL) delete pixels;
	pixels = NULL;
}

BMPImage::BMPImage(int w, int h)
{
	width = height = 0;
	pixels = NULL;
	Resize(w,h);
}

BMPImage::~BMPImage()
{
	if (pixels != NULL) delete pixels;
}

bool BMPImage::Load(const char *filename)
{
	width = height = 0;
	if (pixels != NULL) delete pixels;
	pixels = NULL;

	if ((fp = fopen(filename,"r"))==NULL) return false;
	if (ReadHeader() && ReadInfoHeader() && ReadPalette() && ReadImage())
	{
		fclose(fp);
		return true; //success!
	}
	//not so success...
	fclose(fp);
	width = height = 0;
	if (pixels != NULL) delete pixels;
	pixels = NULL;
	return false;
}

void BMPImage::Resize(int w, int h)
{
	width = height = 0;
	if (pixels != NULL) delete pixels;
	if (w < 0 || h < 0) return;

	width = w;
	height = h;
	pixels = new unsigned char [width * height * 3];
}

bool BMPImage::Write(const char *filename)
{
	if ((fp = fopen(filename,"w"))==NULL) return false;
	if (!(WriteHeader() && WriteInfoHeader() && WriteImage()))
	{
		fclose(fp);
		return false;
	}
	fclose(fp);
	return true;
}

Color BMPImage::GetColor(int x, int y) const
{
	if (x<0 || x>=width || y<0 || y>=height || pixels==NULL)
		return Color(0,0,0);
	int offset = (y*width + x)*3;
	return Color(pixels[offset],pixels[offset+1],pixels[offset+2]);
}

bool BMPImage::SetColor(int x, int y, Color c)
{
	if (x<0 || x>=width || y<0 || y>=height || pixels==NULL)
		return false;
	int offset = (y*width + x)*3;
	pixels[offset] = c.r;
	pixels[offset+1] = c.g;
	pixels[offset+2] = c.b;
	return true;
}

bool BMPImage::IsValid() const
{
	return (width!=0 && height!=0 && pixels!=NULL);
}

bool BMPImage::GetUint16(uint16 &i)
{
	unsigned char buf[2];
	if (fread(buf, 1, 2, fp)<2) return false;
	i = ((int)buf[0]) + ((int)buf[1])*256;
	return true;
}

bool BMPImage::GetUint32(uint32 &i)
{
	unsigned char buf[4];
	if (fread(buf, 1, 4, fp)<4) return false;
	i = ((int)buf[0]) + ((int)buf[1])*256 +
		((int)buf[2])*256*256 + ((int)buf[3])*256*256*256;
	return true;
}

// same as GetUint32. will this cause problems?
bool BMPImage::GetInt(int &i)
{
	unsigned char buf[4];
	if (fread(buf, 1, 4, fp)<4) return false;
	i = ((int)buf[0]) + ((int)buf[1])*256 +
		((int)buf[2])*256*256 + ((int)buf[3])*256*256*256;
	return true;
}

bool BMPImage::ReadHeader()
{
	char magic[2];
	uint32 temp;
	if (fread(magic,1,2,fp)!=2) return false;
	if (magic[0]!='B' || magic[1]!='M') return false;
	if (!GetUint32(temp)) return false; else file_size=temp;
	if (!GetUint32(temp)) return false; //4 bytes reserved
	if (!GetUint32(temp)) return false; else image_offset=temp;
	return true;
}

bool BMPImage::ReadInfoHeader()
{
	int tempint;
	uint16 temp16;
	uint32 temp32;
	if (!GetUint32(temp32)) return false; else header_size=temp32;
	if (!GetInt(tempint)) return false; else width=tempint;
	if (!GetInt(tempint)) return false; else height=tempint;
	if (!GetUint16(temp16)) return false; else planes=temp16;
	if (!GetUint16(temp16)) return false; else bpp=temp16;
	if (!GetUint32(temp32)) return false; else compression_type=temp32;
	if (!GetUint32(temp32)) return false; else imagesize_bytes=temp32;
	if (!GetInt(tempint)) return false; else x_resolution=tempint;
	if (!GetInt(tempint)) return false; else y_resolution=tempint;
	if (!GetUint32(temp32)) return false; else num_colors=temp32;
	if (!GetUint32(temp32)) return false; else num_important_colors=temp32;
	return true;
}

bool BMPImage::ReadPalette()
{
	if (compression_type == 0) return true;
	return false;
}

bool BMPImage::ReadImage()
{
	//	0 - none (24-bit RGB)
	//	1 - 8bit RLE
	//	2 - 4bit RLE
	//	3 - RGB with mask
	if (compression_type == 0) return ReadImageType0();
	return false;
}

bool BMPImage::ReadImageType0()
{
	int bufsize = width * height * 3;
	pixels = new unsigned char[bufsize];
	if (fread(pixels, 1, bufsize, fp)!=bufsize) return false;
	SwapBGR();
	SwapRows();
	return true;
}

void BMPImage::SwapBGR()
{
	//BMP is stored as BGR, but we want RGB. Stupid Bitmaps!
	unsigned char temp;
	int bufsize = width*height*3;
	for (int i=0; i < bufsize; i+=3)
	{
		temp = pixels[i];
		pixels[i] = pixels[i+2];
		pixels[i+2] = temp;
	}
}


void BMPImage::SwapRows()
{
	//BMP stores rows bottom-up. Stupid Bitmaps!
	int pitch = width*3;
	uchar rowbuf[pitch];
	for(int row = 0; row < height/2; row++)
	{
		uchar* toprow = &pixels[row*pitch];
		uchar* bottomrow = &pixels[(height-row-1)*pitch];
		
		memcpy(rowbuf, toprow, pitch);
		memcpy(toprow, bottomrow, pitch);
		memcpy(bottomrow, rowbuf, pitch);
	}
}


void BMPImage::WriteUint16(uint16 i)
{
	uchar buf[2];
	buf[0] = i % 256;
	buf[1] = (i >> 8) % 256;
	fwrite(&buf, 1, 2, fp);
}

void BMPImage::WriteUint32(uint32 i)
{
	uchar buf[4];
	buf[0] = i % 256;
	buf[1] = (i >> 8) % 256;
	buf[2] = (i >> 16) % 256;
	buf[3] = (i >> 24) % 256;
	fwrite(&buf, 1, 4, fp);
}

void BMPImage::WriteChar(char c)
{
	fwrite(&c, 1, 1, fp);
}

// Same as WriteUint32. Will this cause problems?
void BMPImage::WriteInt(int i)
{
	uchar buf[4];
	buf[0] = i % 256;
	buf[1] = (i >> 8) % 256;
	buf[2] = (i >> 16) % 256;
	buf[3] = (i >> 24) % 256;
	fwrite(&buf, 1, 4, fp);
}

void BMPImage::WriteData(uchar *data, int len)
{
	fwrite(data, 1, len, fp);
}

bool BMPImage::WriteHeader()
{
	file_size = 14 + 40 + (width*height*3);
	image_offset = 14 + 40;

	WriteChar('B');
	WriteChar('M');
	WriteUint32(file_size);
	WriteUint32(0); //reserved
	WriteUint32(image_offset);
	return true;
}

bool BMPImage::WriteInfoHeader()
{
	//header_size = 14 + 40;
	header_size = 40; // header size is really just the size of the info header
	planes = 1;
	bpp = 24;
	compression_type = 0;
	imagesize_bytes = width*height*3;
	x_resolution = 72;
	y_resolution = 72;
	num_colors = 0;
	num_important_colors = 0;

	WriteUint32(header_size);
	WriteInt(width);
	WriteInt(height);
	WriteUint16(planes);
	WriteUint16(bpp);
	WriteUint32(compression_type);
	WriteUint32(imagesize_bytes);
	WriteInt(x_resolution);
	WriteInt(y_resolution);
	WriteUint32(num_colors);
	WriteUint32(num_important_colors);
	return true;
}

bool BMPImage::WriteImage()
{
	SwapBGR(); //BMP files need BGR colorspace
	SwapRows(); //wtf? bottom-up? Who does this?

	WriteData(pixels, width*height*3);

	SwapBGR(); //convert back to RGB
	SwapRows(); //convert back to top-down ordering
	return true;
}
