(*
(*  Amiga Oberon Interface Module:
**  $VER: RealTime.mod 40.15 (6.11.94) Oberon 3.5
**
**      (C) Copyright 1993 Commodore-Amiga Inc.
**      All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993, 1994 by hartmut Goebel
*)      All Rights Reserved
*)

MODULE RealTime;

IMPORT
  e * := Exec,
  u * := Utility;

TYPE
  ConductorPtr     * = UNTRACED POINTER TO Conductor;
  PlayerPtr        * = UNTRACED POINTER TO Player;
  MsgPtr           * = UNTRACED POINTER TO Msg;
    PMTimePtr      * = UNTRACED POINTER TO PMTime;
    PMStatePtr     * = UNTRACED POINTER TO PMState;
  RealTimeBasePtr  * = UNTRACED POINTER TO RealTimeBase;

(*****************************************************************************)
CONST

(* realtime.library's idea of time is based on a clock which emits a pulse
 * 1200 times a second (1.2kHz). All time values maintained by realtime.library
 * are based on this number. For example, the field RealTimeBase->rtb_Time
 * expresses an amount of time equivalent to (RealTimeBase->rtb_Time/TICK_FREQ)
 * seconds.
 *)
  tickFreq            * = 1200;


(*****************************************************************************)
TYPE

