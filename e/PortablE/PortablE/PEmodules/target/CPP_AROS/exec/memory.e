/* $Id: memory.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <exec/memory.h>}
NATIVE {EXEC_MEMORY_H} CONST

NATIVE {MemHeader} OBJECT mh
    {mh_Node}	ln	:ln
    {mh_Attributes}	attributes	:UINT
    {mh_First}	first	:PTR TO mc
    {mh_Lower}	lower	:APTR
    {mh_Upper}	upper	:APTR
    {mh_Free}	free	:ULONG
ENDOBJECT

NATIVE {MemChunk} OBJECT mc
    {mc_Next}	next	:PTR TO mc
    {mc_Bytes}	bytes	:ULONG
ENDOBJECT

NATIVE {MemEntry} OBJECT me
    {me_Un.meu_Reqs}	reqs	:ULONG
    {me_Un.meu_Addr}	addr	:APTR
    {me_Length}	length	:ULONG
ENDOBJECT
NATIVE {me_Reqs} DEF
NATIVE {me_Addr} DEF

NATIVE {MemList} OBJECT ml
    {ml_Node}	ln	:ln
    {ml_NumEntries}	numentries	:UINT
    {ml_ME}	me	:ARRAY OF me
ENDOBJECT

NATIVE {MEM_BLOCKSIZE} CONST MEM_BLOCKSIZE = 8
NATIVE {MEM_BLOCKMASK} CONST MEM_BLOCKMASK = (MEM_BLOCKSIZE - 1)

/* AllocMem() Flags */
NATIVE {MEMF_ANY}        CONST MEMF_ANY        = 0
NATIVE {MEMF_PUBLIC}     CONST MEMF_PUBLIC     = $1
NATIVE {MEMF_CHIP}       CONST MEMF_CHIP       = $2
NATIVE {MEMF_FAST}       CONST MEMF_FAST       = $4
NATIVE {MEMF_LOCAL}      CONST MEMF_LOCAL      = $100
NATIVE {MEMF_24BITDMA}   CONST MEMF_24BITDMA   = $200
NATIVE {MEMF_KICK}       CONST MEMF_KICK       = $400
NATIVE {MEMF_CLEAR}      CONST MEMF_CLEAR      = $10000
NATIVE {MEMF_LARGEST}    CONST MEMF_LARGEST    = $20000
NATIVE {MEMF_REVERSE}    CONST MEMF_REVERSE    = $40000
NATIVE {MEMF_TOTAL}      CONST MEMF_TOTAL      = $80000
NATIVE {MEMF_NO_EXPUNGE} CONST MEMF_NO_EXPUNGE = $80000000

/* New in AROS/MorphOS. Flag for CreatePool to get automatic
   semaphore protection */
NATIVE {MEMF_SEM_PROTECTED} CONST MEMF_SEM_PROTECTED = $100000

NATIVE {MemHandlerData} OBJECT memhandlerdata
    {memh_RequestSize}	requestsize	:ULONG
    {memh_RequestFlags}	requestflags	:ULONG
    {memh_Flags}	flags	:ULONG
ENDOBJECT

NATIVE {MEMHF_RECYCLE} CONST MEMHF_RECYCLE = $1

NATIVE {MEM_ALL_DONE}    CONST MEM_ALL_DONE    = (-1)
NATIVE {MEM_DID_NOTHING} CONST MEM_DID_NOTHING = 0
NATIVE {MEM_TRY_AGAIN}   CONST MEM_TRY_AGAIN   = 1
