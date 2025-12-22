(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Narrator.mod 40.15 (28.12.93) Oberon 3.4
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE Narrator;   (* $Implementation- *)

IMPORT e * := Exec;

CONST

                (*          Device Options      *)

  newIORB     * = 0;       (* Use new extended IORB                *)
  wordSync    * = 1;       (* Generate word sync messages          *)
  sylSync     * = 2;       (* Generate syllable sync messages      *)



                (*          Error Codes         *)

  noMem       * =  -2;      (* Can't allocate memory                *)
  noAudLib    * =  -3;      (* Can't open audio device              *)
  makeBad     * =  -4;      (* Error in MakeLibrary call            *)
  unitErr     * =  -5;      (* Unit other than 0                    *)
  cantAlloc   * =  -6;      (* Can't allocate audio channel(s)      *)
  unimpl      * =  -7;      (* Unimplemented command                *)
  noWrite     * =  -8;      (* Read for mouth without write first   *)
  expunged    * =  -9;      (* Can't open, deferred expunge bit set *)
  phonErr     * = -20;      (* Phoneme code spelling error                  *)
  rateErr     * = -21;      (* Rate out of bounds                   *)
  pitchErr    * = -22;      (* Pitch out of bounds                          *)
  sexErr      * = -23;      (* Sex not valid                        *)
  modeErr     * = -24;      (* Mode not valid                       *)
  freqErr     * = -25;      (* Sampling frequency out of bounds     *)
  volErr      * = -26;      (* Volume out of bounds         *)
  dCentErr    * = -27;      (* Degree of centralization out of bounds *)
  centPhonErr * = -28;      (* Invalid central phon                 *)



                (* Input parameters and defaults *)

  defPitch    * = 110;         (* Default pitch                        *)
  defRate     * = 150;         (* Default speaking rate (wpm)                  *)
  defVol      * = 64;          (* Default volume (full)                *)
  defFreq     * = 22200;       (* Default sampling frequency (Hz)      *)
  male        * = 0;           (* Male vocal tract                     *)
  female      * = 1;           (* Female vocal tract                   *)
  naturalF0   * = 0;           (* Natural pitch contours               *)
  roboticF0   * = 1;           (* Monotone pitch                       *)
  manualF0    * = 2;           (* Manual setting of pitch contours     *)
  defSex      * = male;        (* Default sex                                  *)
  defMode     * = naturalF0;   (* Default mode                 *)
  defArtic    * = 100;         (* 100% articulation (normal)           *)
  defCentral  * = 0;           (* No centralization                    *)
  defF0Pert   * = 0;           (* No F0 Perturbation                   *)
  defF0Enthus * = 32;          (* Default F0 enthusiasm (in 32nds)     *)
  defPriority * = 100;         (* Default speaking priority            *)


                        (*      Parameter bounds        *)

  minRate     * = 40;          (* Minimum speaking rate                *)
  maxRate     * = 400;         (* Maximum speaking rate                *)
  minPitch    * = 65;          (* Minimum pitch                        *)
  maxPitch    * = 320;         (* Maximum pitch                        *)
  minFreq     * = 5000;        (* Minimum sampling frequency           *)
  maxFreq     * = 28000;       (* Maximum sampling frequency           *)
  minVol      * = 0;           (* Minimum volume                       *)
  maxVol      * = 64;          (* Maximum volume                       *)
  minCent     * = 0;           (* Minimum degree of centralization     *)
  maxCent     * = 100;         (* Maximum degree of centralization     *)


TYPE

                (*    Standard Write request    *)

  NarratorPtr * = UNTRACED POINTER TO Narrator;
  Narrator * = STRUCT (message * : e.IOStdReq)
            (* Standard IORB                *)
    rate * : INTEGER;                   (* Speaking rate (words/minute) *)
    pitch * : INTEGER;                  (* Baseline pitch in Hertz              *)
    mode * : INTEGER;                   (* Pitch mode                   *)
    sex * : INTEGER;                    (* Sex of voice                 *)
    chMasks * : e.APTR;                 (* Pointer to audio alloc maps  *)
    nmMasks * : INTEGER;                (* Number of audio alloc maps   *)
    volume * : INTEGER;                 (* Volume. 0 (off) thru 64      *)
    sampfreq * : INTEGER;               (* Audio sampling freq                  *)
    mouths * : BOOLEAN;                 (* If non-zero, generate mouths *)
    chanmask * : e.BYTE;                (* Which ch mask used (internal)*)
    numchan * : e.BYTE;                 (* Num ch masks used (internal) *)
    flags * : SHORTSET;                 (* New feature flags            *)
    f0enthusiasm * : SHORTINT;          (* F0 excursion factor          *)
    f0perturb * : SHORTINT;             (* Amount of F0 perturbation    *)
    f1adj * : SHORTINT;                 (* F1 adjustment in ±5% steps   *)
    f2adj * : SHORTINT;                 (* F2 adjustment in ±5% steps   *)
    f3adj * : SHORTINT;                 (* F3 adjustment in ±5% steps   *)
    a1adj * : SHORTINT;                 (* A1 adjustment in decibels    *)
    a2adj * : SHORTINT;                 (* A2 adjustment in decibels    *)
    a3adj * : SHORTINT;                 (* A3 adjustment in decibels    *)
    articulate * : SHORTINT;            (* Transition time multiplier   *)
    centralize * : SHORTINT;            (* Degree of vowel centralization *)
    centphon * : e.APTR;                (* Pointer to central ASCII phon  *)
    avBias * : SHORTINT;                (* AV bias                      *)
    afBias * : SHORTINT;                (* AF bias                      *)
    priority * : SHORTINT;              (* Priority while speaking      *)
    pad1 * : SHORTINT;                  (* For alignment                *)
  END;


                (*    Standard Read request     *)

  MouthPtr * = UNTRACED POINTER TO Mouth;
  Mouth * = STRUCT (voice * : Narrator) (* Speech IORB                 *)
    width  *: e.BYTE;                   (* Width (returned value)      *)
    height *: e.BYTE;                   (* Height (returned value)     *)
    shape  -: e.BYTE;                   (* Internal use, do not modify *)
    sync   *: e.BYTE;                   (* Returned sync events        *)
  END;

END Narrator.




