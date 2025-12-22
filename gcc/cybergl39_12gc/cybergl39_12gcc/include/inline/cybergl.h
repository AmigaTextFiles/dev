#ifndef _INLINE_CYBERGL_H
#define _INLINE_CYBERGL_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef CYBERGL_BASE_NAME
#define CYBERGL_BASE_NAME CyberGLBase
#endif

/*
**
**	$VER: inline/cybergl.h 39.12 (12-Mar-1998)
**
**	created with  fd2pragma 2.63  by Dirk Stoecker
**
**	and slighty modified by
**	Sebastian Huebner <cyco@gmx.de> 08-Apr-1998
**
**
**
**
**-------------gl window related calls-----------------------**
**
*/
#define openGLWindowTagList(par1, par2, tags) \
	LP3(0x1E, GLvoid     *, openGLWindowTagList, GLint, par1, d0, GLint, par2, d1, struct TagItem *, tags, a0, \
	, CYBERGL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define openGLWindowTags(par1, par2, tags...) \
	({ULONG _tags[] = {tags}; openGLWindowTagList((par1), (par2), (struct TagItem *)_tags);})
#endif

#define closeGLWindow(last) \
	LP1NR(0x24, closeGLWindow, GLvoid *, last, a0, \
	, CYBERGL_BASE_NAME)

#define attachGLWindowTagList(par1, par2, par3, tags) \
	LP4(0x2A, GLvoid     *, attachGLWindowTagList, struct Window *, par1, a0, GLint, par2, d0, GLint, par3, d1, struct TagItem *, tags, a1, \
	, CYBERGL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define attachGLWindowTags(par1, par2, par3, tags...) \
	({ULONG _tags[] = {tags}; attachGLWindowTagList((par1), (par2), (par3), (struct TagItem *)_tags);})
#endif

#define disposeGLWindow(last) \
	LP1NR(0x30, disposeGLWindow, GLvoid *, last, a0, \
	, CYBERGL_BASE_NAME)

#define resizeGLWindow(par1, par2, last) \
	LP3NR(0x36, resizeGLWindow, GLvoid *, par1, a0, GLint, par2, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define getWindow(last) \
	LP1(0x3C, struct Window   *, getWindow, GLvoid *, last, a0, \
	, CYBERGL_BASE_NAME)

#define allocColor(par1, par2, par3, last) \
	LP4(0x42, GLubyte, allocColor, GLvoid *, par1, a0, GLubyte, par2, d0, GLubyte, par3, d1, GLubyte, last, d2, \
	, CYBERGL_BASE_NAME)

#define allocColorRange(par1, par2, par3, par4, par5, par6, par7, last) \
	LP8(0x48, GLubyte, allocColorRange, void *, par1, a0, GLubyte, par2, d0, GLubyte, par3, d1, GLubyte, par4, d2, GLubyte, par5, d3, GLubyte, par6, d4, GLubyte, par7, d5, GLubyte, last, d6, \
	, CYBERGL_BASE_NAME)

#define attachGLWndToRPTagList(par1, par2, par3, par4, tags) \
	LP5(0x4E, GLvoid     *, attachGLWndToRPTagList, struct Screen *, par1, a0, struct RastPort *, par2, a1, GLint, par3, d0, GLint, par4, d1, struct TagItem *, tags, a2, \
	, CYBERGL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define attachGLWndToRPTags(par1, par2, par3, par4, tags...) \
	({ULONG _tags[] = {tags}; attachGLWndToRPTagList((par1), (par2), (par3), (par4), (struct TagItem *)_tags);})
#endif

/*
**
**----------------------Contexts-----------------------------**
**
*/
#define glGetError() \
	LP0(0x66, GLenum, glGetError, \
	, CYBERGL_BASE_NAME)

#define glEnable(last) \
	LP1NR(0x6C, glEnable, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glDisable(last) \
	LP1NR(0x72, glDisable, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glIsEnabled(last) \
	LP1(0x78, GLboolean, glIsEnabled, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glGetBooleanv(par1, last) \
	LP2NR(0x7E, glGetBooleanv, GLenum, par1, d0, GLboolean *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetIntegerv(par1, last) \
	LP2NR(0x84, glGetIntegerv, GLenum, par1, d0, GLint     *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetFloatv(par1, last) \
	LP2NR(0x8A, glGetFloatv, GLenum, par1, d0, GLfloat   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetDoublev(par1, last) \
	LP2NR(0x90, glGetDoublev, GLenum, par1, d0, GLdouble  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetClipPlane(par1, last) \
	LP2NR(0x96, glGetClipPlane, GLenum, par1, d0, GLdouble  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetLightfv(par1, par2, last) \
	LP3NR(0x9C, glGetLightfv, GLenum, par1, d0, GLenum, par2, d1, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetLightiv(par1, par2, last) \
	LP3NR(0xA2, glGetLightiv, GLenum, par1, d0, GLenum, par2, d1, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetMaterialfv(par1, par2, last) \
	LP3NR(0xA8, glGetMaterialfv, GLenum, par1, d0, GLenum, par2, d1, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetMaterialiv(par1, par2, last) \
	LP3NR(0xAE, glGetMaterialiv, GLenum, par1, d0, GLenum, par2, d1, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexGendv(par1, par2, last) \
	LP3NR(0xB4, glGetTexGendv, GLenum, par1, d0, GLenum, par2, d1, GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexGenfv(par1, par2, last) \
	LP3NR(0xBA, glGetTexGenfv, GLenum, par1, d0, GLenum, par2, d1, GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexGeniv(par1, par2, last) \
	LP3NR(0xC0, glGetTexGeniv, GLenum, par1, d0, GLenum, par2, d1, GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetPixelMapfv(par1, last) \
	LP2NR(0xC6, glGetPixelMapfv, GLenum, par1, d0, GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetPixelMapuiv(par1, last) \
	LP2NR(0xCC, glGetPixelMapuiv, GLenum, par1, d0, GLuint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetPixelMapusv(par1, last) \
	LP2NR(0xD2, glGetPixelMapusv, GLenum, par1, d0, GLushort *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexEnvfv(par1, par2, last) \
	LP3NR(0xD8, glGetTexEnvfv, GLenum, par1, d0, GLenum, par2, d1, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexEnviv(par1, par2, last) \
	LP3NR(0xDE, glGetTexEnviv, GLenum, par1, d0, GLenum, par2, d1, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexLevelParameterfv(par1, par2, par3, last) \
	LP4NR(0xE4, glGetTexLevelParameterfv, GLenum, par1, d0, GLint, par2, d1, GLenum, par3, d2, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexLevelParameteriv(par1, par2, par3, last) \
	LP4NR(0xEA, glGetTexLevelParameteriv, GLenum, par1, d0, GLint, par2, d1, GLenum, par3, d2, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexParameterfv(par1, par2, last) \
	LP3NR(0xF0, glGetTexParameterfv, GLenum, par1, d0, GLenum, par2, d1, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexParameteriv(par1, par2, last) \
	LP3NR(0xF6, glGetTexParameteriv, GLenum, par1, d0, GLenum, par2, d1, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetTexImage(par1, par2, par3, par4, last) \
	LP5NR(0xFC, glGetTexImage, GLenum, par1, d0, GLint, par2, d1, GLenum, par3, d2, GLenum, par4, d3, GLvoid *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glGetString(last) \
	LP1(0x102, GLubyte   *, glGetString, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glPushAttrib(last) \
	LP1NR(0x108, glPushAttrib, GLbitfield, last, d0, \
	, CYBERGL_BASE_NAME)

#define glPopAttrib() \
	LP0NR(0x10E, glPopAttrib, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Primitives---------------------------**
**
*/
#define glBegin(last) \
	LP1NR(0x114, glBegin, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glEnd() \
	LP0NR(0x11A, glEnd, \
	, CYBERGL_BASE_NAME)

#define glVertex2s(par1, last) \
	LP2NR(0x120, glVertex2s, GLshort, par1, d0, GLshort, last, d1, \
	, CYBERGL_BASE_NAME)

#define glVertex2i(par1, last) \
	LP2NR(0x126, glVertex2i, GLint, par1, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define glVertex2f(par1, last) \
	LP2NR(0x12C, glVertex2f, GLfloat, par1, fp0, GLfloat, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glVertex2d(par1, last) \
	LP2NR(0x132, glVertex2d, GLdouble, par1, fp0, GLdouble, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glVertex3s(par1, par2, last) \
	LP3NR(0x138, glVertex3s, GLshort, par1, d0, GLshort, par2, d1, GLshort, last, d2, \
	, CYBERGL_BASE_NAME)

#define glVertex3i(par1, par2, last) \
	LP3NR(0x13E, glVertex3i, GLint, par1, d0, GLint, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glVertex3f(par1, par2, last) \
	LP3NR(0x144, glVertex3f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glVertex3d(par1, par2, last) \
	LP3NR(0x14A, glVertex3d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glVertex4s(par1, par2, par3, last) \
	LP4NR(0x150, glVertex4s, GLshort, par1, d0, GLshort, par2, d1, GLshort, par3, d2, GLshort, last, d3, \
	, CYBERGL_BASE_NAME)

#define glVertex4i(par1, par2, par3, last) \
	LP4NR(0x156, glVertex4i, GLint, par1, d0, GLint, par2, d1, GLint, par3, d2, GLint, last, d3, \
	, CYBERGL_BASE_NAME)

#define glVertex4f(par1, par2, par3, last) \
	LP4NR(0x15C, glVertex4f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, par3, fp2, GLfloat, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glVertex4d(par1, par2, par3, last) \
	LP4NR(0x162, glVertex4d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glVertex2sv(last) \
	LP1NR(0x168, glVertex2sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex2iv(last) \
	LP1NR(0x16E, glVertex2iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex2fv(last) \
	LP1NR(0x174, glVertex2fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex2dv(last) \
	LP1NR(0x17A, glVertex2dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex3sv(last) \
	LP1NR(0x180, glVertex3sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex3iv(last) \
	LP1NR(0x186, glVertex3iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex3fv(last) \
	LP1NR(0x18C, glVertex3fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex3dv(last) \
	LP1NR(0x192, glVertex3dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex4sv(last) \
	LP1NR(0x198, glVertex4sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex4iv(last) \
	LP1NR(0x19E, glVertex4iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex4fv(last) \
	LP1NR(0x1A4, glVertex4fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glVertex4dv(last) \
	LP1NR(0x1AA, glVertex4dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1s(last) \
	LP1NR(0x1B0, glTexCoord1s, GLshort, last, d0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1i(last) \
	LP1NR(0x1B6, glTexCoord1i, GLint, last, d0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1f(last) \
	LP1NR(0x1BC, glTexCoord1f, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1d(last) \
	LP1NR(0x1C2, glTexCoord1d, GLdouble, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2s(par1, last) \
	LP2NR(0x1C8, glTexCoord2s, GLshort, par1, d0, GLshort, last, d1, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2i(par1, last) \
	LP2NR(0x1CE, glTexCoord2i, GLint, par1, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2f(par1, last) \
	LP2NR(0x1D4, glTexCoord2f, GLfloat, par1, fp0, GLfloat, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2d(par1, last) \
	LP2NR(0x1DA, glTexCoord2d, GLdouble, par1, fp0, GLdouble, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3s(par1, par2, last) \
	LP3NR(0x1E0, glTexCoord3s, GLshort, par1, d0, GLshort, par2, d1, GLshort, last, d2, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3i(par1, par2, last) \
	LP3NR(0x1E6, glTexCoord3i, GLint, par1, d0, GLint, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3f(par1, par2, last) \
	LP3NR(0x1EC, glTexCoord3f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3d(par1, par2, last) \
	LP3NR(0x1F2, glTexCoord3d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4s(par1, par2, par3, last) \
	LP4NR(0x1F8, glTexCoord4s, GLshort, par1, d0, GLshort, par2, d1, GLshort, par3, d2, GLshort, last, d3, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4i(par1, par2, par3, last) \
	LP4NR(0x1FE, glTexCoord4i, GLint, par1, d0, GLint, par2, d1, GLint, par3, d2, GLint, last, d3, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4f(par1, par2, par3, last) \
	LP4NR(0x204, glTexCoord4f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, par3, fp2, GLfloat, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4d(par1, par2, par3, last) \
	LP4NR(0x20A, glTexCoord4d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1sv(last) \
	LP1NR(0x210, glTexCoord1sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1iv(last) \
	LP1NR(0x216, glTexCoord1iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1fv(last) \
	LP1NR(0x21C, glTexCoord1fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord1dv(last) \
	LP1NR(0x222, glTexCoord1dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2sv(last) \
	LP1NR(0x228, glTexCoord2sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2iv(last) \
	LP1NR(0x22E, glTexCoord2iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2fv(last) \
	LP1NR(0x234, glTexCoord2fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord2dv(last) \
	LP1NR(0x23A, glTexCoord2dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3sv(last) \
	LP1NR(0x240, glTexCoord3sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3iv(last) \
	LP1NR(0x246, glTexCoord3iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3fv(last) \
	LP1NR(0x24C, glTexCoord3fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord3dv(last) \
	LP1NR(0x252, glTexCoord3dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4sv(last) \
	LP1NR(0x258, glTexCoord4sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4iv(last) \
	LP1NR(0x25E, glTexCoord4iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4fv(last) \
	LP1NR(0x264, glTexCoord4fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexCoord4dv(last) \
	LP1NR(0x26A, glTexCoord4dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glNormal3b(par1, par2, last) \
	LP3NR(0x270, glNormal3b, GLbyte, par1, d0, GLbyte, par2, d1, GLbyte, last, d2, \
	, CYBERGL_BASE_NAME)

#define glNormal3s(par1, par2, last) \
	LP3NR(0x276, glNormal3s, GLshort, par1, d0, GLshort, par2, d1, GLshort, last, d2, \
	, CYBERGL_BASE_NAME)

#define glNormal3i(par1, par2, last) \
	LP3NR(0x27C, glNormal3i, GLint, par1, d0, GLint, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glNormal3f(par1, par2, last) \
	LP3NR(0x282, glNormal3f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glNormal3d(par1, par2, last) \
	LP3NR(0x288, glNormal3d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glNormal3bv(last) \
	LP1NR(0x28E, glNormal3bv, const GLbyte   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glNormal3sv(last) \
	LP1NR(0x294, glNormal3sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glNormal3iv(last) \
	LP1NR(0x29A, glNormal3iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glNormal3fv(last) \
	LP1NR(0x2A0, glNormal3fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glNormal3dv(last) \
	LP1NR(0x2A6, glNormal3dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3b(par1, par2, last) \
	LP3NR(0x2AC, glColor3b, GLbyte, par1, d0, GLbyte, par2, d1, GLbyte, last, d2, \
	, CYBERGL_BASE_NAME)

#define glColor3s(par1, par2, last) \
	LP3NR(0x2B2, glColor3s, GLshort, par1, d0, GLshort, par2, d1, GLshort, last, d2, \
	, CYBERGL_BASE_NAME)

#define glColor3i(par1, par2, last) \
	LP3NR(0x2B8, glColor3i, GLint, par1, d0, GLint, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glColor3f(par1, par2, last) \
	LP3NR(0x2BE, glColor3f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glColor3d(par1, par2, last) \
	LP3NR(0x2C4, glColor3d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glColor3ub(par1, par2, last) \
	LP3NR(0x2CA, glColor3ub, GLubyte, par1, d0, GLubyte, par2, d1, GLubyte, last, d2, \
	, CYBERGL_BASE_NAME)

#define glColor3us(par1, par2, last) \
	LP3NR(0x2D0, glColor3us, GLushort, par1, d0, GLushort, par2, d1, GLushort, last, d2, \
	, CYBERGL_BASE_NAME)

#define glColor3ui(par1, par2, last) \
	LP3NR(0x2D6, glColor3ui, GLuint, par1, d0, GLuint, par2, d1, GLuint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glColor4b(par1, par2, par3, last) \
	LP4NR(0x2DC, glColor4b, GLbyte, par1, d0, GLbyte, par2, d1, GLbyte, par3, d2, GLbyte, last, d3, \
	, CYBERGL_BASE_NAME)

#define glColor4s(par1, par2, par3, last) \
	LP4NR(0x2E2, glColor4s, GLshort, par1, d0, GLshort, par2, d1, GLshort, par3, d2, GLshort, last, d3, \
	, CYBERGL_BASE_NAME)

#define glColor4i(par1, par2, par3, last) \
	LP4NR(0x2E8, glColor4i, GLint, par1, d0, GLint, par2, d1, GLint, par3, d2, GLint, last, d3, \
	, CYBERGL_BASE_NAME)

#define glColor4f(par1, par2, par3, last) \
	LP4NR(0x2EE, glColor4f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, par3, fp2, GLfloat, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glColor4d(par1, par2, par3, last) \
	LP4NR(0x2F4, glColor4d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glColor4ub(par1, par2, par3, last) \
	LP4NR(0x2FA, glColor4ub, GLubyte, par1, d0, GLubyte, par2, d1, GLubyte, par3, d2, GLubyte, last, d3, \
	, CYBERGL_BASE_NAME)

#define glColor4us(par1, par2, par3, last) \
	LP4NR(0x300, glColor4us, GLushort, par1, d0, GLushort, par2, d1, GLushort, par3, d2, GLushort, last, d3, \
	, CYBERGL_BASE_NAME)

#define glColor4ui(par1, par2, par3, last) \
	LP4NR(0x306, glColor4ui, GLuint, par1, d0, GLuint, par2, d1, GLuint, par3, d2, GLuint, last, d3, \
	, CYBERGL_BASE_NAME)

#define glColor3bv(last) \
	LP1NR(0x30C, glColor3bv, const GLbyte   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3sv(last) \
	LP1NR(0x312, glColor3sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3iv(last) \
	LP1NR(0x318, glColor3iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3fv(last) \
	LP1NR(0x31E, glColor3fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3dv(last) \
	LP1NR(0x324, glColor3dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3ubv(last) \
	LP1NR(0x32A, glColor3ubv, const GLubyte  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3usv(last) \
	LP1NR(0x330, glColor3usv, const GLushort *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor3uiv(last) \
	LP1NR(0x336, glColor3uiv, const GLuint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4bv(last) \
	LP1NR(0x33C, glColor4bv, const GLbyte   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4sv(last) \
	LP1NR(0x342, glColor4sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4iv(last) \
	LP1NR(0x348, glColor4iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4fv(last) \
	LP1NR(0x34E, glColor4fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4dv(last) \
	LP1NR(0x354, glColor4dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4ubv(last) \
	LP1NR(0x35A, glColor4ubv, const GLubyte  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4usv(last) \
	LP1NR(0x360, glColor4usv, const GLushort *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColor4uiv(last) \
	LP1NR(0x366, glColor4uiv, const GLuint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glIndexs(last) \
	LP1NR(0x36C, glIndexs, GLshort, last, d0, \
	, CYBERGL_BASE_NAME)

#define glIndexi(last) \
	LP1NR(0x372, glIndexi, GLint, last, d0, \
	, CYBERGL_BASE_NAME)

#define glIndexf(last) \
	LP1NR(0x378, glIndexf, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glIndexd(last) \
	LP1NR(0x37E, glIndexd, GLdouble, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glIndexsv(last) \
	LP1NR(0x384, glIndexsv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glIndexiv(last) \
	LP1NR(0x38A, glIndexiv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glIndexfv(last) \
	LP1NR(0x390, glIndexfv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glIndexdv(last) \
	LP1NR(0x396, glIndexdv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRects(par1, par2, par3, last) \
	LP4NR(0x39C, glRects, GLshort, par1, d0, GLshort, par2, d1, GLshort, par3, d2, GLshort, last, d3, \
	, CYBERGL_BASE_NAME)

#define glRecti(par1, par2, par3, last) \
	LP4NR(0x3A2, glRecti, GLint, par1, d0, GLint, par2, d1, GLint, par3, d2, GLint, last, d3, \
	, CYBERGL_BASE_NAME)

#define glRectf(par1, par2, par3, last) \
	LP4NR(0x3A8, glRectf, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, par3, fp2, GLfloat, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glRectd(par1, par2, par3, last) \
	LP4NR(0x3AE, glRectd, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glRectsv(par1, last) \
	LP2NR(0x3B4, glRectsv, const GLshort  *, par1, a0, const GLshort  *, last, a1, \
	, CYBERGL_BASE_NAME)

#define glRectiv(par1, last) \
	LP2NR(0x3BA, glRectiv, const GLint    *, par1, a0, const GLint    *, last, a1, \
	, CYBERGL_BASE_NAME)

#define glRectfv(par1, last) \
	LP2NR(0x3C0, glRectfv, const GLfloat  *, par1, a0, const GLfloat  *, last, a1, \
	, CYBERGL_BASE_NAME)

#define glRectdv(par1, last) \
	LP2NR(0x3C6, glRectdv, const GLdouble *, par1, a0, const GLdouble *, last, a1, \
	, CYBERGL_BASE_NAME)

#define glEdgeFlag(last) \
	LP1NR(0x3CC, glEdgeFlag, GLboolean, last, d0, \
	, CYBERGL_BASE_NAME)

#define glEdgeFlagv(last) \
	LP1NR(0x3D2, glEdgeFlagv, const GLboolean *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2s(par1, last) \
	LP2NR(0x3D8, glRasterPos2s, GLshort, par1, d0, GLshort, last, d1, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2i(par1, last) \
	LP2NR(0x3DE, glRasterPos2i, GLint, par1, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2f(par1, last) \
	LP2NR(0x3E4, glRasterPos2f, GLfloat, par1, fp0, GLfloat, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2d(par1, last) \
	LP2NR(0x3EA, glRasterPos2d, GLdouble, par1, fp0, GLdouble, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3s(par1, par2, last) \
	LP3NR(0x3F0, glRasterPos3s, GLshort, par1, d0, GLshort, par2, d1, GLshort, last, d2, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3i(par1, par2, last) \
	LP3NR(0x3F6, glRasterPos3i, GLint, par1, d0, GLint, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3f(par1, par2, last) \
	LP3NR(0x3FC, glRasterPos3f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3d(par1, par2, last) \
	LP3NR(0x402, glRasterPos3d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4s(par1, par2, par3, last) \
	LP4NR(0x408, glRasterPos4s, GLshort, par1, d0, GLshort, par2, d1, GLshort, par3, d2, GLshort, last, d3, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4i(par1, par2, par3, last) \
	LP4NR(0x40E, glRasterPos4i, GLint, par1, d0, GLint, par2, d1, GLint, par3, d2, GLint, last, d3, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4f(par1, par2, par3, last) \
	LP4NR(0x414, glRasterPos4f, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, par3, fp2, GLfloat, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4d(par1, par2, par3, last) \
	LP4NR(0x41A, glRasterPos4d, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2sv(last) \
	LP1NR(0x420, glRasterPos2sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2iv(last) \
	LP1NR(0x426, glRasterPos2iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2fv(last) \
	LP1NR(0x42C, glRasterPos2fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos2dv(last) \
	LP1NR(0x432, glRasterPos2dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3sv(last) \
	LP1NR(0x438, glRasterPos3sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3iv(last) \
	LP1NR(0x43E, glRasterPos3iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3fv(last) \
	LP1NR(0x444, glRasterPos3fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos3dv(last) \
	LP1NR(0x44A, glRasterPos3dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4sv(last) \
	LP1NR(0x450, glRasterPos4sv, const GLshort  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4iv(last) \
	LP1NR(0x456, glRasterPos4iv, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4fv(last) \
	LP1NR(0x45C, glRasterPos4fv, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glRasterPos4dv(last) \
	LP1NR(0x462, glRasterPos4dv, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Transforming-------------------------**
**
*/
#define glDepthRange(par1, last) \
	LP2NR(0x468, glDepthRange, GLclampd, par1, fp0, GLclampd, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glViewport(par1, par2, par3, last) \
	LP4NR(0x46E, glViewport, GLint, par1, d0, GLint, par2, d1, GLsizei, par3, d2, GLsizei, last, d3, \
	, CYBERGL_BASE_NAME)

#define glMatrixMode(last) \
	LP1NR(0x474, glMatrixMode, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glLoadMatrixf(last) \
	LP1NR(0x47A, glLoadMatrixf, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glLoadMatrixd(last) \
	LP1NR(0x480, glLoadMatrixd, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glMultMatrixf(last) \
	LP1NR(0x486, glMultMatrixf, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glMultMatrixd(last) \
	LP1NR(0x48C, glMultMatrixd, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glLoadIdentity() \
	LP0NR(0x492, glLoadIdentity, \
	, CYBERGL_BASE_NAME)

#define glRotatef(par1, par2, par3, last) \
	LP4NR(0x498, glRotatef, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, par3, fp2, GLfloat, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glRotated(par1, par2, par3, last) \
	LP4NR(0x49E, glRotated, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glTranslatef(par1, par2, last) \
	LP3NR(0x4A4, glTranslatef, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glTranslated(par1, par2, last) \
	LP3NR(0x4AA, glTranslated, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glScalef(par1, par2, last) \
	LP3NR(0x4B0, glScalef, GLfloat, par1, fp0, GLfloat, par2, fp1, GLfloat, last, fp2, \
	, CYBERGL_BASE_NAME)

#define glScaled(par1, par2, last) \
	LP3NR(0x4B6, glScaled, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, last, fp2, \
	, CYBERGL_BASE_NAME)

#ifndef GL_APICOMPATIBLE
#define glFrustum(last) \
	LP1NR(0x4BC, glFrustum, const GLfrustum *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glOrtho(last) \
	LP1NR(0x4C2, glOrtho, const GLortho *, last, a0, \
	, CYBERGL_BASE_NAME)
#endif /* !GL_APICOMPATIBLE */

#define glPushMatrix() \
	LP0NR(0x4C8, glPushMatrix, \
	, CYBERGL_BASE_NAME)

#define glPopMatrix() \
	LP0NR(0x4CE, glPopMatrix, \
	, CYBERGL_BASE_NAME)

#define glOrtho2D(par1, par2, par3, last) \
	LP4NR(0x4D4, glOrtho2D, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#ifndef GL_APICOMPATIBLE
#define glProject(last) \
	LP1(0x4DA, GLboolean, glProject, const GLproject *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glUnProject(last) \
	LP1(0x4E0, GLboolean, glUnProject, const GLunProject *, last, a0, \
	, CYBERGL_BASE_NAME)
#endif /* !GL_APICOMPATIBLE */

#define glPerspective(par1, par2, par3, last) \
	LP4NR(0x4E6, glPerspective, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

#ifndef GL_APICOMPATIBLE
#define glLookAt(last) \
	LP1NR(0x4EC, glLookAt, const GLlookAt *, last, a0, \
	, CYBERGL_BASE_NAME)
#endif /* !GL_APICOMPATIBLE */

#define glPickMatrix(par1, par2, par3, last) \
	LP4NR(0x4F2, glPickMatrix, GLdouble, par1, fp0, GLdouble, par2, fp1, GLdouble, par3, fp2, GLdouble, last, fp3, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Clipping-----------------------------**
**
*/
#define glClipPlane(par1, last) \
	LP2NR(0x4F8, glClipPlane, GLenum, par1, d0, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Drawing------------------------------**
**
*/
#define glClear(last) \
	LP1NR(0x4FE, glClear, GLbitfield, last, d0, \
	, CYBERGL_BASE_NAME)

#define glClearColor(par1, par2, par3, last) \
	LP4NR(0x504, glClearColor, GLclampf, par1, fp0, GLclampf, par2, fp1, GLclampf, par3, fp2, GLclampf, last, fp3, \
	, CYBERGL_BASE_NAME)

#define glClearIndex(last) \
	LP1NR(0x50A, glClearIndex, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glClearDepth(last) \
	LP1NR(0x510, glClearDepth, GLclampd, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glFlush() \
	LP0NR(0x516, glFlush, \
	, CYBERGL_BASE_NAME)

#define glFinish() \
	LP0NR(0x51C, glFinish, \
	, CYBERGL_BASE_NAME)

#define glHint(par1, last) \
	LP2NR(0x522, glHint, GLenum, par1, d0, GLenum, last, d1, \
	, CYBERGL_BASE_NAME)

#define glDrawBuffer(last) \
	LP1NR(0x528, glDrawBuffer, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glFogf(par1, last) \
	LP2NR(0x52E, glFogf, GLenum, par1, d0, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glFogi(par1, last) \
	LP2NR(0x534, glFogi, GLenum, par1, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define glFogfv(par1, last) \
	LP2NR(0x53A, glFogfv, GLenum, par1, d0, const GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glFogiv(par1, last) \
	LP2NR(0x540, glFogiv, GLenum, par1, d0, const GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glDepthFunc(last) \
	LP1NR(0x546, glDepthFunc, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glPolygonMode(par1, last) \
	LP2NR(0x54C, glPolygonMode, GLenum, par1, d0, GLenum, last, d1, \
	, CYBERGL_BASE_NAME)

#define glShadeModel(last) \
	LP1NR(0x552, glShadeModel, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glCullFace(last) \
	LP1NR(0x558, glCullFace, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glFrontFace(last) \
	LP1NR(0x55E, glFrontFace, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Selection----------------------------**
**
*/
#define glRenderMode(last) \
	LP1(0x564, GLint, glRenderMode, GLenum, last, d0, \
	, CYBERGL_BASE_NAME)

#define glInitNames() \
	LP0NR(0x56A, glInitNames, \
	, CYBERGL_BASE_NAME)

#define glLoadName(last) \
	LP1NR(0x570, glLoadName, GLuint, last, d0, \
	, CYBERGL_BASE_NAME)

#define glPushName(last) \
	LP1NR(0x576, glPushName, GLuint, last, d0, \
	, CYBERGL_BASE_NAME)

#define glPopName() \
	LP0NR(0x57C, glPopName, \
	, CYBERGL_BASE_NAME)

#define glSelectBuffer(par1, last) \
	LP2NR(0x582, glSelectBuffer, GLsizei, par1, d0, GLuint *, last, a0, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Lighting-----------------------------**
**
*/
#define glLightf(par1, par2, last) \
	LP3NR(0x588, glLightf, GLenum, par1, d0, GLenum, par2, d1, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glLighti(par1, par2, last) \
	LP3NR(0x58E, glLighti, GLenum, par1, d0, GLenum, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glLightfv(par1, par2, last) \
	LP3NR(0x594, glLightfv, GLenum, par1, d0, GLenum, par2, d1, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glLightiv(par1, par2, last) \
	LP3NR(0x59A, glLightiv, GLenum, par1, d0, GLenum, par2, d1, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glLightModelf(par1, last) \
	LP2NR(0x5A0, glLightModelf, GLenum, par1, d0, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glLightModeli(par1, last) \
	LP2NR(0x5A6, glLightModeli, GLenum, par1, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define glLightModelfv(par1, last) \
	LP2NR(0x5AC, glLightModelfv, GLenum, par1, d0, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glLightModeliv(par1, last) \
	LP2NR(0x5B2, glLightModeliv, GLenum, par1, d0, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glMaterialf(par1, par2, last) \
	LP3NR(0x5B8, glMaterialf, GLenum, par1, d0, GLenum, par2, d1, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glMateriali(par1, par2, last) \
	LP3NR(0x5BE, glMateriali, GLenum, par1, d0, GLenum, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glMaterialfv(par1, par2, last) \
	LP3NR(0x5C4, glMaterialfv, GLenum, par1, d0, GLenum, par2, d1, GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glMaterialiv(par1, par2, last) \
	LP3NR(0x5CA, glMaterialiv, GLenum, par1, d0, GLenum, par2, d1, GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glColorMaterial(par1, last) \
	LP2NR(0x5D0, glColorMaterial, GLenum, par1, d0, GLenum, last, d1, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Texturing----------------------------**
**
*/
#define glTexGeni(par1, par2, last) \
	LP3NR(0x5D6, glTexGeni, GLenum, par1, d0, GLenum, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glTexGenf(par1, par2, last) \
	LP3NR(0x5DC, glTexGenf, GLenum, par1, d0, GLenum, par2, d1, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glTexGend(par1, par2, last) \
	LP3NR(0x5E2, glTexGend, GLenum, par1, d0, GLenum, par2, d1, GLdouble, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glTexGeniv(par1, par2, last) \
	LP3NR(0x5E8, glTexGeniv, GLenum, par1, d0, GLenum, par2, d1, const GLint    *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexGenfv(par1, par2, last) \
	LP3NR(0x5EE, glTexGenfv, GLenum, par1, d0, GLenum, par2, d1, const GLfloat  *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexGendv(par1, par2, last) \
	LP3NR(0x5F4, glTexGendv, GLenum, par1, d0, GLenum, par2, d1, const GLdouble *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexEnvf(par1, par2, last) \
	LP3NR(0x5FA, glTexEnvf, GLenum, par1, d0, GLenum, par2, d1, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glTexEnvi(par1, par2, last) \
	LP3NR(0x600, glTexEnvi, GLenum, par1, d0, GLenum, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glTexEnvfv(par1, par2, last) \
	LP3NR(0x606, glTexEnvfv, GLenum, par1, d0, GLenum, par2, d1, const GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexEnviv(par1, par2, last) \
	LP3NR(0x60C, glTexEnviv, GLenum, par1, d0, GLenum, par2, d1, const GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexParameterf(par1, par2, last) \
	LP3NR(0x612, glTexParameterf, GLenum, par1, d0, GLenum, par2, d1, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glTexParameteri(par1, par2, last) \
	LP3NR(0x618, glTexParameteri, GLenum, par1, d0, GLenum, par2, d1, GLint, last, d2, \
	, CYBERGL_BASE_NAME)

#define glTexParameterfv(par1, par2, last) \
	LP3NR(0x61E, glTexParameterfv, GLenum, par1, d0, GLenum, par2, d1, const GLfloat *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexParameteriv(par1, par2, last) \
	LP3NR(0x624, glTexParameteriv, GLenum, par1, d0, GLenum, par2, d1, const GLint   *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexImage1D(par1, par2, par3, par4, par5, par6, par7, last) \
	LP8NR(0x62A, glTexImage1D, GLenum, par1, d0, GLint, par2, d1, GLint, par3, d2, GLsizei, par4, d3, GLint, par5, d4, GLenum, par6, d5, GLenum, par7, d6, const GLvoid *, last, a0, \
	, CYBERGL_BASE_NAME)

#define glTexImage2D(par1, par2, par3, par4, par5, par6, par7, par8, last) \
	LP9NR(0x630, glTexImage2D, GLenum, par1, d0, GLint, par2, d1, GLint, par3, d2, GLsizei, par4, d3, GLsizei, par5, d4, GLint, par6, d5, GLenum, par7, d6, GLenum, par8, d7, const GLvoid *, last, a0, \
	, CYBERGL_BASE_NAME)

/*
**
**----------------------Images-------------------------------**
**
*/
#define glPixelStorei(par1, last) \
	LP2NR(0x636, glPixelStorei, GLenum, par1, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define glPixelStoref(par1, last) \
	LP2NR(0x63C, glPixelStoref, GLenum, par1, d0, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glPixelTransferi(par1, last) \
	LP2NR(0x642, glPixelTransferi, GLenum, par1, d0, GLint, last, d1, \
	, CYBERGL_BASE_NAME)

#define glPixelTransferf(par1, last) \
	LP2NR(0x648, glPixelTransferf, GLenum, par1, d0, GLfloat, last, fp0, \
	, CYBERGL_BASE_NAME)

#define glPixelMapuiv(par1, par2, last) \
	LP3NR(0x64E, glPixelMapuiv, GLenum, par1, d0, GLsizei, par2, d1, const GLuint, last, a0, \
	, CYBERGL_BASE_NAME)

#define glPixelMapusv(par1, par2, last) \
	LP3NR(0x654, glPixelMapusv, GLenum, par1, d0, GLsizei, par2, d1, const GLushort, last, a0, \
	, CYBERGL_BASE_NAME)

#define glPixelMapfv(par1, par2, last) \
	LP3NR(0x65A, glPixelMapfv, GLenum, par1, d0, GLsizei, par2, d1, const GLfloat, last, a0, \
	, CYBERGL_BASE_NAME)

#define glPixelZoom(par1, last) \
	LP2NR(0x660, glPixelZoom, GLfloat, par1, fp0, GLfloat, last, fp1, \
	, CYBERGL_BASE_NAME)

#define glDrawPixels(par1, par2, par3, par4, last) \
	LP5NR(0x666, glDrawPixels, GLsizei, par1, d0, GLsizei, par2, d1, GLenum, par3, d2, GLenum, par4, d3, const GLvoid *, last, a0, \
	, CYBERGL_BASE_NAME)

#ifndef GL_APICOMPATIBLE
#define glBitmap(last) \
	LP1NR(0x66C, glBitmap, const GLbitmap *, last, a0, \
	, CYBERGL_BASE_NAME)
#endif /* !GL_APICOMPATIBLE */

#endif /* !_INLINE_CYBERGL_H */
