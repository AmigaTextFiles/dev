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

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#ifdef CRAY
#include <rpc/types.h>
#include <rpc/xdr.h>
#endif
#if defined(OS2) || defined(WIN32)
#include <stdarg.h>
#else
#include <unistd.h>
#endif
#include <math.h>
#include <stdlib.h>
#ifdef WIN32
#include <windows.h>
#endif
#include <GL/gl.h>
#if defined(WIN32) || defined(__amigaos__)
#include <GL/glaux.h>
#else
#include "aux.h"
#endif
#include "viewperf.h"
#include "bfont.h"
#include "vpProtos.h"
#include "plyJT.h"
#include "mshJT.h"
#include "triJT.h"
#include "qadJT.h"
#include "evtJT.h"
#include "Env.h"

#ifdef WIN32
static FILE *LogFile;
#endif

#if defined(WIN32) || defined(OS2)
#define BINARY_FILE "rb"
#else
#define BINARY_FILE "r"
#endif

#ifdef __hpux
#include "limits.h"
#endif

#ifdef MP
int numProcessors ();
#endif

/* Function Pointers */
void    (*eventloop)(int thread);
void fill_mesh(struct mesh *msh, FILE *f,
GLenum swapFlag, float *min, float *max);
void read_colors(struct colorvector * vcolor, FILE *f);
void calculate_colors(struct colorvector * vcolor, struct vector * verts,
GLfloat * trans, GLfloat maxmag, GLfloat minmag);
void compare_min_max(struct vector * verts, GLfloat * trans, 
GLfloat *minmag, GLfloat *maxmag);
void compute_bounds(GLfloat *center, GLfloat *trans, 
GLfloat *min, GLfloat *max);
void get_colors_msh(struct mesh *msh, int np, 
GLfloat *trans, char *objnameptr);
void get_colors_ply(struct vector *vert, struct colorvector *vcolor, 
int numverts, GLfloat *trans, char *objnameptr);
void get_colors_triquad(struct vector *vert, struct colorvector *vcolor, 
int numverts, GLfloat *trans, char *objnameptr);


/* Global Variables */
struct    EventBlock eventblock;
GLfloat iang=0.0, jang=0.0, kang=0.0;

char    rendermodetext[][16] = {
    "TMESH",
    "VECTOR",
    "LINE",
    "POINT",
    "POLYGON",
    "TFAN",
    "TRIANGLE",
    "QUAD"
};


int    BatchTable[] = {
    BM_NO_BATCH,         /* TMESHmode   */
    BM_BATCH_BY_TWO,     /* VECTORmode  */
    BM_NO_BATCH,         /* LINEmode    */
    BM_BATCH_ALL,         /* POINTmode   */
    BM_NO_BATCH,         /* POLYGONmode */
    BM_NO_BATCH,         /* TFANmode    */
    BM_BATCH_ALL,         /* TRImode     */
    BM_BATCH_ALL         /* QUADmode    */
};


/*********************************************************************/
/*                                                                   */
/*                   text strings for reporting                      */
/*                                                                   */
/*********************************************************************/

char    txfile[100] = "NONE";
char    txmin[30]   = "NEAREST";
char    txmag[30]   = "NEAREST";
char    txenv[30]   = "DECAL";

char    txsblendfunc[40]   = "SRC_ALPHA";
char    txdblendfunc[40]   = "ONE_MINUS_SRC_ALPHA";

char    txtoggle[40] = "NONE";

char    txcriteria[10] = "MINIMUM";

char    txpmf[10]   = "FILL";
char    txpmb[10]   = "FILL";

char    txcolormode[30]   = "COLOR_PER_FRAME";

char    teststring[][32] = {
    "FRAME",
    "PRIMITIVE",
    "VERTEX"
};


char    extension[][8] = {
    ".coo",
    ".ele",
    ".vnm",
    ".clr",
    ".msh",
    ".bin",
    ".wlk"
};


char    falsetrue[][8] = {
    "FALSE",
    "TRUE"
};

char     texture_generation_mode[][32] = {
    "NO_TEXTURE_GENERATION",
    "EYE_LINEAR",
    "OBJECT_LINEAR",
    "SPHERE_MAP"
};

char cmfaceString[64] = "FRONT";
char cmmodeString[64] = "AMBIENT_AND_DIFFUSE";

static char cmdln[400];
static char desc[400];

/* text for test description */
static char *bf[]    = {
    ""       , "-bf "  };
static char *ff[]    = {
    ""       , "-ff "  };
static char *ls[]    = {
    ""       , "-ls "  };
static char *fn[]    = {
    ""       , "-fn "  };
static char *dl[]    = {
    ""       , "-dl "  };
static char *shade[] = {
    ""       , "-f "   };
static char *dr[]    = {
    "-ir "   , ""      };
static char *vac[]   = {
    ""       , "-vac " };
static char *val[]   = {
    ""       , "-val " };
static char *vz[]    = {
    ""       , "-vz "  };
static char *vst[]   = {
    ""       , "-vst " };
static char *db[]    = {
    "-sb "   , ""      };
static char *or[]    = {
    ""       , "-or "  };
static char *di[]    = {
    "-ndi"       , ""  };
static char *bl[]    = {
    ""       , "-bl "  };
static char *zb[]    = {
    ""       , "-zb "  };
static char *lp[]    = {
    ""       , "-lp "  };
static char *pp[]    = {
    ""       , "-pp "  };
static char *fg[]    = {
    ""       , "-fg "  };
static char *clip[]  = {
    ""       , "-c "   };
static char *l2s[]   = {
    ""       , "-l2s " };
static char *lv[]    = {
    ""       , "-lv "  };
static char *ll[]    = {
    ""       , "-ll "  };
static char *ps[]    = {
    ""       , "-ps "  };
static char *cptx[] = {
    "FRAME ", "PRIMITIVE ", "VERTEX "};
static char *inputmodetx[] = {
    "", "-pg ", "-mh ", "-tr ", "-qd "};


static unsigned int    stipple[32] = {
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555,
    0xAAAAAAAA,
    0x55555555
};

static GLfloat maxdim;
static int    vertsperframe;


#if defined(WIN32)
void APIENTRY FinishFrame(HDC hdc)
{
        glFinish();
}
#elif defined(OS2) || defined(__amigaos__)
void FinishFrame(void)
{
        glFinish();
}
#else
void FinishFrame(Display *dpy, GLXDrawable drawable)
{
        glFinish();
}
#endif

/*********************************************************************/
/*                                                                   */
/*  Swap for all you LITTLE_ENDIAN fans out there                    */
/*  Use this to convert binary files to LITTLE_ENDIAN format         */
/*                                                                   */
/*********************************************************************/

void    Swap32(void *ptr, long length)
{
    register GLuint tmp;        /* GLuint should be typedef'ed to 32 bit
                                   unsigned int */
    GLuint i, *array = (GLuint * ) ptr;

    for (i = 0; i < length; i++) {
        tmp = array[i];
        tmp &= 0xffffffff;
        tmp = ((tmp >> 24) | (tmp << 24) | 
            ((tmp >> 8) & 0xff00) | ((tmp << 8) & 0xff0000));
        array[i] = tmp;
    }

}


/*********************************************************************/
/*                                                                   */
/*  Convert GL error enums to text strings for output                */
/*                                                                   */
/*********************************************************************/

char    *error2str(GLenum err)
{
    switch (err) {
    case GL_INVALID_ENUM:
        return("GL_INVALID_ENUM");
    case GL_INVALID_VALUE:
        return("GL_INVALID_VALUE");
    case GL_INVALID_OPERATION:
        return("GL_INVALID_OPERATION");
    case GL_STACK_OVERFLOW:
        return("GL_STACK_OVERFLOW");
    case GL_STACK_UNDERFLOW:
        return("GL_STACK_UNDERFLOW");
    case GL_OUT_OF_MEMORY:
        return("GL_OUT_OF_MEMORY");
    }
}


/*********************************************************************/
/*                                                                   */
/*  Convert HSV color space to RGB                                   */
/*  Used to create vertex colors for data sets                       */
/*                                                                   */
/*********************************************************************/

hsv_to_rgb(GLfloat h, GLfloat s, GLfloat v, GLfloat *r, GLfloat *g, GLfloat *b)
{
    int    i;
    GLfloat       f, p, q, t;

    if (s == 0.0) {
        *r = v;
        *g = v;
        *b = v;
    } else {
        h = fmod(h, 1.);
        h *= 6.;
        i = (int) floor(h);
        f = h - i;
        p = v * (1 - s);
        q = v * (1 - (s * f));
        t = v * (1 - (s * (1 - f)));
        switch (i) {
        case 0 :
            *r = v;
            *g = t;
            *b = p;
            break;
        case 1 :
            *r = q;
            *g = v;
            *b = p;
            break;
        case 2 :
            *r = p;
            *g = v;
            *b = t;
            break;
        case 3 :
            *r = p;
            *g = q;
            *b = v;
            break;
        case 4 :
            *r = t;
            *g = p;
            *b = v;
            break;
        case 5 :
            *r = v;
            *g = p;
            *b = q;
            break;
        }
    }
}

#ifdef SEARCHPATH
/*********************************************************************/
/*                                                                   */
/*  Find a path of a particular file                                 */
/*                                                                   */
/*********************************************************************/

char* SearchPath(const char* path, const char* file)
{
    static char fullpath[512];
    char filename[512];
    char* tmppath;
    char searchpath[512];
    FILE *f;

    strcpy(searchpath, path);
    for (tmppath = strtok(searchpath, ":"); tmppath; tmppath = strtok(NULL, ":")) {
        if (*tmppath == 0) {
            strcpy(filename, ".");
        } else {
            strcpy(filename, tmppath);
        }
        strcat(filename, "/");
        strcat(filename, file);
        if (f = fopen(filename, "r")) {
            fclose(f);
            strcpy(fullpath, tmppath);
            return fullpath;
        }
    }
    return NULL;
}
#endif

/*********************************************************************/
/*                                                                   */
/*  Compute texture coordinates for polygon data sets                */
/*  Creates a spherical mapping based on vertex normals              */
/*                                                                   */
/*********************************************************************/

int    param_poly(struct EventBlock *pevent)
{
    int    i;
    double    phi, theta;
    double    basex, basey, basemag;
    double    uu, ww;
    struct vector *texture;
    struct vector *vnorm = pevent->rb->vnorm;
    int    numverts = pevent->rb->numverts;

    texture = pevent->rb->texture = (struct vector *)malloc((numverts + 1) * sizeof(struct vector ));

    for (i = 1; i <= numverts; i++) {
        /* calculate location in texture map */
        phi = acos(((double) vnorm[i].z));
        basemag = sqrt((double)vnorm[i].x * (double)vnorm[i].x + 
            (double)vnorm[i].y * (double)vnorm[i].y);
        if (basemag == 0.0) {
            basex = 0.0;
            basey = 0.0;
        } else {
            basex = vnorm[i].x / basemag;
            basey = vnorm[i].y / basemag;
        }
        theta = asin((double)basey);
        if (basex < 0.0)
            theta = PI - theta;
        if (theta < 0.0)
            theta += 2.0 * PI;
        uu = theta / (2.0 * PI);
        ww = phi / (PI);
        texture[i].x = (GLfloat)uu;
        texture[i].y = (GLfloat)ww;
    }
}


/*********************************************************************/
/*                                                                   */
/*  Compute texture coordinates for mesh data sets                   */
/*  Creates a spherical mapping based on vertex normals              */
/*                                                                   */
/*********************************************************************/

int    param_mesh(struct EventBlock *pevent)
{
    int    i, k;
    GLfloat phi, theta;
    double    basex, basey, basemag;
    GLfloat uu, ww;
    struct mesh *msh = pevent->rb->msh;
    struct vector *norms;
    struct vector *texture;
    int    *np = &pevent->rb->np;

    for (i = 0; i < *np; i++) {
        norms = msh[i].norms;
        texture = msh[i].texture;
        for (k = 0; k < msh[i].numverts; ++k) {
            /* calculate location in texture map */
            phi = acos((double)norms[k].z);
            basemag = sqrt((double)norms[k].x * (double)norms[k].x + (double)norms[k].y * (double)norms[k].y);
            if (basemag == 0.0) {
                basex = 0.0;
                basey = 0.0;
            } else {
                basex = msh[i].norms[k].x / basemag;
                basey = msh[i].norms[k].y / basemag;
            }
            theta = asin((double)basey);
            if (basex < 0.0)
                theta = PI - theta;
            if (theta < 0.0)
                theta += 2.0 * PI;
            uu = theta / (2.0 * PI);
            ww = phi / (PI);
            texture[k].x = (GLfloat)uu;
            texture[k].y = (GLfloat)ww;
        }
    }
}


/*********************************************************************/
/*                                                                   */
/*  meshinput reads in mesh data sets and computes vertex data       */
/*                                                                   */
/*********************************************************************/

void    meshinput(char *objnameptr, struct EventBlock *pevent)
{
    union {
        int    testWord;
        char    testByte[4];
    } endianTest;
    GLenum swapFlag;
    int binary_version, datatype;
    int    i, k;
    int    nummesh;
    FILE * f;
    char    filename[512], *filenameptr;
    int    tempspace[100];
    GLfloat maxmag, minmag, vertmag;
    GLfloat tmp;
    int cvcount;
    int    nRead;
    struct vector *dummybuffer;
    GLfloat * trans = pevent->trans;
    GLfloat * center = pevent->center;
    struct mesh *msh;
    int    *np = &pevent->rb->np;
    float    max[3], min[3];
#ifdef CRAY
    XDR xdr_handle;
    XDR *xdrs = &xdr_handle;
    float fbuf[3];
#endif

    endianTest.testWord = 1;
    if (endianTest.testByte[0] == 1) {
        swapFlag = GL_TRUE;
    } else {
        swapFlag = GL_FALSE;
    }
    *np = 0;

    filenameptr = filename;

    for (i = 0; i < 3; i++) {
        max[i] = SMALL;
        min[i] = BIG;
    }

    filenameptr = strcpy(filenameptr, objnameptr);
    /* Check to see if binary file format is present */
    filenameptr = strcat(filenameptr, extension[5]);

    if ((f = fopen(filename, BINARY_FILE)))
    {
        nRead = fread(&binary_version, sizeof(unsigned int), 1, f);
        if(nRead == 0) {
            FATAL_ERROR("unexpected end of input in binary file\n");
        }
        switch(binary_version) {
        case 0:
            nRead = fread(&datatype, sizeof(GLenum),1,f);
            if(nRead != 1) FATAL_ERROR("Unexpected end of input\n");
            if(datatype != GL_TRIANGLE_STRIP)
            {
                FATAL_ERROR("primitive type is not a triangle mesh\n");
            }
            nRead = fread(np, sizeof(int), 1, f);
            if(nRead != 1) FATAL_ERROR("Unexpected end of input\n");

            msh = pevent->rb->msh = 
                (struct mesh*)malloc(*np *sizeof(struct mesh));

#ifdef CRAY
            xdrstdio_create(xdrs, f, XDR_DECODE);
#endif
            for(nummesh = 0; nummesh < *np; ++nummesh)
            {
                fill_mesh(&(msh[nummesh]), f, swapFlag, min, max);
            }
#ifdef CRAY
            xdr_destroy(xdrs);
#endif
            fclose(f);

            compute_bounds(center, trans, min, max);
            get_colors_msh(msh, *np, trans, objnameptr);
            break;

        default:
            printf("Unrecognized binary version %u", binary_version);
            exit(1);
            break;
        }
    } else {
        filenameptr = strcpy(filenameptr, objnameptr);
        filenameptr = strcat(filenameptr, extension[4]);

        if((f = fopen(filename, BINARY_FILE)) == NULL) {
            printf("Couldn't open (.msh) input file %s\n", filename);
            exit(1);
        }

        /* Read through one to get a count */

#ifndef CRAY
        while ((nRead = fread(&cvcount, sizeof(GLint), 1, f)) > 0) {
            if (swapFlag)
                Swap32((void *) & cvcount, 1);
            dummybuffer = (struct vector *) malloc(cvcount * sizeof(struct vector ));

            nRead = fread(dummybuffer, cvcount * sizeof(GLfloat) * 3, 1, f);
            if (nRead == 0) {
                FATAL_ERROR("unexpected end of input in .msh file\n");
            }
            if (nRead < 0) {
                FATAL_ERROR("read error getting mesh\n");
            }
            nRead = fread(dummybuffer, cvcount * sizeof(GLfloat) * 3, 1, f);
            if (nRead == 0) {
                FATAL_ERROR("unexpected end of input\n");
            }
            if (nRead < 0) {
                FATAL_ERROR("read error getting mesh\n");
            }
            free(dummybuffer);
            (*np)++;
        }
        if (nRead < 0)
        {
            FATAL_ERROR("read error getting mesh\n");
        }
#else
        xdrstdio_create(xdrs, f, XDR_DECODE);
        while (xdr_int(xdrs, &cvcount)) {
            for (i = 0; i < cvcount; i++) {
                if (!xdr_vector(xdrs, (void *)&fbuf, 3, sizeof(float), xdr_float)) {
                    FATAL_ERROR("unexpected end of input\n");
                }
                if (!xdr_vector(xdrs, (void *)&fbuf, 3, sizeof(float), xdr_float)) {
                    FATAL_ERROR("unexpected end of input\n");
                }
            }
            (*np)++;
        }
        xdr_destroy(xdrs);
#endif
        fclose(f);

        if((f = fopen(filename, BINARY_FILE)) == 0) {
            FATAL_ERROR("Couldn't open (msh) input file\n");
        }
        /* malloc space for structure and fill it in */
        msh = pevent->rb->msh = 
            (struct mesh *)malloc(*np * sizeof(struct mesh ));

#ifdef CRAY
        xdrstdio_create(xdrs, f, XDR_DECODE);
#endif
        for (nummesh = 0; nummesh < *np; ++nummesh) {
            fill_mesh(&(msh[nummesh]), f, swapFlag, min, max);
        }

#ifdef CRAY
        xdr_destroy(xdrs);
#endif
        fclose(f);

        /* Compute bounding box info for data set */

        compute_bounds(center, trans, min, max);

        /* Compute vertex colors */

        get_colors_msh(msh, *np, trans, objnameptr);

    }
    /* count the number of vertex calls per frame */
    vertsperframe = 0;
    for (i = 0; i < *np; i++) {
        vertsperframe += msh[i].numverts;
    }
}

