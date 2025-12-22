PROGRAM MiniView;

{  ======================================================================== }
{  = Programmname    : MiniView V1.0                                      = }
{  =                                                                      = }
{  ======================================================================== }
{  = Author/Copyright : (c) 1994 by Andreas Neumann                       = }
{  =                   based on Andreas R.Kleinert's SimpleView 7.1       = }
{  =                   Freeware. All rights reserved.                     = }
{  =                                                                      = }
{  =                   Use it as an example for programming               = }
{  =                   superview.library !                                = }
{  =                                                                      = }
{  ======================================================================== }
{  = Function         : SVObject operations :                             = }
{  =                    - Show graphics          (all SVObjects)          = }
{  ======================================================================== }
{  = Last Update      : 24.11.1994                                        = }
{  =                                                                      = }
{  ======================================================================== }
{  = Remarks          : Needs "superview.library" V6+                     = }
{  =                                                                      = }
{  =                    CLI only                                          = }
{  =                                                                      = }
{  ======================================================================== }
{  = Compiler         : PCQ 1.2d                                          = }
{  ======================================================================== }


{$I "Include:exec/memory.i" }

{$I "include:intuition/intuitionbase.i" } {  accessing IntuitionBase->FirstScreen }

{$I "include:sv/superview/WurzelSuperView.i" }
{$I "include:sv/superview/superviewbase.i" }

{$I "Include:Utils/Stringlib.i" }
{$I "Include:Utils/Parameters.i" }

   {  Help- and Info- Texts }

CONST
 entry1_text  : String = "\n \c31;32;40m                    MiniView V1.0\c30;32;40m \c33;32;40m (FREEWARE) \c30;32;40m \n(c) 1994 by Andreas Neumann based on a Andreas Ralph Kleinert program.";
 entry2_text  : String = "\c30;31;40m \nAndreas Neumann, c/o Schnitzler,  Espenhausen 3, 35091 Cölbe, Germany.\nAndreas R. Kleinert,  Grube Hohe Grethe 23,  D-57074 Siegen,  Germany.\n";
 entry3_text  : String = "            Uses superview.library to show a picture.\n";
 entry4_text  : String = "              USAGE : \"\c30;33;40mMiniView\c30;31;40m [?] [PicFileName]\"\n";
 entry5_text  : String = "                       '?'    -> This text.\n";


 ver_text : String = "\0$VER: MiniView V1.0 (24.11.94)";


{  *************************************************** }
{  *                                                 * }
{  * Error-Messages for Leave() and KF_Message()     * }
{  *                                                 * }
{  *************************************************** }

 svlib_text :  String = "You need \42superview.library\42 V6+ !";
 svstr_text :  String = "Error allocating string !";


VAR
    filename    :   String;
    myIBase     :   IntuitionBasePtr;
    PPBase      :   Address;


PROCEDURE SimpleView_Show (name : String);

{  *************************************************** }
{  *                                                 * }
{  * Show-Function                                   * }
{  *                                                 * }
{  *************************************************** }

VAR
    handle  :   Address;
    win     :   WindowPtr;
    retval  :   INTEGER;

BEGIN

 handle:=SVL_AllocHandle(NIL);
 IF handle<>NIL THEN
 BEGIN
  retval:=SVL_InitHandleAsDOS(handle, NIL);
  IF retval=0 THEN
  BEGIN
   retval:=SVL_SetWindowIDCMP(handle, MOUSEBUTTONS_f, NIL);
   IF retval=0 THEN
   BEGIN
    retval:=SVL_SetScreenType(handle, CUSTOMSCREEN_f, NIL);
    IF retval=0 THEN
    BEGIN
     retval:=SVL_SuperView(handle, name);
     IF retval=0 THEN
     BEGIN
      retval:=SVL_GetWindowAddress(handle, Adr(win), NIL);
      IF retval=0 THEN
      BEGIN
       IF win<>NIL THEN
       BEGIN
        WaitPort(Address(win^.UserPort));
       END;
      END;
     END;
    END;
   END;
  END;
  SVL_FreeHandle(handle);
 END
 ELSE
  retval:=SVERR_NO_HANDLE;

 IF retval<>0 THEN WRITELN (SVL_GetErrorString(retval));
END;


BEGIN
 filename:=AllocString (255);
 IF filename=NIL THEN
  Writeln (svstr_text)
 ELSE
 BEGIN
  GetParam (1,filename);
  IF StrICmp (filename,"?")=0 THEN
   Writeln (entry1_text,entry2_text,entry3_text,entry4_text,entry5_text)
  ELSE
  BEGIN

   SuperViewBase:=Address(OpenLibrary("superview.library", 6));
   IF (SuperViewBase=Nil) THEN
    Writeln (svlib_text)
   ELSE
   BEGIN

    myIBase:=SuperViewBase^.svb_IntuitionBase;

    {  ^ if NULL, sv-lib wouldn't have opened ! }


    {  Show }

    IF StrLen(filename)>0 Then
     SimpleView_Show (filename);
    CloseLibrary (Address(SuperViewBase));
   END;
  END;
  FreeString (filename);
 END;
END.
