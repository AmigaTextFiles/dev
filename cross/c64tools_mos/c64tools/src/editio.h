#ifdef __WIN32__
#include <io.h>
#include <sys/stat.h>
#include <fcntl.h>
#else
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#define O_BINARY 0
#endif

void write8(int handle, unsigned data);
void writele16(int handle, unsigned data);
void writele32(int handle, unsigned data);

void write8(int handle, unsigned data)
{
  char bytes[1];

  bytes[0] = data;
  write(handle, bytes, 1);
}

void writele16(int handle, unsigned data)
{
  char bytes[2];

  bytes[0] = data;
  bytes[1] = data >> 8;
  write(handle, bytes, 2);
}

void writele32(int handle, unsigned data)
{
  char bytes[4];

  bytes[0] = data;
  bytes[1] = data >> 8;
  bytes[2] = data >> 16;
  bytes[3] = data >> 24;
  write(handle, bytes, 4);
}
