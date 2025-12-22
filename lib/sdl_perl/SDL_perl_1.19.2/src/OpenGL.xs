// SDL::OpenGL
//
//

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_GL
#include <GL/gl.h>
#endif

#ifdef HAVE_GLU
#include <GL/glu.h>
#endif

#ifdef WIN32
#define HAVE_TLS_CONTEXT
#endif

#ifndef GL_ALL_CLIENT_ATTRIB_BITS  
#define GL_ALL_CLIENT_ATTRIB_BITS 0xFFFFFFF
#endif /* GL_ALL_CLIENT_BITS */  

#include "defines.h"

SV* sdl_perl_nurbs_error_hook;
void
sdl_perl_nurbs_error_callback ( GLenum errorCode )
{
	ENTER_TLS_CONTEXT
	dSP;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(errorCode)));
	PUTBACK;

	call_sv(sdl_perl_nurbs_error_hook,G_VOID);
	
	FREETMPS;
	LEAVE;
	LEAVE_TLS_CONTEXT	
}

void
sdl_perl_nurbs_being_callback ( GLenum type, void *cb )
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)cb;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(type)));
	PUTBACK;

	call_sv(cmd,G_VOID);
	
	FREETMPS;
	LEAVE;
	LEAVE_TLS_CONTEXT	
}

void
sdl_perl_nurbs_multi_callback ( GLfloat *vec, void *cb )
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)cb;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(PTR2IV(vec))));
	PUTBACK;

	call_sv(cmd,G_VOID);
	
	FREETMPS;
	LEAVE;
	LEAVE_TLS_CONTEXT	
}

void
sdl_perl_nurbs_end_callback ( void *cb )
{
	SV *cmd;
	ENTER_TLS_CONTEXT

	cmd = (SV*)cb;

	ENTER;
	SAVETMPS;

	call_sv(cmd,G_VOID);
	
	FREETMPS;
	LEAVE;
	LEAVE_TLS_CONTEXT	
}

void
sdl_perl_tess_end_callback ( void *cb )
{
	SV *cmd;
        ENTER_TLS_CONTEXT
	dSP;

        cmd = (SV*)cb;

        ENTER;
        SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(GLU_TESS_BEGIN)));
	PUTBACK;

        call_sv(cmd,G_VOID);

        FREETMPS;
        LEAVE;
        LEAVE_TLS_CONTEXT
}

void
sdl_perl_tess_begin_callback ( GLenum type,  void *cb )
{
        SV *cmd;
        ENTER_TLS_CONTEXT
	dSP;

        cmd = (SV*)cb;

        ENTER;
        SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(GLU_TESS_BEGIN)));
	XPUSHs(sv_2mortal(newSViv(type)));
	PUTBACK;

        call_sv(cmd,G_VOID);

        FREETMPS;
        LEAVE;
        LEAVE_TLS_CONTEXT
}

void
sdl_perl_tess_error_callback ( GLenum type,  void *cb )
{
        SV *cmd;
        ENTER_TLS_CONTEXT
	dSP;

        cmd = (SV*)cb;

        ENTER;
        SAVETMPS;
        PUSHMARK(SP);
        XPUSHs(sv_2mortal(newSViv(GLU_TESS_ERROR)));
        XPUSHs(sv_2mortal(newSViv(type)));
        PUTBACK;

        call_sv(cmd,G_VOID);

        FREETMPS;
        LEAVE;
        LEAVE_TLS_CONTEXT
}

void
sdl_perl_tess_edge_flag_callback ( GLenum flag,  void *cb )
{
        SV *cmd;
        ENTER_TLS_CONTEXT
	dSP;

        cmd = (SV*)cb;

        ENTER;
        SAVETMPS;
        PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(GLU_TESS_EDGE_FLAG)));
        XPUSHs(sv_2mortal(newSViv(flag)));
        PUTBACK;

        call_sv(cmd,G_VOID);

        FREETMPS;
        LEAVE;
        LEAVE_TLS_CONTEXT
}

void
sdl_perl_tess_vertex_callback ( double *vd,  void *cb )
{
        SV *cmd;
        ENTER_TLS_CONTEXT
	dSP;

        cmd = (SV*)cb;

        ENTER;
        SAVETMPS;
        PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(GLU_TESS_VERTEX)));
        XPUSHs(sv_2mortal(newSVnv(vd[0])));
        XPUSHs(sv_2mortal(newSVnv(vd[1])));
        XPUSHs(sv_2mortal(newSVnv(vd[2])));
        XPUSHs(sv_2mortal(newSVnv(vd[3])));
        XPUSHs(sv_2mortal(newSVnv(vd[4])));
        XPUSHs(sv_2mortal(newSVnv(vd[5])));
        PUTBACK;

        call_sv(cmd,G_VOID);

        FREETMPS;
        LEAVE;
        LEAVE_TLS_CONTEXT
}

void
sdl_perl_tess_combine_callback ( GLdouble coords[3], double *vd[4], GLfloat weight[4], 
	GLdouble **out, void *cb )
{
        SV *cmd;
	double *data;
	int width;
        ENTER_TLS_CONTEXT
	dSP;

        cmd = (SV*)cb;

        ENTER;
        SAVETMPS;
        PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(GLU_TESS_COMBINE)));
	XPUSHs(sv_2mortal(newSVpvn((char*)coords,sizeof(GLdouble)*3)));
	XPUSHs(sv_2mortal(newSVpvn((char*)vd,sizeof(GLdouble*)*4)));
	XPUSHs(sv_2mortal(newSVpvn((char*)weight,sizeof(GLfloat)*4)));
        PUTBACK;

        if ( 1 != call_sv(cmd,G_SCALAR) ) {
		Perl_croak(aTHX_ "sdl_perl_tess_combine_callback failed");
	}

	data = (double*)POPp;
	width = (int)POPi;
	*out = (double*)malloc(sizeof(double)*width);
	memcpy(*out,data,sizeof(double)*width);

        FREETMPS;
        LEAVE;
        LEAVE_TLS_CONTEXT
}

MODULE = SDL::OpenGL		PACKAGE = SDL::OpenGL
PROTOTYPES : DISABLE

#ifdef HAVE_GL

void
ClearColor ( r, g, b, a)
	double r
	double g
	double b
	double a
	CODE:
		glClearColor((GLfloat)r,(GLfloat)g,(GLfloat)b,(GLfloat)a);

void
ClearIndex ( index )
	double index
	CODE:
		glClearIndex(index);

void
ClearDepth ( depth )
	double depth
	CODE:
		glClearDepth(depth);

void
ClearStencil ( s )
	int s
	CODE:
		glClearStencil(s);

void
ClearAccum ( r, g, b, a )
	double r
	double g
	double b
	double a
	CODE:
		glClearAccum((GLfloat)r,(GLfloat)g,(GLfloat)b,(GLfloat)a);

void
Clear ( m )
	GLbitfield m
	CODE:
		glClear(m);

void
Flush ()
	CODE:
		glFlush();

void
Finish ()
	CODE:
		glFinish();

void
Rect ( r )
	SDL_Rect* r
	CODE:
		glRecti(r->x,r->y,r->x+r->w,r->y+r->h);

void
Vertex ( x, y, ... )
	double x
	double y
	CODE:
		double z,w;
		if ( items == 4 ) {
			w = SvNV(ST(3));
			z = SvNV(ST(2));
			glVertex4d(x,y,z,w);	
		} else if ( items == 3 ) {
			z = SvNV(ST(2));
			glVertex3d(x,y,z);	
		} else {
			glVertex2d(x,y);
		}
		
void
Begin ( mode )
	GLenum mode
	CODE:
		glBegin(mode);

void
End ()
	CODE:
		glEnd();

void
Enable ( cap )
	GLenum cap
	CODE:
		glEnable(cap);

void
Disable ( cap )
	GLenum cap
	CODE:
		glDisable(cap);

Uint32
IsEnabled ( cap )
	Uint32 cap
	CODE:
		RETVAL = glIsEnabled(cap);
	OUTPUT:
		RETVAL

void
PointSize ( size )
	double size
	CODE:
		glPointSize((GLfloat)size);

void
LineWidth ( size )
	double size
	CODE:
		glLineWidth((GLfloat)size);

void
LineStipple ( factor, pattern )
	Sint32 factor
	Uint16 pattern
	CODE:
		glLineStipple(factor,pattern);

void
PolygonMode ( face, mode )
	GLenum face
	GLenum mode
	CODE:
		glPolygonMode(face,mode);

void
FrontFace ( mode )
	GLenum mode
	CODE:
		glFrontFace(mode);

void
CullFace ( mode )
	GLenum mode
	CODE:
		glCullFace(mode);

void
PolygonStipple ( mask )
	char *mask
	CODE:
		glPolygonStipple(mask);

void
EdgeFlag ( flag )
	GLenum flag
	CODE:
		glEdgeFlag(flag);

void
Normal ( x, y, z )
	double x
	double y
	double z
	CODE:
		glNormal3d(x,y,z);

void
EnableClientState ( array )
	GLenum array
	CODE:
		glEnableClientState(array);

void
DisableClientState ( array )
	GLenum array
	CODE:
		glDisableClientState(array);

void
VertexPointer ( size, type, stride, pointer)
	int size
	GLenum type
	Uint32 stride
	char *pointer
	CODE:
		glVertexPointer(size,type,stride,pointer);

void
ColorPointer ( size, type, stride, pointer )
	Sint32 size
	GLenum type
	Uint32 stride
	char *pointer
	CODE:
		glColorPointer(size,type,stride,pointer);

void
NormalPointer ( type, stride, pointer )
	GLenum type
	Uint32 stride
	char *pointer
	CODE:
		glNormalPointer(type,stride,pointer);

void
TexCoordPointer ( size, type, stride, pointer )
	Sint32 size
	GLenum type
	Uint32 stride
	char *pointer
	CODE:
		glTexCoordPointer(size,type,stride,pointer);

void
EdgeFlagPointer ( stride, pointer )
	Uint32 stride
	char *pointer
	CODE:
		glEdgeFlagPointer(stride,pointer);

void
ArrayElement ( ith )
	Uint32 ith
	CODE:
		glArrayElement(ith);

void
DrawElements ( mode, count, type, indices )
	GLenum mode
	Uint32 count
	GLenum type
	char *indices
	CODE:
		glDrawElements( mode, count, type, indices);

void
DrawRangeElements ( mode, start, end, count, type, indices )
	GLenum mode
	Uint32 start
	Uint32 end
	Uint32 count
	GLenum type
	char *indices
	CODE:
		glDrawRangeElements(mode,start,end,count,type,indices);

void
DrawArrays ( mode, first, count )
	GLenum mode
	Uint32 first
	Uint32 count
	CODE:
		glDrawArrays(mode,first,count);

void
InterleavedArrays ( format, stride, pointer )
	GLenum format
	Uint32 stride
	char *pointer
	CODE:
		glInterleavedArrays(format,stride,pointer);

void
PushAttrib ( mask )
	GLbitfield mask
	CODE:
		glPushAttrib(mask);

void
PopAttrib ()
	CODE:
		glPopAttrib();

void
PushClientAttrib ( mask )
	GLbitfield mask
	CODE:
		glPushClientAttrib(mask);

void
PopClientAttrib ()
	CODE:
		glPopClientAttrib();

void
MatrixMode ( mode )
	GLenum mode
	CODE:
		glMatrixMode(mode);

void
LoadIdentity ()
	CODE:
		glLoadIdentity();

void
LoadMatrix (  ... )
	CODE:
		int i;
		double mat[16];
		for ( i = 0; i < 16; i++ ) {
			mat[i] = (i < items  && SvNOK(ST(i)) ? SvNV(ST(i)) : 0.0 );
		}
		glLoadMatrixd(mat);

void
MultMatrix ( ... )
	CODE:
		int i;
		double mat[16];
		for ( i = 0; i < 16; i++ ) {
			mat[i] = (i < items  && SvNOK(ST(i)) ? SvNV(ST(i)) : 0.0 );
		}
		glMultMatrixd(mat);

void
Translate ( x, y, z )
	double x
	double y
	double z
	CODE:
		glTranslated(x,y,z);

void
Rotate ( angle, x, y, z )
	double angle
	double x
	double y
	double z
	CODE:
		glRotated(angle,x,y,z);

void
Scale ( x, y, z )
	double x
	double y
	double z
	CODE:
		glScaled(x,y,z);

void
Frustum ( left, right, bottom, top, near, far )
	double left
	double right
	double bottom
	double top
	double near
	double far
	CODE:
		glFrustum(left,right,bottom,top,near,far);

void
Ortho ( left, right, bottom, top, near, far )
	double left
	double right
	double bottom
	double top
	double near
	double far
	CODE:
		glOrtho(left,right,bottom,top,near,far);

void
Viewport ( x, y, width, height )
	Sint32 x
	Sint32 y
	Uint32 width
	Uint32 height
	CODE:
		glViewport(x,y,width,height);

void
DepthRange ( near, far )
	double near
	double far
	CODE:
		glDepthRange(near,far);

void
PushMatrix ()
	CODE:
		glPushMatrix();

void
PopMatrix ()
	CODE:
		glPopMatrix();

void
ClipPlane ( plane, ... )
	GLenum plane
	CODE:
		double v[4];
		int i;
		for (i = 0; i < 4; i++ ) {
			v[i] = (i+1 < items && SvNOK(ST(i+1))) ? SvNV(ST(i+1)) : 0.0;
		}
		glClipPlane(plane,v);
	
void
Color ( r, g, b, ... )
	double r	
	double g
	double b	
	CODE:
		if ( items == 4 ) {
			double a;
			a = SvIV(ST(3));
			glColor4d(r,g,b,a);
		} else {
			glColor3d(r,g,b);	
		}

