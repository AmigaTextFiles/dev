OPT TURBO

MODULE 'exec/execbase',
       'exec/lists',
       'exec/memory',
       'exec/nodes'

PROC mm_succFrom(listNode:PTR TO ln) RETURN listNode.succ

PROC maxMem(memType)
/*
**  Calculate max memory of type memType.  memType will be either
**  MEMF_CHIP for chip memory, or MEMF_FAST for fast memory.  The
**  memory is gotten from the memList in execbase, which is a list
**  of memory available to the system.
*/
  DEF execBase:PTR TO execbase, blockSize=0,
      memHeader:PTR TO mh, memList:PTR TO lh
  Forbid()
  /*-- Break down execBase. --*/
  execBase:=execbase
  memList:=execBase.memlist
  memHeader:=memList.head
  /*-- Follow the memlist to accumulate total ram of type memType. --*/
  WHILE mm_succFrom(memHeader.ln)  /* MemHeader.mh_Node.ln_Succ */
    IF memHeader.attributes AND
       memType THEN blockSize:=blockSize+memHeader.upper-memHeader.lower
    memHeader:=mm_succFrom(memHeader.ln)
  ENDWHILE
  Permit()
ENDPROC blockSize
  /* maxMem */
