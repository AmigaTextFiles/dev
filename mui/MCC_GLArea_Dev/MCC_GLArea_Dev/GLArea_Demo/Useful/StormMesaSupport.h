/*----------------------------
  StormMesaSupport.h
  Version: 1.0
  Date: 25 march 1999
  Author: BODMER Stephan
  Note:
-----------------------------*/
#ifndef STORMMESASUPPORT_H
#define STORMMESASUPPORT_H

#include <exec/exec.h>

/*
typedef struct {
    struct Library *gl_Base;
    struct Library *glu_Base;
    struct Library *glut_Base;
} GLBases;
*/

#ifdef __cplusplus
extern "C" {
#endif
int OpenStormMesaLibs(struct Library **gl_Base, struct Library **glu_Base, struct Library **glut_Base);
void CloseStormMesaLibs(struct Library **gl_Base, struct Library **glu_Base, struct Library **glut_Base);
#ifdef __cplusplus
}
#endif
#endif
