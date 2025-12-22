
struct XRefSubFileNode;

struct XRefNode
{
  UWORD File;
  UWORD Line;
  BYTE  Type;
  char  Name[1];
};

extern struct XRefNode **XRefArray;
extern long   XRefArrayLast;

char *GetFileName(UWORD File,char *buf,size_t len);
char *GetShortFileName(UWORD File,char *buf,size_t len);
long SearchNameCase(char *Name,long* number);
long SearchNameNoCase(char *Name,long* number);
long SearchStartOfNameNoCase(char *Name,long* number);
BOOL ReadXRef(char *xreffilename);
void FreeXRefs(void);

