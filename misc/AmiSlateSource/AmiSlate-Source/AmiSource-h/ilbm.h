#ifndef ILBM_H
#define ILBM_H

#define MAXCOLORS 256

BOOL LoadIFF1(int nFromCode, char *szFileName);
BOOL LoadIFF2(void);
BOOL SaveIFF(char *szFileName);

int AdaptNewColor(int red, int green, int blue, BOOL * BPenMap, BOOL BTransmit);

BOOL PrepareTempRaster(void);
BOOL FreeTempRaster(void);

void CleanUpIFF(struct IFFHandle *myIFFHandle);
void GetBitRow(UBYTE * ubTempBuffer, int nWidth, int nRow, int nPlane);

static int DecompressBytes(struct IFFHandle * SlateIFF, UBYTE * ubPixelArray, int nBytesPerRow);
static int CompressBytes(UBYTE * ubBuffer, int nWidth);

static void DecodeRasterLine(UBYTE * ubPenArray, UBYTE * ubByteArray, int nWidth, BOOL BContinued);
static void OrRasterLine(UBYTE * ubPixelArray, UBYTE * ubByteArray, int nPlaneOffset, int nBytesPerRow);

static void ReplyRexxIFF(BOOL BWasSuccessful);

#endif
