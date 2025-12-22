/*
 * BENTON INVERTOR for C64-pic -> sprite conversion!
 *
 * Use normal VGA 320x200 LBMs with colors 0-15 as normal C64 colors and
 * pixels twice the size in x-direction!
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <SDL/SDL_types.h>
#include "fileio.h"

typedef struct
{
  int sizex;
  int sizey;
  unsigned char *data;
  int red[256];
  int green[256];
  int blue[256];
} SCREEN;

/* Some headers for dealing with IFF files */
#define FORM 0x464f524d
#define ILBM 0x494c424d
#define PBM 0x50424d20
#define BMHD 0x424d4844
#define CMAP 0x434d4150
#define BODY 0x424f4459

int main(int argc, char **argv);
void countcolors(void);
int process(void);
Uint32 read_header(FILE *fd);
Uint32 find_chunk(FILE *fd, Uint32 type);
int load_pic(char *name);

/* Needed for ILBM loading (ugly "packed pixels") */
int poweroftwo[] = {1, 2, 4, 8, 16, 32, 64, 128, 256};
SCREEN sc;

int coloruse[16];

int bgcol = 0;
int multi1 = 0;
int multi2 = 0;
FILE *handle;
int rows = 0;
int columns = 0;
int x,y,c;
int startadr = 0xa000;
int rawsave = 0;
int singlecolor = 0;
int sprx = 4;
int spry = 3;

int main(int argc, char **argv)
{
  char *srcname = NULL;
  char *destname = NULL;

  printf("BENTON INVERTOR for C64-spritedata by Cadaver!\n");
  if (argc < 2)
  {
    printf("Usage: BENTON64 <lbm> <prg> + switches\n\n"
           "Switches are:\n"
           "/hXX Clip picture height to XX sprites\n"
           "/wXX Clip picture width to XX sprites\n"
           "/bXX Set background color to XX. Default 0.\n"
           "/mXX Set sprite multicolor 1 to XX.\n"
           "/nXX Set sprite multicolor 2 to XX.\n"
           "/sXX Set data start address in hex (default a000)\n"
           "/r   Raw save (no .PRG start address included)\n"
           "/1   Singlecolor\n");
    return 1;
  }

  printf("* PROCESSING COMMAND LINE\n");
  for (c = 1; c < argc; c++)
  {
    if ((argv[c][0] == '-') || (argv[c][0] == '/'))
    {
      char shit = tolower(argv[c][1]);
      switch (shit)
      {
        case 'h':
        sscanf(&argv[c][2], "%d", &spry);
        break;

        case 'w':
        sscanf(&argv[c][2], "%d", &sprx);
        break;

        case 'b':
        sscanf(&argv[c][2], "%d", &bgcol);
        break;

        case 'm':
        sscanf(&argv[c][2], "%d", &multi1);
        break;

        case 'n':
        sscanf(&argv[c][2], "%d", &multi2);
        break;

        case 's':
        sscanf(&argv[c][2], "%x", &startadr);
        break;

        case '1':
        singlecolor = 1;
        break;

        case 'r':
        rawsave = 1;
        break;
      }
    }
    else
    {
      if (srcname == NULL)
      {
        srcname = argv[c];
      }
      else
      {
        if (destname == NULL)
        {
          destname = argv[c];
        }
      }
    }
  }
  if ((!srcname) || (!destname))
  {
    printf("  Source & destination filenames needed!\n");
    return 1;
  }

  printf("* LOADING PICTURE\n");
  if (!load_pic(srcname))
  {
    printf("Shit happened!\n");
    return 1;
  }

  printf("* CREATING DESTINATION FILE\n");
  handle = fopen(destname, "wb");
  if (!handle)
  {
    printf("Shit happened!\n");
    return 1;
  }
  if (process())
  {
    printf("Out of memory while processing!\n");
    fclose(handle);
    return 1;
  }
  printf("* CLOSING DESTINATION & EXITING\n");
  fclose(handle);
  return 0;
}

