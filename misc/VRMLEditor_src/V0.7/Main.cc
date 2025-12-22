/*----------------------------------------------------
  Main.cc
  Version 0.70
  Date: 22.7.1999
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: THIS IS THE MAIN PART
	Contains all callback functions via hooks
	GCC/StormC Port
	Separated MUI Windows
-----------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <dos/dosextens.h>
#include <intuition/intuition.h>
#include <utility/tagitem.h>
#include <exec/exec.h>
#include <libraries/mui.h>
#include <mui/GLArea_mcc.h>
#include <meshwriter/meshwriter.h>
#include <cybergraphx/cybergraphics.h>

#include <proto/alib.h>
#include <proto/asl.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/meshwriter.h>
#include <proto/muimaster.h>

#ifdef __GNUC__
#else
// #include <pragmas/muimaster_pragmas.h>
#endif

#include "App.h"

#include "MUIWindows.h"
#include "VRMLSupport.h"
#include "GLFunctions.h"
#include "Stack.hpp"
#include "Conversion.h"
#include "Misc.h"
// #include "StormMesaSupport.h"

#include "Main.h"

#include "MCC_DDListtree.h"

//--- Library base ---
extern struct ExecBase *SysBase;
struct Library *CyberGfxBase=NULL;
struct Library *MUIMasterBase=NULL;
struct MeshWriterBase *MeshWriterBase=NULL;

#ifdef __GNUC__
int __openliberror;
unsigned long __stack ={320000};
struct Library *glBase=NULL;
struct Library *gluBase=NULL;
struct Library *glutBase=NULL;
struct GLContext glcontext;
#endif
#ifdef __STORM__
extern struct Library *glBase;
extern struct Library *gluBase;
extern struct Library *glutBase;
#endif

//--- Globale const ---
const ULONG CFRed[3]={0xffffffff,0x0,0x0};
const ULONG CFWhite[3]={0xffffffff,0xffffffff,0xffffffff};

//--- Globale variables ---
struct ObjApp *MyApp=NULL;
struct Screen *RenderScreen=NULL;
FILE *parserfd=NULL;
SharedVariables sh;
VRMLStatus status=saved;
MUIGauge gauge;
Prefs settings;
FNames OFile;
FNames SFile;
int current=MAIN;

//--- Globale Objects ---
VRMLGroups *Main=NULL;
VRMLGroups *Clip=NULL;

//--- OpenGL output variables and functions ---
extern double angleX,angleY;
extern GLCamera mycamera,oldcamera;
int pt=NODE_ONLY;
int pw=MAIN_WORLD;
int pm=ROTATE;
int pr=BOX;
int pp=SMOOTH;
BOOL axis=FALSE;


WIAdd AddWin=WIAdd();

//--- MUI windows
WIAsciiText AsciiTextWin=WIAsciiText();
WICone ConeWin=WICone();
WICoordinate3 Coordinate3Win=WICoordinate3();
WICube CubeWin=WICube();
WICylinder CylinderWin=WICylinder();
WIDirectionalLight DirectionalLightWin=WIDirectionalLight();
WIFontStyle FontStyleWin=WIFontStyle();
WIGroups GroupsWin=WIGroups();
WIMaterial MaterialWin=WIMaterial();
WIIndexedFaceSet IFSWin=WIIndexedFaceSet();
// WIIndexedLineSet *ILSWin=NULL;
WIInfo InfoWin=WIInfo();
WIMaterialBinding MaterialBindingWin=WIMaterialBinding();
WIMatrixTransform MatrixTransformWin=WIMatrixTransform();
WINormal NormalWin=WINormal();
WINormalBinding NormalBindingWin=WINormalBinding();
// WIOrthographicCamera *OrthoWin=NULL;
// WIPerspectiveCamera *PersWin=NULL;

WIPointLight PointLightWin=WIPointLight();
WIPointSet PointSetWin=WIPointSet();
WIRotation RotationWin=WIRotation();
WIScale ScaleWin=WIScale();
WIShapeHints ShapeHintsWin=WIShapeHints();
WISphere SphereWin=WISphere();
WISpotLight SpotLightWin=WISpotLight();
WITexture2 Texture2Win=WITexture2();
WITexture2Transform Texture2TransformWin=WITexture2Transform();
WITextureCoordinate2 TextureCoordinate2Win=WITextureCoordinate2();
WITransform TransformWin=WITransform();
WITranslation TranslationWin=WITranslation();
WIWWWInline WWWInlineWin=WIWWWInline();

//-----------------------------------------------------------------------
/*********************************
 * MISCELLENOUS USEFUL FONCTIONS *
 *********************************/
//-----------------------------------------------------------------------
/*
VRMLNode *GetActive() {
   ULONG store;
   struct MUIS_Listtree_TreeNode *tn=NULL;

   if (current==MAIN) {
	GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
   }
   else if (current==CLIP) {
	GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
   };
   tn=(struct MUIS_Listtree_TreeNode *) store;
   if (tn==MUIV_Listtree_Active_Off) return NULL;
   return (VRMLNode *) tn->tn_User;
}
*/
struct MUIS_Listtree_TreeNode *GetActiveTreeNode() {
   ULONG store=0;
   struct MUIS_Listtree_TreeNode *tn=NULL;

   if (current==MAIN) {
	GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
   }
   else if (current==CLIP) {
	GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
   };
   tn=(struct MUIS_Listtree_TreeNode *) store;
   if (tn==MUIV_Listtree_Active_Off) return NULL;
   return tn;
}
struct MUIS_Listtree_TreeNode *GetParentTreeNode(struct MUIS_Listtree_TreeNode *tn) {
    struct MUIS_Listtree_TreeNode *ptn=NULL;

    if (current==MAIN) {
	 ptn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Parent,0);
    }
    else if (current==CLIP) {
	 ptn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Parent,0);
    };
    return ptn;
}
/*
int GetActiveRelativePosition(struct MUIS_Listtree_TreeNode *tn) {
    int pos=-1;

    if (current==MAIN) {
	 pos=(int) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetNr,tn,MUIV_Listtree_GetNr_Flags_CountLevel);
    }
    else if (current==CLIP) {
	 pos=(int) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetNr,tn,MUIV_Listtree_GetNr_Flags_CountLevel);
    };
    return pos;
}
*/
void InsertNode(VRMLNode *n, int pos, VRMLGroups *parent, struct MUIS_Listtree_TreeNode *ptn, struct MUIS_Listtree_TreeNode *tn, int which) {
    int flags=0;
    struct MUIS_Listtree_TreeNode *newtn=NULL;

    parent->InsertChild(pos,n);
    if ((n->ID&GROUPS)!=0) flags=TNF_LIST;
    if (which==MAIN) {
	if (tn==ptn) {
	    newtn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld, MUIM_Listtree_Insert, n->GetName(), n, ptn,MUIV_Listtree_Insert_PrevNode_Tail,flags);
	}
	else {
	    newtn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld, MUIM_Listtree_Insert, n->GetName(), n, ptn,tn,flags);
	};
	if ((n->ID&GROUPS)!=0) {
	    CompleteTreeNodes((Object *) MyApp->LT_MainWorld,newtn,(VRMLGroups *) n);
	};
    }
    else if (which==CLIP) {
	if (tn==ptn) {
	    newtn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip, MUIM_Listtree_Insert, n->GetName(), n, ptn,MUIV_Listtree_Insert_PrevNode_Tail,flags);
	}
	else {
	    newtn=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip, MUIM_Listtree_Insert, n->GetName(), n, ptn,tn,flags);
	};
	if ((n->ID&GROUPS)!=0) {
	    CompleteTreeNodes((Object *) MyApp->LT_MainClip,newtn,(VRMLGroups *) n);
	};
    };
}
void DeleteNode(int pos, VRMLGroups *parent, struct MUIS_Listtree_TreeNode *ptn, struct MUIS_Listtree_TreeNode *tn, int which) {
    delete (parent->RemoveChild(pos));
    if (which==MAIN) {
	DoMethod((Object *) MyApp->LT_MainWorld, MUIM_Listtree_Remove, ptn, tn,0);
    }
    else if (which==CLIP) {
	DoMethod((Object *) MyApp->LT_MainClip, MUIM_Listtree_Remove, ptn, tn,0);
    };
}
VRMLNode *RemoveNode(int pos, VRMLGroups *parent, struct MUIS_Listtree_TreeNode *ptn, struct MUIS_Listtree_TreeNode *tn, int which) {
    if (which==MAIN) {
	DoMethod((Object *) MyApp->LT_MainWorld, MUIM_Listtree_Remove, ptn, tn,0);
    }
    else if (which==CLIP) {
	DoMethod((Object *) MyApp->LT_MainClip, MUIM_Listtree_Remove, ptn, tn,0);
    };
    return parent->RemoveChild(pos);
}
// Close windows

void PopDownMain() {
    if (AsciiTextWin.which==MAIN) {
	AsciiTextWin.Cancel();
	SetAttrs((Object *) MyApp->WI_AsciiText, MUIA_Window_Open, FALSE);
    };
}
/*
void PopDownAll() {
	// puts("PopDownAll");
	AsciiTextWin->PopDown();
	ConeWin->PopDown();
	Coordinate3Win->PopDown();
	CubeWin->PopDown();
	CylinderWin->PopDown();
	DirectionalLightWin->PopDown();
	FontStyleWin->PopDown();
	IFSWin->PopDown();
	ILSWin->PopDown();
	InfoWin->PopDown();
	MaterialWin->PopDown();
	MaterialBindingWin->PopDown();
	MatrixTransformWin->PopDown();
	NormalWin->PopDown();
	NormalBindingWin->PopDown();
	OrthoWin->PopDown();
	PersWin->PopDown();
	PointLightWin->PopDown();
	PointSetWin->PopDown();
	RotationWin->PopDown();
	ScaleWin->PopDown();
	ShapeHintsWin->PopDown();
	SphereWin->PopDown();
	SpotLightWin->PopDown();
	Texture2Win->PopDown();
	Texture2TransformWin->PopDown();
	TextureCoordinate2Win->PopDown();
	TransformWin->PopDown();
	TranslationWin->PopDown();
	WWWInlineWin->PopDown();
}
*/
void PopDown(VRMLNode *n) {
   int i=0;
   switch (n->ID) {
	case ASCIITEXT_1:if (n==AsciiTextWin.Get()) {
			    AsciiTextWin.Ok();
			    SetAttrs((Object *) MyApp->WI_AsciiText, MUIA_Window_Open, FALSE);
			 };
			 break;
	case CONE_1:if (n==ConeWin.Get()) {
			ConeWin.Ok();
			SetAttrs((Object *) MyApp->WI_Cone, MUIA_Window_Open, FALSE);
		    };
		    break;
	case COORDINATE3_1:if (n==Coordinate3Win.Get()) {
				Coordinate3Win.Ok();
				SetAttrs((Object *) MyApp->WI_Coordinate3, MUIA_Window_Open, FALSE);
			   };
			   break;
	case CUBE_1:if (n==CubeWin.Get()) {
			CubeWin.Ok();
			SetAttrs((Object *) MyApp->WI_Cube, MUIA_Window_Open, FALSE);
		    };
		    break;
	case CYLINDER_1:if (n==CylinderWin.Get()) {
			    CylinderWin.Ok();
			    SetAttrs((Object *) MyApp->WI_Cylinder, MUIA_Window_Open, FALSE);
			};
			break;
	case DIRECTIONALLIGHT_1:if (n==DirectionalLightWin.Get()) {
				    DirectionalLightWin.Ok();
				    SetAttrs((Object *) MyApp->WI_DirectionalLight, MUIA_Window_Open, FALSE);
				};
				break;
	case FONTSTYLE_1:if (n==FontStyleWin.Get()) {
			    FontStyleWin.Ok();
			    SetAttrs((Object *) MyApp->WI_AsciiText, MUIA_Window_Open, FALSE);
			 };
			 break;
	case INDEXEDFACESET_1:if (n==IFSWin.Get()) {
				IFSWin.Ok();
				SetAttrs((Object *) MyApp->WI_IFS, MUIA_Window_Open, FALSE);
			      };
			      break;
	/*
	case IndexedLineSetID:if (n==ILSWin->Get())ILSWin->PopDown();
			      break;
	*/
	case INFO_1:if (n==InfoWin.Get()) {
			InfoWin.Ok();
			SetAttrs((Object *) MyApp->WI_Info, MUIA_Window_Open, FALSE);
		    };
		    break;
	case MATERIAL_1:if (n==MaterialWin.Get()) {
			    MaterialWin.Ok();
			    SetAttrs((Object *) MyApp->WI_Material, MUIA_Window_Open, FALSE);
			};
			break;
	case MATERIALBINDING_1:if (n==MaterialBindingWin.Get()) {
				    MaterialBindingWin.Ok();
				    SetAttrs((Object *) MyApp->WI_MaterialBinding, MUIA_Window_Open, FALSE);
			       };
			       break;
	case MATRIXTRANSFORM_1:if (n==MatrixTransformWin.Get()) {
				    MatrixTransformWin.Ok();
				    SetAttrs((Object *) MyApp->WI_MatrixTransform, MUIA_Window_Open, FALSE);
			       };
			       break;
	case NORMAL_1:if (n==NormalWin.Get()) {
			    NormalWin.Ok();
			    SetAttrs((Object *) MyApp->WI_Normal, MUIA_Window_Open, FALSE);
		      };
		      break;
	case NORMALBINDING_1:if (n==NormalBindingWin.Get()) {
				NormalBindingWin.Ok();
				SetAttrs((Object *) MyApp->WI_NormalBinding, MUIA_Window_Open, FALSE);
			     };
			     break;
	/*
	case OrthographicCameraID:if (n==OrthoWin->Get())OrthoWin->PopDown();
				  break;
	case PerspectiveCameraID:if (n==PersWin->Get())PersWin->PopDown();
				 break;
	*/
	case POINTLIGHT_1:if (n==PointLightWin.Get()) {
			    PointLightWin.Ok();
			    SetAttrs((Object *) MyApp->WI_PointLight, MUIA_Window_Open, FALSE);
			  };
			  break;

	case POINTSET_1:if (n==PointSetWin.Get()) {
			    PointSetWin.Ok();
			    SetAttrs((Object *) MyApp->WI_PointSet, MUIA_Window_Open, FALSE);
			};
			break;

	case ROTATION_1:if (n==RotationWin.Get()) {
			    RotationWin.Ok();
			    SetAttrs((Object *) MyApp->WI_Rotation, MUIA_Window_Open, FALSE);
			};
			break;
	case SCALE_1:if (n==ScaleWin.Get()) {
			ScaleWin.Ok();
			SetAttrs((Object *) MyApp->WI_Scale, MUIA_Window_Open, FALSE);
		     };
		     break;
	case SHAPEHINTS_1:if (n==ShapeHintsWin.Get()) {
				ShapeHintsWin.Ok();
				SetAttrs((Object *) MyApp->WI_ShapeHints, MUIA_Window_Open, FALSE);
			  };
			  break;
	case SPHERE_1:if (n==SphereWin.Get()) {
			    SphereWin.Ok();
			    SetAttrs((Object *) MyApp->WI_Sphere, MUIA_Window_Open, FALSE);
		      };
		      break;
	case SPOTLIGHT_1:if (n==SpotLightWin.Get()) {
			    SpotLightWin.Ok();
			    SetAttrs((Object *) MyApp->WI_SpotLight, MUIA_Window_Open, FALSE);
			 };
			 break;
	case TEXTURE2_1:if (n==Texture2Win.Get()) {
			    Texture2Win.Ok();
			    SetAttrs((Object *) MyApp->WI_Texture2, MUIA_Window_Open, FALSE);
			};
			break;
	case TEXTURE2TRANSFORM_1:if (n==Texture2TransformWin.Get()) {
				    Texture2TransformWin.Ok();
				    SetAttrs((Object *) MyApp->WI_Texture2Transform, MUIA_Window_Open, FALSE);
			       };
			       break;
	case TEXTURECOORDINATE2_1:if (n==TextureCoordinate2Win.Get()) {
				    TextureCoordinate2Win.PopDown();
				    SetAttrs((Object *) MyApp->WI_TextureCoordinate2, MUIA_Window_Open, FALSE);
				  };
				  break;
	case TRANSFORM_1:if (n==TransformWin.Get()) {
			    TransformWin.Ok();
			    SetAttrs((Object *) MyApp->WI_Transform, MUIA_Window_Open, FALSE);
			 };
			 break;
	case TRANSFORMSEPARATOR_1:
	case WWWANCHOR_1:
	case SWITCH_1:
	case LOD_1:
	case GROUP_1:
	case SEPARATOR_1:if (n==GroupsWin.Get()) {
				GroupsWin.Ok();
				SetAttrs((Object *) MyApp->WI_Groups, MUIA_Window_Open, FALSE);
			   };
			   break;

	case TRANSLATION_1:if (n==TranslationWin.Get()) {
				TranslationWin.Ok();
				SetAttrs((Object *) MyApp->WI_Translation, MUIA_Window_Open, FALSE);
			   };
			   break;

	case WWWINLINE_1:if (n==WWWInlineWin.Get()) {
			    WWWInlineWin.Ok();
			    SetAttrs((Object *) MyApp->WI_WWWInline, MUIA_Window_Open, FALSE);
			 };
			 break;
    };
}
/*
void SleepAll() {
	// puts("SleepAll");
	SetAttrs((Object *) MyApp->WI_AsciiText, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Cone, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Coordinate3, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Cube, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Cylinder, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_DirectionalLight, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_FontStyle, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_IFS, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_ILS, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Info, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Material, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_MaterialBinding, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_MatrixTransform, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Normal, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_NormalBinding, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_OrthographicCamera, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_PerspectiveCamera, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_PointLight, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_PointSet, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Rotation, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Scale, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_ShapeHints, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Sphere, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_SpotLight, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Texture2, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Texture2Transform, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_TextureCoordinate2, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Transform, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Translation, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_WWWInline, MUIA_Window_Sleep, TRUE);

	SetAttrs((Object *) MyApp->WI_CyberGL, MUIA_Window_Sleep, TRUE);
	SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Sleep, TRUE);
}
*/
/*
void WakeUpAll() {
	// puts("SleepAll");
	SetAttrs((Object *) MyApp->WI_AsciiText, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Cone, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Coordinate3, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Cube, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Cylinder, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_DirectionalLight, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_FontStyle, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_IFS, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_ILS, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Info, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Material, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_MaterialBinding, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_MatrixTransform, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Normal, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_NormalBinding, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_OrthographicCamera, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_PerspectiveCamera, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_PointLight, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_PointSet, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Rotation, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Scale, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_ShapeHints, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Sphere, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_SpotLight, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Texture2, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Texture2Transform, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_TextureCoordinate2, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Transform, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Translation, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_WWWInline, MUIA_Window_Sleep, FALSE);

	SetAttrs((Object *) MyApp->WI_CyberGL, MUIA_Window_Sleep, FALSE);
	SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Sleep, FALSE);
}
*/
/*---------------------------------
  Function to load a VRMLV1 file
-----------------------------------*/
VRMLNode *Load(char *filename) {
    LoadVRMLParams par={MyApp->App,MyApp->WI_Main,parserfd,settings.msgmode,settings.resolve};
    VRMLNode *node=NULL;
    char temp[512];
    int rep=0;

    status=CheckType(filename);
    if (status==gzip) {
	sprintf(temp,"%s -d %s -c >RAM:Temp.wrl",settings.gzip,filename);
	if (System(temp,NULL)) {
	    rep=MUI_Request(MyApp->App,MyApp->WI_Main,0,"Error","Ok","Error when decompressing file");
	    return NULL;
	};
	settings.V1Gzip=TRUE;
	node=Load("ram:Temp.wrl");
	System("Delete ram:Temp.wrl",NULL);
	return node;
    };

    // puts("begining of check");
    if (status==notfound) {
	rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Loading error","Ok",
			 "File not found");
	return NULL;
    }
    else if (status==v2) {
	rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Wrong format","Ok",
		     "This file is a VRML V2.0 ur8f file\n\n"
		     "VRMLEditor doesn't support this format actually !");
	return NULL;
    }
    else if (status==novrml) {
	rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Wrong format","Ok",
			 "This file is not a VRML V1.0 ascii file !");
	return NULL;
    }
    else if (status==geo) {
	node=LoadGEO(&gauge,filename,parserfd,settings.msgmode);
	status=v1;
	return node;
    }
    else if (status==geobin) {
	rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Wrong format","Ok",
			 "This file is a BINARY Geo format\n"
			 "I can't handle this format\n"
			 "Convert it to Ascii first !");
    }
    else if (status==v1) {
	node=LoadVRML(&par,filename);
	status=saved;
	return node;
    };
    return NULL;
}
/*--------------------------------------------
  Founction to save a VRML V1.0 ascii world
--------------------------------------------*/
void Save(VRMLNode *n, char *filename,BOOL tex, BOOL inlines, BOOL compress) {
    char temp[255];
    SaveVRMLParams par={MyApp->App,MyApp->WI_Main,tex,inlines};

    status=SaveVRML(&par,filename,n);
    if (status==notfound) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saving error","Ok",
		     "File not found");
    }
    else if (status==saved) {
	if (compress) {
	    sprintf(temp,"%s -9 \"%s\"",settings.gzip,filename);
	    printf("string:%s\n",temp);
	    if (System(temp,NULL)) {
		MUI_Request(MyApp->App,MyApp->WI_Main,0,"Error","Ok","Error when gzipping file");
	    };
	};
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saved","Ok",
		     "Saving succesful\n\nBTW you have to test it to be sure...");
    };
}
/*--------------------------------------------
  Function to save a VRML V2.0 utf8 world
--------------------------------------------*/
void Save2(VRMLNode *n, char *filename,BOOL tex) {
    char temp[255];
    SaveVRMLParams par={MyApp->App,MyApp->WI_Main,tex,FALSE};

    status=SaveVRML2(&par,filename,n);
    if (status==notfound) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saving error","Ok",
		     "File not found");
    }
    else if (status==saved) {
	/*
	if (compress) {
	    sprintf(temp,"%s -9 \"%s\"",settings.gzip,filename);
	    printf("string:%s\n",temp);
	    if (System(temp,NULL)) {
		MUI_Request(MyApp->App,MyApp->WI_Main,0,"Error","Ok","Error when gzipping file");
	    };
	};
	*/
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saved","Ok",
		     "Saving succesful\n\nBTW you have to test it to be sure...");
    };
}
/*--------------------------------------------
  Founction to save a VRML V1.0 ascii world
--------------------------------------------*/
void Export(VRMLNode *n, char *filename, int id) {
    SaveMWParams par={MyApp->App,MyApp->WI_Main,settings.coneres,settings.cylinderres,settings.sphereres,id};

    status=SaveMW(&par,filename,n);
    puts("saveMW finished");
    if (status==notfound) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saving error","Ok",
		     "File not found");
    }
    else if (status==saved) {
	/*
	if (compress) {
	    sprintf(temp,"%s -9 \"%s\"",settings.gzip,filename);
	    printf("string:%s\n",temp);
	    if (System(temp,NULL)) {
		MUI_Request(MyApp->App,MyApp->WI_Main,0,"Error","Ok","Error when gzipping file");
	    };
	};
	*/
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saved","Ok",
		     "Saving succesful\n\nBTW you have to test it to be sure...");
    };
}
/*--------------------------
  Save OpenGL code
----------------------------*/
void SaveGL(VRMLNode *n, char *filename) {
    SaveOpenGLParams par={gauge.Win,gauge.Gauge,gauge.Txt,settings.coneres,settings.cylinderres,settings.sphereres,settings.GLTex};
    status=SaveOpenGL(&par,filename,n);
    if (status==notfound) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saving error","Ok",
		     "File not found");
    }
    else if (status==saved) {
	MUI_Request (MyApp->App,MyApp->WI_Main,0,"Saved","Ok",
		"OpenGL source code saving succesful\n\n"
		"BTW you have to test/compile it ;^) to be sure...");
    };
}

