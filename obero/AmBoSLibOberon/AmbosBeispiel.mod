(******************************************************************************)
(* Programmname    : AmbosBeispiel                                            *)
(* Programmversion : 1.000 (beta)                                             *)
(* Datum           : 16.01.1995                                               *)
(* Copyright       : 16.01.1995 (c) Andreas Leicht                            *)
(* Beschreibung    :                                                          *)
(*                 :                                                          *)
(* Autor           : Andreas Leicht                                           *)
(*                 : Seefahrerstr. 5                                          *)
(*                 : 27721 Ritterhude                                         *)
(* Telefon         : 0421 / 63 79 76                                          *)
(* EMail           : Andi@doom.gun.de                                         *)
(* Sprache         : Oberon 2                                                 *)
(* Compiler        : Amiga Oberon v3.20d                                      *)
(******************************************************************************)

(******************************************************************************)
(* Geschichte : v1.000 (Beta) - 16.01.1995 - AO v3.20d                        *)
(*            : Erste Umsetzung                                               *)
(******************************************************************************)

MODULE AmbosBeispiel;

IMPORT  amb :=  AmbosLibOberon,
        arg :=  Arguments,
        con :=  Conversions,
        sys :=  SYSTEM;

VAR
  ExternInfo:   amb.externInfoPtr;
  Argument:     ARRAY 255 OF CHAR;
  Menue1:       amb.bbsMenu;
  Menue2:       amb.bbsMenu;
  Menue3:       amb.bbsMenu;
  Menue4:       amb.bbsMenu;
  Id:           LONGINT;
  Zahl:         ARRAY 10 OF CHAR;
  BoolWert:     BOOLEAN;

BEGIN
  arg.GetArg(1,Argument);
  ExternInfo  := amb.Open(Argument);

  IF ExternInfo = NIL THEN
    HALT(0);
  END;

  amb.PrintF("\f\r\n\r\nHallo %s aus %s !\r\n\r\n",ExternInfo.userName,ExternInfo.city);
  amb.PutS("Das was ein PrintF-Demo\r\n\r\n\r\n\r\n");


  Menue1.next      := sys.ADR(Menue2);
  Menue1.name      := sys.ADR("_Hier");
  Menue1.menuID    := 10;
  Menue1.private1  := 0;
  Menue1.private2  := 0;

  Menue2.next      := sys.ADR(Menue3);
  Menue2.name      := sys.ADR("_kommt");
  Menue2.menuID    := 20;
  Menue2.private1  := 0;
  Menue2.private2  := 0;

  Menue3.next      := sys.ADR(Menue4);
  Menue3.name      := sys.ADR("_ein");
  Menue3.menuID    := 30;
  Menue3.private1  := 0;
  Menue3.private2  := 0;

  Menue4.next      := NIL;
  Menue4.name      := sys.ADR("_DemoMenü");
  Menue4.menuID    := 40;
  Menue4.private1  := 0;
  Menue4.private2  := 0;

  Id := amb.Menu(sys.ADR(Menue1));

  con.IntToStringLeft(Id,Zahl);
  amb.PutS("\r\n\r\nMenüID: ");
  amb.PutS(Zahl);
  amb.PutS("\r\n\r\n\r\n");

CLOSE
  IF ExternInfo#NIL THEN amb.Close() END;
END AmbosBeispiel.

