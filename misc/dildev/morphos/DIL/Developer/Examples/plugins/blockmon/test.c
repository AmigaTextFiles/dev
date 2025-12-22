#define __NOLIBBASE__

#include <exec/exec.h>
#include <dos/dos.h>
#include <libraries/dilplugin.h>
#include <utility/tagitem.h>
#include <utility/utility.h>

#include <proto/alib.h>
#include <proto/debug.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/dilplugin.h>
#include <proto/utility.h>

#include <stdlib.h>
#include <time.h>

//-----------------------------------------------------------------------------

const int __initlibraries	= 0; /* no auto-libinit */
const int __nocommandline	= 1; /* no argc, argv   */
const int __abox__ 			= 1; /* */

//-----------------------------------------------------------------------------
//bit macros

#define   setb(v,b)  ((v) |=  (1ul << (b)))
#define   clrb(v,b)  ((v) &= ~(1ul << (b)))
#define issetb(v,b) (((v) &   (1ul << (b))) != 0)
#define isclrb(v,b) (((v) &   (1ul << (b))) == 0)

#define   setf(v,f)  ((v) |=  (f))
#define   clrf(v,f)  ((v) &= ~(f))
#define issetf(v,f) (((v) &   (f)) != 0)
#define isclrf(v,f) (((v) &   (f)) == 0)

//-----------------------------------------------------------------------------

#define NAME "blockmon"

static const char version[] = "\0$VER: "NAME" 1.0 ("__AMIGADATE__") ©2004-"__YEAR__" Rupert Hausberger\0";
static const char exthelp[] =
	NAME" : ...\n"
	"\tNAME=N/A ...\n";

#define ARG_TEMPLATE "NAME=N"

enum {
	 ARG_NAME = 0,
    ARG_END
};

struct ExecBase *SysBase = NULL;
struct DosLibrary *DOSBase = NULL;
struct Library *UtilityBase = NULL;
struct DILPluginBase *DILPluginBase = NULL;

//-----------------------------------------------------------------------------

//static LONG ExpungeLibrary(struct Library *lib);
static LONG ExpungeLibraryName(CONST_STRPTR name);

static APTR memset(APTR dest, UBYTE val, ULONG len);

static void InitDosEnvec(struct DosEnvec *de);
static void InitParams(DILParams *params);

static LONG Test(void);

//-----------------------------------------------------------------------------

int main(void)
{
	int result = RETURN_FAIL;

	SysBase = *((struct ExecBase **)4l);
	if ((DOSBase = (struct DosLibrary *)OpenLibrary(DOSNAME, 37)))
	{
		if ((UtilityBase = OpenLibrary(UTILITYNAME, 37)))
		{
			struct RDArgs *rda;
			LONG err = 0l;

			if ((rda = AllocDosObject(DOS_RDARGS, NULL)))
			{
				struct RDArgs *rd;
				ULONG args[ARG_END] = { (ULONG)NULL };

				rda->RDA_ExtHelp = (UBYTE *)exthelp;
				if ((rd = ReadArgs(ARG_TEMPLATE, args, rda)))
            {
					if ((DILPluginBase = (struct DILPluginBase *)OpenLibrary("PROGDIR:"NAME".dilp", 1l)))
					{
						//struct TagItem *ti = dilGetInfo();
						//Printf("--> '%s'\n", (UBYTE *)GetTagData(DILI_Name, (ULONG)"---", ti));

						if ((err = Test()) == 0)
							result = RETURN_OK;

						CloseLibrary((struct Library *)DILPluginBase);
						Delay(10);
						ExpungeLibraryName(NAME".dilp");
					} else
						err = ERROR_OBJECT_NOT_FOUND;

					FreeArgs(rd);
				} else
					err = IoErr();

				FreeDosObject(DOS_RDARGS, rda);
			} else
				err = ERROR_NO_FREE_STORE;

			if (err) {
				PrintFault(err, NAME);
				SetIoErr(err);
			}
         CloseLibrary(UtilityBase);
		}
		CloseLibrary((struct Library *)DOSBase);
	}
	return result;
}

//-----------------------------------------------------------------------------

