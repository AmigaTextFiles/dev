/*----------------------------------------------------
  GLFunction.cc (VRMLViewer)
  Version 0.4
  Date: 30 september 1998
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: Contains all OpenGL related functions
	GCC/StormC Port
-----------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <proto/alib.h>

#include <mui/GLArea_mcc.h>

#include <GL/Amigamesa.h>

#include "Main.h"
#include "VRMLNode.h"
#include "GLNode.h"
#include "GLFunctions.h"

#include "MUI_VRMLViewer.h"

// extern functions
extern void RefreshCoord();

// extern Main variable
extern int pm;
extern int pr;
extern int pp;
extern BOOL anim;
extern PList<VRMLCameras> *camlist;
extern GLNode *glnode;
extern Prefs settings;
extern struct ObjApp *MyApp;

// Globale GLState variable
double angleX=0,angleY=0,oldangleX=0,oldangleY=0;
GLCamera mycamera={0,0,40,0,0},oldcamera={0,0,40,0,0};

//----------------------------------- OpenGL additionnal special effects ---------------
void DrawBackground() {
    struct Library *glBase;
    struct Library *gluBase;
    struct Library *glutBase;
    GLubyte backImage[64][64][3];
    int i,j,c;

    for (i=0;i<64;i++) {
	for (j=0;j<64;j++) {
	    c= ((((i&0x8)==0)^((j&0x8))==0))*255;
	    backImage[i][j][0]=c;
	    backImage[i][j][0]=c;
	    backImage[i][j][0]=c;
	};
    };
    /*
    glmatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0.0,(GLfloat) 64, 0.0, (GLfloat) 64);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    */
    glRasterPos2i(0,0);
    glDrawPixels(64,64,GL_RGB,GL_UNSIGNED_BYTE, backImage);
}

//------------------------------------OpenGL RELATED DRAWING FUNCTION-------------------------
void glCamera(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    glLoadIdentity();
    glRotated(-mycamera.pitch,1,0,0);
    glRotated(-mycamera.heading,0,1,0);
    glTranslated(-mycamera.X,-mycamera.Y,-mycamera.Z);
}

void DrawMode(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    switch (pp) {
	case SMOOTH:
	    glEnable(GL_DEPTH_TEST);
	    glEnable(GL_LIGHTING);
	    glDisable(GL_BLEND);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glDisable(GL_TEXTURE_2D);
	    break;
	case FLAT:
	    glEnable(GL_DEPTH_TEST);
	    glEnable(GL_LIGHTING);
	    glDisable(GL_BLEND);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_FLAT);
	    glDisable(GL_TEXTURE_2D);
	    break;
	case WIRE:
	    glEnable(GL_DEPTH_TEST);
	    glEnable(GL_LIGHTING);
	    glDisable(GL_BLEND);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
	    glShadeModel(GL_FLAT);
	    glDisable(GL_TEXTURE_2D);
	    break;
	case POINTS:
	    glEnable(GL_DEPTH_TEST);
	    glDisable(GL_LIGHTING);
	    glDisable(GL_BLEND);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_POINT);
	    glShadeModel(GL_FLAT);
	    glDisable(GL_TEXTURE_2D);
	    break;
	case WIREFRAME:
	    glDisable(GL_DEPTH_TEST);
	    glDisable(GL_LIGHTING);
	    glDisable(GL_BLEND);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
	    glDisable(GL_TEXTURE_2D);
	    break;
	case BOUNDINGBOX:
	    glEnable(GL_DEPTH_TEST);
	    glDisable(GL_LIGHTING);
	    glDisable(GL_BLEND);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_FLAT);
	    glDisable(GL_TEXTURE_2D);
	    break;
	case TRANSPARENT:
	    glEnable(GL_DEPTH_TEST);
	    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	    glEnable(GL_BLEND);
	    glEnable(GL_LIGHTING);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glDisable(GL_TEXTURE_2D);
	    break;
	case TEXTURED:
	    glEnable(GL_DEPTH_TEST);
	    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	    glDisable(GL_BLEND);
	    glEnable(GL_LIGHTING);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glEnable(GL_TEXTURE_2D);
	    // glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
	    // FPrintf(glcontext->fh,"drawmode textured init\n");
	    break;
    };
}

// subtask for the AR_CyberGLArea
int DrawScene(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int rep=0;
    // puts("In drawscene");
    glClearColor(settings.brgb[0],settings.brgb[1],settings.brgb[2],1.0);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // DrawBackground();
    glCamera(glcontext);
    glRotated(angleY, -1.0, 0.0, 0.0);
    glRotated(angleX, 0.0, -1.0, 0.0);
    
    DrawMode(glcontext);
    glPushMatrix ();
    // puts("before gl->DrawGL");
    if (glnode) {
	// puts("glnode not NULL");
	if (pp==BOUNDINGBOX) {glnode->DrawGLBox(glcontext);}
	else {rep=glnode->DrawGL(glcontext);};
    };
    // puts("after the glnode->DrawGL");
    glPopMatrix();
    glFlush();
    return rep;
}

