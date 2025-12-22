/*------------------------------------------------------
  GLConvert.cc
  Version: 0.2
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Convert VRML structure to GL structure
------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <libraries/mui.h>

#include <proto/exec.h>

#include "VRMLSupport.h"
#include "NProducer.h"
#include "GLConvert.h"

#include "Conversion.h"

//--------------------------- USEFULL FUNCTIONS -----------------------
void InitMaterial(material *mat,
		  float ar, float ag, float ab, float aa,
		  float dr, float dg, float db, float da,
		  float sr, float sg, float sb, float sa,
		  float er, float eg, float eb, float ea,
		  float s, float t) {
    mat->ambient[0]=ar;mat->ambient[1]=ag;mat->ambient[2]=ab;mat->ambient[3]=aa;
    mat->diffuse[0]=dr;mat->diffuse[1]=dg;mat->diffuse[2]=db;mat->diffuse[3]=da;
    mat->specular[0]=sr;mat->specular[1]=sg;mat->specular[2]=sb;mat->specular[3]=sa;
    mat->emissive[0]=er;mat->emissive[1]=eg;mat->emissive[2]=eb;mat->emissive[3]=ea;
    mat->shininess=s*128.0;mat->transparency=t;
}
void Initvertex3d(vertex3d *vert, double x, double y, double z) {
    vert->coord[0]=x;vert->coord[1]=y;vert->coord[2]=z;
}
void Initvertex3dv(vertex3d *vert, int num, double *list) {
    int pos=0;
    for (int i=0;i<num;i++) {
	vert[i].coord[0]=list[pos++];
	vert[i].coord[1]=list[pos++];
	vert[i].coord[2]=list[pos++];
    };
}
void Initvertex2dv(vertex2d *vert, int num, double *list) {
    int pos=0;
    for (int i=0;i<num;i++) {
	vert[i].coord[0]=list[pos++];
	vert[i].coord[1]=list[pos++];
    };
}
void Initvertex2d(vertex2d *vert, double x, double y) {
    vert->coord[0]=x;vert->coord[1]=y;
}
void Initindexesv(int *index, int num, int *list) {
    int pos=0;
    for (int i=0;i<num;i++) {
	index[i]=list[i];
    };
}
//-------------------------------- CONSTRUCTOR/DESTRUCTOR ---------------------------
GLConvert::GLConvert(GLConvertParams *par) {
    cp=par;

    //--- Init default GLMaterial node (white) ---
    GLMaterial *cm=new GLMaterial(1);
    InitMaterial(&cm->materiallist[0],
		 0.2,0.2,0.2,1.0,
		 0.8,0.8,0.8,1.0,
		 0.0,0.0,0.0,1.0,
		 0.0,0.0,0.0,1.0,
		 0.2,1.0);
    cp->glm->Add(cm);

    cglmaterial=cm;
    cglcoordinate=NULL;
    cglnormal=NULL;
    cgltexcoord=NULL;

    /*
    if (cp->App) {
	GA_Msg = GaugeObject,
	    GaugeFrame,
	    MUIA_HelpNode, "GA_Msg",
	    MUIA_FixHeight, 10,
	    MUIA_Gauge_Horiz, TRUE,
	    MUIA_Gauge_Max, 100,
	End;

	TX_Msg = TextObject,
	    MUIA_Background, MUII_TextBack,
	    MUIA_Frame, MUIV_Frame_Text,
	    MUIA_Text_Contents, "",
	    MUIA_Text_SetMin, TRUE,
	End;

	WI_Msg = WindowObject,
	    MUIA_Window_Title, "Messages",
	    // MUIA_Window_ID, MAKE_ID('2', 'W', 'I', 'N'),
	    MUIA_Window_CloseGadget, FALSE,
	    MUIA_Window_SizeGadget, FALSE,
	    MUIA_Window_NoMenus, TRUE,
	    MUIA_Window_Open, FALSE,
	    MUIA_Window_Width, MUIV_Window_Width_Screen(30),
	    MUIA_Window_RefWindow, lp->RefWindow,
	    WindowContents, GroupObject,
		Child, GA_Msg,
		Child, ScaleObject,
		    MUIA_Scale_Horiz, TRUE,
		End,
		Child, TX_Msg,
	    End,
	End;

	DoMethod((Object *) lp->App,OM_ADDMEMBER,WI_Msg);
    };
    */
}

GLConvert::~GLConvert() {
    /*
    if (cp->App) {
	DoMethod((Object *) cp->App,OM_REMMEMBER,WI_Msg);
	MUI_DisposeObject((Object *) WI_Msg);
    };
    */
}

GLNode *GLConvert::ConvertVRML(VRMLNode *n) {
    GLNode *gln=NULL;

    if (n->ID==USE_1) {
	USE *u=(USE *) n;
	n=u->reference;
    }
    else if (n->ID==WWWINLINE_1) {
	WWWInline *www=(WWWInline *) n;
	if (www->in) n=www->in;
    };

    switch (n->ID) {
	case CONE_1:
	    gln=ConvertCone((Cone *)n);
	    break;
	case COORDINATE3_1:
	    cglcoordinate=ConvertCoordinate3((Coordinate3 *)n);
	    cp->glc->Add(cglcoordinate);
	    cp->st->c3=(Coordinate3 *) n;
	    break;
	case CUBE_1:
	    gln=ConvertCube((Cube *)n);
	    break;
	case CYLINDER_1:
	    gln=ConvertCylinder((Cylinder *)n);
	    break;
	case DIRECTIONALLIGHT_1:
	    gln=ConvertDirectionalLight((DirectionalLight *)n);
	    break;
	case GROUP_1:
	    gln=ConvertGroup((Group *)n);
	    break;
	case INDEXEDFACESET_1:
	    gln=ConvertIFS((IndexedFaceSet *)n);
	    break;
	case INDEXEDLINESET_1:
	    // gln=ConvertILS((IndexedLineSet *) n);
	    break;
	case MATERIAL_1:
	    cglmaterial=ConvertMaterial((Material *)n);
	    cp->glm->Add(cglmaterial);
	    cp->st->m=(Material *) n;
	    break;
	case MATERIALBINDING_1:
	    cp->st->mb=(MaterialBinding *) n;
	    break;
	case MATRIXTRANSFORM_1:
	    gln=ConvertMatrixTransform((MatrixTransform *) n);
	    break;
	case NORMAL_1:
	    cglnormal=ConvertNormal((Normal *)n);
	    cp->gln->Add(cglnormal);
	    cp->st->n=(Normal *) n;
	    break;
	case NORMALBINDING_1:
	    cp->st->nb=(NormalBinding *) n;
	    break;
	case POINTLIGHT_1:
	    gln=ConvertPointLight((PointLight *) n);
	    break;
	case ROTATION_1:
	    gln=ConvertRotation((Rotation *) n);
	    break;
	case SCALE_1:
	    gln=ConvertScale((Scale *) n);
	    break;
	case SEPARATOR_1:
	    gln=ConvertSeparator((Separator *)n);
	    break;
	case SPHERE_1:
	    gln=ConvertSphere((Sphere *)n);
	    break;
	case TEXTURE2_1:
	    gln=ConvertTexture2((Texture2 *)n);
	    cp->st->t=(Texture2 *) n;
	    break;
	case TEXTURE2TRANSFORM_1:
	    gln=ConvertTexture2Transform((Texture2Transform *)n);
	    break;
	case TEXTURECOORDINATE2_1:
	    cgltexcoord=ConvertTextureCoordinate2((TextureCoordinate2 *)n);
	    cp->gltc->Add(cgltexcoord);
	    cp->st->tc2=(TextureCoordinate2 *) n;
	    break;
	case TRANSFORM_1:
	    gln=ConvertTransform((Transform *)n);
	    break;
	case TRANSFORMSEPARATOR_1:
	    gln=ConvertTransformSeparator((TransformSeparator *)n);
	    break;
	case TRANSLATION_1:
	    gln=ConvertTranslation((Translation *)n);
	    break;
	case WWWANCHOR_1:
	    gln=ConvertWWWAnchor((WWWAnchor *)n);
	    break;
    };
    return gln;
}

