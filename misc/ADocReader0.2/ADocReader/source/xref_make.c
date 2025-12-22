
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <proto/dos.h>
#include <proto/exec.h>

#include "xref_gen.h"
#include "xref_make.h"

#include "Main.h"

/***********************************************/

static int  xref_CloseFiles(int ret);
static int  xref_CloseAll(int ret);
static char *GetCompleteName(char *Name,char *buf,size_t len);
static BOOL PrintXRefList(void);
static BOOL AddXRef(char *Name, char *FileName,long Line, int Type);
static void FreeXRefList(void);
static BOOL ReadLine(BOOL AcceptEOF, BOOL StoreLF);
static BOOL ProcessAutodocs(BPTR Directory, char *Name);
static BOOL ReadDir(BPTR Directory, char *DirName, char *Extension, int Type, BOOL(*Function) (char *Name));
static BOOL ProcessIncludes(BPTR Directory, char *Name);
static void PrintADocEntriesFile(char *adocf);
static void PrintDirListFile(char *dirlf);
static void FreeADocEntriesList(void);
static struct ADocEntNode *AddADocEntry(char *File,char *Name1,char *Name2);
static void FreeDirLList(void);
static struct DirListNode *AddDirList(char *DirName);

/***********************************************/

struct ADocEntNode
{
  struct ADocEntNode *Next;
  char *Name;
  char File[1];
};

static struct ADocEntNode *ADocEntList = NULL;
static struct ADocEntNode *ADocEntLast = NULL;


struct DirListNode
{
  struct DirListNode *Next;
  char DirName[1];
};

static struct DirListNode *DirLList = NULL;
static struct DirListNode *DirLLast = NULL;


struct MakeBigDirNode
{
  struct MakeBigDirNode *Next;
  char Letter;
  char Name[1];
};

struct MakeSubFileNode
{
  struct MakeSubFileNode *Next;
  long Num;
  char Name[1];
};

struct MakeNode
{
  struct MakeNode *Next;
  struct MakeSubFileNode *File;
  UWORD Line;
  BYTE  Type;
  char  Name[1];
};

static struct MakeNode *XRefList = NULL;
static struct MakeNode *XRefLast = NULL;

static char *CurrentSource;
static BPTR CurrentFile;
static long CurrentLine;

static char Identifier[MAX_LEN];

static char CurrentUnit[MAX_LEN];

static char WordBuffer[MAX_LEN];
static char WordBuffertemp[MAX_LEN];

static BPTR IncludeDir1 = NULL;
static BPTR IncludeDir2 = NULL;
static BPTR IncludeDir3 = NULL;
static BPTR IncludeDir4 = NULL;
static BPTR AutodocDir1 = NULL;
static BPTR AutodocDir2 = NULL;
static BPTR AutodocDir3 = NULL;
static BPTR AutodocDir4 = NULL;
static BPTR XRefFile = NULL;

/***********************************************/

static struct MakeBigDirNode *BDNList = NULL;

/***********************************************/

static struct MakeSubFileNode *SDNList = NULL;
static struct MakeSubFileNode *SDNLast = NULL;
static long SDNumLast = 0;

/***********************************************/

static int xref_CloseFiles(int ret)
{
  if (IncludeDir1)
  { UnLock(IncludeDir1); IncludeDir1 = NULL; }
  if (IncludeDir2)
  { UnLock(IncludeDir2); IncludeDir2 = NULL; }
  if (IncludeDir3)
  { UnLock(IncludeDir3); IncludeDir3 = NULL; }
  if (IncludeDir4)
  { UnLock(IncludeDir4); IncludeDir4 = NULL; }

  if (AutodocDir1)
  { UnLock(AutodocDir1); AutodocDir1 = NULL; }
  if (AutodocDir2)
  { UnLock(AutodocDir2); AutodocDir2 = NULL; }
  if (AutodocDir3)
  { UnLock(AutodocDir3); AutodocDir3 = NULL; }
  if (AutodocDir4)
  { UnLock(AutodocDir4); AutodocDir4 = NULL; }

  if (XRefFile)
  { Close(XRefFile); XRefFile = NULL; }

  return (ret);
}

/***********************************************/

static int xref_CloseAll(int ret)
{
  ret = xref_CloseFiles(ret);

  FreeXRefList();
  FreeADocEntriesList();
  FreeDirLList();

  return (ret);
}

/***********************************************/

