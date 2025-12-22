{ GE_MemPools.i -- Memory management routines }

{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:Utils/GE_Hooks.i"}
{$I "Include:Libraries/GE_AVL.i"}
{$I "Include:Libraries/GEngine.i"}

Type
 {Memory Pool structure for memory management}
 GE_MemPool = Record
	mp_MemList: List; {Linked list of MemHeaders}
	mp_MemTree: ^AVLNodePtr;  {The same for fast searches}
	mp_MemFree,			  {Total Free Memory on the pool} 
	mp_MemTotal,		  {Total size of the pool}
	mp_Size: Integer;		  {Size of each memory chunk}
	mp_Attr: Integer;		  {Memory Attributes}
	mp_FreeChunks: Short;     {Number of totally free chunks}
	mp_ColapseNum:Short;	  {Maximun number of free chunks allowed}
 end;

 GE_MemPoolPtr = ^GE_MemPool;


{Create new MemPool}
Function GE_NewMemPool(Size:Integer; Attr:Integer; CN:Short):GE_MemPoolPtr;
External;

{Allocate memory from pool}
Function GE_PoolAlloc(MP:GE_MemPoolPtr; Size:Integer):Address;
External;

{--Dellocate Memory from pool--}
Procedure GE_PoolDealloc(MP:GE_MemPoolPtr; block:Address; Size:Integer);
External;

{Free memory pool}
Procedure GE_FreeMemPool(MP:GE_MemPoolPtr);
External;
