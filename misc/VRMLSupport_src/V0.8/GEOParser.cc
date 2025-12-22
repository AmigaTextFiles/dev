/*-------------------------------------------
  GEOParser.cc
  Version: 0.1
  Date: 5 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Functions to Parse a GEO file
	Only interface with VRMLSupport.cc
----------------------------------------------*/
#include <libraries/mui.h>

#include "GEOParser.h"
// #include "MUI_VRMLEditor.h"

GEOParser::GEOParser() {
    Size=0;Pos=0;
    pt=ALLMSG;
    ofd=NULL;
    mg=NULL;
    Lst=NULL;
    obj=NULL;
}
GEOParser::~GEOParser() {
}

VRMLGroups *GEOParser::LoadGEO(MUIGauge *gauge,FILE *fd,FILE *pfd,int opt) {
    char temp[255];
    pt=opt;
    obj=gauge;
    ofd=pfd;

    SetAttrs((Object *) obj->Txt, MUIA_Text_Contents, "Preparing VRML nodes");
    SetAttrs((Object *) obj->Gauge, MUIA_Gauge_Current,0);
    SetAttrs((Object *) obj->Win, MUIA_Window_Open, TRUE);

    // Init VRMLNodes
    mg=(VRMLGroups *) new Separator("ROOT");
    Material *mat=new Material("Colors");
    mat->AddMaterial(new Mat(0,0,0));        // Noir
    mat->AddMaterial(new Mat(0,0,0.7));      // Bleu fonce
    mat->AddMaterial(new Mat(0,0.7,0));      // Vert fonce
    mat->AddMaterial(new Mat(0,0.7,0.7));    // Cyan fonce
    mat->AddMaterial(new Mat(0.7,0,0));      // Rouge fonce
    mat->AddMaterial(new Mat(1,0.5,1));      // Rose fonce
    mat->AddMaterial(new Mat(0.8,0.6,0.4));  // Brun
    mat->AddMaterial(new Mat(0.5,0.5,0.5));  // Gris
    mat->AddMaterial(new Mat(0,0,0));        // Noir
    mat->AddMaterial(new Mat(0.4,0.4,1));    // Bleu clair
    mat->AddMaterial(new Mat(0.4,1,0.4));    // Vert clair
    mat->AddMaterial(new Mat(0,1,1));        // Cyan clair
    mat->AddMaterial(new Mat(1,0.4,0.4));    // Rouge clair
    mat->AddMaterial(new Mat(1,0.8,1));      // Rose clair
    mat->AddMaterial(new Mat(1,1,0));        // Jaune
    mat->AddMaterial(new Mat(1,1,1));        // Blanc
    mg->AddChild(mat);
    MaterialBinding *mb=new MaterialBinding("Binding");
    mb->value=BINDING_PER_FACE_INDEXED;
    mg->AddChild(mb);

    SetAttrs((Object *) obj->Txt, MUIA_Text_Contents, "Loading file");
    SetAttrs((Object *) obj->Gauge, MUIA_Gauge_Current,0);
    Size=fseek(fd,0,SEEK_END);
    Size=ftell(fd);
   
    Lst=(char *) malloc(Size);
    rewind(fd);
    fread(Lst,1,Size,fd);

    SetAttrs((Object *) obj->Gauge, MUIA_Gauge_Max, Size);
    SetAttrs((Object *) obj->Txt, MUIA_Text_Contents, "Parsing GEO ascii (3DG1) file");
    // Begin the Geo parsing
    if (pfd!=NULL) {
	if (opt==ALLMSG) {
	    fprintf(pfd,"**** BEGIN OF PARSING GEO FILE****\n");
	};
    };
    Pos=4;
    mg->AddChild(ReadPoints());
    mg->AddChild(ReadFaces());
    free (Lst);
    // delete Lst;
    SetAttrs((Object *) obj->Win, MUIA_Window_Open, FALSE);

    if (pfd!=NULL) {
	if (opt==ALLMSG) {
	    fprintf(pfd,"**** END OF PARSING GEO FILE****\n");
	};
    };
    // puts("<===VRMLParser::LoadGEO");
    return mg;
}

Coordinate3 *GEOParser::ReadPoints() {
    Coordinate3 *c3;
    char temp[255];
    int nbpt,i;
    double x,y,z;

    c3=new Coordinate3("Points");
    NextValue(temp);
    nbpt=atoi(temp);
    for (i=0;i<nbpt;i++) {
	NextValue(temp);
	x=-atof(temp);
	NextValue(temp);
	y=atof(temp);
	NextValue(temp);
	z=atof(temp);
	c3->AddPoint(new Vertex3d(x,y,z));
	SetAttrs((Object *) obj->Gauge, MUIA_Gauge_Current, Pos);
    };
    if (ofd) {
	if (pt==ALLMSG) {
	    fprintf(ofd,"%d points found\n",c3->Size());
	};
    };
    return c3;
}
IndexedFaceSet *GEOParser::ReadFaces() {
    IndexedFaceSet *ifs;
    char temp[255];
    int nbp,i,col;
    Face *cf;
    ifs=new IndexedFaceSet("Faces");
    while (Pos<Size) {
	NextValue(temp);
	nbp=atoi(temp);
	cf=new Face();
	for(i=0;i<nbp;i++) {
	     NextValue(temp);
	     cf->coordIndex.Add(atoi(temp));     
	};
	// Couleur
	NextValue(temp);
	col=atoi(temp);
	col=col%16;
	cf->materialIndex.Add(col);
	ifs->AddFace(cf);
	SetAttrs((Object *) obj->Gauge, MUIA_Gauge_Current, Pos);
    };
    if (ofd) {
	if (pt==ALLMSG) {
	    fprintf(ofd,"%d faces found\n",ifs->Size());
	};
    };
    ifs->writeMaterialIndex=TRUE;
    return ifs;
}
void GEOParser::NextValue(char s[255]) {
	int i=0,j=0;

	/* Avance le curseur jusqu'a la prochaine
	   valeur                              */
	while ((Lst[Pos]==' ')||
	       (Lst[Pos]=='\n')) Pos++;

	/* Copie les valeurs lue dans le listing sur
	   temp                                     */
	while ((Lst[Pos]!=' ')&&
	       (Lst[Pos]!='\n')) {
	       s[i]=Lst[Pos];
	       i++;Pos++;
	};
	s[i]='\0';
	Pos++;
};