int xref_make(char *xref,char *adocf,char *dirlf,char *incd1,char *incd2,char *incd3,char *incd4,char *adocd1,char *adocd2,char *adocd3,char *adocd4)
{
  if (xref == NULL)
    return (1);

  xref_CloseAll(0);

  if ( incd1 &&  *incd1) IncludeDir1 = Lock( incd1, ACCESS_READ);
  if ( incd2 &&  *incd2) IncludeDir2 = Lock( incd2, ACCESS_READ);
  if ( incd3 &&  *incd3) IncludeDir3 = Lock( incd3, ACCESS_READ);
  if ( incd4 &&  *incd4) IncludeDir4 = Lock( incd4, ACCESS_READ);
  if (adocd1 && *adocd1) AutodocDir1 = Lock(adocd1, ACCESS_READ);
  if (adocd2 && *adocd2) AutodocDir2 = Lock(adocd2, ACCESS_READ);
  if (adocd3 && *adocd3) AutodocDir3 = Lock(adocd3, ACCESS_READ);
  if (adocd4 && *adocd4) AutodocDir4 = Lock(adocd4, ACCESS_READ);
  if (IncludeDir1 || IncludeDir2 || IncludeDir3 || IncludeDir4 ||
      AutodocDir1 || AutodocDir2 || AutodocDir3 || AutodocDir4)
  {
    XRefFile = Open(xref, MODE_NEWFILE);
    if (XRefFile)
    {
      FreeXRefList();
      FreeADocEntriesList();
      FreeDirLList();

      if (!ProcessAutodocs(AutodocDir1, adocd1))
        return (xref_CloseAll(1));
      if (!ProcessAutodocs(AutodocDir2, adocd2))
        return (xref_CloseAll(1));
      if (!ProcessAutodocs(AutodocDir3, adocd3))
        return (xref_CloseAll(1));
      if (!ProcessAutodocs(AutodocDir4, adocd4))
        return (xref_CloseAll(1));

      if (!ProcessIncludes(IncludeDir1, incd1))
        return (xref_CloseAll(1));
      if (!ProcessIncludes(IncludeDir2, incd2))
        return (xref_CloseAll(1));
      if (!ProcessIncludes(IncludeDir3, incd3))
        return (xref_CloseAll(1));
      if (!ProcessIncludes(IncludeDir4, incd4))
        return (xref_CloseAll(1));

      if (!PrintXRefList())
        return (xref_CloseAll(1));

      PrintADocEntriesFile(adocf);

      PrintDirListFile(dirlf);
    }
    else
      return (xref_CloseAll(1));
  }
  else
    return (xref_CloseAll(1));
  return (xref_CloseAll(0));
}

/***********************************************/

static BOOL PrintBigDirList(void)
{
  struct MakeBigDirNode *CurNode = NULL;
  char dirn[] = " ";
  long bdnum = 0;
  CurNode = BDNList;
  while (CurNode)
  {
    bdnum++;
    CurNode = CurNode->Next;
  }
  FPrintf(XRefFile, "NUMBDIR %ld\n", bdnum);
  CurNode = BDNList;
  while (CurNode)
  {
    dirn[0] = CurNode->Letter;
    FPrintf(XRefFile, "BDIR %s %s\n",(LONG) dirn, (LONG) CurNode->Name);
    CurNode = CurNode->Next;
  }
  FPrintf(XRefFile, "\n");
  return (TRUE);
}

/***********************************************/

static char AddBigDir(char *Name, char Letter)
{
  struct MakeBigDirNode *NewNode;
  char letter = 0;
  if ((Name != NULL) && (Name[0] != '\0'))
  {
    int pos = 1;
    while (Name[pos] != '\0')
      pos++;
    pos--;
    while ((pos > 0) && (Name[pos] == ' '))
      pos--;
    if ((Name[pos] != ':') && (Name[pos] != '/'))
    {
      Name[pos++] = '/';
      Name[pos] = '\0';
    }
    if (NewNode = malloc(sizeof(struct MakeBigDirNode) + strlen(Name)))
    {
      if (Letter != '\0')
        letter = Letter;
      else
      {
        if (BDNList == NULL)
          letter = 'A';
        else
          letter = BDNList->Letter + 1;
      }
      stpcpy(NewNode->Name, Name);
      NewNode->Letter = letter;
      NewNode->Next = BDNList;
      BDNList = NewNode;
      return (letter);
    }
    else
    {
      PrintFault(ERROR_NO_FREE_STORE, NULL);
    }
  }
  return (letter);
}

/***********************************************/