/*static LONG ExpungeLibrary(struct Library *lib)
{
	LONG err = 0l;

	Forbid();
	if (!lib->lib_OpenCnt)
		RemLibrary(lib);
	else
		err = ERROR_OBJECT_IN_USE;
	Permit();
   return err;
}*/

static LONG ExpungeLibraryName(CONST_STRPTR name)
{
	struct Library *lib;
	LONG err = 0l;

	Forbid();
	if ((lib = (struct Library *)FindName(&SysBase->LibList, name))) {
		if (!lib->lib_OpenCnt)
			RemLibrary(lib);
		else
			err = ERROR_OBJECT_IN_USE;
	} else
		err = ERROR_OBJECT_NOT_FOUND;
   Permit();
   return err;
}

//-----------------------------------------------------------------------------

static APTR memset(APTR dest, UBYTE val, ULONG len)
{
	register UBYTE *ptr = (UBYTE *)dest;

   while (len-- > 0)
		*ptr++ = val;
   return dest;
}

//-----------------------------------------------------------------------------

//528MB - 1024 cylinders,  16 heads and 63 sectors (1024x 16x63x512)
//  8GB - 1024 cylinders, 256 heads and 63 sectors (1024x256x63x512)

static void InitDosEnvec(struct DosEnvec *de)
{
	de->de_TableSize      = (ULONG)DE_BOOTBLOCKS;
	de->de_SizeBlock      = (ULONG)512 >> 2;
	de->de_SecOrg         = (ULONG)0;
	de->de_Surfaces       = (ULONG)1;
	de->de_SectorPerBlock = (ULONG)1;
	de->de_BlocksPerTrack = (ULONG)16383;
	de->de_Reserved       = (ULONG)2;
	de->de_PreAlloc       = (ULONG)0;
	de->de_Interleave     = (ULONG)0;
	de->de_LowCyl         = (ULONG)100;
	de->de_HighCyl        = (ULONG)200;
	de->de_NumBuffers     = (ULONG)20;
	de->de_BufMemType     = (ULONG)MEMF_PUBLIC;
	de->de_MaxTransfer    = (ULONG)0x7fffffff;
	de->de_Mask           = (ULONG)0xfffffffe;
	de->de_BootPri        =  (LONG)0;
	de->de_DosType        = (ULONG)ID_DOS_DISK;
	de->de_Baud           = (ULONG)9600;
	de->de_Control        = (ULONG)0;
	de->de_BootBlocks     = (ULONG)0;
}

static void InitParams(DILParams *params)
{
	memset(params, 0, sizeof(DILParams));
	
	params->p_DosName = (ULONG)"DIL0";
	params->p_Device  = (ULONG)"idx.device";
	params->p_Unit 	= (ULONG)3;
	params->p_Flags   = (ULONG)0;

   InitDosEnvec(&params->p_DosEnvec);

	params->p_Stacksize			= (ULONG)8192;
	params->p_Priority			= (ULONG)5;
	params->p_GlobVec				=  (LONG)-1;
	params->p_Startup		      = (ULONG)FALSE;
	params->p_Activate			= (ULONG)TRUE;
	params->p_ForceLoad		   = (ULONG)FALSE;

	params->p_DILUnit 			= (ULONG)0;
	params->p_PDPString		   = "SYS:DIL";
}

//-----------------------------------------------------------------------------

//lowcyl = reserved / (parentDG.dg_Heads * parentDG.dg_TrackSectors) + 1; //general partition

static ULONG CHS2LBA(struct DosEnvec *de, ULONG cylinder, ULONG head, ULONG sector)
{
	return (((cylinder * de->de_Surfaces + head) * de->de_BlocksPerTrack) + sector - 1);
}

