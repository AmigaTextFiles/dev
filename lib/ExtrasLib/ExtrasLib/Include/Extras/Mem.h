#ifndef EXTRAS_MEM_H
#define EXTRAS_MEM_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

struct MemTag
{
  APTR *mt_Ptr;
  ULONG mt_Size,
        mt_MemFlags;
};

struct VecTag
{
  APTR *vt_Ptr;
  ULONG vt_Size,
        vt_MemFlags;
};

struct PoolTag
{
  APTR *pt_Ptr;
  ULONG pt_Size;
};

struct FreeTag
{
  APTR  ft_Ptr;
  ULONG ft_Size;
};

/*** Flags for MultiAlloc-() ***/
#define MA_FAILSIZE0       (1<<0) /* Fails if any size is 0 */

#endif /* EXTRAS_MEM_H */
