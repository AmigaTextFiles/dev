(*
 * VERY Incomplete.
 *
 * Only an Example for Using MuiBasics.PopupBegin() and
 * MuiBasics.PopupEnd and Hooks.
 *
 *
 *
 *)


MODULE  StickNote;

IMPORT
  Mui,
  mb := MuiBasics,
  Exec,
  u := Utility,
  l := StickNoteLocale,
  v := StickNoteVersion,
  y := SYSTEM,
  I := Intuition,
  Strings,
  Dos;


CONST
 id      = 8000;
 idAbout = id+1;

CONST
  idMainWin = y.VAL(LONGINT, 'MAIN' );

TYPE  s2 = ARRAY 2 OF Exec.STRPTR;
      dumhook = PROCEDURE ( hook : u.HookPtr; object : Exec.APTR; message : Exec.APTR ) : LONGINT;
CONST
  cs = s2( y.ADR( "FooBar" ), NIL );

VAR window, app : Mui.Object;
    btfirst, btnext, btprev, btlast, btok, btdel, btnew, btshow : Mui.Object;
    sttitle, stnote, btpopuptitle : Mui.Object;

    cbshow : Mui.Object;

    dum : Mui.Object;
    signals : LONGSET;
    running : BOOLEAN;

    activateHook, pressedHook : mb.Hook;

  PROCEDURE KeyButton( num : LONGINT ): Mui.Object;
    VAR pos : LONGINT;
        s : ARRAY 64 OF CHAR;
        key : CHAR;
    BEGIN
      COPY( l.GetString( num )^, s );
      pos := Strings.Occurs( s, "_" );
      IF pos = -1 THEN
        key := "\o";
      ELSE
        Strings.Delete( s, pos, 1 );
        key := u.ToLower( s[pos] );
      END;

      RETURN mb.KeyButton( s, key );
    END KeyButton;

  PROCEDURE KeyCheckMark( num : LONGINT; checked : Exec.LONGBOOL ): Mui.Object;
    VAR pos : LONGINT;
        s : ARRAY 64 OF CHAR;
        key : CHAR;
    BEGIN
      COPY( l.GetString( num )^, s );
      pos := Strings.Occurs( s, "_" );
      IF pos = -1 THEN
        key := "\o";
      ELSE
        Strings.Delete( s, pos, 1 );
        key := u.ToLower( s[pos] );
      END;

      mb.keyLabel1( s, key );
      mb.Child; RETURN mb.KeyCheckMark( checked, key );
    END KeyCheckMark;

  PROCEDURE KeyLabelString( num : LONGINT): Mui.Object;
    VAR pos : LONGINT;
        s : ARRAY 64 OF CHAR;
        key : CHAR;
    BEGIN
      COPY( l.GetString( num )^, s );
      pos := Strings.Occurs( s, "_" );
      IF pos = -1 THEN
        key := "\o";
      ELSE
        Strings.Delete( s, pos, 1 );
        key := u.ToLower( s[pos] );
      END;

        mb.keyLabel2( s, key );
        mb.Child; mb.StringObject;
                       mb.StringFrame;
                       mb.TagItem( Mui.aControlChar, ORD( key ) );
                  RETURN mb.End();
    END KeyLabelString;

  PROCEDURE KeyLabel( num, what : LONGINT );
    VAR pos : LONGINT;
        s : ARRAY 64 OF CHAR;
        key : CHAR;
    BEGIN
      COPY( l.GetString( num )^, s );
      pos := Strings.Occurs( s, "_" );
      IF pos = -1 THEN
        key := "\o";
      ELSE
        Strings.Delete( s, pos, 1 );
        key := u.ToLower( s[pos] );
      END;
      CASE what OF
       | 0 : mb.keyLabel( s, key );
       | 1 : mb.keyLabel1( s, key );
       | 2 : mb.keyLabel2( s, key );
      ELSE HALT (20) END;
    END KeyLabel;

  PROCEDURE PopupString( num : LONGINT; hook : mb.Hook; img : LONGINT): Mui.Object;
    VAR pos : LONGINT;
        s : ARRAY 64 OF CHAR;
        key : CHAR;
        str : Mui.Object;
    BEGIN
      COPY( l.GetString( num )^, s );
      pos := Strings.Occurs( s, "_" );
      IF pos = -1 THEN
         key := "\o";
      ELSE;
         key := u.ToLower( s[pos+1] );
      END;
      mb.PopupBegin;
         mb.Child; mb.StringObject;
                      mb.StringFrame;
                      mb.TagItem( Mui.aControlChar, ORD ( key ) );
                   str := mb.End();
      mb.popupEnd( hook, img, str );
      RETURN str;
    END PopupString;

  PROCEDURE PressedObject( hook : mb.Hook; obj : Mui.Object ; args : mb.Args) : LONGINT;
    BEGIN
      Dos.PrintF(" Yeah! You pressed the Popup Object\n" );
      RETURN 0;
    END PressedObject;

  PROCEDURE CreateApplication();
  (*------------------------------------------
    :Input.
    :Output.
    :Semantic.  Erstellt das Application Objekt und alle
    :Semantic.  dazugehörigen Fenster die zum bedienen das Programms gehören
    :Note.      Es werden nicht die Fenster IN denen die Notizn stehen generiert.
    :Update.    22-Aug-1993 [awn] - erstellt.
  --------------------------------------------*)
    BEGIN
      mb.ApplicationObject( Mui.aApplicationTitle      , y.ADR(v.name),
                            Mui.aApplicationVersion    , y.ADR(v.ver),
                            Mui.aApplicationCopyright  , y.ADR("© 1993 BY Albert Weinert"),
                            Mui.aApplicationAuthor     , y.ADR("Albert Weinert"),
                            Mui.aApplicationDescription, l.GetString( l.msgDescription ),
                            Mui.aApplicationBase       , y.ADR("STICKNOTE"),
                            u.end );
        mb.SubWindow; mb.WindowObject( Mui.aWindowTitle, y.ADR( v.nameVer ),
                                       Mui.aWindowID   , idMainWin,
                                       u.end );
                        mb.WindowContents; mb.VGroup;
                                              mb.Child; mb.ColGroup( 2 );
                                                          mb.GroupFrameT( l.GetString( l.frameNotes )^ );

                                                              mb.Child; KeyLabel( l.gadTitle, 2 );
                                                              mb.Child; mb.HGroup;
                                                                          pressedHook:=mb.MakeHook ( PressedObject );
                                                                          mb.Child; sttitle := PopupString( l.gadTitle, pressedHook, Mui.iPopUp );
                                                                          btpopuptitle := mb.GetHookObject( pressedHook );
                                                                          mb.Child; cbshow := KeyCheckMark( l.gadShow, Exec.true );
                                                                        mb.end;

                                                          mb.Child; stnote := KeyLabelString( l.gadContent );
                                                        mb.end;
                                              mb.Child; mb.VSpace( 2 );
                                              mb.Child; mb.ColGroup( 4 );
                                                          mb.TagItem( Mui.aGroupSameSize, Exec.true );
                                                          mb.Child; btfirst := KeyButton( l.gadFirst);
                                                          mb.Child; btprev  := KeyButton( l.gadPrev );
                                                          mb.Child; btnext  := KeyButton( l.gadNext );
                                                          mb.Child; btlast  := KeyButton( l.gadLast );
                                                          mb.Child; btok    := KeyButton( l.gadOK );
                                                          mb.Child; btnew   := KeyButton( l.gadNew );
                                                          mb.Child; btdel   := KeyButton( l.gadRemove );
                                                          mb.Child; btshow  := KeyButton( l.gadShowNotes );
                                                        mb.end;
                                          mb.end;
                      window := mb.End();
        IF window = NIL THEN
          Dos.PrintF("Failed to create Window\n");
          HALT( 20 );
        END;

      app := mb.End();

      IF app = NIL THEN
        Dos.PrintF("Failed to create Application\n");
        Mui.DisposeObject( window ); window := NIL;
        HALT(20);
      END;
    END CreateApplication;

    TYPE  ObjectArg = STRUCT( d : mb.ArgsDesc );
              obj : Mui.Object;
          END;

  PROCEDURE ActivateObject( hook : mb.Hook; obj : Mui.Object ; args : mb.Args) : LONGINT;
  (*------------------------------------------
    :Input.     hook : Hook; obj : Object auf welches der Hook ausgeführt wurde
    :Input.     par : Parameter
    :Output.
    :Semantic.  Aktiviert das Object welches zuletzt aktiv war (z.B. String)
    :Note.      Wenn keins Aktiviert war, dann wird das Aktiviert was man
    :Note.      beim DOMethod-Aufruf übergeben hat.
    :Update.    22-Aug-1993 [awn] - erstellt.
  --------------------------------------------*)
  (* $StackChk- *)

    VAR actObj : Mui.Object;

    BEGIN
      mb.Get( obj, Mui.aWindowActiveObject, actObj );

      IF actObj = Mui.vWindowActiveObjectNone THEN
        mb.Set( obj, Mui.aWindowActiveObject, args(ObjectArg).obj );
      ELSIF actObj # args(ObjectArg).obj THEN
          mb.Set( obj, Mui.aWindowActiveObject, actObj );
      END;
      RETURN 0
    END ActivateObject;


