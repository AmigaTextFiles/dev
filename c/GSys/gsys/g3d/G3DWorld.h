
/* Author Anders Kjeldsen */

#ifndef GWORLD
#define GWORLD

#ifdef GAMIGA
#define GWARP3D	/* if Warp3D used - currently one standard supported */

#include <warp3d/warp3d.h>

#endif

#define OBJ_FLOAT 	0x01
#define OBJ_DOUBLE 	0x02
#define OBJ_L1616 	0x04
#define OBJ_LONG	0x08
#define OBJ_WORD 	0x0c

#define OBJ_VTX_W	TRUE
#define OBJ_VTX_TEX3D	TRUE
#define OBJ_VTX_COLOR	TRUE
#define OBJ_VTX_SPEC	TRUE
#define OBJ_VTX_L	TRUE

#define HIGHER TRUE
#define LOWER FALSE




#ifndef GQuat
class GQuat;
#endif

#ifndef GMatrix
class GMatrix;
#endif

#ifndef GVector
class GVector;
#endif

#ifndef GVertex
class GVertex;
#endif

#ifndef GPolygon
class GPolygon;
#endif

#ifndef GObject
class GObject;
#endif

#ifndef GCamera
class GCamera;
#endif

#ifndef GWorld
class GWorld;
#endif


#include "g3d/GQuat.h"
#include "g3d/GMatrix.h"
#include "g3d/GVector.h"
#include "g3d/GVertex.h"
#include "g3d/GPolygon.h"
#include "g3d/GObject.h"
#include "g3d/GCamera.h"

class GWorld
{
public:

	GWorld();
	~GWorld() {};

	class GScreen *GScreen;	/* The screen used to draw stuff */
	class GObject *GObjects;		/* Triangles */

#ifdef GAMIGA
	W3D_Context Context;
#endif

private:
};


#include "g3d/GQuatMet.h"
#include "g3d/GMatrixMet.h"
#include "g3d/GVectorMet.h"
#include "g3d/GVertexMet.h"
#include "g3d/GPolygonMet.h"
#include "g3d/GObjectMet.h"
#include "g3d/GCameraMet.h"

#endif /* GWORLD */

