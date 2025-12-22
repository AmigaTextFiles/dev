_Window_CloseRequest,MUI_TRUE,wi_Groups   ,3,MUIM_Set,MUIA_Window_Open,FALSE])
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
   doMethod(lv_Computer,[MUIM_Notify,MUIA_List_Active ,MUIV_EveryTime,mt_Computer,3,MUIM_Set,MUIA_Radio_Active,MUI