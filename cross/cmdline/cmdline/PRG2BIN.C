#include <libraries/dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <io.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
  int handle;
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

  handle = Open(argv[1], MODE_OLDFILE);
  if (handle == -1)
  {
    printf("source open error\n");
    return 1;
  }
  length = Seek(handle, 0, SEEK_END);
  length = Seek(handle, 0, SEEK_END);
  length -= strip;
  buffer = malloc(length);
  if (!buffer)
  {
    printf("out of memory\n");
    return 1;
  }

  Seek(handle, strip, SEEK_SET);
  Read(handle, buffer, length);
  Close(handle);

  handle = Open(argv[2], MODE_NEWFILE);
  if (handle == -1)
  {
    printf("destination open error\n");
    return 1;
  }
  Write(handle, buffer, length);
  Close(handle);
  return 0;
}

