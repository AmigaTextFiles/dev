(*-------------------------------------------------------------------------*)
(*                                                                         *)
(*  Amiga Oberon Library Module: ToolManager          Date: 15-Apr-93      *)
(*                                                                         *)
(*   © 1992 by Martin Horneffer                                            *)
(*   © 1993 by Stefan Becker (updated for ToolManager 2.1)                 *)
(*                                                                         *)
(*  This  Module  may  freely  be copied and distributed, as long as it is *)
(*  left unchanged and kept together with "toolmanager.library",           *)
(*  © 1990-1993 Stefan Becker.                                             *)
(*                                                                         *)
(*-------------------------------------------------------------------------*)

MODULE ToolManager;

IMPORT u:Utility, Intuition, Exec;

CONST
  Name          * = "toolmanager.library";
  Version       * = 3;

CONST

  (* ToolManager Object Types *)

  typeExec *    = 0;
  typeImage *   = 1;
  typeSound *   = 2;
  typeMenu *    = 3;
  typeIcon *    = 4;
  typeDock *    = 5;
  typeAccess *  = 6;
  types *       = 7;

  (* ToolManager Object Properties (see Object.doc) *)

  (* Type: typeExec *)
  arguments *   = u.user +  1;
  command *     = u.user +  2; (* also used for typeSound *)
  currentDir *  = u.user +  3;
  delay *       = u.user +  4;
  execType *    = u.user +  5;
  hotKey *      = u.user +  6; (* also used for typeDock *)
  output *      = u.user +  7;
  path *        = u.user +  8;
  priority *    = u.user +  9;
  pubScreen *   = u.user + 10; (* also used for typeDock *)
  stack *       = u.user + 11;
  toFront *     = u.user + 12;

  (* Type: tyepImage *)
  file *        = u.user +  257;
  data *        = u.user +  258;

  (* Type: typeSound *)
  port *        = u.user +  513;

  (* Type: typeMenu, typeIcon *)
  exec *        = u.user +  769;
  sound *       = u.user +  770;

  (* Type: typeIcon *)
  image *       = u.user + 1025;
  showName *    = u.user + 1026;

  (* Type: typeIcon, typeDock *)
  leftEdge *    = u.user + 1281;
  topEdge *     = u.user + 1282;

  (* Type: typeDock *)
  activated *   = u.user + 1536;
  centered *    = u.user + 1537;
  columns *     = u.user + 1538;
  font *        = u.user + 1539;
  frontMost *   = u.user + 1540;
  menu *        = u.user + 1541;
  pattern *     = u.user + 1542;
  popup *       = u.user + 1543;
  text *        = u.user + 1544;
  title *       = u.user + 1545;
  tool *        = u.user + 1546;
  vertical *    = u.user + 1547;
  backdrop *    = u.user + 1548;
  sticky *      = u.user + 1549;

  (* Type: typeAccess *)
  (* None defined yet... *)

  (* Types for execType *)
  cli *         = 0;
  wb *          = 1;
  arexx *       = 2;
  dock *        = 3;
  hotkey *      = 4;
  network *     = 5;
  hook *        = 100;

TYPE

(* Data structures for storing image sequences (TMOBJTYPE_IMAGE/TMOP_Data) *)
(* TMImageNode contains the data for ONE picture. Several nodes are joined *)
(* into a single-linked chain via tmin_Next.                               *)

  ImageNodePtr * = UNTRACED POINTER TO ImageNode;
  ImageNode * = STRUCT
                  next * : ImageNodePtr; (* pointer to next node *)
                  data * : Exec.APTR;    (* MEMF_CHIP memory!!   *)
                END;

(* TMImageData contains information about the image data, like sizes etc.   *)
(* You MUST initialize BOTH Image structures and they MUST BE identical     *)
(* except of the ImageData pointer. tmid_Normal.ImageData should point to   *)
(* an image data which shows the inactive state and tmid_Selected.ImageData *)
(* should point to an image which shows the active state.                   *)

  ImageDataPtr * = UNTRACED POINTER TO ImageData;
  ImageData * = STRUCT
                  normal *   : Intuition.Image; (* inactive state  *)
                  selected * : Intuition.Image; (* active state    *)
                  data *     : ImageNodePtr;    (* chain of images *)
                END;

VAR
  base          * : Exec.LibraryPtr;


PROCEDURE QuitToolManager*{base,-36} ();

PROCEDURE AllocTMHandle*{base,-42} (): LONGINT;

PROCEDURE FreeTMHandle*{base,-48} (             handle{8}: LONGINT);

PROCEDURE CreateTMObjectTagList*{base,-54} (    handle{8}: LONGINT;
                                                name{9}  : ARRAY OF CHAR;
                                                type{0}  : LONGINT;
                                                tags{10}  : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE CreateTMObjectTags*{base,-54} (       handle{8}: LONGINT;
                                                name{9}  : ARRAY OF CHAR;
                                                type{0}  : LONGINT;
                                                tags{10}..: u.Tag): BOOLEAN;

PROCEDURE DeleteTMObject*{base,-60} (           handle{8}: LONGINT;
                                                object{9}: ARRAY OF CHAR): BOOLEAN;

PROCEDURE ChangeTMObjectTagList*{base,-66} (    handle{8}: LONGINT;
                                                object{9}: ARRAY OF CHAR;
                                                tags{10} : ARRAY OF u.TagItem ): BOOLEAN;
PROCEDURE ChangeTMObjectTags*{base,-66} (       handle{8}: LONGINT;
                                                object{9}: ARRAY OF CHAR;
                                                tags{10}..: u.Tag ): BOOLEAN;

BEGIN
  base := Exec.OpenLibrary( Name, Version);
  IF base=NIL THEN
    IF Intuition.DisplayAlert(0,"\x00\x64\x14missing toolmanager.library!\o\o",50) THEN END;
    HALT(20)
  END;
CLOSE
  IF base # NIL THEN Exec.CloseLibrary(base) END;
END ToolManager.
