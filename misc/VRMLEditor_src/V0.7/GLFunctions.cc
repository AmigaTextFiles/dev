/*----------------------------------------------------
  GLFunction.cc (VRMLVEditor)
  Version 0.3
  Date: 30 september 1998
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: Contains all OpenGL related functions
	GCC/StormC Port
-----------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <dos/dos.h>
#include <intuition/intuition.h>
#include <mui/Listtree_mcc.h>
#include <mui/GLArea_mcc.h>

#include <proto/dos.h>
#include <proto/alib.h>

#include "Main.h"
#include "VRMLNode.h"
#include "GLNode.h"
#include "GLFunctions.h"
#include "MUIWindows.h"
#include "App.h"

// #include "MCC_GLArea.h"
#include "GL_stubs.h"

#ifdef USE_CYBERGL
#define SHARED
#define GL_APICOMPATIBLE
#include <cybergl/cybergl.h>
#include <cybergl/display.h>
#include <proto/cybergl.h>
#else
#include <proto/Amigamesa.h>
#endif

// extern functions
extern void RefreshCoord();

// extern Main variable
extern struct Screen *RenderScreen;
extern int pm;
extern int pr;
extern int pp;
extern int pw;
extern int pt;
extern BOOL axis;
extern SharedVariables sh;
extern int current;
// extern BOOL anim;
// extern PList<VRMLCameras> *camlist;
extern GLNode *glnode;
extern Prefs settings;
extern struct ObjApp *MyApp;
// extern MyMsg msg;

// extern objects
// extern LVObject *LVMain;
// extern LVObject *LVClip;
// extern VRMLState *st;
extern VRMLGroups *Main;
extern Group *Clip;
extern WIMaterial MaterialWin;
extern WITexture2 Texture2Win;

// Globale GLState variable
double angleX=0,angleY=0,oldangleX=0,oldangleY=0;
double aboutangle=0;
GLCamera mycamera={0,0,40,0,0},oldcamera={0,0,40,0,0};

//------------------------------------OPENGL RELATED DRAWING FUNCTION-------------------------
/*
void DrawAxis(struct GLContext *glcontext) {
    struct Library *glBase=glcontext.gl_Base;
    struct Library *gluBase=glcontext.glu_Base;
    struct Library *glutBase=glcontext.glut_Base;

    // puts("==>DrawAxis");
    glDisable(GL_LIGHTING);
    glEnable (GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT_AND_BACK,GL_DIFFUSE);
    glNormal3d(0.0,0.0,1.0);
    glColor3d(1.0,1.0,1.0);
    glBegin(GL_LINES);
	glVertex3d(0,0,0);
	glVertex3d(100,0,0);
    glEnd();
    glBegin(GL_LINES);
	glVertex3d(0,0,0);
	glVertex3d(0,100,0);
    glEnd();
    glBegin(GL_LINES);
	glVertex3d(0,0,0);
	glVertex3d(0,0,100);
    glEnd();
    glDisable(GL_COLOR_MATERIAL);
    glEnable(GL_LIGHTING);
    // puts("<==DrawAxis");
}
*/
void glCamera(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glLoadIdentity();
    glRotatef(-mycamera.pitch,1,0,0);
    glRotatef(-mycamera.heading,0,1,0);
    glTranslatef(-mycamera.X,-mycamera.Y,-mycamera.Z);
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
	    // glDisable(GL_BLEND);
	    glEnable(GL_BLEND);
	    glEnable(GL_LIGHTING);
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glEnable(GL_TEXTURE_2D);
	    // glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
	    puts("drawmode textured init");
	    break;
    };
}

