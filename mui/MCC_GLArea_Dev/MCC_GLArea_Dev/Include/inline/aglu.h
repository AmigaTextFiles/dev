#ifndef _INLINE_AGLU_H
#define _INLINE_AGLU_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef AGLU_BASE_NAME
#define AGLU_BASE_NAME gluBase
#endif

#define registerGLU(ptr) \
	LP1NR(0x1E, registerGLU, struct glureg *, ptr, a0, \
	, AGLU_BASE_NAME)

#define gluLookAt(GLdouble_eyex, GLdouble_eyey, GLdouble_eyez, GLdouble_centerx, GLdouble_centery, GLdouble_centerz, GLdouble_upx, GLdouble_upy, GLdouble_upz) \
	LP9NR(0x24, gluLookAt, GLdouble, GLdouble_eyex, fp0, GLdouble, GLdouble_eyey, fp1, GLdouble, GLdouble_eyez, fp2, GLdouble, GLdouble_centerx, fp3, GLdouble, GLdouble_centery, fp4, GLdouble, GLdouble_centerz, fp5, GLdouble, GLdouble_upx, fp6, GLdouble, GLdouble_upy, fp7, GLdouble, GLdouble_upz, d0, \
	, AGLU_BASE_NAME)

#define gluOrtho2D(GLdouble_left, GLdouble_right, GLdouble_bottom, GLdouble_top) \
	LP4NR(0x2A, gluOrtho2D, GLdouble, GLdouble_left, fp0, GLdouble, GLdouble_right, fp1, GLdouble, GLdouble_bottom, fp2, GLdouble, GLdouble_top, fp3, \
	, AGLU_BASE_NAME)

#define gluPerspective(GLdouble_fovy, GLdouble_aspect, GLdouble_zNear, GLdouble_zFar) \
	LP4NR(0x30, gluPerspective, GLdouble, GLdouble_fovy, fp0, GLdouble, GLdouble_aspect, fp1, GLdouble, GLdouble_zNear, fp2, GLdouble, GLdouble_zFar, fp3, \
	, AGLU_BASE_NAME)

#define gluPickMatrix(GLdouble_x, GLdouble_y, GLdouble_width, GLdouble_height, GLint_viewport) \
	LP5NR(0x36, gluPickMatrix, GLdouble, GLdouble_x, fp0, GLdouble, GLdouble_y, fp1, GLdouble, GLdouble_width, fp2, GLdouble, GLdouble_height, fp3, const GLint, GLint_viewport, a0, \
	, AGLU_BASE_NAME)

#define gluProject(GLdouble_objx, GLdouble_objy, GLdouble_objz, GLdouble_modelMatrix, GLdouble_projMatrix, GLint_viewport, GLdouble_winx, GLdouble_winy, GLdouble_winz) \
	LP9(0x3C, GLint, gluProject, GLdouble, GLdouble_objx, fp0, GLdouble, GLdouble_objy, fp1, GLdouble, GLdouble_objz, fp2, const GLdouble, GLdouble_modelMatrix, a0, const GLdouble, GLdouble_projMatrix, a1, const GLint, GLint_viewport, a2, GLdouble *, GLdouble_winx, a3, GLdouble *, GLdouble_winy, d0, GLdouble *, GLdouble_winz, d1, \
	, AGLU_BASE_NAME)

#define gluUnProject(GLdouble_winx, GLdouble_winy, GLdouble_winz, GLdouble_modelMatrix, GLdouble_projMatrix, GLint_viewport, GLdouble_objx, GLdouble_objy, GLdouble_objz) \
	LP9(0x42, GLint, gluUnProject, GLdouble, GLdouble_winx, fp0, GLdouble, GLdouble_winy, fp1, GLdouble, GLdouble_winz, fp2, const GLdouble, GLdouble_modelMatrix, a0, const GLdouble, GLdouble_projMatrix, a1, const GLint, GLint_viewport, a2, GLdouble *, GLdouble_objx, a3, GLdouble *, GLdouble_objy, d0, GLdouble *, GLdouble_objz, d1, \
	, AGLU_BASE_NAME)

