
// specify 1 to compile this example for OCS systems
#if 0

#include <stdio.h>

#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <exec/memory.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <intuition/intuition.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>

#include "../sdk/C/c2p_context.h"
#include "c2p_context_proto.h"
#include "sys_helpers_proto.h"
#include "librarybase.h"

#pragma dontwarn 214    // Hide warning: suspicious format string

#define WIDTH 320
#define HEIGHT 200
#define DEPTH C2P_CONTEXT_PLANAR_FORMAT_5_BIT
#define ITERATIONS 320
#define FORCE_SCRAMBLED FALSE

APTR Context;
struct Library *IntuitionBase;
struct GfxBase *GfxBase;
struct LibraryBase *C2PBase;

ULONG ErrorCode;

struct Screen *Screen = NULL;
struct Window *Window = NULL;
struct BitMap *BitMap = NULL;
UBYTE *Reference = NULL;





BOOL OpenLibraries(VOID)
{
    BOOL result = FALSE;

    do
    {
        int amigaos_1_2 = 33;   // version for AmigaOS 1.2 (early Amiga 500 models)

        GfxBase = SYS_OpenLibrary("graphics.library", amigaos_1_2);
        if (GfxBase == NULL)
            break;
        printf("GfxBase: 0x%08x\n", GfxBase);

        IntuitionBase = SYS_OpenLibrary("intuition.library", amigaos_1_2);
        if (IntuitionBase == NULL)
            break;
        printf("IntuitionBase: 0x%08x\n", IntuitionBase);

        C2PBase->lb_SysBase = (*((struct ExecBase **) 4));
        C2PBase->lb_GfxBase = (struct GfxBase *) GfxBase;
        C2PBase->lb_IntuitionBase = (struct IntuitionBase *) IntuitionBase;

        ULONG c2plib = _C2P_InitLibrary(C2PBase);
        if (c2plib != ERR_NONE)
        {
            printf("InitLibrary error code: 0x%08x\n", c2plib);
            break;
        }

        ULONG cpu = _C2P_GetSystemParameter(C2P_SYSTEM_PARAMETER_CPU, C2PBase);
        switch (cpu)
        {
            case C2P_SYSTEM_CPU_68000:
                printf("Detected CPU: 68000\n");
                break;
            case C2P_SYSTEM_CPU_68010:
                printf("Detected CPU: 68010\n");
                break;
            case C2P_SYSTEM_CPU_68020:
                printf("Detected CPU: 68020\n");
                break;
            case C2P_SYSTEM_CPU_68030:
                printf("Detected CPU: 68030\n");
                break;
            case C2P_SYSTEM_CPU_68040:
                printf("Detected CPU: 68040\n");
                break;
            case C2P_SYSTEM_CPU_68060:
                printf("Detected CPU: 68060\n");
                break;
            case C2P_SYSTEM_CPU_68080:
                printf("Detected CPU: 68080\n");
                break;
            default:
                printf("Unknown CPU code: 0x%08x\n", cpu);
                break;
        }

        // all done here
        result = TRUE;

    } while (FALSE);

    return result;

}//OpenLibraries





VOID CloseLibraries(VOID)
{
    _C2P_ExitLibrary(C2PBase);

    if (IntuitionBase != NULL)
    {
        SYS_CloseLibrary(IntuitionBase);
        IntuitionBase = NULL;
    }

    if (GfxBase != NULL)
    {
        SYS_CloseLibrary(GfxBase);
        GfxBase = NULL;
    }

}//CloseLibraries





VOID CleanUp(VOID)
{
    if (Reference)
    {
        _C2P_FreeMem(Reference);
        Reference = NULL;
    }

    if (Window)
    {
        CloseWindow(Window);
        Window = NULL;
    }

    if (Screen)
    {
        BOOL screen_closed = CloseScreen(Screen);
        printf("Screen closed = %d\n", screen_closed);
        Screen = NULL;
    }

    if (Context)
    {
        ULONG context_type = _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_TYPE);
        if (context_type == C2P_CONTEXT_TYPE_CUSTOM_BITMAP)
        {
            if (BitMap)
            {
                printf("Destroying custom bitmap\n");
                _C2P_DestroyBitMap(BitMap, C2PBase);
                BitMap = NULL;
            }
        }
        _C2P_DestroyContext(Context, C2PBase);
        Context = NULL;
    }

    CloseLibraries();

}//CleanUp





