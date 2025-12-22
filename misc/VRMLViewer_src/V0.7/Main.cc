/*----------------------------------------------------
  Main.cc (VRMLViewer)
  Version 0.7
  Date: 8.8.1999
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: THIS IS THE MAIN PART
	Contains all callback functions via hooks
	GCC/StormC Port
-----------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/asl.h>
#include <proto/dos.h>
#include <proto/muimaster.h>

#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <cybergraphx/cybergraphics.h>
#include <intuition/intuition.h>
#include <utility/tagitem.h>
#include <libraries/mui.h>
#include <mui/GLArea_mcc.h>

#include <useful/Conversion.h>
#include <useful/Misc.h>

#include "Main.h"
#include "MUI_VRMLViewer.h"

#include "VRMLNode.h"
#include "VRMLSupport.h"
#include "GLConvert.h"

#include "GLFunctions.h"


extern struct ExecBase *SysBase;
// extern struct Library *glBase;
// extern struct Library *gluBase;
//extern struct Library *glutBase;

// extern struct Library *gleBase;
struct Library *MUIMasterBase=NULL;
struct Library *CyberGfxBase=NULL;
struct Library *MeshWriterBase=NULL;

#ifdef __GNUC__
int __openliberror;
unsigned long __stack ={320000};
struct Library *glBase=NULL;
struct Library *gluBase=NULL;
struct Library *glutBase=NULL;
struct GLContext glcontext;

// struct Library *AslBase=NULL;
// struct Library *IntuitionBase=NULL;
// struct Library *DOSBase=NULL;

// extern "C" ULONG GLArea_Dispatcher();
#endif
#ifdef __STORM__
extern struct Library *glBase;
extern struct Library *gluBase;
extern struct Library *glutBase;
// extern struct Library *CyberGLBase;
// extern struct Library *AslBase;
// extern struct Library *IntuitionBase;
// extern struct Library *DOSBase;
#endif

// MUI objects
struct ObjApp *MyApp=NULL;

// Run-time settings
int nbcameras=0;
ULONG winid=0;
BOOL anim=FALSE;
FNames  FileName;
FILE *parserfd=NULL;
SharedVariables sh;
struct Screen *RenderScreen=NULL,*oldscreen=NULL;

//--- Globale objects ---
GLNode *glnode=NULL;

// Globale state variables
Prefs settings;
WorldInfos winfo;
MUIGauge gauge;
BOOL changedglnode=FALSE;
BOOL changedglmode=FALSE;
BOOL changedcolor=FALSE;
PList<VRMLCameras> *camlist=NULL;
PList<GLVertex3d> *glc=NULL;
PList<GLMaterial> *glm=NULL;
PList<GLVertex3d> *gln=NULL;
PList<GLVertex2d> *gltc=NULL;

// CyberGL output variables
int pm; // mouse event
int pr; // drawing refresh
int pp; // polygone filling

// extern variable form GLFunctions
extern GLCamera mycamera;

// Protos
// void ChangeCamera();

//-----------------------------------------USEFUL FUNCTION--------------------------------------
/*---------------------------------
  Function to load a VRMLV1 file
-----------------------------------*/
void LoadIt (char *filename) {
    char temp[255];
    BOOL ramfile=FALSE;
    VRMLGroups *world=NULL;
    VRMLCameras *cam=NULL;
    VRMLState state=VRMLState();
    GLConvertParams cp={MyApp->App,MyApp->WI_Main,settings.angle,&state,glc,glm,gln,gltc};
    LoadVRMLParams lp={MyApp->App,MyApp->WI_Main,parserfd,settings.msgmode,settings.resolve};
    int rep=-1;
    GLNode *cglnode=NULL;
    VRMLStatus status;
    state.coneres=settings.coneres;
    state.cylinderres=settings.cylinderres;
    state.sphereres=settings.sphereres;
    // printf("conres:%d\n",mymsg.state->coneres);

    status=CheckType(filename);
    if (status==gzip) {
	sprintf(temp,"%s -d %s -c >RAM:Temp.wrl",settings.gzip,FileName.Complete);
	rep=System(temp,NULL);
	if (rep==-1) {
	    MUI_Request(MyApp->App,MyApp->WI_Main,0,"Error","Ok","Error when un-gzipping file");
	    return;
	};

	// cglnode=LoadIt("ram:Temp.wrl");
	// System("delete ram:Temp.wrl",NULL);
	// return cglnode;
	strcpy(filename,"ram:Temp.wrl");
	status=CheckType(filename);
    };

    if (status==notfound) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Loading error","Ok",
			 "File not found");
    }
    else if (status==v1) {
	// puts("VRML V1.0 found");
	world=LoadVRML(&lp,filename);
	if (world) {
	    world->Browse(&state);
	    // printf("totalpolygones:%d\n",mymsg.totalpolygones);
	    winfo.polygones=state.totalpolygones;
	    winfo.materials=state.totalmaterials;
	    winfo.lightsources=state.totallights;
	    /*
	    puts("VRML WORLD loaded");
	    puts("Before convert");
	    */
	    glc->ClearList();
	    glm->ClearList();
	    gln->ClearList();
	    gltc->ClearList();
	    camlist->ClearList();
	    delete glnode;

	    glnode=ConvertVRML2GL(&cp,(VRMLNode *) world);

	    /*
	    printf("In PList<GLCoordinate>:%d GLCoorinate objects\n",glc->Length());
	    printf("In first GLCoordinate:%d points\n",glc->Get(0)->numpoints);
	    */

	    if (glnode) {
		// puts("GLNODE  not NULL");
		// puts("after the Convert2gl");
		// camlist->ClearList();
		// puts("Clearlist passed");
		Extract((VRMLNode *) world,NULL,camlist);
		// puts("Extracted");
		// SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Open, FALSE);
		SetAttrs((Object *) MyApp->TX_Msg, MUIA_Text_Contents, "Cleaning up world");
		SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Open, TRUE);
		// puts("what's the problem");
		if (world) delete world;
		SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Open, FALSE);
		DoMethod((Object *) MyApp->LV_Cameras, MUIM_List_Clear);
		DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Init);
		DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Reset);
		if (camlist->Length()!=0) {
		    for (int i=0;i<camlist->Length();i++) {
			cam=camlist->Get(i);
			// printf("cam:%d %s\n",i,cam->GetName());
			DoMethod((Object *) MyApp->LV_Cameras, MUIM_List_InsertSingle, cam->GetName(), MUIV_List_Insert_Bottom);
			SetAttrs((Object *) MyApp->PO_Cameras, MUIA_Disabled, FALSE);
			DoMethod((Object *) MyApp->PO_Cameras, MUIM_Popstring_Close, TRUE);
		    };
		    mycamera=InitCamera(camlist->Get(0),&glcontext);
		    // InitProjection(camlist->Get(0));
		    SetAttrs((Object *) MyApp->TXT_PO_Cameras, MUIA_Text_Contents, camlist->Get(0)->GetName());
		}
		else {
		    SetAttrs((Object *) MyApp->TXT_PO_Cameras, MUIA_Text_Contents, "None");
		    SetAttrs((Object *) MyApp->PO_Cameras, MUIA_Disabled, TRUE);
		};
		// puts("init passed");
		// puts("reset passed");
		DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	    };

	};
	// puts("out of load()");
    }
    else if (status==v2) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Wrong format","Ok",
		     "This file is a VRML V2.0 utf8 format !");
    }
    else  {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Wrong format","Ok",
		     "This file is not a VRML V1.0 ascii file !");
    };
}
//------------------------------------------------------------------------------------------
//------------------------------------APPLICATION WINDOWS HANDLING--------------------------
//------------------------------------------------------------------------------------------
/*-------------------------
   Position Window
--------------------------*/
void RefreshCoord() {
    char temp[255];
    sh.mode=SYSTEM;
    // puts("In refreshcoord");
    ftoa(mycamera.X,temp);
    SetAttrs((Object *) MyApp->STR_X, MUIA_String_Contents, temp);
    ftoa(mycamera.Y,temp);
    SetAttrs((Object *) MyApp->STR_Y, MUIA_String_Contents, temp);
    ftoa(mycamera.Z,temp);
    SetAttrs((Object *) MyApp->STR_Z, MUIA_String_Contents, temp);
    ftoa(mycamera.heading,temp);
    SetAttrs((Object *) MyApp->STR_Heading, MUIA_String_Contents, temp);
    ftoa(mycamera.pitch,temp);
    SetAttrs((Object *) MyApp->STR_Pitch, MUIA_String_Contents, temp);
    sh.mode=USER;
}
void PositionCmd(Object *obj) {
    ULONG store;
    // puts("PositionCmd");
    if (obj==MyApp->STR_X) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_X, &store);
	mycamera.X=atof((char *) store);
    }
    else if (obj==MyApp->STR_Y) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Y, &store);
	mycamera.Y=atof((char *) store);
    }
    else if (obj==MyApp->STR_Z) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Z, &store);
	mycamera.Z=atof((char *) store);
    }
    else if (obj==MyApp->STR_Heading) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Heading, &store);
	mycamera.heading=atof((char *) store);
    }
    else if (obj==MyApp->STR_Pitch) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Pitch, &store);
	mycamera.pitch=atof((char *) store);
    };
    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
};
/*-----------------------
	MAIN WINDOW
-------------------------*/
void MainWindowCmd(Object *obj) {
    GLNode *cglnode=NULL;
    ULONG store=0;

    // puts("Mainwindowcmd");
    if (obj==MyApp->STR_PA_MainFile) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PA_MainFile, &store);
	strcpy(FileName.Complete,(char *) store);
	LoadIt(FileName.Complete);
	// puts("after the delete");
	/*
	cglnode=LoadIt(FileName.Complete);
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Init);
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Reset);
	if (cglnode) {
	    puts("loaded glnode not NULL");
	    if (glnode) delete glnode;
	    glnode=cglnode;
	    //--------------- Select first cameras if not NULL --------------------
	    if (camlist->Length()!=0) {
		mycamera=InitCamera(camlist->Get(0));
		// InitProjection(camlist->Get(0));
		SetAttrs((Object *) MyApp->TXT_PO_Cameras, MUIA_Text_Contents, camlist->Get(0)->GetName());
	    };
	};
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	*/
    }
    else if (obj==MyApp->CY_Polygone) {
	GetAttr(MUIA_Cycle_Active,(Object *) MyApp->CY_Polygone, &store);
	switch ((int) store) {
	    case 0:pp=SMOOTH;break;
	    case 1:pp=FLAT;break;
	    case 2:pp=WIRE;break;
	    case 3:pp=POINTS;break;
	    case 4:pp=WIREFRAME;break;
	    case 5:pp=BOUNDINGBOX;break;
	    case 6:pp=TRANSPARENT;break;
	    case 7:pp=TEXTURED;break;
	};
	// DrawMode();
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	// DrawScene();
    }
    else if (obj==MyApp->CY_Mode) {
	// SetCameraAndOrientation(cx,cy,cz,mycamera.heading,mycamera.pitch,0);
	GetAttr(MUIA_Cycle_Active,(Object *) MyApp->CY_Mode, &store);
	switch ((int) store) {
	    case 0:pm=ROTATE;break;
	    case 1:pm=SLIDE;break;
	    case 2:pm=TURN;break;
	    case 3:pm=FLY;break;
	};
    }
    else if (obj==MyApp->CH_Filled) {
	// puts("MainFilled");
	GetAttr(MUIA_Selected,(Object *) MyApp->CH_Filled, &store);
	switch ((BOOL) store) {
	    case TRUE:pr=PLAIN;break;
	    case FALSE:pr=BOX;break;
	};
    }
    else if (obj==MyApp->CH_Animated) {
	GetAttr(MUIA_Selected, (Object *) MyApp->CH_Animated, &store);
	switch ((BOOL) store) {
	    case TRUE:anim=TRUE;break;
	    case FALSE:anim=FALSE;break;
	};
    }
    else if (obj==MyApp->BT_MainReset) {
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Reset);
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	RefreshCoord();
	// puts("Back to Reset");
	// DrawScene();
    }
    else if (obj==MyApp->BT_MainRefresh) {
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    }
    else if (obj==MyApp->BT_MainBreak) {
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Break);
    };
}