//----------------------------------------- CONE --------------------------------
GLNode *GLConvert::ConvertCone(Cone *c) {
    GLShape *gls=new GLShape(cp->st->coneres+1,(cp->st->coneres*4)+cp->st->coneres);
    double halfh=c->height/2;
    int sides=(c->parts&SIDES);
    int bottom=(c->parts&BOTTOM);
    double angle=(2*3.1415)/cp->st->coneres,dx=1.0/(cp->st->coneres);
    double tangle=0.0,x=0.0,z=0.0,y=0.0;
    int pos=0,i1=0,i2=0,i3=0,i4=0,t1=0,t2=0,t3=0,t4=0;
    int j=0,i=0;

    #ifdef DEBUG
    puts("=>ConvertCone");
    #endif
    gls->glc=new GLVertex3d(cp->st->coneres+1);
    gls->gln=new GLVertex3d(cp->st->coneres+1);
    gls->gltc=new GLVertex2d(((cp->st->coneres+1)*2)+cp->st->coneres);
    gls->glm=cglmaterial;

    cp->glc->Add(gls->glc);
    cp->gln->Add(gls->gln);
    cp->gltc->Add(gls->gltc);

    //--- Generate Coordinates ---
    tangle=(3.14/2.0);
    for (i=0;i<cp->st->coneres;i++) {
	x=cos(tangle)*c->bottomRadius;
	z=sin(tangle)*c->bottomRadius;
	// printf("x:%f z:%f\n",x,z);
	Initvertex3d(&gls->glc->pointlist[i],x,-halfh,-z);
	tangle+=angle;
    };
    Initvertex3d(&gls->glc->pointlist[cp->st->coneres],0,halfh,0);

    //--- Generate Normals ---
    tangle=(3.14/2.0);
    for (i=0;i<cp->st->coneres;i++) {
	x=cos(tangle);
	z=sin(tangle);
	Initvertex3d(&gls->gln->pointlist[i],x,0.0,-z);
	tangle+=angle;
    };
    Initvertex3d(&gls->gln->pointlist[cp->st->coneres],0.0,-1.0,0.0);     // bottom

    //--- Generate TextureCoordinate ---
    x=0;
    for (i=0;i<=cp->st->coneres;i++) {
	// printf("x:%f\n",x);
	Initvertex2d(&gls->gltc->pointlist[i],x,1.0);
	Initvertex2d(&gls->gltc->pointlist[((cp->st->coneres+1)*2)-i-1],x,0.0);
	x+=dx;
    };
    tangle=(3.14/2.0);
    for (i=((cp->st->coneres+1)*2);i<((cp->st->coneres+1)*2)+cp->st->coneres;i++) {
	x=cos(tangle)/2.0;
	y=sin(tangle)/2.0;
	Initvertex2d(&gls->gltc->pointlist[i],0.5+x,0.5+y);
	tangle+=angle;
    };

    //--- faces initialisation ---
    pos=0;
    for (i=0;i<cp->st->coneres;i++) {
	i1=cp->st->coneres;
	i2=i;
	if (i2+1>=cp->st->coneres) {i3=0;}
	else {i3=i2+1;};
	i4=i1;

	t1=i;
	t2=(cp->st->coneres+1)*2-1-i;
	t3=t2-1;
	t4=t1+1;

	if (sides) {
	    // printf("index:%d %d %d %d tex:%d %d %d %d\n",i1,i2,i3,i4,t1,t2,t3,t4);
	    // first point
	    gls->coordIndex[pos]=i1;
	    gls->normalIndex[pos]=i2;
	    gls->texCoordIndex[pos++]=t1;
	    // second point
	    gls->coordIndex[pos]=i2;
	    gls->normalIndex[pos]=i2;
	    gls->texCoordIndex[pos++]=t2;
	    // third point
	    gls->coordIndex[pos]=i3;
	    gls->normalIndex[pos]=i3;
	    gls->texCoordIndex[pos++]=t3;
	    // forth point
	    gls->coordIndex[pos]=i4;
	    gls->normalIndex[pos]=i3;
	    gls->texCoordIndex[pos++]=t4;
	    // end index
	    gls->coordIndex[pos]=-1;
	    gls->normalIndex[pos]=-1;
	    gls->texCoordIndex[pos++]=-1;
	}
	else {
	    // first
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i2;
	    gls->texCoordIndex[pos++]=t1;
	    // second
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i2;
	    gls->texCoordIndex[pos++]=t2;
	    // third
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i3;
	    gls->texCoordIndex[pos++]=t3;
	    // forth
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i3;
	    gls->texCoordIndex[pos++]=t4;
	    // end
	    gls->coordIndex[pos]=-1;
	    gls->normalIndex[pos]=-1;
	    gls->texCoordIndex[pos++]=-1;
	};
    };

    for (i=cp->st->coneres-1;i>=0;i--) {
	if (bottom) {
	    gls->coordIndex[pos]=i;
	    gls->normalIndex[pos]=cp->st->coneres;
	    gls->texCoordIndex[pos++]=((cp->st->coneres+1)*2)+i;
	}
	else {
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=cp->st->coneres;
	    gls->texCoordIndex[pos++]=((cp->st->coneres+1)*2)+i;
	};
    };
    gls->coordIndex[pos]=-1;
    gls->normalIndex[pos]=-1;
    gls->texCoordIndex[pos++]=-1;

    //--- Materials ---
    pos=0;
    for (i=0;i<cp->st->coneres;i++) {
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=-1;
    };
    if ((cp->st->mb==NULL)||
	(cp->st->mb->value==BINDING_OVERALL)||
	(cp->st->mb->value==BINDING_DEFAULT)) {
	for (i=0;i<cp->st->coneres;i++) {
	    gls->materialIndex[pos++]=0;
	};
	gls->materialIndex[pos++]=-1;
    }
    else {
	for (i=0;i<cp->st->coneres;i++) {
	    if (gls->glm->nummats>=2) {
		gls->materialIndex[pos++]=1;
	    }
	    else {
		gls->materialIndex[pos++]=0;
	    };
	};
	gls->materialIndex[pos++]=-1;
    };

    //---------- Bounding Box
    Initvertex3d(&gls->bb1,-c->bottomRadius,halfh,-c->bottomRadius);
    Initvertex3d(&gls->bb2,c->bottomRadius,-halfh,c->bottomRadius);
    #ifdef DEBUG
    puts("<=ConvertCone");
    #endif
    return (GLNode *) gls;
}