#define gluErrorString(GLenum_errorCode) \
	LP1(0x48, const GLubyte*, gluErrorString, GLenum, GLenum_errorCode, d0, \
	, AGLU_BASE_NAME)

#define gluScaleImage(GLenum_format, GLint_widthin, GLint_heightin, GLenum_typein, void_datain, GLint_widthout, GLint_heightout, GLenum_typeout, void_dataout) \
	LP9(0x4E, GLint, gluScaleImage, GLenum, GLenum_format, d0, GLint, GLint_widthin, d1, GLint, GLint_heightin, d2, GLenum, GLenum_typein, d3, const void *, void_datain, a0, GLint, GLint_widthout, d4, GLint, GLint_heightout, d5, GLenum, GLenum_typeout, d6, void *, void_dataout, a1, \
	, AGLU_BASE_NAME)

#define gluBuild1DMipmaps(GLenum_target, GLint_components, GLint_width, GLenum_format, GLenum_type, void_data) \
	LP6(0x54, GLint, gluBuild1DMipmaps, GLenum, GLenum_target, d0, GLint, GLint_components, d1, GLint, GLint_width, d2, GLenum, GLenum_format, d3, GLenum, GLenum_type, d4, const void *, void_data, a0, \
	, AGLU_BASE_NAME)

#define gluBuild2DMipmaps(GLenum_target, GLint_components, GLint_width, GLint_height, GLenum_format, GLenum_type, void_data) \
	LP7(0x5A, GLint, gluBuild2DMipmaps, GLenum, GLenum_target, d0, GLint, GLint_components, d1, GLint, GLint_width, d2, GLint, GLint_height, d3, GLenum, GLenum_format, d4, GLenum, GLenum_type, d5, const void *, void_data, a0, \
	, AGLU_BASE_NAME)

#define gluNewQuadric() \
	LP0(0x60, GLUquadricObj*, gluNewQuadric, \
	, AGLU_BASE_NAME)

#define gluDeleteQuadric(GLUquadricObj_state) \
	LP1NR(0x66, gluDeleteQuadric, GLUquadricObj *, GLUquadricObj_state, a0, \
	, AGLU_BASE_NAME)

#define gluQuadricDrawStyle(GLUquadricObj_quadObject, GLenum_drawStyle) \
	LP2NR(0x6C, gluQuadricDrawStyle, GLUquadricObj *, GLUquadricObj_quadObject, a0, GLenum, GLenum_drawStyle, d0, \
	, AGLU_BASE_NAME)

#define gluQuadricOrientation(GLUquadricObj_quadObject, GLenum_orientation) \
	LP2NR(0x72, gluQuadricOrientation, GLUquadricObj *, GLUquadricObj_quadObject, a0, GLenum, GLenum_orientation, d0, \
	, AGLU_BASE_NAME)

#define gluQuadricNormals(GLUquadricObj_quadObject, GLenum_normals) \
	LP2NR(0x78, gluQuadricNormals, GLUquadricObj *, GLUquadricObj_quadObject, a0, GLenum, GLenum_normals, d0, \
	, AGLU_BASE_NAME)

#define gluQuadricTexture(GLUquadricObj_quadObject, GLboolean_textureCoords) \
	LP2NR(0x7E, gluQuadricTexture, GLUquadricObj *, GLUquadricObj_quadObject, a0, GLboolean, GLboolean_textureCoords, d0, \
	, AGLU_BASE_NAME)

#define gluCylinder(GLUquadricObj_qobj, GLdouble_baseRadius, GLdouble_topRadius, GLdouble_height, GLint_slices, GLint_stacks) \
	LP6NR(0x8A, gluCylinder, GLUquadricObj *, GLUquadricObj_qobj, a0, GLdouble, GLdouble_baseRadius, fp0, GLdouble, GLdouble_topRadius, fp1, GLdouble, GLdouble_height, fp2, GLint, GLint_slices, d0, GLint, GLint_stacks, d1, \
	, AGLU_BASE_NAME)

