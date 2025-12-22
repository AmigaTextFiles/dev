(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Locale.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert, written by Kai Bolay,
**   revised and updated for V40 by hartmut Goebel
*)
*)

MODULE Locale;

IMPORT
  e * := Exec,
  d * := Dos,
  u * := Utility;

CONST
  localeName * = "locale.library";

(* constants for GetLocaleStr() *)
  day1    * = 1;      (* Sunday    *)
  day2    * = 2;      (* Monday    *)
  day3    * = 3;      (* Tuesday   *)
  day4    * = 4;      (* Wednesday *)
  day5    * = 5;      (* Thursday  *)
  day6    * = 6;      (* Friday    *)
  day7    * = 7;      (* Saturday  *)

  abDay1  * = 8;      (* Sun *)
  abDay2  * = 9;      (* Mon *)
  abDay3  * = 10;     (* Tue *)
  abDay4  * = 11;     (* Wed *)
  abDay5  * = 12;     (* Thu *)
  abDay6  * = 13;     (* Fri *)
  abDay7  * = 14;     (* Sat *)

  mon1    * = 15;     (* January   *)
  mon2    * = 16;     (* February  *)
  mon3    * = 17;     (* March     *)
  mon4    * = 18;     (* April     *)
  mon5    * = 19;     (* May       *)
  mon6    * = 20;     (* June      *)
  mon7    * = 21;     (* July      *)
  mon8    * = 22;     (* August    *)
  mon9    * = 23;     (* September *)
  mon10   * = 24;     (* October   *)
  mon11   * = 25;     (* November  *)
  mon12   * = 26;     (* December  *)

  abMon1  * = 27;     (* Jan    *)
  abMon2  * = 28;     (* Feb    *)
  abMon3  * = 29;     (* Mar    *)
  abMon4  * = 30;     (* Apr    *)
  abMon5  * = 31;     (* May    *)
  abMon6  * = 32;     (* Jun    *)
  abMon7  * = 33;     (* Jul    *)
  abMon8  * = 34;     (* Aug    *)
  abMon9  * = 35;     (* Sep    *)
  abMon10 * = 36;     (* Oct    *)
  abMon11 * = 37;     (* Nov    *)
  abMon12 * = 38;     (* Dec    *)

  yesStr  * = 39;     (* affirmative response for yes/no queries *)
  noStr   * = 40;     (* negative response for yes/no queries    *)

  amStr   * =  41;    (* AM                                      *)
  pmStr   * =  42;    (* PM                                      *)

  softHyphen * = 43;  (* soft hyphenation                        *)
  hardHyphen * = 44;  (* hard hyphenation                        *)

  openQuote  * = 45;  (* start of quoted block                   *)
  closeQuote * = 46;  (* end of quoted block                     *)

  yesterdaystr * = 47;  (* Yesterday *)
  todaystr     * = 48;  (* Today     *)
  tomorrowstr  * = 49;  (* Tomorrow  *)
  futurestr    * = 50;  (* Future    *)

  maxStrMsg  * = 51;  (* current number of defined strings *)


(*****************************************************************************)

TYPE
(* OpenLibrary("locale.library",0) returns a pointer to this structure *)

  LocaleBasePtr = UNTRACED POINTER TO LocaleBase;
  LocaleBase = STRUCT (libNode * : e.Library)
    sysPatches -:  BOOLEAN;   (* TRUE if locale installed its patches *)
  END;


