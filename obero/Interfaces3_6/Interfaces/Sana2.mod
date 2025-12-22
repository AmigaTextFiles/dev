(*(********************************************************************

:Program.    Sana2.mod
:Contents.   Structure definitions for SANA-II devices
:Author.     (Original) Raymond S. Brand, Dale Larson
:Author.     (Oberon) bene@amokut.adsp.sub.org (Nicolas Benezan)
:Copyright.  (C) Copyright 1991 Commodore-Amiga Inc.
:Copyright.  All Rights Reserved
:Language.   Oberon
:Translator. Amiga Oberon Compiler V3.0
:History.    V1.4 bene 25-Nov-91 ported from sana.h 91/11/07
:History.    V1.5 bene 23-Apr-92 + LONGBOOL
:History.    V1.6 bene 11-Jun-92 adapted to compiler 2.25
:History.    V1.7 bene 24-Jul-92 compiler 2.39, BYTE -> SHORTINT
:History.    V1.8 bene 10-Dec-92 DeviceStats bug fixed
:History.    V1.9 bene 16-May-93 + amokNet
:History.    V1.10 hG  20-May-93 updated to V39, rearranged
:History.    40.15 hG  28-Dec-93 updated to V40.15, bumped version/rev.
:Version.    $VER: Sana2.mod 40.15 (28.12.93) Oberon 3.0

********************************************************************)*)

MODULE Sana2; (* $Implementation- *)

IMPORT
  e * := Exec,
  Timer *,
  u * := Utility;

CONST
  maxAddrBits  * = 128;
  maxAddrBytes * = (maxAddrBits + 7) DIV 8;

TYPE
  Sana2Address         * = ARRAY maxAddrBytes OF SHORTINT;
  StatDataPtr          * = UNTRACED POINTER TO StatData;
  IOSana2ReqPtr        * = UNTRACED POINTER TO IOSana2Req;
  DeviceQueryPtr       * = UNTRACED POINTER TO DeviceQuery;
  PacketTypeStatsPtr   * = UNTRACED POINTER TO PacketTypeStats;
  SpecialStatHeaderPtr * = UNTRACED POINTER TO SpecialStatHeader;
  DeviceStatsPtr       * = UNTRACED POINTER TO DeviceStats;
  BufferMngDataPtr     * = UNTRACED POINTER TO BufferMngData;

  CopyBuffProc * = PROCEDURE (to{8}   : e.APTR;
                              from{9} : e.APTR;
                              count{0}: LONGINT): e.LONGBOOL;

  BufferMngData * = STRUCT END;
  BufferTagList * = STRUCT (dummy *: BufferMngData)
    tags *: u.Tags2;
  END;

  IOSana2Req * = STRUCT (ioReq *: e.IORequest)
    wireError  * : LONGINT;           (* wire type specific error     *)
    packetType * : LONGINT;           (* packet type                  *)
    srcAddr    * : Sana2Address;      (* source address               *)
    dstAddr    * : Sana2Address;      (* dest address                 *)
    dataLength * : LONGINT;           (* from header                  *)
    data       * : e.APTR;            (* packet data                  *)
    statData   * : StatDataPtr;       (* statics data pointer         *)
    bufferMng  * : BufferMngDataPtr;  (* TagList / ProcTable          *)
  END;

CONST
(* defines for IOSana2Req.ioReq.flags *)

  raw   * = 7;         (* raw packet IO requested      *)
  bcast * = 6;         (* broadcast packet (received)  *)
  mcast * = 5;         (* multicast packet (received)  *)
  quick * = e.quick;   (* quick IO requested (0)       *)

(* defines for OpenDevice() *)

  mine  * = 0;         (* exclusive access requested   *)
  prom  * = 1;         (* promiscuous mode requested   *)

(* defines for OpenDevice() tags *)

  dummy        * = u.user + 0B0000H;
  copyToBuff   * = dummy + 1;
  copyFromBuff * = dummy + 2;

TYPE
  StatData * = STRUCT END; (* dummy *)

  DeviceQuery * = STRUCT (dummy *: StatData)
    (* standard information *)
    sizeAvailable  * : LONGINT;    (* bytes available              *)
    sizeSupplied   * : LONGINT;    (* bytes supplied               *)
    devQueryFormat * : LONGINT;    (* this is type 0               *)
    deviceLevel    * : LONGINT;    (* this document is level 0     *)
    (* common information *)
    addrFieldSize  * : INTEGER;    (* address size in bits         *)
    mtu            * : LONGINT;    (* maximum packet data size     *)
    bps            * : LONGINT;    (* line rate (bits/sec)         *)
    hardwareType   * : LONGINT;    (* what the wire is             *)
    (* format specific information *)
  END;

CONST
(*
** defined Hardware types
**
**  If your hardware type isn't listed below contact CATS to get a new
**  type number added for your hardware.
*)

  ethernet  * = 1;
  ieee802   * = 6;
  arcnet    * = 7;
  localTalk * = 11;
  dyLan     * = 12;
  amokNet   * = 200;
  PPP       * = 253;
  SLIP      * = 254;
  CSLIP     * = 255;