int DrawBoxScene(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glDisable(GL_LIGHTING);
    glClearColor(settings.brgb[0],settings.brgb[1],settings.brgb[2],1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glCamera(glcontext);
    glEnable (GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT_AND_BACK,GL_DIFFUSE);
    glNormal3d(0.0,0.0,1.0);
    glColor3d(1.0,1.0,1.0);
    glRotated (angleY, -1.0, 0.0, 0.0);
    glRotated (angleX, 0.0, -1.0, 0.0);
    glPushMatrix();
    if (glnode) {
	// puts("not NULL");
	glnode->DrawGLBox(glcontext);
    };
    glPopMatrix();
    glDisable (GL_COLOR_MATERIAL);
    glEnable(GL_LIGHTING);
    glFlush();
    return 0;
}

int Reset(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    angleX=0;angleY=0;
    oldangleX=0;oldangleY=0;
    mycamera.X=0;
    mycamera.Y=0;
    mycamera.Z=40;
    mycamera.heading=0;
    mycamera.pitch=0;
    oldcamera=mycamera;
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    gluPerspective (40.0,1.333,0.1,6000.0);
    glMatrixMode (GL_MODELVIEW);
    glCamera(glcontext);
    return 0;
}

int Init(struct GLContext *glcontext) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;
   GLfloat lightDirection[4]={5.0,5.0,5.0,1.0};
   GLfloat diffuseColor[4]={1.0,1.0,1.0,1.0};
   GLfloat ambientColor[4]={0.2,0.2,0.2,1.0};
   glLightModeli (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
   // glLightModeli (GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
   glEnable (GL_DEPTH_TEST);
   glEnable (GL_LIGHTING);
   glDisable (GL_BLEND);
   // glEnable(GL_DITHER);
   glLightfv (GL_LIGHT0,GL_AMBIENT,ambientColor);
   glLightfv (GL_LIGHT0,GL_DIFFUSE,diffuseColor);
   glLightfv (GL_LIGHT0,GL_POSITION,lightDirection);
   glEnable (GL_LIGHT0);
   glFrontFace(GL_CCW);
   glDisable(GL_CULL_FACE);
   glDisable(GL_LIGHT1);
   glDisable(GL_LIGHT2);
   glDisable(GL_LIGHT3);
   glDisable(GL_LIGHT4);
   glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
   DrawMode(glcontext);
   glEnable (GL_NORMALIZE);
   glClearColor(settings.brgb[0],settings.brgb[1],settings.brgb[2],1.0);
   // glClearColor(0,0,0,0);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   glMatrixMode (GL_PROJECTION);
   glLoadIdentity();
   gluPerspective (40.0,1.333,0.1,6000.0);
   glMatrixMode (GL_MODELVIEW);
   glLoadIdentity();
   glFlush();
   return 0;
}

void MouseDown(int x, int y, struct GLContext *glcontext) {
    oldcamera=mycamera;
}

void MouseMove(int dx, int dy, struct GLContext *glcontext) {
    double alpha,alpha2,beta,beta2,radh,radh2,radp,radp2,sx,sy;
    // puts("Mousemove");
    switch (pm) {
	case ROTATE:
	    angleX=oldangleX+(double) dx;
	    angleY=oldangleY+(double) dy;
	    break;
	case SLIDE:
	    alpha=90-mycamera.heading;
	    alpha2=alpha+90;
	    // beta=90-mycamera.pitch;
	    radh=(3.1415*alpha)/180.0;
	    radh2=(3.1415*alpha2)/180.0;
	    sx=-dx/3.0;
	    sy=-dy/3.0;
	    // double radp=(3.1415*beta)/180.0;
	    mycamera.X=(oldcamera.X+sy*cos(radh)); //+(oldcamera.X+sx*cos(radh2));
	    mycamera.Z=(oldcamera.Z+sy*sin(radh)); // +(oldcamera.Z+sy*sin(radh2));
	    mycamera.X+=sx*cos(radh2);
	    mycamera.Z+=sx*sin(radh2);
	    break;
	case TURN:
	    mycamera.heading=oldcamera.heading+dx;
	    mycamera.pitch=oldcamera.pitch+dy;
	    break;
	case FLY:
	    mycamera.Y=oldcamera.Y+dy/3.0;
	    mycamera.X=oldcamera.X+dx/3.0;
	    break;
    };
    // RefreshCoord();
    if (pr==BOX) {DrawBoxScene(glcontext);}
    else {DrawScene(glcontext);};
}

void MouseUp(int x,int y, struct GLContext *glcontext) {
    // puts("MouseUp");
    oldangleX=angleX;oldangleY=angleY;
    oldcamera=mycamera;
    RefreshCoord();
    // DrawScene(glcontext);
    // DoMethod((Object *) MyApp->AR_CyberGLArea, MCCM_GLArea_Redraw);
    // RefreshCoord()
}

/*
void CameraAnim (GLCamera sc, GLCamera dc, int step) {
    double dx,dy,dz,dh,dp;

    dx=(dc.X-sc.X)/step;
    dy=(dc.Y-sc.Y)/step;
    dz=(dc.Z-sc.Z)/step;
    dh=(dc.heading-sc.heading)/step;
    dp=(dc.pitch-sc.pitch)/step;
    // printf("d:%f %f %f dh:%f dp:%f\n",dx,dy,dz,dh,dp);
    // printf("dp:%f\n",dp);
    for (int i=0;i<step;i++) {
	mycamera.X=sc.X+(dx*i);
	mycamera.Y=sc.Y+(dy*i);
	mycamera.Z=sc.Z+(dz*i);
	mycamera.heading=sc.heading+(dh*i);
	mycamera.pitch=sc.pitch+(dp*i);
	// printf("New cord:%f %f %f h:%f p:%f\n",mycamera.X,mycamera.Y,mycamera.Z,mycamera.heading, mycamera.pitch);
	if (pr==BOX) {DrawBoxScene(NULL);}
	else {DrawScene(NULL);};
	DoMethod((Object *) MyApp->AR_CyberGLArea, MCCM_GLArea_Swap);
    };
}
*/
GLCamera InitCamera(VRMLCameras *cam, struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    GLCamera destcamera;
    double MTC[16];
    double nx,ny,nz;
    double x=0,y=0,z=1;

    destcamera.X=cam->position.coord[0];
    destcamera.Y=cam->position.coord[1];
    destcamera.Z=cam->position.coord[2];
    // printf("Get camera[%d] position:%f %f %f \n",
    //(int) store,cam->position.coord[0],cam->position.coord[1],cam->position.coord[2]);
    // printf("Get destcamera position X:%f\n",destcamera.X,destcamera.Y,destcamera.Z);
    angleX=0;oldangleX=0;
    angleY=0;oldangleY=0;
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glRotatef(cam->orientation.coord[3]/0.017447,cam->orientation.coord[0],
	      cam->orientation.coord[1],cam->orientation.coord[2]);
    // puts("bouh");
    glGetDoublev(GL_MODELVIEW_MATRIX,MTC);
    // PrintMTC();
    nx=MTC[0]*x+MTC[1]*y+MTC[2]*z+MTC[3];
    ny=MTC[4]*x+MTC[5]*y+MTC[6]*z+MTC[7];
    nz=MTC[8]*x+MTC[9]*y+MTC[10]*z+MTC[11];
    destcamera.heading=acos(nx)/0.017447;
    destcamera.pitch=asin(ny)/0.017447;
    destcamera.heading-=90.0;
    return destcamera;
    // printf("destiation HEADING:%f PITCH:%f\n ",destcamera.heading,destcamera.pitch);
}

void InitProjection(VRMLCameras *cam,struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    switch (cam->ID) {
	case ORTHOGRAPHICCAMERA_1:{
		    OrthographicCamera *oc=(OrthographicCamera *) cam;
		    // glOrtho (-oc->height,oc->height,-oc->height,oc->height,0.1,6000.0);
		    break;
		};
	case PERSPECTIVECAMERA_1:{
		    PerspectiveCamera *pc=(PerspectiveCamera *) cam;
		    gluPerspective(pc->height*180.0/3.1415,1.333,0.1,6000.0);
		    break;
		};
    };
    glMatrixMode (GL_MODELVIEW);
}

int MoveCamera(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    double dx,dy,dz,dh,dp,step=10;
    int breaked=0;
    GLCamera sc=mycamera,dc;
    ULONG store=0;

    // puts("MoveCamera\n");
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_Cameras, &store);
    dc=InitCamera(camlist->Get(store),glcontext);
    if (anim) {
	// CameraAnim(source,dest,10);
	dx=(dc.X-sc.X)/step;
	dy=(dc.Y-sc.Y)/step;
	dz=(dc.Z-sc.Z)/step;
	dh=(dc.heading-sc.heading)/step;
	dp=(dc.pitch-sc.pitch)/step;
	// printf("d:%f %f %f dh:%f dp:%f\n",dx,dy,dz,dh,dp);
	// printf("dp:%f\n",dp);
	for (int i=0;i<step;i++) {
	    mycamera.X=sc.X+(dx*i);
	    mycamera.Y=sc.Y+(dy*i);
	    mycamera.Z=sc.Z+(dz*i);
	    mycamera.heading=sc.heading+(dh*i);
	    mycamera.pitch=sc.pitch+(dp*i);
	    // printf("New cord:%f %f %f h:%f p:%f\n",mycamera.X,mycamera.Y,mycamera.Z,mycamera.heading, mycamera.pitch);
	    if (pr==BOX) {
		DrawBoxScene(glcontext);
	    }
	    else {
		breaked=DrawScene(glcontext);
	    };
	    if (breaked) {
		// printf("Move camera breaked\n");
		return 1;
	    };
	    // printf("db_flag:%d\n",context->visual->db_flag);
	    if (glcontext->context->visual->db_flag) {
		AmigaMesaSwapBuffers(glcontext->context);
	    };
	    // DoMethod((Object *) MyApp->AR_CyberGLArea, MCCM_GLArea_Swap);
	};
    }
    else {
	// puts("Not animated")
    };
    mycamera=dc;
    // printf("Drawing last scene\n");
    return DrawScene(glcontext);
}
