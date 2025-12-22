#include "MUI_CPP.include"

#include "MCC_GLArea.h"
#include "MCC_DDListtree.h"

struct ObjApp *CreateApp()
{
	struct ObjApp *MBObj=NULL;

	APTR    GP_RT_About, GR_AboutCmd, GP_RT_Msg, Space_27, Space_28, Scale_0;

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
	static const struct Hook LODChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) LODChangeContents, NULL, NULL};
	static const struct Hook NormalChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) NormalChangeContents, NULL, NULL};
	static const struct Hook OrthoChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) OrthoChangeContents, NULL, NULL};
	static const struct Hook PerspectiveChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) PerspectiveChangeContents, NULL, NULL};
	static const struct Hook TextureCoordinate2ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) TextureCoordinate2ChangeContents, NULL, NULL};
	static const struct Hook SpecialCmdHook = { {NULL, NULL}, (HOOKFUNC) SpecialCmd, NULL, NULL};
	static const struct Hook StartScreenHook = { {NULL, NULL}, (HOOKFUNC) StartScreen, NULL, NULL};
	static const struct Hook StopScreenHook = { {NULL, NULL}, (HOOKFUNC) StopScreen, NULL, NULL};
	static const struct Hook CyberGLCmdHook = { {NULL, NULL}, (HOOKFUNC) CyberGLCmd, NULL, NULL};
	static const struct Hook MenuCmdHook = { {NULL, NULL}, (HOOKFUNC) MenuCmd, NULL, NULL};
	static const struct Hook PrefsCmdHook = { {NULL, NULL}, (HOOKFUNC) PrefsCmd, NULL, NULL};

	if (!(MBObj = (struct ObjApp *) AllocVec(sizeof(struct ObjApp), MEMF_PUBLIC|MEMF_CLEAR)))
		return(NULL);

	//-------- Init CustomClass ----------------
	MBObj->glmcc=InitGLAreaCustomClass();
	MBObj->ltmcc=InitDDListtreeCustomClass();

	//--------- Create All windows object --------------
	CreateWI_Main(MBObj);
	CreateWI_Cube(MBObj);
	CreateWI_Add(MBObj);
	CreateWI_Transform(MBObj);
	CreateWI_Separator(MBObj);
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
	CreateWI_Group(MBObj);
	CreateWI_LOD(MBObj);
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
	CreateWI_Switch(MBObj);
	CreateWI_Texture2(MBObj);
	CreateWI_Texture2Transform(MBObj);
	CreateWI_TextureCoordinate2(MBObj);
	CreateWI_WWWAnchor(MBObj);
	CreateWI_WWWInline(MBObj);
	CreateWI_ILS(MBObj);
	CreateWI_TransformSeparator(MBObj);
	CreateWI_Sphere(MBObj);
	// CreateWI_Msg(MBObj);
	CreateWI_CyberGL(MBObj);
	// CreateWI_About(MBObj);

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

	MBObj->GR_AboutGL = GroupObject,
		MUIA_HelpNode, "GR_AboutGL",
		MUIA_Weight, 50,
	End;

	MBObj->LV_AboutText = FloattextObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
		MUIA_Floattext_Text,
		    "\033c\033u\0338VRMLEditor\n"
		    "\033cVersion 0.62 (28.10.98)\n"
		    "\033c68040\n\n"
		    "\033cWritten by BODMER Stephan\n"
		    "\033c(bodmer2@uni2a.unige.ch)\n\n"
		    "\033cCopyright 1997/98 by BodySoft\n\n"
		    "\033cThis version is a BETA version\n"
		    // "\033conly released for courageous beta testers\n"
		    // "\033cPlease don't distribute this version !\n"
		    "\033cVRMLEditor is freeware and soft-ware\n\n"
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
		    "\033cSebastian Nohn\n",
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
		MUIA_Window_ID, MAKE_ID('4', '1', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_About,
	End;

	MBObj->App = ApplicationObject,
		MUIA_Application_Author, "Bodmer Stephan (bodmer2@uni2a.unige.ch)",
		MUIA_Application_Base, "VRMLEditor",
		MUIA_Application_Title, "VRMLEditor",
		MUIA_Application_Version, "$VER:00.62 (28.10.98) ",
		MUIA_Application_Copyright, "Bodmer Stephan (BodySoft)",
		MUIA_Application_Description, "VRML V1.0 ascii parser and editor",
		// MUIA_HelpFile, "MUI_VRMLEditor.guide",
		MUIA_Application_UseCommodities, FALSE,
		SubWindow, MBObj->WI_Main,
		SubWindow, MBObj->WI_Cube,
		SubWindow, MBObj->WI_Add,
		SubWindow, MBObj->WI_Transform,
		SubWindow, MBObj->WI_Separator,
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
		SubWindow, MBObj->WI_Group,
		SubWindow, MBObj->WI_LOD,
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
		SubWindow, MBObj->WI_Switch,
		SubWindow, MBObj->WI_Texture2,
		SubWindow, MBObj->WI_Texture2Transform,
		SubWindow, MBObj->WI_TextureCoordinate2,
		SubWindow, MBObj->WI_WWWAnchor,
		SubWindow, MBObj->WI_WWWInline,
		SubWindow, MBObj->WI_ILS,
		SubWindow, MBObj->WI_TransformSeparator,
		SubWindow, MBObj->WI_Sphere,
		SubWindow, MBObj->WI_Msg,
		SubWindow, MBObj->WI_CyberGL,
		SubWindow, MBObj->WI_About,
	End;

	if (!MBObj->App)
	{
		FreeVec(MBObj);
		return(NULL);
	}

	#include "Main_Notify.h"
	#include "Notify.include"

	return(MBObj);
}

void DisposeApp(struct ObjApp * MBObj)
{
	MUI_DisposeObject( (Object *) MBObj->App);
	DeleteGLAreaCustomClass(MBObj->glmcc);
	DeleteDDListtreeCustomClass(MBObj->ltmcc);
	FreeVec(MBObj);
}
