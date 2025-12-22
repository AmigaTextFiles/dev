#ifdef WIN32
#include <windows.h>
#endif

#include <GL/gl.h>
#include "viewperf.h"
#include "vpDefine.h"

void FUNCTION(struct ThreadBlock *tb) 
{
  int polyi,verti;
  int numverts;
  int polycount = tb->np;
  int *vertindex;
  GLenum mode = tb->mode;
#ifdef BATCH
  int groupi;
  int batchi;
  int leftoveri;
  int batchcount = tb->batchnum;
  int groupcount = tb->batchgroups;
  int leftovercount = tb->batchleftovers;
#endif
#ifdef EXTERNAL
  GLenum capability = tb->capability;
  void (*lExternfunc)(GLenum) = tb->externfunc;
#endif
#ifdef BY_TWO
  int *startvertindex;
#endif
  struct vector *pvert=tb->vert;
  struct plygon *pply=tb->ply;

#ifndef FUNCTION_CALLS
#ifdef WIN32
  void (APIENTRY *glVertex3fvP)(const GLfloat *);
#else
  void (*glVertex3fvP)(const GLfloat *);
#endif
#endif
  
#if defined(FACET_NORM) || defined(VERT_NORM)
  struct vector *pvnorm=tb->vnorm;
#ifndef FUNCTION_CALLS
#ifdef WIN32
  void (APIENTRY *glNormal3fvP)(const GLfloat *);
#else
  void (*glNormal3fvP)(const GLfloat *);
#endif
#endif /* ifndef FUNCTION_CALLS */
#endif
  
#if defined(FACET_COLOR) || defined(VERT_COLOR)
  struct colorvector *pvcolor=tb->vcolor;
#ifndef FUNCTION_CALLS
#ifdef WIN32
  void (APIENTRY *glColorP)(const GLfloat *);
#else
  void (*glColorP)(const GLfloat *);
#endif
#endif  /* ifndef FUNCTION_CALLS */
#endif
  
#ifdef TEXTURE
  struct vector *ptexture=tb->texture;  
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
#endif /* ifndef FUNCTION_CALLS */

  
#ifdef BATCH
      polyi = polycount;
      for(groupi=groupcount-1;groupi>=0;groupi--) 
	{
	  glBegin(mode);
	  for(batchi=batchcount-1;batchi>=0;batchi--) 
	    {
	      polyi--;
#else
      for(polyi=polycount-1;polyi>=0;polyi--) 
	 {
#endif
	   numverts = pply[polyi].numverts;
	   vertindex = pply[polyi].index;
#ifdef BY_TWO
	   startvertindex = vertindex;
#endif
#ifdef EXTERNAL
	   lExternfunc(capability);
#endif
#if    defined(FACET_COLOR) && !defined(FUNCTION_CALLS)
	   (*glColorP)((const GLfloat *) (pvcolor + *vertindex));
#elif  defined(FACET_COLOR) && defined(FUNCTION_CALLS) && !defined(COLOR4)
	   glColor3fv((const GLfloat *) (pvcolor + *vertindex));
#elif  defined(FACET_COLOR) && defined(FUNCTION_CALLS) && defined(COLOR4)
	   glColor4fv((const GLfloat *) (pvcolor + *vertindex));
#endif
#if    defined(FACET_NORM) && !defined(FUNCTION_CALLS)
	   (*glNormal3fvP)((const GLfloat *) (pvnorm + *vertindex));
#elif  defined(FACET_NORM) && defined(FUNCTION_CALLS)
	   glNormal3fv((const GLfloat *) (pvnorm + *vertindex));
#endif
#ifndef BATCH
	   glBegin(mode);
#endif
#ifdef BY_TWO
	   for(verti=numverts-2;verti>=0;verti--) 
	     {
#else
	   for(verti=numverts-1;verti>=0;verti--) 
	     {
#endif
#if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
	       (*glColorP)((const GLfloat *) (pvcolor + *vertindex));
#elif  defined(VERT_COLOR) && defined(FUNCTION_CALLS) && !defined(COLOR4)
	       glColor3fv((const GLfloat *) (pvcolor + *vertindex));
#elif  defined(VERT_COLOR) && defined(FUNCTION_CALLS) && defined(COLOR4)
	       glColor4fv((const GLfloat *) (pvcolor + *vertindex));
#endif
#if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
	       (*glTexCoord2fvP)((const GLfloat *) (ptexture + *vertindex));
#elif  defined(TEXTURE) && defined(FUNCTION_CALLS)
	       glTexCoord2fv((const GLfloat *) (ptexture + *vertindex));
#endif
#if    defined(VERT_NORM)  &&  !defined(FUNCTION_CALLS)
	       (*glNormal3fvP)((const GLfloat *) (pvnorm + *vertindex));
#elif  defined(VERT_NORM)  &&  defined(FUNCTION_CALLS)
	       glNormal3fv((const GLfloat *) (pvnorm + *vertindex));
#endif
#ifdef  FUNCTION_CALLS
	       glVertex3fv((const GLfloat *) (pvert + *vertindex));
#else
	       (*glVertex3fvP)((const GLfloat *) (pvert + *vertindex));
#endif
#ifdef BY_TWO
  #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
	       (*glColorP)((const GLfloat *) (pvcolor + *(vertindex+1)));
  #elif  defined(VERT_COLOR) && defined(FUNCTION_CALLS) && !defined(COLOR4)
	       glColor3fv((const GLfloat *) (pvcolor + *(vertindex+1)));
  #elif  defined(VERT_COLOR) && defined(FUNCTION_CALLS) && defined(COLOR4)
	       glColor4fv((const GLfloat *) (pvcolor + *(vertindex+1)));
  #endif
  #if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
	       (*glTexCoord2fvP)((const GLfloat *) (ptexture + *(vertindex+1)));
  #elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS)
	       glTexCoord2fv((const GLfloat *) (ptexture + *(vertindex+1)));
  #endif
  #if    defined(VERT_NORM)  &&  !defined(FUNCTION_CALLS)
	       (*glNormal3fvP)((const GLfloat *) (pvnorm + *(vertindex+1)));
  #elif  defined(VERT_NORM)  &&  defined(FUNCTION_CALLS)
	       glNormal3fv((const GLfloat *) (pvnorm + *(vertindex+1)));
  #endif
  #ifdef  FUNCTION_CALLS
	       glVertex3fv((const GLfloat *) (pvert + *(vertindex+1)));
  #else
	       (*glVertex3fvP)((const GLfloat *) (pvert + *(vertindex+1)));
  #endif
#endif
	       ++vertindex;
	     }
#ifdef BY_TWO
  #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
	   (*glColorP)((const GLfloat *) (pvcolor + *vertindex));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
	   glColor3fv((const GLfloat *) (pvcolor + *vertindex));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
	   glColor4fv((const GLfloat *) (pvcolor + *vertindex));
  #endif
  #if    defined(TEXTURE)  &&  !defined(FUNCTION_CALLS)
	   (*glTexCoord2fvP)((const GLfloat *) (ptexture + *vertindex));
  #elif  defined(TEXTURE)  &&   defined(FUNCTION_CALLS)
	   glTexCoord2fv((const GLfloat *) (ptexture + *vertindex));
  #endif
  #if    defined(VERT_NORM)  &&  !defined(FUNCTION_CALLS)
	   (*glNormal3fvP)((const GLfloat *) (pvnorm + *vertindex));
  #elif  defined(VERT_NORM)  &&   defined(FUNCTION_CALLS)
	   glNormal3fv((const GLfloat *) (pvnorm + *vertindex));
  #endif
  #ifdef FUNCTION_CALLS
	   glVertex3fv((const GLfloat *) (pvert + *vertindex));
  #else
	   (*glVertex3fvP)((const GLfloat *) (pvert + *vertindex));
  #endif
  #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
	   (*glColorP)((const GLfloat *) (pvcolor + *startvertindex));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
	   glColor3fv((const GLfloat *) (pvcolor + *startvertindex));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
	   glColor4fv((const GLfloat *) (pvcolor + *startvertindex));
  #endif
  #if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
	   (*glTexCoord2fvP)((const GLfloat *) (ptexture + *startvertindex));
  #elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS)
	   glTexCoord2fv((const GLfloat *) (ptexture + *startvertindex));
  #endif
  #if    defined(VERT_NORM) && !defined(FUNCTION_CALLS)
	   (*glNormal3fvP)((const GLfloat *) (pvnorm + *startvertindex));
  #elif  defined(VERT_NORM) &&  defined(FUNCTION_CALLS)
	   glNormal3fv((const GLfloat *) (pvnorm + *startvertindex));
  #endif
  #ifdef FUNCTION_CALLS
	   glVertex3fv((const GLfloat *) (pvert + *startvertindex));
  #else
	   (*glVertex3fvP)((const GLfloat *) (pvert + *startvertindex));
  #endif
#endif
#ifndef BATCH
	   glEnd();
#endif
	 }
#ifdef BATCH
	      glEnd();
	    }
	  glBegin(mode);
	  for(leftoveri=leftovercount-1;leftoveri>=0;leftoveri--) 
	    {
	      polyi--;
	      numverts = pply[polyi].numverts;
	      vertindex = pply[polyi].index;
  #ifdef BY_TWO
	      startvertindex = vertindex;
  #endif
  #if    defined(FACET_COLOR) && !defined(FUNCTION_CALLS)
	      (*glColorP)((const GLfloat *) (pvcolor + *vertindex));
  #elif  defined(FACET_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
	      glColor3fv((const GLfloat *) (pvcolor + *vertindex));
  #elif  defined(FACET_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
	      glColor4fv((const GLfloat *) (pvcolor + *vertindex));
  #endif
  #if    defined(FACET_NORM) && !defined(FUNCTION_CALLS)
	      (*glNormal3fvP)((const GLfloat *) (pvnorm + *vertindex));
  #elif  defined(FACET_NORM) &&  defined(FUNCTION_CALLS)
	      glNormal3fv((const GLfloat *) (pvnorm + *vertindex));
  #endif
  #ifdef BY_TWO
	      for(verti=numverts-2;verti>=0;verti--) 
		{
  #else
              for(verti=numverts-1;verti>=0;verti--) 
		{
  #endif
  #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
		  (*glColorP)((const GLfloat *) (pvcolor + *vertindex));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
		  glColor3fv((const GLfloat *) (pvcolor + *vertindex));
  #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
		  glColor4fv((const GLfloat *) (pvcolor + *vertindex));
  #endif
  #if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
		  (*glTexCoord2fvP)((const GLfloat *) (ptexture + *vertindex));
  #elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS)
		  glTexCoord2fv((const GLfloat *) (ptexture + *vertindex));
  #endif
  #if    defined(VERT_NORM) && !defined(FUNCTION_CALLS)
		  (*glNormal3fvP)((const GLfloat *) (pvnorm + *vertindex));
  #elif  defined(VERT_NORM) &&  defined(FUNCTION_CALLS)
		  glNormal3fv((const GLfloat *) (pvnorm + *vertindex));
  #endif
  #ifdef FUNCTION_CALLS
		  glVertex3fv((const GLfloat *) (pvert + *vertindex));
  #else
		  (*glVertex3fvP)((const GLfloat *) (pvert + *vertindex));
  #endif
  #ifdef BY_TWO
    #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
		  (*glColorP)((const GLfloat *) (pvcolor + *(vertindex+1)));
    #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
		  glColor3fv((const GLfloat *) (pvcolor + *(vertindex+1)));
    #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
		  glColor4fv((const GLfloat *) (pvcolor + *(vertindex+1)));
    #endif
    #if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
		  (*glTexCoord2fvP)((const GLfloat *) (ptexture + *(vertindex+1)));
    #elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS)
		  glTexCoord2fv((const GLfloat *) (ptexture + *(vertindex+1)));
    #endif
    #if    defined(VERT_NORM) && !defined(FUNCTION_CALLS)
		  (*glNormal3fvP)((const GLfloat *) (pvnorm + *(vertindex+1)));
    #elif  defined(VERT_NORM) &&  defined(FUNCTION_CALLS)
		  glNormal3fv((const GLfloat *) (pvnorm + *(vertindex+1)));
    #endif
    #ifdef FUNCTION_CALLS
		  glVertex3fv((const GLfloat *) (pvert + *(vertindex+1)));
    #else
		  (*glVertex3fvP)((const GLfloat *) (pvert + *(vertindex+1)));
    #endif
  #endif
		  ++vertindex;
		}
  #ifdef BY_TWO
    #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
	      (*glColorP)((const GLfloat *) (pvcolor + *vertindex));
    #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
	      glColor3fv((const GLfloat *) (pvcolor + *vertindex));
    #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
	      glColor4fv((const GLfloat *) (pvcolor + *vertindex));
    #endif
    #if    defined(TEXTURE) && !defined(FUNCTION_CALLS)
	      (*glTexCoord2fvP)((const GLfloat *) (ptexture + *vertindex));
    #elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS)
	      glTexCoord2fv((const GLfloat *) (ptexture + *vertindex));
    #endif
    #if    defined(VERT_NORM) && !defined(FUNCTION_CALLS)
	      (*glNormal3fvP)((const GLfloat *) (pvnorm + *vertindex));
    #elif  defined(VERT_NORM) &&  defined(FUNCTION_CALLS)
	      glNormal3fv((const GLfloat *) (pvnorm + *vertindex));
    #endif
    #ifdef FUNCTION_CALLS
	      glVertex3fv((const GLfloat *) (pvert + *vertindex));
    #else
	      (*glVertex3fvP)((const GLfloat *) (pvert + *vertindex));
    #endif

    #if    defined(VERT_COLOR) && !defined(FUNCTION_CALLS)
	      (*glColorP)((const GLfloat *) (pvcolor + *startvertindex));
    #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) && !defined(COLOR4)
	      glColor3fv((const GLfloat *) (pvcolor + *startvertindex));
    #elif  defined(VERT_COLOR) &&  defined(FUNCTION_CALLS) &&  defined(COLOR4)
	      glColor4fv((const GLfloat *) (pvcolor + *startvertindex));
    #endif
    #if    defined(TEXTURE) && !defined(FUNCTION_CALLS) 
	      (*glTexCoord2fvP)((const GLfloat *) (ptexture + *startvertindex));
    #elif  defined(TEXTURE) &&  defined(FUNCTION_CALLS) 
	      glTexCoord2fv((const GLfloat *) (ptexture + *startvertindex));
    #endif
    #if    defined(VERT_NORM) && !defined(FUNCTION_CALLS)
	      (*glNormal3fvP)((const GLfloat *) (pvnorm + *startvertindex));
    #elif  defined(VERT_NORM) &&  defined(FUNCTION_CALLS)
	      glNormal3fv((const GLfloat *) (pvnorm + *startvertindex));
    #endif
    #ifdef FUNCTION_CALLS
	      glVertex3fv((const GLfloat *) (pvert + *startvertindex));
    #else
	      (*glVertex3fvP)((const GLfloat *) (pvert + *startvertindex));
    #endif
  #endif

	    }
	      glEnd();
#endif

}
