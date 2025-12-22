MODULE Mui;

IMPORT Exec, Utility, Intuition, SYSTEM, ASL, Graphics;

CONST
  LibName* = "muimaster.library";
  Version* = 4;


TYPE

  Object * = Intuition.ObjectPtr;

(***************************************************************************
** ARexx Interface
***************************************************************************)

TYPE
  Command * = STRUCT
    name            * : Exec.STRPTR;
    template        * : Exec.STRPTR;
    parameters      * : LONGINT;
    hook            * : Utility.HookPtr;
    reserved        * : ARRAY 5 OF LONGINT;
  END;


(***************************************************************************
** Return values for MUI_Error()
***************************************************************************)

CONST

        eOK                  * = 0;
        eOutOfMemory         * = 1;
        eOutOfGfxMemory      * = 2;
        eInvalidWindowObject * = 3;
        eMissingLibrary      * = 4;
        eNoARexx             * = 5;
        eSingleTask          * = 6;


(***************************************************************************
** Standard MUI Images
***************************************************************************)

CONST
        iWindowBack    * =  0;
        iRequesterBack * =  1;
        iButtonBack    * =  2;
        iListBack      * =  3;
        iTextBack      * =  4;
        iPropBack      * =  5;
        iActiveBack    * =  6;
        iSelectedBack  * =  7;
        iListCursor    * =  8;
        iListSelect    * =  9;
        iListSelCur    * = 10;
        iArrowUp       * = 11;
        iArrowDown     * = 12;
        iArrowLeft     * = 13;
        iArrowRight    * = 14;
        iCheckMark     * = 15;
        iRadioButton   * = 16;
        iCycle         * = 17;
        iPopUp         * = 18;
        iPopFile       * = 19;
        iPopDrawer     * = 20;
        iPropKnob      * = 21;
        iDrawer        * = 22;
        iHardDisk      * = 23;
        iDisk          * = 24;
        iChip          * = 25;
        iVolume        * = 26;
        iPopUpBack     * = 27;
        iNetwork       * = 28;
        iAssign        * = 29;
        iTapePlay      * = 30;
        iTapePlayBack  * = 31;
        iTapePause     * = 32;
        iTapeStop      * = 33;
        iTapeRecord    * = 34;
        iGroupBack     * = 35;
        iSliderBack    * = 36;
        iSliderKnob    * = 37;
        iTapeUp        * = 38;
        iTapeDown      * = 39;
        iCount         * = 40;


        iBACKGROUND    * = 128    (* These are direct color    *);
        iSHADOW        * = 129    (* combinations and are not  *);
        iSHINE         * = 130    (* affected by users prefs.  *);
        iFILL          * = 131;
        iSHADOWBACK    * = 132    (* Generally, you should     *);
        iSHADOWFILL    * = 133    (* avoid using them. Better  *);
        iSHADOWSHINE   * = 134    (* use one of the customized *);
        iFILLBACK      * = 135    (* images above.             *);
        iFILLSHINE     * = 136;
        iSHINEBACK     * = 137;
        iFILLBACK2     * = 138;
        iHSHINEBACK    * = 139;
        iHSHADOWBACK   * = 140;
        iHSHINESHINE   * = 141;
        iHSHADOWSHADOW * = 142;
        iN1HSHINE      * = 143;
        iLASTPAT       * = 143;


(***************************************************************************
** Special values for some methods
***************************************************************************)

CONST

        vTriggerValue *= 49893131H;
        vEveryTime    *= 49893131H;

        vApplicationSaveENV     * =  0;
        vApplicationSaveENVARC  * = -1;
        vApplicationLoadENV     * =  0;
        vApplicationLoadENVARC  * = -1;

        vApplicationReturnIDQuit * = -1;

        vListInsertTop       * =  0;
        vListInsertActive    * = -1;
        vListInsertSorted    * = -2;
        vListInsertBottom    * = -3;

        vListRemoveFirst     * =  0;
        vListRemoveActive    * = -1;
        vListRemoveLast      * = -2;

        vListSelectOff       * =  0;
        vListSelectOn        * =  1;
        vListSelectToggle    * =  2;
        vListSelectAsk       * =  3;

        vListJumpActive      * = -1;
        vListGetEntryActive  * = -1;
        vListSelectActive    * = -1;

        vListRedrawActive    * = -1;
        vListRedrawAll       * = -2;

        vListExchangeActive  * = -1;



(****************************************************************************)
(** Notify.mui 7.13 (01.12.93)                                             **)
(****************************************************************************)

  cNotify * = "Notify.mui";

(* Methods *)

  CONST mCallHook                  * = 8042B96BH;
  CONST mMultiSet                  * = 8042D356H;
  CONST mNotify                    * = 8042C9CBH;
  CONST mSet                       * = 8042549AH;
  CONST mSetAsString               * = 80422590H;
  CONST mWriteLong                 * = 80428D86H;
  CONST mWriteString               * = 80424BF4H;

(* Attributes *)

  CONST aAppMessage                 * = 80421955H; (* ..g struct AppMessage * *)
  CONST aHelpFile                   * = 80423A6EH; (* isg STRPTR            *)
  CONST aHelpLine                   * = 8042A825H; (* isg LONG              *)
  CONST aHelpNode                   * = 80420B85H; (* isg STRPTR            *)
  CONST aNoNotify                   * = 804237F9H; (* .s. BOOL              *)
  CONST aRevision                   * = 80427EAAH; (* ..g LONG              *)
  CONST aUserData                   * = 80420313H; (* isg ULONG             *)
  CONST aVersion                    * = 80422301H; (* ..g LONG              *)

(****************************************************************************)
(** Application.mui 7.12 (28.11.93)                                        **)
(****************************************************************************)

  cApplication * = "Application.mui";

(* Methods *)

  CONST mApplicationGetMenuCheck   * = 8042C0A7H;
  CONST mApplicationGetMenuState   * = 8042A58FH;
  CONST mApplicationInput          * = 8042D0F5H;
  CONST mApplicationInputBuffered  * = 80427E59H;
  CONST mApplicationLoad           * = 8042F90DH;
  CONST mApplicationPushMethod     * = 80429EF8H;
  CONST mApplicationReturnID       * = 804276EFH;
  CONST mApplicationSave           * = 804227EFH;
  CONST mApplicationSetMenuCheck   * = 8042A707H;
  CONST mApplicationSetMenuState   * = 80428BEFH;
  CONST mApplicationShowHelp       * = 80426479H;

(* Attributes *)

  CONST aApplicationActive          * = 804260ABH; (* isg BOOL              *)
  CONST aApplicationAuthor          * = 80424842H; (* i.g STRPTR            *)
  CONST aApplicationBase            * = 8042E07AH; (* i.g STRPTR            *)
  CONST aApplicationBroker          * = 8042DBCEH; (* ..g Broker *          *)
  CONST aApplicationBrokerHook      * = 80428F4BH; (* isg struct Hook *     *)
  CONST aApplicationBrokerPort      * = 8042E0ADH; (* ..g struct MsgPort *  *)
  CONST aApplicationBrokerPri       * = 8042C8D0H; (* i.g LONG              *)
  CONST aApplicationCommands        * = 80428648H; (* isg struct MUI_Command * *)
  CONST aApplicationCopyright       * = 8042EF4DH; (* i.g STRPTR            *)
  CONST aApplicationDescription     * = 80421FC6H; (* i.g STRPTR            *)
  CONST aApplicationDiskObject      * = 804235CBH; (* isg struct DiskObject * *)
  CONST aApplicationDoubleStart     * = 80423BC6H; (* ..g BOOL              *)
  CONST aApplicationDropObject      * = 80421266H; (* is. Object *          *)
  CONST aApplicationIconified       * = 8042A07FH; (* .sg BOOL              *)
  CONST aApplicationMenu            * = 80420E1FH; (* i.g struct NewMenu *  *)
  CONST aApplicationMenuAction      * = 80428961H; (* ..g ULONG             *)
  CONST aApplicationMenuHelp        * = 8042540BH; (* ..g ULONG             *)
  CONST aApplicationRexxMsg         * = 8042FD88H; (* ..g struct RxMsg *    *)
  CONST aApplicationRexxString      * = 8042D711H; (* .s. STRPTR            *)
  CONST aApplicationSingleTask      * = 8042A2C8H; (* i.. BOOL              *)
  CONST aApplicationSleep           * = 80425711H; (* .s. BOOL              *)
  CONST aApplicationTitle           * = 804281B8H; (* i.g STRPTR            *)
  CONST aApplicationVersion         * = 8042B33FH; (* i.g STRPTR            *)
  CONST aApplicationWindow          * = 8042BFE0H; (* i.. Object *          *)



