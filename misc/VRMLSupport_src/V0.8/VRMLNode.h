/*---------------------------------------------
  VRMLNode.h
  Version 0.71
  Date: 29.11. 1998
  Author: BODMER Stephan
  Note: Base part of all nodes
	Actually: AsciiText,
		  Coordinate3,Cube,Separator,
		  Cone,Cylinder,
		  DirectionalLight,
		  FontStyle,
		  Group,
		  IndexedFaceSet,IndexedLineSet,Info,
		  LOD,
		  Material,MaterialBinding,MatrixTransform,
		  Normal,NormalBinding,
		  OrthographicCamera,
		  PerspectiveCamera,PointLight,PointSet,
		  Rotation,
		  Scale,Separator,ShapeHints,Sphere,SpotLight,Switch,
		  Texture2,Texture2Transform,TextureCoordinate2,
		  Transform,TransformSeparator,Translation,
		  WWWAnchor,WWWInline,
		  USE
-----------------------------------------------*/
#ifndef VRMLNODE_H
#define VRMLNODE_H

// CyberGL or StormMesa
// #define USE_CYBERGL

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <exec/exec.h>

#include "VRMLNode.class"

// Include personal Lists handling
#include "Lists.hpp"

// Include different classes (types)
#include "Other.hpp"

// Node type
#define GROUPS      (1<<9)        // Bit 9 for groupping nodes
#define V2          (1<<10)       // Bit 10 for V2.0 nodes

// VRML V1.0
#define ASCIITEXT_1             1
#define CONE_1                  2
#define COORDINATE3_1           3
#define CUBE_1                  4
#define CYLINDER_1              5
#define DIRECTIONALLIGHT_1      6
#define FONTSTYLE_1             7
#define GROUP_1                 (8|GROUPS)
#define INDEXEDFACESET_1        9
#define INDEXEDLINESET_1        10
#define INFO_1                  11
#define LOD_1                   (12|GROUPS)
#define MATERIAL_1              13
#define MATERIALBINDING_1       14
#define MATRIXTRANSFORM_1       15
#define NORMAL_1                16
#define NORMALBINDING_1         17
#define ORTHOGRAPHICCAMERA_1    18
#define PERSPECTIVECAMERA_1     19
#define POINTLIGHT_1            20
#define POINTSET_1              21
#define ROTATION_1              22
#define SCALE_1                 23
#define SEPARATOR_1             (24|GROUPS)
#define SHAPEHINTS_1            25
#define SPHERE_1                26
#define SPOTLIGHT_1             27
#define SWITCH_1                (28|GROUPS)
#define TEXTURE2_1              29
#define TEXTURE2TRANSFORM_1     30
#define TEXTURECOORDINATE2_1    31
#define TRANSFORM_1             32
#define TRANSFORMSEPARATOR_1    (33|GROUPS)
#define TRANSLATION_1           34
#define WWWANCHOR_1             (35|GROUPS)
#define WWWINLINE_1             36
#define USE_1                   37
// 7 bit used

//--- Group Node ---
#define THIS_LEVEL   0
#define ALL_LEVEL    1

//--- AsciiText justification ---
#define JUSTIFICATION_LEFT      0
#define JUSTIFICATION_CENTER    1
#define JUSTIFICATION_RIGHT     2

//--- Binding type ---
#define BINDING_DEFAULT             0
#define BINDING_OVERALL             1
#define BINDING_PER_PART            2
#define BINDING_PER_PART_INDEXED    3
#define BINDING_PER_FACE            4
#define BINDING_PER_FACE_INDEXED    5
#define BINDING_PER_VERTEX          6
#define BINDING_PER_VERTEX_INDEXED  7

//--- Cylinder/Cone part Bitmask ---
#define SIDES   1
#define TOP     2
#define BOTTOM  4
#define ALL (SIDES|TOP|BOTTOM)

//--- FontStyle ---
#define FONTFAMILY_SERIF      0
#define FONTFAMILY_SANS       1
#define FONTFAMILY_TYPEWRITER 2

#define FONTSTYLE_NONE 0
#define FONTSTYLE_BOLD 1
#define FONTSTYLE_ITALIC 2

// IndexedFace/LineSet bounding box
#define NOTYET 0
#define READY 1

// Texture2 wrap style
#define TEXTURE2_WRAP_REPEAT 0
#define TEXTURE2_WRAP_CLAMP 1

// Separator
// typedef enum {AUTO,ON,OFF} CullingType;
#define CULLING_AUTO    0
#define CULLING_ON      1
#define CULLING_OFF     2

