
// specify 0 to compile this example for AGA systems
#if 1

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
#define DEPTH C2P_CONTEXT_PLANAR_FORMAT_8_BIT
#define ITERATIONS 320
#define INTERLEAVED FALSE
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
        int amigaos_3_0 = 39;   // version for AmigaOS 3.0 (Amiga AGA models)

        GfxBase = SYS_OpenLibrary("graphics.library", amigaos_3_0);
        if (GfxBase == NULL)
            break;
        printf("GfxBase: 0x%08x\n", GfxBase);

        IntuitionBase = SYS_OpenLibrary("intuition.library", amigaos_3_0);
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

        BOOL akiko_detected = (BOOL) _C2P_GetSystemParameter(C2P_SYSTEM_PARAMETER_AKIKO_DETECTED, C2PBase);
        APTR akiko_c2p = (APTR) _C2P_GetSystemParameter(C2P_SYSTEM_PARAMETER_AKIKP_C2P_PTR, C2PBase);
        printf("Akiko chip %s", akiko_detected ? "detected" : "not detected\n");
        if (akiko_detected)
            printf(": 0x%08x\n", akiko_c2p);

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

    APTR mem_sys = _C2P_AllocMem_System(1234, C2PBase);
    printf("System memory: 0x%08x\n", mem_sys);
    if (mem_sys == NULL)
    {
        printf("Cannot allocate memory :-(\n");
        CleanUp();
        return -3;
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

    if (INTERLEAVED)
        _C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_INTERLEAVED_BITMAP, INTERLEAVED);

    BitMap = _C2P_CreateBitMap(Context, WIDTH, HEIGHT, DEPTH, C2PBase);
    if (BitMap == NULL)
    {
        printf("Cannot create custom bitmap :-(\n");
        CleanUp();
        return -5;
    }

    Screen = OpenScreenTags(
        NULL,
        SA_Depth,       DEPTH,
        SA_Width,       WIDTH,
        SA_Height,      HEIGHT,
        /*
        SA_DisplayID,   LORES_KEY,
        */
        SA_Title,       "c2p.library",
        SA_ShowTitle,   FALSE,
        //SA_Type,        CUSTOMSCREEN,
        /**/
        SA_Type,        CUSTOMSCREEN | CUSTOMBITMAP,
        SA_BitMap,      BitMap,
        /**/
        SA_ErrorCode,   &ErrorCode,
        SA_Exclusive,   TRUE,
        SA_Interleaved, INTERLEAVED,
        SA_Quiet,       TRUE,
        TAG_END
        );

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


    // ULONG scrambled_offsets_count = (ULONG) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSETS_COUNT);
    // printf("Scrambled offsets count: %d\n", scrambled_offsets_count);
    // printf("Scrambled offsets: ");
    // for (int i = 0; i < scrambled_offsets_count; i++)
    // {
    //     LONG offset = (LONG) _C2P_GetContextIndexedParameter(Context, C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSET, i);
    //     printf("(%d:%d) ", i, offset);
    // }
    // printf("\n");

    ULONG planar_format = (ULONG) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_PLANAR_FORMAT);
    printf("Planar format: 0x%08x\n", planar_format);
    UBYTE *ref = (UBYTE *) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_REFERENCE);
    printf("Reference address: 0x%08x\n", ref);
    BOOL reference_writeback = (BOOL) _C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK);
    printf("Reference writeback: %d\n", reference_writeback);

    // printf("END DEBUG...\n");
    // CleanUp();
    // return 0;

    // struct Custom* custom = (struct Custom*) 0xDFF000;
    // custom->fmode = 0x4001;
    printf("Screen address: 0x%08x\n", Screen);
    printf("Error code: 0x%08x\n", ErrorCode);
    if (Screen == NULL)
    {
        CleanUp();
        return -6;
    }

    Window = OpenWindowTags(
        NULL,
        WA_IDCMP,           IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY,
        WA_Top,             0,
        WA_Left,            0,
        WA_Width,           WIDTH,
        WA_Height,          HEIGHT,
        WA_CustomScreen,    Screen,
        WA_Backdrop,        TRUE,
        WA_Borderless,      TRUE,
        WA_Flags,           WFLG_RMBTRAP,
        TAG_END
        );
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

    b->Planes[0][0] = 255;
    b->Planes[0][321] = 255;
    b->Planes[7][41] = 170;
    b->Planes[0][642] = 255;
    // b->Planes[0][1] = 126;
    // b->Planes[1][0] = 126;
    // b->Planes[1][1] = 60;
    // b->Planes[2][0] = 60;
    // b->Planes[3][0] = 24;
    // b->Planes[4][0] = 16;

    struct ViewPort *vp = &Screen->ViewPort;
    //SetRGB32(vp, 255, 255 << 24, 0, 0);

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

    // UBYTE bt = b->Planes[0][0];
    // printf("Bpl #0 debug: 0x%02x\n", bt);

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