int process(void)
{
  int row, col;
  unsigned char *pixptr;
  unsigned char *spritebuf = malloc(sprx*spry*64);

  if (!spritebuf)
  {
    return 1;
  }

  memset(spritebuf,0,sprx*spry*64);


  for (row = 0; row < spry; row++)
  {
    for (col = 0; col < sprx; col++)
    {
    if (!singlecolor)
    {
      pixptr = &spritebuf[row*sprx*64+col*64];
      for (y = 0; y < 21; y++)
      {
        for (x = 0; x < 12; x++)
        {
          char color = sc.data[(row*21+y)*sc.sizex+col*24+x*2];
          char decision = 0;
          char bitdata = 0;

          if (color == bgcol)
          {
            bitdata = 0x00;
            decision = 1;
          }
          if (color == multi1)
          {
            bitdata = 0x01;
            decision = 1;
          }
          if (color == multi2)
          {
            bitdata = 0x03;
            decision = 1;
          }
          if (!decision)
          {
            bitdata = 0x02;
            pixptr[63] = color;
          }

          pixptr[y*3+x/4] |= (bitdata << (6-(x%4)*2));
        }
      }
    }
    else
    {
      pixptr = &spritebuf[row*sprx*64+col*64];
      for (y = 0; y < 21; y++)
      {
        for (x = 0; x < 24; x++)
        {
          char color = sc.data[(row*21+y)*sc.sizex+col*24+x];
          char bitdata = 0;

          if (color == bgcol)
          {
            bitdata = 0x00;
          }
          else
          {
            bitdata = 0x01;
            pixptr[63] = color + 16;
          }

          pixptr[y*3+x/8] |= (bitdata << (7-(x%8)));
        }
      }
    }
    }
  }

  if (!rawsave) fwritele16(handle, startadr);
  fwrite(spritebuf, sprx*spry*64, 1, handle);

  return 0;
}

Uint32 read_header(FILE *fd)
{
  Uint32 type;

  /* Go to the beginning */
  fseek(fd, 0, SEEK_SET);

  /* Is it a FORM-type IFF file? */
  type = freadhe32(fd);
  if (type != FORM) return 0;

  /* Go to the identifier */
  fseek(fd, 8, SEEK_SET);
  type = freadhe32(fd);
  return type;
}

Uint32 find_chunk(FILE *fd, Uint32 type)
{
  Uint32 length, thischunk, thislength, pos;

  /* Get file length so we know how much data to go thru */
  fseek(fd, 4, SEEK_SET);
  length = freadhe32(fd) + 8;

  /* Now go to the first chunk */
  fseek(fd, 12, SEEK_SET);

  for (;;)
  {
    /* Read type & length, check for match */
    thischunk = freadhe32(fd);
    thislength = freadhe32(fd);
    if (thischunk == type)
    {
      return thislength;
    }

    /* No match, skip over this chunk (pad byte if odd size) */
    if (thislength & 1)
    {
      fseek(fd, thislength + 1, SEEK_CUR);
      pos = ftell(fd);
    }
    else
    {
      fseek(fd, thislength, SEEK_CUR);
      pos = ftell(fd);
    }

    /* Quit if gone to the end */
    if (pos >= length) break;
  }
  return 0;
}

