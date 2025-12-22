<*STANDARD-*>
MODULE WBStart;
(*
 * libraries/wbstart.h  V2.2
 *
 * shared library include file
 *
 * (c) 1991-1996 Stefan Becker
 *
 * OberonA Version By Morten Bjergstrøm
 * EMail: mbjergstroem@hotmail.com
 *)

IMPORT
  e:=Exec, u:=Utility, Kernel;

CONST
  NAME    * = "wbstart.library";
  VERSION * = 2;

(* Tags for WBStartTagList() *)

(* Name of the program to start. It is relative to      *)
(* directoryName or wbsDirLock.                         *)
  name            * = u.user + 1; (* const char *       *)

(* Name of a directory. Mutually exclusive to directoryLock  *)
  directoryName   * = u.user + 2; (* const char *       *)

(* Lock of a directory. Mutually exclusive to directoryName  *)
  directoryLock   * = u.user + 3; (* BPTR               *)

(* Stack size for the new process                       *)
  stack           * = u.user + 4; (* ULONG              *)

(* Priority for the new process                         *)
  priority        * = u.user + 5; (* LONG               *)

(* Number of arguments in argumentList                  *)
  argumentCount   * = u.user + 6; (* ULONG              *)

(* Array of arguments. argumentCount MUST be specified also! *)
  argumentList    * = u.user + 7; (* struct WBArg *     *)

VAR
  base -: e.LibraryPtr;

PROCEDURE WBStartTagList * [base,-30] (tags[8]  : u.TagListPtr): LONGINT;

PROCEDURE WBStartTags    * [base,-30] (tag1[8]..: u.Tag       ): LONGINT;



PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;

BEGIN
  base := e.OpenLibrary (NAME, VERSION);
  
  IF base # NIL THEN Kernel.SetCleanup (CloseLib) END;
END WBStart.
