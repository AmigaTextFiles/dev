/*
 * :ts=4
 *
 * $VER: memory_pool_insights.h 1.4 (22.1.2022)
 *
 * Gain insights into how well your software uses memory pools by adding
 * #define SHOW_MEMORY_POOL_INSIGHTS to your source code, including this
 * header file and then calling show_memory_pool_insights() with the
 * memory pool parameter, like so:
 *
 *     show_memory_pool_insights(SysBase, pool);
 *
 * Note that the SysBase parameter must be valid, for version checking.
 *
 * show_memory_pool_insights() will print usage information using the
 * debug.lib/kprintf function, like so:
 *
 *    total pool size = 24 (header) + 116480 (puddle size) + 0 (large allocations) bytes -> 116504 bytes
 *    total pool size minus free puddle memory = 106328 bytes
 *    number of puddles = 14
 *    number of large allocations = 0
 *    number of fragments in puddles = 21
 *    puddles memory used = 106304 of 116480 bytes (91%)
 *    memory usage = 100% puddles and 0% large allocations
 *    how many puddles are filled to a specific percentage (no overlaps!):
 *            > 50% = 1 (4744 bytes -> 4% of all puddle memory)
 *            > 70% = 3 (19216 bytes -> 16% of all puddle memory)
 *            > 90% = 10 (82344 bytes -> 70% of all puddle memory)
 *
 * Careful: As with all memory pool operations you must make sure that
 *          only one Task/Process at a time can look at the data structures
 *          or modify them. Otherwise you may get a crash or see inconsistent
 *          information.
 *
 * Note that this code assumes Kickstart 1.2--Kickstart 3.x, with the
 * amiga.lib implementation of the memory pool functions used for
 * Kickstart version older than 3.0 and 3.1.
 *
 * Because the AmigaOS 4 memory pools work differently (and use a different
 * memory management system) you should use this code only on legacy Amiga
 * systems. Now you know why the SysBase parameter has to be passed to
 * the show_memory_pool_insights() function ;-)
 *
 *
 * Written by Olaf Barthel <obarthel at gmx dot net>
 * 2022-01-18
 *
 * Public domain :-)
 */

/****************************************************************************/

#ifdef SHOW_MEMORY_POOL_INSIGHTS

/****************************************************************************/

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif /* EXEC_LISTS_H */

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif /* EXEC_MEMORY_H */

/****************************************************************************/

/* This signature identifies a large allocation on the list
 * which contains both puddles and such large memory allocations.
 */
#define IS_LARGE_ALLOCATION 0

/****************************************************************************/

/* A private memory pool, as used by this implementation of the
 * pool memory management functions in amiga.lib and Kickstart
 * V39/V40, etc. Note that AmigaOS 4 has a completely different
 * memory pool design!
 */
struct MemoryPool
{
	struct MinList	mp_PuddleMinList;		/* Both puddles and large allocations
											 * are stored in this list. The puddles
											 * are stored near the head of the list
											 * and the large allocations are stored
											 * near the tail of the list.
											 */

	ULONG			mp_MemoryFlags;			/* Memory attributes for allocation,
		 									 * which may also include MEMF_CLEAR.
											 */
	ULONG			mp_PuddleSize;			/* Largest allocation which will fit
											 * into a single puddle.
											 */
	ULONG			mp_PuddleSizeThreshold;	/* Allocations which exceed this size
											 * will be allocated separately and not
											 * make use of the puddles.
											 */
};

/****************************************************************************/

/* The management data structure associated with a separate large memory
 * allocation. This is distinct from the puddles.
 */
struct LargeAllocation
{
	struct MinNode	la_MinNode;

	ULONG			la_Signature;	/* Must be set to IS_LARGE_ALLOCATION */
};

/****************************************************************************/

/* This combines a plain Node, a MemHeader and a LargeAllocation. They
 * all overlap to some degree. The "puddle" is really a MemHeader from
 * which the individual memory allocations are made.
 *
 * For reference, here is how the individual data structures look like.
 * The 'struct MinNode' is used by the 'struct LargeAllocation' and you
 * can see that the LargeAllocation.la_Signature overlaps the
 * Node.ln_Type and Node.ln_Pri fields. The 'struct MemHeader' begins
 * with a 'struct Node' and is initialized so that the Node.ln_Type and
 * Node.ln_Pri are never zero. This is why LargeAllocation.la_Signature
 * being zero is key to identifying large allocations which along with
 * the MemHeaders share the same storage list.
 *
 * struct MinNode {
 *     struct MinNode *  mln_Succ;
 *     struct MinNode *  mln_Pred;
 * };
 *
 * struct LargeAllocation {
 *     struct MinNode    la_MinNode;
 *     ULONG             la_Signature;
 * };
 *
 * struct Node {
 *     struct Node *     ln_Succ;
 *     struct Node *     ln_Pred;
 *     UBYTE             ln_Type;
 *     BYTE              ln_Pri;
 *     char *            ln_Name;
 * };
 *
 * struct MemHeader {
 *     struct Node       mh_Node;
 *     UWORD             mh_Attributes;
 *     struct MemChunk * mh_First;
 *     APTR              mh_Lower;
 *     APTR              mh_Upper;
 *     ULONG             mh_Free;
 * };
 */
