#include "MUI_CPP.include"

#include <mui/GLArea_mcc.h>

#include "MCC_DDListtree.h"

#include "GLFunctions.h"

static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
static const struct Hook MatChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) MatChangeContents, NULL, NULL};
static const struct Hook ModifyCmdHook = { {NULL, NULL}, (HOOKFUNC) ModifyCmd, NULL, NULL};
static const struct Hook IFSChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) IFSChangeContents, NULL, NULL};
static const struct Hook CoordinateChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) CoordinateChangeContents, NULL, NULL};
static const struct Hook GroupCmdHook = { {NULL, NULL}, (HOOKFUNC) GroupCmd, NULL, NULL};
static const struct Hook ActionsCmdHook = { {NULL, NULL}, (HOOKFUNC) ActionsCmd, NULL, NULL};
static const struct Hook SelectNodeHook = { {NULL, NULL}, (HOOKFUNC) SelectNode, NULL, NULL};
static const struct Hook InOutCmdHook = { {NULL, NULL}, (HOOKFUNC) InOutCmd, NULL, NULL};
static const struct Hook AsciiTextChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) AsciiTextChangeContents, NULL, NULL};
static const struct Hook ILSChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ILSChangeContents, NULL, NULL};
static const struct Hook GroupsChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) GroupsChangeContents, NULL, NULL};
static const struct Hook NormalChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) NormalChangeContents, NULL, NULL};
static const struct Hook OrthoChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) OrthoChangeContents, NULL, NULL};
static const struct Hook PerspectiveChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) PerspectiveChangeContents, NULL, NULL};
static const struct Hook Texture2ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) Texture2ChangeContents, NULL, NULL};
static const struct Hook TextureCoordinate2ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) TextureCoordinate2ChangeContents, NULL, NULL};
static const struct Hook SpecialCmdHook = { {NULL, NULL}, (HOOKFUNC) SpecialCmd, NULL, NULL};
static const struct Hook StartScreenHook = { {NULL, NULL}, (HOOKFUNC) StartScreen, NULL, NULL};
static const struct Hook StopScreenHook = { {NULL, NULL}, (HOOKFUNC) StopScreen, NULL, NULL};
static const struct Hook CyberGLCmdHook = { {NULL, NULL}, (HOOKFUNC) CyberGLCmd, NULL, NULL};
static const struct Hook MenuCmdHook = { {NULL, NULL}, (HOOKFUNC) MenuCmd, NULL, NULL};
static const struct Hook PrefsCmdHook = { {NULL, NULL}, (HOOKFUNC) PrefsCmd, NULL, NULL};
static const struct Hook MWCmdHook = { {NULL, NULL}, (HOOKFUNC) MWCmd, NULL, NULL};
static const struct Hook ChangeCameraHook = { {NULL, NULL}, (HOOKFUNC) ChangeCamera, NULL, NULL};

struct ObjApp *CreateApp()
{
	struct ObjApp *MBObj=NULL;

	APTR    GP_RT_About, GR_AboutCmd, GP_RT_Msg, Space_27, Space_28, Scale_0;

	if (!(MBObj = (struct ObjApp *) AllocVec(sizeof(struct ObjApp), MEMF_PUBLIC|MEMF_CLEAR))) return(NULL);

	//-------- Init CustomClass ----------------
	MBObj->ltmcc=InitDDListtreeCustomClass();

	//--------- Create All windows object --------------
	CreateWI_Main(MBObj);
	CreateWI_Cube(MBObj);
	CreateWI_Add(MBObj);
	CreateWI_Transform(MBObj);
	CreateWI_Translation(MBObj);
	CreateWI_Cylinder(MBObj);
	CreateWI_Material(MBObj);
	CreateWI_MaterialBinding(MBObj);
	CreateWI_Rotation(MBObj);
	CreateWI_Scale(MBObj);
	CreateWI_Cone(MBObj);
	CreateWI_Coordinate3(MBObj);
	CreateWI_IFS(MBObj);
	CreateWI_Prefs(MBObj);
	CreateWI_Groups(MBObj);
	CreateWI_AsciiText(MBObj);
	CreateWI_DirectionalLight(MBObj);
	CreateWI_FontStyle(MBObj);
	CreateWI_Info(MBObj);
	CreateWI_MatrixTransform(MBObj);
	CreateWI_Normal(MBObj);
	CreateWI_NormalBinding(MBObj);
	CreateWI_OrthographicCamera(MBObj);
	CreateWI_PerspectiveCamera(MBObj);
	CreateWI_PointLight(MBObj);
	CreateWI_PointSet(MBObj);
	CreateWI_ShapeHints(MBObj);
	CreateWI_SpotLight(MBObj);
	CreateWI_Texture2(MBObj);
	// CreateWI_Texture2Display(MBObj);
	CreateWI_Texture2Transform(MBObj);
	CreateWI_TextureCoordinate2(MBObj);
	CreateWI_WWWInline(MBObj);
	CreateWI_ILS(MBObj);
	CreateWI_Sphere(MBObj);
	CreateWI_CyberGL(MBObj);
	CreateWI_MeshWriter(MBObj);
	CreateWI_SaveAs(MBObj);

