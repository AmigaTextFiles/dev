#ifndef MUI_VRMLEDITOR_H
#define MUI_VRMLEDITOR_H

#include "MUI_H.include"

struct ObjApp
{
	struct MUI_CustomClass *ltmcc;

	//--------- App --------------
	APTR    App;

	//--------- Main window ------
	APTR    WI_Main;
	APTR    MN_MenuBar;
	APTR    MNProjectNewAll;
	APTR    MNProjectNewOnlyMain;
	APTR    MNProjectNewOnlyClip;
	APTR    MNProjectOpen;
	APTR    MNProjectSave;
	APTR    MNProjectSaveasVRML;
	APTR    MNProjectSaveasVRML2;
	APTR    MNProjectSaveasOpenGL;
	APTR    MNProjectExport;
	APTR    MNProjectAbout;
	APTR    MNProjectAboutMUI;
	APTR    MNProjectQuit;
	APTR    MNEditCut;
	APTR    MNEditCopy;
	APTR    MNEditPaste;
	APTR    MNOptionParseroutput;
	APTR    MNOptionPrefs;
	APTR    GL_Logo;
	APTR    BT_MainInfo;
	APTR    BT_MainPreview;
	APTR    GR_MainColor;
	APTR    CF_MainWorld;
	APTR    LT_MainWorld;
	APTR    LV_MainWorld;
	APTR    BT_MainMoveRight;
	APTR    BT_MainMoveLeft;
	APTR    BT_MainMoveUp;
	APTR    BT_MainMoveDown;
	APTR    GR_ClipColor;
	APTR    CF_MainClip;
	APTR    LT_MainClip;
	APTR    LV_MainClip;
	APTR    BT_MainAdd;
	APTR    BT_MainDelete;
	APTR    BT_MainCopy;
	APTR    BT_MainClear;
	APTR    BT_MainExchange;
	APTR    BT_MainTransform;
	APTR    BT_MainSave;
	APTR    BT_MainInsert;

	//--------- Add ---------
	APTR    WI_Add;
	APTR    LV_AddNode;
	APTR    STR_AddNodeName;
	APTR    BT_AddOk;
	APTR    BT_AddCancel;

	//------- MeshWriter -----
	APTR    WI_MeshWriter;
	APTR    CY_MWFormat;
	APTR    PA_MWName;
	APTR    STR_PA_MWName;
	APTR    STR_MWExtension;
	APTR    BT_MWSave;
	// char *  CY_MWFormatContent[2];

	//------- CyberGL --------
	APTR    WI_CyberGL;
	APTR    BT_CyberGLRefresh;
	APTR    BT_CyberGLReset;
	APTR    BT_CyberGLRender;
	APTR    BT_CyberGLBreak;
	APTR    GR_CyberGLOutput;
	APTR    AR_CyberGLArea;
	APTR    IM_CyberGLXLeft;
	APTR    IM_CyberGLXRight;
	APTR    STR_CyberGLX;
	APTR    IM_CyberGLYLeft;
	APTR    IM_CyberGLYRight;
	APTR    STR_CyberGLY;
	APTR    IM_CyberGLZLeft;
	APTR    IM_CyberGLZRight;
	APTR    STR_CyberGLZ;
	APTR    IM_CyberGLHLeft;
	APTR    IM_CyberGLHRight;
	APTR    STR_CyberGLHeading;
	APTR    IM_CyberGLPLeft;
	APTR    IM_CyberGLPRight;
	APTR    STR_CyberGLPitch;
	APTR    IM_CyberGLBLeft;
	APTR    IM_CyberGLBRight;
	APTR    STR_CyberGLBacnk;
	APTR    PO_CyberGLCameras;
	APTR    STR_PO_CyberGLCameras;
	APTR    LV_CyberGLCameras;
	APTR    RA_CyberGLActions;
	APTR    CY_CyberGLWhich;
	APTR    CY_CyberGLLevel;
	APTR    CY_CyberGLMode;
	APTR    CH_CyberGLAxes;
	APTR    CH_CyberGLFull;
	APTR    CH_CyberGLAnimated;
	char *  RA_CyberGLActionsContent[5];
	char *  CY_CyberGLWhichContent[4];
	char *  CY_CyberGLLevelContent[4];
	char *  CY_CyberGLModeContent[9];

