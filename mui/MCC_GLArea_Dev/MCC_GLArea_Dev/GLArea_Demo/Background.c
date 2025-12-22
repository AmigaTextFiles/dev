/*------------------------------------------------------
  -OpenGL source code                                  -
  -Generated with VRMLEditor V 0.64 Beta (on Amiga)    -
  -Written by BODMER Stephan (bodmer2@uni2a.unige.ch)  -
  -VRMLEditor is Copyright(1997/98) by BodySoft        -
  ------------------------------------------------------*/
#include <proto/Amigamesa.h>

#include <mui/GLArea_mcc.h>

void DrawGround(struct GLContext *glcontext) {
	struct Library *glBase=glcontext->gl_Base;
	struct Library *gluBase=glcontext->glu_Base;
	struct Library *glutBase=glcontext->glut_Base;

	/*
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
	glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB,128,128,0,GL_RGB,GL_UNSIGNED_BYTE,solimage);
	*/
	// IndexedFaceSet
	glBegin(GL_POLYGON);
	{
	 GLfloat ambient[]={0.20,0.20,0.50,1.00};
	 GLfloat diffuse[]={0.50,0.50,0.90,1.00};
	 GLfloat specular[]={0.00,0.00,0.00,1.00};
	 GLfloat emissive[]={0.00,0.00,0.00,1.00};
	 glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);
	 glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);
	 glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25.60);
	};
		glNormal3d(0.0000,0.0000,1.0000);
		glTexCoord2d(1.0,0.0);
		glVertex3d(5.0000,0.0000,-5.0000);
		glTexCoord2d(1.0,1.0);
		glVertex3d(5.0000,6.0000,-5.0000);
		glTexCoord2d(0.0,1.0);
		glVertex3d(-5.0000,6.0000,-5.0000);
		glTexCoord2d(0.0,0.0);
		glVertex3d(-5.0000,0.0000,-5.0000);
	glEnd();
}
