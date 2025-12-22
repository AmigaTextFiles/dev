(*
**          Oberon Source Code For The MUI Demo Program
**          --------------------------------------
**
**               written 1993 by Albert Weinert
**         based on the C Source Code from Stefan Stuntz
**
*)
MODULE MuiDemo;

IMPORT  Mui, mb := MuiBasics, y := SYSTEM, Exec, gt := GadTools, u:=Utility, Dos;

(*
** A little array definition:
*)

TYPE  S48 = ARRAY 48 OF Exec.STRPTR;

CONST
  LVTBrian = S48(
      y.ADR( "Cheer up, Brian. You know what they say." ),
      y.ADR( "Some things in life are bad," ),
      y.ADR( "They can really make you mad." ),
      y.ADR( "Other things just make you swear and curse." ),
      y.ADR( "When you're chewing on life's grissle," ),
      y.ADR( "Don't grumble, give a whistle." ),
      y.ADR( "And this'll help things turn out for the best," ),
      y.ADR( "And..." ),
      y.ADR( "" ),
      y.ADR( "Always look on the bright side of life" ),
      y.ADR( "Always look on the light side of life" ),
      y.ADR( "" ),
      y.ADR( "If life seems jolly rotten," ),
      y.ADR( "There's something you've forgotten," ),
      y.ADR( "And that's to laugh, and smile, and dance, and sing." ),
      y.ADR( "When you're feeling in the dumps," ),
      y.ADR( "Don't be silly chumps," ),
      y.ADR( "Just purse your lips and whistle, that's the thing." ),
      y.ADR( "And..." ),
      y.ADR( "" ),
      y.ADR( "Always look on the bright side of life, come on!" ),
      y.ADR( "Always look on the right side of life" ),
      y.ADR( "" ),
      y.ADR( "For life is quite absurd," ),
      y.ADR( "And death's the final word." ),
      y.ADR( "You must always face the curtain with a bow." ),
      y.ADR( "Forget about your sin," ),
      y.ADR( "Give the audience a grin." ),
      y.ADR( "Enjoy it, it's your last chance anyhow," ),
      y.ADR( "So..." ),
      y.ADR( "" ),
      y.ADR( "Always look on the bright side of death" ),
      y.ADR( "Just before you draw your terminal breath." ),
      y.ADR( "" ),
      y.ADR( "Life's a piece of shit," ),
      y.ADR( "When you look at it." ),
      y.ADR( "Life's a laugh, and death's a joke, it's true." ),
      y.ADR( "You'll see it's all a show," ),
      y.ADR( "Keep 'em laughing as you go," ),
      y.ADR( "Just remember that the last laugh is on you." ),
      y.ADR( "And..." ),
      y.ADR( "" ),
      y.ADR( "Always look on the bright side of life !" ),
      y.ADR( "" ),
      y.ADR( "..." ),
      y.ADR( "" ),
      y.ADR( "[Thanx to sprooney@unix1.tcd.ie and to M. Python]" ),
      NIL );




(*
** Convetional GadTools NewMenu structures. Since I was
** too lazy to construct my own object oriented menu
** system for now, this is the only part of MUI that needs
** "gadtools.library". Well, GadTools menus aren't that bad.
** Nevertheless, object oriented menus will come soon.
*)

CONST
  IDABOUT  = 1;
  IDNEWVOL = 2;
  IDNEWBRI = 3;

TYPE  Menu5 = ARRAY 5 OF gt.NewMenu;

CONST
  Menu = Menu5(
        gt.title, y.ADR( "Project" )  , NIL , {}, LONGSET{}, 0 ,
        gt.item , y.ADR( "About..." ) , y.ADR( "?" ), {}, LONGSET{}, IDABOUT ,
        gt.item , gt.barLabel         , NIL , {}, LONGSET{}, 0 ,
        gt.item , y.ADR( "Quit" )     , y.ADR( "Q" ), {}, LONGSET{}, Mui.vApplicationReturnIDQuit,
        0, NIL, NIL, {}, LONGSET{} , 0 );

(*
** Here are all the little info texts
** that appear at the top of each demo window.
*)

