/*------------------------------------------------------
  VRMLSupport.h
  Version: 0.2
  Date: 28 march 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Interface to all In/Out objects
------------------------------------------------------*/
#ifndef VRMLSUPPORT_H
#define VRMLSUPPORT_H

#define ONLYERRORS 0
#define ALLMSG 1
#define NORESOLVE 0
#define RESOLVE 1

#include <exec/types.h>

#include "VRMLNode.h"
#include "GLNode.h"

#define VRMLSAVER_VERSION "VRMLEditor V 0.64"
#define OPENGLSAVER_VERSION "VRMLEditor V 0.64"

typedef enum {novrml,notfound,error,v2,v1,saved,geo,geobin,gzip,exported} VRMLStatus;

typedef struct {
    APTR Win;
    APTR Gauge;
    APTR Txt;
} MUIGauge;

typedef struct {
    APTR App;
    APTR RefWindow;
    float angle;
    VRMLState *st;
    PList<GLVertex3d> *glc;
    PList<GLMaterial> *glm;
    PList<GLVertex3d> *gln;
    PList<GLVertex2d> *gltc;
} GLConvertParams;

typedef struct {
    APTR App;
    APTR RefWindow;
    float angle;
} ProduceNormalParams;

typedef struct {
    APTR App;
    APTR RefWindow;
    FILE *pfd;
    int msgtype;
    int resolve;
} LoadVRMLParams;

typedef struct {
    APTR App;
    APTR RefWindow;
    BOOL GenTex;
    BOOL GenInlines;
} SaveVRMLParams;

typedef struct {
    APTR Win;
    APTR Gauge;
    APTR Txt;
    int coneres;
    int cylinderres;
    int sphereres;
    BOOL GenTex;
} SaveOpenGLParams;

typedef struct {
    APTR App;
    APTR RefWindow;
    int coneres;
    int cylinderres;
    int sphereres;
    int id;
} SaveMWParams;

VRMLStatus CheckType(char *filename);

VRMLGroups *LoadVRML(LoadVRMLParams *par, char *filename);
VRMLStatus SaveVRML(SaveVRMLParams *sp,char *filename, VRMLNode *n);
VRMLStatus SaveVRML2(SaveVRMLParams *sp,char *filename, VRMLNode *n);

VRMLGroups *LoadGEO(MUIGauge *gauge,char *filename, FILE *pfd,int pt);
VRMLStatus SaveGEO(MUIGauge *gauge,char *filename, VRMLNode *n);

VRMLStatus SaveOpenGL(SaveOpenGLParams *sp,char *filename, VRMLNode *n);

VRMLStatus SaveMW(SaveMWParams *sp, char *filename, VRMLNode *n);

GLNode *ConvertVRML2GL(GLConvertParams *cp, VRMLNode *n);

Normal *ProduceNormalNode(ProduceNormalParams *par, Coordinate3 *c3, VRMLNode *n);

VRMLNode *Extract(VRMLNode *n,char *name,PList<VRMLCameras> *cl);
#endif
