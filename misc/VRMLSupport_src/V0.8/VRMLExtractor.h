/*------------------------------------------------------
  VRMLExtractor.h
  Version: 0.2
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Convert VRML structure to GL structure
------------------------------------------------------*/
#include "VRMLSupport.h"

class VRMLExtractor {
private:
    VRMLNode *node;

    VRMLNode *Find(VRMLNode *n,char *name);
    void Browse(VRMLNode *n,PList<VRMLCameras> *cl);
public:
	VRMLExtractor(VRMLNode *n);
	~VRMLExtractor();

	VRMLNode *FindNode(char *name);
	void ExtractCameras(PList<VRMLCameras> *cl);
};
