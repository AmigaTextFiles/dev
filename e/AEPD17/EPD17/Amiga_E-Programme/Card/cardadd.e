ow_CloseRequest,MUI_TRUE,wi_Listviews,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Groups   ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Groups   ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Backfill ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Backfill ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Cycle    ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Cycle    ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_String   ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_String   ,3,MUIM_Set,MUIA_Window_Open,FALSE])


/*
** Closing the master window forces a complete shutdown of the application.
*/

   doMethod(wi_Master,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,ap_Demo,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** This connects the prop gadgets in the notification demo window.
*/

   doMethod(pr_PropA,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropH,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropA,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropV,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropH,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropL,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropH,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropR,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropV,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropT,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropV,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropB,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])

   doMethod(pr_PropA ,[MUIM_Notify,MUIA_Prop_First   ,MUIV_EveryTime,ga_Gauge2,3,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])
   doMethod(ga_Gauge2,[MUIM_Notify,MUIA_Gauge_Current,MUIV_EveryTime,ga_Gauge1,3,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])
   doMethod(ga_Gauge2,[MUIM_Notify,MUIA_Gauge_Current,MUIV_EveryTime,ga_Gauge3,3,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])


/*
** And here we connect cycle gadgets, radio buttons and the list in the
** cycle & radio window.
*/

   doMethod(cy_Computer,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mt_Computer,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])
   doMethod(cy_Printer ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mt_Printer ,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])
   doMethod(cy_Display ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mt_Display ,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])
   doMethod(mt_Computer,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,cy_Computer,3,MUIM_Set,MUIA_Cycle_Active,MUIV_TriggerValue])
   doMethod(mt_Printer ,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,cy_Printer ,3,MUIM_Set,MUIA_Cycle_Active,MUIV_TriggerValue])
   doMethod(mt_Display ,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,cy_Display ,3,MUIM_Set,MUIA_Cycle_Active,MUIV_TriggerValue])
   doMethod(mt_Computer,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,lv_Computer,3,MUIM_Set,MUIA_List_Active ,MUIV_TriggerValue])
   doMethod(lv_Computer,[MUIM_Notify,MUIA_List_Active ,MUIV_EveryTime,mt_Computer,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])


/*
** This one makes us receive input ids from several list views.
*/

   doMethod(lv_Volumes ,[MUIM_Notify,MUIA_Listview_DoubleClick,MUI_TRUE,ap_Demo,2,MUIM_Application_ReturnID,ID_NEWVOL])
   doMethod(lv_Brian   ,[MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,ap_Demo,2,MUIM_Application_ReturnID,ID_NEWBRI])


/*
** Now lets set the TAB cycle chain for some of our windows.
*/

   doMethod(wi_Master   ,[MUIM_Window_SetCycleChain,bt_Groups,bt_Frames,bt_Backfill,bt_Notify,bt_Listviews,bt_Cycle,bt_Images,bt_String,NIL])
   doMethod(wi_Listviews,[MUIM_Window_SetCycleChain,lv_Directory,lv_Volumes,NIL])
   doMethod(wi_Cycle    ,[MUIM_Window_SetCycleChain,mt_Computer,mt_Printer,mt_Display,cy_Computer,cy_Printer,cy_Display,lv_Computer,NIL])
   doMethod(wi_String   ,[MUIM_Window_SetCycleChain,st_Brian,NIL])


/*
** Set some start values for certain objects.
*/

   doMethod(lv_Computer,[MUIM_List_Insert,cya_Computer,-1,MUIV_List_Insert_Bottom])
   doMethod(lv_Brian   ,[MUIM_List_Insert,lvt_Brian,-1,MUIV_List_Insert_Bottom])
   set(lv_Computer,MUIA_List_Active,0)
   set(lv_Brian   ,MUIA_List_Active,0)
   set(st_Brian   ,MUIA_String_AttachedList,lv_Brian)


/*
** Everything's ready, lets launch the application. We will
** open the master window now.
*/

   set(wi_Master,MUIA_Window_Open,MUI_TRUE);