	//----------- Prefs -------------
	APTR    WI_Prefs;
	APTR    GR_PrefsRegister;
	APTR    STR_PrefsOutput;
	APTR    RA_PrefsType;
	APTR    CH_PrefsResolve;
	APTR    STR_PrefsConeResolution;
	APTR    STR_PrefsCylinderResolution;
	APTR    STR_PrefsSphereResolution;
	APTR    STR_PrefsR;
	APTR    STR_PrefsG;
	APTR    STR_PrefsB;
	APTR    PA_PrefsScreen;
	APTR    TX_PA_PrefsScreen;
	APTR    STR_PrefsAngle;
	APTR    STR_PrefsGZip;
	APTR    BT_PrefsUse;
	APTR    BT_PrefsSave;
	char *  RA_PrefsTypeContent[3];
	char *  STR_GR_PrefsRegister[4];

	//--------- About -----------
	APTR    WI_About;
	APTR    GR_AboutGL;
	APTR    AR_AboutGLArea;
	APTR    GR_AboutText;
	APTR    LV_AboutText;
	APTR    BT_AboutOk;

	//-------- SaveAs ----------
	APTR    WI_SaveAs;
	APTR    PA_SaveAs;
	APTR    STR_PA_SaveAs;
	APTR    TX_SaveAsFormat;
	APTR    GR_SaveAsV1;
	APTR    CH_SaveAsV1Tex;
	APTR    CH_SaveAsV1Inlines;
	APTR    CH_SaveAsV1Compress;
	APTR    CH_SaveAsV1Normals;
	APTR    GR_SaveAsV2;
	APTR    CH_SaveAsV2Tex;
	APTR    GR_SaveAsGL;
	APTR    CH_SaveAsGLTex;
	APTR    BT_SaveAsSave;

	//------------------------------------------ VRML ----------------------------------

	//-------- Asciitext ---------
	APTR    WI_AsciiText;
	APTR    STR_DEFAsciiTextName;
	APTR    LV_AsciiTextStrings;
	APTR    STR_AsciiTextString;
	APTR    STR_AsciiTextWidth;
	APTR    BT_AsciiTextAdd;
	APTR    BT_AsciiTextDelete;
	APTR    STR_AsciiTextSpacing;
	APTR    CY_AsciiTextJustification;
	APTR    BT_AsciiTextOk;
	APTR    BT_AsciiTextCancel;
	char *  CY_AsciiTextJustificationContent[4];

	//----------- Cone ------------
	APTR    WI_Cone;
	APTR    STR_DEFConeName;
	APTR    STR_ConeBottomRadius;
	APTR    STR_ConeHeight;
	APTR    CH_ConeSides;
	APTR    CH_ConeBottom;
	APTR    BT_ConeOk;
	APTR    BT_ConeDefault;
	APTR    BT_ConeCancel;

	//-------- Coordinate3 ---------
	APTR    WI_Coordinate3;
	APTR    STR_DEFCoordinate3Name;
	APTR    TX_Coordinate3Num;
	APTR    TX_Coordinate3Index;
	APTR    PR_Coordinate3Index;
	APTR    STR_Coordinate3X;
	APTR    STR_Coordinate3Y;
	APTR    STR_Coordinate3Z;
	APTR    BT_Coordinate3Add;
	APTR    BT_Coordinate3Delete;
	APTR    BT_Coordinate3Ok;
	APTR    BT_Coordinate3Cancel;
	char *  STR_TX_Coordinate3Num;
	char *  STR_TX_Coordinate3Index;

	//------------ Cube window ---------------
	APTR    WI_Cube;
	APTR    STR_DEFCubeName;
	APTR    STR_CubeWidth;
	APTR    STR_CubeHeight;
	APTR    STR_CubeDepth;
	APTR    BT_CubeOk;
	APTR    BT_CubeDefault;
	APTR    BT_CubeCancel;

	//----------- Cylinder ------------
	APTR    WI_Cylinder;
	APTR    STR_DEFCylinderName;
	APTR    STR_CylinderRadius;
	APTR    STR_CylinderHeight;
	APTR    CH_CylinderSides;
	APTR    CH_CylinderTop;
	APTR    CH_CylinderBottom;
	APTR    BT_CylinderOk;
	APTR    BT_CylinderDefault;
	APTR    BT_CylinderCancel;

