
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <proto/dos.h>
#include <proto/exec.h>

#include "xref_gen.h"
#include "xref_read.h"

#include "Main.h"

/***********************************************/

struct XRefBigDirNode
{
  char Name[1];
};

static struct XRefBigDirNode **BDNArray = NULL;
static long   BDNArrayLast = -1;

struct XRefSubFileNode
{
  char Name[1];
};

static struct XRefSubFileNode **XSFArray = NULL;
static long   XSFArrayLast = -1;
/*
struct XRefNode
{
  UWORD File;
  UWORD Line;
  BYTE  Type;
  char  Name[1];
};
*/
struct XRefNode **XRefArray = NULL;
long   XRefArrayLast = -1;
long   XRefArrayCurrent = 0;

static char *CurrentSource;
static FILE *CurrentFile;
static long CurrentLine;

/***********************************************/

static struct
{
  char *Name;
  long File;
  char *Father;
  long Line;
  long Type;
}   Line;

/***********************************************/

#define MYPOOLSIZE (20*1024)

struct XMemList
{
  struct XMemList *next;
  char *mymemalloc;
};

static long PosInMyPool = 0;
static struct XMemList *XRefMemList = NULL;

/***********************************************/

void *myalloc(size_t sz)
{
  if (!XRefMemList || ((PosInMyPool + sz) >= MYPOOLSIZE))
  {
    struct XMemList *new = malloc(sizeof(struct XMemList) + MYPOOLSIZE);
    if (new)
    {
      new->next = XRefMemList;
      new->mymemalloc = (char *) (&new[1]);
      XRefMemList = new;
      PosInMyPool = 0;
    }
  }
  if (XRefMemList && ((PosInMyPool + sz) < MYPOOLSIZE))
  {
    void *ma = (void *) &XRefMemList->mymemalloc[PosInMyPool];
    PosInMyPool += sz;
    return ( ma );
  }
  return (NULL);
}

/***********************************************/

void freemyallocs(void)
{
  struct XMemList *nextnode, *list;
  list = XRefMemList;
  while (list)
  {
    nextnode = list->next;
    free(list);
    list = nextnode;
  }
  XRefMemList = NULL;
  PosInMyPool = 0;
}

/***********************************************/

static BOOL AddBigDir(char *PathName, char Letter)
{
  char letterpos = Letter - 'A';
  if ((PathName != NULL) && (PathName[0] != '\0') && (letterpos >= 0) && (letterpos <= BDNArrayLast))
  {
    if (BDNArray[letterpos] = myalloc(sizeof(struct XRefBigDirNode) + strlen(PathName)))
    {
      stpcpy(BDNArray[letterpos]->Name, PathName);
      return (TRUE);
    }
  }
  return (FALSE);
}

/***********************************************/

static BOOL AddSubFile(char *FileName,UWORD FileNum)
{
  if ((FileName != NULL) && (FileName[0] != '\0') && (FileNum <= XSFArrayLast))
  {
    if (XSFArray[FileNum] = myalloc(sizeof(struct XRefSubFileNode) + strlen(FileName)))
    {
      stpcpy(XSFArray[FileNum]->Name, FileName);
      return (TRUE);
    }
  }
  return (FALSE);
}

/***********************************************/

static BOOL AddXRef(char *XRefStr,UWORD FileNum,UWORD LineNum, BYTE TypeNum)
{
  if ((XRefStr != NULL) && (XRefStr[0] != '\0') && (XRefArrayCurrent <= XRefArrayLast) && (FileNum <= XSFArrayLast))
  {
    if (XRefArray[XRefArrayCurrent] = myalloc(sizeof(struct XRefNode) + strlen(XRefStr)))
    {
      stpcpy(XRefArray[XRefArrayCurrent]->Name, XRefStr);
      XRefArray[XRefArrayCurrent]->File = FileNum;
      XRefArray[XRefArrayCurrent]->Line = LineNum;
      XRefArray[XRefArrayCurrent]->Type = TypeNum;
      XRefArrayCurrent++;
      return (TRUE);
    }
  }
  return (FALSE);
}


/***********************************************/

/* someting like that should be used to get complete file name :
  char realname[200];

  GetCompleteName(Name,realname,200);
*/

static char *GetCompleteName(char *Name,char *buf,size_t len)
{
  long curnum;

  if ((Name != NULL) && (strlen(Name) > 1) && (buf != NULL))
  {
    curnum = (long) (*Name - 'A');
    if ((curnum >= 0) && (curnum <= BDNArrayLast) && strlen(BDNArray[curnum]->Name) + strlen(Name) < len)
    {
      stpcpy(stpcpy(buf, BDNArray[curnum]->Name),&Name[1]);
      return (buf);
    }
  }
  return (Name);
}

/***********************************************/

/* someting like that should be used to get (complete) file name :
  char realname[200];

  GetFileName(File,realname,200);
*/

char *GetFileName(UWORD File,char *buf,size_t len)
{
  if ((File <= XSFArrayLast) && XSFArray[File] && buf && (len > 1))
    return (GetCompleteName(XSFArray[File]->Name,buf,len));
  else
    return (NULL);
}