(****************************************************************************)
(** Window.mui 7.16 (03.12.93)                                             **)
(****************************************************************************)

  cWindow * = "Window.mui";

(* Methods *)

  CONST mWindowGetMenuCheck        * = 80420414H;
  CONST mWindowGetMenuState        * = 80420D2FH;
  CONST mWindowScreenToBack        * = 8042913DH;
  CONST mWindowScreenToFront       * = 804227A4H;
  CONST mWindowSetCycleChain       * = 80426510H;
  CONST mWindowSetMenuCheck        * = 80422243H;
  CONST mWindowSetMenuState        * = 80422B5EH;
  CONST mWindowToBack              * = 8042152EH;
  CONST mWindowToFront             * = 8042554FH;

(* Attributes *)

  CONST aWindowActivate             * = 80428D2FH; (* isg BOOL              *)
  CONST aWindowActiveObject         * = 80427925H; (* .sg Object *          *)
  CONST aWindowAltHeight            * = 8042CCE3H; (* i.g LONG              *)
  CONST aWindowAltLeftEdge          * = 80422D65H; (* i.g LONG              *)
  CONST aWindowAltTopEdge           * = 8042E99BH; (* i.g LONG              *)
  CONST aWindowAltWidth             * = 804260F4H; (* i.g LONG              *)
  CONST aWindowAppWindow            * = 804280CFH; (* i.. BOOL              *)
  CONST aWindowBackdrop             * = 8042C0BBH; (* i.. BOOL              *)
  CONST aWindowBorderless           * = 80429B79H; (* i.. BOOL              *)
  CONST aWindowCloseGadget          * = 8042A110H; (* i.. BOOL              *)
  CONST aWindowCloseRequest         * = 8042E86EH; (* ..g BOOL              *)
  CONST aWindowDefaultObject        * = 804294D7H; (* isg Object *          *)
  CONST aWindowDepthGadget          * = 80421923H; (* i.. BOOL              *)
  CONST aWindowDragBar              * = 8042045DH; (* i.. BOOL              *)
  CONST aWindowHeight               * = 80425846H; (* i.g LONG              *)
  CONST aWindowID                   * = 804201BDH; (* isg ULONG             *)
  CONST aWindowInputEvent           * = 804247D8H; (* ..g struct InputEvent * *)
  CONST aWindowLeftEdge             * = 80426C65H; (* i.g LONG              *)
  CONST aWindowMenu                 * = 8042DB94H; (* i.. struct NewMenu *  *)
  CONST aWindowNoMenus              * = 80429DF5H; (* .s. BOOL              *)
  CONST aWindowOpen                 * = 80428AA0H; (* .sg BOOL              *)
  CONST aWindowPublicScreen         * = 804278E4H; (* isg STRPTR            *)
  CONST aWindowRefWindow            * = 804201F4H; (* is. Object *          *)
  CONST aWindowRootObject           * = 8042CBA5H; (* i.. Object *          *)
  CONST aWindowScreen               * = 8042DF4FH; (* isg struct Screen *   *)
  CONST aWindowScreenTitle          * = 804234B0H; (* isg STRPTR            *)
  CONST aWindowSizeGadget           * = 8042E33DH; (* i.. BOOL              *)
  CONST aWindowSizeRight            * = 80424780H; (* i.. BOOL              *)
  CONST aWindowSleep                * = 8042E7DBH; (* .sg BOOL              *)
  CONST aWindowTitle                * = 8042AD3DH; (* isg STRPTR            *)
  CONST aWindowTopEdge              * = 80427C66H; (* i.g LONG              *)
  CONST aWindowWidth                * = 8042DCAEH; (* i.g LONG              *)
  CONST aWindowWindow               * = 80426A42H; (* ..g struct Window *   *)


  CONST vWindowActiveObjectNone     * = 0;
  CONST vWindowActiveObjectNext     * = -1;
  CONST vWindowActiveObjectPrev     * = -2;


  PROCEDURE vWindowAltHeightMinMax      * (p:LONGINT): LONGINT; BEGIN RETURN (0-(p)) END vWindowAltHeightMinMax;
  PROCEDURE vWindowAltHeightVisible     * (p:LONGINT): LONGINT; BEGIN RETURN (-100-(p)) END vWindowAltHeightVisible;
  PROCEDURE vWindowAltHeightScreen      * (p:LONGINT): LONGINT; BEGIN RETURN (-200-(p)) END vWindowAltHeightScreen;
  CONST vWindowAltHeightScaled      * = -1000;
  CONST vWindowAltLeftEdgeCentered  * = -1;
  CONST vWindowAltLeftEdgeMoused    * = -2;
  CONST vWindowAltLeftEdgeNoChange  * = -1000;
  CONST vWindowAltTopEdgeCentered   * = -1;
  CONST vWindowAltTopEdgeMoused     * = -2;
  PROCEDURE vWindowAltTopEdgeDelta      * (p:LONGINT): LONGINT; BEGIN RETURN (-3-(p)) END vWindowAltTopEdgeDelta;
  CONST vWindowAltTopEdgeNoChange   * = -1000;
  PROCEDURE vWindowAltWidthMinMax       * (p:LONGINT): LONGINT; BEGIN RETURN (0-(p)) END vWindowAltWidthMinMax;
  PROCEDURE vWindowAltWidthVisible      * (p:LONGINT): LONGINT; BEGIN RETURN (-100-(p)) END vWindowAltWidthVisible;
  PROCEDURE vWindowAltWidthScreen       * (p:LONGINT): LONGINT; BEGIN RETURN (-200-(p)) END vWindowAltWidthScreen;
  CONST vWindowAltWidthScaled       * = -1000;
  PROCEDURE vWindowHeightMinMax         * (p:LONGINT): LONGINT; BEGIN RETURN (0-(p)) END vWindowHeightMinMax;
  PROCEDURE vWindowHeightVisible        * (p:LONGINT): LONGINT; BEGIN RETURN (-100-(p)) END vWindowHeightVisible;
  PROCEDURE vWindowHeightScreen         * (p:LONGINT): LONGINT; BEGIN RETURN (-200-(p)) END vWindowHeightScreen;
  CONST vWindowHeightScaled         * = -1000;
  CONST vWindowHeightDefault        * = -1001;
  CONST vWindowLeftEdgeCentered     * = -1;
  CONST vWindowLeftEdgeMoused       * = -2;
  CONST vWindowMenuNoMenu           * = -1;
  CONST vWindowTopEdgeCentered      * = -1;
  CONST vWindowTopEdgeMoused        * = -2;
  PROCEDURE vWindowTopEdgeDelta         * (p:LONGINT): LONGINT; BEGIN RETURN (-3-(p)) END vWindowTopEdgeDelta;
  PROCEDURE vWindowWidthMinMax          * (p:LONGINT): LONGINT; BEGIN RETURN (0-(p)) END vWindowWidthMinMax;
  PROCEDURE vWindowWidthVisible         * (p:LONGINT): LONGINT; BEGIN RETURN (-100-(p)) END vWindowWidthVisible;
  PROCEDURE vWindowWidthScreen          * (p:LONGINT): LONGINT; BEGIN RETURN (-200-(p)) END vWindowWidthScreen;
  CONST vWindowWidthScaled          * = -1000;
  CONST vWindowWidthDefault         * = -1001;


(****************************************************************************)
(** Area.mui 7.15 (28.11.93)                                               **)
(****************************************************************************)

  cArea * = "Area.mui";

