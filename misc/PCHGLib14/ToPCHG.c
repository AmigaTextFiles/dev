;/* Execute me if you want to compile me.
sc OPTIMIZE NOSTKCHK IGNORE=73 STREQ UNSCHAR STRMERGE PARMS=REG ToPCHG
slink from ToPCHG.o to ToPCHG lib lib:amiga.lib lib:sc.lib lib:pchgr.lib SC SD ND
quit

                                  ToPCHG.c

                            by Sebastiano Vigna


This file is placed in the public domain.
This program works only under 2.04.

ToPCHG will convert one or many ILBM files (FORMs, LISTs and CATs) with
line-by-line palette change info given by SHAM and CTBL to the new PCHG
(Palette Change) format. If there's nothing to change the file is rewritten
with no changes (up to some reordering of the chunks, which is irrelevant by
the ILBM specification). The conversion however is only at file format
level. There is no real image processing done. Thus, in order to follow the
limitation suggested in the PCHG specs, ToPCHG will simply cut out exceeding
changes (i.e., changes on odd line in laced pictures or changes after the
MAX_CHANGES_PER_LINEth one, unless the AllChanges switch is specified). The
result is quite ugly; thus, ToPCHG is mainly an easy way of producing
multi-palette pictures for testing of programs etc. It shouldn't be used to
convert images. I hope someone will release soon some image processing
program that will do a real conversion. However, if you convert a SHAM image
with AllChanges on, you will get all the information you had in the SHAM
chunk in the PCHG chunk (because SHAM is not specifying changes on odd
interlaced lines anyway).

You should find the complete specification of the PCHG chunk together with
this file. PCHG allows for exact identification of which registers should be
changed, and which not. It's also (usually) smaller than CTBL or SHAM
chunks. It is documented, and has tools that support it. I hope it'll be
soon supported by freeware/shareware/commercial programs.

The Files argument lets you enter as many files (with wildcards) as you
like. ToPCHG will read them, put in a PCHG chunk and rewrite them to the To
directory. You can also specify a single file name, and then To will act as
a destination (it can be either a file name or a directory). That is, ToPCHG
works more or less like the rename command.

If the switch KillOld is specified, the old-fashioned information will be
deleted. This is good if your paint program supports PCHG or if you just
want to see these pictures with Mostra 1.05, but it's not recommended if you
plan to edit again the file. Instead, just add the PCHG chunk (so Mostra can
display the picture). Beware of the fact that probably editing and saving
the picture will delete the PCHG chunk (if the program you're using doesn't
support it). If the option KillOld is not used, ToPCHG will leave in your
file both the old and the new CMAP. The second CMAP overrides the first
(again by the ILBM specification).

ToPCHG will use by default the very dense 12 bit format. If you specify the
switch USE24BIT, the 24bit+alpha channel mode will be used instead. The
chunk can also be compressed using the switch COMP.

The switch AllChanges overrides the default behaviour of cutting the color
changes to MAX_COLOR_CHANGES (=7), as suggested in the PCHG specs. This can
be useful for converting SHAM images, but it will produce picture whose look
depends on their position on the screen.

I'm sorry for the confusion and the poor documentation of the C code that follows.
It was written in a hurry, and I hadn't so much time to work on it. People building
easier interfaces (AppWindow for instance) to this conversion code are welcome.

*/


#include <proto/iffparse.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <libraries/iffparse.h>
#include <dos/dosasl.h>
#include <exec/memory.h>
#include <string.h>
#include <graphics/view.h>
#include <math.h>
#include <time.h>
#include <iff/pchg.h>
#include <clib/pchglib_protos.h>

/*  Bitmap header (BMHD) structure  */
struct BitMapHeader {
	UWORD	w, h;		/*  Width, height in pixels */
	WORD	x, y;		/*  x, y position for this bitmap  */
	UBYTE	nplanes;	/*  # of planes  */
	UBYTE	Masking;
	UBYTE	Compression;
	UBYTE	pad1;
	UWORD	TransparentColor;
	UBYTE	XAspect, YAspect;
	WORD	PageWidth, PageHeight;
};


char Template[] = "Files/M/A,To/A,KillOld/S,Use24Bit/S,AllChanges/S,Comp/S";
char EmbeddedVersion[] = "\0$VER: ToPCHG 37.4 (14.7.92)";

#define OPT_FILES		0
#define OPT_TO			1
#define OPT_KILLOLD	2
#define OPT_24BIT		3
#define OPT_ALLCHANGES 4
#define OPT_COMP		5