static void FreeBigDirList(void)
{
  struct MakeBigDirNode *List = BDNList;
  struct MakeBigDirNode *NextNode;

  while (List)
  {
    NextNode = List->Next;
    free(List);
    List = NextNode;
  }
  BDNList = NULL;
}

/***********************************************/

/* someting like that should be used to get complete file name :
  char realname[200];

  GetCompleteName(Name,realname,200);
*/

static char *GetCompleteName(char *Name,char *buf,size_t len)
{
  struct MakeBigDirNode *CurNode = BDNList;
  if ((Name != NULL) && (strlen(Name) >= 1) && (buf != NULL))
  {
    while (CurNode != NULL)
    {
      if (*Name == CurNode->Letter)
      {
        if (strlen(CurNode->Name) + strlen(Name) <= len)
        {
          stpcpy(stpcpy(buf, CurNode->Name),&Name[1]);
          return (buf);
        }
        return (Name);
      }
      CurNode = CurNode->Next;
    }
  }
  return (Name);
}

/***********************************************/

static BOOL PrintSubFileList(void)
{
  struct MakeSubFileNode *CurNode = NULL;
  FPrintf(XRefFile, "NUMFILE %ld\n", SDNumLast);
  CurNode = SDNList;
  while (CurNode)
  {
    FPrintf(XRefFile, "FILE %ld %s\n", (LONG) CurNode->Num, (LONG) CurNode->Name);
    CurNode = CurNode->Next;
  }
  FPrintf(XRefFile, "\n");
  return (TRUE);
}

/***********************************************/

static struct MakeSubFileNode *AddSubFile(char *Name,long num)
{
  struct MakeSubFileNode *NewNode;
  struct MakeSubFileNode *CurNode;
  struct MakeSubFileNode *OldNode;

  OldNode = NULL;
  CurNode = SDNLast;
  if (!CurNode || !(strcmp(CurNode->Name, Name) <= 0))
    CurNode = SDNList;

  while (CurNode && (strcmp(CurNode->Name, Name) < 0))
  {
    OldNode = CurNode;
    CurNode = CurNode->Next;
  }
  if (CurNode && !strcmp(CurNode->Name, Name))
    return (CurNode);
  else if (NewNode = malloc(sizeof(struct MakeSubFileNode) + strlen(Name)))
  {
    stpcpy(NewNode->Name, Name);
    if (num == -1)
      NewNode->Num = SDNumLast++;
    else
      NewNode->Num = num;
    NewNode->Next = CurNode;
    if (OldNode)
      OldNode->Next = NewNode;
    else
      SDNList = NewNode;
    SDNLast = NewNode;
    return (NewNode);
  }
  else
  {
    PrintFault(ERROR_NO_FREE_STORE, NULL);
  }
  return (NULL);
}

/***********************************************/

static void FreeSubFileList(void)
{
  struct MakeSubFileNode *List = SDNList;
  struct MakeSubFileNode *NextNode;

  while (List)
  {
    NextNode = List->Next;
    free(List);
    List = NextNode;
  }
  SDNList = NULL;
}

/***********************************************/

static void PrintADocEntriesFile(char *adocf)
{
  BPTR ADocFile = NULL;
  char FileName[300];
  ADocFile = Open(adocf, MODE_NEWFILE);
  if (ADocFile)
  {
    struct ADocEntNode *List;
    FileName[0] = '\0';
    PrintInfo("Making autodoc entries file...\n");
    List = ADocEntList;
    while (List)
    {
      if (stricmp(FileName,List->File))
      {
        FPrintf(ADocFile,"\n%s\n\n",(ULONG) List->File);
        stpcpy(FileName,List->File);
      }
      FPrintf(ADocFile,"    %s\n",(ULONG) List->Name);
      List = List->Next;
    }
    Close(ADocFile);
    PrintInfo("autodoc entries file maked !\n");
  }
  else
    PrintError("Can't open the ADoc Entries file to write !\n");
}

/***********************************************/

static struct ADocEntNode *AddADocEntry(char *File,char *Name1,char *Name2)
{
  struct ADocEntNode *NewNode;
  struct ADocEntNode *CurNode;
  struct ADocEntNode *OldNode;
  char FileName[300];

  sprintf(FileName,"%-32s [%s]",&File[1],Name1);

  OldNode = NULL;
  CurNode = ADocEntList;