(* Methods *)

  CONST mAskMinMax                 * = 80423874H;
  CONST mCleanup                   * = 8042D985H;
  CONST mDraw                      * = 80426F3FH;
  CONST mHandleInput               * = 80422A1AH;
  CONST mHide                      * = 8042F20FH;
  CONST mSetup                     * = 80428354H;
  CONST mShow                      * = 8042CC84H;

(* Attributes *)

  CONST aApplicationObject          * = 8042D3EEH; (* ..g Object *          *)
  CONST aBackground                 * = 8042545BH; (* is. LONG              *)
  CONST aBottomEdge                 * = 8042E552H; (* ..g LONG              *)
  CONST aControlChar                * = 8042120BH; (* i.. char              *)
  CONST aDisabled                   * = 80423661H; (* isg BOOL              *)
  CONST aExportID                   * = 8042D76EH; (* isg LONG              *)
  CONST aFixHeight                  * = 8042A92BH; (* i.. LONG              *)
  CONST aFixHeightTxt               * = 804276F2H; (* i.. LONG              *)
  CONST aFixWidth                   * = 8042A3F1H; (* i.. LONG              *)
  CONST aFixWidthTxt                * = 8042D044H; (* i.. STRPTR            *)
  CONST aFont                       * = 8042BE50H; (* i.g struct TextFont * *)
  CONST aFrame                      * = 8042AC64H; (* i.. LONG              *)
  CONST aFramePhantomHoriz          * = 8042ED76H; (* i.. BOOL              *)
  CONST aFrameTitle                 * = 8042D1C7H; (* i.. STRPTR            *)
  CONST aHeight                     * = 80423237H; (* ..g LONG              *)
  CONST aHorizWeight                * = 80426DB9H; (* i.. LONG              *)
  CONST aInnerBottom                * = 8042F2C0H; (* i.. LONG              *)
  CONST aInnerLeft                  * = 804228F8H; (* i.. LONG              *)
  CONST aInnerRight                 * = 804297FFH; (* i.. LONG              *)
  CONST aInnerTop                   * = 80421EB6H; (* i.. LONG              *)
  CONST aInputMode                  * = 8042FB04H; (* i.. LONG              *)
  CONST aLeftEdge                   * = 8042BEC6H; (* ..g LONG              *)
  CONST aPressed                    * = 80423535H; (* ..g BOOL              *)
  CONST aRightEdge                  * = 8042BA82H; (* ..g LONG              *)
  CONST aSelected                   * = 8042654BH; (* isg BOOL              *)
  CONST aShowMe                     * = 80429BA8H; (* isg BOOL              *)
  CONST aShowSelState               * = 8042CAACH; (* i.. BOOL              *)
  CONST aTimer                      * = 80426435H; (* ..g LONG              *)
  CONST aTopEdge                    * = 8042509BH; (* ..g LONG              *)
  CONST aVertWeight                 * = 804298D0H; (* i.. LONG              *)
  CONST aWeight                     * = 80421D1FH; (* i.. LONG              *)
  CONST aWidth                      * = 8042B59CH; (* ..g LONG              *)
  CONST aWindow                     * = 80421591H; (* ..g struct Window *   *)
  CONST aWindowObject               * = 8042669EH; (* ..g Object *          *)

  CONST vFontInherit                * = 0;
  CONST vFontNormal                 * = -1;
  CONST vFontList                   * = -2;
  CONST vFontTiny                   * = -3;
  CONST vFontFixed                  * = -4;
  CONST vFontTitle                  * = -5;
  CONST vFrameNone                  * = 0;
  CONST vFrameButton                * = 1;
  CONST vFrameImageButton           * = 2;
  CONST vFrameText                  * = 3;
  CONST vFrameString                * = 4;
  CONST vFrameReadList              * = 5;
  CONST vFrameInputList             * = 6;
  CONST vFrameProp                  * = 7;
  CONST vFrameGauge                 * = 8;
  CONST vFrameGroup                 * = 9;
  CONST vFramePopUp                 * = 10;
  CONST vFrameVirtual               * = 11;
  CONST vFrameSlider                * = 12;
  CONST vFrameCount                 * = 13;
  CONST vInputModeNone              * = 0;
  CONST vInputModeRelVerify         * = 1;
  CONST vInputModeImmediate         * = 2;
  CONST vInputModeToggle            * = 3;


(****************************************************************************)
(** Rectangle.mui 7.14 (28.11.93)                                          **)
(****************************************************************************)

  cRectangle * = "Rectangle.mui";

(* Attributes *)

  CONST aRectangleHBar              * = 8042C943H; (* i.g BOOL              *)
  CONST aRectangleVBar              * = 80422204H; (* i.g BOOL              *)



(****************************************************************************)
(** Image.mui 7.13 (28.11.93)                                              **)
(****************************************************************************)

  cImage * = "Image.mui";

(* Attributes *)

  CONST aImageFontMatch             * = 8042815DH; (* i.. BOOL              *)
  CONST aImageFontMatchHeight       * = 80429F26H; (* i.. BOOL              *)
  CONST aImageFontMatchWidth        * = 804239BFH; (* i.. BOOL              *)
  CONST aImageFreeHoriz             * = 8042DA84H; (* i.. BOOL              *)
  CONST aImageFreeVert              * = 8042EA28H; (* i.. BOOL              *)
  CONST aImageOldImage              * = 80424F3DH; (* i.. struct Image *    *)
  CONST aImageSpec                  * = 804233D5H; (* i.. char *            *)
  CONST aImageState                 * = 8042A3ADH; (* is. LONG              *)



(****************************************************************************)
(** Text.mui 7.15 (28.11.93)                                               **)
(****************************************************************************)

  cText * = "Text.mui";

(* Attributes *)

  CONST aTextContents               * = 8042F8DCH; (* isg STRPTR            *)
  CONST aTextHiChar                 * = 804218FFH; (* i.. char              *)
  CONST aTextPreParse               * = 8042566DH; (* isg STRPTR            *)
  CONST aTextSetMax                 * = 80424D0AH; (* i.. BOOL              *)
  CONST aTextSetMin                 * = 80424E10H; (* i.. BOOL              *)



(****************************************************************************)
(** String.mui 7.13 (28.11.93)                                             **)
(****************************************************************************)

  cString * = "String.mui";

(* Attributes *)

  CONST aStringAccept               * = 8042E3E1H; (* isg STRPTR            *)
  CONST aStringAcknowledge          * = 8042026CH; (* ..g STRPTR            *)
  CONST aStringAttachedList         * = 80420FD2H; (* i.. Object *          *)
  CONST aStringBufferPos            * = 80428B6CH; (* .sg LONG              *)
  CONST aStringContents             * = 80428FFDH; (* isg STRPTR            *)
  CONST aStringDisplayPos           * = 8042CCBFH; (* .sg LONG              *)
  CONST aStringFormat               * = 80427484H; (* i.g LONG              *)
  CONST aStringInteger              * = 80426E8AH; (* isg ULONG             *)
  CONST aStringMaxLen               * = 80424984H; (* i.. LONG              *)
  CONST aStringReject               * = 8042179CH; (* isg STRPTR            *)
  CONST aStringSecret               * = 80428769H; (* i.g BOOL              *)

  CONST vStringFormatLeft           * = 0;
  CONST vStringFormatCenter         * = 1;
  CONST vStringFormatRight          * = 2;


(****************************************************************************)
(** Prop.mui 7.12 (28.11.93)                                               **)
(****************************************************************************)

  cProp * = "Prop.mui";

(* Attributes *)

  CONST aPropEntries                * = 8042FBDBH; (* isg LONG              *)
  CONST aPropFirst                  * = 8042D4B2H; (* isg LONG              *)
  CONST aPropHoriz                  * = 8042F4F3H; (* i.g BOOL              *)
  CONST aPropSlider                 * = 80429C3AH; (* isg BOOL              *)
  CONST aPropVisible                * = 8042FEA6H; (* isg LONG              *)



(****************************************************************************)
(** Gauge.mui 7.35 (26.01.94)                                              **)
(****************************************************************************)

  cGauge * = "Gauge.mui";