void NotImplemented() {
    MUI_Request (MyApp->App,MyApp->WI_Main,0,"Not implemented","Ok",
		 "\033cThis function is not implemented\n"
		 "Wait for a new version...\n\n"
		 "...well... can you wait a long time ?");
    // return;
}

// Callbacks
void ChangeCamera () {
    ULONG store;
    VRMLCameras *cam=NULL;
    GLCamera sourcecamera,destcamera;
    // if (sh.mode==SYSTEM) return;

    // printf("ChangeCamera\n");
    GetAttr(MUIA_List_Active,(Object *) MyApp->LV_Cameras, &store);
    if (store!=-1) {
	cam=camlist->Get(store);
	SetAttrs((Object *) MyApp->TXT_PO_Cameras, MUIA_Text_Contents, cam->GetName());
	// DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Break);
	SetAttrs((Object *) MyApp->AR_CyberGLArea, MUIA_GLArea_DrawFunc, MoveCamera);
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	SetAttrs((Object *) MyApp->AR_CyberGLArea, MUIA_GLArea_DrawFunc, DrawScene);
	// DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    };
    /*
    if (camlist->Length()==0) return;
    sourcecamera=mycamera;
    cam=camlist->Get((int) store);
    destcamera=InitCamera(cam);
    InitProjection(cam);
    // angleX=0;oldangleX=0;
    // angleY=0;oldangleY=0;
    if (anim) {
	CameraAnim (sourcecamera,destcamera,10);
    };
    mycamera=destcamera;
    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    RefreshCoord();
    */
}
/*---------------------------
  Main Window
-----------------------------*/
void MenuCmd(Object *obj) {
    ULONG store=0;
    char temp[255];

    if (obj==MyApp->MNProjectAbout) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"About","Ok",
		 "\033cVRMLViewer\n"
		 "Version 0.7 Beta (" __DATE__")\n"
		 "Written by Bodmer Stephan\n"
		 "[sbodmer@lsi-media.ch]\n\n"
		 "Copyright 1997/99 by LSI Media SàRL\n\n"
		 "This version is a BETA version\n\n"
		 "Only VRML V1.0 ascii world supported\n\n"
		 "If you use this viewer, e-mail me !");
    }
    else if (obj==MyApp->MNProjectAboutMUI) {
	DoMethod((Object *) MyApp->App, MUIM_Application_AboutMUI, MyApp->WI_Main);
    }
    else if (obj==MyApp->MNProjectWorldinfo) {
	sprintf(temp,"World infomation\n\nPolygones:%d\nMaterials:%d\nLightsources:%d\n",winfo.polygones,winfo.materials,winfo.lightsources);
	MUI_Request (MyApp->App, MyApp->WI_Main,0,"World info","Ok",temp);
    }
    else if (obj==MyApp->MNWinParseroutput) {
	if (parserfd==NULL) {
	    parserfd=fopen(settings.outcon,"w");
	    if (parserfd==NULL) {
		MUI_Request (MyApp->App, MyApp->WI_Main,0,"Parser output","OK",
			     "Can't open parser output...");
	    };
	}
	else {
	    fclose (parserfd);
	    parserfd=NULL;
	};
    }
    else if (obj==MyApp->MNPrefsFull) {
	if (RenderScreen==NULL) {
	    GetAttr(MUIA_Window_Screen,(Object *) MyApp->WI_Main, &store);
	    oldscreen=(struct Screen *) store;
	    GetAttr(MUIA_Window_ID,(Object *) MyApp->WI_Main, &winid);
	    // puts("first Closing window");
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Open, FALSE);
	    RenderScreen = OpenScreenTags (NULL,
				   SA_DisplayID, (ULONG) settings.displayID,
				   SA_Depth, settings.displayDepth,
				   SA_Type, PUBLICSCREEN,
				   SA_SharePens,TRUE,
				   SA_Title, "OpenGL render Screen",
				   TAG_DONE);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Screen, RenderScreen);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_ID, 0);

	    // SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Borderless, TRUE);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_SizeGadget, FALSE);
	    // SetAttrs((Object *) MyApp->AR_CyberGLArea, MUIA_GLArea_FullScreen, TRUE);
	    // SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_DragBar, FALSE);
	    // SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Backdrop, TRUE);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_TopEdge, 0);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_LeftEdge, 0);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Width, MUIV_Window_Width_Screen(100));
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Height, MUIV_Window_Height_Screen(100));

	    // puts("first before re-opening");
	    // Delay(10);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Open, TRUE);
	}
	else {
	    // puts("second Closing window");
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Open, FALSE);
	    // puts("Closing screen");
	    CloseScreen(RenderScreen);
	    RenderScreen=NULL;
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_SizeGadget, TRUE);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Screen, oldscreen);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_ID, winid);
	    // SetAttrs((Object *) MyApp->AR_CyberGLArea, MUIA_GLArea_FullScreen, FALSE);
	    // puts("second before re-opening");
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Open, TRUE);
	};
    };
}
/*----------------------
  -  PREFS WINDOW      -
  ----------------------*/
