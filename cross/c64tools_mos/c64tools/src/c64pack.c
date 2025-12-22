#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define SEEKBACK 256
#define MAXSTRING 255

int progresscount = 0;

int main(int argc, char **argv);
void progress(void);

int main(int argc, char **argv)
{
  FILE *in;
  FILE *out;
  unsigned short startadr;
  unsigned char codebuffer[16];
  unsigned char bits;
  int count;
  int bitcount;
  int codecount;
  int length;
  int c;
  int packlength = 0;
  unsigned char *inbuffer;
  int rawsave = 0;

  if (argc < 3)
  {
    printf("Usage: c64pack <inprg> <outprg> <switches>\n"
           "NOTE! These can be the same file!\n"
           "Use /r switch for raw data (no start address)\n");
    return 1;
  }
  for (c = 1; c < argc; c++)
  {
    if ((argv[c][0] == '-') || (argv[c][0] == '/'))
    {
      char shit = tolower(argv[c][1]);
      switch (shit)
      {
        case 'r':
        rawsave = 1;
        break;
      }
    }
  }
  in = fopen(argv[1], "rb");
  if (!in)
  {
    printf("Can't open source!\n");
    return 1;
  }
  if (!rawsave)
  {
    startadr = fgetc(in);
    startadr |= (fgetc(in) << 8);
    fseek(in, 0, SEEK_END);
    length = ftell(in) - 2;
    fseek(in, 2, SEEK_SET);
  }
  else
  {
    startadr = 0;
    fseek(in, 0, SEEK_END);
    length = ftell(in);
    fseek(in, 0, SEEK_SET);
  }

  inbuffer = malloc(length);
  if (!inbuffer)
  {
    printf("Out of memory!\n");
    return 1;
  }
  fread(inbuffer, length, 1, in);
  fclose(in);

  out = fopen(argv[2], "wb");
  if (!out)
  {
    printf("Can't open destination!\n");
    return 1;
  }
  if (!rawsave)
  {
    fputc(startadr & 255, out);
    fputc(startadr >> 8, out);
  }

  packlength = 0;
  bitcount = 0;
  codecount = 0;
  bits = 0;
  count = 0;

  for(;;)
  {
    if (count > 2)
    {
      unsigned char *seekstartptr = inbuffer;
      unsigned char *seekendptr = &inbuffer[count];
      unsigned char *seekptr;
      int highestlen = 0;
      int highestpos = 0;
      int clen;
      int maxlen = count;

      if (count > SEEKBACK)
      {
        seekstartptr = &inbuffer[count-SEEKBACK];
      }
      if (count > MAXSTRING) maxlen = MAXSTRING;

      while (seekstartptr < seekendptr)
      {
        clen = 0;
        seekptr = seekstartptr;

        for (;;)
        {
          if ((*seekptr == inbuffer[count+clen]) && (clen < maxlen))
          {
            clen++;
            seekptr++;
          }
          else
          {
            if (clen > 1)
            {
              if (clen > highestlen)
              {
                highestlen = clen;
                highestpos = (int)(seekstartptr) - (int)(&inbuffer[count-SEEKBACK]);
              }
            }
            break;
          }
        }
        if (clen) seekstartptr += clen;
        else seekstartptr++;
      }
      if (highestlen > 2)
      {
        codebuffer[codecount] = highestpos;
        codebuffer[codecount+1] = highestlen;
        codecount += 2;
        bits |= 1 << bitcount;
        bitcount++;
        count += highestlen;
      }
      else
      {
        codebuffer[codecount] = inbuffer[count];
        codecount++;
        bitcount++;
        count++;
      }
    }
    else
    {
      codebuffer[codecount] = inbuffer[count];
      codecount++;
      bitcount++;
      count++;
    }
    if (bitcount == 8)
    {
      fputc(bits, out);
      fwrite(codebuffer, codecount, 1, out);
      packlength += 1 + codecount;
      progress();
      fflush(stdout);
      bitcount = 0;
      codecount = 0;
      bits = 0;
    }
    if (count >= length) break;
  }
  if (codecount)
  {
    fputc(bits, out);
    fwrite(codebuffer, codecount, 1, out);
    packlength += 1 + codecount;
    progress();
    fflush(stdout);
  }
  fclose(out);
  printf("\nOriginal size:%d Packed size:%d\n", length, packlength);
  return 0;
}

void progress(void)
{
  progresscount++;
  if (progresscount == 8)
  {
    progresscount = 0;
    printf(".");
    fflush(stdout);
  }
}

