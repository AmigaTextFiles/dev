/*----------------------------------------------------
  OpenGLSaver.h
  Version 0.1
  Date: 18 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: All OpenGL source code output
-----------------------------------------------------*/
#ifndef OPENGLSAVER_H
#define OPENGLSAVER_H

#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>

#include "VRMLSupport.h"


class OpenGLSaver {
private:
	FILE *f;
	SaveOpenGLParams *sp;
	VRMLState st;
	int nb;

	void WriteTabs(int t);
	void WriteMat(Mat *m,int tab);

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
	OpenGLSaver(SaveOpenGLParams *par);
	~OpenGLSaver();

	void WriteOpenGL(FILE *fd,VRMLNode *n);
};
#endif
