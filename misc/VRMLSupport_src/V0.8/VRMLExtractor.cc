/*------------------------------------------------------
  VRMLExtractor.cc
  Version: 0.2
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Convert VRML structure to GL structure
------------------------------------------------------*/
#include <math.h>
#include <libraries/mui.h>

#include "VRMLSupport.h"
#include "VRMLExtractor.h"

// #include "Lists.hpp"

VRMLExtractor::VRMLExtractor(VRMLNode *n) {
    node=n;
    // puts("VRMLExtractor Constructor");
}
VRMLExtractor::~VRMLExtractor() {
}

void VRMLExtractor::ExtractCameras(PList<VRMLCameras> *cl) {
    Browse(node,cl);
}

void VRMLExtractor::Browse(VRMLNode *n, PList<VRMLCameras> *cl) {
    int i=0;

    // printf("processing node type:%d\n",n->ID);
    if ((n->ID&GROUPS)==GROUPS) {
	VRMLGroups *gr=(VRMLGroups *) n;
	for (i=0;i<gr->Size();i++) {
	    Browse(gr->GetChild(i),cl);
	};
    }
    else if ((n->ID==ORTHOGRAPHICCAMERA_1)||
	     (n->ID==PERSPECTIVECAMERA_1)) {
	// printf("found camera\n");
	// VRMLCameras *newcam=(VRMLCameras)
	cl->Add((VRMLCameras *) n->Clone());
    };
}

VRMLNode *VRMLExtractor::FindNode(char *name) {
    if (node==NULL) return NULL;
    return Find(node,name);
}

VRMLNode *VRMLExtractor::Find(VRMLNode *n, char *name) {
    VRMLNode *find=NULL;
    int i=0;

    if ((n->ID&GROUPS)==GROUPS) {
	VRMLGroups *gr=(VRMLGroups *) n;
	if (!strcmp(name,gr->GetName())) return (VRMLNode *) gr;
	for (i=0;i<gr->Size();i++) {
	    find=Find(gr->GetChild(i),name);
	    if (find) return find;
	};
	return NULL;
    }
    else {
	if (!strcmp(name,n->GetName())) {
	    return (VRMLNode *) n;
	};
	return NULL;
    };
}
