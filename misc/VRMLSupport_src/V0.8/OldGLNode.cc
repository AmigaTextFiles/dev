/*---------------------------------------------
  GLNode.cc
  Version 0.2
  Date: 21 june 1998
  Author: BODMER Stephan
  Note: OpenGL object for optimised display
--------------------------------------------*/
#include <clib/dos_protos.h>
#include <dos/dos.h>

#include "GLNode.h"

#ifdef USE_CYBERGL
#define SHARED
#include <cybergl/cybergl.h>
#include <cybergl/display.h>
#include <proto/cybergl.h>
#else
#include <GL/gl.h>
#endif

//--------------------
// GLShape
//--------------------
GLShape::GLShape():
    faces(),bb1(),bb2() {
}
GLShape::~GLShape() {
}
BOOL GLShape::DrawGL() {
    GLFace *glf=NULL;
    Vertex3d *cv=NULL;
    int i,j,nbv,nbm,nbn;

    // puts("GLShape::DrawGL");
    // printf("%d faces\n",faces.Length());
    for (i=0;i<faces.Length();i++) {
	glf=faces.Get(i);
	nbv=glf->vertex.Length();
	nbm=glf->material.Length();
	nbn=glf->normal.Length();
	// printf("Face %d: vertex:%d mat:%d normal:%d\n",i,nbv,nbm,nbn);

	glBegin(GL_POLYGON);
	for (j=0;j<nbv;j++) {
	    // Material defined ?
	    if (j<nbm) {
		// puts("mat->DrawGL");
		glf->material.Get(j)->DrawGL();
	    };
	    // Normal defined ?
	    if (j<nbn) {
		glNormal3dv(glf->normal.Get(j)->coord);
	    };
	    // printf("coord: %.4f %.4f %.4f\n",glf->vertex.Get(j)->coord[0],
	    //         glf->vertex.Get(j)->coord[1],glf->vertex.Get(j)->coord[2]);
	    cv=glf->vertex.Get(j);
	    if (cv->coord[0]<bb1.coord[0]) bb1.coord[0]=cv->coord[0];
	    if (cv->coord[1]<bb1.coord[1]) bb1.coord[1]=cv->coord[1];
	    if (cv->coord[2]<bb1.coord[2]) bb1.coord[2]=cv->coord[2];
	    if (cv->coord[0]>bb2.coord[0]) bb2.coord[0]=cv->coord[0];
	    if (cv->coord[1]>bb2.coord[1]) bb2.coord[1]=cv->coord[1];
	    if (cv->coord[2]>bb2.coord[2]) bb2.coord[2]=cv->coord[2];
	    glVertex3dv(cv->coord);
	};
	glEnd();
	if(CheckSignal(SIGBREAKF_CTRL_D)) return TRUE;
    };
    // puts("<==GLShape::Draw");
    return FALSE;
}
void GLShape::DrawGLBox() {
    // puts("GLShape::DrawGLBox");
    double x1=bb1.coord[0];
    double y1=bb1.coord[1];
    double z1=bb1.coord[2];
    double dx=bb2.coord[0]-x1;
    double dy=bb2.coord[1]-y1;
    double dz=bb2.coord[2]-z1;
    glBegin(GL_LINE_LOOP);
		glVertex3d(x1,y1,z1);
		glVertex3d(x1,y1+dy,z1);
		glVertex3d(x1+dx,y1+dy,z1);
		glVertex3d(x1+dx,y1,z1);
    glEnd();
    glBegin(GL_LINE_LOOP);
		glVertex3d(x1,y1,z1+dz);
		glVertex3d(x1,y1+dy,z1+dz);
		glVertex3d(x1+dx,y1+dy,z1+dz);
		glVertex3d(x1+dx,y1,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1,y1,z1);
		glVertex3d(x1,y1,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1,y1+dy,z1);
		glVertex3d(x1,y1+dy,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1+dx,y1+dy,z1);
		glVertex3d(x1+dx,y1+dy,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1+dx,y1,z1);
		glVertex3d(x1+dx,y1,z1+dz);
    glEnd();
}


