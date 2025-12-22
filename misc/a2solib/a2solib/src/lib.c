#include <interfaces/exec.h>
#include <interfaces/elf.h>
#include <interfaces/dos.h>

#include <libraries/elf.h>

#include <solib.h>
#include <interfaces/solib.h>

#ifdef __cplusplus
extern "C" {
#endif
//#define DEBUG
#undef DEBUG
#include "debug.h"

#define GET_INSTANCE(self)                          \
	  ((ULONG)self - self->Data.NegativeSize)

#define PROGRAM_SIZE (15*4)

static APTR segList;
static struct ExecIFace *IExec;
static struct Library *ElfBase;
static struct ElfIFace *IElf;
static struct Library *DOSBase;
static struct DOSIFace *IDOS;

Elf32_Handle libElfHandle;
struct SignalSemaphore *libElfLock;

struct SymbolEntry
{
	char 	*Symbol;
	APTR	FuncEntry;
};

extern const char libname[];
extern const int libversion;
extern const int librevision;
extern const char libvstring[];

extern const struct SymbolEntry SymbolTable[];

extern int SymbolTableSize;

extern void _init(void);
extern void _fini(void);
extern void __open_libraries(struct ExecIFace *);
extern void __close_libraries(void);
extern void __set_context(struct SolibContext *);

static struct Library *SysBase;
/* Needed to inherit Newlib data */
extern int *** __reent_magic __attribute__((__alias__("SysBase")));

/* main interface instance data */
struct InstanceData
{
	APTR	LinkageTable;		/* Pointer to the linkage table (in exeutable
								 * memory)
								 */
	APTR	DataSegment;		/* Pointer to the local data segment */
	struct SymbolEntry *
			SymbolTable;		/* Mapping of symbol to linkage */
	uint32	NumSymbols;			/* Number of symbols in Symbol and Linkage
								 * table
								 */
	uint32	BaseOffset;			/* Offset into data segment for r2 */
	APTR 	Base;				/* Pointer to free in expunge */
	char *	Name;				/* Pointer to library name */
};


static inline uint32 EstablishEnvironment(uint32 newr2)
{
	uint32 r2;
	__asm volatile ("mr %0, 2" : "=r" (r2));
	__asm volatile ("mr 2, %0" :: "r" (newr2));
	return r2;
}

int strcmp(char *s1, char * s2)
{
    int res = 0;

    if(s1 != s2)
    {
        while((*s1) == (*s2))
        {
            if((*s1) == '\0')
                break;

            s1++;
            s2++;
        }

        res = (*s1) - (*s2);
    }

    return res;
}

/* Generate linkage. This looks like this

	   94 21 ff f0     stwu    r1,-16(r1)
	   7c 08 02 a6     mflr    r0
	   90 41 00 08     stw     r2,8(r1)
	   90 01 00 14     stw     r0,20(r1)
	   3d 80 ** **     lis     r12,code@ha		# Signed!
	   3c 40 ** **     lis     r2,data@ha		# Signed!
	   61 8c ** **     ori     r12,r12,code@l	# Unsigned!
	   60 42 ** **     ori     r2,r2,data@l		# Unsigned!
	   7d 89 03 a6     mtctr   r12
	   4e 80 04 21     bctrl
	   80 01 00 14     lwz     r0,20(r1)
	   80 41 00 08     lwz     r2,8(r1)
	   7c 08 03 a6     mtlr    r0
	   38 21 00 10     addi    r1,r1,16
	   4e 80 00 20     blr
*/

void GenerateLinkage(uint32 code, uint32 data, uint32 *target)
{
//	dprintf("Code @%p, data @%p\n", code, data);
	*target++ = 0x9421fff0;
	*target++ = 0x7c0802a6;
	*target++ = 0x90410008;
	*target++ = 0x90010014;
	*target++ = 0x3d800000 | (((code & 0xffff0000) >> 16));
	*target++ = 0x3c400000 | (((data & 0xffff0000) >> 16));
	*target++ = 0x618c0000 | (code & 0xffff);
	*target++ = 0x60420000 | (data & 0xffff);
	*target++ = 0x7d8903a6;
	*target++ = 0x4e800421;
	*target++ = 0x80010014;
	*target++ = 0x80410008;
	*target++ = 0x7c0803a6;
	*target++ = 0x38210010;
	*target++ = 0x4e800020;
};

/* Clone method */
struct Interface *symClone(struct Interface *Self)
{
	struct Interface *newif;
	uint32 addr = 0;
	struct InstanceData *instanceData;
	uint32 i;
	uint32 linkage;
	uint32 baseDiff;
	Elf32_Handle elfHandle;
	uint32 size;

	dprintf("Entry\n");

	size = Self->Data.PositiveSize + Self->Data.NegativeSize;

	addr = (uint32)IExec->AllocVec(size, MEMF_PUBLIC|MEMF_CLEAR);
	if (!addr)
		return 0;

	newif = (struct Interface *) (addr + Self->Data.NegativeSize);

	/* Copy the functions */
	dprintf("Copying functions\n");
	IExec->CopyMem((APTR)Self, (APTR)newif, Self->Data.PositiveSize);

	/* Initialize data */
	instanceData = (struct InstanceData *)GET_INSTANCE(newif);

	/* Allocate linkage table */
	dprintf("Allocating linkage table\n");
	instanceData->LinkageTable = IExec->AllocVec(SymbolTableSize*PROGRAM_SIZE,
											MEMF_EXECUTABLE);
	if (!instanceData->LinkageTable)
		goto error;

	/* Copy data segment */
	IExec->ObtainSemaphore(libElfLock);
	
	elfHandle = (Elf32_Handle)IElf->OpenElfTags(
				OET_ElfHandle, 	(uint32)libElfHandle, 
			TAG_DONE);
			
	if (!elfHandle)
	{
		IExec->ReleaseSemaphore(libElfLock);
		goto error;
	}
		
	instanceData->DataSegment = IElf->CopyDataSegment(libElfHandle, &baseDiff);
	if (!instanceData->DataSegment)
	{
		IExec->ReleaseSemaphore(libElfLock);
		goto error;
	}

	instanceData->BaseOffset = baseDiff;

	IElf->CloseElfTags(elfHandle, CET_ReClose, TRUE, TAG_DONE);
	
	IExec->ReleaseSemaphore(libElfLock);

	/* Allocate symbol table */
	dprintf("Allocating symbol table\n");
	instanceData->SymbolTable = (struct SymbolEntry *)
			IExec->AllocVec(SymbolTableSize*sizeof(struct SymbolEntry),
											MEMF_PUBLIC|MEMF_CLEAR);
	if (!instanceData->SymbolTable)
		goto error;

	instanceData->NumSymbols = SymbolTableSize;

	/* Generate linkage table */
	dprintf("Generating linkage table\n");
	linkage = (uint32)instanceData->LinkageTable;

	for (i = 0; i < SymbolTableSize; i++)
	{
//		dprintf("Generating code for function %s\n", SymbolTable[i].Symbol);
		GenerateLinkage((uint32)SymbolTable[i].FuncEntry,
						(uint32)instanceData->DataSegment + baseDiff,
						(uint32 *) linkage);

		instanceData->SymbolTable[i].Symbol = SymbolTable[i].Symbol;
		instanceData->SymbolTable[i].FuncEntry = (APTR)linkage;
		linkage += PROGRAM_SIZE;
	}

	dprintf("Clearing cache\n");
	IExec->CacheClearE((APTR)instanceData->LinkageTable,
					   SymbolTableSize*PROGRAM_SIZE,
					   CACRF_ClearI);

	/* Mark us as cloned */
	newif->Data.Flags |= IFLF_CLONED;
	newif->Data.RefCount = 0;
	
	instanceData->Name = newif->Data.LibBase->lib_Node.ln_Name;
	
	dprintf("Done, new interface = %p\n", newif);
	return newif;

error:
	dprintf("Error, bailing out\n");
	if (instanceData->SymbolTable)
		IExec->FreeVec(instanceData->SymbolTable);

	if (instanceData->LinkageTable)
		IExec->FreeVec(instanceData->LinkageTable);
	
	if (instanceData->DataSegment)
		IElf->FreeDataSegmentCopy(libElfHandle, instanceData->DataSegment);

	if (addr)
		IExec->FreeVec((APTR)addr);

	return 0;
}

/* Do constructors */
void symDoCtors(struct SolibSymIFace *Self)
{
	struct InstanceData * instanceData
		= (struct InstanceData *)GET_INSTANCE(Self);

	/* Setup r2 for constructor calls */
	uint32 r2 = EstablishEnvironment((uint32)instanceData->DataSegment 
								   + instanceData->BaseOffset);
	
	__open_libraries(IExec);
	_init();

	EstablishEnvironment(r2);
}

/* Do destructors */
void symDoDtors(struct SolibSymIFace *Self)
{
	struct InstanceData * instanceData
		= (struct InstanceData *)GET_INSTANCE(Self);

	/* Setup r2 for destructor calls */
	uint32 r2 = EstablishEnvironment((uint32)instanceData->DataSegment 
								   + instanceData->BaseOffset);
	
	_fini();
	__close_libraries();

	EstablishEnvironment(r2);
}

/* Symbol expunge */
void symExpunge(struct SolibSymIFace *Self)
{
	uint32 addr = (ULONG)Self - Self->Data.NegativeSize;
	struct InstanceData * instanceData = (struct InstanceData *)GET_INSTANCE(Self);

	Self->DoDtors();

	dprintf("Expunging interface\n");
	
	if (instanceData->SymbolTable)
		IExec->FreeVec(instanceData->SymbolTable);

	if (instanceData->LinkageTable)
		IExec->FreeVec(instanceData->LinkageTable);
		
	if (instanceData->DataSegment)
		IElf->FreeDataSegmentCopy(libElfHandle, instanceData->DataSegment);

	if (addr)
		IExec->FreeVec((APTR)addr);
}

void *symGetSymbol(struct Interface *Self, char *symbol, uint32 flags)
{
	struct InstanceData * instanceData = (struct InstanceData *)GET_INSTANCE(Self);
	int i;

	/* FIXME: Use hash table */
	for (i = 0; i < instanceData->NumSymbols; i++)
	{
		if (strcmp(symbol, instanceData->SymbolTable[i].Symbol) == 0)
			return instanceData->SymbolTable[i].FuncEntry;
	}

	return 0;
}

ULONG symRelease(struct Interface *Self)
{
	uint32 ref;
	
	ref = --Self->Data.RefCount;
	
	if (Self->Data.RefCount == 0 && (Self->Data.Flags & IFLF_CLONED))
		Self->Expunge();
		
	return ref; 
}

/* default methods */

ULONG defaultObtain(struct Interface *Self)
{
	return ++Self->Data.RefCount;
}


ULONG defaultRelease(struct Interface *Self)
{
	return --Self->Data.RefCount;
}

/* Library open */

struct Library *libOpen(struct LibraryManagerInterface *Self, ULONG version)
{
	struct Library *libBase = Self->Data.LibBase;

	dprintf("In libOpen\n");

	/* Add up the open count */
	libBase->lib_OpenCnt++;

	/* Clear pending expunge */
	libBase->lib_Flags &= ~LIBF_DELEXP;

	return libBase;
}

/* Library expunge */

APTR libExpunge(struct LibraryManagerInterface *Self)
{
	struct Library *libBase = Self->Data.LibBase;

	/* Check if we're still open */
	if (libBase->lib_OpenCnt)
	{
		/* We are, delay the expunge */
		libBase->lib_Flags |= LIBF_DELEXP;
		return 0;
	}

	/* Close down elf stuff */
	IExec->FreeSysObject(ASOT_SEMAPHORE, libElfLock);
	
	IExec->DropInterface((struct Interface *)IDOS);
	IExec->CloseLibrary(DOSBase);
	IExec->DropInterface((struct Interface *)IElf);
	IExec->CloseLibrary(ElfBase);
	
	/* No one uses us, so really expunge. Start by removing us from the library list */
	IExec->Remove((struct Node *)libBase);

	/* Delete ourselves */
	IExec->DeleteLibrary(libBase);
	IExec->Release();

	/* Finally, return the handle so whoever loaded us into memory can get rid of us */
	return segList;
}

/* Library close */


APTR libClose(struct LibraryManagerInterface *Self)
{
	struct Library *libBase = Self->Data.LibBase;

		/* Make the close count */
	libBase->lib_OpenCnt--;

	/* If we're still open, do nothing */
	if (libBase->lib_OpenCnt > 0)
		return 0;

	/* Otherwise, if an expunge is pending, execute it now */
	if (libBase->lib_Flags & LIBF_DELEXP)
	{
		return libExpunge(Self);
	}

	return 0;
}

/* Library init */

struct Library *libInit(struct Library *libBase, APTR seglist, struct Interface *exec)
{
	/* Initialize the library base */
	dprintf("Initializing library base %p\n", libBase);
	libBase->lib_Node.ln_Type = NT_LIBRARY;
	libBase->lib_Node.ln_Pri  = 0;
	libBase->lib_Node.ln_Name = (char *)libname;
	libBase->lib_Flags        = LIBF_SUMUSED|LIBF_CHANGED;
	libBase->lib_Version      = (int)libversion;
	libBase->lib_Revision     = (int)librevision;
	libBase->lib_IdString     = (char *)libvstring;

	segList = seglist;
	IExec = (struct ExecIFace *)exec;

	SysBase = IExec->Data.LibBase;
	
	DOSBase = IExec->OpenLibrary("dos.library", 0);
	IDOS = (struct DOSIFace *)IExec->GetInterface(DOSBase, "main", 1, NULL);
	
	ElfBase = IExec->OpenLibrary("elf.library", 0);
	if (!ElfBase)
		return 0;
		
	IElf = (struct ElfIFace *)IExec->GetInterface(ElfBase, "main", 1, NULL);
	if (!IElf)
	{
		IExec->CloseLibrary(ElfBase);
		return 0;
	}
	
	if (1 != IDOS->GetSegListInfoTags((BPTR)seglist, 
							GSLI_ElfHandle, &libElfHandle,
							TAG_DONE))
	{
		IExec->DropInterface((struct Interface *)IElf);
		IExec->CloseLibrary(ElfBase);
		return 0;
	}

	libElfLock = (struct SignalSemaphore *)
		IExec->AllocSysObject(ASOT_SEMAPHORE, NULL);
		
	if (!libElfLock)
	{
		IExec->DropInterface((struct Interface *)IElf);
		IExec->CloseLibrary(ElfBase);
		return 0;
	}
	
	dprintf("Done\n");

	/* Return libBase here to indicate success, or 0 if something failed */
	return libBase;
}

struct SolibSymIFace *mainGetInterface(struct SolibMainIFace *Self, 
	struct SolibContext *ctx)
{
	struct SolibSymIFace *pCur;
	
	if (!ctx)
		return NULL;
		
	dprintf("IExec = %p\n", IExec);
	IExec->ObtainSemaphore(&ctx->Lock);
	
	/* All interfaces are kept it the context's list. We just scan the 
	 * list and see if we can find an interface with our name, and return
	 * that. Otherwise, if we don't find it, we clone a new one, and add it
	 * to the list
	 */
	dprintf("Checking for interface of %s in context %p\n", 
				Self->Data.LibBase->lib_Node.ln_Name, ctx);
				
	for (pCur = (struct SolibSymIFace *)IExec->GetHead(&ctx->Interfaces);
		 pCur;
		 pCur = (struct SolibSymIFace *)IExec->GetSucc(&pCur->Data.Link))
	{
		struct InstanceData * instanceData = 
			(struct InstanceData *)GET_INSTANCE(pCur);
		
		dprintf("Checking %s\n", instanceData->Name);
		if (Self->Data.LibBase->lib_Node.ln_Name == instanceData->Name)
		{
			dprintf("Match\n");
			break;
		}
	}
	
	if (pCur)
	{
		/* Found it */
		pCur->Obtain();
	}
	else
	{
		/* Didn't find it, create a new one */
		pCur =  (struct SolibSymIFace *)IExec->GetInterface(
				Self->Data.LibBase, "solib", 1, 0);	
		if (pCur)
		{
			struct InstanceData * instanceData = 
				(struct InstanceData *)GET_INSTANCE(pCur);
			
			/* Add it to the context */
			dprintf("Adding %s\n", instanceData->Name);
			IExec->AddHead(&ctx->Interfaces, (struct Node *)pCur);
			
			uint32 r2 = EstablishEnvironment((uint32)instanceData->DataSegment 
											+ instanceData->BaseOffset);

			__set_context(ctx);
			
			EstablishEnvironment(r2);
			pCur->DoCtors();
		}
	}
	
	IExec->ReleaseSemaphore(&ctx->Lock);
	return pCur;
}

void mainDropInterface(struct SolibMainInterface *Self, 
	struct SolibSymIFace *other)
{
	if (!other)
		return;
		
	if (other->Data.RefCount == 1)
		/* The release will delete it, remove it from the list */
		IExec->Remove(&other->Data.Link);
		
	other->Release();
}


/* Manager interface vectors */
void *manager_vectors[] =
{
	(void *)defaultObtain,
	(void *)defaultRelease,
	(void *)0,
	(void *)0,
	(void *)libOpen,
	(void *)libClose,
	(void *)libExpunge,
	(void *)0,
	(void *)-1,
};

/* "__library" interface tag list */
struct TagItem managerTags[] =
{
	{MIT_Name,             (ULONG)"__library"},
	{MIT_VectorTable,      (ULONG)manager_vectors},
	{MIT_Version,          1},
	{TAG_DONE,             0}
};



/* Main interface vectors */
void *main_vectors[] =
{
	(void *)defaultObtain,
	(void *)defaultRelease,
	(void *)NULL,
	(void *)NULL,
	(void *)mainGetInterface,
	(void *)mainDropInterface,
	(void *)-1,
};

struct TagItem mainTags[] =
{
	{MIT_Name,             (ULONG)"main"},
	{MIT_VectorTable,      (ULONG)main_vectors},
	{MIT_Version,          1},
	{TAG_DONE,             0}
};

/* Solib interface */
void *solib_vectors[] =
{
	(void *)defaultObtain,
	(void *)symRelease,
	(void *)symExpunge,
	(void *)symClone,
	(void *)symGetSymbol,
	(void *)symDoCtors,
	(void *)symDoDtors,
	(void *)-1,
};

struct TagItem solibTags[] =
{
	{MIT_Name,             (ULONG)"solib"},
	{MIT_VectorTable,      (ULONG)solib_vectors},
	{MIT_Version,          1},
    {MIT_DataSize,         sizeof(struct InstanceData)},
    {MIT_Flags,            IFLF_PRIVATE},
	{TAG_DONE,             0}
};


/* MLT_INTERFACES array */
ULONG libInterfaces[] =
{
	(ULONG)managerTags,
	(ULONG)mainTags,
	(ULONG)solibTags,
	0
};

/* CreateLibrary tag list */
struct TagItem libCreateTags[] =
{
	{CLT_DataSize,         (ULONG)(sizeof(struct Library))},
	{CLT_InitFunc,         (ULONG)libInit},
	{CLT_Interfaces,       (ULONG)libInterfaces},
	{TAG_DONE,             0}
};

struct Resident mylib_res __attribute__((used)) =
{
	RTC_MATCHWORD,
	&mylib_res,
	&mylib_res+1,
	RTF_AUTOINIT|RTF_NATIVE|RTF_COLDSTART,
	(int)libversion,
	NT_LIBRARY,
	0,
	(char *)libname,
	(char *)libvstring,
	libCreateTags
};

/* Keep linker happy */
uint32 _start(void)
{
	return 0;
}

#ifdef __cplusplus
}
#endif
