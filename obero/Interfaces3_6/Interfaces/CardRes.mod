(*
(*  Amiga Oberon Interface Module:
**  $VER: CardRes.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1991-1992 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)

MODULE CardRes;

IMPORT e * := Exec, SYSTEM *;

CONST
  cardResName    * = "card.resource";

TYPE
  CardHandlePtr    * = UNTRACED POINTER TO CardHandle;
  DeviceTDataPtr   * = UNTRACED POINTER TO DeviceTData;
  CardMemoryMapPtr * = UNTRACED POINTER TO CardMemoryMap;
  TPAmigaXIPPtr    * = UNTRACED POINTER TO TPAmigaXIP;

(* Structures used by the card.resource                         *)

  CardHandle * = STRUCT
    node     * : e.Node;
    removed  * : e.InterruptPtr;
    inserted * : e.InterruptPtr;
    status   * : e.InterruptPtr;
    flags    * : SHORTSET;
  END;

  DeviceTData * = STRUCT
    size   * : LONGINT;    (* Size in bytes        *)
    speed  * : LONGINT;    (* Speed in nanoseconds *)
    type   * : SHORTINT;   (* Type of card         *)
    flags  * : SHORTSET;   (* Other flags          *)
  END;

  CardMemoryMap * = STRUCT
    commonMemory    * : e.APTR;
    attributeMemory * : e.APTR;
    ioMemory        * : e.APTR;

(* Extended for V39 - These are the size of the memory spaces above *)

    commonMemSize    * : LONGINT;
    attributeMemSize * : LONGINT;
    ioMemSize        * : LONGINT;
  END;

CONST
(* CardHandle.cah_CardFlags for OwnCard() function              *)

  resetRemove    * = 0;
  ifAvailable    * = 1;
  delayOwnerShip * = 2;
  postStatus     * = 3;

(* ReleaseCreditCard() function flags                           *)

  removeHandle   * = 0;

(* ReadStatus() return flags                                    *)

  statusbCCDET   * = 6;
  statusbBVD1    * = 5;
  statusbSC      * = 5;
  statusbBVD2    * = 4;
  statusbDA      * = 4;
  statusbWR      * = 3;
  statusbBSY     * = 2;
  statusbIRQ     * = 2;

(* CardProgramVoltage() defines *)

  voltage0v      * = 0;       (* Set to default; may be the same as 5V *)
  voltage5v      * = 1;
  voltage12v     * = 2;

(* CardMiscControl() defines *)

  enablebDigaudio * = 1;
  disablebWp      * = 3;

(*
 * New CardMiscControl() bits for V39 card.resource.  Use these bits to set,
 * or clear status change interrupts for BVD1/SC, BVD2/DA, and BSY/IRQ.
 * Write-enable/protect change interrupts are always enabled.  The defaults
 * are unchanged (BVD1/SC is enabled, BVD2/DA is disabled, and BSY/IRQ is enabled).
 *
 * IMPORTANT -- Only set these bits for V39 card.resource or greater (check
 * resource base VERSION)
 *
 *)

  intbSetClr * = 7;
  intbBVD1   * = 5;
  intbSC     * = 5;
  intbBVD2   * = 4;
  intbDA     * = 4;
  intbBSY    * = 2;
  intbIRQ    * = 2;

(* CardInterface() defines *)

  interfaceAmiga0 * = 0;

(*
 * Tuple for Amiga execute-in-place software (e.g., games, or other
 * such software which wants to use execute-in-place software stored
 * on a credit-card, such as a ROM card).
 *
 * See documentatin for IfAmigaXIP().
 *)

  cisTplAmigaXIP * = 091H;

TYPE
  TPAmigaXIP * = STRUCT
    code   * : SHORTINT;
    link   * : SHORTINT;
    loc    * : ARRAY 4 OF SHORTINT;
    flags  * : SHORTSET;
    resrv  * : SHORTINT;
  END;

CONST
(*
 * The XIPFLAGB_AUTORUN bit means that you want the machine
 * to perform a reset if the execute-in-place card is inserted
 * after DOS has been started.  The machine will then reset,
 * and execute your execute-in-place code the next time around.
 *
 * NOTE -- this flag may be ignored on some machines, in which
 * case the user will have to manually reset the machine in the
 * usual way.
 *
 *)

  autoRun        * = 0;

VAR
(*
 *  You have to put a pointer to the card.resource here to use the cia
 *  procedures:
 *)
  base * : e.APTR;

PROCEDURE OwnCard         *{base,-006H}(handle{9}     : CardHandlePtr): CardHandlePtr;
PROCEDURE ReleaseCard     *{base,-00CH}(handle{9}     : CardHandlePtr;
                                        flags{0}      : LONGINT);
PROCEDURE GetCardMap      *{base,-012H}(): CardMemoryMapPtr;
PROCEDURE BeginCardAccess *{base,-018H}(handle{9}     : CardHandlePtr): BOOLEAN;
PROCEDURE EndCardAccess   *{base,-01EH}(handle{9}     : CardHandlePtr): BOOLEAN;
PROCEDURE ReadCardStatus  *{base,-024H}(): SHORTINT;
PROCEDURE CardResetRemove *{base,-02AH}(handle{9}     : CardHandlePtr;
                                        flag{0}       : LONGINT): BOOLEAN;
PROCEDURE CardMiscControl *{base,-030H}(handle{9}     : CardHandlePtr;
                                        controlBits{1}: SHORTSET ): SHORTSET;
PROCEDURE CardAccessSpeed *{base,-036H}(handle{9}     : CardHandlePtr;
                                        nanoseconds{0}: LONGINT): LONGINT;
PROCEDURE CardProgramVoltage*{base,-03CH}(handle{9}   : CardHandlePtr;
                                          voltage{0}  : LONGINT): LONGINT;
PROCEDURE CardResetCard   *{base,-042H}(handle{9}     : CardHandlePtr): BOOLEAN;
PROCEDURE CopyTuple       *{base,-048H}(handle{9}     : CardHandlePtr;
                                        buffer{8}     : ARRAY OF SYSTEM.BYTE;
                                        tupleCode{1}  : LONGINT;
                                        size{0}       : LONGINT): BOOLEAN;
PROCEDURE DeviceTuple     *{base,-04EH}(tupleData{8}  : e.APTR;
                                        storage{9}    : DeviceTDataPtr): LONGINT;
PROCEDURE IfAmigaXIP      *{base,-054H}(handle{10}    : CardHandlePtr): e.ResidentPtr;
PROCEDURE CardForceChange *{base,-05AH}(): BOOLEAN;
PROCEDURE CardChangeCount *{base,-060H}(): LONGINT;
PROCEDURE CardInterface   *{base,-066H}(): LONGINT;

END CardRes.