void NotImplemented() {
    MUI_Request (MyApp->App,MyApp->WI_Main,0,"Not implemented","Ok",
		 "\033cThis function is faaaaaaar not implemented\n"
		 "Wait for a new version...\n\n"
		 "...well... can you wait a long time ?");
}

//---------------------------------------------------------------------
/*****************************
 * CyberGL related functions *
 *****************************/
//---------------------------------------------------------------------

/*-----------------------
  All CyberGL functions
-------------------------*/
void RefreshCoord() {
    char temp[255];
    // if (sh.mode==SYSTEM) return;
    // puts("RefreshCoord");
    sh.mode=SYSTEM;
    ftoa(mycamera.X,temp);
    // printf("x:%f %s\n",mycamera.X,temp);
    SetAttrs(MyApp->STR_CyberGLX,MUIA_String_Contents, temp);
    ftoa(mycamera.Y,temp);
    SetAttrs(MyApp->STR_CyberGLY,MUIA_String_Contents, temp);
    ftoa(mycamera.Z,temp);
    SetAttrs(MyApp->STR_CyberGLZ,MUIA_String_Contents, temp);
    ftoa(mycamera.heading,temp);
    SetAttrs(MyApp->STR_CyberGLHeading,MUIA_String_Contents, temp);
    ftoa(mycamera.pitch,temp);
    SetAttrs(MyApp->STR_CyberGLPitch,MUIA_String_Contents, temp);
    sh.mode=USER;
}
void ReadValues() {
    /*
    ULONG store;
    char temp[25];
    float cx,cy,cz;

    if (sh.mode==SYSTEM) return;
    // puts ("=>ReadValues");
    GetAttr(MUIA_String_Contents, MyApp->STR_CyberGLX, &store);
    mycamera.X=atof((char *) store);
    GetAttr(MUIA_String_Contents, MyApp->STR_CyberGLY, &store);
    mycamera.Y=atof((char *) store);
    GetAttr(MUIA_String_Contents, MyApp->STR_CyberGLZ, &store);
    mycamera.Z=atof((char *) store);
    GetAttr(MUIA_String_Contents, MyApp->STR_CyberGLHeading, &store);
    mycamera.heading=atof((char *) store);
    GetAttr(MUIA_String_Contents, MyApp->STR_CyberGLPitch, &store);
    mycamera.pitch=atof((char *) store);
    // SetCameraAndOrientation(cx,cy,cz,mycamera.heading,mycamera.pitch,0);
    // puts("<=ReadValues");
    */
}
//-------------------------------------
// Rendering to a custom screen
//-------------------------------------
void DrawGLNodeScene() {
   /*
   VRMLNode *node1=NULL,*node2=NULL;
   GLNode *glnode1=NULL,*glnode2=NULL;

   // puts("=>DRAWSCENE");
   if ((pw==Main_Nodes)||
       (pw==Both)) {
       if (pt==World_Preview) {node1=(VRMLNode *)Main;}
       // else if (pt==Group_Preview) {node1=(VRMLNode *) LVMain->GetGroup();}
       // else if (pt==Node_Preview) {node1=(VRMLNode *) LVMain->GetSelectedChild();};
   };
   if ((pw==Clip_Nodes)||
       (pw==Both)) {
       if (pt==World_Preview) {node2=(VRMLNode *)Clip;}
       // else if (pt==Group_Preview) {node2=(VRMLNode *)LVClip->GetGroup();}
       // else if (pt==Node_Preview) {node2=(VRMLNode *)LVClip->GetSelectedChild();};
   };

   if (node1) {
	// puts("node1 not NULL");
	glnode1=ConvertVRML2GL(&gauge,node1,st->coneres,st->cylinderres,st->sphereres,settings.angle);
   };
   if (node2) {
	// puts("node2 not NULL");
	glnode2=ConvertVRML2GL(&gauge,node2,st->coneres,st->cylinderres,st->sphereres,settings.angle);
   };

   if (RenderScreen) {
	// puts("In DrawScene");
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	DrawMode();
	glCamera();
	glPushMatrix ();
	   glRotated (angleX, 0.0, -1.0, 0.0);
	   glRotated (angleY, -1.0, 0.0, 0.0);
	   if (glnode1) glnode1->DrawGL();
	   if (glnode2) glnode2->DrawGL();
	glPopMatrix ();
	glFlush();
   };
   // puts("Before deleting");
   if (glnode1) delete glnode1;
   if (glnode2) delete glnode2;
   // puts("<=DRAWSCENE");
    */
}

void RenderGL() {
    /*
    void *glwin;
    VRMLNode *node1=NULL,*node2=NULL;
    GLNode *glnode1=NULL,*glnode2=NULL;

    if ((pw==Main_Nodes)||
       (pw==Both)) {
       if (pt==World_Preview) {node1=(VRMLNode *)Main;}
       // else if (pt==Group_Preview) {node1=(VRMLNode *) LVMain->GetGroup();}
       // else if (pt==Node_Preview) {node1=(VRMLNode *) LVMain->GetSelectedChild();};
    };
    if ((pw==Clip_Nodes)||
       (pw==Both)) {
       if (pt==World_Preview) {node2=(VRMLNode *)Clip;}
       // else if (pt==Group_Preview) {node2=(VRMLNode *)LVClip->GetGroup();}
       // else if (pt==Node_Preview) {node2=(VRMLNode *)LVClip->GetSelectedChild();};
    };

    if (node1) {
	// puts("node1 not NULL");
	glnode1=ConvertVRML2GL(&gauge,node1,st->coneres,st->cylinderres,st->sphereres,settings.angle);
    };
    if (node2) {
	// puts("node2 not NULL");
	glnode2=ConvertVRML2GL(&gauge,node2,st->coneres,st->cylinderres,st->sphereres,settings.angle);
    };

    SetAttrs((Object *) MyApp->WI_CyberGL, MUIA_Window_Open, FALSE);
    RenderScreen = OpenScreenTags (NULL,
				   SA_DisplayID, (ULONG) settings.displayID,
				   SA_Depth, settings.displayDepth,
				   // SA_Type, PUBLICSCREEN,
				   SA_SharePens,TRUE,
				   // SA_Title, "OpenGL render Screen",
				   TAG_DONE);
    if (RenderScreen) {
	// puts("ScreenOpened");
	// puts("attach gl to rp");

	glwin=openGLWindowTags (RenderScreen->Width, RenderScreen->Height,
			   GLWA_Title, 0,
			   GLWA_IDCMP, IDCMP_MOUSEBUTTONS,
			   GLWA_Flags, WFLG_BORDERLESS,
			   // IDCMP_NEWSIZE,
			   // GLWA_DepthGadget, TRUE,
			   // GLWA_DragBar,     TRUE,
			   GLWA_Activate, TRUE,
			   GLWA_RGBAMode, TRUE,
			   GLWA_CustomScreen, (ULONG) RenderScreen,
			   // GLWA_SizeGadget, TRUE,
			   // GLWA_MinWidth, 80,
			   // GLWA_MinHeight, 60,
			   // GLWA_MaxWidth, 800,
			   // GLWA_MaxHeight, 600,
			   GLWA_Buffered, (ULONG) FALSE,
			   TAG_DONE, 0L);

	if (glwin) {
	    // puts("Window attached to Screen");
	    Init();
	    // puts("In DrawScene");
	    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	    glLoadIdentity();
	    DrawMode();
	    glCamera();
	    glPushMatrix ();
	    glRotated (angleX, 0.0, -1.0, 0.0);
	    glRotated (angleY, -1.0, 0.0, 0.0);
	    if (glnode1) glnode1->DrawGL();
	    if (glnode2) glnode2->DrawGL();
	    glPopMatrix ();
	    glFlush();
	    WaitPort(getWindow(glwin)->UserPort);
	    disposeGLWindow(glwin);
	    CloseScreen(RenderScreen);
	    RenderScreen=NULL;
	}
	else {
	    MUI_Request (MyApp->App,MyApp->WI_CyberGL,0,"CyberGL error","Ok",
		"Can't open CyberGL context window...");
	};
    }
    else {
	MUI_Request (MyApp->App,MyApp->WI_CyberGL,0,"Screen error","Ok",
		     "Can't open screen");
    };
    // puts("Before deleting");
    if (glnode1) delete glnode1;
    if (glnode2) delete glnode2;
    SetAttrs((Object *) MyApp->WI_CyberGL, MUIA_Window_Open, TRUE);
    */
}
//--------------------------------------------------------------------
/*****************************************
 * WINDOWS FUNCTIONS AND CALLBACKS       *
 *****************************************/
