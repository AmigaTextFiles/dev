#define NAME	     "HunkFunc"
#define VERSION      "1"
#define REVISION     "17"
#define DATE         "03.09.2002"
#define DISTRIBUTION "(Freeware) "
#define AUTHOR       "by Dirk Stöcker <stoecker@epost.de>"

/* Programmheader

	Name:		HunkFunk
	Author:		SDI
	Distribution:	PD
	Description:	object/binary file scanner
	Compileropts:	-
	Linkeropts:	-gsi -l amiga

 1.0   12.02.98 : made with help of Olaf 'Olsen' Barthel's HunkFunk
 1.1   23.03.98 : now prints reloc infos
 1.2   23.11.98 : added new overlay format
 1.3   09.12.98 : added CHIP, FAST, ADVISORY to CODE/DATA/BSS hunks
 1.4   28.12.98 : unknown hunk now prints 8 digits
 1.5   30.08.99 : 4 new switches for command line, fixed lots of stuff
 1.6   13.09.99 : better support for Overlay files
 1.7   15.09.99 : changed overlay support, added SOVT keyword
 1.8   27.09.99 : displays extra stuff message
 1.9   03.11.99 : added number of EXT_REF's
 1.10  13.11.99 : added H&P EHF stuff
 1.11  29.11.99 : added CTRL_C to reloc print
 1.12  26.06.00 : added abort for defective relocs, fixed overflow bugs
 1.13  03.06.01 : added EXT_REF display
 1.14  17.06.01 : added SEREF argument
 1.15  17.08.01 : added support for strange headers, optimized
 1.16  26.05.02 : little fix
 1.17  03.09.02 : little fix with corrupt relocs
*/

#include <proto/dos.h>
#include <proto/exec.h>
#include <exec/memory.h>
#include <dos/doshunks.h>

/* CHIP, FAST and ADVISORY information is repeated in hunk itself. If
the word is used normally, the information is in second longword (size).
If it is preceeded by a '_', the information is in first longword (hunk
type). */

#define version "$VER: " NAME " " VERSION "." REVISION " (" DATE ") " DISTRIBUTION AUTHOR
#define PARAM "FILE/M/A,SREL=SHOWRELOC/S,SSYM=SHOWSYMBOL/S,SEXT=SHOWEXTERN/S,SEREF=SHOWEXTERNREF/S," \
              "SOVT=SHOWOVERLAYTABLE/S,STATS/S"

/* Some simple macros. */
#define ReadLong(Type)	  Read(FileHandle, (Type), 4)
#define ReadWord(Type)	  Read(FileHandle, (Type), 2)
#define ReadName(Longs)   Read(FileHandle, NameString, 4 * (Longs))
#define SkipLong(Longs)   Seek(FileHandle, 4 * (Longs), OFFSET_CURRENT)
#define SkipWord(Words)	  Seek(FileHandle, 2* (Words), OFFSET_CURRENT)
#define SkipByte(Bytes)	  Seek(FileHandle, (Bytes), OFFSET_CURRENT)
#define MakeName(Longs)   NameString[(Longs) * 4] = 0
#define GetHunkName(Type) HunkNames[(Type)-HUNK_UNIT]
#define CTRL_C		  (SetSignal(0L,0L) & SIGBREAKF_CTRL_C)

/* only the really used entries are activated */
static const STRPTR HunkNames[] = { /* access them with HunkNames[Type-HUNK_UNIT] */
0/*"HUNK_UNIT"*/,
0/*"HUNK_NAME"*/,
   "HUNK_CODE",
   "HUNK_DATA",
   "HUNK_BSS", 
   "HUNK_(ABS)RELOC32",
   "HUNK_(REL)RELOC16",
   "HUNK_(REL)RELOC8",
0/*"HUNK_EXT"*/,
0/*"HUNK_SYMBOL"*/,
0/*"HUNK_DEBUG"*/,
0/*"HUNK_END"*/,
0/*"HUNK_HEADER"*/,
0/*""*/,
0/*"HUNK_OVERLAY"*/,
0/*"HUNK_BREAK"*/,
   "HUNK_DREL32",
   "HUNK_DREL16",
   "HUNK_DREL8",
0/*"HUNK_LIB"*/,
0/*"HUNK_INDEX"*/,
   "HUNK_RELOC32SHORT",
   "HUNK_RELRELOC32",
   "HUNK_ABSRELOC16",
   "HUNK_DREL32EXE"
};