  while (CurNode && (stricmp(CurNode->File, FileName) < 0))
  {
    OldNode = CurNode;
    CurNode = CurNode->Next;
  }
  while (CurNode && (stricmp(CurNode->File, FileName) == 0) && (stricmp(CurNode->Name, Name2) < 0))
  {
    OldNode = CurNode;
    CurNode = CurNode->Next;
  }
  if (NewNode = malloc(sizeof(struct ADocEntNode) + strlen(FileName) + strlen(Name2) + 1))
  {
    NewNode->Name = stpcpy(NewNode->File, FileName) + 1;
    stpcpy(NewNode->Name, Name2);
    NewNode->Next = CurNode;
    if (OldNode)
      OldNode->Next = NewNode;
    else
      ADocEntList = NewNode;
    ADocEntLast = NewNode;
    return (NewNode);
  }
  else
  {
    PrintFault(ERROR_NO_FREE_STORE, NULL);
  }
  return (NULL);
}

/***********************************************/

static void FreeADocEntriesList(void)
{
  struct ADocEntNode *List = ADocEntList;
  struct ADocEntNode *NextNode;

  while (List)
  {
    NextNode = List->Next;
    free(List);
    List = NextNode;
  }
  ADocEntList = NULL;
  ADocEntLast = NULL;
}

/***********************************************/

static void PrintDirListFile(char *dirlf)
{
  char realname[200];
  BPTR DirLFile = NULL;
  DirLFile = Open(dirlf, MODE_NEWFILE);
  if (DirLFile)
  {
    struct DirListNode *List;
    PrintInfo("Making dir list file...\n");
    List = DirLList;
    while (List)
    {
      GetCompleteName(List->DirName,realname,200);
      FPrintf(DirLFile,"%s\n",(ULONG) realname);
      List = List->Next;
    }
    Close(DirLFile);
    PrintInfo("dir list file maked !\n");
  }
  else
    PrintError("Can't open the Dir List file to write !\n");
}

/***********************************************/

static struct DirListNode *AddDirList(char *DirName)
{
  struct DirListNode *NewNode;

  if (NewNode = malloc(sizeof(struct DirListNode) + strlen(DirName)))
  {
    stpcpy(NewNode->DirName, DirName);
    NewNode->Next = NULL;
    if (DirLLast)
      DirLLast->Next = NewNode;
    else
      DirLList = NewNode;
    DirLLast = NewNode;
    return (NewNode);
  }
  else
  {
    PrintFault(ERROR_NO_FREE_STORE, NULL);
  }
  return (NULL);
}

/***********************************************/

static void FreeDirLList(void)
{
  struct DirListNode *List = DirLList;
  struct DirListNode *NextNode;

  while (List)
  {
    NextNode = List->Next;
    free(List);
    List = NextNode;
  }
  DirLList = NULL;
  DirLLast = NULL;
}

/***********************************************/

static BOOL PrintXRefList(void)
{
  struct MakeNode *CurNode = NULL;
  long xrefnum;

  FPrintf(XRefFile, "/* This file was created by ADocReader "ADRVER" */\n/* Do not edit ! */\n");

PrintInfo("Write BigDirs\n");
  if (!PrintBigDirList())
    return (FALSE);

PrintInfo("Write SubFiles\n");
  if (!PrintSubFileList())
    return (FALSE);

PrintInfo("Write XRefs\n");
  xrefnum = 0;
  CurNode = XRefList;
  while (CurNode)
  {
    xrefnum++;
    CurNode = CurNode->Next;
  }
  FPrintf(XRefFile, "NUMXREFS %ld\n", xrefnum);
  CurNode = XRefList;
  while (CurNode)
  {
    FPrintf(XRefFile, "%s %ld %ld %ld\n", (LONG) CurNode->Name, CurNode->File->Num, CurNode->Line, (long) CurNode->Type);
    CurNode = CurNode->Next;
  }
  FPrintf(XRefFile, "\n#\n");

  PrintInfo("%ld xrefs !\n",xrefnum);
  return (TRUE);
}

/***********************************************/

static BOOL AddXRef(char *Name, char *FileName,long Line, int Type)
{
  struct MakeNode *NewNode;
  struct MakeNode *CurNode;
  struct MakeNode *OldNode;
  struct MakeSubFileNode *fileptr = NULL;

  if (FileName)
    fileptr = AddSubFile(FileName,-1);
  if (fileptr)
  {
    OldNode = NULL;
    CurNode = XRefLast;
    if (!CurNode || !(stricmp(CurNode->Name, Name) <= 0))
      CurNode = XRefList;

    while (CurNode && (stricmp(CurNode->Name, Name) <= 0))
    {
      OldNode = CurNode;
      CurNode = CurNode->Next;
    }
    if (NewNode = malloc(sizeof(struct MakeNode) + strlen(Name)))
    {
      stpcpy(NewNode->Name, Name);
      NewNode->File = fileptr;
      NewNode->Line = Line;
      NewNode->Type = Type;
      NewNode->Next = CurNode;
      if (OldNode)
        OldNode->Next = NewNode;
      else
        XRefList = NewNode;
      XRefLast = NewNode;
      return (TRUE);
    }
    else
    {
      PrintFault(ERROR_NO_FREE_STORE, NULL);
    }
  }
  else
  {
    PrintFault(ERROR_NO_FREE_STORE, NULL);
  }
  return (FALSE);
}

