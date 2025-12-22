/*-------------------------------------------
  GEOParser.h
  Version: 0.1
  Date: 5 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Functions to Parse a GEO file
        Only interface with VRMLSupport.cc
----------------------------------------------*/
// #include "Main.h"

#include "VRMLSupport.h"

class GEOParser {
private:
        FILE *ofd;
        MUIGauge *obj;

        int Size;
        int Pos;
        int pt;
        char *Lst;

        VRMLGroups *mg;

        void NextValue(char temp[255]);

        // Read Each Node
        Coordinate3 *ReadPoints();
        IndexedFaceSet *ReadFaces();
public:
        GEOParser();
        ~GEOParser();

        VRMLGroups *LoadGEO(MUIGauge *gauge,FILE *fd, FILE *pfd, int pt);
};
