IMPLEMENTATION MODULE Template;

FROM InOut        IMPORT WriteString, WriteLn; 
FROM Intuition    IMPORT Screen, ScreenPtr, ScreenFlags, ScreenFlagSet,
                         Window, WindowPtr, WindowFlags, WindowFlagSet,
                         SmartRefresh, IntuiMessage, IntuiMessagePtr,
                         IDCMPFlags, IDCMPFlagSet;
FROM Menus        IMPORT SetMenuStrip;
FROM Screens      IMPORT CloseScreen, ShowTitle;
FROM Strings      IMPORT String;
FROM SYSTEM       IMPORT NULL;
FROM Views        IMPORT Modes, ModeSet;
FROM Windows      IMPORT CloseWindow;
 
FROM ColorTools   IMPORT SetScreenColors;
FROM MenuTools    IMPORT AddMenu, AddItem, AddSubItem, DestroyMenuStrip,
                         FirstMenu, NoKey, ItemOn, Checkable, CheckNow,
                         AutoIndent, InitializeMenuStrip, HiResScreen, Left;
FROM MessageTools IMPORT GotMessage, GetMenuChoice, ChoiceType;
FROM TextTools    IMPORT FrontTextPen, BackTextPen;
FROM WindowTools  IMPORT OpenGraphics,   CreateScreen, CreateWindow,   FillPen,
                         CloseGraphics,  ViewFeatures, ScreenFeatures, TextPen,
                         WindowFeatures, NoTitle, UserIntuiBase, UserGraphBase;
 
 
CONST
   ProjectMenu = 0;
   QuitItem    = 6;

VAR
   IMessage   : IntuiMessagePtr;
   MenuChoice : ChoiceType;
   finished   : BOOLEAN; 
 

   PROCEDURE CreateCanvas () : BOOLEAN;


      PROCEDURE OpenTheScreen () : BOOLEAN;

      VAR
         ScreenTitle : String;

      BEGIN
         ScreenTitle    := NoTitle;
         ViewFeatures   := ModeSet{Hires};
         ScreenFeatures := ScreenFlagSet{ScreenQuiet};
         TheScreen      := CreateScreen (0,0,640,200, 3, ScreenTitle);
         IF (TheScreen <> NULL) THEN
            SetScreenColors(TheScreen);
            RETURN TRUE;
         ELSE
            RETURN FALSE;
         END; (* IF TheScreen *)
      END OpenTheScreen;


      PROCEDURE OpenTheWindow () : BOOLEAN;

      VAR
         WindowTitle : String;

      BEGIN
         WindowTitle    := NoTitle;
         WindowFeatures := SmartRefresh + WindowFlagSet{Activate, Borderless,
                                          BackDrop, ReportMouseFlag};
         TheWindow      := CreateWindow (0,0,640,200, WindowTitle, TheScreen);
         IF (TheWindow <> NULL) THEN
            RETURN TRUE;
         ELSE
            RETURN FALSE;
         END; (* IF TheScreen *)
      END OpenTheWindow;


   BEGIN

      IF ( OpenGraphics() ) THEN
         IF ( OpenTheScreen() ) THEN

            IF ( OpenTheWindow () ) THEN
               ShowTitle (TheScreen, FALSE);      (* don't show Screen title *)
               RETURN TRUE;
            ELSE
               WriteLn; WriteString ("Couldn't allocate Window..."); WriteLn;
               CloseScreen (TheScreen);
               CloseGraphics;
               RETURN FALSE;
            END; (* IF OpenTheWindow *)

         ELSE
            WriteLn; WriteString ("Couldn't allocate Screen..."); WriteLn;
            CloseGraphics;
            RETURN FALSE;
         END; (* IF TheScreen *)

      ELSE
         IF (UserIntuiBase = NULL) THEN
            WriteLn; WriteString("Intuition library would not open."); WriteLn;
         ELSE  (* UserGraphBase = NULL *)
            WriteLn; WriteString("Graphics library would not open."); WriteLn;
         END; (* IF UserIntuiBase *)
         RETURN FALSE;
      END; (* IF OpenGraphics *)

   END CreateCanvas;


   PROCEDURE CreateMenuStrip;
 
   BEGIN

      InitializeMenuStrip;
      HiResScreen  := TRUE;

      AddMenu ("Project");
         AddItem ("New",          "N",   ItemOn, 0);
         AddItem ("Open",         "O",   ItemOn, 0);
         AddItem ("Save",         "S",   ItemOn, 0);
         AddItem ("Save as..   ", "A",   ItemOn, 0);
         AddItem ("Page setup..", NoKey, ItemOn, 0);
         AddItem ("Print",        NoKey, ItemOn, 0);
         AddItem ("Quit",         "Q",   ItemOn, 0);

      AddMenu ("Edit");
         AddItem ("Undo",  "U", ItemOn, 0);
         AddItem ("Cut",   "X", ItemOn, 0);
         AddItem ("Copy",  "C", ItemOn, 0);
         AddItem ("Paste", "P", ItemOn, 0);
         AddItem ("Erase", "E", ItemOn, 0);

      AutoIndent := TRUE;
      AddMenu ("Your Menu");
         Left := -18;
         AddItem ("Your Item", NoKey, ItemOn+Checkable+CheckNow, 63-1);
         AddItem ("Your Item", NoKey, ItemOn,                    63-2);
            AddSubItem ("Your SubItem", NoKey, ItemOn+Checkable, 2);
            AddSubItem ("Your SubItem", NoKey, ItemOn+Checkable, 1);
         AddItem ("Your Item", NoKey, ItemOn+Checkable,          63-4);
         AddItem ("Your Item", NoKey, ItemOn,                    63-8);
            AddSubItem ("Check Me!", NoKey, ItemOn+Checkable, 2+4+8);
            AddSubItem ("Check Me!", NoKey, ItemOn+Checkable, 1+4+8);
            AddSubItem ("Check Me!", NoKey, ItemOn+Checkable, 1+2+8);
            AddSubItem ("Check Me!", NoKey, ItemOn+Checkable, 1+2+4);

   END CreateMenuStrip;
 
 
   PROCEDURE CreateScreenWindowAndMenus () : BOOLEAN;
 
   BEGIN
      IF ( CreateCanvas () ) THEN
         CreateMenuStrip ();
         SetMenuStrip (TheWindow, FirstMenu^);
         TheMenu := FirstMenu;
         RETURN TRUE;
      ELSE
         TheMenu := NULL;
         RETURN FALSE;
      END; (* IF CreateCanvas *)
   END CreateScreenWindowAndMenus;
 

   PROCEDURE ProcessIntuiMessages (VAR finished : BOOLEAN);

   BEGIN
      WHILE (GotMessage (IMessage, TheWindow)) DO
         IF (MenuPick IN IMessage^.Class) THEN
 
            GetMenuChoice (IMessage^.Code, FirstMenu, MenuChoice);
            WITH MenuChoice DO
               IF (MenuChosen = ProjectMenu) AND (ItemChosen = QuitItem) THEN
                  finished := TRUE;
                  RETURN;
               END; (* IF MenuChosen *)
            END; (* WITH MenuChoice *)
 
         END; (* IF MenuPick *)
      END; (* WHILE GotMessage *) 
   END ProcessIntuiMessages; 


   PROCEDURE DestroyScreenWindowAndMenus;

   BEGIN
      DestroyMenuStrip (TheWindow);
      CloseWindow (TheWindow);
      CloseScreen (TheScreen);
      CloseGraphics ();
   END DestroyScreenWindowAndMenus;
 
 
BEGIN
END Template.
