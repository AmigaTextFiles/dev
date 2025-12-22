/*----------------------------------------------------
  MUIWindows.h
  Version 0.63
  Date: 26 july 1998
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: C++ classes for all MUI windows and others
	All classes have a pointer to the main muiapp
-----------------------------------------------------*/
#ifndef MUIWINDOWS_H
#define MUIWINDOWS_H

#include "Main.h"
#include "VRMLNode.h"

#include "App.h"

// struct ObjApp;
// class VRMLState;
// struct GLlookAt;

// Manage ListView
/*
class LVObject {
private:
	struct ObjApp *obj;
	APTR lv;
	VRMLGroups *g;
	SharedVariables *sv;
public:
	LVObject(struct ObjApp *o,APTR l, VRMLGroups *gr, SharedVariables *s);
	~LVObject();

	void SetGroup (VRMLGroups *cg);
	void SetObj (APTR l) {lv=l;};
	VRMLGroups *GetGroup() {return (VRMLGroups *) g;};
	VRMLNode *GetSelected();
	VRMLNode *GetSelectedChild();
	int Selected();

	void Refresh();
	void RefreshHeader();
			
	void InsertEntry(VRMLNode *n);
	void CompleteEntry(char *temp,VRMLNode *n);
	VRMLNode *RemoveEntry();
	void Delete();
	void MoveUp();
	void MoveDown();

	void Clear();
};
*/
// MUIWindow superclass
class MUIWindow {
private:
public:
	// struct ObjApp *obj;
	APTR win;
	// SharedVariables *sv;
	int which;

	void InitWindow();
	// void SetAppAndWin(struct ObjApp *o, APTR w) {obj=o;win=w;};
	void DisableMainWindow();
	void EnableMainWindow();
	void PopUp();
	void PopDown();

	virtual void Set(VRMLNode *n, int w)=0;
	virtual VRMLNode *Get()=0;
};
// Manage Add window
class WIAdd {
private:
	char temp[25];
	int mode;
	// struct ObjApp *obj;
public:
	WIAdd();
	~WIAdd();

	void Mode(int , VRMLNode *);
	int GetMode() {return mode;};
	VRMLNode *Ok();
};

//-----------------------------------
//---- VRML Node manager classes ----
//-----------------------------------
// manage AsciiText settings
class WIAsciiText:public MUIWindow {
private:
	AsciiText *a;
	AsciiText *manip;
public:
	WIAsciiText();
	~WIAsciiText();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) a;};

	void Add();
	void Delete();
	int Selected();

	int Ok();
	void Cancel();
	void Refresh();
	void RefreshString();
	void ReadValues();
};
// manage Cone settings
class WICone:public MUIWindow {
private:
	Cone *c;
	Cone *manip;
public:
	WICone();
	~WICone();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) c;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// Coordinate3
class WICoordinate3:public MUIWindow {
private:
	Coordinate3 *c;
	Coordinate3 *manip;
public:
	WICoordinate3();
	~WICoordinate3();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) c;};

	void Add();
	void Delete();
	int Selected();

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// manage Cube settings window
class WICube:public MUIWindow {
private:
	Cube *c;
	Cube *manip;
public:
	WICube();
	~WICube();

	void Set(VRMLNode *n, int w);     
	VRMLNode *Get() {return (VRMLNode *) c;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// manage Cylinder settings
class WICylinder:public MUIWindow {
private:
	Cylinder *c;
	Cylinder *manip;
public:
	WICylinder();
	~WICylinder();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) c;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// DirectionalLight
class WIDirectionalLight:public MUIWindow {
private:
	DirectionalLight *dl;
	DirectionalLight *manip;
public:
	WIDirectionalLight();
	~WIDirectionalLight();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) dl;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// FontStyle
class WIFontStyle:public MUIWindow {
private:
	FontStyle *fs;
	FontStyle *manip;
public:
	WIFontStyle();
	~WIFontStyle();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) fs;};

	int Ok();
	void SetDefault();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// Group
/*
class WIGroup:public MUIWindow {
private:
	Group *gr;
public:
	WIGroup(struct ObjApp *, APTR win, SharedVariables *s);
	~WIGroup();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) gr;};

	int Ok();
	void Refresh();
	void ReadValues();
};
*/
// Groups
class WIGroups:public MUIWindow {
private:
	VRMLGroups *gr;
	// VRMLGroups *parent;
public:
	WIGroups();
	~WIGroups();

	void Set(VRMLNode *g, int which);
	// void SetGroups(VRMLGroups *g, int w);
	VRMLNode *Get() {return (VRMLNode *) gr;};
	// VRMLGroups *GetParent() {return parent;};

