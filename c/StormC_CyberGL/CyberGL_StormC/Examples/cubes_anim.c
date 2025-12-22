/*
**      $VER: cubes.c 1.0 (20.03.1997)
**
**      This is an example program for CyberGL
**
**      Written by Frank Gerberding
**
**      Copyright © 1996-1997 by phase5 digital products
**      All Rights reserved.
**
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <clib/exec_protos.h>

#define CYBERGLNAME             "cybergl.library"
#define CYBERGLVERSION          39L


#define SHARED                  /* we use the cyberglshared library */
#define GL_APICOMPATIBLE        /* we use stubs from cybergl.lib */


#include "cybergl.h"
#include "cybergl_protos.h"
#include "cybergl_display.h"

#ifdef SHARED
LONG __oslibversion   = 39L;
LONG __CGLlibversion = CYBERGLVERSION;
#include "cybergl_lib.h"
extern  struct  Library *CyberGLBase;
#endif


#define WIDTH    200
#define HEIGHT   200





void drawCube (GLdouble x, GLdouble y, GLdouble z, GLdouble r, GLdouble g, GLdouble b)
{
  glColor3d (r, g, b);
  glBegin (GL_QUADS);
    glEdgeFlag  (GL_TRUE);
    glNormal3d  ( 0.0,  0.0,  1.0);
    glVertex3d  (-0.5 + x, -0.5 + y,  0.5 + z);
    glVertex3d  ( 0.5 + x, -0.5 + y,  0.5 + z);
    glVertex3d  ( 0.5 + x,  0.5 + y,  0.5 + z);
    glVertex3d  (-0.5 + x,  0.5 + y,  0.5 + z);

    glNormal3d  ( 1.0,  0.0,  0.0);
    glEdgeFlag  (GL_TRUE);
    glVertex3d  ( 0.5 + x, -0.5 + y,  0.5 + z);
    glEdgeFlag  (GL_FALSE);
    glVertex3d  ( 0.5 + x, -0.5 + y, -0.5 + z);
    glEdgeFlag  (GL_TRUE);
    glVertex3d  ( 0.5 + x,  0.5 + y, -0.5 + z);
    glEdgeFlag  (GL_FALSE);
    glVertex3d  ( 0.5 + x,  0.5 + y,  0.5 + z);

    glNormal3d  ( 0.0,  0.0, -1.0);
    glEdgeFlag  (GL_TRUE);
    glVertex3d  ( 0.5 + x, -0.5 + y, -0.5 + z);
    glVertex3d  (-0.5 + x, -0.5 + y, -0.5 + z);
    glVertex3d  (-0.5 + x,  0.5 + y, -0.5 + z);
    glVertex3d  ( 0.5 + x,  0.5 + y, -0.5 + z);

    glNormal3d  (-1.0,  0.0,  0.0);
    glEdgeFlag  (GL_TRUE);
    glVertex3d  (-0.5 + x, -0.5 + y, -0.5 + z);
    glEdgeFlag  (GL_FALSE);
    glVertex3d  (-0.5 + x, -0.5 + y,  0.5 + z);
    glEdgeFlag  (GL_TRUE);
    glVertex3d  (-0.5 + x,  0.5 + y,  0.5 + z);
    glEdgeFlag  (GL_FALSE);
    glVertex3d  (-0.5 + x,  0.5 + y, -0.5 + z);

    glNormal3d  ( 0.0,  1.0,  0.0);
    glVertex3d  (-0.5 + x,  0.5 + y,  0.5 + z);
    glVertex3d  ( 0.5 + x,  0.5 + y,  0.5 + z);
    glVertex3d  ( 0.5 + x,  0.5 + y, -0.5 + z);
    glVertex3d  (-0.5 + x,  0.5 + y, -0.5 + z);

    glNormal3d  ( 0.0, -1.0,  0.0);
    glVertex3d  (-0.5 + x, -0.5 + y, -0.5 + z);
    glVertex3d  ( 0.5 + x, -0.5 + y, -0.5 + z);
    glVertex3d  ( 0.5 + x, -0.5 + y,  0.5 + z);
    glVertex3d  (-0.5 + x, -0.5 + y,  0.5 + z);
  glEnd ();
}





void spotLight (GLdouble x,    GLdouble y,    GLdouble z,
                GLdouble dx,   GLdouble dy,   GLdouble dz,
                GLdouble r,    GLdouble g,    GLdouble b,
                GLdouble att0, GLdouble att1, GLdouble att2,
                GLdouble exp,  GLdouble cut,  GLenum light)
{
  GLfloat pos   [4];
  GLfloat dir   [3];
  GLfloat color [4];

  pos   [0] = (GLfloat) x;
  pos   [1] = (GLfloat) y;
  pos   [2] = (GLfloat) z;
  pos   [3] = (GLfloat) 1.0;
  dir   [0] = (GLfloat) dx;
  dir   [1] = (GLfloat) dy;
  dir   [2] = (GLfloat) dz;
  color [0] = (GLfloat) r;
  color [1] = (GLfloat) g;
  color [2] = (GLfloat) b;
  color [3] = (GLfloat) 0.0;

  glEnable  (GL_LIGHTING);
  glEnable  (light);
  glLightfv (light, GL_POSITION,              pos);
  glLightfv (light, GL_DIFFUSE,               color);
  glLightfv (light, GL_SPECULAR,              color);
  glLightfv (light, GL_SPOT_DIRECTION,        dir);
  glLightf  (light, GL_SPOT_CUTOFF,           (GLfloat) cut);
  glLightf  (light, GL_SPOT_EXPONENT,         (GLfloat) exp);
  glLightf  (light, GL_CONSTANT_ATTENUATION,  (GLfloat) att0);
  glLightf  (light, GL_LINEAR_ATTENUATION,    (GLfloat) att1);
  glLightf  (light, GL_QUADRATIC_ATTENUATION, (GLfloat) att2);
}