void
Index ( c )
	Uint32 c
	CODE:
		glIndexi(c);

void
ShadeModel ( mode )
	GLenum mode
	CODE:
		glShadeModel(mode);

void
Light ( light, name, ... )
	GLenum light
	GLenum name
	CODE:
		int i;
		if ( items == 6 ) {
			float v[4];	
			for ( i = 0; i < 4; i++ ) {
				v[i] = (SvNOK(ST(i+2))) ? SvNV(ST(i+2)) : 0.0;
			}
			glLightfv(light,name,v);	
		} else if ( items == 5 ) {
			float v[3];
			for ( i = 0; i < 3; i++ ) {
				v[i] = (SvNOK(ST(i+2))) ? SvNV(ST(i+2)) : 0.0;
			}
			glLightfv(light,name,v);	
		} else if ( items == 3 ) {
			float v;
			v = SvNV(ST(2));
			glLightf(light,name,v);
		} else {
			Perl_croak(aTHX_ "SDL::OpenGL::Light invalid arguments");
		}

void
Material ( face, name, ... )
	GLenum face
	GLenum name
	CODE:
		int i;
		if ( items == 6 ) {
			float v[4];
			for ( i = 0; i < 4; i++ ) {
				v[i] = (SvNOK(ST(i+2))) ? SvNV(ST(i+2)) : 0.0;
			}
			glMaterialfv(face,name,v);
		} else if ( items == 5 ) {
			float v[3];
			for ( i = 0; i < 4; i++ ) {
				v[i] = (SvNOK(ST(i+2))) ? SvNV(ST(i+2)) : 0.0;
			}
			glMaterialfv(face,name,v);
		} else if ( items == 3 ) {	
			float v;
			v = SvNV(ST(2));
			glMaterialf(face,name,v);
		} else {
			Perl_croak(aTHX_ "SDL::OpenGL::Material invalid arguments");
		}

void
ColorMaterial ( face, mode )
	GLenum face
	GLenum mode
	CODE:
		glColorMaterial(face,mode);

void
BlendFunc ( sfactor, dfactor )
	GLenum sfactor
	GLenum dfactor
	CODE:
		glBlendFunc(sfactor,dfactor);


void
Hint ( target, hint )
	GLenum target
	GLenum hint
	CODE:
		glHint(target,hint);	

void
Fog ( name, ... )
	GLenum name
	CODE:
		if ( items == 5 )  {
			float v[4];
			v[0] = SvNV(ST(1));	
			v[1] = SvNV(ST(2));	
			v[2] = SvNV(ST(3));	
			v[3] = SvNV(ST(4));	
			glFogfv(name,v);
		} else if ( items == 2 ) {
			float v;
			v = SvNV(ST(1));
			glFogf(name,v);
		} else {
			Perl_croak(aTHX_ "SDL::OpenGL::Material invalid arguments");
		}

void
PolygonOffset ( factor, units )
	double factor
	double units
	CODE:
		glPolygonOffset(factor,units);

Uint32
GenLists ( range )
	Uint32 range
	CODE:
		RETVAL = glGenLists(range);
	OUTPUT:
		RETVAL

void
NewList ( list, mode )
	Uint32 list
	GLenum mode
	CODE:
		glNewList(list,mode);

void
EndList ()
	CODE:
		glEndList();

void
CallList ( list )
	Uint32 list
	CODE:
		glCallList(list);

Uint32
IsList ( list )
	Uint32 list
	CODE:
		RETVAL = glIsList(list);
	OUTPUT:
		RETVAL

void
ListBase ( base )
	Uint32 base
	CODE:
		glListBase(base);

void
CallLists ( type, ... )
	GLenum type
	CODE:
		int *i, j;	
		if ( items > 1 ) {
			i = (int*)safemalloc(sizeof(int)* (items - 1 ));
			for ( j = 0; j < items - 1; j++ ) {
				i[j] = SvIV(ST(j));
			} 
		} else {
			Perl_croak(aTHX_ "usage: SDL::OpenGL::CallLists(type,...)");
		}
		glCallLists(items-1, type, i);
		safefree(i);
		
void
RasterPos ( x, y, z, ... )
	double x
	double y
	double z
	CODE:
		if ( items == 4 ) {
			double w = SvNV(ST(3));
			glRasterPos4d(x,y,z,w);
		} else {
			glRasterPos3d(x,y,z);
		}

void
Bitmap ( width, height, x1, y1, x2, y2, data )
	Uint32 width
	Uint32 height
	double x1
	double y1
	double x2
	double y2
	char *data
	CODE:
		glBitmap(width,height,x1,y1,x2,y2,data);

void
DrawPixels ( width, height, format, type, pixels )
	Uint32 width
	Uint32 height
	GLenum format
	GLenum type
	char *pixels
	CODE:
		glDrawPixels(width,height,format,type,pixels);

void
CopyPixels ( x, y, width, height, buffer )
	Sint32 x
	Sint32 y
	Uint32 width
	Uint32 height
	GLenum buffer
	CODE:
		glCopyPixels(x,y,width,height,buffer);

void
PixelStore ( name, param )
	Sint32 name
	double param
	CODE:
		glPixelStorei(name,param);

void
PixelTransfer ( name, ... )
	GLenum name
	CODE:
		switch ( name ) {
			case GL_MAP_COLOR:
			case GL_MAP_STENCIL:
			case GL_INDEX_SHIFT:
			case GL_INDEX_OFFSET:
				glPixelTransferi(name,SvIV(ST(1)));
				break;
			default:
				glPixelTransferf(name,SvNV(ST(1)));
				break;
		}

void
PixelMap ( type, map, mapsize, values )
	GLenum type
	GLenum map
	Sint32 mapsize
	char *values
	CODE:
		switch (type) {
			case GL_UNSIGNED_INT: 
				glPixelMapuiv(map,mapsize,(GLint*)values);
				break;
			case GL_UNSIGNED_SHORT:
				glPixelMapusv(map,mapsize,(GLushort*)values);
				break;
			case GL_FLOAT:
				glPixelMapfv(map,mapsize,(GLfloat*)values);
				break;
		}
		
void
PixelZoom ( zoomx, zoomy )
	double zoomx
	double zoomy
	CODE:
		glPixelZoom(zoomx,zoomy);

void
ColorTable ( target, internalFormat, width, format, type, data )
	GLenum target 
	GLenum internalFormat
	Uint32 width
	GLenum format
	GLenum type
	char *data
	CODE:
		glColorTable(target,internalFormat,width,format,type,data);

void
ColorTableParameter ( target, name, r, g, b, a)
	GLenum target
	GLenum name
	double r
	double g
	double b
	double a
	CODE:
		GLfloat vec[4];
		vec[0] = r;
		vec[1] = g;
		vec[2] = b;
		vec[3] = a;
		glColorTableParameterfv(target,name,vec);

void
CopyColorTable ( target, internalFormat, x, y, width )
	GLenum target
	GLenum internalFormat
	Sint32 x
	Sint32 y
	Uint32 width
	CODE:
		glCopyColorTable(target,internalFormat,x,y,width);

void
ColorSubTable ( target, start, count, format, type, data )
	Uint32 target
	Uint32 start
	Uint32 count
	Uint32 format
	Uint32 type
	char *data
	CODE:
		glColorSubTable(target,start,count,format,type,data);

void
CopyColorSubTable ( target, start, x, y, count )
	Uint32 target
	Uint32 start
	Sint32 x
	Sint32 y
	Uint32 count
	CODE:
		glCopyColorSubTable(target,start,x,y,count);

void
ConvolutionFilter2D ( target, internalFormat, width, height, format, type, image )
	Uint32 target
	Uint32 internalFormat
	Uint32 width
	Uint32 height
	Uint32 format
	Uint32 type
	char *image
	CODE:
		glConvolutionFilter2D(target,internalFormat,width,height,format,type,image);

void
CopyConvolutionFilter2D ( target, internalFormat, x, y, width, height )
	Uint32 target
	Uint32 internalFormat
	Sint32 x
	Sint32 y
	Uint32 width
	Uint32 height
	CODE:
		glCopyConvolutionFilter2D(target,internalFormat,x,y,width,height);

void
SeparableFilter2D ( target, internalFormat, width, height, format, type, row, column )
	Uint32 target
	Uint32 internalFormat
	Uint32 width
	Uint32 height
	Uint32 format
	Uint32 type
	char *row
	char *column
	CODE:
		glSeparableFilter2D(target,internalFormat,width,height,format,type,row,column);

void
ConvolutionFilter1D ( target, internalFormat, width, format, type, image )
	Uint32 target
	Uint32 internalFormat
	Uint32 width
	Uint32 format
	Uint32 type
	char *image
	CODE:
		glConvolutionFilter1D(target,internalFormat,width,format,type,image);

void
CopyConvolutionFilter1D ( target, internalFormat, x, y, width )
	Uint32 target
	Uint32 internalFormat
	Sint32 x
	Sint32 y
	Uint32 width
	CODE:
		glCopyConvolutionFilter1D(target,internalFormat,x,y,width);

void
ConvolutionParameter ( target, pname, ... )
	Uint32 target
	Uint32 pname
	CODE:
		Uint32 pi;
		GLfloat pv[4];
		switch(pname) {	
		case GL_CONVOLUTION_BORDER_MODE:
			if ( items != 3 ) 
				Perl_croak(aTHX_ "Usage: ConvolutionParameter(target,pname,...)");
			pi = SvIV(ST(2));
			glConvolutionParameteri(target,pname,pi);
			break;
		case GL_CONVOLUTION_FILTER_SCALE:
		case GL_CONVOLUTION_FILTER_BIAS:
			if ( items != 6 ) 
				Perl_croak(aTHX_ "Usage: ConvolutionParameter(target,pname,...)");
			pv[0] = (GLfloat)SvNV(ST(2));
			pv[1] = (GLfloat)SvNV(ST(3));
			pv[2] = (GLfloat)SvNV(ST(4));
			pv[3] = (GLfloat)SvNV(ST(5));
			glConvolutionParameterfv(target,pname,pv);
			break;
		default:
			Perl_croak(aTHX_ "ConvolutionParameter invalid parameter");
			break;
		}

void 
Histogram ( target, width, internalFormat, sink )
	Uint32 target
	Uint32 width
	Uint32 internalFormat
	GLboolean sink
	CODE:
		glHistogram(target,width,internalFormat,sink);

void
GetHistogram ( target, reset, format, type, values )
	Uint32 target 
	GLboolean reset
	Uint32 format
	Uint32 type
	char *values
	CODE:
		glGetHistogram(target,reset,format,type,values);

void
ResetHistogram ( target )
	Uint32 target
	CODE:
		glResetHistogram(target);

void
Minmax ( target, internalFormat, sink )
	Uint32 target
	Uint32 internalFormat
	GLboolean sink
	CODE:
		glMinmax(target,internalFormat,sink);

void
GetMinmax ( target, reset, format, type, values )
	Uint32 target
	GLboolean reset
	Uint32 format
	Uint32 type
	char *values
	CODE:
		glGetMinmax(target,reset,format,type,values);

void
ResetMinmax ( target )
	Uint32 target
	CODE:
		glResetMinmax(target);

void
BlendEquation ( mode )
	Uint32 mode
	CODE:
		glBlendEquation(mode);

void
TexImage2D ( target, level, internalFormat, width, height, border, format, type, data )
	GLenum target
	Sint32 level
	Sint32 internalFormat
	Uint32 width
	Uint32 height
	Sint32 border
	GLenum format
	GLenum type
	char *data
	CODE:
		glTexImage2D(target,level,internalFormat,width,height,border,format,type,data);
	
void
CopyTexImage2D ( target, level, internalFormat, x, y, width, height, border )
	GLenum target
	Sint32 level
	Sint32 internalFormat
	Sint32 x
	Sint32 y
	Uint32 width
	Uint32 height
	Sint32 border
	CODE:
		glCopyTexImage2D(target,level,internalFormat,x,y,width,height,border);

void
TexSubImage2D ( target, level, xoffset, yoffset, width, height, format, type, data )
	GLenum target
	Sint32 level
	Sint32 xoffset
	Sint32 yoffset
	Uint32 width
	Uint32 height
	GLenum format
	GLenum type
	char *data	
	CODE:
		glTexSubImage2D(target,level,xoffset,yoffset,width,height,format,type,data);

void
CopyTexSubImage2D ( target, level, xoffset, yoffset, x, y, width, height )
	GLenum target
	Sint32 level
	Sint32 xoffset
	Sint32 yoffset
	Sint32 x
	Sint32 y
	Uint32 width
	Uint32 height
	CODE:
		glCopyTexSubImage2D(target,level,xoffset,yoffset,x,y,width,height);

void
TexImage1D ( target, level, internalFormat, width, border, format, type, data )
	GLenum target
	Sint32 level
	Sint32 internalFormat
	Uint32 width
	Sint32 border
	GLenum format
	GLenum type
	char *data	
	CODE:
		glTexImage1D(target,level,internalFormat,width,border,format,type,data);	

void
TexSubImage1D ( target, level, xoffset, width, format, type, data )
	GLenum target
	Sint32 level
	Sint32 xoffset 
	Uint32 width
	GLenum format
	GLenum type
	char *data	
	CODE:
		glTexSubImage1D(target,level,xoffset,width,format,type,data);

void
CopyTexImage1D ( target, level, internalFormat, x, y, width, border )
	GLenum target
	Sint32 level
	Sint32 internalFormat
	Sint32 x
	Sint32 y
	Uint32 width
	Sint32 border
	CODE:
		glCopyTexImage1D(target,level,internalFormat,x,y,width,border);