void PrefsWindowCmd (Object *obj) {
    ULONG store;
    // puts("PrefsWindowCmd");
    if ((obj==MyApp->BT_PrefsSave)||
	(obj==MyApp->BT_PrefsUse)) {
	if (obj==MyApp->BT_PrefsSave) {
	    // puts("Saving...");
	    FILE *fset;
	    fset=fopen("ENV:VRMLViewer.prefs","w");
	    if (fset) {
		fprintf(fset,"%d\n",strlen(settings.outcon));
		fprintf(fset,"%s\n",settings.outcon);
		fprintf(fset,"%d %d\n",settings.msgmode,settings.resolve);
		fprintf(fset,"%0.2f %0.2f %0.2f\n",settings.brgb[0],settings.brgb[1],settings.brgb[2]);
		fprintf(fset,"%x %d\n",settings.displayID,settings.displayDepth);
		fprintf(fset,"%d %d %d\n",settings.coneres,settings.cylinderres,settings.sphereres);
		fprintf(fset,"%2.2f\n",settings.angle);
		fprintf(fset,"%s\n",settings.gzip);
		fprintf(fset,"%d %d\n",settings.buffered,settings.threaded);
		fclose(fset);
		system("copy ENV:VRMLViewer.prefs to ENVARC:");
	    };
	};
	//-----------Update some gl rendering state -------------------
	if (changedglnode) {
	    MUI_Request (MyApp->App, MyApp->WI_Main,0,"Changed settings","OK",
			     "To make your changes take effect\nyou have to reload your World !");
	};
	if (changedglmode) {
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Open, FALSE);
	    SetAttrs((Object *) MyApp->AR_CyberGLArea, MUIA_GLArea_Buffered, (BOOL) settings.buffered);
	    SetAttrs((Object *) MyApp->AR_CyberGLArea, MUIA_GLArea_Threaded, (BOOL) settings.threaded);
	    SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Open, TRUE);
	}
	else if (changedcolor) {
	    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	};
	changedglnode=FALSE;
	changedglmode=FALSE;
	changedcolor=FALSE;
    }
    else if (obj==MyApp->STR_PrefsCon) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsCon, &store);
	strncpy(settings.outcon,(char *) store, 80);
    }
    else if (obj==MyApp->RA_PrefsMode) {
	GetAttr(MUIA_Radio_Active, (Object *) MyApp->RA_PrefsMode, &store);
	switch ((int) store) {
	    case 0:settings.msgmode=ONLYERRORS;break;
	    case 1:settings.msgmode=ALLMSG;break;
	};
    }
    else if (obj==MyApp->CH_PrefsBuffered) {
	GetAttr(MUIA_Selected, (Object *) MyApp->CH_PrefsBuffered, &store);
	// if ((BOOL) store) {
	settings.buffered=(BOOL) store;
	changedglmode=TRUE;
    }
    /*
    else if (obj==MyApp->CH_PrefsThreaded) {
	GetAttr(MUIA_Selected, (Object *) MyApp->CH_PrefsThreaded, &store);
	settings.threaded=(BOOL) store;
	changedglmode=TRUE;
    }
    */

    else if (obj==MyApp->CH_PrefsInline) {
	GetAttr(MUIA_Selected, (Object *) MyApp->CH_PrefsInline, &store);
	if ((BOOL) store) {
	    settings.resolve=RESOLVE;
	}
	else {
	    settings.resolve=NORESOLVE;
	};
    }
    else if (obj==MyApp->SL_R) {
	GetAttr(MUIA_Numeric_Value, (Object *) MyApp->SL_R, &store);
	SetAttrs((Object *) MyApp->CF_Background, MUIA_Colorfield_Red, store<<24);
	settings.brgb[0]=(float) store/255;
	changedcolor=TRUE;
    }
    else if (obj==MyApp->SL_G) {
	GetAttr(MUIA_Numeric_Value, (Object *) MyApp->SL_G, &store);
	SetAttrs((Object *) MyApp->CF_Background, MUIA_Colorfield_Green, store<<24);
	settings.brgb[1]=(float) store/255;
	changedcolor=TRUE;
    }
    else if (obj==MyApp->SL_B) {
	GetAttr(MUIA_Numeric_Value, (Object *) MyApp->SL_B, &store);
	SetAttrs((Object *) MyApp->CF_Background, MUIA_Colorfield_Blue, store<<24);
	settings.brgb[2]=(float) store/255;
	changedcolor=TRUE;
    }
    else if ((obj==MyApp->STR_PrefsCone)||
	     (obj==MyApp->STR_PrefsCylinder)||
	     (obj==MyApp->STR_PrefsSphere)) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsCone, &store);
	settings.coneres=atoi((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsCylinder, &store);
	settings.cylinderres=atoi((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsSphere, &store);
	settings.sphereres=atoi((char *) store);
	// printf("Resolution:%d %d %d\n",st->coneres,st->cylinderres,st->sphereres);
	changedglnode=TRUE;
    }
    else if (obj==MyApp->STR_PrefsGZip) {
	// puts("prefs gzip");
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsGZip, &store);
	strncpy(settings.gzip,(char *) store,255);
    }
    else if (obj==MyApp->STR_PrefsAngle) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsAngle, &store);
	settings.angle=atof((char *) store);
	changedglnode=TRUE;
    };
}
#ifdef __GNUC__
ULONG StartScreen() {
    register Object *a0 asm("a0");
    Object *me = a0;
    register struct TagItem *a1 asm("a1");
    struct TagItem *tags = a1;
    register Object *a2 asm("a2");
    Object *obj = a2;
#else
ULONG StartScreen (register __a0 Object *me,
		   register __a2 Object *obj,
		   register __a1 struct TagItem *tags) {
#endif
    // puts("StartScreen");
    tags[0].ti_Tag=ASLSM_DoDepth;tags[0].ti_Data=TRUE;
    tags[1].ti_Tag=ASLSM_InitialDisplayID;tags[1].ti_Data=settings.displayID;
    tags[2].ti_Tag=ASLSM_InitialDisplayDepth;tags[2].ti_Data=settings.displayDepth;
    tags[3].ti_Tag=TAG_DONE;tags[3].ti_Data=0L;

    return TRUE;
}

#ifdef __GNUC__
ULONG StopScreen() {
    register Object *a0 asm("a0");
    Object *me = a0;
    register struct ScreenModeRequester *a1 asm("a1");
    struct ScreenModeRequester *req = a1;
    register Object *a2 asm("a2");
    Object *obj = a2;
#else
ULONG StopScreen (register __a0 Object *me,
		  register __a2 Object *obj,
		  register __a1 struct ScreenModeRequester *req ) {
#endif
    char idname[255];

    // puts("StopScreen");
    if (req==NULL) {
	// puts("Req is NULL");
	return 0;
    };
    settings.displayID=(int) req->sm_DisplayID;
    settings.displayDepth=(int) req->sm_DisplayDepth;
    // printf("DisplayID:%x\n",settings.displayID);
    ConvertDisplayID(idname,settings.displayID);
    // printf("Name:%s\n",idname);
    SetAttrs((Object *) MyApp->TXT_PA_PrefsSMR, MUIA_Text_Contents, idname);
    return TRUE;
}
/*-------------------------
  MISC CALLBACKS
--------------------------*/
void SpecialCmd (Object *obj) {
    // puts("In SpecialCmd");
}
//------------------------------------------------------------------------------------------------
//-------------------------------------------MAIN PART--------------------------------------------
//------------------------------------------------------------------------------------------------
/*------------------
   Init functions
------------------*/
void StartUp() {
     FILE *fset;
     int size=0;
     char car;
     float value=0;
     ULONG sig=0;

     camlist=new PList<VRMLCameras>();
     glc=new PList<GLVertex3d>();
     glm=new PList<GLMaterial>();
     gln=new PList<GLVertex3d>();
     gltc=new PList<GLVertex2d>();
     // Shared variables
     sh.mode=USER;
     sh.rendering=IDLE;

     // State variable init (prefs)
     fset=fopen("ENV:VRMLViewer.prefs","r");
     if (fset) {
	char temp[255];
	fscanf(fset,"%d%c\n",&size,&car);
	fread(settings.outcon,size,1,fset);
	fscanf(fset,"%d %d\n",&settings.msgmode,&settings.resolve);
	fscanf(fset,"%f %f %f\n",&settings.brgb[0],&settings.brgb[1],&settings.brgb[2]);
	fscanf(fset,"%x %d\n",&settings.displayID,&settings.displayDepth);
	fscanf(fset,"%d %d %d\n",&settings.coneres,&settings.cylinderres,&settings.sphereres);
	fscanf(fset,"%f\n",&settings.angle);
	fscanf(fset,"%s\n",settings.gzip);
	fscanf(fset,"%d %d\n",&settings.buffered, &settings.threaded);
	fclose(fset);
	sh.mode=SYSTEM;
	SetAttrs((Object *) MyApp->STR_PrefsCon, MUIA_String_Contents, settings.outcon);
	SetAttrs((Object *) MyApp->RA_PrefsMode, MUIA_Radio_Active, (ULONG) settings.msgmode);
	SetAttrs((Object *) MyApp->CH_PrefsInline, MUIA_Selected, (BOOL) settings.resolve);
	value=settings.brgb[0]*255;
	SetAttrs((Object *) MyApp->SL_R, MUIA_Numeric_Value, (int) value);
	value=settings.brgb[1]*255;
	SetAttrs((Object *) MyApp->SL_G, MUIA_Numeric_Value, (int) value);
	value=settings.brgb[2]*255;
	// printf("value b:%f\n",value);
	SetAttrs((Object *) MyApp->SL_B, MUIA_Numeric_Value, (int) value);
	itoa(settings.coneres,temp);
	SetAttrs((Object *) MyApp->STR_PrefsCone, MUIA_String_Contents, temp);
	itoa(settings.cylinderres,temp);
	SetAttrs((Object *) MyApp->STR_PrefsCylinder, MUIA_String_Contents, temp);
	itoa(settings.sphereres,temp);
	SetAttrs((Object *) MyApp->STR_PrefsSphere, MUIA_String_Contents, temp);
	ConvertDisplayID(temp,settings.displayID);
	SetAttrs((Object *) MyApp->TXT_PA_PrefsSMR, MUIA_Text_Contents, temp);
	SetAttrs((Object *) MyApp->STR_PrefsGZip, MUIA_String_Contents, settings.gzip);
	// printf("buffered:%d\n",settings.buffered);
	SetAttrs((Object *) MyApp->CH_PrefsBuffered, MUIA_Selected, (BOOL) settings.buffered);
	SetAttrs((Object *) MyApp->CH_PrefsThreaded, MUIA_Selected, (BOOL) settings.threaded);
	sh.mode=USER;
     }
     else {
	strncpy(settings.outcon,"CON:0/0/400/200/VRMLEditor Parser output",80);
	settings.msgmode=ONLYERRORS;
	settings.resolve=NORESOLVE;
	settings.brgb[0]=0.0;settings.brgb[1]=0.0;settings.brgb[2]=0.0;
	settings.displayID=0;
	settings.displayDepth=4;
	settings.coneres=8;
	settings.cylinderres=8;
	settings.sphereres=8;
	settings.angle=45.0;
	strncpy(settings.gzip,"C:Gzip",80);
	settings.buffered=TRUE;
	settings.threaded=TRUE;
     };

     // Some state variable
     parserfd=NULL;
     anim=FALSE;
     pm=ROTATE;
     pr=BOX;
     pp=TRANSPARENT;
     gauge.Win=MyApp->WI_Msg;
     gauge.Gauge=MyApp->GA_Msg;
     gauge.Txt=MyApp->TX_Msg;


    //--- Gauge window positionning
    SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_RefWindow, MyApp->WI_Main);
    SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Width, MUIV_Window_Width_Screen(40));

    //--- Prefs window
    SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_RefWindow, MyApp->WI_Main);

    //--- Position window
    SetAttrs((Object *) MyApp->WI_Position, MUIA_Window_RefWindow, MyApp->WI_Main);

    //--- Opening of the main window and waiting to receieve the updated status ---
    SetAttrs((Object *) MyApp->WI_Main,MUIA_Window_Open,TRUE);
    // Delay(10);
    // DoMethod((Object *) MyApp->App,MUIM_Application_NewInput,&sig);

    //--- FORCE Bufferded mode to be disabled
    // SetAttrs((Object *) MyApp->CH_PrefsBuffered, MUIA_Disabled, TRUE);
    //--- FORCE FullScreen mode to be disabled
    // SetAttrs((Object *) MyApp->MNPrefsFull, MUIA_Disabled, TRUE);
    
}

