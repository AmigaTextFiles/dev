/*-----------------------------------------------------
  VRMLSupport.cc
  Version: 0.3
  Date: 5 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Fonction to call to load a VRML/GEO world
	Interface with this fonction to load a file
-----------------------------------------------------*/
#include <libraries/mui.h>

#include "VRMLSupport.h"

#include "VRMLParser.h"
#include "VRMLSaver.h"
#include "VRML2Saver.h"
#include "OpenGLSaver.h"
#include "MWSaver.h"
#include "GEOParser.h"
#include "GLConvert.h"
#include "NProducer.h"
#include "VRMLExtractor.h"

/*-------------------------------
  - Check the type of the file  -
  -------------------------------*/
VRMLStatus CheckType (char *filename) {
   char temp[255];
   FILE *fd=NULL;

   // printf("filename:%s\n",filename);
   fd=fopen(filename,"r");
   if (fd==NULL) {
	return notfound;
   };
   fread(temp,1,16,fd);
   temp[16]='\0';
   // printf("temp[0]=%x\n",temp[0]);
   // printf("temp[1]=%x\n",(BYTE) temp[1]);
   // printf("temp[2]=%x\n",temp[2]);
   // printf("temp[3]=%x\n",temp[3]);
   if (!strcmp(temp,"#VRML V2.0 utf8 \n")) {
	fclose(fd);
	return v2;
   }
   else if (!strcmp(temp,"#VRML V1.0 ascii")) {
	fclose(fd);
	return v1;
   }
   else if (!strncmp(temp,"3DG1",4)) {
	fclose(fd);
	return geo;
   }
   else if (!strncmp(temp,"3DB1",4)) {
       fclose(fd);
       return geobin;
   }
   else if ((temp[0]==0x1f)&&
	    (temp[1]==0xffffff8b)&&
	    (temp[2]==0x08)&&
	    (temp[3]==0x08)) {
       fclose(fd);
       return gzip;
   }
   else {
	fclose(fd);
	return novrml;
   };
}

/*--------------------------------------
  - Load VRML via an VRMLParser object -
  --------------------------------------*/
VRMLGroups *LoadVRML(LoadVRMLParams *par, char *filename) {
    VRMLParser VP=VRMLParser(par);
    // VRMLGroups *mg=NULL;
    // FILE *fd=NULL;
    
    // puts("===>In VRMLSupport::LoadVRML");
    // printf("filename:%s\n",filename);
    /*
    fd=fopen(filename,"r");
    if (fd==NULL) {
	// puts("Error opening file");
	return NULL;
    };
    */
    /*
    if (gauge) {
	SetAttrs((Object *) gauge->Gauge, MUIA_Gauge_Max, 0);
	SetAttrs((Object *) gauge->Txt, MUIA_Text_Contents, "Parsing VRML V1.0 ascii file");
	SetAttrs((Object *) gauge->Win, MUIA_Window_Open, TRUE);
    };
    */
    return VP.LoadVRML_V1(filename);
    /*
    if (gauge) {
	SetAttrs((Object *) gauge->Win, MUIA_Window_Open, FALSE);
    };
    */
    // fclose (fd);
    // puts("<===Out VRMLSupport::LoadVRML");
    // return mg;
}
/*---- ----------------------------
  - Save a VRML V1.0 ascii world -
  --------------------------------*/
VRMLStatus SaveVRML(SaveVRMLParams *sp,char *filename, VRMLNode *n) {
    VRMLSaver VS=VRMLSaver(sp);
    FILE *fd=NULL;
    
    puts("==>SaveVRML");
    fd=fopen(filename,"w");
    if (fd==NULL) {
	return notfound;
    };
    fprintf(fd,
	    "#VRML V1.0 ascii\n"
	    "# Generated on Amiga conputers with " VRMLSAVER_VERSION " Beta\n"
	    "# Written by BODMER Stephan (bodmer2@uni2a.unige.ch)\n"
	    "# VRMLEditor is Copyright(1997/98) by BodySoft\n"
	    "#----------------------------------------------------\n\n");
    puts("fprintf passed");
    VS.WriteVRML_V1(fd,n);
    puts("<==WriteVRML1 finished");
    fclose(fd);
    return saved;
}

/*---------------------------------
  - Save a VRML V2.0 utf8 world -
  --------------------------------*/
