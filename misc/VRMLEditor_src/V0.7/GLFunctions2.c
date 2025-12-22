#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// #include <dos/dos.h>
#include <intuition/intuition.h>

#include <mui/Listtree_mcc.h>
#include <mui/GLArea_mcc.h>

// #include <proto/dos.h>
// #include <proto/alib.h>

// #include "Main.h"
// #include "VRMLNode.h"
// #include "GLNode.h"
// #include "GLFunctions.h"
// #include "MUIWindows.h"
// #include "App.h"

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

GLubyte checkImage[80][100][3];

//-------------- Colored Checkboard bitmap -----------------
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

void DrawAxis(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

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
//------------------- MAIN WINDOW VRMLEDITOR LOGO ---------------------
void DrawMainLogoBackground(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int origin[2]={0,0};
    #include "VRMLEditor.gl"

    // FPrintf(glcontext->fh,"=>IN THE DRAWMAINLOGOBACKGROUND\n");
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    gluOrtho2D_stub(glcontext,0.0,300.0,0.0,50.0);
    // glOrtho(0,100,0,80,0,10);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glRasterPos2iv(origin);
    // glPixelZoom(2,2);
    // puts("drawpixel");
    // glPixelStorei(GL_UNPACK_ALIGNMENT, 2);
    glDrawPixels(300,50,GL_RGB,GL_UNSIGNED_BYTE,mainlogoimage);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
    // FPrintf(glcontext->fh,"<=IN THE DRAWMAINLOGOBACKGROUND\n");
}

//------------------- MATERIAL SAMPLE CHECKBOARD BACKGROUND --------------
void DrawBackground(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int origin[2]={0,0};

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D_stub(glcontext,0.0,100.0,0.0,80.0);
    // glOrtho(0,100,0,80,0,10);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glRasterPos2iv(origin);
    // glPixelZoom(2,2);
    // puts("drawpixel");
    // glPixelStorei(GL_UNPACK_ALIGNMENT, 2);
    glDrawPixels(100,80,GL_RGB,GL_UNSIGNED_BYTE,checkImage);
}

