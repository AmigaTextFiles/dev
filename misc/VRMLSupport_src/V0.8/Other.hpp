/*----------------------------------------------------
  Other.hpp
  Version: 0.35
  Date: 30 may 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note:  Vertex2d,Vertex3d,Vertex4d,
	 Color3,Color3f,
	 NodeName,NameServer,
	 VRMLState,
	 Face,
	 Mat,
	 MyMsg,
	 MyString,StringWidth
----------------------------------------------------*/
#ifndef OTHER_H
#define OTHER_H

#include <exec/types.h>

#ifdef USE_CYBERGL
#define SHARED
#include <cybergl/cybergl.h>
#include <proto/cybergl.h>
#else
#include <proto/Amigamesa.h>
// #include "StormMesaSupport.h"
#endif
#include <mui/GLArea_mcc.h>

class Vertex2d {
private:
public:
	double coord[2];

	Vertex2d() {coord[0]=0;coord[1]=0;};
	Vertex2d(double x, double y) {coord[0]=x;coord[1]=y;};
	Vertex2d(double *tab) {coord[0]=tab[0];coord[1]=tab[1];};
	~Vertex2d() {};

	void Set(double *tab) {coord[0]=tab[0];coord[1]=tab[1];};
	void Set(double x, double y) {coord[0]=x;coord[1]=y;};
	void Get(double *tab) {tab[0]=coord[0];tab[1]=coord[1];};
	void Get(double& x, double& y) {x=coord[0];y=coord[1];};
	double *Get() {return coord;};
};                           
class Vertex3d {
private:
public:
	double coord[3];

	Vertex3d() {coord[0]=0;coord[1]=0;coord[2]=0;};
	Vertex3d(double ax, double ay, double az) {coord[0]=ax;coord[1]=ay;coord[2]=az;};
	Vertex3d(double *tab) {coord[0]=tab[0];coord[1]=tab[1];coord[2]=tab[2];};
	~Vertex3d() {};

	void Set(double *tab) {coord[0]=tab[0];coord[1]=tab[1];coord[2]=tab[2];};
	void Set(double ax, double ay, double az) {coord[0]=ax;coord[1]=ay;coord[2]=az;};
	void Get(double *tab) {tab[0]=coord[0];tab[1]=coord[1];tab[2]=coord[2];};
	void Get(double& ax, double& ay, double& az) {ax=coord[0];ay=coord[1];az=coord[2];};
	double *Get() {return coord;};
};                           
class Vertex4d {
private:
public:
	double coord[4];

	Vertex4d() {coord[0]=0;coord[1]=0;coord[2]=0;coord[3]=1;};
	Vertex4d(double x, double y, double z,  double a) {coord[0]=x;coord[1]=y;coord[2]=z;coord[3]=a;};
	Vertex4d(double *tab) {coord[0]=tab[0];coord[1]=tab[1];coord[2]=tab[2];coord[3]=tab[3];};
	~Vertex4d() {};

	void Set(double *tab) {coord[0]=tab[0];coord[1]=tab[1];coord[2]=tab[2];coord[3]=tab[3];};
	void Set(double x, double y, double z, double a) {coord[0]=x;coord[1]=y;coord[2]=z;coord[3]=a;};
	void Get(double *tab) {tab[0]=coord[0];tab[1]=coord[1];tab[2]=coord[2];tab[3]=coord[3];};
	void Get(double& x, double& y, double& z, double& a) {x=coord[0];y=coord[1];z=coord[2];a=coord[3];};
	double *Get() {return coord;};
};                           

class Color3 {
private:
	int RGB[3];
public:
	Color3() {RGB[0]=0;RGB[1]=0;RGB[2]=0;};
	Color3(float r, float g, float b) {SetVRML(r,g,b);};
	Color3(int r, int g, int b){RGB[0]=r;RGB[1]=g;RGB[2]=b;};
	~Color3() {};

	void SetValues(int r, int g, int b) {RGB[0]=r;RGB[1]=g;RGB[2]=b;};
	void SetValuesv(int *tab) {RGB[0]=tab[0];RGB[1]=tab[1];RGB[2]=tab[2];};
	void GetValues(int& r, int &g, int &b) {r=RGB[0];g=RGB[1];b=RGB[2];};
	void GetValuesv(int *tab) {tab[0]=RGB[0];tab[1]=RGB[1];tab[2]=RGB[2];};
	int *GetRGB() {return RGB;};
	void SetVRML(float r, float g, float b) {
	    RGB[0]=(int) (r*255);
	    RGB[1]=(int) (g*255);
	    RGB[2]=(int) (b*255);
	    // printf("R:%d G:%d B:%d\n",R,G,B);
	};
	void SetVRMLv(float *tab) {
	    RGB[0]=(int) (tab[0]*255);
	    RGB[1]=(int) (tab[1]*255);
	    RGB[2]=(int) (tab[2]*255);
	};
	void GetVRML(float& r, float& g, float& b) {
	    // float tr,tg,tb;
	    r=(float) RGB[0]/255;
	    g=(float) RGB[1]/255;
	    b=(float) RGB[2]/255;
	    // printf("IN GETVRML r:%f g:%f b:%f\n",r,g,b);
	};
	void GetVRMLv(float *tab) {
	    tab[0]=(float) RGB[0]/255;
	    tab[1]=(float) RGB[1]/255;
	    tab[2]=(float) RGB[2]/255;
	};

};
class Color3f {
private:
public:
	float rgb[4];