//----------------------------------- Coordinate3 ---------------------------
GLVertex3d *GLConvert::ConvertCoordinate3(Coordinate3 *c) {
    GLVertex3d *glc=new GLVertex3d(c->Size());

    for (int i=0;i<c->Size();i++) {
	glc->pointlist[i].coord=c->GetPoint(i)->coord;
    };
    return glc;
}

GLNode *GLConvert::ConvertCube(Cube *c) {
    #ifdef DEBUG
    puts("=>ConvertCube");
    #endif
    GLShape *gls=new GLShape(6,24);
    double w=c->width/2.0;
    double h=c->height/2.0;
    double d=c->depth/2.0;
    gls->glc=new GLVertex3d(8);
    gls->gln=new GLVertex3d(6);
    gls->gltc=new GLVertex2d(4);
    gls->glm=cglmaterial;

    cp->glc->Add(gls->glc);
    cp->gln->Add(gls->gln);
    cp->gltc->Add(gls->gltc);

    //--- Coordinate ---
    double coord[]={-w,-h,-d, -w,h,-d, w,h,-d, w,-h,-d, -w,-h,d, -w,h,d, w,h,d, w,-h,d};
    Initvertex3dv(gls->glc->pointlist,8,coord);
    int coordIndex[]={7,6,5,4,-1,0,1,2,3,-1,5,6,2,1,-1,0,3,7,4,-1,3,2,6,7,-1,4,5,1,0,-1};
    Initindexesv(gls->coordIndex,30,coordIndex);
    // puts("after the coord init");
    //--- Normals ---
    double normals[]={0,0,1, 0,0,-1, 0,1,0, 0,-1,0, 1,0,0, -1,0,0};
    Initvertex3dv(gls->gln->pointlist,6,normals);
    int normalIndex[]={0,0,0,0,-1,1,1,1,1,-1,2,2,2,2,-1,3,3,3,3,-1,4,4,4,4,-1,5,5,5,5,-1};
    Initindexesv(gls->normalIndex,30,normalIndex);
    // puts("after the normals init");

    //--- Texture ---
    double texture[]={0,0, 1,0, 1,1, 0,1};
    Initvertex2dv(gls->gltc->pointlist,4,texture);
    int texCoordIndex[]={3,0,1,2,-1,0,1,2,3,-1,0,1,2,3,-1,1,0,3,2,-1,0,1,2,3,-1,1,0,3,2,-1};
    Initindexesv(gls->texCoordIndex,30,texCoordIndex);
    // puts("after the texture init");

    //--- Material ---
    if ((cp->st->mb==NULL)||
	(cp->st->mb->value==BINDING_OVERALL)||
	(cp->st->mb->value==BINDING_DEFAULT)) {
	int materialIndex[]={0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1};
	Initindexesv(gls->materialIndex,30,materialIndex);
    }
    else {
	if (gls->glm->nummats>=5) {
	    int materialIndex[]={0,0,0,0,-1,1,1,1,1,-1,2,2,2,2,-1,3,3,3,3,-1,4,4,4,4,-1,5,5,5,5,-1};
	    Initindexesv(gls->materialIndex,30,materialIndex);
	}
	else {
	    int materialIndex[]={0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1,0,0,0,0,-1};
	    Initindexesv(gls->materialIndex,30,materialIndex);
	};
    };
    // puts("after the mat init");
    // Delay(1000);
    //---------- Bounding Box
    gls->bb1=gls->glc->pointlist[0];
    gls->bb2=gls->glc->pointlist[6];
    // puts("<=ConvertCube");
    return (GLNode *) gls;
}
// Cylinder
GLNode *GLConvert::ConvertCylinder(Cylinder *c) {
    GLShape *gls=new GLShape(cp->st->cylinderres+2,(cp->st->cylinderres*4)+(2*cp->st->cylinderres));
    double halfh=c->height/2;
    int sides=(c->parts&SIDES);
    int top=(c->parts&TOP);
    int bottom=(c->parts&BOTTOM);
    double angle=(2*3.1415)/cp->st->cylinderres,dx=1.0/(cp->st->cylinderres);
    double tangle=0,x=0,z=0,y=0;
    int pos=0,i1=0,i2=0,i3=0,i4=0,t1=0,t2=0,t3=0,t4=0;
    int j=0,i=0;

    #ifdef DEBUG
    puts("=>ConvertCylinder");
    #endif
    gls->glc=new GLVertex3d(cp->st->cylinderres*2);
    gls->gln=new GLVertex3d(cp->st->cylinderres+2);
    gls->gltc=new GLVertex2d(((cp->st->cylinderres+1)*2)+cp->st->cylinderres);
    gls->glm=cglmaterial;

    cp->glc->Add(gls->glc);
    cp->gln->Add(gls->gln);
    cp->gltc->Add(gls->gltc);

    //--- Generate Coordinates ---
    tangle=(3.14/2.0);
    for (i=0;i<cp->st->cylinderres;i++) {
	x=cos(tangle)*c->radius;
	z=sin(tangle)*c->radius;
	Initvertex3d(&gls->glc->pointlist[i],x,halfh,-z);
	Initvertex3d(&gls->glc->pointlist[i+cp->st->cylinderres],x,-halfh,-z);
	tangle+=angle;
    };
    

    //--- Generate Normals ---
    tangle=(3.14/2.0);
    for (i=0;i<cp->st->cylinderres;i++) {
	x=cos(tangle);
	z=sin(tangle);
	Initvertex3d(&gls->gln->pointlist[i],x,0,-z);
	tangle+=angle;
    };
    Initvertex3d(&gls->gln->pointlist[cp->st->cylinderres],0,1,0);     // Top
    Initvertex3d(&gls->gln->pointlist[cp->st->cylinderres+1],0,-1,0);  // Bottom

    //--- Generate TextureCoordinate ---
    x=0;
    for (i=0;i<=cp->st->cylinderres;i++) {
	// printf("x:%f\n",x);
	Initvertex2d(&gls->gltc->pointlist[i],x,1);
	Initvertex2d(&gls->gltc->pointlist[((cp->st->cylinderres+1)*2)-i-1],x,0);
	x+=dx;
    };
    tangle=(3.14/2.0);
    for (i=((cp->st->cylinderres+1)*2);i<((cp->st->cylinderres+1)*2)+cp->st->cylinderres;i++) {
	x=cos(tangle)/2.0;
	y=sin(tangle)/2.0;
	Initvertex2d(&gls->gltc->pointlist[i],0.5+x,0.5+y);
	tangle+=angle;
    };

    /*
    for (i=0;i<gls->gltc->numpoints;i++) {
	printf("tex:%d x:%f y:%f\n",i,gls->gltc->pointlist[i].coord[0],gls->gltc->pointlist[i].coord[1]);
    };
    */

    //--- faces initialisation ---
    pos=0;
    for (i=0;i<cp->st->cylinderres;i++) {
	i1=i;
	i2=i+cp->st->cylinderres;
	if (i2+1>=cp->st->cylinderres*2) {
	    i3=cp->st->cylinderres;
	}
	else {
	    i3=i2+1;
	};
	if (i1+1>=cp->st->cylinderres) {
	    i4=0;
	}
	else {
	    i4=i1+1;
	};

	t1=i;
	t2=(cp->st->cylinderres+1)*2-1-i;
	t3=t2-1;
	t4=t1+1;

	if (sides) {
	    // printf("index:%d %d %d %d tex:%d %d %d %d\n",i1,i2,i3,i4,t1,t2,t3,t4);
	    // first point
	    gls->coordIndex[pos]=i1;
	    gls->normalIndex[pos]=i1;
	    gls->texCoordIndex[pos++]=t1;
	    // second point
	    gls->coordIndex[pos]=i2;
	    gls->normalIndex[pos]=i1;
	    gls->texCoordIndex[pos++]=t2;
	    // third point
	    gls->coordIndex[pos]=i3;
	    gls->normalIndex[pos]=i4;
	    gls->texCoordIndex[pos++]=t3;
	    // forth point
	    gls->coordIndex[pos]=i4;
	    gls->normalIndex[pos]=i4;
	    gls->texCoordIndex[pos++]=t4;
	    // end index
	    gls->coordIndex[pos]=-1;
	    gls->normalIndex[pos]=-1;
	    gls->texCoordIndex[pos++]=-1;
	}
	else {
	    // first
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i1;
	    gls->texCoordIndex[pos++]=t1;
	    // second
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i1;
	    gls->texCoordIndex[pos++]=t2;
	    // third
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i4;
	    gls->texCoordIndex[pos++]=t3;
	    // forth
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=i4;
	    gls->texCoordIndex[pos++]=t4;
	    // end
	    gls->coordIndex[pos]=-1;
	    gls->normalIndex[pos]=-1;
	    gls->texCoordIndex[pos++]=-1;
	};
    };

    for (i=0;i<cp->st->cylinderres;i++) {
	if (top) {
	    gls->coordIndex[pos]=i;
	    gls->normalIndex[pos]=cp->st->cylinderres;
	    gls->texCoordIndex[pos++]=((cp->st->cylinderres+1)*2)+i;
	}
	else {
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=cp->st->cylinderres;
	    gls->texCoordIndex[pos++]=((cp->st->cylinderres+1)*2)+i;
	};
    };
    gls->coordIndex[pos]=-1;
    gls->normalIndex[pos]=-1;
    gls->texCoordIndex[pos++]=-1;

    for (i=0;i<cp->st->cylinderres;i++) {
	if (bottom) {
	    gls->coordIndex[pos]=i+cp->st->cylinderres;
	    gls->normalIndex[pos]=cp->st->cylinderres+1;
	    gls->texCoordIndex[pos++]=((cp->st->cylinderres+1)*2)+i;
	}
	else {
	    gls->coordIndex[pos]=-2;
	    gls->normalIndex[pos]=cp->st->cylinderres+1;
	    gls->texCoordIndex[pos++]=((cp->st->cylinderres+1)*2)+i;
	};
    };
    gls->coordIndex[pos]=-1;
    gls->normalIndex[pos]=-1;
    gls->texCoordIndex[pos++]=-1;

    //--- Materials ---
    pos=0;
    for (i=0;i<cp->st->cylinderres;i++) {
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=0;
	gls->materialIndex[pos++]=-1;
    };
    if ((cp->st->mb==NULL)||
	(cp->st->mb->value==BINDING_OVERALL)||
	(cp->st->mb->value==BINDING_DEFAULT)) {
	for (i=0;i<cp->st->cylinderres;i++) {
	    gls->materialIndex[pos++]=0;
	};
	gls->materialIndex[pos++]=-1;
	for (i=0;i<cp->st->cylinderres;i++) {
	    gls->materialIndex[pos++]=0;
	};
	gls->materialIndex[pos++]=-1;
    }
    else {
	for (i=0;i<cp->st->cylinderres;i++) {
	    if (gls->glm->nummats>=1) {
		gls->materialIndex[pos++]=1;
	    }
	    else {
		gls->materialIndex[pos++]=0;
	    };
	};
	gls->materialIndex[pos++]=-1;
	for (i=0;i<cp->st->cylinderres;i++) {
	    if (gls->glm->nummats>=2) {
		gls->materialIndex[pos++]=2;
	    }
	    else {
		gls->materialIndex[pos++]=0;
	    };
	};
	gls->materialIndex[pos++]=-1;
    };

    //---------- Bounding Box
    Initvertex3d(&gls->bb1,-c->radius,halfh,-c->radius);
    Initvertex3d(&gls->bb2,c->radius,-halfh,c->radius);
    #ifdef DEBUG
    puts("<=ConvertCylinder");
    #endif
    return (GLNode *) gls;
}
GLNode *GLConvert::ConvertDirectionalLight(DirectionalLight *dl) {
    if (dl->on==FALSE) return NULL;
    GLDirectionalLight *gdl=new GLDirectionalLight(dl,cp->st->lightsource);
    cp->st->lightsource++;
    return (GLNode *) gdl;
}
// Group
GLNode *GLConvert::ConvertGroup(Group *g) {
    // puts("=>ConvertGroup");
    GLGroup *glg=new GLGroup();
    for (int i=0;i<g->Size();i++) {
	VRMLNode *n=g->GetChild(i);
	GLNode *gln=ConvertVRML(n);
	if (gln!=NULL) {
	    glg->children.Add(gln);
	};
    };
    // puts("<=ConvertGroup");
    return (GLNode *) glg;
}

