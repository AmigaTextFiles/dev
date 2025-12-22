/*---------------------------------------------
  GLNode.cc
  Version 0.2
  Date: 21 june 1998
  Author: BODMER Stephan
  Note: OpenGL object for optimised display
--------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>

#ifdef USE_CYBERGL
#define SHARED
#include <cybergl/cybergl.h>
#include <cybergl/display.h>
#include <proto/cybergl.h>
#else
#include <proto/Amigamesa.h>
#endif

#include "GLNode.h"
#include "GL_stubs.h"

//----------------------------------------- GLVertex3d-------------------
GLVertex3d::GLVertex3d(int np) {
    numpoints=np;
    pointlist=(vertex3d *) malloc(sizeof(vertex3d)*np);
    // puts("GLCoordinate::Constructor()");
}
GLVertex3d::~GLVertex3d() {
    free(pointlist);
    // puts("GLCoordinate::Destructor()");
}
//----------------------------------------- GLVertex2d-------------------
GLVertex2d::GLVertex2d(int np) {
    numpoints=np;
    pointlist=(vertex2d *) malloc(sizeof(vertex2d)*np);
    // puts("GLCoordinate::Constructor()");
}
GLVertex2d::~GLVertex2d() {
    free(pointlist);
    // puts("GLCoordinate::Destructor()");
}
//------------------------------------- GLMaterial ---------------------
GLMaterial::GLMaterial(int nm) {
    nummats=nm;
    materiallist=(material *) malloc(sizeof(material)*nm);
}
GLMaterial::~GLMaterial() {
    free(materiallist);
}
//------------------------------------- GLTexture --------------------
GLTexture::GLTexture(int w, int h, int co, int ws, int wt) {
    width=w;
    height=h;
    component=co;
    wrapS=ws;
    wrapT=wt;
    scaled=FALSE;
    image=(UBYTE *) malloc(w*h*co);
}
GLTexture::~GLTexture() {
    if (image) free(image);
}
BOOL GLTexture::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int glwraps=GL_REPEAT,glwrapt=GL_REPEAT;

    if (scaled==FALSE) ScaleImage(glcontext);

    if (image) {
	// puts("in realinti");
	if (wrapS==TEXTURE2_WRAP_CLAMP) glwraps=GL_CLAMP;
	if (wrapT==TEXTURE2_WRAP_CLAMP) glwrapt=GL_CLAMP;
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, glwraps);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, glwrapt);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB, width, height,0,GL_RGB,GL_UNSIGNED_BYTE,image);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
    };
    return FALSE;
}
void GLTexture::DrawGLBox(struct GLContext *glcontext) {
}
int GLTexture::ScaleImage(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int nwidth=0,nheight=0,i=0,rep=0;
    UBYTE *nimage=NULL;

    // puts("Rescaling image");
    do {
	nwidth=(int) pow(2,i);
	i++;
	// printf("nwidth:%d\n",nwidth);
    }
    while (nwidth<width);
    nwidth=(int) pow(2,i-1);
    i=0;
    do {
	nheight=(int) pow(2,i);
	i++;
	// printf("nheight:%d\n",nheight);
    }
    while (nheight<height);
    nheight=(int) pow(2,i-1);
    if ((nwidth==(width+(width%8)))&&
	(nheight==height)) return 0;
    nimage=(UBYTE *) malloc(nwidth*nheight*component);
    // puts("new image allocated");
    rep=gluScaleImage_stub(glcontext,GL_RGB,width,height,GL_UNSIGNED_BYTE,image,nwidth,nheight,GL_UNSIGNED_BYTE,nimage);
    // puts("after the gluscale");
    free(image);
    image=nimage;
    width=nwidth;
    height=nheight;
    scaled=TRUE;
    return rep;
}
//--------------------
// GLShape
//--------------------
GLShape::GLShape(int np, int nf, int nm, int nn, int nt, int coordindexes) {
    // puts("GLShape::Constructor");
    numfaces=nf;
    coordIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
    materialIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
    normalIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
    texCoordIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
}
GLShape::GLShape(int nf, int coordindexes) {
    numfaces=nf;
    glc=NULL;
    glm=NULL;
    gln=NULL;
    gltc=NULL;

    coordIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
    materialIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
    normalIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
    texCoordIndex=(int *) malloc(sizeof(int)*(coordindexes+numfaces));
    bb1.coord[0]=0.0;bb1.coord[1]=0.0;bb1.coord[2]=0.0;
    bb2.coord[0]=0.0;bb2.coord[1]=0.0;bb2.coord[2]=0.0;
}
GLShape::~GLShape() {
    // puts("GLShape::Destructor");
    free(coordIndex);
    free(materialIndex);
    free(normalIndex);
    free(texCoordIndex);
}
BOOL GLShape::DrawGL(struct GLContext *glcontext) {
    int gcmi=-1,gcti=-1,gcni=-1,cmi=0,cni=0,cci=0,cti=0,pos=0;
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    #ifdef DEBUG
    puts("GLShape::DrawGL");
    printf("%d faces\n",numfaces);
    printf("%d coordinates\n",glc->numpoints);
    printf("%d materials\n",glm->nummats);
    printf("%d normals\n",gln->numpoints);
    printf("%d texcoord\n",gltc->numpoints);
    #endif

    for (int i=0;i<numfaces;i++) {
	cci=coordIndex[pos];
	cmi=materialIndex[pos];
	cni=normalIndex[pos];
	cti=texCoordIndex[pos];
	glBegin(GL_POLYGON);
	while (cci!=-1) {
	    if (gcni!=cni) {
		gcni=cni;
		glNormal3dv(gln->pointlist[gcni].coord);
	    };
	    if (gcti!=cti) {
		gcti=cti;
		if (gcti!=-2) {
		    glTexCoord2dv(gltc->pointlist[gcti].coord);
		};
	    };
	    if (gcmi!=cmi) {
		gcmi=cmi;
		// puts("DrawMAT");
		// cmat=materialslist[mi];
		glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,glm->materiallist[gcmi].ambient);
		glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,glm->materiallist[gcmi].diffuse);
		glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,glm->materiallist[gcmi].specular);
		glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,glm->materiallist[gcmi].emissive);
		glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,glm->materiallist[gcmi].shininess);
	    };
	    // printf("points index:%d x:%f y:%f z:%f\n",cci,pointslist[cci].coord[0],pointslist[cci].coord[1],pointslist[cci].coord[2]);
	    if (cci>-1) {
		glVertex3dv(glc->pointlist[cci].coord);
	    };
	    pos++;
	    cci=coordIndex[pos];
	    cmi=materialIndex[pos];
	    cni=normalIndex[pos];
	    cti=texCoordIndex[pos];
	};
	glEnd();
	if(CheckSignal(SIGBREAKF_CTRL_D)) return TRUE;
	pos++;
    };

    // puts("<==GLShape::Draw");
    return FALSE;
}
void GLShape::DrawGLBox(struct GLContext *glcontext) {
    // puts("GLShape::DrawGLBox");
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
// GLWire
//--------------------
GLWire::GLWire(int np, int nf, int nm, int nn, int nt, int coordindexes) {
    // puts("GLShape::Constructor");
    numlines=nf;
    coordIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
    materialIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
    normalIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
    texCoordIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
}
GLWire::GLWire(int nf, int coordindexes) {
    numlines=nf;
    glc=NULL;
    glm=NULL;
    gln=NULL;
    gltc=NULL;

    coordIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
    materialIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
    normalIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
    texCoordIndex=(int *) malloc(sizeof(int)*(coordindexes+numlines));
    bb1.coord[0]=0.0;bb1.coord[1]=0.0;bb1.coord[2]=0.0;
    bb2.coord[0]=0.0;bb2.coord[1]=0.0;bb2.coord[2]=0.0;
}
GLWire::~GLWire() {
    // puts("GLShape::Destructor");
    free(coordIndex);
    free(materialIndex);
    free(normalIndex);
    free(texCoordIndex);
}
BOOL GLWire::DrawGL(struct GLContext *glcontext) {
    int gcmi=-1,gcti=-1,gcni=-1,cmi=0,cni=0,cci=0,cti=0,pos=0;
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    #ifdef DEBUG
    puts("GLWire::DrawGL");
    printf("%d faces\n",numfaces);
    printf("%d coordinates\n",glc->numpoints);
    printf("%d materials\n",glm->nummats);
    printf("%d normals\n",gln->numpoints);
    printf("%d texcoord\n",gltc->numpoints);
    #endif

    for (int i=0;i<numlines;i++) {
	cci=coordIndex[pos];
	cmi=materialIndex[pos];
	cni=normalIndex[pos];
	cti=texCoordIndex[pos];
	glBegin(GL_LINE);
	while (cci!=-1) {
	    if (gcni!=cni) {
		gcni=cni;
		glNormal3dv(gln->pointlist[gcni].coord);
	    };
	    if (gcti!=cti) {
		gcti=cti;
		if (gcti!=-2) {
		    glTexCoord2dv(gltc->pointlist[gcti].coord);
		};
	    };
	    if (gcmi!=cmi) {
		gcmi=cmi;
		// puts("DrawMAT");
		// cmat=materialslist[mi];
		glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,glm->materiallist[gcmi].ambient);
		glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,glm->materiallist[gcmi].diffuse);
		glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,glm->materiallist[gcmi].specular);
		glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,glm->materiallist[gcmi].emissive);
		glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,glm->materiallist[gcmi].shininess);
	    };
	    // printf("points index:%d x:%f y:%f z:%f\n",cci,pointslist[cci].coord[0],pointslist[cci].coord[1],pointslist[cci].coord[2]);
	    if (cci>-1) {
		glVertex3dv(glc->pointlist[cci].coord);
	    };
	    pos++;
	    cci=coordIndex[pos];
	    cmi=materialIndex[pos];
	    cni=normalIndex[pos];
	    cti=texCoordIndex[pos];
	};
	glEnd();
	if(CheckSignal(SIGBREAKF_CTRL_D)) return TRUE;
	pos++;
    };
    return FALSE;
}

void GLWire::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
BOOL GLSeparator::DrawGL(struct GLContext *glcontext) {
    // puts("GLSeparator::DrawGL");
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    BOOL result=FALSE;

    glPushMatrix();
    for (int i=0;i<children.Length();i++) {
	result=children.Get(i)->DrawGL(glcontext);
	if (result) {
	    glPopMatrix();
	    return TRUE;
	};
    };
    glPopMatrix();
    return FALSE;
}
void GLSeparator::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    glPushMatrix();
    for (int i=0;i<children.Length();i++) {
	children.Get(i)->DrawGLBox(glcontext);
    };
    glPopMatrix();
}
//---------------
// GLGroup
//---------------
BOOL GLGroup::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    BOOL result=FALSE;
    for (int i=0;i<children.Length();i++) {
	result=children.Get(i)->DrawGL(glcontext);
	if(result) return TRUE;
    };
    return FALSE;
}
void GLGroup::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    // glPushMatrix();
    for (int i=0;i<children.Length();i++) {
	children.Get(i)->DrawGLBox(glcontext);
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
BOOL GLMultMatrix::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
BOOL GLRotate::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    glRotated_stub(glcontext,rotation[3],rotation[0],rotation[1],rotation[2]);
    return FALSE;
}

//--------------
// GLScale
//--------------
GLScale::GLScale(double *s) {
    scale[0]=s[0];scale[1]=s[1];scale[2]=s[2];
}
BOOL GLScale::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
BOOL GLTransform::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

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
BOOL GLTranslate::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
BOOL GLDirectionalLight::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
BOOL GLPointLight::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
BOOL GLSpotLight::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
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
GLTextureTransform::GLTextureTransform(double *t, double *s, double *c, double r) {
    translation[0]=t[0];translation[1]=t[1];
    scale[0]=s[0];scale[1]=s[1];
    center[0]=c[0];center[1]=c[1];
    rotation=r;
}
BOOL GLTextureTransform::DrawGL(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glMatrixMode(GL_TEXTURE);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    return FALSE;
}
