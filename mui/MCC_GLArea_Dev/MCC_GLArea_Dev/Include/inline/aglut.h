#ifndef _INLINE_AGLUT_H
#define _INLINE_AGLUT_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef AGLUT_BASE_NAME
#define AGLUT_BASE_NAME glutBase
#endif

#define registerGLUT(ptr) \
	LP1NR(0x1E, registerGLUT, struct glutreg *, ptr, a0, \
	, AGLUT_BASE_NAME)

#define glutInit(int_argcp, char_argv) \
	LP2NR(0x24, glutInit, int *, int_argcp, a0, char **, char_argv, a1, \
	, AGLUT_BASE_NAME)

#define glutInitDisplayMode(unsigned_int_mode) \
	LP1NR(0x2A, glutInitDisplayMode, unsigned int, unsigned_int_mode, d0, \
	, AGLUT_BASE_NAME)

#define glutInitDisplayString(const_char_string) \
	LP1NR(0x30, glutInitDisplayString, const char *, const_char_string, a0, \
	, AGLUT_BASE_NAME)

#define glutInitWindowPosition(int_x, int_y) \
	LP2NR(0x36, glutInitWindowPosition, int, int_x, d0, int, int_y, d1, \
	, AGLUT_BASE_NAME)

#define glutInitWindowSize(int_width, int_height) \
	LP2NR(0x3C, glutInitWindowSize, int, int_width, d0, int, int_height, d1, \
	, AGLUT_BASE_NAME)

#define glutMainLoop() \
	LP0NR(0x42, glutMainLoop, \
	, AGLUT_BASE_NAME)

#define glutCreateWindow(const_char_title) \
	LP1(0x48, int, glutCreateWindow, const char *, const_char_title, a0, \
	, AGLUT_BASE_NAME)

#define glutCreateSubWindow(int_win, int_x, int_y, int_width, int_height) \
	LP5(0x4E, int, glutCreateSubWindow, int, int_win, d0, int, int_x, d1, int, int_y, d2, int, int_width, d3, int, int_height, d4, \
	, AGLUT_BASE_NAME)

#define glutDestroyWindow(int_win) \
	LP1NR(0x54, glutDestroyWindow, int, int_win, d0, \
	, AGLUT_BASE_NAME)

#define glutPostRedisplay() \
	LP0NR(0x5A, glutPostRedisplay, \
	, AGLUT_BASE_NAME)

#define glutSwapBuffers() \
	LP0NR(0x60, glutSwapBuffers, \
	, AGLUT_BASE_NAME)

#define glutGetWindow() \
	LP0(0x66, int, glutGetWindow, \
	, AGLUT_BASE_NAME)

#define glutSetWindow(int_win) \
	LP1NR(0x6C, glutSetWindow, int, int_win, d0, \
	, AGLUT_BASE_NAME)

#define glutSetWindowTitle(const_char_title) \
	LP1NR(0x72, glutSetWindowTitle, const char *, const_char_title, a0, \
	, AGLUT_BASE_NAME)

#define glutSetIconTitle(const_char_title) \
	LP1NR(0x78, glutSetIconTitle, const char *, const_char_title, a0, \
	, AGLUT_BASE_NAME)

#define glutPositionWindow(int_x, int_y) \
	LP2NR(0x7E, glutPositionWindow, int, int_x, d0, int, int_y, d1, \
	, AGLUT_BASE_NAME)

#define glutReshapeWindow(int_width, int_height) \
	LP2NR(0x84, glutReshapeWindow, int, int_width, d0, int, int_height, d1, \
	, AGLUT_BASE_NAME)

#define glutPopWindow() \
	LP0NR(0x8A, glutPopWindow, \
	, AGLUT_BASE_NAME)

#define glutPushWindow() \
	LP0NR(0x90, glutPushWindow, \
	, AGLUT_BASE_NAME)

#define glutIconifyWindow() \
	LP0NR(0x96, glutIconifyWindow, \
	, AGLUT_BASE_NAME)

#define glutShowWindow() \
	LP0NR(0x9C, glutShowWindow, \
	, AGLUT_BASE_NAME)

#define glutHideWindow() \
	LP0NR(0xA2, glutHideWindow, \
	, AGLUT_BASE_NAME)

