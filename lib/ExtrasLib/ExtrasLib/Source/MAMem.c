#include <proto/exec.h>
#include <clib/extras_protos.h>

/****** extras.lib/MultiAllocMemA ******************************************
*
*   NAME
*       MultiAllocMemA -- Multiple AllocMem.
*       MultiAllocMem -- varargs stub.
*
*   SYNOPSIS
*       succes = MultiAllocMemA(Flags, MemTagList)
*
*       BOOL MultiAllocMem(ULONG, struct MemTag *);
*
*       succes = MultiAllocMemA(Flags, MemTag)
*
*       BOOL MultiAllocMemA(Flags, ULONG, ...);
*
*   FUNCTION
*       Attempt to allocate one or more memory chunks
*       using AllocMem.
*
*   INPUTS
*       Flags - MA_FAILSIZE0: fail all allocations if any
*               have a size of 0.  if your application will be
*               allocating memory of dynamic sizes, and if
*               you want allocations of 0 bytes to fail, then
*               set this flag.
*       MemTag - pointer to an array of struct MemTag.
*                  vt_Ptr is the address of a pointer.
*                  vt_Size is the size of the allocation.
*                  vt_MemFlags are the exec memory (MEMF_) flags. 
*                Last tag should have vt_Ptr = NULL.
*                 
*   RESULT
*       zero if it couldn't allocate the requested memory. or non-zero
*       on success. vt_Ptrs will be point to a allocated 
*       memory chunk or NULL.  
*
*   EXAMPLE
*       EX1:
*         struct foo *bar;
*         STRPTR dest;
*         APTR cow;
*
*        if( MultiAllocMem(0,
*                           &bar,  sizeof(struct foo),  MEMF_CLEAR,
*                           &dest, 25,                  MEMF_PUBLIC,
*                           &cow,  100,                 MEMF_FAST|MEMF_PUBLIC,
*                           0))
*         {
*           ...
*           MultiFreeMem(3,
*                           bar  ,sizeof(struct foo),
*                           dest ,25,
*                           cow  ,100);
*         }
*
*       EX2: This will never fail.
*         APTR foo;
*         if(MultiAllocMem(0,
*                           &foo,0,MEMF_CLEAR,
*                           0)
*         {...}
*
*       EX3: This will always fail.
*         APTR foo;
*         if(MultiAllocMem(MA_FAILSIZE0,
*                           &foo,0,MEMF_CLEAR,
*                           0)
*         {...}
*
*   NOTES
*       requires exec.library to be open.
*
*       if the MA_FAILSIZE0 Flag is not set, 0 byte allocations
*       will pass even though no memory will be allocated for that.
*       entry and mt_Ptr will be set to 0.
*
*       The memory allocated may be freed individually with 
*       exec.library/FreeMem()
*
*   BUGS
*
*   SEE ALSO
*       MultiAllocVecA(), MultiFreeVecA(), MultiFreeMemA(),
*       MultiAllocPooledA(), MultiFreePooledA(),
*       exec.library/AllocVec(), exec.library/FreeVec()
*       exec.library/AllocMem(), exec.library/FreeMem()
*       exec.library/AllocPooled(), exec.library/FreePooled()
******************************************************************************
*
*/

BOOL MultiAllocMem(ULONG Flags, ULONG MemTag, ... )
{
  return(MultiAllocMemA(Flags,(struct MemTag *)&MemTag));
}

BOOL MultiAllocMemA(ULONG Flags, struct MemTag *MemTagList)
{
  struct MemTag *tag;
  
  if(MemTagList)
  {
    tag=MemTagList;
    while(tag->mt_Ptr)
    {
      *tag->mt_Ptr=0;
      tag++;
    }

    tag=MemTagList;
    
    if(Flags & MA_FAILSIZE0)
    {
      while(tag->mt_Ptr)
      {
        if(tag->mt_Size==0) return(FALSE);
        tag++;
      }
      tag=MemTagList;
    }
       
    while(tag->mt_Ptr)
    {
      if(tag->mt_Size)
      {
        if(!(*tag->mt_Ptr=AllocMem(tag->mt_Size,tag->mt_MemFlags)))
        {
          tag=MemTagList;
          while(tag->mt_Ptr)
          {
            if(tag->mt_Ptr) FreeMem(*tag->mt_Ptr,tag->mt_Size);
            tag++;
          }
          return(FALSE);     
        }
      }
      else
        *tag->mt_Ptr=0;
      
      tag++;
    }
    return(TRUE);
  }
  return(FALSE);
}

/****** extras.lib/MultiFreeMemA ******************************************
*
*   NAME
*       MultiFreeMemA -- Free multiple memory chunks.
*       MultiFreeMem -- varargs stub.
*
*   SYNOPSIS
*       MultiFreeMemA(Args, FreeTagList)
*
*       void MultiFreeMemA(ULONG, struct FreeTag *);
*
*       MultiFreeMem(Args, FreeTag, ... )
*
*       void MultiFreeMem(ULONG, ULONG, ... );
*
*   FUNCTION
*       Free multiple memory blocks allocated with MultiAllocMemA()
*       or exec.library/AllocMem(). 
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

void MultiFreeMem(ULONG Args, ULONG FreeTag, ... )
{
  MultiFreeMemA(Args,(struct FreeTag *)&FreeTag);
}

void MultiFreeMemA(ULONG Args, struct FreeTag *FreeTagList)
{
  LONG l;
  
  for(l=0;l<Args;l++)
  {
    FreeMem(FreeTagList[l].ft_Ptr, FreeTagList[l].ft_Size);
  }
}