/*
** This is the main loop. As you can see, it does just nothing.
** Everything is handled by MUI, no work for the programmer.
**
** The only thing we do here is to react on a double click
** in the volume list (which causes an ID_NEWVOL) by setting
** a new directory name for the directory list. If you want
** to see a real file requester with MUI, wait for the
** next release of MFR :-)
*/


   running := TRUE  /* Not for MUI -> no need to use MUI_TRUE */

   WHILE running

      result := doMethod(ap_Demo, [MUIM_Application_Input, {signal} ])

      SELECT result

	 CASE MUIV_Application_ReturnID_Quit
	    running := FALSE

	 CASE ID_NEWVOL
	    doMethod(lv_Volumes, [MUIM_List_GetEntry, MUIV_List_GetEntry_Active, {buf} ])
	    set(lv_Directory, MUIA_Dirlist_Directory, buf)

	 CASE ID_NEWBRI
	    get(lv_Brian, MUIA_List_Active, {buf} )
	    set(st_Brian, MUIA_String_Contents, lvt_Brian[buf] )

	 CASE ID_ABOUT
	    MuI_RequestA(ap_Demo, wi_Master, 0, NIL, 'OK', 'MUI-Demo\n© 1992-94 by Stefan Stuntz',NIL)

      ENDSELECT

      IF signal THEN Wait(signal)

   ENDWHILE

/*
** Call the exception handling with ER_NON, this will dispose the
** application object, close "muimaster.library" and end the program.
*/

  Raise(ER_NON)

EXCEPT
  IF ap_Demo THEN MuI_DisposeObject(ap_Demo)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  
  SELECT exception
    CASE ER_MUILIB
      WriteF('Failed to open \s.\n',MUIMASTER_NAME)
      CleanUp(20)

    CASE ER_APP
      WriteF('Failed to create application.\n')
      CleanUp(20)
      
  ENDSELECT
ENDPROC 0


/*
** Some PROCs as replacement for macros
*/

PROC list(ftxt)
    DEF obj
    obj :=  ListviewObject,
	MUIA_Weight, 50,
	MUIA_Listview_Input, FALSE,
	MUIA_Listview_List,FloattextObject,
	    MUIA_Frame, MUIV_Frame_ReadList,
	    MUIA_Floattext_Text, ftxt,
	    MUIA_Floattext_TabSize, 4,
	    MUIA_Floattext_Justify, MUI_TRUE,
	End,
    End
ENDPROC obj

PROC image(nr)
    DEF obj
    obj := ImageObject,
	MUIA_Image_Spec, nr,
    End
ENDPROC obj

PROC scaledImage(nr,s,x,y)
    DEF obj
    obj := ImageObject,
	MUIA_Image_Spec, nr,
	MUIA_FixWidth, x,
	MUIA_FixHeight,y,
	MUIA_Image_FreeHoriz, MUI_TRUE,
	MUIA_Image_FreeVert,  MUI_TRUE,
	MUIA_Image_State, s,
    End
ENDPROC obj

PROC hprop()
    DEF obj
    obj := PropObject,
	PropFrame,
	MUIA_Prop_Horiz, MUI_TRUE,
	MUIA_FixHeight, 8,
	MUIA_Prop_Entries, 111,
	MUIA_Prop_Visible, 10,
    End
ENDPROC obj

PROC vprop()
    DEF obj
    obj := PropObject,
	PropFrame,
	MUIA_Prop_Horiz, FALSE,
	MUIA_FixWidth , 8,
	MUIA_Prop_Entries, 111,
	MUIA_Prop_Visible, 10,
    End
ENDPROC obj


/*
** doMethod (written by Wouter van Oortmerssen)
*/

PROC doMethod( obj:PTR TO object, msg:PTR TO msg )

	DEF h:PTR TO hook, o:PTR TO object, dispatcher

	IF obj
		o := obj-SIZEOF object	/* instance data is to negative offset */
		h := o.class
		dispatcher := h.entry	/* get dispatcher from hook in iclass */
		MOVEA.L h,A0
		MOVEA.L msg,A1
		MOVEA.L obj,A2		/* probably should use CallHookPkt, but the */
		