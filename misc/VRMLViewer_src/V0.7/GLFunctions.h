/*----------------------------------------------------
  GLFunctions.h (VRMLViewer)
  Version 0.3
  Date: 30.9.98
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note:
-----------------------------------------------------*/
#include "VRMLNode.h"

#include <GL/Amigamesa.h>

typedef struct {
	double X;
	double Y;
	double Z;
	double heading;
	double pitch;
} GLCamera;

// Protos
void glCamera();
void DrawMode();

int DrawScene(struct GLContext *glcontext);
int DrawBoxScene(struct GLContext *glcontext);
int Reset(struct GLContext *glcontext);
int Init(struct GLContext *glcontext);
void MouseDown(int,int,struct GLContext *glcontext);
void MouseMove(int,int,struct GLContext *glcontext);
void MouseUp(int,int,struct GLContext *glcontext);

void CameraAnim (GLCamera,GLCamera,int,struct GLContext *glcontext);
GLCamera InitCamera(VRMLCameras *,struct GLContext *glcontext);
void InitProjection (VRMLCameras *,struct GLContext *glcontext);
int MoveCamera(struct GLContext *glcontext);
