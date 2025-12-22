/*-------------------------------------------------
  Name: GLArea.h
  Author: BODMER Stephan [sbodmer@lsi-media.ch]
  Note: MUI Custom class GLArea
	StromMesa version
	EGCS port
	defines and declaration/prototype only
---------------------------------------------------*/
// #include <GL/Amigamesa.h>

#ifndef GLAREA_H
#define GLAREA_H

#define SUBTASKNAME "GLArea_RenderTask"
// #define RENDERPORT  "GLArea_RenderPort"
// #define GLAREAPORT  "GLArea_Port"

// Render command
#define GLAREA_NOTHING      0
#define GLAREA_SHOWME      10
#define HIDEME             11
#define DRAWME             12
#define KILLME             13
#define INITME             14
#define SWAPME             15
#define GLAREA_DRAWTHIS    16
#define RESETME            17
#define GLAREA_MOUSEDOWN   18
#define GLAREA_MOUSEUP     19
#define GLAREA_MOUSEMOVE   20
#define GLAREA_DRAWIMAGE   21
#define GLAREA_INITTEXTURE 22

// Result code
#define GLAREA_OK          10
#define GLAREA_ERROR       11

//--- StormMesa libraries init structure ---
struct glreg
{
    int size;
    void (*func_exit)(int);
};
struct glureg
{
    int size;
    struct Library* glbase;
};
struct glutreg
{
    int size;
    void (*func_exit)(int);
    struct Library* glbase;
    struct Library* glubase;
};

//--- DrawThis function
struct MUIP_GLArea_DrawThisFunc {
    ULONG MethodID;
    PF drawthisfunc;
};

//--- DrawImage
struct MUIP_GLArea_DrawImage {
    ULONG MethodID;
    struct GLImage *source;
};

//--- List of tasks accessing the same library ---
struct GLArea_MUI_ListEntry {
    struct MinNode node;
    struct Task *task;
    int muinum;
    int retsignal;
    ULONG sigmask;
    // APTR app;
    //--- Single task libraries base, always opened ---
    struct Library *gl_Base;
    struct Library *glu_Base;
    struct Library *glut_Base;
};

struct Data {
   //--- Message ---
   int command;
   int result;
   ULONG data;

   //--- Debug ---
   BPTR fh;

   //--- Subtask stuff ---
   struct Process *thread;
   struct Task *maintask;

   //--- Context ---
   struct GLContext glcontext;
   struct GLArea_MUI_ListEntry *sharedlist;

   //--- Other stuff ---
   struct List bitmaplist;
   int numbitmap;
   struct List imagelist;
   int numimage;
   struct List texturelist;
   int numtexture;

   //--- MUI stuff ---
   struct MUI_EventHandlerNode ehnode;

   //--- Functions ---
   PF drawfunc;
   PF drawfunc2; // Alternate drawfunc
   PF drawpostfunc;
   PF resetfunc;
   PF initfunc;
   PFD mousedownfunc;
   PFD mousemovefunc;
   PFD mouseupfunc;

   //--- GLArea Class attributs
   BOOL Buffered;
   BOOL FullScreen;
   BOOL Threaded;
   BOOL SingleTask;
   int Status;
   int msgheight;

   int MinWidth;
   int MaxWidth;
   int DefWidth;
   int MinHeight;
   int MaxHeight;
   int DefHeight;

   //--- Mouse event ---
   int x;
   int y;
   int dx;
   int dy;
   int down;
};
#endif