	/*
	MBObj->GA_Msg = GaugeObject,
		GaugeFrame,
		MUIA_HelpNode, "GA_Msg",
		MUIA_FixHeight, 10,
		MUIA_Gauge_Horiz, TRUE,
		MUIA_Gauge_InfoText, "Progressing",
		MUIA_Gauge_Max, 100,
	End;

	Scale_0 = ScaleObject,
		MUIA_Scale_Horiz, TRUE,
	End;

	MBObj->TX_Msg = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_Msg,
		MUIA_Text_SetMin, TRUE,
	End;

	GP_RT_Msg = GroupObject,
		Child, MBObj->GA_Msg,
		Child, Scale_0,
		Child, MBObj->TX_Msg,
	End;

	MBObj->WI_Msg = WindowObject,
		MUIA_Window_Title, "Messages",
		// MUIA_Window_ID, MAKE_ID('3', '9', 'W', 'I'),
		MUIA_Window_CloseGadget, FALSE,
		MUIA_Window_DepthGadget, FALSE,
		MUIA_Window_SizeGadget, FALSE,
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Msg,
	End;
	*/

	MBObj->AR_AboutGLArea = GLAreaObject,
		MUIA_FillArea, TRUE,
		MUIA_GLArea_MinWidth, 200,
		MUIA_GLArea_MinHeight, 40,
		MUIA_GLArea_Buffered, TRUE,
		MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_DrawFunc, DrawAboutScene,
	End;

	MBObj->GR_AboutGL = GroupObject,
		MUIA_HelpNode, "GR_AboutGL",
		MUIA_Weight, 50,
		Child, MBObj->AR_AboutGLArea,
	End;

	MBObj->LV_AboutText = FloattextObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
		MUIA_Floattext_Text,
		    "\033c\033u\0338VRMLEditor\n"
		    "\033cVersion 0.70 (15.7.1999)\n"
		    "\033c68040/StormMesa\n\n"
		    "\033cWritten by BODMER Stephan\n"
		    "\033c(bodmer2@uni2a.unige.ch)\n\n"
		    "\033cCopyright 1997/99 by BodySoft\n\n"
		    "\033cThis version is a BETA version\n"
		    // "\033conly released for courageous beta testers\n"
		    // "\033cPlease don't distribute this version !\n"
		    "\033cVRMLEditor is freeware and (very) soft-ware\n\n"
		    "\033c\033u\0338Features\n"
		    "\033cReading of GEO (ascii) object created\n"
		    "\033cfor videoscape 3D\n"
		    "\033cand reading of VRML V1.0 (ascii) files are supported.\n"
		    "\033cYou could save your worlds as\n"
		    "\033cVRML V1.0 (ascii) or as\n"
		    "\033cOpenGL (1.1) C source code.\n\n"
		    "\033c\033u\0338I would like to thanks following people:\n"
		    "\033cStefan Stuntz (MUI author)\n"
		    "\033cFrank Gerberding (cybergl.library)\n"
		    "\033cDirk Stoecker (FD2Pragma)\n"
		    "\033cSebastian Huebner (cybergl GCC includes)\n"
		    "\033cRaZor Muhammed\n"
		    "\033cSebastian Nohn\n"
		    "\033cStephan Bielmann (meshwriter.library)\n",
	End;

	MBObj->LV_AboutText = ListviewObject,
		MUIA_HelpNode, "LV_AboutText",
		MUIA_Listview_Input, FALSE,
		MUIA_Listview_List, MBObj->LV_AboutText,
	End;

	MBObj->GR_AboutText = GroupObject,
		MUIA_HelpNode, "GR_AboutText",
		MUIA_Weight, 80,
		Child, MBObj->LV_AboutText,
	End;

	Space_27 = HVSpace;

	MBObj->BT_AboutOk = SimpleButton("Ok");

	Space_28 = HVSpace;

	GR_AboutCmd = GroupObject,
		MUIA_HelpNode, "GR_AboutCmd",
		MUIA_Group_Horiz, TRUE,
		Child, Space_27,
		Child, MBObj->BT_AboutOk,
		Child, Space_28,
	End;

	GP_RT_About = GroupObject,
		Child, MBObj->GR_AboutGL,
		Child, MBObj->GR_AboutText,
		Child, GR_AboutCmd,
	End;

	MBObj->WI_About = WindowObject,
		MUIA_Window_Title, "About",
		// MUIA_Window_ID, MAKE_ID('4', '1', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_About,
	End;