// ShapeHints
typedef enum {UNKNOWN_ORDERING,CLOCKWISE,COUNTERCLOCKWISE} VertexOrder;
typedef enum {UNKNOWN_SHAPE_TYPE,SOLID} ShapeType;
typedef enum {CONVEX,UNKNOWN_FACE_TYPE} FaceType;

// WWWAnchor
#define MAP_NONE    0
#define MAP_POINT   1

/*---------------------------------
  C++ Classes
-----------------------------------*/
/*************************************
   Abstract class for all VRML Nodes
 *************************************/
class VRMLNode {
private:
	char defname[25];
	char Type[25];
	// struct SignalSemaphore *sema;

public:
	int ID;
	int ref;
	
	// virtual destructor
	virtual ~VRMLNode() {};

	void SetTypeName(char t[25]);
	char *GetTypeName();
	char *GetName();
	void SetName(char name[25]);
	void GetSemaphore();
	void PutSemaphore();
	void CommonInit();
	void CommonFree();

	// virtual methods
	virtual VRMLNode *Clone()=0;
	virtual void Copy(VRMLNode *n)=0;
	virtual void Print()=0;
	virtual BOOL DrawGL(VRMLState *st)=0;
	virtual void DrawGLBox(struct GLContext *glcontext)=0;
	virtual void Browse(VRMLState *st)=0;
};

class VRMLGroups:public VRMLNode {
private:
public:
	PList<VRMLNode> children;

	int Size();
	
	void SetChild (int where, VRMLNode *n);
	void AddChild (VRMLNode *n);
	void InsertChild(int where, VRMLNode *n);
	BOOL InsertNode(VRMLNode *af, VRMLNode *n, int level);
	VRMLNode *GetChild(int where);
	VRMLNode *RemoveChild(int where);
	VRMLNode *RemoveNode(VRMLNode *n,int level);
	int FindPosition(VRMLNode *n);

	void ClearChildren();
	void ExchangeChildren(int source, int target);

	int UseCamera(char *cname);
	void Browse(VRMLState *st);
};
class VRMLLights:public VRMLNode {
private:
public:
	int on;
	float intensity;
	Color4f color;
	Vertex4d point;

	void SetON();
	void SetOFF();

	void Browse(VRMLState *st);
};

class VRMLCameras:public VRMLNode {
private:
public:
	Vertex3d position;
	Vertex4d orientation;
	float focalDistance;
	float height;

	virtual void DrawGLCamera()=0;
	void Browse(VRMLState *st);
};

class VRMLShapes:public VRMLNode {
private:
public:
	void RefreshGauge(VRMLState *st);
};

class VRMLMisc:public VRMLNode {
private:
public:
	void Browse(VRMLState *st);
};

/*****************
    VRML Nodes   
 *****************/
// AsciiText
class AsciiText:public VRMLShapes  {
private:
public:                                  
	int justification;
	float spacing;
	PList<StringWidth> txt;
	
	AsciiText(char *name);
	~AsciiText();

	int Size();

	void AddTxt (StringWidth *sw);
	void InsertTxt(int where, StringWidth *sw);
	StringWidth *GetTxt (int where);
	StringWidth *RemoveTxt (int where);

	void Clear();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// Cone
class Cone:public VRMLShapes {
private:
public:
	int parts;
	double bottomRadius;
	double height;
	
	Cone(char *name);
	~Cone();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// Coordinate3
class Coordinate3:public VRMLMisc {
private:
public:
	PList<Vertex3d> point;

	Coordinate3 (char *name);
	~Coordinate3 ();

	int Size();

	void AddPoint(Vertex3d *v);
	void InsertPoint(int index, Vertex3d *v);
	Vertex3d *GetPoint(int index);
	Vertex3d *RemovePoint(int index);

	void Clear();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Cube
class Cube:public VRMLShapes {
private:
public:
	double width;
	double height;
	double depth;
	
	Cube (char *name);
	~Cube();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// Cylinder
class Cylinder:public VRMLShapes {
private:
public:
	int parts;
	double radius;
	double height;
	
	Cylinder(char *name);
	~Cylinder();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// DirectionalLight
class DirectionalLight:public VRMLLights {
private:
public:
	DirectionalLight(char *name);
	~DirectionalLight();
	
	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// FontStyle
class FontStyle:public VRMLMisc {
private:      
public:
	float size;
	int family;
	int style;

	FontStyle(char *name);
	~FontStyle();