	int Ok();
	void Add();
	void Delete();
	void Refresh();
	void RefreshLOD();
	void ReadValues();
	void ReadValuesLOD();
};
// WIIndexedFaceSet
class WIIndexedFaceSet:public MUIWindow {
private:
	IndexedFaceSet *ifs;
	IndexedFaceSet *manip;
public:
	WIIndexedFaceSet();
	~WIIndexedFaceSet();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) ifs;};

	int Selected();
	int SelectedCoordEntry();
	int SelectedMatEntry();
	int SelectedNormalEntry();
	int SelectedTextureEntry();

	void AddPoint();
	void DeletePoint();
	void AddMat();
	void DeleteMat();
	void AddNormal();
	void DeleteNormal();
	void AddTexture();
	void DeleteTexture();
	void AddFace();
	void DeleteFace();

	int Ok();
	void Cancel();
	void Refresh();
	void RefreshValue();
	void ReadValues();
};
// IndexedLineSet
class WIIndexedLineSet:public MUIWindow {
private:
	IndexedLineSet *ils;
	IndexedLineSet *manip;
public:
	WIIndexedLineSet();
	~WIIndexedLineSet();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) ils;};

	int Selected();
	int SelectedCoordEntry();
	int SelectedMatEntry();
	int SelectedNormalEntry();
	int SelectedTextureEntry();

	void AddPoint();
	void DeletePoint();
	void AddMat();
	void DeleteMat();
	void AddNormal();
	void DeleteNormal();
	void AddTexture();
	void DeleteTexture();
	void AddLine();
	void DeleteLine();

	int Ok();
	void Cancel();
	void Refresh();
	void RefreshValue();
	void ReadValues();
};
// Info
class WIInfo:public MUIWindow {
private:
	VInfo *in;
	VInfo *manip;
public:
	WIInfo();
	~WIInfo();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) in;};

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// LOD
class WILOD:public MUIWindow {
private:
	LOD *lod;
public:
	WILOD();
	~WILOD();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) lod;};

	void Add();
	void Delete();
	int Selected();

	int Ok();
	void Refresh();
	void ReadValues();
	// void RefreshValues();
};
// WIMaterial
class WIMaterial:public MUIWindow {
private:
	Material *m;
	Material *manip;
	// void VRMLToRGB(int r, int g, int b, int& r1, int& g1, int& b1);
	// void RGBToULONG(int r, int g, int b, ULONG& ru, ULONG& gu, ULONG& bu);
public:
	WIMaterial();
	~WIMaterial();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) m;};
	Mat *GetCurrentMat();

	void Clear();

	void Add();
	void Delete();
	int Selected();

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadAmbient();
	void ReadDiffuse();
	void ReadSpecular();
	void ReadEmissive();
	void ReadValues();
};
// WIMaterialBinding
class WIMaterialBinding:public MUIWindow {
private:
	MaterialBinding *mb;
	MaterialBinding *manip;
public:
	WIMaterialBinding();
	~WIMaterialBinding();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) mb;};

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// MatrixTransform
class WIMatrixTransform:public MUIWindow {
private:
	MatrixTransform *mt;
	MatrixTransform *manip;
public:
	WIMatrixTransform();
	~WIMatrixTransform();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) mt;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// Normal
class WINormal:public MUIWindow {
private:
	Normal *no;
	Normal *manip;
public:
	WINormal();
	~WINormal();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) no;};

	int Selected();
	void Add();
	void Delete();

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// NormalBinding
class WINormalBinding:public MUIWindow {
private:
	NormalBinding *nb;
	NormalBinding *manip;
public:
	WINormalBinding();
	~WINormalBinding();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) nb;};

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// OrthographicCamera:public MUIWindow {
class WIOrthographicCamera:public MUIWindow {
private:
	OrthographicCamera *oc;
	OrthographicCamera *manip;
public:
	WIOrthographicCamera();
	~WIOrthographicCamera();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) oc;};
	OrthographicCamera *GetOC() {return oc;};

	void SetDefault();

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// PerspectiveCamera
class WIPerspectiveCamera:public MUIWindow {
private:
	PerspectiveCamera *pc;
	PerspectiveCamera *manip;
public:
	WIPerspectiveCamera();
	~WIPerspectiveCamera();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) pc;};
	PerspectiveCamera *GetPC() {return pc;};

	void SetDefault();

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// PointLight
class WIPointLight:public MUIWindow {
private:
	PointLight *pl;
	PointLight *manip;
public:
	WIPointLight();
	~WIPointLight();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) pl;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// PointSet
class WIPointSet:public MUIWindow {
private:
	PointSet *ps;
	PointSet *manip;
public:
	WIPointSet();
	~WIPointSet();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) ps;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// WIRotation