//--- subtask for the AR_CyberGLArea and main draw routine ---
int DrawScene(struct GLContext *glcontext) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;
   ULONG store=0;
   int breaked=0;
   VRMLNode *node1=NULL,*node2=NULL;
   struct MUIS_Listtree_TreeNode *tn=NULL,*ptn=NULL;
   VRMLState st=VRMLState();
   st.gauge=TRUE;

   puts("=>DRAWSCENE");
   // GetAttr(MCCA_GLArea_Active, (Object *) MyApp->AR_CyberGLArea, &store);

   // if ((BOOL) store ||
   //     RenderScreen) {
	// puts("In DrawScene");
	// sh.rendering=DRAWING;

	//--- Init state object
	st.glcontext=glcontext;
	st.coneres=settings.coneres;
	st.cylinderres=settings.cylinderres;
	st.sphereres=settings.sphereres;
	// printf("Total nodes to draw:%d\n",msg.totalnodes);
	// printf("Total polygones to draw (approx):%d\n",msg.totalpolygones);
	
	if ((pw==MAIN_WORLD)||
	    (pw==BOTH_WORLD)) {
	    if (pt==WHOLE_WORLD) {
		node1=(VRMLNode *)Main;
	    }
	    else if (pt==GROUP_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    ptn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Parent,0);
		    if (ptn) {
			node1=(VRMLNode *) ptn->tn_User;
		    }
		    else {
			node1=(VRMLNode *) tn->tn_User;
		    };
		};
	    }
	    else if (pt==NODE_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    node1=(VRMLNode *) tn->tn_User;
		};
	    };
	};
	// puts("first init passed");
	if ((pw==CLIP_WORLD)||
	    (pw==BOTH_WORLD)) {
	    if (pt==WHOLE_WORLD) {
		node2=(VRMLNode *)Clip;
	    }
	    else if (pt==GROUP_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    ptn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Parent,0);
		    if (ptn) {
			node2=(VRMLNode *) ptn->tn_User;
		    }
		    else {
			node2=(VRMLNode *) tn->tn_User;
		    };
		};
	    }
	    else if (pt==NODE_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    node2=(VRMLNode *) tn->tn_User;
		};
	    };
	};
	// puts("second init passed");
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	glCamera(glcontext);

	glRotatef (angleX, 0.0, -1.0, 0.0);
	glRotatef (angleY, -1.0, 0.0, 0.0);

	// glRotatef (angleY, cos((angleX*3.1415)/180), 0.0, sin((angleX*3.1415)/180));
	// printf("pos:%f %f %f\n",camera.eyex,camera.eyey,camera.eyez);
	// printf("center:%f %f %f\n",camera.centerx,camera.centery,camera.centerz);

	// glLookAt(&camera);
	if (axis) {DrawAxis(glcontext);};
	DrawMode(glcontext);
	glPushMatrix();
	// puts("gl command passed");
	if (node1) {
		node1->Browse(&st);
		// printf("polygones:%d\n",msg.totalpolygones);
		st.totalpolygones=st.totalpolygones;
		st.currentpolygone=0;
		st.totalnodes=st.totalnodes;
		// SetAttrs((Object *) MyApp->GA_CyberGLRendering, MUIA_Gauge_Current, 0);
		// SetAttrs((Object *) MyApp->GA_CyberGLRendering, MUIA_Gauge_Max, (ULONG) msg.totalpolygones);
		// SetAttrs((Object *) MyApp->AR_CyberGLArea, MCCA_GLArea_GaugeMax, msg.totalpolygones);
		// SetAttrs((Object *) MyApp->AR_CyberGLArea, MCCA_GLArea_GaugeLevel, 0);
		// puts("gl command passed");
		if (pp==BOUNDINGBOX) {
		    node1->DrawGLBox(glcontext);
		}
		else {
		    // puts("before first DrawGL");
		    breaked=node1->DrawGL(&st);
		    // puts("ok");
		    if (breaked) {
			glPopMatrix();
			return 1;
		    };
		    st.Clear();
		};
	    };
	glPopMatrix();
	puts("====>first world finished, go to second");
	glPushMatrix();
	    if (node2) {
		node2->Browse(&st);
		st.totalpolygones=st.totalpolygones;
		st.currentpolygone=0;
		st.totalnodes=st.totalnodes;
		// SetAttrs((Object *) MyApp->AR_CyberGLArea, MCCA_GLArea_GaugeMax, msg.totalpolygones);
		// SetAttrs((Object *) MyApp->AR_CyberGLArea, MCCA_GLArea_GaugeLevel, 0);
		if (pp==BOUNDINGBOX) {
		    node2->DrawGLBox(glcontext);
		}
		else {
		    breaked=node2->DrawGL(&st);
		    if (breaked) {
			glPopMatrix();
			return 1;
		    };
		};
	    };
	glPopMatrix();
	// glPopMatrix();
	// glFlush();
   // };
   puts("<=DRAWSCENE");
   // sh.rendering=IDLE;
   // RefreshCoord();
   // sh.mode=USER;
   return 0;
}