#define glutFullScreen() \
	LP0NR(0xA8, glutFullScreen, \
	, AGLUT_BASE_NAME)

#define glutSetCursor(int_cursor) \
	LP1NR(0xAE, glutSetCursor, int, int_cursor, d0, \
	, AGLUT_BASE_NAME)

#define glutWarpPointer(int_x, int_y) \
	LP2NR(0xB4, glutWarpPointer, int, int_x, d0, int, int_y, d1, \
	, AGLUT_BASE_NAME)

#define glutEstablishOverlay() \
	LP0NR(0xBA, glutEstablishOverlay, \
	, AGLUT_BASE_NAME)

#define glutRemoveOverlay() \
	LP0NR(0xC0, glutRemoveOverlay, \
	, AGLUT_BASE_NAME)

#define glutUseLayer(GLenum_layer) \
	LP1NR(0xC6, glutUseLayer, GLenum, GLenum_layer, d0, \
	, AGLUT_BASE_NAME)

#define glutPostOverlayRedisplay() \
	LP0NR(0xCC, glutPostOverlayRedisplay, \
	, AGLUT_BASE_NAME)

#define glutShowOverlay() \
	LP0NR(0xD2, glutShowOverlay, \
	, AGLUT_BASE_NAME)

#define glutHideOverlay() \
	LP0NR(0xD8, glutHideOverlay, \
	, AGLUT_BASE_NAME)

#define glutCreateMenu(ptr) \
	LP1FP(0xDE, int, glutCreateMenu, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int))

#define glutDestroyMenu(int_menu) \
	LP1NR(0xE4, glutDestroyMenu, int, int_menu, d0, \
	, AGLUT_BASE_NAME)

#define glutGetMenu() \
	LP0(0xEA, int, glutGetMenu, \
	, AGLUT_BASE_NAME)

#define glutSetMenu(int_menu) \
	LP1NR(0xF0, glutSetMenu, int, int_menu, d0, \
	, AGLUT_BASE_NAME)

#define glutAddMenuEntry(const_char_label, int_value) \
	LP2NR(0xF6, glutAddMenuEntry, const char *, const_char_label, a0, int, int_value, d0, \
	, AGLUT_BASE_NAME)

#define glutAddSubMenu(const_char_label, int_submenu) \
	LP2NR(0xFC, glutAddSubMenu, const char *, const_char_label, a0, int, int_submenu, d0, \
	, AGLUT_BASE_NAME)

#define glutChangeToMenuEntry(int_item, const_char_label, int_value) \
	LP3NR(0x102, glutChangeToMenuEntry, int, int_item, d0, const char *, const_char_label, a0, int, int_value, d1, \
	, AGLUT_BASE_NAME)

#define glutChangeToSubMenu(int_item, const_char_label, int_submenu) \
	LP3NR(0x108, glutChangeToSubMenu, int, int_item, d0, const char *, const_char_label, a0, int, int_submenu, d1, \
	, AGLUT_BASE_NAME)

#define glutRemoveMenuItem(int_item) \
	LP1NR(0x10E, glutRemoveMenuItem, int, int_item, d0, \
	, AGLUT_BASE_NAME)

#define glutAttachMenu(int_button) \
	LP1NR(0x114, glutAttachMenu, int, int_button, d0, \
	, AGLUT_BASE_NAME)

#define glutDetachMenu(int_button) \
	LP1NR(0x11A, glutDetachMenu, int, int_button, d0, \
	, AGLUT_BASE_NAME)

#define glutDisplayFunc(ptr) \
	LP1NRFP(0x120, glutDisplayFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(void))

#define glutReshapeFunc(ptr) \
	LP1NRFP(0x126, glutReshapeFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int width, int height))

#define glutKeyboardFunc(ptr) \
	LP1NRFP(0x12C, glutKeyboardFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(unsigned char key, int x, int y))

#define glutMouseFunc(ptr) \
	LP1NRFP(0x132, glutMouseFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int button, int state, int x, int y))

#define glutMotionFunc(ptr) \
	LP1NRFP(0x138, glutMotionFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int x, int y))

#define glutPassiveMotionFunc(ptr) \
	LP1NRFP(0x13E, glutPassiveMotionFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int x, int y))