/***********************************************/

static void FreeXRefList(void)
{
  struct MakeNode *List = XRefList;
  struct MakeNode *NextNode;

  while (List)
  {
    NextNode = List->Next;
    free(List);
    List = NextNode;
  }
  XRefList = NULL;
  XRefLast = NULL;

  FreeSubFileList();
  FreeBigDirList();
}

/***********************************************/

static BOOL ReadLine(BOOL AcceptEOF, BOOL StoreLF)
{
  int Index;
  long Character;

  Index = 0;
  while (TRUE)
  {
    if (Break())
    {
      return (FALSE);
    }
    Character = FGetC(CurrentFile);
    switch (Character)
    {
      case -1:
        if (IoErr())
        {
          PrintFault(IoErr(), CurrentSource);
        }
        else
        {
          if (!AcceptEOF)
          {
            PrintError("Error: Unexpected end of file %s\n"
                       "       Operation aborted.\n", CurrentSource);
          }
        }
        return (FALSE);

      case '\n':
        if (StoreLF)
        {
          Buffer[Index++] = '\n';
        }
        Buffer[Index] = '\0';
        CurrentLine++;
        return (TRUE);

      case '\f':
        if (Index)
        {
          PrintError("Error: Unexpected FormFeed in file %s"
                     "       Operation aborted.\n", CurrentSource);
          return (FALSE);
        }
        else
        {
          Buffer[0] = Character;
          return (TRUE);
        }

      default:
        Buffer[Index++] = Character;
        if (Index >= MAX_LEN)
          Index--;
        break;
    }
  }
}

/***********************************************/

/* DirName is a BigDir letter, which can be followed by SubFile name(s) */

static BOOL ReadDir(BPTR Directory, char *DirName, char *Extension, int Type, BOOL(*Function) (char *Name))
{
  struct FileInfoBlock FileInfoBlock;
  BPTR OldCurrentDir;
  long Length;
  int ExtensionLength;
  char NewName[200];
  BPTR NewDirectory;
  BOOL Success = TRUE;

  if (Directory != NULL)
  {
    AddDirList(DirName);

    OldCurrentDir = CurrentDir(Directory);
    if (Examine(Directory, &FileInfoBlock))
    {
      Success = TRUE;
      ExtensionLength = strlen(Extension);
      while (Success && ExNext(Directory, &FileInfoBlock))
      {
        if (Break())
        {
          Success = FALSE;
        }
        else
        {
          if (FileInfoBlock.fib_DirEntryType < 0)
          {
            Length = strlen(FileInfoBlock.fib_FileName);
            if (Length >= ExtensionLength && !stricmp(FileInfoBlock.fib_FileName + Length - ExtensionLength, Extension))
            {
              char file[strlen(DirName) + Length + 2];
              stpcpy(stpcpy(file, DirName), FileInfoBlock.fib_FileName);
              if (!AddXRef(FileInfoBlock.fib_FileName, file, 0, Type) || !Function(file))
              {
                Success = FALSE;
              }
            }
          }
          else
          {
            if (sprintf(NewName, "%s%s/", DirName, FileInfoBlock.fib_FileName))
            {
              if (NewDirectory = Lock(FileInfoBlock.fib_FileName, ACCESS_READ))
              {
                Success = ReadDir(NewDirectory, NewName, Extension, Type, Function);
                UnLock(NewDirectory);
              }
              else
              {
                PrintFault(IoErr(), NewName);
                Success = FALSE;
              }
            }
            else
            {
              PrintFault(ERROR_NO_FREE_STORE, NULL);
              Success = FALSE;
            }
          }
        }
      }
      if (Success)
      {
        if (IoErr() == ERROR_NO_MORE_ENTRIES)
        {
          Success = TRUE;
        }
        else
        {
          PrintFault(IoErr(), DirName);
          Success = FALSE;
        }
      }
    }
    else
    {
      PrintFault(IoErr(), DirName);
      Success = FALSE;
    }
    CurrentDir(OldCurrentDir);
  }
  return (Success);
}

