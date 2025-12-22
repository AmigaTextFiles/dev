/*----------------------------------------------------
  OpenGLSaver.h
  Version 0.1
  Date: 18 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: All OpenGL source code output
-----------------------------------------------------*/
#ifndef MWSAVER_H
#define MWSAVER_H

#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>

#include "VRMLSupport.h"


class MWSaver {
private:
	APTR WI_Msg;
	APTR GA_Msg;
	APTR TX_Msg;

	SaveMWParams *sp;
	VRMLState st;
	ULONG mwhd;
	int nb;

	void WriteMat(Mat *m);

	// void WriteAsciiText(AsciiText *a,int tab);
	void WriteCone(Cone *c);
	void WriteCoordinate3(Coordinate3 *c);
	void WriteCube(Cube *c);
	void WriteCylinder(Cylinder *c);
	// void WriteDirectionalLight(DirectionalLight *dl,int tab);
	// void WriteFontStyle(FontStyle *fs,int tab);
	void WriteGroup(Group *g);
	void WriteIFS(IndexedFaceSet *ifs);
	// void WriteILS(IndexedLineSet *ils, int tab);
	// void WriteInfo(VInfo *in,int tab);
	void WriteLOD(LOD *l);
	void WriteMaterial(Material *m);
	void WriteMaterialBinding(MaterialBinding *mb);
	// void WriteMatrixTransform(MatrixTransform *mt);
	// void WriteNormal(Normal *n,int tab);
	// void WriteNormalBinding(NormalBinding *nb,int tab);
	// void WriteOC(OrthographicCamera *oc,int tab);
	// void WritePC(PerspectiveCamera *pc,int tab);
	// void WritePointLight(PointLight *pl,int tab);
	void WritePointSet(PointSet *ps);
	void WriteRotation(Rotation *r);
	void WriteScale(Scale *s);
	void WriteSeparator(Separator *s);
	// void WriteShapeHints(ShapeHints *sh,int tab);
	void WriteSphere(Sphere *s);
	// void WriteSpotLight(SpotLight *sl,int tab);
	void WriteSwitch(Switch *sw);
	// void WriteTexture2(Texture2 *n,int tab);
	// void WriteTexture2Transform(Texture2Transform *tt,int tab);
	// void WriteTextureCoordinate2(TextureCoordinate2 *tc,int tab);
	void WriteTransform(Transform *t);
	void WriteTransformSeparator(TransformSeparator *ts);
	void WriteTranslation(Translation *t);
	void WriteWWWAnchor(WWWAnchor *www);
	void WriteWWWInline(WWWInline *www);
	void WriteUSE(USE *u);

	void SaveNode(VRMLNode *n);
public:
	MWSaver(SaveMWParams *par);
	~MWSaver();

	VRMLStatus WriteMW(char *filename,VRMLNode *n);
};
#endif