CONST

  INMaster    = "\tWelcome to the MUI demonstration program. This little toy will show you how easy it is to create graphical user interfaces with MUI and how powerful the results are.\n\tMUI is based on BOOPSI, Amiga's basic object oriented programming system. For details about programming, see the 'ReadMe' file and the documented source code of this demo. Only one thing so far: it's really easy!\n\tNow go on, click around and watch this demo. Or use your keyboard (TAB, Return, Cursor-Keys) if you like that better. Hint: play around with the MUI preferences program and customize every pixel to fit your personal taste.";
  INNotify    = "\tMUI objects communicate with each other with the aid of a broadcasting system. This system is frequently used in every MUI application. Binding an up and a down arrow to a prop gadget e.g. makes up a scrollbar, binding a scrollbar to a list makes up a listview. You can also bind windows to buttons, thus the window will be opened when the button is pressed.\n\tRemember: The main loop of this demo program simply consists of a Wait(). Once set up, MUI handles all user actions concerning the GUI automatically.";
  INFrames    = "\tEvery MUI object can have a surrounding frame. Several types are available, all adjustable with the preferences program.";
  INImages    = "\tMUI offers a vector image class, that allows images to be zoomed to any dimension. Every MUI image is transformed to match the current screens colors before displaying.\n\tThere are several standard images for often used GUI components (e.g. Arrows). These standard images can be defined via the preferences program.";
  INGroups    = "\tGroups are very important for MUI. Their combinations determine how the GUI will look. A group may contain any number of child objects, which are positioned either horizontal or vertical.\n\tWhen a group is layouted, the available space is distributed between all of its children, depending on their minimum and maximum dimensions and on their weight.\n\tOf course, the children of a group may be other groups. There are no restrictions.";
  INBackfill  = "\tEvery object can have his own background, if it wants to. MUI offers several standard backgrounds (e.g. one of the DrawInfo pens or one of the rasters below).\nThe prefs program allows defining a large number of backgrounds... try it!";
  INListviews = "\tMUI's list class is very flexible. A list can be made up of any number of columns containing formatted text or even images. Several subclasses of list class (e.g. a directory class and a volume class) are available. All MUI lists have the capability of multi selection, just by setting a single flag.\n\tThe small info texts at the top of each demo window are made with floattext class. This one just needs a character string as input and formats the text according to its width.";
  INCycle     = "\tCycle gadgets, radios buttons and simple lists can be used to let the user pick exactly one selection from a list of choices. In this example, all three possibilities are shown. Of course they are connected via broadcasting, so every object will immediately be notified and updated when necessary.";
  INString    = "\tOf course, MUI offers a standard string gadget class for text input. The gadget in this example is attached to the list, you can control the list cursor from within the gadget.";


(*
** This are the entries for the cycle gadgets and radio buttons.
*)
TYPE
  S10 = ARRAY 10 OF Exec.STRPTR;
  S4 = ARRAY 4 OF Exec.STRPTR;
  S5 = ARRAY 5 OF Exec.STRPTR;
CONST
  CYAComputer = S10( y.ADR("Amiga 500"),
                     y.ADR("Amiga 600"),
                     y.ADR("Amiga 1000 :)"),
                     y.ADR("Amiga 1200"),
                     y.ADR("Amiga 2000"),
                     y.ADR("Amiga 3000"),
                     y.ADR("Amiga 4000"),
                     y.ADR("Amiga 4000T"),
                     y.ADR("Atari ST :("),
                     NIL );

  CYAPrinter  =S4( y.ADR("HP Deskjet"),
                   y.ADR("NEC P6"),
                   y.ADR("Okimate 20"),
                   NIL );

  CYADisplay  = S5( y.ADR("A1081"),
                    y.ADR("NEC 3D"),
                    y.ADR("A2024"),
                    y.ADR("Eizo T660i"),
                    NIL);


(*
** Some Macros to make my life easier and the actual source
** code more readable.
*)

  PROCEDURE List( ftxt : Exec.STRPTR );
    BEGIN
      mb.ListviewObject(  Mui.aWeight, 50,
                           Mui.aListviewInput, Exec.false,
                           u.end );
          mb.Tag( Mui.aListviewList );
          mb.FloattextObject( Mui.aFrame, Mui.vFrameReadList,
                               Mui.aFloattextText, ftxt,
                               Mui.aFloattextTabSize, 4,
                               Mui.aFloattextJustify, Exec.true, u.end );
          mb.end;
      mb.end;
    END List;

  PROCEDURE DemoWindow(name : ARRAY OF CHAR; id :ARRAY 4 OF CHAR; info : ARRAY OF CHAR);
  (* $CopyArrays- *)
    BEGIN
      mb.WindowObject( Mui.aWindowTitle, y.ADR( name ),
                        Mui.aWindowID, y.VAL(LONGINT, id),
                        u.end );
          mb.WindowContents;
          mb.VGroup;
              mb.Child; List(y.ADR( info ) );
    END DemoWindow;

   PROCEDURE ImageLine(name : ARRAY OF CHAR; nr : LONGINT);
     BEGIN
       mb.HGroup;
           mb.Child; mb.TextObject( Mui.aTextContents, y.ADR(name),
                                      Mui.aTextPreParse, y.ADR("\033r"),
                                      Mui.aFixWidthTxt, y.ADR("RadioButton:"),
                                      u.end);
                      mb.end;
           mb.Child; mb.VGroup;
                          mb.Child; mb.VSpace(0);
                          mb.Child; mb.ImageObject( Mui.aImageSpec, nr, u.end ); mb.end;
                          mb.Child; mb.VSpace(0);
                      mb.end;
       mb.end;
     END ImageLine;

  PROCEDURE ScaledImage(nr : LONGINT; s : BOOLEAN; w,h : LONGINT);
    VAR state : LONGINT;
    BEGIN
      state := LONG(LONG(y.VAL(SHORTINT,s)));
      mb.ImageObject( Mui.aImageSpec, nr,
                       Mui.aFixWidth, w,
                       Mui.aFixHeight, h,
                       Mui.aImageFreeHoriz, Exec.true,
                       Mui.aImageFreeVert, Exec.true,
                       Mui.aImageState, state, u.end );
      mb.end;
    END ScaledImage;

  PROCEDURE HProp():Mui.Object;
    BEGIN
       mb.PropObject;
          mb.PropFrame;
          mb.Tags( Mui.aPropHoriz, Exec.true,
                   Mui.aFixHeight, 8,
                   Mui.aPropEntries, 111,
                   Mui.aPropVisible, 10, u.end );
       RETURN mb.End()
    END HProp;

  PROCEDURE VProp():Mui.Object;
    BEGIN
      mb.PropObject;
         mb.PropFrame;
         mb.Tags( Mui.aPropHoriz, Exec.false,
                  Mui.aFixWidth , 8,
                  Mui.aPropEntries, 111,
                  Mui.aPropVisible, 10, u.end );
      RETURN mb.End();
    END VProp;


  PROCEDURE fail( obj: Mui.Object; s: ARRAY OF CHAR );
    BEGIN
      IF obj # NIL THEN Mui.DisposeObject( obj ); END;
      IF Dos.PutStr( s ) = 0 THEN END;
      HALT( 20 );
    END fail;
