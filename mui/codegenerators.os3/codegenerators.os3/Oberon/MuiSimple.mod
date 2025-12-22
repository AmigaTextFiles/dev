(*------------------------------------------

  :Module.      MuiSimple.mod
  :Author.      Albert Weinert  [awn]
  :Address.     Adamsstr. 83 , 51063 Köln, Germany
  :EMail.       a.weinert@darkness.gun.de
  :Phone.       +49-221-613100
  :Revision.    R.3
  :Date.        26-Sep-1994
  :Copyright.   Albert Weinert
  :Language.    Oberon-2
  :Translator.  AmigaOberon V3.20
  :Contents.    Contains the object creation on a simple manner (but not so easy)
  :Contents.    This Module is for "GenCodeOberon" which comes with MuiBuilder 2.0.
  :Remarks.     *Don't mix MuiBasics.mod and MuiSimple.mod objects!!* Do that
  :Remarks.     only if you want do dynamic object creation.
  :Bugs.        <Bekannte Fehler>
  :Usage.       <Angaben zur Anwendung>
  :History.     .1     [awn] 02-Jul-1994 : Erstellt
  :History.     .2     [awn] 19-Aug-1994 : Do some work at the Module,
  :History.     .3     [awn] 26-Sep-1994 : Requires now muimaster.library V8
  :History.            Must changed some object creation to work with MakeObject()
  :History.            because MuiBuilder 2.0 use features oft his.

--------------------------------------------*)
MODULE MuiSimple;

IMPORT e * := Exec,
       I * := Intuition,
       m * := Mui,
       u * := Utility,
       y   :=SYSTEM;

TYPE
  Args      * = UNTRACED POINTER TO ArgsDesc;
  ArgsDesc  * = STRUCT END;

  HookDef * = PROCEDURE ( hook : u.HookPtr; object : m.Object; args : Args ):LONGINT;

  PROCEDURE MakeHook* ( VAR hook : u.Hook; entry: HookDef );
    BEGIN
      u.InitHook( y.ADR( hook ), y.VAL( u.HookFunc, entry ) );
    END MakeHook;

