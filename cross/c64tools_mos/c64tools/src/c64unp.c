#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
  unsigned char bits;
  int count;
  int bitcount;
  int outcount;
  int length;
  unsigned char *inbuffer;
  unsigned char *outbuffer;

  if (argc < 3)
  {
    printf("Usage: c64unp <inprg> <outprg>\n"
           "NOTE! These can be the same file!\n");
    return 1;
  }
  in = fopen(argv[1], "rb");
  if (!in)
  {
    printf("Can't open source!\n");
    return 1;
  }
  startadr = fgetc(in);
  startadr |= (fgetc(in) << 8);
  fseek(in, 0, SEEK_END);
  length = ftell(in) - 2;
  fseek(in, 2, SEEK_SET);
  inbuffer = malloc(length);
  if (!inbuffer)
  {
    printf("Out of memory - source!\n");
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
  outbuffer = malloc(65536);
  if (!outbuffer)
  {
    printf("Out of memory - destination!\n");
    return 1;
  }
  fputc(startadr & 255, out);
  fputc(startadr >> 8, out);
  printf("Fucking up...\n");

  bitcount = 8;
  bits = 0;
  count = 0;
  outcount = 0;

  for(;;)
  {
    if (bitcount > 7)
    {
      bits = inbuffer[count];
      bitcount = 0;
      count++;
    }
    else
    {
      if ((bits >> bitcount) & 1)
      {
        int stringpos = inbuffer[count];
        int stringlen = inbuffer[count+1];
        count += 2;

        printf("String of pos %d len %d\n", outcount-256+stringpos, stringlen);
        while (stringlen--)
        {
          outbuffer[outcount] = outbuffer[outcount-256+stringpos];
          outcount++;
          progress();
        }
      }
      else
      {
        outbuffer[outcount] = inbuffer[count];
        count++;
        outcount++;
        progress();
      }
      bitcount++;
    }
    if (count >= length) break;
  }
  fwrite(outbuffer, outcount, 1, out);
  fclose(out);
  printf("\nPacked size:%d Original size:%d\n", length, outcount);
  return 0;
}

void progress(void)
{
  progresscount++;
  if (progresscount == 8)
  {
    progresscount = 0;
    printf(".\n");
  }
}