#define glutEntryFunc(ptr) \
	LP1NRFP(0x144, glutEntryFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int state))

#define glutVisibilityFunc(ptr) \
	LP1NRFP(0x14A, glutVisibilityFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int state))

#define glutIdleFunc(ptr) \
	LP1NRFP(0x150, glutIdleFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(void))

#define glutTimerFunc(unsigned_int_millis, ptr, value) \
	LP3NRFP(0x156, glutTimerFunc, unsigned int, unsigned_int_millis, d0, __fpt, ptr, a0, int, value, d1, \
	, AGLUT_BASE_NAME, void (*__fpt)(int value))

#define glutMenuStateFunc(ptr) \
	LP1NRFP(0x15C, glutMenuStateFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int state))

#define glutSpecialFunc(ptr) \
	LP1NRFP(0x162, glutSpecialFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int key, int x, int y))

#define glutSpaceballMotionFunc(ptr) \
	LP1NRFP(0x168, glutSpaceballMotionFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int x, int y, int z))

#define glutSpaceballRotateFunc(ptr) \
	LP1NRFP(0x16E, glutSpaceballRotateFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int x, int y, int z))

#define glutSpaceballButtonFunc(ptr) \
	LP1NRFP(0x174, glutSpaceballButtonFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int button, int state))

#define glutButtonBoxFunc(ptr) \
	LP1NRFP(0x17A, glutButtonBoxFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int button, int state))

#define glutDialsFunc(ptr) \
	LP1NRFP(0x180, glutDialsFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int dial, int value))

#define glutTabletMotionFunc(ptr) \
	LP1NRFP(0x186, glutTabletMotionFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int x, int y))

#define glutTabletButtonFunc(ptr) \
	LP1NRFP(0x18C, glutTabletButtonFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int button, int state, int x, int y))

#define glutMenuStatusFunc(ptr) \
	LP1NRFP(0x192, glutMenuStatusFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int status, int x, int y))

#define glutOverlayDisplayFunc(ptr) \
	LP1NRFP(0x198, glutOverlayDisplayFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(void))

#define glutWindowStatusFunc(ptr) \
	LP1NRFP(0x19E, glutWindowStatusFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int state))

#define glutSetColor(int, GLfloat_red, GLfloat_green, GLfloat_blue) \
	LP4NR(0x1A4, glutSetColor, int, int, d0, GLfloat, GLfloat_red, fp0, GLfloat, GLfloat_green, fp1, GLfloat, GLfloat_blue, fp2, \
	, AGLUT_BASE_NAME)

#define glutGetColor(int_ndx, int_component) \
	LP2(0x1AA, GLfloat, glutGetColor, int, int_ndx, d0, int, int_component, d1, \
	, AGLUT_BASE_NAME)

#define glutCopyColormap(int_win) \
	LP1NR(0x1B0, glutCopyColormap, int, int_win, d0, \
	, AGLUT_BASE_NAME)

#define glutGet(GLenum_type) \
	LP1(0x1B6, int, glutGet, GLenum, GLenum_type, d0, \
	, AGLUT_BASE_NAME)

#define glutDeviceGet(GLenum_type) \
	LP1(0x1BC, int, glutDeviceGet, GLenum, GLenum_type, d0, \
	, AGLUT_BASE_NAME)

#define glutExtensionSupported(const_char_name) \
	LP1(0x1C2, int, glutExtensionSupported, const char *, const_char_name, a0, \
	, AGLUT_BASE_NAME)

#define glutGetModifiers() \
	LP0(0x1C8, int, glutGetModifiers, \
	, AGLUT_BASE_NAME)

#define glutLayerGet(GLenum_type) \
	LP1(0x1CE, int, glutLayerGet, GLenum, GLenum_type, d0, \
	, AGLUT_BASE_NAME)

#define glutBitmapCharacter(void_font, int_character) \
	LP2NR(0x1D4, glutBitmapCharacter, void *, void_font, a0, int, int_character, d0, \
	, AGLUT_BASE_NAME)

#define glutBitmapWidth(void_font, int_character) \
	LP2(0x1DA, int, glutBitmapWidth, void *, void_font, a0, int, int_character, d0, \
	, AGLUT_BASE_NAME)

