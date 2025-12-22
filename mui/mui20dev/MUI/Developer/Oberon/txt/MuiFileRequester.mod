(*------------------------------------------

  :Module.      MuiFileRequester.mod
  :Author.      Albert Weinert  [awn]
  :Address.     Krähenweg 21 , 50829 Köln, Germany
  :EMail.       Usenet_> aweinert@darkness.gun.de
  :EMail.       Z-Netz_> A.WEINERT@DARKNESS.ZER
  :Phone.       0221 / 580 29 84
  :Revision.    $Revision: 1.1 $
  :Date.        $Date: 1993/09/15 17:29:00 $
  :Copyright.   Albert Weinert
  :Language.    Oberon-2
  :Translator.  Amiga Oberon 3.00d
  :Contents.    FileRequester die Mui anstatt die ASL Library benutzen
  :Imports.     MuiBasics.mod [awn], Mui.mod
  :Remarks.     Basiert auf FileReq.mod [fbs] welches dem Compiler beilag.
  :Bugs.        <Bekannte Fehler>
  :Usage.       <Angaben zur Anwendung>
  :RCSId.       $Id: MuiFileRequester.mod,v 1.1 1993/09/15 17:29:00 A_Weinert Exp $
  :History.     .0     [awn] 13-Sep-1993 : Erstellt
  $Log: MuiFileRequester.mod,v $
# Revision 1.1  1993/09/15  17:29:00  A_Weinert
# Initial revision
#
--------------------------------------------*)
MODULE MuiFileRequester;

IMPORT I   := Intuition,
       e   := Exec,
       Dos,
       Mui,
       mb  := MuiBasics,
       asl := ASL,
       u   := Utility,
       sys := SYSTEM;


(*------------------------------------------------------------------------*)


VAR
  fr: asl.FileRequesterPtr;
  pattern*: ARRAY 80 OF CHAR;
  defaultWidth  * ,
  defaultHeight * ,
  defaultLeft   * ,
  defaultTop    * : INTEGER;

(*------------------------------------------------------------------------*)


(****i* MuiFileRequester/Open ***********************************************
*
*   NAME
*       Open --
*
*   SYNOPSIS
*       Open( hail: ARRAY OF CHAR;
*             VAR name: ARRAY OF CHAR;
*             save, drawersonly: BOOLEAN;
*             window : Mui.Object ): BOOLEAN;
*
*   FUNCTION
*
*   INPUTS
*
*   RESULTS
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
*****************************************************************************
* 10 Jan 1994 - [awn] :
*       An die 40.16 Interfaces angepasst bei s : e.STRPTR -> e.LSTRPTR;
* 05 Dec 1993 - [awn] :
*        Erstellt
*
*)

PROCEDURE Open( hail: ARRAY OF CHAR;
                VAR name: ARRAY OF CHAR;
                save, drawersonly: BOOLEAN;
                window : Mui.Object ): BOOLEAN;

VAR
  i,j: INTEGER;
  Dirname: ARRAY 256 OF CHAR;
  Filename: ARRAY 64 OF CHAR;
  s : e.LSTRPTR;
  flags1: LONGSET;
  flags2: LONGSET;
  res: BOOLEAN;
  buf : CHAR;
  l,t,w,h: INTEGER;
  win : I.WindowPtr;

