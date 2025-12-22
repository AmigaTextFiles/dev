
#define VERSION "SObjA - Version 1.03"

#define BANNER \
   "SObjA - Convert object files from Sun to Amiga format."            "\n" \
   "Copyright (C) 1990 - Ray Burr"                                     "\n"

/*  This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 1, or (at your option)
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

  --------------------------------------------------------------------------

    This code is a temporary (I hope) solution to the problem of getting
  GCC to output object files that can be linked by an Amiga linker.  It is
  not ment as a tool for converting ANY Sun object file to an Amiga object
  file.  It was writen with only GCC v1.37 in mind.  I am not an expert on
  UN*X object files so this code might be on the wierd side... but I
  wouldn't release it unless I thought it had some chance of working
  sometimes.
                                    - Ray Burr (ryb)


  HISTORY

  Ver.  Who      When       What

  1.03  ryb      901022     Improved some error checks.  Copies object
                              files that are already in amiga format.

  1.02  ryb      900927     Fixed bug in CopySegments().  Was sometimes
                              calling free() on NULL.

  1.01  ryb      900917     Combined SObjA and MakeBSS.  Fixed bug in
                              handling files with no common references
                              using '-c' option.  Added '-s' option.  Added
                              error checks.

  1.0   ryb      900827     First release.

*/


#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifndef unix
#include <stdlib.h>
#endif


#define CleanExit(m,r) KleanExit(m,r,__LINE__)

#define RC_OK   0
#define RC_WARN 10
#define RC_FAIL 20

#define FALSE 0
#define TRUE  1

#ifndef SEEK_SET
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif

#define MAX_FILENAME_LENGTH 80

#define OPTION_PREFIX '-'

#define FILENAME_EXTENSION "-amiga"

#define BUFFER_SIZE 0x0800

#define LOOP for (;;)

#define ALLOCATE_MEMORY(pointer, count, size) \
  { \
    (pointer) = (void *)malloc((count) * (size)); \
    if ((pointer) == NULL) \
      CleanExit(NoMemoryErrorMessage, RC_FAIL); \
  }

#define WRITE_LONG(longword, file) \
  ((ulongtmp = longword), \
  fwrite((char *)&ulongtmp, 4, 1, file))

#define READ_LONG(file) \
  ((fread((char *)&ulongtmp, 4, 1, file) != 1) ? \
   (ferror(file) ? \
    (CleanExit(ReadErrorMessage, RC_FAIL), 0) : \
    EOF) : \
   ulongtmp)

/* For debug: (Note that var is evaluated twice.) */
#define PRDEC(var) (printf(#var " = %ld\n",     (long)(var)), (var));
#define PRHEX(var) (printf(#var " = 0x%08lx\n", (long)(var)), (var));


#define HUNK_UNIT    0x03e7
#define HUNK_NAME    0x03e8
#define HUNK_CODE    0x03e9
#define HUNK_DATA    0x03ea
#define HUNK_BSS     0x03eb
#define HUNK_RELOC32 0x03ec
#define HUNK_RELOC16 0x03ed
#define HUNK_RELOC8  0x03ee
#define HUNK_EXT     0x03ef
#define HUNK_SYMBOL  0x03f0
#define HUNK_END     0x03f2
#define HUNK_HEADER  0x03f3

#define EXT_DEF      0x01
#define EXT_ABS      0x02
#define EXT_REF32    0x81
#define EXT_COMMON   0x82
#define EXT_REF16    0x83
#define EXT_REF8     0x84


struct exec {
  unsigned       a_dynamic:1;
  unsigned       a_toolversion:7;
  unsigned       a_machtype:8;      /* unsigned char  */
  unsigned       a_magic:16;        /* unsigned short */
  unsigned long  a_text;     /* Text segment's size */
  unsigned long  a_data;     /* Data ...            */
  unsigned long  a_bss;      /* BSS  ...            */
  unsigned long  a_syms;     /* Symbol table's size */
  unsigned long  a_entry;
  unsigned long  a_trsize;   /* Text relocation info's size */
  unsigned long  a_drsize;   /* Data ...                    */
};

struct reloc_info_68k {
  long     r_address;
  unsigned r_symbolnum:24,
           r_pcrel:1,
           r_length:2,
           r_extern:1,
           r_baserel:1,
           r_jmptable:1,
           r_relative:1,
           poopoo:1;
};

#define SUN_MAGIC 0407  /* Octal */

#define N_UNDF 0x00
#define N_EXT  0x01
#define N_ABS  0x02
#define N_TEXT 0x04
#define N_DATA 0x06
#define N_BSS  0x08
#define N_TYPE 0x1e

struct nlist {
  union {
    char *n_name;
    long n_strx;
  } n_un;
  unsigned char n_type;
  char          n_other;
  short         n_desc;
  unsigned long n_value;
};


static char *DefaultFilenameExtension = FILENAME_EXTENSION;
static char *DefaultCommonFilename = "sobja-common";
static char *DefaultBssFilename = "bss.o" FILENAME_EXTENSION;

static char *NoMemoryErrorMessage = "Can't allocate memory.";
static char *ReadErrorMessage = "Can't read input file.";

static char *ProgramName;
static FILE *InFile, *OutFile;
static struct reloc_info_68k *TextRelocInfo, *DataRelocInfo;
static struct nlist *SymbolTable;
static unsigned long StringTableSize;
static char *StringTable;
static long SymbolCount;
static long TextRelocCount;
static long DataRelocCount;
static unsigned long ulongtmp;
static int CodeHunkNumber, DataHunkNumber, BssHunkNumber;
static long *DataRefListRoots, *DataRefLists;
static long *TextRefListRoots, *TextRefLists;
static long *DataRefXRef;
static long *BufferSizes;
static short CommonOption, VerboseOption, MakeBSSOption;
static short DeleteCommonOption, SymbolsOption;
static char *CommonFilename;
static char *InFileName, *OutFileName;
static struct exec WorkingExec;
static FILE *CommonFile;
static long *CommonNames;


static unsigned long *MkBssSizes;
static char **MkBssNames;
static char *StringTable;
static long *XRef;


static unsigned char Buffer[BUFFER_SIZE];