(*
** For every object we want to refer later (e.g. for broadcasting purposes)
** we need a pointer. These pointers do not need to be static, but this
** saves stack space.
*)

VAR
  APDemo,
  WIMaster,WIFrames,WIImages,WINotify,WIListviews,WIGroups,WIBackfill,WICycle,WIString,
  BTNotify,BTFrames,BTImages,BTGroups,BTBackfill,BTListviews,BTCycle,BTString,BTQuit,
  PRPropA,PRPropH,PRPropV,PRPropL,PRPropR,PRPropT,PRPropB,
  LVVolumes,LVDirectory,LVComputer,LVBrian,
  CYComputer,CYPrinter,CYDisplay,
  MTComputer,MTPrinter,MTDisplay,
  STBrian,
  GAGauge1,GAGauge2,GAGauge3,
  BPWheel : Mui.Object;

  signal : LONGSET;
  running : BOOLEAN;
  buf : Exec.STRPTR;
  pos : LONGINT;
  ding : POINTER TO LONGINT;
(*
** This is where it all begins...
*)

BEGIN

(*
** Every MUI application needs an application object
** which will hold general information and serve as
** a kind of anchor for user input, ARexx functions,
** commodities interface, etc.
**
** An application may have any number of Mui.SubWindows
** which can all be created in the same call or added
** later, according to your needs.
**
** Note that creating a window does not mean to
** open it, this will be done later by setting
** the windows open attribute.
*)

  mb.ApplicationObject( Mui.aApplicationTitle         , y.ADR("Oberon MUI-Demo"),
                        Mui.aApplicationVersion       , y.ADR("$VER: Oberon MUI-Demo 1.0 (25.8.93)"),
                        Mui.aApplicationCopyright     , y.ADR("Copyright ©1993, Stefan Stuntz/Albert Weinert"),
                        Mui.aApplicationAuthor        , y.ADR("Stefan Stuntz/Albert Weinert"),
                        Mui.aApplicationDescription   , y.ADR("Demonstrate the features of MUI."),
                        Mui.aApplicationBase          , y.ADR("MUIDEMO"),
                        Mui.aApplicationMenu          , y.ADR(Menu), u.end );
     mb.SubWindow;
          DemoWindow("String","STRG",INString);
                  mb.Child; mb.ListviewObject( Mui.aListviewInput, Exec.true,  u.end );
                                 mb.Tag( Mui.aListviewList ); mb.ListObject; mb.InputListFrame; mb.end;
                             LVBrian := mb.End();
                  mb.Child; mb.StringObject; mb.StringFrame; STBrian:= mb.End();
                  mb.end;
           WIString:=mb.End();

      mb.SubWindow;
          DemoWindow("Cycle Gadgets & RadioButtons",'CYCL',INCycle);
              mb.Child;
              mb.HGroup;
                  mb.Child; MTComputer := mb.Radio("Computer:", y.ADR( CYAComputer  ) );
                  mb.Child; mb.VGroup;
                                 mb.Child; MTPrinter := mb.Radio("Printer:",y.ADR( CYAPrinter) );
                                 mb.Child; mb.VSpace(0);
                                 mb.Child; MTDisplay := mb.Radio("Display:",y.ADR( CYADisplay) );
                             mb.end;
                  mb.Child; mb.VGroup;
                          mb.Child; mb.ColGroup(2); mb.GroupFrameT( "Cycle Gadgets" );
                                  mb.Child; mb.label1("Computer:"); mb.Child; CYComputer := mb.KeyCycle( y.ADR( CYAComputer ),'c');
                                  mb.Child; mb.label1("Printer:" ); mb.Child; CYPrinter  := mb.KeyCycle( y.ADR( CYAPrinter ) ,'p');
                                  mb.Child; mb.label1("Display:" ); mb.Child; CYDisplay  := mb.KeyCycle( y.ADR( CYADisplay ),'d');
                                  mb.end;
                          mb.Child; mb.ListviewObject( Mui.aListviewInput, Exec.true, u.end );
                                         mb.Tag( Mui.aListviewList ); mb.ListObject; mb.InputListFrame; mb.end;
                                     LVComputer:= mb.End();
                          mb.end;
                      mb.end;
              mb.end;
          WICycle:=mb.End();

      mb.SubWindow;
              DemoWindow("Listviews",'LIST',INListviews);
                  mb.Child; mb.HGroup; mb.GroupFrameT( "Dir & Volume List" );
                      mb.Child; mb.ListviewObject( Mui.aListviewInput, Exec.true,
                                                     Mui.aListviewMultiSelect, Exec.true,
                                                     u.end );
                                     mb.Tag( Mui.aListviewList ); mb.DirlistObject;
                                                                     mb.InputListFrame;
                                                                       mb.TagItem( Mui.aDirlistDirectory, y.ADR("ram:") );
                                                                  mb.end;
                                 LVDirectory := mb.End();
                      mb.Child; mb.ListviewObject( Mui.aWeight, 20,
                                                     Mui.aListviewInput, Exec.true,
                                                     u.end );
                                     mb.Tag( Mui.aListviewList ); mb.VolumelistObject;
                                                                    mb.InputListFrame;
                                                                    mb.TagItem( Mui.aDirlistDirectory, y.ADR("ram:") );
                                                                  mb.end;
                                 LVVolumes := mb.End();
                      mb.end;
                  mb.end;
              WIListviews := mb.End();

      mb.SubWindow;
              DemoWindow("Notifying",'BRCA',INNotify);
                      mb.Child; mb.HGroup; mb.GroupFrameT( "Connections" );
                              mb.Child; mb.GaugeObject;
                                          mb.TagItem2( Mui.aGaugeHoriz, Exec.false, Mui.aFixWidth, 16 );
                                          mb.GaugeFrame;
                                        GAGauge1 := mb.End();
                              mb.Child; PRPropL := VProp();
                              mb.Child; PRPropR := VProp();
                              mb.Child; mb.VGroup;
                                            mb.Child; mb.VSpace(0);
                                            mb.Child; PRPropA := HProp();
                                            mb.Child; mb.HGroup;
                                                          mb.Child; PRPropH := HProp();
                                                          mb.Child; PRPropV := HProp();
                                                       mb.end;
                                            mb.Child; mb.VSpace(0);
                                            mb.Child; mb.VGroup; mb.GroupSpacing(1);
                                                          mb.Child; mb.GaugeObject;
                                                                      mb.GaugeFrame;
                                                                      mb.TagItem( Mui.aGaugeHoriz, Exec.true );
                                                                    GAGauge2 := mb.End();
                                                          mb.Child; mb.ScaleObject( Mui.aScaleHoriz, Exec.true, u.end ); mb.end;
                                                       mb.end;
                                            mb.Child; mb.VSpace(0);
                                            mb.end;
                              mb.Child; PRPropT := VProp();
                              mb.Child; PRPropB := VProp();
                              mb.Child; mb.GaugeObject;
                                          mb.GaugeFrame;
                                          mb.TagItem2( Mui.aGaugeHoriz, Exec.false,
                                                       Mui.aFixWidth, 16);
                                        GAGauge3 := mb.End();
                              mb.end;
                      mb.end;
              WINotify := mb.End();

      mb.SubWindow;
          DemoWindow("Backfill",'BACK',INBackfill);
              mb.Child; mb.VGroup; mb.GroupFrameT( "Standard Backgrounds" );
                         mb.Child; mb.HGroup;
                                     mb.Child; mb.RectangleObject;
                                                 mb.TextFrame;
                                                 mb.TagItem( Mui.aBackground, Mui.iBACKGROUND );
                                               mb.end;
                                     mb.Child; mb.RectangleObject;
                                                  mb.TextFrame;
                                                  mb.TagItem( Mui.aBackground, Mui.iFILL );
                                                  mb.end;
                                     mb.Child; mb.RectangleObject;
                                                 mb.TextFrame;
                                                 mb.TagItem( Mui.aBackground, Mui.iSHADOW );
                                               mb.end;
                                   mb.end;
                        mb.Child; mb.HGroup;
                                    mb.Child; mb.RectangleObject;
                                                mb.TextFrame;
                                                mb.TagItem( Mui.aBackground, Mui.iSHADOWBACK);
                                              mb.end;
                                    mb.Child; mb.RectangleObject;
                                                mb.TextFrame;
                                                mb.TagItem( Mui.aBackground, Mui.iSHADOWFILL );
                                              mb.end;
                                    mb.Child; mb.RectangleObject;
                                                mb.TextFrame;
                                                mb.TagItem( Mui.aBackground, Mui.iSHADOWSHINE );
                                              mb.end;
                                  mb.end;
                        mb.Child; mb.HGroup;
                                    mb.Child; mb.RectangleObject;
                                                mb.TextFrame;
                                                mb.TagItem( Mui.aBackground, Mui.iFILLBACK );
                                              mb.end;
                                    mb.Child; mb.RectangleObject;
                                                mb.TextFrame;
                                                mb.TagItem( Mui.aBackground, Mui.iSHINEBACK );
                                              mb.end;
                                    mb.Child; mb.RectangleObject;
                                                mb.TextFrame;
                                                mb.TagItem( Mui.aBackground, Mui.iFILLSHINE );
                                              mb.end;
                                  mb.end;
                      mb.end;
              mb.end;
          WIBackfill := mb.End();

      mb.SubWindow;
              DemoWindow("Groups",'GRPS',INGroups);
                      mb.Child; mb.HGroup; mb.GroupFrameT( "Group Types" );
                              mb.Child; mb.HGroup; mb.GroupFrameT( "Horizontal" );
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.end;
                              mb.Child; mb.VGroup; mb.GroupFrameT( "Vertical" );
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.end;
                              mb.Child; mb.ColGroup(3); mb.GroupFrameT( "Array" );
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.Child; mb.RectangleObject; mb.TextFrame; mb.end;
                                      mb.end;
                              mb.end;
                      mb.Child; mb.HGroup; mb.GroupFrameT( "Different Weights" );
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "\033c25 kg"  ), Mui.aWeight, 25 );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "\033c50 kg"  ), Mui.aWeight, 50 );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "\033c75 kg"  ), Mui.aWeight, 75 );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "\033c100 kg" ), Mui.aWeight,100 );
                                        mb.end;
                              mb.end;
                      mb.Child; mb.HGroup; mb.GroupFrameT( "Fixed & Variable Sizes" );
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "fixed"     ), Mui.aTextSetMax, Exec.true );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "\033cfree" ), Mui.aTextSetMax, Exec.false);
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "fixed"     ), Mui.aTextSetMax, Exec.true) ;
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "\033cfree" ), Mui.aTextSetMax, Exec.false);
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem3( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR( "fixed"     ), Mui.aTextSetMax, Exec.true) ;
                                        mb.end;
                              mb.end;
                      mb.end;
              WIGroups := mb.End();

      mb.SubWindow;
              DemoWindow("Frames",'FRMS', INFrames);
                      mb.Child; mb.ColGroup(2);
                              mb.Child; mb.TextObject;
                                          mb.ButtonFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cButton"     ) );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.ImageButtonFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cImageButton") );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.TextFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cText"       ) );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.StringFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cString"     ) );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.ReadListFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cReadList"   ) );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.InputListFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cInputList"  ) );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.PropFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cProp Gadget") );
                                        mb.end;
                              mb.Child; mb.TextObject;
                                          mb.GroupFrame;
                                          mb.TagItem2( Mui.aBackground, Mui.iTextBack, Mui.aTextContents, y.ADR("\033cGroup"      ) );
                                        mb.end;
                              mb.end;
                      mb.end;
              WIFrames := mb.End();

      mb.SubWindow;
              DemoWindow("Images",'IMGS',INImages);
                      mb.Child; mb.HGroup;
                              mb.Child; mb.VGroup; mb.GroupFrameT( "Standard Images" );
                                      mb.Child; ImageLine("ArrowUp:"    , Mui.iArrowUp    );
                                      mb.Child; ImageLine("ArrowDown:"  , Mui.iArrowDown  );
                                      mb.Child; ImageLine("ArrowLeft:"  , Mui.iArrowLeft  );
                                      mb.Child; ImageLine("ArrowRight:" , Mui.iArrowRight );
                                      mb.Child; ImageLine("RadioButton:", Mui.iRadioButton);
                                      mb.Child; ImageLine("File:"       , Mui.iPopFile    );
                                      mb.Child; ImageLine("HardDisk:"   , Mui.iHardDisk   );
                                      mb.Child; ImageLine("Disk:"       , Mui.iDisk       );
                                      mb.Child; ImageLine("Chip:"       , Mui.iChip       );
                                      mb.Child; ImageLine("Drawer:"     , Mui.iDrawer     );
                                      mb.end;
                              mb.Child; mb.VGroup; mb.GroupFrameT( "Scale Engine"  );
                                      mb.Child; mb.VSpace(0);
                                      mb.Child; mb.HGroup;
                                              mb.Child; ScaledImage(Mui.iRadioButton, TRUE, 17,9);
                                              mb.Child; ScaledImage(Mui.iRadioButton, TRUE, 20,12);
                                              mb.Child; ScaledImage(Mui.iRadioButton, TRUE, 23,15);
                                              mb.Child; ScaledImage(Mui.iRadioButton, TRUE, 26,18);
                                              mb.Child; ScaledImage(Mui.iRadioButton, TRUE, 29,21);
                                              mb.end;
                                      mb.Child; mb.VSpace(0);
                                      mb.Child; mb.HGroup;
                                              mb.Child; ScaledImage(Mui.iCheckMark, TRUE,13,7);
                                              mb.Child; ScaledImage(Mui.iCheckMark, TRUE,16,10);
                                              mb.Child; ScaledImage(Mui.iCheckMark, TRUE,19,13);
                                              mb.Child; ScaledImage(Mui.iCheckMark, TRUE,22,16);
                                              mb.Child; ScaledImage(Mui.iCheckMark, TRUE,25,19);
                                              mb.Child; ScaledImage(Mui.iCheckMark, TRUE,28,22);
                                              mb.end;
                                      mb.Child; mb.VSpace(0);
                                      mb.Child; mb.HGroup;
                                              mb.Child; ScaledImage(Mui.iPopFile, FALSE,12,10);
                                              mb.Child; ScaledImage(Mui.iPopFile, FALSE,15,13);
                                              mb.Child; ScaledImage(Mui.iPopFile, FALSE,18,16);
                                              mb.Child; ScaledImage(Mui.iPopFile, FALSE,21,19);
                                              mb.Child; ScaledImage(Mui.iPopFile, FALSE,24,22);
                                              mb.Child; ScaledImage(Mui.iPopFile, FALSE,27,25);
                                              mb.end;
                                      mb.Child; mb.VSpace(0);
                                      mb.end;
                              mb.end;
                      mb.end;
              WIImages := mb.End();

      mb.SubWindow;
              mb.WindowObject( Mui.aWindowTitle, y.ADR( "MUI-Demo" ),
                                Mui.aWindowID   , y.VAL(LONGINT, 'MAIN' ),
                                u.end );
                      mb.WindowContents; mb.VGroup;
                      mb.Child; mb.TextObject;
                                  mb.GroupFrame;
                                  mb.TagItem2( Mui.aBackground, Mui.iSHADOWFILL, Mui.aTextContents, y.ADR( "\033c\0338MUI - \033bM\033nagic\033bU\033nser\033bI\033nnterface\nwritten 1993 by Stefan Stuntz" ) );
                                mb.end;

                      mb.Child; List( y.ADR( INMaster) );

                      mb.Child; mb.VGroup; mb.GroupFrameT( "Available Demos" );
                              mb.Child; mb.HGroup;
                                          mb.TagItem( Mui.aGroupSameWidth, Exec.true );
                                          mb.Child; BTGroups := mb.KeyButton("Groups"   ,'g');
                                          mb.Child; BTFrames := mb.KeyButton("Frames"   ,'f');
                                          mb.Child; BTBackfill := mb.KeyButton("Backfill" ,'b');
                                        mb.end;
                              mb.Child; mb.HGroup;
                                      mb.TagItem( Mui.aGroupSameWidth, Exec.true );
                                      mb.Child; BTNotify    := mb.KeyButton("Notify",'n');
                                      mb.Child; BTListviews := mb.KeyButton("Listviews",'l');
                                      mb.Child; BTCycle     := mb.KeyButton("Cycle"    ,'c');
                                      mb.end;
                              mb.Child; mb.HGroup;
                                      mb.TagItem( Mui.aGroupSameWidth, Exec.true);
                                      mb.Child;BTImages    := mb.KeyButton("Images"   ,'i');
                                      mb.Child;BTString    := mb.KeyButton("Strings"  ,'s');
                                      mb.Child;BTQuit      := mb.KeyButton("Quit"     ,'q');

                                      mb.end;
                              mb.end;
                      mb.end;
              WIMaster := mb.End();

  APDemo := mb.End();


