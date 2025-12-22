#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  FILE *in, *out;
  int c = 0;

  if (argc < 3) return 1;

  in = fopen(argv[1], "rb");
  out = fopen(argv[2], "wt");

  for (;;)
  {
    int ch = fgetc(in);
    if (ch == EOF) break;

    if (c) fprintf(out, ",");
    if ((c%40) == 0) fprintf(out, "\n");
    fprintf(out, "$%02x", ch);
    c++;
  }
  fclose(in);
  fclose(out);
  return 0;
}
