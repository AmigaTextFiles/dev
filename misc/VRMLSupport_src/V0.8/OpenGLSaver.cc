/*----------------------------------------------------
  OpenGLSaver.cc
  Version 0.1
  Date: 18 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: All OpenGL source code output
-----------------------------------------------------*/
#include <math.h>
#include <libraries/mui.h>

#include "OpenGLSaver.h"

OpenGLSaver::OpenGLSaver(SaveOpenGLParams *par):
    st() {
    // puts("In OpenGLSaver constructor");
    sp=par;
    st.coneres=sp->coneres;
    st.cylinderres=sp->cylinderres;
    st.sphereres=sp->sphereres;
    f=NULL;
    nb=0;
}
OpenGLSaver::~OpenGLSaver() {
}
void OpenGLSaver::WriteOpenGL(FILE *fd,VRMLNode *n) {
    f=fd;
    VRMLState state=VRMLState();

    n->Browse(&state);
    SetAttrs((Object *) sp->Txt, MUIA_Text_Contents, "Saving OpenGL source code (in C syntax)");
    SetAttrs((Object *) sp->Gauge, MUIA_Gauge_Max,state.totalnodes);
    SetAttrs((Object *) sp->Gauge, MUIA_Gauge_Current,0);
    SetAttrs((Object *) sp->Win, MUIA_Window_Open, TRUE);
    SaveNode(n,0);
    SetAttrs((Object *) sp->Win, MUIA_Window_Open, FALSE);
}
void OpenGLSaver::SaveNode(VRMLNode *n,int tab) {
    switch (n->ID) {
	case ASCIITEXT_1:WriteAsciiText((AsciiText *) n,tab);break;
	case CONE_1:WriteCone((Cone *) n, tab);break;
	case COORDINATE3_1:WriteCoordinate3((Coordinate3 *) n, tab);break;
	case CUBE_1:WriteCube((Cube *) n, tab);break;
	case CYLINDER_1:WriteCylinder((Cylinder *) n, tab);break;
	case DIRECTIONALLIGHT_1:WriteDirectionalLight((DirectionalLight *)n, tab);break;
	case FONTSTYLE_1:WriteFontStyle((FontStyle *) n, tab);break;
	case GROUP_1:WriteGroup((Group *) n, tab);break;
	case INDEXEDFACESET_1:WriteIFS((IndexedFaceSet *) n, tab);break;
	case INDEXEDLINESET_1:WriteILS((IndexedLineSet *) n, tab);break;
	case INFO_1:WriteInfo((VInfo *) n, tab);break;
	case LOD_1:WriteLOD((LOD *) n, tab);break;
	case MATERIAL_1:WriteMaterial((Material *) n, tab);break;
	case MATERIALBINDING_1:WriteMaterialBinding((MaterialBinding *) n, tab);break;
	case MATRIXTRANSFORM_1:WriteMatrixTransform((MatrixTransform *) n, tab);break;
	case NORMAL_1:WriteNormal((Normal *) n, tab);break;
	case NORMALBINDING_1:WriteNormalBinding((NormalBinding *) n, tab);break;
	case ORTHOGRAPHICCAMERA_1:WriteOC((OrthographicCamera *) n, tab);break;
	case PERSPECTIVECAMERA_1:WritePC((PerspectiveCamera *) n, tab);break;
	case POINTLIGHT_1:WritePointLight((PointLight *) n, tab);break;
	case POINTSET_1:WritePointSet((PointSet *) n, tab);break;
	case ROTATION_1:WriteRotation((Rotation *) n, tab);break;
	case SCALE_1:WriteScale((Scale *) n, tab);break;
	case SEPARATOR_1:WriteSeparator((Separator *) n, tab);break;
	case SHAPEHINTS_1:WriteShapeHints((ShapeHints *) n, tab);break;
	case SPHERE_1:WriteSphere((Sphere *) n, tab);break;
	case SPOTLIGHT_1:WriteSpotLight((SpotLight *) n, tab);break;
	case SWITCH_1:WriteSwitch((Switch *) n, tab);break;
	case TEXTURE2_1:WriteTexture2((Texture2 *) n, tab);break;
	case TEXTURE2TRANSFORM_1:WriteTexture2Transform((Texture2Transform *) n, tab);break;
	case TEXTURECOORDINATE2_1:WriteTextureCoordinate2((TextureCoordinate2 *) n, tab);break;
	case TRANSFORM_1:WriteTransform((Transform *) n, tab);break;
	case TRANSFORMSEPARATOR_1:WriteTransformSeparator((TransformSeparator *) n, tab);break;
	case TRANSLATION_1:WriteTranslation((Translation *) n, tab);break;
	case WWWANCHOR_1:WriteWWWAnchor((WWWAnchor *) n, tab);break;
	case WWWINLINE_1:WriteWWWInline((WWWInline *) n, tab);break;
	case USE_1:WriteUSE((USE *) n, tab);break;
    };
    nb++;
    SetAttrs((Object *) sp->Gauge, MUIA_Gauge_Current,nb);
}