#define HUNK_DREL32EXE	(HUNK_ABSRELOC16+1)

#define HUNK_PPC_CODE	0x4E9
#define HUNK_RELRELOC26	0x4EC
#define EXT_RELREF26	229

struct Args {
  STRPTR * files;
  ULONG    showreloc;
  ULONG    showsymbol;
  ULONG    showextern;
  ULONG    showexternref;
  ULONG	   showoverlaytable;
  ULONG    stats;
};

struct Stats {
  ULONG Header;
  ULONG Unit;
  ULONG Lib;
  ULONG Code;
  ULONG Data;
  ULONG BSS;
  ULONG Debug;
  ULONG Symbol;
  ULONG Extern;
  ULONG Reloc;
  ULONG NumSymbol;
  ULONG NumReloc;
  ULONG NumExtern;
  ULONG CodeSize;
  ULONG DataSize;
  ULONG BSSSize;
  ULONG DebugSize;
  ULONG PPCCode;
  ULONG PPCCodeSize;
};

static void ShowStats(struct Stats *, struct DosLibrary *);
static LONG ProcessFile(BPTR, ULONG, ULONG, ULONG, ULONG, ULONG, struct Stats *, struct DosLibrary *, struct ExecBase *);

ULONG start(void)
{
  ULONG ret = RETURN_FAIL, err;
  BPTR fh;
  struct DosLibrary *DOSBase;
  struct ExecBase * SysBase = (*((struct ExecBase **) 4));

  { /* test for WB and reply startup-message */
    struct Process *task;
    if(!(task = (struct Process *) FindTask(0))->pr_CLI)
    {
      WaitPort(&task->pr_MsgPort);
      Forbid();
      ReplyMsg(GetMsg(&task->pr_MsgPort));
      return RETURN_FAIL;
    }
  }

  if((DOSBase = (struct DosLibrary *) OpenLibrary("dos.library", 37)))
  {
    struct Args args;
    struct RDArgs *rda;

    /* gets removed in optimizer run */
    err = (ULONG) version;
    for(err = 0; err < sizeof(struct Args); ++err)
      ((UBYTE *) (&args))[err] = 0;
    if((rda = ReadArgs(PARAM, (LONG *) &args, 0)))
    {
      ret = 0;
      while(*args.files)
      {
        if((fh = Open(*args.files, MODE_OLDFILE)))
        {
	  struct Stats stats;

          Printf("File '%s':\n", *args.files);
          for(err = 0; err < sizeof(struct Stats); ++err)
            ((UBYTE *) (&stats))[err] = 0;
          err = ProcessFile(fh, args.showreloc, args.showsymbol, args.showextern, args.showexternref,
          args.showoverlaytable, &stats, DOSBase, SysBase);
          if(err == 2)
            Printf("Unexpected end of file.\n");
          if(args.stats)
            ShowStats(&stats, DOSBase);
          Close(fh);
        }
        else
          PrintFault(IoErr(), *args.files);
        if(CTRL_C)
          SetIoErr(ERROR_BREAK);
        ++args.files;
      }
    }
    
    if(ret)
      PrintFault(IoErr(), 0);

    CloseLibrary((struct Library *) DOSBase);
  }
  return ret;
}

static STRPTR GetTabs(STRPTR NameString)
{
  ULONG i = 0;

  while(*(NameString++) && i < 24)
   ++i;
  i >>= 3;
  
  return "\t\t\t"+i;
}

