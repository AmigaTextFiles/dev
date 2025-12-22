/*------------------------------------------------------
  GLConvert.cc
  Version: 0.2
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Convert VRML structure to GL structure
------------------------------------------------------*/
#include <math.h>
#include <libraries/mui.h>

#include "VRMLSupport.h"
#include "GLConvert.h"

GLConvert::GLConvert(MUIGauge *g,int coneres,int cylinderres, int sphereres, float a):
    st() {
    st.coneres=coneres;
    st.cylinderres=cylinderres;
    st.sphereres=sphereres;
    gauge=g;
    angle=a;
    // puts("GLConvert Constructor");
}
GLConvert::~GLConvert() {
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
	    st.c3=(Coordinate3 *) n;
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
	    gln=ConvertILS((IndexedLineSet *) n);
	    break;
	case MATERIAL_1:
	    st.m=(Material *) n;
	    break;
	case MATERIALBINDING_1:
	    st.mb=(MaterialBinding *) n;
	    break;
	case MATRIXTRANSFORM_1:
	    gln=ConvertMatrixTransform((MatrixTransform *) n);
	    break;
	case NORMAL_1:
	    st.n=(Normal *) n;
	    break;
	case NORMALBINDING_1:
	    st.nb=(NormalBinding *) n;
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

GLNode *GLConvert::ConvertCone(Cone *c) {
    // puts("=>ConvertCone");
    GLShape *gls=new GLShape();
    GLFace *glf=NULL;
    double angle=(2*3.1415)/st.coneres;
    double tangle=0;
    double xcos=1,zsin=0,topx=0,topy=0,topz=0;
    double oldx=c->bottomRadius,oldz=0,newx=oldx,newz=oldz;
    double halfh=c->height/2;
    int sides=c->parts&SIDES;
    int bottom=c->parts&BOTTOM;
    int i=0;
    Mat *cm[2];

    if (st.m==NULL) {
	for (i=0;i<2;i++) {
	    cm[i]=new Mat();
	};
    }
    else {
	if ((st.mb==NULL)||
	    (st.mb->value==OVERALL)||
	    (st.mb->value==DEFAULT)) {
	    for (i=0;i<2;i++) {
		cm[i]=new Mat(st.m->GetMaterial(0));
	    };
	}
	else if ((st.mb->value==PER_PART_INDEXED)||
		 (st.mb->value==PER_PART)) {
	    for (i=0;i<2;i++) {
		cm[i]=new Mat(st.m->GetMaterial(i));
	    };
	}
	else {
	    for (i=0;i<2;i++) {
		cm[i]=new Mat();
	    };
	};
    };
    if (sides) {
	// puts("parts contain SIDES");
	// cm[0]->DrawGL();
	for (i=0;i<st.coneres;i++) {
	    tangle=tangle+angle;
	    newx=cos(tangle)*c->bottomRadius;
	    newz=sin(tangle)*c->bottomRadius;
	    topy=sin(atan(c->bottomRadius/c->height))*c->bottomRadius;
	    // topx=cos(tangle+angle/2.0)*c->bottomRadius;
	    // topz=sin(tangle+angle/2.0)*c->bottomRadius;
	    glf=new GLFace();
	    if (i==0) {
		glf->material.Add(cm[0]);
	    };
	    glf->normal.Add(new Vertex3d(oldx,topy,oldz));
	    glf->vertex.Add(new Vertex3d(0,halfh,0));        // top
	    glf->normal.Add(new Vertex3d(oldx,topy,oldz));
	    glf->vertex.Add(new Vertex3d(oldx,-halfh,oldz));
	    glf->normal.Add(new Vertex3d(newx,topy,newz));
	    glf->vertex.Add(new Vertex3d(newx,-halfh,newz));
	    glf->normal.Add(new Vertex3d(newx,topy,newz));  // top
	    glf->vertex.Add(new Vertex3d(0,halfh,0));
	    oldx=newx;
	    oldz=newz;
	    gls->faces.Add(glf);
	};
    };

    tangle=2*3.1415;
    newx=c->bottomRadius;newz=0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	// cm[1]->DrawGL();
	glf=new GLFace();
	glf->material.Add(cm[1]);
	glf->normal.Add(new Vertex3d(0,-halfh,0));
	// glf->vertex.Add(new Vertex3d(0,-halfh,0));
	for (i=0;i<st.coneres;i++) {
	    glf->vertex.Add(new Vertex3d(newx,-halfh,newz));
	    tangle=tangle-angle;
	    newx=cos(tangle)*c->bottomRadius;
	    newz=sin(tangle)*c->bottomRadius;
	};
	gls->faces.Add(glf);
    };
    // puts("<=ConvertCone");
    return (GLNode *) gls;
}
GLNode *GLConvert::ConvertCube(Cube *c) {
    // puts("=>ConvertCube");
    GLShape *gls=new GLShape();
    GLFace *glf=NULL;
    double w=c->width/2;
    double h=c->height/2;
    double d=c->depth/2;

    // insertion des point des 6 faces
    // Au fond Second
    glf=new GLFace();
    glf->normal.Add(new Vertex3d(0.0,0.0,-1.0));
    //        cm[1]->DrawGL();
    glf->vertex.Add(new Vertex3d(-w,-h,-d));
    glf->vertex.Add(new Vertex3d(-w,h,-d));
    glf->vertex.Add(new Vertex3d(w,h,-d));
    glf->vertex.Add(new Vertex3d(w,-h,-d));
    gls->faces.Add(glf);
    if (st.m==NULL) {
	// puts("Adding white mat");
	glf->material.Add(new Mat());
    }
    else {
	if ((st.mb==NULL)||
	    (st.mb->value==OVERALL)||
	    (st.mb->value==DEFAULT)) {
	    glf->material.Add(new Mat(st.m->GetMaterial(0)));
	}
	else if ((st.mb->value==PER_PART)||
		 (st.mb->value==PER_FACE)) {
	};
    };

    // A gauche Third
    glf=new GLFace();
    glf->normal.Add(new Vertex3d(-1.0,0.0,0.0));
    //        cm[2]->DrawGL();
    glf->vertex.Add(new Vertex3d(-w,-h,-d));
    glf->vertex.Add(new Vertex3d(-w,-h,d));
    glf->vertex.Add(new Vertex3d(-w,h,d));
    glf->vertex.Add(new Vertex3d(-w,h,-d));
    gls->faces.Add(glf);

    // A droite Forth
    glf=new GLFace();
    glf->normal.Add(new Vertex3d(1.0,0.0,0.0));
    // cm[3]->DrawGL();
    glf->vertex.Add(new Vertex3d(w,-h,-d));
    glf->vertex.Add(new Vertex3d(w,h,-d));
    glf->vertex.Add(new Vertex3d(w,h,d));
    glf->vertex.Add(new Vertex3d(w,-h,d));
    gls->faces.Add(glf);

    // Defant first
    glf=new GLFace();
    glf->normal.Add(new Vertex3d (0.0,0.0,1.0));  // Devant First
    //            cm[0]->DrawGL();
    glf->vertex.Add(new Vertex3d(-w,-h,d));
    glf->vertex.Add(new Vertex3d(w,-h,d));
    glf->vertex.Add(new Vertex3d(w,h,d));
    glf->vertex.Add(new Vertex3d(-w,h,d));
    gls->faces.Add(glf);

    // haut Fifth
    glf=new GLFace();
    glf->normal.Add(new Vertex3d(0.0,1.0,0.0)); // Haut Fifth
    // cm[4]->DrawGL();
    glf->vertex.Add(new Vertex3d(-w,h,-d));
    glf->vertex.Add(new Vertex3d(-w,h,d));
    glf->vertex.Add(new Vertex3d(w,h,d));
    glf->vertex.Add(new Vertex3d(w,h,-d));
    gls->faces.Add(glf);

    // Bas Sixth
    glf=new GLFace();
    glf->normal.Add(new Vertex3d (0.0,-1.0,0.0)); // Bas Sixth
    // cm[5]->DrawGL();
    glf->vertex.Add(new Vertex3d(-w,-h,-d));
    glf->vertex.Add(new Vertex3d(w,-h,-d));
    glf->vertex.Add(new Vertex3d(w,-h,d));
    glf->vertex.Add(new Vertex3d(-w,-h,d));
    gls->faces.Add(glf);
    // puts("<=ConvertCube");
    return (GLNode *) gls;
}
// Cylinder
GLNode *GLConvert::ConvertCylinder(Cylinder *c) {
    GLShape *gls=new GLShape();
    GLFace *glf=NULL;
    double angle=(2*3.1415)/st.cylinderres;
    double tangle=0;
    double xcos=1,zsin=0;
    double oldx=c->radius,oldz=0,newx,newz;
    double halfh=c->height/2;
    int sides=c->parts&SIDES;
    int top=c->parts&TOP;
    int bottom=c->parts&BOTTOM;
    int i=0;
    Mat *cm[3];

    if (st.m==NULL) {
	for (i=0;i<3;i++) {
	    cm[i]=new Mat();
	};
    }
    else {
	if ((st.mb==NULL)||
	    (st.mb->value==OVERALL)||
	    (st.mb->value==DEFAULT)) {
	    for (i=0;i<3;i++) {
		cm[i]=new Mat(st.m->GetMaterial(0));
	    };
	}
	else if ((st.mb->value==PER_PART_INDEXED)||
		 (st.mb->value==PER_PART)) {
	    for (i=0;i<3;i++) {
		cm[i]=new Mat(st.m->GetMaterial(i));
	    };
	}
	else {
	    for (i=0;i<3;i++) {
		cm[i]=new Mat();
	    };
	};
     };

    // parts contains SIDE
    if (sides) {
	// puts("parts contain SIDES");
	for (i=0;i<st.cylinderres;i++) {
	    tangle=tangle+angle;
	    newx=cos(tangle)*c->radius;
	    newz=sin(tangle)*c->radius;
	    glf=new GLFace();
	    if (i==0) {
		glf->material.Add(cm[0]);
	    };
	    glf->normal.Add(new Vertex3d(oldx,0,oldz));
	    glf->vertex.Add(new Vertex3d(oldx,halfh,oldz));
	    glf->normal.Add(new Vertex3d(oldx,0,oldz));
	    glf->vertex.Add(new Vertex3d(oldx,-halfh,oldz));
	    glf->normal.Add(new Vertex3d(newx,0,newz));
	    glf->vertex.Add(new Vertex3d(newx,-halfh,newz));
	    glf->normal.Add(new Vertex3d(newx,0,newz));
	    glf->vertex.Add(new Vertex3d(newx,halfh,newz));
	    gls->faces.Add(glf);
	    oldx=newx;
	    oldz=newz;
	};
    };

    tangle=0;
    newx=c->radius;newz=0;
    // parts contains TOP
    if (top) {
	// puts("parts contains TOP");
	// glBegin(GL_TRIANGLE_FAN);
	glf=new GLFace();
	glf->normal.Add(new Vertex3d(0,halfh,0));
	glf->material.Add(cm[1]);
	// cm[1]->DrawGL();
	// glVertex3d(0,halfh,0);
	for (i=0;i<st.cylinderres;i++) {
	    glf->vertex.Add(new Vertex3d(newx,halfh,newz));
		tangle=tangle+angle;
		newx=cos(tangle)*c->radius;
		newz=sin(tangle)*c->radius;
	};
	gls->faces.Add(glf);
    };

    tangle=2*3.1415;
    newx=c->radius;newz=0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	// glBegin(GL_TRIANGLE_FAN);
	glf=new GLFace;
	glf->material.Add(cm[2]);
	glf->normal.Add(new Vertex3d(0,-halfh,0));
	for (i=0;i<st.cylinderres;i++) {
	    glf->vertex.Add(new Vertex3d(newx,-halfh,newz));
	    tangle=tangle-angle;
	    newx=cos(tangle)*c->radius;
	    newz=sin(tangle)*c->radius;
	};
	gls->faces.Add(glf);
    };
    return (GLNode *) gls;
}
GLNode *GLConvert::ConvertDirectionalLight(DirectionalLight *dl) {
    if (dl->on==FALSE) return NULL;
    GLDirectionalLight *gdl=new GLDirectionalLight(dl,st.lightsource);
    st.lightsource++;
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

//IFS
GLNode *GLConvert::ConvertIFS(IndexedFaceSet *ifs) {
    if (st.c3==NULL) return NULL;
    GLShape *gls=new GLShape();
    Face *cf=NULL;
    GLFace *glf=NULL;
    Vertex3d *cv=NULL;
    int lastindex=-1,index=-1;
    int i=0,j=0,psn=0;

    // puts("=>ConvertIFS");
    // For each face
    for (i=0;i<ifs->Size();i++) {
	cf=ifs->GetFace(i);
	glf=new GLFace();

	// Color stuff
	if (st.m==NULL) {
	   if (i==0) {
	      glf->material.Add(new Mat());
	   };
	}
	else if ((st.mb==NULL) ||
		 (st.mb->value==OVERALL)||
		 (st.mb->value==DEFAULT)) {
		  if (i==0) {
		     glf->material.Add(new Mat(st.m->GetMaterial(0)));
		  };
	}
	else if ((st.mb->value==PER_FACE)||
		 (st.mb->value==PER_PART)) {
		 glf->material.Add(new Mat(st.m->GetMaterial(i)));
	}
	else if ((st.mb->value==PER_FACE_INDEXED)||
		 (st.mb->value==PER_PART_INDEXED)) {
		 index=cf->materialIndex.Get(0);
		 if (index!=lastindex) {
		    glf->material.Add(new Mat(st.m->GetMaterial(index)));
		    lastindex=index;
		 };
	};
	
	
	// Normal stuff (if available)
	if (st.n) {
	   if (st.nb) {
	    if (st.nb->value==OVERALL) {
	       if (i==0) {
		   glf->normal.Add(new Vertex3d(st.n->GetVector(0)->coord));
	       };
	    }
	    else if ((st.nb->value==PER_FACE)||
		     (st.nb->value==PER_PART)) {
	       glf->normal.Add(new Vertex3d(st.n->GetVector(i)->coord));
	    }
	    else if ((st.nb->value==PER_FACE_INDEXED)||
		     (st.nb->value==PER_PART_INDEXED)) {
	       index=cf->normalIndex.Get(0);
	       glf->normal.Add(new Vertex3d(st.n->GetVector(index)->coord));
	    };
	   };
	}
	else {
	    st.n=ProduceNormalNode(gauge,st.c3,ifs,angle);
	    psn=1;
	};

	// for each vertex
	for (j=0;j<cf->coordIndex.Length();j++) {
	    // pointlist.Get(cf->coordIndex.Get(j))->Add(i);
	    cv=st.c3->GetPoint(cf->coordIndex.Get(j));
	    glf->vertex.Add(new Vertex3d(cv->coord));

	    // if PER_VERTEX Material binding
	    if ((st.m)&&
		(st.mb)) {
		if (st.mb->value==PER_VERTEX) {
		    glf->material.Add(new Mat(st.m->GetMaterial(cf->coordIndex.Get(j))));
		}
		else if (st.mb->value==PER_VERTEX_INDEXED) {
		    glf->material.Add(new Mat(st.m->GetMaterial(cf->materialIndex.Get(j))));
		};
	    };

	    // if PER_VERTEX Normal binding
	    if (st.n) {
		if ((st.nb==NULL)||
		    (st.nb->value==PER_VERTEX_INDEXED)||
		    (st.nb->value==DEFAULT)) {
		    glf->normal.Add(new Vertex3d(st.n->GetVector(cf->normalIndex.Get(j))->coord));
		}
		else if (st.nb->value==PER_VERTEX) {
		    glf->normal.Add(new Vertex3d(st.n->GetVector(cf->coordIndex.Get(j))->coord));
		};
	    };
	}; // end for each vertex
	gls->faces.Add(glf);
    };

    if (psn==1) {
	delete st.n;
    };
    // RefreshGauge(st);
    // puts("<=ConvertIFS");
    return (GLNode *) gls;
}

// ILS
GLNode *GLConvert::ConvertILS(IndexedLineSet *ils) {
    if (st.c3==NULL) return NULL;
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
	if (st.m==NULL) {
	   if (i==0) {
	      glf->material.Add(new Mat());
	   };
	}
	else if ((st.mb==NULL) ||
		 (st.mb->value==OVERALL)||
		 (st.mb->value==DEFAULT)) {
		  if (i==0) {
		     glf->material.Add(new Mat(st.m->GetMaterial(0)));
		  };
	}
	else if ((st.mb->value==PER_FACE)||
		 (st.mb->value==PER_PART)) {
		 glf->material.Add(new Mat(st.m->GetMaterial(i)));
	}
	else if ((st.mb->value==PER_FACE_INDEXED)||
		 (st.mb->value==PER_PART_INDEXED)) {
		 index=cf->materialIndex.Get(0);
		 if (index!=lastindex) {
		    glf->material.Add(new Mat(st.m->GetMaterial(index)));
		    lastindex=index;
		 };
	};

	// for each vertex
	for (j=0;j<cf->coordIndex.Length();j++) {
	    // pointlist.Get(cf->coordIndex.Get(j))->Add(i);
	    cv=st.c3->GetPoint(cf->coordIndex.Get(j));
	    glf->vertex.Add(new Vertex3d(cv->coord));

	    // if PER_VERTEX Material binding
	    if ((st.m)&&
		(st.mb)) {
		if (st.mb->value==PER_VERTEX) {
		    glf->material.Add(new Mat(st.m->GetMaterial(cf->coordIndex.Get(j))));
		}
		else if (st.mb->value==PER_VERTEX_INDEXED) {
		    glf->material.Add(new Mat(st.m->GetMaterial(cf->materialIndex.Get(j))));
		};
	    };

	}; // end for each vertex
	glw->lines.Add(glf);
    };

    // RefreshGauge(st);
    // puts("<=ConvertIFS");
    return (GLNode *) glw;
}