// IFS
GLNode *GLConvert::ConvertIFS(IndexedFaceSet *ifs) {
    Face *cf=NULL;
    vertex3d cv;
    GLShape *gls=NULL;
    int j=0,i=0,index=0,coordindex=0,pos=0;

    #ifdef DEBUG
    puts("==>ConvertIFS");
    #endif
    if (cp->st->c3==NULL) return NULL;
    // puts("cp->st->c3 not NULL");
    //--- Count coordindex num ---
    for (i=0;i<ifs->faces.Length();i++) {
	cf=ifs->GetFace(i);
	coordindex+=cf->coordIndex.Length();
    };
    gls=new GLShape(ifs->Size(),coordindex);
    // puts("GLShape created");

    //--- Check if normal nodes exist ---
    if (cp->st->n==NULL) {
	ProduceNormalParams pn={cp->App,cp->RefWindow,cp->angle};
	NProducer NP=NProducer(&pn,cp->st->c3,(VRMLNode *) ifs);
	// puts("cp->st->n is NULL");
	cp->st->n=NP.ProduceNormal();
	// puts("normal produced");
	cglnormal=ConvertNormal(cp->st->n);
	// puts("normal vonverted");
	cp->gln->Add(cglnormal);
	cp->st->n=NULL;
	// puts("normal added");
    };

    //--- Affectation of current state variable ---
    gls->glc=cglcoordinate;
    gls->glm=cglmaterial;
    gls->gln=cglnormal;
    gls->gltc=cgltexcoord;

    /*
    printf("cglcoordinate:%d\n",gls->glc->numpoints);
    printf("cglmaterial:%d\n",gls->glm->nummats);
    printf("cglnormal:%d\n",gls->gln->numpoints);
    printf("cgltexcoord:%d\n",gls->gltc->numpoints);
    */

    //--- For each face ---
    for (i=0;i<ifs->Size();i++) {
	// printf("face:%d\n",i);
	cf=ifs->GetFace(i);
	for (j=0;j<cf->coordIndex.Length();j++) {
	    // puts("in loop");
	    gls->coordIndex[pos]=cf->coordIndex.Get(j);
	    // printf("coordindex:%d\n",gls->coordIndex[pos]);
	    cv=gls->glc->pointlist[gls->coordIndex[pos]];
	    // puts("cv found");

	    if (cv.coord[0]<gls->bb1.coord[0]) gls->bb1.coord[0]=cv.coord[0];
	    if (cv.coord[1]<gls->bb1.coord[1]) gls->bb1.coord[1]=cv.coord[1];
	    if (cv.coord[2]<gls->bb1.coord[2]) gls->bb1.coord[2]=cv.coord[2];
	    if (cv.coord[0]>gls->bb2.coord[0]) gls->bb2.coord[0]=cv.coord[0];
	    if (cv.coord[1]>gls->bb2.coord[1]) gls->bb2.coord[1]=cv.coord[1];
	    if (cv.coord[2]>gls->bb2.coord[2]) gls->bb2.coord[2]=cv.coord[2];
	    // puts("after bounding box");

	    //--- Material stuff ---
	    if (cp->st->m==NULL) {
		// puts("mat NULL");
		gls->materialIndex[pos]=0;
	    }
	    else if ((cp->st->mb==NULL) ||
		     (cp->st->mb->value==BINDING_OVERALL)||
		     (cp->st->mb->value==BINDING_DEFAULT)) {
		// puts("materialbinding NULL OR DEFAULT OR OVERALL");
		gls->materialIndex[pos]=0;
		// Delay(100);
	    }
	    else if ((cp->st->mb->value==BINDING_PER_FACE)||
		     (cp->st->mb->value==BINDING_PER_PART)) {
		gls->materialIndex[pos]=i;
	    }
	    else if ((cp->st->mb->value==BINDING_PER_FACE_INDEXED)||
		     (cp->st->mb->value==BINDING_PER_PART_INDEXED)) {
		index=cf->materialIndex.Get(0);
		if (index<=gls->glm->nummats) {
		    gls->materialIndex[pos]=index;
		}
		else {
		    gls->materialIndex[pos]=0;
		};
	    }
	    else if (cp->st->mb->value==BINDING_PER_VERTEX) {
		index=cf->coordIndex.Get(j);
		if (index<=gls->glm->nummats) {
		    gls->materialIndex[pos]=index;
		}
		else {
		    gls->materialIndex[pos]=0;
		};
	    }
	    else if (cp->st->mb->value==BINDING_PER_VERTEX_INDEXED) {
		index=cf->materialIndex.Get(j);
		if (index<=gls->glm->nummats) {
		    gls->materialIndex[pos]=index;
		}
		else {
		    gls->materialIndex[pos]=0;
		};
	    };
	    // puts("material stuff passed");

	    //--- Normal stuff ---
	    if ((cp->st->nb==NULL)||
		(cp->st->nb->value==BINDING_PER_VERTEX_INDEXED)) {
		index=cf->normalIndex.Get(j);
		gls->normalIndex[pos]=index;
	    }
	    else if (cp->st->nb->value==BINDING_OVERALL) {
		gls->normalIndex[pos]=0;
	    }
	    else if ((cp->st->nb->value==BINDING_PER_FACE)||
		     (cp->st->nb->value==BINDING_PER_PART)) {
		gls->normalIndex[pos]=i;
	    }
	    else if ((cp->st->nb->value==BINDING_PER_FACE_INDEXED)||
		     (cp->st->nb->value==BINDING_PER_PART_INDEXED)) {
		index=cf->normalIndex.Get(0);
		gls->normalIndex[pos]=index;
	    }
	    else if (cp->st->nb->value==BINDING_PER_VERTEX) {
		gls->normalIndex[pos]=cf->coordIndex.Get(j);
	    };
	    // puts("normalstuff passed");

	    //--- Texture stuff ---
	    if (cp->st->tc2==NULL) {
		 gls->texCoordIndex[pos]=-2;
	    }
	    else {
		index=cf->textureCoordIndex.Get(j);
		gls->texCoordIndex[pos]=index;
	    };
	    // puts("loop again");
	    pos++;
	    // return NULL;
	}; // end for each vertex
	gls->coordIndex[pos]=-1;
	gls->materialIndex[pos]=-1;
	gls->normalIndex[pos]=-1;
	gls->texCoordIndex[pos]=-1;
	pos++;
    }; // en for each face
    // RefreshGauge(st);
    #ifdef DEBUG
    puts("<=ConvertIFS");
    #endif
    return (GLNode *) gls;
}

