(**********************************************************************
:Program.       mccMailtext.mod
:Contents.      Oberon 2 Modul for Mailtext.mcc
:Contents.      Registered class of the Magic User Interface.
:Author.        Olaf Peters [olf]
:Email.         olf@gmx.de
:Help.          Frank Duerring [fjd]    (Oberon Modul)
:Email.         fd@marvin.unterland.de
:Copyright.     Olaf Peters [olf]
:Language.      Oberon 2
:Translator.    AmigaOberon v3.20d
:History.       [fjd]  17 Mar 1996 : first beta release
***********************************************************************)

MODULE mccMailtext;

IMPORT Mui,
       MuiBasics,
       Utility,
       SYSTEM,
       Exec;

(*** MUI Defines ***)

CONST cMailtext * = "Mailtext.mcc";

(*** Attributes ***)

CONST aMailtextCopyToClip           * = 8057013CH;
CONST aMailtextActionEMail          * = 8057013AH; (* v19 [..G] *)
CONST aMailtextActionURL            * = 8057013BH; (* v18 [..G] *)
CONST aMailtextDisplayRaw           * = 80570139H; (* v18 [.SG] *)
CONST aMailtextForbidContextMenu    * = 80570136H; (* v18 [I..] *)
CONST aMailtextIncPercent           * = 80570103H; (* v10 [ISG] *)
CONST aMailtextQuoteChars           * = 80570107H; (* v10 [ISG] *)
CONST aMailtextText                 * = 80570105H; (* v10 [ISG] *)
CONST aMailtextWordwrap             * = 8057013DH; (* v18 [.SG] *)


VAR

  PROCEDURE mccMailtextObject*{"mccMailtext.mccMailtextObjectA"} ( tags{9}.. : Utility.Tag);
  PROCEDURE mccMailtextObjectA*( tags{9} : Utility.TagListPtr );
    BEGIN
      MuiBasics.NewObjectA( SYSTEM.ADR(cMailtext), tags );
    END mccMailtextObjectA;

END mccMailtext.

