(******************************************************************************)
(* Modulname  : AmbosLib_Oberon                                               *)
(* Version    : v1.000 (beta)                                                 *)
(* Datum      : 05.11.1994                                                    *)
(* Autor      : Andreas Leicht                                                *)
(* Adresse    : Seefahrerstr. 5                                               *)
(*            : 27721 Ritterhude                                              *)
(* Telefon    : 0421 / 63 79 76                                               *)
(* EMail      : Andi@doom.gun.de                                              *)
(* Copyright  : Andreas Leicht © 05.11.1994                                   *)
(* Sprache    : Oberon 2                                                      *)
(* Compiler   : Amiga Oberon v3.20d                                           *)
(******************************************************************************)

(******************************************************************************)
(* Geschichte : v1.000 (beta) - 05.11.1994 - AO v3.20d                        *)
(*            : Erste Umsetzung                                               *)
(******************************************************************************)

MODULE AmbosLibOberon;

IMPORT  exe * :=  Exec,
        dos * :=  Dos,
        int * :=  Intuition,
        sys * :=  SYSTEM;

TYPE
  externInfoPtr       * = UNTRACED POINTER TO externInfo;
  transferNodePtr     * = UNTRACED POINTER TO transferNode;
  userDatenExternPtr  * = UNTRACED POINTER TO userDatenExternPtr;
  fileExternPtr       * = UNTRACED POINTER TO fileExtern;
  brettDatenExternPtr * = UNTRACED POINTER TO brettDatenExtern;
  bbsMenuPtr          * = UNTRACED POINTER TO bbsMenu;

  STRING30            * = UNTRACED POINTER TO ARRAY  30 OF CHAR;
  STRING40            * = UNTRACED POINTER TO ARRAY  40 OF CHAR;
  STRING42            * = UNTRACED POINTER TO ARRAY  42 OF CHAR;
  STRING50            * = UNTRACED POINTER TO ARRAY  50 OF CHAR;
  STRING60            * = UNTRACED POINTER TO ARRAY  60 OF CHAR;
  STRING100           * = UNTRACED POINTER TO ARRAY 100 OF CHAR;

CONST
  bbsName       * = "BBS.library";
  bbsVersion    * = 1;

(******************************************************************************)
(*                                                                            *)
(******************************************************************************)
CONST
  up            * = 6;
  down          * = 3;
  left          * = 4;
  right         * = 5;
  delete        * = 7;
  backspace     * = 8;
  return        * = 13;

(******************************************************************************)
(* Werte für StartetFrom in der ExternInfo Struktur                           *)
(******************************************************************************)
CONST
  fromAMenu           * = 0;            (* Programm wurd von der GeoNeto- oder        *)
                                        (* AmBoS-Menu-Oberfläche gestartet            *)
  fromNachLogin       * = 1;            (* Batchdatei                                 *)
  fromGastLogin       * = 2;            (* Batchdatei                                 *)
  fromVorAntrag       * = 3;            (* Batchdatei                                 *)
  fromNachAntrag      * = 4;            (* Batchdatei                                 *)
  fromVorDownLoad     * = 5;            (* Batchdatei                                 *)
  fromNachDownLoad    * = 6;            (* Batchdatei                                 *)
  fromVorUpLoad       * = 7;            (* Batchdatei                                 *)
  fromNachUpLoad      * = 8;            (* Batchdatei                                 *)
  fromLogoff          * = 9;            (* Batchdatei                                 *)
  fromRelogin         * = 10;           (* Batchdatei                                 *)
  fromSetup           * = 11;           (* Dieser Modus ist noch nicht implementiert, *)
                                        (* er soll dazu verwendet werden, konfor-     *)
                                        (* tables Setup für Externe dem Sysop zur     *)
                                        (* Verfügunug stellen                         *)
                                        (* Sollte dieser Modus auftauchen das         *)
                                        (* Programm am besten sofort beenden          *)

(******************************************************************************)
(* Werte für Language in der ExternInfo-Struktur                              *)
(******************************************************************************)
CONST
  languageDeutsch     * = 0;
  languageEnglish     * = 1;

(******************************************************************************)
(* Werte für DateFormat in der ExternInfo-Struktur                            *)
(******************************************************************************)
CONST
  dateFormatCDN       * = 0; (* Tag-Monat-Jahr *)
  dateFormatUSA       * = 1; (* Monat-Tag-Jahr *)

