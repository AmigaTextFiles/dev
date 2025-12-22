/*
// Permission to use, copy, modify, and distribute this software and its
// documentation for any purpose and without fee is hereby granted, provided
// that the above copyright notice appear in all copies and that both that
// copyright notice and this permission notice appear in supporting
// documentation, and that the name of I.B.M. not be used in advertising
// or publicity pertaining to distribution of the software without specific,
// written prior permission. I.B.M. makes no representations about the
// suitability of this software for any purpose.  It is provided "as is"
// without express or implied warranty.
//
// I.B.M. DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL I.B.M.
// BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
// OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
// CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//
// Author:  Barry Minor, IBM AWS Graphics Systems (Austin)
//          minor@austin.ibm.com
//
// Special Thanks to ..
//
//          John Dennis      of DEC
//          Bob Arenburg     of IBM
//          Rob Putney       of IBM
//          Dale Kirkland    of Intergraph
//          Hock Lee         of Microsoft
//          Tom McReynolds   of SGI
//          John Spitzer     of SGI
//
// and the OPC committee
// for their help in completing this project
*/

/* Begin Windowing System Dependent */
#ifdef WIN32
#include <stdio.h>
#include <float.h>
#include <windows.h>
#define fprintf print_log
int print_log (FILE *fo, const char *format, ...);
#elif !defined(OS2) && !defined(__amigaos__)
#include <X11/Xlib.h>
#include <GL/glx.h>
#endif
/* End Windowing System Dependent */

void startclock (void);
float stopclock (void);
float roundit (float);
char *error2str(GLenum);
#if defined(WIN32)
void APIENTRY FinishFrame(HDC);
#elif defined(OS2) || defined(__amigaos__)
void FinishFrame(void);
#else
void FinishFrame(Display*, GLXDrawable);
#endif

#define         VERSION         "5.1"
#define 	SCREENX 	1280.0
#define 	SCREENY 	1024.0
#define         X_WINDOW_SIZE   700
#define         Y_WINDOW_SIZE   700
#define         MIN_TEST_TIME   10.0

#define         MAXVERTS        40000
#define         MAXPOLYSIDES    100
#define         PI              3.14159265359
#if defined (WIN32) || defined (__hpux) || defined(__amigaos__)
#define         SMALL           FLT_MIN
#define         BIG             FLT_MAX
#else
#define         SMALL           -HUGE
#define         BIG             HUGE 
#endif
#define         ZMIN            0x0
#define         ZMAX            0x7fffff
#define         ZTRANS_SCALE    3.0

#define OUTPUT_LEADER "    "
#define OUTPUT_NAME_WIDTH (-51)

#undef	MAX
#define MAX(a,b)        ((a)>(b)?(a):(b))  /* return greater of a and b */
#undef	MIN
#define MIN(a,b)        ((a)<(b)?(a):(b))  /* return lesser of a and b */

#define ARG_INC  { argv++; argc--; }

#define FATAL_ERROR(s)                                                        \
{                                                                             \
  fprintf (stderr, s);                                                        \
  fflush (stderr);                                                            \
  exit (-1);                                                                  \
}

#define NOINPUT         0
#define POLYGONINPUT    1
#define MESHINPUT       2
#define TRIINPUT        3
#define QUADINPUT       4

#define TMESHmode           0
#define VECTORmode          1
#define LINEmode            2
#define POINTmode           3
#define POLYGONmode         4
#define TFANmode            5
#define TRImode             6
#define QUADmode            7

#define BM_NO_BATCH           0
#define BM_BATCH_ALL          1
#define BM_BATCH_BY_TWO       2
#define BM_EXTERNAL             3
#define BM_EXTERNAL_BY_TWO      4

#define	NO_NORMmode		0
#define	FACET_NORMmode		1
#define	VERTEX_NORMmode		2

#define COLOR_PER_FRAME		0
#define COLOR_PER_PRIMITIVE	1
#define COLOR_PER_VERTEX	2

#define VP_TRUE		1
#define VP_FALSE	0 

#define TXG_NO_TEX_GEN 0
#define TXG_EYE_LINEAR 1
#define TXG_OBJECT_LINEAR 2
#define TXG_SPHERE_MAP 3

#define COLOR3mode	0
#define COLOR4mode	1

#define         XPIX    1280
#define         YPIX    1024
#define         NUMPIX  XPIX*YPIX

struct plygon
{
        int     numverts;
        int     *index;
};

struct vector
{
        GLfloat   x;
        GLfloat   y;
        GLfloat   z;
};

struct colorvector
{
        GLfloat   r;
        GLfloat   g;
        GLfloat   b;
        GLfloat   a;
};

struct mesh
{
        int             	numverts;
        struct vector   	*verts;
        struct vector   	*norms;
        struct vector   	*texture;
        struct colorvector 	*vcolor;
};

