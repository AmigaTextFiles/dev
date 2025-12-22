/*----------------------------------------------------
  Main.h
  Version 0.64
  Date: 27.3.1999
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note:
-----------------------------------------------------*/
#ifndef VRMLEDITOR_MAIN_H
#define VRMLEDITOR_MAIN_H

#define USER 0
#define SYSTEM 1

//-------- Which listtree ? -----
#define MAIN 0
#define CLIP 1

#define DRAWING 0
#define IDLE 1
#define OPENED 0
#define CLOSED 1

//------ Add window mode ---------
#define ADDING          0
#define TRANSFORMING    1

#define CYBERGLNAME             "cybergl.library"
#define CYBERGLVERSION          39L

#define VRMLEDITOR_VERSION "Version 0.70 Beta (27.3.1999)"

#define COMPILED_FOR_CPU_MODEL "68040"
// #define COMPILED_FOR_CPU_MODEL "68030/68881"

//-------- Mouse event ----------
#define ROTATE  0
#define SLIDE   1
#define TURN    2
#define FLY     3

//------- Preview node ---------
#define MAIN_WORLD  0
#define CLIP_WORLD  1
#define BOTH_WORLD  2

//------- Preview level -------
#define NODE_ONLY   0
#define GROUP_ONLY  1
#define WHOLE_WORLD 2

//------- Animation mode -------
#define BOX     0
#define PLAIN   1

//------- GL Modes -------
#define SMOOTH      0
#define FLAT        1
#define WIRE        2
#define POINTS      3
#define WIREFRAME   4
#define BOUNDINGBOX 5
#define TRANSPARENT 6
#define TEXTURED    7

typedef struct {
	char Name[255];
	char Dir[255];
	char Complete[255];
} FNames;

/*
typedef struct {
	// VRMLCameras *view;
	double X;
	double Y;
	double Z;
	double heading;
	double pitch;
} GLCamera;
*/

typedef struct {
	char outcon[255];
	char gzip[255];
	int msgmode;
	int resolve;
	float angle;
	float brgb[3];
	int displayID;
	int displayDepth;
	int coneres;
	int cylinderres;
	int sphereres;
	BOOL V1GenTex;
	BOOL V1GenInlines;
	BOOL V1GenNormals;
	BOOL V1Gzip;
	BOOL V2GenTex;
	BOOL GLTex;
} Prefs;

typedef struct {
    int mode;
    int rendering;
    int about;
} SharedVariables;

#endif
