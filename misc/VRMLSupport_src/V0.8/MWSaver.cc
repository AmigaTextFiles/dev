/*----------------------------------------------------
  MWSaver.cc (MeshWriter library 0.2 saver)
  Version 0.8
  Date: 4 septembre 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: MeshWriter library output
-----------------------------------------------------*/
#include <math.h>
#include <libraries/mui.h>
#include <meshwriter/meshwriter.h>

#include <proto/meshwriter.h>
#include <proto/muimaster.h>
#include <proto/intuition.h>
#include <proto/alib.h>
#include <proto/Amigamesa.h>

#include "MWSaver.h"
#include "VRMLSupport.h"

#define COPYRIGHT_STRING "Produced with VRMLEditor written by BODMER Stephan, using MeshWriter library written by Stephan Bielmann"

extern struct MeshWriterBase *MeshWriterBase;
extern struct Library *glBase;
extern struct Library *gluBase;
extern struct Library *glutBase;

MWSaver::MWSaver(SaveMWParams *par):
    st() {
    puts("In MWSaver constructor");
    sp=par;
    st.coneres=sp->coneres;
    st.cylinderres=sp->cylinderres;
    st.sphereres=sp->sphereres;
    nb=0;
    mwhd=0;

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
	MUIA_Window_SizeGadget, TRUE,
	MUIA_Window_NoMenus, TRUE,
	MUIA_Window_Open, FALSE,
	MUIA_Window_Width, MUIV_Window_Width_Screen(30),
	MUIA_Window_RefWindow, sp->RefWindow,
	WindowContents, GroupObject,
	    Child, GA_Msg,
	    Child, ScaleObject,
		MUIA_Scale_Horiz, TRUE,
	    End,
	    Child, TX_Msg,
	End,
    End;
    DoMethod((Object *) sp->App,OM_ADDMEMBER,WI_Msg);
    puts("object created");
}
MWSaver::~MWSaver() {
    puts("destructor");
    DoMethod((Object *) sp->App,OM_REMMEMBER,WI_Msg);
    MUI_DisposeObject((Object *) WI_Msg);
    puts("out");
}
VRMLStatus MWSaver::WriteMW(char *filename, VRMLNode *n) {
    VRMLState state=VRMLState();

    mwhd=MWLMeshNew();
    
    if (mwhd==0) {
	return error;
    };
    MWLMeshCopyrightSet(mwhd,COPYRIGHT_STRING);
    puts("before browse");
    n->Browse(&state);
    SetAttrs((Object *) TX_Msg, MUIA_Text_Contents, "Inserting data into meshwriter.library");
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Max,state.totalnodes);
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,0);
    SetAttrs((Object *) WI_Msg, MUIA_Window_Open, TRUE);
    SaveNode(n);
    SetAttrs((Object *) TX_Msg, MUIA_Text_Contents, "Saving via meshwriter.library");
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Max,0);
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,0);
    MWLMeshSave3D(mwhd,sp->id,filename,NULL);
    SetAttrs((Object *) WI_Msg, MUIA_Window_Open, FALSE);
    MWLMeshDelete(mwhd);
    // puts("passed");
    return exported;
}
void MWSaver::SaveNode(VRMLNode *n) {
    switch (n->ID) {
	// case ASCIITEXT_1:WriteAsciiText((AsciiText *) n,tab);break;
	case CONE_1:WriteCone((Cone *) n);break;
	case COORDINATE3_1:WriteCoordinate3((Coordinate3 *) n);break;
	case CUBE_1:WriteCube((Cube *) n);break;
	case CYLINDER_1:WriteCylinder((Cylinder *) n);break;
	// case DIRECTIONALLIGHT_1:WriteDirectionalLight((DirectionalLight *)n, tab);break;
	// case FONTSTYLE_1:WriteFontStyle((FontStyle *) n, tab);break;
	case GROUP_1:WriteGroup((Group *) n);break;
	case INDEXEDFACESET_1:WriteIFS((IndexedFaceSet *) n);break;
	// case INDEXEDLINESET_1:WriteILS((IndexedLineSet *) n, tab);break;
	// case INFO_1:WriteInfo((VInfo *) n, tab);break;
	case LOD_1:WriteLOD((LOD *) n);break;
	case MATERIAL_1:WriteMaterial((Material *) n);break;
	case MATERIALBINDING_1:WriteMaterialBinding((MaterialBinding *) n);break;
	// case MATRIXTRANSFORM_1:WriteMatrixTransform((MatrixTransform *) n, tab);break;
	// case NORMAL_1:WriteNormal((Normal *) n, tab);break;
	// case NORMALBINDING_1:WriteNormalBinding((NormalBinding *) n, tab);break;
	// case ORTHOGRAPHICCAMERA_1:WriteOC((OrthographicCamera *) n, tab);break;
	// case PERSPECTIVECAMERA_1:WritePC((PerspectiveCamera *) n, tab);break;
	// case POINTLIGHT_1:WritePointLight((PointLight *) n, tab);break;
	// case POINTSET_1:WritePointSet((PointSet *) n, tab);break;
	case ROTATION_1:WriteRotation((Rotation *) n);break;
	case SCALE_1:WriteScale((Scale *) n);break;
	case SEPARATOR_1:WriteSeparator((Separator *) n);break;
	// case SHAPEHINTS_1:WriteShapeHints((ShapeHints *) n, tab);break;
	case SPHERE_1:WriteSphere((Sphere *) n);break;
	// case SPOTLIGHT_1:WriteSpotLight((SpotLight *) n, tab);break;
	case SWITCH_1:WriteSwitch((Switch *) n);break;
	// case TEXTURE2_1:WriteTexture2((Texture2 *) n, tab);break;
	// case TEXTURE2TRANSFORM_1:WriteTexture2Transform((Texture2Transform *) n, tab);break;
	// case TEXTURECOORDINATE2_1:WriteTextureCoordinate2((TextureCoordinate2 *) n, tab);break;
	case TRANSFORM_1:WriteTransform((Transform *) n);break;
	case TRANSFORMSEPARATOR_1:WriteTransformSeparator((TransformSeparator *) n);break;
	case TRANSLATION_1:WriteTranslation((Translation *) n);break;
	case WWWANCHOR_1:WriteWWWAnchor((WWWAnchor *) n);break;
	case WWWINLINE_1:WriteWWWInline((WWWInline *) n);break;
	case USE_1:WriteUSE((USE *) n);break;
    };
    nb++;
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,nb);
}

/*---------------------
 -       Misc         -
 ----------------------*/
