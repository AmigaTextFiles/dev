{*  REVISION HEADER
**
**  Program         :   Include:Libraries/triton.i
**  Copyright       :   Nils Sjoholm
**  Author          :   Nils Sjoholm
**                      nils.sjoholm@mailbox.swipnet.se
**
**  Creation Date   :   02 May 1996
**  Current version :   $VER: triton.i 1.0 (14 May 1998)
**
**  Remarks         :   This is a header file for PCQ Pascal.
**                      It's translated from Stefan Zeigers triton.h
**                      Triton.h and triton.library is
**                      (C) Coyright 1993-1995 Stefan Zeiger
**                      All Rights Reserved.
**
**  Translator      :   PCQ Pascal 1.2d
**                      (C) Patric Quaid
**
**
**  REVISION HISTORY
**
**  Date            Version      Comment
**  -----------     -------      ------------------------------------
**  02 May 1996     1.0          First version for triton 1.4
**  14 May 1998     2.0          Final version for OpenTriton
**
**
** END OF REVISION HEADER
*}

{///"Includes"}
{$I "Include:Exec/Types.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Utility/TagItem.i"}
{///}


{* ////////////////////////////////////////////////////////////////////////////// *}

{* ------------------------------------------------------------------------------ *}
{* library name and version                                                       *}
{* ------------------------------------------------------------------------------ *}

CONST   TRITONNAME        = "triton.library";
        TRITON10VERSION   = 1;
        TRITON11VERSION   = 2;
        TRITON12VERSION   = 3;
        TRITON13VERSION   = 4;
        TRITON14VERSION   = 5;
        TRITON20VERSION   = 6;
        TRITONVERSION     = TRITON20VERSION;

{* ------------------------------------------------------------------------------ *}
{* Triton Message                                                                 *}
{* ------------------------------------------------------------------------------ *}

TYPE
     TR_ProjectPtr = ^TR_Project;
     TR_AppPtr     = ^TR_App;

     TR_Message = RECORD
         {* trm_Project   : TR_ProjectPtr; *} {* The project which triggered  *}
         trm_Project   : TR_ProjectPtr;       {* the message                  *}
         trm_Id        : Integer;       {* The object's ID              *}
         trm_Class     : Integer;       {* The Triton message class     *}
         trm_Data      : Integer;       {* The class-specific data      *}
         trm_Code      : Integer;       {* Currently only used BY       *}
                                        {* TRMS_KEYPRESSED              *}
         trm_Pad0      : Integer;       {* qualifier is only 16 Bit     *}
         trm_Qualifier : Integer;       {* Qualifiers                   *}
         trm_Seconds   : Integer;       {* \ Copy of system clock time  *}
         trm_Micros    : Integer;       {* / (Only where available! IF  *}
                                        {*    not set, seconds is NULL) *}
         {* trm_App       : TR_AppPtr; *}    {* The project's application    *}
         trm_App       : TR_AppPtr;
     END;                               {* End of TR_Message            *}
     TR_MessagePtr = ^TR_Message;

{* Data for TROM_NEW *}
     TROM_NewDataPtr = ^TROM_NewData;
     TROM_NewData = record
         {* The following elements are set up for the object (read only) *}
         project    : TR_ProjectPtr;     {*  TR_ProjectPtr;  *}
         firstitem  : TagItemPtr;
         objecttype : ULONG;
         grouptype  : ULONG;
         itemdata   : ULONG;
         backfilltype : ULONG;
         {* The following elements have to be set by the object and read by class_DisplayObject *}
         parseargs  : BOOL;
     end;


{* Data for TROM_INSTALL *}
     TROM_InstallDataPtr = ^TROM_InstallData;
     TROM_InstallData = record
         left : ULONG;
         top  : ULONG;
         width : ULONG;
         height : ULONG;
     end;


{* Data for TROM_SETATTRIBUTE *}
     TROM_SetAttributeDataPtr = ^TROM_SetAttributeData;
     TROM_SetAttributeData = record
         attribute : ULONG;
         value     : ULONG;
     end;


{* Data for TROM_EVENT *}
     TROM_EventDataPtr = ^TROM_EventData;
     TROM_EventData = record
         imsg : Address;
     end;

{* ------------------------------------------------------------------------------ *}
{* The Application Structure                                                      *}
{* ------------------------------------------------------------------------------ *}

     TR_App = RECORD {* This structure is PRIVATE! *}
         tra_MemPool    : Address;       {* The memory pool             *}
         tra_BitMask    : Integer;       {* Bits to Wait() for          *}
         tra_Name       : String;        {* Unique name                 *}
     END; {* TR_App *}

     TR_ClassPtr = ^TR_Class;
     TR_Class = RECORD
         trc_Node     : MinNode;         {* PRIVATE! *}
         trc_SuperClass : TR_ClassPtr;
     end;
     



{* ------------------------------------------------------------------------------ *}
{* The Dimension Structure                                                        *}
{* ------------------------------------------------------------------------------ *}

     TR_Dimensions = RECORD
         trd_Left          : Word;
         trd_Top           : Word;
         trd_Width         : Word;
         trd_Height        : Word;
         trd_Left2         : Word;
         trd_Top2          : Word;
         trd_Width2        : Word;
         trd_Height2       : Word;
         trd_Zoomed        : BOOL;
         reserved          : ARRAY [0..2] OF Word;
     END; {* TR_Dimensions *}
     TR_DimensionsPtr = ^TR_Dimensions;

{* ////////////////////////////////////////////////////////////////////// *}
{* ///////////////////////////// Default classes, attributes and flags // *}
{* ////////////////////////////////////////////////////////////////////// *}


     TROD_Object = record
         Node : MinNode;             {* The node for linking all objects *}
         Class : TR_ClassPtr;        {* The object's class *}
         Project : TR_ProjectPtr;    {* The object's project *}
         Reserved : array [0..5] of ULONG;
     end;
     TROD_ObjectPtr = ^TROD_Object;



     TROD_DisplayObject = record
         O           : TROD_Object;       {* Superclass object data *}
         ID          : ULONG;             {* The object's ID *}
         MinWidth    : ULONG;             {* The precalculated minimum width *}
         MinHeight   : ULONG;             {* The precalculated minimum height *}
         Left        : ULONG;             {* The X coordinate of the object *}
         Top         : ULONG;             {* The Y coordinate of the object *}
         Width       : ULONG;             {* The width of the object *}
         Height      : ULONG;             {* The height of the object *}
         Flags       : ULONG;             {* See below for flags *}
         XResize     : BOOL;              {* Horizontally resizable? *}
         YResize     : BOOL;              {* Vertically resizable? *}
         QuickHelpString : String;        {* QuickHelp string *}
         Shortcut    : Short;             {* The object's shortcut *}
         Backfilltype : ULONG;            {* The object's backfill type *}
         Installed   : BOOL;              {* Does the object have an on-screen representation? *}
         Reserved    : array [0..3] of ULONG;   {* Private! *}
     end;
     TROD_DisplayObjectPtr = ^TROD_DisplayObject;

{* Data for TROM_HIT *}
     TROM_HitData = record
         x : ULONG;
         y : ULONG;
         object : TROD_DisplayObjectPtr;
     end;
     TROM_HitDataPtr = ^TROM_HitData;

{* ------------------------------------------------------------------------------ *}
{* The Projects Structure                                                         *}
{* ------------------------------------------------------------------------------ *}

     TR_Project = RECORD
         tro_SC_Object                : TROD_OBject;          {* PRIVATE *}
         trp_App                      : TR_AppPtr;            {* Our application            *}
         trp_MemPool                  : Address;              {* The memory pool *}
         trp_ID                       : ULONG;                {* The project's ID *}
         trp_IDCMPFlags               : ULONG;                {* The IDCMP flags *}
         trp_Window                   : Address;            {* The default window *}
         trp_AspectFixing             : Word;                 {* Pixel aspect correction factor *}
     END;                                               {* End of TR_Projects               *}

{* Message classes *}
CONST   TRMS_CLOSEWINDOW        = 1;  {* The window should be closed *}
        TRMS_ERROR              = 2;  {* An error occured. Error code in trm_Data *}
        TRMS_NEWVALUE           = 3;  {* Object's VALUE has changed. New VALUE in trm_Data *}
        TRMS_ACTION             = 4;  {* Object has triggered an action *}
        TRMS_ICONDROPPED        = 5;  {* Icon dropped over window (ID=0) or DropBox. AppMessage* in trm_Data *}
        TRMS_KEYPRESSED         = 6;  {* Key pressed. trm_Data contains ASCII code,  trm_Code raw code and *}
                                      {* trm_Qualifier contains qualifiers *}
        TRMS_HELP               = 7;  {* The user requested help for the specified ID *}
        TRMS_DISKINSERTED       = 8;  {* A disk has been inserted into a drive *}
        TRMS_DISKREMOVED        = 9;  {* A disk has been removed from a drive *}


{* ////////////////////////////////////////////////////////////////////// *}
{* //////////////////////////////////////////////// Triton error codes // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRER_OK                 = 0;        {* No error *}

        TRER_ALLOCMEM           = 1;        {* Not enough memory *}
        TRER_OPENWINDOW         = 2;        {* Can't open window *}
        TRER_WINDOWTOOBIG       = 3;        {* Window would be too big for screen *}
        TRER_DRAWINFO           = 4;        {* Can't get screen's DrawInfo *}
        TRER_OPENFONT           = 5;        {* Can't open font *}
        TRER_CREATEMSGPORT      = 6;        {* Can't create message port *}
        TRER_INSTALLOBJECT      = 7;        {* Can't create an object *}
        TRER_CREATECLASS        = 8;        {* Can't create a class *}
        TRER_NOLOCKPUBSCREEN    = 9;        {* Can't lock public screen *}
        TRER_CREATEMENUS        = 12;       {* Error while creating the menus *}
        TRER_GT_CREATECONTEXT   = 14;       {* Can't create gadget context *}

        TRER_MAXERRORNUM        = 15;       {* PRIVATE! *}


{* ////////////////////////////////////////////////////////////////////// *}
{* /////////////////////////////////////////////////// Object messages // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TROM_NEW                = 1;         {* Create object *}
        TROM_INSTALL            = 2;         {* Tell object to install itself in the window *}
        TROM_REFRESH            = 4;         {* Refresh object *}
        TROM_REMOVE             = 6;         {* Remove object from window *}
        TROM_DISPOSE            = 7;         {* Dispose an object's private data *}
        TROM_GETATTRIBUTE       = 8;         {* Get an object's attribute *}
        TROM_SETATTRIBUTE       = 9;         {* Set an object's attribute *}
        TROM_EVENT              = 10;        {* IDCMP event *}
        TROM_DISABLED           = 11;        {* Disabled object *}
        TROM_ENABLED            = 12;        {* Enabled object *}
        TROM_KEYDOWN            = 13;        {* Key pressed *}
        TROM_REPEATEDKEYDOWN    = 14;        {* Key pressed repeatedly *}
        TROM_KEYUP              = 15;        {* Key released *}
        TROM_KEYCANCELLED       = 16;        {* Key cancelled *}
        TROM_CREATECLASS        = 17;        {* Create class-specific data *}
        TROM_DISPOSECLASS       = 18;        {* Dispose class-specific data *}
        TROM_HIT                = 22;        {* Find an object for a coordinate pair *}
        TROM_ACTIVATE           = 23;        {* Activate an object *}


        TROM_EVENT_SWALLOWED    = 1;
        TROM_EVENT_CONTINUE     = 0;


{* ////////////////////////////////////////////////////////////////////// *}
{* ///////////////////////////////////////// Tags for TR_OpenProject() // *}
{* ////////////////////////////////////////////////////////////////////// *}

{* Tag bases *}
        TRTG_OAT              = (TAG_USER+$400);  {* Object attribute *}
        TRTG_CLS              = (TAG_USER+$100);  {* Class ID $1 to $2FF *}
        TRTG_OAT2             = (TAG_USER+$80);   {* PRIVATE! *}
        TRTG_PAT              = (TAG_USER);        {* Project attribute *}


{* Window/Project *}
        TRWI_Title              = (TRTG_PAT+$01); {* STRPTR: The window title *}
        TRWI_Flags              = (TRTG_PAT+$02); {* See below for window flags *}
        TRWI_Underscore         = (TRTG_PAT+$03); {* BYTE *: The underscore for menu and gadget shortcuts *}
        TRWI_Position           = (TRTG_PAT+$04); {* Window position,  see below *}
        TRWI_CustomScreen       = (TRTG_PAT+$05); {* STRUCT Screen * *}
        TRWI_PubScreen          = (TRTG_PAT+$06); {* STRUCT Screen *,  must have been locked! *}
        TRWI_PubScreenName      = (TRTG_PAT+$07); {* ADDRESS,  Triton is doing the locking *}
        TRWI_PropFontAttr       = (TRTG_PAT+$08); {* STRUCT TextAttr *: The proportional font *}
        TRWI_FixedWidthFontAttr = (TRTG_PAT+$09); {* STRUCT TextAttr *: The fixed-width font *}
        TRWI_Backfill           = (TRTG_PAT+$0A); {* The backfill type,  see below *}
        TRWI_ID                 = (TRTG_PAT+$0B); {* ULONG: The window ID *}
        TRWI_Dimensions         = (TRTG_PAT+$0C); {* STRUCT TR_Dimensions * *}
        TRWI_ScreenTitle        = (TRTG_PAT+$0D); {* STRPTR: The screen title *}
        TRWI_QuickHelp          = (TRTG_PAT+$0E); {* BOOL: Quick help active? *}

{* Menus *}
        TRMN_Title              = (TRTG_PAT+$65); {* STRPTR: Menu *}
        TRMN_Item               = (TRTG_PAT+$66); {* STRPTR: Menu item *}
        TRMN_Sub                = (TRTG_PAT+$67); {* STRPTR: Menu subitem *}
        TRMN_Flags              = (TRTG_PAT+$68); {* See below for flags *}

{* General object attributes *}
        TRAT_ID               = (TRTG_OAT2+$16);  {* The object's/menu's ID *}
        TRAT_Flags            = (TRTG_OAT2+$17);  {* The object's flags *}
        TRAT_Value            = (TRTG_OAT2+$18);  {* The object's value *}
        TRAT_Text             = (TRTG_OAT2+$19);  {* The object's text *}
        TRAT_Disabled         = (TRTG_OAT2+$1A);  {* Disabled object? *}
        TRAT_Backfill         = (TRTG_OAT2+$1B);  {* Backfill pattern *}
        TRAT_MinWidth         = (TRTG_OAT2+$1C);  {* Minimum width *}
        TRAT_MinHeight        = (TRTG_OAT2+$1D);  {* Minimum height *}


{* ////////////////////////////////////////////////////////////////////// *}
{* ////////////////////////////////////////////////////// Window flags // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRWF_BACKDROP           = $00000001;     {* Create a backdrop borderless window *}
        TRWF_NODRAGBAR          = $00000002;     {* Don't use a dragbar *}
        TRWF_NODEPTHGADGET      = $00000004;     {* Don't use a depth-gadget *}
        TRWF_NOCLOSEGADGET      = $00000008;     {* Don't use a close-gadget *}
        TRWF_NOACTIVATE         = $00000010;     {* Don't activate window *}
        TRWF_NOESCCLOSE         = $00000020;     {* Don't send TRMS_CLOSEWINDOW when Esc is pressed *}
        TRWF_NOPSCRFALLBACK     = $00000040;     {* Don't fall back onto default PubScreen *}
        TRWF_NOZIPGADGET        = $00000080;     {* Don't use a zip-gadget *}
        TRWF_ZIPCENTERTOP       = $00000100;     {* Center the zipped window on the title bar *}
        TRWF_NOMINTEXTWIDTH     = $00000200;     {* Minimum window width not according to title text *}
        TRWF_NOSIZEGADGET       = $00000400;     {* Don't use a sizing-gadget *}
        TRWF_NOFONTFALLBACK     = $00000800;     {* Don't fall back to topaz.8 *}
        TRWF_NODELZIP           = $00001000;     {* Don't zip the window when Del is pressed *}
        TRWF_SIMPLEREFRESH      = $00002000;     {* *** OBSOLETE *** (V3+) *}
        TRWF_ZIPTOCURRENTPOS    = $00004000;     {* Will zip the window at the current position (OS3.0+) *}
        TRWF_APPWINDOW          = $00008000;     {* Create an AppWindow without using class_dropbox *}
        TRWF_ACTIVATESTRGAD     = $00010000;     {* Activate the first string gadget after opening the window *}
        TRWF_HELP               = $00020000;     {* Pressing <Help> will create a TRMS_HELP message (V4) *}
        TRWF_SYSTEMACTION       = $00040000;     {* System status messages will be sent (V4) *}


{* ////////////////////////////////////////////////////////////////////// *}
{* //////////////////////////////////////////////////////// Menu flags // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRMF_CHECKIT            = $00000001;     {* Leave space for a checkmark *}
        TRMF_CHECKED            = $00000002;     {* Check the item (includes TRMF_CHECKIT) *}
        TRMF_DISABLED           = $00000004;     {* Ghost the menu/item *}


{* ////////////////////////////////////////////////////////////////////// *}
{* ////////////////////////////////////////////////// Window positions // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRWP_DEFAULT            = 0;              {* Let Triton choose a good position *}
        TRWP_BELOWTITLEBAR      = 1;              {* Left side of screen,  below title bar *}
        TRWP_CENTERTOP          = 1025;           {* Top of screen,  centered on the title bar *}
        TRWP_TOPLEFTSCREEN      = 1026;           {* Top left corner of screen *}
        TRWP_CENTERSCREEN       = 1027;           {* Centered on the screen *}
        TRWP_CENTERDISPLAY      = 1028;           {* Centered on the currently displayed clip *}
        TRWP_MOUSEPOINTER       = 1029;           {* Under the mouse pointer *}
        TRWP_ABOVECOORDS        = 2049;           {* Above coordinates from the dimensions STRUCT *}
        TRWP_BELOWCOORDS        = 2050;           {* Below coordinates from the dimensions STRUCT *}


{* ////////////////////////////////////////////////////////////////////// *}
{* //////////////////////////////////// Backfill types / System images // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRBF_WINDOWBACK         = $00000000;     {* Window backfill *}
        TRBF_REQUESTERBACK      = $00000001;     {* Requester backfill *}

        TRBF_NONE               = $00000002;     {* No backfill (= Fill with BACKGROUNDPEN) *}
        TRBF_SHINE              = $00000003;     {* Fill with SHINEPEN *}
        TRBF_SHINE_SHADOW       = $00000004;     {* Fill with SHINEPEN + SHADOWPEN *}
        TRBF_SHINE_FILL         = $00000005;     {* Fill with SHINEPEN + FILLPEN *}
        TRBF_SHINE_BACKGROUND   = $00000006;     {* Fill with SHINEPEN + BACKGROUNDPEN *}
        TRBF_SHADOW             = $00000007;     {* Fill with SHADOWPEN *}
        TRBF_SHADOW_FILL        = $00000008;     {* Fill with SHADOWPEN + FILLPEN *}
        TRBF_SHADOW_BACKGROUND  = $00000009;     {* Fill with SHADOWPEN + BACKGROUNDPEN *}
        TRBF_FILL               = $0000000A;     {* Fill with FILLPEN *}
        TRBF_FILL_BACKGROUND    = $0000000B;     {* Fill with FILLPEN + BACKGROUNDPEN *}

        TRSI_USBUTTONBACK       = $00010002;     {* Unselected button backfill *}
        TRSI_SBUTTONBACK        = $00010003;     {* Selected button backfill *}



{* ////////////////////////////////////////////////////////////////////// *}
{* /////////////////////////////////////////////////////// Frame types // *}
{* ////////////////////////////////////////////////////////////////////// *}

        { * Copies of the GadTools BBFT_#? types *}
        TRFT_BUTTON       = 1;
        TRFT_RIDGE        = 2;
        TRFT_ICONDROPBOX  = 3;
        { * Triton's low-level frame types *}
        TRFT_XENBUTTON1   = 33;
        TRFT_XENBUTTON2   = 34;
        TRFT_NEXTBUTTON   = 35;
        { * Triton's abstract frame types *}
        TRFT_ABSTRACT_BUTTON      = 65;
        TRFT_ABSTRACT_ICONDROPBOX = 66;
        TRFT_ABSTRACT_FRAMEBOX    = 67;
        TRFT_ABSTRACT_PROGRESS    = 68;
        TRFT_ABSTRACT_GROUPBOX    = 69;


{* ////////////////////////////////////////////////////////////////////// *}
{* ///////////////////////////////////////////////////////// Pen types // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRPT_SYSTEMPEN   = 0;
        TRPT_GRAPHICSPEN = 1;
        TRPT_TRITONPEN   = 128;

        TRTP_NORMUSCORE         = 0;
        TRTP_HIGHUSCORE         = 1;
        TRTP_HALFSHINE          = 2;
        TRTP_HALFSHADOW         = 3;
        TRTP_USSTRINGGADBACK    = 4;
        TRTP_SSTRINGGADBACK     = 5;
        TRTP_USSTRINGGADFRONT   = 6;
        TRTP_SSTRINGGADFRONT    = 7;

{* ////////////////////////////////////////////////////////////////////// *}
{* ////////////////////////////////////////////// Display Object flags // *}
{* ////////////////////////////////////////////////////////////////////// *}

{* General flags *}
        TROF_RAISED             = $00000001;     {* Raised object *}
        TROF_HORIZ              = $00000002;     {* Horizontal object \ Works automatically *}
        TROF_VERT               = $00000004;     {* Vertical object   / in groups *}
        TROF_RIGHTALIGN         = $00000008;     {* Align object to the right border if available *}
        TROF_GENERAL_MASK       = $000000FF;     {* PRIVATE *}

{* Text flags for different kinds of text-related objects *}
        TRTX_NOUNDERSCORE       = $00000100;     {* Don't interpret underscores *}
        TRTX_HIGHLIGHT          = $00000200;     {* Highlight text *}
        TRTX_3D                 = $00000400;     {* 3D design *}
        TRTX_BOLD               = $00000800;     {* Softstyle 'bold' *}
        TRTX_TITLE              = $00001000;     {* A title (e.g. of a group) *}
        TRTX_MULTILINE          = $00002000;     {* A multi-line text. See TR_PrintText() autodoc clip *}
        TRTX_RIGHTALIGN         = TROF_RIGHTALIGN;
        TRTX_CENTER             = $00004000;     {* Center text *}
        TRTX_SELECTED           = $00002000;     {* PRIVATE! *}

{* ////////////////////////////////////////////////////////////////////// *}
{* ////////////////////////////////////////////////////// Menu entries // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRMN_BARLABEL           = (-1);           {* A barlabel instead of text *}


{* ////////////////////////////////////////////////////////////////////// *}
{* /////////////////////////////////////////// Tags for TR_CreateApp() // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TRCA_Name               = (TAG_USER+1);
        TRCA_LongName           = (TAG_USER+2);
        TRCA_Info               = (TAG_USER+3);
        TRCA_Version            = (TAG_USER+4);
        TRCA_Release            = (TAG_USER+5);
        TRCA_Date               = (TAG_USER+6);


{* ////////////////////////////////////////////////////////////////////// *}
{* ///////////////////////////////////////// Tags for TR_EasyRequest() // *}
{* ////////////////////////////////////////////////////////////////////// *}

        TREZ_ReqPos             = (TAG_USER+1);
        TREZ_LockProject        = (TAG_USER+2);
        TREZ_Return             = (TAG_USER+3);
        TREZ_Title              = (TAG_USER+4);
        TREZ_Activate           = (TAG_USER+5);

{* class_DisplayObject *}

        TROB_DisplayObject      = (TRTG_CLS+$3C); {* A basic display object *}

        TRDO_QuickHelpString    = (TRTG_OAT+$1E3);

{* Flags *}
        TROB_DISPLAYOBJECT_DISABLED    = $00100000; {* Disabled? *}
        TROB_DISPLAYOBJECT_RETURNOK    = $00200000; {* Activate with <Return> *}
        TROB_DISPLAYOBJECT_ESCOK       = $00400000; {* Activate with <Esc> *}
        TROB_DISPLAYOBJECT_TABOK       = $00800000; {* Activate with <Tab> *}
        TROB_DISPLAYOBJECT_SPACE       = $01000000; {* A spacing object? *}

{* class_DragItem *}

         TROB_DragItem          = (TRTG_CLS+$3E); {* A draggable item *}

{* class_Image *}

        TROB_Image              = (TRTG_CLS+$3B); {* An image *}

        TRIM_BOOPSI             = $00010000;     {* Use a BOOPSI IClass image *}

{* class_String *}

        TROB_String             = (TRTG_CLS+$37); {* A string gadget *}
        TRST_Filter             = (TRTG_OAT+$1E4);

        TRST_INVISIBLE          = $00010000;     {* A password gadget -> invisible typing *}
        TRST_NORETURNBROADCAST  = $00020000;     {* <Return> keys will not be broadcast to the window *}
        TRST_FLOAT              = $00040000;     {* Separators "." and "," will be accepted only once *}

{* class_Cycle *}

        TROB_Cycle              = (TRTG_CLS+$36); {* A cycle gadget *}

        TRCY_MX                 = $00010000;     {* Unfold the cycle gadget to a MX gadget *}
        TRCY_RIGHTLABELS        = $00020000;     {* Put the labels to the right of a MX gadget *}

{* class_Palette *}

        TROB_Palette            = (TRTG_CLS+$33); {* A palette gadget *}

{* class_DropBox *}

        TROB_DropBox            = (TRTG_CLS+$38); {* An icon drop box *}

{* class_Group *}

        TRGR_Horiz              = (TAG_USER+201);  {* Horizontal group *}
        TRGR_Vert               = (TAG_USER+202);  {* Vertical group *}
        TRGR_End                = (TRTG_OAT2+$4B); {* End of a group *}

        TRGR_PROPSHARE          = $00000000;     {* Default: Divide objects proportionally *}
        TRGR_EQUALSHARE         = $00000001;     {* Divide objects equally *}
        TRGR_PROPSPACES         = $00000002;     {* Divide spaces proportionally *}
        TRGR_ARRAY              = $00000004;     {* Top-level array group *}

        TRGR_ALIGN              = $00000008;     {* Align resizeable objects in secondary dimension *}
        TRGR_CENTER             = $00000010;     {* Center unresizeable objects in secondary dimension *}

        TRGR_FIXHORIZ           = $00000020;     {* Don't allow horizontal resizing *}
        TRGR_FIXVERT            = $00000040;     {* Don't allow vertical resizing *}
        TRGR_INDEP              = $00000080;     {* Group is independant of surrounding array *}

{* class_Line *}

        TROB_Line               = (TRTG_CLS+$2D); {* A simple line *}

{* class_Slider *}

        TROB_Slider             = (TRTG_CLS+$34); {* A slider gadget *}

        TRSL_Min                = (TRTG_OAT+$1DE);
        TRSL_Max                = (TRTG_OAT+$1DF);

{* class_Listview *}

        TROB_Listview           = (TRTG_CLS+$39); {* A listview gadget *}

        TRLV_Top                = (TRTG_OAT+$1E2);
        TRLV_VisibleLines       = (TRTG_OAT+$1E4);

        TRLV_READONLY           = $00010000;     {* A read-only list *}
        TRLV_SELECT             = $00020000;     {* You may select an entry *}
        TRLV_SHOWSELECTED       = $00040000;     {* Selected entry will be shown *}
        TRLV_NOCURSORKEYS       = $00080000;     {* Don't use arrow keys *}
        TRLV_NONUMPADKEYS       = $00100000;     {* Don't use numeric keypad keys *}
        TRLV_FWFONT             = $00200000;     {* Use the fixed-width font *}
        TRLV_NOGAP              = $00400000;     {* Don't leave a gap below the list *}

{* class_Progress *}

        TROB_Progress           = (TRTG_CLS+$3A); {* A progress indicator *}

{* class_Space *}

        TROB_Space              = (TRTG_CLS+$285); {* The spaces class *}

        TRST_NONE               = 1;              {* No space *}
        TRST_SMALL              = 2;              {* Small space *}
        TRST_NORMAL             = 3;              {* Normal space (default) *}
        TRST_BIG                = 4;              {* Big space *}

{* class_Text *}

        TROB_Text               = (TRTG_CLS+$30); {* A line of text *}

        TRTX_CLIPPED            = $00010000;     {* Text is clipped *}

{* class_Button *}

        TROB_Button             = (TRTG_CLS+$31); {* A BOOPSI button gadget *}

        TRBU_RETURNOK           = $00010000;     {* <Return> answers the button *}
        TRBU_ESCOK              = $00020000;     {* <Esc> answers the button *}
        TRBU_SHIFTED            = $00040000;     {* Shifted shortcut only *}
        TRBU_UNSHIFTED          = $00080000;     {* Unshifted shortcut only *}
        TRBU_YRESIZE            = $00100000;     {* Button resizeable in Y direction *}
        TRBT_TEXT               = 0;              {* Text button *}
        TRBT_GETFILE            = 1;              {* GetFile button *}
        TRBT_GETDRAWER          = 2;              {* GetDrawer button *}
        TRBT_GETENTRY           = 3;              {* GetEntry button *}

{* class_CheckBox *}

        TROB_CheckBox           = (TRTG_CLS+$2F); {* A checkbox gadget *}

{* class_Object *}

        TROB_Object             = (TRTG_CLS+$3D); {* A rootclass object *}

{* class_Scroller *}

        TROB_Scroller           = (TRTG_CLS+$35); {* A scroller gadget *}

        TRSC_Total              = (TRTG_OAT+$1E0);
        TRSC_Visible            = (TRTG_OAT+$1E1);

{* class_FrameBox *}

        TROB_FrameBox           = (TRTG_CLS+$32); {* A framing box *}

        TRFB_GROUPING           = $00000001;     {* A grouping box *}
        TRFB_FRAMING            = $00000002;     {* A framing box *}
        TRFB_TEXT               = $00000004;     {* A text container *}


{* ////////////////////////////////////////////////////////////////////// *}
{* /////////////////////////////////////////////////////////// The End // *}
{* ////////////////////////////////////////////////////////////////////// *}
         
var
    TritonBase : Address;

function TR_OpenProject(app : TR_AppPtr; taglist : TagItemPtr):TR_ProjectPtr;
    EXTERNAL;

PROCEDURE TR_CloseProject(project : TR_ProjectPtr);
    EXTERNAL;

function TR_FirstOccurance( ch : Integer): Integer;
    EXTERNAL;

function TR_NumOccurances(ch : Integer; str : string): Integer;
    EXTERNAL;

function TR_GetErrorString(num : Short): String;
    EXTERNAL;

PROCEDURE TR_SetAttribute(project : TR_ProjectPtr; ID, attribute, VALUE: Integer);
    EXTERNAL;

function TR_GetAttribute(project : TR_ProjectPtr; ID, attribute : Integer):Integer;
    EXTERNAL;

procedure TR_LockProject(project : TR_ProjectPtr);
    EXTERNAL;

Procedure TR_UnlockProject(project : TR_ProjectPtr);
    EXTERNAL;

function TR_AutoRequest(app : TR_AppPtr; lockproject : TR_ProjectPtr; wintags : TagItemPtr): Integer;
    EXTERNAL;

function TR_EasyRequest(app : TR_AppPtr; bodyfmt, gadfmt : String; taglist: TagItemPtr): Integer;
    EXTERNAL;

function TR_CreateApp(apptags : TagItemPtr): TR_AppPtr;
    EXTERNAL;

Procedure TR_DeleteApp(app: TR_AppPtr);
    EXTERNAL;

function TR_GetMsg(app : TR_AppPtr): TR_MessagePtr;
    EXTERNAL;

Procedure TR_ReplyMsg(message : TR_MessagePtr);
    EXTERNAL;

function TR_Wait(app : TR_AppPtr; otherbits : Integer): Integer;
    EXTERNAL;

Procedure TR_CloseWindowSafely(window : Address);
    EXTERNAL;

function TR_GetLastError(app: TR_AppPtr): Short;
    EXTERNAL;

function TR_LockScreen(project : TR_ProjectPtr): Address;
    EXTERNAL;

Procedure TR_UnlockScreen(screen : Address);
    EXTERNAL;

function TR_ObtainWindow(project : TR_ProjectPtr): Address;
    EXTERNAL;

Procedure TR_ReleaseWindow(window : Address);
    EXTERNAL;

function TR_SendMessage(project : TR_ProjectPtr; objectid, messageid: Integer; messagedata : Address): Integer;
    EXTERNAL;

procedure TR_DrawFrame(project : TR_ProjectPtr; rp : Address; left,top,width,height,thetype : word;inverted : BOOL);
external;

function TR_FrameBorderHeight(project : TR_ProjectPtr; thetype : word): ULONG;
external;

function TR_FrameBorderWidth(project : TR_ProjectPtr; thetype : word): ULONG;
external;

function TR_TextWidth(project : TR_ProjectPtr; txt : string; flags : ULONG): ULONG;
external;

function TR_TextHeight(project : TR_ProjectPtr; txt : string; flags : ULONG): ULONG;
external;

procedure TR_PrintText(project : TR_ProjectPtr; rp : Address;
                       txt : string; x,y,width,flags : ULONG);
external;

function TR_GetPen(project : TR_ProjectPtr; pentype,pendata : ULONG): ULONG;
external;

function TR_DoMethod(object : TROD_ObjectPtr; messageid : ULONG; data : Address): ULONG;
external;

function TR_DoMethodClass(object : TROD_ObjectPtr; messageid : ULONG; data : Address; cl : TR_ClassPtr): ULONG;
external;

procedure TR_AreaFill(project : TR_Project; rp : Address;
                      left,top,right,bottom,thetype : ULONG; dummy : Address);
external;

function TR_CreatMsg(app : TR_AppPtr): TR_MessagePtr;
external;

{$C+}
function TR_CreateAppTags(...): TR_AppPtr;
external;

function TR_OpenProjectTags(theapp : TR_AppPtr; ...): TR_ProjectPtr;
external;

function TR_EasyRequestTags(TheApp : TR_AppPtr; bodyfmt, gadfmt: string; ...): integer;
external;

function TR_AutoRequestTags(app : TR_AppPtr; lockproject : TR_ProjectPtr; ...): Integer;
EXTERNAL;

{$C-}

