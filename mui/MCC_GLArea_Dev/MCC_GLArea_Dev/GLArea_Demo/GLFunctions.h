/*----------------------------------------------------
  GLFunctions.h (GLArea_Demo)
  Version 1.1
  Date: 24/7/1999
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note:
-----------------------------------------------------*/

#include <mui/GLArea_mcc.h>
#include <mui/ImageDB_mcc.h>

//--- Prototypes ---
int Init(struct GLContext *glcontext);
int DrawBackgroundStamp(struct GLContext *glcontext);
int DrawGroundStamp(struct GLContext *glcontext);
int DrawObjectStamp(struct GLContext *glcontext);
int DrawSimpleAnimation(struct GLContext *glcontext);
int DrawLongRendering(struct GLContext *glcontext);
int DrawLongRenderingText(struct GLContext *glcontext);
int DrawMouseMove(struct GLContext *glcontext);
// int DrawObject(struct GLContext *glcontext);
int DrawSinglePawn(struct GLContext *glcontext);
void DrawMouseDown(int x, int y,struct GLContext *glcontext);
void DrawMouseM(int dx, int dy,struct GLContext *glcontext);
void DrawMouseUp(int x, int y,struct GLContext *glcontext);