(*
** See if the application was created. The fail function
** is defined in demos.h;it deletes every created object
** and closes "muimaster.library".
**
** Note that we do not need any
** error control for the sub objects since every error
** will automatically be forwarded to the parent object
** and cause this one to fail too.
*)

  IF APDemo = NIL THEN fail(APDemo,"Failed to create application.") END;



(*
** Here comes the broadcast magic. Notifying means:
** When an attribute of an object changes;then please change
** another attribute of another object (accordingly) or send
** a method to another object.
*)

(*
** Lets bind the sub windows to the corresponding button
** of the master window.
*)

        Mui.DoMethod(BTFrames   ,Mui.mNotify,Mui.aPressed,Exec.false,WIFrames   ,3,Mui.mSet,Mui.aWindowOpen,Exec.true);
        Mui.DoMethod(BTImages   ,Mui.mNotify,Mui.aPressed,Exec.false,WIImages   ,3,Mui.mSet,Mui.aWindowOpen,Exec.true);
        Mui.DoMethod(BTNotify   ,Mui.mNotify,Mui.aPressed,Exec.false,WINotify,  3,Mui.mSet,Mui.aWindowOpen,Exec.true);
        Mui.DoMethod(BTListviews,Mui.mNotify,Mui.aPressed,Exec.false,WIListviews,3,Mui.mSet,Mui.aWindowOpen,Exec.true);
        Mui.DoMethod(BTGroups   ,Mui.mNotify,Mui.aPressed,Exec.false,WIGroups   ,3,Mui.mSet,Mui.aWindowOpen,Exec.true);
        Mui.DoMethod(BTBackfill ,Mui.mNotify,Mui.aPressed,Exec.false,WIBackfill ,3,Mui.mSet,Mui.aWindowOpen,Exec.true);
        Mui.DoMethod(BTCycle    ,Mui.mNotify,Mui.aPressed,Exec.false,WICycle    ,3,Mui.mSet,Mui.aWindowOpen,Exec.true);
        Mui.DoMethod(BTString   ,Mui.mNotify,Mui.aPressed,Exec.false,WIString   ,3,Mui.mSet,Mui.aWindowOpen,Exec.true);

        Mui.DoMethod(BTQuit     ,Mui.mNotify,Mui.aPressed,Exec.false,APDemo,2,Mui.mApplicationReturnID,Mui.vApplicationReturnIDQuit);


