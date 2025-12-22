
#define __NOLIBBASE__

#include <exec/exec.h>
#include <exec/rawfmt.h>
#include <dos/dos.h>
#include <libraries/dilplugin.h>
#include <utility/tagitem.h>

#include <proto/alib.h>
#include <proto/debug.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/dilplugin.h>
#include <proto/utility.h>

#include "aes.h"

//-----------------------------------------------------------------------------

struct ExecBase *SysBase = NULL;
struct DosLibrary *DOSBase = NULL;
//struct Library *UtilityBase = NULL;
//struct DILPluginBase *DILPluginBase = NULL;

static int main2(void);

//-----------------------------------------------------------------------------

int main(void)
{
	//struct Library *lib;

	SysBase = *(APTR *)4l;
	if ((DOSBase = (struct DosLibrary *)OpenLibrary(DOSNAME, 37)))
	{
		main2();

		/*if ((UtilityBase = OpenLibrary("utility.library", 37l)))
		{
			if ((DILPluginBase = (struct DILPluginBase *)OpenLibrary("LIBS:DIL/aes.dilp", 1l)))
			{
				struct TagItem *ti = dilGetInfo();
		
				//Printf("--> '%s'\n", (UBYTE *)GetTagData(DILP_Updates, (ULONG)"---", ti));
				Printf("Ok\n");

				CloseLibrary((struct Library *)DILPluginBase);
			} else
				Printf("Fail\n");

			Forbid();
			if ((lib = (struct Library *)FindName(&SysBase->LibList, "aes.dilp")))
				RemLibrary(lib);
			Permit();

			CloseLibrary(UtilityBase);
		}*/
		CloseLibrary((struct Library *)DOSBase);
	}
	return 0;
}

#ifdef __MORPHOS__
void exit(int rc) {}
#endif

//-----------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack(2)
#endif

/* private cipher data */
typedef struct {
	AESContextCbc	p_CBC;			/* chipher context */
	UBYTE 			p_IV[16 + 1]; 	/* +1 cos sprintf's '\0' */
} priv;

#if defined(__GNUC__)
#pragma pack()
#endif

static priv *P;

//-----------------------------------------------------------------------------

static void memclr(APTR data, ULONG size)
{
	register UBYTE *p = (UBYTE *)data;

	while (size-- > 0)
		*p++ = '\0';
}

static ULONG strlen(const char *s)
{
	register ULONG len = 0;

	while (*s++)
		len++;

	return len;
}

static LONG vsprintf(char *to, const char *fmt, va_list args)
{
	VNewRawDoFmt((const STRPTR)fmt, (APTR)RAWFMTFUNC_STRING, (STRPTR)to, args);
	return ((LONG)strlen(to));
}

static LONG sprintf(char *to, const char *fmt, ...)
{
	va_list args;
	LONG size;

	va_start(args, fmt);
	size = vsprintf(to, fmt, args);
	va_end(args);

	return size;
}

static BOOL SaveData(UBYTE *filename, APTR data, LONG size)
{
	BPTR fh;
	BOOL result = FALSE;

	if ((fh = Open(filename, MODE_NEWFILE))) {
		if ((Write(fh, data, size) == size))
			result = TRUE;

		Close(fh);
	}
	return result;
}

//-----------------------------------------------------------------------------

static BOOL Setup(void)
{
	priv *p;

	if ((p = AllocVec(sizeof(priv), MEMF_PUBLIC | MEMF_CLEAR)))
	{
		AES_Init();
		P = p;
		return TRUE;
	}
	return FALSE;
}

static void Cleanup(void)
{
	priv *p = P;

	/* flush private data from memory */
	memclr(p, sizeof(priv));

	FreeVec(p);
	P = NULL;
}

//-----------------------------------------------------------------------------

static BOOL Process(LONG mode, ULONG block, ULONG blocks, const UBYTE *src, UBYTE *dst, const UBYTE *seed, ULONG seedsize)
{
	priv *p = P;
	AESContextCbc *cbc = &p->p_CBC;
	AESContext *aes = &cbc->aes;
	ULONG bs = 512;
	ULONG size = bs * blocks;
	ULONG done;

	//memclr(p->p_IV, sizeof(p->p_IV));
	sprintf((char *)p->p_IV, "%016llx", ((UQUAD)(block+1) * 69069));

	kprintf("IV '%s'\n", (char *)p->p_IV);

	AES_InitCbc(cbc, p->p_IV);

	if (mode == 1) {
		AES_SetKeyDecode(aes, seed, seedsize);
		done = AES_DecodeCbc(cbc, src, dst, size);
	} else {
		AES_SetKeyEncode(aes, seed, seedsize);
		done = AES_EncodeCbc(cbc, src, dst, size);
	}
	return (done == size);
}

//-----------------------------------------------------------------------------

#define BLOCK 		12345
#define BLOCKS 	2
#define BLOCKSIZE 512

#define DATASIZE	(BLOCKSIZE * BLOCKS)
#define SEEDSIZE 	32

static int main2(void)
{
	if (Setup())
	{
		UBYTE src[DATASIZE], tmp[DATASIZE], dst[DATASIZE];
		UBYTE seed[SEEDSIZE];
		ULONG seedsize = SEEDSIZE;
		ULONG block = BLOCK;
		ULONG blocks = BLOCKS;
		ULONG i;
		BOOL err = 0;

		memclr(src, DATASIZE);
		memclr(tmp, DATASIZE);
		memclr(dst, DATASIZE);
		for (i = 0; i < seedsize; i++)
			seed[i] = (UBYTE)((i+1) * 7);

		//for (i = block; i < block + blocks; i++)
		i = block;
		{
			if (!Process(2, i, blocks, src, tmp, seed, seedsize)) {
				Printf("Can't encode block %lu\n", i);
				err = 1; //break;
			}
			if (!Process(1, i, blocks, tmp, dst, seed, seedsize)) {
				Printf("Can't decode block %lu\n", i);
				err = 1; //break;
			}
		}
		if (!err) {
			if (memcmp(src, dst, DATASIZE))
				Printf("Test faild\n");
			else
				Printf("Test ok\n");
		}

		SaveData("ram:src.bin", src, DATASIZE);
		SaveData("ram:tmp.bin", tmp, DATASIZE);
		SaveData("ram:dst.bin", dst, DATASIZE);
		SaveData("ram:seed.bin", seed, SEEDSIZE);

		Cleanup();
	}
	return 0;
}

//-----------------------------------------------------------------------------













