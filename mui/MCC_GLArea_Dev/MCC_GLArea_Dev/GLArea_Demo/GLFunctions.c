/*----------------------------------------------------
  Note: Contains all OpenGL related functions
	GNU-C (EGCS) Port
-----------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <libraries/mui.h>

#include <proto/alib.h>
#include <proto/dos.h>
#include <proto/Amigamesa.h>

#include "Main.h"

#include "GLFunctions.h"

#include "Useful/GL_stubs.h"

//--- Object
extern struct ObjApp *MyApp;

//--- Globale GLState variable
double angleX=0,angleY=0,oldangleX=0,oldangleY=0,angle=0;
extern int object;
extern int rendering;
extern struct GLImage *groundimage,*objimage,*backimage;
extern struct GLImage *groundtex,*objtex,*backtex;

//--- GL object models
extern int DrawPawn(struct GLContext *glcontext);
extern int DrawColorCube(struct GLContext *glcontext);
extern int DrawGround(struct GLContext *glcontext);
extern int DrawBackground(struct GLContext *glcontext);

//--- built-in "Carrelage" Texture and standard texture
#include "TextureSol.gl"
UBYTE notexture[]={255,255,255};

int DrawObject(struct GLContext *glcontext, int otype) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    struct GLUquadricObj *quad=NULL;
    GLfloat ambient[]={0.20,0.20,0.20,1.00};
    GLfloat diffuse[]={0.80,0.20,0.00,1.00};
    GLfloat specular[]={1.00,1.00,1.00,1.00};
    GLfloat emissive[]={0.00,0.00,0.00,1.00};

    glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
    glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
    glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
    glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
    glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);

    if (otype==CUBE) {
	//--- multi color cube
	DrawColorCube(glcontext);
    }
    else if (otype==GLUTCUBE) {
	glutSolidCube(2.0);
    }
    else if (otype==GLUTSPHERE) {
	glutSolidSphere(1.0,16,16);
    }
    else if (otype==GLUTCONE) {
	glRotated(90,-1.0,0.0,0.0);
	glTranslated(0.0,0.0,-1.0);
	glutSolidCone(1.0,2.0,16,16);
    }
    else if (otype==GLUTTORUS) {
	glutSolidTorus(0.5,1.25,16,16);
    }
    else if (otype==GLUTDODECAHEDRON) {
	glutSolidDodecahedron();
    }
    else if (otype==GLUTOCTAHEDRON) {
	glutSolidOctahedron();
    }
    else if (otype==GLUTTETRAHEDRON) {
	glutSolidTetrahedron();
    }
    else if (otype==ICOSAHEDRON) {
	glutSolidIcosahedron();
    }
    else if (otype==GLUTTEAPOT) {
	glutSolidTeapot(1.5);
    }
    else if (otype==GLUCYLINDER) {
	quad=(struct GLUquadricObj *) gluNewQuadric();
	glTranslated(0.0,0.0,-1.5);
	gluCylinder(quad,1.0,1.0,3.0,16,16);
	gluDeleteQuadric(quad);
    }
    else if (otype==PAWN) {
	glPushMatrix();
	glTranslated(0.0,-0.5,0.0);
	DrawPawn(glcontext);
	glPopMatrix();
    };
}
//----------------------------------------------------
//--- rendering function for the SingleTask window ---
//----------------------------------------------------
int DrawSinglePawn(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glTranslated(0.0,0.0,-5.0);
    DrawPawn(glcontext);
    // AmigaMesaSwapBuffers(glcontext->context);
    if (CheckSignal(SIGBREAKF_CTRL_D)) return 1;
    return 0;
}


//---------------------------------------
//--- subtask for the SimpleAnimation ---
//---------------------------------------
int DrawSimpleAnimation(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glMatrixMode (GL_MODELVIEW);
    if (rendering==SOLID) {
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glDisable(GL_TEXTURE_2D);
	    glDisable(GL_BLEND);
    }
    else if (rendering==WIRE) {
	    glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
	    glShadeModel(GL_FLAT);
	    glDisable(GL_TEXTURE_2D);
	    glDisable(GL_BLEND);
    }
    else if (rendering==TEXTURED) {
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glEnable(GL_TEXTURE_2D);
	    // glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	    // glDisable(GL_BLEND);
    };
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    while(1) {
	angle+=2;
	if (angle>360) angle-=360;
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	glTranslated(0.0,-2.0,-5.0);
	if (groundtex) {
	    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,128,128,0,GL_RGB,GL_UNSIGNED_BYTE,groundtex->image);
	    // glBindTexture(GL_TEXTURE_2D,groundtex->glid);
	}
	else {
	    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,1,1,0,GL_RGB,GL_UNSIGNED_BYTE,notexture);
	    // glEnable(GL_TEXTURE_2D);
	    // glBindTexture(GL_TEXTURE_2D,0);
	};
	DrawBackground(glcontext);
	if (backtex) {
	    // printf("backtex->width:%d\n",backtex->width);
	    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,128,128,0,GL_RGB,GL_UNSIGNED_BYTE,backtex->image);
	    // glBindTexture(GL_TEXTURE_2D,backtex->glid);
	}
	else {
	    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,1,1,0,GL_RGB,GL_UNSIGNED_BYTE,notexture);
	    // glBindTexture(GL_TEXTURE_2D,0);
	};
	DrawGround(glcontext);
	glTranslated(0.0,2.25,0.0);
	glRotated(angle,0.0,1.0,0.0);
	if (objtex) {
	    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,128,128,0,GL_RGB,GL_UNSIGNED_BYTE,objtex->image);
	    // glBindTexture(GL_TEXTURE_2D,objtex->glid);
	}
	else {
	    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,1,1,0,GL_RGB,GL_UNSIGNED_BYTE,notexture);
	    // glBindTexture(GL_TEXTURE_2D,0);
	};
	DrawObject(glcontext,object);
	glTranslated(0.0,-1.0,0.0);
	//--- The Swapbuffer is needed, because the rendering will not get back
	//--- to GLArea class code for swapping until it's finished (breaked)
	AmigaMesaSwapBuffers(glcontext->context);
	if (CheckSignal(SIGBREAKF_CTRL_D)) break;
    };
    return 1;
}
//-------------------------------------------------------------------------
//--- Sub task functions for the MouseMove object (middle GLArea object) ---
//-------------------------------------------------------------------------
int DrawMouseMove(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity();
    if (rendering==SOLID) {
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glDisable(GL_TEXTURE_2D);
	    glDisable(GL_BLEND);
    }
    else if (rendering==WIRE) {
	    glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
	    glShadeModel(GL_FLAT);
	    glDisable(GL_TEXTURE_2D);
	    glDisable(GL_BLEND);
    }
    else if (rendering==TEXTURED) {
	    glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
	    glShadeModel(GL_SMOOTH);
	    glEnable(GL_TEXTURE_2D);
	    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	    glEnable(GL_BLEND);
    };
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    if (objtex) {
	glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,128,128,0,GL_RGB,GL_UNSIGNED_BYTE,objtex->image);
    }
    else {
	glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,128,128,0,GL_RGB,GL_UNSIGNED_BYTE,solimage);
    };
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glTranslated(0.0,0.0,-5.0);
    //--- Mouse rotation
    glRotated(angleY, -1.0, 0.0, 0.0);
    glRotated(angleX, 0.0, -1.0, 0.0);
    DrawObject(glcontext,object);
    // AmigaMesaSwapBuffers(glcontext->context);
    if (CheckSignal(SIGBREAKF_CTRL_D)) return 1;
    return 0;
}
//--- When mouse down
void DrawMouseDown(int x, int y, struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    //--- Well, nothing to do here
}
//--- When mouse moves (dragging)
void DrawMouseM(int dx, int dy,struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    angleX=oldangleX+(double) dx;
    angleY=oldangleY+(double) dy;
    DrawMouseMove(glcontext);
}
//--- Mouse up
void DrawMouseUp(int x, int y, struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    oldangleX=angleX;oldangleY=angleY;
}
//----------------------------------------------------------------------------
//--- Sub task function for the LongRendering object (right GLArea object) ---
//----------------------------------------------------------------------------
int DrawLongRendering(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int i=0,j=0,k=0,pos=0;
    double xmax=0.0;
    BOOL out=FALSE;
    // puts("In drawscene2");
    // glCamera();
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,128,128,0,GL_RGB,GL_UNSIGNED_BYTE,solimage);
    glEnable(GL_TEXTURE_2D);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    glTranslated(-13.5,-15.0,-5.0);
    // glRotated(45.0,0.0,1.0,0.0);
    // DrawGround(glcontext);
    // glTranslated(0.0,2.0,0.0);
    pos=0;out=FALSE;
    for (k=0;k<10;k++) {
	glPushMatrix();
	for (j=0;j<10;j++) {
	    glPushMatrix();
	    for (i=0;i<10;i++) {
		DrawColorCube(glcontext);
		pos++;
		glTranslated(0.0,0.0,-3.0);
		//--- Draw the bottom gauge
		xmax=_mwidth(glcontext->glarea)/1000.0*pos;
		// printf("width:%d xmax:%f total:%d currentpolygone:%d\n",_mwidth(st->glcontext->glarea),xmax,st->totalpolygones,st->currentpolygone);
		SetAPen(_rp(glcontext->glarea),2);
		// Call some MUI macro for the object size
		RectFill(_rp(glcontext->glarea),_mleft(glcontext->glarea),_mtop(glcontext->glarea)+_mheight(glcontext->glarea)-2,_mleft(glcontext->glarea)+(int) xmax,_mtop(glcontext->glarea)+_mheight(glcontext->glarea)-1);
		if (out) break;
		if (CheckSignal(SIGBREAKF_CTRL_D)) out=TRUE;
	    };
	    glPopMatrix();
	    glTranslated(3.0,0.0,0.0);
	    if (out) break;
	    if (CheckSignal(SIGBREAKF_CTRL_D)) out=TRUE;
	};
	glPopMatrix();
	glTranslated(0.0,3.0,0.0);
	if (out) break;
	if (CheckSignal(SIGBREAKF_CTRL_D)) out=TRUE;
    };
    // AmigaMesaSwapBuffers(glcontext->context);
    if (out) {
	return 1;
    }
    else {
	return 0;
    };
}

//---------------------------------------
//--- Texture preview stamps function ---
//---------------------------------------
int DrawBackgroundStamp(struct GLContext *glcontext) {
    return DrawStamp(glcontext,backimage);
}
int DrawGroundStamp(struct GLContext *glcontext) {
    return DrawStamp(glcontext,groundimage);
}
int DrawObjectStamp(struct GLContext *glcontext) {
    return DrawStamp(glcontext,objimage);
}

//--------------- Stamps size previews ------------------------
int DrawStamp(struct GLContext *glcontext, struct GLImage *glimage) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    if (glimage) {
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D_stub(glcontext,0.0,glimage->width,0.0,glimage->height);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glRasterPos2i(0,0);
	glDrawPixels(glimage->width,glimage->height,GL_RGB,GL_UNSIGNED_BYTE,glimage->image);
    };
    if (CheckSignal(SIGBREAKF_CTRL_D)) return 1;
    return 0;
}

/*
int Reset(AmigaMesaContext context) {
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
    return 0;
}
*/
