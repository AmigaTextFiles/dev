/*-------------------------------------------------
  Name: GLArea_mcc.h
  Version: 0.9
  Date: 26.12.2000
  Author: Bodmer Stephan [sbodmer@lsi-media.ch]
  Note: MUI Custom class GLArea
	EGCS port
---------------------------------------------------*/
#ifndef MUI_GLArea_MCC_H
#define MUI_GLArea_MCC_H

#include <GL/Amigamesa.h>

//--------------------------------------------------------
// This struct is always passed as argument to
// each GL function (DrawFunc,InitFunc,MouseUpFunc,etc...)
//--------------------------------------------------------
struct GLContext {
    //--- StormMesa context ---
    AmigaMesaContext context;
    struct Library *gl_Base;
    struct Library *glu_Base;
    struct Library *glut_Base;
    
    //--- Debug output file handle ---
    // If you use the GLArea_debug.mcc, fh is not NULL and you
    // could FPrintf(fh,"..") some information
    ULONG fh;

    //--- Corresponding GLArea object and app ---
    // You could use MUI macro _app to find the application too
    APTR glarea;
    APTR app;

    //--- For futur use
    APTR spare;
};

//--- Macros ---
#define MUIC_GLArea "GLArea.mcc"
#define GLAreaObject MUI_NewObject(MUIC_GLArea

//--- GL function prototypes ---
typedef int (*PF) (struct GLContext *glcontext); // return 1 (TRUE), if stopped with sig SIGBREAKF_CTRL_D
typedef void (*PFD) (int, int, struct GLContext *glcontext);

//-------------------------------------------------------------------------
// Tag values
// First: 0x0001
// Last : 0x003B
//------------------------------------------------------------------------
#define MUI_SERIAL (0xfec4<<16)

#define MUIA_GLArea_MinWidth        (TAG_USER | MUI_SERIAL | 0x0001)
#define MUIA_GLArea_MaxWidth        (TAG_USER | MUI_SERIAL | 0x0002)
#define MUIA_GLArea_MinHeight       (TAG_USER | MUI_SERIAL | 0x0003)
#define MUIA_GLArea_MaxHeight       (TAG_USER | MUI_SERIAL | 0x0004)
#define MUIA_GLArea_DefWidth        (TAG_USER | MUI_SERIAL | 0x0005)
#define MUIA_GLArea_DefHeight       (TAG_USER | MUI_SERIAL | 0x0006)
#define MUIA_GLArea_Buffered        (TAG_USER | MUI_SERIAL | 0x0007)
#define MUIA_GLArea_DeltaX          (TAG_USER | MUI_SERIAL | 0x0008)
#define MUIA_GLArea_DeltaY          (TAG_USER | MUI_SERIAL | 0x0009)
#define MUIA_GLArea_Active          (TAG_USER | MUI_SERIAL | 0x000a)
#define MUIA_GLArea_FullScreen      (TAG_USER | MUI_SERIAL | 0x000b)
#define MUIA_GLArea_Priority        (TAG_USER | MUI_SERIAL | 0x0039)
#define MUIA_GLArea_Threaded        (TAG_USER | MUI_SERIAL | 0x000c)
#define MUIA_GLArea_Status          (TAG_USER | MUI_SERIAL | 0x000d)
#define MUIA_GLArea_Context         (TAG_USER | MUI_SERIAL | 0x000e)
#define MUIA_GLArea_glBase          (TAG_USER | MUI_SERIAL | 0x000f)
#define MUIA_GLArea_gluBase         (TAG_USER | MUI_SERIAL | 0x0010)
#define MUIA_GLArea_glutBase        (TAG_USER | MUI_SERIAL | 0x0011)
#define MUIA_GLArea_SingleTask      (TAG_USER | MUI_SERIAL | 0x0012)
#define MUIA_GLArea_MsgHeight       (TAG_USER | MUI_SERIAL | 0x003B)

#define MUIA_GLArea_DrawFunc        (TAG_USER | MUI_SERIAL | 0x0013)
#define MUIA_GLArea_DrawFunc2       (TAG_USER | MUI_SERIAL | 0x0014)
#define MUIA_GLArea_DrawPostFunc    (TAG_USER | MUI_SERIAL | 0x0015)
#define MUIA_GLArea_ResetFunc       (TAG_USER | MUI_SERIAL | 0x0016)
#define MUIA_GLArea_InitFunc        (TAG_USER | MUI_SERIAL | 0x0017)
#define MUIA_GLArea_MouseDownFunc   (TAG_USER | MUI_SERIAL | 0x0018)
#define MUIA_GLArea_MouseMoveFunc   (TAG_USER | MUI_SERIAL | 0x0019)
#define MUIA_GLArea_MouseUpFunc     (TAG_USER | MUI_SERIAL | 0x001a)

#define MUIM_GLArea_Break           (TAG_USER | MUI_SERIAL | 0x0020)
#define MUIM_GLArea_DrawImage       (TAG_USER | MUI_SERIAL | 0x0034)
#define MUIM_GLArea_DrawThisFunc    (TAG_USER | MUI_SERIAL | 0x0024)
#define MUIM_GLArea_Init            (TAG_USER | MUI_SERIAL | 0x0028)
#define MUIM_GLArea_MakeCurrent     (TAG_USER | MUI_SERIAL | 0x002c)
#define MUIM_GLArea_Redraw          (TAG_USER | MUI_SERIAL | 0x002d)
#define MUIM_GLArea_Refresh         (TAG_USER | MUI_SERIAL | 0x002e)
#define MUIM_GLArea_Reset           (TAG_USER | MUI_SERIAL | 0x002f)
#define MUIM_GLArea                 (TAG_USER | MUI_SERIAL | 0x0033)
#define MUIM_GLArea_Swap            (TAG_USER | MUI_SERIAL | 0x0031)

//--- Special values  ---
#define MUIV_GLArea_InitFunc_Standard -1

// Object status
#define MUIV_GLArea_Ready       100
#define MUIV_GLArea_Busy        110
#define MUIV_GLArea_NotActive   120

#endif
