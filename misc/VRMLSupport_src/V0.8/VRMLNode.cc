/*---------------------------------------------
  VRMLNode.cc
  Version 0.70
  Date: 5 october 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Base Part
-----------------------------------------------*/
#include <math.h>

#include <datatypes/pictureclass.h>
#include <datatypes/pictureclassext.h>
#include <cybergraphx/cybergraphics.h>
#include <libraries/mui.h>

#include <proto/graphics.h>
#include <proto/datatypes.h>
#include <proto/exec.h>
#include <proto/cybergraphicsnew.h>

#include "VRMLNode.h"

/*----------------------------
  VRML Super classes
-----------------------------*/
// VRMLNode
void VRMLNode::SetTypeName(char t[25]) {
	strncpy(Type,t,25);
}
char *VRMLNode::GetTypeName() {
	return Type;
}
char *VRMLNode::GetName() {
	return defname;
}
void VRMLNode::SetName(char name[25]) {
	strncpy(defname,name,25);
}

void VRMLNode::GetSemaphore() {
    // puts("Try to obtain the semaphore");
    // ObtainSemaphore(sema);
    // puts("Get it !!!");
}
void VRMLNode::PutSemaphore() {
    // ReleaseSemaphore(sema);
    // puts("sema released");
}
void VRMLNode::CommonInit() {
    // sema=(struct SignalSemaphore *) AllocVec(sizeof(struct SignalSemaphore),MEMF_PUBLIC|MEMF_CLEAR);
    // InitSemaphore(sema);
    //sema=NULL;
    // if (sema) puts("InitSemaphore successful");
    ref=0;
}
void VRMLNode::CommonFree() {
    // FreeVec(sema);
};

// VRMLShapes
void VRMLShapes::RefreshGauge(VRMLState *st) {
   double xmax=0;

   if (st) {
      if (st->gauge) {
	 // SetAttrs((Object *) st->glcontext->glarea, MCCA_GLArea_GaugeLevel, st->currentpolygone);
	xmax=(double) ((double)_mwidth(st->glcontext->glarea)/(double) (st->totalpolygones))*(double) st->currentpolygone+1.0;
	// printf("width:%d xmax:%f total:%d currentpolygone:%d\n",_mwidth(st->glcontext->glarea),xmax,st->totalpolygones,st->currentpolygone);
	SetAPen(_rp(st->glcontext->glarea),2);
	RectFill(_rp(st->glcontext->glarea),_mleft(st->glcontext->glarea),_mtop(st->glcontext->glarea)+_mheight(st->glcontext->glarea)-2,_mleft(st->glcontext->glarea)+(int) xmax,_mtop(st->glcontext->glarea)+_mheight(st->glcontext->glarea)-1);
      };
   };
}

// VRMLGroups
int VRMLGroups::Size() {
   return children.Length();
}
void VRMLGroups::SetChild (int where, VRMLNode *n) {
   children.Set(where,n);
}
void VRMLGroups::AddChild (VRMLNode *n) {
   children.Add(n);
}
void VRMLGroups::InsertChild(int where, VRMLNode *n) {
   children.InsertAfter(where,n);
}
BOOL VRMLGroups::InsertNode(VRMLNode *af, VRMLNode *n, int level) {
    VRMLNode *current=NULL;
    if (af==this) {
	// puts("VRMLGroups::InsertNode after myself");
	children.Add(n);
	return TRUE;
    };
    for (int i=0;i<children.Length();i++) {
	current=children.Get(i);
	if (current==af) {
	    children.InsertAfter(i,n);
	    return TRUE;
	};
	if (level==ALL_LEVEL) {
	    if (current->ID&GROUPS) {
		VRMLGroups *gcurrent=(VRMLGroups *) current;
		if (gcurrent->InsertNode(af,n,level)) return TRUE;
	    };
	};
    };
    return FALSE;
}
VRMLNode *VRMLGroups::GetChild(int where) {
   return children.Get(where);
}
VRMLNode *VRMLGroups::RemoveChild(int where) {
   return children.RemoveEntry(where);
}
VRMLNode *VRMLGroups::RemoveNode(VRMLNode *n,int level) {
    VRMLNode *current=NULL;
    for (int i=0;i<children.Length();i++) {
	current=children.Get(i);
	if (n==current) return children.RemoveEntry(i);
	if (level==ALL_LEVEL) {
	    if (current->ID&GROUPS) {
		VRMLGroups *gcurrent=(VRMLGroups *)current;
		current=gcurrent->RemoveNode(n,level);
		if (current) return current;
	    };
	};
    };
    return NULL;
}
int VRMLGroups::FindPosition(VRMLNode *n) {
    for (int i=0;i<children.Length();i++) {
	if (n==children.Get(i)) return i;
    };
    return -1;
}
void VRMLGroups::ClearChildren() {
   children.ClearList();
}
void VRMLGroups::ExchangeChildren(int source, int target) {
   children.Exchange(source,target);
}
void VRMLGroups::Browse(VRMLState *st) {
   st->totalnodes++;
   if ((ID&GROUPS)==GROUPS) {
	for (int i=0;i<children.Length();i++) {
	    children.Get(i)->Browse(st);
	};
   };
}
int VRMLGroups::UseCamera(char *cname) {
    /*
    VRMLNode *n=NULL;
    int rep=0;

    for (int i=0;i<children.Length();i++) {
	n=children.Get(i);
	if ((n->ID&GROUPS)==GROUPS) {
	    VRMLGroups *gr=(VRMLGroups *) n;
	    rep=gr->UseCamera(cname);
	    if (rep==1) return 1;
	}
	else if (((n->ID&ORTHOGRAPHICCAMERA_1)==ORTHOGRAPHICCAMERA_1)||
		 ((n->ID&PERSPECTIVECAMERA_1)==PERSPECTIVECAMERA_1)) {
	    VRMLCameras *cam=(VRMLCameras *) n;
	    if (!strcmp(cname,cam->GetName())) {
		puts("Found camera");
		cam->DrawGLCamera();
		return 1;
	    };
	}
	else if ((n->ID&ROTATION_1)==ROTATION_1) {
	    n->DrawGLBox();
	}
	else if ((n->ID&SCALE_1)==SCALE_1) {
	    n->DrawGLBox();
	}
	else if ((n->ID&TRANSFORM_1)==TRANSFORM_1) {
	    n->DrawGLBox();
	}
	else if ((n->ID&TRANSLATION_1)==TRANSLATION_1) {
	    n->DrawGLBox();
	};
    };
    */
    return 0;
}
// VRMLLights
void VRMLLights::SetON() {
   on=1;
}
void VRMLLights::SetOFF() {
   on=0;
}
void VRMLLights::Browse(VRMLState *st) {
   st->totalnodes++;
   st->totallights++;
}

// VRMLCameras
void VRMLCameras::Browse(VRMLState *st) {
   st->totalnodes++;
   st->totalcameras++;
}

// VRMLMisc
void VRMLMisc::Browse(VRMLState *st) {
   st->totalnodes++;
   if (ID==MATERIAL_1) {
      Material *mat=(Material *) this;
      st->totalmaterials+=mat->Size();
   };
}
/*****************
 * VRML Nodes    *
 *****************/