void get_colors_msh(struct mesh *msh, int np, 
GLfloat *trans, char *objnameptr)
{
    GLfloat maxmag = SMALL;
    GLfloat minmag = BIG;
    int i, k;
    FILE *f;
    char filename[512], *filenameptr;

    filenameptr = filename;

    filenameptr = strcpy(filenameptr, objnameptr);
    filenameptr = strcat(filenameptr, extension[3]);

    if(f = fopen(filename, BINARY_FILE)) {
        for (i = 0; i < np; i++) {
            for (k = 0; k < msh[i].numverts; ++k) {
                read_colors(&(msh[i].vcolor[k]), f);
            }
        }
        fclose(f);
    } else {
        for (i = 0; i < np; i++) {
            for (k = 0; k < msh[i].numverts; ++k) {
                compare_min_max(&(msh[i].verts[k]), trans, &minmag, &maxmag);
            }
        }
        for (i = 0; i < np; i++) {
            for (k = 0; k < msh[i].numverts; ++k) {
                calculate_colors(&(msh[i].vcolor[k]), &(msh[i].verts[k]),
                    trans, maxmag, minmag);
            }
        }
    }

}


void compute_bounds(GLfloat *center, GLfloat *trans, 
GLfloat *min, GLfloat *max)
{
    center[0] = (max[0] - min[0]);
    center[1] = (max[1] - min[1]);
    center[2] = (max[2] - min[2]);

    maxdim = sqrt((double)(center[0] * center[0] + center[1] * center[1] + 
        center[2] * center[2])) / 2.0F;
    trans[3] = maxdim;

    center[0] /= 2.0F;   /* don't move look up - need half dim */
    center[1] /= 2.0F;
    center[2] /= 2.0F;
    trans[0] = min[0] + center[0];
    trans[1] = min[1] + center[1];
    trans[2] = min[2] + center[2];
}

void compare_min_max(struct vector * verts, GLfloat * trans, 
GLfloat *minmag, GLfloat *maxmag)
{
    GLfloat vertmag;

    vertmag = sqrt((double)(verts->x - trans[0]) * 
        (verts->x - trans[0]) + 
        (verts->y - trans[1]) * 
        (verts->y - trans[1]) + 
        (verts->z - trans[2]) * 
        (verts->z - trans[2]));
    if (vertmag > *maxmag)
        *maxmag = vertmag;
    if (vertmag < *minmag)
        *minmag = vertmag;
}

void calculate_colors(struct colorvector * vcolor,  struct vector * verts,
GLfloat * trans, GLfloat maxmag, GLfloat minmag)
{
    GLfloat r, g, b, d;
    GLfloat vertmag;

    vertmag = sqrt((double)((verts->x - trans[0]) * 
        (verts->x - trans[0]) + 
        (verts->y - trans[1]) * 
        (verts->y - trans[1]) + 
        (verts->z - trans[2]) * 
        (verts->z - trans[2])));
    d = maxmag - vertmag;
    if (d == 0.0)
        vertmag = 1.0;
    else
        vertmag = (maxmag - minmag) / d;
    hsv_to_rgb(vertmag, 1.0, 1.0, &r, &g, &b);
    vcolor->r = r;
    vcolor->g = g;
    vcolor->b = b;
    vcolor->a = 0.5;
}



void read_colors(struct colorvector * vcolor, FILE *f)
{
    float r, g, b, a;
    int nRead;

    nRead = 0;
    nRead += fread(&r, sizeof(float), 1, f);
    nRead += fread(&g, sizeof(float), 1, f);
    nRead += fread(&b, sizeof(float), 1, f);
    nRead += fread(&a, sizeof(float), 1, f);

    if(nRead != 4) {
        FATAL_ERROR("read error in color file");
    }

#ifdef LITTLE_ENDIAN
    Swap32(&r, 1);
    Swap32(&g, 1);
    Swap32(&b, 1);
    Swap32(&a, 1);
#endif
    vcolor->r = r;
    vcolor->g = g;
    vcolor->b = b;
    vcolor->a = a;
}


void fill_mesh(struct mesh *msh, FILE *f, 
GLenum swapFlag, float *min, float*max)
{
    int cvcount;
    int i;

#ifndef CRAY
    fread(&cvcount, sizeof(GLint), 1, f);
    if (swapFlag)
        Swap32((void *) & cvcount, 1);
#else
    xdr_int(xdrs, &cvcount);
#endif
    msh->numverts = cvcount;
    msh->verts = (struct vector *) malloc(cvcount * sizeof(struct vector ));
    msh->norms = (struct vector *) malloc(cvcount * sizeof(struct vector ));
    msh->texture = (struct vector *) malloc(cvcount * sizeof(struct vector ));
    msh->vcolor = (struct colorvector *) malloc(cvcount * sizeof(struct colorvector ));
#ifndef CRAY
    fread(&msh->verts[0].x, cvcount * sizeof(GLfloat) * 3, 1, f);
    fread(&msh->norms[0].x, cvcount * sizeof(GLfloat) * 3, 1, f);
    if (swapFlag) {
        Swap32((void *) & msh->verts[0].x, cvcount * 3);
        Swap32((void *) & msh->norms[0].x, cvcount * 3);
    }
#else
    xdr_vector(xdrs, (void *)&msh->verts[0].x, cvcount * 3, sizeof(float), xdr_float);
    xdr_vector(xdrs, (void *)&msh->norms[0].x, cvcount * 3, sizeof(float), xdr_float);
#endif
    for (i = 0; i < cvcount; i++) {
        if (msh->verts[i].x > max[0])
            max[0] = msh->verts[i].x;
        else 
            if (msh->verts[i].x < min[0])
                min[0] = msh->verts[i].x;

        if (msh->verts[i].y > max[1])
            max[1] = msh->verts[i].y;
        else 
            if ( msh->verts[i].y < min[1])
                min[1] = msh->verts[i].y;

        if (msh->verts[i].z > max[2])
            max[2] = msh->verts[i].z;
        else 
            if (msh->verts[i].z < min[2])
                min[2] = msh->verts[i].z;
    }
}


/*********************************************************************/
/*                                                                   */
/*  polygoninput reads in polygon data sets and computes vertex data */
/*                                                                   */
/*********************************************************************/

void    polygoninput(char *objnameptr, struct EventBlock *pevent)
{
    int    i;
    FILE * f;
    int    numverts;
    int    numpoly;
    char    filename[512], *filenameptr;
    int    tempspace[100];
    GLfloat maxmag, minmag, vertmag;
    GLfloat tmp;
    char    name[1024];
    int    nRead;
    int    index, colorflag;
    GLfloat dummy[3];
    GLfloat * trans = pevent->trans;
    GLfloat * center = pevent->center;
    struct vector *vert;
    struct vector *vnorm;
    struct colorvector *vcolor;
    struct plygon *ply;
    int    *np = &pevent->rb->np;
    float    max[3], min[3];
    int binary_file = 0;
    int binary_version, datatype;

    *np = 0;

    filenameptr = filename;

    for (i = 0; i < 3; i++) {
        max[i] = SMALL;
        min[i] = BIG;
    }

    filenameptr = strcpy(filenameptr, objnameptr);
    /* Check to see if binary file format is present */
    filenameptr = strcat(filenameptr, extension[5]);

    if ((f = fopen(filename, BINARY_FILE))) {
        binary_file = 1;
        nRead = fread(&binary_version, sizeof(unsigned int), 1, f);
        if(nRead == 0) {
            FATAL_ERROR("unexpected end of input in binary file\n");
        }
        switch(binary_version) {
        case 0:
            nRead = fread(&datatype, sizeof(GLenum),1,f);
            if(nRead != 1) FATAL_ERROR("Unexpected end of input\n");
            if(datatype != GL_POLYGON) {
                FATAL_ERROR("primitive type is not a polygon\n");
            }

            nRead = fread(np, sizeof(int), 1, f);
            if(nRead != 1) FATAL_ERROR("Unexpected end of input\n");

            ply = pevent->rb->ply = 
                (struct plygon *)malloc((*np) * sizeof(struct plygon ));

            for(numpoly = 0; numpoly < *np; ++numpoly) {
                fread(&(ply[numpoly].numverts), sizeof(int), 1, f);
                if(ply[numpoly].numverts <= 0)
                    FATAL_ERROR("Negative primitive size\n");
                ply[numpoly].index = 
                    (int *)malloc(ply[numpoly].numverts * sizeof(int));
                fread(ply[numpoly].index, sizeof(int), ply[numpoly].numverts, f);
            }

            nRead = fread(&numverts, sizeof(int), 1, f);
            if(nRead != 1) FATAL_ERROR("Unexpected end of input\n");
            if(numverts <= 0) FATAL_ERROR("Negative number of vertexes\n");
            vert = pevent->rb->vert = 
                (struct vector *)malloc(numverts*sizeof(struct vector));
            vnorm = pevent->rb->vnorm =
                (struct vector *)malloc(numverts*sizeof(struct vector));
            vcolor = pevent->rb->vcolor = 
                (struct colorvector *)malloc(numverts*sizeof(struct colorvector));

            fread(vert, sizeof(struct vector), numverts, f);
            fread(vnorm, sizeof(struct vector), numverts, f);
            for(i=0; i < numverts; i++) {
                if(vert[i].x > max[0])
                    max[0] = vert[i].x;
                else if (vert[i].x < min[0])
                    min[0] = vert[i].x;

                if(vert[i].y > max[1])
                    max[1] = vert[i].y;
                else if (vert[i].x < min[1])
                    min[1] = vert[i].y;

                if(vert[i].z > max[2])
                    max[0] = vert[i].z;
                else if (vert[i].z < min[2])
                    min[2] = vert[i].z;
            }

            compute_bounds(center, trans, min, max);
            get_colors_ply(vert, vcolor, numverts, trans, objnameptr);
            break;

        default:
            printf("Unrecognized binary version %u", binary_version);
            exit(1);
            break;
        }
    } else {
        /* Open .coo file - vertex info */
        filenameptr = strcpy(filenameptr, objnameptr);
        filenameptr = strcat(filenameptr, extension[0]);

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (coo) input file\n");
        }

        /* Read once to get a count */
        numverts = 0;
        while ((nRead = fscanf(f, "%d", &index)) == 1) {
            nRead = fscanf(f, ",%f,%f,%f", &dummy[0], &dummy[1], &dummy[2]);
            if (nRead == EOF) {
                FATAL_ERROR("unexpected end of input\n");
            }
            if (nRead != 3) {
                FATAL_ERROR("read error getting polygon input\n");
            }
            numverts++;
        }
        if (nRead != EOF) {
            FATAL_ERROR("read error getting polygon input\n");
        }
        fclose(f);
        pevent->rb->numverts = numverts;

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (coo) input file\n");
        }


        /* malloc space and fill it in */
        vert = pevent->rb->vert = 
            (struct vector *)malloc((numverts+1)*sizeof(struct vector ));

        for (i = 1; i <= numverts; i++) {
            fscanf(f, "%d", &index);
            fscanf(f, ",%f,%f,%f", &(vert[index].x), &(vert[index].y), 
                &(vert[index].z));

            if (vert[index].x > max[0])
                max[0] = vert[index].x;
            else if (vert[index].x < min[0])
                min[0] = vert[index].x;

            if (vert[index].y > max[1])
                max[1] = vert[index].y;
            else if (vert[index].y < min[1])
                min[1] = vert[index].y;

            if (vert[index].z > max[2])
                max[2] = vert[index].z;
            else if (vert[index].z < min[2])
                min[2] = vert[index].z;
        }

        /* Open .ele file - connectivity info */

        fclose(f);

        filenameptr = strcpy(filenameptr, objnameptr);
        filenameptr = strcat(filenameptr, extension[1]);

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (ele) input file\n");
        }

        /* Read once to get a count */

        while ((nRead = fscanf(f, "%s ", name)) == 1) {
            i = 0;
            while ((nRead = fscanf(f, "%d ", &tempspace[i])) == 1)
                i++;

            if (i > 0) { 
                (*np)++; 
            }
        }
        if (nRead != EOF) {
            FATAL_ERROR("read error getting polygon input\n");
        }

        fclose(f);

        /* malloc space and fill it in */
        ply = pevent->rb->ply = 
            (struct plygon *)malloc((*np) * sizeof(struct plygon ));

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (ele) input file\n");
        }

        for (numpoly = 0; numpoly < *np; ++numpoly) {
            fscanf(f, "%s ", name);
            i = 0;
            while ((nRead = fscanf(f, "%d ", &tempspace[i])) == 1)
                i++;

            if (i > 0) {
                ply[numpoly].numverts = i;
                ply[numpoly].index = (int *) malloc(i * sizeof(int));
                for (i = 0; i < ply[numpoly].numverts; i++)
                    ply[numpoly].index[i] = (int) tempspace[i];
            }
        }
        fclose(f);

        /* Open .vnm file - vertex normals */

        filenameptr = strcpy(filenameptr, objnameptr);
        filenameptr = strcat(filenameptr, extension[2]);

        /* already have count so malloc space and fill it in */

        vnorm = pevent->rb->vnorm = 
            (struct vector *)malloc((numverts + 1) * sizeof(struct vector ));

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (vnm) input file\n");
        }
        for (i = 1; i <= numverts; i++)
            nRead = fscanf(f, "%f %f %f\n", &vnorm[i].x, &vnorm[i].y, &vnorm[i].z);
        if (nRead != 3) {
            FATAL_ERROR("read error in .vnm file\n");
        }
        fclose(f);


        /* Compute bounding box info */
        compute_bounds(center, trans, min, max);

        /* compute vertex color and fill them in */
        vcolor = pevent->rb->vcolor = 
            (struct colorvector *)malloc((numverts+1)*sizeof(struct colorvector ));

        get_colors_ply(vert, vcolor, numverts, trans, objnameptr);
    }
    /* count the number of vertex calls per frame */

    vertsperframe = 0;
    for (i = 0; i < *np; i++) {
        vertsperframe += ply[i].numverts;
    }
}


void get_colors_ply(struct vector *vert, struct colorvector *vcolor, 
int numverts, GLfloat *trans, char *objnameptr)
{
    int colorflag;
    GLfloat maxmag = SMALL;
    GLfloat minmag = BIG;
    int i;
    FILE * f;
    char filename[512], *filenameptr;

    filenameptr = filename;
    filenameptr = strcpy(filenameptr, objnameptr);
    filenameptr = strcat(filenameptr, extension[3]);

    if((f = fopen(filename, BINARY_FILE)) == 0) {
        colorflag = 0;
    } else {
        colorflag = 1;
    }

    if (!colorflag) {
        for (i = 1; i <= numverts; i++) {
            compare_min_max(&(vert[i]), trans, &minmag, &maxmag);
        }
    }

    for (i = 1; i <= numverts; i++) {
        if(colorflag) {
            read_colors(&(vcolor[i]), f);
        } else {
            calculate_colors(&(vcolor[i]), &(vert[i]), trans, maxmag, minmag);
        }
    }
    if(colorflag)
        fclose(f);
}

GLfloat MinAngle( GLfloat from, GLfloat to)
{
    GLfloat delta = to - from;
    if (fabs(delta) > 180.) {
	return (from > to) ? delta + 360. : delta - 360.;
    } else {
	return delta;
    }
}