int DrawBoxScene(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    ULONG store;
    VRMLNode *node1=NULL,*node2=NULL;
    struct MUIS_Listtree_TreeNode *tn=NULL,*ptn=NULL;

    // if (sh.rendering==DRAWING) return 1;
    // puts("=>DRAW BOX SCENE");
    if ((pw==MAIN_WORLD)||
	(pw==BOTH_WORLD)) {
	    if (pt==WHOLE_WORLD) {
		node1=(VRMLNode *)Main;
	    }
	    else if (pt==GROUP_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    ptn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Parent,0);
		    if (ptn) {
			node1=(VRMLNode *) ptn->tn_User;
		    }
		    else {
			node1=(VRMLNode *) tn->tn_User;
		    };
		};
	    }
	    else if (pt==NODE_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    node1=(VRMLNode *) tn->tn_User;
		};
	    };
	};
	if ((pw==CLIP_WORLD)||
	    (pw==BOTH_WORLD)) {
	    if (pt==WHOLE_WORLD) {
		node2=(VRMLNode *)Clip;
	    }
	    else if (pt==GROUP_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    ptn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Parent,0);
		    if (ptn) {
			node2=(VRMLNode *) ptn->tn_User;
		    }
		    else {
			node2=(VRMLNode *) tn->tn_User;
		    };
		};
	    }
	    else if (pt==NODE_ONLY) {
		GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
		tn=(struct MUIS_Listtree_TreeNode *) store;
		if (tn) {
		    node2=(VRMLNode *) tn->tn_User;
		};
	    };
   };
   // GetAttr(MCCA_GLArea_Active, (Object *) MyApp->AR_CyberGLArea, &store);

   // if ((BOOL) store) {
   //     sh.rendering=DRAWING;
	glLoadIdentity();
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glCamera(glcontext);
	// glLookAt(&camera);

	glRotatef (angleX, 0.0, -1.0, 0.0);
	glRotatef (angleY, -1.0, 0.0, 0.0);

	glEnable (GL_COLOR_MATERIAL);
	glColorMaterial(GL_FRONT_AND_BACK,GL_DIFFUSE);
	glNormal3f(0.0,0.0,1.0);
	glColor3f(1.0,1.0,1.0);

	if (axis) {DrawAxis(glcontext);};
	glDisable(GL_LIGHTING);
	glPushMatrix ();
	    if (node1) {
		node1->DrawGLBox(glcontext);
	    };
	glPopMatrix();
	glPushMatrix();
	    if (node2) {
		node2->DrawGLBox(glcontext);
	    };
	glPopMatrix ();
	glDisable (GL_COLOR_MATERIAL);
	glEnable(GL_LIGHTING);
	glFlush();
    // };
    // puts("<=DRAW BOX SCENE");
    // sh.rendering=IDLE;
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
   // glEnable (GL_DEPTH_TEST);
   // glEnable (GL_LIGHTING);
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
   glDisable(GL_DITHER);

   // glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
   DrawMode(glcontext);
   glEnable (GL_NORMALIZE);
   glClearColor(settings.brgb[0],settings.brgb[1],settings.brgb[2],1.0);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   glMatrixMode (GL_PROJECTION);
   glLoadIdentity();
   gluPerspective (40.0,1.333,0.1,6000.0);
   glMatrixMode (GL_MODELVIEW);
   glLoadIdentity();
   // glFlush();
   return 0;
}

void MouseDown(int x, int y, struct GLContext *glcontext) {
    printf("Mousedown\n");
    oldcamera=mycamera;
}