(* Attributes *)

  CONST aGaugeCurrent               * = 8042F0DDH; (* isg LONG              *)
  CONST aGaugeDivide                * = 8042D8DFH; (* isg BOOL              *)
  CONST aGaugeHoriz                 * = 804232DDH; (* i.. BOOL              *)
  CONST aGaugeInfoText              * = 8042BF15H; (* isg char *            *)
  CONST aGaugeMax                   * = 8042BCDBH; (* isg LONG              *)



(****************************************************************************)
(** Scale.mui 7.31 (26.01.94)                                              **)
(****************************************************************************)

  cScale * = "Scale.mui";

(* Attributes *)

  CONST aScaleHoriz                 * = 8042919AH; (* isg BOOL              *)



(****************************************************************************)
(** Boopsi.mui 7.31 (26.01.94)                                             **)
(****************************************************************************)

  cBoopsi * = "Boopsi.mui";

(* Attributes *)

  CONST aBoopsiClass                * = 80426999H; (* isg struct IClass *   *)
  CONST aBoopsiClassID              * = 8042BFA3H; (* isg char *            *)
  CONST aBoopsiMaxHeight            * = 8042757FH; (* isg ULONG             *)
  CONST aBoopsiMaxWidth             * = 8042BCB1H; (* isg ULONG             *)
  CONST aBoopsiMinHeight            * = 80422C93H; (* isg ULONG             *)
  CONST aBoopsiMinWidth             * = 80428FB2H; (* isg ULONG             *)
  CONST aBoopsiObject               * = 80420178H; (* ..g Object *          *)
  CONST aBoopsiRemember             * = 8042F4BDH; (* i.. ULONG             *)
  CONST aBoopsiTagDrawInfo          * = 8042BAE7H; (* isg ULONG             *)
  CONST aBoopsiTagScreen            * = 8042BC71H; (* isg ULONG             *)
  CONST aBoopsiTagWindow            * = 8042E11DH; (* isg ULONG             *)



(****************************************************************************)
(** Colorfield.mui 7.31 (26.01.94)                                         **)
(****************************************************************************)

  cColorfield * = "Colorfield.mui";

(* Attributes *)

  CONST aColorfieldBlue             * = 8042D3B0H; (* isg ULONG             *)
  CONST aColorfieldGreen            * = 80424466H; (* isg ULONG             *)
  CONST aColorfieldPen              * = 8042713AH; (* ..g ULONG             *)
  CONST aColorfieldRed              * = 804279F6H; (* isg ULONG             *)
  CONST aColorfieldRGB              * = 8042677AH; (* isg ULONG *           *)



(****************************************************************************)
(** List.mui 7.22 (28.11.93)                                               **)
(****************************************************************************)

  cList * = "List.mui";

(* Methods *)

  CONST mListClear                 * = 8042AD89H;
  CONST mListExchange              * = 8042468CH;
  CONST mListGetEntry              * = 804280ECH;
  CONST mListInsert                * = 80426C87H;
  CONST mListInsertSingle          * = 804254D5H;
  CONST mListJump                  * = 8042BAABH;
  CONST mListNextSelected          * = 80425F17H;
  CONST mListRedraw                * = 80427993H;
  CONST mListRemove                * = 8042647EH;
  CONST mListSelect                * = 804252D8H;
  CONST mListSort                  * = 80422275H;

(* Attributes *)

  CONST aListActive                 * = 8042391CH; (* isg LONG              *)
  CONST aListAdjustHeight           * = 8042850DH; (* i.. BOOL              *)
  CONST aListAdjustWidth            * = 8042354AH; (* i.. BOOL              *)
  CONST aListCompareHook            * = 80425C14H; (* is. struct Hook *     *)
  CONST aListConstructHook          * = 8042894FH; (* is. struct Hook *     *)
  CONST aListDestructHook           * = 804297CEH; (* is. struct Hook *     *)
  CONST aListDisplayHook            * = 8042B4D5H; (* is. struct Hook *     *)
  CONST aListEntries                * = 80421654H; (* ..g LONG              *)
  CONST aListFirst                  * = 804238D4H; (* ..g LONG              *)
  CONST aListFormat                 * = 80423C0AH; (* isg STRPTR            *)
  CONST aListMultiTestHook          * = 8042C2C6H; (* is. struct Hook *     *)
  CONST aListQuiet                  * = 8042D8C7H; (* .s. BOOL              *)
  CONST aListSourceArray            * = 8042C0A0H; (* i.. APTR              *)
  CONST aListTitle                  * = 80423E66H; (* isg char *            *)
  CONST aListVisible                * = 8042191FH; (* ..g LONG              *)

  CONST vListActiveOff              * = -1;
  CONST vListActiveTop              * = -2;
  CONST vListActiveBottom           * = -3;
  CONST vListActiveUp               * = -4;
  CONST vListActiveDown             * = -5;
  CONST vListActivePageUp           * = -6;
  CONST vListActivePageDown         * = -7;
  CONST vListConstructHookString    * = -1;
  CONST vListDestructHookString     * = -1;


(****************************************************************************)
(** Floattext.mui 7.32 (26.01.94)                                          **)
(****************************************************************************)

  cFloattext * = "Floattext.mui";

(* Attributes *)

  CONST aFloattextJustify           * = 8042DC03H; (* isg BOOL              *)
  CONST aFloattextSkipChars         * = 80425C7DH; (* is. STRPTR            *)
  CONST aFloattextTabSize           * = 80427D17H; (* is. LONG              *)
  CONST aFloattextText              * = 8042D16AH; (* isg STRPTR            *)



(****************************************************************************)
(** Volumelist.mui 7.31 (26.01.94)                                         **)
(****************************************************************************)

  cVolumelist * = "Volumelist.mui";


(****************************************************************************)
(** Scrmodelist.mui 7.34 (26.01.94)                                        **)
(****************************************************************************)

  cScrmodelist * = "Scrmodelist.mui";

(* Attributes *)




(****************************************************************************)
(** Dirlist.mui 7.31 (26.01.94)                                            **)
(****************************************************************************)

  cDirlist * = "Dirlist.mui";

(* Methods *)

  CONST mDirlistReRead             * = 80422D71H;

(* Attributes *)

  CONST aDirlistAcceptPattern       * = 8042760AH; (* is. STRPTR            *)
  CONST aDirlistDirectory           * = 8042EA41H; (* is. STRPTR            *)
  CONST aDirlistDrawersOnly         * = 8042B379H; (* is. BOOL              *)
  CONST aDirlistFilesOnly           * = 8042896AH; (* is. BOOL              *)
  CONST aDirlistFilterDrawers       * = 80424AD2H; (* is. BOOL              *)
  CONST aDirlistFilterHook          * = 8042AE19H; (* is. struct Hook *     *)
  CONST aDirlistMultiSelDirs        * = 80428653H; (* is. BOOL              *)
  CONST aDirlistNumBytes            * = 80429E26H; (* ..g LONG              *)
  CONST aDirlistNumDrawers          * = 80429CB8H; (* ..g LONG              *)
  CONST aDirlistNumFiles            * = 8042A6F0H; (* ..g LONG              *)
  CONST aDirlistPath                * = 80426176H; (* ..g STRPTR            *)
  CONST aDirlistRejectIcons         * = 80424808H; (* is. BOOL              *)
  CONST aDirlistRejectPattern       * = 804259C7H; (* is. STRPTR            *)
  CONST aDirlistSortDirs            * = 8042BBB9H; (* is. LONG              *)
  CONST aDirlistSortHighLow         * = 80421896H; (* is. BOOL              *)
  CONST aDirlistSortType            * = 804228BCH; (* is. LONG              *)
  CONST aDirlistStatus              * = 804240DEH; (* ..g LONG              *)

  CONST vDirlistSortDirsFirst       * = 0;
  CONST vDirlistSortDirsLast        * = 1;
  CONST vDirlistSortDirsMix         * = 2;
  CONST vDirlistSortTypeName        * = 0;
  CONST vDirlistSortTypeDate        * = 1;
  CONST vDirlistSortTypeSize        * = 2;
  CONST vDirlistStatusInvalid       * = 0;
  CONST vDirlistStatusReading       * = 1;
  CONST vDirlistStatusValid         * = 2;


