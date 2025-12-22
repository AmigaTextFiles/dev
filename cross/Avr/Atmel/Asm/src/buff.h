struct MemBuffer{
                  BYTE *Buffer;
                  ULONG Offset;
                  ULONG Used;
                  ULONG Buff_Size;
};

typedef struct MemBuffer MEMBUFF;

int BuffEOF(struct MemBuffer *Buf);
int BuffPutS(const char *s, struct MemBuffer *Buf);
char *BuffGetS(char *s, int n, struct MemBuffer *Buf);
int BuffGetC(struct MemBuffer *Buf);
int BuffPutC(BYTE Ch, struct MemBuffer *Buf);
void BuffRewind(struct MemBuffer *Buf);
void KillBuffer(struct MemBuffer *Buf);
struct MemBuffer *OpenBuffer(void);
void BuffDump(char *Filename, struct MemBuffer *Buf);