void MWSaver::WriteMat(Mat *mat) {
    Color4f ambient=mat->ambient;
    Color4f diffuse=mat->diffuse;
    Color4f specular=mat->specular;
    Color4f emissive=mat->emissive;
    ULONG mhd=0;
    float r,g,b;
    TOCLColor tc;

    MWLMeshMaterialAdd(mwhd,&mhd);
    r=ambient.rgb[0]*255.0;
    g=ambient.rgb[1]*255.0;
    b=ambient.rgb[2]*255.0;
    tc.r=(UBYTE) r;tc.g=(UBYTE) g;tc.b=(UBYTE) b;
    MWLMeshMaterialAmbientColorSet(mwhd,mhd,&tc);
    r=diffuse.rgb[0]*255.0;
    g=diffuse.rgb[1]*255.0;
    b=diffuse.rgb[2]*255.0;
    tc.r=(UBYTE) r;tc.g=(UBYTE) g;tc.b= (UBYTE) b;
    MWLMeshMaterialDiffuseColorSet(mwhd,mhd,&tc);
    MWLMeshMaterialShininessSet(mwhd,mhd,mat->shininess);
    MWLMeshPolygonMaterialSet(mwhd,mhd);
}
/**************
 * VRML Nodes *
 **************/
/*
// AsciiText
void MWSaver::WriteAsciiText(AsciiText *a, int tab) {
}
*/
// Cone
void MWSaver::WriteCone(Cone *c) {
    double angle=(2*3.1415)/st.coneres;
    double tangle=0;
    double xcos=1,zsin=0,topy=0;
    double oldx=c->bottomRadius,oldz=0,newx=oldx,newz=oldz;
    double halfh=c->height/2;
    int sides=c->parts&SIDES;
    int bottom=c->parts&BOTTOM;
    int i=0;
    TOCLVertex tr;
    Mat *cm[2],*currentmat=NULL;
    Mat *white=NULL;


    if (st.m==NULL) {
	white=new Mat();
	for (i=0;i<2;i++) {
	    cm[i]=white;
	};
    }
    else {
	if ((st.mb==NULL)||
	    (st.mb->value==BINDING_OVERALL)||
	    (st.mb->value==BINDING_DEFAULT)) {
	    for (i=0;i<2;i++) {
		cm[i]=st.m->GetMaterial(0);
	    };
	}
	else if ((st.mb->value==BINDING_PER_PART_INDEXED)||
		 (st.mb->value==BINDING_PER_PART)) {
	    for (i=0;i<2;i++) {
		cm[i]=st.m->GetMaterial(i);
	    };
	}
	else {
	    white=new Mat();
	    for (i=0;i<2;i++) {
		cm[i]=white;
	    };    
	};
    };

    // parts contains SIDE
    if (sides) {
	// puts("parts contain SIDES");
	
	
	for (i=0;i<st.coneres;i++) {
	    tangle=tangle+angle;
	    newx=cos(tangle)*c->bottomRadius;
	    newz=sin(tangle)*c->bottomRadius;
	    topy=sin(atan(c->bottomRadius/c->height))*c->bottomRadius;

	    MWLMeshPolygonAdd(mwhd,0);
	    WriteMat(cm[0]);
	    tr.x=0;tr.y=halfh;tr.z=0;
	    MWLMeshPolygonVertexAdd(mwhd,&tr);
	    tr.x=oldx;tr.y=-halfh;tr.z=oldz;
	    MWLMeshPolygonVertexAdd(mwhd,&tr);
	    tr.x=newx;tr.y=-halfh;tr.z=newz;
	    MWLMeshPolygonVertexAdd(mwhd,&tr);
	    oldx=newx;
	    oldz=newz;
	};
    };

    tangle=2*3.1415;
    newx=c->bottomRadius;newz=0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	for (i=0;i<st.coneres+1;i++) {
	    MWLMeshPolygonAdd(mwhd,0);
	    WriteMat(cm[1]);
	    tr.x=0;tr.y=-halfh;tr.z=0;
	    MWLMeshPolygonVertexAdd(mwhd,&tr);
	    tr.x=newx;tr.y=-halfh;tr.z=newz;
	    MWLMeshPolygonVertexAdd(mwhd,&tr);
	    tangle=tangle-angle;
	    newx=cos(tangle)*c->bottomRadius;
	    newz=sin(tangle)*c->bottomRadius;
	    tr.x=newx;tr.y=-halfh;tr.z=newz;
	    MWLMeshPolygonVertexAdd(mwhd,&tr);
	};
    };
    if (white) delete white;
}
// Coordinate3
void MWSaver::WriteCoordinate3(Coordinate3 *c) {
    puts("WriteCoordinate");
    st.c3=c;
}
// Cube
void MWSaver::WriteCube(Cube *c) {
    double w=c->width/2;
    double h=c->height/2;
    double d=c->depth/2;
    float r[6],g[6],b[6];
    int i=0;
    ULONG p0,p1,p2,p3,p4,p5,p6,p7;
    TOCLVertex tp0={w,h,d};
    TOCLVertex tp1={w,h,-d};
    TOCLVertex tp2={-w,h,-d};
    TOCLVertex tp3={-w,h,d};
    TOCLVertex tp4={w,-h,d};
    TOCLVertex tp5={w,-h,-d};
    TOCLVertex tp6={-w,-h,-d};
    TOCLVertex tp7={-w,-h,d};
    Mat *cm[6],*currentmat=NULL;
    Mat *white=NULL;

    /*
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"// %s (Cube)\n",c->GetName());
    }
    else {
	fprintf(f,"// Cube\n");
    };
    */

    if (st.m==NULL) {
	white=new Mat();
	for (i=0;i<6;i++) {
	    cm[i]= white;
	};
    }
    else {
	if ((st.mb==NULL)||
	    (st.mb->value==BINDING_OVERALL)||
	    (st.mb->value==BINDING_DEFAULT)) {
	    for (i=0;i<6;i++) {
		cm[i]=st.m->GetMaterial(0);
	    };
	}
	else if ((st.mb->value==BINDING_PER_FACE_INDEXED)||
		 (st.mb->value==BINDING_PER_FACE)||
		 (st.mb->value==BINDING_PER_PART_INDEXED)||
		 (st.mb->value==BINDING_PER_PART)) {
	    for (i=0;i<6;i++) {
		cm[i]=st.m->GetMaterial(i);
	    };
	}
	else {
	    white=new Mat();
	    for (i=0;i<6;i++) {
		cm[i]= white;
	    };
	};
    };

    MWLMeshVertexAdd(mwhd,&tp0,&p0);
    MWLMeshVertexAdd(mwhd,&tp1,&p1);
    MWLMeshVertexAdd(mwhd,&tp2,&p2);
    MWLMeshVertexAdd(mwhd,&tp3,&p3);
    MWLMeshVertexAdd(mwhd,&tp4,&p4);
    MWLMeshVertexAdd(mwhd,&tp5,&p5);
    MWLMeshVertexAdd(mwhd,&tp6,&p6);
    MWLMeshVertexAdd(mwhd,&tp7,&p7);

    //--- Haut
    MWLMeshPolygonAdd(mwhd,0);
    MWLMeshPolygonVertexAssign(mwhd,p0);
    MWLMeshPolygonVertexAssign(mwhd,p1);
    MWLMeshPolygonVertexAssign(mwhd,p2);
    MWLMeshPolygonVertexAssign(mwhd,p3);
    WriteMat(cm[0]);

    //--- Right
    MWLMeshPolygonAdd(mwhd,0);
    MWLMeshPolygonVertexAssign(mwhd,p0);
    MWLMeshPolygonVertexAssign(mwhd,p4);
    MWLMeshPolygonVertexAssign(mwhd,p5);
    MWLMeshPolygonVertexAssign(mwhd,p1);
    WriteMat(cm[1]);

    //--- behind
    MWLMeshPolygonAdd(mwhd,0);
    MWLMeshPolygonVertexAssign(mwhd,p1);
    MWLMeshPolygonVertexAssign(mwhd,p5);
    MWLMeshPolygonVertexAssign(mwhd,p6);
    MWLMeshPolygonVertexAssign(mwhd,p2);
    WriteMat(cm[2]);

    //--- left
    MWLMeshPolygonAdd(mwhd,0);
    MWLMeshPolygonVertexAssign(mwhd,p2);
    MWLMeshPolygonVertexAssign(mwhd,p6);
    MWLMeshPolygonVertexAssign(mwhd,p7);
    MWLMeshPolygonVertexAssign(mwhd,p3);
    WriteMat(cm[3]);

    //--- front
    MWLMeshPolygonAdd(mwhd,0);
    MWLMeshPolygonVertexAssign(mwhd,p3);
    MWLMeshPolygonVertexAssign(mwhd,p7);
    MWLMeshPolygonVertexAssign(mwhd,p4);
    MWLMeshPolygonVertexAssign(mwhd,p0);
    WriteMat(cm[4]);

    //--- bottom
    MWLMeshPolygonAdd(mwhd,0);
    MWLMeshPolygonVertexAssign(mwhd,p7);
    MWLMeshPolygonVertexAssign(mwhd,p6);
    MWLMeshPolygonVertexAssign(mwhd,p5);
    MWLMeshPolygonVertexAssign(mwhd,p4);
    WriteMat(cm[5]);

    if (white) delete white;
}