#define gluSphere(GLUquadricObj_obj, GLdouble_radius, GLint_slices, GLint_stacks) \
	LP4NR(0x90, gluSphere, GLUquadricObj *, GLUquadricObj_obj, a0, GLdouble, GLdouble_radius, fp0, GLint, GLint_slices, d0, GLint, GLint_stacks, d1, \
	, AGLU_BASE_NAME)

#define gluDisk(GLUquadricObj_qobj, GLdouble_InnerRadius, GLdouble_outerRadius, GLint_slices, GLint_loops) \
	LP5NR(0x96, gluDisk, GLUquadricObj *, GLUquadricObj_qobj, a0, GLdouble, GLdouble_InnerRadius, fp0, GLdouble, GLdouble_outerRadius, fp1, GLint, GLint_slices, d0, GLint, GLint_loops, d1, \
	, AGLU_BASE_NAME)

#define gluPartialDisk(GLUquadricObj_qobj, GLdouble_innerRadius, GLdouble_outerRadius, GLint_slices, GLint_loops, GLdouble_startAngle, GLdouble_sweepAngle) \
	LP7NR(0x9C, gluPartialDisk, GLUquadricObj *, GLUquadricObj_qobj, a0, GLdouble, GLdouble_innerRadius, fp0, GLdouble, GLdouble_outerRadius, fp1, GLint, GLint_slices, d0, GLint, GLint_loops, d1, GLdouble, GLdouble_startAngle, fp2, GLdouble, GLdouble_sweepAngle, fp3, \
	, AGLU_BASE_NAME)

#define gluNewNurbsRenderer() \
	LP0(0xA2, GLUnurbsObj*, gluNewNurbsRenderer, \
	, AGLU_BASE_NAME)

#define gluDeleteNurbsRenderer(GLUnurbsObj_nobj) \
	LP1NR(0xA8, gluDeleteNurbsRenderer, GLUnurbsObj *, GLUnurbsObj_nobj, a0, \
	, AGLU_BASE_NAME)

#define gluLoadSamplingMatrices(GLUnurbsObj_nobj, GLfloat_modelMatrix, GLfloat_projMatrix, GLint_viewport) \
	LP4NR(0xAE, gluLoadSamplingMatrices, GLUnurbsObj *, GLUnurbsObj_nobj, a0, const GLfloat, GLfloat_modelMatrix, a1, const GLfloat, GLfloat_projMatrix, a2, const GLint, GLint_viewport, a3, \
	, AGLU_BASE_NAME)

#define gluNurbsProperty(GLUnurbsObj_nobj, GLenum_property, GLfloat_value) \
	LP3NR(0xB4, gluNurbsProperty, GLUnurbsObj *, GLUnurbsObj_nobj, a0, GLenum, GLenum_property, d0, GLfloat, GLfloat_value, fp0, \
	, AGLU_BASE_NAME)

#define gluGetNurbsProperty(GLUnurbsObj_nobj, GLenum_property, GLfloat_value) \
	LP3NR(0xBA, gluGetNurbsProperty, GLUnurbsObj *, GLUnurbsObj_nobj, a0, GLenum, GLenum_property, d0, GLfloat *, GLfloat_value, a1, \
	, AGLU_BASE_NAME)

#define gluBeginCurve(GLUnurbsObj_nobj) \
	LP1NR(0xC0, gluBeginCurve, GLUnurbsObj *, GLUnurbsObj_nobj, a0, \
	, AGLU_BASE_NAME)

#define gluEndCurve(GLUnurbsObj_nobj) \
	LP1NR(0xC6, gluEndCurve, GLUnurbsObj *, GLUnurbsObj_nobj, a0, \
	, AGLU_BASE_NAME)

#define gluNurbsCurve(GLUnurbsObj_nobj, GLint_nknots, GLfloat_knot, GLint_stride, GLfloat_ctlarray, GLint_order, GLenum_type) \
	LP7NR(0xCC, gluNurbsCurve, GLUnurbsObj *, GLUnurbsObj_nobj, a0, GLint, GLint_nknots, d0, GLfloat *, GLfloat_knot, a1, GLint, GLint_stride, d1, GLfloat *, GLfloat_ctlarray, a2, GLint, GLint_order, d2, GLenum, GLenum_type, d3, \
	, AGLU_BASE_NAME)

