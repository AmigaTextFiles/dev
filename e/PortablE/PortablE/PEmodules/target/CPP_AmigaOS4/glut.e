OPT NATIVE
MODULE 'target/###'
MODULE 'target/exec/types', 'target/exec/exec', 'target/exec/interfaces'
/*MODULE 'target/PEalias/exec', 'target/exec/libraries'*/
{
#include <proto/glut.h>
}
{
//struct Library* GlutBase = NULL;
//struct GlutIFace* IGlut = NULL;
}
NATIVE {GLUT_INTERFACE_DEF_H} CONST
NATIVE {PROTO_GLUT_H} CONST
NATIVE {CLIB_GLUT_PROTOS_H} CONST

/*
NATIVE {GlutBase} DEF glutbase:PTR TO lib
NATIVE {IGlut} DEF

PROC new()
	InitLibrary('???.library', NATIVE {(struct Interface **) &IGlut} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC
*/

NATIVE {GlutIFace} OBJECT

/* ### to do ###
#GLenum
#GLdouble
#GLint
#GLfloat
*/

->NATIVE {GLUTInit} PROC
PROC GlutInit(argc:PTR TO VALUE, argv:ARRAY OF ARRAY OF CHAR) IS NATIVE {GLUTInit(} argc {,} argv {)} ENDNATIVE
->NATIVE {GLUTExit} PROC
PROC GlutExit() IS NATIVE {GLUTExit()} ENDNATIVE
->NATIVE {GLUTInitWindowSize} PROC
PROC GlutInitWindowSize(width:VALUE, height:VALUE) IS NATIVE {GLUTInitWindowSize( (int) } width {, (int) } height {)} ENDNATIVE
->NATIVE {GLUTInitWindowPosition} PROC
PROC GlutInitWindowPosition(x:VALUE, y:VALUE) IS NATIVE {GLUTInitWindowPosition( (int) } x {, (int) } y {)} ENDNATIVE
->NATIVE {GLUTInitDisplayMode} PROC
PROC GlutInitDisplayMode(mode:ULONG) IS NATIVE {GLUTInitDisplayMode( (int) } mode {)} ENDNATIVE
->NATIVE {GLUTCreateWindow} PROC
PROC GlutCreateWindow(name:ARRAY OF CHAR) IS NATIVE {GLUTCreateWindow(} name {)} ENDNATIVE !!VALUE
->NATIVE {GLUTDestroyWindow} PROC
PROC GlutDestroyWindow(window:VALUE) IS NATIVE {GLUTDestroyWindow( (int) } window {)} ENDNATIVE
->NATIVE {GLUTPostRedisplay} PROC
PROC GlutPostRedisplay() IS NATIVE {GLUTPostRedisplay()} ENDNATIVE
->NATIVE {GLUTSwapBuffers} PROC
PROC GlutSwapBuffers() IS NATIVE {GLUTSwapBuffers()} ENDNATIVE
->NATIVE {GLUTMainLoop} PROC
PROC GlutMainLoop() IS NATIVE {GLUTMainLoop()} ENDNATIVE
->NATIVE {GLUTPositionWindow} PROC
PROC GlutPositionWindow(x:VALUE, y:VALUE) IS NATIVE {GLUTPositionWindow( (int) } x {, (int) } y {)} ENDNATIVE
->NATIVE {GLUTReshapeWindow} PROC
PROC GlutReshapeWindow(width:VALUE, height:VALUE) IS NATIVE {GLUTReshapeWindow( (int) } width {, (int) } height {)} ENDNATIVE
->NATIVE {GLUTFullScreen} PROC
PROC GlutFullScreen() IS NATIVE {GLUTFullScreen()} ENDNATIVE
->NATIVE {GLUTPushWindow} PROC
PROC GlutPushWindow() IS NATIVE {GLUTPushWindow()} ENDNATIVE
->NATIVE {GLUTPopWindow} PROC
PROC GlutPopWindow() IS NATIVE {GLUTPopWindow()} ENDNATIVE
->NATIVE {GLUTShowWindow} PROC
PROC GlutShowWindow() IS NATIVE {GLUTShowWindow()} ENDNATIVE
->NATIVE {GLUTHideWindow} PROC
PROC GlutHideWindow() IS NATIVE {GLUTHideWindow()} ENDNATIVE
->NATIVE {GLUTIconifyWindow} PROC
PROC GlutIconifyWindow() IS NATIVE {GLUTIconifyWindow()} ENDNATIVE
->NATIVE {GLUTSetWindowTitle} PROC
PROC GlutSetWindowTitle(name:ARRAY OF CHAR) IS NATIVE {GLUTSetWindowTitle(} name {)} ENDNATIVE
->NATIVE {GLUTSetIconTitle} PROC
PROC GlutSetIconTitle(name:ARRAY OF CHAR) IS NATIVE {GLUTSetIconTitle(} name {)} ENDNATIVE
->NATIVE {GLUTDisplayFunc} PROC
PROC GlutDisplayFunc(func:PTR /*void (*func)()*/) IS NATIVE {GLUTDisplayFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTReshapeFunc} PROC
PROC GlutReshapeFunc(func:PTR /*void (*func)(int, int)*/) IS NATIVE {GLUTReshapeFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTKeyboardFunc} PROC
PROC GlutKeyboardFunc(func:PTR /*void (*func)(unsigned char, int, int)*/) IS NATIVE {GLUTKeyboardFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTMouseFunc} PROC
PROC GlutMouseFunc(func:PTR /*void (*func)(int, int, int, int)*/) IS NATIVE {GLUTMouseFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTMotionFunc} PROC
PROC GlutMotionFunc(func:PTR /*void (*func)(int, int)*/) IS NATIVE {GLUTMotionFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTPassiveMotionFunc} PROC
PROC GlutPassiveMotionFunc(func:PTR /*void (*func)(int, int)*/) IS NATIVE {GLUTPassiveMotionFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTVisibilityFunc} PROC
PROC GlutVisibilityFunc(func:PTR /*void (*func)(int)*/) IS NATIVE {GLUTVisibilityFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTEntryFunc} PROC
PROC GlutEntryFunc(func:PTR /*void (*func)(int)*/) IS NATIVE {GLUTEntryFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTSpecialFunc} PROC
PROC GlutSpecialFunc(func:PTR /*void (*func)(int, int, int)*/) IS NATIVE {GLUTSpecialFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTIdleFunc} PROC
PROC GlutIdleFunc(func:PTR /*void (*func)(void)*/) IS NATIVE {GLUTIdleFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTGet} PROC
PROC GlutGet(state:#GLenum) IS NATIVE {GLUTGet(} state {)} ENDNATIVE !!VALUE
->NATIVE {GLUTKeyboardUpFunc} PROC
PROC GlutKeyboardUpFunc(func:PTR /*void (*func)(unsigned char, int, int)*/) IS NATIVE {GLUTKeyboardUpFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTSpecialUpFunc} PROC
PROC GlutSpecialUpFunc(func:PTR /*void (*func)(int, int, int)*/) IS NATIVE {GLUTSpecialUpFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTIgnoreKeyRepeat} PROC
PROC GlutIgnoreKeyRepeat(ignore:VALUE) IS NATIVE {GLUTIgnoreKeyRepeat( (int) } ignore {)} ENDNATIVE
->NATIVE {GLUTBitmapCharacter} PROC
PROC GlutBitmapCharacter(fontID:PTR, character:VALUE) IS NATIVE {GLUTBitmapCharacter(} fontID {, (int) } character {)} ENDNATIVE
->NATIVE {GLUTBitmapString} PROC
PROC GlutBitmapString(fontID:PTR, string:PTR TO UBYTE) IS NATIVE {GLUTBitmapString(} fontID {,} string {)} ENDNATIVE
->NATIVE {GLUTBitmapWidth} PROC
PROC GlutBitmapWidth(fontID:PTR, character:VALUE) IS NATIVE {GLUTBitmapWidth(} fontID {, (int) } character {)} ENDNATIVE !!VALUE
->NATIVE {GLUTBitmapLength} PROC
PROC GlutBitmapLength(fontID:PTR, string:PTR TO UBYTE) IS NATIVE {GLUTBitmapLength(} fontID {,} string {)} ENDNATIVE !!VALUE
->NATIVE {GLUTBitmapHeight} PROC
PROC GlutBitmapHeight(fontID:PTR) IS NATIVE {GLUTBitmapHeight(} fontID {)} ENDNATIVE !!VALUE
->NATIVE {GLUTStrokeCharacter} PROC
PROC GlutStrokeCharacter(fontID:PTR, character:VALUE) IS NATIVE {GLUTStrokeCharacter(} fontID {, (int) } character {)} ENDNATIVE
->NATIVE {GLUTStrokeString} PROC
PROC GlutStrokeString(fontID:PTR, string:PTR TO UBYTE) IS NATIVE {GLUTStrokeString(} fontID {,} string {)} ENDNATIVE
->NATIVE {GLUTStrokeWidth} PROC
PROC GlutStrokeWidth(fontID:PTR, character:VALUE) IS NATIVE {GLUTStrokeWidth(} fontID {, (int) } character {)} ENDNATIVE !!VALUE
->NATIVE {GLUTStrokeLength} PROC
PROC GlutStrokeLength(fontID:PTR, string:PTR TO UBYTE) IS NATIVE {GLUTStrokeLength(} fontID {,} string {)} ENDNATIVE !!VALUE
->NATIVE {GLUTStrokeHeight} PROC
PROC GlutStrokeHeight(fontID:PTR) IS NATIVE {GLUTStrokeHeight(} fontID {)} ENDNATIVE !!VALUE
->NATIVE {GLUTGameModeString} PROC
PROC GlutGameModeString(string:ARRAY OF CHAR) IS NATIVE {GLUTGameModeString(} string {)} ENDNATIVE
->NATIVE {GLUTEnterGameMode} PROC
PROC GlutEnterGameMode() IS NATIVE {GLUTEnterGameMode()} ENDNATIVE !!VALUE
->NATIVE {GLUTLeaveGameMode} PROC
PROC GlutLeaveGameMode() IS NATIVE {GLUTLeaveGameMode()} ENDNATIVE
->NATIVE {GLUTGameModeGet} PROC
PROC GlutGameModeGet(eWhat:#GLenum) IS NATIVE {GLUTGameModeGet(} eWhat {)} ENDNATIVE !!VALUE
->NATIVE {GLUTWireCube} PROC
PROC GlutWireCube(size:#GLdouble) IS NATIVE {GLUTWireCube(} size {)} ENDNATIVE
->NATIVE {GLUTSolidCube} PROC
PROC GlutSolidCube(size:#GLdouble) IS NATIVE {GLUTSolidCube(} size {)} ENDNATIVE
->NATIVE {GLUTWireSphere} PROC
PROC GlutWireSphere(radius:#GLdouble, slices:#GLint, stacks:#GLint) IS NATIVE {GLUTWireSphere(} radius {,} slices {,} stacks {)} ENDNATIVE
->NATIVE {GLUTSolidSphere} PROC
PROC GlutSolidSphere(radius:#GLdouble, slices:#GLint, stacks:#GLint) IS NATIVE {GLUTSolidSphere(} radius {,} slices {,} stacks {)} ENDNATIVE
->NATIVE {GLUTWireCone} PROC
PROC GlutWireCone(base:#GLdouble, height:#GLdouble, slices:#GLint, stacks:#GLint) IS NATIVE {GLUTWireCone(} base {,} height {,} slices {,} stacks {)} ENDNATIVE
->NATIVE {GLUTSolidCone} PROC
PROC GlutSolidCone(base:#GLdouble, height:#GLdouble, slices:#GLint, stacks:#GLint) IS NATIVE {GLUTSolidCone(} base {,} height {,} slices {,} stacks {)} ENDNATIVE
->NATIVE {GLUTWireTorus} PROC
PROC GlutWireTorus(innerRadius:#GLdouble, outerRadius:#GLdouble, sides:#GLint, rings:#GLint) IS NATIVE {GLUTWireTorus(} innerRadius {,} outerRadius {,} sides {,} rings {)} ENDNATIVE
->NATIVE {GLUTSolidTorus} PROC
PROC GlutSolidTorus(innerRadius:#GLdouble, outerRadius:#GLdouble, sides:#GLint, rings:#GLint) IS NATIVE {GLUTSolidTorus(} innerRadius {,} outerRadius {,} sides {,} rings {)} ENDNATIVE
->NATIVE {GLUTWireDodecahedron} PROC
PROC GlutWireDodecahedron() IS NATIVE {GLUTWireDodecahedron()} ENDNATIVE
->NATIVE {GLUTSolidDodecahedron} PROC
PROC GlutSolidDodecahedron() IS NATIVE {GLUTSolidDodecahedron()} ENDNATIVE
->NATIVE {GLUTWireOctahedron} PROC
PROC GlutWireOctahedron() IS NATIVE {GLUTWireOctahedron()} ENDNATIVE
->NATIVE {GLUTSolidOctahedron} PROC
PROC GlutSolidOctahedron() IS NATIVE {GLUTSolidOctahedron()} ENDNATIVE
->NATIVE {GLUTWireTetrahedron} PROC
PROC GlutWireTetrahedron() IS NATIVE {GLUTWireTetrahedron()} ENDNATIVE
->NATIVE {GLUTSolidTetrahedron} PROC
PROC GlutSolidTetrahedron() IS NATIVE {GLUTSolidTetrahedron()} ENDNATIVE
->NATIVE {GLUTWireIcosahedron} PROC
PROC GlutWireIcosahedron() IS NATIVE {GLUTWireIcosahedron()} ENDNATIVE
->NATIVE {GLUTSolidIcosahedron} PROC
PROC GlutSolidIcosahedron() IS NATIVE {GLUTSolidIcosahedron()} ENDNATIVE
->NATIVE {GLUTWireRhombicDodecahedron} PROC
PROC GlutWireRhombicDodecahedron() IS NATIVE {GLUTWireRhombicDodecahedron()} ENDNATIVE
->NATIVE {GLUTSolidRhombicDodecahedron} PROC
PROC GlutSolidRhombicDodecahedron() IS NATIVE {GLUTSolidRhombicDodecahedron()} ENDNATIVE
->NATIVE {GLUTWireSierpinskiSponge} PROC
PROC GlutWireSierpinskiSponge(num_levels:VALUE, offset:PTR TO #GLdouble, scale:#GLdouble) IS NATIVE {GLUTWireSierpinskiSponge( (int) } num_levels {,} offset {,} scale {)} ENDNATIVE
->NATIVE {GLUTSolidSierpinskiSponge} PROC
PROC GlutSolidSierpinskiSponge(num_levels:VALUE, offset:PTR TO #GLdouble, scale:#GLdouble) IS NATIVE {GLUTSolidSierpinskiSponge( (int) } num_levels {,} offset {,} scale {)} ENDNATIVE
->NATIVE {GLUTWireCylinder} PROC
PROC GlutWireCylinder(radius:#GLdouble, height:#GLdouble, slices:#GLint, stacks:#GLint) IS NATIVE {GLUTWireCylinder(} radius {,} height {,} slices {,} stacks {)} ENDNATIVE
->NATIVE {GLUTSolidCylinder} PROC
PROC GlutSolidCylinder(radius:#GLdouble, height:#GLdouble, slices:#GLint, stacks:#GLint) IS NATIVE {GLUTSolidCylinder(} radius {,} height {,} slices {,} stacks {)} ENDNATIVE
->NATIVE {GLUTWireTeapot} PROC
PROC GlutWireTeapot(size:#GLdouble) IS NATIVE {GLUTWireTeapot(} size {)} ENDNATIVE
->NATIVE {GLUTSolidTeapot} PROC
PROC GlutSolidTeapot(size:#GLdouble) IS NATIVE {GLUTSolidTeapot(} size {)} ENDNATIVE
->NATIVE {GLUTSetOption} PROC
PROC GlutSetOption(eWhat:#GLenum, value:VALUE) IS NATIVE {GLUTSetOption(} eWhat {, (int) } value {)} ENDNATIVE
->NATIVE {GLUTDeviceGet} PROC
PROC GlutDeviceGet(eWhat:#GLenum) IS NATIVE {GLUTDeviceGet(} eWhat {)} ENDNATIVE !!VALUE
->NATIVE {GLUTGetModifiers} PROC
PROC GlutGetModifiers() IS NATIVE {GLUTGetModifiers()} ENDNATIVE !!VALUE
->NATIVE {GLUTLayerGet} PROC
PROC GlutLayerGet(eWhat:#GLenum) IS NATIVE {GLUTLayerGet(} eWhat {)} ENDNATIVE !!VALUE
->NATIVE {GLUTEstablishOverlay} PROC
PROC GlutEstablishOverlay() IS NATIVE {GLUTEstablishOverlay()} ENDNATIVE
->NATIVE {GLUTRemoveOverlay} PROC
PROC GlutRemoveOverlay() IS NATIVE {GLUTRemoveOverlay()} ENDNATIVE
->NATIVE {GLUTUseLayer} PROC
PROC GlutUseLayer(layer:#GLenum) IS NATIVE {GLUTUseLayer(} layer {)} ENDNATIVE
->NATIVE {GLUTPostOverlayRedisplay} PROC
PROC GlutPostOverlayRedisplay() IS NATIVE {GLUTPostOverlayRedisplay()} ENDNATIVE
->NATIVE {GLUTPostWindowOverlayRedisplay} PROC
PROC GlutPostWindowOverlayRedisplay(ID:VALUE) IS NATIVE {GLUTPostWindowOverlayRedisplay( (int) } ID {)} ENDNATIVE
->NATIVE {GLUTShowOverlay} PROC
PROC GlutShowOverlay() IS NATIVE {GLUTShowOverlay()} ENDNATIVE
->NATIVE {GLUTHideOverlay} PROC
PROC GlutHideOverlay() IS NATIVE {GLUTHideOverlay()} ENDNATIVE
->NATIVE {GLUTTimerFunc} PROC
PROC GlutTimerFunc(msecs:ULONG, func:PTR /*void (*func)(int value)*/, value:VALUE) IS NATIVE {GLUTTimerFunc( (int) } msecs {, (void (*)()) } func {, (int) } value {)} ENDNATIVE
->NATIVE {GLUTCloseFunc} PROC
PROC GlutCloseFunc(func:PTR /*void (*func)(void)*/) IS NATIVE {GLUTCloseFunc( (void (*)()) } func {)} ENDNATIVE
->NATIVE {GLUTExtensionSupported} PROC
PROC GlutExtensionSupported(extension:ARRAY OF CHAR) IS NATIVE {GLUTExtensionSupported(} extension {)} ENDNATIVE !!VALUE
->NATIVE {GLUTSetKeyRepeat} PROC
PROC GlutSetKeyRepeat(repeatMode:VALUE) IS NATIVE {GLUTSetKeyRepeat( (int) } repeatMode {)} ENDNATIVE
->NATIVE {GLUTForceJoystickFunc} PROC
PROC GlutForceJoystickFunc() IS NATIVE {GLUTForceJoystickFunc()} ENDNATIVE
->NATIVE {GLUTSetColor} PROC
PROC GlutSetColor(nColor:VALUE, red:#GLfloat, green:#GLfloat, blue:#GLfloat) IS NATIVE {GLUTSetColor( (int) } nColor {,} red {,} green {,} blue {)} ENDNATIVE
->NATIVE {GLUTGetColor} PROC
PROC GlutGetColor(color:VALUE, component:VALUE) IS NATIVE {GLUTGetColor( (int) } color {, (int) } component {)} ENDNATIVE !!NATIVE {GLfloat} #GLfloat
->NATIVE {GLUTCopyColormap} PROC
PROC GlutCopyColormap(window:VALUE) IS NATIVE {GLUTCopyColormap( (int) } window {)} ENDNATIVE
->NATIVE {GLUTWarpPointer} PROC
PROC GlutWarpPointer(x:VALUE, y:VALUE) IS NATIVE {GLUTWarpPointer( (int) } x {, (int) } y {)} ENDNATIVE
->NATIVE {GLUTSpaceballMotionFunc} PROC
PROC GlutSpaceballMotionFunc(callback:PTR /*void (*callback)( int, int, int )*/) IS NATIVE {GLUTSpaceballMotionFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTSpaceballRotateFunc} PROC
PROC GlutSpaceballRotateFunc(callback:PTR /*void (*callback)( int, int, int )*/) IS NATIVE {GLUTSpaceballRotateFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTSpaceballButtonFunc} PROC
PROC GlutSpaceballButtonFunc(callback:PTR /*void (*callback)( int, int )*/) IS NATIVE {GLUTSpaceballButtonFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTButtonBoxFunc} PROC
PROC GlutButtonBoxFunc(callback:PTR /*void (*callback)( int, int )*/) IS NATIVE {GLUTButtonBoxFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTDialsFunc} PROC
PROC GlutDialsFunc(callback:PTR /*void (*callback)( int, int )*/) IS NATIVE {GLUTDialsFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTTabletMotionFunc} PROC
PROC GlutTabletMotionFunc(callback:PTR /*void (*callback)( int, int )*/) IS NATIVE {GLUTTabletMotionFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTTabletButtonFunc} PROC
PROC GlutTabletButtonFunc(callback:PTR /*void (*callback)( int, int, int, int )*/) IS NATIVE {GLUTTabletButtonFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTOverlayDisplayFunc} PROC
PROC GlutOverlayDisplayFunc(callback:PTR /*void (*callback)( void )*/) IS NATIVE {GLUTOverlayDisplayFunc( (void (*)()) } callback {)} ENDNATIVE
->NATIVE {GLUTJoystickFunc} PROC
PROC GlutJoystickFunc(callback:PTR /*void (*callback)( unsigned int, int, int, int )*/, pollInterval:VALUE) IS NATIVE {GLUTJoystickFunc( (void (*)()) } callback {, (int) } pollInterval {)} ENDNATIVE