#define glutStrokeCharacter(void_font, int_character) \
	LP2NR(0x1E0, glutStrokeCharacter, void *, void_font, a0, int, int_character, d0, \
	, AGLUT_BASE_NAME)

#define glutStrokeWidth(void_font, int_character) \
	LP2(0x1E6, int, glutStrokeWidth, void *, void_font, a0, int, int_character, d0, \
	, AGLUT_BASE_NAME)

#define glutBitmapLength(void_font, const_unsigned_char_string) \
	LP2(0x1EC, int, glutBitmapLength, void *, void_font, a0, const unsigned char *, const_unsigned_char_string, a1, \
	, AGLUT_BASE_NAME)

#define glutStrokeLength(void_font, const_unsigned_char_string) \
	LP2(0x1F2, int, glutStrokeLength, void *, void_font, a0, const unsigned char *, const_unsigned_char_string, a1, \
	, AGLUT_BASE_NAME)

#define glutWireSphere(GLdouble_radius, GLint_slices, GLint_stacks) \
	LP3NR(0x1F8, glutWireSphere, GLdouble, GLdouble_radius, fp0, GLint, GLint_slices, d0, GLint, GLint_stacks, d1, \
	, AGLUT_BASE_NAME)

#define glutSolidSphere(GLdouble_radius, GLint_slices, GLint_stacks) \
	LP3NR(0x1FE, glutSolidSphere, GLdouble, GLdouble_radius, fp0, GLint, GLint_slices, d0, GLint, GLint_stacks, d1, \
	, AGLUT_BASE_NAME)

#define glutWireCone(GLdouble_base, GLdouble_height, GLint_slices, GLint_stacks) \
	LP4NR(0x204, glutWireCone, GLdouble, GLdouble_base, fp0, GLdouble, GLdouble_height, fp1, GLint, GLint_slices, d0, GLint, GLint_stacks, d1, \
	, AGLUT_BASE_NAME)

#define glutSolidCone(GLdouble_base, GLdouble_height, GLint_slices, GLint_stacks) \
	LP4NR(0x20A, glutSolidCone, GLdouble, GLdouble_base, fp0, GLdouble, GLdouble_height, fp1, GLint, GLint_slices, d0, GLint, GLint_stacks, d1, \
	, AGLUT_BASE_NAME)

#define glutWireCube(GLdouble_size) \
	LP1NR(0x210, glutWireCube, GLdouble, GLdouble_size, fp0, \
	, AGLUT_BASE_NAME)

#define glutSolidCube(GLdouble_size) \
	LP1NR(0x216, glutSolidCube, GLdouble, GLdouble_size, fp0, \
	, AGLUT_BASE_NAME)

#define glutWireTorus(GLdouble_innerRadius, GLdouble_outerRadius, GLint_sides, GLint_rings) \
	LP4NR(0x21C, glutWireTorus, GLdouble, GLdouble_innerRadius, fp0, GLdouble, GLdouble_outerRadius, fp1, GLint, GLint_sides, d0, GLint, GLint_rings, d1, \
	, AGLUT_BASE_NAME)

#define glutSolidTorus(GLdouble_innerRadius, GLdouble_outerRadius, GLint_sides, GLint_rings) \
	LP4NR(0x222, glutSolidTorus, GLdouble, GLdouble_innerRadius, fp0, GLdouble, GLdouble_outerRadius, fp1, GLint, GLint_sides, d0, GLint, GLint_rings, d1, \
	, AGLUT_BASE_NAME)

#define glutWireDodecahedron() \
	LP0NR(0x228, glutWireDodecahedron, \
	, AGLUT_BASE_NAME)

#define glutSolidDodecahedron() \
	LP0NR(0x22E, glutSolidDodecahedron, \
	, AGLUT_BASE_NAME)

#define glutWireTeapot(GLdouble_size) \
	LP1NR(0x234, glutWireTeapot, GLdouble, GLdouble_size, fp0, \
	, AGLUT_BASE_NAME)

#define glutSolidTeapot(GLdouble_size) \
	LP1NR(0x23A, glutSolidTeapot, GLdouble, GLdouble_size, fp0, \
	, AGLUT_BASE_NAME)

#define glutWireOctahedron() \
	LP0NR(0x240, glutWireOctahedron, \
	, AGLUT_BASE_NAME)