(****************************************************************************)
(** Group.mui 7.12 (28.11.93)                                              **)
(****************************************************************************)

  cGroup * = "Group.mui";

(* Methods *)


(* Attributes *)

  CONST aGroupActivePage            * = 80424199H; (* isg LONG              *)
  CONST aGroupChild                 * = 804226E6H; (* i.. Object *          *)
  CONST aGroupColumns               * = 8042F416H; (* is. LONG              *)
  CONST aGroupHoriz                 * = 8042536BH; (* i.. BOOL              *)
  CONST aGroupHorizSpacing          * = 8042C651H; (* is. LONG              *)
  CONST aGroupPageMode              * = 80421A5FH; (* is. BOOL              *)
  CONST aGroupRows                  * = 8042B68FH; (* is. LONG              *)
  CONST aGroupSameHeight            * = 8042037EH; (* i.. BOOL              *)
  CONST aGroupSameSize              * = 80420860H; (* i.. BOOL              *)
  CONST aGroupSameWidth             * = 8042B3ECH; (* i.. BOOL              *)
  CONST aGroupSpacing               * = 8042866DH; (* is. LONG              *)
  CONST aGroupVertSpacing           * = 8042E1BFH; (* is. LONG              *)



(****************************************************************************)
(** Virtgroup.mui 7.31 (26.01.94)                                          **)
(****************************************************************************)

  cVirtgroup * = "Virtgroup.mui";

(* Methods *)


(* Attributes *)

  CONST aVirtgroupHeight            * = 80423038H; (* ..g LONG              *)
  CONST aVirtgroupLeft              * = 80429371H; (* isg LONG              *)
  CONST aVirtgroupTop               * = 80425200H; (* isg LONG              *)
  CONST aVirtgroupWidth             * = 80427C49H; (* ..g LONG              *)



(****************************************************************************)
(** Scrollgroup.mui 7.29 (26.01.94)                                        **)
(****************************************************************************)

  cScrollgroup * = "Scrollgroup.mui";

(* Attributes *)

  CONST aScrollgroupContents        * = 80421261H; (* i.. Object *          *)



(****************************************************************************)
(** Scrollbar.mui 7.12 (28.11.93)                                          **)
(****************************************************************************)

  cScrollbar * = "Scrollbar.mui";


(****************************************************************************)
(** Listview.mui 7.13 (28.11.93)                                           **)
(****************************************************************************)

  cListview * = "Listview.mui";

(* Attributes *)

  CONST aListviewClickColumn        * = 8042D1B3H; (* ..g LONG              *)
  CONST aListviewDefClickColumn     * = 8042B296H; (* isg LONG              *)
  CONST aListviewDoubleClick        * = 80424635H; (* i.g BOOL              *)
  CONST aListviewInput              * = 8042682DH; (* i.. BOOL              *)
  CONST aListviewList               * = 8042BCCEH; (* i.. Object *          *)
  CONST aListviewMultiSelect        * = 80427E08H; (* i.. LONG              *)
  CONST aListviewSelectChange       * = 8042178FH; (* ..g BOOL              *)

  CONST vListviewMultiSelectNone    * = 0;
  CONST vListviewMultiSelectDefault * = 1;
  CONST vListviewMultiSelectShifted * = 2;
  CONST vListviewMultiSelectAlways  * = 3;


(****************************************************************************)
(** Radio.mui 7.12 (28.11.93)                                              **)
(****************************************************************************)

  cRadio * = "Radio.mui";

(* Attributes *)

  CONST aRadioActive                * = 80429B41H; (* isg LONG              *)
  CONST aRadioEntries               * = 8042B6A1H; (* i.. STRPTR *          *)



(****************************************************************************)
(** Cycle.mui 7.16 (28.11.93)                                              **)
(****************************************************************************)

  cCycle * = "Cycle.mui";

(* Attributes *)

  CONST aCycleActive                * = 80421788H; (* isg LONG              *)
  CONST aCycleEntries               * = 80420629H; (* i.. STRPTR *          *)

  CONST vCycleActiveNext            * = -1;
  CONST vCycleActivePrev            * = -2;


(****************************************************************************)
(** Slider.mui 7.12 (28.11.93)                                             **)
(****************************************************************************)

  cSlider * = "Slider.mui";

(* Attributes *)

  CONST aSliderLevel                * = 8042AE3AH; (* isg LONG              *)
  CONST aSliderMax                  * = 8042D78AH; (* i.. LONG              *)
  CONST aSliderMin                  * = 8042E404H; (* i.. LONG              *)
  CONST aSliderQuiet                * = 80420B26H; (* i.. BOOL              *)
  CONST aSliderReverse              * = 8042F2A0H; (* isg BOOL              *)



(****************************************************************************)
(** Coloradjust.mui 7.34 (26.01.94)                                        **)
(****************************************************************************)

  cColoradjust * = "Coloradjust.mui";

(* Attributes *)

  CONST aColoradjustBlue            * = 8042B8A3H; (* isg ULONG             *)
  CONST aColoradjustGreen           * = 804285ABH; (* isg ULONG             *)
  CONST aColoradjustModeID          * = 8042EC59H; (* isg ULONG             *)
  CONST aColoradjustRed             * = 80420EAAH; (* isg ULONG             *)
  CONST aColoradjustRGB             * = 8042F899H; (* isg ULONG *           *)



(****************************************************************************)
(** Palette.mui 7.30 (26.01.94)                                            **)
(****************************************************************************)

  cPalette * = "Palette.mui";

(* Attributes *)

  CONST aPaletteEntries             * = 8042A3D8H; (* i.g struct MUI_Palette_Entry * *)
  CONST aPaletteGroupable           * = 80423E67H; (* isg BOOL              *)
  CONST aPaletteNames               * = 8042C3A2H; (* isg char **           *)



(****************************************************************************)
(** Stdpalette.mui 7.32 (26.01.94)                                         **)
(****************************************************************************)

  cStdpalette * = "Stdpalette.mui";

(* Attributes *)

  CONST aStdpaletteActive           * = 8042BBF0H; (* isg ULONG *           *)
  CONST aStdpaletteCount            * = 8042D7F8H; (* i.g LONG              *)
  CONST aStdpaletteRGB              * = 804214A5H; (* i.g ULONG *           *)



(****************************************************************************)
(** Popstring.mui 7.19 (02.12.93)                                          **)
(****************************************************************************)

  cPopstring * = "Popstring.mui";

(* Methods *)

  CONST mPopstringClose            * = 8042DC52H;
  CONST mPopstringOpen             * = 804258BAH;

(* Attributes *)

  CONST aPopstringButton            * = 8042D0B9H; (* i.g Object *          *)
  CONST aPopstringCloseHook         * = 804256BFH; (* isg struct Hook *     *)
  CONST aPopstringOpenHook          * = 80429D00H; (* isg struct Hook *     *)
  CONST aPopstringString            * = 804239EAH; (* i.g Object *          *)
  CONST aPopstringToggle            * = 80422B7AH; (* isg BOOL              *)



(****************************************************************************)
(** Popobject.mui 7.18 (02.12.93)                                          **)
(****************************************************************************)

  cPopobject * = "Popobject.mui";

(* Attributes *)

  CONST aPopobjectFollow            * = 80424CB5H; (* isg BOOL              *)
  CONST aPopobjectLight             * = 8042A5A3H; (* isg BOOL              *)
  CONST aPopobjectObject            * = 804293E3H; (* i.g Object *          *)
  CONST aPopobjectObjStrHook        * = 8042DB44H; (* isg struct Hook *     *)
  CONST aPopobjectStrObjHook        * = 8042FBE1H; (* isg struct Hook *     *)
  CONST aPopobjectVolatile          * = 804252ECH; (* isg BOOL              *)



(****************************************************************************)
(** Popasl.mui 7.5 (03.12.93)                                              **)
(****************************************************************************)

  cPopasl * = "Popasl.mui";

(* Attributes *)

  CONST aPopaslActive               * = 80421B37H; (* ..g BOOL              *)
  CONST aPopaslStartHook            * = 8042B703H; (* isg struct Hook *     *)
  CONST aPopaslStopHook             * = 8042D8D2H; (* isg struct Hook *     *)
  CONST aPopaslType                 * = 8042DF3DH; (* i.g ULONG             *)