       VRMLNode *Clone();
       void Copy(VRMLNode *n);
       void Print();
       BOOL DrawGL(VRMLState *st);
       void DrawGLBox(struct GLContext *glcontext);
};
// Group
class Group:public VRMLGroups {
private:
public:
       Group(char *name);
       ~Group();

       VRMLNode *Clone();
       void Copy(VRMLNode *n);
       void Print();
       BOOL DrawGL(VRMLState *st);
       void DrawGLBox(struct GLContext *glcontext);
};
// IndexedFaceSet
class IndexedFaceSet:public VRMLShapes {
private:
public:
	int bbox;
	int writeMaterialIndex;
	int writeNormalIndex;
	int writeTextureCoordIndex;
	Vertex3d min;
	Vertex3d max;

	PList<Face> faces;

	IndexedFaceSet (char *name);
	~IndexedFaceSet();

	int Size();

	void AddFace(Face *f);
	void InsertFace(int where, Face *f);
	Face *GetFace(int where);
	Face *RemoveFace(int where);
	
	void Clear();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// Node IndexedLineSet {}
class IndexedLineSet:public VRMLShapes {
private:
public:
	int bbox;
	int writeMaterialIndex;
	int writeNormalIndex;
	int writeTextureCoordIndex;
	Vertex3d min;
	Vertex3d max;

	PList<Face> faces;

	IndexedLineSet (char *name);
	~IndexedLineSet();

	int Size();

	void AddLine(Face *f);
	void InsertLine(int where, Face *f);
	Face *GetLine(int where);
	Face *RemoveLine(int where);

	void Clear();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// Info
class VInfo:public VRMLMisc {
private:
	char string[1001];
public:
	VInfo(char *name);
	~VInfo();

	void SetString(char *s);
	char *GetString();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// LOD
class LOD:public VRMLGroups {
private:
	VRMLState state;
public:
	VList<float> range;
	Vertex3d center;

	LOD(char *name);
	~LOD();

	int RangeSize();

	void AddRange(float r);
	void InsertRange(int where, float r);
	void SetRange(int where, float r);
	float RemoveRange(int where);
	float GetRange (int index);

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Material
class Material:public VRMLMisc {
private:
public:
	PList<Mat> material;

	Material (char *name);
	~Material ();

	int Size();

	void AddMaterial (Mat *m);
	void InsertMaterial (int where, Mat *m);
	Mat *GetMaterial(int where);
	Mat *RemoveMaterial (int where);

	void Clear();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Node MaterialBinding {}
class MaterialBinding:public VRMLMisc {
private:
public:
	int value;

	MaterialBinding(char *name);
	~MaterialBinding();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// MatrixTransform {}
class MatrixTransform:public VRMLMisc {
private:
public:
	float matrix[16];

	MatrixTransform(char *name);
	~MatrixTransform();
	void SetMatrixv(float *m);
	void GetMatrixv(float *m);

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Normal
class Normal:public VRMLMisc {
private:
public:
	PList<Vertex3d> vector;

	Normal(char *name);
	~Normal();

	int Size();

	void AddVector(Vertex3d *p);
	void InsertVector(int where, Vertex3d *p);
	Vertex3d *GetVector(int where);
	Vertex3d *RemoveVector(int where);

	void Clear();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// NormalBinding {}
class NormalBinding:public VRMLMisc {
private:
public:
	int value;

	NormalBinding(char *name);
	~NormalBinding();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// OrthographicCamera {}
class OrthographicCamera:public VRMLCameras {
private:
public:
	OrthographicCamera(char *name);
	~OrthographicCamera();
	     
	void SetDefault();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void DrawGLCamera();
};
// PerspectiveCamera {}
class PerspectiveCamera:public VRMLCameras {
private:
public:    
	PerspectiveCamera(char *name);
	~PerspectiveCamera();

	void SetDefault();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void DrawGLCamera();
};
// PointLight {}
class PointLight:public VRMLLights {
private:
public:                 
	PointLight(char *name);
	~PointLight();

	void SetDefault();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// PointSet
class PointSet:public VRMLShapes {
private:
public:
	int startIndex;
	int numPoints;

	PointSet(char *name);
	~PointSet();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// Rotation
class Rotation:public VRMLMisc {
private:      
public:
	Vertex4d rotation;

	Rotation (char *name);
	~Rotation();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Scale
class Scale:public VRMLMisc {
private:       
public:
	Vertex3d scaleFactor;

	Scale(char *name);
	~Scale();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Separator {}
class Separator:public VRMLGroups {
private:
	VRMLState state;
public:
	int renderCulling;