//-------------------------------------------------------------------
/*--------------------------
       CYBERGL WINDOW
----------------------------*/
void CyberGLCmd (Object *obj) {
    ULONG store;
    puts("CyberGLCmd");
    if (sh.mode==SYSTEM) return;
    // sh.mode=SYSTEM;
    if ((obj==MyApp->STR_CyberGLX)||
	(obj==MyApp->STR_CyberGLY)||
	(obj==MyApp->STR_CyberGLZ)||
	(obj==MyApp->STR_CyberGLHeading)||
	(obj==MyApp->STR_CyberGLPitch)) {
	ReadValues();
    }
    else if (obj==MyApp->BT_CyberGLBreak) {
	// puts("Refresh");
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Break);
	return;
	// DrawScene();
    }
    else if (obj==MyApp->BT_CyberGLRender) {
	RenderGL();
	return;
    }
    else if (obj==MyApp->RA_CyberGLActions) {
	GetAttr(MUIA_Radio_Active, MyApp->RA_CyberGLActions, &store);
	switch ((int) store) {
	    case 0:pm=ROTATE;break;
	    case 1:pm=SLIDE;break;
	    case 2:pm=TURN;break;
	    case 3:pm=FLY;break;
	};
	return;
    }
    else if (obj==MyApp->CY_CyberGLMode) {
	GetAttr(MUIA_Cycle_Active, MyApp->CY_CyberGLMode, &store);
	switch ((int) store) {
	    case 0:pp=SMOOTH;break;
	    case 1:pp=FLAT;break;
	    case 2:pp=WIRE;break;
	    case 3:pp=POINTS;break;
	    case 4:pp=BOUNDINGBOX;break;
	    case 5:pp=WIREFRAME;break;
	    case 6:pp=TRANSPARENT;break;
	    case 7:pp=TEXTURED;break;
	};
    }
    else if (obj==MyApp->CH_CyberGLFull) {
	GetAttr(MUIA_Selected, MyApp->CH_CyberGLFull, &store);
	switch ((int) store) {
	    case 0:pr=BOX;break;
	    case 1:pr=PLAIN;break;
	};
    }
    else if (obj==MyApp->CH_CyberGLAxes) {
	GetAttr(MUIA_Selected, MyApp->CH_CyberGLAxes, &store);
	switch ((int) store) {
	    case 0:axis=FALSE;break;
	    case 1:axis=TRUE;break;
	};
    }
    else if (obj==MyApp->CY_CyberGLLevel) {
	puts("Level found");
	GetAttr(MUIA_Cycle_Active,MyApp->CY_CyberGLLevel, &store);
	switch ((int) store) {
	    case 0:pt=NODE_ONLY;break;
	    case 1:pt=GROUP_ONLY;break;
	    case 2:pt=WHOLE_WORLD;break;
	};
    }
    else if (obj==MyApp->CY_CyberGLWhich) {
	GetAttr(MUIA_Cycle_Active,MyApp->CY_CyberGLWhich, &store);
	switch ((int) store) {
	    case 0:pw=MAIN_WORLD;break;
	    case 1:pw=CLIP_WORLD;break;
	    case 2:pw=BOTH_WORLD;break;
	};
    }
    else if (obj==MyApp->BT_CyberGLReset) {
	// SetCameraAndOrientation(0,0,40,90,0,0);

	// mycamera.X=0;mycamera.Y=0;mycamera.Z=40;
	// mycamera.heading=0;
	// mycamera.pitch=0;
	// Reset();
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Init);
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Reset);
	RefreshCoord();
    }
    else if (obj==MyApp->IM_CyberGLXRight) {
	mycamera.X+=5;
	RefreshCoord();
    }
    else if (obj==MyApp->IM_CyberGLXLeft) {
	mycamera.X-=5;
	RefreshCoord();
    }
    else if (obj==MyApp->IM_CyberGLYRight) {
	mycamera.Y+=5;
	RefreshCoord();
    }
    else if (obj==MyApp->IM_CyberGLYLeft) {
	mycamera.Y-=5;
	RefreshCoord();
    }
    else if (obj==MyApp->IM_CyberGLZRight) {
	mycamera.Z+=5;
	RefreshCoord();
    }
    else if (obj==MyApp->IM_CyberGLZLeft) {
	mycamera.Z-=5;
	RefreshCoord();
    }
    else if (obj==MyApp->IM_CyberGLHRight) {
	mycamera.heading-=10;
	RefreshCoord();
	// SetOrientation(mycamera.heading,mycamera.pitch,0);
	// PreviewGL->Advance();
    }
    else if(obj==MyApp->IM_CyberGLHLeft) {
	mycamera.heading+=10;
	RefreshCoord();
	// SetOrientation(mycamera.heading,mycamera.pitch,0);
	// PreviewGL->Backward();
    }
    else if(obj==MyApp->IM_CyberGLPRight) {
	mycamera.pitch+=10;
	RefreshCoord();
	// SetOrientation(mycamera.heading,mycamera.pitch,0);
	// PreviewGL->TurnLeft();
    }
    else if(obj==MyApp->IM_CyberGLPLeft) {
	mycamera.pitch-=10;
	RefreshCoord();
	// SetOrientation(mycamera.heading,mycamera.pitch,0);
	// PreviewGL->TurnRight();
    };

    // sh.mode=SYSTEM;
    // RefreshCoord();
    // sh.mode=USER;
    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    // sh.mode=USER;
    // puts("<=CyberGLCmd");
    // return;

}
void ChangeCamera(Object *obj) {
}
//-------------------------------------- MAIN WINDOW HANDLING --------------------------------
// -------------MenuBar----------------------
void MenuCmd(Object *obj) {
     BOOL rep,ok;
     ULONG store;
     VRMLNode *node=NULL;

     if (obj==MyApp->MNProjectOpen) {
	// puts("=>Callback:OpenFile");
	if (status!=saved) {
	     rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Confirm","Ok|Cancel",
			      "The current project is not saved !");
	    if (rep==0) return;
	};

	rep=OpenASL("Load file",OFile.Dir,OFile.Name,OFile.Complete,OFile.Dir,OFile.Name);
	if (rep) {
	    // puts("Before gr=Load()");
	    node=Load(OFile.Complete);
	    if (node!=NULL) {
		 // puts("loading succesful");
		 delete Main;
		 // puts("After delete main");
		 Main=(VRMLGroups *) node;

		 DoMethod((Object *) MyApp->LT_MainWorld, MCCM_DDListtree_Init, (VRMLNode *) Main);
		 GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_CyberGL, &store);
		 if ((BOOL) store) {
		    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Reset);
		    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
		 };
		 // PopDownAll();
		 SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Title, OFile.Name);
	    }
	    else {
		// puts("Error gr=NULL");
	    };
	};
	// puts("<=Callback:OpenFile");
    }
    else if (obj==MyApp->MNProjectNewAll) {
	if (status!=saved) {
	    rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Confirm","Ok|Cancel",
			     "Your Main world is not saved !\n"
			     "Do you really want to clear this project ?");
	    if (rep==0) return;
	};
	// PopDownAll();
	delete Main;
	delete Clip;
	Main=(VRMLGroups *) new Separator("ROOT");
	Clip=(VRMLGroups *) new Separator("CLIP");
	DoMethod((Object *) MyApp->LT_MainWorld, MCCM_DDListtree_Init, (VRMLNode *) Main);
	DoMethod((Object *) MyApp->LT_MainClip, MCCM_DDListtree_Init, (VRMLNode *) Clip);
    }
    else if (obj==MyApp->MNProjectNewOnlyMain) {
	if (status!=saved) {
	    rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Confirm","Ok|Cancel",
			     "Your project is not saved !\n"
			     "Do you really want to clear the main world ?\n");
	    if (rep==0) return;
	};
	// PopDownAll();
	delete Main;
	Main=(VRMLGroups *) new Separator("ROOT");
	DoMethod((Object *) MyApp->LT_MainWorld, MCCM_DDListtree_Init, (VRMLNode *) Main);
    }
    else if (obj==MyApp->MNProjectNewOnlyClip) {
	rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Confirm","Ok|Cancel",
			 "Do you really want to clear your clip world ?\n");
	if (rep==0) return;
	// PopDownAll();
	delete Clip;
	Clip=(VRMLGroups *) new Separator("CLIP");
	DoMethod((Object *) MyApp->LT_MainClip, MCCM_DDListtree_Init, (VRMLNode *) Clip);
    }
    else if (obj==MyApp->MNProjectSave) {
	Save(Main,OFile.Complete,settings.V1GenTex,settings.V1GenInlines,settings.V1Gzip);
    }
    else if (obj==MyApp->MNProjectSaveasVRML) {
	// puts("In Save As VRML");
	SetAttrs((Object *) MyApp->TX_SaveAsFormat, MUIA_Text_Contents, "VRML V1.0 ascii");
	SetAttrs((Object *) MyApp->STR_PA_SaveAs, MUIA_String_Contents, OFile.Complete);
	SetAttrs((Object *) MyApp->GR_SaveAsV1, MUIA_ShowMe, TRUE);
	SetAttrs((Object *) MyApp->GR_SaveAsV2, MUIA_ShowMe, FALSE);
	SetAttrs((Object *) MyApp->GR_SaveAsGL, MUIA_ShowMe, FALSE);
	SetAttrs((Object *) MyApp->WI_SaveAs, MUIA_Window_Open, TRUE);
    }
    else if (obj==MyApp->MNProjectSaveasVRML2) {
	// puts("In Save As VRML");
	SetAttrs((Object *) MyApp->TX_SaveAsFormat, MUIA_Text_Contents, "VRML V2.0 utf8");
	SetAttrs((Object *) MyApp->STR_PA_SaveAs, MUIA_String_Contents, OFile.Complete);
	SetAttrs((Object *) MyApp->GR_SaveAsV1, MUIA_ShowMe, FALSE);
	SetAttrs((Object *) MyApp->GR_SaveAsV2, MUIA_ShowMe, TRUE);
	SetAttrs((Object *) MyApp->GR_SaveAsGL, MUIA_ShowMe, FALSE);
	SetAttrs((Object *) MyApp->WI_SaveAs, MUIA_Window_Open, TRUE);
    }
    else if (obj==MyApp->MNProjectSaveasOpenGL) {
	/*
	rep=OpenASL("Save file",SFile.Dir,SFile.Name,SFile.Complete,SFile.Dir,SFile.Name);
	if (rep) {
	    SaveGL(Main,SFile.Complete);
	};
	*/
	SetAttrs((Object *) MyApp->TX_SaveAsFormat, MUIA_Text_Contents, "OpenGL source code");
	SetAttrs((Object *) MyApp->STR_PA_SaveAs, MUIA_String_Contents, OFile.Complete);
	SetAttrs((Object *) MyApp->GR_SaveAsV1, MUIA_ShowMe, FALSE);
	SetAttrs((Object *) MyApp->GR_SaveAsV2, MUIA_ShowMe, FALSE);
	SetAttrs((Object *) MyApp->GR_SaveAsGL, MUIA_ShowMe, TRUE);
	SetAttrs((Object *) MyApp->WI_SaveAs, MUIA_Window_Open, TRUE);
    }
    else if (obj==MyApp->MNOptionParseroutput) {
	if (parserfd==NULL) {
	    parserfd=fopen(settings.outcon,"w");
	    if (parserfd==NULL) {
		rep=MUI_Request (MyApp->App, MyApp->WI_Main,0,"Parser output","OK",
				 "Can't open parser output...");
	    };
	}
	else {
	    fclose (parserfd);
	    parserfd=NULL;
	};
    }
    else if (obj==MyApp->MNProjectAbout) {
	// SleepAll();
	SetAttrs((Object *) MyApp->WI_About, MUIA_Window_Open, TRUE);
	// sh.about=OPENED;
	// About();
    }
    else if (obj==MyApp->MNProjectAboutMUI) {
	 DoMethod((Object *) MyApp->App, MUIM_Application_AboutMUI, MyApp->WI_Main);
    };
}
//-----------------------------------------------------------
void SelectNode (Object *obj) {
    ULONG store;
    if (sh.mode==SYSTEM) return;
    puts("=>Callback:SelectNode");
    if ((obj==MyApp->LV_MainWorld)||
	(obj==MyApp->CF_MainWorld)) {
	current=MAIN;
	SetAttrs((Object *) MyApp->CF_MainWorld, MUIA_Colorfield_RGB, CFRed);
	SetAttrs((Object *) MyApp->CF_MainClip, MUIA_Colorfield_RGB, CFWhite);
    }
    else if ((obj==MyApp->LV_MainClip)||
	     (obj==MyApp->CF_MainClip)) {
	current=CLIP;
	SetAttrs((Object *) MyApp->CF_MainWorld, MUIA_Colorfield_RGB, CFWhite);
	SetAttrs((Object *) MyApp->CF_MainClip, MUIA_Colorfield_RGB, CFRed);
    };

    if (pt==NODE_ONLY) {
	GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_CyberGL, &store);
	if ((int) store) {
	    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	};
    };

    // puts("<=Callback:SelectNode");
    // return;
}
void ModifyCmd(Object *obj) {
   VRMLNode *node=NULL;
   VRMLGroups *parent=NULL;
   struct MUIS_Listtree_TreeNode *tn=NULL,*tp=NULL;
   ULONG store=0;

   if (sh.mode==SYSTEM) return;
   puts("=>ModifyCmd");

   if (obj==MyApp->LV_MainWorld) {
	// n=LVMain->GetSelected();
	// puts("world");
	current=MAIN;
	SetAttrs((Object *) MyApp->CF_MainWorld, MUIA_Colorfield_RGB, CFRed);
	SetAttrs((Object *) MyApp->CF_MainClip, MUIA_Colorfield_RGB, CFWhite);
   }
   else if (obj==MyApp->LV_MainClip) {
	// n=LVClip->GetSelected();
	puts("clip");
	current=CLIP;
	SetAttrs((Object *) MyApp->CF_MainWorld, MUIA_Colorfield_RGB, CFWhite);
	SetAttrs((Object *) MyApp->CF_MainClip, MUIA_Colorfield_RGB, CFRed);
   };

   GetAttr(MUIA_Listtree_Active, obj, &store);
   tn=(struct MUIS_Listtree_TreeNode *) store;
   if (tn==MUIV_Listtree_Active_Off) return;
   node=(VRMLNode *) tn->tn_User;

   if (node->ID==USE_1) {
       USE *u=(USE *) node;
       node=u->reference;
   };

   if (node->ID&GROUPS) {
       puts("Groups found");
       GroupsWin.Set(node,current);
   }
   else if (node->ID==ASCIITEXT_1) {
       // puts("AsciiText found");
       // node->Print();
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_AsciiText, &store);
       if ((int) store) {
	   AsciiTextWin.Cancel();
       };
       AsciiTextWin.Set(node,current);
   }
   else if (node->ID==CONE_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Cone, &store);
       if ((int) store) {
	   ConeWin.Cancel();
       };
       ConeWin.Set(node,current);
   }
   else if (node->ID==COORDINATE3_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Coordinate3, &store);
       if ((int) store) {
	   Coordinate3Win.Cancel();
       };
       Coordinate3Win.Set(node,current);
   }
   else if (node->ID==CUBE_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Cube, &store);
       if ((int) store) {
	   CubeWin.Cancel();
       };
       CubeWin.Set(node,current);
   }
   else if (node->ID==CYLINDER_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Cylinder, &store);
       if ((int) store) {
	   CylinderWin.Cancel();
       };
       CylinderWin.Set(node,current);
   }
   else if (node->ID==DIRECTIONALLIGHT_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_DirectionalLight, &store);
       if((int) store) {
	   DirectionalLightWin.Cancel();
       };
       DirectionalLightWin.Set(node,current);
   }
   else if (node->ID==FONTSTYLE_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_FontStyle, &store);
       if((int) store) {
	   FontStyleWin.Cancel();
       };
       FontStyleWin.Set(node,current);
   }
   else if (node->ID==INDEXEDFACESET_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_IFS, &store);
       if((int) store) {
	   IFSWin.Cancel();
       };
       IFSWin.Set(node,current);
   }
   else if (node->ID==INFO_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Info, &store);
       if((int) store) {
	   InfoWin.Cancel();
       };
       InfoWin.Set(node,current);
   }
   else if (node->ID==MATERIAL_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Material, &store);
       if((int) store) {
	   MaterialWin.Cancel();
       };
       MaterialWin.Set(node,current);
   }
   else if (node->ID==MATERIALBINDING_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_MaterialBinding, &store);
       if((int) store) {
	   MaterialBindingWin.Cancel();
       };
       MaterialBindingWin.Set(node,current);
   }
   else if (node->ID==MATRIXTRANSFORM_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_MatrixTransform, &store);
       if ((int) store) {
	   MatrixTransformWin.Cancel();
       };
       MatrixTransformWin.Set(node,current);
   }
   else if (node->ID==NORMAL_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Normal, &store);
       if ((int) store) {
	   NormalWin.Cancel();
       };
       NormalWin.Set(node,current);
   }
   else if (node->ID==NORMALBINDING_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_NormalBinding, &store);
       if ((int) store) {
	   NormalBindingWin.Cancel();
       };
       NormalBindingWin.Set(node,current);
   }
   else if (node->ID==POINTLIGHT_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_PointLight, &store);
       if((int) store) {
	   PointLightWin.Cancel();
       };
       PointLightWin.Set(node,current);
   }
   else if (node->ID==POINTSET_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_PointSet, &store);
       if((int) store) {
	   PointSetWin.Cancel();
       };
       PointSetWin.Set(node,current);
   }
   else if (node->ID==ROTATION_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Rotation, &store);
       if((int) store) {
	   RotationWin.Cancel();
       };
       RotationWin.Set(node,current);
   }
   else if (node->ID==SCALE_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Scale, &store);
       if ((int) store) {
	   ScaleWin.Cancel();
       };
       ScaleWin.Set(node,current);
   }
   else if (node->ID==SHAPEHINTS_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_ShapeHints, &store);
       if ((int) store) {
	   ShapeHintsWin.Cancel();
       };
       ShapeHintsWin.Set(node,current);
   }
   else if (node->ID==SPHERE_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Sphere, &store);
       if ((int) store) {
	   SphereWin.Cancel();
       };
       SphereWin.Set(node,current);
   }
   else if (node->ID==SPOTLIGHT_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_SpotLight, &store);
       if ((int) store) {
	   SpotLightWin.Cancel();
       };
       SpotLightWin.Set(node,current);
   }
   else if (node->ID==TEXTURE2_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Texture2, &store);
       if ((int) store) {
	   Texture2Win.Cancel();
       };
       Texture2Win.Set(node,current);
   }
   else if (node->ID==TEXTURE2TRANSFORM_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Texture2Transform, &store);
       if ((int) store) {
	   Texture2TransformWin.Cancel();
       };
       Texture2TransformWin.Set(node,current);
   }
   else if (node->ID==TEXTURECOORDINATE2_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_TextureCoordinate2, &store);
       if ((int) store) {
	   TextureCoordinate2Win.Cancel();
       };
       TextureCoordinate2Win.Set(node,current);
   }
   else if (node->ID==TRANSFORM_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Transform, &store);
       if ((int) store) {
	   TransformWin.Cancel();
       };
       TransformWin.Set(node,current);
   }
   else if (node->ID==TRANSLATION_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_Translation, &store);
       if ((int) store) {
	   TranslationWin.Cancel();
       };
       TranslationWin.Set(node,current);
   }
   else if (node->ID==WWWINLINE_1) {
       GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_WWWInline, &store);
       if ((int) store) {
	   WWWInlineWin.Cancel();
       };
       WWWInlineWin.Set(node,current);
   }

   /*
   switch (n->ID) {
	case AsciiTextID:AsciiTextWin->Set(n,which);
			 break;
	case ConeID:ConeWin->Set(n,which);
		    break;
	case Coordinate3ID:Coordinate3Win->Set(n,which);
			   break;
	case CubeID:CubeWin->Set(n,which);
		    break;
	case CylinderID:CylinderWin->Set(n,which);
			break;
	case DirectionalLightID:DirectionalLightWin->Set(n,which);
				break;
	case FontStyleID:FontStyleWin->Set(n,which);
			 break;
	case IndexedFaceSetID:IFSWin->Set(n,which);
			      break;
	case IndexedLineSetID:ILSWin->Set(n,which);
			      break;
	case InfoID:InfoWin->Set(n,which);
		    break;
	case MaterialID:MaterialWin->Set(n,which);
			break;
	case MaterialBindingID:MaterialBindingWin->Set(n,which);
			       break;
	case MatrixTransformID:MatrixTransformWin->Set(n,which);
			       break;
	case NormalID:NormalWin->Set(n,which);
		      break;
	case NormalBindingID:NormalBindingWin->Set(n,which);
			     break;
	case OrthographicCameraID:OrthoWin->Set(n,which);
				  break;
	case PerspectiveCameraID:PersWin->Set(n,which);
				 break;
	case PointLightID:PointLightWin->Set(n,which);
			  break;
	case PointSetID:PointSetWin->Set(n,which);
			break;
	case RotationID:RotationWin->Set(n,which);
			break;
	case ScaleID:ScaleWin->Set(n,which);
		     break;
	case ShapeHintsID:ShapeHintsWin->Set(n,which);
			  break;
	case SphereID:SphereWin->Set(n,which);
		      break;
	case SpotLightID:SpotLightWin->Set(n,which);
			 break;
	// All group nodes
	case GroupID:
	case LODID:
	case SeparatorID:
	case SwitchID:
	case TransformSeparatorID:
	case WWWAnchorID:
			 if (obj==MyApp->LV_MainWorld) {
			    NodeStack.Push(LVMain->GetGroup());
			    LVMain->SetGroup((VRMLGroups *) n);
			 }
			 else {
			    ClipStack.Push(LVClip->GetGroup());
			    LVClip->SetGroup((VRMLGroups *) n);
			 };
			 break;
	case Texture2ID:Texture2Win->Set(n,which);
			break;
	case Texture2TransformID:Texture2TransformWin->Set(n,which);
				 break;
	case TextureCoordinate2ID:TextureCoordinate2Win->Set(n,which);
				  break;
	case TransformID:TransformWin->Set(n,which);
			 break;
	case TranslationID:TranslationWin->Set(n,which);
			   break;
	case WWWInlineID:WWWInlineWin->Set(n,which);
			 break;
    };
    */
    puts("<=ModifyCmd");
    // return;
}
// Info, Main, Parent
void GroupCmd (Object *obj) {
    // puts("=>GroupCmd");
    /*
    if (obj==MyApp->BT_MainMain) {
	    NodeStack.ClearStack();
	    LVMain->SetGroup((VRMLGroups *) Main);
    }                              
    else if (obj==MyApp->BT_MainClipMain) {
	    ClipStack.ClearStack();
	    LVClip->SetGroup((VRMLGroups *) Clip);
    }                                 
    else if (obj==MyApp->BT_MainParent) {
	    if (NodeStack.Size()>0) {
		LVMain->SetGroup(NodeStack.Pop());
	    };
    }
    else if (obj==MyApp->BT_MainGenerateNormals) {
	    VRMLNode *n=NULL;
	    Coordinate3 *c3=NULL;
	    IndexedFaceSet *ifs=NULL;
	    BOOL loop=TRUE;
	    int i=0;

	    // puts("Generate normals");
	    VRMLGroups *gr=LVMain->GetGroup();
	    for (i=0;i<gr->Size();i++) {
		n=gr->GetChild(i);
		switch (n->type) {
		    case IndexedFaceSetID:
			ifs=(IndexedFaceSet *) n;
			break;
		    case Coordinate3ID:
			c3=(Coordinate3 *) n;
			break;
		};
	    };
	    if ((ifs==NULL)||
		(c3==NULL)) {
		    MUI_Request (MyApp->App, MyApp->WI_Main,0,"Error","OK",
			     "No Coordinate3 or IndexedFaceSet node");
	    }
	    else {
		// puts("trying to generate normals");
		// printf("angle:%f\n",settings.angle);
		PopDown(ifs);
		Normal *n=ProduceNormalNode(&gauge,c3,ifs,settings.angle);
		NormalBinding *nb=new NormalBinding("NONE");
		if (n!=NULL) {
		    gr->InsertChild(0,n);
		    gr->InsertChild(0,nb);
		    LVMain->Refresh();
		};
	    };
    }
    else if (obj==MyApp->BT_MainClipParent) {
	    if (ClipStack.Size()>0) {
		LVClip->SetGroup(ClipStack.Pop());
	    };
    }
    else if ((obj==MyApp->BT_MainGroupInfo)||
	     (obj==MyApp->BT_MainClipGroupInfo)) {
	    VRMLGroups *g;
	    int which;

	    if (obj==MyApp->BT_MainGroupInfo) {
		g=LVMain->GetGroup();
		which=MAIN;
	    }
	    else if (obj==MyApp->BT_MainClipGroupInfo) {
		g=LVClip->GetGroup();
		which=CLIP;
	    };
	    // puts("GroupInfo");
	    switch (g->type) {
		case GroupID:GroupWin->Set((VRMLNode *) g, which);
			     break;
		case LODID:LODWin->Set((VRMLNode *) g, which);
			   break;
		case SeparatorID:SeparatorWin->Set((VRMLNode *) g, which);
				 break;
		case SwitchID:SwitchWin->Set((VRMLNode *) g, which);
			    break;
		case TransformSeparatorID:TransformSeparatorWin->Set((VRMLNode *) g, which);
					break;
		case WWWAnchorID:WWWAnchorWin->Set((VRMLNode *) g, which);
				 break;
	    };

    };                  
    // puts("<=GroupCmd");
    // return;
    */
}
//-----------------------------------------------------------
// MAIN Actions
// middle colums actions and Main/Clipboard copy,clear,delete
// Delete, Copy, MouveUp, MoveDown, MoveRight, MoveLeft Preview
//-----------------------------------------------------------