void	walkthruinput(char *objnameptr, struct EventBlock *pevent)
{
    FILE *fp;
    char filename[512], *filenameptr;
    GLfloat eyeX, eyeY, eyeZ;
    GLfloat p_eyeX, p_eyeY, p_eyeZ;
    GLfloat heading, p_heading;
    GLfloat pitch, p_pitch;
    GLfloat roll, p_roll;
    int frame;
    int p_frame;
    int f;
    const int sizeInc = 10;
    int size = sizeInc;
    GLfloat **walkthru = (GLfloat**)malloc(sizeof(GLfloat*)*size);
    GLfloat dt, dex, dey, dez, dh, dp, dr;

    filenameptr = filename;
    filenameptr = strcpy(filenameptr, objnameptr);
    filenameptr = strcat(filenameptr, extension[6]);
    if ((fp = fopen(filename, "r"))) {
        glMatrixMode(GL_MODELVIEW);
        glPushMatrix();
        glLoadIdentity();
        while (fscanf(fp, "%d %f %f %f %f %f %f",
                  &frame,
                  &eyeX, &eyeY, &eyeZ,
                  &heading, &pitch, &roll) !=EOF) {
            if (frame > 0) {
                dt = frame - p_frame;
                dex = (eyeX - p_eyeX)/dt;
                dey = (eyeY - p_eyeY)/dt;
                dez = (eyeZ - p_eyeZ)/dt;
                dh = MinAngle(p_heading, heading)/dt;
                dp = MinAngle(p_pitch, pitch)/dt;
                dr = MinAngle(p_roll, roll)/dt;
                for (f = p_frame; f < frame; f++) {
                    float i = f - p_frame;
                    glPushMatrix();
                    glRotatef(-90.0,                 1.0, 0.0, 0.0);
                    glRotatef(-(p_roll + i * dr),    0.0, 1.0, 0.0);
                    glRotatef(-(p_pitch + i * dp),   1.0, 0.0, 0.0);
                    glRotatef(-(p_heading + i * dh), 0.0, 0.0, 1.0);
                    glTranslatef(
                        -(p_eyeX + i * dex),
                        -(p_eyeY + i * dey),
                        -(p_eyeZ + i * dez)
                    );
                    if (f == size) {
                        size += sizeInc;
                        walkthru = (GLfloat**)realloc(walkthru, sizeof(GLfloat*)*size);
                    }
                    walkthru[f] = (GLfloat*)malloc(sizeof(GLfloat)*16);
                    glGetFloatv(GL_MODELVIEW_MATRIX, walkthru[f]);
                    glPopMatrix();
                }
            }
            p_frame = frame;
            p_eyeX = eyeX;
            p_eyeY = eyeY;
            p_eyeZ = eyeZ;
            p_heading = heading;
            p_pitch = pitch;
            p_roll = roll;
        }
        glPopMatrix();
	if (pevent->numframes == 0) {
	    pevent->numframes = frame;
	} else if (pevent->numframes > frame) {
	    FATAL_ERROR("viewperf: -numframes greater than defined positions in walkthru file\n");
	}
	pevent->walkthru = walkthru;
    } else {
        FATAL_ERROR("viewperf: could not find walkthru file\n");
    }
}

/*********************************************************************/
/*                                                                   */
/*  triquadinput reads in triangle and quad data sets and computes   */
/*  vertex data                                                      */
/*                                                                   */
/*********************************************************************/

void    triquadinput(char *objnameptr, int vertsperobj, struct EventBlock *pevent)
{
    int    i;
    FILE * f;
    int    numverts;
    int    numpoly;
    char    filename[512], *filenameptr;
    int    tempspace[4];
    GLfloat maxmag, minmag, vertmag;
    GLfloat tmp;
    char    name[1024];
    int    nRead;
    int    index, colorflag;
    GLfloat dummy[3];
    GLfloat * trans = pevent->trans;
    GLfloat * center = pevent->center;
    struct vector *vert;
    struct vector *vnorm;
    struct colorvector *vcolor;
    struct plygon *ply;
    int    *np = &pevent->rb->np;
    float    max[3], min[3];
    unsigned binary_version;
    GLenum datatype;

    *np = 0;

    filenameptr = filename;

    for (i = 0; i < 3; i++) {
        max[i] = SMALL;
        min[i] = BIG;
    }


    filenameptr = strcpy(filenameptr, objnameptr);
    filenameptr = strcat(filenameptr, extension[5]);
    if((f = fopen(filename, BINARY_FILE))) {
        nRead = fread(&binary_version, sizeof(unsigned int), 1, f);
        if(nRead == 0) {
            FATAL_ERROR("Unexpected end of input in binary file\n");
        }
        switch(binary_version) {
        case 0:
            nRead = fread(&datatype, sizeof(GLenum), 1, f);
            if(nRead != 1) FATAL_ERROR("Unexpected end of input\n");
            if(!(((datatype == GL_TRIANGLES) && (vertsperobj == 3)) ||
                ((datatype == GL_QUADS)) && (vertsperobj == 4)))
            {
                FATAL_ERROR("primitive type not triangles or quads\n");
            }

            fread(&numverts, sizeof(unsigned), 1, f);
            pevent->rb->numverts = numverts;
            if(nRead != 1) FATAL_ERROR("Unexpected end of input\n");
            vert = pevent->rb->vert = 
                (struct vector *)malloc((numverts+1)*sizeof(struct vector));
            fread(&vert[1], sizeof(struct vector), numverts, f);

            for(i=1; i <= numverts; i++) {
                if (vert[i].x > max[0])
                    max[0] = vert[i].x;
                else if (vert[i].x < min[0])
                    min[0] = vert[i].x;

                if (vert[i].y > max[1])
                    max[1] = vert[i].y;
                else if (vert[i].y < min[1])
                    min[1] = vert[i].y;

                if (vert[i].z > max[2])
                    max[2] = vert[i].z;
                else if (vert[i].z < min[2])
                    min[2] = vert[i].z;
            }

            *np = numverts / vertsperobj;
            vnorm = pevent->rb->vnorm = 
                (struct vector *)malloc(numverts*sizeof(struct vector));
            fread(vert, sizeof(struct vector), numverts, f);
            ply = pevent->rb->ply = 
                (struct plygon *)malloc((*np) * sizeof(struct plygon ));
            for(numpoly = 0; numpoly < *np; ++numpoly) {
                ply[numpoly].numverts = vertsperobj;
                ply[numpoly].index = (int *)malloc(vertsperobj *sizeof(int));
                fread(ply[numpoly].index, sizeof(int), vertsperobj, f);
            }


            compute_bounds(center, trans, min, max);
            vcolor = pevent->rb->vcolor = 
                (struct colorvector*)malloc((numverts)*sizeof(struct colorvector));
            get_colors_triquad(vert, vcolor, numverts, trans, objnameptr);
            fclose(f);
            break;
        default:
            printf("Unrecognized binary version %u", binary_version);
            exit(1);
            break;
        }
    } else {
        /* Open .coo file - vertex info */
        filenameptr = strcpy(filenameptr, objnameptr);
        filenameptr = strcat(filenameptr, extension[0]);

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (coo) input file\n");
        }

        /* Read once to get a count */

        numverts = 0;
        while ((nRead = fscanf(f, "%d", &index)) == 1) {
            nRead = fscanf(f, ",%f,%f,%f", &dummy[0], &dummy[1], &dummy[2]);
            if (nRead == EOF) {
                FATAL_ERROR("unexpected end of input\n");
            }
            if (nRead != 3) {
                FATAL_ERROR("read error in .coo file\n");
            }
            numverts++;
        }
        if (nRead != EOF) {
            FATAL_ERROR("read error in .coo file (2)\n");
        }
        fclose(f);

        /* malloc space and fill it in */

        vert = pevent->rb->vert = 
            (struct vector *)malloc((numverts + 1) * sizeof(struct vector ));
        pevent->rb->numverts = numverts;

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (coo) input file\n");
        }
        for (i = 1; i <= numverts; i++) {
            fscanf(f, "%d", &index);
            fscanf(f, ",%f,%f,%f", 
                &(vert[index].x), &(vert[index].y), &(vert[index].z));

            if (vert[i].x > max[0])
                max[0] = vert[i].x;
            else if (vert[i].x < min[0])
                min[0] = vert[i].x;

            if (vert[i].y > max[1])
                max[1] = vert[i].y;
            else if (vert[i].y < min[1])
                min[1] = vert[i].y;

            if (vert[i].z > max[2])
                max[2] = vert[i].z;
            else if (vert[i].z < min[2])
                min[2] = vert[i].z;
        }

        fclose(f);

        /* Open .ele file - connectivity info */
        filenameptr = strcpy(filenameptr, objnameptr);
        filenameptr = strcat(filenameptr, extension[1]);

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (ele) input file\n");
        }

        while ((nRead = fscanf(f, "%s ", name)) == 1) {

            i = 0;
            while ((nRead = fscanf(f, "%d ", &tempspace[i])) == 1)
                i++;
            if (i != vertsperobj) {
                FATAL_ERROR("Input file doesn't match input type\n");
            }

            if (i > 0) {
                (*np)++;
            }
        }
        if (nRead != EOF) {
            FATAL_ERROR("read error in .ele file\n");
        }

        fclose(f);

        /* malloc space and fill it in */

        ply = pevent->rb->ply = 
            (struct plygon *)malloc((*np) * sizeof(struct plygon ));

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (ele) input file\n");
        }

        for (numpoly = 0; numpoly < *np; ++numpoly) {
            fscanf(f, "%s ", name);
            ply[numpoly].numverts = vertsperobj;
            ply[numpoly].index = (int *) malloc(vertsperobj * sizeof(int));
            for (i = 0; i < ply[numpoly].numverts; i++)
                fscanf(f, "%d ", &ply[numpoly].index[i]);
        }
        fclose(f);

        /* Open .vnm file - vertex normal info */

        filenameptr = strcpy(filenameptr, objnameptr);
        filenameptr = strcat(filenameptr, extension[2]);

        /* already know how many so malloc and fill in */

        vnorm = pevent->rb->vnorm = 
            (struct vector *)malloc((numverts + 1) * sizeof(struct vector ));

        if ((f = fopen(filename, "r")) == 0) {
            FATAL_ERROR("Couldn't open (vnm) input file\n");
        }
        for (i = 1; i <= numverts; i++)
            nRead = fscanf(f, "%f %f %f\n", &vnorm[i].x, &vnorm[i].y, &vnorm[i].z);
        if (nRead != 3) {
            FATAL_ERROR("read error in .vnm file\n");
        }
        fclose(f);


        /* Compute bounding box info */
        compute_bounds(center, trans, min, max);

        /* Compute vertex color, malloc space, and fill it in */
        vcolor = pevent->rb->vcolor = 
            (struct colorvector *)malloc((numverts+1)*sizeof(struct colorvector));

        get_colors_triquad(vert, vcolor, numverts, trans, objnameptr);
    }

    /* Count the number of vertex calls per frame */

    vertsperframe = 0;
    for (i = 0; i < *np; i++) {
        vertsperframe += ply[i].numverts;
    }
}

void get_colors_triquad(struct vector *vert, struct colorvector *vcolor, 
int numverts, GLfloat *trans, char *objnameptr)
{
    int colorflag;
    GLfloat maxmag = SMALL;
    GLfloat minmag = BIG;
    int i;
    FILE *f;
    char filename[512], *filenameptr;

    filenameptr = filename;
    filenameptr = strcpy(filenameptr, objnameptr);
    filenameptr = strcat(filenameptr, extension[3]);

    if((f = fopen(filename, BINARY_FILE)) == 0) {
        colorflag = 0;
    }
    else
        colorflag = 1;

    if(!colorflag) {
        for (i = 1; i <= numverts; i++) {
            compare_min_max(&vert[i], trans, &minmag, &maxmag);
        }
    }


    if(colorflag) {
        for (i = 1; i <= numverts; i++) {
            read_colors(&vcolor[i], f);
        }
    } else {
        for (i = 1; i <= numverts; i++) {
            calculate_colors(&vcolor[i], &vert[i], trans, maxmag, minmag);
        }
    }

    if(colorflag)
        fclose(f);
}

/*********************************************************************/
/*                                                                   */
/*  Define all material, lighting and lighting model parameters      */
/*                                                                   */
/*********************************************************************/

void SetLightingState(int infiniteLights, int localLights, GLfloat localViewer, GLenum twoSidedLighting, int cmenable, int cmface, int cmmode, int blendOn)
{
    int i;
    GLfloat normFactor;

    /* Material settings */
    GLfloat materialAmbientColor[4] = {
        0.5F, 0.5F, 0.5F, 1.0F
    };

    GLfloat materialDiffuseColor[4] = {
        0.7F, 0.7F, 0.7F, 1.0F
    };

    GLfloat materialSpecularColor[4] = {
        1.0F, 1.0F, 1.0F, 1.0F
    };

    GLfloat materialShininess[1] = {
        128
    };

    /* Lighting settings */
    GLfloat lightPosition[8][4] = {
        {  1.0F,  1.0F,  1.0F, 1.0F },
        {  1.0F,  0.0F,  1.0F, 1.0F },
        {  1.0F, -1.0F,  1.0F, 1.0F },
        {  0.0F, -1.0F,  1.0F, 1.0F },
        { -1.0F, -1.0F,  1.0F, 1.0F },
        { -1.0F,  0.0F,  1.0F, 1.0F },
        { -1.0F,  1.0F,  1.0F, 1.0F },
        {  0.0F,  1.0F,  1.0F, 1.0F }
    };

    GLfloat lightDiffuseColor[8][4] = {
        { 1.0F, 1.0F, 1.0F, 1.0F },
        { 0.0F, 1.0F, 1.0F, 1.0F },
        { 1.0F, 0.0F, 1.0F, 1.0F },
        { 1.0F, 1.0F, 0.0F, 1.0F },
        { 1.0F, 0.0F, 0.0F, 1.0F },
        { 0.0F, 1.0F, 0.0F, 1.0F },
        { 0.0F, 0.0F, 1.0F, 1.0F },
        { 1.0F, 1.0F, 1.0F, 1.0F }
    };

    GLfloat lightAmbientColor[4] = {
        0.1F, 0.1F, 0.1F, 1.0F
    };

    GLfloat lightSpecularColor[4] = {
        1.0F, 1.0F, 1.0F, 1.0F
    };

    GLfloat lightModelAmbient[4] = {
        0.5F, 0.5F, 0.5F, 1.0F
    };

    GLfloat alpha = blendOn ? 0.5F : 1.0F;

    if (infiniteLights + localLights == 0)
        return;

    normFactor = 1.0F / (GLfloat)(infiniteLights + localLights);

    materialDiffuseColor[3] = alpha;
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, materialDiffuseColor);
    materialAmbientColor[3] = alpha;
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, materialAmbientColor);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, materialSpecularColor);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, materialShininess);

    lightAmbientColor[0] *= normFactor;
    lightAmbientColor[1] *= normFactor;
    lightAmbientColor[2] *= normFactor;

    for (i = 0; i < localLights + infiniteLights; i++) {
        lightPosition[i][3] = (GLfloat)(i < localLights);
        lightDiffuseColor[i][0] *= normFactor;
        lightDiffuseColor[i][1] *= normFactor;
        lightDiffuseColor[i][2] *= normFactor;
        glLightfv(GL_LIGHT0 + i, GL_POSITION, lightPosition[i]);
        glLightfv(GL_LIGHT0 + i, GL_DIFFUSE,  lightDiffuseColor[i]);
        glLightfv(GL_LIGHT0 + i, GL_AMBIENT,  lightAmbientColor);
        glLightfv(GL_LIGHT0 + i, GL_SPECULAR, lightSpecularColor);
        glEnable(GL_LIGHT0 + i);
    }

    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, lightModelAmbient);
    glLightModelf(GL_LIGHT_MODEL_LOCAL_VIEWER, localViewer);
    glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, twoSidedLighting);

    if (cmenable) {
        glColorMaterial(cmface, cmmode);
        glEnable(GL_COLOR_MATERIAL);
    }

    glEnable(GL_LIGHTING);
}


/*********************************************************************/
/*                                                                   */
/*  Stroke out cute little text for the title screen                 */
/*                                                                   */
/*********************************************************************/

DrawString(char *str, GLfloat x, GLfloat y)
{
    short    nseg, nstroke;
    short    *cptr;
    int    i, j;

    glPushMatrix();
    glTranslatef (x, y, 0.0F);
    glScalef (10.0F, 10.0F, 1.0F);


    while (*str) {
        cptr = &(chrtbl[*str][0]);
        nseg = *(cptr++);
        for (i = 0; i < nseg; i++) {
            nstroke = *(cptr++);
            glBegin(GL_LINE_STRIP);
            for (j = 0; j < nstroke; j++) {
                glVertex2sv(cptr);
                cptr += 2;
            }
            glEnd();
        }
        glTranslatef (6.0F, 0.0F, 0.0F);
        str++;
    }
    glPopMatrix();
}


/*********************************************************************/
/*                                                                   */
/*  rmnoop is plugged into the jump tables where ever there are      */
/*  holes.  They should never be called if everything is working     */
/*  as planned .. but just in case we'll print an error message.     */
/*                                                                   */
/*********************************************************************/

