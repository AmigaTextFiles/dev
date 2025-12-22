#ifdef WIN32
#include <windows.h>
#endif
#include <GL/gl.h>
#include "vpDefine.h"
#include "viewperf.h"

void FUNCTION(struct ThreadBlock *tb) 
{
  int meshnum,vertnum;
  int numverts;
  int meshcount = tb->np;
  GLenum mode = tb->mode;
#ifdef EXTERNAL
  GLenum capability = tb->capability;
  void (*lExternfunc)(GLenum) = tb->externfunc;
#endif
  struct mesh *pmsh=tb->msh;
  struct vector *pvert;

#ifndef FUNCTION_CALLS
#ifdef WIN32
  void (APIENTRY *glVertex3fvP)(const GLfloat *);
#else
  void (*glVertex3fvP)(const GLfloat *);
#endif
#endif  

#if defined(FACET_NORM) || defined(VERT_NORM)
  struct vector *pnorm;
#ifndef FUNCTION_CALLS
#ifdef WIN32
  void (APIENTRY *glNormal3fvP)(const GLfloat *);
#else
  void (*glNormal3fvP)(const GLfloat *);
#endif
#endif /* ifndef FUNCTION_CALLS */
#endif 

#if defined(FACET_COLOR) || defined(VERT_COLOR)
  struct colorvector *pvcolor;
#ifndef FUNCTION_CALLS
#ifdef WIN32
  void (APIENTRY *glColorP)(const GLfloat *);
#else
  void (*glColorP)(const GLfloat *);
#endif
#endif /* ifndef FUNCTION_CALLS */
#endif 

#ifdef TEXTURE
  struct vector *ptexture;
#ifndef FUNCTION_CALLS
#ifdef WIN32
  void (APIENTRY *glTexCoord2fvP)(const GLfloat *);
#else
  void (*glTexCoord2fvP)(const GLfloat *);
#endif
#endif  /* ifndef FUNCTION_CALLS */
#endif 

#ifndef FUNCTION_CALLS
#ifdef  TEXTURE
  glTexCoord2fvP = glTexCoord2fv;
#endif
#if defined(FACET_COLOR) || defined(VERT_COLOR)
  glColorP = tb->ColorP;
#endif
#if defined(FACET_NORM) || defined(VERT_NORM)
  glNormal3fvP = glNormal3fv;
#endif
  glVertex3fvP = glVertex3fv;
#endif  

 
        for(meshnum=meshcount-1;meshnum>=0;meshnum--) {
		numverts = pmsh[meshnum].numverts;
		pvert = pmsh[meshnum].verts;
#if defined(FACET_NORM) || defined(VERT_NORM)
      pnorm = pmsh[meshnum].norms;
#endif
#if defined(FACET_COLOR) || defined(VERT_COLOR)
      pvcolor = pmsh[meshnum].vcolor;
#endif
#ifdef TEXTURE
      ptexture = pmsh[meshnum].texture;
#endif
#ifdef EXTERNAL
      lExternfunc(capability);
#endif
#if   defined(FACET_COLOR) && !defined(FUNCTION_CALLS)
      (*glColorP)((const GLfloat *) (pvcolor));
#elif defined(FACET_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
      glColor3fv((const GLfloat *) (pvcolor));
#elif defined(FACET_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
      glColor4fv((const GLfloat *) (pvcolor));
#endif
#if    defined(FACET_NORM) && !defined(FUNCTION_CALLS)
      (*glNormal3fvP)((const GLfloat *) (pnorm));
#elif  defined(FACET_NORM) &&  defined(FUNCTION_CALLS) 
      glNormal3fv((const GLfloat *) (pnorm));
#endif
      glBegin(mode);

#ifdef BY_TWO
                for(vertnum=numverts-2;vertnum>=0;vertnum--) {
#else
                for(vertnum=numverts-1;vertnum>=0;vertnum--) {
#endif

#if   defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
	  (*glColorP)((const GLfloat *) (pvcolor));
#elif defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
	  glColor3fv((const GLfloat *) (pvcolor));
#elif defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
	  glColor4fv((const GLfloat *) (pvcolor));
#endif
#if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
	  (*glTexCoord2fvP)((const GLfloat *) (ptexture));
#elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS)
	  glTexCoord2fv((const GLfloat *) (ptexture));
#endif
#if    defined(VERT_NORM) && !defined(FUNCTION_CALLS)
	  (*glNormal3fvP)((const GLfloat *) (pnorm));
#elif  defined(VERT_NORM) &&  defined(FUNCTION_CALLS)
	  glNormal3fv((const GLfloat *) (pnorm));
#endif
#ifdef FUNCTION_CALLS
	  glVertex3fv((const GLfloat *) (pvert));
#else 
	  (*glVertex3fvP)((const GLfloat *) (pvert));
#endif


#ifdef BY_TWO
  #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
                	(*glColorP)((const GLfloat *) (pvcolor+1));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
                	glColor3fv((const GLfloat *) (pvcolor+1));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
                	glColor4fv((const GLfloat *) (pvcolor+1));
  #endif
  #if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
                        (*glTexCoord2fvP)((const GLfloat *) (ptexture+1));
  #elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS)
                        glTexCoord2fv((const GLfloat *) (ptexture+1));
  #endif
  #if    defined(VERT_NORM) && !defined(FUNCTION_CALLS)
                        (*glNormal3fvP)((const GLfloat *) (pnorm+1));
  #elif  defined(VERT_NORM) &&  defined(FUNCTION_CALLS)
                        glNormal3fv((const GLfloat *) (pnorm+1));
  #endif
  #ifdef FUNCTION_CALLS
                        glVertex3fv((const GLfloat *) (pvert+1));
  #else
                        (*glVertex3fvP)((const GLfloat *) (pvert+1));
  #endif
#endif

#ifdef VERT_COLOR
	  pvcolor += 1;
#endif
#ifdef TEXTURE
	  ptexture += 1;
#endif
#ifdef VERT_NORM
	  pnorm += 1;
#endif
	  pvert += 1;

	}
      glEnd();
    }
}
  
