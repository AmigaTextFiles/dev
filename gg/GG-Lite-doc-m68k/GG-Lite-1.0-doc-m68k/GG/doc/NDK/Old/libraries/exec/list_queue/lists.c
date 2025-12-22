/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals.
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

/*
 * Lists.Example - Example program for the lists chapter
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <exec/nodes.h>

#include <proto/all.h>

#include <string.h>
#include <stdio.h>

int CXBRK(VOID) { return(0); }

struct MyNodes {
    struct Node My_Node;
    UBYTE   data[64];
};

/* The type of our name_nodes... */
#define NAME_NODE   27

VOID AddName(struct List *list,UBYTE *name)
{
struct MyNodes *name_node;

    if (name_node=AllocMem(sizeof(struct MyNodes),MEMF_PUBLIC|MEMF_CLEAR))
    {
        strcpy(name_node->data,name);
        name_node->My_Node.ln_Name=name_node->data;
        name_node->My_Node.ln_Type=NAME_NODE;
        name_node->My_Node.ln_Pri=0;
        AddHead(list,(struct Node *)name_node);
    }
}

/*
 * This function frees the whole list, including the header.
 * Note that it does not update the header as it is freeing the list.
 * It is also very important that you do not reference memory
 * that has been freed.
 */
VOID FreeMyList(struct List *list)
{
struct MyNodes *name_node;
struct MyNodes *next_node;

    name_node=(struct MyNodes *)(list->lh_Head);
    while (next_node=(struct MyNodes *)(name_node->My_Node.ln_Succ))
    {
        FreeMem(name_node,sizeof(struct MyNodes));
        name_node=next_node;
    }
    FreeMem(list,sizeof(struct List));
}

VOID DisplayList(struct List *list)
{
struct Node *node;

    if (list->lh_TailPred==(struct Node *)list)
    {
        printf("List is empty.\n");
    }
    else
    {
        for (node=list->lh_Head;node->ln_Succ;node=node->ln_Succ)
        {
            printf("%lx -> %s\n",node,node->ln_Name);
        }
    }
}

VOID DisplayName(struct List *list,UBYTE *name)
{
struct Node *node;

    if (node=FindName(list,name))
    {
        while (node)
        {
            printf("Found %s at node %lx\n",node->ln_Name,node);
            node=FindName((struct List *)node,name);
        }
    }
    else printf("No node with %s found.\n",name);
}

VOID main(int argc, UBYTE *argv[])
{
struct  List    *MyList;

    if (MyList=AllocMem(sizeof(struct List),MEMF_PUBLIC|MEMF_CLEAR))
    {
        NewList(MyList);

        AddName(MyList,"Name7");
        AddName(MyList,"Name6");
        AddName(MyList,"Name5");
        AddName(MyList,"Name4");
        AddName(MyList,"Name3");
        AddName(MyList,"Name2");
        AddName(MyList,"Name1");
        AddName(MyList,"Name0");

        AddName(MyList,"Name7");
        AddName(MyList,"Name6");
        AddName(MyList,"Name5");
        AddName(MyList,"Name4");
        AddName(MyList,"Name3");
        AddName(MyList,"Name2");
        AddName(MyList,"Name1");
        AddName(MyList,"Name0");

        if (argc)
        {
            DisplayName(MyList,"Name5");
            DisplayList(MyList);
        }

        FreeMyList(MyList);
    }
}
