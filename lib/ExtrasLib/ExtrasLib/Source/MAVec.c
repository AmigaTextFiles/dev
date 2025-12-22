#include <proto/exec.h>
#include <clib/extras_protos.h>


/****** extras.lib/MultiAllocVecA ******************************************
*
*   NAME
*       MultiAllocVecA -- Multiple AllocVec.
*       MultiAllocVec -- varargs stub.
*
*   SYNOPSIS
*       succes = MultiAllocVecA(Flags, VecTagList)
*
*       BOOL MultiAllocVec(ULONG, struct VecTag *);
*
*       succes = MultiAllocVecA(Flags, VecTag)
*
*       BOOL MultiAllocVecA(Flags, ULONG, ...);
*
*   FUNCTION
*       Attempt to allocate one or more memory chunks
*       using AllocVec.
*
*   INPUTS
*       Flags - MA_FAILSIZE0: fail all allocations if any
*               have a size of 0.  if your application will be
*               allocating memory of dynamic sizes, and if
*               you want allocations of 0 bytes to fail, then
*               set this flag.
*       VecTag - pointer to an array of struct VecTag.
*                  vt_Ptr is the address of a pointer.
*                  vt_Size is the size of the allocation.
*                  vt_MemFlags are the exec memory (MEMF_) flags. 
*                Last tag should have vt_Ptr = NULL.
*                 
*   RESULT
*       zero if it couldn't allocate the requested memory. or non-zero
*       on success. In either case, vt_Ptrs will be point to a allocated 
*       memory chunk or NULL.  
*
*   EXAMPLE
*       EX1:
*         struct foo *bar;
*         STRPTR dest;
*         APTR cow;
*
*        if( MultiAllocVec(0,
*                           &bar,  sizeof(struct foo),  MEMF_CLEAR,
*                           &dest, strlen(str)+1,       MEMF_PUBLIC,
*                           &cow,  100,                 MEMF_FAST|MEMF_PUBLIC,
*                           0))
*         {
*           ...
*           MultiFreeVec(3,bar,dest,cow);
*         }
*
*       EX2: This will never fail.
*         APTR foo;
*         if(MultiAllocVec(0,
*                           &foo,0,MEMF_CLEAR,
*                           0)
*         {...}
*
*       EX3: This will always fail.
*         APTR foo;
*         if(MultiAllocVec(MA_FAILSIZE0,
*                           &foo,0,MEMF_CLEAR,
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
*       exec.library/FreeVec()
*
*   BUGS
*
*   SEE ALSO
*       MultiFreeVecA(), MultiAllocMemA(),MultiFreeMemA(),
*       MultiAllocPooledA(),MultiFreePooledA(),
*       exec.library/AllocVec(), exec.library/FreeVec()
*       exec.library/AllocMem(), exec.library/FreeMem()
*       exec.library/AllocPooled(), exec.library/FreePooled()
******************************************************************************
*
*/


BOOL MultiAllocVec(ULONG Flags, ULONG VecTag, ... )
{
  return(MultiAllocVecA(Flags,(struct VecTag *)&VecTag));
}

BOOL MultiAllocVecA(ULONG Flags, struct VecTag *VecTagList)
{
  struct VecTag *tag;
  
  if(VecTagList)
  {
    tag=VecTagList;
    while(tag->vt_Ptr)
    {
      *tag->vt_Ptr=0;
      tag++;
    }

    tag=VecTagList;
    
    if(Flags & MA_FAILSIZE0)
    {
      while(tag->vt_Ptr)
      {
        if(tag->vt_Size==0) return(FALSE);
        tag++;
      }
      tag=VecTagList;
    }
       
    while(tag->vt_Ptr)
    {
      if(tag->vt_Size)
      {
        if(!(*tag->vt_Ptr=AllocVec(tag->vt_Size,tag->vt_MemFlags)))
        {
          tag=VecTagList;
          while(tag->vt_Ptr)
          {
            if(tag->vt_Ptr) FreeVec(*tag->vt_Ptr);
            tag++;
          }
          return(FALSE);     
        }
      }
      else
        *tag->vt_Ptr=0;
      
      tag++;
    }
    return(TRUE);
  }
  return(FALSE);
}

/****** extras.lib/MultiFreeVecA ******************************************
*
*   NAME
*       MultiFreeVecA -- Free multiple memory chunks.
*       MultiFreeVec -- varargs stub.
*
*   SYNOPSIS
*       MultiFreeVecA(Args,MemBlockList)
*
*       MultiFreeVecA(ULONG, APTR *);
*
*       MultiFreeVec(Args, MemBlock)
*
*       void MultiFreeVec(ULONG, ULONG, ... );
*
*   FUNCTION
*       Free multiple memory blocks allocated with MultiAllocVecA()
*       or exec.library/AllocVec(). 
*
*   INPUTS
*       Args - Number of blocks that are to be freed.
*       MemBlockList - An array of pointers to memory
*                      blocks to be freed or NULL.
*
*   RESULT
*       none.
*
*   NOTES
*       requires exec.library to be open.
*
*   SEE ALSO
*       MultiAllocVecA(), MultiFreeVecA(), MultiAllocMemA(), MultiFreeMemA(),
*       MultiAllocPooledA(), MultiFreePooledA(),
*       exec.library/AllocVec(), exec.library/FreeVec()
*       exec.library/AllocMem(), exec.library/FreeMem()
*       exec.library/AllocPooled(), exec.library/FreePooled()
******************************************************************************
*
*/

void MultiFreeVec(ULONG Args, APTR MemBlock, ... )
{
  MultiFreeVecA(Args,&MemBlock);
}

void MultiFreeVecA(ULONG Args, APTR *MemBlockList)
{
  LONG l;
  
  for(l=0;l<Args;l++)
    FreeVec(MemBlockList[l]);
}