	MBObj->App = ApplicationObject,
		MUIA_Application_Author, "Bodmer Stephan (bodmer2@uni2a.unige.ch)",
		MUIA_Application_Base, "VRMLEditor",
		MUIA_Application_Title, "VRMLEditor",
		MUIA_Application_Version, "$VER:00.70 (15.7.1999) ",
		MUIA_Application_Copyright, "Bodmer Stephan (BodySoft)",
		MUIA_Application_Description, "VRML V1.0 ascii parser and editor",
		// MUIA_HelpFile, "MUI_VRMLEditor.guide",
		MUIA_Application_UseCommodities, FALSE,
		SubWindow, MBObj->WI_Main,
		SubWindow, MBObj->WI_Cube,
		SubWindow, MBObj->WI_Add,
		SubWindow, MBObj->WI_Transform,
		SubWindow, MBObj->WI_Translation,
		SubWindow, MBObj->WI_Cylinder,
		SubWindow, MBObj->WI_Material,
		SubWindow, MBObj->WI_MaterialBinding,
		SubWindow, MBObj->WI_Rotation,
		SubWindow, MBObj->WI_Scale,
		SubWindow, MBObj->WI_Cone,
		SubWindow, MBObj->WI_Coordinate3,
		SubWindow, MBObj->WI_IFS,
		SubWindow, MBObj->WI_Prefs,
		SubWindow, MBObj->WI_Groups,
		SubWindow, MBObj->WI_AsciiText,
		SubWindow, MBObj->WI_DirectionalLight,
		SubWindow, MBObj->WI_FontStyle,
		SubWindow, MBObj->WI_Info,
		SubWindow, MBObj->WI_MatrixTransform,
		SubWindow, MBObj->WI_Normal,
		SubWindow, MBObj->WI_NormalBinding,
		SubWindow, MBObj->WI_OrthographicCamera,
		SubWindow, MBObj->WI_PerspectiveCamera,
		SubWindow, MBObj->WI_PointLight,
		SubWindow, MBObj->WI_PointSet,
		SubWindow, MBObj->WI_ShapeHints,
		SubWindow, MBObj->WI_SpotLight,
		SubWindow, MBObj->WI_Texture2,
		// SubWindow, MBObj->WI_Texture2Display,
		SubWindow, MBObj->WI_Texture2Transform,
		SubWindow, MBObj->WI_TextureCoordinate2,
		SubWindow, MBObj->WI_WWWInline,
		SubWindow, MBObj->WI_ILS,
		SubWindow, MBObj->WI_Sphere,
		// SubWindow, MBObj->WI_Msg,
		SubWindow, MBObj->WI_CyberGL,
		SubWindow, MBObj->WI_About,
		SubWindow, MBObj->WI_MeshWriter,
		SubWindow, MBObj->WI_SaveAs,
	End;

	if (!MBObj->App)
	{
		FreeVec(MBObj);
		return(NULL);
	}

	// #include "App_Notify.h"
	#include "Main_Notify.h"
	#include "Add_Notify.h"
	#include "CyberGL_Notify.h"
	#include "MeshWriter_Notify.h"
	#include "SaveAs_Notify.h"
	#include "Prefs_Notify.h"

	#include "Groups_Notify.h"
	#include "AsciiText_Notify.h"
	#include "Cone_Notify.h"
	#include "Coordinate3_Notify.h"
	#include "Cube_Notify.h"
	#include "Cylinder_Notify.h"
	#include "DirectionalLight_Notify.h"
	#include "FontStyle_Notify.h"
	#include "IFS_Notify.h"
	#include "Info_Notify.h"
	#include "Material_Notify.h"
	#include "MaterialBinding_Notify.h"
	#include "MatrixTransform_Notify.h"
	#include "Normal_Notify.h"
	#include "NormalBinding_Notify.h"
	#include "PointLight_Notify.h"
	#include "PointSet_Notify.h"
	#include "Rotation_Notify.h"
	#include "Scale_Notify.h"
	#include "ShapeHints_Notify.h"
	#include "Sphere_Notify.h"
	#include "SpotLight_Notify.h"
	#include "Texture2_Notify.h"
	// #include "Texture2Display_Notify.h"
	#include "Texture2Transform_Notify.h"
	#include "TextureCoordinate2_Notify.h"
	#include "Translation_Notify.h"
	#include "Transform_Notify.h"
	#include "WWWInline_Notify.h"

	DoMethod((Object *) MBObj->WI_About,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_AboutOk,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->BT_AboutOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AboutOk,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->WI_About,
		MUIM_Window_SetCycleChain, MBObj->GR_AboutGL,
		MBObj->GR_AboutText,
		MBObj->LV_AboutText,
		MBObj->BT_AboutOk,
		0
		);

	SetAttrs((Object *) MBObj->WI_Main, MUIA_Window_Open, TRUE);

	return(MBObj);
}

void DisposeApp(struct ObjApp * MBObj)
{
	MUI_DisposeObject( (Object *) MBObj->App);
	DeleteDDListtreeCustomClass(MBObj->ltmcc);
	FreeVec(MBObj);
}