/*--------------------------------------
  AsciiText
---------------------------------------*/
AsciiText::AsciiText(char *name)
	:txt() {
	// puts("In AsciiText constuctor");
	ID=ASCIITEXT_1;
	CommonInit();
	SetName(name);
	// type=AsciiTextID;
	// SetTypeName("AsciiText");
	spacing=1;
	justification=JUSTIFICATION_LEFT;
}
AsciiText::~AsciiText() {
    // puts("In AsciiText destructor");
    
}
int AsciiText::Size() {
   return txt.Length();
}
void AsciiText::AddTxt (StringWidth *sw) {
   // puts("in Asciitext::AddTxt");
   txt.Add(sw);
}
void AsciiText::InsertTxt(int where, StringWidth *sw) {
   txt.InsertAfter(where,sw);
}
StringWidth *AsciiText::GetTxt (int where) {
   return txt.Get(where);
}
StringWidth *AsciiText::RemoveTxt (int where) {
   return txt.RemoveEntry(where);
}
void AsciiText::Clear() {
   txt.ClearList();
}
VRMLNode *AsciiText::Clone() {
    AsciiText *a=new AsciiText(GetName());
    a->Copy(this);
    return (VRMLNode *) a;
}
void AsciiText::Copy(VRMLNode *n) {
    // puts("in AsciiText::Copy");
    AsciiText *a=(AsciiText *) n;
    // a->Print();
    StringWidth *csw=NULL;
    txt.ClearList();
    // a->Print();
    for (int i=0;i<a->Size();i++) {
	csw=a->GetTxt(i);
	txt.Add(new StringWidth(csw->str,csw->width));
    };
    spacing=a->spacing;
    justification=a->justification;
    SetName(a->GetName());
}
void AsciiText::Print() {
    for (int i=0;i<txt.Length();i++) {
	printf("String %d:%s width:%5.2f\n",i,txt.Get(i)->str,txt.Get(i)->width);
    };
}
void AsciiText::Browse(VRMLState *st) {
    st->totalnodes++;
}
/*--------------------------------------
  Cone Node
---------------------------------------*/
// Constructor
Cone::Cone(char *name) {
    // puts("Cone Constructor");
    ID=CONE_1;
    CommonInit();
    SetName(name);
    // type=ConeID;
    // SetTypeName("Cone");
    bottomRadius=1;
    parts=SIDES+BOTTOM;
    height=2;
}
Cone::~Cone() {
    // puts("In Cone Destructor");
    CommonFree();
}
VRMLNode *Cone::Clone() {
    Cone *c=new Cone(GetName());
    c->Copy(this);
    return (VRMLNode *) c;
}
void Cone::Copy(VRMLNode *n) {
    Cone *c=(Cone *) n;
    *(this) = *(c);
    SetName(c->GetName());
}
void Cone::Browse(VRMLState *st) {
    // puts("CONE BROWSE");
    st->totalnodes++;
    // printf("totalpolygones:%d\n",m->totalpolygones);
    st->totalpolygones+=st->coneres+1;
    // printf("totalpolygones:%d\n",m->totalpolygones);
}
void Cone::Print() {
    printf("DEF %s Cone{ parts:%d }\n",GetName(),parts);
}
/*--------------------------------------
  Coordinate3
---------------------------------------*/
// Constructor
Coordinate3::Coordinate3 (char *name)
	:point() {
	// puts("In Coordinate3 constructor");
	ID=COORDINATE3_1;
	CommonInit();
	SetName(name);
	// type=Coordinate3ID;
	// SetTypeName("Coordinate3");
}
Coordinate3::~Coordinate3() {
	// puts("In Coordinate3 destructor");
	// Clear();
    CommonFree();
}
int Coordinate3::Size() {
   return point.Length();
}
void Coordinate3::AddPoint(Vertex3d *v) {
   point.Add(v);
}
void Coordinate3::InsertPoint(int index, Vertex3d *v) {
   point.InsertAfter(index,v);
}
Vertex3d *Coordinate3::GetPoint(int index) {
   return point.Get(index);
}
Vertex3d *Coordinate3::RemovePoint(int index) {
   return point.RemoveEntry(index);
}
void Coordinate3::Clear() {
   point.ClearList();
}
VRMLNode *Coordinate3::Clone() {
	Coordinate3 *c=new Coordinate3(GetName());
	c->Copy(this);
	return (VRMLNode *) c;
}
void Coordinate3::Copy(VRMLNode *n) {
	Coordinate3 *c=(Coordinate3 *) n;
	Vertex3d *cv;
	point.ClearList();
	for (int i=0;i<c->Size();i++) {
		cv=c->GetPoint(i);
		point.Add(new Vertex3d(cv->coord[0],cv->coord[1],cv->coord[2]));
	};
	SetName(c->GetName());
}
void Coordinate3::Print() {
	Vertex3d *cv;
	printf ("DEF %s Coordinate3 { %d points }\n",GetName(),point.Length());
	for (int i=0;i<point.Length();i++) {
	    cv=point.Get(i);
	    printf("Point:%d x=%f y=%f z=%f \n",i,
		    cv->coord[0],cv->coord[1],cv->coord[2]);
	};
}