void MouseMove(int dx, int dy, struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    double alpha,alpha2,beta,beta2,radh,radh2,radp,radp2,sx,sy;
    // printf("in mousemovefunc dx:%d dy:%d\n",dx,dy);
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
    // AmigaMesaSwapBuffers(context);
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

/*
void InitProjection(VRMLCameras *cam) {
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    switch (cam->type) {
	case OrthographicCameraID:{
		    OrthographicCamera *oc=(OrthographicCamera *) cam;
		    glOrtho ((double) -oc->height, (double) oc->height,-oc->height,oc->height,0.1,6000.0);
		    break;
		};
	case PerspectiveCameraID:{
		    PerspectiveCamera *pc=(PerspectiveCamera *) cam;
		    glPerspective(pc->height*180.0/3.1415,1.333,0.1,6000.0);
		    break;
		};
    };
    glMatrixMode (GL_MODELVIEW);
}
*/
//---------------------------------- MAIN WINDOW LOGO ANIMATION -----------------------------
int DrawMainLogoScene(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    GLfloat lightDirection[4]={5.0,5.0,5.0,1.0};
    GLfloat diffuseColor[4]={1.0,1.0,1.0,1.0};
    GLfloat ambientColor[4]={0.2,0.2,0.2,1.0};
    Color4f cdiffuse=Color4f(1,0,0,0.6);
    Color4f cambient=Color4f(0.2,0.2,0.2,0.6);
    Color4f cspecular=Color4f(1,1,1,0.6);
    Color4f cemissive=Color4f(0,0,0,0.6);
    Color4f codiffuse=Color4f(0,1,1,0.6);
    Color4f spdiffuse=Color4f(0,1,0,0.6);
    VRMLState state=VRMLState();
    Cube cube=Cube("MainCube");
    Cone cone=Cone("MainCone");
    Sphere sphere=Sphere("MainSphere");
    Material cubemat=Material("MainCubeMat");
    Material conemat=Material("MainConeMat");
    Material spheremat=Material("MainSphereMat");
    int cubeangle=0,coneangle=75,breaked=0;

    state.sphereres=12;
    state.coneres=8;
    state.glcontext=glcontext;
    cone.height=3;
    cone.bottomRadius=1.5;
    sphere.radius=1.5;
    cubemat.AddMaterial(new Mat(cambient,cdiffuse,cspecular,cemissive,0.1,0.4));
    conemat.AddMaterial(new Mat(cambient,codiffuse,cspecular,cemissive,0.1,0.4));
    spheremat.AddMaterial(new Mat(cambient,spdiffuse,cspecular,cemissive,0.1,0.4));

    glLightModeli (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
    glLightfv (GL_LIGHT0,GL_AMBIENT,ambientColor);
    glLightfv (GL_LIGHT0,GL_DIFFUSE,diffuseColor);
    glLightfv (GL_LIGHT0,GL_POSITION,lightDirection);
    glEnable (GL_LIGHT0);
    glEnable(GL_LIGHTING);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
    glShadeModel(GL_SMOOTH);
    glFrontFace(GL_CCW);
    glDisable(GL_CULL_FACE);
    glEnable (GL_NORMALIZE);
    // #include "VRMLEditor_Env.gl"
    /*
    glTexEnvi (GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
    glTexGeni_stub(glcontext,GL_S, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
    glTexGeni_stub(glcontext,GL_T, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
    glEnable(GL_TEXTURE_GEN_S);
    glEnable(GL_TEXTURE_GEN_T);
    glEnable(GL_TEXTURE_2D);
    */
    glClearColor(0.5,0.5,0.5,1.0);
    /*
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    DrawMainLogoBackground(glcontext);
    glEnable(GL_DEPTH_TEST);
    */
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    gluPerspective (40.0,1.333,0.1,6000.0);
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity();

    while(1) {
	cubeangle+=4;coneangle+=4;
	if (cubeangle>360) cubeangle-=360;
	if (coneangle>360) coneangle-=360;
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glDisable(GL_DEPTH_TEST);
	DrawMainLogoBackground(glcontext);
	glEnable(GL_DEPTH_TEST);
	glLoadIdentity();
	glTranslated(0.0,0.0,-25.0);
	glScaled(1.0,4.0,1.0);
	glPushMatrix();
	    glTranslatef(2,0,0);
	    glRotatef(45,0,0,1);
	    glRotatef(cubeangle,1.0,1.0,0);
	    state.m= &cubemat;
	    breaked=cube.DrawGL(&state);
	glPopMatrix();
	if (breaked) break;
	glPushMatrix();
	    glTranslatef(10,0.5,0);
	    glRotatef(45.0,0.0,0.0,1.0);
	    glRotatef(coneangle,1.0,1.0,0.0);
	    state.m= &conemat;
	    breaked=cone.DrawGL(&state);
	glPopMatrix();
	if (breaked) break;
	glPushMatrix();
	    glTranslatef(6,0,0);
	    state.m= &spheremat;
	    breaked=sphere.DrawGL(&state);
	glPopMatrix();
	// glFlush();
	// DoMethod((Object *) MyApp->AR_AboutGLArea, MCCM_GLArea_Swap);
	AmigaMesaSwapBuffers(glcontext->context);
	// if (CheckSignal(SIGBREAKF_CTRL_D)) break;
	if (breaked) break;
	// glFlush();
    };
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    DrawMainLogoBackground(glcontext);
    glEnable(GL_DEPTH_TEST);
    return 1;
}

/*----------------------------
  About window subtask
------------------------------*/
int DrawAboutScene(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    double aboutangle=0.0;
    ULONG store;
    GLfloat lightDirection[4]={5.0,5.0,5.0,1.0};
    GLfloat diffuseColor[4]={1.0,1.0,1.0,1.0};
    GLfloat ambientColor[4]={0.2,0.2,0.2,1.0};

    // puts("drawaboutscene");
    // GetAttr(MCCA_GLArea_Context, (Object *) MyApp->AR_AboutGLArea, &store);
    glLightModeli (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
    glLightfv (GL_LIGHT0,GL_AMBIENT,ambientColor);
    glLightfv (GL_LIGHT0,GL_DIFFUSE,diffuseColor);
    glLightfv (GL_LIGHT0,GL_POSITION,lightDirection);
    glEnable (GL_LIGHT0);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
    glShadeModel(GL_SMOOTH);
    glFrontFace(GL_CCW);
    glDisable(GL_CULL_FACE);
    glEnable (GL_NORMALIZE);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    gluPerspective (40.0,1.333,0.1,6000.0);
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity();
    // glFlush();

    while(1) {
	aboutangle+=2;
	if (aboutangle>360) aboutangle-=360;
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	glTranslated(0.0,0.0,-15.0);
	glScaled(1.0,2.0,1.0);
	glRotatef(aboutangle,0.0,1.0,0.0);

	#include "Logo.gl"
	// glFlush();
	// DoMethod((Object *) MyApp->AR_AboutGLArea, MCCM_GLArea_Swap);
	AmigaMesaSwapBuffers(glcontext->context);
	if (CheckSignal(SIGBREAKF_CTRL_D)) break;
	// glFlush();
    };
    return 1;
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
	if (pr==Box) {DrawBoxScene();}
	else {DrawScene();};
    };
}
*/
/*-------------------
  Material preview
--------------------*/
//-------------- Colored Checkboard bitmap -----------------
/*
void InitMatPreviewBackdrop() {
    int i,j,c;

    for (i=0;i<80;i++) {
	for (j=0;j<100;j++) {
	    c=((((i&0x8)==0)^((j&0x8))==0))*255;
	    checkImage[i][j][0]= (GLubyte) c;
	    checkImage[i][j][1]= (GLubyte) c;
	    checkImage[i][j][2]= (GLubyte) c;
	};
    };
}
*/
/*
void DrawBackground(struct GLContext *glcontext) {
    struct Library *glBase=glcontext.gl_Base;
    struct Library *gluBase=glcontext.glu_Base;
    struct Library *glutBase=glcontext.glut_Base;
    int origin[2]={0,0};

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    // gluOrtho2D(0.0,100.0,0,80);
    glOrtho(0,100,0,80,-10,10);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glRasterPos2iv(origin);
    // glPixelZoom(2,2);
    // puts("drawpixel");
    glDrawPixels(100,80,GL_RGB,GL_UNSIGNED_BYTE,checkImage);
}
*/
int DrawMaterialPreviewScene(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    GLfloat lightDirection[4]={5.0,5.0,10.0,1.0};
    GLfloat diffuseColor[4]={1.0,1.0,1.0,1.0};
    GLfloat ambientColor[4]={0.2,0.2,0.2,1.0};
    VRMLState state=VRMLState();
    Sphere preview=Sphere("Sample");
    Material currentmat=Material("SampleMat");

    currentmat.AddMaterial(new Mat(MaterialWin.GetCurrentMat()));
    state.sphereres=16;
    state.m= &currentmat;
    state.glcontext=glcontext;
    glLightModeli (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
    glLightfv (GL_LIGHT0,GL_AMBIENT,ambientColor);
    glLightfv (GL_LIGHT0,GL_DIFFUSE,diffuseColor);
    glLightfv (GL_LIGHT0,GL_POSITION,lightDirection);
    glEnable (GL_LIGHT0);
    glEnable(GL_LIGHTING);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
    glShadeModel(GL_SMOOTH);
    glFrontFace(GL_CCW);
    glDisable(GL_CULL_FACE);
    glEnable (GL_NORMALIZE);
    glClearColor(0.5,0.5,0.5,1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    DrawBackground(glcontext);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    gluPerspective_stub (glcontext,40.0,1.333,0.1,6000.0);
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0.0,0.0,-3.0);
    glEnable(GL_DEPTH_TEST);
    if (glcontext->fh) {
	FPrintf(glcontext->fh,"before the DrawGL\n");
    };
    return preview.DrawGL(&state);
}

int DrawTexturePreview(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    struct GLImage *preview=NULL;

    preview=(struct GLImage *) DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_GetImage, "Preview");

    glClearColor(0,0,0,1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    if (preview) {
	#ifdef DEBUG
	FPrintf("preview not NULL\n");
	#endif
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D_stub(glcontext,0.0,(GLfloat) preview->width,0.0, (GLfloat) preview->height);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glRasterPos2i(0,0);
	glDrawPixels(preview->width,preview->height,GL_RGB,GL_UNSIGNED_BYTE,preview->image);
    };
    if (CheckSignal(SIGBREAKF_CTRL_D)) return 1;
    return 0;
}

int DrawTextureAnim(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    struct GLTex *tex=NULL;
    double angle=0;
    Cube cube=Cube("TextureAnim");
    Material material=Material("white");
    VRMLState state=VRMLState();
    state.glcontext=glcontext;
    state.m= &material;
    material.AddMaterial(new Mat());

    tex=(struct GLTex *) DoMethod((Object *) MyApp->GLAR_Texture2Anim, MUIM_GLArea_GetTexture, "Sample");
    /*
    GLfloat lightDirection[4]={5.0,5.0,10.0,1.0};
    GLfloat diffuseColor[4]={1.0,1.0,1.0,1.0};
    GLfloat ambientColor[4]={0.2,0.2,0.2,1.0};

    // Texture2 *ctex=(Texture2 *) Texture2Win.Get();

    puts("in DrawTexture");
    glLightModeli (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
    glLightfv (GL_LIGHT0,GL_AMBIENT,ambientColor);
    glLightfv (GL_LIGHT0,GL_DIFFUSE,diffuseColor);
    glLightfv (GL_LIGHT0,GL_POSITION,lightDirection);
    glEnable (GL_LIGHT0);
    glEnable(GL_LIGHTING);
    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
    glShadeModel(GL_SMOOTH);
    glFrontFace(GL_CCW);
    glDisable(GL_CULL_FACE);
    glEnable (GL_NORMALIZE);
    glClearColor(0,0,0,1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity();
    gluPerspective (40.0,1.333,0.1,6000.0);
    */
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity();
    /*
    if (tex) {
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
	glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,tex->width,tex->height,0,GL_RGB,GL_UNSIGNED_BYTE,tex->image);
	glEnable(GL_TEXTURE_2D);
    };
    */
    while(1) {
	    angle+=2;
	    if (angle>360) angle-=360;
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	    glLoadIdentity();
	    glTranslated(0.0,0.0,-5.0);
	    glRotated(angle,0.0,1.0,0.0);
	    cube.DrawGL(&state);
	    AmigaMesaSwapBuffers(glcontext->context);
	    if (CheckSignal(SIGBREAKF_CTRL_D)) break;
    };
    return 1;
}

void MouseDownTexture(int x, int y, struct GLContext *glcontext) {
    printf("x:%d y:%d\n",x,y);
};