(***************************************************************************
** Parameter structures for some classes
***************************************************************************)

TYPE
  PaletteEntryPtr * = POINTER TO PaletteEntry;
  RenderInfoPtr * = POINTER TO RenderInfo;
  ScrmodelistEntryPtr * = POINTER TO ScrmodelistEntry;
  NotifyDataPtr * = POINTER TO NotifyData;
  MinMaxPtr * = POINTER TO MinMax;
  AreaDataPtr * = POINTER TO AreaData;
  GlobalInfoPtr * = POINTER TO GlobalInfo;


  PaletteEntry * = STRUCT;
                     id    * : LONGINT;
                     red   * : LONGINT;
                     green * : LONGINT;
                     blue  * : LONGINT;
                     group * : LONGINT;;
                   END;


CONST vPaletteEntryEnd = -1;


TYPE
  ScrmodelistEntry * = STRUCT;
                         name   * : Exec.STRPTR;
                         modeID * : LONGINT;
                       END;

(*************************************************************************
** Structures and Macros for creating custom classes.
*************************************************************************)


(*
** GENERAL NOTES:
**
** - Everything described in this header file is only valid within
**   MUI classes. You may never use any of these things out of
**   a class, e.g. in a traditional MUI application.
**
** - Except when otherwise stated, all structures are strictly read only.
*)


(* Instance data of notify class *)

TYPE
  NotifyData * = STRUCT
                   globalInfo * : GlobalInfoPtr;
                   userData   * : LONGINT;
                   priv0      * : LONGINT;
                   priv1      * : LONGINT;
                   priv2      * : LONGINT;
                   priv3      * : LONGINT;
                   priv4      * : LONGINT;
                 END;


(* MUI_MinMax structure holds information about minimum, maximum
   and default dimensions of an object. *)

  MinMax * = STRUCT
               minWidth  * : INTEGER;
               minHeight * : INTEGER;
               maxWidth  * : INTEGER;
               maxHeight * : INTEGER;
               defWidth  * : INTEGER;
               defHeight * : INTEGER;
             END;

CONST maxmax  * = 10000; (* use this if a dimension is not limited. *)


(* (partial) instance data of area class *)

TYPE
  AreaData * = STRUCT
                renderInfo * : RenderInfoPtr;         (* RenderInfo for this object *)
                priv0        : Exec.APTR;             (* !!! private data !!! *)
                font       * : Graphics.TextFontPtr;  (* Font *)
                minMax     * : MinMax;             (* min/max/default sizes *)
                box        * : Intuition.IBox;        (* position and dimension *)
                addleft    * : SHORTINT;              (* frame & innerspacing left offset *)
                addtop     * : SHORTINT;              (* frame & innerspacing top offset  *)
                subwidth   * : SHORTINT;              (* frame & innerspacing add. width  *)
                subheight  * : SHORTINT;              (* frame & innerspacing add. height *)
                flags      * : LONGSET;               (* see definitions below *)
                (* ... private data follows ... *)
              END;

(* Definitions for AreaData.flags *)

CONST
  adfDrawobject * = 0; (* completely redraw yourself *)
  adfDrawupdate * = 1; (* only update yourself *)


(* Global information about parent application. *)

TYPE
  GlobalInfo * = STRUCT;
                   priv0             : Exec.APTR; (* !!! private data !!! *)
                   applicationObject * : Object;

                   (* ... private data follows ... *)
                 END;

