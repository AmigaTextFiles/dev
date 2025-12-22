/*----------------------------------------------------
  Main.h (VRMLViewer)
  Version 0.1
  Date: 24 may 1998
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note:
-----------------------------------------------------*/
#ifndef MAIN_H
#define MAIN_H

#define USER 0
#define SYSTEM 1
#define MAIN 0
#define CLIP 1
#define RENDERING 0
#define IDLE 1

#define CYBERGLNAME             "cybergl.library"
#define CYBERGLVERSION          39L

//------ Mouse action ----------------
#define ROTATE  0
#define SLIDE   1
#define TURN    2
#define FLY     3

//------ Drawing method when moving -----------
#define BOX     0
#define PLAIN   1

//------- Polygone filling type ----------
#define TEXTURED        0
#define TRANSPARENT     1
#define SMOOTH          2
#define FLAT            3
#define WIRE            4
#define WIREFRAME       5
#define POINTS          6
#define BOUNDINGBOX     7

typedef struct {
	char Name[255];
	char Dir[255];
	char Complete[255];
} FNames;

typedef struct {
	char outcon[255];
	int msgmode;
	int resolve;
	int buffered;
	int threaded;
	int coneres;
	int cylinderres;
	int sphereres;
	float brgb[3];
	int displayID;
	int displayDepth;
	float angle;
	char gzip[255];
} Prefs;

typedef struct {
    int mode;
    int rendering;
} SharedVariables;

typedef struct {
    int polygones;
    int materials;
    int lightsources;
} WorldInfos;

#endif
