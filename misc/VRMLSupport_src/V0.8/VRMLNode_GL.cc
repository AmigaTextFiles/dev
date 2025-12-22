/*----------------------------------------------------
  VRMLNode_GL.cc
  Version 0.34
  Date: 18 april 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: All CyberGL output
-----------------------------------------------------*/
#include <math.h>

#include <dos/dos.h>

#include <proto/exec.h>
#include <proto/dos.h>

#ifdef USE_CYBERGL
#define SHARED
#include <cybergl/cybergl.h>
#include <cybergl/display.h>
#include <proto/cybergl.h>
#else
#include <proto/Amigamesa.h>
// #include "StormMesaSupport.h"
#endif

#include "VRMLNode.h"
#include "GL_stubs.h"

/*---------------------
  Misc classes
----------------------*/

// BOOL Mat::DrawGL() {

    // glColor3fv(diffuse.rgb);
// }
/**************
 * VRML Nodes *
 **************/
// AsciiText
BOOL AsciiText::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    // GetSemaphore();
    if (st) st->currentnode++;
    // PutSemaphore();
    return FALSE;
}
// Cone
BOOL Cone::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    double angle=(2*3.1415)/st->coneres;
    double tangle=0.0,alpha=0.0,beta=0.0;
    double xcos=1,zsin=0,topy=0;
    double oldx=0.0,oldz=0.0,newx=0.0,newz=0.0;
    double tdx=1.0/st->coneres,ttdx=0.0,oldtx=0.0,newtx=0.0;
    double halfh=height/2;
    int sides=parts&SIDES;
    int bottom=parts&BOTTOM;
    int i=0;
    Mat *cm[2];
    Mat *white=NULL;

    if (st) {
	st->currentnode++;
	st->currentpolygone+=st->coneres+1;
    };

    if (st->m==NULL) {
	white=new Mat();
	for (i=0;i<2;i++) {
	    cm[i]=white;
	};
    }
    else {
	if ((st->mb==NULL)||
	    (st->mb->value==BINDING_OVERALL)||
	    (st->mb->value==BINDING_DEFAULT)) {
	    for (i=0;i<2;i++) {
		cm[i]=st->m->GetMaterial(0);
	    };
	}
	else if ((st->mb->value==BINDING_PER_PART_INDEXED)||
		 (st->mb->value==BINDING_PER_PART)) {
	    for (i=0;i<2;i++) {
		cm[i]=st->m->GetMaterial(i);
	    };
	}
	else {
	    white=new Mat();
	    for (i=0;i<2;i++) {
		cm[i]=white;
	    };    
	};
    };

    tangle=3.1415/2.0;
    if (sides) {
	// puts("parts contain SIDES");
	cm[0]->DrawGL(st->glcontext);
	oldx=cos(tangle)*bottomRadius;
	oldz=-sin(tangle)*bottomRadius;
	oldtx=0.0;
	alpha=atan(height/bottomRadius);
	beta=3.1415-(3.1415/2.0)-alpha;
	topy=cos(beta)*bottomRadius;
	topy=sin(beta)*topy;
	for (i=0;i<st->coneres;i++) {
	    tangle=tangle+angle;
	    ttdx=ttdx+tdx;
	    newx=cos(tangle)*bottomRadius;
	    newz=-sin(tangle)*bottomRadius;
	    newtx=ttdx;
	    glBegin(GL_QUADS);
		glNormal3d(oldx,topy,oldz);
		glTexCoord2d(oldtx,1.0);
		glVertex3d(0,halfh,0);
		glTexCoord2d(oldtx,0.0);
		glVertex3d(oldx,-halfh,oldz);
		glNormal3d(newx,topy,newz);
		glTexCoord2d(newtx,0.0);
		glVertex3d(newx,-halfh,newz);
		glTexCoord2d(newtx,1.0);
		glVertex3d(0,halfh,0);
	    glEnd();
	    oldx=newx;
	    oldz=newz;
	    oldtx=newtx;
	    if(CheckSignal(SIGBREAKF_CTRL_D)) {
		if (white) delete white;
		PutSemaphore();
		return TRUE;
	    };
	};
    };


    /*
    // parts contains SIDE
    tangle=3.1415/2.0;
    if (sides) {
	// puts("parts contain SIDES");
	cm[0]->DrawGL(st->glcontext);
	oldx=cos(tangle)*radius;
	oldz=-sin(tangle)*radius;
	for (i=0;i<st->coneres;i++) {
	    tangle=tangle+angle;
	    xcos=cos(tangle);
	    zsin=sin(tangle);
	    newx=cos(tangle)*bottomRadius;
	    newz=sin(tangle)*bottomRadius;
	    topy=sin(atan(bottomRadius/height))*bottomRadius;
	    glBegin(GL_QUADS);
		glNormal3d(oldx,topy,oldz);
		glVertex3d(0,halfh,0);          // top
		glNormal3d(oldx,topy,oldz);
		glVertex3d(oldx,-halfh,oldz);
		glNormal3d(newx,topy,newz);
		glVertex3d(newx,-halfh,newz);
		glNormal3d(newx,topy,newz);    // top
		glVertex3d(0,halfh,0);
	    glEnd();
	    oldx=newx;
	    oldz=newz;
	    if(CheckSignal(SIGBREAKF_CTRL_D)) {
		if (white) delete white;
		PutSemaphore();
		return TRUE;
	    };
	};
    };
    */
    tangle=3.1415/2.0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	glBegin(GL_TRIANGLE_FAN);
	    glNormal3d(0,-halfh,0);
	    cm[1]->DrawGL(st->glcontext);
	    // glColor3d(r[2],g[2],b[2]);
	    glTexCoord2d(0.5,0.5);
	    glVertex3d(0,-halfh,0);
	    for (i=0;i<st->coneres+1;i++) {
		xcos=cos(tangle);
		zsin=sin(tangle);
		glTexCoord2d(0.5+(xcos/2.0),0.5-(zsin/2.0));
		glVertex3d(xcos*bottomRadius,-halfh,-zsin*bottomRadius);
		tangle=tangle-angle;
		if(CheckSignal(SIGBREAKF_CTRL_D)) {
		    if (white) delete white;
		    PutSemaphore();
		    return TRUE;
		};
	    };
	 glEnd();
    };




    /*
    tangle=2*3.1415;
    newx=bottomRadius;newz=0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	cm[1]->DrawGL(st->glcontext);
	glBegin(GL_TRIANGLE_FAN);
	    glNormal3d(0,-halfh,0);
	    glVertex3d(0,-halfh,0);
	    for (i=0;i<st->coneres+1;i++) {
		glVertex3d(newx,-halfh,newz);
		tangle=tangle-angle;
		newx=cos(tangle)*bottomRadius;
		newz=sin(tangle)*bottomRadius;
		if(CheckSignal(SIGBREAKF_CTRL_D)) {
		    if (white) delete white;
		    PutSemaphore();
		    return TRUE;
		};
	    };
	glEnd();
    };
    */
    if (white) delete white;
    RefreshGauge(st);
    PutSemaphore();
    return FALSE;
}
// Coordinate3
BOOL Coordinate3::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    if (st) st->currentnode++;
    st->c3=this;
    return FALSE;
}
// Cube
BOOL Cube::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    double w=width/2;
    double h=height/2;
    double d=depth/2;
    float r[6],g[6],b[6];
    Mat *cm[6];
    Mat *white=NULL; // =new Mat();
    int i=0;

    // GetSemaphore();
	if (st) {
	    st->currentnode++;
	    st->currentpolygone+=6;
	};
	

	if (st->m==NULL) {
	    white=new Mat();
	    for (i=0;i<6;i++) {
		cm[i]= white;
	    };
	}
	else {
	    if ((st->mb==NULL)||
		(st->mb->value==BINDING_OVERALL)||
		(st->mb->value==BINDING_DEFAULT)) {
		for (i=0;i<6;i++) {
		    cm[i]=st->m->GetMaterial(0);
		};
	    }
	    else if ((st->mb->value==BINDING_PER_FACE_INDEXED)||
		     (st->mb->value==BINDING_PER_FACE)||
		     (st->mb->value==BINDING_PER_PART_INDEXED)||
		     (st->mb->value==BINDING_PER_PART)) {
		for (i=0;i<6;i++) {
		    cm[i]=st->m->GetMaterial(i);
		};
	    }
	    else {
		white=new Mat();
		for (i=0;i<6;i++) {
		    cm[i]= white;
		};
	    };
	};

	//--- texture ---
	if (st->t) {
	    st->t->InitGLTexture(st->glcontext);
	};

	//--- Faces ---
	glBegin(GL_QUADS);
	    //          x y z
	    glNormal3d (0.0,0.0,-1.0);  // Au fond Second
	    cm[1]->DrawGL(st->glcontext);
	    // glColor3d(r[1],g[1],b[1]);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(-w,-h,-d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(-w,h,-d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(w,h,-d);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(w,-h,-d);

	    glNormal3d (-1.0,0.0,0.0);  // A gauche Third
	    cm[2]->DrawGL(st->glcontext);
	    // glColor3d(r[2],g[2],b[2]);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(-w,-h,-d);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(-w,-h,d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(-w,h,d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(-w,h,-d);

	    glNormal3d (1.0,0.0,0.0);  // A droite Forth
	    cm[3]->DrawGL(st->glcontext);
	    // glColor3d(r[3],g[3],b[3]);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(w,-h,-d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(w,h,-d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(w,h,d);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(w,-h,d);

	    glNormal3d (0.0,0.0,1.0);  // Devant First
	    cm[0]->DrawGL(st->glcontext);
	    // glColor3d(r[0],g[0],b[0]);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(-w,-h,d);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(w,-h,d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(w,h,d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(-w,h,d);

	    glNormal3d (0.0,1.0,0.0); // Haut Fifth
	    cm[4]->DrawGL(st->glcontext);
	    // glColor3d(r[4],g[4],b[4]);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(-w,h,-d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(-w,h,d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(w,h,d);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(w,h,-d);

	    glNormal3d (0.0,-1.0,0.0); // Bas Sixth
	    cm[5]->DrawGL(st->glcontext);
	    // glColor3d(r[5],g[5],b[5]);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(-w,-h,-d);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(w,-h,-d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(w,-h,d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(-w,-h,d);
	glEnd();

	if (white) delete white;
	RefreshGauge(st);
	// PutSemaphore();
	return FALSE;
}
// Cylinder
BOOL Cylinder::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    // GetSemaphore();
    if (st) {
	st->currentnode++;
	st->currentpolygone+=st->cylinderres+2;
    };
    float r[3],g[3],b[3];
    Mat *cm[6];
    Mat *white=NULL; // new Mat();
    double angle=(2*3.1415)/st->cylinderres;
    double tangle=3.1415/2.0;
    double xcos=1,zsin=0;
    double oldx=0.0,oldz=0.0,newx=0.0,newz=0.0;
    double halfh=height/2.0;
    double oldtx=0.0,newtx=0.0,tdx=1.0/st->cylinderres,ttdx=0.0;
    int sides=parts&SIDES;
    int top=parts&TOP;
    int bottom=parts&BOTTOM;
    int i=0;

    if (st->m==NULL) {
	white=new Mat();
	for (i=0;i<3;i++) {
	    cm[i]=white;
	};
    }
    else {
	if ((st->mb==NULL)||
	    (st->mb->value==BINDING_OVERALL)||
	    (st->mb->value==BINDING_DEFAULT)) {
	    for (i=0;i<3;i++) {
		cm[i]=st->m->GetMaterial(0);
	    };
	}
	else if ((st->mb->value==BINDING_PER_PART_INDEXED)||
		 (st->mb->value==BINDING_PER_PART)) {
	    for (i=0;i<3;i++) {
		cm[i]=st->m->GetMaterial(i);
	    };
	}
	else {
	    white=new Mat();
	    for (i=0;i<3;i++) {
		cm[i]=white;
	    };
	};
    };

    //--- texture ---
    if (st->t) {
	st->t->InitGLTexture(st->glcontext);
    };

    // parts contains SIDE
    if (sides) {
	// puts("parts contain SIDES");
	cm[0]->DrawGL(st->glcontext);
	oldx=cos(tangle)*radius;
	oldz=-sin(tangle)*radius;
	oldtx=0.0;
	for (i=0;i<st->cylinderres;i++) {
	    tangle=tangle+angle;
	    ttdx=ttdx+tdx;
	    newx=cos(tangle)*radius;
	    newz=-sin(tangle)*radius;
	    newtx=ttdx;
	    glBegin(GL_QUADS);
		glNormal3d(oldx,0,oldz);
		glTexCoord2d(oldtx,1.0);
		glVertex3d(oldx,halfh,oldz);
		glTexCoord2d(oldtx,0.0);
		glVertex3d(oldx,-halfh,oldz);
		glNormal3d(newx,0,newz);
		glTexCoord2d(newtx,0.0);
		glVertex3d(newx,-halfh,newz);
		glTexCoord2d(newtx,1.0);
		glVertex3d(newx,halfh,newz);
	    glEnd();
	    oldx=newx;
	    oldz=newz;
	    oldtx=newtx;
	    if(CheckSignal(SIGBREAKF_CTRL_D)) {
		if (white) delete white;
		PutSemaphore();
		return TRUE;
	    };
	};
    };

    tangle=3.1415/2.0;
    // parts contains TOP
    if (top) {
	// puts("parts contains TOP");
	glBegin(GL_TRIANGLE_FAN);
	    glNormal3d(0,halfh,0);
	    cm[1]->DrawGL(st->glcontext);
	    // glColor3d(r[1],g[1],b[1]);
	    glTexCoord2d(0.5,0.5);
	    glVertex3d(0,halfh,0);
	    for (i=0;i<st->cylinderres+1;i++) {
		xcos=cos(tangle);
		zsin=sin(tangle);
		glTexCoord2d(0.5+(xcos/2.0),0.5+(zsin/2.0));
		glVertex3d(xcos*radius,halfh,-zsin*radius);
		tangle=tangle+angle;
		if(CheckSignal(SIGBREAKF_CTRL_D)) {
		    if (white) delete white;
		    PutSemaphore();
		    return TRUE;
		};
	    };
	 glEnd();
    };

    tangle=3.1415/2.0;
    // parts contain BOTTOM
    if (bottom) {
	// puts("parts contains BOTTOM");
	glBegin(GL_TRIANGLE_FAN);
	    glNormal3d(0,-halfh,0);
	    cm[2]->DrawGL(st->glcontext);
	    // glColor3d(r[2],g[2],b[2]);
	    glTexCoord2d(0.5,0.5);
	    glVertex3d(0,-halfh,0);
	    for (i=0;i<st->cylinderres+1;i++) {
		xcos=cos(tangle);
		zsin=sin(tangle);
		glTexCoord2d(0.5+(xcos/2.0),0.5-(zsin/2.0));
		glVertex3d(xcos*radius,-halfh,-zsin*radius);
		tangle=tangle-angle;
		if(CheckSignal(SIGBREAKF_CTRL_D)) {
		    if (white) delete white;
		    PutSemaphore();
		    return TRUE;
		};
	    };
	 glEnd();
    };
    if (white) delete white;
    RefreshGauge(st);
    // PutSemaphore();
    return FALSE;
}
// DirectionalLight
BOOL DirectionalLight::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    GetSemaphore();
    if (st) st->currentnode++;

    float amb[4];
    float pos[4];
    GLenum LightNum;

    switch (st->lightsource) {
	case 0:LightNum=GL_LIGHT0;break;
	case 1:LightNum=GL_LIGHT1;break;
	case 2:LightNum=GL_LIGHT2;break;
	case 3:LightNum=GL_LIGHT3;break;
    };
    amb[0]=intensity;
    amb[1]=intensity;
    amb[2]=intensity;
    amb[3]=1.0;
    pos[0]=point.coord[0];
    pos[1]=point.coord[1];
    pos[2]=point.coord[2];
    pos[3]=point.coord[3];

    if (on==TRUE) {glEnable(LightNum);}
    else {glDisable(LightNum);};
    glLightfv(LightNum, GL_POSITION, pos);
    glLightfv(LightNum, GL_DIFFUSE, color.rgb);
    glLightfv(LightNum, GL_AMBIENT, amb);
    st->lightsource++;
    PutSemaphore();
    return FALSE;
}
// FontStyle
BOOL FontStyle::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    return FALSE;
}
// Group
BOOL Group::DrawGL(VRMLState *st) {
    GetSemaphore();
    if (st) st->currentnode++;
    for (int i=0;i<children.Length();i++) {
	if(GetChild(i)->DrawGL(st)) {
	    PutSemaphore();
	    return TRUE;
	};
    };
    PutSemaphore();
    return FALSE;
}