static void ShowStats(struct Stats *stats, struct DosLibrary *DOSBase)
{
  Printf("STATISTICS:\nFile type\t");
  if(stats->PPCCode)
    Printf("PPC-WOS Objectfile");
  else if(stats->Header)
    Printf("Executable");
  else if(stats->Lib)
    Printf("New style link library");
  else if(stats->Unit > 1)
    Printf("Old style link library");
  else
    Printf("Objectfile");
  Printf("\n");

  Printf("HUNK_CODE\t%6ld with total %6ld ($%06lx) Bytes\n", stats->Code, stats->CodeSize, stats->CodeSize);
  if(stats->PPCCode)
    Printf("HUNK_PPC_CODE\t%6ld with total %6ld ($%06lx) Bytes\n", stats->PPCCode, stats->PPCCodeSize, stats->PPCCodeSize);
  Printf("HUNK_DATA\t%6ld with total %6ld ($%06lx) Bytes\n", stats->Data, stats->DataSize, stats->DataSize);
  Printf("HUNK_BSS\t%6ld with total %6ld ($%06lx) Bytes\n", stats->BSS, stats->BSSSize, stats->BSSSize);
  Printf("HUNK_DEBUG\t%6ld with total %6ld ($%06lx) Bytes\n", stats->Debug, stats->DebugSize, stats->DebugSize);
  Printf("HUNK_EXT\t%6ld with total %6ld entr%s\n", stats->Extern, stats->NumExtern, stats->NumExtern == 1 ? "y" : "ies");
  Printf("HUNK_RELOC\t%6ld with total %6ld entr%s\n", stats->Reloc, stats->NumReloc, stats->NumReloc == 1 ? "y" : "ies");
  Printf("HUNK_SYMBOL\t%6ld with total %6ld entr%s\n", stats->Symbol, stats->NumSymbol, stats->NumSymbol == 1 ? "y" : "ies");
}

static void PrintMemType(ULONG t, struct DosLibrary *DOSBase)
{
  Printf(" MEMTYPE("/*)*/);
  if(!t) Printf("MEMF_ANY");
  if(t&MEMF_PUBLIC)     { t &= ~MEMF_PUBLIC;     Printf("MEMF_PUBLIC%s", t ? "|" : ""); }
  if(t&MEMF_CHIP)       { t &= ~MEMF_CHIP;       Printf("MEMF_CHIP%s", t ? "|" : ""); }
  if(t&MEMF_FAST)       { t &= ~MEMF_FAST;       Printf("MEMF_FAST%s", t ? "|" : ""); }
  if(t&MEMF_LOCAL)      { t &= ~MEMF_LOCAL;      Printf("MEMF_LOCAL%s", t ? "|" : ""); }
  if(t&MEMF_24BITDMA)   { t &= ~MEMF_24BITDMA;   Printf("MEMF_24BITDMA%s", t ? "|" : ""); }
  if(t&MEMF_KICK)       { t &= ~MEMF_KICK;       Printf("MEMF_KICK%s", t ? "|" : ""); }
  if(t&MEMF_CLEAR)      { t &= ~MEMF_CLEAR;      Printf("MEMF_CLEAR%s", t ? "|" : ""); }
  if(t&MEMF_LARGEST)    { t &= ~MEMF_LARGEST;    Printf("MEMF_LARGEST%s", t ? "|" : ""); }
  if(t&MEMF_REVERSE)    { t &= ~MEMF_REVERSE;    Printf("MEMF_REVERSE%s", t ? "|" : ""); }
  if(t&MEMF_TOTAL)      { t &= ~MEMF_TOTAL;      Printf("MEMF_TOTAL%s", t ? "|" : ""); }
  if(t&MEMF_NO_EXPUNGE) { t &= ~MEMF_NO_EXPUNGE; Printf("MEMF_NO_EXPUNGE%s", t ? "|" : ""); }
  /* TOTAL and LARGEST should never be possible */
  if(t) Printf("%lx",t);

  Printf(/*(*/")");
}