/***********************************************/

static long MyFGetC(BOOL ret)
{
  long Character;

  Character = FGetC(CurrentFile);
  switch (Character)
  {
    case '\n':
      CurrentLine++;
      if (ret)
        break;
    case '\t':
    case 0xA0:
    case '\f':
      Character = ' ';
  }
  return (Character);
}

/***********************************************/

#define ERROR_TOKEN   -1
#define EOF_TOKEN      0
#define IDENT_TOKEN    1
#define ANY_TOKEN      2


static WORD ReadToken(void)
{
  long Character;
  int Index;

DoRead:
  do
  {
    if (Break())
    {
      return (ERROR_TOKEN);
    }
    Character = MyFGetC(FALSE);
  }
  while (Character == ' ');
  switch (Character)
  {
    case -1:
      return (WORD) (IoErr()? ERROR_TOKEN : EOF_TOKEN);

    case '/':
      if ((Character = MyFGetC(FALSE)) == '*')
      {
        do
        {
          while ((Character = MyFGetC(FALSE)) != '*')
          {
            if (Character == -1)
            {
              return (WORD) (IoErr()? ERROR_TOKEN : EOF_TOKEN);
            }
            if (Break())
            {
              return (WORD) (ERROR_TOKEN);
            }
          }
          Character = MyFGetC(FALSE);
          if (Character != '/')
          {
            UnGetC(CurrentFile, Character);
          }
        }
        while (Character != '/');
        goto DoRead;
      }
      else
      {
        UnGetC(CurrentFile, Character);
      }
      return (WORD) (ANY_TOKEN);

    case ';':
    case '[':
    case ']':
    case '{':
    case '}':
    case '(':
    case ')':
      return ((WORD) Character);

    default:
      Index = 0;
      while ((Character >= 'a' && Character <= 'z') ||
             (Character >= 'A' && Character <= 'Z') ||
             (Character >= '0' && Character <= '9') ||
             (Character == '_' || Character == '#'))
      {
        Identifier[Index++] = Character;
        if (Index == MAX_LEN - 1)
        {
          PrintError("Error: Identifier too long.\n"
                             "       Operation aborted.\n");
          return (ERROR_TOKEN);
        }
        Character = MyFGetC(FALSE);
      }
      if (Index)
      {
        Identifier[Index] = '\0';
        UnGetC(CurrentFile, Character);
        return (IDENT_TOKEN);
      }
      return (ANY_TOKEN);
  }
}

/***********************************************/

