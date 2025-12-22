
#include "memory_proto.h"





typedef struct MemoryNode
{
    struct MinNode node;
    APTR mem_ptr;  // pointer to allocated memory
    ULONG size;    // allocated memory size (bytes)
    ULONG flags;   // flags related to alloceted memory
} MemoryNode;





// Allocate memory and adds a node to the manager
APTR AllocMemory(APTR mem_mgr, ULONG size, ULONG flags)
{
    if (!mem_mgr || size == 0)
        return NULL;

    struct MemoryNode *new_node = (struct MemoryNode *) SYS_AllocMem(sizeof(struct MemoryNode), MEMF_PUBLIC | MEMF_CLEAR);
    if (!new_node)
        return NULL;

    new_node->mem_ptr = SYS_AllocMem(size, flags);
    if (!new_node->mem_ptr)
    {
        SYS_FreeMem(new_node, sizeof(struct MemoryNode));
        return NULL;
    }

    new_node->size = size;
    new_node->flags = flags;
    SYS_AddTail((struct List *) mem_mgr, (struct Node *)new_node);

    return new_node->mem_ptr;

}//AllocMemory





// Free all memory blocks allocated inside a manager
void ClearMemoryManager(APTR mem_mgr)
{
    if (!mem_mgr)
        return;

    struct MinList *list = (struct MinList *) mem_mgr;
    struct MemoryNode *current, *next;
    for (
        current = (struct MemoryNode *) list->mlh_Head;
        current->node.mln_Succ != NULL;
        current = next
        )
    {
        next = (struct MemoryNode *) current->node.mln_Succ;
        SYS_FreeMem(current->mem_ptr, current->size);
        SYS_FreeMem(current, sizeof(struct MemoryNode));
    }

    InitMemoryManager(mem_mgr);

}//ClearMemoryManager





// Create the memory manager
APTR CreateMemoryManager()
{
    struct MinList *result = (struct MinList *)SYS_AllocMem(sizeof(struct MinList), MEMF_PUBLIC | MEMF_CLEAR);
    if (!result)
        return NULL;

    InitMemoryManager(result);

    return result;

}//CreateMemoryManager





// Deletes the memory manager, freeing all allocated memory blocks
VOID DeleteMemoryManager(APTR mem_mgr)
{
    if (!mem_mgr)
        return;

    ClearMemoryManager(mem_mgr);
    SYS_FreeMem(mem_mgr, sizeof(struct MinList));

}//DeleteMemoryManager





// Deallocate a single memory block
void FreeMemory(APTR mem_mgr, APTR mem_ptr)
{
    if (!mem_mgr || !mem_ptr)
        return;

    struct MinList *list = (struct MinList *) mem_mgr;
    struct MemoryNode *current;
    for (current = (struct MemoryNode *) list->mlh_Head;
         current->node.mln_Succ != NULL;
         current = (struct MemoryNode *) current->node.mln_Succ)
    {
        if (current->mem_ptr == mem_ptr)
        {
            SYS_Remove((struct Node *) current);
            SYS_FreeMem(current->mem_ptr, current->size);
            SYS_FreeMem(current, sizeof(struct MemoryNode));
            break;
        }
    }//next current

}//FreeMemory





// Initialize the memory manager
VOID InitMemoryManager(APTR mem_mgr)
{
    struct MinList *list = (struct MinList *) mem_mgr;
    list->mlh_Head = (struct MinNode *)&list->mlh_Tail;
    list->mlh_Tail = NULL;
    list->mlh_TailPred = (struct MinNode *)&list->mlh_Head;

}//InitMemoryManager