union PuddleUnion
{
	struct Node				pu_Node;
	struct MemHeader		pu_MemHeader;
	struct LargeAllocation	pu_LargeAllocation;
};

/****************************************************************************/

STATIC VOID
show_memory_pool_insights(struct Library * SysBase, APTR pool)
{
	extern kprintf(const char *fmt, ...);

	const struct MemoryPool * mp = pool;
	const union PuddleUnion * pu;

	ULONG num_puddles = 0;
	ULONG total_puddle_size = 0;
	ULONG total_puddle_size_used = 0;
	ULONG total_puddle_fragments = 0;
	ULONG num_large_allocations = 0;
	ULONG total_large_allocation_size = 0;
	ULONG total_size;
	int usage_count_by_percent[10];
	ULONG memory_used_by_percent[10];
	BOOL usage_count_taken = FALSE;

	/* Note: any assumptions made about the data structures used
	 *       by memory pools only hold for Kickstart 1.2, 1.3,
	 *       2.x and 3.x. The AmigaOS 4 memory pool design is
	 *       something completely different.
	 */
	if (SysBase->lib_Version >= 33 && SysBase->lib_Version < 50)
	{
		int i;

		for (i = 0 ; i < 10 ; i++)
		{
			usage_count_by_percent[i] = 0;
			memory_used_by_percent[i] = 0;
		}

		for (pu = (union PuddleUnion *)mp->mp_PuddleMinList.mlh_Head ;
		     pu->pu_Node.ln_Succ != NULL ;
		     pu = (union PuddleUnion *)pu->pu_Node.ln_Succ)
		{
			if (pu->pu_LargeAllocation.la_Signature == IS_LARGE_ALLOCATION)
			{
				const struct LargeAllocation * la = &pu->pu_LargeAllocation;
				const ULONG * allocation_size = (ULONG *)&la[1];

				num_large_allocations++;

				total_large_allocation_size += (*allocation_size);
			}
			else
			{
				const struct MemHeader * mh = &pu->pu_MemHeader;
				const struct MemChunk * mc;
				ULONG size;

				num_puddles++;

				size = (BYTE *)mh->mh_Upper - (BYTE *)mh->mh_Lower;

				total_puddle_size += size;
				total_puddle_size_used += size - mh->mh_Free;

				if (mh->mh_Free < size)
				{
					int percent;

					/* How much memory is used? */
					percent = 100 - 100 * mh->mh_Free / size;

					percent /= 10;
					if (percent >= 10)
						percent--;

					usage_count_by_percent[percent]++;
					memory_used_by_percent[percent] += size - mh->mh_Free;

					usage_count_taken = TRUE;
				}

				for (mc = mh->mh_First ; mc != NULL ; mc = mc->mc_Next)
					total_puddle_fragments++;
			}
		}

		kprintf("total pool size = %lu (header) + %lu (puddle size) + %lu (large allocations) bytes -> %lu bytes\n",
			sizeof(*mp), total_puddle_size, total_large_allocation_size,
			sizeof(*mp) + total_puddle_size + total_large_allocation_size);

		kprintf("total pool size minus free puddle memory = %lu bytes\n",
			sizeof(*mp) + total_puddle_size_used + total_large_allocation_size);

		kprintf("number of puddles = %lu\n", num_puddles);
		kprintf("number of large allocations = %lu\n", num_large_allocations);
		kprintf("number of fragments in puddles = %lu\n", total_puddle_fragments);

		if (total_puddle_size > 0)
		{
			kprintf("puddles memory used = %lu of %lu bytes (%ld%%)\n",
				total_puddle_size_used,
				total_puddle_size,
				100 * total_puddle_size_used / total_puddle_size);
		}
		else
		{
			kprintf("puddles memory used = 0\n");
		}

		total_size = total_puddle_size + num_large_allocations;
		if (total_size > 0)
		{
			LONG puddle_percent;

			puddle_percent = 100 * total_puddle_size / total_size;

			kprintf("memory usage = %ld%% puddles and %ld%% large allocations\n", puddle_percent, 100 - puddle_percent);
		}

		if (usage_count_taken)
		{
			int i;

			kprintf("how many puddles are filled to a specific percentage (no overlaps!):\n");

			for(i = 0 ; i < 10 ; i++)
			{
				if (usage_count_by_percent[i] > 0)
				{
					kprintf("\t> %2ld%% = %ld (%lu bytes -> %ld%% of all puddle memory)\n",
						i * 10,
						usage_count_by_percent[i],
						memory_used_by_percent[i],
						100 * memory_used_by_percent[i] / total_puddle_size);
				}
			}
		}
		else
		{
			kprintf("no puddles currently have any memory allocated\n");
		}
	}
}

/****************************************************************************/

#else

/****************************************************************************/

#define show_memory_pool_insights(sysbase, pool) ((void)0)

/****************************************************************************/

#endif /* SHOW_MEMORY_POOL_INSIGHTS */