	//-------- Directonallight --------
	APTR    WI_DirectionalLight;
	APTR    STR_DEFDirectionalLightName;
	APTR    CH_DirectionalLightOn;
	APTR    STR_DirectionalLightIntensity;
	APTR    STR_DirectionalLightR;
	APTR    STR_DirectionalLightG;
	APTR    STR_DirectionalLightB;
	APTR    STR_DirectionalLightX;
	APTR    STR_DirectionalLightY;
	APTR    STR_DirectionalLightZ;
	APTR    BT_DirectionalLightOk;
	APTR    BT_DirectionalLightDefault;
	APTR    BT_DirectionalLightCancel;

	//------------ Fontstyle ---------
	APTR    WI_FontStyle;
	APTR    STR_DEFFontStyleName;
	APTR    STR_FontStyleSize;
	APTR    CY_FontStyleFamily;
	APTR    CH_FontStyleBold;
	APTR    CH_FontStyleItalic;
	APTR    BT_FontStyleOk;
	APTR    BT_FontStyleDefault;
	APTR    BT_FontStyleCancel;
	char *  CY_FontStyleFamilyContent[4];

	//---------- Groups -------------
	APTR    WI_Groups;
	APTR    STR_DEFGroupsName;
	APTR    TX_GroupsType;
	APTR    TX_GroupsNum;
	APTR    GR_GroupsLOD;
	APTR    TX_LODRangeIndex;
	APTR    PR_LODRangeIndex;
	APTR    STR_LODRange;
	APTR    BT_LODAdd;
	APTR    BT_LODDelete;
	APTR    STR_LODCenterX;
	APTR    STR_LODCenterY;
	APTR    STR_LODCenterZ;
	APTR    GR_GroupsSeparator;
	APTR    CY_SeparatorRenderCulling;
	APTR    GR_GroupsSwitch;
	APTR    STR_SwitchWhich;
	APTR    GR_GroupsWWWAnchor;
	APTR    STR_WWWAnchorName;
	APTR    STR_WWWAnchorDescription;
	APTR    CY_WWWAnchorMap;
	APTR    BT_GroupsOk;
	char *  STR_TX_GroupsNum;
	char *  STR_TX_LODRangeIndex;
	char *  STR_TX_LODNum;
	char *  CY_SeparatorRenderCullingContent[4];
	char *  CY_WWWAnchorMapContent[3];
	// char *  STR_TX_SeparatorNum;

	//---------- IFS -------------
	APTR    WI_IFS;
	APTR    STR_DEFIFSName;
	APTR    TX_IFSNum;
	APTR    TX_IFSIndex;
	APTR    PR_IFSIndex;
	APTR    BT_IFSAddFace;
	APTR    BT_IFSDeleteFace;
	APTR    LV_IFSCoordIndex;
	APTR    BT_IFSAddPoint;
	APTR    BT_IFSDeletePoint;
	APTR    STR_IFSValue;
	APTR    LV_IFSMaterialIndex;
	APTR    BT_IFSAddMat;
	APTR    BT_IFSDeleteMat;
	APTR    STR_IFSMatValue;
	APTR    LV_IFSNormalIndex;
	APTR    BT_IFSAddNormal;
	APTR    BT_IFSDeleteNormal;
	APTR    STR_IFSNormalValue;
	APTR    LV_IFSTexIndex;
	APTR    BT_IFSAddTex;
	APTR    BT_IFSDeleteTex;
	APTR    STR_IFSTexValue;
	APTR    CH_IFSMat;
	APTR    CH_IFSNormal;
	APTR    CH_IFSTex;
	APTR    BT_IFSOk;
	APTR    BT_IFSCancel;
	char *  STR_TX_IFSNum;
	char *  STR_TX_IFSIndex;

