/*-----------------------------------------------------------------
  NProducer.h
  Version 0.1
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Create a normal node from Coordinate3 and IndexedFaceSet
------------------------------------------------------------------*/
#ifndef NPRODUCER_H
#define NPRODUCER_H

#include "VRMLSupport.h"

class NProducer {
private:
    APTR WI_Msg;
    APTR GA_Msg;
    APTR TX_Msg;
    ProduceNormalParams *pn;
    Coordinate3 *c3;
    VRMLNode *node;

    Vertex3d GenerateNormal(Vertex3d *point1,Vertex3d *point2,Vertex3d *point3);
    float FindAngle(Vertex3d n1, Vertex3d n2);
    float FindNorme(Vertex3d n);

public:
    NProducer(ProduceNormalParams *par, Coordinate3 *c, VRMLNode *n);
    ~NProducer();

    Normal *ProduceNormal();
};
#endif
