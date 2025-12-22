/*------------------------------------------------------
  -OpenGL source code                                  -
  -Generated with VRMLEditor V 0.70 Beta (on Amiga)    -
  -Written by BODMER Stephan (sbodmer@lsi-media.ch)    -
  -VRMLEditor is Copyright(1997/98) by LSI Media S‡RL  -
  ------------------------------------------------------*/
#include <proto/Amigamesa.h>

#include <mui/GLArea_mcc.h>

void DrawColorCube(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    // WoodenCube (Separator)
    glPushMatrix();
	/*
	Wooden Box
	*/
	// PointLight
	/*
	glEnable(GL_LIGHT0);
	glLightf(GL_LIGHT0, GL_POSITION, 2.0000, 2.0000, 2.0000, 1.0000);
	glLightf(GL_LIGHT0, GL_DIFFUSE, 1.00, 1.00, 1.00, 1.00);
	glLightf(GL_LIGHT0, GL_AMBIENT, 1.00, 1.00, 1.00, 1.0);
	*/
	// RGBColorCube (IndexedFaceSet)m
	glBegin(GL_POLYGON);
		glNormal3d(0.0000,1.0000,0.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,1.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,0.0000);
		glVertex3d(1.0000,1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,1.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,1.0000);
		glVertex3d(1.0000,1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,0.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,1.0000);
		glVertex3d(-1.0000,1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,0.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,0.0000);
		glVertex3d(-1.0000,1.0000,1.0000);
	glEnd();
	glBegin(GL_POLYGON);
		glNormal3d(1.0000,0.0000,0.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,1.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,0.0000);
		glVertex3d(1.0000,1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,1.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,1.0000);
		glVertex3d(1.0000,-1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,1.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,1.0000);
		glVertex3d(1.0000,-1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,1.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,0.0000);
		glVertex3d(1.0000,1.0000,-1.0000);
	glEnd();
	glBegin(GL_POLYGON);
		glNormal3d(0.0000,0.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,1.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,0.0000);
		glVertex3d(1.0000,1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,1.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,1.0000);
		glVertex3d(1.0000,-1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,0.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,1.0000);
		glVertex3d(-1.0000,-1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,0.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,0.0000);
		glVertex3d(-1.0000,1.0000,-1.0000);
	glEnd();
	glBegin(GL_POLYGON);
		glNormal3d(-1.0000,0.0000,0.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,0.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,0.0000);
		glVertex3d(-1.0000,1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,0.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,1.0000);
		glVertex3d(-1.0000,-1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,0.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,1.0000);
		glVertex3d(-1.0000,-1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,0.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,0.0000);
		glVertex3d(-1.0000,1.0000,1.0000);
	glEnd();
	glBegin(GL_POLYGON);
		glNormal3d(0.0000,0.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,0.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,0.0000);
		glVertex3d(-1.0000,1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,0.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,1.0000);
		glVertex3d(-1.0000,-1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,1.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,1.0000);
		glVertex3d(1.0000,-1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,1.00,1.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,0.0000);
		glVertex3d(1.0000,1.0000,1.0000);
	glEnd();
	glBegin(GL_POLYGON);
		glNormal3d(0.0000,-1.0000,0.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,0.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,0.0000);
		glVertex3d(-1.0000,-1.0000,1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,0.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(1.0000,1.0000);
		glVertex3d(-1.0000,-1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={0.00,1.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,1.0000);
		glVertex3d(1.0000,-1.0000,-1.0000);
	{
	 GLfloat ambient[]={0.20,0.20,0.20,1.00};
	 GLfloat diffuse[]={1.00,1.00,0.00,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glTexCoord2d(0.0000,0.0000);
		glVertex3d(1.0000,-1.0000,1.0000);
	glEnd();
    glPopMatrix();
}