void ActionsCmd (Object *obj) {
    ULONG store=0;
    VRMLNode *copy1=NULL,*copy2=NULL,*node=NULL,*sourcenode=NULL,*destnode=NULL;
    VRMLGroups *parent=NULL,*sourcegroup=NULL,*destgroup=NULL;
    struct MUIS_Listtree_TreeNode *tn=NULL,*tn2=NULL,*ptn=NULL,*tnmain=NULL,*tnclip=NULL,*ptnmain=NULL,*ptnclip=NULL,*newtn=NULL;
    int pos=-1,rep=0,flags=0;

    if (obj==MyApp->BT_MainAdd) {
       AddWin.Mode(ADDING,(VRMLNode *) GetActiveTreeNode()->tn_User);
    }
    else if (obj==MyApp->BT_MainTransform) {
	AddWin.Mode(TRANSFORMING,(VRMLNode *) GetActiveTreeNode()->tn_User);
    }
    else if (obj==MyApp->BT_AddOk) {
	puts("Add ok pressed");
	VRMLNode *newnode=AddWin.Ok();
	//----------- Init first values if necessary ----------
	if (newnode->ID==ASCIITEXT_1) {
	    puts("asciitext added");
	    AsciiText *a=(AsciiText *) newnode;
	    a->AddTxt(new StringWidth("FIRST",0));
	    // a->AddTxt(new StringWidth("SECOND",0));
	    // a->Print();
	}
	else if (newnode->ID==COORDINATE3_1) {
	    Coordinate3 *c3=(Coordinate3 *) newnode;
	    c3->AddPoint(new Vertex3d(0,0,0));
	}
	else if (newnode->ID==INDEXEDFACESET_1) {
	    IndexedFaceSet *ifs=(IndexedFaceSet *) newnode;
	    Face *f=new Face();
	    f->coordIndex.Add(0);
	    f->coordIndex.Add(0);
	    f->coordIndex.Add(0);
	    ifs->AddFace(f);
	}
	else if (newnode->ID==LOD_1) {
	    LOD *lod=(LOD *) newnode;
	    lod->AddRange(0);
	}
	else if (newnode->ID==MATERIAL_1) {
	    Material *mat=(Material *) newnode;
	    mat->AddMaterial(new Mat());
	}
	else if (newnode->ID==NORMAL_1) {
	    Normal *no=(Normal *) newnode;
	    no->AddVector(new Vertex3d(0.0,0.0,1.0));
	}
	else if (newnode->ID==TEXTURECOORDINATE2_1) {
	    TextureCoordinate2 *tc=(TextureCoordinate2 *) newnode;
	    tc->AddPoint(new Vertex2d(0.0,0.0));
	};
	
	// newnode->Print();
	if (AddWin.GetMode()==ADDING) {
	    struct MUIS_Listtree_TreeNode *tn=NULL,*ptn=NULL;
	    VRMLNode *node=NULL;
	    VRMLGroups *parent=NULL;
	    int pos=0;

	    tn=GetActiveTreeNode();
	    if (tn) {
		node=(VRMLNode *) tn->tn_User;
		// printf("node->ID:%d GROUPS:%d ID&GROUPS:%d\n",node->ID,GROUPS,node->ID&GROUPS);
		if ((node->ID&GROUPS)!=0) {
		    // puts("insert after last one");
		    parent=(VRMLGroups *) node;
		    InsertNode(newnode,parent->Size()-1,parent,tn,tn,current);
		}
		else {
		    ptn=GetParentTreeNode(tn);
		    if (ptn) {
			parent=(VRMLGroups *) ptn->tn_User;
			pos=parent->FindPosition(node);
			// printf("Parent:%s\n",parent->GetName());
			// printf("Insert after node position:%d name:%s\n",pos,node->GetName());
			InsertNode(newnode,pos,parent,ptn,tn,current);
		    };
		};
	    }
	    else {
		delete newnode;
	    };
	}
	else if (AddWin.GetMode()==TRANSFORMING) {
	    struct MUIS_Listtree_TreeNode *tn=NULL,*ptn=NULL;
	    VRMLNode *node=NULL;
	    VRMLGroups *parent=NULL;
	    int pos=0;

	    tn=GetActiveTreeNode();
	    if (tn) {
		node=(VRMLNode *) tn->tn_User;
		ptn=GetParentTreeNode(tn);
		if (ptn) {
		    parent=(VRMLGroups *) ptn->tn_User;
		}
		else {
		    if (current==MAIN) {
			parent=Main;
		    }
		    else {
			parent=Clip;
		    };
		};

		if ((node->ID&GROUPS)&&(newnode->ID&GROUPS)) {
		    if (node->ref==0) {
			VRMLGroups *gr=(VRMLGroups *) node;
			VRMLGroups *ngr=(VRMLGroups *) newnode;

			parent->SetChild(parent->FindPosition(node),newnode);
			while (gr->Size()!=0) {
			    ngr->AddChild(gr->RemoveChild(0));
			};
			if (parent==Main) {
			    Main=ngr;
			}
			else {
			    Clip=ngr;
			};
			delete gr;
			tn->tn_User= newnode;
		    }
		    else {
			MUI_Request (MyApp->App, MyApp->WI_Main,0,"Transformation error","OK",
				     "The transforming node has some USE reference\nPlease delete USE node first before tranforming it !");
			delete newnode;
		    };
		}
		else if (((node->ID&GROUPS)==0)&&((newnode->ID&GROUPS)==0)) {
		    //--- Single node to transform ---
		    if (node->ref==0) {
			parent->SetChild(parent->FindPosition(node),newnode);
			delete node;
			tn->tn_User= newnode;
		    }
		    else {
			MUI_Request (MyApp->App, MyApp->WI_Main,0,"Transformation error","OK",
				     "The transforming node has some USE reference\nPlease delete USE node first before tranforming it !");
			delete newnode;
		    };
		}
		else {
		    MUI_Request (MyApp->App, MyApp->WI_Main,0,"Transformation error","OK",
				 "Can't convert grouping node to no grouping nodes !");
		    delete newnode;
		};
	    }
	    else {
		delete newnode;
	    };
	};
    }
    else if (obj==MyApp->BT_MainDelete) {
	tn=GetActiveTreeNode();
	if (tn) {
	    node=(VRMLNode *) tn->tn_User;
	    PopDown(node);
	    printf("node to delete:%s\n",node->GetName());
	    ptn=GetParentTreeNode(tn);
	    if (ptn) {
		parent=(VRMLGroups *) ptn->tn_User;
		pos=parent->FindPosition(node);
		DeleteNode(pos,parent,ptn,tn,current);
	    }
	    else {
		rep=MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
				 "You couldn't delete the root group");

	    };
	};
    }
    // puts ("=>ActionsCmd");
    /*
    if (obj==MyApp->IM_MainExchangeLeftUp) {
	LVMain->MoveUp();
    }
    else if (obj==MyApp->IM_MainExchangeLeftDown) {
	LVMain->MoveDown();
    }
    else if (obj==MyApp->IM_MainExchangeRightUp) {
	LVClip->MoveUp();
    }
    else if (obj==MyApp->IM_MainExchangeRightDown) {
	LVClip->MoveDown();
    }
    else if (obj==MyApp->BT_MainExchange) {
	if ((LVMain->Selected()==-1)||
	    (LVClip->Selected()==-1)) {
		MUI_Request (MyApp->App,MyApp->WI_Main,0,"Error","Ok",
			     "Humm..I undersrand your query,\n"
			     "but there are not enough node selected\n"
			     "to do an exchange ,^)");
	}
	else {
	    copy1=LVMain->RemoveEntry();
	    copy2=LVClip->RemoveEntry();
	    LVMain->InsertEntry(copy2);
	    LVClip->InsertEntry(copy1);
	};
    }
    */
    else if (obj==MyApp->BT_MainMoveRight) {
	GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
	tnmain=(struct MUIS_Listtree_TreeNode *) store;
	ptnmain=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetEntry,tnmain,MUIV_Listtree_GetEntry_Position_Parent,0);
	if (ptnmain) {
	    sourcegroup=(VRMLGroups *) ptnmain->tn_User;
	    sourcenode=(VRMLNode *) tnmain->tn_User;
	    GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
	    tnclip=(struct MUIS_Listtree_TreeNode *) store;
	    ptnclip=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetEntry,tnclip,MUIV_Listtree_GetEntry_Position_Parent,0);
	    if (tnclip) {
		//--- Do it ---
		if (ptnclip) {
		    destgroup=(VRMLGroups *) ptnclip->tn_User;
		}
		else {
		    puts("PARENT clip is ROOT");
		    ptnclip=tnclip;
		    destgroup=(VRMLGroups *) Clip;
		};
		destnode=(VRMLNode *) tnclip->tn_User;
		InsertNode(sourcenode,destgroup->FindPosition(destnode),destgroup,ptnclip,tnclip,CLIP);
		RemoveNode(sourcegroup->FindPosition(sourcenode),sourcegroup,ptnmain,tnmain,MAIN);
	    }
	    else {
		MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
			     "Don't forget to select the destination node");
	    };
	}
	else {
	    MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
			 "You couldn't move the root group");
	};
    }
    else if (obj==MyApp->BT_MainMoveLeft) {
	GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainClip , &store);
	tnclip=(struct MUIS_Listtree_TreeNode *) store;
	ptnclip=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetEntry,tnclip,MUIV_Listtree_GetEntry_Position_Parent,0);
	if (ptnclip) {
	    sourcegroup=(VRMLGroups *) ptnclip->tn_User;
	    sourcenode=(VRMLNode *) tnclip->tn_User;
	    GetAttr(MUIA_Listtree_Active, (Object *) MyApp->LT_MainWorld , &store);
	    tnmain=(struct MUIS_Listtree_TreeNode *) store;
	    ptnmain=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetEntry,tnmain,MUIV_Listtree_GetEntry_Position_Parent,0);
	    if (tnmain) {
		//--- Do it ---
		if (ptnmain) {
		    destgroup=(VRMLGroups *) ptnmain->tn_User;
		}
		else {
		    // puts("PARENT clip is ROOT");
		    ptnmain=tnmain;
		    destgroup=(VRMLGroups *) Main;
		};
		destnode=(VRMLNode *) tnmain->tn_User;
		InsertNode(sourcenode,destgroup->FindPosition(destnode),destgroup,ptnmain,tnmain,MAIN);
		RemoveNode(sourcegroup->FindPosition(sourcenode),sourcegroup,ptnclip,tnclip,CLIP);
	    }
	    else {
		MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
			     "Don't forget to select the destination node");
	    };
	}
	else {
	    MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
			 "You couldn't move the root group");
	};
    }
    else if (obj==MyApp->BT_MainMoveUp) {
	tn=GetActiveTreeNode();
	ptn=GetParentTreeNode(tn);
	if (ptn) {
	    node=(VRMLNode *) tn->tn_User;
	    parent=(VRMLGroups *) ptn->tn_User;
	    pos=parent->FindPosition(node);
	    printf("position:%d\n",pos);
	    if (current==MAIN) {
		tn2=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Previous,MUIV_Listtree_GetEntry_Flags_SameLevel);
		if (tn2) {
		    // printf("tn2->name:%s\n",tn2->tn_Name);
		    DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_Move,ptn,tn2,ptn,tn,0);
		    parent->ExchangeChildren(pos,pos-1);
		};
	    }
	    else {
		tn2=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Previous,MUIV_Listtree_GetEntry_Flags_SameLevel);
		if (tn2) {
		    DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_Move,ptn,tn2,ptn,tn,0);
		    parent->ExchangeChildren(pos,pos-1);
		};
	    };
	};
    }
    else if (obj==MyApp->BT_MainMoveDown) {
	tn=GetActiveTreeNode();
	ptn=GetParentTreeNode(tn);
	if (ptn) {
	    node=(VRMLNode *) tn->tn_User;
	    parent=(VRMLGroups *) ptn->tn_User;
	    pos=parent->FindPosition(node);
	    printf("position:%d\n",pos);
	    if (current==MAIN) {
		tn2=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Next,MUIV_Listtree_GetEntry_Flags_SameLevel);
		if (tn2) {
		    DoMethod((Object *) MyApp->LT_MainWorld,MUIM_Listtree_Move,ptn,tn,ptn,tn2,0);
		    parent->ExchangeChildren(pos,pos+1);
		    SetAttrs((Object *) MyApp->LT_MainWorld, MUIA_Listtree_Active, tn);
		};
	    }
	    else {
		tn2=(struct MUIS_Listtree_TreeNode *) DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_GetEntry,tn,MUIV_Listtree_GetEntry_Position_Next,MUIV_Listtree_GetEntry_Flags_SameLevel);
		if (tn2) {
		    DoMethod((Object *) MyApp->LT_MainClip,MUIM_Listtree_Move,ptn,tn,ptn,tn2,0);
		    parent->ExchangeChildren(pos,pos+1);
		    SetAttrs((Object *) MyApp->LT_MainClip, MUIA_Listtree_Active, tn);
		};
	    };
	};
    }
    else if (obj==MyApp->BT_MainClear) {
	if (current==MAIN) {
	    delete Main;
	    Main=(VRMLGroups *) new Separator("ROOT");
	    DoMethod((Object *) MyApp->LT_MainWorld, MCCM_DDListtree_Init, (VRMLNode *) Main);
	}
	else {
	    delete Clip;
	    Clip=(VRMLGroups *) new Separator("CLIP");
	    DoMethod((Object *) MyApp->LT_MainClip, MCCM_DDListtree_Init, (VRMLNode *) Clip);
	};
    }
    else if (obj==MyApp->BT_MainCopy) {
	tn=GetActiveTreeNode();
	if (tn) {
	    node=(VRMLNode *) tn->tn_User;
	    printf("node to delete:%s\n",node->GetName());
	    ptn=GetParentTreeNode(tn);
	    if (ptn) {
		parent=(VRMLGroups *) ptn->tn_User;
		pos=parent->FindPosition(node);
		rep=MUI_Request(MyApp->App,MyApp->WI_Main,0,"Select copy type","Clone|USE",
			"Select what type of copy !\n\n"
			"Clone create a new node\n"
			"USE create only a reference to the selected node");
		if (rep==1) {
		    copy1=node->Clone();
		    InsertNode((VRMLNode *) copy1,pos,parent,ptn,tn,current);
		}
		else {
		    if (!strcmp(node->GetName(),"NONE")) {
			MUI_Request(MyApp->App,MyApp->WI_Main,0,"Error","Ok",
				    "The referenced node as no DEF NAME\n\n"
				    "Define a name first");
		    }
		    else {
			USE *u=new USE("NONE");
			node->ref++;
			u->reference=node;
			InsertNode((VRMLNode *) u,pos,parent,ptn,tn,current);
		    };
		};
	    }
	    else {
		rep=MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
				 "You couldn't delete the root group");
	    };
	};
    };
    /*
    else if (obj==MyApp->BT_MainClipCopy) {
	VRMLNode *n=LVClip->GetSelectedChild();
	if (n==NULL) {
	    // puts("<=ActionsCmd");
	    return;
	};
	copy1=n->Clone();
	LVClip->InsertEntry(copy1);
    };
    // DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_Draw, MADF_DRAWOBJECT);
    GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_CyberGL, &store);
    if ((int) store) {
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    };
    // puts("<=ActionsCmd");
    // return;
    */
}
//---------------------
// Load or save a node
//--------------------
void InOutCmd (Object *obj) {
    int rep=0;
    ULONG store=0;
    VRMLGroups *gr=NULL;
    VRMLNode *n=NULL;
    struct MUIS_Listtree_TreeNode *tn=NULL,*ptn=NULL;

    puts("=>InOutCmd");

    if (obj==MyApp->BT_SaveAsSave) {
	GetAttr(MUIA_Text_Contents, (Object *) MyApp->TX_SaveAsFormat, &store);
	if (!strcmp((char *) store,"VRML V1.0 ascii")) {
	    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PA_SaveAs, &store);
	    strcpy(SFile.Complete,(char *) store);
	    if (strcmp((char *) store,"")) {
		printf("saving file %s in V1 format\n",(char *) store);
		Save(Main,(char *) store,settings.V1GenTex,settings.V1GenInlines,settings.V1Gzip);
	    };
	}
	else if (!strcmp((char *) store,"VRML V2.0 utf8")) {
	    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PA_SaveAs, &store);
	    strcpy(SFile.Complete,(char *) store);
	    if (strcmp((char *) store,"")) {
		printf("saving file %s in V2 format\n",(char *) store);
		Save2(Main,(char *) store,settings.V2GenTex);
	    };
	}
	else if (!strcmp((char *) store,"OpenGL source code")) {
	    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PA_SaveAs, &store);
	    if (strcmp((char *) store,"")) {
		printf("saving file %s in OpenGL format\n",(char *) store);
		SaveGL(Main,(char *) store);
	    };
	};
    }
    else if (obj==MyApp->CH_SaveAsV1Tex) {
	GetAttr(MUIA_Selected, (Object *) obj, &store);
	settings.V1GenTex=(BOOL) store;
    }
    else if (obj==MyApp->CH_SaveAsV1Inlines) {
	GetAttr(MUIA_Selected, (Object *) obj, &store);
	settings.V1GenInlines=(BOOL) store;
    }
    else if (obj==MyApp->CH_SaveAsV1Compress) {
	GetAttr(MUIA_Selected, (Object *) obj, &store);
	settings.V1Gzip=(BOOL) store;
    }
    else if (obj==MyApp->CH_SaveAsV1Normals) {
	GetAttr(MUIA_Selected, (Object *) obj, &store);
	settings.V1GenNormals=(BOOL) store;
    }
    else if (obj==MyApp->CH_SaveAsV2Tex) {
	GetAttr(MUIA_Selected, (Object *) obj, &store);
	settings.V2GenTex=(BOOL) store;
    }
    else if (obj==MyApp->CH_SaveAsGLTex) {
	GetAttr(MUIA_Selected, (Object *) obj, &store);
	settings.GLTex=(BOOL) store;
    }
    else if (obj==MyApp->BT_MainInsert) {
	char complete[255],dir[255],name[255];

	tn=GetActiveTreeNode();
	ptn=GetParentTreeNode(tn);
	if (tn) {
	    rep=OpenASL("Load file",OFile.Dir,NULL,complete,dir,name);
	    if (rep==1) {
		VRMLNode *newnode=Load(complete);
		if (newnode) {
		    n=(VRMLNode *) tn->tn_User;
		    if (ptn) {
			gr=(VRMLGroups *) ptn->tn_User;
		    }
		    else {
			ptn=tn;
			if (current==MAIN) {
			    gr=Main;
			}
			else {
			    gr=Clip;
			};
		    };
		    InsertNode(newnode,gr->FindPosition(n),gr,ptn,tn,current);
		};
	    };
	}
	else {
	    MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
			 "Please select a node first");
	};
    }
    else if (obj==MyApp->BT_MainSave) {
	char complete[255],dir[255],name[255];
	tn=GetActiveTreeNode();
	if (tn) {
	    rep=OpenASL("Save file",OFile.Dir,NULL,complete,dir,name);
	    if (rep==1) {
		n=(VRMLNode *) tn->tn_User;
		gr=(VRMLGroups *) new Separator("ROOT");
		gr->AddChild(n);
		Save((VRMLNode *) gr,complete,FALSE,FALSE,FALSE);
		gr->RemoveChild(0);
		delete gr;
	    };
	}
	else {
	    MUI_Request (MyApp->App, MyApp->WI_Main,0,"Command error","OK",
			 "Please select a node first");
	};
    };
    // puts("<=InOutCmd");
    // return;

}
//----------------------------------- GROUPS WINDOW --------------------------------------
void GroupsChangeContents(Object *obj) {
    VRMLGroups *parent=NULL;
    puts("Groups change contents");
    if ((obj==MyApp->STR_DEFGroupsName)||
	(obj==MyApp->CY_SeparatorRenderCulling)||
	(obj==MyApp->STR_SwitchWhich)||
	(obj==MyApp->STR_WWWAnchorName)||
	(obj==MyApp->STR_WWWAnchorDescription)||
	(obj==MyApp->CY_WWWAnchorMap)||
	(obj==MyApp->STR_LODCenterX)||
	(obj==MyApp->STR_LODCenterY)||
	(obj==MyApp->STR_LODCenterZ)) {
	GroupsWin.ReadValues();
    }
    else if (obj==MyApp->STR_LODRange) {
	GroupsWin.ReadValuesLOD();
    }
    else if (obj==MyApp->PR_LODRangeIndex) {
	GroupsWin.RefreshLOD();
    }
    else if (obj==MyApp->BT_LODAdd) {
	GroupsWin.Add();
    }
    else if (obj==MyApp->BT_LODDelete) {
	GroupsWin.Delete();
    };
}
//------------------------------------------- PREFS WINDOW ------------------------------------
void PrefsCmd (Object *obj) {
    if (sh.mode==SYSTEM) return;
    ULONG store=0;
    // puts("Global cmd");
    if (obj==MyApp->STR_PrefsOutput) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsOutput, &store);
	strncpy(settings.outcon,(char *) store, 80);
    }
    else if (obj==MyApp->RA_PrefsType) {
	GetAttr(MUIA_Radio_Active, (Object *) MyApp->RA_PrefsType, &store);
	switch ((int) store) {
	    case 0:settings.msgmode=ONLYERRORS;break;
	    case 1:settings.msgmode=ALLMSG;break;
	};
    }
    else if (obj==MyApp->CH_PrefsResolve) {
	GetAttr(MUIA_Selected, (Object *) MyApp->CH_PrefsResolve, &store);
	if ((BOOL) store) {settings.resolve=RESOLVE;}
	else {settings.resolve=NORESOLVE;};
    }
    else if ((obj==MyApp->STR_PrefsR)||
	     (obj==MyApp->STR_PrefsG)||
	     (obj==MyApp->STR_PrefsB)) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsR, &store);
	settings.brgb[0]=atof((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsG, &store);
	settings.brgb[1]=atof((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsB, &store);
	settings.brgb[2]=atof((char *) store);

	GetAttr(MUIA_GLArea_Active, (Object *) MyApp->AR_CyberGLArea, &store);
	if ((BOOL) store) {
	    // glClearColor(settings.brgb[0],settings.brgb[1],settings.brgb[2],1.0);
	};
    }
    else if ((obj==MyApp->STR_PrefsConeResolution)||
	     (obj==MyApp->STR_PrefsCylinderResolution)||
	     (obj==MyApp->STR_PrefsSphereResolution)) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsConeResolution, &store);
	settings.coneres=atoi((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsCylinderResolution, &store);
	settings.cylinderres=atoi((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsSphereResolution, &store);
	settings.sphereres=atoi((char *) store);
	// printf("Resolution:%d %d %d\n",st->coneres,st->cylinderres,st->sphereres);
    }
    else if (obj==MyApp->BT_PrefsSave) {
	FILE *fset=NULL;
	fset=fopen("ENVARC:VRMLEditor.prefs","w");
	// puts("Saving");
	if (fset) {
	    fprintf(fset,"$VER 0.70\n");
	    fprintf(fset,"%d\n",strlen(settings.outcon));
	    fprintf(fset,"%s\n",settings.outcon);
	    fprintf(fset,"%d %d\n",settings.msgmode,settings.resolve);
	    fprintf(fset,"%0.2f %0.2f %0.2f\n",settings.brgb[0],settings.brgb[1],settings.brgb[2]);
	    fprintf(fset,"%x %d\n",settings.displayID,settings.displayDepth);
	    fprintf(fset,"%d %d %d\n",settings.coneres,settings.cylinderres,settings.sphereres);
	    fprintf(fset,"%2.2f\n",settings.angle);
	    fprintf(fset,"%s\n",settings.gzip);
	    fprintf(fset,"%d %d %d %d\n",settings.V1GenTex,settings.V1GenInlines,settings.V1Gzip,settings.V1GenNormals);
	    fclose(fset);
	    system("copy ENVARC:VRMLEditor.prefs to ENV:");
	};
    }
    else if (obj==MyApp->STR_PrefsGZip) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsGZip, &store);
	strncpy(settings.gzip,(char *) store,255);
    }
    else if (obj==MyApp->STR_PrefsAngle) {
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PrefsAngle, &store);
	settings.angle=atof((char *) store);
    };
    return;
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
	puts("Req is NULL");
	return 0;
    };
    settings.displayID=(int) req->sm_DisplayID;
    settings.displayDepth=(int) req->sm_DisplayDepth;
    // printf("DisplayID:%x\n",settings.displayID);
    ConvertDisplayID(idname,settings.displayID);
    // printf("Name:%s\n",idname);
    SetAttrs((Object *) MyApp->TX_PA_PrefsScreen, MUIA_Text_Contents, idname);
    return TRUE;
}
//------------------------------------ MESHWRITER WINDOW ----------------------------------------
void MWCmd(Object *obj) {
    puts("MWCmd");
    STRPTR *formatlist=MWL3DFileFormatNamesGet();
    ULONG store;

    if (obj==MyApp->CY_MWFormat) {
	GetAttr(MUIA_Cycle_Active,(Object *) MyApp->CY_MWFormat, &store);
	SetAttrs((Object *) MyApp->STR_MWExtension, MUIA_String_Contents,
		  MWL3DFileFormatExtensionGet(MWL3DFileFormatIDGet(formatlist[store])));
    }
    else if (obj==MyApp->BT_MWSave) {
	GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_PA_MWName, &store);
	strcpy(SFile.Complete, (char *) store);
	GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_MWFormat, &store);
	printf("id:%d\n",(int) store);
	Export(Main, SFile.Complete, MWL3DFileFormatIDGet(formatlist[store]));
	printf("Filename:%s\n",store);
    };
}
//------------------------------------- ASCIITEXT WINDOW -----------------------------------------
void AsciiTextChangeContents(Object *obj) {
    puts("ASCIITEXT WIN");
    if (sh.mode==SYSTEM) {return;};
    if ((obj==MyApp->STR_DEFAsciiTextName)||
	(obj==MyApp->STR_AsciiTextSpacing)||
	(obj==MyApp->CY_AsciiTextJustification)||
	(obj==MyApp->STR_AsciiTextString)||
	(obj==MyApp->STR_AsciiTextWidth)) {
	AsciiTextWin.ReadValues();
    }
    else if (obj==MyApp->LV_AsciiTextStrings) {
	// puts("LV moved");
	AsciiTextWin.RefreshString();
    }
    else if (obj==MyApp->BT_AsciiTextAdd) {
	puts("String add");
	AsciiTextWin.Add();
    }
    else if (obj==MyApp->BT_AsciiTextDelete) {
	AsciiTextWin.Delete();
    };
    // return;
}
//-------------------------------------- COORDINATE3 WINDOW ----------------------------------------
void CoordinateChangeContents(Object *obj) {
    puts("COORDINATE3 WIN");

    if (sh.mode==SYSTEM) return;
    if ((obj==MyApp->STR_DEFCoordinate3Name)||
	(obj==MyApp->STR_Coordinate3X)||
	(obj==MyApp->STR_Coordinate3Y)||
	(obj==MyApp->STR_Coordinate3Z)) {
	Coordinate3Win.ReadValues();
    }
    else if(obj==MyApp->PR_Coordinate3Index) {
	Coordinate3Win.Refresh();
    }
    else if(obj==MyApp->BT_Coordinate3Add) {
	Coordinate3Win.Add();
	// Coordinate3Win.ReadValues();
    }
    else if(obj==MyApp->BT_Coordinate3Delete) {
	Coordinate3Win.Delete();
	// Coordinate3Win.ReadValues();
    };
    // return;
}
//--------------------------------------- INDEXEDFACESET WINDOW ---------------------------------------
void IFSChangeContents (Object *obj) {
    puts("INDEXEDFACESET WIN");
    if (sh.mode==SYSTEM) return;

    if(obj==MyApp->PR_IFSIndex) {
	IFSWin.Refresh();
    }
    else if ((obj==MyApp->LV_IFSCoordIndex)||
	     (obj==MyApp->LV_IFSMaterialIndex)||
	     (obj==MyApp->LV_IFSNormalIndex)||
	     (obj==MyApp->LV_IFSTexIndex)) {
	IFSWin.RefreshValue();
    }
    else if ((obj==MyApp->STR_IFSValue)||
	     (obj==MyApp->STR_DEFIFSName)||
	     (obj==MyApp->STR_IFSMatValue)||
	     (obj==MyApp->STR_IFSNormalValue)||
	     (obj==MyApp->STR_IFSTexValue)) {
	IFSWin.ReadValues();
    }
    else if (obj==MyApp->BT_IFSAddPoint) {
	IFSWin.AddPoint();
    }
    else if (obj==MyApp->BT_IFSDeletePoint) {
	IFSWin.DeletePoint();
    }
    else if (obj==MyApp->BT_IFSAddMat) {
	IFSWin.AddMat();
    }
    else if (obj==MyApp->BT_IFSDeleteMat) {
	IFSWin.DeleteMat();
    }
    else if (obj==MyApp->BT_IFSAddNormal) {
	IFSWin.AddNormal();
    }
    else if (obj==MyApp->BT_IFSDeleteNormal) {
	IFSWin.DeleteNormal();
    }
    else if (obj==MyApp->BT_IFSAddTex) {
	IFSWin.AddTexture();
    }
    else if (obj==MyApp->BT_IFSDeleteTex) {
	IFSWin.DeleteTexture();
    }
    else if (obj==MyApp->BT_IFSAddFace) {
	IFSWin.AddFace();
    }
    else if (obj==MyApp->BT_IFSDeleteFace) {
	IFSWin.DeleteFace();
    };
    // return;
}
//------------------------------ INDEXEDLINESET WINDOW ------------------------------
void ILSChangeContents (Object *obj) {
    /*
    if (sh.mode==SYSTEM) return;
    // puts("INDEXEDLINESET WIN");
    if(obj==MyApp->PR_ILSIndex) {
	ILSWin->Refresh();
    }
    else if ((obj==MyApp->LV_ILSCoordIndex)||
	     (obj==MyApp->LV_ILSMaterialIndex)||
	     (obj==MyApp->LV_ILSNormalIndex)||
	     (obj==MyApp->LV_ILSTexIndex)) {
	ILSWin->RefreshValue();
    }
    else if ((obj==MyApp->STR_ILSValue)||
	     (obj==MyApp->STR_DEFILSName)||
	     (obj==MyApp->STR_ILSMatValue)||
	     (obj==MyApp->STR_ILSNormalValue)||
	     (obj==MyApp->STR_ILSTexValue)) {
	ILSWin->ReadValues();
    }
    else if (obj==MyApp->BT_ILSAddPoint) {
	ILSWin->AddPoint();
    }
    else if (obj==MyApp->BT_ILSDeletePoint) {
	ILSWin->DeletePoint();
    }
    else if (obj==MyApp->BT_ILSAddMat) {
	ILSWin->AddMat();
    }
    else if (obj==MyApp->BT_ILSDeleteMat) {
	ILSWin->DeleteMat();
    }
    else if (obj==MyApp->BT_ILSAddNormal) {
	ILSWin->AddNormal();
    }
    else if (obj==MyApp->BT_ILSDeleteNormal) {
	ILSWin->DeleteNormal();
    }
    else if (obj==MyApp->BT_ILSAddTex) {
	ILSWin->AddTexture();
    }
    else if (obj==MyApp->BT_ILSDeleteTex) {
	ILSWin->DeleteTexture();
    }
    else if (obj==MyApp->BT_ILSAddLine) {
	ILSWin->AddLine();
    }
    else if (obj==MyApp->BT_ILSDeleteLine) {
	ILSWin->DeleteLine();
    };
    */
    // return;
}
/*------------------------------
    LOD WINDOW
-------------------------------*/
void LODChangeContents(Object *obj) {
    /*
    if (sh.mode==SYSTEM) return;
    // puts("LOD WIN");
    if ((obj==MyApp->STR_DEFLODName)||
	(obj==MyApp->STR_LODCenterX)||
	(obj==MyApp->STR_LODCenterY)||
	(obj==MyApp->STR_LODCenterZ)||
	(obj==MyApp->STR_LODRange)) {
	    LODWin->ReadValues();
    }
    else if (obj==MyApp->PR_LODRangeIndex) {
	    LODWin->Refresh();
    }
    else if (obj==MyApp->BT_LODAdd) {
	    LODWin->Add();
    }
    else if (obj==MyApp->BT_LODDelete) {
	    LODWin->Delete();
    };
    */
    // return;
}
//------------------------------------ MATERIAL WINDOW -------------------------------------
void MatChangeContents(Object *obj) {

    if (sh.mode==SYSTEM) return;
    puts("MATERIAL WIN");
    if ((obj==MyApp->STR_DEFMaterialName)||
	(obj==MyApp->STR_MaterialShininess)||
	(obj==MyApp->STR_MaterialTransparency)) {
	MaterialWin.ReadValues();
    }
    else if ((obj==MyApp->SL_MaterialAR)||
	     (obj==MyApp->SL_MaterialAG)||
	     (obj==MyApp->SL_MaterialAB)) {
	MaterialWin.ReadAmbient();
    }
    else if((obj==MyApp->SL_MaterialDR)||
	    (obj==MyApp->SL_MaterialDG)||
	    (obj==MyApp->SL_MaterialDB)) {
	MaterialWin.ReadDiffuse();
    }
    else if((obj==MyApp->SL_MaterialSR)||
	    (obj==MyApp->SL_MaterialSG)||
	    (obj==MyApp->SL_MaterialSB)) {
	MaterialWin.ReadSpecular();
    }
    else if((obj==MyApp->SL_MaterialER)||
	    (obj==MyApp->SL_MaterialEG)||
	    (obj==MyApp->SL_MaterialEB)) {
	MaterialWin.ReadEmissive();
    }
    else if (obj==MyApp->PR_MaterialIndex) {
	MaterialWin.Refresh();
    }
    else if(obj==MyApp->BT_MaterialAdd) {
	MaterialWin.Add();
    }
    else if(obj==MyApp->BT_MaterialDelete) {
	MaterialWin.Delete();
    };
    // MaterialWin.Get()->Print();
    DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
    // return;
}
//----------------------------- NORMAL WINDOW ------------------------------
void NormalChangeContents(Object *obj) {
    if (sh.mode==SYSTEM) return;
    if (obj==MyApp->PR_NormalIndex) {
	    NormalWin.Refresh();
    }
    else if ((obj==MyApp->STR_NormalX)||
	     (obj==MyApp->STR_NormalY)||
	     (obj==MyApp->STR_NormalZ)||
	     (obj==MyApp->STR_DEFNormalName)) {
	    NormalWin.ReadValues();
    }
    else if (obj==MyApp->BT_NormalAdd) {
	    NormalWin.Add();
    }
    else if (obj==MyApp->BT_NormalDelete) {
	    NormalWin.Delete();
    };
    // return;
}
/*----------------------------------
    ORTHOGRAPHICCAMERA WINDOW
----------------------------------*/
void OrthoChangeContents(Object *obj) {
    /*
    if (sh.mode==SYSTEM) return;
    // puts("OrthiWin");
    if ((obj==MyApp->STR_DEFOrthographicCameraName)||
	(obj==MyApp->STR_OrthographicCameraPosX)||
	(obj==MyApp->STR_OrthographicCameraPosY)||
	(obj==MyApp->STR_OrthographicCameraPosZ)||
	(obj==MyApp->STR_OrthographicCameraOX)||
	(obj==MyApp->STR_OrthographicCameraOY)||
	(obj==MyApp->STR_OrthographicCameraOZ)||
	(obj==MyApp->STR_OrthographicCameraOAngle)||
	(obj==MyApp->STR_OrthographicCameraFocal)||
	(obj==MyApp->STR_OrthographicCameraHeight)) {
	OrthoWin->ReadValues();
    }
    else if (obj==MyApp->BT_OrthographicCameraView) {
	mycamera=InitCamera(OrthoWin->GetOC());
	// puts("View");
	float nx,ny,nz;
	float x=0,y=0,z=1;
	OrthographicCamera *oc=OrthoWin->GetOC();
	mycamera.X=oc->position.coord[0];
	mycamera.Y=oc->position.coord[1];
	mycamera.Z=oc->position.coord[2];
	angleX=0;oldangleX=0;
	angleY=0;oldangleY=0;
	glLoadIdentity();
	glRotated(oc->orientation.coord[3]/0.017447,oc->orientation.coord[0],
		  oc->orientation.coord[1],oc->orientation.coord[2]);
	glGetFloatv(GL_MODELVIEW_MATRIX,MTC);
	// PrintMTC();
	nx=MTC[0]*x+MTC[1]*y+MTC[2]*z+MTC[3];
	ny=MTC[4]*x+MTC[5]*y+MTC[6]*z+MTC[7];
	nz=MTC[8]*x+MTC[9]*y+MTC[10]*z+MTC[11];
	mycamera.heading=acos(nx)/0.017447;
	mycamera.pitch=asin(ny)/0.017447;
	mycamera.heading-=90;
	// mycamera.pitch-=90;
	RefreshCoord();
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity();
	glOrtho ((double) -oc->height, (double) oc->height,-oc->height,oc->height,0.1,6000.0);
	glMatrixMode (GL_MODELVIEW);


	printf("n=%.4f %.4f %.4f\n",nx,ny,nz);
	printf("heading=%.4f\n",mycamera.heading);
	printf("pitch=%.4f\n",mycamera.pitch);

	// DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_Draw, MADF_DRAWOBJECT);
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    }
    else if (obj==MyApp->BT_OrthographicCameraGrab) {
	OrthographicCamera *oc=OrthoWin->GetOC();
	oc->position.Set(mycamera.X,mycamera.Y,mycamera.Z);
	OrthoWin->Refresh();
    };
    */
    // return;
}
/*--------------------------------
    PERSPECTIVECAMERA WINDOW
----------------------------------*/
void PerspectiveChangeContents(Object *obj) {
    /*
    if (sh.mode==SYSTEM) return;
    if ((obj==MyApp->STR_DEFPerspectiveCameraName)||
	(obj==MyApp->STR_PerspectiveCameraX)||
	(obj==MyApp->STR_PerspectiveCameraY)||
	(obj==MyApp->STR_PerspectiveCameraZ)||
	(obj==MyApp->STR_PerspectiveCameraOX)||
	(obj==MyApp->STR_PerspectiveCameraOY)||
	(obj==MyApp->STR_PerspectiveCameraOZ)||
	(obj==MyApp->STR_PerspectiveCameraOAngle)||
	(obj==MyApp->STR_PerspectiveCameraFocal)||
	(obj==MyApp->STR_PerspectiveCameraHeight)) {
	PersWin->ReadValues();
    }
    else if (obj==MyApp->BT_PerspectiveCameraView) {
	mycamera=InitCamera(PersWin->GetPC());


	float nx,ny,nz;
	float x=0,y=0,z=1;
	PerspectiveCamera *pc=PersWin->GetPC();
	mycamera.X=pc->position.coord[0];
	mycamera.Y=pc->position.coord[1];
	mycamera.Z=pc->position.coord[2];
	angleX=0;oldangleX=0;
	angleY=0;oldangleY=0;
	glLoadIdentity();
	glRotated(pc->orientation.coord[3]/0.017447,pc->orientation.coord[0],
		  pc->orientation.coord[1],pc->orientation.coord[2]);
	glGetFloatv(GL_MODELVIEW_MATRIX,MTC);
	// PrintMTC();
	nx=MTC[0]*x+MTC[1]*y+MTC[2]*z+MTC[3];
	ny=MTC[4]*x+MTC[5]*y+MTC[6]*z+MTC[7];
	nz=MTC[8]*x+MTC[9]*y+MTC[10]*z+MTC[11];
	mycamera.heading=acos(nx)/0.017447;
	mycamera.pitch=asin(ny)/0.017447;
	mycamera.heading-=90;
	// mycamera.pitch-=90;
	RefreshCoord();
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity();
	glPerspective (pc->height*180/3.1415,1.333,0.1,6000.0);
	glMatrixMode (GL_MODELVIEW);

	printf("n=%.4f %.4f %.4f\n",nx,ny,nz);
	printf("heading=%.4f\n",mycamera.heading);
	printf("pitch=%.4f\n",mycamera.pitch);


	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    }
    else if (obj==MyApp->BT_PerspectiveCameraGrab) {
	PerspectiveCamera *pc=PersWin->GetPC();
	pc->position.Set(mycamera.X,mycamera.Y,mycamera.Z);
	PersWin->Refresh();
    };
    */
    // return;
}
/*----------------------------------- TEXTURE2/DISPLAY WINDOWS --------------------------------*/
void Texture2ChangeContents(Object *obj) {
    ULONG store=0;

    puts("Texture2ChangeContents");
    if (sh.mode==SYSTEM) return;
    puts("Calling correspondant function");
    if ((obj==MyApp->STR_DEFTexture2Name)||
	     (obj==MyApp->CY_Texture2WrapS)||
	     (obj==MyApp->CY_Texture2WrapT)) {
	     Texture2Win.ReadValues();
    }
    else if (obj==MyApp->STR_PA_Texture2) {
	    Texture2Win.LoadImage();
    };
    /*
    else if (obj==MyApp->BT_Texture2Show) {
	    Texture2Win.ShowImage();
    };
    */
}
/*----------------------------------- TEXTURECOORDINATE2 WINDOW -------------------------------------*/
void TextureCoordinate2ChangeContents(Object *obj) {
    ULONG store=0;

    if (sh.mode==SYSTEM) return;
    if (obj==MyApp->PR_TextureCoordinate2Index) {
	    TextureCoordinate2Win.Refresh();
    }
    else if ((obj==MyApp->STR_TextureCoordinate2X)||
	     (obj==MyApp->STR_TextureCoordinate2Y)||
	     (obj==MyApp->STR_DEFTextureCoordinate2Name)) {
	    TextureCoordinate2Win.ReadValues();
    }
    else if (obj==MyApp->BT_TextureCoordinate2Add) {
	    TextureCoordinate2Win.Add();
    }
    else if (obj==MyApp->BT_TextureCoordinate2Delete) {
	    TextureCoordinate2Win.Delete();
    };
    // return;
}
/*------------------------------
   COMMON WINDOW CALLBACKS
 ------------------------------*/
