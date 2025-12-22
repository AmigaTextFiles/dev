/*
BMP Image handler.
Public domain source code.
by Bob Rost
*/

#ifndef _BMP_IMAGE_H_
#define _BMP_IMAGE_H_

#include <stdio.h>

typedef unsigned short int uint16;
typedef unsigned int uint32;
typedef unsigned char uchar;

struct Color
{
	unsigned char r,g,b;
	Color(uchar _r, uchar _g, uchar _b):r(_r),g(_g),b(_b){}
	Color():r(0),g(0),b(0){}
	bool operator==(const struct Color &c) const
		{return r==c.r && g==c.g && b==c.b;}
	bool operator!=(const struct Color &c) const
		{return r!=c.r || g!=c.g || b!=c.b;}
};


// reads a BMP image into a 24-bit image buffer
class BMPImage
{
	public:
		BMPImage();
		BMPImage(const char *filename);
		BMPImage(int w, int h);
		~BMPImage();
		void Resize(int w, int h); //destroys existing data
		bool Write(const char *filename);
		bool Load(const char *filename);

		bool IsValid() const;
		int GetWidth() const {return width;}
		int GetHeight() const {return height;}
		unsigned char *GetBuffer() {return pixels;}
		Color GetColor(int x, int y) const;
		bool SetColor(int x, int y, Color);
	private:
		//int width, height;
		uchar *pixels;
		FILE *fp;

		//file header (14 bytes)
		uint16 type; //magic identifier 'BM'
		uint32 file_size;
		uint16 reserved1, reserved2;
		uint32 image_offset; //offset to image data

		//info header (40 bytes)
		uint32 header_size; //header size in bytes
		int width, height; //width and height of image
		uint16 planes; //number of color planes
		uint16 bpp;
		uint32 compression_type;
		uint32 imagesize_bytes; //image size in bytes
		int x_resolution, y_resolution; //pixels per meter
		uint32 num_colors;
		uint32 num_important_colors;

		//read some numbers from the file. non-endian.
		bool GetInt(int&);
		bool GetUint16(uint16&);
		bool GetUint32(uint32&);
		
		//write some numbers to the file. non-endian
		void WriteChar(char);
		void WriteInt(int);
		void WriteUint16(uint16);
		void WriteUint32(uint32);
		void WriteData(uchar*,int);

		//read parts of the BMP format
		bool ReadHeader();
		bool ReadInfoHeader();
		bool ReadPalette();
		bool ReadImage();
		bool ReadImageType0();
		void SwapBGR();
		void SwapRows();

		//write parts of the BMP format
		bool WriteHeader();
		bool WriteInfoHeader();
		bool WriteImage(); //type 0
};


#endif