static int WordLength[] = { 1, 2, 4, 0 };


char *SourceFilename = __FILE__;

static void
KleanExit(mesg, rc, line)
char *mesg;
int rc;
int line;
{


  if (mesg != NULL)
    fprintf(stderr, "%s line %d: %s\n", SourceFilename, line, mesg);
  else
    if (rc != 0)
      fprintf(stderr, "%s line %d: ReturnCode = %d\n",
              SourceFilename, line, rc);


  if (InFile     != NULL) fclose(InFile);
  if (OutFile    != NULL) fclose(OutFile);
  if (CommonFile != NULL) fclose(CommonFile);

  if (TextRelocInfo    != NULL) free(TextRelocInfo);
  if (DataRelocInfo    != NULL) free(DataRelocInfo);
  if (SymbolTable      != NULL) free(SymbolTable);
  if (StringTable      != NULL) free(StringTable);
  if (TextRefListRoots != NULL) free(TextRefListRoots);
  if (TextRefLists     != NULL) free(TextRefLists);
  if (DataRefListRoots != NULL) free(DataRefListRoots);
  if (DataRefLists     != NULL) free(DataRefLists);
  if (DataRefXRef      != NULL) free(DataRefXRef);
  if (BufferSizes      != NULL) free(BufferSizes);
  if (CommonNames      != NULL) free(CommonNames);

  if (MkBssSizes  != NULL) free(MkBssSizes);
  if (MkBssNames  != NULL) free(MkBssNames);
  if (StringTable != NULL) free(StringTable);
  if (XRef        != NULL) free(XRef);

  exit(rc);
}


void
OpenOutputFile()
{
  if (OutFile != NULL) return;

  OutFile = fopen(OutFileName, "w");

  if (OutFile == NULL) {
    fprintf(stderr, "Can't open file \"%s\" for output.\n", OutFileName);
    CleanExit(NULL, RC_FAIL);
  }
}


static DataRefSortCompare(element1, element2)
long *element1, *element2;
{
  static struct reloc_info_68k *RelocInfo;

  if (element1 == NULL) {
    RelocInfo = (struct reloc_info_68k *)element2;
    return 0;
  }

  return RelocInfo[*element1].r_address - RelocInfo[*element2].r_address;
}


/*
    CopySegments - Copy a segment from the input to the output changing
        the relocated refrences as aproporiate.

        The data is copied through in blocks of about BUFFER_SIZE bytes but
    the actual sizes of the blocks are adjusted so that no relocated words
    are split.  The 'type' is argument N_TEXT or N_DATA and determines
    which block is copied through. CopySegments() does a seek on the input
    file to the correct segment.  Then it copies the segment through
    creating a hunk of the same type as the input segment (N_TEXT ==
    HUNK_CODE and N_DATA == HUNK_DATA).

*/

static void
CopySegments(type)
int type;
{
  long i;
  long SeekPosition;
  long SegmentLength;
  long BlockSize;
  unsigned long HunkType;
  long TextOffset;
  long RelocCount;
  long BufferBlockNumber;
  long BytesDontFit;
  int DataRefCount;
  int BufferBlockCount;
  int DataRefIndex;
  long DataRefAddress;
  int BufferOffset;
  int BytesInWord;
  long BufferStartAddress;
  struct reloc_info_68k *RelocInfo;

  /* Set things up for what segment we're working on. */
  if (type == N_TEXT) {
    SeekPosition = sizeof(struct exec);
    SegmentLength = WorkingExec.a_text;
    HunkType = HUNK_CODE;
    RelocInfo = TextRelocInfo;
    RelocCount = TextRelocCount;
    TextOffset = 0;
  }
  else {
    SeekPosition = sizeof(struct exec) + WorkingExec.a_text;
    SegmentLength = WorkingExec.a_data;
    HunkType = HUNK_DATA;
    RelocInfo = DataRelocInfo;
    RelocCount = DataRelocCount;
    TextOffset = WorkingExec.a_text;
  }

  /* If the segment is empty, don't bother. */
  if (SegmentLength == 0) return;

  if (RelocCount != 0)
    ALLOCATE_MEMORY(DataRefXRef, RelocCount, 4);

  /*
    The references to this object file's own DATA and BSS segments needs
    to be changed because in Sun object files these references are
    relative to the TEXT segment while in Amiga object files they are
    relative to the segment (hunk) they are referencing.
    This code does it's own buffering and it modifies each relocatable
    reference as it goes.  It figures the size of the blocks in a way
    that keeps words from being split between blocks.
  */

  BufferBlockCount = (SegmentLength + BUFFER_SIZE - 1) / BUFFER_SIZE;

  ALLOCATE_MEMORY(BufferSizes, BufferBlockCount + 1, 4);

  for (i = 0; i < BufferBlockCount - 1; ++i)
    BufferSizes[i] = BUFFER_SIZE;

  BufferSizes[BufferBlockCount - 1] = SegmentLength % BUFFER_SIZE;

  DataRefCount = 0;

  for (i = 0; i < RelocCount; ++i) {

    if (RelocInfo[i].r_extern == 0 &&
        ((RelocInfo[i].r_symbolnum & N_TYPE) == N_BSS ||
         (RelocInfo[i].r_symbolnum & N_TYPE) == N_DATA)) {

      DataRefAddress = RelocInfo[i].r_address;
      BytesInWord = WordLength[RelocInfo[i].r_length];

      if (DataRefAddress >= SegmentLength - BytesInWord) {
        fprintf(stderr, "Relocation beyond end of hunk.\n");
        fprintf(stderr, "  RelocationOffset = 0x%lx ", DataRefAddress);
        fprintf(stderr, "in segment type %d\n",
                (int)(RelocInfo[i].r_symbolnum & N_TYPE));
        fprintf(stderr, "  RelocInfo entry number %ld.\n", i);
        CleanExit(NULL, RC_FAIL);
      }

      DataRefXRef[DataRefCount++] = i;

      /* Since we know this word must be at least partially in this block,
         find out how many (if any) bytes are past the end of the block. */

      BytesDontFit = BytesInWord - (BUFFER_SIZE
                                    - (DataRefAddress - TextOffset)
                                    % BUFFER_SIZE);

      if (BytesDontFit > 0) {

        BufferBlockNumber = (DataRefAddress - TextOffset) / BUFFER_SIZE;

        /* Extend this block so that the word will fit, and shorten the
           next one so that the end of the next doesn't change. */

        BufferSizes[BufferBlockNumber    ] += BytesDontFit;
        BufferSizes[BufferBlockNumber + 1] -= BytesDontFit;
      }
    }
  }

  /* Tell the compare function what array to use. */
  DataRefSortCompare(NULL, RelocInfo);

  /* Sort the refrences to the order they appear in the file. */
  qsort((char *)DataRefXRef, DataRefCount, 4, DataRefSortCompare);

  if (VerboseOption > 0) {

    printf("Data and BSS Segment Reference Offsets:\n");

    for (i = 0; i < DataRefCount; ++i) {

      printf("  %08lX\n", RelocInfo[DataRefXRef[i]].r_address);
    }

    printf("Buffer Sizes:\n");

    for (i = 0; i < BufferBlockCount; ++i) {

      printf("  %08lX\n", BufferSizes[i]);
    }
  }

  /* Go to the start of the segment. */
  fseek(InFile, SeekPosition, SEEK_SET);

  WRITE_LONG(HunkType, OutFile);

  WRITE_LONG((SegmentLength + 3) / 4, OutFile);

  DataRefIndex = 0;
  BufferStartAddress = 0;

  for (BufferBlockNumber = 0;
       BufferBlockNumber < BufferBlockCount;
       ++BufferBlockNumber) {

    BlockSize = BufferSizes[BufferBlockNumber];

    if (fread(Buffer, 1, BlockSize, InFile) != BlockSize)
      CleanExit("Can't read segment.", RC_FAIL);

    while (DataRefIndex < DataRefCount) {

      DataRefAddress =
        RelocInfo[DataRefXRef[DataRefIndex]].r_address;

      BufferOffset = DataRefAddress - BufferStartAddress;

      if (BufferOffset >= BlockSize) break;

      ulongtmp = 0;

      BytesInWord =
        WordLength[RelocInfo[DataRefXRef[DataRefIndex]].r_length];

      for (i = 0; i < BytesInWord; ++i)
        ulongtmp = (ulongtmp << 8) | Buffer[BufferOffset++];

      if (VerboseOption > 0)
        printf("[%08lX]\n", ulongtmp);

      ulongtmp -= WorkingExec.a_text;

      if (RelocInfo[DataRefXRef[DataRefIndex]].r_symbolnum == N_BSS)
        ulongtmp -= WorkingExec.a_data;

      for (i = 1; i <= BytesInWord; ++i) {
        Buffer[BufferOffset - i] = ulongtmp & 0xff;
        ulongtmp >>= 8;
      }

      ++DataRefIndex;
    }

    if (fwrite(Buffer, 1, BlockSize, OutFile) != BlockSize)
      CleanExit("Can't write segment.", RC_FAIL);

    BufferStartAddress += BlockSize;
  }

  if (DataRefXRef != NULL) {    /* Free this only if it was allocated. */

    free(DataRefXRef);
    DataRefXRef = NULL;
  }

  free(BufferSizes);
  BufferSizes = NULL;
}