//----------------------------------------------
// Cube 
//----------------------------------------------
Cube::Cube(char *name) {
    // puts("In Cube constructor");
    ID=CUBE_1;
    CommonInit();
    SetName(name);
    // type=CubeID;
    // SetTypeName("Cube");
    width=2.0;
    height=2.0;
    depth=2.0;
}
Cube::~Cube() {
    // puts("In Cube destructor");
    CommonFree();
}
void Cube::Browse(VRMLState *st) {
   st->totalnodes++;
   st->totalpolygones+=6;
}
VRMLNode *Cube::Clone() {
    Cube *c=new Cube(GetName());
    c->Copy(this);
    return (VRMLNode *) c;
}
void Cube::Copy (VRMLNode *n) {
    Cube *c=(Cube *) n;
    *(this) = * (c);
    SetName(c->GetName( ));
}
void Cube::Print() {
    printf("DEF %s Cube {w=%5.2f h=%5.2f d=%5.2f}\n",GetName(),width,height,depth);
}
/*--------------------------------------
  Cylinder
---------------------------------------*/
Cylinder::Cylinder(char *name) {
    // puts("Cylinder Constructor");
    ID=CYLINDER_1;
    CommonInit();
    SetName(name);
    // type=CylinderID;
    // SetTypeName("Cylinder");
    radius=1;
    parts=ALL;
    height=2;
}
Cylinder::~Cylinder() {
    // puts("In Cylinder Destructor");
    CommonFree();
}
VRMLNode *Cylinder::Clone() {
    Cylinder *c=new Cylinder(GetName());
    c->Copy(this);
    return (VRMLNode *) c;
}
void Cylinder::Copy(VRMLNode *n) {
    Cylinder *c=( Cylinder *) n;
    *(this) = *(c);
    SetName(c->GetName());
}
void Cylinder::Browse(VRMLState *st) {
    st->totalnodes++;
    st->totalpolygones+=st->cylinderres+2;
}
void Cylinder::Print() {
    printf("DEF %s Cylinder{ parts:%d }\n",GetName(),parts);
}
/*----------------------------------------------------
  DirectionalLight node
-----------------------------------------------------*/
// Constructor
DirectionalLight::DirectionalLight(char *name) {
    // puts("In DirectionalLight constructor");
    ID=DIRECTIONALLIGHT_1;
    CommonInit();
    color=Color4f();
    point=Vertex4d();
    SetName(name);
    // type=DirectionalLightID;
    // SetTypeName("DirectionalLight");
    on=1;intensity=1.0;
    color.Set(1.0,1.0,1.0,1.0);
    point.Set(0.0,0.0,-1.0,0.0);
}
DirectionalLight::~DirectionalLight() {
    // puts("In DirectionalLight Destructor");
    CommonFree();
}
void DirectionalLight::Copy(VRMLNode *n) {
    DirectionalLight *dl=(DirectionalLight *) n;
    point.Set(dl->point.Get());
    color.Set(dl->color.Get());
    intensity=dl->intensity;
    on=dl->on;
    SetName(dl->GetName());
}
VRMLNode *DirectionalLight::Clone() {
    DirectionalLight *dl=new DirectionalLight(GetName());
    dl->Copy(this);
    return dl;
}
// Methods
//--------
void DirectionalLight::Print() {
    //printf("DEF %s DirectionalLight {LS=%d dir=%5.2f %5.2f %5.2f}\n",GetName(),LS,
    //        direction.x,direction.y,direction.z);
}
/*-----------------------------------------------
  FontStyle Node
------------------------------------------------*/
FontStyle::FontStyle(char *name) {
    ID=FONTSTYLE_1;
    CommonInit();
    SetName(name);
    // type=FontStyleID;
    // SetTypeName("FontStyle");
    size=10;
    family=FONTFAMILY_SERIF;
    style=FONTSTYLE_NONE;
    // puts("In FontStyle constructor");
}
FontStyle::~FontStyle() {
    // puts("In FontStyle destructor");
    CommonFree();
}
void FontStyle::Copy(VRMLNode *n) {
    FontStyle *fs=(FontStyle *) n;
    *(this) = *(fs);
    SetName(fs->GetName());
}
VRMLNode *FontStyle::Clone() {
    FontStyle *fs= new FontStyle(GetName());
    fs->Copy(this);
    return (VRMLNode *) fs;
}
void FontStyle::Print() {
    printf("FontStyle { style %d }\n",style);
}
//--------------------------------------
// Group Node
//--------------------------------------
Group::Group(char *name) {
    // puts("Group constructor");
    ID=GROUP_1;
    CommonInit();
    SetName(name);
    // type=GroupID;
    // SetTypeName("*Group*");
    PList<VRMLNode> children();
}
Group::~Group() {
    CommonFree();
}
void Group::Copy(VRMLNode *n) {
     Group *gr=(Group *) n;

     children.ClearList();
     for (int i=0;i<gr->Size();i++) {
	 AddChild(gr->GetChild(i)->Clone());
     };
     SetName(gr->GetName());
}
VRMLNode *Group::Clone() {
    Group *gr=new Group(GetName());
    gr->Copy(this);
    return (VRMLNode *) gr;
}
void Group::Print() {
    for (int i=0;i<children.Length();i++) {
	children.Get(i)->Print();
    };
}
//-----------------------------------------------
// IndexedFaceSet Node
//-----------------------------------------------
// Constructor
IndexedFaceSet::IndexedFaceSet (char *name)
    :faces(),min(),max() {
    ID=INDEXEDFACESET_1;
    bbox=NOTYET;
    // CommonInit();
    SetName(name);
    // type=IndexedFaceSetID;
    // SetTypeName("IndexedFaceSet");
    writeMaterialIndex=0;
    writeNormalIndex=0;
    writeTextureCoordIndex=0;
    // printf("In IndexedFaceSet constructor");
}
IndexedFaceSet::~IndexedFaceSet() {
    // puts("In IndexedFaceSet Destructor");
    CommonFree();
}
int IndexedFaceSet::Size() {
   return faces.Length();
}
void IndexedFaceSet::AddFace(Face *f) {
   faces.Add(f);
}
void IndexedFaceSet::InsertFace(int where, Face *f) {
   faces.InsertAfter(where,f);
}
Face *IndexedFaceSet::GetFace(int where) {
   return faces.Get(where);
}
Face *IndexedFaceSet::RemoveFace(int where) {
   return faces.RemoveEntry(where);
}    
void IndexedFaceSet::Clear() {
   faces.ClearList();
}
VRMLNode *IndexedFaceSet::Clone() {
     IndexedFaceSet *ifs=new IndexedFaceSet(GetName());
     ifs->Copy(this);
     return (VRMLNode *) ifs;
}
void IndexedFaceSet::Copy(VRMLNode *n) {
     Face *cf;
     IndexedFaceSet *ifs=(IndexedFaceSet *) n;

     // puts("IFS::Copy");
     faces.ClearList();
     // puts("After the clear");
     // printf("size to copy:%d\n",ifs->Size());
     for (int i=0;i<ifs->Size();i++) {
	cf=ifs->GetFace(i);
	Face *nf=new Face(cf);
	faces.Add(nf);
     };
     SetName(ifs->GetName());
     // puts("IFS::Copy finished");
}
void IndexedFaceSet::Browse(VRMLState *st) {
    st->totalnodes++;
    st->totalpolygones+=faces.Length();
}
void IndexedFaceSet::Print() {
	int index=0;
	Face *ftemp=NULL;

	printf ("DEF %s IndexedFaceSet {\n");
	printf ("%d Faces\n",faces.Length());
	for (int i=0;i<faces.Length();i++) {
	    ftemp=faces.Get(i);
	    printf("Faces:%d ",i);
	    printf("Coord:");
	    for (int j=0;j<ftemp->coordIndex.Length();j++) {
		printf("%d ",ftemp->coordIndex.Get(j));
	    };
	    printf(" mat:%d normal:%d tex:%d\n",ftemp->materialIndex,
		    ftemp->normalIndex,ftemp->textureCoordIndex);
	};
	printf("}\n");
}

