#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define SEEKBACK 256
#define MAXSTRING 127

int main(int argc, char **argv);

int main(int argc, char **argv)
{
  FILE *in;
  FILE *out;
  unsigned char codebuffer[16];
  unsigned char bits;
  int count;
  int bitcount;
  int codecount;
  int length;
  int packlength;
  unsigned char *inbuffer;

  if (argc < 3)
  {
    printf("Usage: cpack <in> <out>\n");
    return 1;
  }
  in = fopen(argv[1], "rb");
  if (!in)
  {
    printf("Can't open source!\n");
    return 0;
  }

  fseek(in, 0, SEEK_END);
  length = ftell(in);
  fseek(in, 0, SEEK_SET);

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
      if (length - count < maxlen) maxlen = length - count;

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
                highestpos = ((int)(seekstartptr) - (int)(&inbuffer[count-SEEKBACK]));
              }
            }
            break;
          }
        }
        if (clen) seekstartptr += clen;
        else seekstartptr++;
      }
      if (highestlen > 1)
      {
        if (highestlen != 2)
        {
          codebuffer[codecount] = highestlen;
          codebuffer[codecount+1] = highestpos;
          codecount += 2;
          bits |= 1 << bitcount;
          bitcount++;
          count += highestlen;
        }
        else
        {
          if (highestpos >= 0x80)
          {
            codebuffer[codecount] = highestpos;
            codecount += 1;
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
      fflush(stdout);
      bitcount = 0;
      codecount = 0;
      bits = 0;
    }
    if (count >= length) break;
  }
  codebuffer[codecount] = 0;
  codecount++;
  bits |= 1 << bitcount;
  if (codecount)
  {
    fputc(bits, out);
    fwrite(codebuffer, codecount, 1, out);
    packlength += 1 + codecount;
    fflush(stdout);
  }
  fclose(out);
  printf("In:%d Out:%d\n", length, packlength);
  return 0;
}

