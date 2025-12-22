#include "MUI_CPP.include" 

/*
extern ULONG StartScreen (register __a0 Object *me,
			  register __a2 Object *obj,
			  register __a1 struct TagItem *tags);

extern ULONG StopScreen (register __a0 Object *me,
			 register __a2 Object *obj,
			 register __a1 struct ScreenModeRequester *req );
*/

void CreateWI_Prefs(struct ObjApp *MBObj)
{
	APTR    GP_RT_Prefs, GR_PrefsParser, obj_aux0, obj_aux1, GR_grp_231, Space_13;
	APTR    GR_PrefsparserType, GR_PrefsResolve, obj_aux2, obj_aux3, Space_14;
	APTR    GR_PrefsCyberGL, GR_grp_232, Space_15, GR_grp_193, obj_aux4, obj_aux5;
	APTR    obj_aux6, obj_aux7, obj_aux8, obj_aux9, Space_16, GR_grp_213, obj_aux10;
	APTR    obj_aux11, obj_aux12, obj_aux13, obj_aux14, obj_aux15, GR_grp_242;
	APTR    GR_PrefsMisc, obj_aux16, obj_aux17, obj_aux18, obj_aux19, GR_PrefsCmd;

	static const struct Hook StartScreenHook = { {NULL, NULL}, (HOOKFUNC) StartScreen, NULL, NULL};
	static const struct Hook StopScreenHook = { {NULL, NULL}, (HOOKFUNC) StopScreen, NULL, NULL};
	// static const struct Hook PrefsCmdHook = { {NULL, NULL}, (HOOKFUNC) PrefsCmd, NULL, NULL};

	MBObj->STR_GR_PrefsRegister[0] = "Parser";
	MBObj->STR_GR_PrefsRegister[1] = "CyberGL";
	MBObj->STR_GR_PrefsRegister[2] = "Misc";
	MBObj->STR_GR_PrefsRegister[3] = NULL;
	MBObj->RA_PrefsTypeContent[0] = "Only errors";
	MBObj->RA_PrefsTypeContent[1] = "All message";
	MBObj->RA_PrefsTypeContent[2] = NULL;

	MBObj->STR_PrefsOutput = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsOutput",
		MUIA_String_Contents, "CON:0/0/400/400/VRMLEditor Parser output",
	End;

	obj_aux1 = Label2("Parser output console or file:");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_PrefsOutput,
	End;

	Space_13 = HVSpace;

	MBObj->RA_PrefsType = RadioObject,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Parser type",
		MUIA_HelpNode, "RA_PrefsType",
		MUIA_Radio_Entries, MBObj->RA_PrefsTypeContent,
	End;

	GR_PrefsparserType = GroupObject,
		MUIA_HelpNode, "GR_PrefsparserType",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->RA_PrefsType,
	End;

	MBObj->CH_PrefsResolve = CheckMark(FALSE);

	obj_aux3 = Label2("Try to resolve WWWInlines");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->CH_PrefsResolve,
	End;

	GR_PrefsResolve = GroupObject,
		MUIA_HelpNode, "GR_PrefsResolve",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "WWWInlines",
		Child, obj_aux2,
	End;

	Space_14 = HVSpace;

	GR_grp_231 = GroupObject,
		MUIA_HelpNode, "GR_grp_231",
		MUIA_Group_Horiz, TRUE,
		Child, Space_13,
		Child, GR_PrefsparserType,
		Child, GR_PrefsResolve,
		Child, Space_14,
	End;

	GR_PrefsParser = GroupObject,
		MUIA_HelpNode, "GR_PrefsParser",
		Child, obj_aux0,
		Child, GR_grp_231,
	End;

	Space_15 = HVSpace;

	MBObj->STR_PrefsConeResolution = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsConeResolution",
		MUIA_String_Contents, "8",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux5 = Label2("Cone");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_PrefsConeResolution,
	End;

	MBObj->STR_PrefsCylinderResolution = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsCylinderResolution",
		MUIA_String_Contents, "8",
	End;

	obj_aux7 = Label2("Cylinder");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_PrefsCylinderResolution,
	End;

	MBObj->STR_PrefsSphereResolution = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsSphereResolution",
		MUIA_String_Contents, "8",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux9 = Label2("Sphere");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_PrefsSphereResolution,
	End;

	GR_grp_193 = GroupObject,
		MUIA_HelpNode, "GR_grp_193",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "CyberGL resolution",
		Child, obj_aux4,
		Child, obj_aux6,
		Child, obj_aux8,
	End;

	Space_16 = HVSpace;

	GR_grp_232 = GroupObject,
		MUIA_HelpNode, "GR_grp_232",
		MUIA_Group_Horiz, TRUE,
		Child, Space_15,
		Child, GR_grp_193,
		Child, Space_16,
	End;

	MBObj->STR_PrefsR = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsR",
		MUIA_String_Contents, "0.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux11 = Label2("R");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_PrefsR,
	End;

	MBObj->STR_PrefsG = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsG",
		MUIA_String_Contents, "0.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux13 = Label2("G");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_PrefsG,
	End;

	MBObj->STR_PrefsB = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsB",
		MUIA_String_Contents, "0.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux15 = Label2("B");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_PrefsB,
	End;

	GR_grp_213 = GroupObject,
		MUIA_HelpNode, "GR_grp_213",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Preview window background color",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux10,
		Child, obj_aux12,
		Child, obj_aux14,
	End;

	// MBObj->STR_PA_PrefsScreen = String("", 80);
	MBObj->TX_PA_PrefsScreen = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, "",
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PA_PrefsScreen = PopButton(MUII_PopUp);

	MBObj->PA_PrefsScreen = PopaslObject,
		MUIA_HelpNode, "PA_PrefsScreen",
		MUIA_Popasl_Type, 2,
		MUIA_Popstring_String, MBObj->TX_PA_PrefsScreen,
		MUIA_Popstring_Button, MBObj->PA_PrefsScreen,
		MUIA_Popasl_StartHook, &StartScreenHook,
		MUIA_Popasl_StopHook, &StopScreenHook,
	End;

	GR_grp_242 = GroupObject,
		MUIA_HelpNode, "GR_grp_242",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Render screen",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->PA_PrefsScreen,
	End;

	GR_PrefsCyberGL = GroupObject,
		MUIA_HelpNode, "GR_PrefsCyberGL",
		Child, GR_grp_232,
		Child, GR_grp_213,
		Child, GR_grp_242,
	End;

	MBObj->STR_PrefsAngle = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsAngle",
		MUIA_String_Contents, "45",
		MUIA_String_Accept, ".-0123456789",
	End;

	obj_aux17 = Label2("Maximum normal smooth angle (DEG)");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->STR_PrefsAngle,
	End;

	MBObj->STR_PrefsGZip = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsGZip",
		MUIA_String_Contents, "C:gzip",
	End;

	obj_aux19 = Label2("GZip command");

	obj_aux18 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux19,
		Child, MBObj->STR_PrefsGZip,
	End;

	GR_PrefsMisc = GroupObject,
		MUIA_HelpNode, "GR_PrefsMisc",
		Child, obj_aux16,
		Child, obj_aux18,
	End;

	MBObj->GR_PrefsRegister = RegisterObject,
		MUIA_Register_Titles, MBObj->STR_GR_PrefsRegister,
		MUIA_HelpNode, "GR_PrefsRegister",
		Child, GR_PrefsParser,
		Child, GR_PrefsCyberGL,
		Child, GR_PrefsMisc,
	End;

	MBObj->BT_PrefsUse = SimpleButton("Use");

	MBObj->BT_PrefsSave = SimpleButton("Save");

	GR_PrefsCmd = GroupObject,
		MUIA_HelpNode, "GR_PrefsCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_PrefsUse,
		Child, MBObj->BT_PrefsSave,
	End;

	GP_RT_Prefs = GroupObject,
		Child, MBObj->GR_PrefsRegister,
		Child, GR_PrefsCmd,
	End;

	MBObj->WI_Prefs = WindowObject,
		MUIA_Window_Title, "Prefs",
		// MUIA_Window_ID, MAKE_ID('1', '4', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Prefs,
	End;

}