//-----------------------------------------------
// IndexedLineSet Node
//-----------------------------------------------
// Constructor
IndexedLineSet::IndexedLineSet (char *name)
    :faces(),min(),max() {
    ID=INDEXEDLINESET_1;
    bbox=NOTYET;
    // CommonInit();
    writeMaterialIndex=0;
    writeNormalIndex=0;
    writeTextureCoordIndex=0;
    SetName(name);
    // type=IndexedLineSetID;
    // SetTypeName("IndexedLineSet");
    // puts("In IndexedLineSet constructor");
}
IndexedLineSet::~IndexedLineSet() {
    // puts("In IndexedLineSet Destructor");
    CommonFree();
}
int IndexedLineSet::Size() {
   return faces.Length();
}
void IndexedLineSet::AddLine(Face *f) {
   faces.Add(f);
}
void IndexedLineSet::InsertLine(int where, Face *f) {
   faces.InsertAfter(where,f);
}
Face *IndexedLineSet::GetLine(int where) {
   return faces.Get(where);
}
Face *IndexedLineSet::RemoveLine(int where) {
   return faces.RemoveEntry(where);
}
void IndexedLineSet::Clear() {
   faces.ClearList();
}
VRMLNode *IndexedLineSet::Clone() {
     IndexedLineSet *ils=new IndexedLineSet(GetName());
     ils->Copy(this);
     return (VRMLNode *) ils;
}
void IndexedLineSet::Copy(VRMLNode *n) {
     Face *cf;
     IndexedLineSet *ils=(IndexedLineSet *) n;
     faces.ClearList();
     for (int i=0;i<ils->Size();i++) {
	cf=ils->GetLine(i);
	Face *nf=new Face();
	for (int j=0;j<cf->coordIndex.Length();j++) {
	    nf->coordIndex.Add(cf->coordIndex.Get(j));
	};
	nf->materialIndex=cf->materialIndex;
	nf->normalIndex=cf->normalIndex;
	nf->textureCoordIndex=cf->textureCoordIndex;
	faces.Add(nf);
     };
     SetName(ils->GetName());
}
void IndexedLineSet::Browse(VRMLState *st) {
     st->totalnodes++;
     st->totalpolygones+=faces.Length();
}
void IndexedLineSet::Print() {
	int index;
	Face *ftemp;
	printf ("DEF %s IndexedLineSet {\n");
	printf ("%d Faces\n",faces.Length());
	for (int i=0;i<faces.Length();i++) {
	    ftemp=faces.Get(i);
	    printf("Faces:%d ",i);
	    printf("Coord:");
	    for (int j=0;j<ftemp->coordIndex.Length();j++) {
		printf("%d ",ftemp->coordIndex.Get(j));
	    };
	    printf(" mat:%d normal:%d tex:%d\n",ftemp->materialIndex,
		    ftemp->normalIndex,ftemp->textureCoordIndex);
	};
	printf("}\n");
}
//----------------------------------------------
// Info
//---------------------------------------------
VInfo::VInfo(char *name) {
    ID=INFO_1;
    CommonInit();
    SetName(name);
    // type=InfoID;
    strcpy(string,"<Undefined info>");
    // SetTypeName("Info");
}
VInfo::~VInfo() {
    CommonFree();
}
void VInfo::SetString(char *s) {
    strncpy(string,s,1000);
}
char *VInfo::GetString() {
   return string;
}
void VInfo::Copy(VRMLNode *n) {
    VInfo *in=(VInfo *) n;
    strcpy(string,in->GetString());
    SetName(in->GetName());
}
VRMLNode *VInfo::Clone() {
    VInfo *in=new VInfo(GetName());
    in->Copy(this);
    return (VRMLNode *) in;
}
void VInfo::Print() {
    printf("Info {%s}\n",string);
}
//---------------------------------------------
// LOD
//---------------------------------------------
LOD::LOD(char *name)
    :range(),center(),state() {
    // VRMLState state();
    ID=LOD_1;
    CommonInit();
    SetName(name);
    // type=LODID;
    // SetTypeName("*LOD*");
    center.Set(0.0,0.0,0.0);
    PList<VRMLNode> children();
    // PList<VRMLNode> children();
}
LOD::~LOD() {
    // delete children;
    CommonFree();
}
int LOD::RangeSize() {
   return range.Length();
}
void LOD::AddRange(float r) {
   range.Add(r);
}
void LOD::InsertRange(int where, float r) {
   range.InsertAfter(where,r);
}
void LOD::SetRange(int where, float r) {
   range.Set(where,r);
}
float LOD::RemoveRange(int where) {
   return range.RemoveEntry(where);
}
float LOD::GetRange (int index) {
   return range.Get(index);
}
void LOD::Copy(VRMLNode *n) {
     int i=0;
     LOD *lod=(LOD *) n;
     children.ClearList();
     range.ClearList();
     for (i=0;i<lod->Size();i++) {
	 AddChild(lod->GetChild(i)->Clone());
     };
     for (i=0;i<lod->RangeSize();i++) {
	range.Add(lod->GetRange(i));
     };
     center.Set(lod->center.Get());
     SetName(lod->GetName());
}
VRMLNode *LOD::Clone() {
    LOD *lod=new LOD(GetName());
    lod->Copy(this);
    return (VRMLNode *) lod;
}
void LOD::Print() {
    for (int i=0;i<children.Length();i++) {
	children.Get(i)->Print();
    };
}
//------------------------------------------------------
// Material 
//-----------------------------------------------------
// Constructor
Material::Material(char *name)
    :material() {
    ID=MATERIAL_1;
    CommonInit();
    SetName(name);
    // type=MaterialID;
    // SetTypeName("Material");
    // puts("Material constructor");
}
Material::~Material() {
    // puts("In Material Destructor");
    CommonFree();
}
int Material::Size() {
   return material.Length();
}
void Material::AddMaterial (Mat *m) {
   material.Add(m);
}
void Material::InsertMaterial (int where, Mat *m) {
   material.InsertAfter(where,m);
}
Mat *Material::GetMaterial(int where) {
   return material.Get(where);
}
Mat *Material::RemoveMaterial (int where) {
   return material.RemoveEntry(where);
}
void Material::Clear() {
   material.ClearList();
}
VRMLNode *Material::Clone() {
    Material *m=new Material(GetName());
    m->Copy(this);
    return (VRMLNode *) m;
}
void Material::Copy(VRMLNode *n) {
    Material *m=(Material *) n;
    Mat *cm;

    Clear();
    for (int i=0;i<m->Size();i++) {
	Mat *nm=new Mat();
	cm=m->GetMaterial(i);
	nm->ambient=cm->ambient;
	nm->diffuse=cm->diffuse;
	nm->specular=cm->specular;
	nm->emissive=cm->emissive;
	nm->shininess=cm->shininess;
	nm->transparency=cm->transparency;
	material.Add(nm);
    };
    SetName(m->GetName());
}
void Material::Print() {
    float *a,*d,*s,*e,sh,t;
    Mat *cm=NULL;
    // printf("DEF %s Material {%d Mat}\n",GetName(),material.Length());
    for (int i=0;i<material.Length();i++) {
	cm=material.Get(i);

	d= cm->diffuse.rgb;
	a= cm->ambient.rgb;
	s= cm->specular.rgb;
	e= cm->emissive.rgb;
	sh=cm->shininess;
	t=cm->transparency;
	printf("Mat:%d A:%.4g %.4g %.4g D:%.4g %.4g %.4g "
		"S:%.4f %.4f %.4f E:%.4f %.4f %.4f "
		"Shin:%.4f Tr:%.4f\n",i,
		a[0],a[1],a[2],d[0],d[1],d[2],s[0],s[1],s[2],e[0],e[1],e[2],sh,t);
    };
}
/*---------------------------------------
  MaterialBinding Node
-----------------------------------------*/
// Constructor
MaterialBinding::MaterialBinding (char *name) {
    ID=MATERIALBINDING_1;
    CommonInit();
    SetName(name);
    // type=MaterialBindingID;
    // SetTypeName("MaterialBinding");
    value=BINDING_OVERALL;
}
MaterialBinding::~MaterialBinding () {
    // puts("In MaterialBinding destructor");
    CommonFree();
}
// Methods
//--------
void MaterialBinding::Print() {
    printf("DEF %s MaterialBinding { Type =%d }\n",GetName(),value);
}
VRMLNode *MaterialBinding::Clone() {
    MaterialBinding *mb=new MaterialBinding(GetName());
    mb->Copy(this);
    return (VRMLNode *) mb;
}
void MaterialBinding::Copy(VRMLNode *n) {
    MaterialBinding *mb=(MaterialBinding *) n;
    value=mb->value;
    SetName(mb->GetName());
}
/*----------------------------
  MatrixTransform
-----------------------------*/
MatrixTransform::MatrixTransform(char *name) {
     ID=MATRIXTRANSFORM_1;
     CommonInit();
     SetName(name);
     // type=MatrixTransformID;
     // SetTypeName("MatrixTransform");
     matrix[0]= 1;matrix[1]= 0;matrix[2]= 0;matrix[3]= 0;
     matrix[4]= 0;matrix[5]= 1;matrix[6]= 0;matrix[7]= 0;
     matrix[8]= 0;matrix[9]= 0;matrix[10]=1;matrix[11]=0;
     matrix[12]=0;matrix[13]=0;matrix[14]=0;matrix[15]=1;
}
MatrixTransform::~MatrixTransform() {
    CommonFree();
}
void MatrixTransform::SetMatrixv(float *m) {
	for (int i=0;i<16;i++) {
		matrix[i]=m[i];
	};
}
void MatrixTransform::GetMatrixv(float *m) {
	for (int i=0;i<16;i++) {
		m[i]=matrix[i];
	};
}
void MatrixTransform::Copy(VRMLNode *n) {
    float tab[16];
    MatrixTransform *mt=(MatrixTransform *) n;
    mt->GetMatrixv(tab);
    SetMatrixv(tab);
    SetName(mt->GetName());
}
VRMLNode *MatrixTransform::Clone() {
    MatrixTransform *mt=new MatrixTransform(GetName());
    mt->Copy(this);
    return (VRMLNode *) mt;
}
void MatrixTransform::Print() {
}
/*-----------------------------------
 Normal
---------------------------------------*/
Normal::Normal(char *name)
    :vector() {
    ID=NORMAL_1;
    CommonInit();
    SetName(name);
    // type=NormalID;
    // SetTypeName("Normal");
}
Normal::~Normal() {
    CommonFree();
}
int Normal::Size() {
   return vector.Length();
}
void Normal::AddVector(Vertex3d *p) {
   vector.Add(p);
}
void Normal::InsertVector(int where, Vertex3d *p) {
   vector.InsertAfter(where,p);
}
Vertex3d *Normal::GetVector(int where) {
   return vector.Get(where);
}
Vertex3d *Normal::RemoveVector(int where) {
   return vector.RemoveEntry(where);
}
void Normal::Clear() {
   vector.ClearList();
}
VRMLNode *Normal::Clone() {
    Normal *n=new Normal(GetName());
    n->Copy(this);
    return (VRMLNode *) n;
}
void Normal::Copy(VRMLNode *n) {
    Normal *no=(Normal *) n;
    Vertex3d *cp;

    vector.ClearList();
    for (int i=0;i<no->Size();i++) {
	cp=no->GetVector(i);
	AddVector(new Vertex3d(cp->coord[0],cp->coord[1],cp->coord[2]));
    };
    SetName(no->GetName());
}
/*---------------------------------------
  NormalBinding
----------------------------------------*/
NormalBinding::NormalBinding(char *name) {
    ID=NORMALBINDING_1;
    CommonInit();
    SetName(name);
    // type=NormalBindingID;
    // SetTypeName("NormalBinding");
    value=BINDING_DEFAULT;
}
NormalBinding::~NormalBinding() {
    CommonFree();
}
VRMLNode *NormalBinding::Clone() {
    NormalBinding *nb=new NormalBinding(GetName());
    nb->Copy(this);
    return (VRMLNode *) nb;
}
void NormalBinding::Copy(VRMLNode *n) {
    NormalBinding *nb=(NormalBinding *) n;
    value=nb->value;
}
/*-----------------------------
  OrthographicCamera
------------------------------*/
OrthographicCamera::OrthographicCamera(char *name) {
    ID=ORTHOGRAPHICCAMERA_1;
    // CommonInit();
    SetName(name);
    // type=OrthographicCameraID;
    // SetTypeName("OrthographicCamera");
    position.Set(0.0,0.0,1.0);
    orientation.Set(0.0,0.0,1.0,0.0);
    focalDistance=5.0;
    height=2.0;
}
OrthographicCamera::~OrthographicCamera() {
    // CommonFree();
}
void OrthographicCamera::SetDefault() {
    position.Set(0.0,0.0,1.0);
    orientation.Set(0.0,0.0,1.0,0.0);
    focalDistance=5.0;
    height=2.0;
}
VRMLNode *OrthographicCamera::Clone() {
    OrthographicCamera *oc=new OrthographicCamera(GetName());
    oc->Copy(this);
    return (VRMLNode *) oc;
}
void OrthographicCamera::Copy(VRMLNode *n) {
    // float x,y,z,a;
    OrthographicCamera *oc=(OrthographicCamera *) n;
    position.Set(oc->position.Get());
    orientation.Set(oc->orientation.Get());
    focalDistance=oc->focalDistance;
    height=oc->height;
}
/*------------------------------
  PerspectiveCamera
-------------------------------*/
PerspectiveCamera::PerspectiveCamera(char *name) {
    ID=PERSPECTIVECAMERA_1;
    // CommonInit();
    SetName(name);
    // type=PerspectiveCameraID;
    // SetTypeName("PerspectiveCamera");
    position.Set(0.0,0.0,1.0);
    orientation.Set(0.0,0.0,1.0,0.0);
    focalDistance=5;
    height=0.785398;
}
PerspectiveCamera::~PerspectiveCamera() {
    // CommonFree();
}
void PerspectiveCamera::SetDefault() {
    position.Set(0.0,0.0,1.0);
    orientation.Set(0.0,0.0,1.0,0.0);
    focalDistance=5.0;
    height=0.785398;
}
VRMLNode *PerspectiveCamera::Clone() {
    PerspectiveCamera *oc=new PerspectiveCamera(GetName());
    oc->Copy(this);
    return (VRMLNode *) oc;
}
void PerspectiveCamera::Copy(VRMLNode *n) {
    PerspectiveCamera *oc=(PerspectiveCamera *) n;
    position.Set(oc->position.Get());
    orientation.Set(oc->orientation.Get());
    focalDistance=oc->focalDistance;
    height=oc->height;
}

