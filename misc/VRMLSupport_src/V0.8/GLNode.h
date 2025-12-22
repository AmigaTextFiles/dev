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

// #define DEBUG

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

typedef struct {
    double coord[3];
} vertex3d;
typedef struct {
    double coord[2];
} vertex2d;

typedef struct {
    int numpoints;
    int nummaterials;
    int numnormals;
    int numtextures;
    int *coordIndex;
    int *materialIndex;
    int *normalIndex;
    int *textureCoordIndex;
} face;

typedef struct {
    float ambient[4];
    float diffuse[4];
    float specular[4];
    float emissive[4];
    float shininess;
    float transparency;
} material;


class GLVertex3d {
public:
    int numpoints;
    vertex3d *pointlist;

    GLVertex3d(int np);
    ~GLVertex3d();
};
class GLVertex2d {
public:
    int numpoints;
    vertex2d *pointlist;

    GLVertex2d(int np);
    ~GLVertex2d();
};
class GLMaterial {
public:
    int nummats;
    material *materiallist;

    GLMaterial(int nm);
    ~GLMaterial();
};

/*------------------------------
  abstract class for all GLNode
--------------------------------*/
class GLNode {
private:
public:
    virtual ~GLNode() {}; // virtual destructor

    virtual BOOL DrawGL(struct GLContext *glcontext)=0;
    virtual void DrawGLBox(struct GLContext *glcontext)=0;
};

class GLTexture:public GLNode {
private:
    BOOL scaled;

    int ScaleImage(struct GLContext *glcontext);

public:
    int width;
    int height;
    int component;
    int wrapS;
    int wrapT;
    UBYTE *image;

    GLTexture(int w,int h,int co, int ws, int wt);
    ~GLTexture();

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext);
};

//----------------------------------
// Class that really draw something
//----------------------------------
class GLShape:public GLNode {
private:
public:
    vertex3d bb1;
    vertex3d bb2;

    GLVertex3d *glc;
    GLMaterial *glm;
    GLVertex3d *gln;
    GLVertex2d *gltc;

    int numfaces;

    int *coordIndex;
    int *materialIndex;
    int *normalIndex;
    int *texCoordIndex;

    GLShape(int pt, int nf, int nm, int nn, int tn, int coordindexes);
    GLShape(int nf, int coordindexes);
    ~GLShape();

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext);
};

class GLWire:public GLNode {
private:
public:
    vertex3d bb1;
    vertex3d bb2;

    GLVertex3d *glc;
    GLMaterial *glm;
    GLVertex3d *gln;
    GLVertex2d *gltc;

    int numlines;

    int *coordIndex;
    int *materialIndex;
    int *normalIndex;
    int *texCoordIndex;

    GLWire(int pt, int nf, int nm, int nn, int tn, int coordindexes);
    GLWire(int nf, int coordindexes);
    ~GLWire();

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext);
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

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
};
class GLPointLight:public GLNode {
public:
    int num;
    Vertex4d position;
    Color4f color;
    float intensity;

    GLPointLight(PointLight *pl,int num);
    ~GLPointLight() {};

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
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

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
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

	BOOL DrawGL(struct GLContext *glcontext);
	void DrawGLBox(struct GLContext *glcontext);
};
// Group
class GLGroup:public GLNode {
public:
	PList<GLNode> children;

	GLGroup():children() {};
	~GLGroup() {};

	BOOL DrawGL(struct GLContext *glcontext);
	void DrawGLBox(struct GLContext *glcontext);
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

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
};
class GLRotate:public GLNode {
private:
    double rotation[4];
public:
    GLRotate(double *r);
    ~GLRotate() {};

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
};
class GLScale:public GLNode {
private:
    double scale[4];
public:
    GLScale(double *s);
    ~GLScale() {};

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
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

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
};
class GLTranslate:public GLNode {
private:
	double translate[3];
public:
	GLTranslate(double *t);
	~GLTranslate() {};

	BOOL DrawGL(struct GLContext *glcontext);
	void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
};
class GLTextureTransform:public GLNode {
private:
    double translation[2];
    double rotation;
    double scale[2];
    double center[2];
public:
    GLTextureTransform(double *t, double *s, double *c, double r);
    ~GLTextureTransform() {};

    BOOL DrawGL(struct GLContext *glcontext);
    void DrawGLBox(struct GLContext *glcontext) {DrawGL(glcontext);};
};
#endif