/***********************************************/

/* someting like that should be used to get file name :
  char realname[200];

  GetShortFileName(File,realname,200);
*/

char *GetShortFileName(UWORD File,char *buf,size_t len)
{
  if ((File <= XSFArrayLast) && XSFArray[File] && buf && (len > 1))
  {
    strncpy(buf,&XSFArray[File]->Name[1],len);
    buf[len-1] = '\0';
    return (buf);
  }
  else
    return (NULL);
}

/***********************************************/

long SearchNameCase(char *Name,long* number)
{
  long Upper, Lower;
  long Index,I2,I3;
  long OldIndex;
  long Result;

  *number = 0;
  if (XRefArray && (strlen(Name) > 0))
  {
    Lower = 0;
    Upper = XRefArrayLast + 1;
    Index = 0;
    do
    {
      OldIndex = Index;
      Index = (Upper + Lower) / 2;
      if (!(Result = stricmp(XRefArray[Index]->Name, Name)))
      {
        Lower = 0;
        Upper = XRefArrayLast + 1;
        I2 = Index - 1;
        while ((I2 >= Lower) && (!stricmp(XRefArray[I2]->Name, Name)))
          I2--;
        I3 = Index + 1;
        while ((I3 < Upper) && (!stricmp(XRefArray[I3]->Name, Name)))
          I3++;
        I2++;
        while ((I2 < I3) && (strcmp(XRefArray[I2]->Name, Name)))
          I2++;
        I3 = I2;
        while ((I3 < Upper) && (!strcmp(XRefArray[I3]->Name, Name)))
          I3++;
        Index = I2;
        *number = I3 - Index;
        if (*number == 0)
          return (-1);
        return (Index);
      }
      if (Result < 0)
      {
        Lower = Index;
      }
      else
      {
        Upper = Index;
      }
    }
    while (Index != OldIndex);
  }
  return (-1);
}

/***********************************************/

long SearchNameNoCase(char *Name,long* number)
{
  long Upper, Lower;
  long Index,I2,I3;
  long OldIndex;
  long Result;

  *number = 0;
  if (XRefArray && (strlen(Name) > 0))
  {
    Lower = 0;
    Upper = XRefArrayLast + 1;
    Index = 0;
    do
    {
      OldIndex = Index;
      Index = (Upper + Lower) / 2;
      if (!(Result = stricmp(XRefArray[Index]->Name, Name)))
      {
        Lower = 0;
        Upper = XRefArrayLast + 1;
        I2 = Index - 1;
        while ((I2 >= Lower) && (!stricmp(XRefArray[I2]->Name, Name)))
          I2--;
        I3 = Index + 1;
        while ((I3 < Upper) && (!stricmp(XRefArray[I3]->Name, Name)))
          I3++;
        Index = I2 + 1;
        *number = I3 - Index;
        if (*number == 0)
          return (-1);
        return (Index);
      }
      if (Result < 0)
      {
        Lower = Index;
      }
      else
      {
        Upper = Index;
      }
    }
    while (Index != OldIndex);
  }
  return (-1);
}

/***********************************************/

long SearchStartOfNameNoCase(char *Name,long* number)
{
  long Upper, Lower;
  long Index,I2,I3;
  long OldIndex;
  long Result;
  size_t namelen = strlen(Name);

  *number = 0;
  if (XRefArray && (namelen > 0))
  {
    Lower = 0;
    Upper = XRefArrayLast + 1;
    Index = 0;
    do
    {
      OldIndex = Index;
      Index = (Upper + Lower) / 2;
      if (!(Result = strnicmp(XRefArray[Index]->Name, Name, namelen)))
      {
        Lower = 0;
        Upper = XRefArrayLast + 1;
        I2 = Index - 1;
        while ((I2 >= Lower) && (!strnicmp(XRefArray[I2]->Name, Name, namelen)))
          I2--;
        I3 = Index + 1;
        while ((I3 < Upper) && (!strnicmp(XRefArray[I3]->Name, Name, namelen)))
          I3++;
        Index = I2 + 1;
        *number = I3 - Index;
        if (*number == 0)
          return (-1);
        return (Index);
      }
      if (Result < 0)
      {
        Lower = Index;
      }
      else
      {
        Upper = Index;
      }
    }
    while (Index != OldIndex);
  }
  return (-1);
}

/***********************************************/

static BOOL ReadLine(void)
{
  int Index;
  int Character;

  Index = 0;
  if (Break())
  {
    return (FALSE);
  }
  while (((Character = getc(CurrentFile)) != EOF) && (Character != '\n'))
    if (Index < (MAX_LEN-1)) Buffer[Index++] = Character;
  Buffer[Index] = '\0';
  CurrentLine++;
  if (Character == '\n')
    return (TRUE);
  return (FALSE);
}

/***********************************************/