/*-------------------------------
  PointLight
--------------------------------*/
PointLight::PointLight(char *name) {
    ID=POINTLIGHT_1;
    CommonInit();
    color=Color4f();
    point=Vertex4d();
    SetName(name);
    // type=PointLightID;
    // SetTypeName("PointLight");
    on=1;intensity=1.0;
    color.Set(1.0,1.0,1.0,1.0);
    point.Set(0.0,0.0,1.0,1.0);
}
PointLight::~PointLight() {
    CommonFree();
}
void PointLight::SetDefault() {
    on=1;intensity=1.0;
    color.Set(1.0,1.0,1.0,1.0);
    point.Set(0.0,0.0,1.0,1.0);
}
void PointLight::Copy(VRMLNode *n) {
    PointLight *pl=(PointLight *) n;
    point.Set(pl->point.Get());
    color.Set(pl->color.Get());
    intensity=pl->intensity;
    on=pl->on;
    SetName(pl->GetName());
}
VRMLNode *PointLight::Clone() {
    PointLight *pl=new PointLight(GetName());
    pl->Copy(this);
    return pl;
}
/*----------------------------------------------------
  PointSet Node
------------------------------------------------------*/
// Constructor
PointSet::PointSet(char *name) {
   ID=POINTSET_1;
   CommonInit();
   SetName(name);
   // type=PointSetID;
   // SetTypeName("PointSet");
   startIndex=0;
   numPoints=-1;
}
PointSet::~PointSet() {
    CommonFree();
}
void PointSet::Browse(VRMLState *st) {
   st->totalnodes++;
}
VRMLNode *PointSet::Clone() {
    PointSet *ps=new PointSet(GetName());
    ps->Copy(this);
    return ps;
}
void PointSet::Copy(VRMLNode *n) {
    PointSet *ps=(PointSet *) n;
    *(this) = *(ps);
    SetName(ps->GetName());
}

void PointSet::Print() {
   printf("DEF %s PointSet {startIndex=%d, numPoint=%d ",GetName(),startIndex,numPoints);
}
/*---------------------------------------------------
  Rotation Node
----------------------------------------------------*/
// Constructor
Rotation::Rotation(char *name)
    :rotation() {
    ID=ROTATION_1;
    CommonInit();
    SetName(name);
    // type=RotationID;
    // SetTypeName("Rotation");
    rotation.Set(0,0,1,0);
}
Rotation::~Rotation() {
    // puts("In Rotation Destructor");
    CommonFree();
}
VRMLNode *Rotation::Clone() {
    Rotation *r=new Rotation(GetName());
    r->Copy(this);
    return (VRMLNode *) r;
}
void Rotation::Copy(VRMLNode *n) {
    Rotation *r=(Rotation *) n;
    rotation=r->rotation;
}                            
void Rotation::Print() {
    float x,y,z,a;
    // GetRotation(x,y,z,a);
    // printf("DEF %s Rotation {%1.2f,%1.2f,%1.2f,%1.5f}\n",GetName(),x,y,z,a);
}