(* MUI's draw pens *)

CONST
  penShine      *= 0;
  penHalfshine  *= 1;
  penBackground *= 2;
  penHalfshadow *= 3;
  penShadow     *= 4;
  penText       *= 5;
  penFill       *= 6;
  penCount      *= 7;

TYPE

  PenPtr * = POINTER TO ARRAY penCount OF INTEGER;

(* Information on display environment *)

  RenderInfo * = STRUCT;
                   windowObject  * : Object;              (* valid between MUIM_Setup/MUIM_Cleanup *)
                   screen        * : Intuition.ScreenPtr; (* valid between MUIM_Setup/MUIM_Cleanup *)
                   drawInfo      * : Intuition.DrawInfoPtr;  (* valid between MUIM_Setup/MUIM_Cleanup *)
                   pens          * : PenPtr;              (* valid between MUIM_Setup/MUIM_Cleanup *)
                   window        * : Intuition.WindowPtr; (* valid between MUIM_Show/MUIM_Hide *)
                   rastPort      * : Graphics.RastPortPtr;    (* valid between MUIM_Show/MUIM_Hide *)
                   (* ... private data follows ...*)
                 END;


(* the following macros can be used to get pointers to an objects
   GlobalInfo and RenderInfo structures. *)

  dummyXFC2 = POINTER TO STRUCT;
                            mnd : NotifyData;
                            mad : AreaData;
                          END;

  PROCEDURE GetNotifyData*( obj : Object ):NotifyDataPtr;
    VAR d : dummyXFC2;
    BEGIN
      d:= SYSTEM.VAL( dummyXFC2, obj );
      RETURN SYSTEM.VAL( NotifyDataPtr,SYSTEM.ADR( d.mnd  ) );
    END GetNotifyData;

  PROCEDURE GetAreaData*( obj : Object ):AreaDataPtr;
    VAR d : dummyXFC2;
    BEGIN
      d:= SYSTEM.VAL( dummyXFC2, obj );
      RETURN SYSTEM.VAL( AreaDataPtr,SYSTEM.ADR( d.mad  ) );
    END GetAreaData;

  PROCEDURE GetGlobalInfo*( obj : Object ):GlobalInfoPtr;
    BEGIN
      RETURN SYSTEM.VAL( dummyXFC2, obj ).mnd.globalInfo;
    END GetGlobalInfo;

  PROCEDURE GetRenderInfo*( obj : Object ):RenderInfoPtr;
    BEGIN
      RETURN SYSTEM.VAL( dummyXFC2, obj ).mad.renderInfo;
    END GetRenderInfo;


(* User configurable keyboard events coming with MUIM_HandleInput *)
(* User configurable keyboard events coming with MUIM_HandleInput *)

CONST
  keyRelease     *= -2; (* not a real key, faked when wenn keyPress is released *)
  keyNone        *= -1;
  keyPress       *= 0;
  keyToggle      *= 1;
  keyUp          *= 2;
  keyDown        *= 3;
  keyPageUp      *= 4;
  keyPageDown    *= 5;
  keyTop         *= 6;
  keyBottom      *= 7;
  keyLeft        *= 8;
  keyRight       *= 9;
  keyWordLeft    *= 10;
  keyWordRight   *= 11;
  keyLineStart   *= 12;
  keyLineEnd     *= 13;
  keyGadgetNext  *= 14;
  keyGadgetPrev  *= 15;
  keyGadgetOff   *= 16;
  keyWindowClose *= 17;
  keyWindowNext  *= 18;
  keyWindowPrev  *= 19;
  keyHelp        *= 20;

(* Some useful shortcuts. define MUI_NOSHORTCUTS to get rid of them *)

  PROCEDURE app*( obj : Object ):Object;
    BEGIN RETURN GetGlobalInfo( obj ).applicationObject END app;

  PROCEDURE win*( obj : Object ):Object;
    BEGIN RETURN GetRenderInfo( obj ).windowObject END win;

  PROCEDURE dri*( obj : Object ):Intuition.DrawInfoPtr;
    BEGIN RETURN GetRenderInfo( obj ).drawInfo END dri;

  PROCEDURE window*( obj : Object ):Intuition.WindowPtr;
    BEGIN RETURN GetRenderInfo( obj ).window END window;

  PROCEDURE screen*( obj : Object ):Intuition.ScreenPtr;
    BEGIN RETURN GetRenderInfo( obj ).screen END screen;

  PROCEDURE rp*( obj : Object ):Graphics.RastPortPtr;
    BEGIN RETURN GetRenderInfo( obj ).rastPort END rp;

  PROCEDURE left*( obj : Object ):INTEGER;
    BEGIN RETURN GetAreaData( obj ).box.left END left;

  PROCEDURE top*( obj : Object ):INTEGER;
    BEGIN RETURN GetAreaData( obj ).box.top END top;

  PROCEDURE width*( obj : Object ):INTEGER;
    BEGIN RETURN GetAreaData( obj ).box.width END width;

  PROCEDURE height*( obj : Object ):INTEGER;
    BEGIN RETURN GetAreaData( obj ).box.height END height;

  PROCEDURE right*( obj : Object ):INTEGER;
    BEGIN RETURN  left(obj)+width(obj)-1 END right;

  PROCEDURE bottom*( obj : Object ):INTEGER;
    BEGIN RETURN top(obj)+height(obj)-1 END bottom;

  PROCEDURE addleft*( obj : Object ):SHORTINT;
    BEGIN RETURN GetAreaData(obj).addleft END addleft;

  PROCEDURE addtop*( obj : Object ):SHORTINT;
    BEGIN RETURN GetAreaData(obj).addtop END addtop;

  PROCEDURE subwidth*( obj : Object ):SHORTINT;
    BEGIN RETURN  GetAreaData(obj).subwidth END subwidth;

  PROCEDURE subheight*( obj : Object ):SHORTINT;
    BEGIN RETURN GetAreaData(obj).subheight END subheight;

  PROCEDURE mleft*( obj : Object ):INTEGER;
    BEGIN RETURN ( left(obj)+addleft(obj) ) END mleft;

  PROCEDURE mtop*( obj : Object ):INTEGER;
    BEGIN RETURN ( top(obj)+addtop(obj) ) END mtop;

  PROCEDURE mwidth*( obj : Object ):INTEGER;
    BEGIN RETURN ( width(obj)-subwidth(obj) ) END mwidth;

  PROCEDURE mheight*( obj : Object ):INTEGER;
    BEGIN RETURN ( height(obj)-subheight(obj) ) END mheight;

  PROCEDURE mright*( obj : Object ):INTEGER;
    BEGIN RETURN ( mleft(obj)+mwidth(obj)-1 ) END mright;

  PROCEDURE mbottom*( obj : Object ):INTEGER;
    BEGIN RETURN ( mtop(obj)+mheight(obj)-1 ) END mbottom;

  PROCEDURE font*( obj : Object ):Graphics.TextFontPtr;
    BEGIN RETURN GetAreaData(obj).font END font;

  PROCEDURE flags*( obj : Object ):LONGSET;
    BEGIN RETURN GetAreaData(obj).flags END flags;

(***************************************************************************
**
** For Boopsi Image Implementors Only:
**
** If MUI is using a boopsi image object, it will send a special method
** immediately after object creation. This method has a parameter structure
** where the boopsi can fill in its minimum and maximum size and learn if
** its used in a horizontal or vertical context.
**
** The boopsi image must use the method id (MUIM_BoopsiQuery) as return
** value. That's how MUI sees that the method is implemented.
**
** Note: MUI does not depend on this method. If the boopsi image doesn't
**       implement it, minimum size will be 0 and maximum size unlimited.
**
***************************************************************************)

CONST mBoopsiQuery *= 80427157H;    (* this is send to the boopsi and *)
                                    (* must be used as return value   *)

TYPE pBoopsiQuery  *= STRUCT( msg* : Intuition.Msg ); (* parameter structure *)
                  screen    * : Intuition.ScreenPtr;  (* read only, display context *)
                  flags     * : LONGSET;              (* read only, see below *)

                  minWidth  * : LONGINT;              (* write only, fill in min width  *)
                  minHeight * : LONGINT;              (* write only, fill in min height *)
                  maxWidth  * : LONGINT;              (* write only, fill in max width  *)
                  maxHeight * : LONGINT;              (* write only, fill in max height *)
                  renderInfo * : RenderInfoPtr;       (* read only, display context *)
                  (* ... may grow in future ... *)
                  END;

CONST bqfHoriz *= 0;             (* object used in a horizontal *)
                                 (* context (else vertical)     *)

CONST bqMaxMax *= 10000;         (* use this for unlimited MaxWidth/Height *)



(***************************************************************************
** Method Parameter Structures
**
***************************************************************************)

TYPE

(* Notify *)

  pCallHookPtr * = POINTER TO pCallHook;
  pCallHook * = STRUCT( msg * : Intuition.Msg );
                  hook * : Utility.HookPtr;
                  (* following hookparams *)
                END;

  pMultiSetPtr * = POINTER TO pMultiSet;
  pMultiSet * = STRUCT( msg * : Intuition.Msg );
                       attr * : LONGINT;
                       val  * : LONGINT;
                       obj  * : Object;
                       (* ... *)
                     END;

  pNotifyPtr * = POINTER TO pNotify;
  pNotify * = STRUCT( msg * : Intuition.Msg );
                trigAttr * : LONGINT;
                trigVal  * : LONGINT;
                destObj  * : Object;
                (* FollowingParams *)
              END;

  pSetPtr * = POINTER TO pSet;
  pSet * = STRUCT( msg * : Intuition.Msg );
                  attr * : LONGINT;
                  val  * : LONGINT;
                END;

  pSetAsStringPtr * = POINTER TO pSetAsString;
  pSetAsString * = STRUCT( msg * : Intuition.Msg );
                     attr   * : LONGINT;
                     format * : Exec.STRPTR;
                     val    * : LONGINT;
                     (* ... *)
                   END;

  pWriteLongPtr * = POINTER TO pWriteLong;
  pWriteLong * = STRUCT( msg * : Intuition.Msg );
                   val     * : LONGINT;
                   memory  * : POINTER TO LONGINT;
                 END;

  pWriteStringPtr * = POINTER TO pWriteString;
  pWriteString * = STRUCT( msg * : Intuition.Msg );
                     str     * : Exec.STRPTR;
                     memory  * : Exec.STRPTR;
                   END;

(* Application *)

  pApplicationGetMenuCheckPtr * = POINTER TO pApplicationGetMenuCheck;
  pApplicationGetMenuCheck * = STRUCT( msg * : Intuition.Msg );
                      menuID * : LONGINT;
                    END;

  pApplicationGetMenuStatePtr * = POINTER TO pApplicationGetMenuState;
  pApplicationGetMenuState * = STRUCT( msg * : Intuition.Msg );
                      menuID * : LONGINT;
                    END;

  pApplicationInputPtr * = POINTER TO pApplicationInput;
  pApplicationInput * = STRUCT( msg * : Intuition.Msg );
                          signal * : POINTER TO LONGSET;
                        END;

  pApplicationLoadPtr * = POINTER TO pApplicationLoad;
  pApplicationLoad * = STRUCT( msg * : Intuition.Msg );
                         name * : Exec.STRPTR;
                       END;

  pApplicationPushMethodPtr * = POINTER TO pApplicationPushMethod;
  pApplicationPushMethod * = STRUCT( msg * : Intuition.Msg );
                               dest * : Object;
                               (* following Method *)
                             END;

  pApplicationReturnIDPtr * = POINTER TO pApplicationReturnID;
  pApplicationReturnID * = STRUCT( msg * : Intuition.Msg );
                             retid * : LONGINT;
                           END;

  pApplicationSavePtr * = POINTER TO pApplicationSave;
  pApplicationSave * = STRUCT( msg * : Intuition.Msg );
                         name * : Exec.STRPTR;
                       END;


  pApplicationSetMenuCheckPtr * = POINTER TO pApplicationSetMenuCheck;
  pApplicationSetMenuCheck * = STRUCT( msg * : Intuition.Msg );
                      menuID * : LONGINT;
                      set    * : LONGINT;
                    END;

  pApplicationSetMenuStatePtr * = POINTER TO pApplicationSetMenuState;
  pApplicationSetMenuState * = STRUCT( msg * : Intuition.Msg );
                      menuID * : LONGINT;
                      set    * : LONGINT;
                    END;

  pApplicationShowHelpPtr * = POINTER TO pApplicationShowHelp;
  pApplicationShowHelp * = STRUCT( msg * : Intuition.Msg );
                             window * : Object;
                             name   * : Exec.STRPTR;
                             node   * : Exec.STRPTR;
                             line   * : LONGINT;
                           END;

(* Window *)

  pWindowGetMenuCheckPtr * = POINTER TO pWindowGetMenuCheck;
  pWindowGetMenuCheck * = STRUCT( msg * : Intuition.Msg );
                            menuID * : LONGINT;
                          END;

  pWindowGetMenuStatePtr * = POINTER TO pWindowGetMenuState;
  pWindowGetMenuState * = STRUCT( msg * : Intuition.Msg );
                            menuID * : LONGINT;
                          END;

  pWindowSetCycleChainPtr * = POINTER TO pWindowSetCycleChain;
  pWindowSetCycleChain * = STRUCT( msg * : Intuition.Msg );
                             (* following objects *)
                           END;

  pWindowSetMenuCheckPtr * = POINTER TO pWindowSetMenuCheck;
  pWindowSetMenuCheck * = STRUCT( msg * : Intuition.Msg );
                            menuID * : LONGINT;
                            set    * : LONGINT;
                          END;

  pWindowSetMenuStatePtr * = POINTER TO pWindowSetMenuState;
  pWindowSetMenuState * = STRUCT( msg * : Intuition.Msg );
                            menuID * : LONGINT;
                            set    * : LONGINT;
                          END;

(* Area *)

  pAskMinMaxPtr * = POINTER TO pAskMinMax;
  pAskMinMax * = STRUCT( msg * : Intuition.Msg );
                   minMax * : MinMaxPtr;
                 END;

  pDrawPtr * = POINTER TO pDraw;
  pDraw * = STRUCT( msg * : Intuition.Msg );
              flags * : LONGSET
            END;

  pHandleInputPtr * = POINTER TO pHandleInput;
  pHandleInput * = STRUCT( msg * : Intuition.Msg );
                     imsg   * : Intuition.IntuiMessagePtr;
                     muikey * : LONGINT;
                   END;

  pSetUpPtr * = POINTER TO pSetUp;
  pSetUp * = STRUCT( msg * : Intuition.Msg );
               renderInfo * : RenderInfoPtr;
             END;

(* List *)

  pListExchangePtr * = POINTER TO pListExchange;
  pListExchange * = STRUCT( msg * : Intuition.Msg );
                      pos1 * : LONGINT;
                      pos2 * : LONGINT;
                    END;

  pListGetEntryPtr * = POINTER TO pListGetEntry;
  pListGetEntry * = STRUCT( msg * : Intuition.Msg );
                      pos * : LONGINT;
                      entry * : Exec.APTR
                    END;

  pListInsertPtr * = POINTER TO pListInsert;
  pListInsert * = STRUCT( msg * : Intuition.Msg );
                    entries * : Exec.APTR;
                    count   * : LONGINT;
                    pos     * : LONGINT;
                  END;

  pListInsertSinglePtr * = POINTER TO pListInsertSingle;
  pListInsertSingle * = STRUCT( msg * : Intuition.Msg );
                          entry * : Exec.APTR;
                          pos   * : LONGINT;
                        END;

  pListJumpPtr * = POINTER TO pListJump;
  pListJump * = STRUCT( msg * : Intuition.Msg );
                    pos * : LONGINT;
                  END;

  pListNextSelectedPtr * = POINTER TO pListNextSelected;
  pListNextSelected * = STRUCT( msg * : Intuition.Msg );
                          pos * : POINTER TO LONGINT;
                        END;

  pListRedrawPtr * = POINTER TO pListRedraw;
  pListRedraw * = STRUCT( msg * : Intuition.Msg );
                    pos * : LONGINT;
                  END;

  pListRemovePtr * = POINTER TO pListRemove;
  pListRemove * = STRUCT( msg * : Intuition.Msg );
                    pos * : LONGINT;
                  END;

  pListSelectPtr * = POINTER TO pListSelect;
  pListSelect * = STRUCT( msg * : Intuition.Msg );
                    pos     * : LONGINT;
                    selType * : LONGINT;
                    state   * : POINTER TO LONGINT;
                  END;

(* Popstring *)

  pPopstringClosePtr * = POINTER TO pPopstringClose;
  pPopstringClose *= STRUCT( msg * : Intuition.Msg );
                       result : LONGINT;
                     END;

(***************************************************************************
** Functions in muimaster.library
***************************************************************************)

VAR
  base * : Exec.LibraryPtr;

PROCEDURE NewObjectA           * {base,-30}( class{8}      : ARRAY OF CHAR;
                                             tags{9}       : ARRAY OF Utility.TagItem): Object;

PROCEDURE NewObject            * {base,-30}( class{8}      : ARRAY OF CHAR;
                                             tags{9}..     : Utility.Tag): Object;

PROCEDURE DisposeObject        * {base,-36}( obj{8}        : Object);


PROCEDURE RequestA             * {base,-42}( app{0}        : Object;
                                             win{1}        : Object;
                                             flags{2}      : LONGINT;
                                             title{8}      : ARRAY OF CHAR;
                                             gadgets{9}    : ARRAY OF CHAR;
                                             format{10}    : ARRAY OF CHAR;
                                             params{11}    : ARRAY OF Utility.TagItem) : LONGINT;

PROCEDURE Request              * {base,-42}( app{0}        : Object;
                                             win{1}        : Object;
                                             flags{2}      : LONGINT;
                                             title{8}      : ARRAY OF CHAR;
                                             gadgets{9}    : ARRAY OF CHAR;
                                             format{10}    : ARRAY OF CHAR;
                                             params{11}..  : Utility.Tag) : LONGINT;

PROCEDURE AllocAslRequest      * {base,-48}( typ{0}  : LONGINT;
                                             tags{8} : ARRAY OF Utility.TagItem) : ASL.ASLRequesterPtr;

PROCEDURE AllocAslRequestTags  * {base,-48}( typ{0}    : LONGINT;
                                             tags{8}.. : Utility.Tag) : ASL.ASLRequesterPtr;

PROCEDURE AslRequest           * {base,-54}( req{8}  : ASL.ASLRequesterPtr;
                                             tags{9} : ARRAY OF Utility.TagItem) : BOOLEAN;

PROCEDURE AslRequestTags       * {base,-54}( req{8}    : ASL.ASLRequesterPtr;
                                             tags{9}.. : Utility.Tag) : BOOLEAN;

PROCEDURE FreeAslRequest       * {base,-60}( req{8}  : ASL.ASLRequesterPtr );

PROCEDURE Error                * {base,-66}() : LONGINT;

(* functions to be used with custom classes *)

PROCEDURE SetError             * {base,-72}( num{0} : LONGINT ):LONGINT;

PROCEDURE GetClass             * {base,-78}( classname{8} : ARRAY OF CHAR ):Intuition.IClassPtr;

PROCEDURE FreeClass            * {base,-84}( classptr{8}: Intuition.IClassPtr );

PROCEDURE RequestIDCMP         * {base,-90}( obj{8}:Object; flags{0}:LONGSET );

PROCEDURE RejectIDCMP          * {base,-96}( obj{8}:Object; flags{0}:LONGSET );

PROCEDURE Redraw               * {base,-102}( obj{8}:Object; flags{0}:LONGSET );

PROCEDURE DoMethodA * ( obj{10}, msg{9}: Intuition.Msg ): LONGINT;

BEGIN  (* $EntryExitCode- *)
  SYSTEM.INLINE(  0206AH, 0FFFCH,    (*  movea.l -4(a2),a0    *)
                  02F28H, 00008H,    (*  move.l  8(a0),-(a7)  *)
                  04E75H);           (*  rts                  *)
END DoMethodA;

PROCEDURE DoMethod * {"Mui.DoMethodA"} ( obj{10}: Object; msg{9}..: Exec.APTR );
PROCEDURE DOMethod * {"Mui.DoMethodA"} ( obj{10}: Object; msg{9}..: Exec.APTR ) : LONGINT;

BEGIN
  base := Exec.OpenLibrary( LibName, Version);
  IF base=NIL THEN
    IF Intuition.DisplayAlert(0,"\x00\x64\x14missing muimaster.library\o\o",50) THEN END;
    HALT(0)
  END;
CLOSE
  IF base#NIL THEN Exec.CloseLibrary(base) END;
END Mui.