BEGIN
  l.OpenCatalog( NIL, "" );
  CreateApplication;
  activateHook := mb.MakeHook( ActivateObject );

(* *)
  Mui.DoMethod( window, Mui.mWindowSetCycleChain,
                sttitle, btpopuptitle, stnote, cbshow,
                btfirst, btprev, btnext, btlast, btok, btnew, btdel, btshow, NIL );

(* Aktivieren des CloseGadgets, so das die entsprechende ID gesendet wird *);

  Mui.DoMethod( window, Mui.mNotify, Mui.aWindowCloseRequest, Exec.true,
                app, 2, Mui.mApplicationReturnID, Mui.vApplicationReturnIDQuit );


  Mui.DoMethod( sttitle, Mui.mNotify, Mui.aStringAcknowledge, Mui.vEveryTime,
                window , 3, Mui.mSet, Mui.aWindowActiveObject, stnote );

(* Installiere den Hook der wenn das Fenster aktiviert wird, das letze
   aktive Gadget aktiviert wenn keins aktiv war, dann soll das
   Popup Gadget aktiviert werden *)


  IF activateHook # NIL THEN
    Mui.DoMethod( window, Mui.mNotify, Mui.aWindowActivate, Exec.true,
                  window, 3, Mui.mCallHook, activateHook, btpopuptitle );
  END;

(* Öffnen das Hauptfenster *)

  mb.Set( window, Mui.aWindowOpen, Exec.true );

  running := TRUE ;
  WHILE running DO
    CASE Mui.DOMethod( app, Mui.mApplicationInput, y.ADR(signals), u.end ) OF
      | Mui.vApplicationReturnIDQuit :
          running := FALSE;
    ELSE END;
    IF (running) & (signals # LONGSET{}) THEN y.SETREG( 0, Exec.Wait(signals) ) END;
  END;

  mb.Set(window, Mui.aWindowOpen, Exec.false );

CLOSE
  IF app # NIL THEN
    Mui.DisposeObject( app );
  ELSE
    IF window # NIL THEN
      Mui.DisposeObject( window );
    END;
  END;
END StickNote.