/*---------------------------------------------------
  Scale Node
----------------------------------------------------*/
// Constructor
Scale::Scale(char *name)
    :scaleFactor() {
    ID=SCALE_1;
    CommonInit();
    SetName(name);
    // type=ScaleID;
    // SetTypeName("Scale");
    scaleFactor.Set(1.0,1.0,1.0);
}
Scale::~Scale() {
    // puts("In Scale Destructor");
    CommonFree();
}
VRMLNode *Scale::Clone() {
    Scale *s=new Scale(GetName());
    s->Copy(this);
    return (VRMLNode *) s;
}
void Scale::Copy (VRMLNode *n) {
    Scale *s=(Scale *) n;
    scaleFactor=s->scaleFactor;
}
void Scale::Print() {
    float x,y,z;
    // GetScaleFactor(x,y,z);
    // printf("DEF %s Scale {%1.2f,%1.2f,%1.2f}\n",x,y,z);
}
//---------------------------------------------
// Separator Node
//----------------------------------------------
// Constructor
Separator::Separator (char *name)
    :state() {
    // VRMLState state();
    ID=SEPARATOR_1;
    CommonInit();
    SetName(name);
    // type=SeparatorID;
    // SetTypeName("*Separator*");
    renderCulling=CULLING_AUTO;
    // children=new PList<VRMLNode>();
    PList<VRMLNode> children();
}
Separator::~Separator () {
    // puts ("In Separator destructor");
    // ClearChildren();
    // delete children;
    CommonFree();
}
// Methods
//--------
void Separator::Copy(VRMLNode *n) {
     Separator *s=(Separator *) n;
     children.ClearList();
     for (int i=0;i<s->Size();i++) {
	 AddChild(s->GetChild(i)->Clone());
     };
     renderCulling=s->renderCulling;
     SetName(s->GetName());
}
VRMLNode *Separator::Clone() {
    Separator *s=new Separator(GetName());
    s->Copy(this);
    return (VRMLNode *) s;
}
// Print
void Separator::Print() {
    printf("DEF %s Separator {\n",GetName());
    for (int i=0;i<children.Length();i++) {
	GetChild(i)->Print();
    };
    printf("}\n");
}
/*-----------------------------------
  ShapeHints
-------------------------------------*/
ShapeHints::ShapeHints(char *name) {
    ID=SHAPEHINTS_1;
    CommonInit();
    SetName(name);
    // type=ShapeHintsID;
    // SetTypeName("ShapeHints");
    vertexOrdering=UNKNOWN_ORDERING;
    shapeType=UNKNOWN_SHAPE_TYPE;
    faceType=CONVEX;
    creaseAngle=0.5;
}
ShapeHints::~ShapeHints() {
    CommonFree();
}
VRMLNode *ShapeHints::Clone() {
    ShapeHints *sh=new ShapeHints(GetName());
    sh->Copy(this);
    return (VRMLNode *) sh;
}
void ShapeHints::Copy(VRMLNode *n) {
    ShapeHints *sh=(ShapeHints *) n;
    *(this) = *(sh);
    SetName(sh->GetName());
}

//--------------------------------------------
// Sphere Node
//--------------------------------------------
// Constructor
Sphere::Sphere(char *name) {
    ID=SPHERE_1;
    CommonInit();
    SetName(name);
    // type=SphereID;
    // SetTypeName("Sphere");
    radius=1.0;
}
Sphere::~Sphere() {
    CommonFree();
}
// Methods
//--------
// Print
void Sphere::Print() {
    printf("DEF %s Sphere {%f}\n",GetName(),radius);
}
VRMLNode *Sphere::Clone() {
    Sphere *s=new Sphere(GetName());
    s->Copy(this);
    return (VRMLNode *) s;
}
void Sphere::Copy(VRMLNode *n) {
    Sphere *sp=(Sphere *) n;
    radius=sp->radius;
    SetName(sp->GetName());
}
void Sphere::Browse(VRMLState *st) {
    st->totalnodes++;
    st->totalpolygones+=(st->sphereres*st->sphereres/2);
}

