(*(***********************************************************************

:Module.      Classface.mod
:Author.      Albert Weinert  [awn]
:Copyright.   Albert Weinert
:Copyright.   permission granted for inclusion into AmigaOberon library
:Contents.    Interface zur Classface Programmierung mit Amiga Oberon.
:Imports.     needs `Classface.o', assemble Classface.asm therefore
:History.     0.0   [awn] 13-Jun-1993 : Erstellt
:History.     0.1   [awn] 16-Jun-1993 : Makro-Umsetzungen und die ProcDefinition
:History.           mit Utility.InitHook() erstellt, bzw. definiert.
:History.     0.2   [hG]  06 Jul 1993 : an Oberon üblichen Stil angepasst.
:Histroy.     1.0   [hG] renamed to Classface, some optical clean up
:Histroy.     40.15 [hG] bumped version/revision
:Histroy.           further notes see Interfaces package ReadMe
:Version.     $VER: Classface.mod 40.15 (6.11.94) Oberon 3.5

***********************************************************************)*)

MODULE Classface;

(* $StackChk- $NilChk- $ReturnChk- $ClearVars- *)
(* $JOIN Classface.o *)

IMPORT
  e * := Exec,
  I * := Intuition,
  SYSTEM,
  u * := Utility;

TYPE
  ObjectPtr * = e.APTR;

(* the next three procedure should come from Intuition.mod,
** since they are defined in classes.h which is indegrated
** into Intuition.mod
*)

PROCEDURE InstData*(cl{8}: I.IClassPtr; o{9}: ObjectPtr): e.APTR;
BEGIN
  RETURN  (SYSTEM.VAL(LONGINT,o)+LONG(cl.instOffset));
END InstData;

PROCEDURE SizeOfInstance*(cl{8}: I.IClassPtr): LONGINT;
BEGIN
  RETURN cl.instOffset+cl.instSize+SIZE(I.Object);
END SizeOfInstance;

PROCEDURE OClass*(o{8}: I.ObjectPtr): I.IClassPtr;
BEGIN (* $RangeChk- *)
  o := SYSTEM.VAL(ObjectPtr,SYSTEM.VAL(LONGINT,o)-SIZE(I.Object));
  RETURN o.class; (* $RangeChk= *)
END OClass;

PROCEDURE CoerceMethodA  * {"_a_CoerceMethodA"} (cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}    : I.Msg): e.APTR;
PROCEDURE CoercemethodA  * {"_a_CoerceMethodA"} (cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}    : I.Msg);
PROCEDURE CoerceMethod   * {"_a_CoerceMethodA"} (cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}..  : u.Tag): e.APTR;
PROCEDURE Coercemethod   * {"_a_CoerceMethodA"} (cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}..  : u.Tag);
PROCEDURE DoMethodA      * {"_a_DoMethodA"}     (obj{10}   : ObjectPtr;
                                                 msg{9}    : I.Msg): e.APTR;
PROCEDURE DomethodA      * {"_a_DoMethodA"}     (obj{10}   : ObjectPtr;
                                                 msg{9}    : I.Msg);
PROCEDURE DoMethod       * {"_a_DoMethodA"}     (obj{10}   : ObjectPtr;
                                                 msg{9}..  : u.Tag): e.APTR;
PROCEDURE Domethod       * {"_a_DoMethodA"}     (obj{10}   : ObjectPtr;
                                                 msg{9}..  : u.Tag);
PROCEDURE DoSuperMethodA * {"_a_DoSuperMethodA"}(cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}    : I.Msg): e.APTR;
PROCEDURE DoSupermethodA * {"_a_DoSuperMethodA"}(cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}    : I.Msg);
PROCEDURE DoSuperMethod  * {"_a_DoSuperMethodA"}(cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}..  : u.Tag): e.APTR;
PROCEDURE DoSupermethod  * {"_a_DoSuperMethodA"}(cl{8}     : I.IClassPtr;
                                                 obj{10}   : ObjectPtr;
                                                 msg{9}..  : u.Tag);
PROCEDURE SetSuperAttrs  * {"_a_SetSuperAttrs"}  (cl{8}    : I.IClassPtr;
                                                  obj{10}  : ObjectPtr;
                                                  tags{9}..: u.Tag): e.APTR;
PROCEDURE SetSuperAttrsA * {"_a_SetSuperAttrs"}  (cl{8}    : I.IClassPtr;
                                                  obj{10}  : ObjectPtr;
                                                  tags{9}  : ARRAY OF u.TagItem): e.APTR;
END Classface.
