type
„NewWindow_t=unknown48,
„Gadget_t=unknown44,
„List_t=unknown14,

„DrawerData_t=struct{
ˆNewWindow_tdd_NewWindow;
ˆulongdd_CurrentX,dd_CurrentY;
„},

„DiskObject_t=struct{
ˆuintdo_Magic,do_Version;
ˆ*Gadget_tdo_Gadget;
ˆushortdo_Type;
ˆ*chardo_DefaultTool;
ˆ**chardo_ToolTypes;
ˆulongdo_CurrentX,do_CurrentY;
ˆ*DrawerData_tdo_DrawerData;
ˆ*chardo_ToolWindow;
ˆulongdo_StackSize;
„},

„FreeList_t=struct{
ˆuintfl_NumFree;
ˆList_tfl_MemList;
„};

ushort
„WBDISK†=1,
„WBDRAWER„=2,
„WBTOOL†=3,
„WBPROJECTƒ=4,
„WBGARBAGEƒ=5,
„WBDEVICE„=6,
„WBKICK†=7;

ulongDRAWERDATAFILESIZE=sizeof(DrawerData_t);

uint
„WB_DISKMAGICˆ=0xe310,
„WB_DISKVERSION†=1;

uint
„MTYPE_PSTDŠ=1,
„MTYPE_TOOLEXIT†=2,
„MTYPE_DISKCHANGE„=3,
„MTYPE_TIMER‰=4,
„MTYPE_CLOSEDOWN…=5,
„MTYPE_IOPROCˆ=6;

uintGADGBACKFILL‡=0x0001;

ulongNO_ICON_POSITION‚=0x80000000;