// LOD
GLNode *GLConvert::ConvertLOD(LOD *lod) {
    return ConvertVRML(lod->GetChild(0));
}
// MatrixTransform
GLNode *GLConvert::ConvertMatrixTransform(MatrixTransform *m) {
    GLMultMatrix *glm=new GLMultMatrix(m->matrix);
    return (GLNode *) glm;
}
// PointLight
GLNode *GLConvert::ConvertPointLight(PointLight *pl) {
    if (pl->on==FALSE) return NULL;
    GLPointLight *gpl=new GLPointLight(pl,st.lightsource);
    st.lightsource++;
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
    // puts("=>ConvertSeparator");
    VRMLState state=VRMLState();
    state=st;
    GLSeparator *gls=new GLSeparator();
    for (int i=0;i<s->Size();i++) {
	// VRMLNode *n=s->GetChild(i);
	GLNode *gln=ConvertVRML(s->GetChild(i));
	if (gln!=NULL) {
	    gls->children.Add(gln);
	};
    };
    st=state;
    // puts("<=ConvertSeparator");
    return (GLNode *) gls;
}
// Sphere
GLNode *GLConvert::ConvertSphere(Sphere *s) {
    GLShape *gls=new GLShape();
    GLFace *glf=NULL;
    Mat *cm;
    Mat *white=NULL;
    double phi=(2*3.1415)/st.sphereres;    // Vertical
    double teta=(2*3.1415)/st.sphereres;   // Horizontal
    double tteta=0,tphi=0;
    double costeta=0,sinphi=0,cosphi=0,sinteta=0;
    int i,j;
    double radius=s->radius;
    #ifdef __GNUC__
    Vertex3d p1=Vertex3d();
    Vertex3d p2=Vertex3d();
    Vertex3d p3=Vertex3d();
    Vertex3d p4=Vertex3d();
    #else
    Vertex3d p1(),p2(),p3(),p4();
    #endif

    // puts("=>ConvertSphere");
    if (st.m==NULL) {
	white=new Mat();
	cm=white;
    }
    else {
	cm=st.m->GetMaterial(0);
    };
    // cm->DrawGL();

    for (i=0;i<st.sphereres;i++) {
	for (j=0;j<st.sphereres;j++) {
	    costeta=cos(tteta);
	    sinphi=sin(tphi);
	    cosphi=cos(tphi);
	    sinteta=sin(tteta);

	    // glBegin(GL_QUADS);
	    glf=new GLFace();
	    if (i==0) glf->material.Add(new Mat(cm));
	    p1.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    glf->vertex.Add(new Vertex3d(p1.coord));
	    glf->normal.Add(new Vertex3d(p1.coord));
	    tteta+=teta;
	    sinteta=sin(tteta);
	    costeta=cos(tteta);
	    p2.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    glf->normal.Add(new Vertex3d(p2.coord));
	    glf->vertex.Add(new Vertex3d(p2.coord));
	    tphi+=phi;
	    cosphi=cos(tphi);
	    sinphi=sin(tphi);
	    p3.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    glf->normal.Add(new Vertex3d(p3.coord));
	    glf->vertex.Add(new Vertex3d(p3.coord));
	    tteta-=teta;
	    sinteta=sin(tteta);
	    costeta=cos(tteta);
	    p4.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
	    glf->normal.Add(new Vertex3d(p4.coord));
	    glf->vertex.Add(new Vertex3d(p4.coord));
	    tteta+=teta;
	    tphi-=phi;
	    gls->faces.Add(glf);
	};
	tphi+=phi;
	tteta=0;
    };
    // puts("<=ConvertSphere");
    return (GLNode *) gls;
}
// SpotLight
GLNode *GLConvert::ConvertSpotLight(SpotLight *sl) {
    if (sl->on==FALSE) return NULL;
    GLSpotLight *gsl=new GLSpotLight(sl,st.lightsource);
    st.lightsource++;
    return (GLNode *) gsl;
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
    for (int i=0;i<ts->Size();i++) {
	GLNode *gln=ConvertVRML(ts->GetChild(i));
	if (gln!=NULL) {
	    gls->children.Add(gln);
	};
    };
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
    state=st;
    GLSeparator *gls=new GLSeparator();
    for (int i=0;i<www->Size();i++) {
	// VRMLNode *n=s->GetChild(i);
	GLNode *gln=ConvertVRML(www->GetChild(i));
	if (gln!=NULL) {
	    gls->children.Add(gln);
	};
    };
    st=state;
    // puts("<=ConvertSeparator");
    return (GLNode *) gls;
}

// WWWInline
GLNode *GLConvert::ConvertWWWInline(WWWInline *www) {
    if (www->in) {
	return ConvertVRML((VRMLNode *) www);
    };
}