#define gluBeginSurface(GLUnurbsObj_nobj) \
	LP1NR(0xD2, gluBeginSurface, GLUnurbsObj *, GLUnurbsObj_nobj, a0, \
	, AGLU_BASE_NAME)

#define gluEndSurface(GLUnurbsObj_nobj) \
	LP1NR(0xD8, gluEndSurface, GLUnurbsObj *, GLUnurbsObj_nobj, a0, \
	, AGLU_BASE_NAME)

#define gluNurbsSurface(GLUnurbsObj_nobj, GLint_sknot_count, GLfloat_sknot, GLint_tknot_count, GLfloat_tknot, GLint_s_stride, GLint_t_stride, GLfloat_ctlarray, GLint_sorder, GLint_torder, GLenum_type) \
	LP11NR(0xDE, gluNurbsSurface, GLUnurbsObj *, GLUnurbsObj_nobj, a0, GLint, GLint_sknot_count, d0, GLfloat *, GLfloat_sknot, a1, GLint, GLint_tknot_count, d1, GLfloat *, GLfloat_tknot, a2, GLint, GLint_s_stride, d2, GLint, GLint_t_stride, d3, GLfloat *, GLfloat_ctlarray, a3, GLint, GLint_sorder, d4, GLint, GLint_torder, d5, GLenum, GLenum_type, d6, \
	, AGLU_BASE_NAME)

#define gluBeginTrim(GLUnurbsObj_nobj) \
	LP1NR(0xE4, gluBeginTrim, GLUnurbsObj *, GLUnurbsObj_nobj, a0, \
	, AGLU_BASE_NAME)

#define gluEndTrim(GLUnurbsObj_nobj) \
	LP1NR(0xEA, gluEndTrim, GLUnurbsObj *, GLUnurbsObj_nobj, a0, \
	, AGLU_BASE_NAME)

#define gluPwlCurve(GLUnurbsObj_nobj, GLint_count, GLfloat_array, GLint_stride, GLenum_type) \
	LP5NR(0xF0, gluPwlCurve, GLUnurbsObj *, GLUnurbsObj_nobj, a0, GLint, GLint_count, d0, GLfloat *, GLfloat_array, a1, GLint, GLint_stride, d1, GLenum, GLenum_type, d2, \
	, AGLU_BASE_NAME)

#define gluNewTess() \
	LP0(0xFC, GLUtriangulatorObj*, gluNewTess, \
	, AGLU_BASE_NAME)

#define gluDeleteTess(GLUtriangulatorObj_tobj) \
	LP1NR(0x108, gluDeleteTess, GLUtriangulatorObj *, GLUtriangulatorObj_tobj, a0, \
	, AGLU_BASE_NAME)

#define gluBeginPolygon(GLUtriangulatorObj_tobj) \
	LP1NR(0x10E, gluBeginPolygon, GLUtriangulatorObj *, GLUtriangulatorObj_tobj, a0, \
	, AGLU_BASE_NAME)

#define gluEndPolygon(GLUtriangulatorObj_tobj) \
	LP1NR(0x114, gluEndPolygon, GLUtriangulatorObj *, GLUtriangulatorObj_tobj, a0, \
	, AGLU_BASE_NAME)

#define gluNextContour(GLUtriangulatorObj_tobj, GLenum_type) \
	LP2NR(0x11A, gluNextContour, GLUtriangulatorObj *, GLUtriangulatorObj_tobj, a0, GLenum, GLenum_type, d0, \
	, AGLU_BASE_NAME)

#define gluTessVertex(GLUtriangulatorObj_tobj, GLdouble_v, void_data) \
	LP3NR(0x120, gluTessVertex, GLUtriangulatorObj *, GLUtriangulatorObj_tobj, a0, GLdouble, GLdouble_v, a1, void *, void_data, a2, \
	, AGLU_BASE_NAME)

#define gluGetString(GLenum_name) \
	LP1(0x126, const GLubyte*, gluGetString, GLenum, GLenum_name, d0, \
	, AGLU_BASE_NAME)

#endif /*  _INLINE_AGLU_H  */