void    rmnoop(struct ThreadBlock *tb)
{
    fprintf(stderr, "This RenderMode is not available for the selected data set\n");
}


/*********************************************************************/
/*                                                                   */
/*  Extern routines are plugged into renderers that turn on and off  */
/*  OpenGL capabilities. These are called once per primitive         */
/*  through a function pointer. Special "Extern" render routines     */
/*  have been created that call these functions as part of their     */
/*  rendering duties. Look in VP_OBJS for their names.               */
/*                                                                   */
/*********************************************************************/

void    toggle_capability(GLenum capability)
{
    static int    toggleon = 0;

    if (toggleon = 1 - toggleon)
        glEnable(capability);
    else
        glDisable(capability);
}


void    toggle_linewidth(GLenum dummy)
{
    static GLfloat togglewide = 0.0F;

    togglewide = 1.0F - togglewide;
    glLineWidth(togglewide + 1.0F);
}


void    toggle_matrix(GLenum dummy)
{
    static GLfloat matrix[] = {
        1.0F, 0.0F, 0.0F, 0.0F,
        0.0F, 1.0F, 0.0F, 0.0F,
        0.0F, 0.0F, 1.0F, 0.0F,
        0.0F, 0.0F, 0.0F, 1.0F             };

    glMultMatrixf(matrix);
}


/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
/*                                                                   */
/*  Mr. Main                                                         */
/*                                                                   */
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/

