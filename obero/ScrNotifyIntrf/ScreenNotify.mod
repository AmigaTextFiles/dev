(*------------------------------------------

  :Module.      ScreenNotify.mod
  :Author.      Albert Weinert  [awn]
  :Address.     Adamsstr. 83 , 51063 Köln, Germany
  :EMail.       a.weinert@darkness.gun.de
  :Phone.       +49-221-613100
  :Revision.    R.1
  :Date.        27-Mar-1995
  :Copyright.   Albert Weinert
  :Language.    Oberon-2
  :Translator.  AmigaOberon V3.20, Oberon-A 1.5
  :Contents.    Interface file for screennotify.library V1
  :Remarks.     Useable with AmigaOberon and Oberon-A
  :History.     .1     [awn] 27-Mar-1995 : Erstellt

--------------------------------------------*)

(* <*IF OberonA THEN*> $IF OberonA *)

(*
<* STANDARD- *> <* INITIALISE- *> <* MAIN- *>
<*$ CaseChk-  IndexChk- LongVars+ NilChk-  *>
<*$ RangeChk- StackChk- TypeChk-  OvflChk- *>

*)

(* <* ELSE *> $ELSE *)

(* $CaseChk-  $NilChk-  *)
(* $RangeChk- $StackChk- $TypeChk-  $OvflChk- *)

(* <*END*> $END *)

MODULE ScreenNotify;

IMPORT
  e := Exec,
  (* <*IF OberonA THEN*> $IF OberonA *)
  Kernel,
  (* <*END*> $END *)
  I := Intuition;

CONST
(* Name and version *)
  libName    *= "screennotify.library";
  libVersion *= 1;
  libMinimum *= 1;


TYPE

(* Message sent to clients *)

(* <*IF OberonA THEN*> $IF OberonA *)
  ScreenNotifyMessagePtr *= POINTER [2] TO ScreenNotifyMessage;
  ScreenNotifyMessage *= RECORD [2];
                           message * : e.Message;
(* <* ELSE *> $ELSE *)
  ScreenNotifyMessagePtr *= UNTRACED POINTER TO ScreenNotifyMessage;
  ScreenNotifyMessage *= STRUCT ( message*: e.Message );
(* <*END*> $END *)
                           type  - : LONGINT;
                           value - : e.APTR;
                         END;

CONST

(* Values for snm_Type *)
  typeCloseScreen   *= 0; (* CloseScreen() called, snm_Value contains *)
                          (* pointer to Screen structure              *)
  typePublicScreen  *= 1; (* PubScreenStatus() called to make screen  *)
                          (* public, snm_Value contains pointer to    *)
                          (* PubScreenNode structure                  *)
  typePrivateScreen *= 2; (* PubScreenStatus() called to make screen  *)
                          (* private, snm_Value contains pointer to   *)
                          (* PubScreenNode structure                  *)
  typeWorkbench     *= 3; (* snm_Value == FALSE (0): CloseWorkBench() *)
                          (* called, please close windows on WB       *)
                          (* snm_Value == TRUE  (1): OpenWorkBench()  *)
                          (* called, windows can be opened again      *)

TYPE
(* <*IF OberonA THEN*> $IF OberonA *)
  ScreenClient *= POINTER [2] TO RECORD [2] END;
(* <* ELSE *> $ELSE *)
  ScreenClient *= UNTRACED POINTER TO STRUCT END;
(* <*END*> $END *)

VAR
  base : e.LibraryPtr;

PROCEDURE AddCloseScreenClient *{base, -30} ( screen{8}  : I.ScreenPtr;
                                              msgPort{9} : e.MsgPortPtr;
                                              pri  {0}   : SHORTINT ): ScreenClient;
PROCEDURE RemCloseScreenClient *{base, -36} ( handle {8} : ScreenClient ): BOOLEAN;

PROCEDURE AddPubScreenClient   *{base, -42} ( msgPort{8} : e.MsgPortPtr;
                                              pri    {0} : SHORTINT ): ScreenClient;
PROCEDURE RemPubScreenClient   *{base, -48} ( handle {8} : ScreenClient ): BOOLEAN;

PROCEDURE AddWorkbenchClient   *{base, -54} ( msgPort{8} : e.MsgPortPtr;
                                              pri    {0} : SHORTINT ): ScreenClient;
PROCEDURE RemWorkbenchClient   *{base, -60} ( handle {8} :  ScreenClient ): BOOLEAN;

(* <*IF OberonA THEN*> $IF OberonA *)

(* <*$LongVars-*> *)

PROCEDURE* CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END;
END CloseLib;

BEGIN (* Dos *)
  base := e.OpenLibrary (libName, libMinimum);
  Kernel.SetCleanup (CloseLib)

(* <* ELSE *> $ELSE *)

BEGIN
  base :=  e.OpenLibrary(libName, libMinimum);

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

(* <*END*> $END *)
END ScreenNotify.