//--------------------
// FGLShape
//--------------------
FGLShape::FGLShape(int pt, int fs, int nm) {
    puts("FGLShape constructor");
    numpoints=pt;
    numfaces=fs;
    nummaterial=nm;

    points=(vertex3d *) malloc(sizeof(vertex3d)*numpoints);
    faces=(int *) malloc(sizeof(int)*numfaces*numpoints);
    materials=(mat *) malloc(sizeof(mat)*nummaterials);
}
FGLShape::~FGLShape() {
    free(points);
    free(faces);
    free(materials);
}
BOOL FGLShape::DrawGL() {
    /*
    int pindex=0;
    int matindex=0;
    // puts("GLShape::DrawGL");
    // printf("%d faces\n",faces.Length());
    for (i=0;i<numfaces;i++) {
	// printf("Face %d: vertex:%d mat:%d normal:%d\n",i,nbv,nbm,nbn);
	howmuchpoints=faces[i];
	glBegin(GL_POLYGON);
	for (j=0;j<howmuchpoints;j++) {
	    // Material defined ?
	    if (j<nbm) {
		// puts("mat->DrawGL");
		glf->material.Get(j)->DrawGL();
	    };
	    // Normal defined ?
	    if (j<nbn) {
		glNormal3dv(glf->normal.Get(j)->coord);
	    };
	    // printf("coord: %.4f %.4f %.4f\n",glf->vertex.Get(j)->coord[0],
	    //         glf->vertex.Get(j)->coord[1],glf->vertex.Get(j)->coord[2]);
	    cv=glf->vertex.Get(j);
	    if (cv->coord[0]<bb1.coord[0]) bb1.coord[0]=cv->coord[0];
	    if (cv->coord[1]<bb1.coord[1]) bb1.coord[1]=cv->coord[1];
	    if (cv->coord[2]<bb1.coord[2]) bb1.coord[2]=cv->coord[2];
	    if (cv->coord[0]>bb2.coord[0]) bb2.coord[0]=cv->coord[0];
	    if (cv->coord[1]>bb2.coord[1]) bb2.coord[1]=cv->coord[1];
	    if (cv->coord[2]>bb2.coord[2]) bb2.coord[2]=cv->coord[2];
	    glVertex3dv(cv->coord);
	};
	glEnd();
	if(CheckSignal(SIGBREAKF_CTRL_D)) return TRUE;
    };
    */
    // puts("<==GLShape::Draw");
    return FALSE;
}
void FGLShape::DrawGLBox() {
    // puts("GLShape::DrawGLBox");
    /*
    double x1=bb1.coord[0];
    double y1=bb1.coord[1];
    double z1=bb1.coord[2];
    double dx=bb2.coord[0]-x1;
    double dy=bb2.coord[1]-y1;
    double dz=bb2.coord[2]-z1;
    glBegin(GL_LINE_LOOP);
		glVertex3d(x1,y1,z1);
		glVertex3d(x1,y1+dy,z1);
		glVertex3d(x1+dx,y1+dy,z1);
		glVertex3d(x1+dx,y1,z1);
    glEnd();
    glBegin(GL_LINE_LOOP);
		glVertex3d(x1,y1,z1+dz);
		glVertex3d(x1,y1+dy,z1+dz);
		glVertex3d(x1+dx,y1+dy,z1+dz);
		glVertex3d(x1+dx,y1,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1,y1,z1);
		glVertex3d(x1,y1,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1,y1+dy,z1);
		glVertex3d(x1,y1+dy,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1+dx,y1+dy,z1);
		glVertex3d(x1+dx,y1+dy,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1+dx,y1,z1);
		glVertex3d(x1+dx,y1,z1+dz);
    glEnd();
    */
}

//--------------------
// GLWire
//--------------------
GLWire::GLWire():
    lines(),bb1(),bb2() {
}
GLWire::~GLWire() {
}
BOOL GLWire::DrawGL() {
    GLFace *glf=NULL;
    Vertex3d *cv=NULL;
    int i,j,nbv,nbm,nbn;
    // puts("GLShape::DrawGL");
    // printf("%d faces\n",faces.Length());
    for (i=0;i<lines.Length();i++) {
	glf=lines.Get(i);
	nbv=glf->vertex.Length();
	nbm=glf->material.Length();
	nbn=glf->normal.Length();
	// printf("Face %d: vertex:%d mat:%d normal:%d\n",i,nbv,nbm,nbn);

	glBegin(GL_LINES);
	for (j=0;j<nbv;j++) {
	    // Material defined ?
	    if (j<nbm) {
		// puts("mat->DrawGL");
		glf->material.Get(j)->DrawGL();
	    };
	    // Normal defined ?
	    if (j<nbn) {
		glNormal3dv(glf->normal.Get(j)->coord);
	    };
	    // printf("coord: %.4f %.4f %.4f\n",glf->vertex.Get(j)->coord[0],
	    //         glf->vertex.Get(j)->coord[1],glf->vertex.Get(j)->coord[2]);
	    cv=glf->vertex.Get(j);
	    if (cv->coord[0]<bb1.coord[0]) bb1.coord[0]=cv->coord[0];
	    if (cv->coord[1]<bb1.coord[1]) bb1.coord[1]=cv->coord[1];
	    if (cv->coord[2]<bb1.coord[2]) bb1.coord[2]=cv->coord[2];
	    if (cv->coord[0]>bb2.coord[0]) bb2.coord[0]=cv->coord[0];
	    if (cv->coord[1]>bb2.coord[1]) bb2.coord[1]=cv->coord[1];
	    if (cv->coord[2]>bb2.coord[2]) bb2.coord[2]=cv->coord[2];
	    glVertex3dv(glf->vertex.Get(j)->coord);
	};
	glEnd();
	if(CheckSignal(SIGBREAKF_CTRL_D)) return TRUE;
    };
    return FALSE;
}

