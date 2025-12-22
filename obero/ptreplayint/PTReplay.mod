(* ==================================================================== *)

(*
******* PTReplay/--about-- *******
*
*    $RCSfile: PTReplay.mod $
*   $Revision: 1.3 $
*       $Date: 1995/09/19 17:14:11 $
*     $Author: phf $
*
* Description: AmigaOberon interface to ptreplay.library.
*
*   Copyright: Copyright (c) 1995 by Peter Fröhlich [phf].
*              All rights reserved.
*
*     License: This  file  is  freely distributable as long as no
*              money  is  made by distributing it.  If you modify
*              it   please  let  me  know.   You  may  distribute
*              modified versions as long as my original copyright
*              is  respected  and  your modifications are clearly
*              marked  as  such.   It  may  only  be used in non-
*              commercial projects.
*
*      e-mail: p.froehlich@amc.cube.net
*
*     $Source: Users:Homes/phf/Programming/Development/PTReplay/REPOSITORY/PTReplay.mod $
*
**************
*
**************
*)

(*
******* PTReplay/--history-- *******
*
* $Log: PTReplay.mod $
* Revision 1.3  1995/09/19  17:14:11  phf
* Corrected V6 functions, minor changes to Autodocs.
*
* Revision 1.2  1995/09/15  18:18:21  phf
* Adapted to ptreplay.library V6.
*
* Revision 1.1  1995/08/30  06:11:25  phf
* Initial revision
*
**************
*
**************
*)

(* ==================================================================== *)

MODULE PTReplay;

(* ==================================================================== *)

IMPORT E* := Exec, S := SYSTEM;

(* ==================================================================== *)

(*
******* PTReplay/--background-- *******
*
*   PURPOSE
*
*	This module provides an AmigaOberon interface to the
*	ptreplay.library by Mattias Karlsson / BetaSoft.
*
*   NOTES
*
*	Remember to check "base # NIL" before making any calls
*	to the library.
*
*   SEE ALSO
*
*	ptreplay.doc
*
*   REFERENCES
*
*	Aminet: mus/play/PTReplay#?.lha
*
**************
*
**************
*)

(* ==================================================================== *)

CONST
  ptReplayName* = "ptreplay.library";

TYPE
  ModulePtr* = UNTRACED POINTER TO Module;
  Module* = STRUCT
    modName-: E.LSTRPTR; (* "-" means read-only in Oberon-2 *)
    (* The rest is private for now, but more details may be released later. *)
  END;

TYPE
  SampleName* = ARRAY 22 OF CHAR;

  SamplePtr* = UNTRACED POINTER TO Sample;
  Sample* = STRUCT
    name-: SampleName;  (* Null terminated string with samplename *)
    length-: E.UWORD;   (* Sample length in words *)
    fineTune-: E.UBYTE; (* FineTune of sample in lower 4 bits *)
    volume-: E.UBYTE;   (* Volume of sample *)
    repeat-: E.UWORD;   (* Repeat start in number of words *)
    repLen-: E.UWORD;   (* Repeat length in number of words *)
  END;

VAR
  base-: E.LibraryPtr;

(* ==================================================================== *)

PROCEDURE LoadModule*   {base,- 30}(name{8}: ARRAY OF CHAR): ModulePtr;
PROCEDURE UnloadModule* {base,- 36}(module{8}: ModulePtr);
PROCEDURE Play*         {base,- 42}(module{8}: ModulePtr): LONGINT;
PROCEDURE Stop*         {base,- 48}(module{8}: ModulePtr): LONGINT;
PROCEDURE Pause*        {base,- 54}(module{8}: ModulePtr): LONGINT;
PROCEDURE Resume*       {base,- 60}(module{8}: ModulePtr): LONGINT;

(* New in V2 *)

PROCEDURE Fade*         {base,- 66}(module{8}: ModulePtr; speed{0}: E.UBYTE);

(* New in V3 *)

PROCEDURE SetVolume*    {base,- 72}(module{8}: ModulePtr; speed{0}: E.UBYTE);

(* New in V4 *)

PROCEDURE SongPos*      {base,- 78}(module{8}: ModulePtr): E.UBYTE;
PROCEDURE SongLen*      {base,- 84}(module{8}: ModulePtr): E.UBYTE;
PROCEDURE SongPattern*  {base,- 90}(module{8}: ModulePtr; position{0}: E.UWORD): E.UBYTE;
PROCEDURE PatternPos*   {base,- 96}(module{8}: ModulePtr): E.UBYTE;
PROCEDURE PatternData*  {base,-102}(module{8}: ModulePtr; pattern{0},row{1}: E.UBYTE): E.APTR;
PROCEDURE InstallBits*  {base,-108}(module{8}: ModulePtr; restart{0},nextPattern{1},nextRow{2},fade{3}: E.UBYTE);
PROCEDURE SetupMod*     {base,-114}(moduleFile{8}: E.APTR): ModulePtr;
PROCEDURE FreeMod*      {base,-120}(module{8}: ModulePtr);
PROCEDURE StartFade*    {base,-126}(module{8}: ModulePtr; speed{0}: E.UBYTE);

(* New in V5 *)

PROCEDURE OnChannel*    {base,-132}(module{8}: ModulePtr; channels{0}: LONGSET);
PROCEDURE OffChannel*   {base,-138}(module{8}: ModulePtr; channels{0}: LONGSET);
PROCEDURE SetPos*       {base,-144}(module{8}: ModulePtr; position{0}: E.UBYTE);
PROCEDURE SetPri*       {base,-150}(priority{0}: E.BYTE);
PROCEDURE GetPri*       {base,-156}(): E.BYTE;

(* New in V6 *)

PROCEDURE GetChannel*   {base,-162}(): E.UBYTE;
PROCEDURE GetSample*    {base,-168}(module{8}: ModulePtr; number{0}: E.UBYTE): SamplePtr;

(* ==================================================================== *)

BEGIN

  base := E.OpenLibrary (ptReplayName, 0);

CLOSE

  IF (base # NIL) THEN E.CloseLibrary (base) END;

END PTReplay.

(* ==================================================================== *)