	//--------- ILS ----------
	APTR    WI_ILS;
	APTR    STR_DEFILSName;
	APTR    TX_ILSNum;
	APTR    TX_ILSIndex;
	APTR    PR_ILSIndex;
	APTR    BT_ILSAddLine;
	APTR    BT_ILSDeleteLine;
	APTR    LV_ILSCoordIndex;
	APTR    BT_ILSAddPoint;
	APTR    BT_ILSDeletePoint;
	APTR    STR_ILSValue;
	APTR    LV_ILSMaterialIndex;
	APTR    BT_ILSAddMat;
	APTR    BT_ILSDeleteMat;
	APTR    STR_ILSMatValue;
	APTR    LV_ILSNormalIndex;
	APTR    BT_ILSAddNormal;
	APTR    BT_ILSDeleteNormal;
	APTR    STR_ILSNormalValue;
	APTR    LV_ILSTexIndex;
	APTR    BT_ILSAddTex;
	APTR    BT_ILSDeleteTex;
	APTR    STR_ILSTexValue;
	APTR    CH_ILSMat;
	APTR    CH_ILSNormal;
	APTR    CH_ILSTex;
	APTR    BT_ILSOk;
	APTR    BT_ILSCancel;
	char *  STR_TX_ILSNum;
	char *  STR_TX_ILSIndex;

	//---------- Info -----------
	APTR    WI_Info;
	APTR    STR_DEFInfoName;
	APTR    STR_InfoString;
	APTR    BT_InfoOk;
	APTR    BT_InfoCancel;

	//------------- Meterial ------------
	APTR    WI_Material;
	APTR    STR_DEFMaterialName;
	APTR    TX_MaterialNum;
	APTR    GR_MatPreview;
	APTR    AR_MatGLArea;
	APTR    TX_MaterialIndex;
	APTR    PR_MaterialIndex;
	APTR    BT_MaterialAdd;
	APTR    BT_MaterialDelete;
	APTR    SL_MaterialAR;
	APTR    SL_MaterialAG;
	APTR    SL_MaterialAB;
	APTR    CF_MaterialAmbient;
	APTR    SL_MaterialDR;
	APTR    SL_MaterialDG;
	APTR    SL_MaterialDB;
	APTR    CF_MaterialDiffuse;
	APTR    SL_MaterialSR;
	APTR    SL_MaterialSG;
	APTR    SL_MaterialSB;
	APTR    CF_MaterialSpecular;
	APTR    SL_MaterialER;
	APTR    SL_MaterialEG;
	APTR    SL_MaterialEB;
	APTR    CF_MaterialEmmisive;
	APTR    STR_MaterialShininess;
	APTR    STR_MaterialTransparency;
	APTR    BT_MaterialOk;
	APTR    BT_MaterialDefault;
	APTR    BT_MaterialCancel;
	char *  STR_TX_MaterialNum;
	char *  STR_TX_MaterialIndex;

	//--------- Materialbinding --------
	APTR    WI_MaterialBinding;
	APTR    STR_DEFMaterialBindingName;
	APTR    CY_MaterialBinding;
	APTR    BT_MaterialBindingOk;
	APTR    BT_MaterialBindingCancel;
	char *  CY_MaterialBindingContent[9];

	//----------- MatrixTransform -----------
	APTR    WI_MatrixTransform;
	APTR    STR_DEFMatrixTransformName;
	APTR    STR_MatrixTransform0;
	APTR    STR_MatrixTransform1;
	APTR    STR_MatrixTransform2;
	APTR    STR_MatrixTransform3;
	APTR    STR_MatrixTransform4;
	APTR    STR_MatrixTransform5;
	APTR    STR_MatrixTransform6;
	APTR    STR_MatrixTransform7;
	APTR    STR_MatrixTransform8;
	APTR    STR_MatrixTransform9;
	APTR    STR_MatrixTransform10;
	APTR    STR_MatrixTransform11;
	APTR    STR_MatrixTransform12;
	APTR    STR_MatrixTransform13;
	APTR    STR_MatrixTransform14;
	APTR    STR_MatrixTransform15;
	APTR    BT_MatrixTransformOk;
	APTR    BT_MatrixTransformDefault;
	APTR    BT_MatrixTransformCancel;

	//--------------- Normal -----------------
	APTR    WI_Normal;
	APTR    STR_DEFNormalName;
	APTR    TX_NormalNum;
	APTR    TX_NormalIndex;
	APTR    PR_NormalIndex;
	APTR    STR_NormalX;
	APTR    STR_NormalY;
	APTR    STR_NormalZ;
	APTR    BT_NormalAdd;
	APTR    BT_NormalDelete;
	APTR    BT_NormalOk;
	APTR    BT_NormalCancel;
	char *  STR_TX_NormalNum;
	char *  STR_TX_NormalIndex;

