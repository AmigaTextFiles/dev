#ifndef __RTGGADTOOLS_H
#define __RTGGADTOOLS_H

struct RGGadget {
    struct RGGadget *Next;          /* Link Field */
    UWORD LeftEdge, TopEdge;        /* Left/TopEdge of gadget hit box */
    UWORD Width, Height;            /* Dimensions of hit box */
    ULONG Flags;                    /* Flags. See below */
    UWORD Key;                      /* Currently not in use */
    APTR GadgetRender;              /* The Object to render for the gadget */
    APTR SelectRender;              /* SelectRender Object */
    ULONG TextPen;                  /* Pen to render in */
    ULONG HiPen;
    ULONG LoPen;                    /* Pens for frames */
    APTR HitTest;                   /* Non-Null means custom hit handler */
    APTR DownAction;                /* Callback for gadget press */
    APTR UpAction;                  /* Callback for gadget release */
    ULONG BackGnd, Hilite;
    APTR UserData;                  /* UserData field for your own purpose */
};

typedef struct RGGadget *RGGadget;

#define RGF_UpAction            (1L<<0)
#define RGF_DownAction          (1L<<1)
#define RGF_TextGadget          (1L<<2)
#define RGF_ImageGadget         (1L<<3)
#define RGF_Selected            (1L<<4)
#define RGF_Disabled            (1L<<5)
#define RGF_ToggleSelect        (1L<<6)

/* TagItem Defines */
#define RGG_BASE                TAG_USER
#define RGG_RenderText          RGG_BASE+1
#define RGG_ActiveKey           RGG_BASE+2
#define RGG_SelectRender        RGG_BASE+3
#define RGG_UpAction            RGG_BASE+5
#define RGG_DownAction          RGG_BASE+6
#define RGG_LeftEdge            RGG_BASE+7
#define RGG_TopEdge             RGG_BASE+8
#define RGG_Width               RGG_BASE+9
#define RGG_Height              RGG_BASE+10
#define RGG_RenderHook          RGG_BASE+11
#define RGG_HitTest             RGG_BASE+13
#define RGG_UserData            RGG_BASE+14
#define RGG_Flags               RGG_BASE+15
#define RGG_HiPen               RGG_BASE+16
#define RGG_LoPen               RGG_BASE+17
#define RGG_TextPen             RGG_BASE+18
#define RGG_ControlKey          RGG_BASE+19
#define RGG_BackColor           RGG_BASE+20
#define RGG_HiliteColor         RGG_BASE+21
#define RGG_RenderImage         RGG_BASE+22

struct RGAnchor {
    APTR RtgScreen;
    RGGadget first;
    BOOL DirectColor;
    APTR Buffer[3];
    ULONG NumBuffers;
};

#define RGS_Disable     0L
#define RGS_Enable      1L
#define RGS_Toggle      2L

#endif
