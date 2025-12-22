,MUIA_Frame, MUIV_Frame_String,MUIA_ControlChar    , "o",MUIA_String_MaxLen  , 80,MUIA_String_Contents, 0,TAG_DONE]),
			MUIA_Popstring_Button, MuI_MakeObjectA(MUIO_PopButton,[MUII_PopUp]),
			MUIA_Popasl_Type , ASL_FONTREQUEST,
			ASLFO_TITLETEXT  , 'Please select a font...',
		    TAG_DONE]),

		    MUIA_Group_Child, MuI_MakeObjectA(MUIO_Label,['Fixed Font:',Or(MUIO_Label_DoubleFrame,"i")]),
		    MUIA_Group_Child, pop4 := MuI_NewObjectA('Popasl.mui',[TAG_IGNORE,0,
			MUIA_Popstring_String, MuI_NewObjectA('String.mui',[TAG_IGNORE,0,MUIA_Frame, MUIV_Frame_String,MUIA_ControlChar    , "i",MUIA_String_MaxLen  , 80,MUIA_String_Contents, 0,TAG_DONE]),
			MUIA_Popstring_Button, MuI_MakeObjectA(MUIO_PopButton,[MUII_PopUp]),
			MUIA_Popasl_Type , ASL_FONTREQUEST,
			ASLFO_TITLETEXT  , 'Please select a fixed font...',
			ASLFO_FIXEDWIDTHONLY, MUI_TRUE,
		    TAG_DONE]),

		    MUIA_Group_Child, MuI_MakeObjectA(MUIO_Label,['Thanks To:',Or(MUIO_Label_DoubleFrame,"n")]),
		    MUIA_Group_Child, pop5 := MuI_NewObjectA('Popobject.mui',[TAG_IGNORE,0,
			MUIA_Popstring_String, MuI_NewObjectA('String.mui',[TAG_IGNORE,0,MUIA_Frame, MUIV_Frame_String,MUIA_ControlChar    , "n",MUIA_String_MaxLen  , 60,MUIA_String_Contents, 0,TAG_DONE]),
			MUIA_Popstring_Button, MuI_MakeObjectA(MUIO_PopButton,[MUII_PopUp]),
			MUIA_Popobject_StrObjHook, hookStrObj,
			MUIA_Popobject_ObjStrHook, hookObjStr,
			MUIA_Popobject_Object, plist := MuI_NewObjectA('Listview.mui',[TAG_IGNORE,0,
			    MUIA_Listview_List, MuI_NewObjectA('List.mui',[TAG_IGNORE,0,
				MUIA_Frame, MUIV_Frame_InputList,
				MUIA_List_SourceArray, popNames,
			    TAG_DONE]),
			TAG_DONE]),
		    TAG_DONE]),
		TAG_DONE]),
	    TAG_DONE]),
	TAG_DONE]),
    TAG_DONE])

   IF app=NIL THEN Raise(ER_APP)

   doMethod(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
	    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

   doMethod(window,[MUIM_Window_SetCycleChain,pop1,pop2,pop3,pop4,pop5,NIL])

   /* A double click terminates the popping list with a successful r		    Child, scaledImage(MUII_RadioButton,1,26,18),
				    Child, scaledImage(MUII_RadioButton,1,29,21),
				End,
				Child, VSpace(0),
				Child, HGroup,
				    Child, scaledImage(MUII_CheckMark,1,13, 7),
				    Child, scaledImage(MUII_CheckMark,1,16,10),
				    Child, scaledImage(MUII_CheckMark,1,19,13),
				    Child, scaledImage(MUII_CheckMark,1,22,16),
				    Child, scaledImage(MUII_CheckMark,1,25,19),
				    Child, scaledImage(MUII_CheckMark,1,28,22),
				End,
				Child, VSpace(0),
				Child, HGroup,
				    Child, scaledImage(MUII_PopFile,0,12,10),
				    Child, scaledImage(MUII_PopFile,0,15,13),
				    Child, scaledImage(MUII_PopFile,0,18,16),
				    Child, scaledImage(MUII_PopFile,0,21,1