	//-------------- Normal binding -----------
	APTR    WI_NormalBinding;
	APTR    STR_DEFNormalBindingName;
	APTR    CY_NormalBindingValue;
	APTR    BT_NormalBindingOk;
	APTR    BT_NormalBindingCancel;
	char *  CY_NormalBindingValueContent[9];

	//------------- OrthographicCamera ----------
	APTR    WI_OrthographicCamera;
	APTR    STR_DEFOrthographicCameraName;
	APTR    BT_OrthographicCameraView;
	APTR    BT_OrthographicCameraGrab;
	APTR    STR_OrthographicCameraPosX;
	APTR    STR_OrthographicCameraPosY;
	APTR    STR_OrthographicCameraPosZ;
	APTR    STR_OrthographicCameraOX;
	APTR    STR_OrthographicCameraOY;
	APTR    STR_OrthographicCameraOZ;
	APTR    STR_OrthographicCameraOAngle;
	APTR    STR_OrthographicCameraFocal;
	APTR    STR_OrthographicCameraHeight;
	APTR    BT_OrthographicCameraOk;
	APTR    BT_OrthographicCameraDefault;
	APTR    BT_OrthographicCameraCancel;

	//------------- PerspectivCamera -----------
	APTR    WI_PerspectiveCamera;
	APTR    STR_DEFPerspectiveCameraName;
	APTR    BT_PerspectiveCameraView;
	APTR    BT_PerspectiveCameraGrab;
	APTR    STR_PerspectiveCameraX;
	APTR    STR_PerspectiveCameraY;
	APTR    STR_PerspectiveCameraZ;
	APTR    STR_PerspectiveCameraOX;
	APTR    STR_PerspectiveCameraOY;
	APTR    STR_PerspectiveCameraOZ;
	APTR    STR_PerspectiveCameraOAngle;
	APTR    STR_PerspectiveCameraFocal;
	APTR    STR_PerspectiveCameraHeight;
	APTR    BT_PerspectiveCameraOk;
	APTR    BT_PerspectiveCameraDefault;
	APTR    BT_PerspectiveCameraCancel;

	//------------- Pointlight -------------
	APTR    WI_PointLight;
	APTR    STR_DEFPointLightName;
	APTR    CH_PointLightOn;
	APTR    STR_PointLightIntensity;
	APTR    STR_PointLightX;
	APTR    STR_PointLightY;
	APTR    STR_PointLightZ;
	APTR    STR_PointLightR;
	APTR    STR_PointLightG;
	APTR    STR_PointLightB;
	APTR    BT_PointLightOk;
	APTR    BT_PointLightDefault;
	APTR    BT_PointLightCancel;

	//--------------- PointSet ----------
	APTR    WI_PointSet;
	APTR    STR_DEFPointSetName;
	APTR    STR_PointSetStartIndex;
	APTR    STR_PointSetNumPoints;
	APTR    BT_PointSetOk;
	APTR    BT_PointSetDefault;
	APTR    BT_PointSetCancel;

	//--------- Rotation ------------
	APTR    WI_Rotation;
	APTR    STR_DEFRotationName;
	APTR    STR_RotationX;
	APTR    STR_RotationY;
	APTR    STR_RotationZ;
	APTR    STR_RotationA;
	APTR    BT_RotationOk;
	APTR    BT_RotationDefault;
	APTR    BT_RotationCancel;

	//------------ Scale -----------
	APTR    WI_Scale;
	APTR    STR_DEFScaleName;
	APTR    STR_ScaleX;
	APTR    STR_ScaleY;
	APTR    STR_ScaleZ;
	APTR    BT_ScaleOk;
	APTR    BT_ScaleDefault;
	APTR    BT_ScaleCancel;

	//------------ ShapeHints -----------
	APTR    WI_ShapeHints;
	APTR    STR_DEFShapeHintsName;
	APTR    CY_ShapeHintsVertexOrdering;
	APTR    CY_ShapeHintsShapeType;
	APTR    CY_ShapeHintsFaceType;
	APTR    STR_ShapeHintsCreaseAngle;
	APTR    BT_ShapeHintsOk;
	APTR    BT_ShapeHintsDefault;
	APTR    BT_ShapeHintsCancel;
	char *  CY_ShapeHintsVertexOrderingContent[4];
	char *  CY_ShapeHintsShapeTypeContent[3];
	char *  CY_ShapeHintsFaceTypeContent[3];

