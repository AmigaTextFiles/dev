(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Audio.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Audio;   (* $Implementation- *)

IMPORT e * := Exec;

CONST

  audioName * = "audio.device";

  hardChannels      * = 4;

  allocMinprec      * = -128;
  allocMaxprec      * = 127;

  free              * = e.nonstd+0;
  setPrec           * = e.nonstd+1;
  finish            * = e.nonstd+2;
  perVol            * = e.nonstd+3;
  lock              * = e.nonstd+4;
  waitCycle         * = e.nonstd+5;
  allocate          * = 32;

  pervol            * = 4;
  syncCycle         * = 5;
  noWait            * = 6;
  writeMessage      * = 7;

  noAllocation      * = -10;
  allocFailed       * = -11;
  channelStolen     * = -12;


TYPE

  IOAudioPtr * = UNTRACED POINTER TO IOAudio;
  IOAudio * = STRUCT (request * : e.IORequest)
    allocKey * : INTEGER;
    data * : e.APTR;
    length * : LONGINT;
    period * : INTEGER;
    volume * : INTEGER;
    cycles * : INTEGER;
    writeMsg * : e.Message;
  END;

END Audio.

