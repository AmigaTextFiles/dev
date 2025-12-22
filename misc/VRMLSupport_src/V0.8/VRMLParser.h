/*-------------------------------------------
  VRMLParser.h
  Version: 0.37
  Date: 28 march 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Functions to Parse a VRML file
	Only interface with VRMLSupport.cc
----------------------------------------------*/
#include "VRMLSupport.h"

/*
typedef struct {
    MaterialBinding *mb;
    Material *m;
    NormalBinding *nb;
    Normal *n;
    Coordinate3 *c3;
    TextureCoordinate2 *tc2;
} ParsingMsg;
*/

class NodeName {
private:
public:
	char def[255];
	VRMLNode *node;

	NodeName();
	NodeName(char *d, VRMLNode *n);
	~NodeName();
};

class NameServer {
private:
public:
	PList<NodeName> deflist;

	NameServer();
	~NameServer();

	void Add (NodeName *nn);
	int Set (char *name, VRMLNode *n);
	VRMLNode *Get(char *name);
	void Clear();
	void Print();
};

class VRMLParser {
private:
	APTR WI_Msg;
	APTR GA_Msg;
	APTR TX_Msg;
	char dir[255];
	FILE *fd;
	LoadVRMLParams *lp;
	NameServer ns;
	// ParsingMsg pmsg;
	VRMLState state;

	int Size;
	int Pos;
	int line;
	char *Lst;

	VRMLGroups *mg;

	void KeywordNotFound(char *key);
	int NextWord(char temp[255]);
	void ReadComment();

	// Read Each Node
	VRMLNode *ReadGroupNodes(char *name, char *newdefname);

	VRMLNode *ReadAsciiTextNode(char *name);
	VRMLNode *ReadConeNode(char *name);
	VRMLNode *ReadCoordinate3Node(char *name);
	VRMLNode *ReadCubeNode(char *name);
	VRMLNode *ReadCylinderNode(char *name);
	VRMLNode *ReadDirectionalLightNode(char *name);
	VRMLNode *ReadFontStyleNode(char *name);
	VRMLNode *ReadGroupNode(char *name);
	VRMLNode *ReadIndexedFaceSetNode(char *name);
	VRMLNode *ReadIndexedLineSetNode(char *name);
	VRMLNode *ReadInfoNode(char *name);
	VRMLNode *ReadLODNode(char *name);
	VRMLNode *ReadMaterialNode(char *name);
	VRMLNode *ReadMaterialBindingNode(char *name);
	VRMLNode *ReadMatrixTransformNode(char *name);
	VRMLNode *ReadNormalNode(char *name);
	VRMLNode *ReadNormalBindingNode(char *name);
	VRMLNode *ReadOrthographicCameraNode(char *name);
	VRMLNode *ReadPerspectiveCameraNode(char *name);
	VRMLNode *ReadPointLightNode(char *name);
	VRMLNode *ReadPointSetNode(char *name);
	VRMLNode *ReadRotationNode(char *name);
	VRMLNode *ReadScaleNode(char *name);
	VRMLNode *ReadSeparatorNode(char *name);
	VRMLNode *ReadShapeHintsNode(char *name);
	VRMLNode *ReadSphereNode(char *name);
	VRMLNode *ReadSpotLightNode(char *name);
	VRMLNode *ReadSwitchNode(char *name);
	VRMLNode *ReadTexture2Node(char *name);
	VRMLNode *ReadTexture2TransformNode(char *name);
	VRMLNode *ReadTextureCoordinate2Node(char *name);
	VRMLNode *ReadTransformNode(char *name);
	VRMLNode *ReadTransformSeparatorNode(char *name);
	VRMLNode *ReadTranslationNode(char *name);
	VRMLNode *ReadWWWAnchorNode(char *name);
	VRMLNode *ReadWWWInlineNode(char *name);

	VRMLNode *ReadUSENode(char *name);
public:
	VRMLParser(LoadVRMLParams *par);
	~VRMLParser();

	VRMLGroups *LoadVRML_V1(char *filename);
};