class WIRotation:public MUIWindow {
private:
	Rotation *r;
	Rotation *manip;
public:
	WIRotation();
	~WIRotation();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) r;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// WIScale
class WIScale:public MUIWindow {
private:
	Scale *s;
	Scale *manip;
public:
	WIScale();
	~WIScale();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) s;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// Separator
class WISeparator:public MUIWindow {
private:
	Separator *s;
public:
	WISeparator();
	~WISeparator();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) s;};

	int Ok();
	void Refresh();
	void ReadValues();
};
// ShapeHints
class WIShapeHints:public MUIWindow {
private:
	ShapeHints *shi;
	ShapeHints *manip;
public:
	WIShapeHints();
	~WIShapeHints();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) shi;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// Sphere
class WISphere:public MUIWindow {
private:
	Sphere *s;
	Sphere *manip;
public:
	WISphere();
	~WISphere();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) s;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// SpotLight
class WISpotLight:public MUIWindow {
private:
	SpotLight *sl;
	SpotLight *manip;
public:
	WISpotLight();
	~WISpotLight();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) sl;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// Switch
class WISwitch:public MUIWindow {
private:
	Switch *s;
public:
	WISwitch();
	~WISwitch();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) s;};

	int Ok();
	void Refresh();    
	void ReadValues();
};
// Texture2
class WITexture2:public MUIWindow {
private:
	Texture2 *t;
	Texture2 *manip;
public:
	WITexture2();
	~WITexture2();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) t;};
	void LoadImage();
	void ShowImage();
	// void CloseImage();

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// Texture2Transform
class WITexture2Transform:public MUIWindow {
private:
	Texture2Transform *t;
	Texture2Transform *manip;
public:
	WITexture2Transform();
	~WITexture2Transform();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) t;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// TextureCoordinate2
class WITextureCoordinate2:public MUIWindow {
private:
	TextureCoordinate2 *tc;
	TextureCoordinate2 *manip;
public:
	WITextureCoordinate2();
	~WITextureCoordinate2();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) tc;};

	void Add();
	void Delete();
	int Selected();

	int Ok();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// Manage Transform node setting
class WITransform:public MUIWindow {
private:
	Transform *t;
	Transform *manip;
public:
	WITransform();
	~WITransform();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) t;};

	int Ok();      
	void SetDefault ();
	void Cancel();
	void Refresh();
	void ReadValues();
};
// TransformSeparator
class WITransformSeparator:public MUIWindow {
private:
	TransformSeparator *t;
public:
	WITransformSeparator();
	~WITransformSeparator();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) t;};

	int Ok();
	void Refresh();
	void ReadValues();
};
// WITranslation
class WITranslation:public MUIWindow {
private:
	Translation *t;
	Translation *manip;
public:
	WITranslation();
	~WITranslation();

	void Set(VRMLNode *n, int w);                     
	VRMLNode *Get() {return (VRMLNode *) t;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
};
// WWWAnchor
class WIWWWAnchor:public MUIWindow {
private:
	WWWAnchor *www;
public:
	WIWWWAnchor();
	~WIWWWAnchor();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) www;};

	int Ok();
	void Refresh();      
	void ReadValues();
};
// WWWInline
class WIWWWInline:public MUIWindow {
private:
	WWWInline *www;
	WWWInline *manip;
public:
	WIWWWInline();
	~WIWWWInline();

	void Set(VRMLNode *n, int w);
	VRMLNode *Get() {return (VRMLNode *) www;};

	int Ok();
	void Cancel();
	void SetDefault();
	void Refresh();
	void ReadValues();
	WWWInline *GetInline();
};
#endif
/*--------------------------------
  CyberGL
----------------------------------*/
// Manage CyberGL display
/*
class GLContext {
private:
	void *glwin;
	struct Window *win;

	struct ObjApp *obj;
	

	double  angleX,angleY;
	double  heading,pitch,bank;

	VRMLState *st;
public:
	struct GLlookAt *camera;

	PreviewType pt;
	PreviewWhich pw;
	PreviewMode pm;
	PreviewProjection pp;
	
	VRMLNode *what;
	int Active;
	int db;

	GLContext(struct ObjApp *o);
	~GLContext();

	int GetActive() {return Active;};
	VRMLNode *GetWhat() {return what;};

	void InitGLWin();
	void CloseGLWin();
	void Reset();

	void SetNode (VRMLNode *n);
	
	void HandleEvents ();

	void DrawBoxScene();
	void DrawScene();

	void RefreshCoord();
	void ReadValues();

	void SetCamera(float x, float y,float z, float tx, float ty, float tz);
	void Advance();
	void Backward();
	void TurnRight();
	void TurnLeft();
};
*/
