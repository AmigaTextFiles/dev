/*
 * Covert Depacker.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define PACKBUFFERSIZE 256

#define MAXOUTPUT 4*65536

unsigned char *inbuffer;
unsigned char *outbuffer;

FILE *in;
FILE *out;
int length, c, d, e;
unsigned char depackbits = 0;
unsigned char src = 0, dest = 0;

int inbytes = 0;
int outbytes = 0;

int main(int argc, char **argv);

int main(int argc, char **argv)
{
  if (argc < 3)
  {
    printf("Usage: cdepack <in> <out>\n");
    return 1;
  }

  in = fopen(argv[1], "rb");
  if (!in)
  {
    return 0;
  }
  inbuffer = malloc(MAXOUTPUT);
  outbuffer = malloc(MAXOUTPUT);

  if ((!inbuffer) || (!outbuffer))
  {
    printf("Out of memory\n");
    return 1;
  }

  fseek(in, 0, SEEK_END);
  length = ftell(in);
  fseek(in, 0, SEEK_SET);
  fread(inbuffer, length, 1, in);
  fclose(in);

  out = fopen(argv[2], "wb");
  if (!out)
  {
    printf("Destination open error\n");
    return 1;
  }
  for (;;)
  {
    int bit = depackbits & 1;
    depackbits >>= 1;
    if (!depackbits)
    {
      depackbits = inbuffer[inbytes];
      inbytes++;
      bit = depackbits & 1;
      depackbits >>= 1;
      depackbits |= 0x80;
    }
    if (!bit)
    {
      outbuffer[outbytes] = inbuffer[inbytes];
      outbytes++;
      inbytes++;
    }
    else
    {
      int length, index;
      if (inbuffer[inbytes] >= 0x80)
      {
        index = inbuffer[inbytes];
        inbytes++;
        length = 2;
      }
      else
      {
        length = inbuffer[inbytes];
        inbytes++;
        index = inbuffer[inbytes];
        inbytes++;
        if (!length) break; /* EOF */
      }
      while(length)
      {
        outbuffer[outbytes] = outbuffer[outbytes-256+index];
        outbytes++;
        length--;
      }
    }
  }
  fwrite(outbuffer, outbytes, 1, out);
  printf("In: %d Out: %d\n", inbytes, outbytes);
  fclose(out);
  return 0;
}
