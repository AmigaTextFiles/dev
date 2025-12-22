/*
 * Rename a program file in a D64 image
 * by Cadaver
 *
 * Use a 32bit compiler because this proggy loads the entire disk at once!
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int snumtable[] =
{
  21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,
  19,19,19,19,19,19,19,
  18,18,18,18,18,18,
  17,17,17,17,17
};

int firstsecttbl[35];

int main(int argc, char **argv);
int getoffset(int track, int sector);


int main(int argc, char **argv)
{
  int c,s;
  int ofs;

  FILE *d64handle;
  char *d64buf;
  char *ptr;

  if (argc < 4)
  {
    printf("Usage: d64ren <d64 image name> <old name> <new name>\n"
           "Use _ to represent spaces in the filename.\n");
    return 1;
  }

  d64handle = fopen(argv[1], "rb");
  if (!d64handle)
  {
    printf("Couldn't open d64 image.\n");
    return 1;
  }

  d64buf = malloc(174848);
  if (!d64buf)
  {
    printf("No memory for d64 image.\n");
    return 1;
  }

  fread(d64buf,174848,1,d64handle);
  fclose(d64handle);

  s = 0;
  for (c = 0; c < 35; c++)
  {
    firstsecttbl[c] = s;
    s += snumtable[c];
  }

  ptr = &d64buf[getoffset(18,1)];
  ofs = 2;

  for (;;)
  {
    ptr[ofs+3+16] = 0;

    if ((ptr[ofs] & 0x83)==0x82)
    {
      int a;
      int err = 0;
      for (a = 0; a < strlen(argv[2]); a++)
      {
        c = ptr[ofs+3+a];
        if (c == 0xa0) c = 0x5f;
        if (c == 0x20) c = 0x5f;
        if (toupper(ptr[ofs+3+a]) != toupper(argv[2][a]))
        {
          err = 1;
          break;
        }
      }
      if (!err)
      {
        for (a = 0; a < strlen(argv[3]); a++)
        {
          c = argv[3][a];
          if (c == 0x5f) c = 0x20;
          ptr[ofs+3+a] = c;
        }
        for (; a < 16; a++)
        {
          ptr[ofs+3+a] = 0xa0;
        }
        d64handle = fopen(argv[1], "wb");
        if (d64handle)
        {
          fwrite(d64buf, 174848, 1, d64handle);
          fclose(d64handle);
          printf("File name changed.\n");
          return 0;
        }
        else return 1;
      }
    }
    ofs += 32;
    if (ofs >= 256)
    {
      if (ptr[0])
      {
        ptr = &d64buf[getoffset(ptr[0],ptr[1])];
        ofs = 2;
      }
      else
      {
        printf("File not found.\n");
        return 1;
      }
    }
  }
}




int getoffset(int track, int sector)
{
  int offset;
  track--;
  offset = (firstsecttbl[track]+sector)*256;
  return offset;
}