	Separator (char *name);
	~Separator ();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// ShapeHints
class ShapeHints:public VRMLMisc {
private:        
public:
	VertexOrder vertexOrdering;
	ShapeType shapeType;
	FaceType faceType;
	float creaseAngle;

	ShapeHints(char *name);
	~ShapeHints();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Node Sphere {}
class Sphere:public VRMLShapes {
private:
public:
	double radius;

	Sphere (char *name);
	~Sphere();

	VRMLNode *Clone();
	void Copy (VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
// SpotLight
class SpotLight:public VRMLLights {
private:
public:
	Vertex3d direction;
	float dropOffRate;
	float cutOffAngle;

	SpotLight(char *name);
	~SpotLight();

	void SetDefault();

	VRMLNode *Clone();
	void Copy(VRMLNode *n); 
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Switch
class Switch:public VRMLGroups {
private:
public:
	int whichChild;

	Switch (char *name);
	~Switch();

	VRMLNode *Clone();
	void Copy(VRMLNode *n); 
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Texture2
class Texture2:public VRMLMisc {
private:
	char filename[255];
public:
	int wrapS;
	int wrapT;
	int width;
	int height;
	int component;
	UBYTE *image;
	
	Texture2(char *name);
	~Texture2();

	void SetFileName(char *fn);
	char *GetFileName();
				       
	VRMLNode *Clone();
	void Copy(VRMLNode *n); 
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void InitGLTexture(struct GLContext *glcontext);
	int LoadImage();
	int ScaleImage(struct GLContext *glcontext);
};
// Texture2Transform
class Texture2Transform:public VRMLMisc {
private:
public:
	Vertex2d translation;
	float rotation;
	Vertex2d scaleFactor;
	Vertex2d center;
	
	Texture2Transform(char *name);
	~Texture2Transform();

	void SetDefault();

	VRMLNode *Clone();
	void Copy(VRMLNode *n); 
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// TextureCoordinate2
class TextureCoordinate2:public VRMLMisc {
private:

public:
	PList<Vertex2d> point;

	TextureCoordinate2(char *name);
	~TextureCoordinate2();

	int Size();

	void AddPoint(Vertex2d *p);
	void InsertPoint(int where, Vertex2d *p);
	Vertex2d *GetPoint(int index);
	Vertex2d *RemovePoint(int index);

	void Clear();

	VRMLNode *Clone();
	void Copy(VRMLNode *n); 
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// Transform
class Transform:public VRMLMisc {
private:
public:
	Vertex3d translation;
	Vertex4d rotation;
	Vertex3d scaleFactor;
	Vertex4d scaleOrientation;
	Vertex3d center;

	Transform(char *name);
	~Transform();

	void SetDefault();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// TransformSeparator
class TransformSeparator:public VRMLGroups {
private:
public:
       TransformSeparator(char *name);
       ~TransformSeparator();

       VRMLNode *Clone();
       void Copy(VRMLNode *n);
       void Print();
       BOOL DrawGL(VRMLState *st);
       void DrawGLBox(struct GLContext *glcontext);
};
// Translation
class Translation:public VRMLMisc {
private:
public:
	Vertex3d translation;

	Translation(char *name);
	~Translation();
				 
	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// WWWAnchor
class WWWAnchor:public VRMLGroups {
private:
	VRMLState state;
	char url[255];
	char description[255];
public:
	int map;
	
	WWWAnchor(char *name);
	~WWWAnchor();

	void SetURL(char *name);
	char *GetURL();
	void SetDescription(char *d);
	char *GetDescription();
			    
	VRMLNode *Clone();
	void Copy(VRMLNode *n); 
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
};
// WWWInline
class WWWInline:public VRMLShapes {
private:
	char url[255];
	
public:
	VRMLNode *in;
	Vertex3d bboxSize;
	Vertex3d bboxCenter;
	
	WWWInline(char *name);
	~WWWInline();

	void SetURL(char *name);
	char *GetURL();

	VRMLNode *Clone();
	void Copy(VRMLNode *n); 
	void Print() {};
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse (VRMLState *st);
};
/*------------------------
  Pseudo Node USE (keyword)
-------------------------*/
class USE:public VRMLShapes {
private:
public:
	VRMLNode *reference;

	USE(char *name);
	~USE();

	VRMLNode *Clone();
	void Copy(VRMLNode *n);
	void Print();
	BOOL DrawGL(VRMLState *st);
	void DrawGLBox(struct GLContext *glcontext);
	void Browse(VRMLState *st);
};
#endif