void GLWire::DrawGLBox() {
    double x1=bb1.coord[0];
    double y1=bb1.coord[1];
    double z1=bb1.coord[2];
    double dx=bb2.coord[0]-x1;
    double dy=bb2.coord[1]-y1;
    double dz=bb2.coord[2]-z1;
    glBegin(GL_LINE_LOOP);
		glVertex3d(x1,y1,z1);
		glVertex3d(x1,y1+dy,z1);
		glVertex3d(x1+dx,y1+dy,z1);
		glVertex3d(x1+dx,y1,z1);
    glEnd();
    glBegin(GL_LINE_LOOP);
		glVertex3d(x1,y1,z1+dz);
		glVertex3d(x1,y1+dy,z1+dz);
		glVertex3d(x1+dx,y1+dy,z1+dz);
		glVertex3d(x1+dx,y1,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1,y1,z1);
		glVertex3d(x1,y1,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1,y1+dy,z1);
		glVertex3d(x1,y1+dy,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1+dx,y1+dy,z1);
		glVertex3d(x1+dx,y1+dy,z1+dz);
    glEnd();
    glBegin(GL_LINES);
		glVertex3d(x1+dx,y1,z1);
		glVertex3d(x1+dx,y1,z1+dz);
    glEnd();
}

//--------------
// GLSeparator
//--------------
BOOL GLSeparator::DrawGL() {
    // puts("GLSeparator::DrawGL");
    BOOL result=FALSE;

    glPushMatrix();
    for (int i=0;i<children.Length();i++) {
	result=children.Get(i)->DrawGL();
	if (result) {
	    glPopMatrix();
	    return TRUE;
	};
    };
    glPopMatrix();
    return FALSE;
}
void GLSeparator::DrawGLBox() {
    glPushMatrix();
    for (int i=0;i<children.Length();i++) {
	children.Get(i)->DrawGLBox();
    };
    glPopMatrix();
}
//---------------
// GLGroup
//---------------
BOOL GLGroup::DrawGL() {
    BOOL result=FALSE;
    for (int i=0;i<children.Length();i++) {
	result=children.Get(i)->DrawGL();
	if(result) return TRUE;
    };
    return FALSE;
}
void GLGroup::DrawGLBox() {
    // glPushMatrix();
    for (int i=0;i<children.Length();i++) {
	children.Get(i)->DrawGLBox();
    };
    // glPopMatrix();
}
//------------------
// GLMultMatrix
//------------------
GLMultMatrix::GLMultMatrix(float *m) {
    for (int i=0;i<16;i++) {
	matrix[i]=m[i];
    };
}
BOOL GLMultMatrix::DrawGL() {
    glMultMatrixf(matrix);
    return FALSE;
}
//------------
// GLRotate
//------------
GLRotate::GLRotate(double *r) {
    rotation[0]=r[0];rotation[1]=r[1];rotation[2]=r[2];
    rotation[3]=r[3]/0.017447;
}
BOOL GLRotate::DrawGL() {
    glRotated(rotation[3],rotation[0],rotation[1],rotation[2]);
    return FALSE;
}

