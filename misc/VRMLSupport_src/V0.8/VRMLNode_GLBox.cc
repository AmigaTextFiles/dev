/*----------------------------------------------------
  VRMLNode_GLBox.cc
  Version 0.33
  Date: 19 march 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: All CyberGL output for the bounding box
-----------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#ifdef USE_CYBERGL
#define SHARED
#include <cybergl/cybergl.h>
#include <cybergl/display.h>
#include <proto/cybergl.h>
#else
#include <proto/Amigamesa.h>
#endif

#include "VRMLNode.h"

/*---------------------
  Misc classes
----------------------*/
/**************
 * VRML Nodes *
 **************/
// AsciiText
void AsciiText::DrawGLBox(struct GLContext *glcontext) {
}
// Cone
void Cone::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    double h=height/2;
    double r=bottomRadius;
	glBegin(GL_LINE_LOOP);
		// glColor3f(0.0,0.0,0.0);
		glVertex3d(-r,-h,r);
		glVertex3d(0.0,h,0.0);
		glVertex3d(r,-h,r);
	glEnd();
	glBegin(GL_LINE_LOOP);
		glVertex3d(-r,-h,-r);
		glVertex3d(0.0,h,0.0);
		glVertex3d(r,-h,-r);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(-r,-h,-r);
		glVertex3d(-r,-h,r);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(r,-h,-r);
		glVertex3d(r,-h,r);
	glEnd();
}              
// Coordinate3
void Coordinate3::DrawGLBox(struct GLContext *glcontext) {
}      
// Cube
void Cube::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    double w=width/2;
    double h=height/2;
    double d=depth/2;

	
	glBegin(GL_LINE_LOOP);
		// glColor3f(1.0,1.0,1.0);
		glVertex3d(-w,-h,-d);
		glVertex3d(-w,h,-d);
		glVertex3d(w,h,-d);
		glVertex3d(w,-h,-d);
	glEnd();
	glBegin(GL_LINE_LOOP);
		glVertex3d(-w,-h,d);
		glVertex3d(-w,h,d);
		glVertex3d(w,h,d);
		glVertex3d(w,-h,d);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(-w,-h,-d);
		glVertex3d(-w,-h,d);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(w,-h,-d);
		glVertex3d(w,-h,d);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(-w,h,-d);
		glVertex3d(-w,h,d);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(w,h,-d);
		glVertex3d(w,h,d);
	glEnd();
}          
// Cylinder
void Cylinder::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    double h=height/2;
    double r=radius;
	glBegin(GL_LINE_LOOP);
		glVertex3d(-r,-h,-r);
		glVertex3d(-r,h,-r);
		glVertex3d(r,h,-r);
		glVertex3d(r,-h,-r);
	glEnd();
	glBegin(GL_LINE_LOOP);
		glVertex3d(-r,-h,r);
		glVertex3d(-r,h,r);
		glVertex3d(r,h,r);
		glVertex3d(r,-h,r);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(-r,-h,-r);
		glVertex3d(-r,-h,r);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(r,-h,-r);
		glVertex3d(r,-h,r);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(-r,h,-r);
		glVertex3d(-r,h,r);
	glEnd();
	glBegin(GL_LINES);
		glVertex3d(r,h,-r);
		glVertex3d(r,h,r);
	glEnd();
}          
// DirectionalLight
void DirectionalLight::DrawGLBox(struct GLContext *glcontext) {
}       
// FontStyle
void FontStyle::DrawGLBox(struct GLContext *glcontext) {
}
// Group
void Group::DrawGLBox(struct GLContext *glcontext) {
    for (int i=0;i<children.Length();i++) {
	GetChild(i)->DrawGLBox(glcontext);
    };
}
// IndexedFaceSet
void IndexedFaceSet::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    double x1=min.coord[0];
    double y1=min.coord[1];
    double z1=min.coord[2];
    double dx=max.coord[0]-x1;
    double dy=max.coord[1]-y1;
    double dz=max.coord[2]-z1;

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
// IndexedLineSet
void IndexedLineSet::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    double x1=min.coord[0];
    double y1=min.coord[1];
    double z1=min.coord[2];
    double dx=max.coord[0]-x1;
    double dy=max.coord[1]-y1;
    double dz=max.coord[2]-z1;

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
// Info
void VInfo::DrawGLBox(struct GLContext *glcontext) {
}
// LOD
void LOD::DrawGLBox(struct GLContext *glcontext) {
}            
// Material
void Material::DrawGLBox(struct GLContext *glcontext) {
}     
// MaterialBinding
void MaterialBinding::DrawGLBox(struct GLContext *glcontext) {
}     
// MatrixTranform
void MatrixTransform::DrawGLBox(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glMultMatrixf(matrix);
}
// Normal
void Normal::DrawGLBox(struct GLContext *glcontext) {
}                 
// NormalBinding
void NormalBinding::DrawGLBox(struct GLContext *glcontext) {
}                 
// OrthographicCamera
void OrthographicCamera::DrawGLBox(struct GLContext *glcontext) {
}
// PerspectiveCamera
void PerspectiveCamera::DrawGLBox(struct GLContext *glcontext) {
}
// PointLight
void PointLight::DrawGLBox(struct GLContext *glcontext) {
}
// PointSet
void PointSet::DrawGLBox(struct GLContext *glcontext) {
}
// Rotation
void Rotation::DrawGLBox(struct GLContext *glcontext) {
    VRMLState st=VRMLState();
    st.glcontext=glcontext;
    // double x,y,z,a;
    // rotation.Get(x,y,z,a);
    // glRotated(a/0.017447,x,y,z);
    DrawGL(&st);
}
// Scale
void Scale::DrawGLBox(struct GLContext *glcontext) {
    VRMLState st=VRMLState();
    st.glcontext=glcontext;
    // double x,y,z;
    // scaleFactor.Get(x,y,z);
    // glScaled(x,y,z);
    DrawGL(&st);
}
// Separator
void Separator::DrawGLBox(struct GLContext *glcontext) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;

   glPushMatrix(); // Push the current position
   for (int i=0;i<Size();i++) {
       GetChild(i)->DrawGLBox(glcontext);
   };
   glPopMatrix();
}        
// ShapeHints
void ShapeHints::DrawGLBox(struct GLContext *glcontext) {
}
// Sphere
void Sphere::DrawGLBox(struct GLContext *glcontext) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;
   double r=radius;

   glBegin(GL_LINE_LOOP);
		glVertex3d(-r,-r,-r);
		glVertex3d(-r,r,-r);
		glVertex3d(r,r,-r);
		glVertex3d(r,-r,-r);
   glEnd();
   glBegin(GL_LINE_LOOP);
		glVertex3d(-r,-r,r);
		glVertex3d(-r,r,r);
		glVertex3d(r,r,r);
		glVertex3d(r,-r,r);
   glEnd();
   glBegin(GL_LINES);
		glVertex3d(-r,-r,-r);
		glVertex3d(-r,-r,r);
   glEnd();
   glBegin(GL_LINES);
		glVertex3d(r,-r,-r);
		glVertex3d(r,-r,r);
   glEnd();
   glBegin(GL_LINES);
		glVertex3d(-r,r,-r);
		glVertex3d(-r,r,r);
   glEnd();
   glBegin(GL_LINES);
		glVertex3d(r,r,-r);
		glVertex3d(r,r,r);
   glEnd();

}
// SpotLight
void SpotLight::DrawGLBox(struct GLContext *glcontext) {
}
// Switch
void Switch::DrawGLBox(struct GLContext *glcontext) {
    if (whichChild!=-1) {
	GetChild(whichChild)->DrawGLBox(glcontext);
    };
}
// Texture
void Texture2::DrawGLBox(struct GLContext *glcontext) {
}
// Texture2Transform
void Texture2Transform::DrawGLBox(struct GLContext *glcontext) {
}
// TextureCoordinate2
void TextureCoordinate2::DrawGLBox(struct GLContext *glcontext) {
}
// Transform
void Transform::DrawGLBox(struct GLContext *glcontext) {
   VRMLState st=VRMLState();
   st.glcontext=glcontext;
   DrawGL(&st);
}
// TransformSeparator
void TransformSeparator::DrawGLBox(struct GLContext *glcontext) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;

   glPushMatrix(); // Push the current position
   for (int i=0;i<Size();i++) {
       GetChild(i)->DrawGLBox(glcontext);
   };
   glPopMatrix();
}
// Translation
void Translation::DrawGLBox(struct GLContext *glcontext) {
   VRMLState st=VRMLState();
   st.glcontext=glcontext;
   DrawGL(&st);
}
// WWWAnchor
void WWWAnchor::DrawGLBox(struct GLContext *glcontext) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;

   glPushMatrix(); // Push the current position
   for (int i=0;i<Size();i++) {
       GetChild(i)->DrawGLBox(glcontext);
   };
   glPopMatrix();
}
// WWWInline
void WWWInline::DrawGLBox(struct GLContext *glcontext) {
    if (in) in->DrawGLBox(glcontext);
}

// USE
void USE::DrawGLBox(struct GLContext *glcontext) {
    // VRMLNode *n=nn->Get(usename);
    if (reference!=NULL) reference->DrawGLBox(glcontext);
};