(*
** Automagically remove a window when the user hits the close gadget.
*)

        Mui.DoMethod(WIImages   ,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WIImages   ,3,Mui.mSet,Mui.aWindowOpen,Exec.false);
        Mui.DoMethod(WIFrames   ,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WIFrames   ,3,Mui.mSet,Mui.aWindowOpen,Exec.false);
        Mui.DoMethod(WINotify   ,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WINotify   ,3,Mui.mSet,Mui.aWindowOpen,Exec.false);
        Mui.DoMethod(WIListviews,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WIListviews,3,Mui.mSet,Mui.aWindowOpen,Exec.false);
        Mui.DoMethod(WIGroups   ,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WIGroups   ,3,Mui.mSet,Mui.aWindowOpen,Exec.false);
        Mui.DoMethod(WIBackfill ,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WIBackfill ,3,Mui.mSet,Mui.aWindowOpen,Exec.false);
        Mui.DoMethod(WICycle    ,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WICycle    ,3,Mui.mSet,Mui.aWindowOpen,Exec.false);
        Mui.DoMethod(WIString   ,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,WIString   ,3,Mui.mSet,Mui.aWindowOpen,Exec.false);


(*
** Closing the master window forces a complete shutdown of the application.
*)

        Mui.DoMethod(WIMaster,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,APDemo,2,Mui.mApplicationReturnID,Mui.vApplicationReturnIDQuit);