/*
    OutputSymbolName - Output a string to OutFile in the format that Amiga
        object files use... Longword of length, then the string padded with
        zeros.  The upper byte of the length longword is set to 'type'.

*/

static void
OutputSymbolName(symbolname, type)
char *symbolname;
unsigned char type;
{
  int SymbolNameLength;

  SymbolNameLength = strlen(symbolname);

  WRITE_LONG(((SymbolNameLength + 3) / 4) | (type << 24), OutFile);

  fwrite(symbolname, 1, SymbolNameLength, OutFile);

  if (SymbolNameLength % 4 != 0) {

    ulongtmp = 0;
    fwrite((char *)&ulongtmp, 1,
           3 - (SymbolNameLength + 3) % 4, OutFile);
  }
}


/*
    OutputRelocInfo - Generates the HUNK_RELOCxx blocks for a hunk.

 */

static void
OutputRelocInfo(relocinfo, reloccount)
struct reloc_info_68k *relocinfo;
int reloccount;
{
  int FoundAnyOfType, FoundAnyOfBits, Bits;
  long i, ReferenceCount, SeekPosition;
  int NType, ReferencedHunk, Type;
  unsigned long HunkType, RelocAddress;

  int SegmentLength;
  SegmentLength = (relocinfo == TextRelocInfo) ?    /* Yes, this is bad. */
                  WorkingExec.a_text :
                  WorkingExec.a_data;

  for (Bits = 0; Bits < 3; ++Bits) {

    FoundAnyOfBits = FALSE;

    for (Type = 0; Type < 3; ++Type) {

      switch (Type) {

        case 0:
          ReferencedHunk = CodeHunkNumber;
          NType = N_TEXT;
          break;
        case 1:
          ReferencedHunk = DataHunkNumber;
          NType = N_DATA;
          break;
        default:
          ReferencedHunk = BssHunkNumber;
          NType = N_BSS;
      }

      FoundAnyOfType = FALSE;
      ReferenceCount = 0;

      for (i = 0; i < reloccount; ++i) {

        if (relocinfo[i].r_extern    == 0 &&
            relocinfo[i].r_length    == Bits &&
            (relocinfo[i].r_symbolnum & N_TYPE) == NType) {

          if (!FoundAnyOfType) {

            if (!FoundAnyOfBits) {

              FoundAnyOfBits = TRUE;

              switch (Bits) {
                case 0:  HunkType = HUNK_RELOC8;  break;
                case 1:  HunkType = HUNK_RELOC16; break;
                default: HunkType = HUNK_RELOC32; break;
              }

              WRITE_LONG(HunkType, OutFile);
            }


            FoundAnyOfType = TRUE;

            SeekPosition = ftell(OutFile);

            WRITE_LONG(0, OutFile);

            WRITE_LONG(ReferencedHunk, OutFile);
          }

          RelocAddress = relocinfo[i].r_address;

          WRITE_LONG(RelocAddress, OutFile);

          ++ReferenceCount;
        }
      }

      if (FoundAnyOfType) {

        fseek(OutFile, SeekPosition, SEEK_SET);

        WRITE_LONG(ReferenceCount, OutFile);

        fseek(OutFile, 0L, SEEK_END);
      }
    }

    if (FoundAnyOfBits)
      WRITE_LONG(0, OutFile);
  }
}