// Cylinder
void MWSaver::WriteCylinder(Cylinder *c) {
    float r[3],g[3],b[3];
    Mat *cm[6],*currentmat=NULL;
    Mat *white=NULL;
    double angle=(2*3.1415)/st.cylinderres;
    double tangle=0;
    double xcos=1,zsin=0;
    double oldx=c->radius,oldz=0,newx,newz;
    double halfh=c->height/2;
    int sides=c->parts&SIDES;
    int top=c->parts&TOP;
    int bottom=c->parts&BOTTOM;
    int i;
    TOCLVertex tv;

    /*
    WriteTabs(tab);
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"// %s (Cylinder)\n",c->GetName());
    }
    else {
	fprintf(f,"// Cylinder\n");
    };
    */

    if (st.m==NULL) {
	white=new Mat();
	for (i=0;i<3;i++) {
	    cm[i]=white;
	};
    }
    else {
	if ((st.mb==NULL)||
	    (st.mb->value==BINDING_OVERALL)||
	    (st.mb->value==BINDING_DEFAULT)) {
	    for (i=0;i<3;i++) {
		cm[i]=st.m->GetMaterial(0);
	    };
	}
	else if ((st.mb->value==BINDING_PER_PART_INDEXED)||
		 (st.mb->value==BINDING_PER_PART)) {
	    for (i=0;i<3;i++) {
		cm[i]=st.m->GetMaterial(i);
	    };
	}
	else {
	    white=new Mat();
	    for (i=0;i<3;i++) {
		cm[i]=white;
	    };
	};
     };

    // parts contains SIDE
    if (sides) {
	// puts("parts contain SIDES");
	for (i=0;i<st.cylinderres;i++) {
	    MWLMeshPolygonAdd(mwhd,0);
	    WriteMat(cm[0]);
	    tangle=tangle+angle;
	    newx=cos(tangle)*c->radius;
	    newz=sin(tangle)*c->radius;
	    tv.x=oldx;tv.y=halfh;tv.z=oldz;
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    tv.x=oldx;tv.y=-halfh;tv.z=oldz;
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    tv.x=newx;tv.y=-halfh;tv.z=newz;
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    tv.x=newx;tv.y=halfh;tv.z=newz;
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    oldx=newx;
	    oldz=newz;
	};
    };

    tangle=0;
    newx=c->radius;newz=0;
    // parts contains TOP
    if (top) {
	// puts("parts contains TOP");
	    for (i=0;i<st.cylinderres+1;i++) {
		MWLMeshPolygonAdd(mwhd,0);
		WriteMat(cm[1]);
		tv.x=0;tv.y=halfh;tv.z=0;
		MWLMeshPolygonVertexAdd(mwhd,&tv);
		tv.x=newx;tv.y=halfh;tv.z=newz;
		MWLMeshPolygonVertexAdd(mwhd,&tv);
		tangle=tangle+angle;
		newx=cos(tangle)*c->radius;
		newz=sin(tangle)*c->radius;
		tv.x=newx;tv.y=halfh;tv.z=newz;
		MWLMeshPolygonVertexAdd(mwhd,&tv);
	    };
    };

    tangle=2*3.1415;
    newx=c->radius;newz=0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
		
	    for (i=0;i<st.cylinderres+1;i++) {
		MWLMeshPolygonAdd(mwhd,0);
		WriteMat(cm[2]);
		tv.x=0;tv.y=-halfh;tv.z=0;
		MWLMeshPolygonVertexAdd(mwhd,&tv);
		tv.x=newx;tv.y=-halfh;tv.z=newz;
		MWLMeshPolygonVertexAdd(mwhd,&tv);
		tangle=tangle-angle;
		newx=cos(tangle)*c->radius;
		newz=sin(tangle)*c->radius;
		tv.x=newx;tv.y=-halfh;tv.z=newz;
		MWLMeshPolygonVertexAdd(mwhd,&tv);
	    };
    };
    if (white) delete white;

}