void OpenGLSaver::WriteTabs(int t) {
    for (int i=0;i<t;i++) {
	fprintf(f,"\t");
    };
}

/*---------------------
 -       Misc         -
 ----------------------*/
void OpenGLSaver::WriteMat(Mat *mat, int tab) {
    Color4f ambient=mat->ambient;
    Color4f diffuse=mat->diffuse;
    Color4f specular=mat->specular;
    Color4f emissive=mat->emissive;
    WriteTabs(tab);
    fprintf(f,"{\n");
    WriteTabs(tab);
    fprintf(f," GLfloat ambient[]={%.2f,%.2f,%.2f,%.2f};\n",
	    ambient.rgb[0],ambient.rgb[1],ambient.rgb[2],ambient.rgb[3]);
    WriteTabs(tab);
    fprintf(f," GLfloat diffuse[]={%.2f,%.2f,%.2f,%.2f};\n",
	    diffuse.rgb[0],diffuse.rgb[1],diffuse.rgb[2],diffuse.rgb[3]);
    WriteTabs(tab);
    fprintf(f," GLfloat specular[]={%.2f,%.2f,%.2f,%.2f};\n",
	    specular.rgb[0],specular.rgb[1],specular.rgb[2],specular.rgb[3]);
    WriteTabs(tab);
    fprintf(f," GLfloat emissive[]={%.2f,%.2f,%.2f,%.2f};\n",
	    emissive.rgb[0],emissive.rgb[1],emissive.rgb[2],emissive.rgb[3]);
    WriteTabs(tab);
    fprintf(f," glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,ambient);\n");
    WriteTabs(tab);
    fprintf(f," glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,diffuse);\n");
    WriteTabs(tab);
    fprintf(f," glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,specular);\n");
    WriteTabs(tab);
    fprintf(f," glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,emissive);\n");
    WriteTabs(tab);
    fprintf(f," glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,%.2f);\n",mat->shininess);
    WriteTabs(tab);
    fprintf(f,"};\n");
}
/**************
 * VRML Nodes *
 **************/