(******************************************************************************)
(* Werte für tr_Type in der TransferNode-Struktur                             *)
(******************************************************************************)
CONST
  transferUpLoad      * = 1;
  transferDownLoad    * = 2;

(******************************************************************************)
(* Filetyen                                                                   *)
(******************************************************************************)
CONST
  fileTypeMessage     * = 1;
  fileTypeBin         * = 2;

(******************************************************************************)
(* Bretttypen                                                                 *)
(******************************************************************************)
CONST
  brettTypeNoBrett    * = 0;
  brettTypeAsc        * = 1;
  brettTypeBin        * = 2;
  brettTypeAscBin     * = 3;
  brettTypeHead       * = 4;
  brettTypeExtern     * = 5;
  brettTypePm         * = 6;

(******************************************************************************)
(* Eine ExternInfo-Struktur. Wird von der Funktion bbs_open() zurückgegeben   *)
(******************************************************************************)
TYPE
  externInfo * = STRUCT
    conOnly           * : BOOLEAN;      (* Wenn ConLogin ungleich 0               *)
    startedFrom       * : LONGINT;      (* Hier kann man entnehmen, von wo das    *)
                                        (* Programm gestartet wurde               *)
    userName          * : exe.STRPTR;   (* Name des Users                         *)
    city              * : exe.STRPTR;   (* Wohnort des Users                      *)
    loginTime         * : dos.Date;     (* Zeitpunkt des Logins                   *)
    totalDownLoads    * : LONGINT;      (* Download Bytes des Users               *)
    totalUpLoads      * : LONGINT;      (* Upload Bytes des Users                 *)
    baudRate          * : LONGINT;      (* BaudRate des Connects                  *)
    lines             * : LONGINT;      (* Anzahl der Zeilen des Users            *)

    callsToday        * : LONGINT;      (* Anzahl der Anrufe heute in der Box     *)
    callsTotal        * : LONGINT;      (* Anzahl der gesammten Anrufe in der Box *)
    lastCallNr        * : LONGINT;      (* Nummer des letzten Anrufes vom User    *)
                                        (* in der Box                             *)
    callNr            * : LONGINT;      (* Aktuelle Anrufnummer                   *)

    transferListe     * : exe.List;     (* Liste der Up- bzw. Downgelodeten       *)
                                        (* Files wenn das Programm aus der        *)
                                        (* Nachupload- oder Nachdownload-Batch    *)
                                        (* gestartet wurde                        *)
    autoLogOff        * : INTEGER;      (* Ist dieser Wert ungleich NULL befinde  *)
                                        (* sich der User in einer Autologoff-     *)
                                        (* Sequenze, d.h. Eingabeaufforderungen   *)
                                        (* sind tunlichst zu unterlassen... ;-)   *)
    dateFormat        * : INTEGER;      (* Das bevorzugte Datumsformat des Users  *)
    coSysop           * : INTEGER;      (* Wenn ungleich NULL ist der User Sysop  *)
                                        (* oder CoSysop                           *)
    ambosVersion      * : INTEGER;      (* AmBoS Version                          *)
    ambosRevision     * : INTEGER;      (* AmBoS Revision                         *)
    ambosSerialNumber * : LONGINT;      (* Seriennummer oder 0 für DEMO-Version   *)
  END;

(******************************************************************************)
(* Nodes in der ExternInfo-Struktur->TransferListe                            *)
(******************************************************************************)
TYPE
  transferNode * = STRUCT
    trSucc            * : transferNodePtr;
    trPrev            * : transferNodePtr;
    trType            * : sys.BYTE;       (* Art der Übertragung Up oder Download     *)
    trPri             * : sys.BYTE;
    trName            * : exe.STRPTR;     (* Names des Files                          *)
    trRealName        * : exe.STRPTR;     (* Name unter dem das File auf dem          *)
                                          (* Datenträger zu finden ist                *)
    trBoxPath         * : exe.STRPTR;     (* Kompletter Brettpfad                     *)
    trDosPath         * : exe.STRPTR;     (* Pfad unter dem das File auf dem          *)
                                          (* Datenträger zu finden ist                *)
    trUpLoader        * : exe.STRPTR;     (* Der Uploader des Files                   *)
    trSize            * : LONGINT;        (* Länge des Files in Bytes                 *)
    trCps             * : LONGINT;        (* CPS_Rate bei der Übertragung             *)
    trAnzDownLoads    * : LONGINT;        (* Wie oft das File schon downgelodet wurde *)
    trProtectedBoard  * : LONGINT;        (* File liegt in einem durch Zugangsgruppe  *)
                                          (* geschützten Pfad                         *)