// Ok button clicked
void OkFunc(Object *obj) {
    int which;
    ULONG store=0;
    // puts("=>OkFunc");
    // status=v1;

    if (obj==MyApp->BT_AsciiTextOk) {
	which=AsciiTextWin.Ok();
    }
    else if(obj==MyApp->BT_ConeOk) {
	which=ConeWin.Ok();
    }
    else if (obj==MyApp->BT_Coordinate3Ok) {
	which=Coordinate3Win.Ok();
    }
    else if (obj==MyApp->BT_CubeOk) {
	which=CubeWin.Ok();
    }
    else if (obj==MyApp->BT_CylinderOk) {
	which=CylinderWin.Ok();
    }
    else if (obj==MyApp->BT_DirectionalLightOk) {
	which=DirectionalLightWin.Ok();
    }
    else if (obj==MyApp->BT_FontStyleOk) {
	which=FontStyleWin.Ok();
    }
    else if (obj==MyApp->BT_GroupsOk) {
	return;
    }
    else if (obj==MyApp->BT_IFSOk) {
	which=IFSWin.Ok();
    }
    /*
    else if (obj==MyApp->BT_ILSOk) {
	which=ILSWin->Ok();
    }
    */
    else if (obj==MyApp->BT_InfoOk) {
	which=InfoWin.Ok();
    }
    else if (obj==MyApp->BT_MaterialOk) {
	which=MaterialWin.Ok();
    }
    else if (obj==MyApp->BT_MaterialBindingOk) {
	which=MaterialBindingWin.Ok();
    }
    else if (obj==MyApp->BT_MatrixTransformOk) {
	which=MatrixTransformWin.Ok();
    }
    else if (obj==MyApp->BT_NormalOk) {
	which=NormalWin.Ok();
    }
    else if (obj==MyApp->BT_NormalBindingOk) {
	which=NormalBindingWin.Ok();
    }
    /*
    else if (obj==MyApp->BT_OrthographicCameraOk) {
	which=OrthoWin->Ok();
    }
    else if (obj==MyApp->BT_PerspectiveCameraOk) {
	which=PersWin->Ok();
    }
    */
    else if (obj==MyApp->BT_PointLightOk) {
	which=PointLightWin.Ok();
    }
    else if (obj==MyApp->BT_PointSetOk) {
	which=PointSetWin.Ok();
    }
    else if (obj==MyApp->BT_RotationOk) {
	which=RotationWin.Ok();
    }
    else if (obj==MyApp->BT_ScaleOk) {
	which=ScaleWin.Ok();
    }
    else if (obj==MyApp->BT_ShapeHintsOk) {
	which=ShapeHintsWin.Ok();
    }
    else if (obj==MyApp->BT_SphereOk) {
	which=SphereWin.Ok();
    }
    else if (obj==MyApp->BT_SpotLightOk) {
	which=SpotLightWin.Ok();
    }
    else if (obj==MyApp->BT_Texture2Ok) {
	which=Texture2Win.Ok();
    }
    else if (obj==MyApp->BT_Texture2TransformOk) {
	which=Texture2TransformWin.Ok();
    }
    else if (obj==MyApp->BT_TextureCoordinate2Ok) {
	which=TextureCoordinate2Win.Ok();
    }
    else if (obj==MyApp->BT_TransformOk) {
	which=TransformWin.Ok();
    }
    else if (obj==MyApp->BT_TranslationOk) {
	which=TranslationWin.Ok();
    }
    else if (obj==MyApp->BT_WWWInlineOk) {
	which=WWWInlineWin.Ok();
    };
}
// Cancel clicked
void CancelFunc(Object *obj) {
    // puts("Cancel button clicked");

    if (obj==MyApp->BT_AsciiTextCancel) {
	AsciiTextWin.Cancel();
    }
    else if (obj==MyApp->BT_ConeCancel) {
	ConeWin.Cancel();
    }
    else if (obj==MyApp->BT_Coordinate3Cancel) {
	Coordinate3Win.Cancel();
    }
    else if (obj==MyApp->BT_CubeCancel) {
	CubeWin.Cancel();
    }
    else if (obj==MyApp->BT_CylinderCancel) {
	CylinderWin.Cancel();
    }
    else if (obj==MyApp->BT_DirectionalLightCancel) {
	DirectionalLightWin.Cancel();
    }
    else if (obj==MyApp->BT_FontStyleCancel) {
	FontStyleWin.Cancel();
    }
    else if (obj==MyApp->BT_IFSCancel) {
	IFSWin.Cancel();
    }
    /*
    else if (obj==MyApp->BT_ILSCancel) {
	ILSWin->Cancel();
    }
    */
    else if (obj==MyApp->BT_InfoCancel) {
	InfoWin.Cancel();
    }
    else if (obj==MyApp->BT_MaterialCancel) {
	MaterialWin.Cancel();
    }
    else if (obj==MyApp->BT_MaterialBindingCancel) {
	MaterialBindingWin.Cancel();
    }
    else if (obj==MyApp->BT_MatrixTransformCancel) {
	MatrixTransformWin.Cancel();
    }
    else if (obj==MyApp->BT_NormalCancel) {
	NormalWin.Cancel();
    }
    else if (obj==MyApp->BT_NormalBindingCancel) {
	NormalBindingWin.Cancel();
    }
    /*
    else if (obj==MyApp->BT_OrthographicCameraCancel) {
	OrthoWin->Cancel();
    }
    else if (obj==MyApp->BT_PerspectiveCameraCancel) {
	PersWin->Cancel();
    }
    */
    else if (obj==MyApp->BT_PointLightCancel) {
	PointLightWin.Cancel();
    }
    else if (obj==MyApp->BT_PointSetCancel) {
	PointSetWin.Cancel();
    }
    else if (obj==MyApp->BT_RotationCancel) {
	RotationWin.Cancel();
    }
    else if (obj==MyApp->BT_ScaleCancel) {
	ScaleWin.Cancel();
    }
    else if (obj==MyApp->BT_ShapeHintsCancel) {
	ShapeHintsWin.Cancel();
    }
    else if (obj==MyApp->BT_SphereCancel) {
	SphereWin.Cancel();
    }
    else if (obj==MyApp->BT_SpotLightCancel) {
	SpotLightWin.Cancel();
    }
    else if (obj==MyApp->BT_Texture2Cancel) {
	Texture2Win.Cancel();
    }
    else if (obj==MyApp->BT_Texture2TransformCancel) {
	Texture2TransformWin.Cancel();
    }
    else if (obj==MyApp->BT_TextureCoordinate2Cancel) {
	TextureCoordinate2Win.Cancel();
    }
    else if (obj==MyApp->BT_TransformCancel) {
	TransformWin.Cancel();
    }
    else if (obj==MyApp->BT_TranslationCancel) {
	TranslationWin.Cancel();
    }
    else if (obj==MyApp->BT_WWWInlineCancel) {
	WWWInlineWin.Cancel();
    };

}
// Default clicked
void DefaultFunc(Object *obj) {
    ULONG store=0;

    // puts("Default button clicked");
    if (obj==MyApp->BT_ConeDefault) {
	ConeWin.SetDefault();
    }
    else if (obj==MyApp->BT_CubeDefault) {
	CubeWin.SetDefault();
    }
    else if (obj==MyApp->BT_CylinderDefault) {
	CylinderWin.SetDefault();
    }
    else if(obj==MyApp->BT_DirectionalLightDefault) {
	DirectionalLightWin.SetDefault();
    }
    else if(obj==MyApp->BT_FontStyleDefault) {
	FontStyleWin.SetDefault();
    }
    else if(obj==MyApp->BT_MaterialDefault) {
	MaterialWin.SetDefault();
    }
    else if(obj==MyApp->BT_MatrixTransformDefault) {
	MatrixTransformWin.SetDefault();
    }
    /*
    else if (obj==MyApp->BT_OrthographicCameraDefault) {
	OrthoWin->SetDefault();
    }
    else if (obj==MyApp->BT_PerspectiveCameraDefault) {
	PersWin->SetDefault();
    }
    */
    else if (obj==MyApp->BT_PointLightDefault) {
	PointLightWin.SetDefault();
    }
    else if (obj==MyApp->BT_PointSetDefault) {
	PointSetWin.SetDefault();
    }
    else if(obj==MyApp->BT_RotationDefault) {
	RotationWin.SetDefault();
    }
    else if(obj==MyApp->BT_ScaleDefault) {
	ScaleWin.SetDefault();
    }
    else if (obj==MyApp->BT_ShapeHintsDefault) {
	ShapeHintsWin.SetDefault();
    }
    else if (obj==MyApp->BT_SphereDefault) {
	SphereWin.SetDefault();
    }
    else if (obj==MyApp->BT_SpotLightDefault) {
	SpotLightWin.SetDefault();
    }
    else if (obj==MyApp->BT_Texture2Default) {
	Texture2Win.SetDefault();
    }
    else if (obj==MyApp->BT_Texture2TransformDefault) {
	Texture2TransformWin.SetDefault();
    }
    else if(obj==MyApp->BT_TransformDefault) {
	TransformWin.SetDefault();
    }
    else if(obj==MyApp->BT_TranslationDefault) {
	TranslationWin.SetDefault();
    }
    else if (obj==MyApp->BT_WWWInlineDefault) {
	WWWInlineWin.SetDefault();
    };
    /*
    GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_CyberGL, &store);
    if ((int) store) {
	DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
    };
    */
}
// Change contents
void ChangeContents(Object *obj) {
    ULONG store=0;
    BOOL refresh=FALSE;

    if (sh.mode==SYSTEM) return;
    // puts ("=>ChangeContents");
    if((obj==MyApp->STR_DEFConeName)||
       (obj==MyApp->STR_ConeBottomRadius)||
       (obj==MyApp->STR_ConeHeight)||
       (obj==MyApp->CH_ConeSides)||(obj==MyApp->CH_ConeBottom)) {
       // puts("CONE WIN");
       if ((ConeWin.which==MAIN)&&((pw==MAIN_WORLD)||(pw==BOTH_WORLD))) refresh=TRUE;
       if ((ConeWin.which==CLIP)&&((pw==CLIP_WORLD)||(pw==BOTH_WORLD))) refresh=TRUE;
       ConeWin.ReadValues();
    }
    else if ((obj==MyApp->STR_CubeWidth)||
	     (obj==MyApp->STR_CubeHeight)||
	     (obj==MyApp->STR_CubeDepth)||
	     (obj==MyApp->STR_DEFCubeName)) {
	     // puts("CUBE WIN");
	     if ((CubeWin.which==MAIN)&&((pw==MAIN_WORLD)||(pw==BOTH_WORLD))) refresh=TRUE;
	     if ((CubeWin.which==CLIP)&&((pw==CLIP_WORLD)||(pw==BOTH_WORLD))) refresh=TRUE;
	     CubeWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFCylinderName)||
	     (obj==MyApp->STR_CylinderRadius)||
	     (obj==MyApp->STR_CylinderHeight)||
	     (obj==MyApp->CH_CylinderSides)||
	     (obj==MyApp->CH_CylinderTop)||
	     (obj==MyApp->CH_CylinderBottom)) {
	     // puts("CYLINDER WIN");
	    if ((CylinderWin.which==MAIN)&&((pw==MAIN_WORLD)||(pw==BOTH_WORLD))) refresh=TRUE;
	    if ((CylinderWin.which==CLIP)&&((pw==CLIP_WORLD)||(pw==BOTH_WORLD))) refresh=TRUE;
	    CylinderWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFDirectionalLightName)||
	     (obj==MyApp->STR_DirectionalLightX)||
	     (obj==MyApp->STR_DirectionalLightY)||
	     (obj==MyApp->STR_DirectionalLightZ)||
	     (obj==MyApp->STR_DirectionalLightR)||
	     (obj==MyApp->STR_DirectionalLightG)||
	     (obj==MyApp->STR_DirectionalLightB)||
	     (obj==MyApp->STR_DirectionalLightIntensity)||
	     (obj==MyApp->CH_DirectionalLightOn)) {
	     DirectionalLightWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFFontStyleName)||
	     (obj==MyApp->STR_FontStyleSize)||
	     (obj==MyApp->CY_FontStyleFamily)||
	     (obj==MyApp->CH_FontStyleBold)||
	     (obj==MyApp->CH_FontStyleItalic)) {
	     FontStyleWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFInfoName)||
	     (obj==MyApp->STR_InfoString)) {
	     InfoWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFMaterialBindingName)||
	     (obj==MyApp->CY_MaterialBinding)) {
	     // puts("MATERIALBINDING WIN");
	     MaterialBindingWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFMatrixTransformName)||
	     (obj==MyApp->STR_MatrixTransform0)||
	     (obj==MyApp->STR_MatrixTransform1)||
	     (obj==MyApp->STR_MatrixTransform2)||
	     (obj==MyApp->STR_MatrixTransform3)||
	     (obj==MyApp->STR_MatrixTransform4)||
	     (obj==MyApp->STR_MatrixTransform5)||
	     (obj==MyApp->STR_MatrixTransform6)||
	     (obj==MyApp->STR_MatrixTransform7)||
	     (obj==MyApp->STR_MatrixTransform8)||
	     (obj==MyApp->STR_MatrixTransform9)||
	     (obj==MyApp->STR_MatrixTransform10)||
	     (obj==MyApp->STR_MatrixTransform11)||
	     (obj==MyApp->STR_MatrixTransform12)||
	     (obj==MyApp->STR_MatrixTransform13)||
	     (obj==MyApp->STR_MatrixTransform14)||
	     (obj==MyApp->STR_MatrixTransform15)) {
	     MatrixTransformWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFNormalBindingName)||
	     (obj==MyApp->CY_NormalBindingValue)) {
		// puts("NORMALBINDING WIN");
		NormalBindingWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFPointLightName)||
	     (obj==MyApp->STR_PointLightX)||
	     (obj==MyApp->STR_PointLightY)||
	     (obj==MyApp->STR_PointLightZ)||
	     (obj==MyApp->STR_PointLightR)||
	     (obj==MyApp->STR_PointLightG)||
	     (obj==MyApp->STR_PointLightB)||
	     (obj==MyApp->STR_PointLightIntensity)||
	     (obj==MyApp->CH_PointLightOn)) {
	     PointLightWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFPointSetName)||
	     (obj==MyApp->STR_PointSetStartIndex)||
	     (obj==MyApp->STR_PointSetNumPoints)) {
	     PointSetWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFRotationName)||
	     (obj==MyApp->STR_RotationX)||
	     (obj==MyApp->STR_RotationY)||
	     (obj==MyApp->STR_RotationZ)||
	     (obj==MyApp->STR_RotationA)) {
	     // puts("ROTATION WIN");
	     RotationWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFScaleName)||
	     (obj==MyApp->STR_ScaleX)||
	     (obj==MyApp->STR_ScaleY)||
	     (obj==MyApp->STR_ScaleZ)) {
	     // puts("SCALE WIN");
	     ScaleWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFShapeHintsName)||
	     (obj==MyApp->CY_ShapeHintsVertexOrdering)||
	     (obj==MyApp->CY_ShapeHintsShapeType)||
	     (obj==MyApp->CY_ShapeHintsFaceType)||
	     (obj==MyApp->STR_ShapeHintsCreaseAngle)) {
	     ShapeHintsWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFSphereName)||
	     (obj==MyApp->STR_SphereRadius)) {
	     SphereWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFTexture2TransformName)||
	     (obj==MyApp->STR_Texture2TransformTX)||
	     (obj==MyApp->STR_Texture2TransformTY)||
	     (obj==MyApp->STR_Texture2TransformRot)||
	     (obj==MyApp->STR_Texture2TransformSX)||
	     (obj==MyApp->STR_Texture2TransformSY)||
	     (obj==MyApp->STR_Texture2TransformCenterX)||
	     (obj==MyApp->STR_Texture2TransformCenterY)) {
	     Texture2TransformWin.ReadValues();
    }
    else if ((obj==MyApp->STR_DEFTransformName)||
	     (obj==MyApp->STR_TTranslationX)||
	     (obj==MyApp->STR_TTranslationY)||
	     (obj==MyApp->STR_TTranslationZ)||
	     (obj==MyApp->STR_TRotationX)||
	     (obj==MyApp->STR_TRotationY)||
	     (obj==MyApp->STR_TRotationZ)||
	     (obj==MyApp->STR_TRotationA)||
	     (obj==MyApp->STR_TScaleFX)||
	     (obj==MyApp->STR_TScaleFY)||
	     (obj==MyApp->STR_TScaleFZ)||
	     (obj==MyApp->STR_TScaleOX)||
	     (obj==MyApp->STR_TScaleOY)||
	     (obj==MyApp->STR_TScaleOZ)||
	     (obj==MyApp->STR_TScaleOA)||
	     (obj==MyApp->STR_TCenterX)||
	     (obj==MyApp->STR_TCenterY)||
	     (obj==MyApp->STR_TCenterZ)) {
	     // puts("TRANSFORM WIN");
	     TransformWin.ReadValues();
    }
    /*
    else if (obj==MyApp->STR_DEFTransformSeparatorName) {
	    TransformSeparatorWin->ReadValues();
    }
    */
    else if ((obj==MyApp->STR_DEFTranslationName)||
	     (obj==MyApp->STR_TranslationX)||
	     (obj==MyApp->STR_TranslationY)||
	     (obj==MyApp->STR_TranslationZ)) {
	     // puts("TRANSLATION WIN");
	     TranslationWin.ReadValues();
    }
    /*
    else if ((obj==MyApp->STR_DEFWWWAnchorName)||
	     (obj==MyApp->STR_WWWAnchorName)||
	     (obj==MyApp->STR_WWWAnchorDescription)||
	     (obj==MyApp->CY_WWWAnchorMap)) {
	     WWWAnchorWin->ReadValues();
    }
    */
    else if ((obj==MyApp->STR_DEFWWWInlineName)||
	     (obj==MyApp->STR_WWWInlineName)||
	     (obj==MyApp->STR_WWWInlineBoxSizeX)||
	     (obj==MyApp->STR_WWWInlineBoxSizeY)||
	     (obj==MyApp->STR_WWWInlineBoxSizeZ)||
	     (obj==MyApp->STR_WWWInlineBoxCenterX)||
	     (obj==MyApp->STR_WWWInlineBoxCenterY)||
	     (obj==MyApp->STR_WWWInlineBoxCenterZ)) {
	     WWWInlineWin.ReadValues();
    }
    // Add
    /*
    else if (obj==MyApp->STR_AddNodeName) {
	// puts("ADD WIN");
	AddWin->ReadValues();
    };
    */
    if (refresh) {
	GetAttr(MUIA_Window_Open, (Object *) MyApp->WI_CyberGL, &store);
	if((int) store) {
	    DoMethod((Object *) MyApp->AR_CyberGLArea, MUIM_GLArea_Redraw);
	};
    };
    // puts("<=ChangeContents");
    // return;
}
/*-------------------------
  MISC
--------------------------*/
void SpecialCmd (Object *obj) {
    // puts("In SpecialCmd");
    ULONG store;
    FNames TFile;
    char temp[255];
    int len;

    if (obj==MyApp->BT_MainPreview) {
	// puts("MainCmdPreview");
	// Reset();
    }
    else if (obj==MyApp->BT_AboutOk) {
	puts("AboutOk");
	printf("X:%f\n",mycamera.X);
	SetAttrs((Object *) MyApp->WI_About, MUIA_Window_Open, FALSE);
	// WakeUpAll();
	printf("X:%f\n",mycamera.X);
	// sh.about=CLOSED;
    }
    else if (obj==MyApp->BT_WWWInlineRead) {
	/*
	TFile=OFile;
	// puts("Read Inline");
	// strncpy(TFile.Name,OFile.Name,255);
	// strncpy(TFile.Dir,OFile.Dir,255);
	// strncpy(TFile.Complete,OFile.Complete,255);

	// strcpy(OFile.Complete,"RAM:Test.wrl");
	// printf("OFile.Complete:%s\n",OFile.Complete);
	// printf("TFile.Complete:%s\n",TFile.Complete);

	WWWInline *www=WWWInlineWin->GetInline();
	strncpy(OFile.Complete,OFile.Dir,255);
	// GetCurrentDirName(OFile.Complete,255);
	// GetCurrentDirName(OFile.Dir,255);
	AddPart(OFile.Complete,www->GetURL(),255);
	len=strlen(PathPart(OFile.Complete));
	strncpy(OFile.Name,FilePart(OFile.Complete),255);
	// strcpy(OFile.Dir,"");
	strncpy(OFile.Dir,OFile.Complete,strlen(OFile.Complete)-len);

	printf("Path:%s\n",OFile.Dir);
	printf("File:%s\n",OFile.Name);
	printf("Complete:%s\n",OFile.Complete);

	if (www->in) delete www->in;
	www->in=(VRMLNode *) Load();

	OFile=TFile;
	*/
	/*
	strcpy(temp,OFile.Name);
	strcpy(OFile.Name,www->GetURL());
	
	strcpy(OFile.Name,temp);
	*/
	/*
	strncpy(OFile.Name,TFile.Name,255);
	strncpy(OFile.Dir,TFile.Dir,255);
	strncpy(OFile.Complete,TFile.Complete,255);
	*/
    };
}

