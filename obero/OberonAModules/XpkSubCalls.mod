(*************************************************************************

:Program.    XpkSubCalls.mod
:Contents.   Lib-Call-Interface-Module for XpkSub-libraries
:Author.     Hartmut Goebel
:Copyright.  Copyright © 1991 by Hartmut Goebel
:Copyright.  May be free dirstibuted with the Xpk-Package
:Copyright.  permission is given to be inlcuded with AmigaOberon
:Language.   Oberon
:Translator. Amiga Oberon V2.14
:History.    V0.9, 11 Jan 1992 Hartmut Goebel [hG]
:History.    V1.0, 04 Jun 1992 [hG]
:History     Converted to Oberon-A by Morten Bjergstrøm 16/8/98
:Date.       04 Jun 1992 09:32:10
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
MODULE [2] XpkSubCalls;

IMPORT
  e  := Exec,
  xs := XpkSubDefs;

VAR
  subBase * : e.LibraryPtr;

PROCEDURE XpksPackerInfo  * [subBase,-30](): xs.XpkInfoPtr;
PROCEDURE XpksPackChunk   * [subBase,-36](params[8]: xs.XpkSubParamsPtr): LONGINT;
PROCEDURE XpksPackFree    * [subBase,-42](params[8]: xs.XpkSubParamsPtr);
PROCEDURE XpksPackReset   * [subBase,-48](params[8]: xs.XpkSubParamsPtr): LONGINT;
PROCEDURE XpksUnpackChunk * [subBase,-54](params[8]: xs.XpkSubParamsPtr): LONGINT;
PROCEDURE XpksUnpackFree  * [subBase,-60](params[8]: xs.XpkSubParamsPtr);

END XpkSubCalls.