VRMLStatus SaveVRML2(SaveVRMLParams *sp,char *filename, VRMLNode *n) {
    VRML2Saver VS=VRML2Saver(sp);
    FILE *fd=NULL;

    puts("==>SaveVRML2");
    fd=fopen(filename,"w");
    if (fd==NULL) {
	return notfound;
    };
    fprintf(fd,
	    "#VRML V2.0 utf8\n"
	    "# Generated on Amiga conputers with " VRMLSAVER_VERSION " Beta\n"
	    "# Written by BODMER Stephan (bodmer2@uni2a.unige.ch)\n"
	    "# VRMLEditor is Copyright(1997/98) by BodySoft\n"
	    "#----------------------------------------------------\n\n");
    VS.WriteVRML_V2(fd,n);
    puts("<==WriteVRML2 finished");
    fclose(fd);
    return saved;
}

/*---------------------------------
  - Function to load a GEO file   -
  ---------------------------------*/
VRMLGroups *LoadGEO(MUIGauge *gauge,char *filename, FILE *pfd, int pt) {
    GEOParser GP=GEOParser();
    VRMLGroups *mg=NULL;
    FILE *fd=NULL;
    

    // puts("===>In VRMLSupport::LoadGEO");
    fd=fopen(filename,"r");
    if (fd==NULL) {
	return NULL;
    };
    mg=GP.LoadGEO(gauge,fd,pfd,pt);
    fclose (fd);
    // puts("<===Out VRMLSupport::LoadGEO");
    return mg;
}

VRMLStatus SaveGEO(MUIGauge *gauge,char *filename, VRMLNode *n) {
    return saved;
}

VRMLStatus SaveOpenGL(SaveOpenGLParams *sp,char *filename, VRMLNode *n) {
    OpenGLSaver GLS=OpenGLSaver(sp);
    FILE *fd=NULL;

    fd=fopen(filename,"w");
    if (fd==NULL) {
	return notfound;
    };
    /*
    if (sp->Win) {
	SetAttrs((Object *) sp->Gauge, MUIA_Gauge_Max,0);
	SetAttrs((Object *) sp->Gauge, MUIA_Gauge_Current,0);
	SetAttrs((Object *) sp->Txt, MUIA_Text_Contents, "Saving OpenGL 'C' source code");
	SetAttrs((Object *) sp->Win, MUIA_Window_Open, TRUE);
    };
    */
    fprintf(fd,
	    "/*------------------------------------------------------\n"
	    "  -OpenGL source code                                  -\n"
	    "  -Generated with " OPENGLSAVER_VERSION " Beta (on Amiga)    -\n"
	    "  -Written by BODMER Stephan (bodmer2@uni2a.unige.ch)  -\n"
	    "  -VRMLEditor is Copyright(1997/98) by BodySoft        -\n"
	    "  ------------------------------------------------------*/\n"
	    "void DrawGLScene() {\n");
    GLS.WriteOpenGL(fd,n);
    // fprintf(fd,"glFlush();\n");
    fprintf(fd,"}\n");
    /*
    if (sp->Win) {
	SetAttrs((Object *) sp->Win, MUIA_Window_Open, FALSE);
    };
    */
    fclose(fd);
    // puts("End");
    return saved;
}

VRMLStatus SaveMW(SaveMWParams *sp, char *filename, VRMLNode *node) {
    MWSaver MWS=MWSaver(sp);

    // puts("before WriteMW");
    return MWS.WriteMW(filename,node);
    // puts("after WriteMW");
    // return 0;
}

//---------------------------------------- Convert VRML to GLNodes ----------------------------
GLNode *ConvertVRML2GL(GLConvertParams *cp, VRMLNode *n) {
    GLConvert CV=GLConvert(cp);
    GLNode *gln=NULL;

    // puts("=>In ConvertVRML2GL");
    /*
    if (cp->Win) {
	SetAttrs((Object *) cp->Txt, MUIA_Text_Contents, "Converting into GL primitives");
	SetAttrs((Object *) cp->Gauge, MUIA_Gauge_Current,0);
	SetAttrs((Object *) cp->Win, MUIA_Window_Open, TRUE);
    };
    */
    gln=CV.ConvertVRML(n);
    /*
    if (cp->Win) {
	SetAttrs((Object *) cp->Win, MUIA_Window_Open, FALSE);
    };
    */
    // puts("<=ConvertVRML2GL");
    return gln;
}

Normal *ProduceNormalNode(ProduceNormalParams *par, Coordinate3 *c3, VRMLNode *node) {
    if ((c3==NULL)||(node==NULL)) return NULL;
    // puts("creating NProducer object");
    NProducer NP=NProducer(par,c3,node);
    // puts("begining to produce normal");
    Normal *n=NP.ProduceNormal();
    return n;
}

VRMLNode *Extract(VRMLNode *n,char *name,PList<VRMLCameras> *cl) {
    VRMLExtractor EX=VRMLExtractor(n);
    VRMLNode *node=NULL;

    if (name) {
	node=EX.FindNode(name);
    };
    if (cl) {
	EX.ExtractCameras(cl);
    };
    return node;
}