main(int argc, char *argv[])
{
    char *ptr;
    char tempstring[512];
    GLenum vistype = 0;
    int    i, j, k;
    int    thread;

    FILE * f, *texfile;

    int    numInfiniteLights = 0;
    int    numLocalLights = 0;
    GLenum lighttwoside = GL_FALSE;

    int    vis_id = 0;
    GLenum vis_criteria = AUX_MINIMUM_CRITERIA;

    int    renderDoubleBuffer = VP_TRUE;
    int    colormode = COLOR_PER_FRAME;
    int    inputmode = NOINPUT;
    int    batchmode = VP_FALSE;
    int    numtobatch = 0;
    int    facetnormalmode = VP_FALSE;
    int    linesmoothmode = VP_FALSE;
    int    polysmoothmode = VP_FALSE;
    int    backfacemode = VP_FALSE;
    int    frontfacemode = VP_FALSE;
    int    zbuffermode = VP_FALSE;
    int    fogmode = VP_FALSE;
    int    clipmode = VP_FALSE;
    GLenum shademodelmode = GL_SMOOTH;
    int    polystipplemode = VP_FALSE;
    int    linestipplemode = VP_FALSE;
    int    togglemode = VP_FALSE;
    int    togglelinewidthmode = VP_FALSE;
    int    togglematrixmode = VP_FALSE;
    int    orthomode = VP_FALSE;
    int    dithermode = VP_TRUE;
    int    texturemode = VP_FALSE;
    int    texgenmode = TXG_NO_TEX_GEN;
    GLenum texenvmode = GL_DECAL;
    int    blendmode = VP_FALSE;
    GLenum sblendfunc = GL_SRC_ALPHA;
    GLenum dblendfunc = GL_ONE_MINUS_SRC_ALPHA;
    int    rendermode = LINEmode;
    int    displaylistmode = VP_FALSE;
    GLfloat linewidthmode = 1.0F;
    GLfloat localviewmode = 0.0F;
    GLenum polymodefront = GL_FILL;
    GLenum polymodeback = GL_FILL;
    int     mblurmode = VP_FALSE;
    GLfloat blur_amount = 0.0;
    int     fsantimode = VP_FALSE;
    int     fsaredraw = 0;
    GLfloat fsajitter = 0.0F;
    struct vector *jitter;
    int     walkthrumode = VP_FALSE;
    int     cmface = GL_FRONT;
    int     cmmode = GL_AMBIENT_AND_DIFFUSE;
    int     cmenable = VP_FALSE;

    char    filename[512], *filenameptr;
    char    objname[64], *objnameptr;

    char    header[64];
    char    *depth;
    long    pack;
    int    row, col, index;
    int    xpix, ypix;
    int    numpix;
    int    numcomp = 3;
    GLfloat minfilter = GL_NEAREST;
    GLfloat magfilter = GL_NEAREST;
    unsigned char    *Image;
    unsigned char    *TextureImage;

    RenderIndex rfindex;
    EventLoopIndex elindex;
    struct RenderBlock renderblock;
    struct ThreadBlock *tb;

    GLfloat * trans = eventblock.trans;
    GLfloat * center = eventblock.center;

    EnvironmentInfo environ;
    char *leader = OUTPUT_LEADER;
    int nameWidth = OUTPUT_NAME_WIDTH;

    environ.directRender = VP_TRUE;
    environ.bufConfig.doubleBuffer = VP_TRUE;
    environ.windowWidth = X_WINDOW_SIZE;
    environ.windowHeight = Y_WINDOW_SIZE;

    eventblock.rb = &renderblock;
    eventblock.numframes = 0;
    eventblock.minperiod = MIN_TEST_TIME;
    eventblock.threads = 1;

    filenameptr = filename;
    objnameptr = objname;



#ifdef WIN32
    LogFile = fopen("viewperf.log", "a");
#endif

    /* Save a copy of the command line arguments */
    strcpy( cmdln , "\0" );
    for( i=1 ; i< argc ; i++) {
        strcat(cmdln,argv[i]);
        strcat(cmdln," ");
    }

    /*********************************************************************/
    /*                                                                   */
    /*  Get your branch units ready ...                                  */
    /*  Parse the command line args and set viewperf mode variables      */
    /*                                                                   */
    /*********************************************************************/

    while (--argc) {
        ++argv;

        /*** Options accepting arguments. ***/
        if (strcmp ("-backface", argv[0]) == 0 || 
            strcmp ("-bf", argv[0]) == 0) {
            backfacemode = VP_TRUE;
        } else if (strcmp ("-frontface", argv[0]) == 0 || 
            strcmp ("-ff", argv[0]) == 0)
        {
            frontfacemode = VP_TRUE;
        } else if (strcmp ("-mblur", argv[0]) == 0) {
            if(argc == 1)
                FATAL_ERROR ("viewperf: the -mblur flag requires a number of frames.\n");
            mblurmode = VP_TRUE;
            blur_amount =  atof(argv[1]);
            vistype |= AUX_ACCUM;
            ARG_INC;
        } else if (strcmp("-aa_multi", argv[0]) == 0) {
            if(argc < 3)
                FATAL_ERROR ("viewperf: the -aa_multi flag requires # of samples and jitter distance.\n");
            fsantimode = VP_TRUE;
            fsaredraw = atoi(argv[1]);
            fsajitter = atof(argv[2]);
            jitter = (struct vector *)malloc((fsaredraw +1)* sizeof(struct vector));
            jitter[0].x = 0;
            jitter[0].y = 0;
            jitter[0].z = 0;
            for(i=1; i<= fsaredraw; i++)
            {
                jitter[i].x = fsajitter * cos(2.0*PI*i/fsaredraw);
                jitter[i].y = fsajitter * sin(2.0*PI*i/fsaredraw);
            }
            vistype |= AUX_ACCUM;
            ARG_INC;
            ARG_INC;
        } else if (strcmp ("-rendermode", argv[0]) == 0 || 
            strcmp ("-rm", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -rendermode flag requires an argument.\n");
            if (strcmp ("VECTOR", argv[1]) == 0)
                rendermode = VECTORmode;
            else if (strcmp ("LINE", argv[1]) == 0)
                rendermode = LINEmode;
            else if (strcmp ("POLYGON", argv[1]) == 0)
                rendermode = POLYGONmode;
            else if (strcmp ("TFAN", argv[1]) == 0)
                rendermode = TFANmode;
            else if (strcmp ("POINT", argv[1]) == 0)
                rendermode = POINTmode;
            else if (strcmp ("TMESH", argv[1]) == 0)
                rendermode = TMESHmode;
            else if (strcmp ("TRIANGLE", argv[1]) == 0)
                rendermode = TRImode;
            else if (strcmp ("QUAD", argv[1]) == 0)
                rendermode = QUADmode;
            ARG_INC;
        } else if (strcmp ("-linesmooth", argv[0]) == 0 || 
            strcmp ("-ls", argv[0]) == 0) {
            linesmoothmode = VP_TRUE;
        } else if (strcmp ("-facetnormal", argv[0]) == 0 || 
            strcmp ("-fn", argv[0]) == 0) {
            facetnormalmode = VP_TRUE;
        } else if (strcmp ("-displaylist", argv[0]) == 0 || 
            strcmp ("-dl", argv[0]) == 0) {
            displaylistmode = VP_TRUE;
        } else if (strcmp ("-flat", argv[0]) == 0 || 
            strcmp ("-f", argv[0]) == 0) {
            shademodelmode = GL_FLAT;
        } else if (strcmp ("-indirectrender", argv[0]) == 0 || 
            strcmp ("-ir", argv[0]) == 0) {
            environ.directRender = VP_FALSE;
        } else if (strcmp ("-vaccum", argv[0]) == 0 || 
            strcmp ("-vac", argv[0]) == 0) {
            vistype |= AUX_ACCUM;
        } else if (strcmp ("-valpha", argv[0]) == 0 || 
            strcmp ("-val", argv[0]) == 0) {
            vistype |= AUX_ALPHA;
        } else if (strcmp ("-vdepthbuffer", argv[0]) == 0 || 
            strcmp ("-vz", argv[0]) == 0) {
            vistype |= AUX_DEPTH;
        } else if (strcmp ("-vstencil", argv[0]) == 0 || 
            strcmp ("-vst", argv[0]) == 0) {
            vistype |= AUX_STENCIL;
        } else if (strcmp ("-vid", argv[0]) == 0 ) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -vid flag requires an argument.\n");
            vis_id = atoi (argv[1]);
            vis_criteria = AUX_USE_ID;
            strcpy( txcriteria , "ID" );
            ARG_INC;
        } else if (strcmp ("-vcriteria", argv[0]) == 0 || 
            strcmp ("-vcrit", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -vcriteria flag requires an argument.\n");
            if (strcmp ("EXACT", argv[1]) == 0) {
                vis_criteria = AUX_EXACT_MATCH;
                strcpy( txcriteria , "EXACT" );
            } else if (strcmp ("MIN", argv[1]) == 0) {
                vis_criteria = AUX_MINIMUM_CRITERIA;
                strcpy( txcriteria , "MINIMUM" );
            }
            ARG_INC;
        } else if (strcmp ("-singlebuffer", argv[0]) == 0 || 
            strcmp ("-sb", argv[0]) == 0) {
            renderDoubleBuffer = VP_FALSE;
        } else if (strcmp ("-ortho", argv[0]) == 0 || 
            strcmp ("-or", argv[0]) == 0) {
            orthomode = VP_TRUE;
        } else if (strcmp ("-nodither", argv[0]) == 0 || 
            strcmp ("-ndi", argv[0]) == 0) {
            dithermode = VP_FALSE;
        } else if (strcmp ("-blend", argv[0]) == 0 || 
            strcmp ("-bl", argv[0]) == 0) {
            blendmode = VP_TRUE;
        } else if (strcmp ("-zbuffer", argv[0]) == 0 || 
            strcmp ("-zb", argv[0]) == 0) {
            zbuffermode = VP_TRUE;
        } else if (strcmp ("-linestipple", argv[0]) == 0 || 
            strcmp ("-lp", argv[0]) == 0) {
            linestipplemode = VP_TRUE;
        } else if (strcmp ("-polystipple", argv[0]) == 0 || 
            strcmp ("-pp", argv[0]) == 0) {
            polystipplemode = VP_TRUE;
        } else if (strcmp ("-fog", argv[0]) == 0 || 
            strcmp ("-fg", argv[0]) == 0) {
            fogmode = VP_TRUE;
        } else if (strcmp ("-clip", argv[0]) == 0 || 
            strcmp ("-c", argv[0]) == 0) {
            clipmode = VP_TRUE;
        } else if (strcmp ("-lighttwoside", argv[0]) == 0 || 
            strcmp ("-l2s", argv[0]) == 0) {
            lighttwoside = GL_TRUE;
        } else if (strcmp ("-localview", argv[0]) == 0 || 
            strcmp ("-lv", argv[0]) == 0) {
            localviewmode = 1.0F;
        } else if (strcmp ("-toggle", argv[0]) == 0 || 
            strcmp ("-tg", argv[0]) == 0) {
            togglemode = VP_TRUE;
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -toggle flag requires an argument.\n");
            if (strcmp ("DEPTH_TEST", argv[1]) == 0) {
                renderblock.capability = GL_DEPTH_TEST;
                strcpy( txtoggle , "DEPTH_TEST" );
            } else if (strcmp ("DITHER", argv[1]) == 0) {
                renderblock.capability = GL_DITHER;
                strcpy( txtoggle , "DITHER" );
            } else if (strcmp ("LIGHTING", argv[1]) == 0) {
                renderblock.capability = GL_LIGHTING;
                strcpy( txtoggle , "LIGHTING" );
            } else if (strcmp ("LINE_STIPPLE", argv[1]) == 0) {
                renderblock.capability = GL_LINE_STIPPLE;
                strcpy( txtoggle , "LINE_STIPPLE" );
            } else if (strcmp ("BLEND", argv[1]) == 0) {
                renderblock.capability = GL_BLEND;
                strcpy( txtoggle , "BLEND" );
            } else if (strcmp ("POLYGON_STIPPLE", argv[1]) == 0) {
                renderblock.capability = GL_POLYGON_STIPPLE;
                strcpy( txtoggle , "POLYGON_STIPPLE" );
            } else if (strcmp ("LINE_WIDTH", argv[1]) == 0) {
                togglelinewidthmode = VP_TRUE;
                strcpy( txtoggle , "LINE_WIDTH" );
            } else if (strcmp ("MATRIX", argv[1]) == 0) {
                togglematrixmode = VP_TRUE;
                strcpy( txtoggle , "MATRIX" );
            }

            ARG_INC;
        } else if (strcmp ("-srcblendfunc", argv[0]) == 0 || 
            strcmp ("-sbf", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -srcblendfunc flag requires an argument.\n");
            if (strcmp ("ZERO", argv[1]) == 0) {
                sblendfunc = GL_ZERO;
                strcpy( txsblendfunc , "ZERO" );
            } else if (strcmp ("ONE", argv[1]) == 0) {
                sblendfunc = GL_ONE;
                strcpy( txsblendfunc , "ONE" );
            } else if (strcmp ("DST_COLOR", argv[1]) == 0) {
                sblendfunc = GL_DST_COLOR;
                strcpy( txsblendfunc , "DST_COLOR" );
            } else if (strcmp ("ONE_MINUS_DST_COLOR", argv[1]) == 0) {
                sblendfunc = GL_ONE_MINUS_DST_COLOR;
                strcpy( txsblendfunc , "ONE_MINUS_DST_COLOR" );
            } else if (strcmp ("SRC_ALPHA", argv[1]) == 0) {
                sblendfunc = GL_SRC_ALPHA;
                strcpy( txsblendfunc , "SRC_ALPHA" );
            } else if (strcmp ("ONE_MINUS_SRC_ALPHA", argv[1]) == 0) {
                sblendfunc = GL_ONE_MINUS_SRC_ALPHA;
                strcpy( txsblendfunc , "ONE_MINUS_SRC_ALPHA" );
            } else if (strcmp ("DST_ALPHA", argv[1]) == 0) {
                sblendfunc = GL_DST_ALPHA;
                strcpy( txsblendfunc , "DST_ALPHA" );
            } else if (strcmp ("ONE_MINUS_DST_ALPHA", argv[1]) == 0) {
                sblendfunc = GL_ONE_MINUS_DST_ALPHA;
                strcpy( txsblendfunc , "ONE_MINUS_DST_ALPHA" );
            } else if (strcmp ("SRC_ALPHA_SATURATE", argv[1]) == 0) {
                sblendfunc = GL_SRC_ALPHA_SATURATE;
                strcpy( txsblendfunc , "SRC_ALPHA_SATURATE" );
            }
            ARG_INC;
        } else if (strcmp ("-dstblendfunc", argv[0]) == 0 || 
            strcmp ("-dbf", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -dstblendfunc flag requires an argument.\n");
            if (strcmp ("ZERO", argv[1]) == 0) {
                dblendfunc = GL_ZERO;
                strcpy( txdblendfunc , "ZERO" );

            } else if (strcmp ("ONE", argv[1]) == 0) {
                dblendfunc = GL_ONE;
                strcpy( txdblendfunc , "ONE" );

            } else if (strcmp ("SRC_COLOR", argv[1]) == 0) {
                dblendfunc = GL_SRC_COLOR;
                strcpy( txdblendfunc , "SRC_COLOR" );

            } else if (strcmp ("ONE_MINUS_SRC_COLOR", argv[1]) == 0) {
                dblendfunc = GL_ONE_MINUS_SRC_COLOR;
                strcpy( txdblendfunc , "ONE_MINUS_SRC_COLOR" );

            } else if (strcmp ("SRC_ALPHA", argv[1]) == 0) {
                dblendfunc = GL_SRC_ALPHA;
                strcpy( txdblendfunc , "SRC_ALPHA" );

            } else if (strcmp ("ONE_MINUS_SRC_ALPHA", argv[1]) == 0) {
                dblendfunc = GL_ONE_MINUS_SRC_ALPHA;
                strcpy( txdblendfunc , "ONE_MINUS_SRC_ALPHA" );

            } else if (strcmp ("DST_ALPHA", argv[1]) == 0) {
                dblendfunc = GL_DST_ALPHA;
                strcpy( txdblendfunc , "DST_ALPHA" );

            } else if (strcmp ("ONE_MINUS_DST_ALPHA", argv[1]) == 0) {
                dblendfunc = GL_ONE_MINUS_DST_ALPHA;
                strcpy( txdblendfunc , "ONE_MINUS_DST_ALPHA" );
            }
            ARG_INC;
        } else if (strcmp ("-polysmooth", argv[0]) == 0 || 
            strcmp ("-ps", argv[0]) == 0) {
            polysmoothmode = VP_TRUE;
            sblendfunc = GL_SRC_ALPHA_SATURATE;
            strcpy( txsblendfunc , "SRC_ALPHA_SATURATE" );
            dblendfunc = GL_ONE;
            strcpy( txdblendfunc , "ONE" );
        } else if (strcmp ("-batch", argv[0]) == 0 || 
            strcmp ("-bt", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -batch flag requires an argument.\n");
            batchmode = VP_TRUE;
            numtobatch = atoi (argv[1]);
            ARG_INC;
        } else if (strcmp ("-colorper", argv[0]) == 0 || 
            strcmp ("-cp", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -colorper flag requires an argument.\n");
            if (strcmp ("FRAME", argv[1]) == 0) {
                colormode = COLOR_PER_FRAME;
                strcpy( txcolormode , "COLOR_PER_FRAME" );
            } else if (strcmp ("PRIMITIVE", argv[1]) == 0) {
                colormode = COLOR_PER_PRIMITIVE;
                strcpy( txcolormode , "COLOR_PER_PRIMITIVE" );
            } else if (strcmp ("VERTEX", argv[1]) == 0) {
                colormode = COLOR_PER_VERTEX;
                strcpy( txcolormode , "COLOR_PER_VERTEX" );
            }
            ARG_INC;
        } else if (strcmp ("-texcomp", argv[0]) == 0 || 
            strcmp ("-tc", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -texcomp flag requires an argument.\n");
            numcomp = atoi (argv[1]);
            if (numcomp < 1 || numcomp > 4)
                numcomp = 3;
            ARG_INC;
        } else if (strcmp ("-texenv", argv[0]) == 0 || 
            strcmp ("-te", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -texenv flag requires an argument.\n");
            if (strcmp ("MODULATE", argv[1]) == 0) {
                texenvmode = GL_MODULATE;
                strcpy( txenv , "MODULATE" );
            } else if (strcmp ("BLEND", argv[1]) == 0) {
                texenvmode = GL_BLEND;
                strcpy( txenv , "BLEND" );
            } else if (strcmp ("DECAL", argv[1]) == 0) {
                texenvmode = GL_DECAL;
                strcpy( txenv , "DECAL" );
            }
            ARG_INC;
        } else if (strcmp ("-texgen", argv[0]) == 0 || 
            strcmp ("-txg", argv[0]) == 0) {
            if (argc == 1)
                FATAL_ERROR ("viewperf: the -texgen flag requires an argument.\n");
            texgenmode = TXG_EYE_LINEAR;
            strcpy( txfile , argv[1]);
#ifdef SEARCHPATH
            {
                char* texpath = getenv("VPTEXPATH");
                char* dataPath;
                char  filenameptr[512];
                char* defaultPath = ".:./data/textures:/";
                if (texpath == 0)
                    texpath = defaultPath;
                else if (*texpath == 0)
                    texpath = defaultPath;
                if (txfile) {
                    strcpy(filenameptr, txfile);
                    dataPath = SearchPath(texpath, filenameptr);
                    if (dataPath == NULL)
                        FATAL_ERROR("Couldn't open texture file\n");
                    /* Add dataPath to the beginning of txfile */
                    strcat(dataPath, "/");
                    strcpy(txfile, strcat(dataPath, txfile));
                }
            }
#endif
            if ((texfile = fopen(txfile, BINARY_FILE) ) == 0) {
                FATAL_ERROR("Can't open texture file\n");
            }
            ARG_INC;
            if( (argc != 1) && (argv[1][0] != '-') )
            {
                if(!strcmp(argv[1], "OBJECT_LINEAR"))
                    texgenmode = TXG_OBJECT_LINEAR;
                else
                    if(!strcmp(argv[1], "SPHERE_MAP"))
                        texgenmode = TXG_SPHERE_MAP;
            }
        }
        else 
            if (strcmp ("-texture", argv[0]) == 0 || 
                strcmp ("-tx", argv[0]) == 0)
            {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -texture flag requires an argument.\n");
                texturemode = VP_TRUE;
                strcpy( txfile , argv[1]);
#ifdef SEARCHPATH
                {
                    char* texpath = getenv("VPTEXPATH");
                    char* dataPath;
                    char  filenameptr[512];
                    char* defaultPath = ".:./data/textures:/";
                    if (texpath == 0)
                        texpath = defaultPath;
                    else if (*texpath == 0)
                        texpath = defaultPath;
                    if (txfile) {
                        strcpy(filenameptr, txfile);
                        dataPath = SearchPath(texpath, filenameptr);
                        if (dataPath == NULL)
                            FATAL_ERROR("Couldn't open texture file\n");
                        /* Add dataPath to the beginning of txfile */
                        strcat(dataPath, "/");
                        strcpy(txfile, strcat(dataPath, txfile));
                    }
                }
#endif
                if ((texfile = fopen(txfile, BINARY_FILE) ) == 0) {
                    FATAL_ERROR("Can't open texture file\n");
                }
                ARG_INC;
            } 
            else if (strcmp ("-minfilter", argv[0]) == 0 || 
                strcmp ("-minf", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -minfilter flag requires an argument.\n");
                if (strcmp ("NEAREST", argv[1]) == 0) {
                    minfilter = GL_NEAREST;
                    strcpy( txmin , "NEAREST" );
                } else if (strcmp ("LINEAR", argv[1]) == 0) {
                    minfilter = GL_LINEAR;
                    strcpy( txmin , "LINEAR" );
                } else if (strcmp ("NEAREST_MIPMAP_NEAREST", argv[1]) == 0) {
                    minfilter = GL_NEAREST_MIPMAP_NEAREST;
                    strcpy( txmin , "NEAREST_MIPMAP_NEAREST" );
                } else if (strcmp ("LINEAR_MIPMAP_LINEAR", argv[1]) == 0) {
                    minfilter = GL_LINEAR_MIPMAP_LINEAR;
                    strcpy( txmin , "LINEAR_MIPMAP_LINEAR" );
                } else if (strcmp ("NEAREST_MIPMAP_LINEAR", argv[1]) == 0) {
                    minfilter = GL_NEAREST_MIPMAP_LINEAR;
                    strcpy( txmin , "NEAREST_MIPMAP_LINEAR" );
                } else if (strcmp ("LINEAR_MIPMAP_LINEAR", argv[1]) == 0) {
                    minfilter = GL_LINEAR_MIPMAP_LINEAR;
                    strcpy( txmin , "LINEAR_MIPMAP_LINEAR" );
                }
                ARG_INC;
            } 
            else if (strcmp ("-magfilter", argv[0]) == 0 || 
                strcmp ("-magf", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -magfilter flag requires an argument.\n");
                if (strcmp ("NEAREST", argv[1]) == 0) {
                    magfilter = GL_NEAREST;
                    strcpy( txmag , "NEAREST" );
                } else if (strcmp ("LINEAR", argv[1]) == 0) {
                    magfilter = GL_LINEAR;
                    strcpy( txmag , "LINEAR" );
                }
                ARG_INC;
            } 
            else if (strcmp ("-colormaterial", argv[0]) == 0 || 
                strcmp ("-cm", argv[0]) == 0) {
                if (argc < 3)
                    FATAL_ERROR ("viewperf: the -colormaterial flag requires 2 arguments.\n");
                if (strcmp ("FRONT", argv[1]) == 0) {
                    cmface = GL_FRONT;
                    strcpy( cmfaceString , "FRONT" );
                } else if (strcmp ("BACK", argv[1]) == 0) {
                    cmface = GL_BACK;
                    strcpy( cmfaceString , "BACK" );
                } else if (strcmp ("FRONT_AND_BACK", argv[1]) == 0) {
                    cmface = GL_FRONT_AND_BACK;
                    strcpy( cmfaceString , "FRONT_AND_BACK" );
                }
                if (strcmp ("EMISSION", argv[2]) == 0) {
                    cmmode = GL_EMISSION;
                    strcpy( cmmodeString , "EMISSION" );
                } else if (strcmp ("AMBIENT", argv[2]) == 0) {
                    cmmode = GL_AMBIENT;
                    strcpy( cmmodeString , "AMBIENT" );
                } else if (strcmp ("DIFFUSE", argv[2]) == 0) {
                    cmmode = GL_DIFFUSE;
                    strcpy( cmmodeString , "DIFFUSE" );
                } else if (strcmp ("SPECULAR", argv[2]) == 0) {
                    cmmode = GL_SPECULAR;
                    strcpy( cmmodeString , "SPECULAR" );
                } else if (strcmp ("AMBIENT_AND_DIFFUSE", argv[2]) == 0) {
                    cmmode = GL_AMBIENT_AND_DIFFUSE;
                    strcpy( cmmodeString , "AMBIENT_AND_DIFFUSE" );
                }
                ARG_INC;
            } 
            else if (strcmp ("-polymodefront", argv[0]) == 0 || 
                strcmp ("-pmf", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -polymodefront flag requires an argument.\n");
                if (strcmp ("FILL", argv[1]) == 0) {
                    polymodefront = GL_FILL;
                    strcpy( txpmf , "FILL" );
                } else if (strcmp ("POINT", argv[1]) == 0) {
                    polymodefront = GL_POINT;
                    strcpy( txpmf , "POINT" );
                } else if (strcmp ("LINE", argv[1]) == 0) {
                    polymodefront = GL_LINE;
                    strcpy( txpmf , "LINE" );
                }
                ARG_INC;
            } 
            else if (strcmp ("-polymodeback", argv[0]) == 0 || 
                strcmp ("-pmb", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -polymodeback flag requires an argument.\n");
                if (strcmp ("FILL", argv[1]) == 0) {
                    polymodeback = GL_FILL;
                    strcpy( txpmb , "FILL" );
                } else if (strcmp ("POINT", argv[1]) == 0) {
                    polymodeback = GL_POINT;
                    strcpy( txpmb , "POINT" );
                } else if (strcmp ("LINE", argv[1]) == 0) {
                    polymodeback = GL_LINE;
                    strcpy( txpmb , "LINE" );
                }
                ARG_INC;
            } 
            else if (strcmp ("-triangle", argv[0]) == 0 || 
                strcmp ("-tr", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -triangle flag requires an argument.\n");
                objnameptr = strcpy(objnameptr, argv[1]);
                inputmode = TRIINPUT;
                ARG_INC;
            } 
            else if (strcmp ("-quad", argv[0]) == 0 || 
                strcmp ("-qd", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -quad flag requires an argument.\n");
                objnameptr = strcpy(objnameptr, argv[1]);
                inputmode = QUADINPUT;
                ARG_INC;
            } 
            else if (strcmp ("-mesh", argv[0]) == 0 || 
                strcmp ("-mh", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -mesh flag requires an argument.\n");
                objnameptr = strcpy(objnameptr, argv[1]);
                inputmode = MESHINPUT;
                ARG_INC;
            } 
            else if (strcmp ("-polygon", argv[0]) == 0 || 
                strcmp ("-pg", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -polygon flag requires an argument.\n");
                objnameptr = strcpy(objnameptr, argv[1]);
                inputmode = POLYGONINPUT;
                ARG_INC;
            } 
            else if (strcmp ("-walkthru", argv[0]) == 0 || 
                strcmp ("-wt", argv[0]) == 0) {
                walkthrumode = VP_TRUE;
            } 
            else if (strcmp ("-linewidth", argv[0]) == 0 || 
                strcmp ("-lw", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -linewidth flag requires an argument.\n");
                linewidthmode = atof (argv[1]);
                ARG_INC;
            } 
            else if (strcmp ("-xwinsize", argv[0]) == 0 || 
                strcmp ("-xws", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -xwinsize flag requires an argument.\n");
                environ.windowWidth = atoi (argv[1]);
                ARG_INC;
            } 
            else if (strcmp ("-ywinsize", argv[0]) == 0 || 
                strcmp ("-yws", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -ywinsize flag requires an argument.\n");
                environ.windowHeight = atoi (argv[1]);
                ARG_INC;
            } 
            else if (strcmp ("-numframes", argv[0]) == 0 || 
                strcmp ("-nf", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -numframes flag requires an argument.\n");
                eventblock.numframes = atoi (argv[1]);
                if (eventblock.numframes <= 0)
                    FATAL_ERROR ("viewperf: You'll need more frames than this\n");
                ARG_INC;
            } 
            else if (strcmp ("-numilights", argv[0]) == 0 || 
                strcmp ("-nil", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -numilights flag requires an argument.\n");
                numInfiniteLights = atoi (argv[1]);
                if (numInfiniteLights < 0)
                    FATAL_ERROR ("viewperf: Number of infinite lights must be positive.\n");
                if (numInfiniteLights + numLocalLights > 8)
                    FATAL_ERROR ("viewperf: Total number of lights enabled must be less than or equal to 8.\n");
                ARG_INC;
            } 
            else if (strcmp ("-numllights", argv[0]) == 0 || 
                strcmp ("-nll", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -numllights flag requires an argument.\n");
                numLocalLights = atoi (argv[1]);
                if (numLocalLights < 0)
                    FATAL_ERROR ("viewperf: Number of local lights must be positive.\n");
                if (numInfiniteLights + numLocalLights > 8)
                    FATAL_ERROR ("viewperf: Total number of lights enabled must be less than or equal to 8.\n");
                ARG_INC;
            } 
            else if (strcmp ("-minperiod", argv[0]) == 0 || 
                strcmp ("-mp", argv[0]) == 0) {
                if (argc == 1)
                    FATAL_ERROR ("viewperf: the -minperiod flag requires an argument.\n");
                eventblock.minperiod = atof (argv[1]);
                ARG_INC;
#ifdef MP
            } 
            else if (strcmp ("-threads", argv[0]) == 0 ||
                strcmp ("-th", argv[0]) == 0) {
                if ((argc > 1) && (isdigit(*argv[1]))) {
                    eventblock.threads = atoi (argv[1]);
                    ARG_INC;
                } else {
                    eventblock.threads = numProcessors ();
                }
                if (eventblock.threads < 1)
                    FATAL_ERROR ("viewperf: the minimum number of threads is 1.\n");
#endif
            } 
            else if (strcmp ("-help", argv[0]) == 0 || 
                strcmp ("-usage", argv[0]) == 0 || 
                strcmp ("-h", argv[0]) == 0 || 
                strcmp ("-u", argv[0]) == 0) {
                fprintf (stdout, "viewperf version %s:\n", VERSION);
                fprintf (stdout, "\
Program options:\n\
-polygon -pg   <file>  : Viewpoint object to be used in the tests\n\
-triangle -tr  <file>  : Viewpoint object to be used in the tests\n\
-quad -qd      <file>  : Viewpoint object to be used in the tests\n\
-mesh -mh      <file>  : Mesh object to be used in the tests\n\
-rendermode -rm <mode> : POINT, VECTOR, LINE, POLYGON, TMESH, TFAN,\n\
                         TRIANGLE, or QUAD - default LINE\n\
-vcriteria -vcrit      : AUX Visual selection criteria - EXACT, MIN\n\
                         - default MIN\n\
-vid <id>              : Ask AUX for visual with ID = <id>\n\
-vaccum -vac           : Ask AUX for an accumulation buffer visual\n\
-valpha -val           : Ask AUX for an alpha buffer visual\n\
-vdepthbuffer -vz      : Ask AUX for a depth buffer visual\n\
-vstencil -vst         : Ask AUX for a stencil buffer visual\n\
-indirectrender -ir    : Render indirect - default direct\n\
-nodither -ndi         : Disable dithering\n\
-ortho -or             : Parallel/Orthographic projection - default Perspective\n\
-displaylist -dl       : Render with display list mode\n\
-colorper -cp  <mode>  : FRAME = Color per Frame,\n\
                       : PRIMITIVE = Color per Primitive,\n\
                       : VERTEX = Color per Vertex - default FRAME\n\
-texture -tx   <file>  : MTV image for texturing\n\
-texgen -txg <file> <mode> : <file> is MTV image for environment mapping\n\
                         <mode> is SPHERE_MAP, OBJECT_LINEAR, EYE_LINEAR\n\
                         - default EYE_LINEAR\n\
-magfilter -magf <flt> : NEAREST, LINEAR - default NEAREST\n\
-minfilter -minf <flt> : NEAREST, LINEAR, NEAREST_MIPMAP_NEAREST,\n\
                         LINEAR_MIPMAP_NEAREST, NEAREST_MIPMAP_LINEAR,\n\
                         LINEAR_MIPMAP_LINEAR - default NEAREST\n\
-texenv -te <env>      : Texture environment, MODULATE, DECAL, BLEND\n\
                         - default DECAL\n\
-texcomp -tc <num>     : Texture components where <num> is 1,2,3, or 4\n\
                       : -default 3\n\
");
                fprintf (stdout, "\
-blend -bl             : Enable Blending\n\
-srcblendfunc -sbf     : ZERO, ONE, DST_COLOR, ONE_MINUS_DST_COLOR, SRC_ALPHA,\n\
                         ONE_MINUS_SRC_ALPHA, DST_ALPHA, ONE_MINUS_DST_ALPHA,\n\
                         SRC_ALPHA_SATURATE - default SRC_ALPHA\n\
-dstblendfunc -dbf     : ZERO, ONE, SRC_COLOR, ONE_MINUS_SRC_COLOR, SRC_ALPHA,\n\
                         ONE_MINUS_SRC_ALPHA, DST_ALPHA, ONE_MINUS_DST_ALPHA,\n\
                         - default ONE_MINUS_SRC_ALPHA\n\
-linewidth -lw <width> : Linewidth for wire/vector tests - default 1.0\n\
-xwinsize -xws <side>  : Size of test windows X dimension - default 700\n\
-ywinsize -yws <side>  : Size of test windows Y dimension - default 700\n\
-numframes -nf <num>   : Number of frames to be rendered during measurement\n\
                         Takes priority over -mp\n\
-numilights -nil <num> : Turns on <num> infinite lights - default 0\n\
-numllights -nll <num> : Turns on <num> local lights - default 0\n\
");
                fprintf (stdout, "\
-colormaterial -cm <side> <mode> :\n\
                         <side> is FRONT, BACK, FRONT_AND_BACK - default FRONT\n\
                         <mode> is AMBIENT, DIFFUSE, EMISSION, SPECULAR,\n\
                         AMBIENT_AND_DIFFUSE - default AMBIENT_AND_DIFFUSE\n\
-backface -bf          : Cull Backfacing primitives - default off\n\
-frontface -ff         : Cull Frontfacing primitives - default off\n\
-singlebuffer -sb      : Single buffer mode\n\
-fog -fg               : Enable fog\n\
-linesmooth -ls        : Enable line antialiasing\n\
-polysmooth -ps        : Enable polygon antialiasing\n\
-facetnormal -fn       : Use facet normals when lighting\n\
-linestipple -lp       : Enable line stipple\n\
-polystipple -pp       : Enable polygon stipple\n\
-toggle -tg <cap>      : Toggle per primitive - BLEND, DEPTH_TEST, DITHER,\n\
                         LIGHTING, LINE_WIDTH, LINE_STIPPLE, POLYGON_STIPPLE,\n\
                         or MATRIX - multmatrix\n\
-batch -bt <num>       : Batch <num> primitives together per glBegin/glEnd\n\
                         Valid with POINT, VECTOR, TRIANGLE, and QUADS\n\
-polymodefront -pmf    : POINT, LINE, or FILL - default FILL\n\
-polymodeback  -pmb    : POINT, LINE, or FILL - default FILL\n\
-flat -f               : Set shademodel to FLAT - default GOURAUD\n\
-zbuffer -zb           : Enable zbuffer for tests - default off\n\
");
                fprintf (stdout, "\
-clip -c               : Align object on 3D clip boundary\n\
-lighttwoside -l2s     : Light both sides of model\n\
-localview -lv         : Define local viewer for lit tests\n\
-minperiod -mp <num>   : Set minimum testing period in seconds\n\
-mblur <num>           : Use motion blur with num being amount of decay\n\
-aa_multi <x> <r>      : Full scene antialiasing rendered x times at an\n\
                       : offset of r.  r should be tuned to the viewset\n\
-walkthru -wt          : Walkthru mode\n\
");
#ifdef MP
                fprintf (stdout, "\
-threads -th <num>     : Sets number of threads (no arg means 1 per processor)\n\
");
#endif
                exit(0);
            }
    }


    /*********************************************************************/
    /*                                                                   */
    /*                        Test Description                           */
    /*                                                                   */
    /*********************************************************************/


    strcpy( desc , "\0" );

    /* Input mode & Object */
    strcat( desc , inputmodetx[ inputmode ] );
    ptr=(ptr=strrchr(objnameptr,'/')) == NULL ? ptr=objnameptr : ++ptr;
    strcat( desc , ptr );
    strcat( desc , " ");

    /* -rm */
    strcat( desc , "-rm ");
    strcat(desc, rendermodetext[rendermode]);
    strcat( desc, " ");

    /* -cm */
    if (colormode != COLOR_PER_FRAME && numInfiniteLights + numLocalLights > 0) {
        cmenable = VP_TRUE;
    }

    /* -nf and -mp */
    if (eventblock.numframes > 0) {
        eventblock.minperiod = 0.0F;
        sprintf( tempstring , "-nf %d \0", eventblock.numframes);
        strcat( desc , tempstring );
    } else if (eventblock.minperiod != MIN_TEST_TIME) {
        if ((float)floor(eventblock.minperiod) == eventblock.minperiod) {
            int mp = (int)eventblock.minperiod;
            sprintf( tempstring , "-mp %d \0", mp);
            strcat( desc , tempstring );
        } else {
            sprintf( tempstring , "-mp %f \0", eventblock.minperiod);
            strcat( desc , tempstring );
        }
    }

    /* -cp */
    strcat( desc , "-cp ");
    strcat(desc, cptx[colormode]);

    strcat( desc , dr[environ.directRender]);
    strcat( desc , dl[displaylistmode]);
    strcat( desc , db[renderDoubleBuffer]);
    strcat( desc , zb[zbuffermode]);
    strcat( desc , fg[fogmode]);
    /* -bt */
    if ( numtobatch != 0 ) {
        sprintf( tempstring,"-bt %d \0",numtobatch);
        strcat( desc, tempstring );
    }
    strcat( desc , shade[shademodelmode == GL_FLAT]);
    /* -nil */
    if ( numInfiniteLights > 0 ) {
        sprintf( tempstring , "-nil %d \0", numInfiniteLights);
        strcat( desc , tempstring );
    }
    /* -nll */
    if ( numLocalLights > 0 ) {
        sprintf( tempstring , "-nll %d \0", numLocalLights);
        strcat( desc , tempstring );
    }
    if ( cmenable && ( cmface != GL_FRONT || cmmode != GL_AMBIENT_AND_DIFFUSE ) ) {
        sprintf( tempstring , "-cm %s %s \0", cmfaceString, cmmodeString);
        strcat( desc , tempstring );
    }
    strcat( desc , lv[(int)localviewmode]);
    strcat( desc , l2s[lighttwoside]);
    strcat( desc , or[orthomode]);
    strcat( desc , fn[facetnormalmode]);
    strcat( desc , bf[backfacemode]);
    strcat( desc , ff[frontfacemode]);
    strcat( desc , pp[polystipplemode]);
    strcat( desc , ps[polysmoothmode]);
    strcat( desc , lp[linestipplemode]);
    strcat( desc , ls[linesmoothmode]);
    /* -lw */
    if ( linewidthmode > 1.0 ) {
        sprintf( tempstring , "-lw %0.1f \0", linewidthmode);
        strcat( desc , tempstring );
    }
    strcat( desc , di[dithermode]);
    strcat( desc , clip[clipmode]);
    /* -pmf */
    if (strcmp("FILL", txpmf) != 0) {
        sprintf(tempstring,"-pmf %s \0",txpmf);
        strcat(desc,tempstring);
    }
    /* -pmb */
    if (strcmp("FILL", txpmb) != 0) {
        sprintf(tempstring,"-pmb %s \0",txpmb);
        strcat(desc,tempstring);
    }

    /* -tg */
    if (togglemode) {
        sprintf(tempstring,"-tg %s \0",txtoggle);
        strcat(desc,tempstring);
    }

    strcat( desc , bl[blendmode]);
    /* -sbf */
    if (strcmp("SRC_ALPHA",txsblendfunc)!=0) {
        sprintf(tempstring,"-sbf %s \0",txsblendfunc);
        strcat(desc,tempstring);
    }
    /* -dbf */
    if (strcmp("ONE_MINUS_SRC_ALPHA",txdblendfunc)!=0) {
        sprintf(tempstring,"-dbf %s \0",txdblendfunc);
        strcat(desc,tempstring);
    }
    /* -tx */
    if( texturemode )
    {
        ptr=(ptr=strrchr(txfile,'/')) == NULL ? ptr=txfile : ++ptr;
        sprintf(tempstring,"-tx %s ", ptr);
        strcat( desc , tempstring );
        if (strcmp("NEAREST", txmag) != 0) {
            sprintf(tempstring,"-magf %s \0",txmag);
            strcat(desc,tempstring);
        }
        if (strcmp("NEAREST", txmin) != 0) {
            sprintf(tempstring,"-minf %s \0",txmin);
            strcat(desc,tempstring);
        }
        if (strcmp("DECAL", txenv) != 0)   {
            sprintf(tempstring,"-te %s \0"  ,txenv);
            strcat(desc,tempstring);
        }
        if ( numcomp != 3)                 {
            sprintf(tempstring,"-tc %d \0"  ,numcomp);
            strcat(desc,tempstring);
        }
    }

    /* -txg */
    if( texgenmode )
    {
        ptr=(ptr=strrchr(txfile,'/')) == NULL ? ptr=txfile : ++ptr;
        sprintf(tempstring,"-txg %s %s ", ptr, texture_generation_mode[texgenmode]);
        strcat( desc , tempstring );
        if (strcmp("NEAREST", txmag) != 0) {
            sprintf(tempstring,"-magf %s \0",txmag);
            strcat(desc,tempstring);
        }
        if (strcmp("NEAREST", txmin) != 0) {
            sprintf(tempstring,"-minf %s \0",txmin);
            strcat(desc,tempstring);
        }
        if (strcmp("DECAL", txenv) != 0)   {
            sprintf(tempstring,"-te %s \0"  ,txenv);
            strcat(desc,tempstring);
        }
        if ( numcomp != 3)                 {
            sprintf(tempstring,"-tc %d \0"  ,numcomp);
            strcat(desc,tempstring);
        }
    }

    /*  -xws, -yws */
    if( environ.windowWidth != X_WINDOW_SIZE )  {
        sprintf( tempstring , "-xws %d ",environ.windowWidth);
        strcat( desc , tempstring );
    }
    if( environ.windowHeight != Y_WINDOW_SIZE )  {
        sprintf( tempstring , "-yws %d ",environ.windowHeight);
        strcat( desc , tempstring );
    }

    /* -vcrit */
    if ( vis_criteria == AUX_EXACT_MATCH ) strcat( desc , "-vcrit EXACT ");
    strcat( desc , vac[(vistype & AUX_ACCUM) == AUX_ACCUM]);
    strcat( desc , val[(vistype & AUX_ALPHA) == AUX_ALPHA]);
    strcat( desc , vz[(vistype & AUX_DEPTH) == AUX_DEPTH]);
    strcat( desc , vst[(vistype & AUX_STENCIL) == AUX_STENCIL]);

    /* -mblur */
    if(mblurmode) {
        sprintf( tempstring, "-mblur %f ", blur_amount);
        strcat( desc, tempstring);
    }

    /* -aa_multi */
    if(fsantimode) {
        sprintf(tempstring, "-aa_multi %d %f ", fsaredraw, fsajitter);
        strcat(desc, tempstring);
    }

    /* -walkthru */
    if(walkthrumode) {
        sprintf(tempstring, "-wt ");
        strcat(desc, tempstring);
    }

    /*********************************************************************/
    /*                                                                   */
    /*                      Open Window                                  */
    /*                                                                   */
    /*********************************************************************/

    /* if the user didn't select any visual buffers 
       then select some for him */

    if (vistype == 0) {
        if (zbuffermode)
            vistype |= AUX_DEPTH;
        if (blendmode && (sblendfunc == GL_DST_ALPHA ||
            sblendfunc == GL_ONE_MINUS_DST_ALPHA ||
            sblendfunc == GL_SRC_ALPHA_SATURATE ||
            dblendfunc == GL_DST_ALPHA ||
            dblendfunc == GL_ONE_MINUS_DST_ALPHA))
            vistype |= AUX_ALPHA;
    }

    /* Add these to what the user or viewperf selected */

    vistype |= AUX_RGB;
    vistype |= (renderDoubleBuffer) ? AUX_DOUBLE : AUX_SINGLE;
    vistype |= (environ.directRender) ? AUX_DIRECT : AUX_INDIRECT;

    /* set AUX visual selection criteria */

    auxInitDisplayModePolicy(vis_criteria);
    if (vis_criteria == AUX_USE_ID )
        auxInitDisplayModeID(vis_id);
    else
        auxInitDisplayMode(vistype);

    /* Open the window */

    auxInitPosition(0, 0, environ.windowWidth, environ.windowHeight);
    if (auxInitWindow("Viewperf") == GL_FALSE) {
        fprintf(stderr, "AUX couldn't find a visual matching the given criteria\n");
        auxQuit();
    }

    /* Begin Windowing System Dependent */
#ifdef WIN32
    eventblock.window = auxGetHWND();
    eventblock.display = auxGetHDC();
#elif !defined(OS2) && !defined(__amigaos__)
    eventblock.window = auxXWindow();
    eventblock.display = auxXDisplay();
#endif
    NullEnvironmentData(&environ);
    GetEnvironment(&environ);

    /* End Windowing System Dependent */

    /*********************************************************************/
    /*                                                                   */
    /*                      Render title screen                          */
    /*                                                                   */
    /*********************************************************************/

    glClearColor(0.0F, 0.0F, 0.0F, 1.0F);
    glDrawBuffer(GL_FRONT_AND_BACK);
    glClear(GL_COLOR_BUFFER_BIT);
    if (renderDoubleBuffer && environ.bufConfig.doubleBuffer)
        glDrawBuffer(GL_BACK);
    else
        glDrawBuffer(GL_FRONT);


    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0F, 1280.0F, 0.0F, 1024.0F, 1.0F, -1.0F);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glShadeModel(GL_SMOOTH);

    glBegin(GL_QUADS);
    glColor3f(1.0F, 0.9F, 0.3F);
    glVertex2f(0.0F, 0.0F);
    glColor3f(1.0F, 0.9F, 0.3F);
    glVertex2f(1280.0F, 0.0F);
    glColor3f(0.6F, 0.1F, 0.9F);
    glVertex2f(1280.0F, 1024.0F);
    glColor3f(0.6F, 0.1F, 0.9F);
    glVertex2f(0.0F, 1024.0F);
    glEnd();

    glLineWidth(4.0F);
    glColor3f(0.0F, 0.0F, 0.0F);
    DrawString("     OpenGL     ", 172.0F, 602.0F);
    glLineWidth(3.0F);
    glColor3f(1.0F, 1.0F, 0.0F);
    DrawString("     OpenGL     ", 170.0F, 600.0F);

    glLineWidth(4.0F);
    glColor3f(0.0F, 0.0F, 0.0F);
    DrawString("    Viewperf    ", 172.0F, 477.0F);
    glLineWidth(3.0F);
    glColor3f(0.0F, 1.0F, 0.0F);
    DrawString("    Viewperf    ", 170.0F, 475.0F);

    glLineWidth(4.0F);
    glColor3f(0.0F, 0.0F, 0.0F);
    DrawString("Loading Data Set", 172.0F, 352.0F);
    glLineWidth(3.0F);
    glColor3f(0.0F, 0.7F, 1.0F);
    DrawString("Loading Data Set", 170.0F, 350.0F);

    if (renderDoubleBuffer && environ.bufConfig.doubleBuffer)
        auxSwapBuffers();

    /* Create thread blocks */
    eventblock.tb = (struct ThreadBlock *)calloc(eventblock.threads,
        sizeof(struct ThreadBlock));

    /*********************************************************************/
    /*                                                                   */
    /*                        Read Data Set in                           */
    /*                                                                   */
    /*********************************************************************/

#ifdef SEARCHPATH
    if (inputmode != NOINPUT)
    {
        char* objpath = getenv("VPGEOMPATH");
        char* dataPath;
        char  filenameptr[512];
        char* defaultPath = ".:./data/geometry/object:./data/geometry/mesh:/";
        if (objpath == 0)
            objpath = defaultPath;
        else 
            if (*objpath == 0)
                objpath = defaultPath;
        if (objnameptr)
        {
            if (inputmode == MESHINPUT)
            {
                /* Look for objnameptr file in objpath */
                strcpy(filenameptr, objnameptr);
                strcat(filenameptr, extension[4]);
                dataPath = SearchPath(objpath, filenameptr);
                if (dataPath == NULL)
                {
                    FATAL_ERROR("Couldn't open mesh file\n");
                }
            }
            else 
            {
                /* Look for three files */
                for (i=0; i<3; i++)
                {
                    strcpy(filenameptr, objnameptr);
                    strcat(filenameptr, extension[i]);
                    dataPath = SearchPath(objpath, filenameptr);
                    if (dataPath == NULL)
                    {
                        fprintf(stdout, "%s\n", filenameptr);
                        FATAL_ERROR("Couldn't open input file\n");
                    }
                }
            }
            /* Add dataPath to the beginning of objnameptr */
            strcat(dataPath, "/");
            strcpy(objnameptr, strcat(dataPath, objnameptr));
        }
    }
#endif

    switch (inputmode) {
    case NOINPUT:
        fprintf(stderr, "No input file specified\n");
        exit(0);
        break;

    case POLYGONINPUT:
        polygoninput(objnameptr, &eventblock);
        if (texturemode)
            param_poly(&eventblock);
        break;

    case MESHINPUT:
        meshinput(objnameptr, &eventblock);
        if (texturemode)
            param_mesh(&eventblock);
        break;

    case TRIINPUT:
        triquadinput(objnameptr, 3, &eventblock);
        if (texturemode)
            param_poly(&eventblock);
        break;

    case QUADINPUT:
        triquadinput(objnameptr, 4, &eventblock);
        if (texturemode)
            param_poly(&eventblock);
        break;
    }

    if (walkthrumode) {
	walkthruinput(objnameptr, &eventblock);
    }

    /*********************************************************************/
    /*                                                                   */
    /*                      Output test info                             */
    /*                                                                   */
    /*********************************************************************/


    /*
         * Viewperf program information
         */
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Viewperf Version", VERSION);

    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Viewperf Arguments", cmdln);

    /*
         * Test Environment Information
         */
    PrintEnvironment(stdout, &environ, NULL, leader, nameWidth, NULL);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Visual Selection Criteria", txcriteria);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Number of Execution Threads", eventblock.threads);

    /*
         * General viewperf test information
         */
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Geometry File", objnameptr);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Input Mode", inputmodetx[ inputmode ]);
    fprintf(stdout, "%s%*s%f\n", leader, nameWidth,
        "Minimum Test Period", eventblock.minperiod);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Number of Frames", eventblock.numframes);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Number of Primitives", renderblock.np);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Number of Vertices per Frame", vertsperframe);
    fprintf(stdout, "%s%*s%f\n", leader, nameWidth,
        "Number of Vertices per Primitive",
        ((GLfloat) vertsperframe) / ((GLfloat) renderblock.np));
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Toggle Mode", txtoggle);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Batching Count", numtobatch);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Render Mode", rendermodetext[rendermode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Color per", txcolormode);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Orthographic Projection", falsetrue[orthomode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Display List", falsetrue[displaylistmode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Clip Geometry", falsetrue[clipmode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Walkthrough Mode", falsetrue[walkthrumode]);

    /*
         * Polygon information
         */
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Back Face Cull", falsetrue[backfacemode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Front Face Cull", falsetrue[frontfacemode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Front Polygon Mode", txpmf);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Back Polygon Mode", txpmb);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Polygon Stipple Enable", falsetrue[polystipplemode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Polygon Antialiasing Enable", falsetrue[polysmoothmode]);

    /*
         * Line information
         */
    fprintf(stdout, "%s%*s%f\n", leader, nameWidth,
        "Line Width", linewidthmode);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Line Stipple Enable", falsetrue[linestipplemode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Line Antialiasing Enable", falsetrue[linesmoothmode]);

    /*
         * Lighting/Shading information
         */
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Number of Infinite Lights", numInfiniteLights);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Number of Local Lights", numLocalLights);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Color Material Enable", falsetrue[(int)cmenable]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Color Material Face", cmfaceString);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Color Material Mode", cmmodeString);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Facet Normals", falsetrue[facetnormalmode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Two Sided Lighting Enable", falsetrue[(int)lighttwoside]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Local Viewer Enable", falsetrue[(int)localviewmode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Flat Shading", falsetrue[shademodelmode==GL_FLAT]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Fog Enable", falsetrue[fogmode]);

    /*
         * Texturing information
         */
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Texture Enable", falsetrue[texturemode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Texture Generation Mode", texture_generation_mode[texgenmode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Texture File", txfile);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Texture Minification Filter", txmin);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Texture Magnification Filter", txmag);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Texture Environment Mode", txenv);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Texture Components", numcomp);


    /*
         * Fragment Rasterization Information
         */
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Depth Test Enable", falsetrue[zbuffermode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Blend Enable", falsetrue[blendmode]);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Source Blend Function", txsblendfunc);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Destination Blend Function", txdblendfunc);
    fprintf(stdout, "%s%*s%s\n", leader, nameWidth,
        "Dithering Enable", falsetrue[dithermode]);
    fprintf(stdout, "%s%*s%f\n", leader, nameWidth,
        "Motion Blur Amount", blur_amount);
    fprintf(stdout, "%s%*s%d\n", leader, nameWidth,
        "Full Scene Antialiasing Redraws", fsaredraw);
    fprintf(stdout, "%s%*s%f\n", leader, nameWidth,
        "Full Scene Antialiasing Jitter Amount", fsajitter);

    FreeEnvironmentData(&environ);

    /*********************************************************************/
    /*                                                                   */
    /*  Compute address into jump table for each renderer                */
    /*                                                                   */
    /*********************************************************************/

    eventblock.teststring = desc;

    rfindex.word = 0;
    rfindex.bits.Texture = texturemode;

    switch (inputmode)
    {
    case MESHINPUT:
        switch (rendermode)
        {
        case POLYGONmode:
        case TFANmode:
        case TRImode:
        case QUADmode:
            fprintf(stderr, "Rendermode %s not available for mesh objects\n",
                rendermodetext[rendermode]);
            exit(0);
            break;
        case POINTmode:
            renderblock.mode = GL_POINTS;
            break;
        case VECTORmode:
            renderblock.mode = GL_LINES;
            break;
        case LINEmode:
            renderblock.mode = GL_LINE_STRIP;
            break;
        case TMESHmode:
            renderblock.mode = GL_TRIANGLE_STRIP; /* was GL_TRIANGLE_STRIP */
            break;
        }
        if (blendmode || polysmoothmode)
        {
            renderblock.ColorP = glColor4fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR4mode;
#endif
        }
        else 
        {
            renderblock.ColorP = glColor3fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR3mode;
#endif
        }
        if (togglemode)
        {
            if (rendermode == VECTORmode)
                rfindex.bits.RenderMode = BM_EXTERNAL_BY_TWO;
            else
                rfindex.bits.RenderMode = BM_EXTERNAL;
            if (togglelinewidthmode)
            {
                renderblock.externfunc = toggle_linewidth;
            }
            else if (togglematrixmode)
            {
                renderblock.externfunc = toggle_matrix;
            } else {
                renderblock.externfunc = toggle_capability;
            }
        } else {
            rfindex.bits.RenderMode = BatchTable[rendermode];
        }
        rfindex.bits.Color = colormode;
        if (numInfiniteLights + numLocalLights > 0) {
            if (facetnormalmode)
                rfindex.bits.Normal = FACET_NORMmode;
            else
                rfindex.bits.Normal = VERTEX_NORMmode;
        } else {
            rfindex.bits.Normal = NO_NORMmode;
        }
        eventblock.func = MeshTable[rfindex.word];

        /* Calculate per thread input data */
        k = eventblock.rb->np / eventblock.threads;
        tb = eventblock.tb;
        for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++) {
            tb->np = k;
            tb->msh = &eventblock.rb->msh[thread * k];
        }
        tb->np = eventblock.rb->np - (thread * k);
        tb->msh = &eventblock.rb->msh[thread * k];
        break;


    case POLYGONINPUT:
        switch (rendermode)
        {
        case TMESHmode:
        case TRImode:
        case QUADmode:
            fprintf(stderr, "Rendermode %s not available for polygonal objects\n", 
                rendermodetext[rendermode]);
            exit(0);
            break;
        case POINTmode:
            renderblock.mode = GL_POINTS;
            break;
        case VECTORmode:
            renderblock.mode = GL_LINES;
            break;
        case LINEmode:
            renderblock.mode = GL_LINE_LOOP;
            break;
        case POLYGONmode:
            renderblock.mode = GL_POLYGON;
            break;
        case TFANmode:
            renderblock.mode = GL_TRIANGLE_FAN;
            break;
        }
        if (blendmode || polysmoothmode)
        {
            renderblock.ColorP = glColor4fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR4mode;  
#endif
        }
        else 
        {
            renderblock.ColorP = glColor3fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR3mode; 
#endif
        }
        if (togglemode)
        {
            if (rendermode == VECTORmode)
                rfindex.bits.RenderMode = BM_EXTERNAL_BY_TWO;
            else
                rfindex.bits.RenderMode = BM_EXTERNAL;
            if (togglelinewidthmode)
            {
                renderblock.externfunc = toggle_linewidth;
            }
            else 
                if (togglematrixmode)
                {
                    renderblock.externfunc = toggle_matrix;
                }
                else 
                {
                    renderblock.externfunc = toggle_capability;
                }

            /* Calculate per thread input data */
            k = eventblock.rb->np / eventblock.threads;
            tb = eventblock.tb;
            for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
            {
                tb->np = k;
                tb->ply = &eventblock.rb->ply[thread * k];
            }
            tb->np = eventblock.rb->np - (thread * k);
            tb->ply = &eventblock.rb->ply[thread * k];

        }
        else 
        {
            if (batchmode)
            {

                /* Calculate per thread input data */
                k = eventblock.rb->np / eventblock.threads;
                tb = eventblock.tb;
                for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                {
                    tb->np = k;
                    tb->ply = &eventblock.rb->ply[thread * k];
                    if(numtobatch >= tb->np)
                    {
                        tb->batchnum = tb->np;
                        tb->batchgroups = 1;
                        tb->batchleftovers = 0;
                    }
                    else 
                    {
                        tb->batchnum = numtobatch;
                        tb->batchgroups = tb->np / numtobatch;
                        tb->batchleftovers = tb->np % numtobatch;
                    }
                }
                tb->np = eventblock.rb->np - (thread * k);
                tb->ply = &eventblock.rb->ply[thread * k];
                if(numtobatch >= tb->np)
                {
                    tb->batchnum = tb->np;
                    tb->batchgroups = 1;
                    tb->batchleftovers = 0;
                }
                else 
                {
                    tb->batchnum = numtobatch;
                    tb->batchgroups = tb->np / numtobatch;
                    tb->batchleftovers = tb->np % numtobatch;
                }

                rfindex.bits.RenderMode = BatchTable[rendermode];

            }
            else 
            {
                if (rendermode == VECTORmode)
                {

                    /* Calculate per thread input data */
                    k = eventblock.rb->np / eventblock.threads;
                    tb = eventblock.tb;
                    for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                    {
                        tb->np = k;
                        tb->ply = &eventblock.rb->ply[thread * k];
                        tb->batchnum = 1;
                        tb->batchgroups = tb->np;
                        tb->batchleftovers = 0;
                    }
                    tb->np = eventblock.rb->np - (thread * k);
                    tb->ply = &eventblock.rb->ply[thread * k];
                    tb->batchnum = 1;
                    tb->batchgroups = tb->np;
                    tb->batchleftovers = 0;
                    rfindex.bits.RenderMode = BM_BATCH_BY_TWO;
                }
                else 
                {

                    /* Calculate per thread input data */
                    k = eventblock.rb->np / eventblock.threads;
                    tb = eventblock.tb;
                    for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                    {
                        tb->np = k;
                        tb->ply = &eventblock.rb->ply[thread * k];
                    }
                    tb->np = eventblock.rb->np - (thread * k);
                    tb->ply = &eventblock.rb->ply[thread * k];
                    rfindex.bits.RenderMode = BM_NO_BATCH;
                }
            }
        }
        rfindex.bits.Color = colormode;
        if (numInfiniteLights + numLocalLights > 0)
        {
            if (facetnormalmode)
                rfindex.bits.Normal = FACET_NORMmode;
            else
                rfindex.bits.Normal = VERTEX_NORMmode;
        }
        else 
        {
            rfindex.bits.Normal = NO_NORMmode;
        }
        eventblock.func = PolyTable[rfindex.word];
        break;
    case TRIINPUT:
        switch (rendermode)
        {
        case TMESHmode:
        case QUADmode:
        case POLYGONmode:
            fprintf(stderr, "Rendermode %s not available for Triangle objects\n", 
                rendermodetext[rendermode]);
            exit(0);
            break;
        case POINTmode:
            renderblock.mode = GL_POINTS;
            break;
        case VECTORmode:
            renderblock.mode = GL_LINES;
            break;
        case LINEmode:
            renderblock.mode = GL_LINE_LOOP;
            break;
        case TRImode:
            renderblock.mode = GL_TRIANGLES;
            break;
        case TFANmode:
            renderblock.mode = GL_TRIANGLE_FAN;
            break;
        }
        if (blendmode || polysmoothmode)
        {
            renderblock.ColorP = glColor4fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR4mode; 
#endif
        }
        else 
        {
            renderblock.ColorP = glColor3fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR3mode; 
#endif
        }
        if (togglemode)
        {
            if (rendermode == VECTORmode)
                rfindex.bits.RenderMode = BM_EXTERNAL_BY_TWO;
            else
                rfindex.bits.RenderMode = BM_EXTERNAL;
            if (togglelinewidthmode)
            {
                renderblock.externfunc = toggle_linewidth;
            }
            else 
                if (togglematrixmode)
                {
                    renderblock.externfunc = toggle_matrix;
                }
                else 
                {
                    renderblock.externfunc = toggle_capability;
                }

            /* Calculate per thread input data */
            k = eventblock.rb->np / eventblock.threads;
            tb = eventblock.tb;
            for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
            {
                tb->np = k;
                tb->ply = &eventblock.rb->ply[thread * k];
            }
            tb->np = eventblock.rb->np - (thread * k);
            tb->ply = &eventblock.rb->ply[thread * k];
        }
        else 
        {
            if (batchmode)
            {
                /* Calculate per thread input data */
                k = eventblock.rb->np / eventblock.threads;
                tb = eventblock.tb;
                for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                {
                    tb->np = k;
                    tb->ply = &eventblock.rb->ply[thread * k];
                    if(numtobatch >= tb->np)
                    {
                        tb->batchnum = tb->np;
                        tb->batchgroups = 1;
                        tb->batchleftovers = 0;
                    }
                    else 
                    {
                        tb->batchnum = numtobatch;
                        tb->batchgroups = tb->np / numtobatch;
                        tb->batchleftovers = tb->np % numtobatch;
                    }
                }
                tb->np = eventblock.rb->np - (thread * k);
                tb->ply = &eventblock.rb->ply[thread * k];
                if(numtobatch >= tb->np)
                {
                    tb->batchnum = tb->np;
                    tb->batchgroups = 1;
                    tb->batchleftovers = 0;
                }
                else 
                {
                    tb->batchnum = numtobatch;
                    tb->batchgroups = tb->np / numtobatch;
                    tb->batchleftovers = tb->np % numtobatch;
                }
                rfindex.bits.RenderMode = BatchTable[rendermode];
            }
            else 
            {
                if (rendermode == VECTORmode)
                {
                    /* Calculate per thread input data */
                    k = eventblock.rb->np / eventblock.threads;
                    tb = eventblock.tb;
                    for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                    {
                        tb->np = k;
                        tb->ply = &eventblock.rb->ply[thread * k];
                        tb->batchnum = 1;
                        tb->batchgroups = tb->np;
                        tb->batchleftovers = 0;
                    }
                    tb->np = eventblock.rb->np - (thread * k);
                    tb->ply = &eventblock.rb->ply[thread * k];
                    tb->batchnum = 1;
                    tb->batchgroups = tb->np;
                    tb->batchleftovers = 0;
                    rfindex.bits.RenderMode = BM_BATCH_BY_TWO;
                }
                else 
                {

                    /* Calculate per thread input data */
                    k = eventblock.rb->np / eventblock.threads;
                    tb = eventblock.tb;
                    for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                    {
                        tb->np = k;
                        tb->ply = &eventblock.rb->ply[thread * k];
                    }
                    tb->np = eventblock.rb->np - (thread * k);
                    tb->ply = &eventblock.rb->ply[thread * k];
                    rfindex.bits.RenderMode = BM_NO_BATCH;
                }
            }
        }
        rfindex.bits.Color = colormode;
        if (numInfiniteLights + numLocalLights > 0)
        {
            if (facetnormalmode)
                rfindex.bits.Normal = FACET_NORMmode;
            else
                rfindex.bits.Normal = VERTEX_NORMmode;
        }
        else 
        {
            rfindex.bits.Normal = NO_NORMmode;
        }
        eventblock.func = TriTable[rfindex.word];
        break;
    case QUADINPUT:
        switch (rendermode)
        {
        case TMESHmode:
        case TRImode:
        case POLYGONmode:
            fprintf(stderr, "Rendermode %s not available for Quad objects\n", 
                rendermodetext[rendermode]);
            exit(0);
            break;
        case POINTmode:
            renderblock.mode = GL_POINTS;
            break;
        case VECTORmode:
            renderblock.mode = GL_LINES;
            break;
        case LINEmode:
            renderblock.mode = GL_LINE_LOOP;
            break;
        case QUADmode:
            renderblock.mode = GL_QUADS;
            break;
        case TFANmode:
            renderblock.mode = GL_TRIANGLE_FAN;
            break;
        }
        if (blendmode || polysmoothmode)
        {
            renderblock.ColorP = glColor4fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR4mode; 
#endif
        }
        else 
        {
            renderblock.ColorP = glColor3fv;
#ifdef FUNCTION_CALLS
            rfindex.bits.ColorVectorLength = COLOR3mode;  
#endif
        }
        if (togglemode)
        {
            if (rendermode == VECTORmode)
                rfindex.bits.RenderMode = BM_EXTERNAL_BY_TWO;
            else
                rfindex.bits.RenderMode = BM_EXTERNAL;
            if (togglelinewidthmode)
            {
                renderblock.externfunc = toggle_linewidth;
            }
            else 
                if (togglematrixmode)
                {
                    renderblock.externfunc = toggle_matrix;
                }
                else 
                {
                    renderblock.externfunc = toggle_capability;
                }

            /* Calculate per thread input data */
            k = eventblock.rb->np / eventblock.threads;
            tb = eventblock.tb;
            for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
            {
                tb->np = k;
                tb->ply = &eventblock.rb->ply[thread * k];
            }
            tb->np = eventblock.rb->np - (thread * k);
            tb->ply = &eventblock.rb->ply[thread * k];
        }
        else 
        {
            if (batchmode)
            {
                /* Calculate per thread input data */
                k = eventblock.rb->np / eventblock.threads;
                tb = eventblock.tb;
                for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                {
                    tb->np = k;
                    tb->ply = &eventblock.rb->ply[thread * k];
                    if(numtobatch >= tb->np)
                    {
                        tb->batchnum = tb->np;
                        tb->batchgroups = 1;
                        tb->batchleftovers = 0;
                    }
                    else 
                    {
                        tb->batchnum = numtobatch;
                        tb->batchgroups = tb->np / numtobatch;
                        tb->batchleftovers = tb->np % numtobatch;
                    }
                }
                tb->np = eventblock.rb->np - (thread * k);
                tb->ply = &eventblock.rb->ply[thread * k];
                if(numtobatch >= tb->np)
                {
                    tb->batchnum = tb->np;
                    tb->batchgroups = 1;
                    tb->batchleftovers = 0;
                }
                else 
                {
                    tb->batchnum = numtobatch;
                    tb->batchgroups = tb->np / numtobatch;
                    tb->batchleftovers = tb->np % numtobatch;
                }
                rfindex.bits.RenderMode = BatchTable[rendermode];
            }
            else 
            {
                if (rendermode == VECTORmode)
                {
                    /* Calculate per thread input data */
                    k = eventblock.rb->np / eventblock.threads;
                    tb = eventblock.tb;
                    for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                    {
                        tb->np = k;
                        tb->ply = &eventblock.rb->ply[thread * k];
                        tb->batchnum = 1;
                        tb->batchgroups = tb->np;
                        tb->batchleftovers = 0;
                    }
                    tb->np = eventblock.rb->np - (thread * k);
                    tb->ply = &eventblock.rb->ply[thread * k];
                    tb->batchnum = 1;
                    tb->batchgroups = tb->np;
                    tb->batchleftovers = 0;
                    rfindex.bits.RenderMode = BM_BATCH_BY_TWO;
                }
                else 
                {

                    /* Calculate per thread input data */
                    k = eventblock.rb->np / eventblock.threads;
                    tb = eventblock.tb;
                    for (thread = 0; thread < (eventblock.threads - 1); thread++, tb++)
                    {
                        tb->np = k;
                        tb->ply = &eventblock.rb->ply[thread * k];
                    }
                    tb->np = eventblock.rb->np - (thread * k);
                    tb->ply = &eventblock.rb->ply[thread * k];
                    rfindex.bits.RenderMode = BM_NO_BATCH;
                }
            }
        }
        rfindex.bits.Color = colormode;
        if (numInfiniteLights + numLocalLights > 0)
        {
            if (facetnormalmode)
                rfindex.bits.Normal = FACET_NORMmode;
            else
                rfindex.bits.Normal = VERTEX_NORMmode;
        }
        else 
        {
            rfindex.bits.Normal = NO_NORMmode;
        }
        eventblock.func = QuadTable[rfindex.word];
        break;
    }
    eventblock.jitter = jitter;
    eventblock.redraws = fsaredraw;
    eventblock.blur_frames = blur_amount;
    eventblock.doubleBuffer = renderDoubleBuffer && environ.bufConfig.doubleBuffer;
    eventblock.clip = clipmode;
    eventblock.zbuffer = zbuffermode;

    /* Copy rest of RenderBlock information into ThreadBlock */
    tb = eventblock.tb;
    for (thread = 0; thread < eventblock.threads; thread++, tb++)
    {
        tb->mode = eventblock.rb->mode;
        tb->capability = eventblock.rb->capability;
        tb->ColorP = eventblock.rb->ColorP;
        tb->externfunc = eventblock.rb->externfunc;
        tb->vert = eventblock.rb->vert;
        tb->vnorm = eventblock.rb->vnorm;
        tb->texture = eventblock.rb->texture;
        tb->vcolor = eventblock.rb->vcolor;
    }

    /*********************************************************************/
    /*                                                                   */
    /*  Compute address into jump table for eventloop                    */
    /*                                                                   */
    /*********************************************************************/

    elindex.word = 0;
    elindex.bits.Walkthru = walkthrumode;
    elindex.bits.FSAA = fsantimode;
    elindex.bits.BlurMode = mblurmode;
    elindex.bits.DisplayList = displaylistmode;

    eventloop = EventTable[elindex.word];

    /*********************************************************************/
    /*                                                                   */
    /*  Load Texture Image                                               */
    /*                                                                   */
    /*********************************************************************/

    if (texturemode || texgenmode) {
        k = 0;
        do
        {
            fread(&header[k], 1, 1, texfile);
            ++k;
        }    while ((header[k-1] != 0) && (header[k-1] != 10));

        for (i = 0; i < k; i++)
            if (header[i] == ' ')
            {
                header[i] = 0;
                depth = &header[i+1];
                break;
            }

        xpix = atoi(header);
        ypix = atoi(depth);

        numpix = xpix * ypix;
        Image = (unsigned char *) malloc ( numpix * 3 );
        TextureImage = (unsigned char *) malloc(numpix * numcomp);

        fread(Image, 3, numpix, texfile);
        fclose(texfile);

        switch (numcomp)
        {
        case 1 :
            i = 0;
            for (j = 0; j < numpix * 3; j += 3)
            {
                TextureImage[i++] = Image[j+1];
            }
            break;
        case 2 :
            i = 0;
            for (j = 0; j < numpix * 3; j += 3)
            {
                TextureImage[i++] = Image[j];
                TextureImage[i++] = 0x77;
            }
            break;
        case 3 :
            i = 0;
            for (j = 0; j < numpix * 3; j += 3)
            {
                TextureImage[i++] = Image[j];
                TextureImage[i++] = Image[j+1];
                TextureImage[i++] = Image[j+2];
            }
            break;
        case 4 :
            i = 0;
            for (j = 0; j < numpix * 3; j += 3)
            {
                TextureImage[i++] = Image[j];
                TextureImage[i++] = Image[j+1];
                TextureImage[i++] = Image[j+2];
                TextureImage[i++] = 0x77;
            }
            break;
        }
        free(Image);
    }

    /*********************************************************************/
    /*                                                                   */
    /*                     Begin Rendering                               */
    /*                                                                   */
    /*********************************************************************/

#ifdef WIN32
    eventblock.tb[0].dc = eventblock.display;
    eventblock.tb[0].rc = wglGetCurrentContext();
#endif

    /* Initialize the contexts in the reverse order so that this thread
     * ends up with its own context current.
     */
#ifdef MP
    for (thread = (eventblock.threads - 1); thread >= 0; thread--) {
#if defined(WIN32)
        if (eventblock.tb[thread].rc == NULL)
            eventblock.tb[thread].rc = wglCreateContext(eventblock.display);
        wglMakeCurrent(eventblock.display, eventblock.tb[thread].rc);
#elif defined(SOME_OTHER_OS)
        /* Put os specific code to:
            Create Context
            Make context current
        */
#endif
#endif
        if (linesmoothmode) {
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            glEnable(GL_BLEND);
            glEnable(GL_LINE_SMOOTH);
        }
        if (polysmoothmode) {
            glClearColor(0.0F, 0.0F, 0.0F, 0.0F);
            glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
            glColor4f(1.0F, 1.0F, 1.0F, 1.0F);
            glBlendFunc(sblendfunc, dblendfunc);
            glEnable(GL_BLEND);
            glEnable(GL_POLYGON_SMOOTH);
        }
        if (blendmode) {
            glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
            glColor4f(1.0F, 1.0F, 1.0F, 0.5F);
            glBlendFunc(sblendfunc, dblendfunc);
            glEnable(GL_BLEND);
        } else {
            glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_FALSE);
            glColor3f(1.0F, 1.0F, 1.0F);
        }

        if (dithermode) {
            glEnable(GL_DITHER);
        } else {
            glDisable(GL_DITHER);
        }

        glPolygonMode(GL_FRONT, polymodefront);
        glPolygonMode(GL_BACK, polymodeback);

        if (linestipplemode) {
            glLineStipple(1, 0xf0f0);
            glEnable(GL_LINE_STIPPLE);
        }

        if (polystipplemode) {
            glPolygonStipple((const GLubyte *) stipple);
            glEnable(GL_POLYGON_STIPPLE);
        }
        glShadeModel(shademodelmode);
        if (zbuffermode) {
            glEnable(GL_DEPTH_TEST);
            glDepthFunc(GL_LESS);
            glDepthMask(GL_TRUE);
        } else {
            glDisable(GL_DEPTH_TEST);
            glDepthMask(GL_FALSE);
        }
        if (backfacemode) {
            glCullFace(GL_BACK);
            glEnable(GL_CULL_FACE);
        }
        if (frontfacemode) {
            glCullFace(GL_FRONT);
            glEnable(GL_CULL_FACE);
        }
        if (frontfacemode && backfacemode) {
            glCullFace(GL_FRONT_AND_BACK);
            glEnable(GL_CULL_FACE);
        }
        glLineWidth(linewidthmode);
        if (fogmode) {
            glFogf(GL_FOG_START, eventblock.trans[3] * ZTRANS_SCALE - maxdim);
            glFogf(GL_FOG_END, eventblock.trans[3] * ZTRANS_SCALE + maxdim);
            glFogf(GL_FOG_MODE, GL_LINEAR);
            glEnable(GL_FOG);
        }

        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
	if (walkthrumode) {
	    if (orthomode) {
		/* This will NOT work well, need to do something else... */
	        glOrtho(-maxdim / 1.1F, maxdim / 1.1F, -maxdim / 1.1F, maxdim / 1.1F,
                trans[3] * ZTRANS_SCALE - maxdim, trans[3] * ZTRANS_SCALE + maxdim);
	    } else {
		/* Quite arbitrary FOV, near and far planes, need something better */
	        gluPerspective(60.0, environ.windowWidth/environ.windowHeight, 1.0, 1000.0);
	    }
	} else {
        if (orthomode) {
            glOrtho(-maxdim / 1.1F, maxdim / 1.1F, -maxdim / 1.1F, maxdim / 1.1F,
                trans[3] * ZTRANS_SCALE - maxdim, trans[3] * ZTRANS_SCALE + maxdim);
        } else {
            glFrustum(-maxdim / 1.6F, maxdim / 1.6F, -maxdim / 1.6F, maxdim / 1.6F, 
                trans[3] * ZTRANS_SCALE - maxdim, trans[3] * ZTRANS_SCALE + maxdim);
        }
	}

        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();

        SetLightingState(numInfiniteLights, numLocalLights, localviewmode, lighttwoside, 
                         cmenable, cmface, cmmode, blendmode);

        if (texturemode || texgenmode) {
            switch (numcomp) {
            case 1:
                if (gluBuild2DMipmaps(GL_TEXTURE_2D, numcomp, xpix, 
                    ypix, GL_LUMINANCE, GL_UNSIGNED_BYTE, TextureImage) != 0) {
                    fprintf(stderr, "Mipmaps didn't build\n");
                    exit(0);
                }
                break;
            case 2:
                if (gluBuild2DMipmaps(GL_TEXTURE_2D, numcomp, xpix, 
                    ypix, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, TextureImage) != 0) {
                    fprintf(stderr, "Mipmaps didn't build\n");
                    exit(0);
                }
                break;
            case 3:
                if (gluBuild2DMipmaps(GL_TEXTURE_2D, numcomp, xpix, 
                    ypix, GL_RGB, GL_UNSIGNED_BYTE, TextureImage) != 0) {
                    fprintf(stderr, "Mipmaps didn't build\n");
                    exit(0);
                }
                break;
            case 4:
                if (gluBuild2DMipmaps(GL_TEXTURE_2D, numcomp, xpix, 
                    ypix, GL_RGBA, GL_UNSIGNED_BYTE, TextureImage) != 0) {
                    fprintf(stderr, "Mipmaps didn't build\n");
                    exit(0);
                }
                break;
            }
            glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, texenvmode);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magfilter);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minfilter);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
            if(texgenmode) {
                switch(texgenmode) {
                case TXG_NO_TEX_GEN:
                    FATAL_ERROR("Hoseage has occurred in texture generation\n");
                    break;
                case TXG_EYE_LINEAR:
                    glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_EYE_LINEAR); /* Was GL_EYE_LINEAR */
                    glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_EYE_LINEAR);
                    break;
                case TXG_OBJECT_LINEAR:
                    glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
                    glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
                    break;
                case TXG_SPHERE_MAP:
                    glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
                    glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_SPHERE_MAP);
                    break;
                }
                glEnable(GL_TEXTURE_GEN_S);
                glEnable(GL_TEXTURE_GEN_T);

                glMatrixMode(GL_TEXTURE);
                glRotatef(180.0F, 0.0F, 0.0F, 1.0F);
                glTranslatef(0.5F, 0.5F, 0.0F);
                glScalef(1.0F / (maxdim * 2.0F), 1.0F / (maxdim * 2.0F), 1.0F / (maxdim * 2.0F));
                glMatrixMode(GL_MODELVIEW);
            }
            glEnable(GL_TEXTURE_2D);
            glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
        }
#ifdef MP
    }
#endif

    /*********************************************************************/
    /*                                                                   */
    /*  Run the tests by calling the eventloop                           */
    /*                                                                   */
    /*********************************************************************/


#ifdef MP
    tb = &eventblock.tb[1];
    for (thread = 1; thread < eventblock.threads; thread++, tb++)
    {
#if defined(WIN32)
        tb->startEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
        tb->doneEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
        tb->threadHandle = CreateThread(NULL, 0,
            (LPTHREAD_START_ROUTINE)eventloop, (LPVOID)thread, 0,
            &tb->threadId);
#elif defined(SOME_OTHER_OS)
        /* Put os specific code to:
            Create synchronization events for each thread
            Create each thread
            Call eventloop() with thread number
        */
#endif
    }
#endif

    (*eventloop)(0);

#ifdef MP
    tb = &eventblock.tb[1];
    for (thread = 1; thread < eventblock.threads; thread++, tb++)
    {
#if defined(WIN32)
        TerminateThread(tb->threadHandle, 0);
#elif defined(SOME_OTHER_OS)
        /* Put os specific code to:
            Terminate threads
        */
#endif
    }
#endif

    fprintf(stdout, "=============================================================\n");

#ifdef WIN32
    fclose(LogFile);
#endif

    auxQuit();
}


#ifdef WIN32
int print_log (FILE *fo, const char *format, ...)
{
    int count;
    va_list args;

    va_start(args, format);
    count = vfprintf(LogFile, format, args);
    fflush(LogFile);
    va_end(args);
    return count;
}
#endif

#ifdef MP
int numProcessors ()
{
#if defined(WIN32)
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    return (si.dwNumberOfProcessors);

#elif defined(SOME_OTHER_OS)
    /* Put os specific code to:
        Return number of processors                
    */
#endif
}
#endif