void
CopyTexSubImage1D ( target, level, xoffset, x, y, width )
	GLenum target
	Sint32 level
	Sint32 xoffset
	Sint32 x
	Sint32 y
	Uint32 width
	CODE:
		glCopyTexSubImage1D(target,level,xoffset,x,y,width);

void
TexImage3D ( target, level, internalFormat, width, height, depth, border, format, type, data )
	GLenum target
	Sint32 level
	Sint32 internalFormat
	Uint32 width
	Uint32 height
	Uint32 depth
	Sint32 border
	GLenum format
	GLenum type
	char *data
	CODE:
		glTexImage3D(target,level,internalFormat,width,height,depth,border,format,type,data);

void
TexSubImage3D ( target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, data )
	GLenum target
	Sint32 level
	Sint32 xoffset
	Sint32 yoffset
	Sint32 zoffset
	Uint32 width
	Uint32 height
	Uint32 depth
	GLenum format
	GLenum type
	char *data
	CODE:
		glTexSubImage3D(target,level,xoffset,yoffset,zoffset,
			width,height,depth,format,type,data);

void
CopyTexSubImage3D ( target, level, xoffset, yoffset, zoffset, x, y, width, height )
	GLenum target
	Sint32 level
	Sint32 xoffset
	Sint32 yoffset
	Sint32 zoffset
	Sint32 x
	Sint32 y
	Uint32 width
	Uint32 height
	CODE:
		glCopyTexSubImage3D(target,level,xoffset,yoffset,zoffset,x,y,width,height);

AV*
GenTextures ( n )
	Uint32 n;
	CODE:
		Uint32 i;
		Uint32 *names;
		names = (Uint32*)safemalloc(sizeof(Uint32)*n);
		RETVAL = newAV();
		glGenTextures(n,names);
		for ( i = 0; i < n; i++ ) {
			av_push(RETVAL,newSViv(names[i]));
		}
		safefree(names);
	OUTPUT:
		RETVAL

GLboolean
IsTexture ( texture )
	Uint32 texture
	CODE:
		RETVAL = glIsTexture(texture);
	OUTPUT:
		RETVAL

void
BindTexture ( target, texture )
	GLenum target
	Uint32 texture
	CODE:
		glBindTexture(target,texture);

void
DeleteTextures ( ... )
	CODE:
		Uint32 *textures;
		int i;
		textures = (Uint32*)safemalloc(sizeof(Uint32) * items);
		if ( textures ) {
	 		for ( i = 0; i < items; i++ ) {
				textures[i] = SvIV(ST(i));	
			}
		}
		glDeleteTextures(items,textures);
		safefree(textures);
			 
AV*
AreTexturesResident ( ... )
	CODE:
		Uint32 *textures;
		GLboolean *homes;
		int i;
		RETVAL = newAV();
		textures = (Uint32*)safemalloc(sizeof(Uint32) * items);
		homes = (GLboolean*)safemalloc(sizeof(GLboolean) * items);
		if ( textures ) {
	 		for ( i = 0; i < items; i++ ) {
				textures[i] = SvIV(ST(i));	
			}
		}
		if ( GL_FALSE != glAreTexturesResident(items,textures,homes)) {
			for (i = 0; i < items; i++ ) {
				av_push(RETVAL,newSViv(homes[i]));	
			}
		}
		safefree(homes);
		safefree(textures);
	OUTPUT:
		RETVAL

void
PrioritizeTextures ( n, names, priorities )
	Uint32 n
	char *names
	char *priorities
	CODE:
		glPrioritizeTextures(n,(GLuint*)names,(const GLclampf *)priorities);

void
TexEnv ( target, name, ... )
	GLenum target
	GLenum name
	CODE:
		float pv[4];
		GLint p;	
		switch(name) {
			case GL_TEXTURE_ENV_MODE:
				p = SvIV(ST(2));
				glTexEnvi(target,name,p);	
				break;
			case GL_TEXTURE_ENV_COLOR:
				pv[0] = SvNV(ST(2));
				pv[1] = SvNV(ST(3));
				pv[2] = SvNV(ST(4));
				pv[3] = SvNV(ST(5));
				glTexEnvfv(target,name,pv);
				break;
		}

void
TexCoord ( ... )
	CODE:
		double s,t,r,q;
		if ( items < 1 || items > 4 ) 
			Perl_croak (aTHX_ "usage: SDL::OpenGL::TexCoord(s,[t,[r,[q]]])");
		s = t = r = 0.0;
		q = 1.0;
		switch(items) {
			case 4:
				q = SvNV(ST(3)); 
			case 3:
				r = SvNV(ST(2)); 
			case 2:
				t = SvNV(ST(1)); 
			case 1:
				s = SvNV(ST(0));	
		}
		glTexCoord4d(s,t,r,q);

void
TexParameter ( target, name, ... )
	GLenum target
	GLenum name
	CODE:
		GLfloat pv[4];
		GLint p;
		switch (name) {
			case GL_TEXTURE_BORDER_COLOR:
				pv[0] = SvNV(ST(2));
				pv[1] = SvNV(ST(3));
				pv[2] = SvNV(ST(4));
				pv[3] = SvNV(ST(5));
				glTexParameterfv(target,name,pv);
				break;
			case GL_TEXTURE_PRIORITY:
			case GL_TEXTURE_MIN_LOD:
			case GL_TEXTURE_MAX_LOD:
				pv[0] = SvNV(ST(2));
				glTexParameterf(target,name,pv[0]);	
				break;
			case GL_TEXTURE_BASE_LEVEL:
			case GL_TEXTURE_MAX_LEVEL:
			default:
				p = SvIV(ST(2));	
				glTexParameteri(target,name,p);
				break;
		}

void
TexGen ( coord, name, ... )
	GLenum coord
	GLenum name	
	CODE:
		GLdouble *pv;
		GLint p;
		int i;
		switch (name) {
			case GL_TEXTURE_GEN_MODE:
				p = SvIV(ST(2));
				glTexGeni(coord,name,p);
				break;
			default:
				if ( items == 2 ) 
					Perl_croak(aTHX_  "usage: glTexGen(coord,name,...)");
				pv = (GLdouble*)safemalloc(sizeof(GLdouble)*(items-2));
				for ( i = 0; i < items - 2; i++ ) {
					pv[i] = SvNV(ST(i+2));	
				}
				glTexGendv(coord,name,pv);	
				safefree(pv);
				break;
		}

void
ActiveTextureARB ( texUnit )
	GLenum texUnit
	CODE:
		glActiveTextureARB(texUnit);
				
void
MultiTexCoord ( texUnit,  ... )
	Uint32 texUnit
	CODE:
		double s,t,r,q;
		if ( items < 2 || items > 5 ) 
			Perl_croak (aTHX_ "usage: SDL::OpenGL::MultiTexCoord(tex,s,[t,[r,[q]]])");
		s = t = r = 0.0;
		q = 1.0;
		switch(items) {
			case 5:
				q = SvNV(ST(3)); 
			case 4:
				r = SvNV(ST(2)); 
			case 3:
				t = SvNV(ST(1)); 
			case 2:
				s = SvNV(ST(0));	
		}
		glMultiTexCoord4dARB(texUnit,s,t,r,q);

void
DrawBuffer ( mode )
	GLenum mode
	CODE:
		glDrawBuffer(mode);

void
ReadBuffer ( mode )
	GLenum mode
	CODE:
		glReadBuffer(mode);

void
IndexMask ( mask )
	Uint32 mask
	CODE:
		glIndexMask(mask);

void
ColorMask ( red, green, blue, alpha )
	GLboolean red
	GLboolean green 
	GLboolean blue 
	GLboolean alpha 
	CODE:
		glColorMask(red,green,blue,alpha);

void
DepthMask ( flag )
	GLboolean flag
	CODE:
		glDepthMask(flag);

void
StencilMask ( mask )
	Uint32 mask
	CODE:
		glStencilMask(mask);

void
Scissor ( x , y, width, height )
	Sint32 x
	Sint32 y
	Uint32 width
	Uint32 height 
	CODE:
		glScissor(x,y,width,height);

void
AlphaFunc ( func, ref )
	GLenum func
	double ref
	CODE:
		glAlphaFunc(func,ref);

void
StencilFunc ( func, ref, mask )
	GLenum func
	Sint32 ref
	Uint32 mask
	CODE:
		glStencilFunc(func,ref,mask);

void
StencilOp ( fail, zfail, zpass )
	GLenum fail
	GLenum zfail
	GLenum zpass
	CODE:
		glStencilOp(fail,zfail,zpass);

void
DepthFunc ( func )
	GLenum func
	CODE:
		glDepthFunc(func);

void
LogicOp ( opcode )
	GLenum opcode
	CODE:
		glLogicOp(opcode);

void
Accum ( op, value )
	GLenum op
	double value
	CODE:
		glAccum(op,value);

void
Map1 ( target, u1, u2, stride, order, points )
	GLenum target
	double u1
	double u2
	Sint32 stride
	Sint32 order
	char *points
	CODE:
		glMap1d(target,u1,u2,stride,order,(double*)points);

void
EvalCoord1 ( u )
	double u
	CODE:
		glEvalCoord1d(u);	

void
MapGrid1 ( n, u1, u2 )
	Sint32 n
	double u1
	double u2
	CODE:
		glMapGrid1d(n,u1,u2);

void
EvalMesh1 ( mode, p1, p2 )
	GLenum mode
	Sint32 p1
	Sint32 p2
	CODE:
		glEvalMesh1(mode,p1,p2);

void
Map2 ( target, u1, u2, ustride, uorder, v1, v2, vstride, vorder, points )
	GLenum target
	double u1
	double u2
	Sint32 ustride
	Sint32 uorder
	double v1
	double v2
	Sint32 vstride
	Sint32 vorder
	char *points
	CODE:
		glMap2d(target,u1,u2,ustride,uorder,v1,v2,vstride,vorder,(double*)points);

void
EvalCoord2 ( u, v )
	double u
	double v
	CODE:
		glEvalCoord2d(u,v);

void
MapGrid2 ( nu, u1, u2, nv, v1, v2 )
	Sint32 nu
	double u1
	double u2
	Sint32 nv
	double v1
	double v2
	CODE:
		glMapGrid2d(nu,u1,u2,nv,v1,v2);

void
EvalMesh2 ( mode, i1, i2, j1, j2 )
	GLenum mode
	Sint32 i1
	Sint32 i2
	Sint32 j1
	Sint32 j2
	CODE:
		glEvalMesh2(mode,i1,i2,j1,j2);

GLenum
GetError ( )
	CODE:
		RETVAL = glGetError();
	OUTPUT:
		RETVAL
	

#endif

#ifdef HAVE_GLU

void
LookAt ( eyex, eyey, eyez, centerx, centery, centerz, upx, upy, upz )
	double eyex
	double eyey
	double eyez
	double centerx
	double centery
	double centerz
	double upx
	double upy
	double upz
	CODE:
		gluLookAt(eyex,eyey,eyez,centerx,centery,centerz,upx,upy,upz);

void
Perspective ( fovy, aspect, near, far )
	double fovy
	double aspect
	double near
	double far
	CODE:
		gluPerspective(fovy,aspect,near,far);

void
Ortho2D ( left, right, bottom, top )
	double left
	double right
	double bottom
	double top
	CODE:
		gluOrtho2D(left,right,bottom,top);

int
ScaleImage ( format, widthin, heightin, typein, datain, widthout, heightout, typeout, dataout )
	GLenum format
	Uint32 widthin
	Uint32 heightin
	GLenum typein
	char *datain
	Uint32 widthout
	Uint32 heightout
	GLenum typeout
	char *dataout
	CODE:
		RETVAL = gluScaleImage(format,widthin,heightin,typein,datain,
				widthout,heightout,typeout,dataout);
	OUTPUT:
		RETVAL

int
Build1DMipmaps ( target, internalFormat, width, format, type, data )
	GLenum target
	Sint32 internalFormat
	Uint32 width
	GLenum format
	GLenum type
	char *data
	CODE:
		RETVAL = gluBuild1DMipmaps(target,internalFormat,width,format,type,data);
	OUTPUT:
		RETVAL

int
Build2DMipmaps ( target, internalFormat, width, height, format, type, data )
	GLenum target
	Sint32 internalFormat
	Uint32 width
	Uint32 height 
	GLenum format
	GLenum type
	char *data
	CODE:
		RETVAL = gluBuild2DMipmaps(target,internalFormat,width,height,format,type,data);
	OUTPUT: 
		RETVAL


#if HAVE_GLU_VERSION >= 12
int
Build3DMipmaps ( target, internalFormat, width, height, depth, format, type, data )
	GLenum target
	Sint32 internalFormat
	Uint32 width
	Uint32 height 
	Uint32 depth 
	GLenum format
	GLenum type
	char *data
	CODE:
		RETVAL = gluBuild3DMipmaps(target,internalFormat,width,height,depth,
				format,type,data);
	OUTPUT: 
		RETVAL

#else
void
Build3DMipmaps ( )
	CODE:
		Perl_croak (aTHX_ "SDL::OpenGL::Build3DMipmaps requires GLU 1.2");

#endif

#if HAVE_GLU_VERSION >= 12
int
Build1DMipmapLevels ( target, internalFormat, width, format, type, level, base, max, data )
	GLenum target
	Sint32 internalFormat
	Uint32 width
	GLenum format
	GLenum type
	Sint32 level
	Sint32 base
	Sint32 max
	char *data
	CODE:
		RETVAL = gluBuild1DMipmapLevels(target,internalFormat,width,
				format,type,level,base,max,data);
	OUTPUT:
		RETVAL

#else
void
Build1DMipmapLevels ()
	CODE:
		Perl_croak(aTHX_ "SDL::OpenGL::Build1DMipmapLevels requires GLU 1.2");		
	