/*-------------------------------------------------------------------------------------*/
/*************
 * MAIN PART *
 *************/

/*------------------
   Init functions
------------------*/
void StartUp() {
     FILE *fset=NULL;
     int size=0;
     char car;

     puts("Startup");
     strcpy(OFile.Name,"");
     GetCurrentDirName(OFile.Dir,255);
     strcpy(OFile.Complete,"");
     strcpy(SFile.Name,"");
     GetCurrentDirName(SFile.Dir,255);
     strcpy(SFile.Complete,"");
     // printf("CurrentDir:%s\n",OFile.Dir);

     //--- Shared variables ---
     sh.mode=USER;
     sh.rendering=IDLE;
     sh.about=CLOSED;
     
     //--- State variable init (prefs) ---
     fset=fopen("ENV:VRMLEditor.prefs","r");
     if (fset) {
	char temp[255];
	fscanf(fset,"%s %s\n",temp,temp);
	if (!strcmp(temp,"0.70")) {
	    fscanf(fset,"%d%c\n",&size,&car);
	    // printf("size:%d\n",size);
	    fread(settings.outcon,size,1,fset);
	    // printf("con:%s\n",settings.outcon);
	    fscanf(fset,"%d %d\n",&settings.msgmode,&settings.resolve);
	    // printf("mode:%d %d\n",settings.msgmode,settings.resolve);
	    fscanf(fset,"%f %f %f\n",&settings.brgb[0],&settings.brgb[1],&settings.brgb[2]);
	    // printf("color:%f %f %f\n",settings.brgb[0],settings.brgb[1],settings.brgb[2]);
	    fscanf(fset,"%x %d\n",&settings.displayID,&settings.displayDepth);
	    // printf("displayID:%x Depth:%d\n",settings.displayID,settings.displayDepth);
	    fscanf(fset,"%d %d %d\n",&settings.coneres,&settings.cylinderres,&settings.sphereres);
	    // printf("res:%d %d %d\n",st->coneres,st->cylinderres,st->sphereres);
	    fscanf(fset,"%f\n",&settings.angle);
	    fscanf(fset,"%s\n",settings.gzip);
	    //--- VRML V1.0 ascii file saving option ---
	    fscanf(fset,"%d %d %d %d\n",&settings.V1GenTex,&settings.V1GenInlines,&settings.V1Gzip,&settings.V1GenNormals);
	    //
	    fclose(fset);
	    sh.mode=SYSTEM;
	    SetAttrs((Object *) MyApp->STR_PrefsOutput, MUIA_String_Contents, settings.outcon);
	    SetAttrs((Object *) MyApp->RA_PrefsType, MUIA_Radio_Active, (LONG) settings.msgmode);
	    SetAttrs((Object *) MyApp->CH_PrefsResolve, MUIA_Selected, (BOOL) settings.resolve);
	    ftoa(settings.brgb[0],temp);
	    SetAttrs((Object *) MyApp->STR_PrefsR, MUIA_String_Contents, temp);
	    ftoa(settings.brgb[1],temp);
	    SetAttrs((Object *) MyApp->STR_PrefsG, MUIA_String_Contents, temp);
	    ftoa(settings.brgb[2],temp);
	    SetAttrs((Object *) MyApp->STR_PrefsB, MUIA_String_Contents, temp);
	    itoa(settings.coneres,temp);
	    SetAttrs((Object *) MyApp->STR_PrefsConeResolution, MUIA_String_Contents, temp);
	    itoa(settings.cylinderres,temp);
	    SetAttrs((Object *) MyApp->STR_PrefsCylinderResolution, MUIA_String_Contents, temp);
	    itoa(settings.sphereres,temp);
	    SetAttrs((Object *) MyApp->STR_PrefsSphereResolution, MUIA_String_Contents, temp);
	    ConvertDisplayID(temp,settings.displayID);
	    SetAttrs((Object *) MyApp->TX_PA_PrefsScreen, MUIA_Text_Contents, temp);
	    ftoa(settings.angle,temp);
	    SetAttrs((Object *) MyApp->STR_PrefsGZip, MUIA_String_Contents, settings.gzip);
	    SetAttrs((Object *) MyApp->CH_SaveAsV1Tex, MUIA_Selected, (BOOL) settings.V1GenTex);
	    SetAttrs((Object *) MyApp->CH_SaveAsV1Inlines, MUIA_Selected, (BOOL) settings.V1GenInlines);
	    SetAttrs((Object *) MyApp->CH_SaveAsV1Compress, MUIA_Selected, (BOOL) settings.V1Gzip);
	    SetAttrs((Object *) MyApp->CH_SaveAsV1Normals, MUIA_Selected, (BOOL) settings.V1GenNormals);
	};
	sh.mode=USER;
     }
     else {
	strncpy(settings.outcon,"CON:0/0/400/200/VRMLEditor Parser output",80);
	strncpy(settings.gzip,"C:gzip",255);
	settings.msgmode=ONLYERRORS;
	settings.resolve=NORESOLVE;
	settings.brgb[0]=0;settings.brgb[1]=0;settings.brgb[2]=0.0;
	settings.displayID=0;
	settings.displayDepth=4;
	settings.angle=45.0;
	settings.coneres=8;
	settings.cylinderres=8;
	settings.sphereres=8;
	settings.V1GenTex=FALSE;
	settings.V1GenInlines=FALSE;
	settings.V1Gzip=FALSE;
	settings.V1GenNormals=FALSE;
     };

     //--- Camera inital position ---
     mycamera.X=0;
     mycamera.Y=0;
     mycamera.Z=40;
     mycamera.heading=0;
     mycamera.pitch=0;
     oldcamera=mycamera;

     //
     /*
     gauge.Win=MyApp->WI_Msg;
     gauge.Gauge=MyApp->GA_Msg;
     gauge.Txt=MyApp->TX_Msg;
     */

     //--- Creating first level for main and clip worlds
     Main=(VRMLGroups *) new Separator("ROOT");
     Clip=(VRMLGroups *) new Separator("CLIP");
     DoMethod((Object *) MyApp->LT_MainWorld, MCCM_DDListtree_Init, (VRMLNode *) Main);
     DoMethod((Object *) MyApp->LT_MainClip, MCCM_DDListtree_Init, (VRMLNode *) Clip);
     // puts("after domethod");
			   
     //--- Init GL 2D images
     InitMatPreviewBackdrop();

     // AddWin=WIAdd();
     //AsciiTextWin=WIAsciiText();
     //ConeWin=WICone();
     //Coordinate3Win=WICoordinate3();
     // CubeWin=WICube();
     //CylinderWin=WICylinder();
     /*
     DirectionalLightWin=new WIDirectionalLight();
     FontStyleWin=new WIFontStyle();
     */
     // GroupsWin=WIGroups();
     /*
     IFSWin=new WIIndexedFaceSet();
     ILSWin=new WIIndexedLineSet();
     InfoWin=new WIInfo();
     // LODWin=new WILOD();
     MaterialWin=new WIMaterial();
     MaterialBindingWin=new WIMaterialBinding();
     MatrixTransformWin=new WIMatrixTransform();
     NormalWin=new WINormal();
     NormalBindingWin=new WINormalBinding();
     OrthoWin=new WIOrthographicCamera();
     PersWin=new WIPerspectiveCamera();
     PointLightWin=new WIPointLight();
     PointSetWin=new WIPointSet();
     RotationWin=new WIRotation();
     ScaleWin=new WIScale();
     // SeparatorWin=new WISeparator();
     ShapeHintsWin=new WIShapeHints();
     SphereWin=new WISphere();
     SpotLightWin=new WISpotLight();
     // SwitchWin=new WISwitch();
     Texture2Win=new WITexture2();
     Texture2TransformWin=new WITexture2Transform();
     TextureCoordinate2Win=new WITextureCoordinate2();
     TransformWin=new WITransform();
     // TransformSeparatorWin=new WITransformSeparator();
     TranslationWin=new WITranslation();
     // WWWAnchorWin=new WIWWWAnchor();
     WWWInlineWin=new WIWWWInline();
     */

     // Add window default selected
     SetAttrs((Object *) MyApp->LV_AddNode,MUIA_List_Active, 0,NULL);

     // Gauge positionning
     // SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_RefWindow, MyApp->WI_Main);
     // SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Width,MUIV_Window_Width_Screen(30));

     // Prefs window positionning
     SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_RefWindow, MyApp->WI_Main);
     SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_Width, MUIV_Window_Width_Screen(40));

     // About window
     SetAttrs((Object *) MyApp->WI_About, MUIA_Window_RefWindow, MyApp->WI_Main);
     SetAttrs((Object *) MyApp->WI_About, MUIA_Window_Width,MUIV_Window_Width_Screen(40));
     SetAttrs((Object *) MyApp->WI_About, MUIA_Window_Height,MUIV_Window_Height_Screen(35));

     // Prefs window
     SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_RefWindow, MyApp->WI_Main);
     SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_Width,MUIV_Window_Width_Screen(40));
     SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_Height,MUIV_Window_Height_Screen(35));

     // MeshWriter window
     SetAttrs((Object *) MyApp->CY_MWFormat, MUIA_Cycle_Entries, MWL3DFileFormatNamesGet());

     // SaveAs window
     SetAttrs((Object *) MyApp->WI_SaveAs, MUIA_Window_RefWindow, MyApp->WI_Main);
     SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_Width,MUIV_Window_Width_Screen(40));
     SetAttrs((Object *) MyApp->WI_Prefs, MUIA_Window_Height,MUIV_Window_Height_Screen(35));

     //---------- Open Main window
     // SetAttrs((Object *) MyApp->WI_Main, MUIA_Window_Open, TRUE);

     puts("<=Startup");
}
void CleanUp() {
    // puts("InClearAll");
    // delete st;
    // puts("st deleted");

    delete Main;
    // puts("Main finished");
    delete Clip;
    // puts("Clip finished");

    /*
    delete AddWin;

    delete AsciiTextWin;
    delete ConeWin;
    delete Coordinate3Win;
    delete CubeWin;
    delete CylinderWin;
    delete DirectionalLightWin;
    delete FontStyleWin;
    // delete GroupWin;
    delete IFSWin;
    delete ILSWin;
    delete InfoWin;
    // delete LODWin;
    delete MaterialWin;
    delete MaterialBindingWin;
    delete MatrixTransformWin;
    delete NormalWin;
    delete NormalBindingWin;
    delete OrthoWin;
    delete PersWin;
    delete PointLightWin;
    delete PointSetWin;
    delete RotationWin;
    delete ScaleWin;
    // delete SeparatorWin;
    delete ShapeHintsWin;
    delete SphereWin;
    delete SpotLightWin;
    // delete SwitchWin;
    delete Texture2Win;
    delete Texture2TransformWin;
    delete TextureCoordinate2Win;
    delete TransformWin;
    // delete TransformSeparatorWin;
    delete TranslationWin;
    // delete WWWAnchorWin;
    delete WWWInlineWin;

    if (parserfd!=NULL) fclose (parserfd);
    // puts("ClearAll finisehd");
    */
}