// IndexedFaceSet
BOOL IndexedFaceSet::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    Face *cf=NULL;
    Vertex3d *cv=NULL;
    int lastindex=-1,index=-1;
    int i=0,j=0,cpt=0;

    if (st) st->currentnode++;
    if (st->c3==NULL) {
	// PutSemaphore();
	return FALSE;
    };
    /*
    st->c3->GetSemaphore();
    if (st->m!=NULL) st->m->GetSemaphore();
    if (st->mb!=NULL) st->mb->GetSemaphore();
    if (st->n!=NULL) st->n->GetSemaphore();
    if (st->nb!=NULL) st->nb->GetSemaphore();
    */
    // puts(">In IndexedFaceSet DrawGL");

    //--- Texture ---
    if (st->t) {
	st->t->InitGLTexture(st->glcontext);
	if (st->tc2==NULL) {
	    GLfloat xequalzero[]={1.0,0,0,0};
	    GLfloat yequalzero[]={0,1.0,0,0};
	    glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
	    glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR);
	    glTexGenfv(GL_S, GL_OBJECT_PLANE, xequalzero);
	    glTexGenfv(GL_T, GL_OBJECT_PLANE, yequalzero);
	    glEnable(GL_TEXTURE_GEN_S);
	    glEnable(GL_TEXTURE_GEN_T);
	};
    };

    for (i=0;i<faces.Length();i++,cpt++) {
	cf=faces.Get(i);
	glBegin(GL_POLYGON);
	    //--- Color stuff
	    if (st->m==NULL) {
		Mat white=Mat();
		white.DrawGL(st->glcontext);
	    }
	    else {
		if ((st->mb==NULL) ||
		    (st->mb->value==BINDING_OVERALL)||
		    (st->mb->value==BINDING_DEFAULT)) {
		    st->m->GetMaterial(0)->DrawGL(st->glcontext);
		}
		else if ((st->mb->value==BINDING_PER_FACE)||
			 (st->mb->value==BINDING_PER_PART)) {
			st->m->GetMaterial(i)->DrawGL(st->glcontext);
		}
		else if ((st->mb->value==BINDING_PER_FACE_INDEXED)||
			 (st->mb->value==BINDING_PER_PART_INDEXED)) {
			index=cf->materialIndex.Get(0);
			if (index!=lastindex) {
				st->m->GetMaterial(index)->DrawGL(st->glcontext);
				lastindex=index;
			};
		};
	    };

	    //--- Normal stuff
	    if (st->n==NULL) {
		if (cf->coordIndex.Length()>2) {
		    Vertex3d *point1=st->c3->GetPoint(cf->coordIndex.Get(0));
		    Vertex3d *point2=st->c3->GetPoint(cf->coordIndex.Get(1));
		    Vertex3d *point3=st->c3->GetPoint(cf->coordIndex.Get(2));
		    Vertex3d vec1=Vertex3d(point2->coord[0]-point1->coord[0],
					   point2->coord[1]-point1->coord[1],
					   point2->coord[2]-point1->coord[2]);
		    Vertex3d vec2=Vertex3d(point3->coord[0]-point1->coord[0],
					   point3->coord[1]-point1->coord[1],
					   point3->coord[2]-point1->coord[2]);
		    glNormal3d(vec1.coord[1]*vec2.coord[2]-vec1.coord[2]*vec2.coord[1],
			       vec1.coord[2]*vec2.coord[0]-vec1.coord[0]*vec2.coord[2],
			       vec1.coord[0]*vec2.coord[1]-vec1.coord[1]*vec2.coord[0]);
		};
	    }
	    else {
		// if ((st->nb==NULL)||
		if (st->nb) {
		    if  (st->nb->value==BINDING_OVERALL) {
			glNormal3dv(st->n->GetVector(0)->coord);
		    }
		    else if ((st->nb->value==BINDING_PER_FACE)||
			     (st->nb->value==BINDING_PER_PART)) {
			glNormal3dv(st->n->GetVector(i)->coord);
		    }
		    else if ((st->nb->value==BINDING_PER_FACE_INDEXED)||
			     (st->nb->value==BINDING_PER_PART_INDEXED)) {
			index=cf->normalIndex.Get(0);
			glNormal3dv(st->n->GetVector(index)->coord);
		    };
		};
	    };
	    
	    //--- Drawing
	    for (j=0;j<cf->coordIndex.Length();j++) {
		cv=st->c3->GetPoint(cf->coordIndex.Get(j));
		// calculate the bounding box
		if (bbox==NOTYET) {
		    if (cv->coord[0]<min.coord[0]) min.coord[0]=cv->coord[0];
		    if (cv->coord[1]<min.coord[1]) min.coord[1]=cv->coord[1];
		    if (cv->coord[2]<min.coord[2]) min.coord[2]=cv->coord[2];

		    if (cv->coord[0]>max.coord[0]) max.coord[0]=cv->coord[0];
		    if (cv->coord[1]>max.coord[1]) max.coord[1]=cv->coord[1];
		    if (cv->coord[2]>max.coord[2]) max.coord[2]=cv->coord[2];
		}
		// Effective draw of the vertex
		if (st->mb) {
		   if (st->mb->value==BINDING_PER_VERTEX) {
		       st->m->GetMaterial(cf->coordIndex.Get(j))->DrawGL(st->glcontext);
		   }
		   else if (st->mb->value==BINDING_PER_VERTEX_INDEXED) {
		       st->m->GetMaterial(cf->materialIndex.Get(j))->DrawGL(st->glcontext);
		   };
		};

		if ((st->nb==NULL)||
		    (st->nb->value==BINDING_PER_VERTEX_INDEXED)||
		    (st->nb->value==BINDING_DEFAULT)) {
		    if (st->n) {
			glNormal3dv(st->n->GetVector(cf->normalIndex.Get(j))->coord);
		    };
		}
		else if (st->nb->value==BINDING_PER_VERTEX) {
		    if (st->n) {
		       glNormal3dv(st->n->GetVector(cf->coordIndex.Get(j))->coord);
		    };
		};

		//--- Texture stuff
		if (st->tc2) {
		    glTexCoord2dv(st->tc2->GetPoint(cf->textureCoordIndex.Get(j))->coord);
		};

		glVertex3dv(cv->coord);
	    };
	glEnd();
	st->currentpolygone++;
	if (cpt>40) {
	    RefreshGauge(st);
	    cpt=0;
	};
	if(CheckSignal(SIGBREAKF_CTRL_D)) {
	    /*
	    st->c3->PutSemaphore();
	    if (st->m!=NULL) st->m->PutSemaphore();
	    if (st->mb!=NULL) st->mb->PutSemaphore();
	    if (st->n!=NULL) st->n->PutSemaphore();
	    if (st->nb!=NULL) st->nb->PutSemaphore();
	    */
	    PutSemaphore();
	    return TRUE;
	};
    };

    if (st->t) {
	glDisable(GL_TEXTURE_GEN_S);
	glDisable(GL_TEXTURE_GEN_T);
    };

    bbox=READY;
    RefreshGauge(st);
    // puts("<IndexedFaceSet GL");
    /*
    st->c3->PutSemaphore();
    if (st->m!=NULL) st->m->PutSemaphore();
    if (st->mb!=NULL) st->mb->PutSemaphore();
    if (st->n!=NULL) st->n->PutSemaphore();
    if (st->nb!=NULL) st->nb->PutSemaphore();
    */
    PutSemaphore();
    return FALSE;
}
// IndexedLineSet
BOOL IndexedLineSet::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    // GetSemaphore();

    int index=-1,lastindex=-1;
    int i=0,j=0,cpt=0;
    Face *cf=NULL;
    Vertex3d *cv=NULL;

    if (st) st->currentnode++;
    if (st->c3==NULL) {
	PutSemaphore();
	return FALSE;
    };
    /*
    st->c3->GetSemaphore();
    if (st->m!=NULL) st->m->GetSemaphore();
    if (st->mb!=NULL) st->mb->GetSemaphore();
    if (st->n!=NULL) st->n->GetSemaphore();
    if (st->nb!=NULL) st->nb->GetSemaphore();
    */
    // puts("In IndexedLineSet DrawGL");
    for (i=0;i<faces.Length();i++,cpt++) {
	cf=faces.Get(i);
	glBegin(GL_LINE);
	    // Color stuff
	    if (st->m==NULL) {
		glColor3d(1.0,1.0,1.0);
	    }
	    else if ((st->mb==NULL) ||
		     (st->mb->value==BINDING_OVERALL)||
		     (st->mb->value==BINDING_DEFAULT)) {
		    st->m->GetMaterial(0)->DrawGL(st->glcontext);
	    }
	    else if (st->mb->value==BINDING_PER_FACE_INDEXED) {
		    index=cf->materialIndex.Get(0);
		    if (index!=lastindex) {
			st->m->GetMaterial(index)->DrawGL(st->glcontext);
			lastindex=index;
		    };
	    };
	    // Drawing
	    for (j=0;j<cf->coordIndex.Length();j++) {
		cv=st->c3->GetPoint(cf->coordIndex.Get(j));
		if (bbox==NOTYET) {
		    if (cv->coord[0]<min.coord[0]) min.coord[0]=cv->coord[0];
		    if (cv->coord[1]<min.coord[1]) min.coord[1]=cv->coord[1];
		    if (cv->coord[2]<min.coord[2]) min.coord[2]=cv->coord[2];

		    if (cv->coord[0]>max.coord[0]) max.coord[0]=cv->coord[0];
		    if (cv->coord[1]>max.coord[1]) max.coord[1]=cv->coord[1];
		    if (cv->coord[2]>max.coord[2]) max.coord[2]=cv->coord[2];
		}
		glVertex3dv(cv->coord);
	    };
	 glEnd();
	 st->currentpolygone++;
	 if (cpt>40) {
	     RefreshGauge(st);
	     cpt=0;
	 };
	 if(CheckSignal(SIGBREAKF_CTRL_D)) {
	    /*
	    st->c3->PutSemaphore();
	    if (st->m!=NULL) st->m->PutSemaphore();
	    if (st->mb!=NULL) st->mb->PutSemaphore();
	    if (st->n!=NULL) st->n->PutSemaphore();
	    if (st->nb!=NULL) st->nb->PutSemaphore();
	    */
	    PutSemaphore();
	    return TRUE;
	 };
    };
    bbox=READY;
    RefreshGauge(st);
    /*
    st->c3->PutSemaphore();
    if (st->m!=NULL) st->m->PutSemaphore();
    if (st->mb!=NULL) st->mb->PutSemaphore();
    if (st->n!=NULL) st->n->PutSemaphore();
    if (st->nb!=NULL) st->nb->PutSemaphore();
    */
    PutSemaphore();
    return FALSE;
}
// Info
BOOL VInfo::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    return FALSE;
}
// LOD
BOOL LOD::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    // GetSemaphore();
    BOOL rep=TRUE;

    if (st) st->currentnode++;
    glPushMatrix();
    state = *(st);
    rep=children.Get(0)->DrawGL(st);
    int cn=st->currentnode;
    int cp=st->currentpolygone;
    *(st) = state;
    st->currentnode=cn;
    st->currentpolygone=cp;
    glPopMatrix();
    PutSemaphore();
    return rep;
}
// Material
BOOL Material::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    st->m=this;
    return FALSE;
}
// MaterialBinding
BOOL MaterialBinding::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    st->mb=this;
    return FALSE;
}
// MatrixTranform
BOOL MatrixTransform::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    // GetSemaphore();
    if (st) st->currentnode++;
    glMultMatrixf(matrix);
    PutSemaphore();
    return FALSE;
}
// Normal
BOOL Normal::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    st->n=this;
    return FALSE;
}
// NormalBinding
BOOL NormalBinding::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    st->nb=this;
    return FALSE;
}
// OrthographicCamera
BOOL OrthographicCamera::DrawGL(VRMLState *st) {
    GetSemaphore();
    if (st) st->currentnode++;
    PutSemaphore();
    return FALSE;
}
void OrthographicCamera::DrawGLCamera() {
    puts("OrthographicCamera::DrawGLCamera");
}
// PerspectiveCamera
BOOL PerspectiveCamera::DrawGL(VRMLState *st) {
    GetSemaphore();
    if (st) st->currentnode++;
    PutSemaphore();
    return FALSE;
}
void PerspectiveCamera::DrawGLCamera() {
    /*
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    puts("PerspectiveCamera::DrawGLCamera");
    glTranslated(-position.coord[0],-position.coord[1],-position.coord[2]);
    */
    // glRotated(
    // glRotated(orientation[3]
}

