/*
Copyright (c) 1993-2012, Cognitive Technologies
All rights reserved.

Разрешается повторное распространение и использование как в виде исходного кода,
так и в двоичной форме, с изменениями или без, при соблюдении следующих условий:

      * При повторном распространении исходного кода должны оставаться указанное
        выше уведомление об авторском праве, этот список условий и последующий
        отказ от гарантий.
      * При повторном распространении двоичного кода в документации и/или в
        других материалах, поставляемых при распространении, должны сохраняться
        указанная выше информация об авторском праве, этот список условий и
        последующий отказ от гарантий.
      * Ни название Cognitive Technologies, ни имена ее сотрудников не могут
        быть использованы в качестве средства поддержки и/или продвижения
        продуктов, основанных на этом ПО, без предварительного письменного
        разрешения.

ЭТА ПРОГРАММА ПРЕДОСТАВЛЕНА ВЛАДЕЛЬЦАМИ АВТОРСКИХ ПРАВ И/ИЛИ ДРУГИМИ ЛИЦАМИ "КАК
ОНА ЕСТЬ" БЕЗ КАКОГО-ЛИБО ВИДА ГАРАНТИЙ, ВЫРАЖЕННЫХ ЯВНО ИЛИ ПОДРАЗУМЕВАЕМЫХ,
ВКЛЮЧАЯ ГАРАНТИИ КОММЕРЧЕСКОЙ ЦЕННОСТИ И ПРИГОДНОСТИ ДЛЯ КОНКРЕТНОЙ ЦЕЛИ, НО НЕ
ОГРАНИЧИВАЯСЬ ИМИ. НИ ВЛАДЕЛЕЦ АВТОРСКИХ ПРАВ И НИ ОДНО ДРУГОЕ ЛИЦО, КОТОРОЕ
МОЖЕТ ИЗМЕНЯТЬ И/ИЛИ ПОВТОРНО РАСПРОСТРАНЯТЬ ПРОГРАММУ, НИ В КОЕМ СЛУЧАЕ НЕ
НЕСЁТ ОТВЕТСТВЕННОСТИ, ВКЛЮЧАЯ ЛЮБЫЕ ОБЩИЕ, СЛУЧАЙНЫЕ, СПЕЦИАЛЬНЫЕ ИЛИ
ПОСЛЕДОВАВШИЕ УБЫТКИ, СВЯЗАННЫЕ С ИСПОЛЬЗОВАНИЕМ ИЛИ ПОНЕСЕННЫЕ ВСЛЕДСТВИЕ
НЕВОЗМОЖНОСТИ ИСПОЛЬЗОВАНИЯ ПРОГРАММЫ (ВКЛЮЧАЯ ПОТЕРИ ДАННЫХ, ИЛИ ДАННЫЕ,
СТАВШИЕ НЕГОДНЫМИ, ИЛИ УБЫТКИ И/ИЛИ ПОТЕРИ ДОХОДОВ, ПОНЕСЕННЫЕ ИЗ-ЗА ДЕЙСТВИЙ
ТРЕТЬИХ ЛИЦ И/ИЛИ ОТКАЗА ПРОГРАММЫ РАБОТАТЬ СОВМЕСТНО С ДРУГИМИ ПРОГРАММАМИ,
НО НЕ ОГРАНИЧИВАЯСЬ ЭТИМИ СЛУЧАЯМИ), НО НЕ ОГРАНИЧИВАЯСЬ ИМИ, ДАЖЕ ЕСЛИ ТАКОЙ
ВЛАДЕЛЕЦ ИЛИ ДРУГОЕ ЛИЦО БЫЛИ ИЗВЕЩЕНЫ О ВОЗМОЖНОСТИ ТАКИХ УБЫТКОВ И ПОТЕРЬ.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of the Cognitive Technologies nor the names of its
      contributors may be used to endorse or promote products derived from this
      software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <cstdio>
#include <string>
#include <cstring>

#include "bmp.h"

static const char     BmpSignature[]    = {0x42, 0x4D};
static const double   BmpInchToMeter    = 39.37007874015748;
static const int      BmpFileHeaderSize = 14;
static const int      BmpDibHeaderSize  = 40;
static const int      BmpReserve        = 0;
static const int      BmpPlanesCount    = 1;
static const int      BmpCompressType   = 0;
static const int      BmpColorsCount    = 0;
static const int      BmpImpColorsCount = 0;

int GetBytesPerLine(const BmpInfo* pBmpInfo)
{
  int bpl = 0;
  switch (pBmpInfo->type)
  {
  case BmpMono: 
    bpl = pBmpInfo->width / 8;
    break;
  case BmpGray: 
    bpl = pBmpInfo->width;
    break;
  case BmpRgb:
    bpl = pBmpInfo->width * 3;
    break;
  case BmpRgba:
    bpl = pBmpInfo->width * 4;
    break;
  }
  if (bpl % 4 != 0) ///< must be divisible by 4
    bpl += 4 - bpl % 4;
  return bpl;
}

int GetBytesPerPixel(const BmpInfo* pBmpInfo)
{
  int bpp = 0;
  switch (pBmpInfo->type)
  {
  case BmpMono:
    bpp = 0;
    break;
  case BmpGray:
    bpp = 1;
    break;
  case BmpRgb: 
    bpp = 3;
    break;
  case BmpRgba:
    bpp = 4;
    break;
  }
  return bpp;
}

LIBBMP_API int BmpGetInfo(BmpInfo* pBmpInfo, const char* pFileName)
{
  if (!pBmpInfo || !pFileName)
    return -1;

  FILE* pFile(fopen(pFileName, "rb"));
  if (pFile == 0)
    return -1;

  char signature[3] = {0};
  fread(signature, 2, 1, pFile);
  if (strcmp(signature, "BM") != 0 && strcmp(signature, "BA") != 0 && strcmp(signature, "CI") != 0 &&
      strcmp(signature, "CP") != 0 && strcmp(signature, "IC") != 0 && strcmp(signature, "PT") != 0)
    return -1;

  int filesize = 0;
  fread(&filesize, 4, 1, pFile);
  if (filesize == 0)
  {
    fclose(pFile);
    return -1;
  }

  int reserve = 0;
  fread(&reserve, 4, 1, pFile);

  int offset = 0;
  fread(&offset, 4, 1, pFile);
  int paletteSize = offset - BmpFileHeaderSize - BmpDibHeaderSize;
  int imageSize = filesize - offset;
  if (paletteSize < 0 || imageSize < 0)
  {
    fclose(pFile);
    return -1;
  }

  int headerSize = 0;
  fread(&headerSize, 4, 1, pFile);
  if (headerSize != BmpDibHeaderSize)
  {
    fclose(pFile);
    return -1;
  }

  fread(&(pBmpInfo->width), 4, 1, pFile);
  fread(&(pBmpInfo->height), 4, 1, pFile);
  if (pBmpInfo->width == 0 || pBmpInfo->height == 0)
  {
    fclose(pFile);
    return -1;
  }

  int planesCount = 0;
  fread(&planesCount, 2, 1, pFile);
  if (planesCount != BmpPlanesCount)
  {
    fclose(pFile);
    return -1;
  }

  short int depth = 0;
  fread(&depth, 2, 1, pFile);
  switch (depth)
  {
  case 1: 
    pBmpInfo->type = BmpMono;
    break;
  case 8: 
    pBmpInfo->type = BmpGray;
    break;
  case 24: 
    pBmpInfo->type = BmpRgb;
    break;
  case 32: 
    pBmpInfo->type = BmpRgba;
    break;
  default:
    fclose(pFile);
    return -1;
  }

  pBmpInfo->stride = GetBytesPerLine(pBmpInfo);

  int compressType = 0;
  fread(&compressType, 4, 1, pFile);
  if (compressType != BmpCompressType)
  {
    fclose(pFile);
    return -1;
  }

  unsigned int readImageSize = 0;
  fread(&readImageSize, 4, 1, pFile);

  // reading DPI
  int xDPM = 0, yDPM = 0;
  fread(&xDPM, 4, 1, pFile);
  fread(&yDPM, 4, 1, pFile);
  pBmpInfo->xDPI = static_cast<float>(xDPM / BmpInchToMeter);
  pBmpInfo->yDPI = static_cast<float>(yDPM / BmpInchToMeter);

  int nColors = 0;  
  fread(&nColors, 4, 1, pFile);
  if (nColors * 4 != paletteSize)
  {
    fclose(pFile);
    return -1;
  }

  int nImpColors = 0;
  fread(&nImpColors, 4, 1, pFile);
  if (nImpColors != BmpImpColorsCount && nImpColors != nColors)
  {
    fclose(pFile);
    return -1;
  }

  fclose(pFile);
  return 0;
}

LIBBMP_API int BmpLoadImage(unsigned char *pBmpData, const BmpInfo* pBmpInfo, const char* pFileName)
{
  if (!pBmpData || !pBmpInfo || !pFileName)
    return -1;
  if (pBmpInfo->width == 0 || pBmpInfo->height == 0)
    return -1;

  FILE* pFile(fopen(pFileName, "rb"));
  if (pFile == 0)
    return -1;

  unsigned int offset = 0;
  fseek(pFile, 10, SEEK_SET);
  fread(&offset, 4, 1, pFile);
  if (offset < BmpFileHeaderSize + BmpDibHeaderSize)
  {
    fclose(pFile);
    return -1;
  }
  fseek(pFile, offset, SEEK_SET);

  int bytesPerPix = GetBytesPerPixel(pBmpInfo);
  int bytesPerLine = GetBytesPerLine(pBmpInfo);
  int step = bytesPerPix == 4 ? 2 : 1;

  unsigned char* pBuf = new unsigned char[bytesPerLine];
  for (int y = pBmpInfo->height - 1; y >= 0; --y)
  {
    fread(pBuf, bytesPerLine, 1, pFile);
    unsigned char* pLine = pBmpData + y * pBmpInfo->stride;

    if (bytesPerPix == 0) // Mono
    {
      memcpy(pLine, pBuf, bytesPerLine);
    }
    else if (bytesPerPix == 1)  // Gray
    {
      memcpy(pLine, pBuf, bytesPerLine);
    }
    else if (bytesPerPix == 3)  // BGR
    {
      for (int x = 0; x < pBmpInfo->width; ++x)
      {
        pLine[3 * x + 0] = pBuf[3 * x + 2];
        pLine[3 * x + 1] = pBuf[3 * x + 1];
        pLine[3 * x + 2] = pBuf[3 * x + 0];
      }
    }
    else if (bytesPerPix == 4)  // BGRA
    {
      for (int x = 0; x < pBmpInfo->width; ++x)
      {
        pLine[4 * x + 0] = pBuf[4 * x + 2];
        pLine[4 * x + 1] = pBuf[4 * x + 1];
        pLine[4 * x + 2] = pBuf[4 * x + 0];
        pLine[4 * x + 3] = pBuf[4 * x + 3];
      }
    }
  }

  delete [] pBuf;
  fclose(pFile);
  return 0;
}

LIBBMP_API int BmpSaveImage(unsigned char* pBmpData, const BmpInfo* pBmpInfo, const char* pFileName)
{
  if (!pBmpData || !pBmpInfo || !pFileName)
    return -1;

  int depth = 0;
  int bytesPerPix  = GetBytesPerPixel(pBmpInfo);
  int bytesPerLine = GetBytesPerLine(pBmpInfo);
  switch (pBmpInfo->type)
  {
  case BmpMono:
    depth = 1;
    break;
  case BmpGray:
    depth = 8;
    break;
  case BmpRgb: 
    depth = 24;
    break;
  case BmpRgba:
    depth = 32;
    break;
  }

  FILE* pFile(fopen(pFileName, "wb"));
  if (pFile == 0)
    return -1;

  int xDPM = 0, yDPM = 0;
  if (pBmpInfo->xDPI > 0)
    xDPM = static_cast<int>(pBmpInfo->xDPI * BmpInchToMeter + 0.5);
  if (pBmpInfo->yDPI > 0)
    yDPM = static_cast<int>(pBmpInfo->yDPI * BmpInchToMeter + 0.5);

  // palette (if need)
  int nColors = 0;
  int paletteSize = 0;
  int imageSize = pBmpInfo->height * pBmpInfo->stride;

  int offset   = BmpFileHeaderSize + BmpDibHeaderSize + paletteSize;
  int fileSize = offset + imageSize;

  if (pBmpInfo->type == BmpMono || pBmpInfo->type == BmpGray)
  {
    nColors = pBmpInfo->type == BmpMono ? 2 : 256;
    paletteSize = 4 * nColors;
    offset += paletteSize;
    fileSize += paletteSize;
  }

  // file header writing
  fwrite(&BmpSignature, 2, 1, pFile); // 0
  fwrite(&fileSize,     4, 1, pFile); // 2
  fwrite(&BmpReserve,   4, 1, pFile); // 4
  fwrite(&offset,       4, 1, pFile); // 8

  //  dib header writing
  fwrite(&BmpDibHeaderSize,   4, 1, pFile); // 14
  fwrite(&(pBmpInfo->width),  4, 1, pFile); // 18
  fwrite(&(pBmpInfo->height), 4, 1, pFile); // 22
  fwrite(&BmpPlanesCount,     2, 1, pFile); // 26
  fwrite(&depth,              2, 1, pFile); // 28
  fwrite(&BmpCompressType,    4, 1, pFile); // 30
  fwrite(&imageSize,          4, 1, pFile); // 34
  fwrite(&xDPM,               4, 1, pFile); // 38
  fwrite(&yDPM,               4, 1, pFile); // 42
  fwrite(&nColors,            4, 1, pFile); // 46
  fwrite(&BmpImpColorsCount,  4, 1, pFile); // 50

  // bmp palette writing
  if (pBmpInfo->type == BmpMono || pBmpInfo->type == BmpGray)
  {
    unsigned char* pColors = new unsigned char[paletteSize];
    int step = pBmpInfo->type == BmpMono ? 255 : 1;
    for (int i = 0; i < nColors; i++)
    {
      for (int j = 0; j < 3; j++)
        pColors[4 * i + j] = i * step;
      pColors[4 * i + 3]   = 0;
    }
    fwrite(pColors, paletteSize, 1, pFile);
    delete[] pColors;
  }

  int step = 0;
  if (pBmpInfo->type == BmpRgb || pBmpInfo->type == BmpGray)
    step = 1;
  else if (pBmpInfo->type == BmpRgba)
    step = 2;

  unsigned char* pBuf = new unsigned char[bytesPerLine];
  for (int y = pBmpInfo->height - 1; y >= 0; y--)
  {
    unsigned char* pLine = pBmpData + y * pBmpInfo->stride;
    memset(pBuf, 0, bytesPerLine);

    if (pBmpInfo->type == BmpMono)
    {
      memcpy(pBuf, pLine, bytesPerLine);
    }
    else if (pBmpInfo->type == BmpGray)
    {
      memcpy(pBuf, pLine, bytesPerLine);
    }
    else if (pBmpInfo->type == BmpRgb)
    {
      for (int x = 0; x < pBmpInfo->width; x++)
      {
        pBuf[3 * x + 0] = pLine[3 * x + 2];
        pBuf[3 * x + 1] = pLine[3 * x + 1];
        pBuf[3 * x + 2] = pLine[3 * x + 0];
      }
    }

    else if (pBmpInfo->type == BmpRgba)
    {
      for (int x = 0; x < pBmpInfo->width; x++)
      {
        pBuf[4 * x + 0] = pLine[4 * x + 2];
        pBuf[4 * x + 1] = pLine[4 * x + 1];
        pBuf[4 * x + 2] = pLine[4 * x + 0];
        pBuf[4 * x + 3] = pLine[4 * x + 3];
      }
    }

    fwrite(pBuf, bytesPerLine, 1, pFile);
  }

  delete[] pBuf;
  fclose(pFile);
  return 0;
}
