/*---------------------------------------------
  GLNode.h
  Version 0.2
  Date: 21 june 1998
  Author: BODMER Stephan
  Note: OpenGL object for optimised display
--------------------------------------------*/
#ifndef GLNODE_H
#define GLNODE_H

#include "VRMLNode.h"

// Represent a face with corresponding material/normal
class GLFace {
private:
public:
	PList<Vertex3d> vertex;
	PList<Vertex3d> normal;
	PList<Mat> material;

	GLFace():vertex(),normal(),material() {};
	~GLFace() {};
};

/*------------------------------
  abstract class for all GLNode
--------------------------------*/
class GLNode {
private:
public:
	virtual ~GLNode() {}; // virtual destructor

	virtual BOOL DrawGL()=0;
	virtual void DrawGLBox()=0;
};
//----------------------------------
// Class that really draw something
//----------------------------------
class GLShape:public GLNode {
private:
    Vertex3d bb1;
    Vertex3d bb2;
public:
	PList<GLFace> faces;

	GLShape();
	~GLShape();

	BOOL DrawGL();
	void DrawGLBox();
};
class GLWire:public GLNode {
private:
    Vertex3d bb1;
    Vertex3d bb2;
public:
	PList<GLFace> lines;

	GLWire();
	~GLWire();

	BOOL DrawGL();
	void DrawGLBox();
};

typedef struct {
    double coord[3];
} vertex3d;

typedef struct {
    float ambient[3];
    float diffuse[3];
    float emissive[3];
    float shininess;
    float transparency
} mat;

class FGLShape::public GLNode {
public:
    int numpoints;
    int numfaces;
    int nummaterials;

    vertex3d *points;
    int *faces;
    mat *materials;
};

//---------------
//GLLight
//---------------
class GLDirectionalLight:public GLNode {
public:
    int num;
    Vertex4d position;
    Color4f color;
    float intensity;

    GLDirectionalLight(DirectionalLight *dl,int num);
    ~GLDirectionalLight () {};

    BOOL DrawGL();
    void DrawGLBox() {DrawGL();};
};
class GLPointLight:public GLNode {
public:
    int num;
    Vertex4d position;
    Color4f color;
    float intensity;

    GLPointLight(PointLight *pl,int num);
    ~GLPointLight() {};

    BOOL DrawGL();
    void DrawGLBox() {DrawGL();};
};
class GLSpotLight:public GLNode {
public:
    int num;
    Vertex4d position;
    Vertex3d direction;
    Color4f color;
    float intensity;
    float dropOffRate;
    float cutOffAngle;

    GLSpotLight(SpotLight *sl,int num);
    ~GLSpotLight() {};

    BOOL DrawGL();
    void DrawGLBox() {DrawGL();};
};
//---------------
// Grouping nodes
//---------------
// Separator
class GLSeparator:public GLNode {
public:
	PList<GLNode> children;

	GLSeparator():children() {};
	~GLSeparator() {};

	BOOL DrawGL();
	void DrawGLBox();
};
// Group
class GLGroup:public GLNode {
public:
	PList<GLNode> children;

	GLGroup():children() {};
	~GLGroup() {};

	BOOL DrawGL();
	void DrawGLBox();
};
//-------------------------------
// Current Matrix tranformation
//-------------------------------
class GLMultMatrix:public GLNode {
private:
    float matrix[16];
public:
    GLMultMatrix(float *m);
    ~GLMultMatrix() {};

    BOOL DrawGL();
    void DrawGLBox() {DrawGL();};
};
class GLRotate:public GLNode {
private:
    double rotation[4];
public:
    GLRotate(double *r);
    ~GLRotate() {};

    BOOL DrawGL();
    void DrawGLBox() {DrawGL();};
};
class GLScale:public GLNode {
private:
    double scale[4];
public:
    GLScale(double *s);
    ~GLScale() {};

    BOOL DrawGL();
    void DrawGLBox() {DrawGL();};
};
class GLTransform:public GLNode {
private:
    double translation[3];
    double rotation[4];
    double scaleFactor[3];
    double scaleOrientation[4];
    double center[3];
public:
    GLTransform(double *t,double *r, double *sf, double *so, double *c);
    ~GLTransform() {};

    BOOL DrawGL();
    void DrawGLBox() {DrawGL();};
};
class GLTranslate:public GLNode {
private:
	double translate[3];
public:
	GLTranslate(double *t);
	~GLTranslate() {};

	BOOL DrawGL();
	void DrawGLBox() {DrawGL();};
};
#endif
