
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

ULONG ErrorCode;





VOID CleanUp(VOID);
BOOL Initialize(VOID);
VOID SetPalette(struct ViewPort *vp);





int main()
{
    struct Screen *scr;
    struct Window *win;
    struct IntuiMessage *msg, local_msg;
    BOOL done = FALSE;

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

    Context = C2P_CreateContext();
    if (Context == NULL)
    {
        printf("Cannot create Context :-(\n");
        CleanUp();
        return -2;
    }
    printf("Context: 0x%08x\n", Context);

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
    BOOL force_scrambled = (BOOL) C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED);
    printf("Force use of scrambled buffer: %d\n", force_scrambled);

    ULONG scrambled_offsets_count = (ULONG) C2P_GetContextParameter(Context, C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSETS_COUNT);
    printf("Scrambled offsets count: %d\n", scrambled_offsets_count);
    printf("Scrambled offsets: ");
    for (int i = 0; i < scrambled_offsets_count; i++)
    {
        LONG offset = (LONG) C2P_GetContextIndexedParameter(Context, C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSET, i);
        printf("(%d:%d) ", i, offset);
    }
    printf("\n");

    scr = OpenScreenTags(NULL,
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
    printf("Screen address: 0x%08x\n", scr);
    printf("Error code: 0x%08x\n", ErrorCode);
    if (scr != NULL)
    {
        win = OpenWindowTags(NULL,
                            WA_IDCMP,           IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY,
                            WA_Top,             0,
                            WA_Left,            0,
                            WA_Width,           WIDTH,
                            WA_Height,          HEIGHT,
                            WA_CustomScreen,    scr,
                            WA_Backdrop,        TRUE,
                            WA_Borderless,      TRUE,
                            WA_Flags,           WFLG_RMBTRAP,
                            TAG_END);
        if (win != NULL)
        {
            SetPalette(&scr->ViewPort);

            ScreenToFront(scr);
            ActivateWindow(win);

            // mark screen margins
            C2P_WritePixel(Context, 0, 0, 1);
            C2P_WritePixel(Context, WIDTH - 1, 0, 1);
            C2P_WritePixel(Context, 0, HEIGHT - 1, 1);
            C2P_WritePixel(Context, WIDTH - 1, HEIGHT - 1, 1);

            for (ULONG i = 0; i < WIDTH ; i++)
            {
                C2P_WritePixel(Context, i, i >> 1, i);
                WaitTOF();
                C2P_Chunky2Planar(Context);
            }

            // UBYTE bt = b->Planes[0][0];
            // printf("Bpl #0 debug: 0x%02x\n", bt);

            done = TRUE;

            while(!done)
            {
                WaitPort(win->UserPort);
                while((msg = (struct IntuiMessage *)GetMsg(win -> UserPort)))
                {
                    CopyMem(msg, &local_msg, sizeof(struct IntuiMessage));
                    ReplyMsg((struct Message *)msg);

                    switch(msg->Class)
                    {
                        case IDCMP_VANILLAKEY:
                            printf("Got message: IDCMP_VANILLAKEY");
                            done = TRUE;
                            break;

                        case IDCMP_CLOSEWINDOW:
                            printf("Got message: IDCMP_CLOSEWINDOW");
                            done = TRUE; 
                            break;                 
                    }
                }
            }

            CloseWindow(win);
        }
        CloseScreen(scr);
    }
    C2P_DestroyContext(Context);

    CleanUp();

    printf("\n-\nEnd of program reached!\n");
    printf("Press RETURN key to exit...\n");  
    getchar();    

    return 0;

}//main





VOID CleanUp(VOID)
{
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

