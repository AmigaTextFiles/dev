#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  FILE *handle;
  int length;
  int strip = 2;
  char *buffer;
  if (argc < 3)
  {
    printf("Usage: prg2bin <prg> <bin> [amount of bytes to strip, default 2]\n");
    return 1;
  }
  if (argc > 3)
  {
    sscanf(argv[3], "%d", &strip);
  }

  handle = fopen(argv[1], "rb");
  if (!handle)
  {
    printf("Source open error\n");
    return 1;
  }

  fseek(handle, 0, SEEK_END);
  length = ftell(handle);
  length -= strip;
  buffer = malloc(length);
  if (!buffer)
  {
    printf("out of memory\n");
    return 1;
  }

  fseek(handle, strip, SEEK_SET);
  fread(buffer, length, 1, handle);
  fclose(handle);

  handle = fopen(argv[2], "wb");
  if (!handle)
  {
    printf("Destination open error\n");
    return 1;
  }
  fwrite(buffer, length, 1, handle);
  fclose(handle);
  return 0;
}