(* This structure must only be allocated by locale.library and is READ-ONLY! *)
  LocalePtr * = UNTRACED POINTER TO Locale;
  Locale* = STRUCT
    localeName     - : e.LSTRPTR;            (* locale's name               *)
    languageName   - : e.LSTRPTR;            (* language of this locale     *)
    prefLanguages  - : ARRAY 10 OF e.LSTRPTR;(* preferred languages         *)
    flags          - : LONGSET;              (* always 0 for now            *)

    codeSet        - : LONGINT;              (* for now, always 0           *)
    countryCode    - : LONGINT;              (* user's country code         *)
    telephoneCode  - : LONGINT;              (* country's telephone code    *)
    gmtOffset      - : LONGINT;              (* minutes from GMT            *)
    measuringSystem- : SHORTINT;             (* what measuring system?      *)
    calendarType   - : SHORTINT;             (* what calendar type?         *)
    reserved0      - : ARRAY 2 OF SHORTINT;

    dateTimeFormat - : e.LSTRPTR;            (* regular date & time format  *)
    dateFormat     - : e.LSTRPTR;            (* date format by itself       *)
    timeFormat     - : e.LSTRPTR;            (* time format by itself       *)

    shortDateTimeFormat  - : e.LSTRPTR;      (* short date & time format    *)
    shortDateFormat      - : e.LSTRPTR;      (* short date format by itself *)
    shortTimeFormat      - : e.LSTRPTR;      (* short time format by itself *)

    (* for numeric values *)
    decimalPoint         - : e.LSTRPTR;      (* character before the decimals   *)
    groupSeparator       - : e.LSTRPTR;      (* separates groups of digits      *)
    fracGroupSeparator   - : e.LSTRPTR;      (* separates groups of digits      *)
    grouping             - : e.ADDRESS;      (* size of each group              *)
    fracGrouping         - : e.ADDRESS;      (* size of each group              *)

    (* for monetary values *)
    monDecimalPoint      - : e.LSTRPTR;
    monGroupSeparator    - : e.LSTRPTR;
    monFracGroupSeparator- : e.LSTRPTR;
    monGrouping          - : e.ADDRESS;
    monFracGrouping      - : e.ADDRESS;
    monFracDigits        - : SHORTINT;       (* digits after the decimal point  *)
    monIntFracDigits     - : SHORTINT;       (* for international representation*)
    reserved1            - : ARRAY 2 OF SHORTINT;

    (* for currency symbols *)
    monCS                - : e.LSTRPTR;      (* currency symbol                 *)
    monSmallCS           - : e.LSTRPTR;      (* symbol for small amounts        *)
    monIntCS             - : e.LSTRPTR;      (* internationl (ISO 4217) code    *)

    (* for positive monetary values *)
    monPositiveSign      - : e.LSTRPTR;      (* indicate positive money value   *)
    monPositiveSpaceSep  - : SHORTINT;       (* determine if separated by space *)
    monPositiveSignPos   - : SHORTINT;       (* position of positive sign       *)
    monPositiveCSPos     - : SHORTINT;       (* position of currency symbol     *)
    reserved2            - : SHORTINT;

    (* for negative monetary values *)
    monNegativeSign      - : e.LSTRPTR;      (* indicate negative money value   *)
    monNegativeSpaceSep  - : SHORTINT;       (* determine if separated by space *)
    monNegativeSignPos   - : SHORTINT;       (* position of negative sign       *)
    monNegativeCSPos     - : SHORTINT;       (* position of currency symbol     *)
    reserved3            - : SHORTINT;
  END;

CONST
(* constants for Locale.measuringSystem *)
  iso        * = 0;  (* international metric system *)
  american   * = 1;  (* american system             *)
  imperial   * = 2;  (* imperial system             *)
  british    * = 3;  (* british system              *)

(* constants for Locale.loc_CalendarType *)
  ct7sun   * = 0;   (* 7 days a week, Sunday is the first day    *)
  ct7mon   * = 1;   (* 7 days a week, Monday is the first day    *)
  ct7tue   * = 2;   (* 7 days a week, Tuesday is the first day   *)
  ct7wed   * = 3;   (* 7 days a week, Wednesday is the first day *)
  ct7thu   * = 4;   (* 7 days a week, Thursday is the first day  *)
  ct7fri   * = 5;   (* 7 days a week, Friday is the first day    *)
  ct7sat   * = 6;   (* 7 days a week, Saturday is the first day  *)

(* constants for Locale.monPositiveSpaceSep and Locale.monNegativeSpaceSep   *)
  noSpace    * = 0;  (* cur. symbol is NOT separated from value with a space *)
  space      * = 1;  (* cur. symbol IS separated from value with a space     *)

(* constants for Locale.monPositiveSignPos and Locale.monNegativeSignPos *)
  parens     * = 0;  (* () surround the quantity and currencySymbol    *)
  precAll    * = 1;  (* sign string comes before amount and symbol     *)
  succAll    * = 2;  (* sign string comes after amount and symbol      *)
  precCurr   * = 3;  (* sign string comes right before currency symbol *)
  succCurr   * = 4;  (* sign string comes right after currency symbol  *)

(* constants for Locale.monPositiveCSPos and Locale.monNegativeCSPos *)
  precedes   * = 0;  (* currency symbol comes before value *)
  succeeds   * = 1;  (* currency symbol comes after value  *)

(* elements of the byte arrays pointed to by:
 *   Locale.grouping
 *   Locale.fracGrouping
 *   Locale.monGrouping
 *   Locale.monFracGrouping
 * are interpreted as follows:
 *
 *    255     indicates that no further grouping is to be performed
 *    0       indicates that the previous element is to be repeatedly used
 *            for the remainder of the digits
 *    <other> the number of digits that comprises the current group
 *)


(*****************************************************************************)


(* Tags for OpenCatalog() *)
  tagBase         * = u.user + 90000H;
  builtInLanguage * = tagBase+1;  (* language of built-in strings    *)
  builtInCodeSet  * = tagBase+2;  (* code set of built-in strings    *)
  version         * = tagBase+3;  (* catalog version number required *)
  language        * = tagBase+4;  (* preferred language of catalog   *)


(*****************************************************************************)


(* Comparison types for StrnCmp() *)
  ascii      * = 0;
  collate1   * = 1;
  collate2   * = 2;


(*****************************************************************************)


TYPE

(* This structure must only be allocated by locale.library and is READ-ONLY! *)
  CatalogPtr * = UNTRACED POINTER TO Catalog;
  Catalog    * = STRUCT (link - : e.Node) (* for internal linkage    *)
    pad       - : INTEGER;     (* to longword align       *)
    language  - : e.LSTRPTR;   (* language of the catalog *)
    codeSet   - : LONGINT;     (* currently always 0      *)
    version   - : INTEGER;     (* version of the catalog  *)
    revision  - : INTEGER;     (* revision of the catalog *)
  END;


(*****************************************************************************)



VAR
  base * : LocaleBasePtr;

(*--- functions in V38 or higher (Release 2.1) ---*)

PROCEDURE CloseCatalog  *{base,-36}(catalog{8}       : CatalogPtr);
PROCEDURE CloseLocale   *{base,-42}(locale{8}        : LocalePtr);
PROCEDURE ConvToLower   *{base,-48}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): CHAR;
PROCEDURE ConvToUpper   *{base,-54}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): CHAR;
PROCEDURE FormatDate    *{base,-60}(locale{8}        : LocalePtr;
                                    fmtTemplate{9}   : ARRAY OF CHAR;
                                    date{10}         : d.Date;
                                    putCharFunc{11}  : u.HookPtr);
PROCEDURE FormatString  *{base,-66}(locale{8}        : LocalePtr;
                                    fmtTemplate{9}   : ARRAY OF CHAR;
                                    dataStream{10}   : e.ADDRESS;
                                    putCharFunc{11}  : u.HookPtr): e.ADDRESS;
PROCEDURE GetCatalogStr *{base,-72}(catalog{8}       : CatalogPtr;
                                    stringNum{0}     : LONGINT;
                                    defaultString{9} : ARRAY OF CHAR): e.LSTRPTR;
PROCEDURE GetLocaleStr  *{base,-78}(locale{8}        : LocalePtr;
                                    stringNum{0}     : LONGINT): e.LSTRPTR;
PROCEDURE IsAlNum       *{base,-84}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsAlpha       *{base,-90}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsCntrl       *{base,-96}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsDigit      *{base,-102}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsGraph      *{base,-108}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsLower      *{base,-114}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsPrint      *{base,-120}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsPunct      *{base,-126}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsSpace      *{base,-132}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsUpper      *{base,-138}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE IsXDigit     *{base,-144}(locale{8}        : LocalePtr;
                                    character{0}     : CHAR): BOOLEAN;
PROCEDURE OpenCatalogA *{base,-150}(locale{8}        : LocalePtr;
                                    name{9}          : ARRAY OF CHAR;
                                    tagList{10}      : ARRAY OF u.TagItem): CatalogPtr;
PROCEDURE OpenCatalog  *{base,-150}(locale{8}        : LocalePtr;
                                    name{9}          : ARRAY OF CHAR;
                                    tag1{10}..       : u.Tag): CatalogPtr;
PROCEDURE OpenLocale   *{base,-156}(name{8}          : ARRAY OF CHAR): LocalePtr;
PROCEDURE ParseDate    *{base,-162}(locale{8}        : LocalePtr;
                                    date{9}          : d.Date;
                                    fmtTemplate{10}     : ARRAY OF CHAR;
                                    getCharFunc{11}  : u.HookPtr): BOOLEAN;
PROCEDURE StrConvert   *{base,-174}(locale{8}        : LocalePtr;
                                    string{9}        : ARRAY OF CHAR;
                                    VAR buffer{10}   : ARRAY OF CHAR;
                                    bufferSize{0}    : LONGINT;
                                    type{1}          : LONGINT): LONGINT;
PROCEDURE StrnCmp      *{base,-180}(locale{8}        : LocalePtr;
                                    string1{9}       : ARRAY OF CHAR;
                                    string2{10}      : ARRAY OF CHAR;
                                    length{0}        : LONGINT;
                                    type{1}          : LONGINT): LONGINT;

BEGIN
  base := e.OpenLibrary (localeName, 38);

CLOSE
  IF base # NIL THEN e.CloseLibrary (base) END;

END Locale.

