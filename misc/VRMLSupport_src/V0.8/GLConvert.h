/*------------------------------------------------------
  GLConvert.h
  Version: 0.2
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Convert VRML structure to GL structure
------------------------------------------------------*/
#include "VRMLSupport.h"

// #define DEBUG
class GLConvert {
private:
	APTR WI_Msg;
	APTR GA_Msg;
	APTR TX_Msg;
	GLConvertParams *cp;

	GLVertex3d *cglcoordinate;
	GLMaterial *cglmaterial;
	GLVertex3d *cglnormal;
	GLVertex2d *cgltexcoord;

	GLNode *ConvertCone(Cone *c);
	GLVertex3d *ConvertCoordinate3(Coordinate3 *c);
	GLNode *ConvertCube(Cube *c);
	GLNode *ConvertCylinder(Cylinder *c);
	GLNode *ConvertDirectionalLight(DirectionalLight *dl);
	GLNode *ConvertGroup(Group *g);
	GLNode *ConvertIFS(IndexedFaceSet *ifs);
	GLNode *ConvertILS(IndexedLineSet *ils);
	GLNode *ConvertLOD(LOD *lod);
	GLMaterial *ConvertMaterial(Material *m);
	GLNode *ConvertMatrixTransform(MatrixTransform *m);
	GLVertex3d *ConvertNormal(Normal *n);
	GLNode *ConvertPointLight(PointLight *pl);
	GLNode *ConvertRotation(Rotation *r);
	GLNode *ConvertScale(Scale *s);
	GLNode *ConvertSeparator(Separator *s);
	GLNode *ConvertSphere(Sphere *s);
	GLNode *ConvertSpotLight(SpotLight *sl);
	GLNode *ConvertTexture2(Texture2 *t);
	GLVertex2d *ConvertTextureCoordinate2(TextureCoordinate2 *tc);
	GLNode *ConvertTexture2Transform(Texture2Transform *tc);
	GLNode *ConvertTransform(Transform *t);
	GLNode *ConvertTransformSeparator(TransformSeparator *ts);
	GLNode *ConvertTranslation(Translation *t);
	GLNode *ConvertWWWInline(WWWInline *www);
	GLNode *ConvertWWWAnchor(WWWAnchor *www);
	
public:
	GLConvert(GLConvertParams *par);
	~GLConvert();

	GLNode *ConvertVRML(VRMLNode *n);
};