// ILS
GLNode *GLConvert::ConvertILS(IndexedLineSet *ils) {
    Face *cf=NULL;
    vertex3d cv;
    GLWire *gls=NULL;
    int j=0,i=0,index=0,coordindex=0,pos=0;

    #ifdef DEBUG
    puts("==>ConvertILS");
    #endif
    if (cp->st->c3==NULL) return NULL;
    // puts("cp->st->c3 not NULL");
    //--- Count coordindex num ---
    for (i=0;i<ils->faces.Length();i++) {
	cf=ils->GetLine(i);
	coordindex+=cf->coordIndex.Length();
    };
    gls=new GLWire(ils->Size(),coordindex);
    // puts("GLShape created");

    //--- Check if normal nodes exist ---
    if (cp->st->n==NULL) {
	ProduceNormalParams pn={cp->App,cp->RefWindow,cp->angle};
	NProducer NP=NProducer(&pn,cp->st->c3,(VRMLNode *) ils);
	// puts("cp->st->n is NULL");
	cp->st->n=NP.ProduceNormal();
	// puts("normal produced");
	cglnormal=ConvertNormal(cp->st->n);
	// puts("normal vonverted");
	cp->gln->Add(cglnormal);
	cp->st->n=NULL;
	// puts("normal added");
    };
    //--- Affectation of current state variable ---
    gls->glc=cglcoordinate;
    gls->glm=cglmaterial;
    gls->gln=cglnormal;
    gls->gltc=cgltexcoord;

    /*
    printf("cglcoordinate:%d\n",gls->glc->numpoints);
    printf("cglmaterial:%d\n",gls->glm->nummats);
    printf("cglnormal:%d\n",gls->gln->numpoints);
    printf("cgltexcoord:%d\n",gls->gltc->numpoints);
    */

    //--- For each face ---
    for (i=0;i<ils->Size();i++) {
	// printf("face:%d\n",i);
	cf=ils->GetLine(i);
	for (j=0;j<cf->coordIndex.Length();j++) {
	    // puts("in loop");
	    gls->coordIndex[pos]=cf->coordIndex.Get(j);
	    // printf("coordindex:%d\n",gls->coordIndex[pos]);
	    cv=gls->glc->pointlist[gls->coordIndex[pos]];
	    // puts("cv found");

	    if (cv.coord[0]<gls->bb1.coord[0]) gls->bb1.coord[0]=cv.coord[0];
	    if (cv.coord[1]<gls->bb1.coord[1]) gls->bb1.coord[1]=cv.coord[1];
	    if (cv.coord[2]<gls->bb1.coord[2]) gls->bb1.coord[2]=cv.coord[2];
	    if (cv.coord[0]>gls->bb2.coord[0]) gls->bb2.coord[0]=cv.coord[0];
	    if (cv.coord[1]>gls->bb2.coord[1]) gls->bb2.coord[1]=cv.coord[1];
	    if (cv.coord[2]>gls->bb2.coord[2]) gls->bb2.coord[2]=cv.coord[2];
	    // puts("after bounding box");

	    //--- Material stuff ---
	    if (cp->st->m==NULL) {
		// puts("mat NULL");
		gls->materialIndex[pos]=0;
	    }
	    else if ((cp->st->mb==NULL) ||
		     (cp->st->mb->value==BINDING_OVERALL)||
		     (cp->st->mb->value==BINDING_DEFAULT)) {
		// puts("materialbinding NULL OR DEFAULT OR OVERALL");
		gls->materialIndex[pos]=0;
		// Delay(100);
	    }
	    else if ((cp->st->mb->value==BINDING_PER_FACE)||
		     (cp->st->mb->value==BINDING_PER_PART)) {
		gls->materialIndex[pos]=i;
	    }
	    else if ((cp->st->mb->value==BINDING_PER_FACE_INDEXED)||
		     (cp->st->mb->value==BINDING_PER_PART_INDEXED)) {
		index=cf->materialIndex.Get(0);
		if (index<=gls->glm->nummats) {
		    gls->materialIndex[pos]=index;
		}
		else {
		    gls->materialIndex[pos]=0;
		};
	    }
	    else if (cp->st->mb->value==BINDING_PER_VERTEX) {
		index=cf->coordIndex.Get(j);
		if (index<=gls->glm->nummats) {
		    gls->materialIndex[pos]=index;
		}
		else {
		    gls->materialIndex[pos]=0;
		};
	    }
	    else if (cp->st->mb->value==BINDING_PER_VERTEX_INDEXED) {
		index=cf->materialIndex.Get(j);
		if (index<=gls->glm->nummats) {
		    gls->materialIndex[pos]=index;
		}
		else {
		    gls->materialIndex[pos]=0;
		};
	    };
	    // puts("material stuff passed");

	    //--- Normal stuff ---
	    if ((cp->st->nb==NULL)||
		(cp->st->nb->value==BINDING_PER_VERTEX_INDEXED)) {
		index=cf->normalIndex.Get(j);
		gls->normalIndex[pos]=index;
	    }
	    else if (cp->st->nb->value==BINDING_OVERALL) {
		gls->normalIndex[pos]=0;
	    }
	    else if ((cp->st->nb->value==BINDING_PER_FACE)||
		     (cp->st->nb->value==BINDING_PER_PART)) {
		gls->normalIndex[pos]=i;
	    }
	    else if ((cp->st->nb->value==BINDING_PER_FACE_INDEXED)||
		     (cp->st->nb->value==BINDING_PER_PART_INDEXED)) {
		index=cf->normalIndex.Get(0);
		gls->normalIndex[pos]=index;
	    }
	    else if (cp->st->nb->value==BINDING_PER_VERTEX) {
		gls->normalIndex[pos]=cf->coordIndex.Get(j);
	    };
	    // puts("normalstuff passed");

	    //--- Texture stuff ---
	    if (cp->st->tc2==NULL) {
		 gls->texCoordIndex[pos]=-2;
	    }
	    else {
		index=cf->textureCoordIndex.Get(j);
		gls->texCoordIndex[pos]=index;
	    };
	    // puts("loop again");
	    pos++;
	    // return NULL;
	}; // end for each vertex
	gls->coordIndex[pos]=-1;
	gls->materialIndex[pos]=-1;
	gls->normalIndex[pos]=-1;
	gls->texCoordIndex[pos]=-1;
	pos++;
    }; // en for each face
    // RefreshGauge(st);
    #ifdef DEBUG
    puts("<=ConvertILS");
    #endif
    return (GLNode *) gls;









    /*
    if (cp->st->c3==NULL) return NULL;
    GLWire *glw=new GLWire();
    Face *cf=NULL;
    GLFace *glf=NULL;
    Vertex3d *cv=NULL;
    int lastindex=-1,index=-1;
    int i=0,j=0,psn=0;

    // puts("=>ConvertIFS");
    // For each face
    for (i=0;i<ils->Size();i++) {
	cf=ils->GetLine(i);
	glf=new GLFace();

	// Color stuff
	if (cp->st->m==NULL) {
	   if (i==0) {
	      glf->material.Add(new Mat());
	   };
	}
	else if ((cp->st->mb==NULL) ||
		 (cp->st->mb->value==BINDING_OVERALL)||
		 (cp->st->mb->value==BINDING_DEFAULT)) {
		  if (i==0) {
		     glf->material.Add(new Mat(cp->st->m->GetMaterial(0)));
		  };
	}
	else if ((cp->st->mb->value==BINDING_PER_FACE)||
		 (cp->st->mb->value==BINDING_PER_PART)) {
		 glf->material.Add(new Mat(cp->st->m->GetMaterial(i)));
	}
	else if ((cp->st->mb->value==BINDING_PER_FACE_INDEXED)||
		 (cp->st->mb->value==BINDING_PER_PART_INDEXED)) {
		 index=cf->materialIndex.Get(0);
		 if (index!=lastindex) {
		    glf->material.Add(new Mat(cp->st->m->GetMaterial(index)));
		    lastindex=index;
		 };
	};

	// for each vertex
	for (j=0;j<cf->coordIndex.Length();j++) {
	    // pointlicp->st->Get(cf->coordIndex.Get(j))->Add(i);
	    cv=cp->st->c3->GetPoint(cf->coordIndex.Get(j));
	    glf->vertex.Add(new Vertex3d(cv->coord));

	    // if PER_VERTEX Material binding
	    if ((cp->st->m)&&
		(cp->st->mb)) {
		if (cp->st->mb->value==BINDING_PER_VERTEX) {
		    glf->material.Add(new Mat(cp->st->m->GetMaterial(cf->coordIndex.Get(j))));
		}
		else if (cp->st->mb->value==BINDING_PER_VERTEX_INDEXED) {
		    glf->material.Add(new Mat(cp->st->m->GetMaterial(cf->materialIndex.Get(j))));
		};
	    };

	}; // end for each vertex
	glw->lines.Add(glf);
    };

    // RefreshGauge(st);
    // puts("<=ConvertIFS");
    return (GLNode *) glw;
    */
    return NULL;
}