static BOOL ProcessIncludeFile(char *Name)
{
  long BlockLevel;
  long StructLine;
  long TypedefLine;
  BOOL Success;
  WORD Typedef;
  WORD Define;
  WORD Token;
  char realname[200];

  GetCompleteName(Name,realname,200);

  Success = TRUE;
  {
    PrintInfo("    Reading %s\n", realname);
    if (CurrentFile = Open(realname, MODE_OLDFILE))
    {
      CurrentLine = 0;
      BlockLevel = 0;
      Typedef = 0;
      Define = 0;
      while ((Token = ReadToken()) > 0 && Success)
      {
CheckToken:
        switch (Token)
        {
          case '(':
          case '{':
          case '[':
            BlockLevel++;
            break;
          case ')':
          case '}':
          case ']':
            BlockLevel--;
            break;

          case IDENT_TOKEN:
            if (!BlockLevel)
            {
              if (!stricmp(Identifier, "#define"))
              {
                Define = 2;
                TypedefLine = CurrentLine;
              }
/*
              else if (!strcmp(Identifier, "#"))
              {
                Define = 1;
                TypedefLine = CurrentLine;
              }
              else if ((Define == 1) && !stricmp(Identifier, "define"))
              {
                Define = 2;
              }
*/
              else if (Define == 2)
              {
                Success = AddXRef(Identifier, Name, TypedefLine, TYPE_DEFINE);
                Define = 0;
                {
                  int comment = 0;
                  long Character = ' ';
                  while (Character != '\n')
                  {
                    while ((Character != '\n') && (Character != '\\'))
                    {
                      Character = MyFGetC(TRUE);
                      if ((Character == -1) || Break())
                      {
                        comment = 0;
                        Success = FALSE;
                        Character = '\n';
                      }
                      switch (comment)
                      {
                        case 0 :
                          if (Character == '/')
                            comment = 1;
                          break;
                        case 1 :
                          if (Character == '*')
                          {
/*PrintInfo("define: start comment\n");*/
                            comment = 2;
                          }
                          else
                            comment = 0;
                          break;
                        case 2 :
                          if (Character == '*')
                            comment = 3;
                          break;
                        case 3 :
                          if (Character == '/')
                          {
/*PrintInfo("define: end comment\n");*/
                            comment = 0;
                          }
                          else
                            comment = 2;
                          break;
                      }
                    }
                    if (comment >= 2)
                    {
                      Character = ' ';
                      comment = 2;
                    }
                    else if (Character == '\\')
                    {
                      comment = 0;
                      Character = MyFGetC(TRUE);
                      if (Character == -1)
                      {
                        comment = 0;
                        Success = FALSE;
                        Character = '\n';
                      }
                      else if (Character == '\n')
                        Character = ' ';
                    }
                    if (Break())
                    {
                      comment = 0;
                      Success = FALSE;
                      Character = '\n';
                    }
                  }
                }
              }
              else if (!strcmp(Identifier, "typedef"))
              {
                Typedef = 1;
                TypedefLine = CurrentLine;
              }
              else if (!strcmp(Identifier, "struct"))
              {
                StructLine = CurrentLine;
                Token = ReadToken();
                if (Token == IDENT_TOKEN)
                {
                  if (Typedef)
                  {
                    stpcpy(Buffer, Identifier);
                    Typedef = 2;
                  }
                  Token = ReadToken();
                  if (Token == '{')
                  {
                    Success = AddXRef(Identifier, Name, StructLine, TYPE_STRUCT);
                  }
                  goto CheckToken;
                }
                else
                {
                  goto CheckToken;
                }
              }
            }
            break;

          case ';':
            if (!BlockLevel)
            {
              switch (Typedef)
              {
                case 1 :
                  Success = AddXRef(Identifier, Name, TypedefLine, TYPE_TYPEDEF);
                  break;
                case 2 :
                  Success = AddXRef(Identifier, Name, TypedefLine, TYPE_TYPEDEFSTRUCT);
                  break;
              }
              Typedef = 0;
            }
            break;
        }
      }
      if (Token)
      {
        Success = FALSE;
      }
      Close(CurrentFile);
    }
    else
    {
      PrintFault(IoErr(), Name);
      Success = FALSE;
    }
  }
  return (Success);
}

/***********************************************/

static BOOL ProcessIncludes(BPTR Directory, char *Name)
{
  if (Directory != NULL)
  {
    char dirn[] = " ";
    dirn[0] = AddBigDir(Name,'\0');
    if (dirn[0] && ReadDir(Directory, dirn, ".h", TYPE_INCFILE, ProcessIncludeFile))
      return (TRUE);
    return (FALSE);
  }
  return (TRUE);
}

/***********************************************/