void ClearAll() {
    // puts("InClearAll");
    // SetAttrs((Object *) MyApp->TX_Msg, MUIA_Text_Contents, "Cleaning up memory allocation");
    // SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Open, TRUE);
    if (glnode) delete glnode;
    // SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Open, FALSE);
    delete camlist;
    delete glc;
    delete glm;
    delete gln;
    delete gltc;
    /*
    for (int i=0;i<nbcameras;i++) {
	if (entries[i]) {
	    free (entries[i]);
	};
    };
    */
    // puts("ClearAll finisehd");
}

void CloseAll() {
    // puts("in CloseAll");
    if (RenderScreen) CloseScreen(RenderScreen);
    if (parserfd!=NULL) fclose (parserfd);
    if (CyberGfxBase) CloseLibrary(CyberGfxBase);
    if (MUIMasterBase) CloseLibrary(MUIMasterBase);
    // if (glutBase) CloseLibrary(glutBase);
    // if (gluBase) CloseLibrary(gluBase);
    // if (glBase) CloseLibrary(glBase);
    #ifdef __GNUC__
    // if (glBase) CloseLibrary(CyberGLBase);
    // if (AslBase) CloseLibrary(AslBase);
    // if (IntuitionBase) CloseLibrary(IntuitionBase);
    // if (DOSBase) CloseLibrary(DOSBase);
    #endif
    // puts("finished");
}
/*-----------------------------
  ------MAIN FUNCTIONS ---------
  -----------------------------*/