/*
    OutputExternDefInfo - Generates the EXT_DEF part of a HUNK_EXT for a
        hunk.

*/

static OutputExternDefInfo(type, foundany)
int type, foundany;
{
  long i;
  unsigned long Value;

  for (i = 0; i < SymbolCount; ++i) {

    if ((SymbolTable[i].n_type & (N_TYPE | N_EXT)) == (type | N_EXT)) {

      if (!foundany) {

        WRITE_LONG(HUNK_EXT, OutFile);

        foundany = TRUE;
      }

      OutputSymbolName(SymbolTable[i].n_un.n_name, EXT_DEF);

      Value = SymbolTable[i].n_value;
      if (type == N_DATA) Value -= WorkingExec.a_text;
      if (type == N_BSS) {
        printf("Found a BSS XDef!\n");
        Value -= WorkingExec.a_text + WorkingExec.a_data;
      }

      WRITE_LONG(Value, OutFile);
    }
  }

  return foundany;
}


/*
    OutputExternInfo - Generates the EXT_REFxx blocks for a hunk.

*/

static void
OutputExternInfo(relocinfo, reflistroots, reflists, type)
struct reloc_info_68k *relocinfo;
long *reflistroots, *reflists;
int type;
{
  int FoundAny, Bits, BitType;
  long i, x, Index;
  unsigned long RefAddress, RefAddressLimit;


  for (Bits = 0; Bits < 3; ++Bits) {

    RefAddressLimit =
      (type == N_TEXT ? WorkingExec.a_text : WorkingExec.a_data)
       - WordLength[Bits];

    switch (Bits) {

      case 0:  BitType = EXT_REF8;  break;
      case 1:  BitType = EXT_REF16; break;
      default: BitType = EXT_REF32; break;
    }

    FoundAny = FALSE;

    for (i = 0; i < SymbolCount; ++i) {

      if (reflistroots[i] >= 0 ) {

        x = 0;
        Index = reflistroots[i];

        while (Index >= 0) {

          if (relocinfo[Index].r_length == Bits) ++x;

          Index = reflists[Index];
        }

        if (x != 0) {

          if (!FoundAny) {

            WRITE_LONG(HUNK_EXT, OutFile);

            FoundAny = TRUE;
          }

          OutputSymbolName(SymbolTable[i].n_un.n_name, BitType);

          WRITE_LONG(x, OutFile);

          Index = reflistroots[i];

          while (Index >= 0) {

            if (relocinfo[Index].r_length == Bits) {

              RefAddress = relocinfo[Index].r_address;

              if (RefAddress > RefAddressLimit) {
                fprintf(stderr, "Reference beyond end of hunk.\n");
                fprintf(stderr, "  ReferenceOffset = 0x%lx\n", RefAddress);
                fprintf(stderr, "  RelocInfo entry number %ld.\n", Index);
                CleanExit(NULL, RC_FAIL);
              }

              WRITE_LONG(RefAddress, OutFile);
            }

            Index = reflists[Index];
          }
        }
      }
    }
  }

  FoundAny = OutputExternDefInfo(type, FoundAny);

  if (FoundAny)
    WRITE_LONG(0, OutFile);

}


static void
OutputSymbols(type)
unsigned long type;
{
  long i;
  unsigned long TextOffset;
  int FoundAny;

  switch (type) {

    case N_TEXT:
      TextOffset = 0;
      break;

    case N_DATA:
      TextOffset = WorkingExec.a_text;
      break;

    case N_BSS:
      TextOffset = WorkingExec.a_text + WorkingExec.a_data;
      break;
  }

  FoundAny = FALSE;

  for (i = 0; i < SymbolCount; ++i) {

    if ((SymbolTable[i].n_type & N_TYPE) == type &&
        SymbolTable[i].n_un.n_name != NULL) {

      if (!FoundAny) {

        FoundAny = TRUE;

        WRITE_LONG(HUNK_SYMBOL, OutFile);
      }

      OutputSymbolName(SymbolTable[i].n_un.n_name, 0);

      WRITE_LONG(SymbolTable[i].n_value - TextOffset, OutFile);
    }
  }

  if (FoundAny)
    WRITE_LONG(0, OutFile);
}


/*
    OutputCommonAsBss

*/

static void
OutputCommonAsBss()
{
  long i, CommonBssSize, CommonBssOffset;

  CommonBssSize = 0;

  for (i = 0; i < SymbolCount; ++i) {

    if ((SymbolTable[i].n_type & (N_TYPE | N_EXT)) == (N_UNDF | N_EXT) &&
        SymbolTable[i].n_value != 0)
      CommonBssSize += SymbolTable[i].n_value;
  }

  if (CommonBssSize == 0) return;

  WRITE_LONG(HUNK_BSS,      OutFile);
  WRITE_LONG(CommonBssSize, OutFile);
  WRITE_LONG(HUNK_EXT,      OutFile);

  CommonBssOffset = 0;

  for (i = 0; i < SymbolCount; ++i) {

    if ((SymbolTable[i].n_type & (N_TYPE | N_EXT)) == (N_UNDF | N_EXT) &&
        SymbolTable[i].n_value != 0) {

      OutputSymbolName(SymbolTable[i].n_un.n_name, EXT_DEF);

      WRITE_LONG(CommonBssOffset, OutFile);

      CommonBssOffset += SymbolTable[i].n_value;
    }
  }

  WRITE_LONG(0, OutFile);

  WRITE_LONG(HUNK_END, OutFile);

  return;
}


