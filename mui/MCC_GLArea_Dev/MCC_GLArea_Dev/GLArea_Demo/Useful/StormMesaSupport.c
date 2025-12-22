/*-------------------------------------
  StormMesaSupport.c
  Version: 1.0
  Date: 25 march 99
  Author: BODMER Stephan
  Note:
---------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <exec/types.h>
#include <exec/libraries.h>
#include <proto/exec.h>

#include "glsm.h"
#include "glusm.h"
#include "glutsm.h"

#include "StormMesaSupport.h"

#ifdef __STORM__
// extern struct Library *glBase;
// extern struct Library *gluBase;
// extern struct Library *glutBase;
#endif
#ifdef __GNUC__
#include <inline/agl.h>
#include <inline/aglu.h>
#include <inline/aglut.h>
#endif

#ifdef STORMMESASUPPORT_LIBS
// void exit(int i) {};
#endif


int OpenStormMesaLibs(struct Library **gl_Base, struct Library **glu_Base, struct Library **glut_Base) {
	struct Library *glBase=NULL;
	struct Library *gluBase=NULL;
	struct Library *glutBase=NULL;
	struct glreg gl_reg;
	struct glureg glu_reg;
	struct glutreg glut_reg;

	// oldfpu = SetFPU();
	if (!( *(gl_Base) = OpenLibrary("agl.library",0))) {
	    // printf("Failed to open 'agl.library'\n");
	    return 0;
	    // exit(0);
	};
	if (!( *(glu_Base) = OpenLibrary("aglu.library",0))) {
	    // printf("Failed to open 'aglu.library'\n");
	    return 0;
	    // exit(0);
	};
	if (!( *(glut_Base) = OpenLibrary("aglut.library",0))) {
	    // printf("Failed to open 'aglut.library'\n");
	    return 0;
	    // exit(0);
	};
	glBase= *(gl_Base);
	gluBase= *(glu_Base);
	glutBase= *(glut_Base);

	// puts("after openlibs");
	/*
	printf("OPENLIBS:gl_Base:%x glu_Base:%x glut_Base:%x\n",*(gl_Base), *(glu_Base), *(glut_Base));
	printf("OPENLIBS:glBase:%x gluBase:%x glutBase:%x\n",glBase, gluBase, glutBase);
	*/
	CacheClearU();
	gl_reg.size = (int)sizeof(struct glreg);
	gl_reg.func_exit = exit;
	// puts("before registerGL");
	registerGL(&gl_reg);
	// puts("after registerGL");
	glu_reg.size = (int)sizeof(struct glureg);
	glu_reg.glbase = *(gl_Base);
	registerGLU(&glu_reg);
	glut_reg.size = (int)sizeof(struct glutreg);
	glut_reg.func_exit = exit;
	glut_reg.glbase = *(gl_Base);
	glut_reg.glubase = *(glu_Base);
	registerGLUT(&glut_reg);
	return 1;
}

void CloseStormMesaLibs(struct Library **gl_Base, struct Library **glu_Base, struct Library **glut_Base) {
    if (*(gl_Base)) {
	CloseLibrary( *(gl_Base));
	*(gl_Base)=NULL;
    };
    if (*(glu_Base)) {
	CloseLibrary( *(glu_Base));
	*(glu_Base)=NULL;
    };
    if (*(glut_Base)) {
	CloseLibrary( *(glut_Base));
	*(glut_Base)=NULL;
    };
}
