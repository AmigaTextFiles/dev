#include <graphics/rastport.h>
#include <graphics/scale.h>
#include <exec/exec.h>

#include <proto/Amigamesa.h>
#include <proto/graphics.h>

#include <mui/GLArea_mcc.h>
#include <mui/ImageDB_mcc.h>


//--- GL stubs
void glTexImage2D_stub (struct GLContext *glcontext, GLenum target, GLint level, GLint internalFormat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glTexImage2D (target,level,internalFormat,width,height,border,format,type,pixels);
}

void gluOrtho2D_stub (struct GLContext *glcontext, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top) {
   struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;

   gluOrtho2D(left,right,bottom,top);
}

//-- Graphics stubs
void BltBitMap_stub(struct BitMap *source,int sx,int sy,struct BitMap *dest,int dx,int dy,int width,int height,int minterm, int mask) {
    BltBitMap(source,sx,sy,dest,dx,dy,width,height,minterm,mask,NULL);
}
/****************************************************************************************/
/*                               OPENGL STANDARD FUNCTIONS                              */
/****************************************************************************************/
int GLArea_InitFunc(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
   struct Library *gluBase=glcontext->glu_Base;
   struct Library *glutBase=glcontext->glut_Base;
   GLfloat lightDirection[4]={5.0,5.0,5.0,1.0};
   GLfloat diffuseColor[4]={1.0,1.0,1.0,1.0};
   GLfloat ambientColor[4]={0.2,0.2,0.2,1.0};

   glLightModeli (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
   // glLightModeli (GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
   glEnable (GL_DEPTH_TEST);
   glEnable (GL_LIGHTING);
   glShadeModel(GL_SMOOTH);
   glLightfv (GL_LIGHT0,GL_AMBIENT,ambientColor);
   glLightfv (GL_LIGHT0,GL_DIFFUSE,diffuseColor);
   glLightfv (GL_LIGHT0,GL_POSITION,lightDirection);
   glEnable (GL_LIGHT0);
   glFrontFace(GL_CCW);
   glDisable(GL_CULL_FACE);
   glDisable(GL_LIGHT1);
   glDisable(GL_LIGHT2);
   glDisable(GL_LIGHT3);
   glDisable(GL_LIGHT4);
   glDisable(GL_DITHER);
   glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
   glEnable (GL_NORMALIZE);
   glClearColor(0.0,0.0,0.0,1.0);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   glMatrixMode (GL_PROJECTION);
   glLoadIdentity();
   gluPerspective (40.0,1.333,0.1,6000.0);
   glMatrixMode (GL_MODELVIEW);
   glLoadIdentity();
   // glFlush();
   return 0;
}

int GLArea_DrawImage(struct GLContext *glcontext, struct GLImage *glimage) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    if (glimage) {
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D_stub(glcontext,0.0,glimage->width,0.0,glimage->height);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glRasterPos2i(0,0);
	glDrawPixels(glimage->width,glimage->height,GL_RGB,GL_UNSIGNED_BYTE,glimage->image);
    };
    if (CheckSignal(SIGBREAKF_CTRL_D)) return 1;
    return 0;
}

/*
void GLArea_MUI_InitGLTexture(struct GLContext *glcontext, struct GLTex *gltex) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;

    AmigaMesaMakeCurrent(glcontext->context,glcontext->context->buffer);
    glBindTexture(GL_TEXTURE_2D,gltex->glid);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGBA,gltex->width,gltex->height,0,GL_RGBA,GL_UNSIGNED_BYTE,gltex->image);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D,gltex->glid);
}
*/

/****************************************************************************************/
/*                                  USEFUL FUNCTIONS                                    */
/****************************************************************************************/
/*
Object *GLArea_MUI_LoadDT(char *filename) {
    Object *dto=NULL;
    // struct Screen *wbscreen=NULL;

    // wbscreen=LockPubScreen("Workbench");
    dto=NewDTObject(filename,
		    DTA_GroupID, GID_PICTURE,
		    OBP_Precision, PRECISION_EXACT,
		    PDTA_FreeSourceBitMap, TRUE,
		    // PDTA_Remap, TRUE,
		    // PDTA_Screen, wbscreen,
		    PDTA_DestMode, PMODE_V43,
		    // PDTA_SourceMode, PMODE_V43,
		    PDTA_UseFriendBitMap, TRUE,
		    TAG_DONE);
    // UnlockPubScreen("Workbench",wbscreen);
    return dto;
}
*/