TYPE
  PacketTypeStats * = STRUCT (dummy *: StatData)
    packetsSent     * : LONGINT;  (* transmitted count            *)
    packetsReceived * : LONGINT;  (* received count               *)
    bytesSent       * : LONGINT;  (* bytes transmitted count      *)
    bytesReceived   * : LONGINT;  (* bytes received count         *)
    packetsDropped  * : LONGINT;  (* packets dropped count        *)
  END;

  SpecialStatRecord * = STRUCT
    type   * : LONGINT;           (* statistic identifier         *)
    count  * : LONGINT;           (* the statistic                *)
    string * : e.LSTRPTR;         (* statistic name               *)
  END;

  SpecialStatHeader * = STRUCT (dummy *: StatData)
    recordCountMax      * : LONGINT;  (* room available               *)
    recordCountSupplied * : LONGINT;  (* number supplied              *)
    (* struct Sana2SpecialStatRecord[RecordCountMax]; *)
  END;

  DeviceStats * = STRUCT (dummy *: StatData)
    packetsReceived      * : LONGINT;  (* received count               *)
    packetsSent          * : LONGINT;  (* transmitted count            *)
    badData              * : LONGINT;  (* bad packets received         *)
    overruns             * : LONGINT;  (* hardware miss count          *)
    unused               * : LONGINT;  (* 12-Nov-92 release bugfix     *)
    unknownTypesReceived * : LONGINT;  (* orphan count                 *)
    reconfigurations     * : LONGINT;  (* network reconfigurations     *)
    lastStart            * : Timer.TimeVal;(* time of last online          *)
  END;

CONST
(* device commands *)
  start              * = e.nonstd;

  deviceQuery         * = start + 0;
  getStationAddress   * = start + 1;
  configInterface     * = start + 2;
  addMulticastAddress * = start + 5;
  delMulticastAddress * = start + 6;
  multicast           * = start + 7;
  broadcast           * = start + 8;
  trackType           * = start + 9;
  untrackType         * = start + 10;
  getTypeStats        * = start + 11;
  getSpecialStats     * = start + 12;
  getGlobalStats      * = start + 13;
  onEvent             * = start + 14;
  readOrphan          * = start + 15;
  online              * = start + 16;
  offline             * = start + 17;

  end                 * = start+18;

(* defined errors for IOSana2Req.ioReq.error (see also <exec/errors.h>) *)

  noError             * = 0;      (* peachy-keen                  *)
  noResources         * = 1;      (* resource allocation failure  *)
  badArgument         * = 3;      (* garbage somewhere            *)
  badState            * = 4;      (* inappropriate state          *)
  badAddress          * = 5;      (* who?                         *)
  mtuExceeded         * = 6;      (* too much to chew             *)
  notSupported        * = 8;      (* command not supported        *)
  software            * = 9;      (* software error detected      *)
  outOfService        * = 10;     (* driver is OFFLINE            *)
(*
** From <exec/errors.h>
**
**  openFail    * = -1; (* device/unit failed to open *)
**  aborted     * = -2; (* request terminated early [after AbortIO()] *)
**  noCmd       * = -3; (* command not supported by device *)
**  badLength   * = -4; (* not a valid length (usually IO_LENGTH) *)
**  badAddress  * = -5; (* invalid address (misaligned or bad range) *)
**  unitBusy    * = -6; (* device opens ok, but requested unit is busy *)
**  selfTest    * = -7; (* hardware failed self-test *)
**
*)

(* defined errors for S2io_WireError *)

  genericError        * = 0;       (* no specific info available   *)
  notConfigured       * = 1;       (* unit not configured          *)
  unitOnline          * = 2;       (* unit is currently online     *)
  unitOffline         * = 3;       (* unit is currently offline    *)
  alreadyTracked      * = 4;       (* protocol already tracked     *)
  notTracked          * = 5;       (* protocol not tracked         *)
  buffError           * = 6;       (* buff mgt func returned error *)
  srcAddress          * = 7;       (* source address problem       *)
  dstAddress          * = 8;       (* destination address problem  *)
  badBroadcast        * = 9;       (* broadcast address problem    *)
  badMulticast        * = 10;      (* multicast address problem    *)
  multicastFull       * = 11;      (* multicast address list full  *)
  badEvent            * = 12;      (* unsupported event class      *)
  badStatData         * = 13;      (* statdata failed sanity check *)
  isConfigured        * = 15;      (* attempt to config twice      *)
  nullPointer         * = 16;      (* null pointer detected        *)

(* defined events *)

  eventError          * = 0;       (* error catch all              *)
  eventTx             * = 1;       (* transmitter error catch all  *)
  eventRx             * = 2;       (* receiver error catch all     *)
  eventOnline         * = 3;       (* unit is in service           *)
  eventOffline        * = 4;       (* unit is not in service       *)
  eventBuff           * = 5;       (* buff mgt function error      *)
  eventHardware       * = 6;       (* hardware error catch all     *)
  eventSoftware       * = 7;       (* software error catch all     *)

(*
** The SANA-II special statistic identifier is an unsigned 32 number.
** The upper 16 bits identify the type of network wire type to which
** the statistic applies and the lower 16 bits identify the particular
** statistic.
**
** If you desire to add a new statistic identifier, contacts CATS.
*)

  ethernetIDDummy * =  ASH(ethernet,16);

(*
** defined ethernet special statistics
*)

  ethernetBadMulticast * =  ethernetIDDummy + 0;
(*
** This count will record the number of times a received packet tripped
** the hardware's multicast filtering mechanism but was not actually in
** the current multicast table.
*)

  ethernetRetries      * = ethernetIDDummy +1;
(*
** This count records the total number of retries which have resulted
** from transmissions on this board.
*)

END Sana2.