int load_pic(char *name)
{
  FILE *fd = fopen(name, "rb");
  Uint32 type;

  /* Couldn't open */
  if (!fd) return 0;

  type = read_header(fd);

  /* Not an IFF file */
  if (!type)
  {
    fclose(fd);
    return 0;
  }

  switch(type)
  {
    case PBM:
    {
      if (find_chunk(fd, BMHD))
      {
        Uint16 sizex = freadhe16(fd);
        Uint16 sizey = freadhe16(fd);
        Uint8 compression;
        int colors = 256;
        Uint32 bodylength;

        /*
         * Hop over the "hotspot", planes & masking (stencil pictures are
         * always saved as ILBMs!
         */
        fseek(fd, 6, SEEK_CUR);
        compression = fread8(fd);
        fread8(fd);
        fread8(fd);
        fread8(fd);
        /*
         * That was all we needed of the BMHD, now the CMAP (optional hehe!)
         */
        if (find_chunk(fd, CMAP))
        {
          int count;
          for (count = 0; count < colors; count++)
          {
            sc.red[count] = fread8(fd) >> 2;
            sc.green[count] = fread8(fd) >> 2;
            sc.blue[count] = fread8(fd) >> 2;
          }
        }
        /*
         * Now the BODY chunk, this is important!
         */
        bodylength = find_chunk(fd, BODY);

        if (bodylength)
        {
          sc.sizex = sizex;
          sc.sizey = sizey;
          sc.data = malloc(sc.sizex * sc.sizey);
          if (!sc.data)
          {
            fclose(fd);
            return 0;
          }
          if (!compression)
          {
            int ycount;
            for (ycount = 0; ycount < sizey; ycount++)
            {
              fread(&sc.data[sc.sizex * ycount], sizex, 1, fd);
            }
          }
          else
          {
            int ycount;

            char *ptr = malloc(bodylength);
            char *origptr = ptr;
            if (!ptr)
            {
              fclose(fd);
              return 0;
            }

            fread(ptr, bodylength, 1, fd);

            /* Run-length encoding */
            for (ycount = 0; ycount < sizey; ycount++)
            {
              int total = 0;
              while (total < sizex)
              {
                signed char decision = *ptr++;
                if (decision >= 0)
                {
                  memcpy(&sc.data[sc.sizex * ycount + total], ptr, decision + 1);
                  ptr += decision + 1;
                  total += decision + 1;
                }
                if ((decision < 0) && (decision != -128))
                {
                  memset(&sc.data[sc.sizex * ycount + total], *ptr++, -decision + 1);
                  total += -decision + 1;
                }
              }
            }
            free(origptr);
          }
        }
      }
    }
    break;

    case ILBM:
    {
      if (find_chunk(fd, BMHD))
      {
        Uint16 sizex = freadhe16(fd);
        Uint16 sizey = freadhe16(fd);
        Uint8 compression;
        Uint8 planes;
        Uint8 mask;
        int colors;
        Uint32 bodylength;

        /*
         * Hop over the "hotspot"
         */
        fseek(fd, 4, SEEK_CUR);
        planes = fread8(fd);
        mask = fread8(fd);
        compression = fread8(fd);
        fread8(fd);
        fread8(fd);
        fread8(fd);
        colors = poweroftwo[planes];
        if (mask > 1) mask = 0;
        /*
         * That was all we needed of the BMHD, now the CMAP (optional hehe!)
         */
        if (find_chunk(fd, CMAP))
        {
          int count;
          for (count = 0; count < 256; count++)
          {
            sc.red[count] = 0;
            sc.green[count] = 0;
            sc.blue[count] = 0;
          }
          sc.red[255] = 255;
          sc.green[255] = 255;
          sc.blue[255] = 255;
          for (count = 0; count < colors; count++)
          {
            sc.red[count] = fread8(fd) >> 2;
            sc.green[count] = fread8(fd) >> 2;
            sc.blue[count] = fread8(fd) >> 2;
          }
        }
        /*
         * Now the BODY chunk, this is important!
         */
        bodylength = find_chunk(fd, BODY);

        if (bodylength)
        {
          char *ptr;
          char *origptr;
          char *unpackedptr;
          char *workptr;
          int ycount, plane;
          int bytes, dbytes;

          sc.sizex = sizex;
          sc.sizey = sizey;
          sc.data = malloc(sc.sizex * sc.sizey);
          memset(sc.data, 0, sc.sizex * sc.sizey);
          if (!sc.data)
          {
            fclose(fd);
            return 0;
          }
          origptr = malloc(bodylength * 2);
          ptr = origptr;
          if (!origptr)
          {
            fclose(fd);
            return 0;
          }
          fread(origptr, bodylength, 1, fd);
          if (compression)
          {
            dbytes = sizey * (planes + mask) * ((sizex + 7) / 8);
            unpackedptr = malloc(dbytes);
            workptr = unpackedptr;
            if (!unpackedptr)
          {
        fclose(fd);
        return 0;
      }
            bytes = 0;
            while (bytes < dbytes)
            {
              signed char decision = *ptr++;
              if (decision >= 0)
              {
                memcpy(workptr, ptr, decision + 1);
                workptr += decision + 1;
                ptr += decision + 1;
                bytes += decision + 1;
              }
              if ((decision < 0) && (decision != -128))
              {
                memset(workptr, *ptr++, -decision + 1);
                workptr += -decision + 1;
                bytes += -decision + 1;
              }
            }
            free(origptr);
            origptr = unpackedptr;
            ptr = unpackedptr;
          }
          for (ycount = 0; ycount < sizey; ycount++)
          {
            for (plane = 0; plane < planes; plane++)
            {
              int xcount = (sizex + 7) / 8;
              int xcoord = 0;
              while (xcount)
              {
                if (*ptr & 128) sc.data[sc.sizex * ycount + xcoord + 0] |= poweroftwo[plane];
                if (*ptr & 64 ) sc.data[sc.sizex * ycount + xcoord + 1] |= poweroftwo[plane];
                if (*ptr & 32 ) sc.data[sc.sizex * ycount + xcoord + 2] |= poweroftwo[plane];
                if (*ptr & 16 ) sc.data[sc.sizex * ycount + xcoord + 3] |= poweroftwo[plane];
                if (*ptr & 8  ) sc.data[sc.sizex * ycount + xcoord + 4] |= poweroftwo[plane];
                if (*ptr & 4  ) sc.data[sc.sizex * ycount + xcoord + 5] |= poweroftwo[plane];
                if (*ptr & 2  ) sc.data[sc.sizex * ycount + xcoord + 6] |= poweroftwo[plane];
                if (*ptr & 1  ) sc.data[sc.sizex * ycount + xcoord + 7] |= poweroftwo[plane];
                ptr++;
                xcoord += 8;
                xcount--;
              }
            }
            if (mask)
            {
              ptr += (sizex + 7) / 8;
            }
          }
          free(origptr);
        }
      }
    }
    break;
  }
  fclose(fd);
  return 1;
}