/*------------------------------
  SpotLight
-------------------------------*/
SpotLight::SpotLight(char *name)
    :direction() {
    ID=SPOTLIGHT_1;
    CommonInit();
    color=Color4f();
    point=Vertex4d();
    SetName(name);
    // type=SpotLightID;
    // SetTypeName("SpotLight");
    on=1;intensity=1.0;
    color.Set(1.0,1.0,1.0,1.0);
    point.Set(0.0,0.0,1.0,1.0);
    direction.Set(0.0,0.0,-1.0);
    dropOffRate=0;
    cutOffAngle=0.785398;
}
SpotLight::~SpotLight() {
    CommonFree();
}
void SpotLight::SetDefault() {
    on=1;intensity=1.0;
    color.Set(1.0,1.0,1.0,1.0);
    point.Set(0.0,0.0,1.0,1.0);
    direction.Set(0.0,0.0,-1.0);
    dropOffRate=0;
    cutOffAngle=0.785398;
}
VRMLNode *SpotLight::Clone() {
     SpotLight *sl=new SpotLight(GetName());
     sl->Copy(this);
     return (VRMLNode *) sl;
}
void SpotLight::Copy(VRMLNode *n) {
     SpotLight*sl=(SpotLight *) n;
     *(this) = *(sl);
     SetName(sl->GetName());
}
/*-----------------------------
  Switch
------------------------------*/
Switch::Switch(char *name) {
    ID=SWITCH_1;
    CommonInit();
    SetName(name);
    // type=SwitchID;
    // SetTypeName("*Switch*");
    whichChild=-1;
    // children=new PList<VRMLNode>();
    PList<VRMLNode> children();
}
Switch::~Switch() {
    // delete children;
    CommonFree();
}
VRMLNode *Switch::Clone() {
     Switch *sw=new Switch(GetName());
     sw->Copy(this);
     return (VRMLNode *) sw;
}
void Switch::Copy(VRMLNode *n) {
     Switch *sw=(Switch *) n;
     children.ClearList();
     for (int i=0;i<sw->Size();i++) {
	 AddChild(sw->GetChild(i)->Clone());
     };
     whichChild=sw->whichChild;
     SetName(sw->GetName());
}
void Switch::Print() {
}
/*-----------------------------
  Texture2
------------------------------*/
Texture2::Texture2(char *name) {
    ID=TEXTURE2_1;
    CommonInit();
    SetName(name);
    // type=Texture2ID;
    // SetTypeName("Texture2");
    strcpy(filename,"");
    width=0;height=0;component=0;
    image=NULL;
    wrapS=TEXTURE2_WRAP_REPEAT;
    wrapT=TEXTURE2_WRAP_REPEAT;
}
Texture2::~Texture2() {
    if (image) {free(image);};
    CommonFree();
}
void Texture2::SetFileName(char *fn) {
   strncpy(filename,fn,255);
}
char *Texture2::GetFileName() {
   return filename;
}
VRMLNode *Texture2::Clone() {
    Texture2 *t=new Texture2(GetName());
    t->Copy(this);
    return (VRMLNode *) t;
}
void Texture2::Copy(VRMLNode *n) {
    Texture2 *t=(Texture2 *) n;
    width=t->width;
    height=t->height;
    component=t->component;
    image=(UBYTE *) malloc (width*height*component);
    if (width!=0) {
	for (int i=0;i<height*width*component;i++) {
	    image[i]=t->image[i];
	};
    };
    wrapS=t->wrapS;
    wrapT=t->wrapT;
    strncpy(filename,t->GetFileName(),255);
    SetName(t->GetName());
}
int Texture2::LoadImage() {
    UBYTE *data=NULL,*cimage=NULL,*cdata=NULL;
    APTR bmhd=NULL;
    ULONG store=0;
    Object *dto=NULL;
    int pixelfmt=0,bwidth=0,bheight=0,numcolors=0,index=0,padding=0;
    int bprow=0,nwidth=0,nheight=0,depth=0,i=0,value=0;
    struct BitMap *bm=NULL;
    struct BitMapHeader *bmh=NULL;
    struct ColorRegister *cr=NULL,*ccr=NULL;
    struct RastPort rp;

    // puts("Texture2::LoadImage");
    if (strcmp(filename,"")) {
	dto=NewDTObject(filename,
			DTA_GroupID, GID_PICTURE,
			OBP_Precision, PRECISION_EXACT,
			PDTA_FreeSourceBitMap, TRUE,
			PDTA_DestMode, MODE_V43,
			PDTA_UseFriendBitMap, TRUE,
			TAG_DONE);
	// puts("after the DT object");
	if (dto==NULL) {
	    return -1;
	};
	GetDTAttrs(dto,PDTA_BitMap,(ULONG) &bm,PDTA_BitMapHeader, (ULONG) &bmh);
	// puts("after get");

	width=bmh->bmh_Width;
	height=bmh->bmh_Height;
	depth=bmh->bmh_Depth;
	// printf("bitmapheader width:%d\n",width);
	// printf("bitmapheader height:%d\n",height);
	// printf("bitmapheader depth:%d\n",depth);

	if ((GetBitMapAttr(bm,BMA_FLAGS)&BMF_STANDARD)==BMF_STANDARD) {
	    //--- Standard Bitmap with depth <=8 ---
	    // puts("standard bitmap");
	    bwidth=GetBitMapAttr(bm,BMA_WIDTH);
	    bheight=GetBitMapAttr(bm,BMA_HEIGHT);
	    component=3;
	    GetDTAttrs(dto,PDTA_NumColors,(ULONG) &numcolors, PDTA_ColorRegisters,(ULONG) &cr);
	    // ccr=cr;
	    // printf("num of colors:%d\n",numcolors);

	    /*
	    for (int i=0;i<numcolors;i++) {
		printf("color %d:%d %d %d\n",i,ccr->red,ccr->green,ccr->blue);
		ccr++;
	    };
	    */


	    if (image) free(image);
	    image=(UBYTE *) malloc(width*height*component);
	    cimage=image;

	    InitRastPort(&rp);
	    rp.BitMap=bm;
	    for (int i=height-1;i>=0;i--) {
		for (int j=0;j<width;j++) {
		    value=(int) ReadPixel(&rp,j,i);
		    // printf("%d,",value);
		    ccr=cr+value;
		    *(cimage) = (UBYTE) ccr->red;
		    cimage++;
		    *(cimage) = (UBYTE) ccr->green;
		    cimage++;
		    *(cimage) = (UBYTE) ccr->blue;
		    cimage++;
		};
		// printf("\n");
	    };
	}
	else {
	    //--- CyberGrpahX bitmap ---
	    // puts("cybergraphx bitmap");
	    bwidth=GetCyberMapAttr(bm,CYBRMATTR_WIDTH);
	    bheight=GetCyberMapAttr(bm,CYBRMATTR_HEIGHT);
	    pixelfmt=GetCyberMapAttr(bm,CYBRMATTR_PIXFMT);
	    bprow=GetCyberMapAttr(bm,CYBRMATTR_XMOD);
	    component=GetCyberMapAttr(bm,CYBRMATTR_BPPIX);
	    /*
	    printf("bwidth:%d\n",bwidth);
	    printf("bheight:%d\n",bheight);
	    printf("Bytes per row:%d\n",bprow);
	    printf("component:%d\n",component);
	    printf("format:%d\n",pixelfmt);
	    */
	    if (pixelfmt==PIXFMT_LUT8) {
		// puts("PIXELFMT_LUT8");
		GetDTAttrs(dto,PDTA_NumColors,(ULONG) &numcolors, PDTA_ColorRegisters, (ULONG) &cr);
		component=3;
		// cr=(struct ColorRegister *) store;
		// ccr=cr;
		// printf("num of colors:%d\n",numcolors);

		/*
		for (int i=0;i<numcolors;i++) {
		    printf("color % d:%d %d %d\n",i,ccr->red,ccr->green,ccr->blue);
		    ccr++;
		};
		*/
		// puts("before freeing image");
		if (image) free(image);
		image=(UBYTE *) malloc(width*height*component);
		cimage=image;
		// puts("before init rp");
		InitRastPort(&rp);
		rp.BitMap=bm;
		for (int i=height-1;i>=0;i--) {
		    for (int j=0;j<width;j++) {
			value=(int) ReadPixel(&rp,j,i);
			// printf("%d,",value);
			ccr=cr+value;
			*(cimage) = (UBYTE) ccr->red;
			cimage++;
			*(cimage) = (UBYTE) ccr->green;
			cimage++;
			*(cimage) = (UBYTE) ccr->blue;
			cimage++;
		    };
		    // printf("\n");
		};
	    }
	    else {
		if (image) free(image);
		image=(UBYTE *) malloc(width*height*component);
		cimage=image;
		bmhd=LockBitMapTags((APTR) bm, LBMI_BASEADDRESS, &store);
		data=(UBYTE *) store;
		// cdata=data;
		if (bmhd) {
		    // puts("BitMapahandle not NULL");
		    for (int i=height-1;i>=0;i--) {
			cdata=data+(i*bprow);
			CopyMem(cdata,cimage,width*component);
			cimage=cimage+(width*component);
		    };
		    // t->width=t->width+padding;
		    UnLockBitMap(bmhd);
		};
	    };
	};
	DisposeDTObject((Object *) dto);
	return 1;
   };
   return 0;
}
/*------------------------------
  Texture2Transform
-------------------------------*/
Texture2Transform::Texture2Transform(char *name)
    :translation(),scaleFactor(),center() {
    ID=TEXTURE2TRANSFORM_1;
    CommonInit();
    SetName(name);
    // type=Texture2TransformID;
    // SetTypeName("Texure2Transform");
    translation.Set(0.0,0.0);
    rotation=0.0;
    scaleFactor.Set(1.0,1.0);
    center.Set(0.0,0.0);
}
Texture2Transform::~Texture2Transform() {
    CommonFree();
}
void Texture2Transform::SetDefault() {
    translation.Set(0.0,0.0);
    rotation=0.0;
    scaleFactor.Set(1.0,1.0);
    center.Set(0.0,0.0);
}
VRMLNode *Texture2Transform::Clone() {
    Texture2Transform *t=new Texture2Transform(GetName());
    t->Copy(this);
    return (VRMLNode *) t;
}
void Texture2Transform::Copy(VRMLNode *n) {
    Texture2Transform *t=(Texture2Transform *) n;
    *(this) = *(t);
    SetName(t->GetName());
}

/*-------------------------------
  TextureCoordinate2
--------------------------------*/
TextureCoordinate2::TextureCoordinate2(char *name)
    :point() {
    ID=TEXTURECOORDINATE2_1;
    CommonInit();
    SetName(name);
    // type=TextureCoordinate2ID;
    // SetTypeName("TextureCoordinate2");
}
TextureCoordinate2::~TextureCoordinate2() {
    CommonFree();
}
int TextureCoordinate2::Size() {
    return point.Length();
}
void TextureCoordinate2::AddPoint(Vertex2d *p) {
    point.Add(p);
}
void TextureCoordinate2::InsertPoint(int where, Vertex2d *p) {
    point.InsertAfter(where,p);
}
Vertex2d *TextureCoordinate2::GetPoint(int index) {
    return point.Get(index);
}
Vertex2d *TextureCoordinate2::RemovePoint(int index) {
    return point.RemoveEntry(index);
}
void TextureCoordinate2::Clear() {
    point.ClearList();
}