END;

(******************************************************************************)
(*                                                                            *)
(******************************************************************************)
TYPE
  userDatenExtern * = STRUCT
    ambosPrivat * : exe.APTR;
    userName    * : STRING30;
    firstName   * : STRING50;
    name        * : STRING50;
    city        * : STRING100;
    street      * : STRING60;
    phoneNr     * : STRING30;
    fax         * : STRING30;
    modem       * : STRING30;
    computer    * : STRING30;
    substitute  * : STRING30; (* Vertreter *)
    dlProtocol  * : STRING30;
    packer      * : STRING30;

    birthYear   * : INTEGER;
    birthMonth  * : INTEGER;
    birthDay    * : INTEGER;
    lastLogin   * : LONGINT; (* In Minuten seid dem 01.01.1978 *)
    newsDate    * : LONGINT; (* IN Minuten seid dem 01.01.1978 *)
    firstLogin  * : LONGINT; (* In Minuten seid dem 01.01.1978 *)

    dlFreeSpace * : LONGINT;
    upLoads     * : LONGINT;
    downLoads   * : LONGINT;

    lastCall    * : LONGINT;

    onlineTime  * : INTEGER;
    onlineToday * : INTEGER;
    lines       * : INTEGER;
    zone        * : INTEGER;
    upDownRatio * : INTEGER;
    maxPmMails  * : INTEGER;

    numCrashes  * : INTEGER;
    numLogins   * : INTEGER;
END;

(******************************************************************************)
(* Eine FileExtern-Struktur                                                   *)
(******************************************************************************)
TYPE
  fileExtern * = STRUCT
    ambosPrivat   * : exe.APTR;

    number        * : LONGINT;    (* Nummer des Files im Brett            *)
    delete        * : INTEGER;    (* kann gesetzt werden                  *)
    markiert      * : INTEGER;    (* Eintrag ist markiert                 *)

    fileType      * : INTEGER;    (* File oder Mail                       *)
    brettType     * : INTEGER;    (* Art des aktuellen Brettes            *)
    downLoads     * : INTEGER;    (* Anzahl der Zugriffe auf den Eintrag  *)
    upLoadDate    * : LONGINT;    (* in Minuten seit dem 01.01.1978       *)
    createDate    * : LONGINT;    (* in Minuten seit dem 01.01.1978       *)
    size          * : LONGINT;    (* Länge von Binärfiles                 *)
    lines         * : LONGINT;    (* Anzahl der Zeilen bei Mails          *)

    upLoader      * : exe.STRING; (* Name des Uploaders                   *)
    realName      * : exe.STRING; (* Name unter dem das File auf der      *)
                                  (* Platte zu finden ist                 *)
    boxPath       * : exe.STRING; (* Brettpfad                            *)
    dosPath       * : exe.STRING; (* Dospfad des aktuellen Brettes        *)

    readMeFile    * : STRING42;
    boxName       * : STRING42;
    comment       * : STRING50;
END;

(******************************************************************************)
(* Eine BrettDatenExtern-Struktur                                             *)
(******************************************************************************)
TYPE
  brettDatenExtern * = STRUCT
    ambosPrivat     * : exe.APTR;

    brettName       * : STRING40;
    brettPfad       * : exe.STRING;

    schreibGruppe   * : STRING40;
    zugangsGruppe   * : STRING40;
    leseGruppe      * : STRING40;
    verwalter       * : STRING40;
    brettPasswort   * : STRING40;

    letzterEintrag  * : LONGINT;
    brettFlags      * : LONGINT;
    brettTyp        * : exe.BYTE;
    locked          * : exe.BYTE;
    area            * : exe.BYTE;
    noRatio         * : exe.BYTE;
END;

