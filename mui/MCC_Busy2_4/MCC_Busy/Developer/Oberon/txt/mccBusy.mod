
(**********************************************************************
:Program.       mccBusy.mod
:Contents.      Oberon 2 Modul for Busy.mcc
:Contents.      Registered class of the Magic User Interface.
:Author.        Klaus Melchior [kmel]
:Email.         kmel@eifel.tng.oche.de
:Help.          Frank Duerring [fjd]    (Oberon Modul)
:Email.         fd@marvin.unterland.de
:Copyright.     Klaus Melchior [kmel]
:Language.      Oberon 2
:Translator.    AmigaOberon v3.20d
:History.       [kmel] 23-Jul-1997 : PrMake generates this
***********************************************************************)

MODULE mccBusy;

IMPORT Mui,
       MuiBasics,
       Utility,
       SYSTEM,
       Exec;


(*** Methods ***)

  CONST mBusyMove           * = 80020001H;


(*** Method structs ***)

  TYPE
  pBusyMovePtr * = POINTER TO pBusyMove;
  pBusyMove    * = STRUCT
    MethodID   * : LONGINT;
  END;


(*** Special method values ***)


(*** Special method flags ***)



(*** Attributes ***)

  CONST aBusyShowHideIH     * = 800200A9H;
  CONST aBusySpeed          * = 80020049H;


(*** Special attribute values ***)

  CONST vBusySpeedOff                   * =   0;
  CONST vBusySpeedUser                  * =  -1;



(*** Stuff ***)

  CONST cBusy * = "Busy.mcc";





VAR

  PROCEDURE mccBusyObject*{"mccBusy.mccBusyObjectA"} ( tags{9}.. : Utility.Tag);
  PROCEDURE mccBusyObjectA*( tags{9} : Utility.TagListPtr );
    BEGIN
      MuiBasics.NewObjectA( SYSTEM.ADR(cBusy), tags );
    END mccBusyObjectA;

(*** Macros ***)

  PROCEDURE BusyBar *;
    BEGIN
      mccBusyObject(aBusySpeed, vBusySpeedUser, Utility.end);
      MuiBasics.end;
    END BusyBar;

END mccBusy.

(* PrMake.rexx 0.10 (16.2.1996) Copyright 1995 kmel, Klaus Melchior *)