/*static void LBA2CHS(struct DosEnvec *de, ULONG lba, ULONG *cylinder, ULONG *head, ULONG *sector)
{
	ULONG tmp = lba % (de->de_Surfaces * de->de_BlocksPerTrack);

	*cylinder = lba / (de->de_Surfaces * de->de_BlocksPerTrack);
	*head = tmp / de->de_BlocksPerTrack;
	*sector = tmp % de->de_BlocksPerTrack + 1;
}

static ULONG GetNumBlocks(struct DosEnvec *de)
{
	return ((de->de_HighCyl - de->de_LowCyl + 1) * de->de_Surfaces * de->de_BlocksPerTrack);
}

static ULONG GetLowBlock(struct DosEnvec *de)
{
	return (de->de_LowCyl * de->de_Surfaces * de->de_BlocksPerTrack);
}

static ULONG GetHighBlock(struct DosEnvec *de)
{
	return (((de->de_HighCyl+1) * de->de_Surfaces * de->de_BlocksPerTrack)-1);
}

static ULONG GetCyl(struct DosEnvec *de, ULONG lba)
{
	return (lba / (de->de_Surfaces * de->de_BlocksPerTrack));
}

static ULONG GetSurface(struct DosEnvec *de, ULONG lba)
{
	ULONG tmp = lba % (de->de_Surfaces * de->de_BlocksPerTrack);

	return (tmp / de->de_BlocksPerTrack);
}

static ULONG GetTrack(struct DosEnvec *de, ULONG lba)
{
	ULONG tmp = lba % (de->de_Surfaces * de->de_BlocksPerTrack);

	return (tmp % de->de_BlocksPerTrack + 1);
}

static ULONG GetRootBlock_AROS(struct DosEnvec *de)
{
	return ((GetNumBlocks(de) - 1 + de->de_Reserved) / 2);
}
*/

//-----------------------------------------------------------------------------

/*typedef struct DILPlugin {
	DILParams					*p_Params;

   APTR 							 p_Seed;
	APTR 							 p_Source;
	APTR 							 p_Destination;

	ULONG 						 p_Block;
	ULONG 						 p_Blocks;
	ULONG 						 p_BlockSize;

	ULONG 						 p_Flags;
} DILPlugin;*/

#if 0
#define MORE
#else
#undef MORE
#endif

static LONG Test(void)
{
	DILParams params;

	InitParams(&params);

	if (dilSetup(&params))
   {
		DILPlugin plugin;
		struct DosEnvec *de = &params.p_DosEnvec;
		//ULONG i, j, k;

		memset(&plugin, 0, sizeof(plugin));
      plugin.p_Params = &params;
      plugin.p_Source = NULL;

		/*Printf("numblocks %6lu, lowblock %6lu, highblock %6lu, arosroot %6lu\n\n",
			GetNumBlocks(de),
			GetLowBlock(de),
			GetHighBlock(de),
			GetRootBlock_AROS(de)
		);*/

		srand(time(NULL));

		#ifdef MORE
		while (TRUE)
		#endif
      {
			ULONG c = de->de_LowCyl + rand() % (de->de_HighCyl - de->de_LowCyl + 1);
			ULONG h = rand() % (de->de_Surfaces + 1);
			ULONG t = 1ul + rand() % de->de_BlocksPerTrack;

			plugin.p_Block = CHS2LBA(de, c, h, t);
			plugin.p_Blocks = 1ul; //+ rand() % 1024;
			
			plugin.p_Flags = 0ul;
			setf(plugin.p_Flags, (rand() % 2) ? DILF_READ : DILF_WRITE);

			//Printf("cyl %6lu, lba %6lu\n", i, plugin.p_Block);
			
			dilProcess(&plugin);
			
			#ifdef MORE
			if (SetSignal(0ul, SIGBREAKF_CTRL_F) & SIGBREAKF_CTRL_F) break; Delay(25);
			#else
         {char buf[2]; Read(Input(), buf, 2l);}
			#endif
      }
		
		//{char buf[2]; Read(Input(), buf, 2l);}

		/*for (i = de->de_LowCyl; i <= de->de_HighCyl; i++)
		{
			for (j = 0ul; j < de->de_Surfaces; j++)
			{
				for (k = 1ul; k <= de->de_BlocksPerTrack; k++)
				{
					Printf("cyl %6lu, surface %6lu, track %6lu - LBA %lu\n",
						i, j, k, CHS2LBA(de, i, j, k));
				}
			}
		}

		Printf("\n\n");
		
		for (i = 0; i < GetNumBlocks(de); i++)
      {
			ULONG c, h, s;

			LBA2CHS(de, i, &c, &h, &s);
			Printf("cyl %6lu, surface %6lu, track %6lu - LBA %lu\n", c, h, s, i);
		}*/
		
		dilCleanup(&params);
	}
	else return ERROR_NO_FREE_STORE;
	
   return 0;
}

//-----------------------------------------------------------------------------





































