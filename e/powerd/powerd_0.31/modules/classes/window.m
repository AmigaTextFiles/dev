//MODULE	'reaction/reaction'
#define WINDOW_Dummy 			(REACTION_Dummy + $25000)
#define WINDOW_Window         (WINDOW_Dummy + 1)
#define WINDOW_SigMask        (WINDOW_Dummy + 2)
#define WINDOW_MenuStrip      (WINDOW_Dummy + 4)
#define WINDOW_Layout 	(WINDOW_Dummy + 5)
#define WINDOW_ParentLayout    	WINDOW_Layout
#define WINDOW_ParentGroup 		WINDOW_Layout
#define WINDOW_UserData       (WINDOW_Dummy + 6)
#define WINDOW_SharedPort     (WINDOW_Dummy + 7)
#define WINDOW_Zoom           (WINDOW_Dummy + 8)
#define WINDOW_FrontBack      (WINDOW_Dummy + 9)
#define WINDOW_Activate       (WINDOW_Dummy +10)
#define WINDOW_LockWidth      (WINDOW_Dummy +11)
#define WINDOW_LockHeight     (WINDOW_Dummy +12)
#define WINDOW_AppPort        (WINDOW_Dummy +13)
#define WINDOW_Position 		 (WINDOW_Dummy +14)
#define WINDOW_IDCMPHook      (WINDOW_Dummy +15)
#define WINDOW_IDCMPHookBits  (WINDOW_Dummy +16)
#define WINDOW_GadgetUserData 	(WINDOW_Dummy +17)
#define WINDOW_InterpretUserData 	WINDOW_GadgetUserData
#define WINDOW_MenuUserData 	(WINDOW_Dummy +25)
#define WGUD_HOOK  0	
#define WGUD_FUNC  1	
#define WGUD_IGNORE  2
#define WINDOW_IconTitle 	 (WINDOW_Dummy +18)
#define WINDOW_AppMsgHook 	 (WINDOW_Dummy +19)
#define WINDOW_Icon 			 (WINDOW_Dummy +20)
#define WINDOW_AppWindow 	 (WINDOW_Dummy +21)
#define WINDOW_GadgetHelp 	 (WINDOW_Dummy +22)
#define WINDOW_IconifyGadget  (WINDOW_Dummy +23)
#define WINDOW_TextAttr 		 (WINDOW_Dummy +24)
#define WINDOW_BackFillName 	 (WINDOW_Dummy +26)
#define WINDOW_RefWindow 	 (WINDOW_Dummy +41)
#define WINDOW_InputEvent 	 (WINDOW_Dummy +42)
#define WINDOW_HintInfo 		 (WINDOW_Dummy +43)
#define WINDOW_KillWindow 		(WINDOW_Dummy +44)
#define WINDOW_Application 		(WINDOW_Dummy +45)
#define WINDOW_InterpretIDCMPHook 	(WINDOW_Dummy +46)
#define WINDOW_Parent 			(WINDOW_Dummy +47)
#define WINDOW_PreRefreshHook 	(WINDOW_Dummy +48)
#define WINDOW_PostRefreshHook 	(WINDOW_Dummy +49)
#define WINDOW_AppWindowPtr 	(WINDOW_Dummy +50)
#define WINDOW_VertProp 		(WINDOW_Dummy +27)
#define WINDOW_VertObject 	(WINDOW_Dummy +28)
#define WINDOW_HorizProp 	(WINDOW_Dummy +29)
#define WINDOW_HorizObject 	(WINDOW_Dummy +30)
#define WMHI_LASTMSG                (0)	
#define WMHI_IGNORE                (~0)	
#define WMHI_GADGETMASK 		   ($ffff) 
#define WMHI_MENUMASK 		   ($ffff)	
#define WMHI_KEYMASK 			   ($ff)   
#define WMHI_CLASSMASK  	   ($ffff0000)	
#define WMHI_CLOSEWINDOW         (1<<16)
#define WMHI_GADGETUP 			(2<<16)
#define WMHI_INACTIVE            (3<<16)
#define WMHI_ACTIVE              (4<<16)
#define WMHI_NEWSIZE 			(5<<16)
#define WMHI_MENUPICK 			(6<<16)
#define WMHI_MENUHELP 			(7<<16)
#define WMHI_GADGETHELP 			(8<<16)
#define WMHI_ICONIFY 			(9<<16)
#define WMHI_UNICONIFY 		   (10<<16)
#define WMHI_RAWKEY             (11<<16)
#define WMHI_VANILLAKEY         (12<<16)
#define WMHI_CHANGEWINDOW 	   (13<<16)
#define WMHI_INTUITICK          (14<<16)
#define WMHI_MOUSEMOVE          (15<<16)
#define WMHI_MOUSEBUTTONS       (16<<16)
#define WMHI_DISPOSEDWINDOW 	   (17<<16)
#define WMF_ZOOMED 			   ($0001) 
#define WMF_ZIPWINDOW 		   ($0002) 
#define WT_FRONT    TRUE
#define WT_BACK     FALSE
#define WPOS_CENTERSCREEN         (1)   
#define WPOS_CENTERMOUSE          (2)   
#define WPOS_TOPLEFT              (3)   
#define WPOS_CENTERWINDOW         (4)   
#define WPOS_FULLSCREEN           (5)   

OBJECT wmHandle
	MethodID:ULONG,
	Code:PTR TO WORD

CONST WM_HANDLEINPUT=$570001,
  WM_OPEN=$570002,
  WM_CLOSE=$570003,
  WM_NEWPREFS=$570004,
  WM_ICONIFY=$570005,
  WM_RETHINK=$570006

OBJECT HintInfo
  GadgetID:WORD,
  Code:WORD,
  Text:PTR TO UBYTE,
  Flags:ULONG
