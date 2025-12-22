#include <proto/Amigamesa.h>

// #include "StormMesaSupport.h"
#include <mui/GLArea_mcc.h>

#ifdef __cplusplus
extern "C" {
#endif
void gluOrtho2D_stub (struct GLContext *glcontext, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top);
void gluPerspective_stub (struct GLContext *glcontext, GLdouble fovy, GLdouble aspect, GLdouble near, GLdouble far);
int gluScaleImage_stub (struct GLContext *glcontext, GLenum format, GLint widthin, GLint heightin, GLenum typein, const void *datain, GLint widthout, GLint heightout, GLenum typeout, void *dataout);
void glTexGeni_stub (struct GLContext *glcontext, GLenum coord, GLenum pname, GLint param);
void glTexImage2D_stub (struct GLContext *glcontext, GLenum target, GLint level, GLint internalFormat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexParameteri_stub(struct GLContext *glcontext, GLenum target, GLenum pname, GLint param);
void glDrawPixels_stub (struct GLContext *glcontext, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);

//--- Transformation ---
void glRotated_stub (struct GLContext *glcontext, GLdouble angle, GLdouble x, GLdouble y, GLdouble z);

#ifdef __cplusplus
}
#endif