// PointLight
BOOL PointLight::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    // GetSemaphore();
    if (st) st->currentnode++;
    GLfloat amb[4];
    GLfloat pos[4];
    GLenum LightNum;

    switch (st->lightsource) {
	case 0:LightNum=GL_LIGHT0;break;
	case 1:LightNum=GL_LIGHT1;break;
	case 2:LightNum=GL_LIGHT2;break;
	case 3:LightNum=GL_LIGHT3;break;
    };
    amb[0]=intensity;
    amb[1]=intensity;
    amb[2]=intensity;
    amb[3]=1.0;
    pos[0]=point.coord[0];
    pos[1]=point.coord[1];
    pos[2]=point.coord[2];
    pos[3]=point.coord[3];
    // printf("position: %f %f %f %f\n",pos[0],pos[1],pos[2],pos[4]);
    if (on==TRUE) {glEnable(LightNum);}
    else {glDisable(LightNum);};
    glLightfv(LightNum, GL_POSITION, pos);
    glLightfv(LightNum, GL_DIFFUSE, color.rgb);
    glLightfv(LightNum, GL_AMBIENT, amb);
    st->lightsource++;
    PutSemaphore();
    return FALSE;
}

// PointSet
BOOL PointSet::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    // GetSemaphore();
    if (st) st->currentnode++;
    if (st->c3==NULL) {
	// PutSemaphore();
	return FALSE;
    };
    st->c3->GetSemaphore();
    if (st->m!=NULL) st->m->GetSemaphore();

    int max=0,cpt=0;
    if (numPoints==-1) {max=st->c3->Size();}
    else {max=startIndex+numPoints;};

    glBegin(GL_POINTS);
    for (int i=startIndex;i<max;i++,cpt++) {
	if (st->m==NULL) {
		Mat white=Mat();
		white.DrawGL(st->glcontext);
	}
	else {
	   if ((st->mb==NULL)||
	       (st->mb->value==BINDING_DEFAULT)||
	       (st->mb->value==BINDING_OVERALL)) {
	       st->m->GetMaterial(0)->DrawGL(st->glcontext);
	   }
	   else if ((st->mb->value==BINDING_PER_PART)||
		    (st->mb->value==BINDING_PER_FACE)||
		    (st->mb->value==BINDING_PER_VERTEX)) {
		    st->m->GetMaterial(i)->DrawGL(st->glcontext);
	   };
	};
	if (st->n==NULL) {
	   glNormal3d(0,0,-1);
	}
	else {
	   if ((st->nb==NULL)||
	       (st->nb->value==BINDING_DEFAULT)||
	       (st->nb->value==BINDING_PER_PART)||
	       (st->nb->value==BINDING_PER_FACE)||
	       (st->nb->value==BINDING_PER_VERTEX)) {
	       glNormal3dv(st->n->GetVector(i)->coord);
	   }
	   else if (st->nb->value==BINDING_OVERALL) {
		glNormal3dv(st->n->GetVector(0)->coord);
	   };
	};
	glVertex3dv(st->c3->GetPoint(i)->coord);
	st->currentpolygone++;
	if (cpt>40) {
		RefreshGauge(st);
		cpt=0;
	};
	if(CheckSignal(SIGBREAKF_CTRL_D)) {
	    /*
	    st->c3->PutSemaphore();
	    if (st->m!=NULL) st->m->PutSemaphore();
	    */
	    // PutSemaphore();
	    return TRUE;
	};
    };
    glEnd();   
    /*
    st->c3->PutSemaphore();
    if (st->m!=NULL) st->m->PutSemaphore();
    */
    // PutSemaphore();
    return FALSE;
}

