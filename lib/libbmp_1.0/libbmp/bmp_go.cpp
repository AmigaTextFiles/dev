#include "bmp.h"
#include <stdio.h>

int usage()
{
  printf("This app show how to read bmp images, operate with pixels and write back\n");
  printf("usage: bmp_go <src-bmp-image> <dst-bmp-image>\n");
  return 0;
}

int main(int argc, char* argv[])
{
  if (argc < 3)
    return usage();

  BmpInfo info = {0};
  BmpGetInfo(&info, argv[1]);

  unsigned char* pBmpData = new unsigned char[info.height * info.stride];
  BmpLoadImage(pBmpData, &info, argv[1]);

  // revert pixel values
  for (int y = 0; y < info.height; ++y)
  {
    unsigned char* pLine = pBmpData + info.stride * y;
    // separately for each channels in colorede images
    for (int x = 0; x < info.width; ++x)
      pLine[x] = 255 - pLine[x];
  }

  BmpSaveImage(pBmpData, &info, argv[2]);

  delete [] pBmpData;
  return 0;
}