#define glutSolidOctahedron() \
	LP0NR(0x246, glutSolidOctahedron, \
	, AGLUT_BASE_NAME)

#define glutWireTetrahedron() \
	LP0NR(0x24C, glutWireTetrahedron, \
	, AGLUT_BASE_NAME)

#define glutSolidTetrahedron() \
	LP0NR(0x252, glutSolidTetrahedron, \
	, AGLUT_BASE_NAME)

#define glutWireIcosahedron() \
	LP0NR(0x258, glutWireIcosahedron, \
	, AGLUT_BASE_NAME)

#define glutSolidIcosahedron() \
	LP0NR(0x25E, glutSolidIcosahedron, \
	, AGLUT_BASE_NAME)

#define glutVideoResizeGet(GLenum_param) \
	LP1(0x264, int, glutVideoResizeGet, GLenum, GLenum_param, d0, \
	, AGLUT_BASE_NAME)

#define glutSetupVideoResizing() \
	LP0NR(0x26A, glutSetupVideoResizing, \
	, AGLUT_BASE_NAME)

#define glutStopVideoResizing() \
	LP0NR(0x270, glutStopVideoResizing, \
	, AGLUT_BASE_NAME)

#define glutVideoResize(int_x, int_y, int_width, int_height) \
	LP4NR(0x276, glutVideoResize, int, int_x, d0, int, int_y, d1, int, int_width, d2, int, int_height, d3, \
	, AGLUT_BASE_NAME)

#define glutVideoPan(int_x, int_y, int_width, int_height) \
	LP4NR(0x27C, glutVideoPan, int, int_x, d0, int, int_y, d1, int, int_width, d2, int, int_height, d3, \
	, AGLUT_BASE_NAME)

#define glutReportErrors() \
	LP0NR(0x282, glutReportErrors, \
	, AGLUT_BASE_NAME)

#define glutKeyboardUpFunc(ptr) \
	LP1NRFP(0x288, glutKeyboardUpFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(unsigned char key, int x, int y))

#define glutSpecialUpFunc(ptr) \
	LP1NRFP(0x28E, glutSpecialUpFunc, __fpt, ptr, a0, \
	, AGLUT_BASE_NAME, void (*__fpt)(int key, int x, int y))

#define glutJoystickFunc(ptr, int_pollInterval) \
	LP2NRFP(0x294, glutJoystickFunc, __fpt, ptr, a0, int, int_pollInterval, d0, \
	, AGLUT_BASE_NAME, void (*__fpt)(unsigned int buttonMask, int x, int y, int z))

#define glutIgnoreKeyRepeat(int_ignore) \
	LP1NR(0x29A, glutIgnoreKeyRepeat, int, int_ignore, d0, \
	, AGLUT_BASE_NAME)

#define glutSetKeyRepeat(int_repeatMode) \
	LP1NR(0x2A0, glutSetKeyRepeat, int, int_repeatMode, d0, \
	, AGLUT_BASE_NAME)

#define glutForceJoystickFunc() \
	LP0NR(0x2A6, glutForceJoystickFunc, \
	, AGLUT_BASE_NAME)

#define glutEnterGameMode() \
	LP0(0x2AC, int, glutEnterGameMode, \
	, AGLUT_BASE_NAME)

#define glutLeaveGameMode() \
	LP0NR(0x2B2, glutLeaveGameMode, \
	, AGLUT_BASE_NAME)

#define glutGameModeGet(GLenum_mode) \
	LP1(0x2B8, int, glutGameModeGet, GLenum, GLenum_mode, d0, \
	, AGLUT_BASE_NAME)

#define glutGameModeString(const_char_string) \
	LP1NR(0x2BE, glutGameModeString, const char *, const_char_string, a0, \
	, AGLUT_BASE_NAME)

#define glutPostWindowRedisplay(int_win) \
	LP1NR(0x2C4, glutPostWindowRedisplay, int, int_win, d0, \
	, AGLUT_BASE_NAME)

#define glutPostWindowOverlayRedisplay(int_win) \
	LP1NR(0x2CA, glutPostWindowOverlayRedisplay, int, int_win, d0, \
	, AGLUT_BASE_NAME)

#endif /*  _INLINE_AGLUT_H  */
