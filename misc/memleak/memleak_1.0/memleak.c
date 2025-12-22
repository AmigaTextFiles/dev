/*
 * MemLeak: Test for memory leaks.
 *
 * ©1994 by Francesco Devitt -- Freely distributable without profit.
 *
 * email: ffranc@comp.vuw.ac.nz
 * snail: 29a Kinghorne St, Strathmore, Wellington, NZ.
 *
 */

#include <exec/types.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>

#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <exec/memory.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "memory.h"

static ULONG last_memory;

#define ALL_MEMORY (0xfffffff)
#define SAME_LIMIT 50
#define DIFF_DELAY 1

const char VerString[] = "$VER: MemLeak 1.0 " __AMIGADATE__;


/* Patching the gadtools code:

memory.h: Reqiures a "void" inserted in the proto for MemoryCloseWindow
memory.c: Replace "clib" with "proto" and "_protos" with "", in the #includes.

There are two warnings generated when compiling memory.c, but
it is not worth fixing them each time.

*/


void clear_gadget(int gad, char *str)
{
    GT_SetGadgetAttrs(MemoryGadgets[gad], MemoryWnd, NULL,
        GTTX_Text, str,
        TAG_END);
}


void set_gadget(int gad, char *buf, int num)
{
    sprintf(buf,"%d", num);
    
    GT_SetGadgetAttrs(MemoryGadgets[gad], MemoryWnd, NULL,
        GTTX_Text, buf,
    TAG_END);
}



ULONG memory_available(void)
{
    ULONG prev, mem;
    int same=0;
    
    prev=0;
    
    for (;;)
    {
        /* First flush memory */
        
        APTR tmp = AllocMem(ALL_MEMORY, MEMF_ANY);
        if (tmp) FreeMem(tmp,ALL_MEMORY);  /* Just in case! */
        
        /* determine memory size */
        
        mem = AvailMem(MEMF_ANY);
        
        /* Exit if memory size has not changed for a while */
        
        if (mem != prev) same=0;
        else if (++same >= SAME_LIMIT) break;
        
        prev=mem;
        
        Delay(DIFF_DELAY);
    }
    
    return mem;
}


ULONG mem_before;
ULONG mem_after;

char before_text[32];
char after_text[32];
char diff_text[32];



int BeforeGadClicked( void )
{
    clear_gadget(GD_BeforeText, "wait...");
    clear_gadget(GD_AfterText, NULL);
    clear_gadget(GD_DiffText, NULL);
    
    mem_before = memory_available();
    
    set_gadget(GD_BeforeText, before_text, mem_before);
    
    return 1;
}


int AfterGadClicked(void)
{
    clear_gadget(GD_AfterText, "wait...");
    clear_gadget(GD_DiffText, NULL);
    
    mem_after = memory_available();
    
    set_gadget(GD_AfterText, after_text, mem_after);
    set_gadget(GD_DiffText, diff_text, mem_before-mem_after);
    
    return 1;
}



void fail(char *str)
{
    struct EasyStruct es=
    {
        sizeof(struct EasyStruct),
        0,
    };
    
    es.es_Title = "Memory check";
    es.es_TextFormat = "Fail: %s";
    es.es_GadgetFormat = "OK";
    
    EasyRequest(0,&es,0,str);
    
    exit(10);
}

    
int MemoryCloseWindow( void )
{
    return 0;
}


void main(void)
{
    if (SetupScreen()) fail("Cannot get screen info");
    if (OpenMemoryWindow())
    {
        CloseDownScreen();
        fail("Cannot open window");
    }
    
    do {
        
        Wait(1L << MemoryWnd->UserPort->mp_SigBit);
        
    } while (HandleMemoryIDCMP());
    
    CloseMemoryWindow();
    CloseDownScreen();
}
