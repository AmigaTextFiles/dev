
/*
    This example shows how to convert a limited chunky data using source
    offset on chunky and target offset on bitmap.

    Require c2p.library v1.3 or newer.
*/



#include <stdio.h>

#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <exec/memory.h>
#include <graphics/gfx.h>
#include <intuition/intuition.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>

#include "../C/c2p.h"
#pragma dontwarn 214    // Hide warning: suspicious format string

#define WIDTH 320
#define HEIGHT 200

struct Library *IntuitionBase;
struct Library *GfxBase;
struct Library *C2PBase;
APTR Context;
struct Screen *Screen;
struct Window *Window;
struct BitMap *BitMap;

ULONG ErrorCode;





VOID CleanUp(VOID);
VOID FillChunkyData(UBYTE *chunky, ULONG displacement);
BOOL Initialize(VOID);
VOID SetPalette(struct ViewPort *vp);





int main()
{
    struct IntuiMessage *msg, local_msg;

    printf("\n");
    printf("c2p.library\n");
    printf("Copyright (c) 2022 Alimede Informatica\n");
    printf("www.alimede.com - All Rights Reserved.\n");
    printf("\n");
    printf("debug log:\n");
    printf("\n");

    if (!Initialize())
    {
        CleanUp();
        return -1;
    }

    C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_TYPE, C2P_CONTEXT_TYPE_BITMAP);
    C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_WIDTH, WIDTH);
    C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_HEIGHT, HEIGHT);
    C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_PLANAR_FORMAT, C2P_CONTEXT_PLANAR_FORMAT_8_BIT);

    ErrorCode = C2P_InitializeContext(Context);
    printf("Context initialization: 0x%08x\n", ErrorCode);
    UBYTE *chk = (UBYTE *) C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_CHUNKY);
    printf("Chunky address: 0x%08x\n", chk);
    APTR bmp = (APTR) C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_BITMAP);
    printf("BitMap address: 0x%08x\n", bmp);
    struct BitMap *b = (struct BitMap *) bmp;
    for (int i = 0; i < 8; i++)
        printf("Bitplane %d address: 0x%08x\n", i, b->Planes[i]);

    Screen = OpenScreenTags(NULL,
                        SA_Depth,       8,
                        SA_Width,       WIDTH,
                        SA_Height,      HEIGHT,
                        /*
                        SA_DisplayID,   LORES_KEY,
                        */
                        SA_Title,       "c2p.library",
                        SA_ShowTitle,   FALSE,
                        SA_Type,        CUSTOMSCREEN | CUSTOMBITMAP,
                        SA_BitMap,      bmp,
                        SA_ErrorCode,   &ErrorCode,
                        SA_Exclusive,   TRUE,
                        SA_Quiet,       TRUE,
                        TAG_END);
    if (ErrorCode != 0)
    {
        printf("Screen error code: 0x%08x\n", ErrorCode);
    }
    if (Screen == NULL)
    {
        printf("Cannot open Screen :-(\n");
        CleanUp();
        return -2;
    }

    Window = OpenWindowTags(NULL,
                        WA_IDCMP,           IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY,
                        WA_Top,             0,
                        WA_Left,            0,
                        WA_Width,           WIDTH,
                        WA_Height,          HEIGHT,
                        WA_CustomScreen,    Screen,
                        WA_Backdrop,        TRUE,
                        WA_Borderless,      TRUE,
                        WA_Flags,           WFLG_RMBTRAP,
                        TAG_END);
    if (Window == NULL)
    {
        printf("Cannot open Window :-(\n");
        CleanUp();
        return -3;
    }

    SetPalette(&Screen->ViewPort);

    ScreenToFront(Screen);
    ActivateWindow(Window);

    // firsts, fill all chunky data and convert it
    FillChunkyData(chk, 0);
    C2P_Chunky2Planar(Context);

    // next, adjust offsets
    C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_SOURCE_OFFSET, WIDTH * 12);
    C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_TARGET_OFFSET, WIDTH * 40);
    C2P_SetContextParameter(Context, C2P_CONTEXT_PARAMETER_CONVERT_COUNT, WIDTH * 80);

    // finally, convert only a small size of chunky data
    for (ULONG i = 0; i < 256 ; i++)
    {
        FillChunkyData(chk, i);

        WaitTOF();
        C2P_Chunky2Planar(Context);
    }

    CleanUp();

    printf("\n-\nEnd of program reached!\n");
    printf("Press RETURN key to exit...\n");  
    getchar();    

    return 0;

}//main





VOID CleanUp(VOID)
{
    if (Window != NULL)
    {
        CloseWindow(Window);
        Window = NULL;
    }

    if (Screen != NULL)
    {
        CloseScreen(Screen);
        Screen = NULL;
    }

    if (Context != NULL)
    {
        C2P_DestroyContext(Context);
        Context = NULL;
    }

    if (C2PBase != NULL)
    {
        CloseLibrary(C2PBase);
        C2PBase = NULL;
    }

    if (IntuitionBase != NULL)
    {
        CloseLibrary(IntuitionBase);
        IntuitionBase = NULL;
    }

    if (GfxBase != NULL)
    {
        CloseLibrary(GfxBase);
        GfxBase = NULL;
    }

}//CleanUp





VOID FillChunkyData(UBYTE *chunky, ULONG displacement)
{
    UBYTE *row = chunky;

    for (ULONG y = 0; y < HEIGHT ; y++)
    {
        for (ULONG x = 0; x < WIDTH ; x++)
        {
            row[x] = (x + displacement) & 0xFF;
        }
        row += WIDTH;
    }
}//FillChunkyData





BOOL Initialize(VOID)
{
    BOOL result = FALSE;

    do
    {
        GfxBase = OpenLibrary("graphics.library", 39);
        if (GfxBase == NULL)
            break;
        printf("GfxBase: 0x%08x\n", GfxBase);

        IntuitionBase = OpenLibrary("intuition.library", 39);
        if (IntuitionBase == NULL)
            break;
        printf("IntuitionBase: 0x%08x\n", IntuitionBase);

        C2PBase = OpenLibrary("c2p.library", 0);
        if (C2PBase == NULL)
            break;
        printf("C2PBase: 0x%08x\n", C2PBase);

        Context = C2P_CreateContext();
        if (Context == NULL)
            break;
        printf("Context: 0x%08x\n", Context);

        // all done here
        result = TRUE;

    } while (FALSE);

    return result;

}//Initialize





VOID SetPalette(struct ViewPort *vp)
{
    // create a spectrum palette

    for (int i = 0; i < 32 ; i++)
    {
        int step = i * 8;
        SetRGB32(vp, i, step << 24, 0, 0);                          // red increase
        SetRGB32(vp, i + 32, 255 << 24, step << 24, 0);             // green increase
        SetRGB32(vp, i + 64, (255 - step) << 24, 255 << 24, 0);     // red decrease
        SetRGB32(vp, i + 96, 0, 255 << 24, step << 24);             // blue increase
        SetRGB32(vp, i + 128, 0, (255 - step) << 24, 255 << 24);    // green decrease
        SetRGB32(vp, i + 160, step << 24, 0, 255 << 24);            // red increase
        SetRGB32(vp, i + 192, 255 << 24, step << 24, 255 << 24);    // green increase
        SetRGB32(vp, i + 224, (255 - step) << 24, (255 - step) << 24, (255 - step) << 24);  // white decrease
    }

}//SetPalette

