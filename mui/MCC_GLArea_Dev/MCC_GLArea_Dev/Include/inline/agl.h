#ifndef _INLINE_AGL_H
#define _INLINE_AGL_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef AGL_BASE_NAME
#define AGL_BASE_NAME glBase
#endif

#define registerGL(ptr) \
	LP1NR(0x1E, registerGL, struct glreg *, ptr, a0, \
	, AGL_BASE_NAME)

#define AmigaMesaCreateContext(tagListptr) \
	LP1(0x24, struct amigamesa_context*, AmigaMesaCreateContext, struct TagItem *, tagListptr, a0, \
	, AGL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AmigaMesaCreateContextTags(tags...) \
	({ULONG _tags[] = {tags}; AmigaMesaCreateContext((struct TagItem *) _tags);})
#endif


#define AmigaMesaDestroyContext(str_amesa_context) \
	LP1NR(0x2A, AmigaMesaDestroyContext, struct amigamesa_context *, str_amesa_context, a0, \
	, AGL_BASE_NAME)

#define AmigaMesaCreateVisual(tagListptr) \
	LP1(0x30, struct amigamesa_visual*, AmigaMesaCreateVisual, struct TagItem *, tagListptr, a0, \
	, AGL_BASE_NAME)

#define AmigaMesaDestroyVisual(str_amesa_context) \
	LP1NR(0x36, AmigaMesaDestroyVisual, struct amigamesa_visual *, str_amesa_context, a0, \
	, AGL_BASE_NAME)

#define AmigaMesaMakeCurrent(str_amesa_context, str_amesa_buffer) \
	LP2NR(0x3C, AmigaMesaMakeCurrent, struct amigamesa_context *, str_amesa_context, a0, struct amigamesa_buffer *, str_amesa_buffer, a1, \
	, AGL_BASE_NAME)

#define AmigaMesaSwapBuffers(str_amesa_context) \
	LP1NR(0x42, AmigaMesaSwapBuffers, struct amigamesa_context *, str_amesa_context, a0, \
	, AGL_BASE_NAME)

#define AmigaMesaSetOneColor(str_amesa_context, index, r, g, b) \
	LP5NR(0x48, AmigaMesaSetOneColor, struct amigamesa_context *, str_amesa_context, a0, int, index, d0, float, r, fp0, float, g, fp1, float, b, fp2, \
	, AGL_BASE_NAME)

#define AmigaMesaSetRast(str_amesa_context, tagListptr) \
	LP2NR(0x4E, AmigaMesaSetRast, struct amigamesa_context *, str_amesa_context, a0, struct TagItem *, tagListptr, a1, \
	, AGL_BASE_NAME)

#define AmigaMesaGetConfig(str_amesa_visual, pname, params) \
	LP3NR(0x54, AmigaMesaGetConfig, struct amigamesa_visual *, str_amesa_visual, a0, GLenum, pname, d0, GLint*, params, a1, \
	, AGL_BASE_NAME)

#define glClearIndex(GLfloat) \
	LP1NR(0xB4, glClearIndex, GLfloat, GLfloat, fp0, \
	, AGL_BASE_NAME)

#define glClearColor(GLclampf_red, GLclampf_green, GLclampf_blue, GLclampf_alpha) \
	LP4NR(0xBA, glClearColor, GLclampf, GLclampf_red, fp0, GLclampf, GLclampf_green, fp1, GLclampf, GLclampf_blue, fp2, GLclampf, GLclampf_alpha, fp3, \
	, AGL_BASE_NAME)

#define glClear(GLbitfield_mask) \
	LP1NR(0xC0, glClear, GLbitfield, GLbitfield_mask, d0, \
	, AGL_BASE_NAME)

#define glIndexMask(GLuint_mask) \
	LP1NR(0xC6, glIndexMask, GLuint, GLuint_mask, d0, \
	, AGL_BASE_NAME)

#define glColorMask(GLboolean_red, GLboolean_green, GLboolean_blue, GLboolean_alpha) \
	LP4NR(0xCC, glColorMask, GLboolean, GLboolean_red, d0, GLboolean, GLboolean_green, d1, GLboolean, GLboolean_blue, d2, GLboolean, GLboolean_alpha, d3, \
	, AGL_BASE_NAME)

#define glAlphaFunc(GLenum_func, GLclampf_ref) \
	LP2NR(0xD2, glAlphaFunc, GLenum, GLenum_func, d0, GLclampf, GLclampf_ref, fp0, \
	, AGL_BASE_NAME)

#define glBlendFunc(GLenum_sfactor, GLenum_dfactor) \
	LP2NR(0xD8, glBlendFunc, GLenum, GLenum_sfactor, d0, GLenum, GLenum_dfactor, d1, \
	, AGL_BASE_NAME)

#define glLogicOp(GLenum_opcode) \
	LP1NR(0xDE, glLogicOp, GLenum, GLenum_opcode, d0, \
	, AGL_BASE_NAME)

#define glCullFace(GLenum_mode) \
	LP1NR(0xE4, glCullFace, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glFrontFace(GLenum_mode) \
	LP1NR(0xEA, glFrontFace, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glPointSize(GLfloat_size) \
	LP1NR(0xF0, glPointSize, GLfloat, GLfloat_size, fp0, \
	, AGL_BASE_NAME)

#define glLineWidth(GLfloat_width) \
	LP1NR(0xF6, glLineWidth, GLfloat, GLfloat_width, fp0, \
	, AGL_BASE_NAME)

#define glLineStipple(GLint_factor, GLushort_pattern) \
	LP2NR(0xFC, glLineStipple, GLint, GLint_factor, d0, GLushort, GLushort_pattern, d1, \
	, AGL_BASE_NAME)

#define glPolygonMode(GLenum_face, GLenum_mode) \
	LP2NR(0x102, glPolygonMode, GLenum, GLenum_face, d0, GLenum, GLenum_mode, d1, \
	, AGL_BASE_NAME)

#define glPolygonOffset(GLfloat_factor, GLfloat_units) \
	LP2NR(0x108, glPolygonOffset, GLfloat, GLfloat_factor, fp0, GLfloat, GLfloat_units, fp1, \
	, AGL_BASE_NAME)

#define glPolygonStipple(const_GLubyte_ptr_mask) \
	LP1NR(0x10E, glPolygonStipple, const GLubyte *, const_GLubyte_ptr_mask, a0, \
	, AGL_BASE_NAME)

#define glGetPolygonStipple(GLubyte_ptr_mask) \
	LP1NR(0x114, glGetPolygonStipple, GLubyte *, GLubyte_ptr_mask, a0, \
	, AGL_BASE_NAME)

#define glEdgeFlag(GLboolean_flag) \
	LP1NR(0x11A, glEdgeFlag, GLboolean, GLboolean_flag, d0, \
	, AGL_BASE_NAME)

#define glEdgeFlagv(const_GLboolean_ptr_flag) \
	LP1NR(0x120, glEdgeFlagv, const GLboolean *, const_GLboolean_ptr_flag, a0, \
	, AGL_BASE_NAME)

#define glScissor(GLint_x, GLint_y, GLsizei_width, GLsizei_height) \
	LP4NR(0x126, glScissor, GLint, GLint_x, d0, GLint, GLint_y, d1, GLsizei, GLsizei_width, d2, GLsizei, GLsizei_height, d3, \
	, AGL_BASE_NAME)

#define glClipPlane(GLenum_plane, const_GLdouble_ptr_equation) \
	LP2NR(0x12C, glClipPlane, GLenum, GLenum_plane, d0, const GLdouble *, const_GLdouble_ptr_equation, a0, \
	, AGL_BASE_NAME)

#define glGetClipPlane(GLenum_plane, GLdouble_ptr_equation) \
	LP2NR(0x132, glGetClipPlane, GLenum, GLenum_plane, d0, GLdouble *, GLdouble_ptr_equation, a0, \
	, AGL_BASE_NAME)

#define glDrawBuffer(GLenum_mode) \
	LP1NR(0x138, glDrawBuffer, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glReadBuffer(GLenum_mode) \
	LP1NR(0x13E, glReadBuffer, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glEnable(GLenum_cap) \
	LP1NR(0x144, glEnable, GLenum, GLenum_cap, d0, \
	, AGL_BASE_NAME)

#define glDisable(GLenum_cap) \
	LP1NR(0x14A, glDisable, GLenum, GLenum_cap, d0, \
	, AGL_BASE_NAME)

#define glIsEnabled(GLenum_cap) \
	LP1(0x150, GLboolean, glIsEnabled, GLenum, GLenum_cap, d0, \
	, AGL_BASE_NAME)

#define glEnableClientState(GLenum_cap) \
	LP1NR(0x156, glEnableClientState, GLenum, GLenum_cap, d0, \
	, AGL_BASE_NAME)

#define glDisableClientState(GLenum_cap) \
	LP1NR(0x15C, glDisableClientState, GLenum, GLenum_cap, d0, \
	, AGL_BASE_NAME)

#define glGetBooleanv(GLenum_pname, GLboolean_ptr_params) \
	LP2NR(0x162, glGetBooleanv, GLenum, GLenum_pname, d0, GLboolean *, GLboolean_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetDoublev(GLenum_pname, GLdouble_ptr_params) \
	LP2NR(0x168, glGetDoublev, GLenum, GLenum_pname, d0, GLdouble *, GLdouble_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetFloatv(GLenum_pname, GLfloat_ptr_params) \
	LP2NR(0x16E, glGetFloatv, GLenum, GLenum_pname, d0, GLfloat *, GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetIntegerv(GLenum_pname, GLint_ptr_params) \
	LP2NR(0x174, glGetIntegerv, GLenum, GLenum_pname, d0, GLint *, GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glPushAttrib(GLbitfield_mask) \
	LP1NR(0x17A, glPushAttrib, GLbitfield, GLbitfield_mask, d0, \
	, AGL_BASE_NAME)

#define glPopAttrib() \
	LP0NR(0x180, glPopAttrib, \
	, AGL_BASE_NAME)

#define glPushClientAttrib(GLbitfield_mask) \
	LP1NR(0x186, glPushClientAttrib, GLbitfield, GLbitfield_mask, d0, \
	, AGL_BASE_NAME)

#define glPopClientAttrib() \
	LP0NR(0x18C, glPopClientAttrib, \
	, AGL_BASE_NAME)

#define glRenderMode(GLenum_mode) \
	LP1(0x192, GLint, glRenderMode, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glGetError() \
	LP0(0x198, GLenum, glGetError, \
	, AGL_BASE_NAME)

#define glGetString(GLenum_name) \
	LP1(0x19E, const GLubyte*, glGetString, GLenum, GLenum_name, d0, \
	, AGL_BASE_NAME)

#define glFinish() \
	LP0NR(0x1A4, glFinish, \
	, AGL_BASE_NAME)

#define glFlush() \
	LP0NR(0x1AA, glFlush, \
	, AGL_BASE_NAME)

#define glHint(GLenum_target, GLenum_mode) \
	LP2NR(0x1B0, glHint, GLenum, GLenum_target, d0, GLenum, GLenum_mode, d1, \
	, AGL_BASE_NAME)

#define glClearDepth(GLclampd_depth) \
	LP1NR(0x1B6, glClearDepth, GLclampd, GLclampd_depth, fp0, \
	, AGL_BASE_NAME)

#define glDepthFunc(GLenum_func) \
	LP1NR(0x1BC, glDepthFunc, GLenum, GLenum_func, d0, \
	, AGL_BASE_NAME)

#define glDepthMask(GLbooleanflag) \
	LP1NR(0x1C2, glDepthMask, GLboolean, GLbooleanflag, d0, \
	, AGL_BASE_NAME)

#define glDepthRange(GLclampd_near_val, GLclampd_far_val) \
	LP2NR(0x1C8, glDepthRange, GLclampd, GLclampd_near_val, fp0, GLclampd, GLclampd_far_val, fp1, \
	, AGL_BASE_NAME)

#define glClearAccum(GLfloat_red, GLfloat_green, GLfloat_blue, GLfloat_alpha) \
	LP4NR(0x1CE, glClearAccum, GLfloat, GLfloat_red, fp0, GLfloat, GLfloat_green, fp1, GLfloat, GLfloat_blue, fp2, GLfloat, GLfloat_alpha, fp3, \
	, AGL_BASE_NAME)

#define glAccum(GLenum_op, GLfloat_value) \
	LP2NR(0x1D4, glAccum, GLenum, GLenum_op, d0, GLfloat, GLfloat_value, fp0, \
	, AGL_BASE_NAME)

#define glMatrixMode(GLenum_mode) \
	LP1NR(0x1DA, glMatrixMode, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glOrtho(GLdouble_left, GLdouble_right, GLdouble_bottom, GLdouble_top, GLdouble_near_val, GLdouble_far_val) \
	LP6NR(0x1E0, glOrtho, GLdouble, GLdouble_left, fp0, GLdouble, GLdouble_right, fp1, GLdouble, GLdouble_bottom, fp2, GLdouble, GLdouble_top, fp3, GLdouble, GLdouble_near_val, fp4, GLdouble, GLdouble_far_val, fp5, \
	, AGL_BASE_NAME)

#define glFrustum(GLdouble_left, GLdouble_right, GLdouble_bottom, GLdouble_top, GLdouble_near_val, GLdouble_far_val) \
	LP6NR(0x1E6, glFrustum, GLdouble, GLdouble_left, fp0, GLdouble, GLdouble_right, fp1, GLdouble, GLdouble_bottom, fp2, GLdouble, GLdouble_top, fp3, GLdouble, GLdouble_near_val, fp4, GLdouble, GLdouble_far_val, fp5, \
	, AGL_BASE_NAME)

#define glViewport(GLint_x, GLint_y, GLsizei_width, GLsizei_height) \
	LP4NR(0x1EC, glViewport, GLint, GLint_x, d0, GLint, GLint_y, d1, GLsizei, GLsizei_width, d2, GLsizei, GLsizei_height, d3, \
	, AGL_BASE_NAME)

#define glPushMatrix() \
	LP0NR(0x1F2, glPushMatrix, \
	, AGL_BASE_NAME)

#define glPopMatrix() \
	LP0NR(0x1F8, glPopMatrix, \
	, AGL_BASE_NAME)

#define glLoadIdentity() \
	LP0NR(0x1FE, glLoadIdentity, \
	, AGL_BASE_NAME)

#define glLoadMatrixd(const_GLdouble_ptr_m) \
	LP1NR(0x204, glLoadMatrixd, const GLdouble *, const_GLdouble_ptr_m, a0, \
	, AGL_BASE_NAME)

#define glLoadMatrixf(const_GLfloat_ptr_m) \
	LP1NR(0x20A, glLoadMatrixf, const GLfloat *, const_GLfloat_ptr_m, a0, \
	, AGL_BASE_NAME)

#define glMultMatrixd(const_GLdouble_ptr_m) \
	LP1NR(0x210, glMultMatrixd, const GLdouble *, const_GLdouble_ptr_m, a0, \
	, AGL_BASE_NAME)

#define glMultMatrixf(const_GLfloat_ptr_m) \
	LP1NR(0x216, glMultMatrixf, const GLfloat *, const_GLfloat_ptr_m, a0, \
	, AGL_BASE_NAME)

#define glRotated(GLdouble_angle, GLdouble_x, GLdouble_y, GLdouble_z) \
	LP4NR(0x21C, glRotated, GLdouble, GLdouble_angle, fp0, GLdouble, GLdouble_x, fp1, GLdouble, GLdouble_y, fp2, GLdouble, GLdouble_z, fp3, \
	, AGL_BASE_NAME)

#define glRotatef(GLfloat_angle, GLfloat_x, GLfloat_y, GLfloat_z) \
	LP4NR(0x222, glRotatef, GLfloat, GLfloat_angle, fp0, GLfloat, GLfloat_x, fp1, GLfloat, GLfloat_y, fp2, GLfloat, GLfloat_z, fp3, \
	, AGL_BASE_NAME)

#define glScaled(GLdouble_x, GLdouble_y, GLdouble_z) \
	LP3NR(0x228, glScaled, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, GLdouble, GLdouble_z, fp2, \
	, AGL_BASE_NAME)

#define glScalef(GLfloat_x, GLfloat_y, GLfloat_z) \
	LP3NR(0x22E, glScalef, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, GLfloat, GLfloat_z, fp2, \
	, AGL_BASE_NAME)

#define glTranslated(GLdouble_x, GLdouble_y, GLdouble_z) \
	LP3NR(0x234, glTranslated, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, GLdouble, GLdouble_z, fp2, \
	, AGL_BASE_NAME)

#define glTranslatef(GLfloat_x, GLfloat_y, GLfloat_z) \
	LP3NR(0x23A, glTranslatef, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, GLfloat, GLfloat_z, fp2, \
	, AGL_BASE_NAME)

#define glIsList(GLuint_list) \
	LP1(0x240, GLboolean, glIsList, GLuint, GLuint_list, d0, \
	, AGL_BASE_NAME)

#define glDeleteLists(GLuint_list, GLsizei_range) \
	LP2NR(0x246, glDeleteLists, GLuint, GLuint_list, d0, GLsizei, GLsizei_range, d1, \
	, AGL_BASE_NAME)

#define glGenLists(GLsizei_range) \
	LP1(0x24C, GLuint, glGenLists, GLsizei, GLsizei_range, d0, \
	, AGL_BASE_NAME)

#define glNewList(GLuint_list, GLenum_mode) \
	LP2NR(0x252, glNewList, GLuint, GLuint_list, d0, GLenum, GLenum_mode, d1, \
	, AGL_BASE_NAME)

#define glEndList() \
	LP0NR(0x258, glEndList, \
	, AGL_BASE_NAME)

#define glCallList(GLuint_list) \
	LP1NR(0x25E, glCallList, GLuint, GLuint_list, d0, \
	, AGL_BASE_NAME)

#define glCallLists(GLsizei_n, GLenum_type, const_GL_ptr_lists) \
	LP3NR(0x264, glCallLists, GLsizei, GLsizei_n, d0, GLenum, GLenum_type, d1, const GLvoid *, const_GL_ptr_lists, a0, \
	, AGL_BASE_NAME)

#define glListBase(GLuint_base) \
	LP1NR(0x26A, glListBase, GLuint, GLuint_base, d0, \
	, AGL_BASE_NAME)

#define glBegin(GLenum_mode) \
	LP1NR(0x270, glBegin, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glEnd() \
	LP0NR(0x276, glEnd, \
	, AGL_BASE_NAME)

#define glVertex2d(GLdouble_x, GLdouble_y) \
	LP2NR(0x27C, glVertex2d, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, \
	, AGL_BASE_NAME)

#define glVertex2f(GLfloat_x, GLfloat_y) \
	LP2NR(0x282, glVertex2f, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, \
	, AGL_BASE_NAME)

#define glVertex2i(GLint_x, GLint_y) \
	LP2NR(0x288, glVertex2i, GLint, GLint_x, d0, GLint, GLint_y, d1, \
	, AGL_BASE_NAME)

#define glVertex2s(GLshort_x, GLshort_y) \
	LP2NR(0x28E, glVertex2s, GLshort, GLshort_x, d0, GLshort, GLshort_y, d1, \
	, AGL_BASE_NAME)

#define glVertex3d(GLdouble_x, GLdouble_y, GLdouble_z) \
	LP3NR(0x294, glVertex3d, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, GLdouble, GLdouble_z, fp2, \
	, AGL_BASE_NAME)

#define glVertex3f(GLfloat_x, GLfloat_y, GLfloat_z) \
	LP3NR(0x29A, glVertex3f, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, GLfloat, GLfloat_z, fp2, \
	, AGL_BASE_NAME)

#define glVertex3i(GLint_x, GLint_y, GLint_z) \
	LP3NR(0x2A0, glVertex3i, GLint, GLint_x, d0, GLint, GLint_y, d1, GLint, GLint_z, d2, \
	, AGL_BASE_NAME)

#define glVertex3s(GLshort_x, GLshort_y, GLshort_z) \
	LP3NR(0x2A6, glVertex3s, GLshort, GLshort_x, d0, GLshort, GLshort_y, d1, GLshort, GLshort_z, d2, \
	, AGL_BASE_NAME)

#define glVertex4d(GLdouble_x, GLdouble_y, GLdouble_z, GLdouble_w) \
	LP4NR(0x2AC, glVertex4d, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, GLdouble, GLdouble_z, fp2, GLdouble, GLdouble_w, fp3, \
	, AGL_BASE_NAME)

#define glVertex4f(GLfloat_x, GLfloat_y, GLfloat_z, GLfloat_w) \
	LP4NR(0x2B2, glVertex4f, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, GLfloat, GLfloat_z, fp2, GLfloat, GLfloat_w, fp3, \
	, AGL_BASE_NAME)

#define glVertex4i(GLint_x, GLint_y, GLint_z, GLint_w) \
	LP4NR(0x2B8, glVertex4i, GLint, GLint_x, d0, GLint, GLint_y, d1, GLint, GLint_z, d2, GLint, GLint_w, d3, \
	, AGL_BASE_NAME)

#define glVertex4s(GLshort_x, GLshort_y, GLshort_z, GLshort_w) \
	LP4NR(0x2BE, glVertex4s, GLshort, GLshort_x, d0, GLshort, GLshort_y, d1, GLshort, GLshort_z, d2, GLshort, GLshort_w, d3, \
	, AGL_BASE_NAME)

#define glVertex2dv(const_GLdouble_ptr_v) \
	LP1NR(0x2C4, glVertex2dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex2fv(const_GLfloat_ptr_v) \
	LP1NR(0x2CA, glVertex2fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex2iv(const_GLint_ptr_v) \
	LP1NR(0x2D0, glVertex2iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex2sv(const_GLshort_ptr_v) \
	LP1NR(0x2D6, glVertex2sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex3dv(const_GLdouble_ptr_v) \
	LP1NR(0x2DC, glVertex3dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex3fv(const_GLfloat_ptr_v) \
	LP1NR(0x2E2, glVertex3fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex3iv(const_GLint_ptr_v) \
	LP1NR(0x2E8, glVertex3iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex3sv(const_GLshort_ptr_v) \
	LP1NR(0x2EE, glVertex3sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex4dv(const_GLdouble_ptr_v) \
	LP1NR(0x2F4, glVertex4dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex4fv(const_GLfloat_ptr_v) \
	LP1NR(0x2FA, glVertex4fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex4iv(const_GLint_ptr_v) \
	LP1NR(0x300, glVertex4iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glVertex4sv(const_GLshort_ptr_v) \
	LP1NR(0x306, glVertex4sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glNormal3b(GLbyte_nx, GLbyte_ny, GLbyte_nz) \
	LP3NR(0x30C, glNormal3b, GLbyte, GLbyte_nx, d0, GLbyte, GLbyte_ny, d1, GLbyte, GLbyte_nz, d2, \
	, AGL_BASE_NAME)

#define glNormal3d(GLdouble_nx, GLdouble_ny, GLdouble_nz) \
	LP3NR(0x312, glNormal3d, GLdouble, GLdouble_nx, fp0, GLdouble, GLdouble_ny, fp1, GLdouble, GLdouble_nz, fp2, \
	, AGL_BASE_NAME)

#define glNormal3f(GLfloat_nx, GLfloat_ny, GLfloat_nz) \
	LP3NR(0x318, glNormal3f, GLfloat, GLfloat_nx, fp0, GLfloat, GLfloat_ny, fp1, GLfloat, GLfloat_nz, fp2, \
	, AGL_BASE_NAME)

#define glNormal3i(GLint_nx, GLint_ny, GLint_nz) \
	LP3NR(0x31E, glNormal3i, GLint, GLint_nx, d0, GLint, GLint_ny, d1, GLint, GLint_nz, d2, \
	, AGL_BASE_NAME)

#define glNormal3s(GLshort_nx, GLshort_ny, GLshort_nz) \
	LP3NR(0x324, glNormal3s, GLshort, GLshort_nx, d0, GLshort, GLshort_ny, d1, GLshort, GLshort_nz, d2, \
	, AGL_BASE_NAME)

#define glNormal3bv(const_GLbyte_ptr_v) \
	LP1NR(0x32A, glNormal3bv, const GLbyte *, const_GLbyte_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glNormal3dv(const_GLdouble_ptr_v) \
	LP1NR(0x330, glNormal3dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glNormal3fv(const_GLfloat_ptr_v) \
	LP1NR(0x336, glNormal3fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glNormal3iv(const_GLint_ptr_v) \
	LP1NR(0x33C, glNormal3iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glNormal3sv(const_GLshort_ptr_v) \
	LP1NR(0x342, glNormal3sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glIndexd(GLdouble_c) \
	LP1NR(0x348, glIndexd, GLdouble, GLdouble_c, fp0, \
	, AGL_BASE_NAME)

#define glIndexf(GLfloat_c) \
	LP1NR(0x34E, glIndexf, GLfloat, GLfloat_c, fp0, \
	, AGL_BASE_NAME)

#define glIndexi(GLint_c) \
	LP1NR(0x354, glIndexi, GLint, GLint_c, d0, \
	, AGL_BASE_NAME)

#define glIndexs(GLshort_c) \
	LP1NR(0x35A, glIndexs, GLshort, GLshort_c, d0, \
	, AGL_BASE_NAME)

#define glIndexub(GLubyte_c) \
	LP1NR(0x360, glIndexub, GLubyte, GLubyte_c, d0, \
	, AGL_BASE_NAME)

#define glIndexdv(const_GLdouble_ptr_c) \
	LP1NR(0x366, glIndexdv, const GLdouble *, const_GLdouble_ptr_c, a0, \
	, AGL_BASE_NAME)

#define glIndexfv(const_GLfloat_ptr_c) \
	LP1NR(0x36C, glIndexfv, const GLfloat *, const_GLfloat_ptr_c, a0, \
	, AGL_BASE_NAME)

#define glIndexiv(const_GLint_ptr_c) \
	LP1NR(0x372, glIndexiv, const GLint *, const_GLint_ptr_c, a0, \
	, AGL_BASE_NAME)

#define glIndexsv(const_GLshort_ptr_c) \
	LP1NR(0x378, glIndexsv, const GLshort *, const_GLshort_ptr_c, a0, \
	, AGL_BASE_NAME)

#define glIndexubv(GLubyte_c) \
	LP1NR(0x37E, glIndexubv, const GLubyte *, GLubyte_c, a0, \
	, AGL_BASE_NAME)

#define glColor3b(GLbyte_red, GLbyte_green, GLbyte_blue) \
	LP3NR(0x384, glColor3b, GLbyte, GLbyte_red, d0, GLbyte, GLbyte_green, d1, GLbyte, GLbyte_blue, d2, \
	, AGL_BASE_NAME)

#define glColor3d(GLdouble_red, GLdouble_green, GLdouble_blue) \
	LP3NR(0x38A, glColor3d, GLdouble, GLdouble_red, fp0, GLdouble, GLdouble_green, fp1, GLdouble, GLdouble_blue, fp2, \
	, AGL_BASE_NAME)

#define glColor3f(GLfloat_red, GLfloat_green, GLfloat_blue) \
	LP3NR(0x390, glColor3f, GLfloat, GLfloat_red, fp0, GLfloat, GLfloat_green, fp1, GLfloat, GLfloat_blue, fp2, \
	, AGL_BASE_NAME)

#define glColor3i(GLint_red, GLint_green, GLint_blue) \
	LP3NR(0x396, glColor3i, GLint, GLint_red, d0, GLint, GLint_green, d1, GLint, GLint_blue, d2, \
	, AGL_BASE_NAME)

#define glColor3s(GLshort_red, GLshort_green, GLshort_blue) \
	LP3NR(0x39C, glColor3s, GLshort, GLshort_red, d0, GLshort, GLshort_green, d1, GLshort, GLshort_blue, d2, \
	, AGL_BASE_NAME)

#define glColor3ub(GLubyte_red, GLubyte_green, GLubyte_blue) \
	LP3NR(0x3A2, glColor3ub, GLubyte, GLubyte_red, d0, GLubyte, GLubyte_green, d1, GLubyte, GLubyte_blue, d2, \
	, AGL_BASE_NAME)

#define glColor3ui(GLuint_red, GLuint_green, GLuint_blue) \
	LP3NR(0x3A8, glColor3ui, GLuint, GLuint_red, d0, GLuint, GLuint_green, d1, GLuint, GLuint_blue, d2, \
	, AGL_BASE_NAME)

#define glColor3us(GLushort_red, GLushort_green, GLushort_blue) \
	LP3NR(0x3AE, glColor3us, GLushort, GLushort_red, d0, GLushort, GLushort_green, d1, GLushort, GLushort_blue, d2, \
	, AGL_BASE_NAME)

#define glColor4b(GLbyte_red, GLbyte_green, GLbyte_blue, GLbyte_alpha) \
	LP4NR(0x3B4, glColor4b, GLbyte, GLbyte_red, d0, GLbyte, GLbyte_green, d1, GLbyte, GLbyte_blue, d2, GLbyte, GLbyte_alpha, d3, \
	, AGL_BASE_NAME)

#define glColor4d(GLdouble_red, GLdouble_green, GLdouble_blue, GLdouble_alpha) \
	LP4NR(0x3BA, glColor4d, GLdouble, GLdouble_red, fp0, GLdouble, GLdouble_green, fp1, GLdouble, GLdouble_blue, fp2, GLdouble, GLdouble_alpha, fp3, \
	, AGL_BASE_NAME)

#define glColor4f(GLfloat_red, GLfloat_green, GLfloat_blue, GLfloat_alpha) \
	LP4NR(0x3C0, glColor4f, GLfloat, GLfloat_red, fp0, GLfloat, GLfloat_green, fp1, GLfloat, GLfloat_blue, fp2, GLfloat, GLfloat_alpha, fp3, \
	, AGL_BASE_NAME)

#define glColor4i(GLint_red, GLint_green, GLint_blue, GLint_alpha) \
	LP4NR(0x3C6, glColor4i, GLint, GLint_red, d0, GLint, GLint_green, d1, GLint, GLint_blue, d2, GLint, GLint_alpha, d3, \
	, AGL_BASE_NAME)

#define glColor4s(GLshort_red, GLshort_green, GLshort_blue, GLshort_alpha) \
	LP4NR(0x3CC, glColor4s, GLshort, GLshort_red, d0, GLshort, GLshort_green, d1, GLshort, GLshort_blue, d2, GLshort, GLshort_alpha, d3, \
	, AGL_BASE_NAME)

#define glColor4ub(GLubyte_red, GLubyte_green, GLubyte_blue, GLubyte_alpha) \
	LP4NR(0x3D2, glColor4ub, GLubyte, GLubyte_red, d0, GLubyte, GLubyte_green, d1, GLubyte, GLubyte_blue, d2, GLubyte, GLubyte_alpha, d3, \
	, AGL_BASE_NAME)

#define glColor4ui(GLuint_red, GLuint_green, GLuint_blue, GLuint_alpha) \
	LP4NR(0x3D8, glColor4ui, GLuint, GLuint_red, d0, GLuint, GLuint_green, d1, GLuint, GLuint_blue, d2, GLuint, GLuint_alpha, d3, \
	, AGL_BASE_NAME)

#define glColor4us(GLushort_red, GLushort_green, GLushort_blue, GLushort_alpha) \
	LP4NR(0x3DE, glColor4us, GLushort, GLushort_red, d0, GLushort, GLushort_green, d1, GLushort, GLushort_blue, d2, GLushort, GLushort_alpha, d3, \
	, AGL_BASE_NAME)

#define glColor3bv(const_GLbyte_ptr_v) \
	LP1NR(0x3E4, glColor3bv, const GLbyte *, const_GLbyte_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor3dv(const_GLdouble_ptr_v) \
	LP1NR(0x3EA, glColor3dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor3fv(const_GLfloat_ptr_v) \
	LP1NR(0x3F0, glColor3fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor3iv(const_GLint_ptr_v) \
	LP1NR(0x3F6, glColor3iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor3sv(const_GLshort_ptr_v) \
	LP1NR(0x3FC, glColor3sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor3ubv(const_GLubyte_ptr_v) \
	LP1NR(0x402, glColor3ubv, const GLubyte *, const_GLubyte_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor3uiv(const_GLuint_ptr_v) \
	LP1NR(0x408, glColor3uiv, const GLuint *, const_GLuint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor3usv(const_GLushort_ptr_v) \
	LP1NR(0x40E, glColor3usv, const GLushort *, const_GLushort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4bv(const_GLbyte_ptr_v) \
	LP1NR(0x414, glColor4bv, const GLbyte *, const_GLbyte_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4dv(const_GLdouble_ptr_v) \
	LP1NR(0x41A, glColor4dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4fv(const_GLfloat_ptr_v) \
	LP1NR(0x420, glColor4fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4iv(const_GLint_ptr_v) \
	LP1NR(0x426, glColor4iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4sv(const_GLshort_ptr_v) \
	LP1NR(0x42C, glColor4sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4ubv(const_GLubyte_ptr_v) \
	LP1NR(0x432, glColor4ubv, const GLubyte *, const_GLubyte_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4uiv(const_GLuint_ptr_v) \
	LP1NR(0x438, glColor4uiv, const GLuint *, const_GLuint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glColor4usv(const_GLushort_ptr_v) \
	LP1NR(0x43E, glColor4usv, const GLushort *, const_GLushort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord1d(GLdouble_s) \
	LP1NR(0x444, glTexCoord1d, GLdouble, GLdouble_s, fp0, \
	, AGL_BASE_NAME)

#define glTexCoord1f(GLfloat_s) \
	LP1NR(0x44A, glTexCoord1f, GLfloat, GLfloat_s, fp0, \
	, AGL_BASE_NAME)

#define glTexCoord1i(GLint_s) \
	LP1NR(0x450, glTexCoord1i, GLint, GLint_s, d0, \
	, AGL_BASE_NAME)

#define glTexCoord1s(GLshort_s) \
	LP1NR(0x456, glTexCoord1s, GLshort, GLshort_s, d0, \
	, AGL_BASE_NAME)

#define glTexCoord2d(GLdouble_s, GLdouble_t) \
	LP2NR(0x45C, glTexCoord2d, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, \
	, AGL_BASE_NAME)

#define glTexCoord2f(GLfloat_s, GLfloat_t) \
	LP2NR(0x462, glTexCoord2f, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, \
	, AGL_BASE_NAME)

#define glTexCoord2i(GLint_s, GLint_t) \
	LP2NR(0x468, glTexCoord2i, GLint, GLint_s, d0, GLint, GLint_t, d1, \
	, AGL_BASE_NAME)

#define glTexCoord2s(GLshort_s, GLshort_t) \
	LP2NR(0x46E, glTexCoord2s, GLshort, GLshort_s, d0, GLshort, GLshort_t, d1, \
	, AGL_BASE_NAME)

#define glTexCoord3d(GLdouble_s, GLdouble_t, GLdouble_r) \
	LP3NR(0x474, glTexCoord3d, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, GLdouble, GLdouble_r, fp2, \
	, AGL_BASE_NAME)

#define glTexCoord3f(GLfloat_s, GLfloat_t, GLfloat_r) \
	LP3NR(0x47A, glTexCoord3f, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, GLfloat, GLfloat_r, fp2, \
	, AGL_BASE_NAME)

#define glTexCoord3i(GLint_s, GLint_t, GLint_r) \
	LP3NR(0x480, glTexCoord3i, GLint, GLint_s, d0, GLint, GLint_t, d1, GLint, GLint_r, d2, \
	, AGL_BASE_NAME)

#define glTexCoord3s(GLshort_s, GLshort_t, GLshort_r) \
	LP3NR(0x486, glTexCoord3s, GLshort, GLshort_s, d0, GLshort, GLshort_t, d1, GLshort, GLshort_r, d2, \
	, AGL_BASE_NAME)

#define glTexCoord4d(GLdouble_s, GLdouble_t, GLdouble_r, GLdouble_q) \
	LP4NR(0x48C, glTexCoord4d, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, GLdouble, GLdouble_r, fp2, GLdouble, GLdouble_q, fp3, \
	, AGL_BASE_NAME)

#define glTexCoord4f(GLfloat_s, GLfloat_t, GLfloat_r, GLfloat_q) \
	LP4NR(0x492, glTexCoord4f, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, GLfloat, GLfloat_r, fp2, GLfloat, GLfloat_q, fp3, \
	, AGL_BASE_NAME)

#define glTexCoord4i(GLint_s, GLint_t, GLint_r, GLint_q) \
	LP4NR(0x498, glTexCoord4i, GLint, GLint_s, d0, GLint, GLint_t, d1, GLint, GLint_r, d2, GLint, GLint_q, d3, \
	, AGL_BASE_NAME)

#define glTexCoord4s(GLshort_s, GLshort_t, GLshort_r, GLshort_q) \
	LP4NR(0x49E, glTexCoord4s, GLshort, GLshort_s, d0, GLshort, GLshort_t, d1, GLshort, GLshort_r, d2, GLshort, GLshort_q, d3, \
	, AGL_BASE_NAME)

#define glTexCoord1dv(const_GLdouble_ptr_v) \
	LP1NR(0x4A4, glTexCoord1dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord1fv(const_GLfloat_ptr_v) \
	LP1NR(0x4AA, glTexCoord1fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord1iv(const_GLint_ptr_v) \
	LP1NR(0x4B0, glTexCoord1iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord1sv(const_GLshort_ptr_v) \
	LP1NR(0x4B6, glTexCoord1sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord2dv(const_GLdouble_ptr_v) \
	LP1NR(0x4BC, glTexCoord2dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord2fv(const_GLfloat_ptr_v) \
	LP1NR(0x4C2, glTexCoord2fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord2iv(const_GLint_ptr_v) \
	LP1NR(0x4C8, glTexCoord2iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord2sv(const_GLshort_ptr_v) \
	LP1NR(0x4CE, glTexCoord2sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord3dv(const_GLdouble_ptr_v) \
	LP1NR(0x4D4, glTexCoord3dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord3fv(const_GLfloat_ptr_v) \
	LP1NR(0x4DA, glTexCoord3fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord3iv(const_GLint_ptr_v) \
	LP1NR(0x4E0, glTexCoord3iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord3sv(const_GLshort_ptr_v) \
	LP1NR(0x4E6, glTexCoord3sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord4dv(const_GLdouble_ptr_v) \
	LP1NR(0x4EC, glTexCoord4dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord4fv(const_GLfloat_ptr_v) \
	LP1NR(0x4F2, glTexCoord4fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord4iv(const_GLint_ptr_v) \
	LP1NR(0x4F8, glTexCoord4iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glTexCoord4sv(const_GLshort_ptr_v) \
	LP1NR(0x4FE, glTexCoord4sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos2d(GLdouble_x, GLdouble_y) \
	LP2NR(0x504, glRasterPos2d, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, \
	, AGL_BASE_NAME)

#define glRasterPos2f(GLfloat_x, GLfloat_y) \
	LP2NR(0x50A, glRasterPos2f, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, \
	, AGL_BASE_NAME)

#define glRasterPos2i(GLint_x, GLint_y) \
	LP2NR(0x510, glRasterPos2i, GLint, GLint_x, d0, GLint, GLint_y, d1, \
	, AGL_BASE_NAME)

#define glRasterPos2s(GLshort_x, GLshort_y) \
	LP2NR(0x516, glRasterPos2s, GLshort, GLshort_x, d0, GLshort, GLshort_y, d1, \
	, AGL_BASE_NAME)

#define glRasterPos3d(GLdouble_x, GLdouble_y, GLdouble_z) \
	LP3NR(0x51C, glRasterPos3d, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, GLdouble, GLdouble_z, fp2, \
	, AGL_BASE_NAME)

#define glRasterPos3f(GLfloat_x, GLfloat_y, GLfloat_z) \
	LP3NR(0x522, glRasterPos3f, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, GLfloat, GLfloat_z, fp2, \
	, AGL_BASE_NAME)

#define glRasterPos3i(GLint_x, GLint_y, GLint_z) \
	LP3NR(0x528, glRasterPos3i, GLint, GLint_x, d0, GLint, GLint_y, d1, GLint, GLint_z, d2, \
	, AGL_BASE_NAME)

#define glRasterPos3s(GLshort_x, GLshort_y, GLshort_z) \
	LP3NR(0x52E, glRasterPos3s, GLshort, GLshort_x, d0, GLshort, GLshort_y, d1, GLshort, GLshort_z, d2, \
	, AGL_BASE_NAME)

#define glRasterPos4d(GLdouble_x, GLdouble_y, GLdouble_z, GLdouble_w) \
	LP4NR(0x534, glRasterPos4d, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, GLdouble, GLdouble_z, fp2, GLdouble, GLdouble_w, fp3, \
	, AGL_BASE_NAME)

#define glRasterPos4f(GLfloat_x, GLfloat_y, GLfloat_z, GLfloat_w) \
	LP4NR(0x53A, glRasterPos4f, GLfloat, GLfloat_x, fp0, GLfloat, GLfloat_y, fp1, GLfloat, GLfloat_z, fp2, GLfloat, GLfloat_w, fp3, \
	, AGL_BASE_NAME)

#define glRasterPos4i(GLint_x, GLint_y, GLint_z, GLint_w) \
	LP4NR(0x540, glRasterPos4i, GLint, GLint_x, d0, GLint, GLint_y, d1, GLint, GLint_z, d2, GLint, GLint_w, d3, \
	, AGL_BASE_NAME)

#define glRasterPos4s(GLshort_x, GLshort_y, GLshort_z, GLshort_w) \
	LP4NR(0x546, glRasterPos4s, GLshort, GLshort_x, d0, GLshort, GLshort_y, d1, GLshort, GLshort_z, d2, GLshort, GLshort_w, d3, \
	, AGL_BASE_NAME)

#define glRasterPos2dv(const_GLdouble_ptr_v) \
	LP1NR(0x54C, glRasterPos2dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos2fv(const_GLfloat_ptr_v) \
	LP1NR(0x552, glRasterPos2fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos2iv(const_GLint_ptr_v) \
	LP1NR(0x558, glRasterPos2iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos2sv(const_GLshort_ptr_v) \
	LP1NR(0x55E, glRasterPos2sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos3dv(const_GLdouble_ptr_v) \
	LP1NR(0x564, glRasterPos3dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos3fv(const_GLfloat_ptr_v) \
	LP1NR(0x56A, glRasterPos3fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos3iv(const_GLint_ptr_v) \
	LP1NR(0x570, glRasterPos3iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos3sv(const_GLshort_ptr_v) \
	LP1NR(0x576, glRasterPos3sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos4dv(const_GLdouble_ptr_v) \
	LP1NR(0x57C, glRasterPos4dv, const GLdouble *, const_GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos4fv(const_GLfloat_ptr_v) \
	LP1NR(0x582, glRasterPos4fv, const GLfloat *, const_GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos4iv(const_GLint_ptr_v) \
	LP1NR(0x588, glRasterPos4iv, const GLint *, const_GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRasterPos4sv(const_GLshort_ptr_v) \
	LP1NR(0x58E, glRasterPos4sv, const GLshort *, const_GLshort_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glRectd(GLdouble_x1, GLdouble_y1, GLdouble_x2, GLdouble_y2) \
	LP4NR(0x594, glRectd, GLdouble, GLdouble_x1, fp0, GLdouble, GLdouble_y1, fp1, GLdouble, GLdouble_x2, fp2, GLdouble, GLdouble_y2, fp3, \
	, AGL_BASE_NAME)

#define glRectf(GLfloat_x1, GLfloat_y1, GLfloat_x2, GLfloat_y2) \
	LP4NR(0x59A, glRectf, GLfloat, GLfloat_x1, fp0, GLfloat, GLfloat_y1, fp1, GLfloat, GLfloat_x2, fp2, GLfloat, GLfloat_y2, fp3, \
	, AGL_BASE_NAME)

#define glRecti(GLint_x1, GLint_y1, GLint_x2, GLint_y2) \
	LP4NR(0x5A0, glRecti, GLint, GLint_x1, d0, GLint, GLint_y1, d1, GLint, GLint_x2, d2, GLint, GLint_y2, d3, \
	, AGL_BASE_NAME)

#define glRects(GLshort_x1, GLshort_y1, GLshort_x2, GLshort_y2) \
	LP4NR(0x5A6, glRects, GLshort, GLshort_x1, d0, GLshort, GLshort_y1, d1, GLshort, GLshort_x2, d2, GLshort, GLshort_y2, d3, \
	, AGL_BASE_NAME)

#define glRectdv(const_GLdouble_ptr_v1, const_GLdouble_ptr_v2) \
	LP2NR(0x5AC, glRectdv, const GLdouble *, const_GLdouble_ptr_v1, a0, const GLdouble *, const_GLdouble_ptr_v2, a1, \
	, AGL_BASE_NAME)

#define glRectfv(const_GLfloat_ptr_v1, const_GLfloat_ptr_v2) \
	LP2NR(0x5B2, glRectfv, const GLfloat *, const_GLfloat_ptr_v1, a0, const GLfloat *, const_GLfloat_ptr_v2, a1, \
	, AGL_BASE_NAME)

#define glRectiv(const_GLint_ptr_v1, const_GLint_ptr_v2) \
	LP2NR(0x5B8, glRectiv, const GLint *, const_GLint_ptr_v1, a0, const GLint *, const_GLint_ptr_v2, a1, \
	, AGL_BASE_NAME)

#define glRectsv(const_GLshort_ptr_v1, const_GLshort_ptr_v2) \
	LP2NR(0x5BE, glRectsv, const GLshort *, const_GLshort_ptr_v1, a0, const GLshort *, const_GLshort_ptr_v2, a1, \
	, AGL_BASE_NAME)

#define glVertexPointer(GLint_size, GLenum_type, GLsizei_stride, GLvoid_ptr) \
	LP4NR(0x5C4, glVertexPointer, GLint, GLint_size, d0, GLenum, GLenum_type, d1, GLsizei, GLsizei_stride, d2, const GLvoid *, GLvoid_ptr, a0, \
	, AGL_BASE_NAME)

#define glNormalPointer(GLenum_type, GLsizei_stride, GLvoid_ptr) \
	LP3NR(0x5CA, glNormalPointer, GLenum, GLenum_type, d0, GLsizei, GLsizei_stride, d1, const GLvoid *, GLvoid_ptr, a0, \
	, AGL_BASE_NAME)

#define glColorPointer(GLint_size, GLenum_type, GLsizei_stride, GLvoid_ptr) \
	LP4NR(0x5D0, glColorPointer, GLint, GLint_size, d0, GLenum, GLenum_type, d1, GLsizei, GLsizei_stride, d2, const GLvoid *, GLvoid_ptr, a0, \
	, AGL_BASE_NAME)

#define glIndexPointer(GLenum_type, GLsizei_stride, GLvoid_ptr) \
	LP3NR(0x5D6, glIndexPointer, GLenum, GLenum_type, d0, GLsizei, GLsizei_stride, d1, const GLvoid *, GLvoid_ptr, a0, \
	, AGL_BASE_NAME)

#define glTexCoordPointer(GLint_size, GLenum_type, GLsizei_stride, GLvoid_ptr) \
	LP4NR(0x5DC, glTexCoordPointer, GLint, GLint_size, d0, GLenum, GLenum_type, d1, GLsizei, GLsizei_stride, d2, const GLvoid *, GLvoid_ptr, a0, \
	, AGL_BASE_NAME)

#define glEdgeFlagPointer(GLsizei_stride, GLboolean_ptr) \
	LP2NR(0x5E2, glEdgeFlagPointer, GLsizei, GLsizei_stride, d0, const GLboolean *, GLboolean_ptr, a0, \
	, AGL_BASE_NAME)

#define glGetPointerv(GLenum_pname, GLvoid_params) \
	LP2NR(0x5E8, glGetPointerv, GLenum, GLenum_pname, d0, void **, GLvoid_params, a0, \
	, AGL_BASE_NAME)

#define glArrayElement(GLint_i) \
	LP1NR(0x5EE, glArrayElement, GLint, GLint_i, d0, \
	, AGL_BASE_NAME)

#define glDrawArrays(GLenum_mode, GLint_first, GLsizei_count) \
	LP3NR(0x5F4, glDrawArrays, GLenum, GLenum_mode, d0, GLint, GLint_first, d1, GLsizei, GLsizei_count, d2, \
	, AGL_BASE_NAME)

#define glDrawElements(GLenum_mode, GLsizei_count, GLenum_type, GLvoid_indices) \
	LP4NR(0x5FA, glDrawElements, GLenum, GLenum_mode, d0, GLsizei, GLsizei_count, d1, GLenum, GLenum_type, d2, const GLvoid *, GLvoid_indices, a0, \
	, AGL_BASE_NAME)

#define glInterleavedArrays(GLenum_format, GLsizei_stride, GLvoid_pointer) \
	LP3NR(0x600, glInterleavedArrays, GLenum, GLenum_format, d0, GLsizei, GLsizei_stride, d1, const GLvoid *, GLvoid_pointer, a0, \
	, AGL_BASE_NAME)

#define glShadeModel(GLenum_mode) \
	LP1NR(0x606, glShadeModel, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glLightf(GLenum_light, GLenum_pname, GLfloat_param) \
	LP3NR(0x60C, glLightf, GLenum, GLenum_light, d0, GLenum, GLenum_pname, d1, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glLighti(GLenum_light, GLenum_pname, GLint_param) \
	LP3NR(0x612, glLighti, GLenum, GLenum_light, d0, GLenum, GLenum_pname, d1, GLint, GLint_param, d2, \
	, AGL_BASE_NAME)

#define glLightfv(GLenum_light, GLenum_pname, const_GLfloat_ptr_params) \
	LP3NR(0x618, glLightfv, GLenum, GLenum_light, d0, GLenum, GLenum_pname, d1, const GLfloat *, const_GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glLightiv(GLenum_light, GLenum_pname, const_GLint_ptr_params) \
	LP3NR(0x61E, glLightiv, GLenum, GLenum_light, d0, GLenum, GLenum_pname, d1, const GLint *, const_GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetLightfv(GLenum_light, GLenum_pname, GLfloat_ptr_params) \
	LP3NR(0x624, glGetLightfv, GLenum, GLenum_light, d0, GLenum, GLenum_pname, d1, GLfloat *, GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetLightiv(GLenum_light, GLenum_pname, GLint_ptr_params) \
	LP3NR(0x62A, glGetLightiv, GLenum, GLenum_light, d0, GLenum, GLenum_pname, d1, GLint *, GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glLightModelf(GLenum_pname, GLfloat_param) \
	LP2NR(0x630, glLightModelf, GLenum, GLenum_pname, d0, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glLightModeli(GLenum_pname, GLint_param) \
	LP2NR(0x636, glLightModeli, GLenum, GLenum_pname, d0, GLint, GLint_param, d1, \
	, AGL_BASE_NAME)

#define glLightModelfv(GLenum_pname, const_GLfloat_ptr_params) \
	LP2NR(0x63C, glLightModelfv, GLenum, GLenum_pname, d0, const GLfloat *, const_GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glLightModeliv(GLenum_pname, const_GLint_ptr_params) \
	LP2NR(0x642, glLightModeliv, GLenum, GLenum_pname, d0, const GLint *, const_GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glMaterialf(GLenum_face, GLenum_pname, GLfloat_param) \
	LP3NR(0x648, glMaterialf, GLenum, GLenum_face, d0, GLenum, GLenum_pname, d1, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glMateriali(GLenum_face, GLenum_pname, GLint_param) \
	LP3NR(0x64E, glMateriali, GLenum, GLenum_face, d0, GLenum, GLenum_pname, d1, GLint, GLint_param, d2, \
	, AGL_BASE_NAME)

#define glMaterialfv(GLenum_face, GLenum_pname, const_GLfloat_ptr_params) \
	LP3NR(0x654, glMaterialfv, GLenum, GLenum_face, d0, GLenum, GLenum_pname, d1, const GLfloat *, const_GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glMaterialiv(GLenum_face, GLenum_pname, const_GLint_ptr_params) \
	LP3NR(0x65A, glMaterialiv, GLenum, GLenum_face, d0, GLenum, GLenum_pname, d1, const GLint *, const_GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetMaterialfv(GLenum_face, GLenum_pname, GLfloat_ptr_params) \
	LP3NR(0x660, glGetMaterialfv, GLenum, GLenum_face, d0, GLenum, GLenum_pname, d1, GLfloat *, GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetMaterialiv(GLenum_face, GLenum_pname, GLint_ptr_params) \
	LP3NR(0x666, glGetMaterialiv, GLenum, GLenum_face, d0, GLenum, GLenum_pname, d1, GLint *, GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glColorMaterial(GLenum_face, GLenum_mode) \
	LP2NR(0x66C, glColorMaterial, GLenum, GLenum_face, d0, GLenum, GLenum_mode, d1, \
	, AGL_BASE_NAME)

#define glPixelZoom(GLfloat_xfactor, GLfloat_yfactor) \
	LP2NR(0x672, glPixelZoom, GLfloat, GLfloat_xfactor, fp0, GLfloat, GLfloat_yfactor, fp1, \
	, AGL_BASE_NAME)

#define glPixelStoref(GLenum_pname, GLfloat_param) \
	LP2NR(0x678, glPixelStoref, GLenum, GLenum_pname, d0, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glPixelStorei(GLenum_pname, GLint_param) \
	LP2NR(0x67E, glPixelStorei, GLenum, GLenum_pname, d0, GLint, GLint_param, d1, \
	, AGL_BASE_NAME)

#define glPixelTransferf(GLenum_pname, GLfloat_param) \
	LP2NR(0x684, glPixelTransferf, GLenum, GLenum_pname, d0, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glPixelTransferi(GLenum_pname, GLint_param) \
	LP2NR(0x68A, glPixelTransferi, GLenum, GLenum_pname, d0, GLint, GLint_param, d1, \
	, AGL_BASE_NAME)

#define glPixelMapfv(GLenum_map, GLint_mapsize, const_GLfloat_ptr_values) \
	LP3NR(0x690, glPixelMapfv, GLenum, GLenum_map, d0, GLint, GLint_mapsize, d1, const GLfloat *, const_GLfloat_ptr_values, a0, \
	, AGL_BASE_NAME)

#define glPixelMapuiv(GLenum_map, GLint_mapsize, const_GLuint_ptr_values) \
	LP3NR(0x696, glPixelMapuiv, GLenum, GLenum_map, d0, GLint, GLint_mapsize, d1, const GLuint *, const_GLuint_ptr_values, a0, \
	, AGL_BASE_NAME)

#define glPixelMapusv(GLenum_map, GLint_mapsize, const_GLushort_ptr_values) \
	LP3NR(0x69C, glPixelMapusv, GLenum, GLenum_map, d0, GLint, GLint_mapsize, d1, const GLushort *, const_GLushort_ptr_values, a0, \
	, AGL_BASE_NAME)

#define glGetPixelMapfv(GLenum_map, GLfloat_ptr_values) \
	LP2NR(0x6A2, glGetPixelMapfv, GLenum, GLenum_map, d0, GLfloat *, GLfloat_ptr_values, a0, \
	, AGL_BASE_NAME)

#define glGetPixelMapuiv(GLenum_map, GLuint_ptr_values) \
	LP2NR(0x6A8, glGetPixelMapuiv, GLenum, GLenum_map, d0, GLuint *, GLuint_ptr_values, a0, \
	, AGL_BASE_NAME)

#define glGetPixelMapusv(GLenum_map, GLushort_ptr_values) \
	LP2NR(0x6AE, glGetPixelMapusv, GLenum, GLenum_map, d0, GLushort *, GLushort_ptr_values, a0, \
	, AGL_BASE_NAME)

#define glBitmap(GLsizei_width, GLsizei_height, GLfloat_xorig, GLfloat_yorig, GLfloat_xmove, GLfloat_ymove, const_GLubyte_ptr_bitmap) \
	LP7NR(0x6B4, glBitmap, GLsizei, GLsizei_width, d0, GLsizei, GLsizei_height, d1, GLfloat, GLfloat_xorig, fp0, GLfloat, GLfloat_yorig, fp1, GLfloat, GLfloat_xmove, fp2, GLfloat, GLfloat_ymove, fp3, const GLubyte *, const_GLubyte_ptr_bitmap, a0, \
	, AGL_BASE_NAME)

#define glReadPixels(GLint_x, GLint_y, GLsizei_width, GLsizei_height, GLenum_format, GLenum_type, GL_ptr_pixels) \
	LP7NR(0x6BA, glReadPixels, GLint, GLint_x, d0, GLint, GLint_y, d1, GLsizei, GLsizei_width, d2, GLsizei, GLsizei_height, d3, GLenum, GLenum_format, d4, GLenum, GLenum_type, d5, GLvoid *, GL_ptr_pixels, a0, \
	, AGL_BASE_NAME)

#define glDrawPixels(GLsizei_width, GLsizei_height, GLenum_format, GLenum_type, const_GL_ptr_pixels) \
	LP5NR(0x6C0, glDrawPixels, GLsizei, GLsizei_width, d0, GLsizei, GLsizei_height, d1, GLenum, GLenum_format, d2, GLenum, GLenum_type, d3, const GLvoid *, const_GL_ptr_pixels, a0, \
	, AGL_BASE_NAME)

#define glCopyPixels(GLint_x, GLint_y, GLsizei_width, GLsizei_height, GLenum_type) \
	LP5NR(0x6C6, glCopyPixels, GLint, GLint_x, d0, GLint, GLint_y, d1, GLsizei, GLsizei_width, d2, GLsizei, GLsizei_height, d3, GLenum, GLenum_type, d4, \
	, AGL_BASE_NAME)

#define glStencilFunc(GLenum_func, GLint_ref, GLuint_mask) \
	LP3NR(0x6CC, glStencilFunc, GLenum, GLenum_func, d0, GLint, GLint_ref, d1, GLuint, GLuint_mask, d2, \
	, AGL_BASE_NAME)

#define glStencilMask(GLuint_mask) \
	LP1NR(0x6D2, glStencilMask, GLuint, GLuint_mask, d0, \
	, AGL_BASE_NAME)

#define glStencilOp(GLenum_fail, GLenum_zfail, GLenum_zpass) \
	LP3NR(0x6D8, glStencilOp, GLenum, GLenum_fail, d0, GLenum, GLenum_zfail, d1, GLenum, GLenum_zpass, d2, \
	, AGL_BASE_NAME)

#define glClearStencil(GLint_s) \
	LP1NR(0x6DE, glClearStencil, GLint, GLint_s, d0, \
	, AGL_BASE_NAME)

#define glTexGend(GLenum_coord, GLenum_pname, GLdouble_param) \
	LP3NR(0x6E4, glTexGend, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, GLdouble, GLdouble_param, fp0, \
	, AGL_BASE_NAME)

#define glTexGenf(GLenum_coord, GLenum_pname, GLfloat_param) \
	LP3NR(0x6EA, glTexGenf, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glTexGeni(GLenum_coord, GLenum_pname, GLint_param) \
	LP3NR(0x6F0, glTexGeni, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, GLint, GLint_param, d2, \
	, AGL_BASE_NAME)

#define glTexGendv(GLenum_coord, GLenum_pname, const_GLdouble_ptr_params) \
	LP3NR(0x6F6, glTexGendv, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, const GLdouble *, const_GLdouble_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glTexGenfv(GLenum_coord, GLenum_pname, const_GLfloat_ptr_params) \
	LP3NR(0x6FC, glTexGenfv, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, const GLfloat *, const_GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glTexGeniv(GLenum_coord, GLenum_pname, const_GLint_ptr_params) \
	LP3NR(0x702, glTexGeniv, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, const GLint *, const_GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexGendv(GLenum_coord, GLenum_pname, GLdouble_ptr_params) \
	LP3NR(0x708, glGetTexGendv, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, GLdouble *, GLdouble_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexGenfv(GLenum_coord, GLenum_pname, GLfloat_ptr_params) \
	LP3NR(0x70E, glGetTexGenfv, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, GLfloat *, GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexGeniv(GLenum_coord, GLenum_pname, GLint_ptr_params) \
	LP3NR(0x714, glGetTexGeniv, GLenum, GLenum_coord, d0, GLenum, GLenum_pname, d1, GLint *, GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glTexEnvf(GLenum_target, GLenum_pname, GLfloat_param) \
	LP3NR(0x71A, glTexEnvf, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glTexEnvi(GLenum_target, GLenum_pname, GLint_param) \
	LP3NR(0x720, glTexEnvi, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLint, GLint_param, d2, \
	, AGL_BASE_NAME)

#define glTexEnvfv(GLenum_target, GLenum_pname, const_GLfloat_ptr_params) \
	LP3NR(0x726, glTexEnvfv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, const GLfloat *, const_GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glTexEnviv(GLenum_target, GLenum_pname, const_GLint_ptr_params) \
	LP3NR(0x72C, glTexEnviv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, const GLint *, const_GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexEnvfv(GLenum_target, GLenum_pname, GLfloat_ptr_params) \
	LP3NR(0x732, glGetTexEnvfv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLfloat *, GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexEnviv(GLenum_target, GLenum_pname, GLint_ptr_params) \
	LP3NR(0x738, glGetTexEnviv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLint *, GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glTexParameterf(GLenum_target, GLenum_pname, GLfloat_param) \
	LP3NR(0x73E, glTexParameterf, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glTexParameteri(GLenum_target, GLenum_pname, GLint_param) \
	LP3NR(0x744, glTexParameteri, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLint, GLint_param, d2, \
	, AGL_BASE_NAME)

#define glTexParameterfv(GLenum_target, GLenum_pname, const_GLfloat_ptr_params) \
	LP3NR(0x74A, glTexParameterfv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, const GLfloat *, const_GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glTexParameteriv(GLenum_target, GLenum_pname, const_GLint_ptr_params) \
	LP3NR(0x750, glTexParameteriv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, const GLint *, const_GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexParameterfv(GLenum_target, GLenum_pname, GLfloat_ptr_params) \
	LP3NR(0x756, glGetTexParameterfv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLfloat *, GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexParameteriv(GLenum_target, GLenum_pname, GLint_ptr_params) \
	LP3NR(0x75C, glGetTexParameteriv, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLint *, GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexLevelParameterfv(GLenum_target, GLint_level, GLenum_pname, GLfloat_ptr_params) \
	LP4NR(0x762, glGetTexLevelParameterfv, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLenum, GLenum_pname, d2, GLfloat *, GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glGetTexLevelParameteriv(GLenum_target, GLint_level, GLenum_pname, GLint_ptr_params) \
	LP4NR(0x768, glGetTexLevelParameteriv, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLenum, GLenum_pname, d2, GLint *, GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glTexImage1D(GLenum_target, GLint_level, GLint_components, GLsizei_width, GLint_border, GLenum_format, GLenum_type, const_GL_ptr_pixels) \
	LP8NR(0x76E, glTexImage1D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_components, d2, GLsizei, GLsizei_width, d3, GLint, GLint_border, d4, GLenum, GLenum_format, d5, GLenum, GLenum_type, d6, const GLvoid *, const_GL_ptr_pixels, a0, \
	, AGL_BASE_NAME)

#define glTexImage2D(GLenum_target, GLint_level, GLint_components, GLsizei_width, GLsizei_height, GLint_border, GLenum_format, GLenum_type, const_GL_ptr_pixels) \
	LP9NR(0x774, glTexImage2D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_components, d2, GLsizei, GLsizei_width, d3, GLsizei, GLsizei_height, d4, GLint, GLint_border, d5, GLenum, GLenum_format, d6, GLenum, GLenum_type, d7, const GLvoid *, const_GL_ptr_pixels, a0, \
	, AGL_BASE_NAME)

#define glGetTexImage(GLenum_target, GLint_level, GLenum_format, GLenum_type, GL_ptr_pixels) \
	LP5NR(0x77A, glGetTexImage, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLenum, GLenum_format, d2, GLenum, GLenum_type, d3, GLvoid *, GL_ptr_pixels, a0, \
	, AGL_BASE_NAME)

#define glGenTextures(GLsizei_n, GLuint_textures) \
	LP2NR(0x780, glGenTextures, GLsizei, GLsizei_n, d0, GLuint *, GLuint_textures, a0, \
	, AGL_BASE_NAME)

#define glDeleteTextures(GLsizei_n, GLuint_textures) \
	LP2NR(0x786, glDeleteTextures, GLsizei, GLsizei_n, d0, const GLuint *, GLuint_textures, a0, \
	, AGL_BASE_NAME)

#define glBindTexture(GLenum_target, GLuint_texture) \
	LP2NR(0x78C, glBindTexture, GLenum, GLenum_target, d0, GLuint, GLuint_texture, d1, \
	, AGL_BASE_NAME)

#define glPrioritizeTextures(GLsizei_n, GLuint_textures, GLclampf_priorities) \
	LP3NR(0x792, glPrioritizeTextures, GLsizei, GLsizei_n, d0, const GLuint *, GLuint_textures, a0, const GLclampf *, GLclampf_priorities, a1, \
	, AGL_BASE_NAME)

#define glAreTexturesResident(GLsizei_n, GLuint_textures, GLboolean_residences) \
	LP3(0x798, GLboolean, glAreTexturesResident, GLsizei, GLsizei_n, d0, const GLuint *, GLuint_textures, a0, GLboolean *, GLboolean_residences, a1, \
	, AGL_BASE_NAME)

#define glIsTexture(GLuint_texture) \
	LP1(0x79E, GLboolean, glIsTexture, GLuint, GLuint_texture, d0, \
	, AGL_BASE_NAME)

#define glTexSubImage1D(GLenum_target, GLint_level, GLint_xoffset, GLsizei_width, GLenum_format, GLenum_type, GLvoid_pixels) \
	LP7NR(0x7A4, glTexSubImage1D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLsizei, GLsizei_width, d3, GLenum, GLenum_format, d4, GLenum, GLenum_type, d5, const GLvoid *, GLvoid_pixels, a0, \
	, AGL_BASE_NAME)

#define glTexSubImage2D(GLenum_target, GLint_level, GLint_xoffset, GLint_yoffset, GLsizei_width, GLsizei_height, GLenum_format, GLenum_type, GLvoid_pixels) \
	LP9NR(0x7AA, glTexSubImage2D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLint, GLint_yoffset, d3, GLsizei, GLsizei_width, d4, GLsizei, GLsizei_height, d5, GLenum, GLenum_format, d6, GLenum, GLenum_type, d7, const GLvoid *, GLvoid_pixels, a0, \
	, AGL_BASE_NAME)

#define glCopyTexImage1D(GLenum_target, GLint_level, GLenum_internalformat, GLint_x, GLint_y, GLsizei_width, GLint_border) \
	LP7NR(0x7B0, glCopyTexImage1D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLenum, GLenum_internalformat, d2, GLint, GLint_x, d3, GLint, GLint_y, d4, GLsizei, GLsizei_width, d5, GLint, GLint_border, d6, \
	, AGL_BASE_NAME)

#define glCopyTexImage2D(GLenum_target, GLint_level, GLenum_internalformat, GLint_x, GLint_y, GLsizei_width, GLsizei_height, GLint_border) \
	LP8NR(0x7B6, glCopyTexImage2D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLenum, GLenum_internalformat, d2, GLint, GLint_x, d3, GLint, GLint_y, d4, GLsizei, GLsizei_width, d5, GLsizei, GLsizei_height, d6, GLint, GLint_border, d7, \
	, AGL_BASE_NAME)

#define glCopyTexSubImage1D(GLenum_target, GLint_level, GLint_xoffset, GLint_x, GLint_y, GLsizei_width) \
	LP6NR(0x7BC, glCopyTexSubImage1D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLint, GLint_x, d3, GLint, GLint_y, d4, GLsizei, GLsizei_width, d5, \
	, AGL_BASE_NAME)

#define glCopyTexSubImage2D(GLenum_target, GLint_level, GLint_xoffset, GLint_yoffset, GLint_x, GLint_y, GLsizei_width, GLsizei_height) \
	LP8NR(0x7C2, glCopyTexSubImage2D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLint, GLint_yoffset, d3, GLint, GLint_x, d4, GLint, GLint_y, d5, GLsizei, GLsizei_width, d6, GLsizei, GLsizei_height, d7, \
	, AGL_BASE_NAME)

#define glMap1d(GLenum_target, GLdouble_u1, GLdouble_u2, GLint_stride, GLint_order, const_GLdouble_ptr_points) \
	LP6NR(0x7C8, glMap1d, GLenum, GLenum_target, d0, GLdouble, GLdouble_u1, fp0, GLdouble, GLdouble_u2, fp1, GLint, GLint_stride, d1, GLint, GLint_order, d2, const GLdouble *, const_GLdouble_ptr_points, a0, \
	, AGL_BASE_NAME)

#define glMap1f(GLenum_target, GLfloat_u1, GLfloat_u2, GLint_stride, GLint_order, const_GLfloat_ptr_points) \
	LP6NR(0x7CE, glMap1f, GLenum, GLenum_target, d0, GLfloat, GLfloat_u1, fp0, GLfloat, GLfloat_u2, fp1, GLint, GLint_stride, d1, GLint, GLint_order, d2, const GLfloat *, const_GLfloat_ptr_points, a0, \
	, AGL_BASE_NAME)

#define glMap2d(GLenum_target, GLdouble_u1, GLdouble_u2, GLint_ustride, GLint_uorder, GLdouble_v1, GLdouble_v2, GLint_vstride, GLint_vorder, const_GLdouble_ptr_points) \
	LP10NR(0x7D4, glMap2d, GLenum, GLenum_target, d0, GLdouble, GLdouble_u1, fp0, GLdouble, GLdouble_u2, fp1, GLint, GLint_ustride, d1, GLint, GLint_uorder, d2, GLdouble, GLdouble_v1, fp2, GLdouble, GLdouble_v2, fp3, GLint, GLint_vstride, d3, GLint, GLint_vorder, d4, const GLdouble *, const_GLdouble_ptr_points, a0, \
	, AGL_BASE_NAME)

#define glMap2f(GLenum_target, GLfloat_u1, GLfloat_u2, GLint_ustride, GLint_uorder, GLfloat_v1, GLfloat_v2, GLint_vstride, GLint_vorder, const_GLfloat_ptr_points) \
	LP10NR(0x7DA, glMap2f, GLenum, GLenum_target, d0, GLfloat, GLfloat_u1, fp0, GLfloat, GLfloat_u2, fp1, GLint, GLint_ustride, d1, GLint, GLint_uorder, d2, GLfloat, GLfloat_v1, fp2, GLfloat, GLfloat_v2, fp3, GLint, GLint_vstride, d3, GLint, GLint_vorder, d4, const GLfloat *, const_GLfloat_ptr_points, a0, \
	, AGL_BASE_NAME)

#define glGetMapdv(GLenum_target, GLenum_query, GLdouble_ptr_v) \
	LP3NR(0x7E0, glGetMapdv, GLenum, GLenum_target, d0, GLenum, GLenum_query, d1, GLdouble *, GLdouble_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glGetMapfv(GLenum_target, GLenum_query, GLfloat_ptr_v) \
	LP3NR(0x7E6, glGetMapfv, GLenum, GLenum_target, d0, GLenum, GLenum_query, d1, GLfloat *, GLfloat_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glGetMapiv(GLenum_target, GLenum_query, GLint_ptr_v) \
	LP3NR(0x7EC, glGetMapiv, GLenum, GLenum_target, d0, GLenum, GLenum_query, d1, GLint *, GLint_ptr_v, a0, \
	, AGL_BASE_NAME)

#define glEvalCoord1d(GLdouble_u) \
	LP1NR(0x7F2, glEvalCoord1d, GLdouble, GLdouble_u, fp0, \
	, AGL_BASE_NAME)

#define glEvalCoord1f(GLfloat_u) \
	LP1NR(0x7F8, glEvalCoord1f, GLfloat, GLfloat_u, fp0, \
	, AGL_BASE_NAME)

#define glEvalCoord1dv(const_GLdouble_ptr_u) \
	LP1NR(0x7FE, glEvalCoord1dv, const GLdouble *, const_GLdouble_ptr_u, a0, \
	, AGL_BASE_NAME)

#define glEvalCoord1fv(const_GLfloat_ptr_u) \
	LP1NR(0x804, glEvalCoord1fv, const GLfloat *, const_GLfloat_ptr_u, a0, \
	, AGL_BASE_NAME)

#define glEvalCoord2d(GLdouble_u, GLdouble_v) \
	LP2NR(0x80A, glEvalCoord2d, GLdouble, GLdouble_u, fp0, GLdouble, GLdouble_v, fp1, \
	, AGL_BASE_NAME)

#define glEvalCoord2f(GLfloat_u, GLfloat_v) \
	LP2NR(0x810, glEvalCoord2f, GLfloat, GLfloat_u, fp0, GLfloat, GLfloat_v, fp1, \
	, AGL_BASE_NAME)

#define glEvalCoord2dv(const_GLdouble_ptr_u) \
	LP1NR(0x816, glEvalCoord2dv, const GLdouble *, const_GLdouble_ptr_u, a0, \
	, AGL_BASE_NAME)

#define glEvalCoord2fv(const_GLfloat_ptr_u) \
	LP1NR(0x81C, glEvalCoord2fv, const GLfloat *, const_GLfloat_ptr_u, a0, \
	, AGL_BASE_NAME)

#define glMapGrid1d(GLint_un, GLdouble_u1, GLdouble_u2) \
	LP3NR(0x822, glMapGrid1d, GLint, GLint_un, d0, GLdouble, GLdouble_u1, fp0, GLdouble, GLdouble_u2, fp1, \
	, AGL_BASE_NAME)

#define glMapGrid1f(GLint_un, GLfloat_u1, GLfloat_u2) \
	LP3NR(0x828, glMapGrid1f, GLint, GLint_un, d0, GLfloat, GLfloat_u1, fp0, GLfloat, GLfloat_u2, fp1, \
	, AGL_BASE_NAME)

#define glMapGrid2d(GLint_un, GLdouble_u1, GLdouble_u2, GLint_vn, GLdouble_v1, GLdouble_v2) \
	LP6NR(0x82E, glMapGrid2d, GLint, GLint_un, d0, GLdouble, GLdouble_u1, fp0, GLdouble, GLdouble_u2, fp1, GLint, GLint_vn, d1, GLdouble, GLdouble_v1, fp2, GLdouble, GLdouble_v2, fp3, \
	, AGL_BASE_NAME)

#define glMapGrid2f(GLint_un, GLfloat_u1, GLfloat_u2, GLint_vn, GLfloat_v1, GLfloat_v2) \
	LP6NR(0x834, glMapGrid2f, GLint, GLint_un, d0, GLfloat, GLfloat_u1, fp0, GLfloat, GLfloat_u2, fp1, GLint, GLint_vn, d1, GLfloat, GLfloat_v1, fp2, GLfloat, GLfloat_v2, fp3, \
	, AGL_BASE_NAME)

#define glEvalPoint1(GLint_i) \
	LP1NR(0x83A, glEvalPoint1, GLint, GLint_i, d0, \
	, AGL_BASE_NAME)

#define glEvalPoint2(GLint_i, GLint_j) \
	LP2NR(0x840, glEvalPoint2, GLint, GLint_i, d0, GLint, GLint_j, d1, \
	, AGL_BASE_NAME)

#define glEvalMesh1(GLenum_mode, GLint_i1, GLint_i2) \
	LP3NR(0x846, glEvalMesh1, GLenum, GLenum_mode, d0, GLint, GLint_i1, d1, GLint, GLint_i2, d2, \
	, AGL_BASE_NAME)

#define glEvalMesh2(GLenum_mode, GLint_i1, GLint_i2, GLint_j1, GLint_j2) \
	LP5NR(0x84C, glEvalMesh2, GLenum, GLenum_mode, d0, GLint, GLint_i1, d1, GLint, GLint_i2, d2, GLint, GLint_j1, d3, GLint, GLint_j2, d4, \
	, AGL_BASE_NAME)

#define glFogf(GLenum_pname, GLfloat_param) \
	LP2NR(0x852, glFogf, GLenum, GLenum_pname, d0, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glFogi(GLenum_pname, GLint_param) \
	LP2NR(0x858, glFogi, GLenum, GLenum_pname, d0, GLint, GLint_param, d1, \
	, AGL_BASE_NAME)

#define glFogfv(GLenum_pname, const_GLfloat_ptr_params) \
	LP2NR(0x85E, glFogfv, GLenum, GLenum_pname, d0, const GLfloat *, const_GLfloat_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glFogiv(GLenum_pname, const_GLint_ptr_params) \
	LP2NR(0x864, glFogiv, GLenum, GLenum_pname, d0, const GLint *, const_GLint_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glFeedbackBuffer(GLsizei_size, GLenum_type, GLfloat_ptr_buffer) \
	LP3NR(0x86A, glFeedbackBuffer, GLsizei, GLsizei_size, d0, GLenum, GLenum_type, d1, GLfloat *, GLfloat_ptr_buffer, a0, \
	, AGL_BASE_NAME)

#define glPassThrough(GLfloat_token) \
	LP1NR(0x870, glPassThrough, GLfloat, GLfloat_token, fp0, \
	, AGL_BASE_NAME)

#define glSelectBuffer(GLsizei_size, GLuint_ptr_buffer) \
	LP2NR(0x876, glSelectBuffer, GLsizei, GLsizei_size, d0, GLuint *, GLuint_ptr_buffer, a0, \
	, AGL_BASE_NAME)

#define glInitNames() \
	LP0NR(0x87C, glInitNames, \
	, AGL_BASE_NAME)

#define glLoadName(GLuint_name) \
	LP1NR(0x882, glLoadName, GLuint, GLuint_name, d0, \
	, AGL_BASE_NAME)

#define glPushName(GLuint_name) \
	LP1NR(0x888, glPushName, GLuint, GLuint_name, d0, \
	, AGL_BASE_NAME)

#define glPopName() \
	LP0NR(0x88E, glPopName, \
	, AGL_BASE_NAME)

#define glBlendEquationEXT(GLenum_mode) \
	LP1NR(0x894, glBlendEquationEXT, GLenum, GLenum_mode, d0, \
	, AGL_BASE_NAME)

#define glBlendColorEXT(GLclampf_red, GLclampf_green, GLclampfblue, GLclampf_alpha) \
	LP4NR(0x89A, glBlendColorEXT, GLclampf, GLclampf_red, fp0, GLclampf, GLclampf_green, fp1, GLclampf, GLclampfblue, fp2, GLclampf, GLclampf_alpha, fp3, \
	, AGL_BASE_NAME)

#define glPolygonOffsetEXT(GLfloat_factor, GLfloat_bias) \
	LP2NR(0x8A0, glPolygonOffsetEXT, GLfloat, GLfloat_factor, fp0, GLfloat, GLfloat_bias, fp1, \
	, AGL_BASE_NAME)

#define glVertexPointerEXT(GLint_size, GLenum_type, GLsizei_stride, GLsizei_count, const_ptr_ptr) \
	LP5NR(0x8A6, glVertexPointerEXT, GLint, GLint_size, d0, GLenum, GLenum_type, d1, GLsizei, GLsizei_stride, d2, GLsizei, GLsizei_count, d3, const GLvoid *, const_ptr_ptr, a0, \
	, AGL_BASE_NAME)

#define glNormalPointerEXT(GLenum_type, GLsizei_stride, GLsizei_count, const_ptr_ptr) \
	LP4NR(0x8AC, glNormalPointerEXT, GLenum, GLenum_type, d0, GLsizei, GLsizei_stride, d1, GLsizei, GLsizei_count, d2, const GLvoid *, const_ptr_ptr, a0, \
	, AGL_BASE_NAME)

#define glColorPointerEXT(GLint_size, GLenum_type, GLsizei_stride, GLsizei_count, const_ptr_ptr) \
	LP5NR(0x8B2, glColorPointerEXT, GLint, GLint_size, d0, GLenum, GLenum_type, d1, GLsizei, GLsizei_stride, d2, GLsizei, GLsizei_count, d3, const GLvoid *, const_ptr_ptr, a0, \
	, AGL_BASE_NAME)

#define glIndexPointerEXT(GLenum_type, GLsizei_stride, GLsizei_count, const_ptr_ptr) \
	LP4NR(0x8B8, glIndexPointerEXT, GLenum, GLenum_type, d0, GLsizei, GLsizei_stride, d1, GLsizei, GLsizei_count, d2, const GLvoid *, const_ptr_ptr, a0, \
	, AGL_BASE_NAME)

#define glTexCoordPointerEXT(GLint_size, GLenum_type, GLsizei_stride, GLsizei_count, const_ptr_ptr) \
	LP5NR(0x8BE, glTexCoordPointerEXT, GLint, GLint_size, d0, GLenum, GLenum_type, d1, GLsizei, GLsizei_stride, d2, GLsizei, GLsizei_count, d3, const GLvoid *, const_ptr_ptr, a0, \
	, AGL_BASE_NAME)

#define glEdgeFlagPointerEXT(GLsizei_stride, GLsizei_count, const_GLboolean_ptr_ptr) \
	LP3NR(0x8C4, glEdgeFlagPointerEXT, GLsizei, GLsizei_stride, d0, GLsizei, GLsizei_count, d1, const GLboolean *, const_GLboolean_ptr_ptr, a0, \
	, AGL_BASE_NAME)

#define glGetPointervEXT(GLenum_pname, prt_ptr_params) \
	LP2NR(0x8CA, glGetPointervEXT, GLenum, GLenum_pname, d0, void **, prt_ptr_params, a0, \
	, AGL_BASE_NAME)

#define glArrayElementEXT(GLint_i) \
	LP1NR(0x8D0, glArrayElementEXT, GLint, GLint_i, d0, \
	, AGL_BASE_NAME)

#define glDrawArraysEXT(GLenum_mode, GLint_first, GLsizei_count) \
	LP3NR(0x8D6, glDrawArraysEXT, GLenum, GLenum_mode, d0, GLint, GLint_first, d1, GLsizei, GLsizei_count, d2, \
	, AGL_BASE_NAME)

#define glGenTexturesEXT(GLsizei_n, GLuint_textures) \
	LP2NR(0x8DC, glGenTexturesEXT, GLsizei, GLsizei_n, d0, GLuint *, GLuint_textures, a0, \
	, AGL_BASE_NAME)

#define glDeleteTexturesEXT(GLsizei_n, GLuint_textures) \
	LP2NR(0x8E2, glDeleteTexturesEXT, GLsizei, GLsizei_n, d0, const GLuint *, GLuint_textures, a0, \
	, AGL_BASE_NAME)

#define glBindTextureEXT(GLenum_target, GLuint_texture) \
	LP2NR(0x8E8, glBindTextureEXT, GLenum, GLenum_target, d0, GLuint, GLuint_texture, d1, \
	, AGL_BASE_NAME)

#define glPrioritizeTexturesEXT(GLsizei_n, GLuint_textures, GLclampf_priorities) \
	LP3NR(0x8EE, glPrioritizeTexturesEXT, GLsizei, GLsizei_n, d0, const GLuint *, GLuint_textures, a0, const GLclampf *, GLclampf_priorities, a1, \
	, AGL_BASE_NAME)

#define glAreTexturesResidentEXT(GLsizei_n, GLuint_textures, GLboolean_residences) \
	LP3(0x8F4, GLboolean, glAreTexturesResidentEXT, GLsizei, GLsizei_n, d0, const GLuint *, GLuint_textures, a0, GLboolean *, GLboolean_residences, a1, \
	, AGL_BASE_NAME)

#define glIsTextureEXT(GLuint_texture) \
	LP1(0x8FA, GLboolean, glIsTextureEXT, GLuint, GLuint_texture, d0, \
	, AGL_BASE_NAME)

#define glTexImage3DEXT(GLenum_target, GLint_level, GLenum_internalformat, GLsizei_width, GLsizei_height, GLsizei_depth, GLint_border, GLenum_format, GLenum_type, GLvoid_pixels) \
	LP10NR(0x900, glTexImage3DEXT, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLenum, GLenum_internalformat, d2, GLsizei, GLsizei_width, d3, GLsizei, GLsizei_height, d4, GLsizei, GLsizei_depth, d5, GLint, GLint_border, d6, GLenum, GLenum_format, d7, GLenum, GLenum_type, a0, const GLvoid *, GLvoid_pixels, a1, \
	, AGL_BASE_NAME)

#define glTexSubImage3DEXT(GLenum_target, GLint_level, GLint_xoffset, GLint_yoffset, GLint_zoffset, GLsizei_width, GLsizei_height, GLsizei_depth, GLenum_format, GLenum_type, GLvoid_pixels) \
	LP11NR(0x906, glTexSubImage3DEXT, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLint, GLint_yoffset, d3, GLint, GLint_zoffset, d4, GLsizei, GLsizei_width, d5, GLsizei, GLsizei_height, d6, GLsizei, GLsizei_depth, d7, GLenum, GLenum_format, a0, GLenum, GLenum_type, a1, const GLvoid *, GLvoid_pixels, a2, \
	, AGL_BASE_NAME)

#define glCopyTexSubImage3DEXT(GLenum_target, GLint_level, GLint_xoffset, GLint_yoffset, GLint_zoffset, GLint_x, GLint_y, GLsizei_width, GLsizei_height) \
	LP9NR(0x90C, glCopyTexSubImage3DEXT, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLint, GLint_yoffset, d3, GLint, GLint_zoffset, d4, GLint, GLint_x, d5, GLint, GLint_y, d6, GLsizei, GLsizei_width, d7, GLsizei, GLsizei_height, a0, \
	, AGL_BASE_NAME)

#define glColorTableEXT(GLenum_target, GLenum_internalformat, GLsizei_width, GLenum_format, GLenum_type, GLvoid_table) \
	LP6NR(0x912, glColorTableEXT, GLenum, GLenum_target, d0, GLenum, GLenum_internalformat, d1, GLsizei, GLsizei_width, d2, GLenum, GLenum_format, d3, GLenum, GLenum_type, d4, const GLvoid *, GLvoid_table, a0, \
	, AGL_BASE_NAME)

#define glColorSubTableEXT(GLenum_target, GLsizei_start, GLsizei_count, GLenum_format, GLenum_type, GLvoid_data) \
	LP6NR(0x918, glColorSubTableEXT, GLenum, GLenum_target, d0, GLsizei, GLsizei_start, d1, GLsizei, GLsizei_count, d2, GLenum, GLenum_format, d3, GLenum, GLenum_type, d4, const GLvoid *, GLvoid_data, a0, \
	, AGL_BASE_NAME)

#define glGetColorTableEXT(GLenum_target, GLenum_format, GLenum_type, GLvoid_table) \
	LP4NR(0x91E, glGetColorTableEXT, GLenum, GLenum_target, d0, GLenum, GLenum_format, d1, GLenum, GLenum_type, d2, GLvoid *, GLvoid_table, a0, \
	, AGL_BASE_NAME)

#define glGetColorTableParameterfvEXT(GLenum_target, GLenum_pname, GLfloat_params) \
	LP3NR(0x924, glGetColorTableParameterfvEXT, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLfloat *, GLfloat_params, a0, \
	, AGL_BASE_NAME)

#define glGetColorTableParameterivEXT(GLenum_target, GLenum_pname, GLint_params) \
	LP3NR(0x92A, glGetColorTableParameterivEXT, GLenum, GLenum_target, d0, GLenum, GLenum_pname, d1, GLint *, GLint_params, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1dSGIS(GLenum_target, GLdouble_s) \
	LP2NR(0x930, glMultiTexCoord1dSGIS, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1dvSGIS(GLenum_target, GLdouble_v) \
	LP2NR(0x936, glMultiTexCoord1dvSGIS, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1fSGIS(GLenum_target, GLfloat_s) \
	LP2NR(0x93C, glMultiTexCoord1fSGIS, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1fvSGIS(GLenum_target, GLfloat_v) \
	LP2NR(0x942, glMultiTexCoord1fvSGIS, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1iSGIS(GLenum_target, GLint_s) \
	LP2NR(0x948, glMultiTexCoord1iSGIS, GLenum, GLenum_target, d0, GLint, GLint_s, d1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1ivSGIS(GLenum_target, GLint_v) \
	LP2NR(0x94E, glMultiTexCoord1ivSGIS, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1sSGIS(GLenum_target, GLshort_s) \
	LP2NR(0x954, glMultiTexCoord1sSGIS, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1svSGIS(GLenum_target, GLshort_v) \
	LP2NR(0x95A, glMultiTexCoord1svSGIS, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2dSGIS(GLenum_target, GLdouble_s, GLdouble_t) \
	LP3NR(0x960, glMultiTexCoord2dSGIS, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2dvSGIS(GLenum_target, GLdouble_v) \
	LP2NR(0x966, glMultiTexCoord2dvSGIS, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2fSGIS(GLenum_target, GLfloat_s, GLfloat_t) \
	LP3NR(0x96C, glMultiTexCoord2fSGIS, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2fvSGIS(GLenum_target, GLfloat_v) \
	LP2NR(0x972, glMultiTexCoord2fvSGIS, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2iSGIS(GLenum_target, GLint_s, GLint_t) \
	LP3NR(0x978, glMultiTexCoord2iSGIS, GLenum, GLenum_target, d0, GLint, GLint_s, d1, GLint, GLint_t, d2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2ivSGIS(GLenum_target, GLint_v) \
	LP2NR(0x97E, glMultiTexCoord2ivSGIS, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2sSGIS(GLenum_target, GLshort_s, GLshort_t) \
	LP3NR(0x984, glMultiTexCoord2sSGIS, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, GLshort, GLshort_t, d2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2svSGIS(GLenum_target, GLshort_v) \
	LP2NR(0x98A, glMultiTexCoord2svSGIS, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3dSGIS(GLenum_target, GLdouble_s, GLdouble_t, GLdouble_r) \
	LP4NR(0x990, glMultiTexCoord3dSGIS, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, GLdouble, GLdouble_r, fp2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3dvSGIS(GLenum_target, GLdouble_v) \
	LP2NR(0x996, glMultiTexCoord3dvSGIS, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3fSGIS(GLenum_target, GLfloat_s, GLfloat_t, GLfloat_r) \
	LP4NR(0x99C, glMultiTexCoord3fSGIS, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, GLfloat, GLfloat_r, fp2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3fvSGIS(GLenum_target, GLfloat_v) \
	LP2NR(0x9A2, glMultiTexCoord3fvSGIS, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3iSGIS(GLenum_target, GLint_s, GLint_t, GLint_r) \
	LP4NR(0x9A8, glMultiTexCoord3iSGIS, GLenum, GLenum_target, d0, GLint, GLint_s, d1, GLint, GLint_t, d2, GLint, GLint_r, d3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3ivSGIS(GLenum_target, GLint_v) \
	LP2NR(0x9AE, glMultiTexCoord3ivSGIS, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3sSGIS(GLenum_target, GLshort_s, GLshort_t, GLshort_r) \
	LP4NR(0x9B4, glMultiTexCoord3sSGIS, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, GLshort, GLshort_t, d2, GLshort, GLshort_r, d3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3svSGIS(GLenum_target, GLshort_v) \
	LP2NR(0x9BA, glMultiTexCoord3svSGIS, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4dSGIS(GLenum_target, GLdouble_s, GLdouble_t, GLdouble_r, GLdouble_q) \
	LP5NR(0x9C0, glMultiTexCoord4dSGIS, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, GLdouble, GLdouble_r, fp2, GLdouble, GLdouble_q, fp3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4dvSGIS(GLenum_target, GLdouble_v) \
	LP2NR(0x9C6, glMultiTexCoord4dvSGIS, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4fSGIS(GLenum_target, GLfloat_s, GLfloat_t, GLfloat_r, GLfloat_q) \
	LP5NR(0x9CC, glMultiTexCoord4fSGIS, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, GLfloat, GLfloat_r, fp2, GLfloat, GLfloat_q, fp3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4fvSGIS(GLenum_target, GLfloat_v) \
	LP2NR(0x9D2, glMultiTexCoord4fvSGIS, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4iSGIS(GLenum_target, GLint_s, GLint_t, GLint_r, GLint_q) \
	LP5NR(0x9D8, glMultiTexCoord4iSGIS, GLenum, GLenum_target, d0, GLint, GLint_s, d1, GLint, GLint_t, d2, GLint, GLint_r, d3, GLint, GLint_q, d4, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4ivSGIS(GLenum_target, GLint_v) \
	LP2NR(0x9DE, glMultiTexCoord4ivSGIS, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4sSGIS(GLenum_target, GLshort_s, GLshort_t, GLshort_r, GLshort_q) \
	LP5NR(0x9E4, glMultiTexCoord4sSGIS, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, GLshort, GLshort_t, d2, GLshort, GLshort_r, d3, GLshort, GLshort_q, d4, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4svSGIS(GLenum_target, GLshort_v) \
	LP2NR(0x9EA, glMultiTexCoord4svSGIS, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoordPointerSGIS(GLenum_target, GLint_size, GLenum_type, GLsizei_stride, GLvoid_pointer) \
	LP5NR(0x9F0, glMultiTexCoordPointerSGIS, GLenum, GLenum_target, d0, GLint, GLint_size, d1, GLenum, GLenum_type, d2, GLsizei, GLsizei_stride, d3, const GLvoid *, GLvoid_pointer, a0, \
	, AGL_BASE_NAME)

#define glSelectTextureSGIS(GLenum_target) \
	LP1NR(0x9F6, glSelectTextureSGIS, GLenum, GLenum_target, d0, \
	, AGL_BASE_NAME)

#define glSelectTextureCoordSetSGIS(GLenum_target) \
	LP1NR(0x9FC, glSelectTextureCoordSetSGIS, GLenum, GLenum_target, d0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1dEXT(GLenum_target, GLdouble_s) \
	LP2NR(0xA02, glMultiTexCoord1dEXT, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1dvEXT(GLenum_target, GLdouble_v) \
	LP2NR(0xA08, glMultiTexCoord1dvEXT, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1fEXT(GLenum_target, GLfloat_s) \
	LP2NR(0xA0E, glMultiTexCoord1fEXT, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1fvEXT(GLenum_target, GLfloat_v) \
	LP2NR(0xA14, glMultiTexCoord1fvEXT, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1iEXT(GLenum_target, GLint_s) \
	LP2NR(0xA1A, glMultiTexCoord1iEXT, GLenum, GLenum_target, d0, GLint, GLint_s, d1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1ivEXT(GLenum_target, GLint_v) \
	LP2NR(0xA20, glMultiTexCoord1ivEXT, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1sEXT(GLenum_target, GLshort_s) \
	LP2NR(0xA26, glMultiTexCoord1sEXT, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord1svEXT(GLenum_target, GLshort_v) \
	LP2NR(0xA2C, glMultiTexCoord1svEXT, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2dEXT(GLenum_target, GLdouble_s, GLdouble_t) \
	LP3NR(0xA32, glMultiTexCoord2dEXT, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2dvEXT(GLenum_target, GLdouble_v) \
	LP2NR(0xA38, glMultiTexCoord2dvEXT, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2fEXT(GLenum_target, GLfloat_s, GLfloat_t) \
	LP3NR(0xA3E, glMultiTexCoord2fEXT, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2fvEXT(GLenum_target, GLfloat_v) \
	LP2NR(0xA44, glMultiTexCoord2fvEXT, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2iEXT(GLenum_target, GLint_s, GLint_t) \
	LP3NR(0xA4A, glMultiTexCoord2iEXT, GLenum, GLenum_target, d0, GLint, GLint_s, d1, GLint, GLint_t, d2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2ivEXT(GLenum_target, GLint_v) \
	LP2NR(0xA50, glMultiTexCoord2ivEXT, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2sEXT(GLenum_target, GLshort_s, GLshort_t) \
	LP3NR(0xA56, glMultiTexCoord2sEXT, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, GLshort, GLshort_t, d2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord2svEXT(GLenum_target, GLshort_v) \
	LP2NR(0xA5C, glMultiTexCoord2svEXT, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3dEXT(GLenum_target, GLdouble_s, GLdouble_t, GLdouble_r) \
	LP4NR(0xA62, glMultiTexCoord3dEXT, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, GLdouble, GLdouble_r, fp2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3dvEXT(GLenum_target, GLdouble_v) \
	LP2NR(0xA68, glMultiTexCoord3dvEXT, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3fEXT(GLenum_target, GLfloat_s, GLfloat_t, GLfloat_r) \
	LP4NR(0xA6E, glMultiTexCoord3fEXT, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, GLfloat, GLfloat_r, fp2, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3fvEXT(GLenum_target, GLfloat_v) \
	LP2NR(0xA74, glMultiTexCoord3fvEXT, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3iEXT(GLenum_target, GLint_s, GLint_t, GLint_r) \
	LP4NR(0xA7A, glMultiTexCoord3iEXT, GLenum, GLenum_target, d0, GLint, GLint_s, d1, GLint, GLint_t, d2, GLint, GLint_r, d3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3ivEXT(GLenum_target, GLint_v) \
	LP2NR(0xA80, glMultiTexCoord3ivEXT, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3sEXT(GLenum_target, GLshort_s, GLshort_t, GLshort_r) \
	LP4NR(0xA86, glMultiTexCoord3sEXT, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, GLshort, GLshort_t, d2, GLshort, GLshort_r, d3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord3svEXT(GLenum_target, GLshort_v) \
	LP2NR(0xA8C, glMultiTexCoord3svEXT, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4dEXT(GLenum_target, GLdouble_s, GLdouble_t, GLdouble_r, GLdouble_q) \
	LP5NR(0xA92, glMultiTexCoord4dEXT, GLenum, GLenum_target, d0, GLdouble, GLdouble_s, fp0, GLdouble, GLdouble_t, fp1, GLdouble, GLdouble_r, fp2, GLdouble, GLdouble_q, fp3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4dvEXT(GLenum_target, GLdouble_v) \
	LP2NR(0xA98, glMultiTexCoord4dvEXT, GLenum, GLenum_target, d0, const GLdouble *, GLdouble_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4fEXT(GLenum_target, GLfloat_s, GLfloat_t, GLfloat_r, GLfloat_q) \
	LP5NR(0xA9E, glMultiTexCoord4fEXT, GLenum, GLenum_target, d0, GLfloat, GLfloat_s, fp0, GLfloat, GLfloat_t, fp1, GLfloat, GLfloat_r, fp2, GLfloat, GLfloat_q, fp3, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4fvEXT(GLenum_target, GLfloat_v) \
	LP2NR(0xAA4, glMultiTexCoord4fvEXT, GLenum, GLenum_target, d0, const GLfloat *, GLfloat_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4iEXT(GLenum_target, GLint_s, GLint_t, GLint_r, GLint_q) \
	LP5NR(0xAAA, glMultiTexCoord4iEXT, GLenum, GLenum_target, d0, GLint, GLint_s, d1, GLint, GLint_t, d2, GLint, GLint_r, d3, GLint, GLint_q, d4, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4ivEXT(GLenum_target, GLint_v) \
	LP2NR(0xAB0, glMultiTexCoord4ivEXT, GLenum, GLenum_target, d0, const GLint *, GLint_v, a0, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4sEXT(GLenum_target, GLshort_s, GLshort_t, GLshort_r, GLshort_q) \
	LP5NR(0xAB6, glMultiTexCoord4sEXT, GLenum, GLenum_target, d0, GLshort, GLshort_s, d1, GLshort, GLshort_t, d2, GLshort, GLshort_r, d3, GLshort, GLshort_q, d4, \
	, AGL_BASE_NAME)

#define glMultiTexCoord4svEXT(GLenum_target, GLshort_v) \
	LP2NR(0xABC, glMultiTexCoord4svEXT, GLenum, GLenum_target, d0, const GLshort *, GLshort_v, a0, \
	, AGL_BASE_NAME)

#define glInterleavedTextureCoordSetsEXT(GLint_factor) \
	LP1NR(0xAC2, glInterleavedTextureCoordSetsEXT, GLint, GLint_factor, d0, \
	, AGL_BASE_NAME)

#define glSelectTextureEXT(GLenum_target) \
	LP1NR(0xAC8, glSelectTextureEXT, GLenum, GLenum_target, d0, \
	, AGL_BASE_NAME)

#define glSelectTextureCoordSetEXT(GLenum_target) \
	LP1NR(0xACE, glSelectTextureCoordSetEXT, GLenum, GLenum_target, d0, \
	, AGL_BASE_NAME)

#define glSelectTextureTransformEXT(GLenum_target) \
	LP1NR(0xAD4, glSelectTextureTransformEXT, GLenum, GLenum_target, d0, \
	, AGL_BASE_NAME)

#define glPointParameterfEXT(GLenum_pname, GLfloat_param) \
	LP2NR(0xADA, glPointParameterfEXT, GLenum, GLenum_pname, d0, GLfloat, GLfloat_param, fp0, \
	, AGL_BASE_NAME)

#define glPointParameterfvEXT(GLenum_pname, GLfloat_params) \
	LP2NR(0xAE0, glPointParameterfvEXT, GLenum, GLenum_pname, d0, const GLfloat *, GLfloat_params, a0, \
	, AGL_BASE_NAME)

#define glWindowPos2iMESA(glint_x, glint_y) \
	LP2NR(0xAE6, glWindowPos2iMESA, GLint, glint_x, d0, GLint, glint_y, d1, \
	, AGL_BASE_NAME)

#define glWindowPos2sMESA(glshort_x, glshort_y) \
	LP2NR(0xAEC, glWindowPos2sMESA, GLshort, glshort_x, d0, GLshort, glshort_y, d1, \
	, AGL_BASE_NAME)

#define glWindowPos2fMESA(glfloat_x, glfloat_y) \
	LP2NR(0xAF2, glWindowPos2fMESA, GLfloat, glfloat_x, fp0, GLfloat, glfloat_y, fp1, \
	, AGL_BASE_NAME)

#define glWindowPos2dMESA(gldouble_x, gldouble_y) \
	LP2NR(0xAF8, glWindowPos2dMESA, GLdouble, gldouble_x, fp0, GLdouble, gldouble_y, fp1, \
	, AGL_BASE_NAME)

#define glWindowPos2ivMESA(glint_p) \
	LP1NR(0xAFE, glWindowPos2ivMESA, const GLint *, glint_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos2svMESA(glshort_p) \
	LP1NR(0xB04, glWindowPos2svMESA, const GLshort *, glshort_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos2fvMESA(glfloat_p) \
	LP1NR(0xB0A, glWindowPos2fvMESA, const GLfloat *, glfloat_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos2dvMESA(gldouble_p) \
	LP1NR(0xB10, glWindowPos2dvMESA, const GLdouble *, gldouble_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos3iMESA(glint_x, glint_y, glint_z) \
	LP3NR(0xB16, glWindowPos3iMESA, GLint, glint_x, d0, GLint, glint_y, d1, GLint, glint_z, d2, \
	, AGL_BASE_NAME)

#define glWindowPos3sMESA(glshort_x, glshort_y, glshort_z) \
	LP3NR(0xB1C, glWindowPos3sMESA, GLshort, glshort_x, d0, GLshort, glshort_y, d1, GLshort, glshort_z, d2, \
	, AGL_BASE_NAME)

#define glWindowPos3fMESA(glfloat_x, glfloat_y, glfloat_z) \
	LP3NR(0xB22, glWindowPos3fMESA, GLfloat, glfloat_x, fp0, GLfloat, glfloat_y, fp1, GLfloat, glfloat_z, fp2, \
	, AGL_BASE_NAME)

#define glWindowPos3dMESA(gldouble_x, gldouble_y, gldouble_z) \
	LP3NR(0xB28, glWindowPos3dMESA, GLdouble, gldouble_x, fp0, GLdouble, gldouble_y, fp1, GLdouble, gldouble_z, fp2, \
	, AGL_BASE_NAME)

#define glWindowPos3ivMESA(glint_p) \
	LP1NR(0xB2E, glWindowPos3ivMESA, const GLint *, glint_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos3svMESA(glshort_p) \
	LP1NR(0xB34, glWindowPos3svMESA, const GLshort *, glshort_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos3fvMESA(glfloat_p) \
	LP1NR(0xB3A, glWindowPos3fvMESA, const GLfloat *, glfloat_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos3dvMESA(gldouble_p) \
	LP1NR(0xB40, glWindowPos3dvMESA, const GLdouble *, gldouble_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos4iMESA(glint_x, glint_y, glint_z, glint_w) \
	LP4NR(0xB46, glWindowPos4iMESA, GLint, glint_x, d0, GLint, glint_y, d1, GLint, glint_z, d2, GLint, glint_w, d3, \
	, AGL_BASE_NAME)

#define glWindowPos4sMESA(glshort_x, glshort_y, glshort_z, glshort_w) \
	LP4NR(0xB4C, glWindowPos4sMESA, GLshort, glshort_x, d0, GLshort, glshort_y, d1, GLshort, glshort_z, d2, GLshort, glshort_w, d3, \
	, AGL_BASE_NAME)

#define glWindowPos4fMESA(glfloat_x, glfloat_y, glfloat_z, glfloat_w) \
	LP4NR(0xB52, glWindowPos4fMESA, GLfloat, glfloat_x, fp0, GLfloat, glfloat_y, fp1, GLfloat, glfloat_z, fp2, GLfloat, glfloat_w, fp3, \
	, AGL_BASE_NAME)

#define glWindowPos4dMESA(gldouble_x, gldouble_y, gldouble_z, gldouble_w) \
	LP4NR(0xB58, glWindowPos4dMESA, GLdouble, gldouble_x, fp0, GLdouble, gldouble_y, fp1, GLdouble, gldouble_z, fp2, GLdouble, gldouble_w, fp3, \
	, AGL_BASE_NAME)

#define glWindowPos4ivMESA(glint_p) \
	LP1NR(0xB5E, glWindowPos4ivMESA, const GLint *, glint_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos4svMESA(glshort_p) \
	LP1NR(0xB64, glWindowPos4svMESA, const GLshort *, glshort_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos4fvMESA(glfloat_p) \
	LP1NR(0xB6A, glWindowPos4fvMESA, const GLfloat *, glfloat_p, a0, \
	, AGL_BASE_NAME)

#define glWindowPos4dvMESA(gldouble_p) \
	LP1NR(0xB70, glWindowPos4dvMESA, const GLdouble *, gldouble_p, a0, \
	, AGL_BASE_NAME)

#define glResizeBuffersMESA() \
	LP0NR(0xB76, glResizeBuffersMESA, \
	, AGL_BASE_NAME)

#define glDrawRangeElements(GLenum_mode, GLuint_start, GLuint_end, GLsizei_count, GLenum_type, GLvoid_indices) \
	LP6NR(0xB7C, glDrawRangeElements, GLenum, GLenum_mode, d0, GLuint, GLuint_start, d1, GLuint, GLuint_end, d2, GLsizei, GLsizei_count, d3, GLenum, GLenum_type, d4, const GLvoid *, GLvoid_indices, a0, \
	, AGL_BASE_NAME)

#define glTexImage3D(GLenum_target, GLint_level, GLenum_internalFormat, GLsizei_width, _GLsizei_height, GLsizei_depth, GLint_border, GLenum_format, GLenum_type, GLvoid_pixels) \
	LP10NR(0xB82, glTexImage3D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLenum, GLenum_internalFormat, d2, GLsizei, GLsizei_width, d3, GLsizei, _GLsizei_height, d4, GLsizei, GLsizei_depth, d5, GLint, GLint_border, d6, GLenum, GLenum_format, d7, GLenum, GLenum_type, a0, const GLvoid *, GLvoid_pixels, a1, \
	, AGL_BASE_NAME)

#define glTexSubImage3D(GLenum_target, GLint_level, GLint_xoffset, GLint_yoffset, GLint_zoffset, GLsizei_width, GLsizei_height, GLsizei_depth, GLenum_format, GLenum_type, GLvoid_pixels) \
	LP11NR(0xB88, glTexSubImage3D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLint, GLint_yoffset, d3, GLint, GLint_zoffset, d4, GLsizei, GLsizei_width, d5, GLsizei, GLsizei_height, d6, GLsizei, GLsizei_depth, d7, GLenum, GLenum_format, a0, GLenum, GLenum_type, a1, const GLvoid *, GLvoid_pixels, a2, \
	, AGL_BASE_NAME)

#define glCopyTexSubImage3D(GLenum_target, GLint_level, GLint_xoffset, GLint_yoffset, GLint_zoffset, GLint_x, GLint_y, GLsizei_width, GLsizei_height) \
	LP9NR(0xB8E, glCopyTexSubImage3D, GLenum, GLenum_target, d0, GLint, GLint_level, d1, GLint, GLint_xoffset, d2, GLint, GLint_yoffset, d3, GLint, GLint_zoffset, d4, GLint, GLint_x, d5, GLint, GLint_y, d6, GLsizei, GLsizei_width, d7, GLsizei, GLsizei_height, a0, \
	, AGL_BASE_NAME)

#endif /*  _INLINE_AGL_H  */