(*
** This connects the prop gadgets in the broadcast demo window.
*)

        Mui.DoMethod(PRPropA,Mui.mNotify,Mui.aPropFirst,Mui.vEveryTime,PRPropH,3,Mui.mSet,Mui.aPropFirst,Mui.vTriggerValue);
        Mui.DoMethod(PRPropA,Mui.mNotify,Mui.aPropFirst,Mui.vEveryTime,PRPropV,3,Mui.mSet,Mui.aPropFirst,Mui.vTriggerValue);
        Mui.DoMethod(PRPropH,Mui.mNotify,Mui.aPropFirst,Mui.vEveryTime,PRPropL,3,Mui.mSet,Mui.aPropFirst,Mui.vTriggerValue);
        Mui.DoMethod(PRPropH,Mui.mNotify,Mui.aPropFirst,Mui.vEveryTime,PRPropR,3,Mui.mSet,Mui.aPropFirst,Mui.vTriggerValue);
        Mui.DoMethod(PRPropV,Mui.mNotify,Mui.aPropFirst,Mui.vEveryTime,PRPropT,3,Mui.mSet,Mui.aPropFirst,Mui.vTriggerValue);
        Mui.DoMethod(PRPropV,Mui.mNotify,Mui.aPropFirst,Mui.vEveryTime,PRPropB,3,Mui.mSet,Mui.aPropFirst,Mui.vTriggerValue);

        Mui.DoMethod(PRPropA ,Mui.mNotify,Mui.aPropFirst   ,Mui.vEveryTime,GAGauge2,3,Mui.mSet,Mui.aGaugeCurrent,Mui.vTriggerValue);
        Mui.DoMethod(GAGauge2,Mui.mNotify,Mui.aGaugeCurrent,Mui.vEveryTime,GAGauge1,3,Mui.mSet,Mui.aGaugeCurrent,Mui.vTriggerValue);
        Mui.DoMethod(GAGauge2,Mui.mNotify,Mui.aGaugeCurrent,Mui.vEveryTime,GAGauge3,3,Mui.mSet,Mui.aGaugeCurrent,Mui.vTriggerValue);