#endif

#if HAVE_GLU_VERSION >= 12
int
Build2DMipmapLevels ( target, internalFormat, width, height, format, type, level, base, max, data )
	GLenum target
	Sint32 internalFormat
	Uint32 width
	Uint32 height 
	GLenum format
	GLenum type
	Sint32 level
	Sint32 base
	Sint32 max
	char *data
	CODE:
		RETVAL = gluBuild2DMipmapLevels(target,internalFormat,width,height,
				format,type,level,base,max,data);
	OUTPUT:
		RETVAL

#else
void
Build2DMipmapLevels ()
	CODE:
		Perl_croak(aTHX_ "SDL::OpenGL::Build2DMipmapLevels requires GLU 1.2");		

#endif

#if HAVE_GLU_VERSION >= 12
int
Build3DMipmapLevels ( target, internalFormat, width, height, depth, format, type, level, base, max, data )
	GLenum target
	Sint32 internalFormat
	Uint32 width
	Uint32 height 
	Uint32 depth 
	GLenum format
	GLenum type
	Sint32 level
	Sint32 base
	Sint32 max
	char *data
	CODE:
		RETVAL = gluBuild3DMipmapLevels(target,internalFormat,width,height,depth,
				format,type,level,base,max,data);
	OUTPUT:
		RETVAL

#else
void
Build3DMipmapLevels ()
	CODE:
		Perl_croak(aTHX_ "SDL::OpenGL::Build3DMipmapLevels requires GLU 1.2");		

#endif

char*
ErrorString ( code )
	GLenum code
	CODE:
		RETVAL = (char*)gluErrorString(code);
	OUTPUT:
		RETVAL

GLUnurbsObj*
NewNurbsRenderer ()
	CODE:
		RETVAL = gluNewNurbsRenderer();
	OUTPUT:
		RETVAL

void
DeleteNurbsRenderer ( obj )
	GLUnurbsObj *obj
	CODE:
		gluDeleteNurbsRenderer(obj);

void
NurbsProperty ( obj, property, value )
	GLUnurbsObj *obj
	GLenum property
	double value
	CODE:
		gluNurbsProperty(obj,property,(float)value);

void
LoadSamplingMatrices ( obj, mm, pm, vp )
	GLUnurbsObj *obj
	char *mm
	char *pm
	char *vp
	CODE:
		gluLoadSamplingMatrices(obj,(GLfloat*)mm,(GLfloat*)pm,(GLint*)vp);

double
GetNurbsProperty ( obj, property )
	GLUnurbsObj *obj
	GLenum property
	CODE:
		float f;
		gluGetNurbsProperty(obj,property,&f);
		RETVAL = (double)f;
	OUTPUT:
		RETVAL

void
NurbsCallback ( obj, which, cb )
	GLUnurbsObj *obj
	GLenum which
	SV *cb
	CODE:
		switch(which) {
			case GLU_ERROR:
				sdl_perl_nurbs_error_hook = cb;
				gluNurbsCallback(obj,GLU_ERROR,(GLvoid*)sdl_perl_nurbs_error_callback);
				break;
			case GLU_NURBS_BEGIN:
			case GLU_NURBS_BEGIN_DATA:
				gluNurbsCallbackData(obj,(void*)cb);
				gluNurbsCallback(obj,GLU_NURBS_BEGIN_DATA,
					(GLvoid*)sdl_perl_nurbs_being_callback);	
				break;
			case GLU_NURBS_TEXTURE_COORD:
			case GLU_NURBS_TEXTURE_COORD_DATA:
				gluNurbsCallbackData(obj,(void*)cb);
				gluNurbsCallback(obj,GLU_NURBS_TEXTURE_COORD_DATA,
					(GLvoid*)sdl_perl_nurbs_multi_callback);	
				break;
			case GLU_NURBS_COLOR:
			case GLU_NURBS_COLOR_DATA:
				gluNurbsCallbackData(obj,(void*)cb);
				gluNurbsCallback(obj,GLU_NURBS_COLOR_DATA,
					(GLvoid*)sdl_perl_nurbs_multi_callback);	
				break;
			case GLU_NURBS_NORMAL:
			case GLU_NURBS_NORMAL_DATA:
				gluNurbsCallbackData(obj,(void*)cb);
				gluNurbsCallback(obj,GLU_NURBS_NORMAL_DATA,
					(GLvoid*)sdl_perl_nurbs_multi_callback);	
				break;
			case GLU_NURBS_VERTEX:
			case GLU_NURBS_VERTEX_DATA:
				gluNurbsCallbackData(obj,(void*)cb);
				gluNurbsCallback(obj,GLU_NURBS_VERTEX_DATA,
					(GLvoid*)sdl_perl_nurbs_multi_callback);	
				break;
			case GLU_NURBS_END:
			case GLU_NURBS_END_DATA:
				gluNurbsCallbackData(obj,(void*)cb);
				gluNurbsCallback(obj,GLU_NURBS_END_DATA,
					(GLvoid*)sdl_perl_nurbs_end_callback);	
				break;
			default:
				Perl_croak(aTHX_ "SDL::OpenGL::NurbsCallback - invalid type");
		}

void
NurbsCallbackData ( obj, cb )
	GLUnurbsObj *obj
	SV *cb
	CODE:
		gluNurbsCallbackData(obj,(void*)cb);

void
BeginSurface ( obj )
	GLUnurbsObj *obj
	CODE:
		gluBeginSurface(obj);

void
EndSurface ( obj )
	GLUnurbsObj *obj
	CODE:
		gluEndSurface(obj);
	
void
NurbsSurface ( obj, uknot_count, uknot, vknot_count, vknot, u_stride, v_stride, ctlarray, uorder, vorder, type )
	GLUnurbsObj *obj
	Sint32 uknot_count
	char *uknot
	Sint32 vknot_count
	char *vknot
	Sint32 u_stride
	Sint32 v_stride
	char *ctlarray
	Sint32 uorder
	Sint32 vorder
	GLenum type
	CODE:
		gluNurbsSurface(obj,uknot_count,(GLfloat*)uknot,vknot_count,(GLfloat*)vknot,
			u_stride,v_stride,(GLfloat*)ctlarray,uorder,vorder,type);

void
BeginCurve ( obj )
	GLUnurbsObj *obj
	CODE:
		gluBeginCurve(obj);

void
EndCurve ( obj ) 
	GLUnurbsObj *obj
	CODE:
		gluEndCurve(obj);

void
NurbsCurve ( obj, uknot_count, uknot, u_stride, ctlarray, uorder, type )
	GLUnurbsObj *obj
	Sint32 uknot_count
	char *uknot
	Sint32 u_stride
	char *ctlarray
	Sint32 uorder
	GLenum type
	CODE:
		gluNurbsCurve(obj,uknot_count,(GLfloat*)uknot,u_stride,(GLfloat*)ctlarray,
			uorder,type);

void
BeginTrim ( obj )
	GLUnurbsObj *obj
	CODE:
		gluBeginTrim(obj);

void
EndTrim ( obj )
	GLUnurbsObj *obj
	CODE:
		gluEndTrim(obj);

void
PwlCurve ( obj, count, array, stride, type )	
	GLUnurbsObj *obj
	Sint32 count
	char *array
	Sint32 stride
	GLenum type
	CODE:
		gluPwlCurve(obj,count,(GLfloat*)array,stride,type);

AV*
UnProject ( winx, winy, winz, mm, pm, vp )
	double winx
	double winy
	double winz
	char *mm
	char *pm
	char *vp
	CODE:
		GLdouble objx, objy, objz;
		RETVAL = newAV();
		av_push(RETVAL,newSViv(gluUnProject(winx,winy,winz,(GLdouble*)mm,
			(GLdouble*)pm,(GLint*)vp,&objx,&objy,&objz)));
		av_push(RETVAL,newSVnv((double)objx));
		av_push(RETVAL,newSVnv((double)objy));
		av_push(RETVAL,newSVnv((double)objz));
	OUTPUT:
		RETVAL
		
AV*
UnProject4 ( winx, winy, winz, clipw, mm, pm, vp, near, far )
        double winx
        double winy
        double winz
	double clipw
        char *mm
        char *pm
        char *vp
	double near
	double far
        CODE:
                GLdouble objx, objy, objz, objw;
                RETVAL = newAV();
                av_push(RETVAL,newSViv(gluUnProject4(winx,winy,winz,clipw,(GLdouble*)mm,
                        (GLdouble*)pm,(GLint*)vp,(GLclampd)near,(GLclampd)far,
			&objx,&objy,&objz,&objw)));
                av_push(RETVAL,newSVnv((double)objx));
                av_push(RETVAL,newSVnv((double)objy));
                av_push(RETVAL,newSVnv((double)objz));
                av_push(RETVAL,newSVnv((double)objw));
        OUTPUT:
                RETVAL

AV*
Project ( objx, objy, objz, mm, pm, vp )
	double objx
	double objy
	double objz
	char *mm
	char *pm
	char *vp
	CODE:
		GLdouble winx, winy, winz;
		RETVAL = newAV();
		av_push(RETVAL,newSViv(gluUnProject(objx,objy,objz,(GLdouble*)mm,
			(GLdouble*)pm,(GLint*)vp,&winx,&winy,&winz)));
                av_push(RETVAL,newSVnv((double)winx));
                av_push(RETVAL,newSVnv((double)winy));
                av_push(RETVAL,newSVnv((double)winz));
	OUTPUT:
		RETVAL

GLUtesselator*
NewTess ()
	CODE:
		RETVAL = gluNewTess();
	OUTPUT:
		RETVAL

void
TessCallback ( tess, type )
	GLUtesselator *tess
	GLenum type
	CODE:
		switch(type) {
			case GLU_TESS_BEGIN:
			case GLU_TESS_BEGIN_DATA:
				gluTessCallback(tess,GLU_TESS_BEGIN_DATA,
					(GLvoid*)sdl_perl_tess_begin_callback);	
				break;
	
			case GLU_TESS_EDGE_FLAG:
			case GLU_TESS_EDGE_FLAG_DATA:
				gluTessCallback(tess,GLU_TESS_EDGE_FLAG_DATA,
					(GLvoid*)sdl_perl_tess_edge_flag_callback);	
				break;

			case GLU_TESS_VERTEX:
			case GLU_TESS_VERTEX_DATA:
				gluTessCallback(tess,GLU_TESS_VERTEX_DATA,
					(GLvoid*)sdl_perl_tess_vertex_callback);	
				break;

			case GLU_TESS_END:
			case GLU_TESS_END_DATA:
				gluTessCallback(tess,GLU_TESS_END_DATA,
					(GLvoid*)sdl_perl_tess_end_callback);	
				break;

			case GLU_TESS_COMBINE:
			case GLU_TESS_COMBINE_DATA:
				gluTessCallback(tess,GLU_TESS_COMBINE_DATA,
					(GLvoid*)sdl_perl_tess_combine_callback);	
				break;

			case GLU_TESS_ERROR:
			case GLU_TESS_ERROR_DATA:
				gluTessCallback(tess,GLU_TESS_ERROR_DATA,
					(GLvoid*)sdl_perl_tess_error_callback);	
				break;
		}

void
TessProperty ( tessobj, property, value )
	GLUtesselator *tessobj
	Uint32 property
	double value
	CODE:
		gluTessProperty(tessobj,property,value);

double
GetTessProperty ( tessobj, property )
	GLUtesselator *tessobj
	Uint32 property
	CODE:
		gluGetTessProperty(tessobj,property,&RETVAL);
	OUTPUT:
		RETVAL

void
TessNormal ( tessobj, x, y, z )
	GLUtesselator *tessobj
	double x
	double y
	double z
	CODE:
		gluTessNormal(tessobj,x,y,z);

void
TessBeginPolygon ( tessobj, cb )
	GLUtesselator *tessobj
	SV *cb
	CODE:
		gluTessBeginPolygon(tessobj,cb);

void
TessEndPolygon ( tessobj ) 
	GLUtesselator *tessobj
	CODE:
		gluTessEndPolygon(tessobj);

void
TessBeginContour ( tessobj )
	GLUtesselator *tessobj
	CODE:
		gluTessBeginContour(tessobj);

void
TessEndContour ( tessobj )
	GLUtesselator *tessobj
	CODE:
		gluTessEndContour(tessobj);

void
DeleteTess ( tessobj )
	GLUtesselator *tessobj
	CODE:
		gluDeleteTess(tessobj);

void
TessVertex ( tessobj, coords, vd ) 
	GLUtesselator *tessobj
	char *coords
	char *vd
	CODE:
		gluTessVertex(tessobj,(GLdouble*)coords,vd);
	
#endif

#ifdef HAVE_GL

GLbitfield
GL_COLOR_BUFFER_BIT ()
	CODE:
		RETVAL = GL_COLOR_BUFFER_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_DEPTH_BUFFER_BIT ()
	CODE:
		RETVAL = GL_DEPTH_BUFFER_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_ACCUM_BUFFER_BIT ()
	CODE:
		RETVAL = GL_ACCUM_BUFFER_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_STENCIL_BUFFER_BIT ()
	CODE:
		RETVAL = GL_STENCIL_BUFFER_BIT;
	OUTPUT:
		RETVAL

GLenum
GL_POINTS ()
	CODE:
		RETVAL = GL_POINTS;
	OUTPUT:
		RETVAL

GLenum
GL_LINES ()
        CODE:
                RETVAL = GL_LINES;
        OUTPUT:
                RETVAL

GLenum
GL_LINE_STRIP ()
        CODE:
                RETVAL = GL_LINE_STRIP;
        OUTPUT:
                RETVAL

GLenum
GL_LINE_LOOP ()
        CODE:
                RETVAL = GL_LINE_LOOP;
        OUTPUT:
                RETVAL

