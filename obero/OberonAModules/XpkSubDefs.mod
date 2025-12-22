(*************************************************************************

:Program.    XpkSubDefs.mod
:Contents.   structur definitions for XpkSub libraries
:Author.     Hartmut Goebel
:Copyright.  Copyright © 1991 by Hartmut Goebel
:Copyright.  May be free dirstibuted with the Xpk-Package
:Copyright.  permission is given to be inlcuded with AmigaOberon
:Language.   Oberon
:Translator. Amiga Oberon V2.14
:History.    V0.9, 11 Jan 1992 Hartmut Goebel [hG]
:History.    V1.1, 27 Jul 1992 [hG]
:History.    V2.0  04 Aug 1992 [hG] adapted to Xpk 2.0
:History     Converted to Oberon-A by Morten Bjergstrøm 16/8/98
:Date.       04 Aug 1992 01:33:36
:EMail.      mbjergstroem@hotmail.com

*************************************************************************)
(*
 * Remark
 * Since the sub libraries need the definitions, but not the
 * calls, I decided to split the two parts for reasons of efficiency
 * [hG]
 *)

<*MAIN-*>
<*STANDARD-*>
MODULE [2] XpkSubDefs;


IMPORT
  e := Exec,
  x := XpkMaster;

(**************************************************************************
 *
 *                     The XpkInfo structure
 *
 *)

(* Sublibs return this structure to xpkmaster when asked nicely
 * This is version 1 of XpkInfo.  It's not #define'd because we don't want
 * it changing automatically with recompiles - you've got to actually update
 * your code when it changes.
 *)
TYPE
  XpkInfoPtr * = POINTER TO XpkInfo;
  XpkInfo * = RECORD
    xpkInfoVersion * : INTEGER       ; (* Version number of this structure   *)
    libVersion    * : INTEGER        ; (* The version of this sublibrary     *)
    masterVersion * : INTEGER        ; (* The required master lib version    *)
    modesVersion  * : INTEGER;       ; (* Version number of mode descriptors *)
    name        * : e.STRPTR         ; (* Brief name of the packer           *)
    longName    * : e.STRPTR         ; (* Full name of the packer            *)
    description * : e.STRPTR         ; (* Short packer desc., 70 char max    *)
    id    * : LONGINT                ; (* ID the packer goes by (XPK format) *)
    flags * : SET                    ; (* Defines see x.XpkPackerInfo.flags  *)
    maxPkInChunk * : LONGINT         ; (* Max input chunk size for packing   *)
    minPkInChunk * : LONGINT         ; (* Min input chunk size for packing   *)
    defPkInChunk * : LONGINT         ; (* Default packing chunk size         *)
    packMsg   * : e.STRPTR           ; (* Packing message, present tense     *)
    unpackMsg * : e.STRPTR           ; (* Unpacking message, present tense   *)
    packedMsg * : e.STRPTR           ; (* Packing message, past tense        *)
    unpackedMsg * : e.STRPTR         ; (* Unpacking message, past tense      *)
    defModes * : INTEGER             ; (* Default mode number                *)
    pad      * : INTEGER             ; (* for future use                     *)
    modeDesc * : x.XpkModePtr        ; (* List of individual descriptors     *)
    reserved * : ARRAY 6 OF e.ADDRESS; (* Future expansion - set to zero     *)
  END;


(**************************************************************************
 *
 *                     The XpkSubParams structure
 *
 *)
TYPE
  XpkSubParamsPtr * = POINTER TO XpkSubParams;
  XpkSubParams * = RECORD
    inBuf  * : e.APTR            ; (* The input data               *)
    inLen  * : LONGINT           ; (* The number of bytes to pack  *)
    outBuf * : e.APTR            ; (* The output buffer            *)
    outBufLen * : LONGINT        ; (* The length of the output buf *)
    outLen * : LONGINT           ; (* Number of bytes written      *)
    flags  * : SET               ; (* Flags for master/sub comm.   *)
    number * : LONGINT           ; (* The number of this chunk     *)
    mode   * : LONGINT           ; (* The packing mode to use      *)
    password * : e.APTR          ; (* The password to use          *)
    arg * : ARRAY 4 OF e.ADDRESS ; (* Reserved; don't use          *)
    sub * : ARRAY 4 OF e.ADDRESS ; (* Sublib private data          *)
  END;

CONST
  (* defines for XpkSubParams.flags *)
  stepDown    * = 1;    (* May reduce pack eff. to save mem   *)
  prevChunk   * = 2;    (* Previous chunk available on unpack *)

END XpkSubDefs.