#define ID_BODY MAKE_ID('B','O','D','Y')
#define ID_CTBL MAKE_ID('C','T','B','L')
#define ID_MPCT MAKE_ID('M','P','C','T')
#define ID_ILBM MAKE_ID('I','L','B','M')
#define ID_CMAP MAKE_ID('C','M','A','P')
#define ID_BMHD MAKE_ID('B','M','H','D')
#define ID_CAMG MAKE_ID('C','A','M','G')
#define ID_SHAM MAKE_ID('S','H','A','M')

#define MAX_CHANGES_PER_LINE (7)

struct ExecBase *SysBase;
struct Library *IFFParseBase;

static struct AnchorPath Anchor;
static struct FileInfoBlock *fib;
static BPTR DirLock;
static LONG argv[6];

static void ConvertToPCHG(char *SouceName, BPTR SourceDir, char *DestName, BPTR DestDir, ULONG KillOld, ULONG Use24Bit, ULONG AllChanges, ULONG Comp);
static void PrintError(int Code);

int __saveds __asm main(void) {

	int i, rc;
	struct RDArgs *RA;

	SysBase = *(void **)4;
	if (!(DOSBase = (void *)OpenLibrary("dos.library", 37))) return(ERROR_INVALID_RESIDENT_LIBRARY);

	if (IFFParseBase = OpenLibrary("iffparse.library", 37)) {

		if (RA = ReadArgs(Template, argv, NULL)) {
			i = 0;
			while(((char **)argv[OPT_FILES])[i++]);
			Anchor.ap_BreakBits = SIGBREAKF_CTRL_C;

/* Here we decide the relationship source/dest. If the destination is a file, source
has to be a single filename (possibly with wildcards, the first matching file will
be used). If destination is a directory, we scan all sources and place the results in it.
If we have many sources and destination is a file, we issue a ``wrong object type'' error. */

			if (fib = AllocDosObject(DOS_FIB, NULL)) {
				if  ((DirLock = Lock((char *)argv[OPT_TO], ACCESS_READ)) && (rc = Examine(DirLock, fib)) && fib->fib_DirEntryType>0) {
					rc = i = 0;

					while(!rc && ((char **)argv[OPT_FILES])[i]) {
						rc = MatchFirst(((char **)argv[OPT_FILES])[i++], &Anchor);
						while(!rc) {
							if (Anchor.ap_Info.fib_DirEntryType < 0) {
								Printf("Converting %s...\n", Anchor.ap_Info.fib_FileName);
								ConvertToPCHG(Anchor.ap_Info.fib_FileName, Anchor.ap_Last->an_Lock, Anchor.ap_Info.fib_FileName, DirLock, argv[OPT_KILLOLD], argv[OPT_24BIT], argv[OPT_ALLCHANGES], argv[OPT_COMP]);
							}
							rc = MatchNext(&Anchor);
						}
						MatchEnd(&Anchor);

						if (rc == ERROR_NO_MORE_ENTRIES) rc = 0;
					}
					if (rc) PrintError(rc);
				}
				else if (!DirLock && i>2) PrintError(ERROR_OBJECT_NOT_FOUND);
				else if (DirLock && rc && i>2) PrintError(ERROR_OBJECT_WRONG_TYPE);
				else if (i == 2) {
					UnLock(DirLock);
					DirLock = NULL;
					if (rc = MatchFirst(((char **)argv[OPT_FILES])[0], &Anchor)) PrintError(rc);
					else ConvertToPCHG(Anchor.ap_Info.fib_FileName, Anchor.ap_Last->an_Lock, (char *)argv[OPT_TO], ((struct Process *)FindTask(NULL))->pr_CurrentDir, argv[OPT_KILLOLD], argv[OPT_24BIT], argv[OPT_ALLCHANGES], argv[OPT_COMP]);
					MatchEnd(&Anchor);
				}
				else PrintError(IoErr());
				if (DirLock) UnLock(DirLock);
				FreeDosObject(DOS_FIB, fib);
			}
			else PrintError(ERROR_NO_FREE_STORE);
			FreeArgs(RA);
		}
		else PrintError(IoErr());

		CloseLibrary(IFFParseBase);
	}
	else PutStr("Can't find iffparse.library\n");
	return(0);
}


static void PrintError(int Code) {
	PrintFault(Code, (char *)BADDR(((struct CommandLineInterface *)BADDR(((struct Process *)FindTask(NULL))->pr_CLI))->cli_CommandName)+1);
}

