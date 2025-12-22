#ifndef	EXEC_MEMORY_H
#define	EXEC_MEMORY_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 

OBJECT MemChunk
 
       Next:PTR TO MemChunk	
    Bytes:LONG		
ENDOBJECT


OBJECT MemHeader
 
       Node:Node
    Attributes:UWORD	
       First:PTR TO MemChunk 
    Lower:LONG		
    Upper:LONG		
    Free:LONG		
ENDOBJECT


OBJECT MemEntry
 
 UNION Un

    Reqs:LONG		
    Addr:LONG		
     ENDUNION
    Length:LONG		
ENDOBJECT

#define me_un	    me_Un	
#define me_Reqs     me_Un.meu_Reqs
#define me_Addr     me_Un.meu_Addr


OBJECT MemList
 
       Node:Node
    NumEntries:UWORD	
       ME[1]:MemEntry	
ENDOBJECT

#define ml_me	ml_ME		


#define MEMF_ANY    (0)	
#define MEMF_PUBLIC (1<<0)
#define MEMF_CHIP   (1<<1)
#define MEMF_FAST   (1<<2)
#define MEMF_LOCAL  (1<<8)	
#define MEMF_24BITDMA (1<<9)	
#define	MEMF_KICK   (1<<10)	
#define MEMF_CLEAR   (1<<16)	
#define MEMF_LARGEST (1<<17)	
#define MEMF_REVERSE (1<<18)	
#define MEMF_TOTAL   (1<<19)	
#define	MEMF_NO_EXPUNGE	(1<<31) 

#define MEM_BLOCKSIZE	8
#define MEM_BLOCKMASK	(MEM_BLOCKSIZE-1)


OBJECT MemHandlerData

	RequestSize:LONG	
	RequestFlags:LONG	
	Flags:LONG		
ENDOBJECT

#define	MEMHF_RECYCLE	(1<<0)	

#define	MEM_DID_NOTHING	(0)	
#define	MEM_ALL_DONE	(-1)	
#define	MEM_TRY_AGAIN	(1)	
#endif	