	Color3f() {rgb[0]=0.0;rgb[1]=0.0;rgb[2]=0.0;rgb[3]=1.0;};
	Color3f(float r, float g, float b) {rgb[0]=r;rgb[1]=g;rgb[2]=b;rgb[3]=1.0;};
	~Color3f() {};

	void Set(float r, float g, float b) {rgb[0]=r;rgb[1]=g;rgb[2]=b;};
	void Set(float *f) {rgb[0]=f[0];rgb[1]=f[1];rgb[2]=f[2];};
	void Get(float &r, float& g, float& b) {r=rgb[0];g=rgb[1];b=rgb[2];};
	float *Get() {return rgb;};
};
class Color4f {
private:
public:
	float rgb[4];

	Color4f() {rgb[0]=0.0;rgb[1]=0.0;rgb[2]=0.0;rgb[3]=1.0;};
	Color4f(float r, float g, float b, float a) {rgb[0]=r;rgb[1]=g;rgb[2]=b;rgb[3]=a;};
	~Color4f() {};

	void Set(float r, float g, float b, float a) {rgb[0]=r;rgb[1]=g;rgb[2]=b;rgb[3]=a;};
	void Set(float r, float g, float b) {rgb[0]=r;rgb[1]=g;rgb[2]=b;};
	void Set(float *f) {rgb[0]=f[0];rgb[1]=f[1];rgb[2]=f[2];rgb[3]=f[3];};
	void Get(float &r, float& g, float& b, float& a) {r=rgb[0];g=rgb[1];b=rgb[2];a=rgb[3];};
	float *Get() {return rgb;};
};

/*
class NodeName {
private:
public:
	char def[255];
	VRMLNode *node;

	NodeName() {strcpy(def,"");node=NULL;};
	NodeName(char *d, VRMLNode *n) {strncpy(def,d,255);node=n;};
};
class NameServer {
private:
public:
	PList<NodeName> deflist;

	NameServer();
	~NameServer();

	void Add (NodeName *nn) {deflist.Add(nn);};
	int Set (char *name, VRMLNode *n);
	VRMLNode *Get(char *name);
	void Clear();
	void Print();
};
*/
class VRMLState {
public:
	struct GLContext *glcontext;

	Coordinate3 *c3;
	Material *m;
	MaterialBinding *mb;
	Normal *n;
	NormalBinding *nb;
	Texture2 *t;
	TextureCoordinate2 *tc2;

	BOOL gauge;
	int totalnodes;
	int totalpolygones;
	int totalmaterials;
	int totallights;
	int totalcameras;
	int lightsource;
	int currentnode;
	int currentpolygone;

	int coneres;
	int cylinderres;
	int sphereres;

	VRMLState() {
	    // puts("VRMLState constructor");
	    c3=NULL;m=NULL;mb=NULL;n=NULL;nb=NULL;t=NULL;tc2=NULL;gauge=FALSE;
	    totalnodes=0;totalpolygones=0;totalmaterials=0;totallights=0;totalcameras=0;
	    lightsource=0;currentnode=0;currentpolygone=0;
	    coneres=8;cylinderres=8;sphereres=8;
	};
	~VRMLState() {};

	void Clear() {
	    c3=NULL;m=NULL;mb=NULL;n=NULL;nb=NULL;t=NULL;
	    totalnodes=0;totalpolygones=0;totalmaterials=0;totallights=0;totalcameras=0;
	    lightsource=0;currentnode=0;currentpolygone=0;
	};
};

/*
typedef struct {
    int totalnodes;
    int totalpolygones;
    int totalmaterials;
    int totallights;
    int totalcameras;
    VRMLState *state;
} MyMsg;
*/

class Face {
private:
public:
	VList<int> coordIndex;
	VList<int> materialIndex;
	VList<int> normalIndex;
	VList<int> textureCoordIndex;