int main()
{
    struct IntuiMessage *msg, local_msg;
    BOOL done = FALSE;

    struct LibraryBase _LibraryBase;
    C2PBase = &_LibraryBase;

    printf("\n");
    printf("c2p.library\n");
    printf("Copyright (c) 2022-2025 Alimede Informatica\n");
    printf("www.alimede.com - All Rights Reserved.\n");
    printf("\n");
    printf("debug log:\n");
    printf("\n");

    if (!OpenLibraries())
    {
        CleanUp();
        return -1;
    }

    Context = _C2P_CreateContext(C2PBase);
    if (Context == NULL)
    {
        printf("Cannot create Context :-(\n");
        CleanUp();
        return -2;
    }

    printf("Context: 0x%08x\n", Context);

    Reference = _C2P_AllocMem(Context, WIDTH * HEIGHT);
    if (Reference == NULL)
    {
        printf("Cannot allocate reference buffer :-(\n");
        CleanUp();
        return -4;
    }

    BitMap = _C2P_CreateBitMap(Context, WIDTH, HEIGHT, DEPTH, C2PBase);
    if (BitMap == NULL)
    {
        printf("Cannot create custom bitmap :-(\n");
        CleanUp();
        return -5;
    }

    struct NewScreen new_screen = {
        0, 0,                   // X, Y position
        WIDTH, HEIGHT,          // size
        DEPTH,                  // number of bitplanes
        DETAILPEN, BLOCKPEN,    // draw pens
        0 ,                     // view mode (0 => LOWRES)
        CUSTOMSCREEN | CUSTOMBITMAP | SCREENQUIET,  // screen type
        NULL,                   // font
        NULL,                   // title
        NULL,                   // gadgets
        BitMap                  // custom bitmap
        };

    Screen = OpenScreen(&new_screen);

    _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_TYPE, C2P_CONTEXT_TYPE_CUSTOM_BITMAP);
    _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_BITMAP, (ULONG) BitMap);
    _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_WIDTH, WIDTH);
    _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_HEIGHT, HEIGHT);
    _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_PLANAR_FORMAT, DEPTH);
    _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED, FORCE_SCRAMBLED);
    //_C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_CONVERT_COUNT, WIDTH * 32);
    //_C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_REFERENCE, (ULONG) Reference);
    //_C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK, TRUE);

    ErrorCode = _C2P_InitializeContext(Context, C2PBase);

    printf("Context initialization: 0x%08x\n", ErrorCode);
    UBYTE *chk = (UBYTE *) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_CHUNKY);
    printf("Chunky address: 0x%08x\n", chk);
    BitMap = (APTR) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_BITMAP);
    printf("BitMap address: 0x%08x\n", BitMap);
    struct BitMap *b = (struct BitMap *) BitMap;
    for (int i = 0; i<8; i++)
        printf("Bitplane %d address: 0x%08x\n", i, b->Planes[i]);
    BOOL force_scrambled = (BOOL) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED);
    printf("Scrambled chunky buffer: %d\n", force_scrambled);

    printf("BitMap->BytesPerRow: 0x%08x\n", b->BytesPerRow);

    ULONG planar_format = (ULONG) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_PLANAR_FORMAT);
    printf("Planar format: 0x%08x\n", planar_format);
    UBYTE *ref = (UBYTE *) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_REFERENCE);
    printf("Reference address: 0x%08x\n", ref);
    BOOL reference_writeback = (BOOL) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK);
    printf("Reference writeback: %d\n", reference_writeback);

    printf("Screen address: 0x%08x\n", Screen);
    printf("Error code: 0x%08x\n", ErrorCode);
    if (Screen == NULL)
    {
        CleanUp();
        return -6;
    }

    struct NewWindow new_window = {
        0, 0,                   // top left
        WIDTH, HEIGHT,          // size
        DETAILPEN, BLOCKPEN,    // draw pens
        IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY,   // IDCMP flags
        WFLG_ACTIVATE | WFLG_BORDERLESS | WFLG_RMBTRAP, // wnidow flags
        NULL,                   // gadgets
        NULL,                   // checkmark
        NULL,                   // title
        Screen,                 // screen pointer
        NULL,                   // bitmap
        WIDTH, HEIGHT,          // min size
        WIDTH, HEIGHT,          // max size
        CUSTOMSCREEN            // screen type
        };
    
    Window = OpenWindow(&new_window);

    if (Window == NULL)
    {
        CleanUp();
        return -7;
    }

    ScreenToFront(Screen);
    ActivateWindow(Window);

    // write pixel on screen margins
    _C2P_WritePixel(Context, 0, 0, 1);
    _C2P_WritePixel(Context, WIDTH - 1, 0, 1);
    _C2P_WritePixel(Context, 0, HEIGHT - 1, 1);
    _C2P_WritePixel(Context, WIDTH - 1, HEIGHT - 1, 1);

    struct ViewPort *vp = &Screen->ViewPort;

    for (ULONG i = 0; i < ITERATIONS; i++)
    {
        //_C2P_CopyMem(Reference, chk, WIDTH * HEIGHT);
        _C2P_WritePixel(Context, i, i >> 1, i+1);
        WaitTOF();
        // _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_SOURCE_OFFSET, WIDTH * 12);
        // _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_TARGET_OFFSET, WIDTH * 40);
        // _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_CONVERT_COUNT, WIDTH * 80);
        _C2P_Chunky2Planar(Context, C2PBase);

        // // swap chunky and reference buffer
        // UBYTE *swap = chk;
        // chk = Reference;
        // Reference = swap;
        // _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_CHUNKY, (ULONG) chk);
        // _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_REFERENCE, (ULONG) Reference);
    }

    done = TRUE;    // skip next part

    while(!done)
    {
        WaitPort(Window->UserPort);
        while((msg = (struct IntuiMessage *)GetMsg(Window->UserPort)))
        {
            CopyMem(msg, &local_msg, sizeof(struct IntuiMessage));
            ReplyMsg((struct Message *)msg);

            switch(msg->Class)
            {
                case IDCMP_VANILLAKEY:
                    printf("Got message: IDCMP_VANILLAKEY\n");
                    done = TRUE;
                    break;

                case IDCMP_CLOSEWINDOW:
                    printf("Got message: IDCMP_CLOSEWINDOW\n");
                    done = TRUE; 
                    break;                 
            }
        }
    }

    CleanUp();

    printf("-\nEnd of program reached!\n");
    printf("Press RETURN key to exit...\n");
    getchar();    

    return 0;

}//main

#endif