(* Each Conductor represents a group of applications which wish to remain
 * synchronized together.
 *
 * This structure must only be allocated by realtime.library and is
 * READ-ONLY!
 *)
  Conductor * = STRUCT (link - : e.Node)
    reserved0       - : INTEGER;
    players         - : e.MinList;     (* this conductor's players      *)
    clockTime       - : LONGINT;       (* current time of this sequence *)
    startTime       - : LONGINT;       (* start time of this sequence   *)
    externalTime    - : LONGINT;       (* time from external unit       *)
    maxExternalTime - : LONGINT;       (* upper limit on sync'd time    *)
    metronome       - : LONGINT;       (* MetricTime highest pri node   *)
    reserved1       - : INTEGER;
    flags           - : SET;           (* conductor flags               *)
    state           - : SHORTINT;      (* playing or stopped            *)
  END;

CONST
(* Flag bits for Conductor.cdt_Flags *)

  external    * = 0;   (* clock is externally driven *)
  gotTick     * = 1;   (* received 1st external tick *)
  metroSet    * = 2;   (* cdt_Metronome filled in    *)
  private     * = 3;   (* conductor is private       *)

(* constants for Conductor.cdt_State and SetConductorState() *)
  stopped    * = 0;   (* clock is stopped              *)
  paused     * = 1;   (* clock is paused               *)
  locate     * = 2;   (* go to 'running' when ready    *)
  running    * = 3;   (* run clock NOW                 *)

(* These do not actually exist as Conductor states, but are used as additional
 * arguments to SetConductorState()
 *)
  metric     * = -1;   (* ask high node to locate       *)
  shuttle    * = -2;   (* time changing but not running *)
  locateSet  * = -3;   (* maestro done locating         *)


(*****************************************************************************)
TYPE

(* The Player is the connection between a Conductor and an application.
 *
 * This structure must only be allocated by realtime.library and is
 * READ-ONLY!
 *)
  Player * = STRUCT (link - : e.Node)
    reserved0    - : SHORTINT;
    reserved1    - : SHORTINT;
    hook         - : u.HookPtr;        (* player's hook function       *)
    source       - : ConductorPtr;     (* pointer to parent context    *)
    task         - : e.TaskPtr;        (* task to signal for alarm     *)
    metricTime   - : LONGINT;          (* current time in app's metric *)
    alarmTime    - : LONGINT;          (* time to wake up              *)
    userData     - : e.APTR;           (* for application use          *)
    playerID     - : INTEGER;          (* for application use          *)
    flags        - : INTEGER;          (* general Player flags         *)
  END;

CONST
(* Flag bits for Player.pl_Flags *)

  ready        * = 0;      (* player is ready to go!        *)
  alarmSet     * = 1;      (* alarm is set                  *)
  quiet        * = 2;      (* a dummy player, used for sync *)
  conducted    * = 3;      (* give me metered time          *)
  extsync      * = 4;      (* granted external sync         *)


(*****************************************************************************)


(* Tags for CreatePlayer(), SetPlayerAttrs(), and GetPlayerAttrs() *)
  playerBase          * = u.user+64;
  playerHook          * = playerBase+1;   (* set address of hook function *)
  playerName          * = playerBase+2;   (* name of player               *)
  playerPriority      * = playerBase+3;   (* priority of player           *)
  playerConductor     * = playerBase+4;   (* set conductor for player     *)
  playerReady         * = playerBase+5;   (* the "ready" flag             *)
  playerAlarmTime     * = playerBase+12;  (* alarm time (sets PLAYERF_ALARMSET) *)
  playerAlarm         * = playerBase+13;  (* sets/clears PLAYERF_ALARMSET flag  *)
  playerAlarmSigTask  * = playerBase+6;   (* task to signal for alarm/notify    *)
  playerAlarmSigBit   * = playerBase+8;   (* signal bit for alarm (or -1)       *)
  playerConducted     * = playerBase+7;   (* sets/clears PLAYERF_CONDUCTED flag *)
  playerQuiet         * = playerBase+9;   (* don't process time thru this       *)
  playerUserData      * = playerBase+10;
  playerID            * = playerBase+11;
  playerExtSync       * = playerBase+14;  (* attempt/release to ext sync  *)
  playerErrorCode     * = playerBase+15;  (* error return value           *)


(*****************************************************************************)


(* Method types for messages sent via a Player's hook *)
  pmTick              * = 0;
  pmState             * = 1;
  pmPosition          * = 2;
  pmShuttle           * = 3;

TYPE
  Msg * = STRUCT END;  (* dummy base for all message type *)

(* used for PM_TICK, PM_POSITION and PM_SHUTTLE methods *)
  PMTime * = STRUCT (msg * : Msg)
    method       * : LONGINT;        (* PM_TICK, PM_POSITION, or PM_SHUTTLE *)
    time         * : LONGINT;
  END;

(* used for the PM_STATE method *)
  PMState * = STRUCT (msg * : Msg)
    method       * : LONGINT;        (* PM_STATE *)
    oldState     * : LONGINT;
  END;


(*****************************************************************************)
CONST

(* Possible lock types for LockRealTime() *)
  conductors     * = 0;   (* conductor list *)


(*****************************************************************************)


(* realtime.library error codes *)
  noMemory         * = 801;   (* memory allocation failed      *)
  noConductor      * = 802;   (* player needs a conductor      *)
  noTimer          * = 803;   (* timer (CIA) allocation failed *)
  playing          * = 804;   (* can't shuttle while playing   *)


(*****************************************************************************)
TYPE

(* OpenLibrary("realtime.library",0) returns a pointer to this structure.
 * All fields are READ-ONLY.
 *)
  RealTimeBase * = STRUCT (LibNode - : e.Library)
    reserved0    - : ARRAY 2 OF SHORTINT;

    time         - : LONGINT;          (* current time                         *)
    timeFrac     - : LONGINT;          (* fixed-point fraction part of time    *)
    reserved1    - : INTEGER;
    tickErr      - : INTEGER;          (* nanosecond error from ideal Tick     *)
  END;                                 (* length to real tick length           *)

CONST
(* Actual tick length is: 1/TICK_FREQ + rtb_TickErr/1e9 *)

  tickErrMin     * = -705;
  tickErrMax     * =  705;

TYPE
  RealTimeLock * = UNTRACED POINTER TO STRUCT END;

(*****************************************************************************)

VAR
  base * : RealTimeBasePtr;

(*--- functions in V37 or higher (Release 2.04) ---*)

(* Locks *)

PROCEDURE LockRealTime   *{base,-01EH}(lockType{0}    : LONGINT): RealTimeLock;
PROCEDURE UnlockRealTime *{base,-024H}(lock{8}        : RealTimeLock);

(* Conductor *)

PROCEDURE CreatePlayerA  *{base,-02AH}(tagList{8}     : ARRAY OF u.TagItem): PlayerPtr;
PROCEDURE CreatePlayer   *{base,-02AH}(tag1{8}..      : u.Tag): PlayerPtr;
PROCEDURE DeletePlayer   *{base,-030H}(player{8}      : PlayerPtr);
PROCEDURE SetPlayerAttrsA*{base,-036H}(player{8}      : PlayerPtr;
                                      tagList{9}      : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE SetPlayerAttrs *{base,-036H}(player{8}      : PlayerPtr;
                                      tag1{9}..       : u.Tag): BOOLEAN;
PROCEDURE SetConductorState*{base,-03CH}(player{8}    : PlayerPtr;
                                      state{0}        : LONGINT;
                                      time{1}         : LONGINT ): LONGINT;
PROCEDURE ExternalSync   *{base,-042H}(player{8}      : PlayerPtr;
                                      minTime{0}      : LONGINT;
                                      maxTime{1}      : LONGINT ): BOOLEAN;
PROCEDURE NextConductor  *{base,-048H}(previousConductor{8}: ConductorPtr): ConductorPtr;
PROCEDURE FindConductor  *{base,-04EH}(name{8}        : ARRAY OF CHAR): ConductorPtr;
PROCEDURE GetPlayerAttrsA*{base,-054H}(player{8}      : PlayerPtr;
                                      tagList{9}      : ARRAY OF u.TagItem): LONGINT;
PROCEDURE GetPlayerAttrs *{base,-054H}(player{8}      : PlayerPtr;
                                      tag1{9}..       : u.Tag): LONGINT;

END RealTime.

