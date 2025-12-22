#include <proto/exec.h>
#include <clib/extras_protos.h>


/****** extras.lib/MultiAllocPooledA ******************************************
*
*   NAME
*       MultiAllocPooledA -- Multiple AllocPooled.
*       MultiAllocPooled -- varargs stub.
*
*   SYNOPSIS
*       succes = MultiAllocPooledA(Flags, PoolTagList)
*
*       BOOL MultiAllocPooled(ULONG, struct PoolTag*);
*
*       succes = MultiAllocPooledA(Flags, PoolTag)
*
*       BOOL MultiAllocPooledA(Flags, ULONG, ...);
*
*   FUNCTION
*       Attempt to allocate one or more memory chunks
*       using AllocPooled.
*
*   INPUTS
*       Flags - MA_FAILSIZE0: fail all allocations if any
*               have a size of 0.  if your application will be
*               allocating memory of dynamic sizes, and if
*               you want allocations of 0 bytes to fail, then
*               set this flag.
*       PoolTag - pointer to an array of struct PoolTag.
*                  pt_Ptr is the address of a pointer.
*                  pt_Size is the size of the allocation.
*                Last tag should have vt_Ptr = NULL.
*                 
*   RESULT
*       zero if it couldn't allocate the requested memory. or non-zero
*       on success. In either case, vt_Ptrs will be point to a allocated 
*       memory chunk or NULL.  
*
*   EXAMPLE
*       EX1:
*         APTR pool;
*         struct foo *bar;
*         STRPTR dest;
*         APTR cow;
*
*         if(pool=CreatePool(MEMF_ANY,300,300))
*         {
*           if( MultiAllocPooled(pool,0,
*                           &bar,  sizeof(struct foo),
*                           &dest, 50,       
*                           &cow,  100,
*                           0))
*           {
*             ...
*             MultiFreePooled(pool,3,
*                               bar,  sizeof(struct foo),
*                               dest, 50,
*                               cow,  100);
*           }
*           DeletePool(pool);
*         }
*
*       EX2: This will never fail.
*         if(MultiAllocPooled(pool,0,
*                           &foo, 0,
*                           0)
*         {...}
*
*       EX3: This will always fail.
*         if(MultiAllocPooled(pool,MA_FAILSIZE0,
*                           &foo, 0,
*                           0)
*         {...}
*
*   NOTES
*       requires exec.library to be open.
*
*       if the MA_FAILSIZE0 flag is not set, 0 byte allocations
*       will pass even though no memory will be allocated for that.
*       entry and mt_Ptr will be set to 0.
*
*       The memory allocated may be freed individually with 
*       exec.library/FreePooled()
*
*   BUGS
*
*   SEE ALSO
*       MultiFreeVecA(), MultiAllocMemA(),MultiFreeMemA(),
*       MultiFreePooledA(),
*       exec.library/AllocVec(), exec.library/FreeVec()
*       exec.library/AllocMem(), exec.library/FreeMem()
*       exec.library/AllocPooled(), exec.library/FreePooled()
******************************************************************************
*
*/



BOOL MultiAllocPooled(APTR Pool, ULONG Flags, ULONG PoolTag, ... )
{
  return(MultiAllocPooledA(Pool, Flags,(struct PoolTag *)&PoolTag));
}

BOOL MultiAllocPooledA(APTR Pool, ULONG Flags, struct PoolTag *PoolTagList)
{
  struct PoolTag *tag;
  
  if(PoolTagList)
  {
    tag=PoolTagList;
    while(tag->pt_Ptr)
    {
      *tag->pt_Ptr=0;
      tag++;
    }

    tag=PoolTagList;
    
    if(Flags & MA_FAILSIZE0)
    {
      while(tag->pt_Ptr)
      {
        if(tag->pt_Size==0) return(FALSE);
        tag++;
      }
      tag=PoolTagList;
    }
       
    while(tag->pt_Ptr)
    {
      if(tag->pt_Size)
      {
        if(!(*tag->pt_Ptr=AllocPooled(Pool, tag->pt_Size)))
        {
          tag=PoolTagList;
          while(tag->pt_Ptr)
          {
            if(tag->pt_Ptr) FreePooled(Pool, *tag->pt_Ptr, tag->pt_Size);
            tag++;
          }
          return(FALSE);     
        }
      }
      else
        *tag->pt_Ptr=0;
      
      tag++;
    }
    return(TRUE);
  }
  return(FALSE);
}

/****** extras.lib/MultiFreePooledA ******************************************
*
*   NAME
*       MultiFreePooledA -- Free multiple memory chunks.
*       MultiFreePooled -- varargs stub.
*
*   SYNOPSIS
*       MultiFreePooledA(Pool, Args, FreeTagList)
*
*       void MultiFreePooledA(APTR, ULONG, struct FreeTag *);
*
*       MultiFreePooled(Pool, Args, FreeTag, ... )
*
*       void MultiFreePooled(APTR, ULONG, ULONG, ... );
*
*   FUNCTION
*       Free multiple memory blocks allocated with MultiAllocPooledA()
*       or exec.library/AllocPooled(). 
*
*   INPUTS
*       Args - Number of blocks that are to be freed.
*       FreeTagList - An array of FreeTags. may be NULL.
*                       ft_Ptr - contains a pointer to a
*                                memory block or NULL.
*                       ft_Size - the size of the block.
*
*   RESULT
*       none.
*
*   NOTES
*       requires exec.library to be open.
*
*   SEE ALSO
*       MultiAllocVecA(), MultiFreeVecA(), MultiAllocMemA(),
*       MultiAllocPooledA(), MultiFreePooledA(),
*       exec.library/AllocVec(), exec.library/FreeVec()
*       exec.library/AllocMem(), exec.library/FreeMem()
*       exec.library/AllocPooled(), exec.library/FreePooled()
*
******************************************************************************
*
*/

void MultiFreePooled(APTR Pool, ULONG Args, ULONG FreeTag, ... )
{
  MultiFreePooledA(Pool, Args,(struct FreeTag *)&FreeTag);
}

void MultiFreePooledA(APTR Pool, ULONG Args, struct FreeTag *FreeTagList)
{
  LONG l;
  
  for(l=0;l<Args;l++)
  {
    FreePooled(Pool, FreeTagList[l].ft_Ptr, FreeTagList[l].ft_Size);
  }
}