	Face():coordIndex(),normalIndex(),materialIndex(),textureCoordIndex() {
	    /*
	    coordIndex.Add(-1);
	    materialIndex.Add(-1);
	    normalIndex.Add(-1);
	    textureCoordIndex.Add(-1);
	    */
	    // puts("In Face constructor");
	    // printf("coordindex:%d\n",coordIndex.Length());
	    // textureCoordIndex=-1;
	};
	Face(Face *cf):coordIndex(),normalIndex(),materialIndex(),textureCoordIndex() {
	    // puts("In Face constructor");
	    // printf("coordindex:%d\n",coordIndex.Length());
	    // textureCoordIndex=-1;
	    int i=0;
	    for (i=0;i<cf->coordIndex.Length();i++) {
		coordIndex.Add(cf->coordIndex.Get(i));
	    };
	    for (i=0;i<cf->materialIndex.Length();i++) {
		materialIndex.Add(cf->materialIndex.Get(i));
	    };
	    for (i=0;i<cf->normalIndex.Length();i++) {
		normalIndex.Add(cf->normalIndex.Get(i));
	    };
	    for (i=0;i<cf->textureCoordIndex.Length();i++) {
		textureCoordIndex.Add(cf->textureCoordIndex.Get(i));
	    };
	};
	~Face() {};

	/*
	void operator= (Face cf) {
	    int i=0;
	    coordIndex.ClearList();
	    materialIndex.ClearList();
	    normalIndex.ClearList();
	    textureCoordIndex.ClearList();
	    for (i=0;i<cf.coordIndex.Length();i++) {
		coordIndex.Add(cf.coordIndex.Get(i));
	    };
	    for (i=0;i<cf.materialIndex.Length();i++) {
		materialIndex.Add(cf.materialIndex.Get(i));
	    };
	    for (i=0;i<cf.normalIndex.Length();i++) {
		normalIndex.Add(cf.normalIndex.Get(i));
	    };
	    for (i=0;i<cf.textureCoordIndex.Length();i++) {
		textureCoordIndex.Add(cf.textureCoordIndex.Get(i));
	    };
	};
	*/
};

class Mat {
private:
public:
	Color4f ambient;
	Color4f diffuse;
	Color4f specular;
	Color4f emissive;
	float shininess;
	float transparency;

	Mat():ambient(),diffuse(),specular(),emissive() {
	    // puts("Mat constructor");
	    ambient.Set(0.2,0.2,0.2,1.0);
	    diffuse.Set(0.8,0.8,0.8,1.0);
	    specular.Set(0.0,0.0,0.0,1.0);
	    emissive.Set(0.0,0.0,0.0,1.0);
	    shininess=0.2*128.0;
	    transparency=0.0;
	    // printf("Mat::shininess=%f\n",shininess);
	};
	Mat(Mat *m):ambient(),diffuse(),specular(),emissive() {
	    ambient.Set(m->ambient.rgb);
	    diffuse.Set(m->diffuse.rgb);
	    specular.Set(m->specular.rgb);
	    emissive.Set(m->emissive.rgb);
	    shininess=m->shininess;
	    transparency=m->transparency;
	};
	Mat(Color4f a, Color4f d, Color4f s, Color4f e, float shin, float t) {
	    ambient=a;diffuse=d;specular=s;emissive=e;shininess=shin*128.0;transparency=t;
	    // printf("shininess:%f\n",shininess);
	};
	Mat(float r, float g, float b):ambient(),specular(),emissive(),diffuse() {
	   ambient.Set(0.2,0.2,0.2,1.0);
	   diffuse.Set(r,g,b,1.0);
	   specular.Set(0.0,0.0,0.0,1.0);
	   emissive.Set(0.0,0.0,0.0,1.0);
	   shininess=0.2*128.0;
	   transparency=0.0;
	};
	~Mat() {};

	/*
	void WriteTabs(FILE *f, int tab) {
		for (int i=0;i<tab;i++) fprintf(f,"\t");
	};
	void WriteOpenGL(FILE *f, int tab, VRMLState *st);
	*/
	void DrawGL(struct GLContext *glcontext) {
	    struct Library *glBase=glcontext->gl_Base;
	    struct Library *gluBase=glcontext->glu_Base;
	    struct Library *glutBase=glcontext->glut_Base;
	    // printf("ambient:%f %f %f\n",ambient.rgb[0],ambient.rgb[1],ambient.rgb[2], ambient.rgb[3]);
	    // printf("diffuse:%f %f %f\n",diffuse.rgb[0],diffuse.rgb[1],diffuse.rgb[2], diffuse.rgb[3]);

	    glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient.rgb);
	    glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse.rgb);
	    glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular.rgb);
	    glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive.rgb);
	    glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess);

	};
	void SetTransparency() {
	    ambient.rgb[3]=1.0-transparency;
	    diffuse.rgb[3]=1.0-transparency;
	    specular.rgb[3]=1.0-transparency;
	    emissive.rgb[3]=1.0-transparency;
	};
};

class StringWidth {
private:
public:
	char str[255];
	float width;

	StringWidth() {strcpy(str,"");width=1.0;};
	StringWidth(char *name, float w) {strncpy(str,name,255);width=w;};
	~StringWidth() {};
};
class MyString {
private:
public:
	char str[255];

	MyString() {strcpy(str,"");};
	MyString(char *name) {strncpy(str,name,255);};
	~MyString() {};
};
#endif