static void
StupidCommonKludge()
{
  long i, NameIndex, SizeEntryCount, StringCharCount, SeekPosition;
  char *SymbolName;
  int SymbolNameLength;

  if (CommonFilename == NULL) CommonFilename = DefaultCommonFilename;

  if (CommonOption == 1)
    CommonFile = fopen(CommonFilename, "r+");
  else
    CommonFile = fopen(CommonFilename, "w+");

  if (CommonFile == NULL)
    CleanExit("Can't open the stupid common file thing.", RC_FAIL);

  fseek(CommonFile, 0L, SEEK_END);

  SeekPosition = ftell(CommonFile);

  WRITE_LONG(0, CommonFile);
  WRITE_LONG(0, CommonFile);

  SizeEntryCount  = 0;

  for (i = 0; i < SymbolCount; ++i) {

    if ((SymbolTable[i].n_type & (N_TYPE | N_EXT)) == (N_UNDF | N_EXT) &&
        SymbolTable[i].n_value != 0) {

      WRITE_LONG(SymbolTable[i].n_value, CommonFile);

      ++SizeEntryCount;
    }
  }

  StringCharCount = 0;

  if (SizeEntryCount != 0) {

    ALLOCATE_MEMORY(CommonNames, SizeEntryCount, 4);

    NameIndex = 0;

    for (i = 0; i < SymbolCount; ++i) {

      if ((SymbolTable[i].n_type & (N_TYPE | N_EXT)) == (N_UNDF | N_EXT) &&
          SymbolTable[i].n_value != 0) {

        SymbolName = SymbolTable[i].n_un.n_name;
        SymbolNameLength = strlen(SymbolName);

        fwrite(SymbolName, 1, SymbolNameLength + 1, CommonFile);

        CommonNames[NameIndex++] = StringCharCount;

        StringCharCount += SymbolNameLength + 1;
      }
    }

    fwrite((char *)CommonNames, 4, SizeEntryCount, CommonFile);

    free(CommonNames);
    CommonNames = NULL;
  }

  fseek(CommonFile, SeekPosition, SEEK_SET);

  WRITE_LONG(SizeEntryCount, CommonFile);
  WRITE_LONG(StringCharCount, CommonFile);

  if (ferror(CommonFile) != 0)
    CleanExit("Error accessing the CommonFile.", RC_FAIL);

  fclose(CommonFile);
  CommonFile = NULL;
}


static void
FindRefs(type)
int type;
{
  long i, RelocCount;
  long *RefListRoots, *RefLists;
  struct reloc_info_68k *RelocInfo;

  if (type == N_TEXT) {
    RelocInfo = TextRelocInfo;
    RelocCount = TextRelocCount;
    RefLists = TextRefLists;
    RefListRoots = TextRefListRoots;
  }
  else {
    RelocInfo = DataRelocInfo;
    RelocCount = DataRelocCount;
    RefLists = DataRefLists;
    RefListRoots = DataRefListRoots;
  }


  for (i = 0; i < RelocCount; ++i) {

    if (RelocInfo->r_pcrel != 0)
      printf("Warning: pcrel bit set in relocation info.\n");

    if (RelocInfo->r_baserel != 0)
      printf("Warning: baserel bit set in relocation info.\n");

    if (RelocInfo->r_jmptable != 0)
      printf("Warning: jmptable bit set in relocation info.\n");

    if (RelocInfo->r_relative != 0)
      printf("Warning: relative bit set in relocation info.\n");

    if (RelocInfo->r_extern != 0) {

      RefLists[i] = RefListRoots[RelocInfo->r_symbolnum];
      RefListRoots[RelocInfo->r_symbolnum] = i;
    }

    ++RelocInfo;
  }
}


int
CopyIfAmigaObject()
{
  unsigned long BlockSize, NameLength;

  OpenOutputFile();

  fseek(InFile, 0, SEEK_SET);

  /* If it doesn't start with HUNK_UNIT, can't be an amiga object file. */
  if (READ_LONG(InFile) != HUNK_UNIT)
    return FALSE;

  /* Make sure the input file is not an executable. */
  NameLength = READ_LONG(InFile) * 4;
  fseek(InFile, NameLength, SEEK_CUR);
  if (READ_LONG(InFile) == HUNK_HEADER)
    return FALSE;

  fseek(InFile, 0, SEEK_SET);

  LOOP {

    BlockSize = fread(Buffer, 1 , BUFFER_SIZE, InFile);
    if (BlockSize == 0) break;

    fwrite(Buffer, 1, BlockSize, OutFile);
    if (ferror(OutFile))
      CleanExit("Error writing output file.", RC_FAIL);

  }

  if (ferror(InFile))
    CleanExit(ReadErrorMessage, RC_FAIL);

  return TRUE;
}


static void
Usage()
{

  fprintf(stderr, BANNER
"Usage: %s [-v] {[-s] [{[-c[Common-Filename]|-C[Common-Filename]} | -b]\n"
"         Input-Filename [Output-Filename]} | {-m[d] [-cInput-Filename]\n"
"         [Output-Filename]}\n",
  ProgramName);

  CleanExit(NULL, RC_OK);
}


static void
MkBssUsage()
{
  fprintf(stderr, BANNER
"Usage: %s Input-Filename Output-Filename\n",
  ProgramName);

  CleanExit(NULL, RC_FAIL);
}


static int
CompareNames(element1, element2)
long *element1, *element2;
{

  return strcmp(MkBssNames[*element1], MkBssNames[*element2]);
}