GLenum
GL_TRIANGLES ()
	CODE:
		RETVAL = GL_TRIANGLES;
	OUTPUT:
		RETVAL

GLenum
GL_TRIANGLE_STRIP ()
        CODE:
                RETVAL = GL_TRIANGLE_STRIP;
        OUTPUT:
                RETVAL

GLenum
GL_TRIANGLE_FAN ()
        CODE:
                RETVAL = GL_TRIANGLE_FAN;
        OUTPUT:
                RETVAL

GLenum
GL_QUADS ()
	CODE:
		RETVAL = GL_QUADS;
	OUTPUT:
		RETVAL

GLenum
GL_QUAD_STRIP ()
	CODE:
		RETVAL = GL_QUAD_STRIP;
	OUTPUT:
		RETVAL

GLenum
GL_POLYGON ()
	CODE:
		RETVAL = GL_POLYGON;
	OUTPUT:
		RETVAL

GLenum
GL_LINE_STIPPLE ()
	CODE:
		RETVAL = GL_LINE_STIPPLE;
	OUTPUT:
		RETVAL

GLenum
GL_FRONT ()
	CODE:
		RETVAL = GL_FRONT;
	OUTPUT:
		RETVAL

GLenum
GL_BACK ()
	CODE:
		RETVAL = GL_BACK;
	OUTPUT:
		RETVAL

GLenum
GL_POINT ()
	CODE:
		RETVAL = GL_POINT;
	OUTPUT:
		RETVAL

GLenum
GL_LINE ()
	CODE:
		RETVAL = GL_LINE;
	OUTPUT:
		RETVAL

GLenum
GL_FILL ()
	CODE:
		RETVAL = GL_FILL;
	OUTPUT:
		RETVAL

GLenum
GL_CCW ()
	CODE:
		RETVAL = GL_CCW;
	OUTPUT:
		RETVAL

GLenum
GL_CW ()
	CODE:
		RETVAL = GL_CW;
	OUTPUT:
		RETVAL

GLenum
GL_FRONT_AND_BACK ()
	CODE:
		RETVAL = GL_FRONT_AND_BACK;
	OUTPUT:
		RETVAL

GLenum
GL_CULL_FACE ()
	CODE:
		RETVAL = GL_CULL_FACE;
	OUTPUT:
		RETVAL

GLenum
GL_POLYGON_STIPPLE ()
	CODE:
		RETVAL = GL_POLYGON_STIPPLE;
	OUTPUT:
		RETVAL

GLenum
GL_NORMALIZE ()
	CODE:
		RETVAL = GL_NORMALIZE;
	OUTPUT:
		RETVAL

GLenum
GL_RESCALE_NORMAL ()
	CODE:
		RETVAL = GL_RESCALE_NORMAL;
	OUTPUT:
		RETVAL

GLenum
GL_VERTEX_ARRAY ()
	CODE:
		RETVAL = GL_VERTEX_ARRAY;
	OUTPUT:
		RETVAL

GLenum
GL_COLOR_ARRAY ()
	CODE:
		RETVAL = GL_COLOR_ARRAY;
	OUTPUT:
		RETVAL

GLenum
GL_INDEX_ARRAY ()
	CODE:
		RETVAL = GL_INDEX_ARRAY;
	OUTPUT:
		RETVAL

GLenum
GL_NORMAL_ARRAY ()
	CODE:
		RETVAL = GL_NORMAL_ARRAY;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_COORD_ARRAY ()
	CODE:
		RETVAL = GL_TEXTURE_COORD_ARRAY;
	OUTPUT:
		RETVAL

GLenum
GL_EDGE_FLAG_ARRAY ()
	CODE:
		RETVAL = GL_EDGE_FLAG_ARRAY;
	OUTPUT:
		RETVAL

GLenum
GL_BYTE ()
	CODE:
		RETVAL = GL_BYTE;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_BYTE ()
	CODE:
		RETVAL = GL_UNSIGNED_BYTE;
	OUTPUT:
		RETVAL

GLenum
GL_SHORT ()
	CODE:
		RETVAL = GL_SHORT;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_SHORT ()
	CODE:
		RETVAL = GL_UNSIGNED_SHORT;
	OUTPUT:
		RETVAL

GLenum
GL_INT ()
	CODE:
		RETVAL = GL_INT;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_INT ()
	CODE:
		RETVAL = GL_UNSIGNED_INT;
	OUTPUT:
		RETVAL

GLenum
GL_FLOAT ()
	CODE:
		RETVAL = GL_FLOAT;
	OUTPUT:
		RETVAL

GLenum
GL_DOUBLE ()
	CODE:
		RETVAL = GL_DOUBLE;
	OUTPUT:
		RETVAL

GLenum
GL_V2F ()
	CODE:
		RETVAL = GL_V2F;
	OUTPUT:
		RETVAL

GLenum
GL_V3F ()
	CODE:
		RETVAL = GL_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_C4UB_V2F ()
	CODE:
		RETVAL = GL_C4UB_V2F;
	OUTPUT:
		RETVAL

GLenum
GL_C4UB_V3F ()
	CODE:
		RETVAL = GL_C4UB_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_C3F_V3F ()
	CODE:
		RETVAL = GL_C3F_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_N3F_V3F ()
	CODE:
		RETVAL = GL_N3F_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_C4F_N3F_V3F ()
	CODE:
		RETVAL = GL_C4F_N3F_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_T2F_V3F ()
	CODE:
		RETVAL = GL_T2F_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_T4F_V4F ()
	CODE:
		RETVAL = GL_T4F_V4F;
	OUTPUT:
		RETVAL

GLenum
GL_T2F_C4UB_V3F ()
	CODE:
		RETVAL = GL_T2F_C4UB_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_T2F_C3F_V3F ()
	CODE:
		RETVAL = GL_T2F_C3F_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_T2F_N3F_V3F ()
	CODE:
		RETVAL = GL_T2F_N3F_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_T2F_C4F_N3F_V3F ()
	CODE:
		RETVAL = GL_T2F_C4F_N3F_V3F;
	OUTPUT:
		RETVAL

GLenum
GL_T4F_C4F_N3F_V4F ()
	CODE:
		RETVAL = GL_T4F_C4F_N3F_V4F;
	OUTPUT:
		RETVAL

GLbitfield
GL_ALL_ATTRIB_BITS ()
	CODE:
		RETVAL = GL_ALL_ATTRIB_BITS;
	OUTPUT:
		RETVAL

GLbitfield
GL_CURRENT_BIT ()
	CODE:
		RETVAL = GL_CURRENT_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_ENABLE_BIT ()
	CODE:
		RETVAL = GL_ENABLE_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_EVAL_BIT ()
	CODE:
		RETVAL = GL_EVAL_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_FOG_BIT ()
	CODE:
		RETVAL = GL_FOG_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_HINT_BIT ()
	CODE:
		RETVAL = GL_HINT_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_LIGHTING_BIT ()
	CODE:
		RETVAL = GL_LIGHTING_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_LINE_BIT ()
	CODE:
		RETVAL = GL_LINE_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_LIST_BIT ()
	CODE:
		RETVAL = GL_LIST_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_PIXEL_MODE_BIT ()
	CODE:
		RETVAL = GL_PIXEL_MODE_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_POINT_BIT ()
	CODE:
		RETVAL = GL_POINT_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_POLYGON_BIT ()
	CODE:
		RETVAL = GL_POLYGON_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_POLYGON_STIPPLE_BIT ()
	CODE:
		RETVAL = GL_POLYGON_STIPPLE_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_SCISSOR_BIT ()
	CODE:
		RETVAL = GL_SCISSOR_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_TEXTURE_BIT ()
	CODE:
		RETVAL = GL_TEXTURE_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_TRANSFORM_BIT ()
	CODE:
		RETVAL = GL_TRANSFORM_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_VIEWPORT_BIT ()
	CODE:
		RETVAL = GL_VIEWPORT_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_CLIENT_PIXEL_STORE_BIT ()
	CODE:
		RETVAL = GL_CLIENT_PIXEL_STORE_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_CLIENT_VERTEX_ARRAY_BIT ()
	CODE:
		RETVAL = GL_CLIENT_VERTEX_ARRAY_BIT;
	OUTPUT:
		RETVAL

GLbitfield
GL_ALL_CLIENT_ATTRIB_BITS ()
	CODE:
		RETVAL = GL_ALL_CLIENT_ATTRIB_BITS;
	OUTPUT:
		RETVAL

GLenum
GL_MODELVIEW ()
	CODE:
		RETVAL = GL_MODELVIEW;
	OUTPUT:
		RETVAL

GLenum
GL_PROJECTION ()
	CODE:
		RETVAL = GL_PROJECTION;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE ()
	CODE:
		RETVAL = GL_TEXTURE;
	OUTPUT:
		RETVAL

GLenum
GL_SMOOTH ()
	CODE:
		RETVAL = GL_SMOOTH;
	OUTPUT:
		RETVAL

GLenum
GL_FLAT ()
	CODE:
		RETVAL = GL_FLAT;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT0 ()
	CODE:
		RETVAL = GL_LIGHT0;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT1 ()
	CODE:
		RETVAL = GL_LIGHT1;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT2 ()
	CODE:
		RETVAL = GL_LIGHT2;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT3 ()
	CODE:
		RETVAL = GL_LIGHT3;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT4 ()
	CODE:
		RETVAL = GL_LIGHT4;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT5 ()
	CODE:
		RETVAL = GL_LIGHT5;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT6 ()
	CODE:
		RETVAL = GL_LIGHT6;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT7 ()
	CODE:
		RETVAL = GL_LIGHT7;
	OUTPUT:
		RETVAL

GLenum
GL_AMBIENT ()
	CODE:
		RETVAL = GL_AMBIENT;
	OUTPUT:
		RETVAL

GLenum
GL_DIFFUSE ()
	CODE:
		RETVAL = GL_DIFFUSE;
	OUTPUT:
		RETVAL

GLenum
GL_AMBIENT_AND_DIFFUSE ()
	CODE:
		RETVAL = GL_AMBIENT_AND_DIFFUSE;
	OUTPUT:
		RETVAL

GLenum
GL_SPECULAR ()
	CODE:
		RETVAL = GL_SPECULAR;
	OUTPUT:
		RETVAL

GLenum
GL_SHININESS ()
	CODE:
		RETVAL = GL_SHININESS;
	OUTPUT:
		RETVAL

GLenum
GL_EMISSION ()
	CODE:
		RETVAL = GL_EMISSION;
	OUTPUT:
		RETVAL

GLenum
GL_COLOR_INDEXES ()
	CODE:
		RETVAL = GL_COLOR_INDEXES;
	OUTPUT:
		RETVAL

GLenum
GL_POSITION ()
	CODE:
		RETVAL = GL_POSITION;
	OUTPUT:
		RETVAL

GLenum
GL_SPOT_DIRECTION ()
	CODE:
		RETVAL = GL_SPOT_DIRECTION;
	OUTPUT:
		RETVAL

GLenum
GL_SPOT_EXPONENT ()
	CODE:
		RETVAL = GL_SPOT_EXPONENT;
	OUTPUT:
		RETVAL

GLenum
GL_SPOT_CUTOFF ()
	CODE:
		RETVAL = GL_SPOT_CUTOFF;
	OUTPUT:
		RETVAL

GLenum
GL_CONSTANT_ATTENUATION ()
	CODE:
		RETVAL = GL_CONSTANT_ATTENUATION;
	OUTPUT:
		RETVAL

GLenum
GL_LINEAR_ATTENUATION ()
	CODE:
		RETVAL = GL_LINEAR_ATTENUATION;
	OUTPUT:
		RETVAL

GLenum
GL_QUADRATIC_ATTENUATION ()
	CODE:
		RETVAL = GL_QUADRATIC_ATTENUATION;
	OUTPUT:
		RETVAL


GLenum
GL_LIGHT_MODEL_AMBIENT ()
	CODE:
		RETVAL = GL_LIGHT_MODEL_AMBIENT;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT_MODEL_LOCAL_VIEWER ()
	CODE:
		RETVAL = GL_LIGHT_MODEL_LOCAL_VIEWER;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT_MODEL_TWO_SIDE ()
	CODE:
		RETVAL = GL_LIGHT_MODEL_TWO_SIDE;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHT_MODEL_COLOR_CONTROL ()
	CODE:
		RETVAL = GL_LIGHT_MODEL_COLOR_CONTROL;
	OUTPUT:
		RETVAL

GLenum
GL_FALSE ()
	CODE:
		RETVAL = GL_FALSE;
	OUTPUT:
		RETVAL

GLenum
GL_TRUE ()
	CODE:
		RETVAL = GL_TRUE;
	OUTPUT:
		RETVAL

GLenum
GL_SINGLE_COLOR ()
	CODE:
		RETVAL = GL_SINGLE_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_ZERO ()
	CODE:
		RETVAL = GL_ZERO;
	OUTPUT:
		RETVAL

GLenum
GL_ONE ()
	CODE:
		RETVAL = GL_ONE;
	OUTPUT:
		RETVAL

GLenum
GL_DST_COLOR ()
	CODE:
		RETVAL = GL_DST_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_SRC_COLOR ()
	CODE:
		RETVAL = GL_SRC_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_ONE_MINUS_DST_COLOR ()
	CODE:
		RETVAL = GL_ONE_MINUS_DST_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_ONE_MINUS_SRC_COLOR ()
	CODE:
		RETVAL = GL_ONE_MINUS_SRC_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_SRC_ALPHA ()
	CODE:
		RETVAL = GL_SRC_ALPHA;
	OUTPUT:
		RETVAL