/*------------------------------
  ------MAIN FUNCTIONS ---------
  -----------------------------*/
void main(int argc, char **argv) {
    int rep;
    double aboutangle=0;
    ULONG sig=0,store;
    GLboolean down=GL_FALSE;
    int cpu=0;

    puts("In main");
    cpu=CheckCPU();
    printf("CPU:%d\n",cpu);
    printf("FPU:%d\n",CheckFPU());

    MUIMasterBase=(struct Library *) OpenLibrary ((UBYTE*)MUIMASTER_NAME,MUIMASTER_VLATEST);
    if (MUIMasterBase==NULL) {
	puts ("Can't open muimaster.library");
	exit(0);
    };
    MeshWriterBase=(struct MeshWriterBase *) OpenLibrary((UBYTE*)"meshwriter.library",0L);
    if (MeshWriterBase==NULL) {
	puts("Can't open meshwriter.library");
	exit(0);
    };
    CyberGfxBase=(struct Library *) OpenLibrary((UBYTE*)CYBERGFXNAME,0L);
    if (CyberGfxBase==NULL) {
	puts("can't open cybergraphics");
    };

    #ifdef __GNUC__
    // OpenStormMesaLibs(&glBase,&gluBase,&glutBase);
    /*
    glbases.gl_Base=glBase;
    glbases.glu_Base=gluBase;
    glbases.glut_Base=glutBase;
    */
    #endif

    MyApp=CreateApp();
    GetAttr(MUIA_GLArea_glBase, (Object *) MyApp->GL_Logo, &store);
    glBase=(struct Library *) store;
    GetAttr(MUIA_GLArea_gluBase, (Object *) MyApp->GL_Logo, &store);
    gluBase=(struct Library *) store;
    GetAttr(MUIA_GLArea_glutBase, (Object *) MyApp->GL_Logo, &store);
    glutBase=(struct Library *) store;
    glcontext.gl_Base=glBase;
    glcontext.glu_Base=gluBase;
    glcontext.glut_Base=glutBase;
    StartUp();

    // Main loop
    while (1) {
	while (DoMethod((Object *) MyApp->App,MUIM_Application_NewInput,&sig)!=MUIV_Application_ReturnID_Quit) {
	    // printf("Event loop:%lu\n",sig);
	    if (sig) {
		// puts("sig received");
		sig = Wait(sig|SIGBREAKF_CTRL_C);
		if (sig&SIGBREAKF_CTRL_C) break;
	    };
	}; // end while
       
	rep=MUI_Request (MyApp->App,MyApp->WI_Main,0,"Confirm","Ok|Cancel",
			"Do you really want to quit this application ?\n\n"
			"BTW if you clicked on close, you will surely quit...");
	if (rep) break;
    }; // end while(1)

    /*
    SetAttrs((Object *) MyApp->TX_Msg, MUIA_Text_Contents, "Cleaning up");
    SetAttrs((Object *) MyApp->GA_Msg, MUIA_Gauge_Max, 100);
    SetAttrs((Object *) MyApp->GA_Msg, MUIA_Gauge_Current, 0);
    SetAttrs((Object *) MyApp->WI_Msg, MUIA_Window_Open, TRUE);
    */
    CleanUp();
    DisposeApp(MyApp);
    puts("After the DisposeApp");
    if (MeshWriterBase) CloseLibrary((struct Library *) MeshWriterBase);
    puts("MeshWriter closed");
    if (MUIMasterBase) CloseLibrary(MUIMasterBase);
    puts("muimaster closed");

    #ifdef __GNUC__
    // CloseStormMesaLibs(&glBase,&gluBase,&glutBase);
    #endif
}

#ifdef __STORM__
void wbmain(struct WBStartup *wbmsg) {
    // puts("From workbench");
    main(0,NULL);
}
#endif