	//------- Sphere ---------
	APTR    WI_Sphere;
	APTR    STR_DEFSphereName;
	APTR    STR_SphereRadius;
	APTR    BT_SphereOk;
	APTR    BT_SphereDefault;
	APTR    BT_SphereCancel;

	//--------- Spotlight -------------
	APTR    WI_SpotLight;
	APTR    STR_DEFSpotLightName;
	APTR    CH_SpotLightOn;
	APTR    STR_SpotLightIntensity;
	APTR    STR_SpotLightR;
	APTR    STR_SpotLightG;
	APTR    STR_SpotLightB;
	APTR    STR_SpotLightX;
	APTR    STR_SpotLightY;
	APTR    STR_SpotLightZ;
	APTR    STR_SpotLightDirX;
	APTR    STR_SpotLightDirY;
	APTR    STR_SpotLightDirZ;
	APTR    STR_SpotLightDrop;
	APTR    STR_SpotLightCut;
	APTR    BT_SpotLightOk;
	APTR    BT_SpotLightDefault;
	APTR    BT_SpotLightCancel;

	//--------- Texture2 -----------
	APTR    WI_Texture2;
	APTR    GLAR_Texture2Preview;
	APTR    GLAR_Texture2Anim;
	APTR    STR_DEFTexture2Name;
	APTR    PA_Texture2;
	APTR    STR_PA_Texture2;
	APTR    CY_Texture2WrapS;
	APTR    CY_Texture2WrapT;
	APTR    TX_Texture2Width;
	APTR    TX_Texture2Height;
	APTR    TX_Texture2Component;
	APTR    BT_Texture2Ok;
	APTR    BT_Texture2Default;
	APTR    BT_Texture2Cancel;
	char *  STR_TX_Texture2Width;
	char *  STR_TX_Texture2Height;
	char *  STR_TX_Texture2Component;
	char *  CY_Texture2WrapSContent[3];
	char *  CY_Texture2WrapTContent[3];

	//--------- Texture2Display ---------
	// APTR    WI_Texture2Display;
	// APTR    GR_Texture2Display;
	// APTR    GLAR_Texture2;

	//----------- Texture2Transform ----------------
	APTR    WI_Texture2Transform;
	APTR    STR_DEFTexture2TransformName;
	APTR    STR_Texture2TransformTX;
	APTR    STR_Texture2TransformTY;
	APTR    STR_Texture2TransformRot;
	APTR    STR_Texture2TransformSX;
	APTR    STR_Texture2TransformSY;
	APTR    STR_Texture2TransformCenterX;
	APTR    STR_Texture2TransformCenterY;
	APTR    BT_Texture2TransformOk;
	APTR    BT_Texture2TransformDefault;
	APTR    BT_Texture2TransformCancel;

	//----------------- TextureCoordinate2 ------------
	APTR    WI_TextureCoordinate2;
	APTR    STR_DEFTextureCoordinate2Name;
	APTR    TX_TextureCoordinate2Num;
	APTR    TX_TextureCoordinate2Index;
	APTR    PR_TextureCoordinate2Index;
	APTR    STR_TextureCoordinate2X;
	APTR    STR_TextureCoordinate2Y;
	APTR    BT_TextureCoordinate2Add;
	APTR    BT_TextureCoordinate2Delete;
	APTR    BT_TextureCoordinate2Ok;
	APTR    BT_TextureCoordinate2Cancel;
	char *  STR_TX_TextureCoordinate2Num;
	char *  STR_TX_TextureCoordinate2Index;

	//--------- Transform ----------
	APTR    WI_Transform;
	APTR    STR_DEFTransformName;
	APTR    STR_TTranslationX;
	APTR    STR_TTranslationY;
	APTR    STR_TTranslationZ;
	APTR    STR_TRotationX;
	APTR    STR_TRotationY;
	APTR    STR_TRotationZ;
	APTR    STR_TRotationA;
	APTR    STR_TScaleFX;
	APTR    STR_TScaleFY;
	APTR    STR_TScaleFZ;
	APTR    STR_TScaleOX;
	APTR    STR_TScaleOY;
	APTR    STR_TScaleOZ;
	APTR    STR_TScaleOA;
	APTR    STR_TCenterX;
	APTR    STR_TCenterY;
	APTR    STR_TCenterZ;
	APTR    BT_TransformOk;
	APTR    BT_TransformDefault;
	APTR    BT_TransformCancel;