GLenum
GL_ONE_MINUS_SRC_ALPHA ()
	CODE:
		RETVAL = GL_ONE_MINUS_SRC_ALPHA;
	OUTPUT:
		RETVAL

GLenum
GL_SRC_ALPHA_SATURATE ()
	CODE:
		RETVAL = GL_SRC_ALPHA_SATURATE;
	OUTPUT:
		RETVAL

GLenum
GL_CONSTANT_COLOR ()
	CODE:
		RETVAL = GL_CONSTANT_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_ONE_MINUS_CONSTANT_COLOR ()
	CODE:
		RETVAL = GL_ONE_MINUS_CONSTANT_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_CONSTANT_ALPHA ()
	CODE:
		RETVAL = GL_CONSTANT_ALPHA;
	OUTPUT:
		RETVAL

GLenum
GL_ONE_MINUS_CONSTANT_ALPHA ()
	CODE:
		RETVAL = GL_ONE_MINUS_CONSTANT_ALPHA;
	OUTPUT:
		RETVAL

GLenum
GL_POINT_SMOOTH_HINT ()
	CODE:
		RETVAL = GL_POINT_SMOOTH_HINT;
	OUTPUT:
		RETVAL

GLenum
GL_LINE_SMOOTH_HINT ()
	CODE:
		RETVAL = GL_LINE_SMOOTH_HINT;
	OUTPUT:
		RETVAL

GLenum
GL_POLYGON_SMOOTH_HINT ()
	CODE:
		RETVAL = GL_POLYGON_SMOOTH_HINT;
	OUTPUT:
		RETVAL

GLenum
GL_FOG_HINT ()
	CODE:
		RETVAL = GL_FOG_HINT;
	OUTPUT:
		RETVAL

GLenum
GL_PERSPECTIVE_CORRECTION_HINT ()
	CODE:
		RETVAL = GL_PERSPECTIVE_CORRECTION_HINT;
	OUTPUT:
		RETVAL

GLenum
GL_EXP ()
	CODE:
		RETVAL = GL_EXP;
	OUTPUT:
		RETVAL

GLenum
GL_EXP2 ()
	CODE:
		RETVAL = GL_EXP2;
	OUTPUT:
		RETVAL

GLenum
GL_FOG_MODE ()
	CODE:
		RETVAL = GL_FOG_MODE;
	OUTPUT:
		RETVAL

GLenum
GL_LINEAR ()
	CODE:
		RETVAL = GL_LINEAR;
	OUTPUT:
		RETVAL

GLenum
GL_FOG_DENSITY ()
	CODE:
		RETVAL = GL_FOG_DENSITY;
	OUTPUT:
		RETVAL

GLenum
GL_FOG_START ()
	CODE:
		RETVAL = GL_FOG_START;
	OUTPUT:
		RETVAL

GLenum
GL_FOG_END ()
	CODE:
		RETVAL = GL_FOG_END;
	OUTPUT:
		RETVAL

GLenum
GL_FOG_COLOR ()
	CODE:
		RETVAL = GL_FOG_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_POLYGON_OFFSET_LINE ()
	CODE:
		RETVAL = GL_POLYGON_OFFSET_LINE;
	OUTPUT:
		RETVAL

GLenum
GL_POLYGON_OFFSET_FILL ()
	CODE:
		RETVAL = GL_POLYGON_OFFSET_FILL;
	OUTPUT:
		RETVAL

GLenum
GL_POLYGON_OFFSET_POINT ()
	CODE:
		RETVAL = GL_POLYGON_OFFSET_POINT;
	OUTPUT:
		RETVAL

GLenum
GL_COLOR_INDEX ()
	CODE:
		RETVAL = GL_COLOR_INDEX;
	OUTPUT:
		RETVAL

GLenum
GL_RGB ()
	CODE:
		RETVAL = GL_RGB;
	OUTPUT:
		RETVAL

GLenum
GL_RGBA ()
	CODE:
		RETVAL = GL_RGBA;
	OUTPUT:
		RETVAL

GLenum
GL_BGR ()
	CODE:
		RETVAL = GL_BGR;
	OUTPUT:
		RETVAL

GLenum
GL_BGRA ()
	CODE:
		RETVAL = GL_BGRA;
	OUTPUT:
		RETVAL

GLenum
GL_RED ()
	CODE:
		RETVAL = GL_RED;
	OUTPUT:
		RETVAL

GLenum
GL_GREEN ()
	CODE:
		RETVAL = GL_GREEN;
	OUTPUT:
		RETVAL

GLenum
GL_BLUE ()
	CODE:
		RETVAL = GL_BLUE;
	OUTPUT:
		RETVAL

GLenum
GL_ALPHA ()
	CODE:
		RETVAL = GL_ALPHA;
	OUTPUT:
		RETVAL

GLenum
GL_LUMINANCE ()
	CODE:
		RETVAL = GL_LUMINANCE;
	OUTPUT:
		RETVAL

GLenum
GL_LUMINANCE_ALPHA ()
	CODE:
		RETVAL = GL_LUMINANCE_ALPHA;
	OUTPUT:
		RETVAL

GLenum
GL_STENCIL_INDEX ()
	CODE:
		RETVAL = GL_STENCIL_INDEX;
	OUTPUT:
		RETVAL

GLenum
GL_DEPTH_COMPONENT ()
	CODE:
		RETVAL = GL_DEPTH_COMPONENT;
	OUTPUT:
		RETVAL

GLenum
GL_BITMAP ()
	CODE:
		RETVAL = GL_BITMAP;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_BYTE_3_3_2 ()
	CODE:
		RETVAL = GL_UNSIGNED_BYTE_3_3_2;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_BYTE_2_3_3_REV ()
	CODE:
		RETVAL = GL_UNSIGNED_BYTE_2_3_3_REV;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_SHORT_5_6_5 ()
	CODE:
		RETVAL = GL_UNSIGNED_SHORT_5_6_5;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_SHORT_5_6_5_REV ()
	CODE:
		RETVAL = GL_UNSIGNED_SHORT_5_6_5_REV;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_SHORT_4_4_4_4 ()
	CODE:
		RETVAL = GL_UNSIGNED_SHORT_4_4_4_4;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_SHORT_4_4_4_4_REV ()
	CODE:
		RETVAL = GL_UNSIGNED_SHORT_4_4_4_4_REV;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_SHORT_5_5_5_1 ()
	CODE:
		RETVAL = GL_UNSIGNED_SHORT_5_5_5_1;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_SHORT_1_5_5_5_REV ()
	CODE:
		RETVAL = GL_UNSIGNED_SHORT_1_5_5_5_REV;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_INT_8_8_8_8 ()
	CODE:
		RETVAL = GL_UNSIGNED_INT_8_8_8_8;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_INT_8_8_8_8_REV ()
	CODE:
		RETVAL = GL_UNSIGNED_INT_8_8_8_8_REV;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_INT_10_10_10_2 ()
	CODE:
		RETVAL = GL_UNSIGNED_INT_10_10_10_2;
	OUTPUT:
		RETVAL

GLenum
GL_UNSIGNED_INT_2_10_10_10_REV ()
	CODE:
		RETVAL = GL_UNSIGNED_INT_2_10_10_10_REV;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_SWAP_BYTES ()
	CODE:
		RETVAL = GL_UNPACK_SWAP_BYTES;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_SWAP_BYTES ()
	CODE:
		RETVAL = GL_PACK_SWAP_BYTES;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_LSB_FIRST ()
	CODE:
		RETVAL = GL_UNPACK_LSB_FIRST;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_LSB_FIRST ()
	CODE:
		RETVAL = GL_PACK_LSB_FIRST;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_ROW_LENGTH ()
	CODE:
		RETVAL = GL_UNPACK_ROW_LENGTH;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_ROW_LENGTH ()
	CODE:
		RETVAL = GL_PACK_ROW_LENGTH;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_SKIP_ROWS ()
	CODE:
		RETVAL = GL_UNPACK_SKIP_ROWS;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_SKIP_ROWS ()
	CODE:
		RETVAL = GL_PACK_SKIP_ROWS;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_SKIP_PIXELS ()
	CODE:
		RETVAL = GL_UNPACK_SKIP_PIXELS;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_SKIP_PIXELS ()
	CODE:
		RETVAL = GL_PACK_SKIP_PIXELS;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_ALIGNMENT ()
	CODE:
		RETVAL = GL_UNPACK_ALIGNMENT;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_ALIGNMENT ()
	CODE:
		RETVAL = GL_PACK_ALIGNMENT;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_IMAGE_HEIGHT ()
	CODE:
		RETVAL = GL_UNPACK_IMAGE_HEIGHT;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_IMAGE_HEIGHT ()
	CODE:
		RETVAL = GL_PACK_IMAGE_HEIGHT;
	OUTPUT:
		RETVAL

Sint32
GL_UNPACK_SKIP_IMAGES ()
	CODE:
		RETVAL = GL_UNPACK_SKIP_IMAGES;
	OUTPUT:
		RETVAL

Sint32
GL_PACK_SKIP_IMAGES ()
	CODE:
		RETVAL = GL_PACK_SKIP_IMAGES;
	OUTPUT:
		RETVAL

Sint32
GL_MAP_COLOR ()
	CODE:
		RETVAL = GL_MAP_COLOR;
	OUTPUT:
		RETVAL

Sint32
GL_MAP_STENCIL ()
	CODE:
		RETVAL = GL_MAP_STENCIL;
	OUTPUT:
		RETVAL

Sint32
GL_INDEX_SHIFT ()
	CODE:
		RETVAL = GL_INDEX_SHIFT;
	OUTPUT:
		RETVAL

Sint32
GL_INDEX_OFFSET ()
	CODE:
		RETVAL = GL_INDEX_OFFSET;
	OUTPUT:
		RETVAL

		
double
GL_RED_SCALE ()
	CODE:
		RETVAL = GL_RED_SCALE;
	OUTPUT:
		RETVAL

double
GL_GREEN_SCALE ()
	CODE:
		RETVAL = GL_GREEN_SCALE;
	OUTPUT:
		RETVAL

double
GL_BLUE_SCALE ()
	CODE:
		RETVAL = GL_BLUE_SCALE;
	OUTPUT:
		RETVAL

double
GL_ALPHA_SCALE ()
	CODE:
		RETVAL = GL_ALPHA_SCALE;
	OUTPUT:
		RETVAL

double
GL_DEPTH_SCALE ()
	CODE:
		RETVAL = GL_DEPTH_SCALE;
	OUTPUT:
		RETVAL

double
GL_RED_BIAS ()
	CODE:
		RETVAL = GL_RED_BIAS;
	OUTPUT:
		RETVAL

double
GL_GREEN_BIAS ()
	CODE:
		RETVAL = GL_GREEN_BIAS;
	OUTPUT:
		RETVAL

double
GL_BLUE_BIAS ()
	CODE:
		RETVAL = GL_BLUE_BIAS;
	OUTPUT:
		RETVAL

double
GL_ALPHA_BIAS ()
	CODE:
		RETVAL = GL_ALPHA_BIAS;
	OUTPUT:
		RETVAL

double
GL_DEPTH_BIAS ()
	CODE:
		RETVAL = GL_DEPTH_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_RED_SCALE ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_RED_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_GREEN_SCALE ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_GREEN_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_BLUE_SCALE ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_BLUE_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_ALPHA_SCALE ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_ALPHA_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_RED_BIAS ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_RED_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_GREEN_BIAS ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_GREEN_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_BLUE_BIAS ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_BLUE_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_CONVOLUTION_ALPHA_BIAS ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_ALPHA_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_RED_SCALE ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_RED_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_GREEN_SCALE ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_GREEN_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_BLUE_SCALE ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_BLUE_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_ALPHA_SCALE ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_ALPHA_SCALE;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_RED_BIAS ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_RED_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_GREEN_BIAS ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_GREEN_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_BLUE_BIAS ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_BLUE_BIAS;
	OUTPUT:
		RETVAL

double
GL_POST_COLOR_MATRIX_ALPHA_BIAS ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_ALPHA_BIAS;
	OUTPUT:
		RETVAL


GLenum
GL_PIXEL_MAP_I_TO_I ()
	CODE:
		RETVAL = GL_PIXEL_MAP_I_TO_I;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_S_TO_S ()
	CODE:
		RETVAL = GL_PIXEL_MAP_S_TO_S;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_I_TO_R ()
	CODE:
		RETVAL = GL_PIXEL_MAP_I_TO_R;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_I_TO_G ()
	CODE:
		RETVAL = GL_PIXEL_MAP_I_TO_G;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_I_TO_B ()
	CODE:
		RETVAL = GL_PIXEL_MAP_I_TO_B;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_I_TO_A ()
	CODE:
		RETVAL = GL_PIXEL_MAP_I_TO_A;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_R_TO_R ()
	CODE:
		RETVAL = GL_PIXEL_MAP_R_TO_R;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_G_TO_G ()
	CODE:
		RETVAL = GL_PIXEL_MAP_G_TO_G;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_B_TO_B ()
	CODE:
		RETVAL = GL_PIXEL_MAP_B_TO_B;
	OUTPUT:
		RETVAL

GLenum
GL_PIXEL_MAP_A_TO_A ()
	CODE:
		RETVAL = GL_PIXEL_MAP_A_TO_A;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_1D ()
	CODE:
		RETVAL = GL_TEXTURE_1D;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_2D ()
	CODE:
		RETVAL = GL_TEXTURE_2D;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_3D ()
	CODE:
		RETVAL = GL_TEXTURE_3D;
	OUTPUT:
		RETVAL

GLenum
GL_PROXY_TEXTURE_2D ()
	CODE:
		RETVAL = GL_PROXY_TEXTURE_2D;
	OUTPUT:
		RETVAL