/*
// DirectionalLight
void MWSaver::WriteDirectionalLight(DirectionalLight *dl, int tab) {
    char LightNum[10];
    switch (st.lightsource) {
	case 0:strcpy(LightNum,"GL_LIGHT0");break;
	case 1:strcpy(LightNum,"GL_LIGHT1");break;
	case 2:strcpy(LightNum,"GL_LIGHT2");break;
	case 3:strcpy(LightNum,"GL_LIGHT3");break;
	default  :strcpy(LightNum,"GL_LIGHT4");break;
    };

    WriteTabs(tab);
    if (strcmp(dl->GetName(),"NONE")) {
	fprintf(f,"// %s (DirectionalLight)\n",dl->GetName());
    }
    else {
	fprintf(f,"// DirectionalLight\n");
    };

    if (dl->on==TRUE) {
	WriteTabs(tab);
	fprintf(f,"glEnable(%s);\n",LightNum);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_POSITION, %.4f, %.4f, %.4f, %.4f);\n",
		   LightNum,
		   dl->point.coord[0],dl->point.coord[1],dl->point.coord[2],dl->point.coord[3]);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_DIFFUSE, %.2f, %.2f, %.2f, %.2f);\n",
		   LightNum,
		   dl->color.rgb[0],dl->color.rgb[1],dl->color.rgb[2],dl->color.rgb[3]);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_AMBIENT, %.2f, %.2f, %.2f, 1.0);\n",
		   LightNum,
		   dl->intensity,dl->intensity,dl->intensity);
	st.lightsource++;
   };

}
*/
/*
// FontStyle
void MWSaver::WriteFontStyle(FontStyle *fs, int tab) {
}
*/
// Group
void MWSaver::WriteGroup(Group *g) {
    int i=0;
    // printf("Group:st.coneres=%d\n",st.coneres);
    for (i=0;i<g->children.Length();i++) {
	SaveNode(g->GetChild(i));
    };
}
// IndexedFaceSet
void MWSaver::WriteIFS(IndexedFaceSet *ifs) {
    if (st.c3==NULL) return;
    Face *cf=NULL;
    Vertex3d *cv=NULL;
    Mat *currentmat=NULL;
    Mat white=Mat();
    TOCLVertex tv;
    int lastindex=-1,index=-1;
    int i=0,j=0,cpt=0;

    for (i=0;i<ifs->faces.Length();i++,cpt++) {
	cf=ifs->faces.Get(i);
	// printf("poly:%d\n",i);
	MWLMeshPolygonAdd(mwhd,0);
	// Color stuff
	if (st.m==NULL) {
	    WriteMat(&white);
	}
	else {
	    if ((st.mb==NULL) ||
		(st.mb->value==BINDING_OVERALL)||
		(st.mb->value==BINDING_DEFAULT)) {
		WriteMat(st.m->GetMaterial(0));
	    }
	    else if ((st.mb->value==BINDING_PER_FACE)||
		     (st.mb->value==BINDING_PER_PART)) {
		WriteMat(st.m->GetMaterial(i));
	    }
	    else if ((st.mb->value==BINDING_PER_FACE_INDEXED)||
		     (st.mb->value==BINDING_PER_PART_INDEXED)) {
			index=cf->materialIndex.Get(0);
			WriteMat(st.m->GetMaterial(index));
	    };

	    // Drawing
	    for (j=0;j<cf->coordIndex.Length();j++) {
		cv=st.c3->GetPoint(cf->coordIndex.Get(j));
		// Effective draw of the vertex
		if (st.mb) {
		   if (st.mb->value==BINDING_PER_VERTEX) {
		       WriteMat(st.m->GetMaterial(cf->coordIndex.Get(j)));
		   }
		   else if (st.mb->value==BINDING_PER_VERTEX_INDEXED) {
		       WriteMat(st.m->GetMaterial(cf->materialIndex.Get(j)));
		   };
		};
		tv.x=cv->coord[0];tv.y=cv->coord[1];tv.z=cv->coord[2];
		MWLMeshPolygonVertexAdd(mwhd,&tv);
	    };
	};
    };
    // puts("<IndexedFaceSet GL");
}
/*
// IndexedLineSet
void MWSaver::WriteILS(IndexedLineSet *ils, int tab) {
    if (st.c3==NULL) return;
    Face *cf;
    Vertex3d *cv;
    int lastindex=-1,index=-1;
    int i=0,j=0,cpt=0;

    WriteTabs(tab);
    if (strcmp(ils->GetName(),"NONE")) {
	    fprintf(f,"// %s (IndexedLineSet)m\n",ils->GetName());
    }
    else {
	fprintf(f,"// IndexedLineSet\n");
    };
    for (i=0;i<ils->faces.Length();i++,cpt++) {
	cf=ils->faces.Get(i);
	WriteTabs(tab);
	fprintf(f,"glBegin(GL_LINES);\n");
	    // Color stuff
	    if (st.m==NULL) {
		Mat white=Mat();
		WriteMat(&white,tab);
	    }
	    else {
		if ((st.mb==NULL) ||
		    (st.mb->value==BINDING_OVERALL)||
		    (st.mb->value==BINDING_DEFAULT)) {
		    WriteMat(st.m->GetMaterial(0),tab);
		}
		else if ((st.mb->value==BINDING_PER_FACE)||
			 (st.mb->value==BINDING_PER_PART)) {
			WriteMat(st.m->GetMaterial(i),tab);
		}
		else if ((st.mb->value==BINDING_PER_FACE_INDEXED)||
			 (st.mb->value==BINDING_PER_PART_INDEXED)) {
			index=cf->materialIndex.Get(0);
			if (index!=lastindex) {
				WriteMat(st.m->GetMaterial(index),tab);
				lastindex=index;
			};
		};
	    };
	    // Normal stuff
	    if (st.n==NULL) {
		Vertex3d *point1=st.c3->GetPoint(cf->coordIndex.Get(0));
		Vertex3d *point2=st.c3->GetPoint(cf->coordIndex.Get(1));
		Vertex3d *point3=st.c3->GetPoint(cf->coordIndex.Get(2));
		Vertex3d vec1=Vertex3d(point2->coord[0]-point1->coord[0],
				     point2->coord[1]-point1->coord[1],
				     point2->coord[2]-point1->coord[2]);
		Vertex3d vec2=Vertex3d(point3->coord[0]-point1->coord[0],
				     point3->coord[1]-point1->coord[1],
				     point3->coord[2]-point1->coord[2]);
		WriteTabs(tab+1);
		fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
			   vec1.coord[1]*vec2.coord[2]-vec1.coord[2]*vec2.coord[1],
			   vec1.coord[2]*vec2.coord[0]-vec1.coord[0]*vec2.coord[2],
			   vec1.coord[0]*vec2.coord[1]-vec1.coord[1]*vec2.coord[0]);
	    }
	    else {
		if ((st.nb==NULL)||
		    (st.nb->value==BINDING_OVERALL)) {
		    WriteTabs(tab+1);
		    Vertex3d *ver=st.n->GetVector(0);
		    fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
				ver->coord[0],ver->coord[1],ver->coord[2]);
		}
		else if ((st.nb->value==BINDING_PER_FACE)||
			 (st.nb->value==BINDING_PER_PART)) {
		    WriteTabs(tab+1);
		    Vertex3d *ver=st.n->GetVector(i);
		    fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
				ver->coord[0],ver->coord[1],ver->coord[2]);    
		}
		else if ((st.nb->value==BINDING_PER_FACE_INDEXED)||
			 (st.nb->value==BINDING_PER_PART_INDEXED)) {
		    index=cf->normalIndex.Get(0);
		    WriteTabs(tab+1);
		    Vertex3d *ver=st.n->GetVector(index);
		    fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
				ver->coord[0],ver->coord[1],ver->coord[2]);    
		};
	    };
	    // Drawing
	    for (j=0;j<cf->coordIndex.Length();j++) {
		cv=st.c3->GetPoint(cf->coordIndex.Get(j));
		// Effective draw of the vertex
		if (st.mb) {
		   if (st.mb->value==BINDING_PER_VERTEX) {
		       WriteMat(st.m->GetMaterial(cf->coordIndex.Get(j)),tab);
		   }
		   else if (st.mb->value==BINDING_PER_VERTEX_INDEXED) {
		       WriteMat(st.m->GetMaterial(cf->materialIndex.Get(j)),tab);
		   };
		};
		if (st.nb) {
		   if (st.nb->value==BINDING_PER_VERTEX) {
		       Vertex3d *ver=st.n->GetVector(cf->coordIndex.Get(j));
		       WriteTabs(tab+1);
		       fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
			       ver->coord[0],ver->coord[1],ver->coord[2]);
		   }
		   else if ((st.nb->value==BINDING_PER_VERTEX_INDEXED)||
			    (st.nb->value==BINDING_DEFAULT)) {
		       Vertex3d *ver=st.n->GetVector(cf->normalIndex.Get(j));
		       WriteTabs(tab+1);
		       fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
			       ver->coord[0],ver->coord[1],ver->coord[2]);
		   };
		};
		WriteTabs(tab+1);
		fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",
			cv->coord[0],cv->coord[1],cv->coord[2]);
	    };
	WriteTabs(tab);
	fprintf(f,"glEnd();\n");
    };
    // puts("<IndexedFaceSet GL");
}
*/
// Info
// void MWSaver::WriteInfo(VInfo *in, int tab) {
    // WriteTabs(tab);
    // fprintf(f,"/*\n");
    // WriteTabs(tab);
    // fprintf(f,"%s\n",in->GetString());
    // WriteTabs(tab);
    // fprintf(f,"*/\n");
