#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  char header[5];
  int val;
  FILE *in;
  FILE *out;
  char cmd[80];
  if (argc < 3) printf("pmap <infile> <outfile> - invokes exomizer and adds startadr. $0000\n");
  in = fopen(argv[1], "rb");
  if (!in) return 0;
  out = fopen("temp.bin", "wb");
  if (!out) return 1;
  fputc(0, out);
  fputc(0, out);
  header[0] = fgetc(in);
  header[1] = fgetc(in);
  header[2] = fgetc(in);
  header[3] = fgetc(in);
  header[4] = fgetc(in);
  for(;;)
  {
    int c = fgetc(in);
    if (c == EOF) break;
    fputc(c, out);
  }
  fclose(in);
  fclose(out);
  sprintf(cmd, "exomizer -o %s -r %s", "temp2.bin", "temp.bin");
  val = system(cmd);
  unlink("temp.bin");
  in = fopen("temp2.bin", "rb");
  if (!in) return 1;
  out = fopen(argv[2], "wb");
  if (!out) return 1;
  fputc(header[0], out);
  fputc(header[1], out);
  fputc(header[2], out);
  fputc(header[3], out);
  fputc(header[4], out);
  for(;;)
  {
    int c = fgetc(in);
    if (c == EOF) break;
    fputc(c, out);
  }
  fclose(in);
  fclose(out);
  unlink("temp2.bin");
  return val;
}
