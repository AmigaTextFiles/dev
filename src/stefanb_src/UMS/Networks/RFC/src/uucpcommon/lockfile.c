
/*
 *  LOCKFILE.C
 *
 *  (C) Copyright 1989-1990 by Matthew Dillon,  All Rights Reserved.
 *
 *  Now uses OwnDevUnit.Library
 *  Installs exit handler to deal with program exit
 *
 *  WARNING:    cannot call MakeConfigPath() since static buffer will
 *              be overwritten and caller might expect it not to be
 */

#include <clib/exec_protos.h>
#include <exec/types.h>
#include <exec/lists.h>
#include <libraries/dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <config.h>
#include <OwnDevUnit.h>
#include <log.h>

typedef struct List LIST;
typedef struct Node NODE;

typedef struct {
    NODE    Node;
    FILE    *Fi;
    short   Refs;
} LNode;

Prototype void LockFile(const char *);
Prototype void UnLockFile(const char *);
Prototype void UnLockFiles(void);
Prototype int FileIsLocked(const char *);
Local void FreeLockNode(LNode *);

LIST LockList = { (NODE *)&LockList.lh_Tail, NULL, (NODE *)&LockList.lh_Head };
static char Buf[512];

extern struct Library *OwnDevUnitBase;

void
LockFile(file)
const char *file;
{
    const char *ptr;
    char *lockDir = GetConfigDir(LOCKDIR);
    short lockLen = strlen(lockDir);
    LNode *node;
    LNode *n;

    for (ptr = file + strlen(file); ptr >= file && *ptr != '/' && *ptr != ':'; --ptr)
        ;
    ++ptr;

    if (node = malloc(sizeof(LNode) + lockLen + 16 + strlen(ptr))) {
        node->Node.ln_Name = (char *)(node + 1);

        strcpy(node->Node.ln_Name, MakeConfigPathBuf(Buf, LOCKDIR, ptr));
        strcat(node->Node.ln_Name, ".LOCK");

        for (n = (LNode *)LockList.lh_Head; n != (LNode *)&LockList.lh_Tail; n = (LNode *)n->Node.ln_Succ) {
            if (stricmp(node->Node.ln_Name, n->Node.ln_Name) == 0) {
                ++n->Refs;
                free(node);
                return;
            }
        }
#ifdef NOTDEF
        while ((node->Fi = fopen(node->Node.ln_Name, "w")) == NULL) {
            sleep(2);
            chkabort();
        }
#endif
        if (OwnDevUnitBase) {
            if (ptr = LockDevUnit(node->Node.ln_Name, 0, LogProgram, 0)) {
                ulog(-1, "LockDevUnit() failed: %s", ptr);
            }
        }
        node->Refs = 1;
        AddTail(&LockList, &node->Node);
    }
}

/*
 *  Check to see whether a file is locked.  We could try to fopen the
 *  file for 'w', but this causes unnecesary filesystem activity
 */

int
FileIsLocked(file)
const char *file;
{
    const char *ptr;
/*    FILE *fi; !!! UNUSED !!! */
    char buf[128];
#ifdef NOTDEF
    long lock;
#endif

    for (ptr = file + strlen(file); ptr >= file && *ptr != '/' && *ptr != ':'; --ptr)
        ;
    ++ptr;
    sprintf(buf, "%s.LOCK", MakeConfigPathBuf(Buf, LOCKDIR, ptr));

#ifdef NOTDEF
    if (lock = Lock(buf, EXCLUSIVE_LOCK)) {
        UnLock(lock);
        return(0);
    }
    if (IoErr() == ERROR_OBJECT_IN_USE)
        return(1);
    return(0);
#endif
    if (OwnDevUnitBase) {
        if (AvailDevUnit(buf, 0))
            return(0);
        return(1);
    }
    return(0);
}

void
UnLockFile(file)
const char *file;
{
    LNode *node;
/*    short len; !!! UNUSED !!! */
    const char *ptr;

    for (ptr = file + strlen(file); ptr >= file && *ptr != '/' && *ptr != ':'; --ptr)
        ;
    ++ptr;

    MakeConfigPathBuf(Buf, LOCKDIR, ptr);
    strcat(Buf, ".LOCK");

    for (node = (LNode *)LockList.lh_Head; node != (LNode *)&LockList.lh_Tail; node = (LNode *)node->Node.ln_Succ) {
        if (stricmp(Buf, node->Node.ln_Name) == 0) {
            if (--node->Refs == 0)
                FreeLockNode(node);
            break;
        }
    }
}

void
UnLockFiles()
{
    LNode *node;

    while ((node = (LNode *)LockList.lh_Head) != (LNode *)&LockList.lh_Tail)
        FreeLockNode(node);
}

static void
FreeLockNode(node)
LNode *node;
{
    Remove((struct Node *) node);
#ifdef NOTDEF
    fclose(node->Fi);
    unlink(node->Node.ln_Name);
#endif
    if (OwnDevUnitBase)
        FreeDevUnit(node->Node.ln_Name, 0);
    free(node);
}