static int PrintIFFError(int Code) {
	switch(Code) {
		case IFFERR_NOSCOPE:	PutStr("No valid scope for property\n");
									break;
		case IFFERR_NOMEM:	PutStr("IFFParse memory allocation failed\n");
									break;
		case IFFERR_READ:		PutStr("IFFParse read error\n");
									break;
		case IFFERR_SEEK:		PutStr("IFFParse seek error\n");
									break;
		case IFFERR_MANGLED:	PutStr("Data in file is corrupt\n");
									break;
		case IFFERR_SYNTAX:	PutStr("IFF syntax error\n");
									break;
		case IFFERR_NOTIFF:	PutStr("Not an IFF file\n");
									break;
		default: break;
	}
	return(Code);
}


static char ID[8];
static ULONG HoldChunk[] = { ID_MPCT, ID_CMAP, ID_CTBL, ID_SHAM };


/* Here we take two locks (for two dirs) and two filenames. We convert the
source to the destination. */

static void ConvertToPCHG(char *SourceName, BPTR SourceDir, char *DestName, BPTR DestDir, ULONG KillOld, ULONG Use24Bit, ULONG AllChanges, ULONG Comp) {

	ULONG in = 0, out = 0, DataSize, TreeSize, SourceSize, ChangeCount, ChangedLines, MaxChanges, TotalChanges, MinReg, MaxReg;
	int i,j,t, Skip;
	struct IFFHandle *iffi = NULL, *iffo = NULL;
	BPTR TLock;
	int rc;
	struct ContextNode *cn;
	char *b;
	BOOL IsLace, openi = TRUE, openo = TRUE, RestoreOld, IsSHAM = FALSE, IsCTBL = FALSE;
	UWORD (*CTBL)[16] = NULL, *RGB;
	UBYTE *CMAP = NULL;
	ULONG CTBLSize, *LineMask;
	struct StoredProperty *sp;
	struct SmallLineChanges *slc;
	struct BigLineChanges *blc;
	struct BigPaletteChange *pc;
	char *p, *LC = NULL;
	struct PCHGHeader *ph;
	struct PCHGCompHeader *pch;

	if (!(LC = AllocVec(sizeof(struct PCHGHeader)+128+(sizeof(struct SmallLineChanges)+sizeof(struct BigPaletteChange)*16)*300, MEMF_PUBLIC | MEMF_CLEAR))) {
		PrintError(ERROR_NO_FREE_STORE);
		return;
	}

	TLock = CurrentDir(SourceDir);
	if (!(in = Open(SourceName, MODE_OLDFILE))) PrintError(IoErr());
	CurrentDir(TLock);

	if (iffi = AllocIFF()) iffi->iff_Stream = in;
	else PrintError(ERROR_NO_FREE_STORE);

	if (in && iffi) {
		InitIFFasDOS(iffi);
		if (!PrintIFFError(openi = OpenIFF(iffi, IFFF_READ))) {

/* These are the chunk we need to gather for our conversion code */

			PropChunk(iffi, ID_ILBM, ID_CMAP);
			PropChunk(iffi, ID_ILBM, ID_CTBL);
			PropChunk(iffi, ID_ILBM, ID_MPCT);
			PropChunk(iffi, ID_ILBM, ID_BMHD);
			PropChunk(iffi, ID_ILBM, ID_SHAM);
			PropChunk(iffi, ID_ILBM, ID_CAMG);

			TLock = CurrentDir(DestDir);
			if (!(out = Open(DestName, MODE_NEWFILE))) PrintError(IoErr());
			CurrentDir(TLock);

			if (iffo = AllocIFF()) iffo->iff_Stream = out;
			else PrintError(ERROR_NO_FREE_STORE);

			if (out && iffo) {
				InitIFFasDOS(iffo);
				if (!PrintIFFError(openo = OpenIFF(iffo, IFFF_WRITE))) do {
					PrintIFFError(rc = ParseIFF(iffi, IFFPARSE_STEP));
					cn = CurrentChunk(iffi);

/* If we get an EOC (end of context), there are three cases: we are out of a wrapper
(FORM, CAT, etc.) and then we simply PopChunk(); or we are out of a chunk we
are gathering (and then we write it, unless KillOld is on and the chunk is a
HoldChunk), or it's a chunk we're not gathering (and then we do nothing). This
mechanism is necessary because iffparse complains if we read manually a chunk
we asked to be gathered. */

					if (rc == IFFERR_EOC) {
							if (cn->cn_Type == ID_ILBM && ((cn->cn_ID == ID_MPCT && !KillOld) || cn->cn_ID == ID_BMHD || cn->cn_ID == ID_CAMG || (cn->cn_ID == ID_CTBL && !KillOld) || (cn->cn_ID == ID_SHAM && !KillOld) || (cn->cn_ID == ID_CMAP && !KillOld))) {
							PrintIFFError(rc = PushChunk(iffo, cn->cn_Type, cn->cn_ID, cn->cn_Size));
							sp = FindProp(iffi, cn->cn_Type, cn->cn_ID);
							PrintIFFError(WriteChunkBytes(iffo, sp->sp_Data, sp->sp_Size));
							PrintIFFError(rc = PopChunk(iffo));
						}
						else if (cn->cn_ID == ID_FORM || cn->cn_ID == ID_CAT || cn->cn_ID == ID_LIST || cn->cn_ID == ID_PROP)
							PrintIFFError(rc = PopChunk(iffo));
						else rc = 0;
					}
					else if (!rc) {
						IDtoStr(cn->cn_ID, ID);
						Printf("Found chunk; ID: %s", ID);
						IDtoStr(cn->cn_Type, ID);
						Printf("  Type: %s  Size: %ld\n", ID, cn->cn_Size);

/* We are just entering a chunk. If it's a wrapper we just PushChunk(), otherwise
if it's a BODY we do our conversion work. Then if it's a HoldChunk we do nothing,
otherwise we write it. Note that if something is wrong in the conversion, all
chunks which were gathered but not written because KillOld was on are written
just before the BODY (this includes MPCT, CMAP, SHAM and CTBL).

The code is very clumsy, but I don't think making it well-readable would
change the meaning of life *that* much. */


						if (cn->cn_ID == ID_FORM || cn->cn_ID == ID_CAT || cn->cn_ID == ID_LIST || cn->cn_ID == ID_PROP)
							PrintIFFError(rc = PushChunk(iffo, cn->cn_Type, cn->cn_ID, IFFSIZE_UNKNOWN));
						else  {
							if (cn->cn_Type == ID_ILBM && cn->cn_ID == ID_BODY) {
								RestoreOld = TRUE;
								if ((IsCTBL = ((sp = FindProp(iffi, ID_ILBM, ID_CTBL)) != NULL)) || (IsSHAM = ((sp = FindProp(iffi, ID_ILBM, ID_SHAM)) != NULL))) {
									CTBLSize = sp->sp_Size - (IsSHAM ? 2 : 0);
									CTBL = (void *)((char *)sp->sp_Data+(IsSHAM ? 2 : 0));
									if (IsCTBL) PutStr("Got a CTBL chunk, going to convert to PCHG...\n");
									else PutStr("Got a SHAM chunk, going to convert to PCHG...\n");
									IsLace = (sp = FindProp(iffi, ID_ILBM, ID_CAMG)) && (*((ULONG *)sp->sp_Data) & LACE);
									if (FindProp(iffi, ID_ILBM, ID_MPCT)) PutStr("Got a MPCT chunk, too, it should be a MacroPaint picture...\n");
									if ((sp = FindProp(iffi, ID_ILBM, ID_CMAP)) && sp->sp_Size >= 48) {
										RestoreOld = FALSE;
										CMAP = (UBYTE *)sp->sp_Data;
										for(i=0; i<16; i++) {
											CMAP[i*3] = (CTBL[0][i] & 0xF00)>>4;
											CMAP[i*3+1] = (CTBL[0][i] & 0xF0);
											CMAP[i*3+2] = (CTBL[0][i] & 0xF)<<4;
										}
										PrintIFFError(PushChunk(iffo, ID_ILBM, ID_CMAP, sp->sp_Size));
										PrintIFFError(WriteChunkBytes(iffo, CMAP, sp->sp_Size));
										PrintIFFError(PopChunk(iffo));

										MaxReg = TotalChanges = ChangedLines = MaxChanges = 0;
										MinReg = 16;
										PrintIFFError(PushChunk(iffo, ID_ILBM, ID_PCHG, IFFSIZE_UNKNOWN));
										ph = (void *)LC;
										p = (void *)(LineMask = (void *)&ph[1]);
										blc = (void *)(slc = (void *)(LineMask+((CTBLSize/(16*sizeof(UWORD)))*(1+(IsSHAM && IsLace))+31)/32));
										Skip = 1+(IsLace && IsCTBL);
										for(i=Skip; i<CTBLSize/(16*sizeof(UWORD)); i+=Skip) {
											ChangeCount = 0;
											if (Use24Bit) pc = (void *)&blc[1];
											else RGB = (void *)&slc[1];
											for(j=0; j<16; j++)
												if ((t = CTBL[i][j]) != CTBL[i-Skip][j]) {
													if ((Use24Bit && (AllChanges || blc->ChangeCount<MAX_CHANGES_PER_LINE)) ||
														(!Use24Bit && (AllChanges || slc->ChangeCount16<MAX_CHANGES_PER_LINE))) {
														if (j>MaxReg) MaxReg = j;
														if (j<MinReg) MinReg = j;
														TotalChanges++;
														if (Use24Bit) {
															blc->ChangeCount++;
															pc->Register = j;
															pc->Red = (t & 0xF00)>>4;
															pc->Green = t & 0xF0;
															pc->Blue = (t & 0xF)<<4;
															pc++;
														}
														else {
															slc->ChangeCount16++;
															*(RGB++) = t | j<<12;
														}
													}
												}
											if ((Use24Bit && (t = blc->ChangeCount)) || (t = slc->ChangeCount16)) {
												ChangedLines++;
												if (Use24Bit) blc = (void *)pc;
												else slc = (void *)RGB;
												if (MaxChanges<t) MaxChanges = t;
												LineMask[(i*(1+(IsSHAM && IsLace)))/32] |= 1<<(31-((i*(1+(IsSHAM && IsLace)))%32));
											}
										}
										SourceSize = (Use24Bit ? (char *)blc : (char *)slc)-p;
										ph->Flags = Use24Bit ? PCHGF_32BIT : PCHGF_12BIT;
										ph->LineCount = (CTBLSize/(16*sizeof(UWORD)))*(1+(IsSHAM && IsLace));
										ph->StartLine = 0;
										ph->TotalChanges = TotalChanges;
										ph->MaxChanges = MaxChanges;
										ph->ChangedLines = ChangedLines;
										ph->MinReg = MinReg;
										ph->MaxReg = MaxReg;
										if (Comp) {
											p = PCHG_CompHuffmann(LineMask, SourceSize, &DataSize, &TreeSize);
											ph->Compression = PCHG_COMP_HUFFMANN;
											pch = (void *)&ph[1];
											pch->CompInfoSize = TreeSize;
											pch->OriginalDataSize = SourceSize;
											WriteChunkBytes(iffo, LC, sizeof(struct PCHGHeader)+sizeof(struct PCHGCompHeader));
											WriteChunkBytes(iffo, p, TreeSize+DataSize);
											FreeMem(p, DataSize+TreeSize);
										}
										else {
											ph->Compression = PCHG_COMP_NONE;
											WriteChunkBytes(iffo, LC, SourceSize+sizeof(struct PCHGHeader));
										}
										PrintIFFError(PopChunk(iffo));
									}
									else PutStr("No CMAP or CMAP bad size\n");
								}
								else PutStr("No CTBL/SHAM chunk.\n");
								if (RestoreOld && KillOld) {
									for(i=0; i<sizeof(HoldChunk)/sizeof(ULONG); i++)
										if (sp = FindProp(iffi, ID_ILBM, HoldChunk[i])) {
											PrintIFFError(rc = PushChunk(iffo, ID_ILBM, HoldChunk[i], sp->sp_Size));
											PrintIFFError(WriteChunkBytes(iffo, sp->sp_Data, sp->sp_Size));
											PrintIFFError(rc = PopChunk(iffo));
										}
								}
							}

							if (!(cn->cn_Type == ID_ILBM && (cn->cn_ID == ID_MPCT || cn->cn_ID == ID_BMHD || cn->cn_ID == ID_CTBL || cn->cn_ID == ID_SHAM || cn->cn_ID == ID_CAMG || cn->cn_ID == ID_CMAP))) {
								PrintIFFError(rc = PushChunk(iffo, cn->cn_Type, cn->cn_ID, cn->cn_Size));
								if (cn->cn_Size && (b = AllocMem(cn->cn_Size, MEMF_PUBLIC))) {
									ReadChunkBytes(iffi, b, cn->cn_Size);
									WriteChunkBytes(iffo, b, cn->cn_Size);
									FreeMem(b, cn->cn_Size);
								}
								else PrintError(rc = ERROR_NO_FREE_STORE);
								PopChunk(iffo);
							}
						}
					}
				} while(!rc);
			}
		}
	}

	if (!openi) CloseIFF(iffi);
	if (!openo) CloseIFF(iffo);
	if (in) Close(in);
	if (out) Close(out);
	if (iffi) FreeIFF(iffi);
	if (iffo) FreeIFF(iffo);
	FreeVec(LC);
}
