/*----------------------------------------------------
  GLFunctions.h (VRMLViewer)
  Version 0.3
  Date: 30.9.98
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note:
-----------------------------------------------------*/
#ifndef VRMLEDITOR_GLFUNCTIONS_H
#define VRMLEDITOR_GLFUNCTIONS_H


#include <mui/GLArea_mcc.h>

// #include <GL/Amigamesa.h>

#include "VRMLNode.h"

// #include "StormMesaSupport.h"

typedef struct {
	double X;
	double Y;
	double Z;
	double heading;
	double pitch;
} GLCamera;

// Protos
void glCamera(struct GLContext *glcontext);
void DrawMode(struct GLContext *glcontext);
int DrawScene(struct GLContext *glcontext);
int DrawBoxScene(struct GLContext *glcontext);
int Reset(struct GLContext *glcontext);
int Init(struct GLContext *glcontext);
void MouseDown(int,int, struct GLContext *glcontext);
void MouseMove(int,int, struct GLContext *glcontext);
void MouseUp(int,int, struct GLContext *glcontext);
// void CameraAnim (GLCamera,GLCamera, int);
GLCamera InitCamera(VRMLCameras *, struct GLContext *glcontext);
// void InitProjection (VRMLCameras *);
void MouseDownTexture(int,int, struct GLContext *glcontext);

int DrawAboutScene(struct GLContext *glcontext);
int DrawMainLogoScene(struct GLContext *glcontext);
int DrawMaterialPreviewScene(struct GLContext *glcontext);
int DrawTexturePreview(struct GLContext *glcontext);
int DrawTextureAnim(struct GLContext *glcontext);

#ifdef __cplusplus
extern "C" {
#endif
void InitMatPreviewBackdrop();
void DrawBackground(struct GLContext *glcontext);
void DrawMainLogoBackground(struct GLContext *glcontext);
void DrawAxis(struct GLContext *glcontext);
#ifdef __cplusplus
}
#endif

#endif