(*
** And here we connect cycle gadgets;radio buttons and the list in the
** cycle & radio window.
*)

        Mui.DoMethod(CYComputer,Mui.mNotify,Mui.aCycleActive,Mui.vEveryTime,MTComputer,3,Mui.mSet,Mui.aRadioActive,Mui.vTriggerValue);
        Mui.DoMethod(CYPrinter ,Mui.mNotify,Mui.aCycleActive,Mui.vEveryTime,MTPrinter ,3,Mui.mSet,Mui.aRadioActive,Mui.vTriggerValue);
        Mui.DoMethod(CYDisplay ,Mui.mNotify,Mui.aCycleActive,Mui.vEveryTime,MTDisplay ,3,Mui.mSet,Mui.aRadioActive,Mui.vTriggerValue);
        Mui.DoMethod(MTComputer,Mui.mNotify,Mui.aRadioActive,Mui.vEveryTime,CYComputer,3,Mui.mSet,Mui.aCycleActive,Mui.vTriggerValue);
        Mui.DoMethod(MTPrinter ,Mui.mNotify,Mui.aRadioActive,Mui.vEveryTime,CYPrinter ,3,Mui.mSet,Mui.aCycleActive,Mui.vTriggerValue);
        Mui.DoMethod(MTDisplay ,Mui.mNotify,Mui.aRadioActive,Mui.vEveryTime,CYDisplay ,3,Mui.mSet,Mui.aCycleActive,Mui.vTriggerValue);
        Mui.DoMethod(MTComputer,Mui.mNotify,Mui.aRadioActive,Mui.vEveryTime,LVComputer,3,Mui.mSet,Mui.aListActive ,Mui.vTriggerValue);
        Mui.DoMethod(LVComputer,Mui.mNotify,Mui.aListActive ,Mui.vEveryTime,MTComputer,3,Mui.mSet,Mui.aRadioActive,Mui.vTriggerValue);