BEGIN
  (* $OddChk- *)
  s := Dos.FilePart( name );
  IF s # NIL THEN
    COPY( s^, Filename );
  ELSE
    Filename := "";
  END;
  s := Dos.PathPart( name );
  IF s # NIL THEN
    buf := s[0]; s[0] := CHR( 0 );
    COPY ( name, Dirname );
    s[0] := buf;
  ELSE
    Dirname := "";
  END;
  (* $OddChk= *)
  win := NIL;
  IF window # NIL THEN
    mb.Get( window, Mui.aWindow, win );
  END;

  IF fr=NIL THEN
    l := defaultLeft;
    t := defaultTop;
    w := defaultWidth;
    h := defaultHeight;
    IF win#NIL THEN
      IF win.width  - 40 > w THEN l := win.leftEdge + 20; w := win.width  - 40; IF w>320 THEN w := 320 END END;
      IF win.height - 40 > h THEN t := win.topEdge  + 20; h := win.height - 40 END;
    END;
    fr := Mui.AllocAslRequestTags(asl.fileRequest,
                                  asl.initialLeftEdge,l,
                                  asl.initialTopEdge, t,
                                  asl.initialWidth,   w,
                                  asl.initialHeight,  h,
                                  u.done);
    IF fr=NIL THEN HALT(20) END;
  END;
  
  flags1 := LONGSET{ asl.frDoPatterns };
  flags2 := LONGSET{ };
  IF save THEN INCL( flags1, asl.frDoSaveMode ) END;
  IF drawersonly THEN INCL( flags2, asl.frDrawersOnly ) END;

  IF window # NIL THEN
    mb.Set( window, Mui.aWindowSleep, e.true );
  END;

  res := Mui.AslRequestTags(fr,
                            asl.titleText,      sys.ADR(hail),
                            asl.initialFile,    sys.ADR(Filename),
                            asl.initialDrawer,  sys.ADR(Dirname),
                            asl.window,   win,
                            asl.initialPattern,  sys.ADR(pattern),
                            asl.flags1, flags1,
                            asl.flags2, flags2,
                            u.done);
  IF window # NIL THEN
    mb.Set( window, Mui.aWindowSleep, e.false );
  END;

  (* $OddChk- *)
  COPY(fr.dir^,Dirname);
  (* $OddChk= *)

  defaultLeft   := fr.leftEdge;
  defaultTop    := fr.topEdge;
  defaultHeight := fr.height;
  defaultWidth  := fr.width;

  IF ~ res THEN
    RETURN FALSE;
  ELSE
    COPY( Dirname, name );
    IF fr.file # NIL THEN
     (* $OddChk- *)
      RETURN Dos.AddPart( name, fr.file^, LEN( name ) );
     (* $OddChk= *)
    ELSE
      RETURN TRUE;
    END;
  END;

END Open;


(*------------------------------------------------------------------------*)


(****** MuiFileRequester/OpenForSave ****************************************
*
*   NAME
*       OpenForSave -- Öffnet FileRequester zum Speichern von Dateien
*
*   SYNOPSIS
*       OpenForSave*( hail: ARRAY OF CHAR;
*                     VAR name: ARRAY OF CHAR;
*                     win:  Mui.Object ): BOOLEAN;
*
*   FUNCTION
*
*   INPUTS
*
*   RESULTS
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
*****************************************************************************
* 05 Dec 1993 - [awn] :
*        Erstellt
*
*)

PROCEDURE OpenForSave*( hail: ARRAY OF CHAR;
                        VAR name: ARRAY OF CHAR;
                        win:  Mui.Object ): BOOLEAN;

(* öffnet ARP/ASL-FileRequester zum Speichern. Ergebnis ist FALSE wenn CANCEL
 * gedrückt wurde oder der gewählte name zu lang ist.
 * Beispiel: IF FileReqWinSave("Save File:",name,mywin) THEN Save(name) END;
 *)

BEGIN RETURN Open( hail, name, TRUE, FALSE, win) END OpenForSave;



(****** MuiFileRequester/OpenForLoad ****************************************
*
*   NAME
*       OpenForLoad -- Öffnet FileRequester zum Laden von Dateien
*
*   SYNOPSIS
*       OpenForLoad*( hail: ARRAY OF CHAR;
*                     VAR name: ARRAY OF CHAR;
*                     win:  Mui.Object ): BOOLEAN;
*
*   FUNCTION
*
*   INPUTS
*
*   RESULTS
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
*****************************************************************************
* 05 Dec 1993 - [awn] :
*        Erstellt
*
*)

PROCEDURE OpenForLoad*( hail: ARRAY OF CHAR;
                        VAR name: ARRAY OF CHAR;
                        win:  Mui.Object ): BOOLEAN;

(* öffnet ARP/ASL-FileRequester zum Laden. Ergebnis ist FALSE wenn CANCEL
 * gedrückt wurde oder der gewählte name zu lang ist.
 * Beispiel: IF FileReqWin("Load File:",name,mywin) THEN Load(name) END;
 *)

BEGIN RETURN Open( hail, name, FALSE, FALSE, win) END OpenForLoad;

PROCEDURE OpenForDrawer*( hail: ARRAY OF CHAR;
                        VAR name: ARRAY OF CHAR;
                        win:  Mui.Object ): BOOLEAN;

(* öffnet ARP/ASL-FileRequester zum Laden. Ergebnis ist FALSE wenn CANCEL
 * gedrückt wurde oder der gewählte name zu lang ist.
 * Beispiel: IF FileReqWin("Load File:",name,mywin) THEN Load(name) END;
 *)

BEGIN RETURN Open( hail, name, FALSE, TRUE, win) END OpenForDrawer;

BEGIN

  defaultTop   := 20;
  defaultLeft  := 20;
  defaultWidth := 300;
  defaultHeight:= 180;

  pattern := "~(#?.info)";

CLOSE

  IF fr # NIL THEN Mui.FreeAslRequest(fr)  END;

END MuiFileRequester.
