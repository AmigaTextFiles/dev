#include <stdio.h>
#include <stdlib.h>

typedef unsigned char BYTE;
typedef unsigned long ULONG;

#include "buff.h"

#define BUFFCHUNK_SIZE  8192

int BuffEOF(struct MemBuffer *Buf)
{
  if (Buf->Offset >= Buf->Used)
  {
    return 1;
  }
  return 0;
}

int BuffPutS(const char *s, struct MemBuffer *Buf)
{
  while(*s)
  {
    if (BuffPutC(*s, Buf) == 0) return(-1);
    s++;
  }
  return(1);
}

char *BuffGetS(char *s, int n, struct MemBuffer *Buf)
{
  char *p=s;
  int k;

  do
  {
    k=BuffGetC(Buf);
    if (k == -1) return (NULL);
    *p++=k;
  }while( (--n) && (k!='\n') );
  *p++=0;
  return(s);
}

int BuffGetC(struct MemBuffer *Buf)
{
  BYTE Return;

  if (Buf->Offset >= Buf->Used)
  {
    return -1;
  }

  Return = Buf->Buffer[Buf->Offset];
  Buf->Offset++;
  return (Return);
}

int BuffPutC(BYTE Ch, struct MemBuffer *Buf)
{
  if (Buf == NULL)
  {
    return -1;
  }

  if (Buf->Buffer == NULL)   /*Allocate some memory for buffer*/
  {
    Buf->Buffer = (BYTE*)malloc(BUFFCHUNK_SIZE);
    if (Buf->Buffer == NULL)
    {
      return -1;
    }
    Buf->Offset = 0;
    Buf->Used = 0;
    Buf->Buff_Size = BUFFCHUNK_SIZE;
  }

  Buf->Buffer[Buf->Offset] = Ch;
  Buf->Offset++;
  if (Buf->Offset > Buf->Used)
  {
    Buf->Used = Buf->Offset;
  }
  if (Buf->Offset >= Buf->Buff_Size )
  {
    BYTE *Tmp;
    Tmp = (BYTE*)realloc(Buf->Buffer, Buf->Buff_Size + BUFFCHUNK_SIZE);
    if (Tmp == NULL)
    {
      return -1;
    }
    Buf->Buff_Size += BUFFCHUNK_SIZE;
    Buf->Buffer = Tmp;
  }
  return 1;
}

void BuffRewind(struct MemBuffer *Buf)
{
  if (Buf != NULL)
  {
    Buf->Offset = 0;
  }
}

void KillBuffer(struct MemBuffer *Buf)
{
  if(Buf != NULL)
  {
    if (Buf->Buffer != NULL)
    {
      free(Buf->Buffer);
    }
    free(Buf);
  }
}

struct MemBuffer *OpenBuffer(void)
{
  struct MemBuffer *Res;

  Res = (struct MemBuffer*)malloc(sizeof(struct MemBuffer));
  if (Res != NULL)
  {
    Res->Buffer = NULL;
    Res->Offset = 0;
    Res->Used = 0;
    Res->Buff_Size = 0;
  }
  return Res;
}

void BuffDump(char *Filename, struct MemBuffer *Buf)
{
  FILE *Out;
  ULONG Count;

  Out = fopen(Filename,"w");
  if (Out == NULL)
  {
    return;
  }

  for(Count=0; Count<Buf->Used; Count++)
  {
    fputc(Buf->Buffer[Count],Out);
  }
  fclose(Out);
}