// Rotation
BOOL Rotation::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    double ra,x,y,z;

    if (st) st->currentnode++;
    rotation.Get(x,y,z,ra);
    glRotated(ra/0.017447,x,y,z);
    // PutSemaphore();
    return FALSE;
}
// Scale
BOOL Scale::DrawGL(VRMLState *st) {
    // GetSemaphore();
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    if (st) st->currentnode++;
    double x,y,z;
    scaleFactor.Get(x,y,z);
    glScaled(x,y,z);
    PutSemaphore();
    return FALSE;
}
// Separator
BOOL Separator::DrawGL(VRMLState *st) {
    // GetSemaphore();
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    if (st) st->currentnode++;
    // puts(">In Separator DrawGL");
    glPushMatrix(); // Push the current position
    state = *(st);
    for (int i=0;i<Size();i++) {
	if (GetChild(i)->DrawGL(st)) {
	    glPopMatrix();
	    return TRUE;
	};
    };
    glPopMatrix();
    int cn=st->currentnode;
    int cp=st->currentpolygone;
    * (st) = state;
    st->currentnode=cn;
    st->currentpolygone=cp;
    // puts("<Separator GL");
    PutSemaphore();
    return FALSE;
}
// ShapeHints
BOOL ShapeHints::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    if (st) st->currentnode++;
    if (vertexOrdering==CLOCKWISE) {
	glFrontFace(GL_CW);
    }
    else {
	glFrontFace(GL_CCW);
    };
    /*
    if (shapeType==SOLID) {
	glCullFace(GL_FRONT);
	glEnable(GL_CULL_FACE);
    }
    else {
	glDisable(GL_CULL_FACE);
    };
    */
    return FALSE;
}
// Sphere
BOOL Sphere::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    int i=0,j=0,cpt=0;
    Mat *cm=NULL;
    Mat *white=NULL;
    double cosha=0.0,cosha2=0.0,costa=0.0,costa2=0.0,sinta=0.0,sinta2=0.0;
    double tdx=1.0/st->sphereres,tdy=1.0/(st->sphereres/2.0),ttx=0.0,tty=1.0;
    double hangle=0.0,tangle=0.0,angle=2.0*3.1415/st->sphereres,x=0.0,y=0.0,z=0.0;
    #ifdef __GNUC__
    Vertex3d p1=Vertex3d();
    Vertex3d p2=Vertex3d();
    Vertex3d p3=Vertex3d();
    Vertex3d p4=Vertex3d();
    #else
    Vertex3d p1(),p2(),p3(),p4();
    #endif

    // if (st->glcontext->fh) {
	// FPrintf(st->glcontext->fh,"Sphere::DrawGL\n");
    // };
    if (st) {
	st->currentnode++;
    };

    if (st->m==NULL) {
	white=new Mat();
	cm=white;
    }
    else {
	cm=st->m->GetMaterial(0);
    };
    cm->DrawGL(st->glcontext);

    //--- texture ---
    if (st->t) {
	st->t->InitGLTexture(st->glcontext);
    };

    hangle=(3.14/2.0);
    for (j=0;j<st->sphereres/2;j++) {
	tangle=(3.14/2.0);
	for (i=0;i<st->sphereres;i++) {
	    glBegin(GL_QUADS);
		cosha=cos(hangle);
		cosha2=cos(hangle+angle);
		costa=cos(tangle);
		costa2=cos(tangle+angle);
		sinta=sin(tangle);
		sinta2=sin(tangle+angle);

		// Point 1 (Up)
		x=costa*radius*fabs(cosha);
		z=sinta*radius*fabs(cosha);
		y=sin(hangle)*radius;
		glNormal3d(x/radius,y/radius,-z/radius);
		glTexCoord2d(ttx,tty);
		glVertex3d(x,y,-z);

		// Point 2 (Up)
		x=costa2*radius*fabs(cosha);
		z=sinta2*radius*fabs(cosha);
		glNormal3d(x/radius,y/radius,-z/radius);
		glTexCoord2d(ttx+tdx,tty);
		glVertex3d(x,y,-z);
		
		// Point 3 (Down)
		x=costa2*radius*fabs(cosha2);
		z=sinta2*radius*fabs(cosha2);
		y=sin(hangle+angle)*radius;
		glNormal3d(x/radius,y/radius,-z/radius);
		glTexCoord2d(ttx+tdx,tty-tdy);
		glVertex3d(x,y,-z);

		x=costa*radius*fabs(cosha2);
		z=sinta*radius*fabs(cosha2);
		glNormal3d(x/radius,y/radius,-z/radius);
		glTexCoord2d(ttx,tty-tdy);
		glVertex3d(x,y,-z);
	     glEnd();
	     tangle+=angle;
	     ttx+=tdx;
	     if (st) {
		st->currentpolygone+=1;
	     };
	     if (cpt>10) {
		 RefreshGauge(st);
		 cpt=0;
	     };
	     cpt=cpt++;
	};
	hangle+=angle;tty-=tdy;
	if(CheckSignal(SIGBREAKF_CTRL_D)) {
	    return TRUE;
	};
    };




    /*
    for (i=0;i<st->sphereres;i++) {
	for (j=0;j<st->sphereres;j++) {
	    costeta=cos(tteta);
	    sinteta=sin(tteta);
	    cosphi=cos(tphi);
	    sinphi=sin(tphi);

	    glBegin(GL_QUADS);
		p1.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
		glNormal3dv(p1.coord);
		glTexCoord2d(ttx,tty);
		glVertex3dv(p1.coord);

		tteta+=teta;ttx+=td;
		sinteta=sin(tteta);
		costeta=cos(tteta);
		p2.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
		glNormal3dv(p2.coord);
		glTexCoord2d(ttx,tty);
		glVertex3dv(p2.coord);

		tphi+=phi;tty-=td;
		cosphi=cos(tphi);
		sinphi=sin(tphi);
		p3.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
		glNormal3dv(p3.coord);
		glTexCoord2d(ttx,tty);
		glVertex3dv(p3.coord);

		tteta-=teta;ttx-=td;
		sinteta=sin(tteta);
		costeta=cos(tteta);
		p4.Set(radius*sinphi*costeta,radius*sinphi*sinteta,radius*cosphi);
		glNormal3dv(p4.coord);
		glTexCoord2d(ttx,tty);
		glVertex3dv(p4.coord);
	    glEnd();

	    if (st) {
		st->currentpolygone+=4;
	    };
	    RefreshGauge(st);
	    tteta+=teta;ttx+=td;
	    tphi-=phi;tty+=td;
	    
	    if(CheckSignal(SIGBREAKF_CTRL_D)) {
		// if (st->glcontext->fh) {
		//     FPrintf(st->glcontext->fh,"breaked\n");
		// };
		return TRUE;
	    };
	};
	tphi+=phi;tty-=td;
	tteta=0.0;ttx=0.0;
    };
    */
    if (white) delete white;
    RefreshGauge(st);
    // if (st->glcontext->fh) {
    //     FPrintf(st->glcontext->fh,"not breaked => out\n");
    // };
    return FALSE;
}
// SpotLight
BOOL SpotLight::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    if (st) st->currentnode++;
    float amb[4];
    float pos[4];
    float dir[3];
    GLenum LightNum;

    switch (st->lightsource) {
	case 0:LightNum=GL_LIGHT0;break;
	case 1:LightNum=GL_LIGHT1;break;
	case 2:LightNum=GL_LIGHT2;break;
	case 3:LightNum=GL_LIGHT3;break;
    };
    amb[0]=intensity;
    amb[1]=intensity;
    amb[2]=intensity;
    amb[3]=1.0;
    pos[0]=point.coord[0];
    pos[1]=point.coord[1];
    pos[2]=point.coord[2];
    pos[3]=point.coord[3];
    dir[0]=direction.coord[0];
    dir[1]=direction.coord[1];
    dir[2]=direction.coord[2];
    if (on==TRUE) {glEnable(LightNum);}
    else {glDisable(LightNum);};
    glLightfv(LightNum, GL_POSITION, pos);
    glLightfv(LightNum, GL_DIFFUSE, color.rgb);
    glLightfv(LightNum, GL_AMBIENT, amb);
    glLightfv(LightNum, GL_SPOT_DIRECTION, dir);
    glLightf(LightNum, GL_SPOT_CUTOFF, (360*cutOffAngle)/2*3.14);
    glLightf(LightNum, GL_SPOT_EXPONENT, dropOffRate);
    st->lightsource++;
    return FALSE;
}
// Switch
BOOL Switch::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    if (whichChild!=-1) {
	return (GetChild(whichChild)->DrawGL(st));
    };
    return FALSE;

}
// Texture
BOOL Texture2::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    // GLuint texname;
    
    if (st) st->currentnode++;
    ScaleImage(st->glcontext);
    st->t=this;
    return FALSE;
}
void Texture2::InitGLTexture(struct GLContext *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int glwraps=GL_REPEAT,glwrapt=GL_REPEAT;

    if (image) {
	puts("in realinti");
	if (wrapS==TEXTURE2_WRAP_CLAMP) glwraps=GL_CLAMP;
	if (wrapT==TEXTURE2_WRAP_CLAMP) glwrapt=GL_CLAMP;
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, glwraps);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, glwrapt);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri_stub(glcontext,GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexImage2D_stub(glcontext,GL_TEXTURE_2D,0,GL_RGB, width, height,0,GL_RGB,GL_UNSIGNED_BYTE,image);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
    };
    // puts("Texture2::InitGLTexture");
}
int Texture2::ScaleImage(struct GLContext  *glcontext) {
    struct Library *glBase=glcontext->gl_Base;
    struct Library *gluBase=glcontext->glu_Base;
    struct Library *glutBase=glcontext->glut_Base;
    int nwidth=0,nheight=0,i=0,rep=0;
    UBYTE *nimage=NULL;

    puts("Rescaling image");
    do {
	nwidth=(int) pow(2,i);
	i++;
	// printf("nwidth:%d\n",nwidth);
    }
    while (nwidth<width);
    nwidth=(int) pow(2,i-1);
    i=0;
    do {
	nheight=(int) pow(2,i);
	i++;
	// printf("nheight:%d\n",nheight);
    }
    while (nheight<height);
    nheight=(int) pow(2,i-1);
    if ((nwidth==(width+(width%8)))&&
	(nheight==height)) return 0;
    nimage=(UBYTE *) malloc(nwidth*nheight*component);
    // puts("new image allocated");
    rep=gluScaleImage_stub(glcontext,GL_RGB,width,height,GL_UNSIGNED_BYTE,image,nwidth,nheight,GL_UNSIGNED_BYTE,nimage);
    puts("after the gluscale");
    free(image);
    image=nimage;
    width=nwidth;
    height=nheight;
    return rep;
}
// Texture2Transform
BOOL Texture2Transform::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    double cx,cy,sx,sy,tx,ty;
    if (st) st->currentnode++;

    glMatrixMode(GL_TEXTURE);
    glLoadIdentity();
    center.Get(cy,cy);
    glTranslated(-cx,-cy,0);
    scaleFactor.Get(sx,sy);
    glScaled(sx,sy,1);
    glRotatef(rotation/0.017447,0,0,1);
    glTranslated(cx,cy,0);
    translation.Get(tx,ty);
    glTranslated(tx,ty,0);
    glMatrixMode(GL_MODELVIEW);
    return FALSE;
}
// TextureCoordinate2
BOOL TextureCoordinate2::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    st->tc2=this;
    return FALSE;
}
// Transform
BOOL Transform::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;
    double tx,ty,tz,rx,ry,rz,ra,sx,sy,sz,sox,soy,soz,soa,cx,cy,cz;
    if (st) st->currentnode++;
    
    translation.Get(tx,ty,tz);
    glTranslatef(tx,ty,tz);
    rotation.Get(rx,ry,rz,ra);
    glRotatef(ra/0.017447,rx,ry,rz);
    scaleOrientation.Get(sox,soy,soz,soa);
    glRotatef(soa/0.017447,sox,soy,soz);
    scaleFactor.Get(sx,sy,sz);
    glScalef(sx,sy,sz);
    glRotatef(-soa/0.017447,sox,soy,soz);
    center.Get(cx,cy,cz);
    glTranslatef(-cx,-cy,-cz);
    /*
    // glTranslated(cx,cy,cz);
    // glRotated(ra/0.017447,rx,ry,rz);
    // glRotated(soa/0.017447,sox,soy,soz);
    // glScaled(sx,sy,sz);
    // glRotated(-soa/0.017447,sox,soy,soz);
    // glTranslated(-cx,-cy,-cz);
    */
    return FALSE;
}
// TransformSeparator
BOOL TransformSeparator::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    if (st) st->currentnode++;
    glPushMatrix(); // Push the current position
    for (int i=0;i<Size();i++) {
	// puts("In loop");
	if (GetChild(i)->DrawGL(st)) {
	    glPopMatrix();
	    return TRUE;
	};
    };
    glPopMatrix();
    return FALSE;
}
// Translation
BOOL Translation::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    if (st) st->currentnode++;
    double x,y,z;
    translation.Get(x,y,z);
    glTranslated(x,y,z);
    return FALSE;
}
// WWWAnchor
BOOL WWWAnchor::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glcontext->gl_Base;
    struct Library *gluBase=st->glcontext->glu_Base;
    struct Library *glutBase=st->glcontext->glut_Base;

    if (st) st->currentnode++;
    glPushMatrix(); // Push the current position
    state= *(st);
    for (int i=0;i<Size();i++) {
	// puts("In loop");
	if (GetChild(i)->DrawGL(st)) {
	    glPopMatrix();
	    return TRUE;
	};
    };
    glPopMatrix();
    int cn=st->currentnode;
    int cp=st->currentpolygone;
    * (st) = state;
    st->currentnode=cn;
    st->currentpolygone=cp;
    return FALSE;
}
// WWWInline
BOOL WWWInline::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    if (in) return(in->DrawGL(st));
}

// USE
BOOL USE::DrawGL(VRMLState *st) {
    if (st) st->currentnode++;
    if (reference!=NULL) return(reference->DrawGL(st));
};
