/*
 * Extract a program file from a D64 image
 * by Cadaver
 */

#include <libraries/dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include <sys/stat.h>

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
  char noheader = 0;

  int d64handle, prghandle;
  char *d64buf;
  char *ptr;

  if (argc < 4)
  {
    printf("Usage: D642PRG <diskimage> <c64 filename> <dos filename>\n\n"
           "Use _ to represent spaces in the c64 filename. Use -h switch after the\n"
           "to skip the startaddress.\n");
    return 1;
  }

  if (argc > 4)
  {
    for (c = 4; c < argc; c++)
    {
/*   strupr(argv[c]); */
      if ((argv[c][0] == '-') || (argv[c][0] == '/'))
      {
        switch(argv[c][1])
        {
          case 'H':
          noheader = 1;
          case 'h':
          noheader = 1;
          break;
         }
      }
    }
  }

  d64handle = Open(argv[1], MODE_OLDFILE);
/*  strupr(argv[2]); */
  if (d64handle == -1)
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

  prghandle = Open(argv[3], MODE_NEWFILE);
  if (!prghandle)
  {
    Close(d64handle);
    printf("Couldn't open destination.\n");
    return 1;
  }
  Read(d64handle,d64buf,174848);
  Close(d64handle);

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
    for (c = 0; c<16;c++)
    {
      if (ptr[ofs+3+c] == 0xa0) ptr[ofs+3+c] = 0x5f;
      if (ptr[ofs+3+c] == 0x20) ptr[ofs+3+c] = 0x5f;
    }
    ptr[ofs+3+16] = 0;

    /* Onko PRG */
    if ((ptr[ofs] & 0x83)==0x82)
    {
      int a;
      int err = 0;
      /* Onko nimi oikea */
      for (a = 0; a < strlen(argv[2]); a++)
      {
        if (ptr[ofs+3+a] != argv[2][a])
        {
          err = 1;
          break;
        }
      }
      if (!err)
      {
        printf("Found on track %d sector %d\n", ptr[ofs+1],ptr[ofs+2]);
        ptr = &d64buf[getoffset(ptr[ofs+1],ptr[ofs+2])];
        for (;;)
        {
          /* Oliko t„m„ blokki viimeinen? */
          if (ptr[0])
          {
            /* Ei, kirjoitetaan t„ydet 254 tavua */
            if (!noheader)
            {
              Write(prghandle, &ptr[2], 254);
            }
            else
            {
              Write(prghandle, &ptr[4], 252);
              noheader = 0;
            }
            ptr = &d64buf[getoffset(ptr[0],ptr[1])];
            printf(".");
            fflush(stdout);
          }
          else
          {
            if (!noheader)
            {
              Write(prghandle, &ptr[2], ptr[1]-1);
            }
            else
            {
              Write(prghandle, &ptr[4], ptr[1]-3);
              noheader = 0;
            }
            printf(".\n");
            break;
          }
        }
        printf("File extracted successfully.\n");
        Close(prghandle);
        return 0;
      }
    }
    ofs += 32;
    if (ofs >= 256)
    {
      /* Otetaan seuraava dir. blokki */
      if (ptr[0])
      {
        printf("..Next directory block..\n");
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