	//---------- Translation -----------
	APTR    WI_Translation;
	APTR    STR_DEFTranslationName;
	APTR    STR_TranslationX;
	APTR    STR_TranslationY;
	APTR    STR_TranslationZ;
	APTR    BT_TranslationOk;
	APTR    BT_TranslationDefault;
	APTR    BT_TranslationCancel;


	//---------- WWWInline ---------
	APTR    WI_WWWInline;
	APTR    STR_DEFWWWInlineName;
	APTR    STR_WWWInlineName;
	APTR    BT_WWWInlineRead;
	APTR    STR_WWWInlineBoxSizeX;
	APTR    STR_WWWInlineBoxSizeY;
	APTR    STR_WWWInlineBoxSizeZ;
	APTR    STR_WWWInlineBoxCenterX;
	APTR    STR_WWWInlineBoxCenterY;
	APTR    STR_WWWInlineBoxCenterZ;
	APTR    BT_WWWInlineOk;
	APTR    BT_WWWInlineDefault;
	APTR    BT_WWWInlineCancel;

	// char *  STR_TX_GroupNum;
	// char *  STR_TX_LODNum;
	// char *  STR_TX_LODRangeIndex;
	// char *  STR_TX_SwitchNum;
	// char *  STR_TX_WWWAnchorNum;
	// char *  STR_TX_TransformSeparatorNum;
	// char *  CY_SeparatorRenderCullingContent[4];
	// char *  CY_WWWAnchorMapContent[3];
};

extern struct ObjApp * CreateApp(void);
extern void DisposeApp(struct ObjApp *);

//------------ Other MUI Windows Creation function ----------------
extern void CreateWI_Main(struct ObjApp *);
extern void CreateWI_Cube(struct ObjApp *);
extern void CreateWI_Add(struct ObjApp *);
extern void CreateWI_Transform(struct ObjApp *);
extern void CreateWI_Translation(struct ObjApp *);
extern void CreateWI_Cylinder(struct ObjApp *);
extern void CreateWI_Material(struct ObjApp *);
extern void CreateWI_MaterialBinding(struct ObjApp *);
extern void CreateWI_Rotation(struct ObjApp *);
extern void CreateWI_Scale(struct ObjApp *);
extern void CreateWI_Cone(struct ObjApp *);
extern void CreateWI_Coordinate3(struct ObjApp *);
extern void CreateWI_IFS(struct ObjApp *);
extern void CreateWI_Prefs(struct ObjApp *);
extern void CreateWI_Groups(struct ObjApp *);
extern void CreateWI_AsciiText(struct ObjApp *);
extern void CreateWI_DirectionalLight(struct ObjApp *);
extern void CreateWI_FontStyle(struct ObjApp *);
extern void CreateWI_Info(struct ObjApp *);
extern void CreateWI_MatrixTransform(struct ObjApp *);
extern void CreateWI_Normal(struct ObjApp *);
extern void CreateWI_NormalBinding(struct ObjApp *);
extern void CreateWI_OrthographicCamera(struct ObjApp *);
extern void CreateWI_PerspectiveCamera(struct ObjApp *);
extern void CreateWI_PointLight(struct ObjApp *);
extern void CreateWI_PointSet(struct ObjApp *);
extern void CreateWI_ShapeHints(struct ObjApp *);
extern void CreateWI_SpotLight(struct ObjApp *);
extern void CreateWI_Texture2(struct ObjApp *);
// extern void CreateWI_Texture2Display(struct ObjApp *);
extern void CreateWI_Texture2Transform(struct ObjApp *);
extern void CreateWI_TextureCoordinate2(struct ObjApp *);
extern void CreateWI_Translation(struct ObjApp *);
extern void CreateWI_WWWInline(struct ObjApp *);
extern void CreateWI_ILS(struct ObjApp *);
extern void CreateWI_Sphere(struct ObjApp *);
extern void CreateWI_CyberGL(struct ObjApp *);
extern void CreateWI_MeshWriter(struct ObjApp *);
extern void CreateWI_SaveAs(struct ObjApp *);

#endif