// LOD
GLNode *GLConvert::ConvertLOD(LOD *lod) {
    return ConvertVRML(lod->GetChild(0));
}
//------------------------------------- Material -----------------------------
GLMaterial *GLConvert::ConvertMaterial(Material *m) {
    GLMaterial *glm=new GLMaterial(m->Size());
    Mat *cM=NULL;

    for (int i=0;i<m->Size();i++) {
	cM=m->GetMaterial(i);
	InitMaterial(&glm->materiallist[i],
		     cM->ambient.rgb[0],cM->ambient.rgb[1],cM->ambient.rgb[2],cM->ambient.rgb[3],
		     cM->diffuse.rgb[0],cM->diffuse.rgb[1],cM->diffuse.rgb[2],cM->diffuse.rgb[3],
		     cM->specular.rgb[0],cM->specular.rgb[1],cM->specular.rgb[2],cM->specular.rgb[3],
		     cM->emissive.rgb[0],cM->emissive.rgb[1],cM->emissive.rgb[2],cM->emissive.rgb[3],
		     cM->shininess/128.0,cM->transparency);
    };
    return glm;
}
// MatrixTransform
GLNode *GLConvert::ConvertMatrixTransform(MatrixTransform *m) {
    GLMultMatrix *glm=new GLMultMatrix(m->matrix);
    return (GLNode *) glm;
}
//----------------------------------- Normal ---------------------------
GLVertex3d *GLConvert::ConvertNormal(Normal *n) {
    GLVertex3d *gln=new GLVertex3d(n->Size());

    for (int i=0;i<n->Size();i++) {
	gln->pointlist[i].coord=n->GetVector(i)->coord;
    };
    return gln;
}