(******************************************************************************)
(* Datenstruktur für bbs_menu()                                               *)
(******************************************************************************)
TYPE
  bbsMenu * = STRUCT
    next      * : exe.APTR;
    name      * : exe.APTR;
    menuID    * : LONGINT;    (* Niemals auf 0 setzen !       *)
    private1  * : LONGINT;    (* Immer mit 0 initialisieren ! *)
    private2  * : SHORTINT;   (* Immer mit 0 initialisieren ! *)
  END;

(******************************************************************************)
(*                                                                            *)
(******************************************************************************)
VAR
 bbs                      * : exe.LibraryPtr;
 base                     * : exe.LibraryPtr;

(******************************************************************************)
(* bbs_Private1            - nicht dokumentierte Funktion                     *)
(* bbs_Private2            - nicht dokumentierte Funktion                     *)
(* bbs_Open                - Anmelden des externen Programmes am Port         *)
(* bbs_Close               - Abmelden des externen Programmes bei Port        *)
(* bbs_PutS                - einen String ausgeben                            *)
(* bbs_GetS                - einen String einlesen                            *)
(* bbs_SGetS               - liest einen nicht sichtbaren String ein          *)
(* bbs_Private3            - nicht dokumentierte Funktion                     *)
(* bbs_GetC                - liest ein Zeichen ein                            *)
(* bbs_FGetC               - liest ein gefiltertes Zeichen ein                *)
(* bbs_Menu                - baut ein horizontales Cursor-Shortcut-Menü auf   *)
(* bbs_Graphic             - zeigt eine ANSI-Datei an                         *)
(* bbs_Text                - zeigt eine Text-Datei an                         *)
(* bbs_Private4            - nicht dokumentierte Funktion                     *)
(* bbs_RPutS               -                                                  *)
(* bbs_Private5            - nicht dokumentierte Funktion                     *)
(* bbs_Private6            - nicht dokumentierte Funktion                     *)
(* bbs_Private7            - nicht dokumentierte Funktion                     *)
(* bbs_WGetC               - liest ein Zeichen ein                            *)
(* bbs_WFGetC              - liest ein gefiltertes Zeichen ein                *)
(* bbs_Private8            - nicht dokumentierte Funktion                     *)
(* bbs_Private9            - nicht dokumentierte Funktion                     *)
(* bbs_Private10           - nicht dokumentierte Funktion                     *)
(* bbs_PrintF              - formatierte Ausgabe (wie dos.PrintF)             *)
(* bbs_WGetS               -                                                  *)
(* bbs_Private11           - nicht dokumentierte Funktion                     *)
(* bbs_LookC               - lesen eines Zeichen (asynchron)                  *)
(* bbs_FirstUser           - Userdaten des ersten Users auslesen              *)
(* bbs_NextUser            - weitere Userdaten lesen                          *)
(* bbs_ObtainName          - belegen eines Names                              *)
(* bbs_ReleaseName         - freigeben eines Names                            *)
(* bbs_LoadUserData        - auslesen von Userdaten                           *)
(* bbs_SaveUserData        - speichern von Userdaten                          *)
(* bbs_FreeUserData        - Userdaten freigeben                              *)
(* bbs_MailToUser          - Nachricht an einen User schreiben                *)
(* bbs_MailToBrett         - Nachricht in ein Brett schreiben                 *)
(* bbs_GetBrettType        - Bretttyp feststellen                             *)
(* bbs_FirstBrettInhalt    - Brettdaten auslesen                              *)
(* bbs_NextBrettInhalt     - Brettinhalt weiterlesen                          *)
(* bbs_BrettInhaltByNumber - bestimmten Brettinhalt lesen                     *)
(* bbs_FreeBrettInhalt     - Brettinhalt freigeben                            *)
(* bbs_SaveBrettInhalt     - Brettinhalt speichern                            *)
(******************************************************************************)

PROCEDURE Private1        *{bbs,- 30};
PROCEDURE Private2        *{bbs,- 36};
PROCEDURE Open            *{bbs,- 42}(port{9}          : ARRAY OF CHAR): externInfoPtr;
PROCEDURE Close           *{bbs,- 48};
PROCEDURE PutS            *{bbs,- 54}(string{9}        : ARRAY OF CHAR);
PROCEDURE GetS            *{bbs,- 60}(deposid{9}       : ARRAY OF CHAR;
                                      maxChars{1}      : LONGINT;
                                      mode{2}          : LONGINT): INTEGER;