static BOOL AddAutodocContents(char *FileName)
{
  BOOL Success;
  unsigned char *pos1,*pos2;
  unsigned char father[MAX_LEN];
  BOOL first;
  BOOL name;
  int current = 0;
  int poscmax;
  int posc;
  char realname[200];

  GetCompleteName(FileName,realname,200);

  PrintInfo("    Reading %s\n", realname);
  Success = FALSE;
  if (CurrentFile = Open(realname, MODE_OLDFILE))
  {
    do
    {
      Success = ReadLine(TRUE, FALSE);
      if (Success && !stricmp(Buffer, "TABLE OF CONTENTS"))
        break;
    }
    while (Success && Buffer[0] != '\f');

    if (Success && Buffer[0] != '\f')
    {
      while ((Buffer[0] != '\f') && (Success = ReadLine(TRUE, FALSE)))
        ;
      first = TRUE;
      while (Success && (Buffer[0] == '\f'))
      {
        current++;
        if (Success = ReadLine(TRUE, FALSE))
        {
          /* for autodoc where the form feed is alone on the line, we should read another line */
          pos2=Buffer;
          while ((*pos2!='\0') && ((*pos2==' ') || (*pos2=='\t') || (*pos2==0xA0)))
            pos2++;
          if (*pos2=='\0')
            Success = ReadLine(TRUE, FALSE);

          /* trying to find 'NAME' : one bug in audio.doc where it's missing for ADCMD_ALLOCATE ! */
          pos2=Buffer;
          while ((*pos2!='\0') && (*pos2!='/'))
            pos2++;
          if (*pos2=='/')
          {
            *pos2 = '\0';
            stpcpy(father,Buffer);
            if (first)
            {
              first = FALSE;
              AddXRef(father,FileName,0,TYPE_ADOCNAME);
            }
            name = FALSE;
            while ((Success = ReadLine(TRUE, FALSE)) && (Buffer[0] != '\f'))
            {
              posc = 0;
              pos1=Buffer;
              while ((*pos1!='\0') && (*pos1!='N') && (posc++ < 6))
                pos1++;
              if ((pos1[0]=='N') && (pos1[1]=='A') && (pos1[2]=='M') && (pos1[3]=='E'))
              {
                name = TRUE;
                break;
              }
            }
            /* reqtools.doc has a bad form: NAME is use near as SYNOPSIS, hope doc will be fixed ! */
            /* find first entry after NAME (skipping empty line(s) for some docs !) */
            poscmax = 12;
            while (name && (Success = ReadLine(TRUE, FALSE)))
            {
              posc = 0;
              pos1 = Buffer;
              while ((*pos1!='\0') && ((*pos1==' ') || (*pos1=='\t') || (*pos1==0xA0)) && (posc < poscmax))
              {
                if (*pos1=='\t')
                {
                  posc += 4;
                  if (posc > poscmax)
                    break;
                }
                else
                {
                  posc++;
                }
                pos1++;
              }
              pos2 = pos1;
              while ((*pos2!='\0') && (*pos2!=' ') && (*pos2!='\t') && (*pos2!='(') && (*pos2!=0xA0))
                pos2++;
              if (pos2>pos1)
              {
                *pos2 = '\0';
                /* because of trackdisk.doc which xxx/yyy entries ! */
                pos2 = pos1;
                while ((*pos2!='\0') && (*pos2!='/'))
                  pos2++;
                if (*pos2=='/')
                {
                  *pos2 = '\0';
                  pos2++;
                  AddXRef(pos1,FileName,current,TYPE_ADENTRY);
                  AddADocEntry(FileName,father,pos1);
                  if (*pos2!='\0')
                  {
                    AddXRef(pos2,FileName,current,TYPE_ADENTRY);
                    AddADocEntry(FileName,father,pos2);
                  }
                }
                else
                {
                  AddXRef(pos1,FileName,current,TYPE_ADENTRY);
                  AddADocEntry(FileName,father,pos1);
                }
                poscmax = posc;
                break;
              }
            }
            /* find other entries, don't care about lines which start before the first one (tabs used as 4 spaces) */
            while (Success && name && (Success = ReadLine(TRUE, FALSE)))
            {
              posc = 0;
              pos1 = Buffer;
              while ((*pos1!='\0') && ((*pos1==' ') || (*pos1=='\t') || (*pos1==0xA0)) && (posc < poscmax))
              {
                if (*pos1=='\t')
                {
                  posc += 4;
                  if (posc > poscmax)
                    break;
                }
                else
                {
                  posc++;
                }
                pos1++;
              }
              pos2 = pos1;
              while ((*pos2!='\0') && (*pos2!=' ') && (*pos2!='\t') && (*pos2!=0xA0))
                pos2++;
              if ((pos2>pos1) && (posc == poscmax))
              {
                if ((pos2[0]=='\0') || (pos2[1]=='\0') || (pos2[1]=='-') ||
                    (pos2[2]=='\0') || (pos2[2]=='-') || ((pos2[1]=='(') && (pos2[2]=='V')))
                {
                  *pos2 = '\0';
                  AddXRef(pos1,FileName,current,TYPE_ADENTRY);
                  AddADocEntry(FileName,father,pos1);
                }
              }
              else
                name = FALSE;
            }
          }
        }
        while (Success && (Buffer[0] != '\f') && (Success = ReadLine(TRUE, FALSE)))
          ;
        if (Break())
          Success = FALSE;
      }
      Success = TRUE;
    }
    else
    {
      Success = FALSE;
PrintError("can't find TABLE OF CONTENTS !\n");
/*
      PrintError("Error: First line in autodoc file must read\n"
                 "       \x22TABLE OF CONTENTS\x22\n"
                 "       File: %s\n"
                 "       Operation aborted.\n", File);
*/
    }
    Close(CurrentFile);
  }
  else
  {
    PrintFault(IoErr(), CurrentSource);
  }
  return (Success);
}

/***********************************************/

static BOOL ProcessAutodocs(BPTR Directory, char *Name)
{
  if (Directory != NULL)
  {
    char dirn[] = " ";
    dirn[0] = AddBigDir(Name,'\0');
    if (dirn[0] && ReadDir(Directory, dirn, ".doc", TYPE_ADOCFILE, AddAutodocContents))
      return (TRUE);
    return (FALSE);
  }
  return (TRUE);
}

