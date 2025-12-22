#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  FILE *in;
  FILE *out;
  FILE *out2;
  int count;

  if (argc < 5)
  {
    printf("Usage: filespli <in1> <out1> <out2> <splitpoint>\n");
    return 1;
  }

  in = fopen(argv[1], "rb");
  if (!in)
  {
    printf("Source open error\n");
    return 1;
  }

  out = fopen(argv[2], "wb");
  if (!out)
  {
    printf("Destination open error\n");
    return 1;
  }

  out2 = fopen(argv[3], "wb");
  if (!out2)
  {
    printf("Destination open error\n");
    return 1;
  }

  sscanf(argv[4], "%d", &count);

  while(count--)
  {
    int b = fgetc(in);
    if (b < 0) break;
    fputc(b, out);
  }

  for(;;)
  {
    int b = fgetc(in);
    if (b < 0) break;
    fputc(b, out2);
  }
  fclose(in);
  fclose(out);
  fclose(out2);
  return 0;
}