void
MakeBSS()
{
  long i;
  char *Name;
  int MaxComm;
  unsigned long Offset;
  long HunkSizeSeekPos;
  unsigned long *SizesNow;
  char **NamesNow;
  char *StringTableNow;
  long SizeEntryCount, StringCharCount;
  long TotalEntryCount, TotalStringLength;

  printf("Making BSS file.\n");

  InFile = fopen(InFileName, "r");

  if (InFile == NULL)
    CleanExit("Can't open input file.", RC_FAIL);

  TotalEntryCount = 0;
  TotalStringLength = 0;

  LOOP {

    SizeEntryCount = READ_LONG(InFile);

    if (feof(InFile)) break;

    StringCharCount = READ_LONG(InFile);

    if (SizeEntryCount == 0) continue;

    TotalEntryCount   += SizeEntryCount;
    TotalStringLength += StringCharCount;

    fseek(InFile, SizeEntryCount * 8 + StringCharCount, SEEK_CUR);
  }

  if (TotalEntryCount != 0) {

    ALLOCATE_MEMORY(MkBssSizes, TotalEntryCount, 4);
    ALLOCATE_MEMORY(MkBssNames, TotalEntryCount, 4);
    ALLOCATE_MEMORY(StringTable, TotalStringLength, 1);
    ALLOCATE_MEMORY(XRef, TotalEntryCount, 4);

    SizesNow       = MkBssSizes;
    NamesNow       = MkBssNames;
    StringTableNow = StringTable;

    fseek(InFile, 0L, SEEK_SET);

    LOOP {

      SizeEntryCount = READ_LONG(InFile);

      if (feof(InFile)) break;

      StringCharCount = READ_LONG(InFile);

      fread((char *)SizesNow, 4, SizeEntryCount, InFile);

      fread(StringTableNow, 1, StringCharCount, InFile);

      fread((char *)NamesNow, 4, SizeEntryCount, InFile);

      if (ferror(InFile))
        CleanExit(ReadErrorMessage, RC_FAIL);

      for (i = 0; i < SizeEntryCount; ++i)
        NamesNow[i] = (unsigned long)NamesNow[i] + StringTableNow;

      SizesNow       += SizeEntryCount;
      NamesNow       += SizeEntryCount;
      StringTableNow += StringCharCount;
    }

    for (i = 0; i < TotalEntryCount; ++i)
      XRef[i] = i;

    qsort((char *)XRef, TotalEntryCount, 4, CompareNames);
  }

  OutFile = fopen(OutFileName, "w");

  if (OutFile == NULL)
    CleanExit("Can't open output file.", RC_FAIL);

  WRITE_LONG(HUNK_UNIT, OutFile);

  WRITE_LONG(0, OutFile);

  if (TotalEntryCount != 0) {

    WRITE_LONG(HUNK_BSS, OutFile);

    HunkSizeSeekPos = ftell(OutFile);

    WRITE_LONG(0, OutFile);

    WRITE_LONG(HUNK_EXT, OutFile);

    i = 0;
    Offset = 0;

    LOOP {

      Name = MkBssNames[XRef[i]];
      MaxComm = MkBssSizes[XRef[i]];

      ++i;

      if (i > TotalEntryCount) break;

      while(strcmp(Name, MkBssNames[XRef[i]]) == 0 &&
            i <= TotalEntryCount) {

        if (MkBssSizes[XRef[i]] > MaxComm)
          MaxComm = MkBssSizes[XRef[i]];

        ++i;
      }

   /* printf("0x%08lX %s\n", MaxComm, Name); */

      OutputSymbolName(Name, EXT_DEF);

      WRITE_LONG(Offset, OutFile);

      Offset += MaxComm;
    }

    WRITE_LONG(0, OutFile);
  }

  WRITE_LONG(HUNK_END, OutFile);

  if (TotalEntryCount != 0) {

    fseek(OutFile, HunkSizeSeekPos, SEEK_SET);

    WRITE_LONG((Offset + 3) / 4, OutFile);
  }

  fclose(OutFile);
  OutFile = NULL;

  fclose(InFile);
  InFile = NULL;

  if (DeleteCommonOption)
    remove(InFileName);
}