// }
// LOD
void MWSaver::WriteLOD(LOD *l) {
    VRMLState *state=new VRMLState();
    TOCLVertex tv,rv,sv;

    *(state) = st;
    MWLMeshTranslationGet(mwhd,&tv);
    MWLMeshRotationGet(mwhd,&rv);
    MWLMeshScaleGet(mwhd,&sv);
    SaveNode(l->children.Get(0));
    MWLMeshTranslationChange(mwhd,&tv,CTMSET);
    MWLMeshRotationChange(mwhd,&rv,CTMSET);
    MWLMeshScaleChange(mwhd,&sv,CTMSET);
    st = *(state);
    delete state;
}
// Material
void MWSaver::WriteMaterial(Material *mat) {
    st.m=mat;
}
// MaterialBinding
void MWSaver::WriteMaterialBinding(MaterialBinding *mb) {
    st.mb=mb;
}
/*
// MatrixTranform
void MWSaver::WriteMatrixTransform(MatrixTransform *mt) {
    float *matrix=mt->matrix;

    WriteTabs(tab);
    if (strcmp(mt->GetName(),"NONE")) {
	fprintf(f,"// %s (MatrixTransform)\n",mt->GetName());
    }
    else {
	fprintf(f,"// MatrixTransform\n");
    };
    WriteTabs(tab);
    fprintf(f,"{\n");
    WriteTabs(tab);
    fprintf(f,"float matrix[16]={%.4f,%.4f,%.4f,%.4f,\n",matrix[0],matrix[1],matrix[2],matrix[3]);
    WriteTabs(tab);
    fprintf(f,"                  %.4f,%.4f,%.4f,%.4f,\n",matrix[4],matrix[5],matrix[6],matrix[7]);
    WriteTabs(tab);
    fprintf(f,"                  %.4f,%.4f,%.4f,%.4f,\n",matrix[8],matrix[9],matrix[10],matrix[11]);
    WriteTabs(tab);
    fprintf(f,"                  %.4f,%.4f,%.4f,%.4f};\n",matrix[12],matrix[13],matrix[14],matrix[15]);
    WriteTabs(tab);
    fprintf(f,"glMultMatrixf(matrix);\n");
    WriteTabs(tab);
    fprintf(f,"};\n");
}
*/
/*
// Normal
void MWSaver::WriteNormal(Normal *n, int tab) {
    st.n=n;
}
// NormalBinding
void MWSaver::WriteNormalBinding(NormalBinding *nb, int tab) {
    st.nb=nb;
}
*/
// OrthographicCamera
/*
void MWSaver::WriteOC(OrthographicCamera *oc, int tab) {
}
// PerspectiveCamera
void MWSaver::WritePC(PerspectiveCamera *pc, int tab) {
}
*/
/*
// PointLight
void MWSaver::WritePointLight(PointLight *pl, int tab) {
    char LightNum[10];
    switch (st.lightsource) {
	case 0:strcpy(LightNum,"GL_LIGHT0");break;
	case 1:strcpy(LightNum,"GL_LIGHT1");break;
	case 2:strcpy(LightNum,"GL_LIGHT2");break;
	case 3:strcpy(LightNum,"GL_LIGHT3");break;
	default  :strcpy(LightNum,"GL_LIGHT4");break;
    };

    WriteTabs(tab);
    if (strcmp(pl->GetName(),"NONE")) {
	fprintf(f,"// %s (PointLight)\n",pl->GetName());
    }
    else {
	fprintf(f,"// PointLight\n");
    };

    if (pl->on==TRUE) {
	WriteTabs(tab);
	fprintf(f,"glEnable(%s);\n",LightNum);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_POSITION, %.4f, %.4f, %.4f, %.4f);\n",
		   LightNum,
		   pl->point.coord[0],pl->point.coord[1],pl->point.coord[2],pl->point.coord[3]);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_DIFFUSE, %.2f, %.2f, %.2f, %.2f);\n",
		   LightNum,
		   pl->color.rgb[0],pl->color.rgb[1],pl->color.rgb[2],pl->color.rgb[3]);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_AMBIENT, %.2f, %.2f, %.2f, 1.0);\n",
		   LightNum,
		   pl->intensity,pl->intensity,pl->intensity);
	st.lightsource++;
   };
}
*/
/*
// PointSet
void MWSaver::WritePointSet(PointSet *ps, int tab) {
    int max=0;
    if (ps->numPoints==-1) {max=st.c3->Size();}
    else {max=ps->startIndex+ps->numPoints;};

    WriteTabs(tab);
    if (strcmp(ps->GetName(),"NONE")) {
	fprintf(f,"// %s (PointSet)\n",ps->GetName());
    }
    else {
	fprintf(f,"// PointSet\n");
    };

    WriteTabs(tab);
    fprintf(f,"glBegin(GL_POINTS);\n");
    for (int i=ps->startIndex;i<max;i++) {
	if (st.m==NULL) {
		Mat white=Mat();
		WriteMat(&white,tab+1);
	}
	else {
	   if ((st.mb==NULL)||
	       (st.mb->value==BINDING_DEFAULT)||
	       (st.mb->value==BINDING_OVERALL)) {
	       WriteMat(st.m->GetMaterial(0),tab+1);
	   }
	   else if ((st.mb->value==BINDING_PER_PART)||
		    (st.mb->value==BINDING_PER_FACE)||
		    (st.mb->value==BINDING_PER_VERTEX)) {
		    WriteMat(st.m->GetMaterial(i),tab+1);
	   };
	};
	WriteTabs(tab+1);
	if (st.n==NULL) {
	   WriteTabs(tab+1);
	   fprintf(f,"glNormal3d(0,0,-1);\n");
	}
	else {
	   if ((st.nb==NULL)||
	       (st.nb->value==BINDING_DEFAULT)||
	       (st.nb->value==BINDING_PER_PART)||
	       (st.nb->value==BINDING_PER_FACE)||
	       (st.nb->value==BINDING_PER_VERTEX)) {
	       fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
			st.n->GetVector(i)->coord[0],
			st.n->GetVector(i)->coord[1],
			st.n->GetVector(i)->coord[2]);
	   }
	   else if (st.nb->value==BINDING_OVERALL) {
		fprintf(f,"glNormal3d(%.4f,%.4f,%.4f);\n",
			  st.n->GetVector(0)->coord[0],
			  st.n->GetVector(0)->coord[1],
			  st.n->GetVector(0)->coord[2]);
	   };
	};
	WriteTabs(tab+1);
	fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",
		   st.c3->GetPoint(i)->coord[0],
		   st.c3->GetPoint(i)->coord[1],
		   st.c3->GetPoint(i)->coord[2]);
    };
    WriteTabs(tab);
    fprintf(f,"glEnd();\n");   
}
*/
// Rotation
void MWSaver::WriteRotation(Rotation *r) {
    double x,y,z,a,c,d;
    float ctm[16],dz=0,dx=0,dy=0,anglex=0,angley=0,anglez=0;
    TOCLVertex tv,p1,p2;

    r->rotation.Get(x,y,z,a);
    /*
    glMatrixMode (GL_MODELVIEW);
    glPushMatrix();
    glLoadIdentity();
    glRotated((a*180.0)/3.1415,x,y,z);
    glGetFloatv(GL_MODELVIEW_MATRIX,ctm);

    printf("%f %f %f %f\n",ctm[0],ctm[1],ctm[2],ctm[3]);
    printf("%f %f %f %f\n",ctm[4],ctm[5],ctm[6],ctm[7]);
    printf("%f %f %f %f\n",ctm[8],ctm[9],ctm[10],ctm[11]);
    printf("%f %f %f %f\n",ctm[12],ctm[13],ctm[14],ctm[15]);
    if ((x==y)&&(y==z)) {
	p1.x=1.0;p1.y=0.5;p1.z=0.5;
    }
    else {
	p1.x=1.0;p1.y=1.0;p1.z=1.0;
    };
    p2.x=ctm[0]*p1.x + ctm[1]*p1.y + ctm[2]*p1.z;
    p2.y=ctm[4]*p1.x + ctm[5]*p1.y + ctm[6]*p1.z;
    p2.z=ctm[8]*p1.x + ctm[9]*p1.y + ctm[10]*p1.z;

    printf("p1: %f %f %f\n",p1.x,p1.y,p1.z);
    printf("p2: %f %f %f\n",p2.x,p2.y,p2.z);
    dx=p1.x-p2.x;
    dy=p1.y-p2.y;
    dz=p1.z-p2.z;
    anglex=atan(dy/dz);
    angley=atan(dz/dx);
    anglez=atan(dy/dx);
    printf("anglex:%f\n",(anglex*180.0)/3.1415);
    printf("angley:%f\n",(angley*180.0)/3.1415);
    printf("anglez:%f\n",(anglez*180.0)/3.1415);
    */
    // tv.x=0.0;tv.y=3.1415/4.0;tv.z=0.0;
    // MWLMeshRotationChange(mwhd,&tv,CTMADD);
    tv.x=3.1415/2.0;tv.y=0;tv.z=0.0;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    tv.x=0;tv.y=0;tv.z=3.1415/4.0;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    tv.x=-3.1415/2.0;tv.y=0.0;tv.z=0.0;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    /*
    c= sqrt((y*y)+(z*z));
    if (c!=0) {
	anglex= asin(y/c);
    }
    else {
	anglex=0.0;
    };
    printf("anglex:%f\n",(anglex*180.0)/3.1415);
    tv.x= (float) anglex;tv.y=0.0;tv.z=0.0;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    d= sqrt((x*x)+(c*c));
    if (d!=0) {
	angley= asin(x/d);
    }
    else {
	angley=0.0;
    };
    printf("angley:%f\n",(angley*180.0)/3.1415);
    tv.x=0.0;tv.y= (float) angley;tv.z=0.0;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    tv.x=0.0;tv.y=0.0;tv.z= (float) a;
    printf("tv.x:%f y:%f z:%f\n",tv.x,tv.y,tv.z);
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    tv.x=0.0;tv.y= (float) -angley;tv.z=0.0;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    tv.x= (float) -anglex;tv.y=0.0;tv.z=0.0;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);
    */
    // glPopMatrix();
}
// Scale
void MWSaver::WriteScale(Scale *s) {
    double x,y,z;
    TOCLVertex tv;

    s->scaleFactor.Get(x,y,z);
    tv.x=(float) x;tv.y=(float) y;tv.z=(float) z;
    MWLMeshScaleChange(mwhd,&tv,CTMADD);

}
// Separator
void MWSaver::WriteSeparator(Separator *s) {
    VRMLState *state=new VRMLState();
    TOCLVertex tv,rv,sv;

    puts("Separator");
    MWLMeshTranslationGet(mwhd,&tv);
    MWLMeshRotationGet(mwhd,&rv);
    MWLMeshScaleGet(mwhd,&sv);
    *(state) = st;
    for (int i=0;i<s->Size();i++) {
	SaveNode(s->GetChild(i));
    };
    MWLMeshTranslationChange(mwhd,&tv,CTMSET);
    MWLMeshRotationChange(mwhd,&rv,CTMSET);
    MWLMeshScaleChange(mwhd,&sv,CTMSET);
    st = *(state);
    delete state;
}
/*
// ShapeHints
void MWSaver::WriteShapeHints(ShapeHints *sh, int tab) {
    if (st) st.currentnode++;
    if (vertexOrdering==CLOCKWISE) {
	glFrontFace(GL_CW);
    }
    else {
	glFrontFace(GL_CCW);
    };
    if (shapeType==SOLID) {
	glCullFace(GL_FRONT);
	glEnable(GL_CULL_FACE);
    }
    else {
	glDisable(GL_CULL_FACE);
    };
}
*/
// Sphere
void MWSaver::WriteSphere(Sphere *s) {
    Mat *cm=NULL,*white=NULL;
    int i,j;
    double phi=(2*3.1415)/st.sphereres;    // Vertical
    double teta=(2*3.1415)/st.sphereres;   // Horizontal
    double tteta=0,tphi=0;
    double costeta=0,sinphi=0,cosphi=0,sinteta=0;
    double radius=s->radius;
    Vertex3d p1=Vertex3d();
    Vertex3d p2=Vertex3d();
    Vertex3d p3=Vertex3d();
    Vertex3d p4=Vertex3d();
    TOCLVertex tv;

    if (st.m==NULL) {
	white=new Mat();
	cm=white;
    }
    else {
	cm=st.m->GetMaterial(0);
    };


    WriteMat(cm);
    for (i=0;i<st.sphereres;i++) {
	for (j=0;j<st.sphereres;j++) {
	    costeta=cos(tteta);
	    sinphi=sin(tphi);
	    cosphi=cos(tphi);
	    sinteta=sin(tteta);

	    MWLMeshPolygonAdd(mwhd,0);
	    WriteMat(cm);
	    p1.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    tv.x= (float) p1.coord[0];tv.y= (float) p1.coord[1];tv.z= (float) p1.coord[2];
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    tteta+=teta;
	    sinteta=sin(tteta);
	    costeta=cos(tteta);
	    p2.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    tv.x= (float) p2.coord[0];tv.y= (float) p2.coord[1];tv.z= (float) p2.coord[2];
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    tphi+=phi;
	    cosphi=cos(tphi);
	    sinphi=sin(tphi);
	    p3.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    tv.x= (float) p3.coord[0];tv.y= (float) p3.coord[1];tv.z= (float) p3.coord[2];
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    tteta-=teta;
	    sinteta=sin(tteta);
	    costeta=cos(tteta);
	    p4.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    tv.x= (float) p4.coord[0];tv.y= (float) p4.coord[1];tv.z= (float) p4.coord[2];
	    MWLMeshPolygonVertexAdd(mwhd,&tv);
	    tteta+=teta;
	    tphi-=phi;
	};
	tphi+=phi;
	tteta=0;
    };
    if (white) delete white;
}
/*
// SpotLight
void MWSaver::WriteSpotLight(SpotLight *sl, int tab) {
    char LightNum[10];
    switch (st.lightsource) {
	case 0:strcpy(LightNum,"GL_LIGHT0");break;
	case 1:strcpy(LightNum,"GL_LIGHT1");break;
	case 2:strcpy(LightNum,"GL_LIGHT2");break;
	case 3:strcpy(LightNum,"GL_LIGHT3");break;
	default  :strcpy(LightNum,"GL_LIGHT4");break;
    };

    WriteTabs(tab);
    if (strcmp(sl->GetName(),"NONE")) {
	fprintf(f,"// %s (SpotLight)\n",sl->GetName());
    }
    else {
	fprintf(f,"// SpotLight\n");
    };

    if (sl->on==TRUE) {
	WriteTabs(tab);
	fprintf(f,"glEnable(%s);\n",LightNum);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_POSITION, %.4f, %.4f, %.4f, %.4f);\n",
		   LightNum,
		   sl->point.coord[0],sl->point.coord[1],sl->point.coord[2],sl->point.coord[3]);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_DIFFUSE, %.2f, %.2f, %.2f, %.2f);\n",
		   LightNum,
		   sl->color.rgb[0],sl->color.rgb[1],sl->color.rgb[2],sl->color.rgb[3]);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_AMBIENT, %.2f, %.2f, %.2f, 1.0);\n",
		   LightNum,
		   sl->intensity,sl->intensity,sl->intensity);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_SPOT_DIRECTION, %.4f, %.4f, %.4f);\n",
		   LightNum,
		   sl->direction.coord[0],sl->direction.coord[1],sl->direction.coord[2]);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_SPOT_CUTOFF, %.4f);\n",
		   LightNum,(360*sl->cutOffAngle)/2*3.14);
	WriteTabs(tab);
	fprintf(f,"glLightf(%s, GL_SPOT_EXPONENT, %.4f);\n",
		   LightNum,sl->dropOffRate);

	st.lightsource++;
   };
}
*/
// Switch
void MWSaver::WriteSwitch(Switch *sw) {
    if (sw->whichChild!=-1) {
	SaveNode(sw->GetChild(sw->whichChild));
    }
    else {
	SaveNode(sw->GetChild(0));
    };
}
/*
// Texture2
void MWSaver::WriteTexture2(Texture2 *t, int tab) {
    int cpt=0,i=0;

    if (sp->GenTex) {
	WriteTabs(tab);
	if (strcmp(t->GetName(),"NONE")) {
	    fprintf(f,"// %s (Texture2) %width:%d height:%d component:%d\n",t->GetName(),t->width,t->height,t->component);
	}
	else {
	    fprintf(f,"// Texture2 width:%d height:%d component:%d\n",t->width,t->height,t->component);
	};
    
	if (t->image) {
	    UBYTE *cimage=t->image;

	    WriteTabs(tab);
	    fprintf(f,"GLubyte image[]={\n");
	    WriteTabs(tab);
	    for (i=0;i<t->height*t->width*t->component;i++) {
		fprintf(f,"%d ", *(cimage));
		cimage++;cpt++;
		if (i<(t->height*t->width*t->component)-1) {
		    fprintf(f,",");
		};
		if (cpt>=12) {
		    fprintf(f,"\n");
		    cpt=0;
		    WriteTabs(tab);
		};
	    };
	    fprintf(f,"};\n");

	    WriteTabs(tab);
	    fprintf(f,"glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,");
	    if (t->wrapS==TEXTURE2_WRAP_REPEAT) {
		fprintf(f,"GL_REPEAT);\n");
	    }
	    else {
		fprintf(f,"GL_CLAMP);\n");
	    };
	    WriteTabs(tab);
	    fprintf(f,"glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,");
	    if (t->wrapT==TEXTURE2_WRAP_REPEAT) {
		fprintf(f,"GL_REPEAT);\n");
	    }
	    else {
		fprintf(f,"GL_CLAMP);\n");
	    };
	    WriteTabs(tab);
	    fprintf(f,"glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);\n");
	    WriteTabs(tab);
	    fprintf(f,"glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);\n");
	    WriteTabs(tab);
	    fprintf(f,"glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,%d,%d,0,GL_RGB,GL_UNSIGNED_BYTE,image);\n",t->width,t->height);
	};
    };
}
*/
/*
// Texture2Transform
void MWSaver::WriteTexture2Transform(Texture2Transform *tt, int tab) {
}
// TextureCoordinate2
void MWSaver::WriteTextureCoordinate2(TextureCoordinate2 *tc, int tab) {
    st.tc2=tc;
}
*/
// Transform
void MWSaver::WriteTransform(Transform *t) {
    double tx,ty,tz,rx,ry,rz,ra,sx,sy,sz,sox,soy,soz,soa,cx,cy,cz,c,d;
    TOCLVertex tv;

    t->translation.Get(tx,ty,tz);
    t->rotation.Get(rx,ry,rz,ra);
    t->scaleFactor.Get(sx,sy,sz);
    t->scaleOrientation.Get(sox,soy,soz,soa);
    t->center.Get(cx,cy,cz);

    tv.x= (float) tx;tv.y= (float) ty;tv.z= (float) tz;
    MWLMeshTranslationChange(mwhd,&tv,CTMADD);

    tv.x= (float) cx;tv.y= (float) cy;tv.z= (float) cz;
    MWLMeshTranslationChange(mwhd,&tv,CTMADD);

    c= sqrt((ry*ry)+(rz*rz));
    tv.x= (float) asin(ry/c);
    d= sqrt((rx*rx)+(c*c));
    tv.y= (float) asin(rx/d);
    tv.z= (float) ra;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);

    c= sqrt((soy*soy)+(soz*soz));
    tv.x= (float) asin(soy/c);
    d= sqrt((sox*sox)+(c*c));
    tv.y= (float) asin(sox/d);
    tv.z= (float) soa;
    MWLMeshRotationChange(mwhd,&tv,CTMADD);

    tv.x= (float) sx;tv.y= (float) sy;tv.z= (float) sz;
    MWLMeshScaleChange(mwhd,&tv,CTMMUL);

    c= sqrt((soy*soy)+(soz*soz));
    tv.x= (float) asin(soy/c);
    d= sqrt((sox*sox)+(c*c));
    tv.y= (float) asin(sox/d);
    tv.z= (float) soa;
    MWLMeshRotationChange(mwhd,&tv,CTMSUB);
    // fprintf(f,"glRotated(%.4f,%.4f,%.4f,%.4f);\n",-soa/0.017447,sox,soy,soz);

    tv.x= (float) cx;tv.y= (float) cy;tv.z= (float) cz;
    MWLMeshTranslationChange(mwhd,&tv,CTMSUB);
    // fprintf(f,"glTranslated(%.4f,%.4f,%.4f);\n",-cx,-cy,-cz);
}
// TransformSeparator
void MWSaver::WriteTransformSeparator(TransformSeparator *ts) {
    TOCLVertex tv,rv,sv;

    MWLMeshTranslationGet(mwhd,&tv);
    MWLMeshRotationGet(mwhd,&rv);
    MWLMeshScaleGet(mwhd,&sv);
    for (int i=0;i<ts->Size();i++) {
	SaveNode(ts->GetChild(i));
    };
    MWLMeshTranslationChange(mwhd,&tv,CTMSET);
    MWLMeshRotationChange(mwhd,&rv,CTMSET);
    MWLMeshScaleChange(mwhd,&sv,CTMSET);
}
// Translation
void MWSaver::WriteTranslation(Translation *t) {
    double x,y,z;
    TOCLVertex tv;

    t->translation.Get(x,y,z);
    tv.x=(float) x;tv.y=(float) y;tv.z=(float) z;
    MWLMeshTranslationChange(mwhd,&tv,CTMADD);
}
// WWWAnchor
void MWSaver::WriteWWWAnchor(WWWAnchor *www) {
    VRMLState *state=new VRMLState();
    TOCLVertex tv,rv,sv;

    *(state) = st;
    MWLMeshTranslationGet(mwhd,&tv);
    MWLMeshRotationGet(mwhd,&rv);
    MWLMeshScaleGet(mwhd,&sv);
    for (int i=0;i<www->Size();i++) {
	SaveNode(www->GetChild(i));
    };
    MWLMeshTranslationChange(mwhd,&tv,CTMSET);
    MWLMeshRotationChange(mwhd,&rv,CTMSET);
    MWLMeshScaleChange(mwhd,&sv,CTMSET);
    st = *(state);
    delete state;
}
// WWWInline
void MWSaver::WriteWWWInline(WWWInline *www) {
    if (www->in) SaveNode((VRMLNode *) www);
}

// USE
void MWSaver::WriteUSE(USE *u) {
    if (u->reference!=NULL) {
	SaveNode(u->reference);
    };
};
