#include <exec/exec.h>
#include <exec/execbase.h>

/* MemClear.c - (c) 1986-90 Dallas John Hodgson VER 1.05

	= Compiled under Aztec C : 32-bit int mode =

   	MemClear walks through the free memory lists zeroing along the way.
Written mainly as an exercise, but may prove useful to some. This kind of
system manipulation should never be performed in interrupt code; see RKM:Exec,
Pg. 56 for more information.

	Memory management consists of a linked list of MemHeaders, each
of which points to a linked list of MemChunks. The address of the first
MemHeader is contained in ExecBase, yielding access to the whole mess.

	Each MemHeader oversees a hardware RAM partition, such as CHIP
memory or a contiguous block of FAST RAM. It contains information regarding
Attribute, (CHIP|FAST|PUBLIC) the block's address space, free space remaining,
free list pointer, and link. The free bytes count is the sum total of all
the Length fields in its free list; a linked list of MemChunks each containing
a Length field and a link.

	Note that there are no actual pointers to the free space itself;
Rather, the MemChunks are like Exec Messages in that there is a link node
on top followed by 0..N bytes of free space. The MemChunk Length fields
include the sizeof() the MemChunk structure itself, so a MemChunk cannot be
shorter than 2 longwords. What AllocMem() does is searches each MemHeader that
matches your attribute and looks for the FIRST MemChunk that fits. The node is
unlinked from the chain, and its address returned. If the allocation was
smaller than the node, the excess space is again partitioned up and linked
into the MemChunk free list. The Length field of the MemHeader is decreased
by the size of your allocation. Keep in mind that all allocations are rounded
up to the nearest 8 bytes. Also, MemChunks are coalesced together whenever
their address spaces are contiguous; it is imperative that the largest
contiguous space possible be maintained for large-chunk applications such as
bitmap allocation.

This new version allows the user to specify the memory fill byte (0 by
default) & display additional diagnostic information regarding CHIP and
FAST RAM fragmentation. */

extern struct ExecBase *SysBase;

main(argc,argv)
int argc;
char *argv[];
{
  struct MemHeader *memhdr;
  struct MemChunk *memchunk;
  ULONG fast_total=0,chip_total=0;
  UWORD fast_count=0,chip_count=0,flag;
  unsigned value=0;

  printf("MemClear v1.05 : © 1986-90, Dallas J. Hodgson\n");

  if (argc>1) {
    if (!sscanf(argv[1],"%x",&value)) {
      puts("Usage : MemClear [hex byte-value]");
      exit(100);
    }
    if (value>0xff) {
      puts("Value must be within range of 00-FF");
      exit(100);
    }
  }
  
  Forbid(); /* task switching OFF */

  /* traverse linked list of MemHeaders */

  for (memhdr=(struct MemHeader *)SysBase->MemList.lh_Head;
          memhdr->mh_Node.ln_Succ;
              memhdr=(struct MemHeader *)memhdr->mh_Node.ln_Succ) {

    flag=memhdr->mh_Attributes & MEMF_CHIP;

    /* traverse linked list of MemChunks */

    for (memchunk=memhdr->mh_First;memchunk;memchunk=memchunk->mc_Next) {

      /* zap free space; but don't touch the node! */

      if (memchunk->mc_Bytes>sizeof(*memchunk))
        setmem((char *)memchunk+sizeof(*memchunk),
          memchunk->mc_Bytes-sizeof(*memchunk),value);

      if (flag) {
        chip_total+=memchunk->mc_Bytes-sizeof(*memchunk);
        chip_count++;
      }
      else {
        fast_total+=memchunk->mc_Bytes-sizeof(*memchunk);
        fast_count++;
      }
    }  
  }

  Permit();

  printf("%7d bytes of CHIP memory in %d MemChunks filled w/value %xH.\n",chip_total,chip_count,value);
  printf("%7d bytes of FAST memory in %d MemChunks filled w/value %xH.\n",fast_total,fast_count,value);
}