void
main(argc, argv)
int argc;
char **argv;
{
  int i, x, FilenameCount, NamedMakeBSS;
  int FoundAny;
  long Index;

  static char FilenameBuffer[MAX_FILENAME_LENGTH + 1];


  printf(VERSION "\n");

#if 0
  /* All these things should already be zeroed because they are BSS or
     zeroed DATA but if main() somehow got called again... */

  CommonFilename = NULL;
  CommonOption   = 0;
  VerboseOption = 0;
  MakeBSSOption = 0;
  SymbolsOption = 0;
  DeleteCommonOption = 0;

  InFileName  = NULL;
  OutFileName = NULL;

  InFile     = NULL;
  OutFile    = NULL;
  CommonFile = NULL;

  TextRelocInfo    = NULL;
  DataRelocInfo    = NULL;
  SymbolTable      = NULL;
  StringTable      = NULL;
  TextRefListRoots = NULL;
  DataRefListRoots = NULL;
  TextRefLists     = NULL;
  DataRefLists     = NULL;
  DataRefXRef      = NULL;
  CommonNames      = NULL;

  MkBssSizes  = NULL;
  MkBssNames  = NULL;
  StringTable = NULL;
  XRef        = NULL;
#endif

  if (argc == 0) exit(0);

  /*
   *  Get the base of the name on the command line.
   */

  ProgramName = argv[0] + strlen(argv[0]);

  while(--ProgramName > argv[0])
    if (*ProgramName == '/' || *ProgramName == ':') {
      ++ProgramName;
      break;
    }

  /*
   *  Set 'NamedMakeBSS' to TRUE if the program's name is 'makebss'.
   */

  {
    char *c1 = ProgramName;
    char *c2 = "MAKEBSS";

    NamedMakeBSS = TRUE;

    while (*c1 && *c2) {

      /* Note: toupper() is a macro and it's argument is evaluated
         more than once. */

      if (toupper(*c1) != *c2) {
        NamedMakeBSS = FALSE;
        break;
      }

      ++c1;
      ++c2;
    }
  }

  /*
   *  If we were called as 'MakeBSS', act it.
   */

  if (NamedMakeBSS) {

    if (argc != 3) MkBssUsage();

    InFileName  = argv[1];
    OutFileName = argv[2];

    MakeBSS();

    CleanExit(NULL, RC_OK);
  }

  if (argc == 1) Usage();   /* Be nice if no arg's are given. */

  FilenameCount = 0;    /* The count of non-options */

  /*
   *  Parse the command line.
   */

  for (i = 1; i < argc; ++i) {

    if (argv[i][0] == OPTION_PREFIX) {

      switch (argv[i][1]) {

        case 'c':
          CommonOption = 1;

          if (argv[i][2] != 0) {

            CommonFilename = argv[i] + 2;
          }
          break;

        case 'C':
          CommonOption = 2;

          if (argv[i][2] != 0) {

            CommonFilename = argv[i] + 2;
          }
          break;

        case 'b':
          CommonOption = 3;
          break;

        case 'v':
          VerboseOption = 1;
          break;

        case 'm':
          MakeBSSOption = 1;

          if (argv[i][2] == 'd')
            DeleteCommonOption = 1;

          break;

        case 's':
          SymbolsOption = 1;
          break;

        default:
          fprintf(stderr, "Bad option.\n");
          Usage();
      }
    }
    else {

      switch (FilenameCount++) {

        case 0:  InFileName  = argv[i]; break;
        case 1:  OutFileName = argv[i]; break;
        default: Usage();
      }
    }
  }

  if (MakeBSSOption) {  /* If '-m' was specified... */

    if (OutFileName != NULL) Usage();   /* Only one non-option allowed. */

    OutFileName = InFileName;   /* That's actually the output file's name. */

    InFileName = CommonFilename;    /* The input if '-c' was used. */

    if (InFileName == NULL)
      InFileName = DefaultCommonFilename;

    if (OutFileName == NULL)
      OutFileName = DefaultBssFilename;

    MakeBSS();

    CleanExit(NULL, RC_OK);
  }

  if (InFileName == NULL) {

    fprintf(stderr, "No input filename.\n");
    Usage();
  }

  if (OutFileName == NULL) {

    if (strlen(InFileName) + strlen(DefaultFilenameExtension) >
        MAX_FILENAME_LENGTH)
      CleanExit("Filename is too long.", RC_FAIL);

    strcpy(FilenameBuffer, InFileName);
    OutFileName = strcat(FilenameBuffer, DefaultFilenameExtension);
  }

  InFile = fopen(InFileName, "r");

  if (InFile == NULL) {
    fprintf(stderr, "Can't open file \"%s\" for input.\n", InFileName);
    CleanExit(NULL, RC_FAIL);
  }

  /*
   *  Try to read the exec structure from the input.
   */

  if (fread((char *)&WorkingExec, sizeof(struct exec), 1, InFile) != 1) {

    /* If the input file is an Amiga object, copy it through unchanged.
       This simplifies linking Sun and Amiga objects together and isn't
       any more kludgy than this whole deal. */

    if (CopyIfAmigaObject())
      CleanExit(NULL, RC_OK);

    fprintf(stderr, "Can't read exec structure in file \"%s\".\n",
            InFileName);
    CleanExit(NULL, RC_FAIL);
  }

  if (WorkingExec.a_magic != SUN_MAGIC) {   /* The only magic supported */

    if (CopyIfAmigaObject())
      CleanExit(NULL, RC_OK);

    fprintf(stderr, "Bad magic number in file \"%s\".\n", InFileName);
    CleanExit(NULL, RC_FAIL);
  }

  if (VerboseOption > 0) {

    printf("exec:\n");

    printf("  dynamic     = 0x%X\n", (int)WorkingExec.a_dynamic);
    printf("  toolversion = 0x%X\n", (int)WorkingExec.a_toolversion);
    printf("  machtype    = 0x%X\n", (int)WorkingExec.a_machtype);
    printf("  text        = 0x%lX\n", WorkingExec.a_text);
    printf("  data        = 0x%lX\n", WorkingExec.a_data);
    printf("  bss         = 0x%lX\n", WorkingExec.a_bss);
    printf("  syms        = 0x%lX\n", WorkingExec.a_syms);
    printf("  entry       = 0x%lX\n", WorkingExec.a_entry);
    printf("  trsize      = 0x%lX\n", WorkingExec.a_trsize);
    printf("  drsize      = 0x%lX\n", WorkingExec.a_drsize);

    printf("\n");
  }

  /* Skip to the relocation info first. */
  fseek(InFile, sizeof(struct exec) +
                WorkingExec.a_text + WorkingExec.a_data, SEEK_SET);

  /*
   *  Get the text and data relocation info.
   */

  if (WorkingExec.a_trsize != 0) {

    ALLOCATE_MEMORY(TextRelocInfo, WorkingExec.a_trsize, 1);

    if (fread((char *)TextRelocInfo, 1, WorkingExec.a_trsize, InFile) !=
        WorkingExec.a_trsize)
      CleanExit("Can't read text relocation info.", RC_FAIL);
  }

  if (WorkingExec.a_drsize != 0) {

    ALLOCATE_MEMORY(DataRelocInfo, WorkingExec.a_drsize, 1);

    if (fread((char *)DataRelocInfo, 1, WorkingExec.a_drsize, InFile) !=
        WorkingExec.a_drsize)
      CleanExit("Can't read data relocation info.", RC_FAIL);
  }

  /*
   *  Get the symbol table.
   */

  if (WorkingExec.a_syms != 0) {

    ALLOCATE_MEMORY(SymbolTable, WorkingExec.a_syms, 1);

    if (fread((char *)SymbolTable, 1, WorkingExec.a_syms, InFile) !=
        WorkingExec.a_syms)
      CleanExit("Can't read symbol table.", RC_FAIL);
  }

  /*
   *  Get the symbols' names.
   */

  /* Find the size of the table. */
  if (fread((char *)&StringTableSize, 4, 1, InFile) != 1)
    CleanExit("Can't read string table size.", RC_FAIL);

  ALLOCATE_MEMORY(StringTable, StringTableSize, 1);

  if (fread((char *)StringTable + 4, 1, StringTableSize - 4, InFile) !=
      StringTableSize - 4)
    CleanExit("Can't read string table.", RC_FAIL);

  /*
   *  Find out how many of these things we have.
   *
   */

  TextRelocCount = WorkingExec.a_trsize / sizeof(struct reloc_info_68k);
  DataRelocCount = WorkingExec.a_drsize / sizeof(struct reloc_info_68k);
  SymbolCount = WorkingExec.a_syms / sizeof(struct nlist);

  /*
   *  For each symbol, make a list of references to external symbols.
   *
   */


  if (SymbolCount != 0) {

    /* Allocate memory for the roots. */
    ALLOCATE_MEMORY(TextRefListRoots, SymbolCount,    4);
    ALLOCATE_MEMORY(DataRefListRoots, SymbolCount,    4);

    /* Allocate memory for the lists. */

    if (TextRelocCount != 0)
      ALLOCATE_MEMORY(TextRefLists,     TextRelocCount, 4);

    if (DataRelocCount != 0)
      ALLOCATE_MEMORY(DataRefLists,     DataRelocCount, 4);

    for (i = 0; i < SymbolCount; ++i) {

      /* Relocate the symbol name ponters. */
      if (SymbolTable[i].n_un.n_strx != 0)
        SymbolTable[i].n_un.n_strx += (unsigned long)StringTable;

      /* Initialize the roots to be -1, meaning empty list. */
      TextRefListRoots[i] = -1;
      DataRefListRoots[i] = -1;
    }


    FindRefs(N_TEXT);

    FindRefs(N_DATA);
  }

  /*
   *  Figure the number of each hunk in the output file.
   */

  x = 0;
  if (WorkingExec.a_text != 0) { CodeHunkNumber = x; ++x; }
  if (WorkingExec.a_data != 0) { DataHunkNumber = x; ++x; }
  if (WorkingExec.a_bss  != 0) { BssHunkNumber  = x; ++x; }

  /*
   *  Write the output file.
   */

  OpenOutputFile();

  /* Unnamed program unit. */
  WRITE_LONG(HUNK_UNIT, OutFile);
  WRITE_LONG(0, OutFile);

  /*
   *  Output the CODE, DATA and BSS hunks.
   */

  if (WorkingExec.a_text != 0) {

    CopySegments(N_TEXT);

    OutputRelocInfo(TextRelocInfo, TextRelocCount);

    OutputExternInfo(TextRelocInfo, TextRefListRoots, TextRefLists, N_TEXT);

    if (SymbolsOption) OutputSymbols(N_TEXT);

    WRITE_LONG(HUNK_END, OutFile);
  }

  if (WorkingExec.a_data != 0) {

    CopySegments(N_DATA);

    OutputRelocInfo(DataRelocInfo, DataRelocCount);

    OutputExternInfo(DataRelocInfo, DataRefListRoots, DataRefLists, N_DATA);

    if (SymbolsOption) OutputSymbols(N_DATA);

    WRITE_LONG(HUNK_END, OutFile);
  }

  if (WorkingExec.a_bss != 0) {

    WRITE_LONG(HUNK_BSS, OutFile);

    WRITE_LONG(WorkingExec.a_bss, OutFile);

    OutputExternDefInfo(N_BSS, FALSE);

    if (SymbolsOption) OutputSymbols(N_BSS);

    WRITE_LONG(HUNK_END, OutFile);
  }

  /* We're done with the input file. */
  fclose(InFile);
  InFile = NULL;

  /*
   *   Output absolute external definitions.  Output common block
   *   definitions if aproprate.  These things are done in a seperate hunk
   *   with no HUNK_CODE, ..DATA, or ..BSS.
   */

  FoundAny = FALSE;

  for (i = 0; i < SymbolCount; ++i) {

    if ((SymbolTable[i].n_type & (N_TYPE | N_EXT)) == (N_ABS | N_EXT)) {

      if (!FoundAny) {

        WRITE_LONG(HUNK_EXT, OutFile);

        FoundAny = TRUE;
      }

      OutputSymbolName(SymbolTable[i].n_un.n_name, EXT_ABS);

      WRITE_LONG(SymbolTable[i].n_value, OutFile);
    }
  }

  if (CommonOption == 0) {

    for (i = 0; i < SymbolCount; ++i) {

      if ((SymbolTable[i].n_type & (N_TYPE | N_EXT)) == (N_UNDF | N_EXT) &&
          SymbolTable[i].n_value != 0) {

        if (!FoundAny) {

          WRITE_LONG(HUNK_EXT, OutFile);

          FoundAny = TRUE;
        }

        OutputSymbolName(SymbolTable[i].n_un.n_name, EXT_COMMON);

        WRITE_LONG(SymbolTable[i].n_value, OutFile);

        WRITE_LONG(0, OutFile);
      }
    }
  }

  if (FoundAny) {

    WRITE_LONG(0, OutFile);

    WRITE_LONG(HUNK_END, OutFile);
  }

  /* Ho hum. */

  if (CommonOption >= 1 && CommonOption <= 2)
    StupidCommonKludge();

  if (CommonOption == 3)
    OutputCommonAsBss();

  fclose(OutFile);
  OutFile = NULL;

  if (VerboseOption > 0) {  /* This mind intentionally left blank. */

    printf("%ld symbols.\n", SymbolCount);

    for (i = 0; i < SymbolCount; ++i) {

      x = 0;
      Index = TextRefListRoots[i];

      while (Index >= 0) {
        Index = TextRefLists[Index];
        ++x;
      }

      printf("%3d %s\n", x, SymbolTable[i].n_un.n_name);
    }

    printf("\n%ld Text Relocations.\n", TextRelocCount);

    for (i = 0; i < TextRelocCount; ++i) {

      Index = TextRelocInfo[i].r_symbolnum;

      printf("%08lX %1d %1d %1d %1d %1d %1d ",
             TextRelocInfo[i].r_address,
             TextRelocInfo[i].r_pcrel,
             TextRelocInfo[i].r_length,
             TextRelocInfo[i].r_extern,
             TextRelocInfo[i].r_baserel,
             TextRelocInfo[i].r_jmptable,
             TextRelocInfo[i].r_relative);

      if (TextRelocInfo[i].r_extern == 1) {

        printf("%s\n", SymbolTable[Index].n_un.n_name);
      }
      else {

        printf("n_type = %02lX\n", Index);
      }
    }

    printf("\n%ld Data Relocations.\n", DataRelocCount);

    for (i = 0; i < DataRelocCount; ++i) {

      Index = DataRelocInfo[i].r_symbolnum;

      printf("%08lX %1d %1d %1d %1d %1d %1d ",
             DataRelocInfo[i].r_address,
             DataRelocInfo[i].r_pcrel,
             DataRelocInfo[i].r_length,
             DataRelocInfo[i].r_extern,
             DataRelocInfo[i].r_baserel,
             DataRelocInfo[i].r_jmptable,
             DataRelocInfo[i].r_relative);

      if (DataRelocInfo[i].r_extern == 1) {

        printf("%s\n", SymbolTable[Index].n_un.n_name);
      }
      else {

        printf("n_type = %02lX\n", Index);
      }
    }
  }

  CleanExit(NULL, RC_OK);
}

