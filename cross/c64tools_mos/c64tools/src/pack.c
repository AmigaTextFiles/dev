#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  int val;
  FILE *in;
  FILE *out;
  char cmd[80];
  if (argc < 3) printf("pack <infile> <outfile> - invokes exomizer and adds startadr. $0000\n");
  in = fopen(argv[1], "rb");
  if (!in) return 0;
  out = fopen("temp.bin", "wb");
  if (!out) return 1;
  fputc(0, out);
  fputc(0, out);
  for(;;)
  {
    int c = fgetc(in);
    if (c == EOF) break;
    fputc(c, out);
  }
  fclose(in);
  fclose(out);
  sprintf(cmd, "exomizer -o %s -r %s", argv[2], "temp.bin");
  val = system(cmd);
  unlink("temp.bin");
  return val;
}