void main(int argc, char **argv) {
    int rep,i;
    BOOL initialload=FALSE;
    ULONG sig=0,store=0;
    GLboolean down=GL_FALSE;

    // setlocale(0,"C");
    if (argc==2) {
	if (!strcmp(argv[1],"?")) {
	    printf("Usage:VRMLViewer <file>\n");
	    exit(0);
	};
    }
    else if (argc==1) {
	printf("VRMLViewer V 0.7 ("__DATE__")\n");
	// printf("Complied for 68040 only !\n");
	// printf("Only StormMesa libraries supported\n");
	printf("Usage: VRMLViewer <file>\n");
	exit(0);
    };

    // puts("In main");
    
    // CyberGLBase=(struct Library *) OpenLibrary ((UBYTE*)CYBERGLNAME,CYBERGLVERSION);
    MUIMasterBase=(struct Library *) OpenLibrary ((UBYTE*)MUIMASTER_NAME,MUIMASTER_VLATEST);
    if (MUIMasterBase==NULL) {
	puts ("Can't open muimaster.library");
	CloseAll();
	exit(1);
    };
    CyberGfxBase=(struct Library *) OpenLibrary((UBYTE*)CYBERGFXNAME,0L);
    if (CyberGfxBase==NULL) {
	// puts("can't open cybergraphics");
    };
    #ifdef __GNUC__
    // INIT_8_OpenLibs();
    /*
    OpenStormMesaLibs(&glBase,&gluBase,&glutBase);
    glbases.gl_Base=glBase;
    glbases.glu_Base=gluBase;
    glbases.glut_Base=glutBase;
    */
    #endif
    /*
    if (glBase==NULL) {
	puts("Can't open agl.library");
	CloseAll();
	exit(1);
    };
    */
    // Creation of MUI Application
    MyApp=CreateApp();
    GetAttr(MUIA_GLArea_glBase, (Object *) MyApp->AR_CyberGLArea, &store);
    glBase=(struct Library *) store;
    GetAttr(MUIA_GLArea_gluBase, (Object *) MyApp->AR_CyberGLArea, &store);
    gluBase=(struct Library *) store;
    GetAttr(MUIA_GLArea_glutBase, (Object *) MyApp->AR_CyberGLArea, &store);
    glutBase=(struct Library *) store;
    glcontext.gl_Base=glBase;
    glcontext.glu_Base=gluBase;
    glcontext.glut_Base=glutBase;
    StartUp();

    // Parsing CLI argument
    if (argc>1) {
	for (i=1;i<argc;i++) {
	    if (!strcmp(argv[i],"FS")) {

	    }
	    else {
		//     printf("argv[i]=%s\n",argv[i]);
		strcpy(FileName.Complete,argv[i]);
		// printf("Name:%s\n",OFile.Complete);
		SetAttrs((Object *) MyApp->STR_PA_MainFile, MUIA_String_Contents, FileName.Complete);

		while (1) {
		    // puts("in parsing loop");
		    DoMethod((Object *) MyApp->App,MUIM_Application_NewInput,&sig);
		    sig=Wait(sig);
		    GetAttr(MUIA_GLArea_Status, (Object *) MyApp->AR_CyberGLArea, &store);
		    // printf("status:%d\n",store);
		    if ((int) store==MUIV_GLArea_Ready) break;
		};
		LoadIt(FileName.Complete);
		// initialload=TRUE;
	    };
	};
    };

    // Main loop
    // puts("Before loop");
    while (DoMethod((Object *) MyApp->App,MUIM_Application_NewInput,&sig)!=MUIV_Application_ReturnID_Quit) {
	// puts("In main loop");
	// printf("");
	// if (initialload) {
	    // LoadIt(FileName.Complete);
	    //initialload=FALSE;
	// };
	if (sig) {
	    // puts("sig not NULL");
	    sig = Wait(sig | SIGBREAKF_CTRL_C);
	    if (sig & SIGBREAKF_CTRL_C) break;
	};
    }; // end while
    
    ClearAll();
    DisposeApp(MyApp);
    CloseAll();
    #ifdef __GNUC__
    // CloseStormMesaLibs(&glBase,&gluBase,&glutBase);
    // EXIT_8_OpenLibs();
    #endif
    // Delay(200);
    // printf("Out of main\n");
}

#ifdef __STORM__
void wbmain(struct WBStartup *wbmsg) {
    // puts("From workbench");
    main(0,NULL);
}
#endif