(***************************************************************************
** Class Tree
****************************************************************************
**
** rootclass               (BOOPSI's base class)
** +--Notify               (implements notification mechanism)
**    +--Family            (handles multiple children)
**    !  +--Menustrip      (describes a complete menu strip)
**    !  +--Menu           (describes a single menu)
**    !  \--Menuitem       (describes a single menu item)
**    +--Application       (main class for all applications)
**    +--Window            (handles intuition window related topics)
**    +--Area              (base class for all GUI elements)
**       +--Rectangle      (creates (empty) rectangles)
**       +--Image          (creates images)
**       +--Text           (creates some text)
**       +--String         (creates a string gadget)
**       +--Prop           (creates a proportional gadget)
**       +--Gauge          (creates a fule gauge)
**       +--Scale          (creates a percentage scale)
**       +--Boopsi         (interface to BOOPSI gadgets)
**       +--Colorfield     (creates a field with changeable color)
**       +--List           (creates a line-oriented list)
**       !  +--Floattext   (special list with floating text)
**       !  +--Volumelist  (special list with volumes)
**       !  +--Scrmodelist (special list with screen modes)
**       !  \--Dirlist     (special list with files)
**       +--Group          (groups other GUI elements)
**          +--Register    (handles page groups with titles)
**          +--Virtgroup   (handles virtual groups)
**          +--Scrollgroup (handles virtual groups with scrollers)
**          +--Scrollbar   (creates a scrollbar)
**          +--Listview    (creates a listview)
**          +--Radio       (creates radio buttons)
**          +--Cycle       (creates cycle gadgets)
**          +--Slider      (creates slider gadgets)
**          +--Coloradjust (creates some RGB sliders)
**          +--Palette     (creates a complete palette gadget)
**          +--Colorpanel  (creates a panel of colors)
**          +--Popstring   (base class for popups)
**             +--Popobject(popup a MUI object in a window)
**             \--Popasl   (popup an asl requester)
**
**************************************************************)
  PROCEDURE FamilyObject*{"MuiSimple.FamilyObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE FamilyObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cFamily, u.more, tags );
    END FamilyObjectA;

  PROCEDURE MenustripObject*{"MuiSimple.MenustripObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE MenustripObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cMenustrip, u.more, tags );
    END MenustripObjectA;

  PROCEDURE MenuObject*{"MuiSimple.MenuObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE MenuObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cMenu, u.more, tags );
    END MenuObjectA;

  PROCEDURE MenuTObject*{"MuiSimple.MenuTObjectA"} ( name {8}: ARRAY OF CHAR; tags{9}.. : u.Tag):m.Object;
  PROCEDURE MenuTObjectA*( name {8}: e.STRPTR; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cMenu, m.aMenuTitle, name, u.more, tags );
    END MenuTObjectA;

  PROCEDURE MenuitemObject*{"MuiSimple.MenuitemObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE MenuitemObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cMenuitem, u.more, tags );
    END MenuitemObjectA;

  PROCEDURE WindowObject*{"MuiSimple.WindowObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE WindowObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cWindow, u.more, tags );
    END WindowObjectA;

  PROCEDURE ImageObject*{"MuiSimple.ImageObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ImageObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cImage, u.more, tags );
    END ImageObjectA;

  PROCEDURE BitmapObject*{"MuiSimple.BitmapObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE BitmapObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cBitmap, u.more, tags );
    END BitmapObjectA;

  PROCEDURE BodychunkObject*{"MuiSimple.BodychunkObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE BodychunkObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cBodychunk, u.more, tags );
    END BodychunkObjectA;

  PROCEDURE NotifyObject*{"MuiSimple.NotifyObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE NotifyObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cNotify, u.more, tags );
    END NotifyObjectA;

  PROCEDURE ApplicationObject*{"MuiSimple.ApplicationObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ApplicationObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cApplication, u.more, tags );
    END ApplicationObjectA;

  PROCEDURE TextObject*{"MuiSimple.TextObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE TextObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cText, u.more, tags );
    END TextObjectA;

  PROCEDURE RectangleObject*{"MuiSimple.RectangleObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE RectangleObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cRectangle, u.more, tags );
    END RectangleObjectA;

  PROCEDURE ListObject*{"MuiSimple.ListObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ListObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cList, u.more, tags );
    END ListObjectA;

  PROCEDURE PropObject*{"MuiSimple.PropObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE PropObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cProp, u.more, tags );
    END PropObjectA;

  PROCEDURE StringObject*{"MuiSimple.StringObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE StringObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cString, u.more, tags );
    END StringObjectA;

  PROCEDURE ScrollbarObject*{"MuiSimple.ScrollbarObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ScrollbarObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cScrollbar, u.more, tags );
    END ScrollbarObjectA;

  PROCEDURE ListviewObject*{"MuiSimple.ListviewObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ListviewObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cListview, u.more, tags );
    END ListviewObjectA;

  PROCEDURE RadioObject*{"MuiSimple.RadioObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE RadioObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cRadio, u.more, tags );
    END RadioObjectA;

  PROCEDURE VolumelistObject*{"MuiSimple.VolumelistObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE VolumelistObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cVolumelist, u.more, tags );
    END VolumelistObjectA;

  PROCEDURE FloattextObject*{"MuiSimple.FloattextObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE FloattextObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cFloattext, u.more, tags );
    END FloattextObjectA;

  PROCEDURE DirlistObject*{"MuiSimple.DirlistObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE DirlistObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cDirlist, u.more, tags );
    END DirlistObjectA;

  PROCEDURE SliderObject*{"MuiSimple.SliderObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE SliderObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cSlider, u.more, tags );
    END SliderObjectA;

  PROCEDURE CycleObject*{"MuiSimple.CycleObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE CycleObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cCycle, u.more, tags );
    END CycleObjectA;

  PROCEDURE GaugeObject*{"MuiSimple.GaugeObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE GaugeObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cGauge, u.more, tags );
    END GaugeObjectA;

  PROCEDURE ScaleObject*{"MuiSimple.ScaleObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ScaleObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cScale, u.more, tags );
    END ScaleObjectA;

  PROCEDURE BoopsiObject*{"MuiSimple.BoopsiObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE BoopsiObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cBoopsi, u.more, tags );
    END BoopsiObjectA;

  PROCEDURE ColorfieldObject*{"MuiSimple.ColorfieldObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ColorfieldObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cColorfield, u.more, tags );
    END ColorfieldObjectA;

  PROCEDURE ColorpanelObject*{"MuiSimple.ColorpanelObjectA"} ( tags{9}.. : u.Tag):m.Object;
  PROCEDURE ColorpanelObjectA*( tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cColorpanel, u.more, tags );
    END ColorpanelObjectA;

  PROCEDURE ColoradjustObject*{"MuiSimple.ColoradjustObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ColoradjustObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cColoradjust, u.more, tags );
    END ColoradjustObjectA;

 PROCEDURE PaletteObject*{"MuiSimple.PaletteObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE PaletteObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cPalette, u.more, tags );
    END PaletteObjectA;

  PROCEDURE GroupObject*{"MuiSimple.GroupObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE GroupObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cGroup, u.more, tags );
    END GroupObjectA;

  PROCEDURE RegisterObject*{"MuiSimple.RegisterObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE RegisterObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cRegister, u.more, tags );
    END RegisterObjectA;

  PROCEDURE VirtgroupObject*{"MuiSimple.VirtgroupObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE VirtgroupObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cVirtgroup, u.more, tags );
    END VirtgroupObjectA;

  PROCEDURE ScrollgroupObject*{"MuiSimple.ScrollgroupObjectA"} ( tags{9}.. : u.Tag ): m.Object;
  PROCEDURE ScrollgroupObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cScrollgroup, u.more, tags );
    END ScrollgroupObjectA;

  PROCEDURE PopstringObject*{"MuiSimple.PopstringObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE PopstringObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cPopstring, u.more, tags );
    END PopstringObjectA;

  PROCEDURE PopobjectObject*{"MuiSimple.PopobjectObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE PopobjectObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cPopobject, u.more, tags );
    END PopobjectObjectA;

  PROCEDURE PoplistObject*{"MuiSimple.PoplistObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE PoplistObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cPoplist, u.more, tags );
    END PoplistObjectA;

  PROCEDURE PopaslObject*{"MuiSimple.PopaslObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE PopaslObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cPopasl, u.more, tags );
    END PopaslObjectA;

  PROCEDURE ScrmodelistObject*{"MuiSimple.ScrmodelistObjectA"} ( tags{9}.. : u.Tag): m.Object;
  PROCEDURE ScrmodelistObjectA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cScrmodelist, u.more, tags );
    END ScrmodelistObjectA;

  PROCEDURE VGroup*{"MuiSimple.VGroupA"}( tags{9}.. : u.Tag ): m.Object;
  PROCEDURE VGroupA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cGroup, u.more, tags );
    END VGroupA;

  PROCEDURE HGroup*{"MuiSimple.HGroupA"}( tags{9}.. : u.Tag ): m.Object;
  PROCEDURE HGroupA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cGroup, m.aGroupHoriz, e.true, u.more, tags );
    END HGroupA;

  PROCEDURE ColGroup*{"MuiSimple.ColGroupA"} ( cols{3} : LONGINT; tags{9}.. : u.Tag );
  PROCEDURE ColGroupA*( cols{3} : LONGINT; tags{9} : u.TagListPtr  ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cGroup, m.aGroupColumns, cols, u.more, tags );
    END ColGroupA;

  PROCEDURE RowGroup*{"MuiSimple.RowGroupA"}( rows{3} : LONGINT; tags{9}.. : u.Tag  ): m.Object;
  PROCEDURE RowGroupA*( rows{3} : LONGINT; tags{9} : u.TagListPtr  ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cGroup, m.aGroupRows, rows, u.more, tags );
    END RowGroupA;

  PROCEDURE PageGroup*{"MuiSimple.PageGroupA"}( tags{9}.. : u.Tag ): m.Object;
  PROCEDURE PageGroupA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cGroup, m.aGroupPageMode, e.true, u.more, tags );
    END PageGroupA;

  PROCEDURE VGroupV*{"MuiSimple.VGroupVA"}( tags{9}.. : u.Tag ): m.Object;
  PROCEDURE VGroupVA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cVirtgroup, u.more, tags );
    END VGroupVA;

  PROCEDURE HGroupV*{"MuiSimple.HGroupVA"}( tags{9}.. : u.Tag ): m.Object;
  PROCEDURE HGroupVA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cVirtgroup, m.aGroupHoriz, e.true, u.more, tags );
    END HGroupVA;

  PROCEDURE ColGroupV*{"MuiSimple.ColGroupVA"} ( cols{3} : LONGINT; tags{9}.. : u.Tag ): m.Object;
  PROCEDURE ColGroupVA*( cols{3} : LONGINT; tags{9} : u.TagListPtr  ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cVirtgroup, m.aGroupColumns, cols, u.more, tags );
    END ColGroupVA;

  PROCEDURE RowGroupV*{"MuiSimple.RowGroupVA"}( rows{3} : LONGINT; tags{9}.. : u.Tag  ): m.Object;
  PROCEDURE RowGroupVA*( rows{3} : LONGINT; tags{9} : u.TagListPtr  ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cVirtgroup, m.aGroupRows, rows, u.more, tags);
    END RowGroupVA;

  PROCEDURE PageGroupV*{"MuiSimple.PageGroupVA"}( tags{9}.. : u.Tag ): m.Object;
  PROCEDURE PageGroupVA*( tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cVirtgroup, m.aGroupPageMode, e.true, u.more, tags );
    END PageGroupVA;

  PROCEDURE RegisterGroup*{"MuiSimple.RegisterGroupA"}( t{8} : e.APTR; tags{9}.. : u.Tag ): m.Object;
  PROCEDURE RegisterGroupA*( t{8} : e.APTR; tags{9} : u.TagListPtr ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cRegister, m.aRegisterTitles, t, u.more, tags );
    END RegisterGroupA;


(***************************************************************************
**
** Baring Procedures
** ------------------
**
***************************************************************************)

  PROCEDURE HBar*(): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cRectangle,
                          m.aRectangleHBar, e.true,
                          m.aFixHeight, 2,
                          u.done ) ;
    END HBar;

  PROCEDURE VBar*(): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cRectangle,
                          m.aRectangleVBar, e.true,
                          m.aFixWidth, 2,
                          u.done );
    END VBar;

(***************************************************************************
**
** Spacing Procedures
** ------------------
**
***************************************************************************)

  PROCEDURE HVSpace*(): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.NewObject( m.cRectangle, u.done );
    END HVSpace;

(*
 *  PROCEDURE GroupSpacing*( x: LONGINT );
 *  (*  *)
 *    BEGIN (* SaveReg+ *)
 *      TagItem( m.aGroupSpacing, x );
 *    END GroupSpacing;
 *)

  PROCEDURE HSpace*( x : LONGINT ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oHSpace, x );
    END HSpace;

  PROCEDURE VSpace*( x : LONGINT ): m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oVSpace, x );
    END VSpace;


  PROCEDURE HCenterObject*( obj : m.Object ): m.Object;
    VAR spL, spR : m.Object;
    BEGIN (* SaveReg+ *)
      spL := HSpace( 0 );
      spR := HSpace( 0 );
      RETURN HGroup( m.aGroupSpacing, 0,
                     m.aGroupChild, spL,
                     m.aGroupChild, obj,
                     m.aGroupChild, spR,
                     u.end );
    END HCenterObject;

  PROCEDURE VCenterObject*( obj : m.Object ): m.Object;
    VAR spO, spU : m.Object;
    BEGIN (* SaveReg+ *)
      spO := VSpace( 0 );
      spU := VSpace( 0 );
      RETURN VGroup( m.aGroupSpacing,0,
                     m.aGroupChild, spO,
                     m.aGroupChild, obj,
                     m.aGroupChild, spU,
                     u.end );
    END VCenterObject;


(*
 *  PROCEDURE InnerSpacing*( h, v : LONGINT );
 *  (*  *)
 *    BEGIN (* SaveReg+ *)
 *      Tags( m.aInnerLeft   , h,
 *            m.aInnerRight  , h,
 *            m.aInnerTop    , v,
 *            m.aInnerBottom , v,
 *            u.end );
 *    END InnerSpacing;
 *)


(***************************************************************************
**
** String-Object
** -------------
**
** The following procedure creates a simple string gadget.
**
***************************************************************************)

  PROCEDURE String * {"MuiSimple.StringA"} ( contents{8} : ARRAY OF CHAR; maxlen{3} : LONGINT; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE StringA*( contents{8} : e.STRPTR; maxlen{3} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN StringObject( m.aFrame, m.vFrameString,
                           m.aStringMaxLen, maxlen,
                           m.aStringContents, contents,
                           u.more, tags );
    END StringA;

  PROCEDURE KeyString * {"MuiSimple.KeyStringA"} ( contents{8} : ARRAY OF CHAR; maxlen{3} : LONGINT; controlchar{4}: CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyStringA*( contents{8} : e.STRPTR; maxlen{3} : LONGINT; controlchar{4} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN String( contents^, maxlen, m.aControlChar, controlchar, u.more, tags );
    END KeyStringA;

(***************************************************************************
**
** Integer-Object
** --------------
**
** The following procedure creates a simple integer string gadget.
**
***************************************************************************)

  PROCEDURE Integer * {"MuiSimple.IntegerA"} ( contents{0} : LONGINT; maxlen{1} : LONGINT; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE IntegerA*( contents{0} : LONGINT; maxlen{1} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN StringObject( m.aFrame, m.vFrameString,
                           m.aStringMaxLen, maxlen,
                           m.aStringInteger, contents,
                           m.aStringAccept, y.ADR( "0123456789" ),
                           u.more, tags );
    END IntegerA;

  PROCEDURE KeyInteger * {"MuiSimple.KeyIntegerA"} ( contents{0} : LONGINT; maxlen{1} : LONGINT; controlchar{2}: CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyIntegerA*( contents{0} : LONGINT; maxlen{1} : LONGINT; controlchar{2} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN Integer( contents, maxlen, m.aControlChar, controlchar, u.more, tags );
    END KeyIntegerA;

(***************************************************************************
**
** CheckMark-Object
** ----------------
**
** The following procedure creates a checkmark gadget.
**
***************************************************************************)

  PROCEDURE CheckMark * {"MuiSimple.CheckMarkA"}( checked{4} : BOOLEAN; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE CheckMarkA*( checked{4} : e.LONGBOOL; tags{9} : u.TagListPtr ):m.Object;
   BEGIN (* SaveReg+ *)
    RETURN ImageObject( m.aFrame, m.vFrameImageButton,
                        m.aInputMode, m.vInputModeToggle,
                        m.aImageSpec, m.iCheckMark,
                        m.aImageFreeVert, e.true,
                        m.aSelected, checked,
                        m.aBackground, m.iButtonBack,
                        m.aShowSelState, e.false,
                        u.more, tags );
    END CheckMarkA;

  PROCEDURE KeyCheckMark *{"MuiSimple.KeyCheckMarkA"}( checked{4} : BOOLEAN; key{3} : CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyCheckMarkA*( checked{4} : e.LONGBOOL; key{3} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
   BEGIN (* SaveReg+ *)
    RETURN CheckMark( y.VAL(BOOLEAN,SHORT(SHORT(checked))), m.aControlChar, key, u.more, tags );
    END KeyCheckMarkA;


(***************************************************************************
**
** Button-Objects
** --------------
**
** Note: Use small letters for KeyButtons, e.g.
**       KeyButton("Cancel",'c')  and not  KeyButton("Cancel",'C') !!
**
***************************************************************************)

  PROCEDURE Button* {"MuiSimple.ButtonA"} ( label{8} : ARRAY OF CHAR ): m.Object;
  PROCEDURE ButtonA* (label{8} : y.ADDRESS ):m.Object;
    BEGIN
      RETURN m.MakeObject( m.oButton, label );
    END ButtonA;
            
  PROCEDURE SimpleButton * {"MuiSimple.SimpleButtonA"} ( name{8} : ARRAY OF CHAR ):m.Object;
  PROCEDURE SimpleButtonA * ( name{8} : e.STRPTR ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oButton, name );
    END SimpleButtonA;


(***************************************************************************
**
** Cycle-Object
** ------------
**
***************************************************************************)

  PROCEDURE Cycle * {"MuiSimple.CycleA"} ( entries{10} : e.APTR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE CycleA * ( entries{10} : e.APTR; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN CycleObject( m.aCycleEntries, entries, u.more, tags );
    END CycleA;

  PROCEDURE KeyCycle * {"MuiSimple.KeyCycleA"} ( entries{10} : e.APTR; key{4} : CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyCycleA * ( entries{10} : e.APTR; key{4} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN Cycle( entries, m.aControlChar, key, u.more, tags );
    END KeyCycleA;

(***************************************************************************
**
** Radio-Object
** ------------
**
***************************************************************************)

  PROCEDURE Radio * {"MuiSimple.RadioA"} ( name{8} : ARRAY OF CHAR; entries{10} : e.APTR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE RadioA * ( name{8}: e.STRPTR; entries{10} : e.APTR; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN RadioObject( m.aFrame, m.vFrameGroup,
                          m.aFrameTitle, name,
                          m.aRadioEntries, entries,
                          u.more, tags );
    END RadioA;

  PROCEDURE KeyRadio * {"MuiSimple.KeyRadioA"} ( name{8} : ARRAY OF CHAR; entries{10} : e.APTR; key{4} : CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyRadioA * ( name{8}: e.STRPTR; entries{10} : e.APTR; key{4} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN Radio( name^, entries, m.aControlChar, key, u.more, tags );
    END KeyRadioA;

(***************************************************************************
**
** Slider-Object
** -------------
**
***************************************************************************)

  PROCEDURE Slider * {"MuiSimple.SliderA"} ( min{0}, max{1}, level{2} : LONGINT; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE SliderA * ( min{0}, max{1}, level{2} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN SliderObject( m.aSliderMin, min,
                           m.aSliderMax, max,
                           m.aSliderLevel, level,
                           u.more, tags );
    END SliderA;

  PROCEDURE KeySlider * {"MuiSimple.KeySliderA"} ( min{0}, max{1}, level{2} : LONGINT; key{3} : CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeySliderA * ( min{0}, max{1}, level{2}, key{3} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN Slider( min, max, level, m.aControlChar, key, u.more, tags );
    END KeySliderA;

  PROCEDURE VSlider * {"MuiSimple.VSliderA"} ( min{0}, max{1}, level{2} : LONGINT; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE VSliderA * ( min{0}, max{1}, level{2} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN Slider( min, max, level, m.aGroupHoriz, e.false, u.more, tags );
    END VSliderA;

  PROCEDURE KeyVSlider * {"MuiSimple.KeyVSliderA"} ( min{0}, max{1}, level{2} : LONGINT; key{3} : CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyVSliderA * ( min{0}, max{1}, level{2}, key{3} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN VSlider( min,  max, level, m.aControlChar, key, u.more, tags );
    END KeyVSliderA;

(***************************************************************************
**
** Scrollbar-Object
** -------------
**
***************************************************************************)

  PROCEDURE Scrollbar * {"MuiSimple.ScrollbarA"} ( min{0}, max{1}, level{2} : LONGINT; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE ScrollbarA * ( min{0}, max{1}, level{2} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN ScrollbarObject( m.aSliderMin, min,
                              m.aSliderMax, max,
                              m.aSliderLevel, level,
                              m.aGroupHoriz, e.true,
                              u.more, tags );
    END ScrollbarA;

  PROCEDURE KeyScrollbar * {"MuiSimple.KeyScrollbarA"} ( min{0}, max{1}, level{2} : LONGINT; key{3} : CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyScrollbarA * ( min{0}, max{1}, level{2}, key{3} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN Scrollbar( min, max, level, m.aControlChar, key, u.more, tags );
    END KeyScrollbarA;

  PROCEDURE VScrollbar * {"MuiSimple.VScrollbarA"} ( min{0}, max{1}, level{2} : LONGINT; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE VScrollbarA * ( min{0}, max{1}, level{2} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN ScrollbarObject( m.aSliderMin, min,
                              m.aSliderMax, max,
                              m.aSliderLevel, level,
                              u.more, tags );
    END VScrollbarA;

  PROCEDURE KeyVScrollbar * {"MuiSimple.KeyVScrollbarA"} ( min{0}, max{1}, level{2} : LONGINT; key{3} : CHAR; tags{9}.. : u.Tag ):m.Object;
  PROCEDURE KeyVScrollbarA * ( min{0}, max{1}, level{2}, key{3} : LONGINT; tags{9} : u.TagListPtr ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN VScrollbar( min, max, level, m.aControlChar, key, u.more, tags );
    END KeyVScrollbarA;

(***************************************************************************
**
** Button to be used for popup objects
**
***************************************************************************)

  PROCEDURE PopButton* {"MuiSimple.PopButtonA"} ( img{3} : LONGINT ):m.Object;
  PROCEDURE PopButtonA*( img{3} : LONGINT ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oPopButton, img );
    END PopButtonA;

(***************************************************************************
**
** Labeling Objects
** ----------------
**
** Labeling objects, e.g. a group of string gadgets,
**
**   Small: |foo   |
**  Normal: |bar   |
**     Big: |foobar|
**    Huge: |barfoo|
**
** is done using a 2 column group:
**
** ColGroup(2);
**      Child; Label2( "Small:"  );
**    Child; StringObject; end;
**      Child; Label2( "Normal:" );
**    Child; StringObject; end;
**      Child; Label2( "Big:"    );
**    Child; StringObject; end;
**      Child; Label2( "Huge:"   );
**    Child; StringObject; end;
**    end;
**
** Note that we have three versions of the label procedure, depending on
** the frame type of the right hand object:
**
** Label1(): For use with standard frames (e.g. checkmarks).
** Label2(): For use with double high frames (e.g. string gadgets).
** Label() : For use with objects without a frame.
**
** These procedures ensure that your label will look fine even if the
** user of your application configured some strange spacing values.
** If you want to use your own labeling, you'll have to pay attention
** on this topic yourself.
**
***************************************************************************)

  PROCEDURE LLabel* {"MuiSimple.LLabelA"} ( label {8} : ARRAY OF CHAR ):m.Object;
  PROCEDURE LLabelA * ( label{8} : e.STRPTR ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelLeftAligned );
    END LLabelA;

  PROCEDURE LLabel1* {"MuiSimple.LLabel1A"} ( label {8} : ARRAY OF CHAR ):m.Object;
  PROCEDURE LLabel1A * ( label{8} : e.STRPTR ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelSingleFrame+m.oLabelLeftAligned );
    END LLabel1A;

  PROCEDURE LLabel2* {"MuiSimple.LLabel2A"} ( label {8} : ARRAY OF CHAR ):m.Object;
  PROCEDURE LLabel2A * ( label{8} : e.STRPTR ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelDoubleFrame+m.oLabelLeftAligned );
    END LLabel2A;

  PROCEDURE Label* {"MuiSimple.LabelA"} ( label {8} : ARRAY OF CHAR ):m.Object;
  PROCEDURE LabelA * ( label{8} : e.STRPTR ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, 0 );
    END LabelA;

  PROCEDURE Label1* {"MuiSimple.Label1A"} ( label {8} : ARRAY OF CHAR ):m.Object;
  PROCEDURE Label1A * ( label{8} : e.STRPTR ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelSingleFrame );

    END Label1A;

  PROCEDURE Label2* {"MuiSimple.Label2A"} ( label {8} : ARRAY OF CHAR):m.Object;
  PROCEDURE Label2A * ( label{8} : e.STRPTR ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelDoubleFrame );
    END Label2A;

  PROCEDURE KeyLabel*{"MuiSimple.KeyLabelA"} ( label{8} : ARRAY OF CHAR; hichar{3} : CHAR ):m.Object;
  PROCEDURE KeyLabelA * ( label{8} : e.STRPTR; hichar{3} : LONGINT  ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, 0+hichar );
    END KeyLabelA;

  PROCEDURE KeyLabel1*{"MuiSimple.KeyLabel1A"} ( label{8} : ARRAY OF CHAR; hichar{3} : CHAR ):m.Object;
  PROCEDURE KeyLabel1A * ( label{8} : e.STRPTR; hichar{3} : LONGINT ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelSingleFrame+hichar );
    END KeyLabel1A;

  PROCEDURE KeyLabel2*{"MuiSimple.KeyLabel2A"} ( label{8} : ARRAY OF CHAR; hichar{3} : CHAR ):m.Object;
  PROCEDURE KeyLabel2A * ( label{8} : e.STRPTR; hichar{3} : LONGINT ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelDoubleFrame+m.oLabelLeftAligned+hichar );
    END KeyLabel2A;

  PROCEDURE KeyLLabel*{"MuiSimple.KeyLLabelA"} ( label{8} : ARRAY OF CHAR; hichar{3} : CHAR):m.Object;
  PROCEDURE KeyLLabelA * ( label{8} : e.STRPTR; hichar{3} : LONGINT ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, 0+hichar );
    END KeyLLabelA;

  PROCEDURE KeyLLabel1*{"MuiSimple.KeyLLabel1A"} ( label{8} : ARRAY OF CHAR; hichar{3} : CHAR ):m.Object;
  PROCEDURE KeyLLabel1A * ( label{8} : e.STRPTR; hichar{3} : LONGINT ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelSingleFrame+m.oLabelLeftAligned+hichar );
    END KeyLLabel1A;

  PROCEDURE KeyLLabel2*{"MuiSimple.KeyLLabel2A"} ( label{8} : ARRAY OF CHAR; hichar{3} : CHAR ):m.Object;
  PROCEDURE KeyLLabel2A * ( label{8} : e.STRPTR; hichar{3} : LONGINT ):m.Object;
    BEGIN (* SaveReg+ *)
      RETURN m.MakeObject( m.oLabel, label, m.oLabelDoubleFrame+m.oLabelLeftAligned+hichar );
    END KeyLLabel2A;

(***************************************************************************
**
** Controlling Objects
** -------------------
**
** Set() and Get() are two short stubs for BOOPSI GetAttr() and SetAttrs()
** calls:
**
**
**    VAR x : e.STRPTR;
**
**    Set(obj,MUIA_String_Contents, y.ADR("foobar") );
**    Get(obj,MUIA_String_Contents, x);
**
**    Dos.PrintF( "gadget contains '%s'\n" , x );
**
** NNset() sets an attribute without triggering a possible notification.
**
**
***************************************************************************)

  PROCEDURE Set*( obj : m.Object; attr, value : e.APTR );
    BEGIN (* SaveReg+ *)
      IF I.SetAttrs( obj, attr, value, u.end ) = 0 THEN END
    END Set;

  PROCEDURE Get*( obj : m.Object; attr : LONGINT ; VAR store : ARRAY OF e.BYTE );
    BEGIN (* SaveReg+ *)
      IF I.GetAttr( attr, obj, store) = 0 THEN END
    END Get;

  PROCEDURE NNSet( obj : m.Object; attr, value : e.APTR );
    BEGIN (* SaveReg+ *)
      IF I.SetAttrs( obj, m.aNoNotify, e.LTRUE, attr, value, u.end ) = 0 THEN END
    END NNSet;

  PROCEDURE SetMutex * ( obj : m.Object; n : LONGINT );
    BEGIN (* SaveReg+ *)
      Set( obj, m.aRadioActive, n );
    END SetMutex;

  PROCEDURE SetCycle * ( obj : m.Object; n : LONGINT );
    BEGIN (* SaveReg+ *)
      Set( obj, m.aCycleActive, n );
    END SetCycle;

  PROCEDURE SetString * ( obj : m.Object; s : ARRAY OF CHAR );
    BEGIN (* SaveReg+ *)
      Set( obj, m.aStringContents, y.ADR( s ) );
    END SetString;

  PROCEDURE SetCheckmark * ( obj : m.Object; b : BOOLEAN );
    BEGIN (* SaveReg+ *)
      Set( obj, m.aSelected, y.VAL(SHORTINT,b) );
    END SetCheckmark;

  PROCEDURE SetSlider * ( obj : m.Object; l : LONGINT );
    BEGIN (* SaveReg+ *)
      Set( obj, m.aSliderLevel, l );
    END SetSlider;

  PROCEDURE MAKEID*( c1, c2, c3, c4 : CHAR):LONGINT;
    BEGIN (* SaveReg+ *)
      RETURN( y.LSH( ORD(c1), 24 )+
              y.LSH( ORD(c2), 16 )+
              y.LSH( ORD(c3),  8 )+
              ORD(c4) )
    END MAKEID;

BEGIN
  IF m.base.version < 8 THEN HALT( 100 ) END;
END MuiSimple.