//--------------
// GLScale
//--------------
GLScale::GLScale(double *s) {
    scale[0]=s[0];scale[1]=s[1];scale[2]=s[2];
}
BOOL GLScale::DrawGL() {
    glScaled(scale[0],scale[1],scale[2]);
    return FALSE;
}
//--------------
// GLTransform
//--------------
GLTransform::GLTransform(double *t,double *r,double *sf,double *so, double *c) {
    translation[0]=t[0];translation[1]=t[1];translation[2]=t[2];
    rotation[0]=r[0];rotation[1]=r[1];rotation[2]=r[2];rotation[3]=r[3]/0.017447;
    scaleFactor[0]=sf[0];scaleFactor[1]=sf[1];scaleFactor[2]=sf[2];
    scaleOrientation[0]=so[0];scaleOrientation[1]=so[1];scaleOrientation[2]=so[2];
    scaleOrientation[3]=so[3]/0.017447;
    center[0]=c[0];center[1]=c[1];center[2]=c[2];
}
BOOL GLTransform::DrawGL() {
    glTranslated(translation[0],translation[1],translation[2]);
    glTranslated(center[0],center[1],center[2]);
    glRotated(rotation[3],rotation[0],rotation[1],rotation[2]);
    glRotated(scaleOrientation[3],scaleOrientation[0],scaleOrientation[1],scaleOrientation[2]);
    glScaled(scaleFactor[0],scaleFactor[1],scaleFactor[2]);
    glRotated(-scaleOrientation[3],scaleOrientation[0],scaleOrientation[1],scaleOrientation[2]);
    glTranslated(-center[0],-center[1],-center[2]);
    return FALSE;
}
//-------------
// GLTranslate
//-------------
GLTranslate::GLTranslate(double *t) {
    translate[0]=t[0];translate[1]=t[1];translate[2]=t[2];
}
BOOL GLTranslate::DrawGL() {
    glTranslated(translate[0],translate[1],translate[2]);
    return FALSE;
}
//--------------------
// GLDirectionalLight
//--------------------
GLDirectionalLight::GLDirectionalLight(DirectionalLight *dl,int lsn):
    position(),color() {
    num=lsn;
    position=dl->point;
    color=dl->color;
    intensity=dl->intensity;
}
BOOL GLDirectionalLight::DrawGL() {
    GLenum LightNum;
    float amb[4];
    float pos[4];

    switch (num) {
	case 0:LightNum=GL_LIGHT0;break;
	case 1:LightNum=GL_LIGHT1;break;
	case 2:LightNum=GL_LIGHT2;break;
	case 3:LightNum=GL_LIGHT3;break;
    };
    amb[0]=intensity;
    amb[1]=intensity;
    amb[2]=intensity;
    amb[3]=1.0;
    pos[0]=position.coord[0];
    pos[1]=position.coord[1];
    pos[2]=position.coord[2];
    pos[3]=position.coord[3];

    glEnable(LightNum);
    glLightfv(LightNum, GL_POSITION, pos);
    glLightfv(LightNum, GL_DIFFUSE, color.rgb);
    glLightfv(LightNum, GL_AMBIENT, amb);
    return FALSE;
}
//--------------------
// GLPointLight
//--------------------
GLPointLight::GLPointLight(PointLight *pl, int lsn):
    position(),color() {
    num=lsn;
    position=pl->point;
    color=pl->color;
    intensity=pl->intensity;
}
BOOL GLPointLight::DrawGL() {
    GLfloat amb[4];
    GLfloat pos[4];
    GLenum LightNum;

    switch (num) {
	case 0:LightNum=GL_LIGHT0;break;
	case 1:LightNum=GL_LIGHT1;break;
	case 2:LightNum=GL_LIGHT2;break;
	case 3:LightNum=GL_LIGHT3;break;
    };
    amb[0]=intensity;
    amb[1]=intensity;
    amb[2]=intensity;
    amb[3]=1.0;
    pos[0]=position.coord[0];
    pos[1]=position.coord[1];
    pos[2]=position.coord[2];
    pos[3]=position.coord[3];
    // printf("position: %f %f %f %f\n",pos[0],pos[1],pos[2],pos[4]);
    glEnable(LightNum);
    glLightfv(LightNum, GL_POSITION, pos);
    glLightfv(LightNum, GL_DIFFUSE, color.rgb);
    glLightfv(LightNum, GL_AMBIENT, amb);
    return FALSE;
}
//--------------------
// GLSpotLight
//--------------------
GLSpotLight::GLSpotLight(SpotLight *sl, int lsn):
    position(),direction(),color() {
    num=lsn;
    position=sl->point;
    direction=sl->direction;
    color=sl->color;
    intensity=sl->intensity;
    dropOffRate=sl->dropOffRate;
    cutOffAngle=sl->cutOffAngle;
}
BOOL GLSpotLight::DrawGL() {
    float amb[4];
    float pos[4];
    float dir[3];
    GLenum LightNum;

    switch (num) {
	case 0:LightNum=GL_LIGHT0;break;
	case 1:LightNum=GL_LIGHT1;break;
	case 2:LightNum=GL_LIGHT2;break;
	case 3:LightNum=GL_LIGHT3;break;
    };
    amb[0]=intensity;
    amb[1]=intensity;
    amb[2]=intensity;
    amb[3]=1.0;
    pos[0]=position.coord[0];
    pos[1]=position.coord[1];
    pos[2]=position.coord[2];
    pos[3]=position.coord[3];
    dir[0]=direction.coord[0];
    dir[1]=direction.coord[1];
    dir[2]=direction.coord[2];

    glEnable(LightNum);
    glLightfv(LightNum, GL_POSITION, pos);
    glLightfv(LightNum, GL_DIFFUSE, color.rgb);
    glLightfv(LightNum, GL_AMBIENT, amb);
    glLightfv(LightNum, GL_SPOT_DIRECTION, dir);
    glLightf(LightNum, GL_SPOT_CUTOFF, (360*cutOffAngle)/2*3.14);
    glLightf(LightNum, GL_SPOT_EXPONENT, dropOffRate);
    return FALSE;
}