Sint32
GL_ALPHA4 ()
	CODE:
		RETVAL = GL_ALPHA4;
	OUTPUT:
		RETVAL

Sint32
GL_ALPHA8 ()
	CODE:
		RETVAL = GL_ALPHA8;
	OUTPUT:
		RETVAL

Sint32
GL_ALPHA12 ()
	CODE:
		RETVAL = GL_ALPHA12;
	OUTPUT:
		RETVAL

Sint32
GL_ALPHA16 ()
	CODE:
		RETVAL = GL_ALPHA16;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE4 ()
	CODE:
		RETVAL = GL_LUMINANCE4;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE8 ()
	CODE:
		RETVAL = GL_LUMINANCE8;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE12 ()
	CODE:
		RETVAL = GL_LUMINANCE12;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE16 ()
	CODE:
		RETVAL = GL_LUMINANCE16;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE4_ALPHA4 ()
	CODE:
		RETVAL = GL_LUMINANCE4_ALPHA4;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE6_ALPHA2 ()
	CODE:
		RETVAL = GL_LUMINANCE6_ALPHA2;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE8_ALPHA8 ()
	CODE:
		RETVAL = GL_LUMINANCE8_ALPHA8;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE12_ALPHA4 ()
	CODE:
		RETVAL = GL_LUMINANCE12_ALPHA4;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE12_ALPHA12 ()
	CODE:
		RETVAL = GL_LUMINANCE12_ALPHA12;
	OUTPUT:
		RETVAL

Sint32
GL_LUMINANCE16_ALPHA16 ()
	CODE:
		RETVAL = GL_LUMINANCE16_ALPHA16;
	OUTPUT:
		RETVAL

Sint32
GL_INTENSITY ()
	CODE:
		RETVAL = GL_INTENSITY;
	OUTPUT:
		RETVAL

Sint32
GL_INTENSITY4 ()
	CODE:
		RETVAL = GL_INTENSITY4;
	OUTPUT:
		RETVAL

Sint32
GL_INTENSITY8 ()
	CODE:
		RETVAL = GL_INTENSITY8;
	OUTPUT:
		RETVAL

Sint32
GL_INTENSITY12 ()
	CODE:
		RETVAL = GL_INTENSITY12;
	OUTPUT:
		RETVAL

Sint32
GL_INTENSITY16 ()
	CODE:
		RETVAL = GL_INTENSITY16;
	OUTPUT:
		RETVAL

Sint32
GL_R3_G3_B2 ()
	CODE:
		RETVAL = GL_R3_G3_B2;
	OUTPUT:
		RETVAL

Sint32
GL_RGB4 ()
	CODE:
		RETVAL = GL_RGB4;
	OUTPUT:
		RETVAL

Sint32
GL_RGB5 ()
	CODE:
		RETVAL = GL_RGB5;
	OUTPUT:
		RETVAL

Sint32
GL_RGB8 ()
	CODE:
		RETVAL = GL_RGB8;
	OUTPUT:
		RETVAL

Sint32
GL_RGB10 ()
	CODE:
		RETVAL = GL_RGB10;
	OUTPUT:
		RETVAL

Sint32
GL_RGB12 ()
	CODE:
		RETVAL = GL_RGB12;
	OUTPUT:
		RETVAL

Sint32
GL_RGB16 ()
	CODE:
		RETVAL = GL_RGB16;
	OUTPUT:
		RETVAL

Sint32
GL_RGBA2 ()
	CODE:
		RETVAL = GL_RGBA2;
	OUTPUT:
		RETVAL

Sint32
GL_RGBA4 ()
	CODE:
		RETVAL = GL_RGBA4;
	OUTPUT:
		RETVAL

Sint32
GL_RGB5_A1 ()
	CODE:
		RETVAL = GL_RGB5_A1;
	OUTPUT:
		RETVAL

Sint32
GL_RGBA8 ()
	CODE:
		RETVAL = GL_RGBA8;
	OUTPUT:
		RETVAL

Sint32
GL_RGB10_A2 ()
	CODE:
		RETVAL = GL_RGB10_A2;
	OUTPUT:
		RETVAL

Sint32
GL_RGBA12 ()
	CODE:
		RETVAL = GL_RGBA12;
	OUTPUT:
		RETVAL

Sint32
GL_RGBA16 ()
	CODE:
		RETVAL = GL_RGBA16;
	OUTPUT:
		RETVAL

GLenum
GL_MAX_TEXTURE_SIZE ()
	CODE:
		RETVAL = GL_MAX_TEXTURE_SIZE;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_BASE_LEVEL ()
	CODE:
		RETVAL = GL_TEXTURE_BASE_LEVEL;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_MAX_LEVEL ()
	CODE:
		RETVAL = GL_TEXTURE_MAX_LEVEL;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_MAX_LOD ()
	CODE:
		RETVAL = GL_TEXTURE_MAX_LOD;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_MIN_LOD ()
	CODE:
		RETVAL = GL_TEXTURE_MIN_LOD;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_ENV_MODE ()
	CODE:
		RETVAL = GL_TEXTURE_ENV_MODE;
	OUTPUT:
		RETVAL
	
GLenum
GL_TEXTURE_ENV_COLOR ()
	CODE:
		RETVAL = GL_TEXTURE_ENV_COLOR;
	OUTPUT:
		RETVAL
	
Sint32
GL_DECAL()
	CODE:
		RETVAL = GL_DECAL;
	OUTPUT:
		RETVAL
	
Sint32
GL_REPLACE()
	CODE:
		RETVAL = GL_REPLACE;
	OUTPUT:
		RETVAL
	
Sint32
GL_MODULATE()
	CODE:
		RETVAL = GL_MODULATE;
	OUTPUT:
		RETVAL
	
Sint32
GL_BLEND()
	CODE:
		RETVAL = GL_BLEND;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_WRAP_S ()
	CODE:
		RETVAL = GL_TEXTURE_WRAP_S;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_WRAP_T ()
	CODE:
		RETVAL = GL_TEXTURE_WRAP_T;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_WRAP_R ()
	CODE:
		RETVAL = GL_TEXTURE_WRAP_R;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_MAG_FILTER ()
	CODE:
		RETVAL = GL_TEXTURE_MAG_FILTER;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_MIN_FILTER ()
	CODE:
		RETVAL = GL_TEXTURE_MIN_FILTER;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_BORDER_COLOR ()
	CODE:
		RETVAL = GL_TEXTURE_BORDER_COLOR;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_PRIORITY ()
	CODE:
		RETVAL = GL_TEXTURE_PRIORITY;
	OUTPUT:
		RETVAL

Sint32
GL_CLAMP ()
	CODE:
		RETVAL = GL_CLAMP;
	OUTPUT:
		RETVAL

Sint32
GL_CLAMP_TO_EDGE ()
	CODE:
		RETVAL = GL_CLAMP_TO_EDGE;
	OUTPUT:
		RETVAL

Sint32
GL_REPEAT ()
	CODE:
		RETVAL = GL_REPEAT;
	OUTPUT:
		RETVAL

Sint32
GL_NEAREST ()
	CODE:
		RETVAL = GL_NEAREST;
	OUTPUT:
		RETVAL

Sint32
GL_NEAREST_MIPMAP_NEAREST ()
	CODE:
		RETVAL = GL_NEAREST_MIPMAP_NEAREST;
	OUTPUT:
		RETVAL

Sint32
GL_NEAREST_MIPMAP_LINEAR ()
	CODE:
		RETVAL = GL_NEAREST_MIPMAP_LINEAR;
	OUTPUT:
		RETVAL

Sint32
GL_LINEAR_MIPMAP_NEAREST ()
	CODE:
		RETVAL = GL_LINEAR_MIPMAP_NEAREST;
	OUTPUT:
		RETVAL

Sint32
GL_LINEAR_MIPMAP_LINEAR ()
	CODE:
		RETVAL = GL_LINEAR_MIPMAP_LINEAR;
	OUTPUT:
		RETVAL

GLenum
GL_S ()
	CODE:
		RETVAL = GL_S;
	OUTPUT:
		RETVAL

GLenum
GL_T ()
	CODE:
		RETVAL = GL_T;
	OUTPUT:
		RETVAL

GLenum
GL_R ()
	CODE:
		RETVAL = GL_R;
	OUTPUT:
		RETVAL

GLenum
GL_Q ()
	CODE:
		RETVAL = GL_Q;
	OUTPUT:
		RETVAL

GLenum
GL_TEXTURE_GEN_MODE ()
	CODE:
		RETVAL = GL_TEXTURE_GEN_MODE;
	OUTPUT:
		RETVAL

GLenum
GL_OBJECT_PLANE ()
	CODE:
		RETVAL = GL_OBJECT_PLANE;
	OUTPUT:
		RETVAL

GLenum
GL_EYE_PLANE ()
	CODE:
		RETVAL = GL_EYE_PLANE;
	OUTPUT:
		RETVAL

Sint32
GL_EYE_LINEAR ()
	CODE:
		RETVAL = GL_EYE_LINEAR;
	OUTPUT:
		RETVAL

Sint32
GL_OBJECT_LINEAR ()
	CODE:
		RETVAL = GL_OBJECT_LINEAR;
	OUTPUT:
		RETVAL

Sint32
GL_SPHERE_MAP ()
	CODE:
		RETVAL = GL_SPHERE_MAP;
	OUTPUT:
		RETVAL

GLenum
GL_LEFT ()
	CODE:
		RETVAL = GL_LEFT;
	OUTPUT:
		RETVAL

GLenum
GL_RIGHT ()
	CODE:
		RETVAL = GL_RIGHT;
	OUTPUT:
		RETVAL

GLenum
GL_FRONT_LEFT ()
	CODE:
		RETVAL = GL_FRONT_LEFT;
	OUTPUT:
		RETVAL

GLenum
GL_FRONT_RIGHT ()
	CODE:
		RETVAL = GL_FRONT_RIGHT;
	OUTPUT:
		RETVAL

GLenum
GL_BACK_LEFT ()
	CODE:
		RETVAL = GL_BACK_LEFT;
	OUTPUT:
		RETVAL

GLenum
GL_BACK_RIGHT ()
	CODE:
		RETVAL = GL_BACK_RIGHT;
	OUTPUT:
		RETVAL

GLenum
GL_NONE ()
	CODE:
		RETVAL = GL_NONE;
	OUTPUT:
		RETVAL

GLenum
GL_SCISSOR_TEST ()
	CODE:
		RETVAL = GL_SCISSOR_TEST;
	OUTPUT:
		RETVAL

GLenum
GL_NEVER ()
	CODE:
		RETVAL = GL_NEVER;
	OUTPUT:
		RETVAL

GLenum
GL_ALWAYS ()
	CODE:
		RETVAL = GL_ALWAYS;
	OUTPUT:
		RETVAL

GLenum
GL_LESS ()
	CODE:
		RETVAL = GL_LESS;
	OUTPUT:
		RETVAL

GLenum
GL_LEQUAL ()
	CODE:
		RETVAL = GL_LEQUAL;
	OUTPUT:
		RETVAL

GLenum
GL_EQUAL ()
	CODE:
		RETVAL = GL_EQUAL;
	OUTPUT:
		RETVAL

GLenum
GL_GEQUAL ()
	CODE:
		RETVAL = GL_GEQUAL;
	OUTPUT:
		RETVAL

GLenum
GL_GREATER ()
	CODE:
		RETVAL = GL_GREATER;
	OUTPUT:
		RETVAL

GLenum
GL_NOTEQUAL ()
	CODE:
		RETVAL = GL_NOTEQUAL;
	OUTPUT:
		RETVAL


GLenum
GL_KEEP ()
	CODE:
		RETVAL = GL_KEEP;
	OUTPUT:
		RETVAL

GLenum
GL_INCR ()
	CODE:
		RETVAL = GL_INCR;
	OUTPUT:
		RETVAL

GLenum
GL_DECR ()
	CODE:
		RETVAL = GL_DECR;
	OUTPUT:
		RETVAL

GLenum
GL_INVERT ()
	CODE:
		RETVAL = GL_INVERT;
	OUTPUT:
		RETVAL


GLenum
GL_CLEAR ()
	CODE:
		RETVAL = GL_CLEAR;
	OUTPUT:
		RETVAL

GLenum
GL_COPY ()
	CODE:
		RETVAL = GL_COPY;
	OUTPUT:
		RETVAL

GLenum
GL_NOOP ()
	CODE:
		RETVAL = GL_NOOP;
	OUTPUT:
		RETVAL

GLenum
GL_SET ()
	CODE:
		RETVAL = GL_SET;
	OUTPUT:
		RETVAL

GLenum
GL_COPY_INVERTED ()
	CODE:
		RETVAL = GL_COPY_INVERTED;
	OUTPUT:
		RETVAL

GLenum
GL_AND_REVERSE ()
	CODE:
		RETVAL = GL_AND_REVERSE;
	OUTPUT:
		RETVAL

GLenum
GL_OR_REVERSE ()
	CODE:
		RETVAL = GL_OR_REVERSE;
	OUTPUT:
		RETVAL

GLenum
GL_AND ()
	CODE:
		RETVAL = GL_AND;
	OUTPUT:
		RETVAL

GLenum
GL_OR ()
	CODE:
		RETVAL = GL_OR;
	OUTPUT:
		RETVAL

GLenum
GL_NAND ()
	CODE:
		RETVAL = GL_NAND;
	OUTPUT:
		RETVAL

GLenum
GL_NOR ()
	CODE:
		RETVAL = GL_NOR;
	OUTPUT:
		RETVAL

GLenum
GL_XOR ()
	CODE:
		RETVAL = GL_XOR;
	OUTPUT:
		RETVAL

GLenum
GL_EQUIV ()
	CODE:
		RETVAL = GL_EQUIV;
	OUTPUT:
		RETVAL