/* return 0 on error */
static LONG ProcessFile(BPTR FileHandle, ULONG showreloc, ULONG showsymbol, ULONG showextern, ULONG showexternref, 
ULONG showoverlaytable, struct Stats *stats, struct DosLibrary *DOSBase, struct ExecBase *SysBase)
{
  ULONG Type, Data, i;
  UBYTE NameString[257];

  while(!CTRL_C)
  {
    if((i = ReadLong(&Type)) != 4)
    {
      if(i)
        Printf("There %s %ld extra byte%s at end of file.\n", i == 1 ? "is" : "are", i, i == 1 ? "" : "s");
      return 0;
    }

    if(Type == HUNK_DREL32 && stats->Header)
      Type = HUNK_DREL32EXE;

    /* Look which type it is. */
    switch(Type & 0xFFFF)
    {
    case HUNK_UNIT:
      ++stats->Unit;
      ReadLong(&Data);
      if(Data)
        ReadName(Data);
      MakeName(Data);
      Printf("HUNK_UNIT\t\"%s\"\n\n", NameString);
      break;
    case HUNK_NAME:
      ReadLong(&Data);
      if(Data)
        ReadName(Data);
      MakeName(Data);
      Printf("HUNK_NAME\t\"%s\"\n", NameString);
      break;
    case HUNK_LIB:
      ++stats->Lib;
      ReadLong(&Data);
      Printf("HUNK_LIB\t%6ld ($%06lx) Bytes\n\n", Data, Data);
      break;
    case HUNK_INDEX:
      {
        UWORD dat2;

        ReadLong(&Data);
        Printf("HUNK_INDEX\t%6ld ($%06lx) Bytes\n", Data, Data);
        ReadWord(&dat2);
        SkipByte((Data*4)-2);
	Printf("  Textsize =\t%6ld Bytes\n\n", dat2);
      }
      break;
    case HUNK_CODE: case HUNK_DATA: case HUNK_BSS:
      ReadLong(&Data);
      i = Data;
      Data <<= 2;
      Data &= 0x7FFFFFFF;
      switch(Type&0xFFFF)
      {
      case HUNK_CODE: ++stats->Code; stats->CodeSize += Data; SkipByte(Data); break;
      case HUNK_DATA: ++stats->Data; stats->DataSize += Data; SkipByte(Data); break;
      case HUNK_BSS: ++stats->BSS; stats->BSSSize += Data; break;
      }
      Printf("%s\t%6ld ($%06lx) Bytes", GetHunkName(Type), Data, Data);
      if(Type & HUNKF_CHIP)		Printf(" _CHIP");
      if(Type & HUNKF_FAST)		Printf(" _FAST");
      if(Type & HUNKF_ADVISORY) 	Printf(" _ADVISORY");
      if(i & HUNKF_CHIP)		Printf(" CHIP");
      if(i & HUNKF_FAST)		Printf(" FAST");
      if(i & HUNKF_ADVISORY) 		Printf(" ADVISORY");
      Printf("\n");
      break;
    case HUNK_PPC_CODE:
      ReadLong(&Data);
      i = Data;
      Data <<= 2;
      Data &= 0x7FFFFFFF;
      ++stats->PPCCode; stats->PPCCodeSize += Data;
      SkipByte(Data);
      Printf("HUNK_PPC_CODE\t%6ld ($%06lx) Bytes", Data, Data);
      if(Type & HUNKF_CHIP)		Printf(" _CHIP");
      if(Type & HUNKF_FAST)		Printf(" _FAST");
      if(Type & HUNKF_ADVISORY) 	Printf(" _ADVISORY");
      if(i & HUNKF_CHIP)		Printf(" CHIP");
      if(i & HUNKF_FAST)		Printf(" FAST");
      if(i & HUNKF_ADVISORY) 		Printf(" ADVISORY");
      Printf("\n");
      break;
    case HUNK_RELRELOC32: case HUNK_ABSRELOC16: case HUNK_RELRELOC26:
    case HUNK_RELOC32: case HUNK_RELOC16: case HUNK_RELOC8:
    case HUNK_DREL32: case HUNK_DREL16: case HUNK_DREL8:
      if(Type == HUNK_RELRELOC26)
        Printf("HUNK_RELRELOC26\n");
      else
        Printf("%s\n", GetHunkName(Type));
      ++stats->Reloc;

      do
      {
	if(ReadLong(&Data) != 4)
	  return 2;
	if(Data)
	{
	  ULONG dat2 = 0, dat3;
	  ReadLong(&dat2);
	  stats->NumReloc += Data;
	  Printf("  Summary\t%6ld entr%s to hunk %ld%s\n", Data,
	  Data == 1 ? "y" : "ies", dat2, Data > 0xFFFF ? " (LoadSeg fails)" : "");
	  if(showreloc)
	  {
	    for(dat3 = Data; dat3 && !CTRL_C; --dat3)
	    {
	      if(ReadLong(&dat2) != 4)
	        return 2;
	      Printf("  Offset\t\t$%08lx\n", dat2);
	    }
	  }
	  else if(SkipLong(Data&0xFFFF) < 0) /* 0xFFFF as security */
	    return 3;
	}
      } while(!CTRL_C && Data);
      break;
    case HUNK_RELOC32SHORT: case HUNK_DREL32EXE:
      {
        UWORD Data = 0;
        ULONG nums = 0;
        Printf("%s\n", GetHunkName(Type));
        ++stats->Reloc;

        do
        {
	  UWORD dat2 = 0;
	  ULONG dat3;
	  if(ReadWord(&Data) != 2)
	    return 2;
	  if(Data)
	  {
            ReadWord(&dat2);
            stats->NumReloc += Data;
	    Printf("  Summary\t%6ld entr%s to hunk %ld\n", Data,
	    Data == 1 ? "y" : "ies", dat2);
	    if(showreloc)
	    {
	      for(dat3 = Data; dat3 && !CTRL_C; --dat3)
	      {
	        if(ReadWord(&dat2) != 2)
	          return 2;
	        Printf("  Offset\t\t$%04lx\n", dat2);
	      }
	    }
	    else
	      SkipWord(Data);
	    nums += Data;
	  }
        } while(!CTRL_C && Data);
        if(!(nums & 1))
          SkipWord(1);
      }
      break;
    case HUNK_EXT:
      Printf("HUNK_EXT\n");
      ++stats->Extern;

      do
      {
	LONG i;

        ReadLong(&Data);
        if(!Data)
	  break;
	++stats->NumExtern;
	if(showextern)
	{
          switch((Data >> 24) & 0xFF)
	  {
	  case EXT_DEF:       Printf("  EXT_DEF"); break;
	  case EXT_ABS:       Printf("  EXT_ABS"); break;
	  case EXT_RES:       Printf("  EXT_RES"); break;
	  case EXT_REF32:     Printf("  EXT_REF32"); break;
	  case EXT_COMMON:    Printf("  EXT_COMMON"); break;
	  case EXT_REF16:     Printf("  EXT_REF16"); break;
	  case EXT_REF8:      Printf("  EXT_REF8"); break;
	  case EXT_DEXT32:    Printf("  EXT_DEXT32"); break;
	  case EXT_DEXT16:    Printf("  EXT_DEXT16"); break;
	  case EXT_DEXT8:     Printf("  EXT_DEXT8"); break;
	  case EXT_RELREF32:  Printf("  EXT_RELREF32"); break;
	  case EXT_RELREF26:  Printf("  EXT_RELREF26"); break;
	  case EXT_RELCOMMON: Printf("  EXT_RELCOMMON"); break;
	  default: Printf("  EXT_??? ($%02x)\n",(Data >> 24) & 0xFF);
	    break;
          }
        }

	/* Is it followed by a symbol name? */

	if(Data & 0xFFFFFF)
	{
	  ReadName(Data & 0xFFFFFF);
	  MakeName(Data & 0xFFFFFF);
	  if(showextern)
            Printf("\t%s", NameString);
        }

	/* Remember extension type. */
        i = (Data >> 24) & 0xFF;

	/* Display value of symbol. */
        if(i == EXT_DEF || i == EXT_ABS || i == EXT_RES)
        {
	  if(!(Data & 0xFFFFFF) && showextern)
	    Printf("\t???");

	  ReadLong(&Data);
	  if(showextern)
	    Printf("%s= $%08lx", GetTabs(NameString), Data);
	}

	/* Skip relocation information. */
        if(i == EXT_REF32 || i == EXT_REF16 || i == EXT_REF8 ||
        i == EXT_DEXT32 || i == EXT_DEXT16 || i == EXT_DEXT8 ||
        i == EXT_RELREF32 || i == EXT_RELREF26)
	{
	  ReadLong(&Data);
	  if(showextern)
	  {
	    ULONG d;

	    if(Data > 1)
	    {
	      Printf("%s= %ld entries", GetTabs(NameString), Data);
	      if(showexternref)
	      {
	        while(Data--)
	        {
	          ReadLong(&d);
	          Printf("\n\t\t%s= $%08lx", GetTabs(""), d);
	        }
	      }
	      else
	        SkipLong(Data);
	    }
	    else
	    {
	      ReadLong(&d);
	      Printf("%s= $%08lx (1 entry)", GetTabs(NameString), d);
	    }
	  }
	  else
	    SkipLong(Data);
	}

	/* Display size of common block. */
        if(i == EXT_COMMON || i == EXT_RELCOMMON)
	{
	  ReadLong(&Data);

	  if(showextern)
	    Printf("\tSize = %ld Bytes", Data << 2);
	  ReadLong(&Data);
	  SkipLong(Data);
	}
	if(showextern)
          Printf("\n");
      } while(!CTRL_C);
      break;
    case HUNK_SYMBOL:
      Printf("HUNK_SYMBOL\n");
      ++stats->Symbol;

      do
      {
	ReadLong(&Data);

	if(!Data)
	  break;

	++stats->NumSymbol;
	/* Display name. */
        ReadName(Data & 0xFFFFFF);
        MakeName(Data & 0xFFFFFF);

	if(showsymbol)
          Printf("  Symbol\t%s", NameString);

	/* Display value. */
        ReadLong(&Data);

	if(showsymbol)
	  Printf("%s= $%08lx\n", GetTabs(NameString), Data);
      } while(!CTRL_C);
      break;
    case HUNK_DEBUG:
      ++stats->Debug;
      ReadLong(&Data);
      SkipLong(Data);
      Data <<= 2;
      stats->DebugSize += Data;
      Printf("HUNK_DEBUG\t%6ld ($%06lx) Bytes\n", Data, Data);
      break;
    case HUNK_END:
      Printf("HUNK_END\n\n");
      break;
    case HUNK_HEADER:
      Printf("HUNK_HEADER\n");

      ++stats->Header;

      do
      {
        ULONG data2;

	if(ReadLong(&Data) != 4)
	  return 2;

	/* Display names of resident libraries. */
        if(!Data)
          break;

	if((data2 = Data) > 64)
	  data2 = 64;
	Data -= data2;

	if(ReadName(data2) != 4*data2)
	  return 2;
	if(Data && SkipLong(Data) < 0)
	  return 2;
	MakeName(data2);

	Printf("  Name =\t%s\n", NameString);
      } while(!CTRL_C);

      if(!CTRL_C)
      {
        LONG i,From,To;

        ReadLong(&Data);

	Printf("  Numhunks =\t%6ld (", Data&0x3FFFFFFF);
        ReadLong(&From);
        Printf("%ld to ", From&0xFFFF);
        ReadLong(&To);
        Printf("%ld)",To & 0xFFFF);
        /* memflags are supported for header also - dos internal alloc function */
        if((Data & 0xE0000000) || (From & 0xFFFF0000) || (To & 0xFFFF0000))
        {
          Printf("       ");
          if((Data & HUNKF_CHIP) && (Data & HUNKF_FAST))
	  {	/* extended type */
	    ULONG t;
	    ReadLong(&t);
	    PrintMemType(t, DOSBase);
	  }
	  else
	  {
            if(Data & HUNKF_CHIP)	Printf(" CHIP");
            if(Data & HUNKF_FAST)	Printf(" FAST");
          }
          if(Data & HUNKF_ADVISORY)	Printf(" ADVISORY");
          if((From & 0xFFFF0000) || (To & 0xFFFF0000))
          {
            To &= 0xFFFF;
            From &= 0xFFFF;
            Printf(" wasted upper bytes");
          }
        }

        Printf("\n");
        /* Display hunk lengths/types. */
        for(i = 0; !CTRL_C && i < To - From + 1; ++i)
        {
	  ReadLong(&Data);
          Printf("  Hunk %03ld =\t%6ld ($%06lx) Bytes", i,
          (Data & 0x3FFFFFFF) << 2, (Data & 0x3FFFFFFF) << 2);

	  if((Data & HUNKF_CHIP) && (Data & HUNKF_FAST))
	  {	/* extended type */
	    ULONG t;
	    ReadLong(&t);
	    PrintMemType(t, DOSBase);
	  }
	  else
	  {
            if(Data & HUNKF_CHIP)	Printf(" CHIP");
            if(Data & HUNKF_FAST)	Printf(" FAST");
          }
          if(Data & HUNKF_ADVISORY)	Printf(" ADVISORY");

	  Printf("\n");
        }
        Printf("\n");
      }
      break;
    case HUNK_OVERLAY:
      {
        LONG TabSize, Data, Data2 = 0;
        ULONG *ovt = 0;

        Printf("HUNK_OVERLAY\n");
        ReadLong(&TabSize);
	Printf("  TableSize\t%6ld ($%06lx) Bytes\n", TabSize*4, TabSize*4);

	if(TabSize)
	{
	  ReadLong(&Data2);
	  if(showoverlaytable && (ovt = (ULONG *) AllocVec(TabSize*4, MEMF_ANY)))
	    Read(FileHandle, ovt, TabSize*4);
	  else
	    SkipLong(TabSize);
	}
	ReadLong(&Data);
	if(!TabSize && Data == HUNK_BREAK)
	{
	  Data = Seek(FileHandle, 0, OFFSET_END);
	  Data = Seek(FileHandle, 0, OFFSET_END) - Data;
	  Printf("HUNK_BREAK\n\nLeft Space\t%6ld ($%06lx) Bytes\n", Data, Data);
	}
	else if(TabSize && Data >= HUNK_UNIT && Data <= HUNK_ABSRELOC16)
	{
	  Seek(FileHandle, -4, OFFSET_CURRENT);
	  Printf("  Levels\t%6ld\n", Data2-2);
	  Printf("  Entries\t%6ld\n", (TabSize-Data2+1) >> 3);
	}
	else
	{
	  Data = Seek(FileHandle, 0, OFFSET_END);
	  Data = Seek(FileHandle, 0, OFFSET_END) - Data;
	  Printf("  DataSize\t%6ld ($%06lx) Bytes\n", Data+8, Data+8);
	  if(ovt)
	  {
	    for(Data = TabSize-1; Data; --Data)
	      ovt[Data] = ovt[Data-1];
	    ovt[0] = Data2;
	  }
	}
	if(ovt)
	{
	  Data2 = 0;
	  while(Data2 < TabSize)
	  {
	    Printf("  Data $%04lx\t", Data2*4);
	    for(Data = 0; Data < 4; ++Data)
	    {
	      if(Data2 < TabSize)
	      {
	        Printf("%08lx%s", ovt[Data2], Data2 < TabSize-1 ? " " : "");
	        ++Data2;
	      }
	    }
	    Printf("\n");
	  }
	  FreeVec(ovt);
	}
	Printf("\n");
      }
      break;
    case HUNK_BREAK:
      Printf("HUNK_BREAK\n\n");
      break;
    default:
      Printf("HUNK_??? ($%08lx) - Aborting!\n\n", Type);
      return 1;
    }
  }

  return 0;
}
