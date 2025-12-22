#include <math.h>

#include <intuition/intuition.h>

#include <proto/Amigamesa.h>

#include "GL_stubs.h"

void gluOrtho2D_stub (struct GLContext *glcontext, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;

   gluOrtho2D(left,right,bottom,top);
}

void gluPerspective_stub (struct GLContext *glcontext, GLdouble fovy, GLdouble aspect, GLdouble near, GLdouble far) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;

   gluPerspective (fovy,aspect,near,far);
}

int gluScaleImage_stub (struct GLContext *glcontext, GLenum format, GLint widthin, GLint heightin, GLenum typein, const void *datain, GLint widthout, GLint heightout, GLenum typeout, void *dataout) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    return gluScaleImage(format,widthin,heightin,typein,datain,widthout,heightout,typeout,dataout);
}

void glTexGeni_stub (struct GLContext *glcontext, GLenum coord, GLenum pname, GLint param) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glTexGeni (coord,pname,param);
}
void glTexImage2D_stub (struct GLContext *glcontext, GLenum target, GLint level, GLint internalFormat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glTexImage2D (target,level,internalFormat,width,height,border,format,type,pixels);
}

void glTexParameteri_stub(struct GLContext *glcontext, GLenum target, GLenum pname, GLint param) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glTexParameteri(target,pname,param);
}

void glDrawPixels_stub (struct GLContext *glcontext, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glDrawPixels(width,height,format,type,pixels);
}

void glRotated_stub (struct GLContext *glcontext, GLdouble angle, GLdouble x, GLdouble y, GLdouble z) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glRotated(angle,x,y,z);
}
