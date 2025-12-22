//--------------------------------------------------------------------------//
// This file is in the public domain.                                       //
//--------------------------------------------------------------------------//
#include <stddef.h>
#include <exec/io.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <clib/exec_protos.h>
//--------------------------------------------------------------------------//
#include "mem.h"
#define Debug(x,y,z,w)
//--------------------------------------------------------------------------//
struct MemoryBlock
{
    struct MemoryBlock *next;
    size_t size;
    void *address;
};
//--------------------------------------------------------------------------//
struct MemoryList
{
    struct MemoryBlock *first;
    struct MemoryBlock *last;
    long size;
    long count;
    long opcount;
};
//--------------------------------------------------------------------------//
static struct MemoryList *list = NULL;
//--------------------------------------------------------------------------//
void allocerror(char*, size_t);
void deallocerror(char*, void*);
//--------------------------------------------------------------------------//
void* allocmem(size_t size)
{
    struct MemoryBlock *newblock;
    size_t allocsize;

    if (list == NULL) {
        list =
            (struct MemoryList*)
            AllocVec(sizeof(struct MemoryList), MEMF_ANY | MEMF_CLEAR);

        if (!list) {
            allocerror("list", sizeof(struct MemoryList));
            return 0;
        }

        list->first = NULL;
        list->last = NULL;
        list->size = 0;
        list->count = 0;
    }

    // Align to bytes of 4
    allocsize = (size + 3) & ~0x03UL;

    newblock =
        (struct MemoryBlock*)
        AllocVec(sizeof(struct MemoryBlock), MEMF_ANY | MEMF_CLEAR);

    if (!newblock) {
        allocerror("block", sizeof(struct MemoryBlock));
        return 0;
    }

    newblock->address =
        (struct MemoryBlock*)
        AllocVec(allocsize, MEMF_ANY | MEMF_CLEAR);

    if (!newblock->address) {
        FreeVec(newblock);
        allocerror("memory", allocsize);
        return 0;
    }

    newblock->size = allocsize;
    newblock->next = NULL;

    if(list->first == NULL) {
        list->first = newblock;
        list->last = newblock;
    } else {
        list->last->next = newblock;
        list->last = newblock;
    }

    list->size += allocsize;
    list->count++;

    list->opcount++;
    if (list->opcount % 25 == 0) {
        Debug(
            NULL,
            "Memory usage: %d bytes allocated in %d blocks.\n",
            list->size,
            list->count
        );
    }

    //Debug(NULL, "Memory allocated at address (%x)\n", newblock->address);

    return newblock->address;
}

//--------------------------------------------------------------------------//

void freemem(void* block)
{
    struct MemoryBlock *current, *last;

    if (list == NULL || block == NULL) {
        deallocerror("list", 0);
        return;
    }

    if (block == NULL) {
        deallocerror("memory", 0);
        return;
    }

    last = NULL;
    current = list->first;
    while (current != NULL && current->address != block) {
        last = current;
        current = current->next;
    }

    if (current == NULL) {
        deallocerror("address not found", block);
        return;
    }

    list->size -= current->size;
    list->count--;

    if (list->first == current) {
        list->first = NULL;
        list->last = NULL;
    } else if (list->last == current) {
        last->next = current->next;
        list->last = last;
    } else {
        last->next = current->next;
    }

    FreeVec(current->address);
    FreeVec(current);

    list->opcount++;

    //Debug(NULL, "Memory deallocated at address (%x)\n", block);
}

void freeall()
{
    struct MemoryBlock *current, *next;

    if (list == NULL) {
        return;
    }

    current = list->first;
    while (current != NULL) {
        next = current->next;
        FreeVec(current->address);
        FreeVec(current);
        current = next;
    }

    FreeVec(list);
    list = NULL;
}

//--------------------------------------------------------------------------//

void allocerror(char *descr, size_t size)
{
    Debug(NULL, "Memory allocation error (%s) with size (%d)\n", descr, size);
}

void deallocerror(char *descr, void *p)
{
    Debug(NULL, "Memory deallocation error (%s) address (%x)\n", descr, p);
}

//--------------------------------------------------------------------------//

char *strdup(const char *s1)
{
    char *s2;
    size_t len = strlen(s1);
    s2 = allocmem(++len);

    if(s2 == NULL)
    {
        return NULL;
    }

    memcpy(s2, s1, --len);
    return s2;
}

//--------------------------------------------------------------------------//
