#include <math.h>

#ifdef USE_CYBERGL
#define SHARED
#include <cybergl/cybergl.h>
#include <cybergl/display.h>
#include <proto/cybergl.h>
#else
#include <proto/Amigamesa.h>
#include "StormMesaSupport.h"
#endif

#include "VRMLNode.h"

BOOL Cube::DrawGL(VRMLState *st) {
    struct Library *glBase=st->glbases.gl_Base;
    struct Library *gluBase=st->glbases.glu_Base;
    struct Library *glutBase=st->glbases.glut_Base;
    double w=width/2;
    double h=height/2;
    double d=depth/2;
    float r[6],g[6],b[6];
    // double cog[4]={0,0,0,1};
    Mat *cm[6];
    Mat *white=NULL; // =new Mat();
    GLubyte checkImage[64][64][3];
    int i,j,c;

    for (i=0;i<64;i++) {
	for (j=0;j<64;j++) {
	    c=((((i&0x8)==0)^((j&0x8))==0))*255;
	    checkImage[i][j][0]= (GLubyte) c;
	    checkImage[i][j][1]= (GLubyte) c;
	    checkImage[i][j][2]= (GLubyte) c;
	};
    };

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

	//--- texture ? ---
	/*
	if (st->t) {
	    st->t->InitGLTexture(st->glbases);
	};
	*/
	// glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	// glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexImage2D_stubs (st->glbases, GL_TEXTURE_2D,0,GL_RGB, 64, 64, 0,GL_RGB,GL_UNSIGNED_BYTE,checkImage);
	// glTexImage2D_stub(st->glbases,checkImage);

	// glEnable(GL_TEXTURE_2D);

	//--- Faces ---
	glBegin(GL_QUADS);
	    //          x y z
	    glNormal3d (0.0,0.0,-1.0);  // Au fond Second
	    cm[1]->DrawGL(st->glbases);
	    // glColor3d(r[1],g[1],b[1]);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(-w,-h,-d);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(-w,h,-d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(w,h,-d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(w,-h,-d);

	    glNormal3d (-1.0,0.0,0.0);  // A gauche Third
	    cm[2]->DrawGL(st->glbases);
	    // glColor3d(r[2],g[2],b[2]);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(-w,-h,-d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(-w,-h,d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(-w,h,d);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(-w,h,-d);

	    glNormal3d (1.0,0.0,0.0);  // A droite Forth
	    cm[3]->DrawGL(st->glbases);
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
	    cm[0]->DrawGL(st->glbases);
	    // glColor3d(r[0],g[0],b[0]);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(-w,-h,d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(w,-h,d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(w,h,d);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(-w,h,d);

	    glNormal3d (0.0,1.0,0.0); // Haut Fifth
	    cm[4]->DrawGL(st->glbases);
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
	    cm[5]->DrawGL(st->glbases);
	    // glColor3d(r[5],g[5],b[5]);
	    glTexCoord2f(0.0,0.0);
	    glVertex3d(-w,-h,-d);
	    glTexCoord2f(1.0,0.0);
	    glVertex3d(w,-h,-d);
	    glTexCoord2f(1.0,1.0);
	    glVertex3d(w,-h,d);
	    glTexCoord2f(0.0,1.0);
	    glVertex3d(-w,-h,d);
	glEnd();

	// glDisable(GL_TEXTURE_2D);

	if (white) delete white;
	RefreshGauge(st);
	// PutSemaphore();
	return FALSE;
}