GLenum
GL_AND_INVERTED ()
	CODE:
		RETVAL = GL_AND_INVERTED;
	OUTPUT:
		RETVAL

GLenum
GL_OR_INVERTED ()
	CODE:
		RETVAL = GL_OR_INVERTED;
	OUTPUT:
		RETVAL


GLenum
GL_LOAD ()
	CODE:
		RETVAL = GL_LOAD;
	OUTPUT:
		RETVAL

GLenum
GL_RETURN ()
	CODE:
		RETVAL = GL_RETURN;
	OUTPUT:
		RETVAL

GLenum
GL_ADD ()
	CODE:
		RETVAL = GL_ADD;
	OUTPUT:
		RETVAL

GLenum
GL_MULT ()
	CODE:
		RETVAL = GL_MULT;
	OUTPUT:
		RETVAL

GLenum
GL_ACCUM ()
	CODE:
		RETVAL = GL_ACCUM;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_VERTEX_3 ()
	CODE:
		RETVAL = GL_MAP1_VERTEX_3;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_VERTEX_4 ()
	CODE:
		RETVAL = GL_MAP1_VERTEX_4;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_INDEX ()
	CODE:
		RETVAL = GL_MAP1_INDEX;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_COLOR_4 ()
	CODE:
		RETVAL = GL_MAP1_COLOR_4;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_NORMAL ()
	CODE:
		RETVAL = GL_MAP1_NORMAL;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_TEXTURE_COORD_1 ()
	CODE:
		RETVAL = GL_MAP1_TEXTURE_COORD_1;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_TEXTURE_COORD_2 ()
	CODE:
		RETVAL = GL_MAP1_TEXTURE_COORD_2;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_TEXTURE_COORD_3 ()
	CODE:
		RETVAL = GL_MAP1_TEXTURE_COORD_3;
	OUTPUT:
		RETVAL

GLenum
GL_MAP1_TEXTURE_COORD_4 ()
	CODE:
		RETVAL = GL_MAP1_TEXTURE_COORD_4;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_VERTEX_3 ()
	CODE:
		RETVAL = GL_MAP2_VERTEX_3;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_VERTEX_4 ()
	CODE:
		RETVAL = GL_MAP2_VERTEX_4;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_INDEX ()
	CODE:
		RETVAL = GL_MAP2_INDEX;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_COLOR_4 ()
	CODE:
		RETVAL = GL_MAP2_COLOR_4;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_NORMAL ()
	CODE:
		RETVAL = GL_MAP2_NORMAL;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_TEXTURE_COORD_1 ()
	CODE:
		RETVAL = GL_MAP2_TEXTURE_COORD_1;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_TEXTURE_COORD_2 ()
	CODE:
		RETVAL = GL_MAP2_TEXTURE_COORD_2;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_TEXTURE_COORD_3 ()
	CODE:
		RETVAL = GL_MAP2_TEXTURE_COORD_3;
	OUTPUT:
		RETVAL

GLenum
GL_MAP2_TEXTURE_COORD_4 ()
	CODE:
		RETVAL = GL_MAP2_TEXTURE_COORD_4;
	OUTPUT:
		RETVAL

GLenum
GL_AUTO_NORMAL ()
	CODE:
		RETVAL = GL_AUTO_NORMAL;
	OUTPUT:
		RETVAL

GLenum
GL_LIGHTING ()
	CODE:
		RETVAL = GL_LIGHTING;
	OUTPUT:
		RETVAL

GLenum
GL_DEPTH_TEST ()
	CODE:
		RETVAL = GL_DEPTH_TEST;
	OUTPUT:
		RETVAL

GLenum
GL_COLOR_TABLE ()
	CODE:
		RETVAL = GL_COLOR_TABLE;
	OUTPUT:
		RETVAL

GLenum
GL_POST_CONVOLUTION_COLOR_TABLE ()
	CODE:
		RETVAL = GL_POST_CONVOLUTION_COLOR_TABLE;
	OUTPUT:
		RETVAL

GLenum
GL_POST_COLOR_MATRIX_COLOR_TABLE ()
	CODE:
		RETVAL = GL_POST_COLOR_MATRIX_COLOR_TABLE;
	OUTPUT:
		RETVAL

GLenum
GL_PROXY_COLOR_TABLE ()
	CODE:
		RETVAL = GL_PROXY_COLOR_TABLE;
	OUTPUT:
		RETVAL

GLenum
GL_PROXY_POST_CONVOLUTION_COLOR_TABLE ()
	CODE:
		RETVAL = GL_PROXY_POST_CONVOLUTION_COLOR_TABLE;
	OUTPUT:
		RETVAL

GLenum
GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE ()
	CODE:
		RETVAL = GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE;
	OUTPUT:
		RETVAL

GLenum
GL_CONVOLUTION_1D ()
	CODE:
		RETVAL = GL_CONVOLUTION_1D;
	OUTPUT:
		RETVAL

GLenum
GL_CONVOLUTION_2D ()
	CODE:
		RETVAL = GL_CONVOLUTION_2D;
	OUTPUT:
		RETVAL

GLenum
GL_SEPARABLE_2D ()
	CODE:
		RETVAL = GL_SEPARABLE_2D;
	OUTPUT:
		RETVAL

GLenum
GL_CONVOLUTION_BORDER_MODE ()
	CODE:
		RETVAL = GL_CONVOLUTION_BORDER_MODE;
	OUTPUT:
		RETVAL

GLenum
GL_CONVOLUTION_FILTER_SCALE ()
	CODE:
		RETVAL = GL_CONVOLUTION_FILTER_SCALE;
	OUTPUT:
		RETVAL

GLenum
GL_CONVOLUTION_FILTER_BIAS ()
	CODE:
		RETVAL = GL_CONVOLUTION_FILTER_BIAS;
	OUTPUT:
		RETVAL

GLenum
GL_REDUCE ()
	CODE:
		RETVAL = GL_REDUCE;
	OUTPUT:
		RETVAL

GLenum
GL_CONSTANT_BORDER ()
	CODE:
		RETVAL = GL_CONSTANT_BORDER;
	OUTPUT:
		RETVAL

GLenum
GL_REPLICATE_BORDER ()
	CODE:
		RETVAL = GL_REPLICATE_BORDER;
	OUTPUT:
		RETVAL

GLenum 
GL_HISTOGRAM ()
	CODE:
		RETVAL = GL_HISTOGRAM;
	OUTPUT:
		RETVAL

GLenum
GL_PROXY_HISTOGRAM ()
	CODE:
		RETVAL = GL_PROXY_HISTOGRAM;
	OUTPUT:
		RETVAL

GLenum
GL_MINMAX ()
	CODE:
		RETVAL = GL_MINMAX;
	OUTPUT:
		RETVAL

GLenum
GL_MIN ()
	CODE:
		RETVAL = GL_MIN;
	OUTPUT:
		RETVAL

GLenum
GL_MAX ()
	CODE:
		RETVAL = GL_MAX;
	OUTPUT:
		RETVAL

GLenum
GL_FUNC_ADD ()
	CODE:
		RETVAL = GL_FUNC_ADD;
	OUTPUT:
		RETVAL

GLenum
GL_FUNC_SUBTRACT ()
	CODE:
		RETVAL = GL_FUNC_SUBTRACT;
	OUTPUT:
		RETVAL

GLenum
GL_FUNC_REVERSE_SUBTRACT ()
	CODE:
		RETVAL = GL_FUNC_REVERSE_SUBTRACT;
	OUTPUT:
		RETVAL

GLenum
GL_COLOR_TABLE_SCALE ()
	CODE:
		RETVAL = GL_COLOR_TABLE_SCALE;
	OUTPUT:
		RETVAL

GLenum
GL_COLOR_TABLE_BAIS ()
	CODE:
		RETVAL = GL_COLOR_TABLE_BIAS;
	OUTPUT:
		RETVAL

GLenum
GL_READ_BUFFER ()
	CODE:
		RETVAL = GL_READ_BUFFER;
	OUTPUT:
		RETVAL

#endif

#ifdef HAVE_GLU

GLenum
GLU_DISPLAY_MODE ()
	CODE:
		RETVAL = GLU_DISPLAY_MODE;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_MODE ()
	CODE:
		RETVAL = GLU_NURBS_MODE;
	OUTPUT:
		RETVAL

GLenum
GLU_CULLING ()
	CODE:
		RETVAL = GLU_CULLING;
	OUTPUT:
		RETVAL

GLenum
GLU_SAMPLING_METHOD ()
	CODE:
		RETVAL = GLU_SAMPLING_METHOD;
	OUTPUT:
		RETVAL

GLenum
GLU_SAMPLING_TOLERANCE ()
	CODE:
		RETVAL = GLU_SAMPLING_TOLERANCE;
	OUTPUT:
		RETVAL

GLenum
GLU_PARAMETRIC_TOLERANCE ()
	CODE:
		RETVAL = GLU_PARAMETRIC_TOLERANCE;
	OUTPUT:
		RETVAL

GLenum
GLU_U_STEP ()
	CODE:
		RETVAL = GLU_U_STEP;
	OUTPUT:
		RETVAL

GLenum
GLU_V_STEP ()
	CODE:
		RETVAL = GLU_V_STEP;
	OUTPUT:
		RETVAL

GLenum
GLU_AUTO_LOAD_MATRIX ()
	CODE:
		RETVAL = GLU_AUTO_LOAD_MATRIX;
	OUTPUT:
		RETVAL

double
GLU_FILL ()
	CODE:
		RETVAL = GLU_FILL;
	OUTPUT:
		RETVAL

double
GLU_OUTLINE_POLYGON ()
	CODE:
		RETVAL = GLU_OUTLINE_POLYGON;
	OUTPUT:
		RETVAL

double
GLU_OUTLINE_PATCH ()
	CODE:
		RETVAL = GLU_OUTLINE_PATCH;
	OUTPUT:
		RETVAL

double
GLU_NURBS_RENDERER ()
	CODE:
		RETVAL = GLU_NURBS_RENDERER;
	OUTPUT:
		RETVAL

double
GLU_NURBS_TESSELLATOR ()
	CODE:
		RETVAL = GLU_NURBS_TESSELLATOR;
	OUTPUT:
		RETVAL

double
GLU_PATH_LENGTH ()
	CODE:
		RETVAL = GLU_PATH_LENGTH;
	OUTPUT:
		RETVAL

double
GLU_DOMAIN_DISTANCE ()
	CODE:
		RETVAL = GLU_DOMAIN_DISTANCE;
	OUTPUT:
		RETVAL

double
GLU_OBJECT_PATH_LENGTH ()
	CODE:
		RETVAL = GLU_OBJECT_PATH_LENGTH;
	OUTPUT:
		RETVAL

double
GLU_OBJECT_PARAMETRIC_ERROR ()
	CODE:
		RETVAL = GLU_OBJECT_PARAMETRIC_ERROR;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_ERROR ()
	CODE:
		RETVAL = GLU_NURBS_ERROR;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_BEGIN ()
	CODE:
		RETVAL = GLU_NURBS_BEGIN;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_BEGIN_DATA ()
	CODE:
		RETVAL = GLU_NURBS_BEGIN_DATA;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_TEXTURE_COORD ()
	CODE:
		RETVAL = GLU_NURBS_TEXTURE_COORD;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_TEXTURE_COORD_DATA ()
	CODE:
		RETVAL = GLU_NURBS_TEXTURE_COORD_DATA;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_COLOR ()
	CODE:
		RETVAL = GLU_NURBS_COLOR;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_COLOR_DATA ()
	CODE:
		RETVAL = GLU_NURBS_COLOR_DATA;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_NORMAL ()
	CODE:
		RETVAL = GLU_NURBS_NORMAL;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_NORMAL_DATA ()
	CODE:
		RETVAL = GLU_NURBS_NORMAL_DATA;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_VERTEX ()
	CODE:
		RETVAL = GLU_NURBS_VERTEX;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_VERTEX_DATA ()
	CODE:
		RETVAL = GLU_NURBS_VERTEX_DATA;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_END ()
	CODE:
		RETVAL = GLU_NURBS_END;
	OUTPUT:
		RETVAL

GLenum
GLU_NURBS_END_DATA ()
	CODE:
		RETVAL = GLU_NURBS_END_DATA;
	OUTPUT:
		RETVAL

GLenum
GLU_MAP1_TRIM_2 ()
	CODE:
		RETVAL = GLU_MAP1_TRIM_2;
	OUTPUT:
		RETVAL

GLenum
GLU_MAP1_TRIM_3 ()
	CODE:
		RETVAL = GLU_MAP1_TRIM_3;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_BOUNDARY_ONLY ()
	CODE:
		RETVAL = GLU_TESS_BOUNDARY_ONLY;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_TOLERANCE ()
	CODE:
		RETVAL = GLU_TESS_TOLERANCE;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_WINDING_RULE ()
	CODE:
		RETVAL = GLU_TESS_WINDING_RULE;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_WINDING_ODD ()
	CODE:
		RETVAL = GLU_TESS_WINDING_ODD;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_WINDING_NONZERO ()
	CODE:
		RETVAL = GLU_TESS_WINDING_NONZERO;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_WINDING_POSITIVE ()
	CODE:
		RETVAL = GLU_TESS_WINDING_POSITIVE;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_WINDING_NEGATIVE ()
	CODE:
		RETVAL = GLU_TESS_WINDING_NEGATIVE;
	OUTPUT:
		RETVAL

GLenum
GLU_TESS_WINDING_ABS_GEQ_TWO ()
	CODE:
		RETVAL = GLU_TESS_WINDING_ABS_GEQ_TWO;
	OUTPUT:
		RETVAL

#endif