// AsciiText
void OpenGLSaver::WriteAsciiText(AsciiText *a, int tab) {
}
// Cone
void OpenGLSaver::WriteCone(Cone *c, int tab) {
    double angle=(2*3.1415)/st.coneres;
    double tangle=0;
    double xcos=1,zsin=0,topy=0;
    double oldx=c->bottomRadius,oldz=0,newx=oldx,newz=oldz;
    double halfh=c->height/2;
    int sides=c->parts&SIDES;
    int bottom=c->parts&BOTTOM;
    int i=0;
    Mat *cm[2],*currentmat=NULL;
    Mat *white=NULL;

    // printf("st.coneres=%d\n",st.coneres);
    WriteTabs(tab);
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"// %s (Cone)\n",c->GetName());
    }
    else {
	fprintf(f,"// Cone\n");
    };
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
	WriteMat(cm[0],tab);
	currentmat=cm[0];
	for (i=0;i<st.coneres;i++) {
	    tangle=tangle+angle;
	    newx=cos(tangle)*c->bottomRadius;
	    newz=sin(tangle)*c->bottomRadius;
	    topy=sin(atan(c->bottomRadius/c->height))*c->bottomRadius;

	    WriteTabs(tab);
	    fprintf(f,"glBegin(GL_QUADS);\n");
	    WriteTabs(tab);
	    fprintf(f,"  glNormal3d(%.4f,%.4f,%.4f);\n",oldx,topy,oldz);
	    WriteTabs(tab);
	    fprintf(f,"  glVertex3d(0,%.4f,0);\n",halfh);           // top
	    WriteTabs(tab);
	    fprintf(f,"  glNormal3d(%.4f,%.4f,%.4f);\n",oldx,topy,oldz);
	    WriteTabs(tab);
	    fprintf(f,"  glVertex3d(%.4f,%.4f,%.4f);\n",oldx,-halfh,oldz);
	    WriteTabs(tab);
	    fprintf(f,"  glNormal3d(%.4f,%.4f,%.4f);\n",newx,topy,newz);
	    WriteTabs(tab);
	    fprintf(f,"  glVertex3d(%.4f,%.4f,%.4f);\n",newx,-halfh,newz);
	    WriteTabs(tab);
	    fprintf(f,"  glNormal3d(%.4f,%.4f,%.4f);\n",newx,topy,newz);
	    WriteTabs(tab);
	    fprintf(f,"  glVertex3d(0,%.4f,0);\n",halfh);           // top
	    WriteTabs(tab);
	    fprintf(f,"glEnd();\n");
	    oldx=newx;
	    oldz=newz;
	};
    };

    tangle=2*3.1415;
    newx=c->bottomRadius;newz=0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	if (cm[1]!=currentmat) {
		WriteMat(cm[1],tab);
		currentmat=cm[1];
	};
	WriteTabs(tab);
	fprintf(f,"glBegin(GL_TRIANGLE_FAN);\n");
	WriteTabs(tab);
	fprintf(f,"  glNormal3d(0,%.4f,0);\n",-halfh);
	WriteTabs(tab);
	fprintf(f,"  glVertex3d(0,%.4f,0);\n",-halfh);
	for (i=0;i<st.coneres+1;i++) {
	    WriteTabs(tab);
	    fprintf(f,"  glVertex3d(%.4f,%.4f,%.4f);\n",newx,-halfh,newz);
	    tangle=tangle-angle;
	    newx=cos(tangle)*c->bottomRadius;
	    newz=sin(tangle)*c->bottomRadius;
	};
	WriteTabs(tab);
	fprintf(f,"glEnd();\n");
    };
    if (white) delete white;
    // RefreshGauge(st);
}
// Coordinate3
void OpenGLSaver::WriteCoordinate3(Coordinate3 *c, int tab) {
    st.c3=c;
}
// Cube
void OpenGLSaver::WriteCube(Cube *c, int tab) {
	double w=c->width/2;
	double h=c->height/2;
	double d=c->depth/2;
	float r[6],g[6],b[6];
	int i=0;
	Mat *cm[6],*currentmat=NULL;
	Mat *white=NULL;

	WriteTabs(tab);
	if (strcmp(c->GetName(),"NONE")) {
	    fprintf(f,"// %s (Cube)\n",c->GetName());
	}
	else {
	    fprintf(f,"// Cube\n");    
	};

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

	WriteTabs(tab);
	fprintf(f,"glBegin(GL_QUADS);\n");
	   //          x y z
	   WriteTabs(tab+1);
	   fprintf(f,"glNormal3d (0.0,0.0,-1.0);\n");  // Au fond Second
	   WriteMat(cm[1],tab+1);
	   currentmat=cm[1];
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,-h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,-h,-d);

	   WriteTabs(tab+1);
	   fprintf(f,"glNormal3d (-1.0,0.0,0.0);\n");  // A gauche Third
	   if (currentmat!=cm[2]) {
		WriteMat(cm[2],tab);
		currentmat=cm[2];
	   };
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,-h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,-h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,h,-d);

	   WriteTabs(tab+1);
	   fprintf(f,"glNormal3d (1.0,0.0,0.0);\n");  // A droite Forth
	   if (currentmat!=cm[3]) {
		WriteMat(cm[3],tab);
		currentmat=cm[3];
	   };
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,-h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,-h,d);

	   WriteTabs(tab+1);
	   fprintf(f,"glNormal3d (0.0,0.0,1.0);\n");  // Devant First
	   if (currentmat!=cm[0]) {
		WriteMat(cm[0],tab);
		currentmat=cm[0];
	   };
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,-h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,-h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,h,d);

	   WriteTabs(tab+1);
	   fprintf(f,"glNormal3d (0.0,1.0,0.0);\n"); // Haut Fifth
	   if (currentmat!=cm[4]) {
		WriteMat(cm[4],tab);
		currentmat=cm[4];
	   };
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,h,-d);

	   WriteTabs(tab+1);
	   fprintf(f,"glNormal3d(0.0,-1.0,0.0);\n"); // Bas Sixth
	   if (currentmat!=cm[5]) {
		WriteMat(cm[5],tab);
		currentmat=cm[5];
	   };
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,-h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(0.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,-h,-d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,0.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",w,-h,d);
	   WriteTabs(tab+1);
	   fprintf(f,"glTexCoord2f(1.0,1.0);\n");
	   WriteTabs(tab+1);
	   fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",-w,-h,d);
	WriteTabs(tab);
	fprintf(f,"glEnd();\n");
	if (white) delete white;
}
// Cylinder
void OpenGLSaver::WriteCylinder(Cylinder *c, int tab) {
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

    WriteTabs(tab);
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"// %s (Cylinder)\n",c->GetName());
    }
    else {
	fprintf(f,"// Cylinder\n");
    };

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
	WriteMat(cm[0],tab);
	currentmat=cm[0];
	for (i=0;i<st.cylinderres;i++) {
	    tangle=tangle+angle;
	    newx=cos(tangle)*c->radius;
	    newz=sin(tangle)*c->radius;
	    WriteTabs(tab);
	    fprintf(f,"glBegin(GL_QUADS);\n");
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(%.4f,0,%.4f);\n",oldx,oldz);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",oldx,halfh,oldz);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",oldx,-halfh,oldz);
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(%.4f,0,%.4f);\n",newx,newz);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",newx,-halfh,newz);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",newx,halfh,newz);
	    WriteTabs(tab);
	    fprintf(f,"glEnd();\n");
	    oldx=newx;
	    oldz=newz;
	};
    };

    tangle=0;
    newx=c->radius;newz=0;
    // parts contains TOP
    if (top) {
	// puts("parts contains TOP");
	WriteTabs(tab);
	fprintf(f,"glBegin(GL_TRIANGLE_FAN);\n");
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(0,%.4f,0);\n",halfh);
	    if (currentmat!=cm[1]) {
		WriteMat(cm[1],tab);
		currentmat=cm[1];
	    };
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(0,%.4f,0);\n",halfh);
	    for (i=0;i<st.cylinderres+1;i++) {
		WriteTabs(tab+1);
		fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",newx,halfh,newz);
		tangle=tangle+angle;
		newx=cos(tangle)*c->radius;
		newz=sin(tangle)*c->radius;
	    };
	 WriteTabs(tab);
	 fprintf(f,"glEnd();\n");
    };

    tangle=2*3.1415;
    newx=c->radius;newz=0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	WriteTabs(tab);
	fprintf(f,"glBegin(GL_TRIANGLE_FAN);\n");
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(0,%.4f,0);\n",-halfh);
	    if (currentmat!=cm[2]) {
		WriteMat(cm[2],tab);
		currentmat=cm[2];
	    };
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(0,%.4f,0);\n",-halfh);
	    for (i=0;i<st.cylinderres+1;i++) {
		WriteTabs(tab+1);
		fprintf(f,"glVertex3d(%.4f,%.4f,%.4f);\n",newx,-halfh,newz);
		tangle=tangle-angle;
		newx=cos(tangle)*c->radius;
		newz=sin(tangle)*c->radius;
	    };
	 WriteTabs(tab);
	 fprintf(f,"glEnd();\n");
    };
    if (white) delete white;
}
// DirectionalLight
void OpenGLSaver::WriteDirectionalLight(DirectionalLight *dl, int tab) {
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
// FontStyle
void OpenGLSaver::WriteFontStyle(FontStyle *fs, int tab) {
}
// Group
void OpenGLSaver::WriteGroup(Group *g, int tab) {
    int i=0;
    // printf("Group:st.coneres=%d\n",st.coneres);
    for (i=0;i<g->children.Length();i++) {
	SaveNode(g->GetChild(i),tab+1);
    };
}
// IndexedFaceSet
void OpenGLSaver::WriteIFS(IndexedFaceSet *ifs, int tab) {
    if (st.c3==NULL) return;
    Face *cf;
    Vertex3d *cv;
    Mat *currentmat=NULL;
    Mat white=Mat();
    int lastindex=-1,index=-1;
    int i=0,j=0,cpt=0;

    WriteTabs(tab);
    if (strcmp(ifs->GetName(),"NONE")) {
	    fprintf(f,"// %s (IndexedFaceSet)m\n",ifs->GetName());
    }
    else {
	fprintf(f,"// IndexedFaceSet\n");
    };
    for (i=0;i<ifs->faces.Length();i++,cpt++) {
	cf=ifs->faces.Get(i);
	WriteTabs(tab);
	fprintf(f,"glBegin(GL_POLYGON);\n");
	    // Color stuff
	    if (st.m==NULL) {
		if (currentmat!= &white) {
			WriteMat(&white,tab);
			currentmat=&white;
		};
	    }
	    else {
		if ((st.mb==NULL) ||
		    (st.mb->value==BINDING_OVERALL)||
		    (st.mb->value==BINDING_DEFAULT)) {
		    if (currentmat!=st.m->GetMaterial(0)) {
			WriteMat(st.m->GetMaterial(0),tab);
			currentmat=st.m->GetMaterial(0);
		    };
		}
		else if ((st.mb->value==BINDING_PER_FACE)||
			 (st.mb->value==BINDING_PER_PART)) {
		     if (currentmat!=st.m->GetMaterial(i)) {
			WriteMat(st.m->GetMaterial(i),tab);
			currentmat=st.m->GetMaterial(i);
		     };
		}
		else if ((st.mb->value==BINDING_PER_FACE_INDEXED)||
			 (st.mb->value==BINDING_PER_PART_INDEXED)) {
			index=cf->materialIndex.Get(0);
			if (currentmat!=st.m->GetMaterial(index)) {
				WriteMat(st.m->GetMaterial(index),tab);
				currentmat=st.m->GetMaterial(index);
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

	    // TextureCoordinate2d
	    

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
		if (st.tc2) {
		    Vertex2d *ver=st.tc2->GetPoint(cf->textureCoordIndex.Get(j));
		    WriteTabs(tab+1);
		    fprintf(f,"glTexCoord2d(%.4f,%.4f);\n",ver->coord[0],ver->coord[1]);
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
// IndexedLineSet
void OpenGLSaver::WriteILS(IndexedLineSet *ils, int tab) {
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
// Info
void OpenGLSaver::WriteInfo(VInfo *in, int tab) {
    WriteTabs(tab);
    fprintf(f,"/*\n");
    WriteTabs(tab);
    fprintf(f,"%s\n",in->GetString());
    WriteTabs(tab);
    fprintf(f,"*/\n");
}
// LOD
void OpenGLSaver::WriteLOD(LOD *l, int tab) {
    VRMLState *state=new VRMLState();

    *(state) = st;
    WriteTabs(tab);
    if (strcmp(l->GetName(),"NONE")) {
	fprintf(f,"// %s (LOD)\n",l->GetName());
    }
    else {
	fprintf(f,"// LOD\n");
    };
    WriteTabs(tab);
    fprintf(f,"glPushMatrix();\n");
    SaveNode(l->children.Get(0),tab+1);
    st = *(state);
    WriteTabs(tab);
    fprintf(f,"glPopMatrix();\n");
    delete state;
}
// Material
void OpenGLSaver::WriteMaterial(Material *mat, int tab) {
    st.m=mat;
}
// MaterialBinding
void OpenGLSaver::WriteMaterialBinding(MaterialBinding *mb, int tab) {
    st.mb=mb;
}
// MatrixTranform
void OpenGLSaver::WriteMatrixTransform(MatrixTransform *mt, int tab) {
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
// Normal
void OpenGLSaver::WriteNormal(Normal *n, int tab) {
    st.n=n;
}
// NormalBinding
void OpenGLSaver::WriteNormalBinding(NormalBinding *nb, int tab) {
    st.nb=nb;
}
// OrthographicCamera
void OpenGLSaver::WriteOC(OrthographicCamera *oc, int tab) {
}
// PerspectiveCamera
void OpenGLSaver::WritePC(PerspectiveCamera *pc, int tab) {
}
// PointLight
void OpenGLSaver::WritePointLight(PointLight *pl, int tab) {
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
// PointSet
void OpenGLSaver::WritePointSet(PointSet *ps, int tab) {
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
// Rotation
void OpenGLSaver::WriteRotation(Rotation *r, int tab) {
    double x,y,z,a;
    r->rotation.Get(x,y,z,a);
    WriteTabs(tab);
    if (strcmp(r->GetName(),"NONE")) {
	fprintf(f,"// %s (Rotation)\n",r->GetName());
    }
    else {
	fprintf(f,"// Rotation\n");
    };

    WriteTabs(tab);
    fprintf(f,"glRotated(%.4f,%.4f,%.4f,%.4f);\n",a/0.017447,x,y,z);
}
// Scale
void OpenGLSaver::WriteScale(Scale *s, int tab) {
    double x,y,z;
    s->scaleFactor.Get(x,y,z);
    WriteTabs(tab);
    if (strcmp(s->GetName(),"NONE")) {
	fprintf(f,"// %s (Scale)\n",s->GetName());
    }
    else {
	fprintf(f,"// Scale\n");
    };
    WriteTabs(tab);
    fprintf(f,"glScaled(%.4f,%.4f,%.4f);\n",x,y,z);
}
// Separator
void OpenGLSaver::WriteSeparator(Separator *s, int tab) {
    VRMLState *state=new VRMLState();

    WriteTabs(tab);
    if (strcmp(s->GetName(),"NONE")) {
	fprintf(f,"// %s (Separator)\n",s->GetName());
    }
    else {
	fprintf(f,"// Separator\n");
    };
    WriteTabs(tab);
    fprintf(f,"glPushMatrix();\n"); // Push the current position
    
    *(state) = st;
    for (int i=0;i<s->Size();i++) {
	SaveNode(s->GetChild(i),tab+1);
    };
    WriteTabs(tab);
    fprintf(f,"glPopMatrix();\n");
    st = *(state);
    delete state;
}
// ShapeHints
void OpenGLSaver::WriteShapeHints(ShapeHints *sh, int tab) {
    /*
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
    */
}
// Sphere
void OpenGLSaver::WriteSphere(Sphere *s, int tab) {
    Mat *cm;
    Mat *white=NULL;
    int i,j;
    double phi=(2*3.1415)/st.sphereres;    // Vertical
    double teta=(2*3.1415)/st.sphereres;   // Horizontal
    double tteta=0,tphi=0;
    double costeta=0,sinphi=0,cosphi=0,sinteta=0;
    double radius=s->radius;
    #ifdef __GNUC__
    Vertex3d p1=Vertex3d();
    Vertex3d p2=Vertex3d();
    Vertex3d p3=Vertex3d();
    Vertex3d p4=Vertex3d();
    #else
    Vertex3d p1(),p2(),p3(),p4();
    #endif

    WriteTabs(tab);
    if (strcmp(s->GetName(),"NONE")) {
	fprintf(f,"// %s (Sphere)\n",s->GetName());
    }
    else {
	fprintf(f,"// Sphere\n");
    };

    if (st.m==NULL) {
	white=new Mat();
	cm=white;
    }
    else {
	cm=st.m->GetMaterial(0);
    };

    WriteMat(cm,tab);
    for (i=0;i<st.sphereres;i++) {
	for (j=0;j<st.sphereres;j++) {
	    costeta=cos(tteta);
	    sinphi=sin(tphi);
	    cosphi=cos(tphi);
	    sinteta=sin(tteta);


	    WriteTabs(tab);
	    fprintf(f,"glBegin(GL_QUADS);\n");
	    p1.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(%f,%f,%f);\n",p1.coord[0],p1.coord[1],p1.coord[2]);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%f,%f,%f);\n",p1.coord[0],p1.coord[1],p1.coord[2]);
	    tteta+=teta;
	    sinteta=sin(tteta);
	    costeta=cos(tteta);
	    p2.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(%f,%f,%f);\n",p2.coord[0],p2.coord[1],p2.coord[2]);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%f,%f,%f);\n",p2.coord[0],p2.coord[1],p2.coord[2]);
	    tphi+=phi;
	    cosphi=cos(tphi);
	    sinphi=sin(tphi);
	    p3.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(%f,%f,%f);\n",p3.coord[0],p3.coord[1],p3.coord[2]);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%f,%f,%f);\n",p3.coord[0],p3.coord[1],p3.coord[2]);
	    tteta-=teta;
	    sinteta=sin(tteta);
	    costeta=cos(tteta);
	    p4.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    WriteTabs(tab+1);
	    fprintf(f,"glNormal3d(%f,%f,%f);\n",p4.coord[0],p4.coord[1],p4.coord[2]);
	    WriteTabs(tab+1);
	    fprintf(f,"glVertex3d(%f,%f,%f);\n",p4.coord[0],p4.coord[1],p4.coord[2]);
	    WriteTabs(tab);
	    fprintf(f,"glEnd();\n");
	    tteta+=teta;
	    tphi-=phi;
	};
	tphi+=phi;
	tteta=0;
    };
    if (white) delete white;
}
// SpotLight
void OpenGLSaver::WriteSpotLight(SpotLight *sl, int tab) {
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
// Switch
void OpenGLSaver::WriteSwitch(Switch *sw, int tab) {
    WriteTabs(tab);
    if (strcmp(sw->GetName(),"NONE")) {
	fprintf(f,"// %s (Switch)\n",sw->GetName());
    }
    else {
	fprintf(f,"// Switch\n");
    };
    if (sw->whichChild!=-1) {
	SaveNode(sw->GetChild(sw->whichChild),tab+1);
    };
}
// Texture2
void OpenGLSaver::WriteTexture2(Texture2 *t, int tab) {
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
// Texture2Transform
void OpenGLSaver::WriteTexture2Transform(Texture2Transform *tt, int tab) {
}
// TextureCoordinate2
void OpenGLSaver::WriteTextureCoordinate2(TextureCoordinate2 *tc, int tab) {
    st.tc2=tc;
}
// Transform
void OpenGLSaver::WriteTransform(Transform *t, int tab) {
     double tx,ty,tz,rx,ry,rz,ra,sx,sy,sz,sox,soy,soz,soa,cx,cy,cz;
     WriteTabs(tab);
     if (strcmp(t->GetName(),"NONE")) {
	    fprintf(f,"// %s (Transform)\n",t->GetName());
     }
     else {
	fprintf(f,"// Transform\n");
     };
     t->translation.Get(tx,ty,tz);
     t->rotation.Get(rx,ry,rz,ra);
     t->scaleFactor.Get(sx,sy,sz);
     t->scaleOrientation.Get(sox,soy,soz,soa);
     t->center.Get(cx,cy,cz);
     WriteTabs(tab);
     fprintf(f,"glTranslated(%.4f,%.4f,%.4f);\n",tx,ty,tz);
     WriteTabs(tab);
     fprintf(f,"glTranslated(%.4f,%.4f,%.4f);\n",cx,cy,cz);
     WriteTabs(tab);
     fprintf(f,"glRotated(%.4f,%.4f,%.4f,%.4f);\n",ra/0.017557,rx,ry,rz);
     WriteTabs(tab);
     fprintf(f,"glRotated(%.4f,%.4f,%.4f,%.4f);\n",soa/0.017447,sox,soy,soz);
     WriteTabs(tab);
     fprintf(f,"glScaled(%.4f,%.4f,%.4f);\n",sx,sy,sz);
     WriteTabs(tab);
     fprintf(f,"glRotated(%.4f,%.4f,%.4f,%.4f);\n",-soa/0.017447,sox,soy,soz);
     WriteTabs(tab);
     fprintf(f,"glTranslated(%.4f,%.4f,%.4f);\n",-cx,-cy,-cz);
}
// TransformSeparator
void OpenGLSaver::WriteTransformSeparator(TransformSeparator *ts, int tab) {
     WriteTabs(tab);
     if (strcmp(ts->GetName(),"NONE")) {
	    fprintf(f,"// %s (TransformSeparator)\n",ts->GetName());
     }
     else {
	fprintf(f,"// TransformSeparator\n");
     };

    WriteTabs(tab);
    fprintf(f,"glPushMatrix();\n"); // Push the current position
    for (int i=0;i<ts->Size();i++) {
	SaveNode(ts->GetChild(i),tab+1);
    };
    WriteTabs(tab);
    fprintf(f,"glPopMatrix();\n");
}
// Translation
void OpenGLSaver::WriteTranslation(Translation *t, int tab) {
    double x,y,z;
    t->translation.Get(x,y,z);
    WriteTabs(tab);
    if (strcmp(t->GetName(),"NONE")) {
	    fprintf(f,"// %s (Translation)\n",t->GetName());
    }
    else {
	fprintf(f,"// Translation\n");
    };
    WriteTabs(tab);
    fprintf(f,"glTranslated(%.4f,%.4f,%.4f);\n",x,y,z);
}
// WWWAnchor
void OpenGLSaver::WriteWWWAnchor(WWWAnchor *www, int tab) {
    VRMLState *state=new VRMLState();

    *(state) = st;
    WriteTabs(tab);
    if (strcmp(www->GetName(),"NONE")) {
	    fprintf(f,"// %s (WWWAchor)\n",www->GetName());
    }
    else {
	fprintf(f,"// WWWAnchor\n");
    };
    WriteTabs(tab);
    fprintf(f,"glPushMatrix();\n"); // Push the current position
    for (int i=0;i<www->Size();i++) {
	SaveNode(www->GetChild(i),tab+1);
    };
    WriteTabs(tab);    
    fprintf(f,"glPopMatrix();\n");
    st = *(state);
    delete state;
}
// WWWInline
void OpenGLSaver::WriteWWWInline(WWWInline *www, int tab) {
    if (www->in) SaveNode((VRMLNode *) www,tab+1);
}

// USE
void OpenGLSaver::WriteUSE(USE *u, int tab) {
    if (u->reference!=NULL) {
	WriteTabs(tab);
	fprintf(f,"// USE %s\n",u->reference->GetName());
	SaveNode(u->reference,tab);
    };
};
