#include <exec/libraries.h>
#include <dos/dosextens.h>
#include <proto/exec.h>
#include <clib/debug_protos.h>

#define MEMF_31BIT          (1<<12)	/* Memory that is in <2GiB area */

struct MemList	*LIB_AllocEntry(struct MemList	*MyMemList, struct ExecBase	*SysBase);

int main(void)
{
UBYTE *ptr,*a,*b,*c,*d;
struct MemList src_memlist;
struct MemList *ml;
ULONG size;
void	*Pool1;
void	*Pool2;

#if 1
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocMem PreWall Test\n");
	kprintf("* AllocSize 4\n");
	kprintf("* Hit[-1]\n");

	if ((ptr=AllocMem(4,MEMF_ANY)))
	{
		ptr[-1]=0;
		FreeMem(ptr,4);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocMem PostWall Test\n");
	kprintf("* AllocSize 4\n");
	kprintf("* Hit[AllocSize]\n");

	if ((ptr=AllocMem(4,MEMF_ANY)))
	{
		ptr[4]=0;
		FreeMem(ptr,4);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocMem PostWall Test\n");
	kprintf("* AllocSize 4\n");
	kprintf("* Hit[AllocSize+4]\n");

	if ((ptr=AllocMem(4,MEMF_ANY)))
	{
		ptr[8]=0;
		FreeMem(ptr,4);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocMem PostWall Test\n");
	kprintf("* AllocSize 8\n");
	kprintf("* Hit[AllocSize]\n");

	if ((ptr=AllocMem(8,MEMF_ANY)))
	{
		ptr[8]=0;
		FreeMem(ptr,8);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocMem PostWall Test\n");
	kprintf("* AllocSize 16\n");
	kprintf("* Hit[AllocSize]\n");
	if ((ptr=AllocMem(16,MEMF_ANY)))
	{
		ptr[16]=0;
		FreeMem(ptr,16);
	}









	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocVec PreWall Test\n");
	kprintf("* AllocSize 4\n");
	kprintf("* Hit[-1]\n");

	if ((ptr=AllocVec(4,MEMF_ANY)))
	{
		ptr[-1]=0;
		FreeVec(ptr);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocVec PostWall Test\n");
	kprintf("* AllocSize 4\n");
	kprintf("* Hit[AllocSize]\n");

	if ((ptr=AllocVec(4,MEMF_ANY)))
	{
		ptr[4]=0;
		FreeVec(ptr);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocVec PostWall Test\n");
	kprintf("* AllocSize 4\n");
	kprintf("* Hit[AllocSize+4]\n");

	if ((ptr=AllocVec(4,MEMF_ANY)))
	{
		ptr[8]=0;
		FreeVec(ptr);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocVec PostWall Test\n");
	kprintf("* AllocSize 8\n");
	kprintf("* Hit[AllocSize]\n");

	if ((ptr=AllocVec(8,MEMF_ANY)))
	{
		ptr[8]=0;
		FreeVec(ptr);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocVec PostWall Test\n");
	kprintf("* AllocSize 16\n");
	kprintf("* Hit[AllocSize]\n");
	if ((ptr=AllocVec(16,MEMF_ANY)))
	{
		ptr[16]=0;
		FreeVec(ptr);
	}

#endif

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocEntry Test\n");
	src_memlist.ml_NumEntries      = 1;
	src_memlist.ml_ME[0].me_Reqs   = MEMF_PUBLIC | MEMF_CLEAR;
	src_memlist.ml_ME[0].me_Length = 0x186a0 + 0x14 + sizeof(struct Process);

	kprintf("* Size 0x%lx\n",src_memlist.ml_ME[0].me_Length);

	//ml = AllocEntry(&src_memlist);
	ml = LIB_AllocEntry(&src_memlist,SysBase);

	if (!((ULONG) ml & (1UL << 31)))
	{
		FreeEntry(ml);
	}
	else
	{
		kprintf("* failed to alloc, result 0x%lx\n",ml);
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* AllocEntry Problem Test\n");
	size = sizeof(struct MemList) - sizeof(struct MemEntry) + (1 * sizeof(struct MemEntry));
	kprintf("* Size 0x%lx\n",size);

	if ((ptr=AllocMem(size, MEMF_31BIT | MEMF_CLEAR)))
	{
		FreeMem(ptr,size);
	}
	else
	{
		kprintf("* failed to alloc\n");
	}

	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("**************************************************************\n");
	kprintf("* Pool Test\n");
	if ((Pool1=CreatePool(MEMF_ANY,1000,1000)))
	{
		kprintf("* Pool 1 0x%lx\n",Pool1);

		if ((Pool2=CreatePool(MEMF_ANY,1000,1000)))
		{
			kprintf("* Pool 2 0x%lx\n",Pool2);

			kprintf("* AllocPooled 20 Bytes from Pool 1\n");
			a=AllocPooled(Pool1,20);
			kprintf("* = 0x%lx\n",a);
			kprintf("* FreePooled 0x%lx 20 Bytes from Pool 1\n",a);
			FreePooled(Pool1,a,20);

			kprintf("* AllocPooled 20 Bytes from Pool 2\n");
			b=AllocPooled(Pool2,20);
			kprintf("* = 0x%lx\n",b);
			kprintf("* FreePooled 0x%lx 20 Bytes from Pool 2\n",b);
			FreePooled(Pool2,b,20);

			kprintf("* AllocPooledAligned 20 Bytes align 64 offset 4 from Pool 1\n");
			a=AllocPooledAligned(Pool1,20,64,0);
			kprintf("* = 0x%lx\n",a);
			kprintf("* FreePooled 0x%lx 20 Bytes from Pool 1\n",a);
			FreePooled(Pool1,a,20);

			kprintf("* AllocPooledAligned 20 Bytes align 64 offset 4 from Pool 1\n");
			a=AllocPooledAligned(Pool1,20,64,4);
			kprintf("* = 0x%lx\n",a);
			kprintf("* FreePooled 0x%lx 20 Bytes from Pool 1\n",a);
			FreePooled(Pool1,a,20);

			DeletePool(Pool2);
		}
		else
		{
			kprintf("* Pool2 creation failed\n");
		}
		DeletePool(Pool1);
	}
	else
	{
		kprintf("* Pool1 creation failed\n");
	}




	return(0);
}

struct MemList	*LIB_AllocEntry(struct MemList	*MyMemList, struct ExecBase	*SysBase)
{


  struct MemEntry	*MyMemEntry;
  struct MemEntry	*NewMemEntry;
  struct MemList	*NewMemList;
  ULONG			i;

  (kprintf("LIB_AllocEntry: MemList 0x%lx\n",
                       MyMemList));

  NewMemList = (struct MemList *) AllocMem(sizeof(struct MemList) - sizeof(struct MemEntry) + (MyMemList->ml_NumEntries*sizeof(struct MemEntry)),
                                           MEMF_31BIT | MEMF_CLEAR);
  if (!NewMemList)
  {
    (kprintf("LIB_AllocEntry: Error\n"));

    return((struct MemList *) (MEMF_CLEAR | (1UL<<31)));
  }

  (kprintf("LIB_AllocEntry: NewMemList 0x%lx\n",
                       NewMemList));

  NewMemList->ml_NumEntries=MyMemList->ml_NumEntries;

  for (i=0,MyMemEntry=&MyMemList->ml_ME[0],NewMemEntry=&NewMemList->ml_ME[0];i<MyMemList->ml_NumEntries;i++,MyMemEntry++,NewMemEntry++)
  {
    (kprintf("LIB_AllocEntry: AllocMem Size 0x%lx Attr 0x%lx\n",
                         MyMemEntry->me_Length,
                         MyMemEntry->me_Un.meu_Reqs));

    if ((NewMemEntry->me_Un.meu_Addr=AllocMem(MyMemEntry->me_Length,
                                              MyMemEntry->me_Un.meu_Reqs)))
    {
      NewMemEntry->me_Length=MyMemEntry->me_Length;

      (kprintf("LIB_AllocEntry: NewMemEntry 0x%lx Addr 0x%lx Size 0x%lx\n",
                           NewMemEntry,
                           NewMemEntry->me_Un.meu_Addr,
                           NewMemEntry->me_Length));

    }
    else
    {

      (kprintf("LIB_AllocEntry: Not Enough Memory\n"));

      FreeEntry(NewMemList);
      return((struct MemList *) (MyMemEntry->me_Un.meu_Reqs | (1UL<<31)));
    }
  }
  (kprintf("LIB_AllocEntry: Result=NewMemList 0x%lx\n",
                           NewMemList));
  return(NewMemList);
}
