type
„Window_t=struct{
ˆ*Window_tw_NextWindow;
ˆ
ˆuintw_LeftEdge,w_TopEdge;
ˆuintw_Width,w_Height;
ˆ
ˆintw_MouseY,w_MouseX;
ˆ
ˆuintw_MinWidth,w_MinHeight;
ˆuintw_MaxWidth,w_MaxHeight;
ˆ
ˆulongw_Flags;
ˆ
ˆ*Menu_tw_MenuStrip;
ˆ
ˆ*charw_Title;
ˆ
ˆ*Requester_tw_FirstRequest;
ˆ*Requester_tw_DMRequest;
ˆuintw_ReqCount;
ˆ
ˆ*Screen_tw_WScreen;
ˆ*RastPort_tw_RPort;
ˆ
ˆushortw_BorderLeft,w_BorderTop,w_BorderRight,w_BorderBottom;
ˆ*RastPort_tw_BorderRPort;
ˆ
ˆ*Gadget_tw_FirstGadget;
ˆ
ˆ*Window_tw_Parent,w_Descendant;
ˆ
ˆ*uintw_Pointer;
ˆushortw_PtrHeight,w_PtrWidth;
ˆshortw_XOffset,w_YOffset;
ˆ
ˆulongw_IDCMPFlags;
ˆ*MsgPort_tw_UserPort,w_WindowPort;
ˆ*IntuiMessage_tw_MessageKey;
ˆ
ˆushortw_DetailPen,w_BlockPen;
ˆ
ˆ*Image_tw_CheckMark;
ˆ
ˆ*charw_ScreenTitle;
ˆ
ˆintw_GZZMouseX,w_GZZMouseY;
ˆuintw_GZZWidth,w_GZZHeight;
ˆ
ˆ*bytew_ExtData;
ˆ
ˆ*bytew_UserData;
ˆ
ˆ*Layer_tw_WLayer;
ˆ
ˆ*TextFont_tw_IFont;
„};

ulong
„WINDOWSIZING„=0x00000001,
„WINDOWDRAG†=0x00000002,
„WINDOWDEPTH…=0x00000004,
„WINDOWCLOSE…=0x00000008,

„SIZEBRIGHT†=0x00000010,
„SIZEBBOTTOM…=0x00000020,

„REFRESHBITS…=0x000000C0,
„SMART_REFRESHƒ=0x00000000,
„SIMPLE_REFRESH‚=0x00000040,
„SUPER_BITMAP„=0x00000080,
„OTHER_REFRESHƒ=0x000000C0,

„BACKDROPˆ=0x00000100,

„REPORTMOUSE…=0x00000200,

„GIMMEZEROZEROƒ=0x00000400,

„BORDERLESS†=0x00000800,

„ACTIVATEˆ=0x00001000,

„WINDOWACTIVE„=0x00002000,
„INREQUEST‡=0x00004000,
„MENUSTATE‡=0x00008000,

„RMBTRAP‰=0x00010000,
„NOCAREREFRESHƒ=0x00020000,

„WINDOWREFRESHƒ=0x01000000,
„WBENCHWINDOW„=0x02000000,
„WINDOWTICKED„=0x04000000,

„SUPER_UNUSED„=0xF8FC0000;

type
„NewWindow_t=struct{
ˆuintnw_LeftEdge,nw_TopEdge;
ˆuintnw_Width,nw_Height;
ˆ
ˆushortnw_DetailPen,nw_BlockPen;
ˆ
ˆulongnw_IDCMPFlags;
ˆ
ˆulongnw_Flags;
ˆ
ˆ*Gadget_tnw_FirstGadget;
ˆ
ˆ*Image_tnw_CheckMark;
ˆ
ˆ*charnw_Title;
ˆ
ˆ*Screen_tnw_Screen;
ˆ
ˆ*BitMap_tnw_BitMap;
ˆ
ˆuintnw_MinWidth,nw_MinHeight;
ˆuintnw_MaxWidth,nw_MaxHeight;
ˆ
ˆuintnw_Type;
„};

uint
„FREESIZE=0xffff;

ushort
„FREEPEN=0xff;

extern
„ActivateWindow(*Window_tw)void,
„BeginRefresh(*Window_tw)void,
„ClearPointer(*Window_tw)void,
„CloseWindow(*Window_tw)void,
„EndRefresh(*Window_tw;ulongcomplete)void,
„ModifyIDCMP(*Window_tw;ulongIDCMPFlags)void,
„MoveWindow(*Window_tw;longdeltaX,deltaY)void,
„OpenWindow(*NewWindow_tnw)*Window_t,
„RefreshWindowFrame(*Window_tw)void,
„ReportMouse(ulongvalue;*Window_tw)void,
„SetPointer(*Window_tw;*uintpointer;
ulongheight,width;longXOffset,YOffset)void,
„SetWindowTitles(*Window_tw;*charwindowTitle,screenTitle)void,
„SizeWindow(*Window_tw;longdeltaX,deltaY)void,
„ViewPortAddress(*Window_tw)*ViewPort_t,
„WindowLimits(*Window_tw;ulongminWidth,minHeight,maxWidth,maxHeight)bool,
„WindowToBack(*Window_tw)void,
„WindowToFront(*Window_tw)void;