(*
** This one makes us receive input ids from several list views.
*)

        Mui.DoMethod(LVVolumes ,Mui.mNotify,Mui.aListviewDoubleClick,Exec.true,APDemo,2,Mui.mApplicationReturnID,IDNEWVOL);
        Mui.DoMethod(LVBrian   ,Mui.mNotify,Mui.aListActive,Mui.vEveryTime,APDemo,2,Mui.mApplicationReturnID,IDNEWBRI);


(*
** Now lets set the TAB cycle chain for some of our windows.
*)

        Mui.DoMethod(WIMaster   ,Mui.mWindowSetCycleChain,BTGroups,BTFrames,BTBackfill,BTNotify,BTListviews,BTCycle,BTImages,BTString,NIL);
        Mui.DoMethod(WIListviews,Mui.mWindowSetCycleChain,LVDirectory,LVVolumes,NIL);
        Mui.DoMethod(WICycle    ,Mui.mWindowSetCycleChain,MTComputer,MTPrinter,MTDisplay,CYComputer,CYPrinter,CYDisplay,LVComputer,NIL);
        Mui.DoMethod(WIString   ,Mui.mWindowSetCycleChain,STBrian,NIL);


(*
** Set some start values for certain objects.
*)

        Mui.DoMethod(LVComputer,Mui.mListInsert, y.ADR( CYAComputer),-1,Mui.vListInsertBottom);
        Mui.DoMethod(LVBrian   ,Mui.mListInsert, y.ADR( LVTBrian),-1,Mui.vListInsertBottom);
        mb.Set(LVComputer,Mui.aListActive,0);
        mb.Set(LVBrian   ,Mui.aListActive,0);
        mb.Set(STBrian   ,Mui.aStringAttachedList,LVBrian);


(*
** Everything's ready;lets launch the application. We will
** open the master window now.
*)

        mb.Set(WIMaster,Mui.aWindowOpen,Exec.true);


(*
** This is the main loop. As you can see;it does just nothing.
** Everything is handled by MUI;no work for the programmer.
**
** The only thing we do here is to react on a double click
** in the volume list (which causes an IDNEWVOL) by setting
** a new directory name for the directory list. If you want
** to see a real file requester with MUI;wait for the
** next release of MFR :-)
*)

  running := TRUE;

  WHILE running DO
    CASE Mui.DOMethod( APDemo,Mui.mApplicationInput,y.ADR( signal ) ) OF
      | Mui.vApplicationReturnIDQuit: running := FALSE;

      | IDNEWVOL : Mui.DoMethod( LVVolumes, Mui.mListGetEntry, Mui.vListGetEntryActive, y.ADR( buf ) );
                   mb.Set( LVDirectory, Mui.aDirlistDirectory, buf );


      | IDNEWBRI:  mb.Get( LVBrian, Mui.aListActive, pos );
                   mb.Set( STBrian, Mui.aStringContents, LVTBrian[ pos ]);

      | IDABOUT:   IF Mui.Request(APDemo,WIMaster,0,NIL,"*OK","Oberon MUI-Demo\n© 1993 by Albert Weinert") = 0 THEN END;
    ELSE END;
    IF signal # LONGSET{} THEN y.SETREG( 0, Exec.Wait(signal) ) END;;
  END;

  Mui.DisposeObject( APDemo );


(*
** This is the end...
*)
END MuiDemo.