BOOL ReadBigDirs(void)
{
  if (!ReadLine())
    return (FALSE);
  if (!strncmp(Buffer,"NUMBDIR ",8))
  {
    long pathnum;
    if ((BDNArrayLast = atol(&Buffer[8])) < 1)
      return (FALSE);
    BDNArray = (struct XRefBigDirNode **) malloc((BDNArrayLast+1) * sizeof(struct XRefBigDirNode *));
    if (!BDNArray)
      return (FALSE);
    for (pathnum=0;pathnum<=BDNArrayLast;pathnum++)
      BDNArray[pathnum] = NULL;
    while (1)
    {
      if (!ReadLine())
        return (FALSE);
      if ((Buffer[0] == '\0'))
        return (TRUE);
      if (!strncmp(Buffer,"BDIR ",5))
      {
        if (!AddBigDir(&Buffer[7],Buffer[5]))
          return (FALSE);
      }
    }
  }
  return (FALSE);
}

/***********************************************/

BOOL ReadSubFiles(void)
{
  if (!ReadLine())
    return (FALSE);
  if (!strncmp(Buffer,"NUMFILE ",8))
  {
    char *filename;
    char *numstr;
    long filenum;
    int pos;
    if ((XSFArrayLast = atol(&Buffer[8])) < 1)
      return (FALSE);
    XSFArray = (struct XRefSubFileNode **) malloc((XSFArrayLast+1) * sizeof(struct XRefSubFileNode *));
    if (!XSFArray)
      return (FALSE);
    for (filenum=0;filenum<=XSFArrayLast;filenum++)
      XSFArray[filenum] = NULL;
    while (1)
    {
      if (!ReadLine())
        return (FALSE);
      if ((Buffer[0] == '\0'))
        return (TRUE);
      if (!strncmp(Buffer,"FILE ",5))
      {
        pos = 5;
        numstr = &Buffer[pos];
        while (Buffer[pos] && (Buffer[pos] != ' ')) pos++;
        if (Buffer[pos]) { Buffer[pos++] = '\0'; }
        filename = &Buffer[pos];
        if (*numstr)
        {
          filenum = atol(numstr);
          if (!AddSubFile(filename,filenum))
            return (FALSE);
        }
        else
          return (FALSE);
      }
    }
  }
  return (FALSE);
}

/***********************************************/

BOOL ReadXRefs(void)
{
  if (!ReadLine())
    return (FALSE);
  if (!strncmp(Buffer,"NUMXREFS ",9))
  {
    char *xrefstr;
    char *filestr;
    char *linestr;
    char *typestr;
    long filenum;
    long linenum;
    long typenum;
    int pos;
    if ((XRefArrayLast = atol(&Buffer[9])) < 1)
      return (FALSE);
    XRefArray = (struct XRefNode **) malloc((XRefArrayLast+1) * sizeof(struct XRefNode *));
    if (!XRefArray)
      return (FALSE);
    XRefArrayCurrent = 0;
    while (1)
    {
      if (!ReadLine())
        return (FALSE);
      if ((Buffer[0] == '\0'))
      {
        XRefArrayLast = XRefArrayCurrent - 1;
        return (TRUE);
      }
      pos = 0;
      xrefstr = &Buffer[pos];
      while (Buffer[pos] && (Buffer[pos] != ' ')) pos++;
      if (Buffer[pos]) { Buffer[pos++] = '\0'; }
      filestr = &Buffer[pos];
      while (Buffer[pos] && (Buffer[pos] != ' ')) pos++;
      if (Buffer[pos]) { Buffer[pos++] = '\0'; }
      linestr = &Buffer[pos];
      while (Buffer[pos] && (Buffer[pos] != ' ')) pos++;
      if (Buffer[pos]) { Buffer[pos++] = '\0'; }
      typestr = &Buffer[pos];
      if ((*xrefstr) && (*filestr) && (*linestr) && (*typestr))
      {
        filenum = atol(filestr);
        linenum = atol(linestr);
        typenum = atol(typestr);
        if (!AddXRef(xrefstr,filenum,linenum,typenum))
          return (FALSE);
      }
      else
        return (FALSE);
    }
  }
  return (FALSE);
}

/***********************************************/

void FreeXRefs(void)
{
  freemyallocs();
  if (BDNArray)
  { free(BDNArray); BDNArray = NULL; BDNArrayLast = -1; }
  if (XSFArray)
  { free(XSFArray); XSFArray = NULL; XSFArrayLast = -1; }
  if (XRefArray)
  { free(XRefArray); XRefArray = NULL; XRefArrayLast = -1; XRefArrayCurrent = 0; }
}

/***********************************************/

BOOL ReadXRef(char *xreffilename)
{
  CurrentLine = -1;
  FreeXRefs();
  if (CurrentSource = xreffilename)
  {
    if (CurrentFile = fopen(xreffilename, "r"))
    {
      BOOL Success = TRUE;
      int Index;
      for (Index = 0; Index < 2 && Success; Index++)
        Success = ReadLine();
      if (Success)
        Success = ReadBigDirs();
      if (Success)
        Success = ReadSubFiles();
      if (Success)
        Success = ReadXRefs();
      fclose(CurrentFile);
      if (Success)
        return (TRUE);
    }
  }
  FreeXRefs();
  PrintError("Error happened when at line %ld of %s ! \n",CurrentLine,xreffilename);
  return (FALSE);
}