VRMLNode *TextureCoordinate2::Clone() {
    TextureCoordinate2 *tc=new TextureCoordinate2(GetName());
    tc->Copy(this);
    return (VRMLNode *) tc;
}
void TextureCoordinate2::Copy(VRMLNode *n) {
    TextureCoordinate2 *tc=(TextureCoordinate2 *) n;
    Vertex2d *cp; 
    point.ClearList();
    for (int i=0;i<tc->Size();i++) {
	cp=tc->GetPoint(i);
	AddPoint(new Vertex2d(cp->coord[0],cp->coord[1]));
    };
    SetName(tc->GetName());
}
/*----------------------------------------------
  Transform Node
----------------------------------------------*/
// Constructor
Transform::Transform(char *name)
    :translation(),rotation(),scaleFactor(),scaleOrientation(),center() {
    ID=TRANSFORM_1;
    CommonInit();
    SetName(name);
    // type=TransformID;
    // SetTypeName("Transform");
    translation.Set(0.0,0.0,0.0);
    rotation.Set(0.0,0.0,1.0,0.0);
    scaleFactor.Set(1.0,1.0,1.0);
    scaleOrientation.Set(0.0,0.0,1.0,0.0);
    center.Set(0.0,0.0,0.0);
}
Transform::~Transform() {
    // puts("In Transform Destructor");
    CommonFree();
}
void Transform::SetDefault() {
    translation.Set(0.0,0.0,0.0);
    rotation.Set(0.0,0.0,1.0,0.0);
    scaleFactor.Set(1.0,1.0,1.0);
    scaleOrientation.Set(0.0,0.0,1.0,0.0);
    center.Set(0.0,0.0,0.0);
}
VRMLNode *Transform::Clone() {
     Transform *t=new Transform(GetName());
     t->Copy(this);
     return (VRMLNode *) t;
}
void Transform::Copy(VRMLNode *n) {
     Transform *t=(Transform *) n;
     *(this) = *(t);
     SetName(t->GetName());
}
void Transform::Print() {
     /*
     printf("DEF %s Transform {t=%4.2f %4.2f %4.2f s=%1.2f %1.2f %1.2f r=%1.2f %1.2f %1.2f %1.2f}\n",
	     GetName(),translation.x,translation.y,translation.z,
	     scaleFactor.x,scaleFactor.y,scaleFactor.z,
	     rotation.x,rotation.y,rotation.z,rotation.angle);
     */
}
//--------------------------------------
// TransformSeparator Node
//--------------------------------------
TransformSeparator::TransformSeparator(char *name) {
    ID=TRANSFORMSEPARATOR_1;
    CommonInit();
    SetName(name);
    // type=TransformSeparatorID;
    // SetTypeName("*TransformSeparator*");
    // children=new PList<VRMLNode>();
    PList<VRMLNode> children();
    // puts("TransformSeparator constructor ");
}
TransformSeparator::~TransformSeparator() {
    // delete children;
    CommonFree();
}       
void TransformSeparator::Copy(VRMLNode *n) {
     TransformSeparator *ts=(TransformSeparator *) n;
     for (int i=0;i<ts->Size();i++) {
	AddChild(ts->GetChild(i)->Clone());
     };
     SetName(ts->GetName());
}
VRMLNode *TransformSeparator::Clone() {
    TransformSeparator *ts=new TransformSeparator(GetName());
    ts->Copy(this);
    return (VRMLNode *) ts;
}
void TransformSeparator::Print() {
    for (int i=0;i<children.Length();i++) {
	children.Get(i)->Print();
    };
}
/*---------------------------------------------------
  Translation Node
----------------------------------------------------*/
// Constructor
Translation::Translation(char *name)
    :translation() {
    ID=TRANSLATION_1;
    CommonInit();
    SetName(name);
    // type=TranslationID;
    // SetTypeName("Translation");
    translation.Set(0,0,0);
}
Translation::~Translation() {
    // puts("In Translation Destructor");
    CommonFree();
}
VRMLNode *Translation::Clone() {
    Translation *t=new Translation(GetName());
    t->Copy(this);
    return (VRMLNode *) t;
}
void Translation::Copy(VRMLNode *n) {
    Translation *t=(Translation *) n;
    *(this) = *(t);
    SetName(t->GetName());
}
void Translation::Print() {
    // float x,y,z;
    // GetTranslation(x,y,z);
    // printf("DEF %s Translation {%5.2f,%5.2f,%5.2f}\n",GetName(),x,y,z);
}
/*---------------------------------------
  WWWAnchor
-----------------------------------------*/
WWWAnchor::WWWAnchor(char *name)
    :state() {
    // VRMLState state();
    ID=WWWANCHOR_1;
    CommonInit();
    SetName(name);
    // type=WWWAnchorID;
    // SetTypeName("*WWWAnchor*");
    strcpy(url,"");
    strcpy(description,"");
    map=MAP_NONE;
    // children=new PList<VRMLNode>();
    PList<VRMLNode> children();
}
WWWAnchor::~WWWAnchor() {
    // delete children;
    // CommonFree();
}
void WWWAnchor::SetURL(char *name) {
    strncpy(url,name,255);
}
char *WWWAnchor::GetURL() {
    return url;
}
void WWWAnchor::SetDescription(char *d) {
    strncpy(description,d,255);
}
char *WWWAnchor::GetDescription() {
    return description;
}

VRMLNode *WWWAnchor::Clone() {
    WWWAnchor *www=new WWWAnchor(GetName());
    www->Copy(this);
    return (VRMLNode *)www;
}
void WWWAnchor::Copy(VRMLNode *n) {
    WWWAnchor *www=(WWWAnchor *) n;
    map=www->map;
    strncpy(www->GetURL(),url,255);
    strncpy(www->GetDescription(),description,255);
    for (int i=0;i<www->Size();i++) {
	AddChild(www->GetChild(i)->Clone());
    };
    SetName(www->GetName());
}
/*--------------------------------------
  WWWInline
---------------------------------------*/
WWWInline::WWWInline(char *name)
    :bboxSize(),bboxCenter() {
    ID=WWWINLINE_1;
    CommonInit();
    SetName(name);
    // type=WWWInlineID;
    // SetTypeName("WWWInline");
    strcpy(url,"");
    in=NULL;
    bboxSize.Set(0.0,0.0,0.0);
    bboxCenter.Set(0.0,0.0,0.0);
}
WWWInline::~WWWInline() {
    if (in) delete in;
    CommonFree();
}
void WWWInline::SetURL(char *name) {
    strncpy(url,name,255);
}
char *WWWInline::GetURL() {
    return url;
}

VRMLNode *WWWInline::Clone() {
    WWWInline *www=new WWWInline(GetName());
    www->Copy(this);
    return (VRMLNode *) www;
}
void WWWInline::Copy(VRMLNode *n) {
    WWWInline *www=(WWWInline *) n;
    bboxSize=www->bboxSize;
    bboxCenter=www->bboxCenter;
    if (www->in) in=www->in->Clone();
    strncpy(url,www->GetURL(),255);
    SetName(www->GetName());
}
void WWWInline::Browse(VRMLState *st) {
    // puts("In wwwinline browse");
    if (in) {
	// puts("WWWInline browsing");
	in->Browse(st);
    };
}
/***************
 * Pseudo Node *
 ***************/
/*------------------------------------
  USE Keyword
--------------------------------------*/
// Constructor
USE::USE(char *name) {
    // puts("In USE constructor");
    ID=USE_1;
    CommonInit();
    SetName(name);
    // type=USEID;
    // SetTypeName("USE");
    // strcpy(usename,"");
}
USE::~USE() {
    // puts("In pseudo node USE Destructor");
    reference->ref--;
    CommonFree();
}
VRMLNode *USE::Clone() {
    USE *u=new USE(GetName());
    u->Copy(this);
    return (VRMLNode *) u;
}
void USE::Copy(VRMLNode *n) {
    USE *u=(USE *) n;
    // strncpy(u->GetUsedName(),usename,255);
    // SetName(u->GetName());
    reference=u->reference;
    reference->ref++;
}
void USE::Print() {
    // printf("Pseudo Node USE %s\n",usename);
}
void USE::Browse(VRMLState *st) {
    int tn=st->totalnodes;
    reference->Browse(st);
    st->totalnodes=tn;
}

