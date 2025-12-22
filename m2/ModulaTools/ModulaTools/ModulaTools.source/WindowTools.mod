(******************************************************************************)
(*                                                                            *)
(*  Version 1.00a.002 (Beta) :   March 2, 1988                                *)
(*                                                                            *)
(*    These procedures were originally written under version 1.20 of the TDI  *)
(* Modula-2 compiler. I have rewritten this module to operate under the v2.00 *)
(* compiler. However, should you find any problem or inconsistency with the   *)
(* functionality of this code, please contact me at the following address:    *)
(*                                                                            *)
(*                               Jerry Mack                                   *)
(*                               23 Prospect Hill Ave.                        *)
(*                               Waltham, MA   02154                          *)
(*                                                                            *)
(*    Check the module MenuUtils for TDI's (considerably less powerful) ver-  *)
(* sions of my Menu and IntuitionText procedures. The modules GadgetUtils and *)
(* EasyGadgets should also be of great help.                                  *)
(*                                                                            *)
(******************************************************************************)
(*                                                                            *)
(*    The source code to WindowTools is in the public domain. You may do with *)
(* it as you please.                                                          *)
(*                                                                            *)
(******************************************************************************)

IMPLEMENTATION MODULE WindowTools;


FROM GraphicsBase    IMPORT GfxBasePtr, NTSC, PAL;
FROM GraphicsLibrary IMPORT GraphicsName, GraphicsBase;
FROM Intuition       IMPORT IntuitionName, IntuitionBase, IntuitionBasePtr,
                            IDCMPFlags,IDCMPFlagSet, StdScreenHeight,
                            Screen, ScreenPtr, ScreenFlags, ScreenFlagSet,
                            CustomScreen, WindowPtr, NewWindow,
                            WindowFlags, WindowFlagSet, SmartRefresh;
FROM Libraries       IMPORT OpenLibrary, CloseLibrary;
FROM Screens         IMPORT NewScreen, NewScreenPtr, OpenScreen;
FROM Storage         IMPORT ALLOCATE, DEALLOCATE;
FROM Strings         IMPORT String, InitStringModule, Compare, Equal, Length;
FROM SYSTEM          IMPORT ADR, BYTE, NULL;
FROM Views           IMPORT Modes, ModeSet;
FROM Windows         IMPORT OpenWindow;

CONST
   NoText      = 0C;
   MinHigh     = 30;                (* minimum height of Windows and Screens *)
   MinWide     = 40;                (* minimum width  of Windows             *)
 
TYPE
   StringPtr = POINTER TO String;       (* storage space for Menu text;      *)

VAR
   ScreenHeight : INTEGER;           (* # of lines in non-interlaced display *)
 

   PROCEDURE Min (int1, int2 : INTEGER ) : INTEGER;
   
   BEGIN
      IF (int1 < int2) THEN              (* utility routine to find the    *)
         RETURN int1;                    (* minimum of a pair of integers; *)
      ELSE
         RETURN int2;
      END; (* IF int1 *)
   END Min; 
   
   
   PROCEDURE Max (int1, int2 : INTEGER ) : INTEGER;
   
   BEGIN
      IF (int1 > int2) THEN              (* utility routine to find the    *)
         RETURN int1;                    (* maximum of a pair of integers; *)
      ELSE
         RETURN int2;
      END; (* IF int1 *)
   END Max; 
   

(***************************************************************************)
(*                                                                         *)
(*    This procedure opens the Intuition & Graphics libraries and initial- *)
(* izes the user-accessible variables for the procedures CreateScreen and  *)
(* CreateWindow. If both libraries are opened properly, the procedure re-  *)
(* turns the value TRUE; otherwise, it returns the value FALSE.            *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE OpenGraphics () : BOOLEAN;

   CONST
      IntuitionRev = 33;
      GraphicsRev  = 33;

   BEGIN

      TextPen         := 0;               (* which color registers to use; *)
      FillPen         := 1;
      MinWindowWide   := MinWide;    (* minimum and maximum dimensions to  *)
      MaxWindowWide   := 0;          (* which Window may be sized; 0 -->   *)
      MinWindowHigh   := MinHigh;    (* current dimension is used;         *)
      MaxWindowHigh   := 0;
      ScreenBitMap    := NULL;   (* <> NULL --> user-managed Screen bitmap *)
      WindowBitMap    := NULL;   (* <> NULL --> user-managed Window bitmap *)
      ViewFeatures    := ModeSet{};
      ScreenFeatures  := CustomScreen;
      WindowFeatures  := SmartRefresh + WindowFlagSet {WindowSizing,
                         WindowDrag, WindowDepth, WindowClose, 
                         Activate, ReportMouseFlag}; 
      IDCMPFeatures   := IDCMPFlagSet{MenuPick, CloseWindowFlag, NewSize,
                                      GadgetUp};


  (* IntuitionBase & GraphicsBase let the compiler know where to access  *)
  (* the associated libraries; UserIntuiBase & UserGraphBase do the same *)
  (* for the user;                                                       *)

      IntuitionBase   := OpenLibrary (IntuitionName,IntuitionRev);
      UserIntuiBase   := IntuitionBasePtr (IntuitionBase);
      IF (IntuitionBase = NULL) THEN
         UserGraphBase := NIL;
         RETURN FALSE;
      ELSE
         GraphicsBase  := OpenLibrary (GraphicsName, GraphicsRev);
         UserGraphBase := GfxBasePtr (GraphicsBase);
         IF (GraphicsBase = NULL) THEN
            CloseLibrary (IntuitionBase);
            RETURN FALSE;
         ELSE            (* Hey TDI: Where's GraphicsBase^.NormalDisplayRows? *)
            IF (UserGraphBase^.DisplayFlags = PAL) THEN
               ScreenHeight := 256;         (* set Screen height according *)
            ELSE                            (* to whether monitor is PAL   *)
               ScreenHeight := 200;         (* or NTSC;                    *)
            END; (* IF UserGraphBase^ *)
            RETURN TRUE;
         END; (* IF GraphicsBase *)
      END; (* IF IntuitionBase *)
   END OpenGraphics;


(***************************************************************************)
(*                                                                         *)
(*    This procedure opens a Screen with a minimum of fuss while allowing  *)
(* the user easy access to the fields of the NewScreen structure. Several  *)
(* checks are made to insure that illegal parameter values are not handed  *)
(* to the Amiga. The procedure returns a pointer to the desired Screen ex- *)
(* cept when OpenScreen fails, in which case it will return a NULL pointer.*)
(*    The procedure "OpenGraphics" must be called prior to invoking        *)
(* this procedure, in order to open certain libraries & initialize certain *)
(* variables.                                                              *)
(*                                                                         *)
(*    The following parameters are required as inputs:                     *)
(*                                                                         *)
(*     Left - (INTEGER) the leftmost pixel-position of the Screen; this is *)
(*            always set to zero in this version of the procedure.         *)
(*     Top  - (INTEGER) the topmost pixel-position of the Screen; this can *)
(*            be set to any value between 0 and the bottommost vertical    *)
(*            pixel (399 if Lace is set in ViewFeatures, 199 otherwise).   *)
(*     Wide - (INTEGER) the width of the Screen; this will be set to the   *)
(*            maximum # of horizontal pixels in the display (640 if Hires  *)
(*            is set in ViewFeatures, 320 otherwise).                      *)
(*     High - (INTEGER) the height of the Screen; this will be set so that *)
(*            Top+High >= # of vertical pixels on the Screen.              *)
(*   Bitplanes - (INTEGER) # of bitplanes desired for this Screen; this is *)
(*               allowed to take the values from 0 to 5 with plain Screens,*)
(*               0 to 6 with Dual-playfield Screens and 6 otherwise.       *)
(*  ScreenTitle - (String) title of the Screen; if this equals the defined *)
(*                constant "NoTitle", then neither a title nor a drag bar  *)
(*                will be included with the Screen.                        *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE CreateScreen (Left, Top, Wide, High : INTEGER;
                           Bitplanes             : INTEGER;
                           VAR ScreenTitle       : String) : ScreenPtr;
   
   VAR
      UserScreen : NewScreenPtr;
      TempScreen : ScreenPtr;
      
   BEGIN
      NEW (UserScreen);
      WITH UserScreen^ DO 

         LeftEdge := 0;
         IF (Hires IN ViewFeatures) THEN
            Width := 640;                   (* make sure that Screen fills *)
         ELSE                               (* the display                 *)
            Width := 320;
         END; (* IF Hires *)


(* ensure that Screen is not larger than the display or smaller than I allow *)

         IF (Lace IN ViewFeatures) THEN
            IF (High <> StdScreenHeight) THEN
               Height  := Max(MinHigh, Min(High, 2*ScreenHeight));
               TopEdge := Max(0,       Min(Top,  2*ScreenHeight - MinHigh));
            ELSE
               Height  := 2*ScreenHeight;
               TopEdge := 0;
            END; (* IF High *)
         ELSE
            IF (High <> StdScreenHeight) THEN
               Height  := Max(MinHigh, Min(High, ScreenHeight));
               TopEdge := Max(0,       Min(Top,  ScreenHeight - MinHigh));
            ELSE
               Height  := ScreenHeight;
               TopEdge := 0;
            END; (* IF High *)
         END; (* IF Lace *)


                         (* # of bitplanes desired/required *)

         IF (DualPF IN ViewFeatures) THEN      (* dual-playfield mode      *)
            Depth := Min (6, Max(0, Bitplanes));
         ELSIF (HAM IN ViewFeatures) THEN      (* hold-and-modify mode     *)
            Depth := 6;
         ELSIF (ExtraHalfBright IN ViewFeatures) THEN
            Depth := 6;                        (* extra-half-bright mode   *)
         ELSE
            Depth := Min (5, Max (0, Bitplanes)); (* normal mode           *)
         END; (* IF DualPF *)

         ViewModes    := ViewFeatures;
         Type         := ScreenFeatures;
         DetailPen    := BYTE(TextPen);
         BlockPen     := BYTE(FillPen);
         Font         := NULL;                 (* use system font          *)
         Gadgets      := NULL;                 (* no gadget list to add    *)
         CustomBitMap := ScreenBitMap;         (* initially NULL           *)

         IF (Compare(ScreenTitle, NoTitle) = Equal) THEN
            DefaultTitle := ADR(ScreenTitle);
         ELSE
            DefaultTitle := ADR(ScreenTitle);  (* render Screen title      *)
         END; (* IF Compare *)

      END; (* WITH UserScreen^ *)

      TempScreen := OpenScreen (UserScreen);
      DISPOSE (UserScreen);                (* replaced by Screen structure *)
      RETURN TempScreen;

   END CreateScreen;

   
(***************************************************************************)
(*                                                                         *)
(*    This procedure opens a Window with a minimum of fuss while allowing  *)
(* the user easy access to the fields of the NewWindow structure. Several  *)
(* checks are made to insure that illegal parameter values are not handed  *)
(* to the Amiga. The procedure returns a pointer to the desired Window ex- *)
(* cept when OpenWindow fails, in which case it will return a NULL pointer.*)
(*    The procedure "OpenGraphics" must be called prior to invoking        *)
(* this procedure, in order to open certain libraries & initialize certain *)
(* variables.                                                              *)
(*                                                                         *)
(*    The following parameters are required as inputs:                     *)
(*                                                                         *)
(*     Left - (INTEGER) the leftmost pixel-position of the Window;         *)
(*     Top  - (INTEGER) the topmost  pixel-position of the Window;         *)
(*     Wide - (INTEGER) the width  of the Window;                          *)
(*     High - (INTEGER) the height of the Window;                          *)
(*                                                                         *)
(*  WindowTitle - (String) title of the Window; if this equals the defined *)
(*                constant "NoTitle", then no title will be rendered;      *)
(*  UserScreen  - (ScreenPtr) pointer to the Screen in which the Window    *)
(*                will be opened; if this is set to NULL, then the Window  *)
(*                will be opened in the WorkBench Screen.                  *)
(*                                                                         *)
(*                                                                         *)
(*    The following relationships hold among the first four parameters:    *)
(*                                                                         *)
(*                 0    <=  Left  <=  Screen width  -  MinWide;            *)
(*                 0    <=  Top   <=  Screen height -  MinHigh;            *)
(*              MinWide <=  Wide  <=  Screen width  -  Left;               *)
(*              MinHigh <=  High  <=  Screen height -  Top.                *)
(*                                                                         *)
(*         MinWide and MinHigh are global constants defined above.         *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE CreateWindow (Left, Top, Wide, High : INTEGER;
                           VAR WindowTitle       : String;
                           UserScreen            : ScreenPtr) : WindowPtr;
                         
   VAR
      UserWindow    : NewWindow;

   BEGIN

      IF (UserScreen <> NULL) THEN      (* make sure Window fits in Screen *)
         Left := Max(0,       Min(Left, UserScreen^.Width  - MinWide));
         Wide := Max(MinWide, Min(Wide, UserScreen^.Width  - Left));
         Top  := Max(0,       Min(Top,  UserScreen^.Height - MinHigh));
         High := Max(MinHigh, Min(High, UserScreen^.Height - Top));
      ELSE                           (* make sure Window fits in WorkBench *)
         Left := Max(0,       Min(Left, 640 - MinWide));
         Wide := Max(MinWide, Min(Wide, 640 - Left));
         Top  := Max(0,       Min(Top,  ScreenHeight - MinHigh));
         High := Max(MinHigh, Min(High, ScreenHeight - Top));
      END; (* IF UserScreen *)

      MinWindowWide := Max(0, Min(1024, MinWindowWide)); (* limits to which   *)
      MinWindowHigh := Max(0, Min(1024, MinWindowHigh)); (* Window may be     *)
      MaxWindowWide := Max(0, Min(1024, MaxWindowWide)); (* sized with sizing *)
      MaxWindowHigh := Max(0, Min(1024, MaxWindowHigh)); (* gadget;           *)

      WITH UserWindow DO                 (* Initialize NewWindow structure *)

         LeftEdge   := Left;
         TopEdge    := Top;              (* location & size of Window      *)
         Width      := Wide;
         Height     := High;
         DetailPen  := BYTE (TextPen);   (* pen for Window's text          *)
         BlockPen   := BYTE (FillPen);   (* pen for Window's background    *)
         Flags      := WindowFeatures;   (* Window type, gadgets, etc.     *)
         IDCMPFlags := IDCMPFeatures;    (* Intuition messages received    *)
         CheckMark  := NULL;             (* <> NULL --> use your checkmark *)

         IF (Compare(WindowTitle, NoTitle) = Equal) THEN
            Title   := NULL;
         ELSE
            Title   := ADR(WindowTitle); (* render Window title            *)
         END; (* IF Compare *)

         IF (UserScreen <> NULL) THEN    (* use user-opened Screen         *)
            Type := CustomScreen;
         ELSE                            (* use WorkBench Screen           *)
            Type := ScreenFlagSet{WBenchScreen};
         END; (* IF UserWindow *)

         FirstGadget := NULL;            (* user-created gadget-list       *)
         BitMap      := WindowBitMap;    (* <> NULL --> user-managed bitmap*)
         MinWidth    := MinWindowWide;
         MinHeight   := MinWindowHigh;   (* limits to which Window can be  *)
         MaxWidth    := MaxWindowWide;   (* sized if size gadget attached  *)
         MaxHeight   := MaxWindowHigh;
         Screen      := UserScreen;      (* Window appears in this Screen  *)

      END; (* WITH UserWindow *)

      RETURN OpenWindow (UserWindow);
   END CreateWindow;
   
   
(***************************************************************************)
(*                                                                         *)
(*    This procedure closes the Intuition & Graphics libraries which were  *)
(* opened by the OpenGraphics procedure. Since GraphicsBase and Intuition- *)
(* Base were assigned by this module, they must also be closed by this     *)
(* module. Any attempt by the user to close these libraries using her/his  *)
(* own GraphicsBase and IntuitionBase won't work, since the bases she/he   *)
(* imports will be different variables. UserIntuiBase & UserGraphBase gives*)
(* user access to these addresses, if she/he requires.                     *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE CloseGraphics ();
   
   BEGIN
      CloseLibrary (GraphicsBase );  (* Close libraries in the  *)
      CloseLibrary (IntuitionBase ); (* order they were opened  *) 
   END CloseGraphics;



BEGIN

   InitStringModule;
                               (* default # of lines in non-interlaced     *)
   ScreenHeight := 200;        (* display; it's reassigned in CreateScreen *)

END WindowTools.
