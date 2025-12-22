/*----------------------------------------------------
  VRMLSaver.h
  Version 0.1
  Date: 16 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: All VRML V1.0 (ascii) output
-----------------------------------------------------*/
#ifndef VRML2SAVER_H
#define VRML2SAVER_H

#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>

#include "VRMLSupport.h"


class VRML2Saver {
private:
	APTR WI_Msg;
	APTR GA_Msg;
	APTR TX_Msg;

	FILE *f;
	SaveVRMLParams *sp;
	VRMLNode *lastnode;
	VRMLNode *currentnode;
	VRMLGroups *currentgroup;

	int nb;

	void WriteTabs(int t);

	void WriteAsciiText(AsciiText *a,int tab);
	void WriteCone(Cone *c,int tab);
	void WriteCoordinate3(Coordinate3 *c,int tab);
	void WriteCube(Cube *c,int tab);
	void WriteCylinder(Cylinder *c,int tab);
	void WriteDirectionalLight(DirectionalLight *dl,int tab);
	void WriteFontStyle(FontStyle *fs,int tab);
	void WriteGroup(Group *g,int tab);
	void WriteIFS(IndexedFaceSet *ifs,int tab);
	void WriteILS(IndexedLineSet *ils,int tab);
	void WriteInfo(VInfo *in,int tab);
	void WriteLOD(LOD *l,int tab);
	void WriteMaterial(Material *m,int tab);
	void WriteMaterialBinding(MaterialBinding *mb,int tab);
	void WriteMatrixTransform(MatrixTransform *mt,int tab);
	void WriteNormal(Normal *n,int tab);
	void WriteNormalBinding(NormalBinding *nb,int tab);
	void WriteOC(OrthographicCamera *oc,int tab);
	void WritePC(PerspectiveCamera *pc,int tab);
	void WritePointLight(PointLight *pl,int tab);
	void WritePointSet(PointSet *ps,int tab);
	void WriteRotation(Rotation *r,int tab);
	void WriteScale(Scale *s,int tab);
	void WriteSeparator(Separator *s,int tab);
	void WriteShapeHints(ShapeHints *sh,int tab);
	void WriteSphere(Sphere *s,int tab);
	void WriteSpotLight(SpotLight *sl,int tab);
	void WriteSwitch(Switch *sw,int tab);
	void WriteTexture2(Texture2 *n,int tab);
	void WriteTexture2Transform(Texture2Transform *tt,int tab);
	void WriteTextureCoordinate2(TextureCoordinate2 *tc,int tab);
	void WriteTransform(Transform *t,int tab);
	void WriteTransformSeparator(TransformSeparator *ts,int tab);
	void WriteTranslation(Translation *t,int tab);
	void WriteWWWAnchor(WWWAnchor *www,int tab);
	void WriteWWWInline(WWWInline *www,int tab);
	void WriteUSE(USE *u,int tab);

	void SaveNode(VRMLNode *n,int tab);
public:
	VRML2Saver(SaveVRMLParams *par);
	~VRML2Saver();

	void WriteVRML_V2(FILE *fd,VRMLNode *n);
};
#endif