struct ThreadBlock {
	int			np;
	GLenum			mode;
	GLenum			capability;
#ifdef WIN32
        void (APIENTRY           *ColorP)(const GLfloat *);
#else
        void                    (*ColorP)(const GLfloat *);
#endif
	void			(*externfunc)(GLenum);
        struct vector   	*vert;
        struct vector   	*vnorm;
        struct vector   	*texture;
        struct colorvector   	*vcolor;
	int			batchgroups;
	int			batchnum;
	int			batchleftovers;
        struct plygon 		*ply;
        struct mesh 		*msh;
#ifdef WIN32
	HDC			dc;
	HGLRC			rc;
	DWORD			threadId;
	HANDLE			threadHandle;
	HANDLE			startEvent;
	HANDLE			doneEvent;
#endif
};

struct RenderBlock {
        int     		np;
        int     		numverts;
	GLenum			mode;
	GLenum			capability;
#ifdef WIN32
        void (APIENTRY           *ColorP)(const GLfloat *);
#else
        void                    (*ColorP)(const GLfloat *);
#endif
	void			(*externfunc)(GLenum);
        struct vector   	*vert;
        struct vector   	*vnorm;
        struct vector   	*texture;
        struct colorvector   	*vcolor;
        struct plygon 		*ply;
        struct mesh 		*msh;
};

struct EventBlock {
	float			minperiod;
	int			numframes;
	int			doubleBuffer;
	int			clip;
	int			zbuffer;
        int                     walkthruFrame;
	struct vector           *jitter;    /* jitter and redraws are for use with FS antialiasing */
	int                     redraws;
	GLfloat                 blur_frames;
	GLfloat			**walkthru;
	char			*teststring;
	GLfloat			trans[4];
	GLfloat			center[3];
/* Begin Windowing System Dependent */
#ifdef WIN32
        HWND                    window;
        HDC                     display;
#elif !defined(OS2) && !defined(__amigaos__)
	Window			window;
	Display			*display;
#endif
/* End Windowing System Dependent */
	void			(*func)(struct ThreadBlock *);
	struct RenderBlock	*rb;
	int			threads;
	struct ThreadBlock	*tb;
};


#ifdef LITTLE_ENDIAN
typedef union {
    struct {
        unsigned int Texture:1;        /* 0=OFF 1=ON */
        unsigned int Color:2;          /* 0=FRAME 1=PRIMITIVE 2=VERTEX */
        unsigned int Normal:2;         /* 0=OFF 1=FACET 2=VERTEX */
        unsigned int RenderMode:3;     /* 0=NO_BATCH 1=BATCH_ALL 2=BATCH_BY_TWO */
                                       /* 3=EXTERNAL 4=EXTERNAL_BY_TWO - no batching */

#ifdef FUNCTION_CALLS
        unsigned int ColorVectorLength:1; /* 0=glColor3fv   1=glColor4fv  */
#endif
	unsigned int BlurMode:1;       /* 0 = no motion blur.  1= motion blur */
	unsigned int FSAA:1;           /* 0 = no full scene antialiasing, 1 = some */
#ifdef FUNCTION_CALLS
        unsigned int Pad:21;           /* pad bits to fill word */
#else
        unsigned int Pad:22;           /* pad bits to fill word */
#endif
    } bits;
    unsigned int word;
} RenderIndex;

typedef union {
    struct {
        unsigned int DisplayList:1;    /* 0=OFF 1=ON */
	unsigned int BlurMode:1;       /* 0=OFF 1=ON */
	unsigned int FSAA:1;           /* Full scene antialiasing on/off */
	unsigned int Walkthru:1;       /* Walkthru mode */
        unsigned int Pad:28;           /* pad bits to fill word */
    } bits;
    unsigned int word;
} EventLoopIndex;
#else
typedef union {
    struct {
#ifdef FUNCTION_CALLS
        unsigned int Pad:21;           /* pad bits to fill word */
#else
        unsigned int Pad:22;           /* pad bits to fill word */
#endif
	unsigned int FSAA:1;           /* Full scene antialiasing */
	unsigned int BlurMode:1;       /* 0 = no motion blur, 1 = mb */
#ifdef FUNCTION_CALLS
        unsigned int ColorVectorLength:1; /* 0=glColor3fv   1=glColor4fv  */
#endif
        unsigned int RenderMode:3;     /* 0=NO_BATCH 1=BATCH_ALL 2=BATCH_BY_TWO */
                                       /* 3=EXTERNAL 4=EXTERNAL_BY_TWO - no batching */
        unsigned int Normal:2;         /* 0=OFF 1=FACET 2=VERTEX */
        unsigned int Color:2;          /* 0=FRAME 1=PRIMITIVE 2=VERTEX */
        unsigned int Texture:1;        /* 0=OFF 1=ON */
    } bits;
    unsigned int word;
} RenderIndex;

typedef union {
    struct {
        unsigned int Pad:28;           /* pad bits to fill word */
	unsigned int Walkthru:1;       /* Walkthru mode */
	unsigned int FSAA:1;           /* Full scene antialiasing */
	unsigned int BlurMode:1;       /* motion blur */
        unsigned int DisplayList:1;    /* 0=OFF 1=ON */
    } bits;
    unsigned int word;
} EventLoopIndex;

#endif