PROCEDURE SGetS           *{bbs,- 66}(deposid{9}       : ARRAY OF CHAR;
                                      maxChars{10}     : LONGINT;
                                      mode{11}         : LONGINT): INTEGER;
PROCEDURE Private3        *{bbs,- 72};
PROCEDURE GetC            *{bbs,- 78}(): CHAR;
PROCEDURE FGetC           *{bbs,- 84}(): CHAR;
PROCEDURE Menu            *{bbs,- 90}(menuDaten{9}     : bbsMenuPtr): LONGINT;
PROCEDURE Graphic         *{bbs,- 96}(fileName{9}      : ARRAY OF CHAR);
PROCEDURE Text            *{bbs,-102}(fileName{9}      : ARRAY OF CHAR);
PROCEDURE Private4        *{bbs,-108};
PROCEDURE RPutS           *{bbs,-114}(string{9}        : ARRAY OF CHAR);
PROCEDURE Private5        *{bbs,-120};
PROCEDURE Private6        *{bbs,-126};
PROCEDURE Private7        *{bbs,-132};
PROCEDURE WGetC           *{bbs,-138}(waitBits{1}      : LONGINT): CHAR;
PROCEDURE WFGetC          *{bbs,-144}(waitBits{1}      : LONGINT): CHAR;
PROCEDURE Private8        *{bbs,-150};
PROCEDURE Private9        *{bbs,-156};
PROCEDURE Private10       *{bbs,-162};
PROCEDURE PrintF          *{bbs,-168}(string{9}        : ARRAY OF CHAR;
                                      arg1{10}..       : exe.APTR);
PROCEDURE WGetS           *{bbs,-174};
PROCEDURE Private11       *{bbs,-180};
PROCEDURE LookC           *{bbs,-186}(): SHORTINT;
PROCEDURE FirstUser       *{bbs,-192}(): userDatenExternPtr;
PROCEDURE NextUser        *{bbs,-198}(userDaten{9}     : userDatenExternPtr): userDatenExternPtr;
PROCEDURE ObtainName      *{bbs,-204}(string{9}        : ARRAY OF CHAR);
PROCEDURE ReleaseName     *{bbs,-210}(string{9}        : ARRAY OF CHAR);
PROCEDURE LoadUserData    *{bbs,-216}(name{9}          : ARRAY OF CHAR): userDatenExternPtr;
PROCEDURE SaveUserData    *{bbs,-222}(userDaten{9}     : userDatenExternPtr);
PROCEDURE FreeUserData    *{bbs,-228}(userDaten{9}     : userDatenExternPtr);
PROCEDURE MailToUser      *{bbs,-234}(userName{9}      : ARRAY OF CHAR;
                                      absender{1}      : ARRAY OF CHAR;
                                      betreff{2}       : ARRAY OF CHAR;
                                      textFile{10}     : ARRAY OF CHAR);
PROCEDURE MailToBrett     *{bbs,-240}(userName{9}      : ARRAY OF CHAR;
                                      absender{1}      : ARRAY OF CHAR;
                                      betreff{2}       : ARRAY OF CHAR;
                                      textFile{10}     : ARRAY OF CHAR);
PROCEDURE GetBrettType     *{bbs,-246}(): LONGINT;
PROCEDURE FirstBrettInhalt *{bbs,-252}(): fileExternPtr;
PROCEDURE NextBrettInhalt  *{bbs,-258}(fileExtern{9}   : fileExternPtr);
PROCEDURE BrettInhaltByNumber *{bbs,-264}(number{1}    : LONGINT): fileExternPtr;
PROCEDURE FreeBrettInhalt     *{bbs,-270}(fileExtern{9} : fileExternPtr);
PROCEDURE SaveBrettInhalt     *{bbs,-276}(fileExtern{9} : fileExternPtr);

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  bbs :=   exe.OpenLibrary(bbsName,bbsVersion);

  IF bbs = NIL THEN
    sys.SETREG(0,int.DisplayAlert(0,"\x00\x64\x14missing bbs.library V1.1\o\o",50));
    HALT(0);
  END;

  base := bbs;

CLOSE
  IF bbs#NIL THEN exe.CloseLibrary(bbs) END;

END AmbosLibOberon.