void drawScene (void)
{
  glClear   (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  drawCube  (-0.6, -0.6, -0.6,   1.0,  1.0,  1.0);
  drawCube  (-0.6, -0.6,  0.6,   1.0,  0.0,  0.0);
  drawCube  (-0.6,  0.6, -0.6,   0.0,  1.0,  0.0);
  drawCube  (-0.6,  0.6,  0.6,   0.0,  0.0,  1.0);
  drawCube  ( 0.6, -0.6, -0.6,   1.0,  1.0,  0.0);
  drawCube  ( 0.6, -0.6,  0.6,   1.0,  0.0,  1.0);
  drawCube  ( 0.6,  0.6, -0.6,   0.0,  1.0,  1.0);
  drawCube  ( 0.6,  0.6,  0.6,   0.3,  0.3,  0.3);
}





void handle_window_events (void *win)
{
  struct IntuiMessage *msg;
  int                  done = 0;
  int                  x, y;
  GLdouble             angleX = 0.0, angleY = 0.0;
  GLboolean            down = GL_FALSE;
  struct Window       *window;

  window = getWindow (win);
  ReportMouse (1, window);
  while (!done)
  {
    Wait (1L << window->UserPort->mp_SigBit);
    while ((!done) && (msg = (struct IntuiMessage *) GetMsg (window->UserPort)))
    {
      switch (msg->Class)
      {
        case IDCMP_CLOSEWINDOW:
          done = 1;
          break;
        case IDCMP_NEWSIZE:
          resizeGLWindow   (win, window->GZZWidth, window->GZZHeight);
          glClear          (GL_COLOR_BUFFER_BIT);
          drawScene ();
          break;
        case IDCMP_MOUSEBUTTONS:
          if (msg->Code == SELECTDOWN)
          {
            x    = msg->MouseX;
            y    = msg->MouseY;
            down = GL_TRUE;
          }
          else
          {
            down = GL_FALSE;
          }
          break;
        case IDCMP_MOUSEMOVE:
          if (down)
          {
            angleX += x - msg->MouseX;
            angleY += y - msg->MouseY;
            x = msg->MouseX;
            y = msg->MouseY;
            glPushMatrix ();
              glRotated (angleX, 0.0, -1.0, 0.0);
              glRotated (angleY, -1.0, 0.0, 0.0);
              drawScene ();
            glPopMatrix ();
          }
          break;

      }
      ReplyMsg ((struct Message *) msg);
    }
  }
}





void main (int argc, char *argv[])
{
  void *window;

  window  = openGLWindowTags (WIDTH, HEIGHT, GLWA_Title,"Animated Cubes",
                                             GLWA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_MOUSEMOVE | IDCMP_MOUSEBUTTONS | IDCMP_NEWSIZE,
                                             GLWA_CloseGadget, TRUE,
                                             GLWA_DepthGadget, TRUE,
                                             GLWA_DragBar,     TRUE,
                                             GLWA_Activate, TRUE,
                                             GLWA_RGBAMode, GL_TRUE,
                                             GLWA_SizeGadget, TRUE,
                                             GLWA_MaxWidth, 1280,
                                             GLWA_MaxHeight, 1024,
                                             TAG_DONE);

  if (window)
  {
    glColorMaterial  (GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
    glEnable         (GL_COLOR_MATERIAL);
    glCullFace       (GL_BACK);
    glEnable         (GL_CULL_FACE);
    glShadeModel     (GL_SMOOTH);
    glEnable         (GL_DEPTH_TEST);
    glMaterialf      (GL_FRONT_AND_BACK, GL_SHININESS, (GLfloat) 50.0);
    glLightModeli    (GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);
    glMatrixMode     (GL_PROJECTION);
    glPerspective    (50.0, 1.0, 0.5, 50.5);
    glMatrixMode     (GL_MODELVIEW);
#ifndef GL_APICOMPATIBLE
  {
    GLlookAt lookat;

    lookat.eyex    = 0.0;
    lookat.eyey    = 0.0;
    lookat.eyez    = 5.0;
    lookat.centerx = 0.0;
    lookat.centery = 0.0;
    lookat.centerz = 0.0;
    lookat.upx     = 0.0;
    lookat.upy     = 1.0;
    lookat.upz     = 0.0;
    glLookAt (&lookat);
  }
#else
    glLookAt         (0.0,  0.0, 5.0,   0.0, 0.0, 0.0,   0.0, 1.0, 0.0);
#endif
    glMatrixMode     (GL_MODELVIEW);

    spotLight (15.0, 15.0, 15.0,   -1.0, -1.0, -1.0,   1.0, 1.0, 1.0,   1.0, 0.0, 0.0,   50.0, 90.0, GL_LIGHT0);

    drawScene ();

    handle_window_events (window);

    closeGLWindow (window);
  }
}
