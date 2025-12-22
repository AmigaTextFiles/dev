#include <stdio.h>
#include <stdlib.h>

#define SEEKBACK 256
#define MAXSTRING 255

int workcount = 0;

int main(int argc, char **argv);
void counter(void);
char runstring[128];

int main(int argc, char **argv)
{
  FILE *in;
  FILE *bin;
  unsigned short loadadr;
  unsigned short runadr;
  unsigned char codebuffer[16];
  unsigned char bits;
  int count;
  int bitcount;
  int codecount;
  int length;
  int packlength = 0;
  unsigned char *inbuffer;

  if (argc < 4)
  {
    printf("Packs a .prg file and adds depacker\n");
    printf("Usage: packprg <inprg> <outprg> <startadr>\n");
    return 1;
  }
  in = fopen(argv[1], "rb");
  if (!in)
  {
    printf("Can't open source!\n");
    return 1;
  }
  sscanf(argv[3], "%hx", &runadr);
  loadadr = fgetc(in);
  loadadr |= (fgetc(in) << 8);
  fseek(in, 0, SEEK_END);
  length = ftell(in) - 2;
  fseek(in, 2, SEEK_SET);
  inbuffer = malloc(length);
  if (!inbuffer)
  {
    printf("Out of memory!\n");
    return 1;
  }
  fread(inbuffer, length, 1, in);
  fclose(in);

  bin = fopen("packed.bin", "wb");
  if (!bin)
  {
    printf("Can't create packed data file!\n");
    return 1;
  }

  packlength = 0;
  bitcount = 0;
  codecount = 0;
  bits = 0;
  count = 0;

  printf("Step 1: packing...\n");
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
            if (clen > 2)
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
      fputc(bits, bin);
      fwrite(codebuffer, codecount, 1, bin);
      packlength += 1 + codecount;
      counter();
      fflush(stdout);
      bitcount = 0;
      codecount = 0;
      bits = 0;
    }
    if (count >= length) break;
  }
  if (codecount)
  {
    fputc(bits, bin);
    fwrite(codebuffer, codecount, 1, bin);
    packlength += 1 + codecount;
    counter();
    fflush(stdout);
  }
  fclose(bin);
  printf("\nOriginal size:%d Packed size:%d\n", length, packlength);
  printf("Step 2: assembling...\n");
  sprintf(runstring, "dasm depack.s -o%s -v3 -p3 -DPACKLEN=$%04x -DLOADADR=$%04x -DSTARTADR=$%04x", argv[2], packlength, loadadr, runadr);
  printf("%s\n",runstring);
  return system(runstring);
}

void counter(void)
{
  workcount++;
  if (workcount == 8)
  {
    workcount = 0;
    printf(".");
    fflush(stdout);
  }
}

