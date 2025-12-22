/*------------------------------------------------------
  GLConvert.h
  Version: 0.2
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Convert VRML structure to GL structure
------------------------------------------------------*/
#include "VRMLSupport.h"

class GLConvert {
	MUIGauge *gauge;
	float angle;
private:
	VRMLState st;

	GLNode *ConvertCone(Cone *c);
	GLNode *ConvertCube(Cube *c);
	GLNode *ConvertCylinder(Cylinder *c);
	GLNode *ConvertDirectionalLight(DirectionalLight *dl);
	GLNode *ConvertGroup(Group *g);
	GLNode *ConvertIFS(IndexedFaceSet *ifs);
	GLNode *ConvertILS(IndexedLineSet *ils);
	GLNode *ConvertLOD(LOD *lod);
	GLNode *ConvertMatrixTransform(MatrixTransform *m);
	GLNode *ConvertPointLight(PointLight *pl);
	GLNode *ConvertRotation(Rotation *r);
	GLNode *ConvertScale(Scale *s);
	GLNode *ConvertSeparator(Separator *s);
	GLNode *ConvertSphere(Sphere *s);
	GLNode *ConvertSpotLight(SpotLight *sl);
	GLNode *ConvertTransform(Transform *t);
	GLNode *ConvertTransformSeparator(TransformSeparator *ts);
	GLNode *ConvertTranslation(Translation *t);
	GLNode *ConvertWWWInline(WWWInline *www);
	GLNode *ConvertWWWAnchor(WWWAnchor *www);
	
public:
	GLConvert(MUIGauge *g,int coneres, int cylinderres, int sphereres, float a);
	~GLConvert();

	GLNode *ConvertVRML(VRMLNode *n);
};