// PointLight
GLNode *GLConvert::ConvertPointLight(PointLight *pl) {
    if (pl->on==FALSE) return NULL;
    GLPointLight *gpl=new GLPointLight(pl,cp->st->lightsource);
    cp->st->lightsource++;
    return (GLNode *) gpl;
}
// Rotation
GLNode *GLConvert::ConvertRotation(Rotation *r) {
    GLRotate *glr=new GLRotate(r->rotation.coord);
    return (GLNode *) glr;
}

// Scale
GLNode *GLConvert::ConvertScale(Scale *s) {
    GLScale *gls=new GLScale(s->scaleFactor.coord);
    return (GLScale *) gls;
}

// Separator
GLNode *GLConvert::ConvertSeparator(Separator *s) {
    #ifdef DEBUG
    puts("=>ConvertSeparator");
    #endif
    VRMLState state=VRMLState();
    GLVertex3d *lglcoordinate=cglcoordinate;
    GLMaterial *lglmaterial=cglmaterial;
    GLVertex3d *lglnormal=cglnormal;
    GLVertex2d *lgltexcoord=cgltexcoord;
    state= *(cp->st);


    GLSeparator *gls=new GLSeparator();
    for (int i=0;i<s->Size();i++) {
	// VRMLNode *n=s->GetChild(i);
	GLNode *gln=ConvertVRML(s->GetChild(i));
	if (gln!=NULL) {
	    gls->children.Add(gln);
	};
    };
    *(cp->st)=state;
    cglcoordinate=lglcoordinate;
    cglmaterial=lglmaterial;
    cglnormal=lglnormal;
    cgltexcoord=lgltexcoord;
    #ifdef DEBUG
    puts("<=ConvertSeparator");
    #endif
    return (GLNode *) gls;
}
// Sphere
GLNode *GLConvert::ConvertSphere(Sphere *s) {
    GLShape *gls=new GLShape(cp->st->sphereres*(cp->st->sphereres/2),cp->st->sphereres*(cp->st->sphereres/2)*4);
    double radius=s->radius;
    double tangle=0,hangle=0,x=0,y=0,z=0,dx=0,dy=0;
    double angle=(2*3.1415)/cp->st->sphereres;
    int i=0,j=0,nb=0,i1=0,i2=0,i3=0,i4=0,pos=0,t1=0,t2=0,t3=0,t4=0;

    // puts("=>ConvertSphere");
    nb=(cp->st->sphereres-2)/2+2;
    // printf("points:%d\n",nb*cp->st->sphereres);
    gls->glc=new GLVertex3d(nb*cp->st->sphereres);
    gls->gln=new GLVertex3d(nb*cp->st->sphereres);
    gls->gltc=new GLVertex2d(nb*(cp->st->sphereres+1));
    gls->glm=cglmaterial;

    cp->glc->Add(gls->glc);
    cp->gln->Add(gls->gln);
    cp->gltc->Add(gls->gltc);

    //--- Generate Coordinates and normals ---
    hangle=(3.14/2.0);
    pos=0;
    for (j=0;j<nb;j++) {
	tangle=(3.14/2.0);
	for (i=0;i<cp->st->sphereres;i++) {
	    x=cos(tangle)*s->radius*fabs(cos(hangle));
	    z=sin(tangle)*s->radius*fabs(cos(hangle));
	    y=sin(hangle)*s->radius;
	    // printf("ligne %d x:%f y:%f z:%f\n",j,x,y,-z);
	    Initvertex3d(&gls->glc->pointlist[pos],x,y,-z);
	    Initvertex3d(&gls->gln->pointlist[pos++],x/s->radius,y/s->radius,-z/s->radius);
	    tangle+=angle;
	};
	hangle+=angle;
    };

    //--- Genrate texture coordinate ---
    pos=0;
    dx=1.0/cp->st->sphereres;dy=1.0/(nb-1);
    // printf("dx:%f dy:%f\n",dx,dy);
    x=0.0;y=1.0;
    for (j=0;j<nb;j++) {
	for (i=0;i<=cp->st->sphereres;i++) {
	    // printf("point:%d x:%f y:%f\n",pos,x,y);
	    Initvertex2d(&gls->gltc->pointlist[pos++],x,y);
	    x+=dx;
	};
	x=0.0;
	y-=dy;
    };

    //--- Init faces ---
    pos=0;
    for (j=0;j<nb-1;j++) {
	for (i=0;i<cp->st->sphereres;i++) {
	    i1=(j*cp->st->sphereres)+i;
	    i2=(j*cp->st->sphereres)+i+cp->st->sphereres;
	    if (i==cp->st->sphereres-1) {
		i3=(j*cp->st->sphereres)+cp->st->sphereres;
		i4=j*cp->st->sphereres;
	    }
	    else {
		i3=i2+1;
		i4=i1+1;
	    };
	    t1=(j*(cp->st->sphereres+1))+i;
	    t2=(j*(cp->st->sphereres+1))+i+cp->st->sphereres+1;
	    t3=t2+1;
	    t4=t1+1;

	    gls->coordIndex[pos]=i1;
	    gls->materialIndex[pos]=0;
	    gls->texCoordIndex[pos]=t1;
	    gls->normalIndex[pos++]=i1;

	    gls->coordIndex[pos]=i2;
	    gls->materialIndex[pos]=0;
	    gls->texCoordIndex[pos]=t2;
	    gls->normalIndex[pos++]=i2;

	    gls->coordIndex[pos]=i3;
	    gls->materialIndex[pos]=0;
	    gls->texCoordIndex[pos]=t3;
	    gls->normalIndex[pos++]=i3;

	    gls->coordIndex[pos]=i4;
	    gls->materialIndex[pos]=0;
	    gls->texCoordIndex[pos]=t4;
	    gls->normalIndex[pos++]=i4;

	    gls->coordIndex[pos]=-1;
	    gls->materialIndex[pos]=-1;
	    gls->texCoordIndex[pos]=-1;
	    gls->normalIndex[pos++]=-1;
	    // printf("index:%d %d %d %d\n",i1,i2,i3,i4);
	};
    };

    //---------- Bounding Box
    Initvertex3d(&gls->bb1,-s->radius,s->radius,-s->radius);
    Initvertex3d(&gls->bb2,s->radius,-s->radius,s->radius);

    return (GLNode *) gls;
}
// SpotLight
GLNode *GLConvert::ConvertSpotLight(SpotLight *sl) {
    if (sl->on==FALSE) return NULL;
    GLSpotLight *gsl=new GLSpotLight(sl,cp->st->lightsource);
    cp->st->lightsource++;
    return (GLNode *) gsl;
}
GLNode *GLConvert::ConvertTexture2(Texture2 *t) {
    GLTexture *glt=new GLTexture(t->width,t->height,t->component,t->wrapS,t->wrapT);
    CopyMem(t->image,glt->image,t->width*t->height*t->component);
    return (GLNode *) glt;
}
//----------------------------- TextureCoordinate2 -------------------
GLVertex2d *GLConvert::ConvertTextureCoordinate2(TextureCoordinate2 *tc) {
    GLVertex2d *gltc=new GLVertex2d(tc->Size());

    for (int i=0;i<tc->Size();i++) {
	gltc->pointlist[i].coord=tc->GetPoint(i)->coord;
    };
    /*
    for (int i=0;i<tc->Size();i++) {
	printf("position:%d x:%f y:%f\n",i,gltc->pointlist[i].coord[0],gltc->pointlist[i].coord[1]);
    };
    */
    return gltc;
}
// Texture2Transform
GLNode *GLConvert::ConvertTexture2Transform(Texture2Transform *tt) {
    /*
    GLTextureTransform *glt=new GLTextureTransform(tt->translation,tt->scaleFactor,tt->center,tt->rotation);

    return (GLNode *) glt;
    */
}
// Transform
GLNode *GLConvert::ConvertTransform(Transform *t) {
    // puts("=>ConvertTransform");
    GLTransform *glt=new GLTransform(t->translation.coord,t->rotation.coord,t->scaleFactor.coord,t->scaleOrientation.coord,t->center.coord);
    // puts("<=ConvertTransform");
    return (GLNode *) glt;
}

// TransformSeparator
GLNode *GLConvert::ConvertTransformSeparator(TransformSeparator *ts) {
    GLSeparator *gls=new GLSeparator();
    #ifdef DEBUG
    puts("==>ConvertTransformSeparator");
    #endif
    for (int i=0;i<ts->Size();i++) {
	GLNode *gln=ConvertVRML(ts->GetChild(i));
	if (gln!=NULL) {
	    gls->children.Add(gln);
	};
    };
    #ifdef DEBUG
    puts("<==ConvertTransformSeparator");
    #endif
    return (GLNode *) gls;
}

// Translation
GLNode *GLConvert::ConvertTranslation(Translation *t) {
    // puts("=>ConvertTranslation");
    GLTranslate *glt=new GLTranslate(t->translation.coord);
    // puts("<=ConvertTranslation");
    return (GLNode *) glt;
}
// WWWAnchor
GLNode *GLConvert::ConvertWWWAnchor(WWWAnchor *www) {
    VRMLState state=VRMLState();
    state= *(cp->st);
    GLSeparator *gls=new GLSeparator();
    for (int i=0;i<www->Size();i++) {
	// VRMLNode *n=s->GetChild(i);
	GLNode *gln=ConvertVRML(www->GetChild(i));
	if (gln!=NULL) {
	    gls->children.Add(gln);
	};
    };
    *(cp->st) =state;
    // puts("<=ConvertSeparator");
    return (GLNode *) gls;
}

// WWWInline
GLNode *GLConvert::ConvertWWWInline(WWWInline *www) {
    if (www->in) {
	return ConvertVRML((VRMLNode *) www);
    };
}
