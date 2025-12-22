(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Hardware.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Hardware; (* $Implementation- *)

IMPORT e * := Exec;

CONST
(* ADKBits: *)
  adkSet   * = 15; (* standard set/clear bit *)
  preComp1 * = 14; (* two bits of precompensation *)
  preComp0 * = 13;
  mfmPrec  * = 12; (* use mfm style precompensation *)
  uartBrk  * = 11; (* force uart output to zero *)
  wordSync * = 10; (* enable DSKSYNC register matching *)
  msbSync  * = 9;  (* (Apple GCR Only) sync on MSB for reading *)
  fast     * = 8;  (* 1 -> 2 us/bit (mfm), 2 -> 4 us/bit (gcr) *)
  use3pn   * = 7;  (* use aud chan 3 to modulate period of ?? *)
  use2p3   * = 6;  (* use aud chan 2 to modulate period of 3 *)
  use1p2   * = 5;  (* use aud chan 1 to modulate period of 2 *)
  use0p1   * = 4;  (* use aud chan 0 to modulate period of 1 *)
  use3vn   * = 3;  (* use aud chan 3 to modulate volume of ?? *)
  use2v3   * = 2;  (* use aud chan 2 to modulate volume of 3 *)
  use1v2   * = 1;  (* use aud chan 1 to modulate volume of 2 *)
  use0v1   * = 0;  (* use aud chan 0 to modulate volume of 1 *)

  pre000ns  * = {};                  (* 000 ns of precomp *)
  pre140ns  * = {preComp0};          (* 140 ns of precomp *)
  pre280ns  * = {preComp1};          (* 280 ns of precomp *)
  pre560ns  * = {preComp0,preComp1}; (* 560 ns of precomp *)

  hSizeBits * = 6;
  vSizeBits * = 16-hSizeBits;
  hSizeMask * = 3FH;        (* 2^6  - 1 *)
  vSizeMask * = 3FFH;       (* 2^10 - 1 *)

(* all agnii support horizontal blit of at least 1024 bits (128 bytes) wide *)
(* some agnii support horizontal blit of up to 32768 bits (4096 bytes) wide *)

  minBytesPerRow * = 128;
  maxBytesPerRow * = 4096;

  maxBytesPerRowNoBigBlits * = 128;

(* definitions for blitter control register 0 *)

  abc    * = 7;
  abnc   * = 6;
  anbc   * = 5;
  anbnc  * = 4;
  nabc   * = 3;
  nabnc  * = 2;
  nanbc  * = 1;
  nanbnc * = 0;


(* some commonly used operations *)
  aORb   * = {abc,abnc,anbc,anbnc,nabc,nabnc};
  aORc   * = {abc,abnc,anbc,anbnc,nabc,      nanbc};
  aXORc  * = {    abnc,     anbnc,nabc,            nanbc};
  aTOd   * = {abc,abnc,anbc,anbnc};

  dest   * = 8;
  srcC   * = 9;
  srcB   * = 10;
  srcA   * = 11;
  ash1   * = 12;
  ash2   * = 13;
  ash4   * = 14;
  ash8   * = 15;



  aShiftShift * = 12;      (* bits to right align ashift value *)
  bShiftShift * = 12;      (* bits to right align bshift value *)


(* definations for blitter control register 1 *)
  lineMode     * = 0;
  fillOr       * = 3;
  fillXor      * = 4;
  fillCarryIn  * = 2;
  desc         * = 1;       (* blitter descend direction *)
  oneDot       * = 1;     (* one dot per horizontal line *)
  ovFlag       * = 5;
  signFlag     * = 6;
  blitReverse  * = 1;

  sud    * = {fillXor};
  sul    * = {fillOr};
  aul    * = {fillCarryIn};

  octant8   * = sul+sud;
  octant7   * = aul;
  octant6   * = aul+sul;
  octant5   * = aul+sul+sud;
  octant4   * = aul+sud;
  octant3   * = sul;
  octant2   * = {};
  octant1   * = sud;


TYPE

(* stuff for blit queuer *)
  BltnodePtr * = UNTRACED POINTER TO Bltnode;
  Bltnode * = STRUCT
    n * : BltnodePtr;
    function * : e.PROC;
    stat     * : CHAR;
    blitsize * : INTEGER;
    beamsync * : INTEGER;
    cleanup  * : e.PROC;
  END;

CONST

(* defined bits for bltstat *)
  cleanup * = 40H;
  cleanme * = cleanup;

TYPE

(*
 * ciaa is on an ODD address (e.g. the low byte) -- 0BFE001H
 * ciab is on an EVEN address (e.g. the high byte) -- 0BFD000H
 *
 * do this to get the definitions:
 *    extern struct CIA ciaa, ciab;
 *)

  Pad * = ARRAY 254 OF SHORTSET;

  CIA * = STRUCT
    pra    * : SHORTSET; pad0 * : Pad;
    prb    * : SHORTSET; pad1 * : Pad;
    ddra   * : SHORTSET; pad2 * : Pad;
    ddrb   * : SHORTSET; pad3 * : Pad;
    talo   * : SHORTINT; pad4 * : Pad;
    tahi   * : SHORTINT; pad5 * : Pad;
    tblo   * : SHORTINT; pad6 * : Pad;
    tbhi   * : SHORTINT; pad7 * : Pad;
    todlow * : SHORTINT; pad8 * : Pad;
    todmid * : SHORTINT; pad9 * : Pad;
    todhi  * : SHORTINT; pad10 * : Pad;
    unusedreg * : SHORTSET; pad11 * : Pad;
    sdr    * : SHORTINT; pad12 * : Pad;
    icr    * : SHORTSET; pad13 * : Pad;
    cra    * : SHORTSET; pad14 * : Pad;
    crb    * : SHORTSET;
  END;

VAR
  ciaa * [0BFE001H] : CIA;
  ciab * [0BFD000H] : CIA;

CONST

(* interrupt control register bit numbers *)
  ta      * = 0;
  tb      * = 1;
  alrm    * = 2;
  sp      * = 3;
  flg     * = 4;
  setClr  * = 7;
  ir      * = 7;

(* control register A bit numbers *)
  craStart   * = 0;
  craPbon    * = 1;
  craOutmode * = 2;
  craRunmode * = 3;
  craLoad    * = 4;
  craInmode  * = 5;
  craSpmode  * = 6;
  craTodin   * = 7;

(* control register B bit numbers *)
  crbStart   * = 0;
  crbPbon    * = 1;
  crbOutmode * = 2;
  crbRunmode * = 3;
  crbLoad    * = 4;
  crbInmode0 * = 5;
  crbInmode1 * = 6;
  crbAlarm   * = 7;

(*
 * Port definitions -- what each bit in a cia peripheral register is tied to
 *)

(* ciaa port A (0xbfe001) *)
  gamePort1  * = 7;   (* gameport 1, pin 6 (fire button) *)
  gamePort0  * = 6;   (* gameport 0, pin 6 (fire button) *)
  dskRdy     * = 5;   (* disk ready* *)
  dskTrack0  * = 4;   (* disk on track 00* *)
  dskProt    * = 3;   (* disk write protect* *)
  dskChange  * = 2;   (* disk change* *)
  led        * = 1;   (* led light control (0==>bright) *)
  overlay    * = 0;   (* memory overlay bit *)

(* ciaa port B (0xbfe101) -- parallel port *)

(* ciab port A (0xbfd000) -- serial and printer control *)
  comDTR     * = 7;   (* serial Data Terminal Ready* *)
  comRTS     * = 6;   (* serial Request to Send* *)
  comCD      * = 5;   (* serial Carrier Detect* *)
  comCTS     * = 4;   (* serial Clear to Send* *)
  comDSR     * = 3;   (* serial Data Set Ready* *)
  prtrSel    * = 2;   (* printer SELECT *)
  prtrPOut   * = 1;   (* printer paper out *)
  prtrBusy   * = 0;   (* printer busy *)

(* ciab port B (0xbfd100) -- disk control *)
  dskMotor   * = 7;   (* disk motorr* *)
  dskSel3    * = 6;   (* disk select unit 3* *)
  dskSel2    * = 5;   (* disk select unit 2* *)
  dskSel1    * = 4;   (* disk select unit 1* *)
  dskSel0    * = 3;   (* disk select unit 0* *)
  dskSide    * = 2;   (* disk side select* *)
  dskDirec   * = 1;   (* disk direction of seek* *)
  dskStep    * = 0;   (* disk step heads* *)


TYPE

(*
 * do this to get base of custom registers:
 * extern struct Custom custom;
 *)

  Coord      * = STRUCT v*,h*: SHORTINT END;
  SerialInfo * = STRUCT flags * : SHORTSET; data * : CHAR END;
  DiskInfo   * = STRUCT flags * : SHORTSET; data * : e.BYTE END;

  AudChannel * = STRUCT
    ptr * : e.APTR;      (* ptr to start of waveform data *)
    len * : INTEGER;     (* length of waveform in words *)
    per * : INTEGER;     (* sample period *)
    vol * : INTEGER;     (* volume *)
    dat * : INTEGER;     (* sample pair *)
    pad * : ARRAY 2 OF INTEGER; (* unused *)
  END;
  AudChannels * = ARRAY 4 OF AudChannel;

  SpriteDef * = STRUCT
    pos * : INTEGER;
    ctl * : STRUCT
              ev * : e.BYTE;
              flags * : SHORTSET;
            END;
    data * : LONGINT;
  END;
  SpriteDefs * = ARRAY 8 OF SpriteDef;

  Custom * = STRUCT
    bltddat * : INTEGER;
    dmaconr * : SET;
    vposr   * : INTEGER;
    vhposr  * : INTEGER;
    dskdatr * : INTEGER;
    joy0dat * : Coord;
    joy1dat * : Coord;
    clxdat  * : SET;
    adkconr * : SET;
    pot0dat * : Coord;
    pot1dat * : Coord;
    potinp  * : SET;
    serdatr * : SerialInfo;
    dskbytr * : DiskInfo;
    intenar * : SET;
    intreqr * : SET;
    dskpt   * : e.APTR;
    dsklen  * : INTEGER;
    dskdat  * : INTEGER;
    refptr  * : INTEGER;
    vposw   * : INTEGER;
    vhposw  * : INTEGER;
    copcon  * : SET;
    serdat  * : SerialInfo;
    serper  * : INTEGER;
    potgo   * : SET;
    joytest * : Coord;
    strequ  * : INTEGER;
    strvbl  * : INTEGER;
    strhor  * : INTEGER;
    strlong * : INTEGER;
    bltcon0 * : SET;
    bltcon1 * : SET;
    bltafwm * : SET;
    bltalwm * : SET;
    bltcpt  * : e.APTR;
    bltbpt  * : e.APTR;
    bltapt  * : e.APTR;
    bltdpt  * : e.APTR;
    bltsize * : INTEGER;
    pad2d   * : e.BYTE;
    bltcon0l * : SHORTSET;   (* low 8 bits of bltcon0, write only *)
    bltsizv  * : INTEGER;
    bltsizh  * : INTEGER;    (* 5e *)
    bltcmod  * : INTEGER;
    bltbmod  * : INTEGER;
    bltamod  * : INTEGER;
    bltdmod  * : INTEGER;
    pad34    * : ARRAY 4 OF INTEGER;
    bltcdat  * : INTEGER;
    bltbdat  * : INTEGER;
    bltadat  * : INTEGER;
    pad3b    * : ARRAY 3 OF INTEGER;
    deniseid * : INTEGER;   (* 7c *)
    dsksync * : INTEGER;
    cop1lc  * : LONGINT;
    cop2lc  * : LONGINT;
    copjmp1 * : INTEGER;
    copjmp2 * : INTEGER;
    copins  * : INTEGER;
    diwstrt * : Coord;
    diwstop * : Coord;
    ddfstrt * : Coord;
    ddfstop * : Coord;
    dmacon  * : SET;
    clxcon  * : SET;
    intena  * : SET;
    intreq  * : SET;
    adkcon  * : SET;
    aud     * : AudChannels;
    bplpt   * : ARRAY 8 OF e.APTR;
    bplcon0 * : SET;
    bplcon1 * : SET;
    bplcon2 * : SET;
    bplcon3 * : SET;
    bpl1mod * : INTEGER;
    bpl2mod * : INTEGER;
    bplcon4 * : INTEGER;
    clxcon2 * : INTEGER;
    bpldat  * : ARRAY 8 OF INTEGER;;
    sprpt   * : ARRAY 8 OF e.APTR;
    spr     * : SpriteDefs;
    color   * : ARRAY 32 OF INTEGER;
    htotal  * : INTEGER;
    hsstop  * : INTEGER;
    hbstrt  * : INTEGER;
    hbstop  * : INTEGER;
    vtotal  * : INTEGER;
    vsstop  * : INTEGER;
    vbstrt  * : INTEGER;
    vbstop  * : INTEGER;
    sprhstrt * : INTEGER;
    sprhstop * : INTEGER;
    bplhstrt * : INTEGER;
    bplhstop * : INTEGER;
    hhposw   * : INTEGER;
    hhposr   * : INTEGER;
    beamcon0 * : SET;
    hsstrt   * : INTEGER;
    vsstrt   * : INTEGER;
    hcenter  * : INTEGER;
    diwhigh  * : INTEGER;    (* 1e4 *)
    padf3    * : ARRAY 11 OF INTEGER;
    fmode    * : INTEGER;
  END;

VAR
  custom * [0DFF000H] : Custom;

CONST

(* defines for beamcon register *)
  varVBlank     * = 12;  (* Variable vertical blank enable *)
  loLDis        * = 11;  (* long line disable *)
  cscBlankEn    * = 10;  (* redirect composite sync *)
  varVSync      * = 9;  (* Variable vertical sync enable *)
  varHSync      * = 8;  (* Variable horizontal sync enable *)
  varBeam       * = 7;  (* variable beam counter enable *)
  displayDual   * = 6;  (* use UHRES pointer and standard pointers *)
  displayPal    * = 5;  (* set decodes to generate PAL display *)
  varCSync      * = 4;  (* Variable composite sync enable *)
  csBlank       * = 3;  (* Composite blank out to CSY* pin *)
  cSyncTrue     * = 2;  (* composite sync true signal *)
  vSyncTrue     * = 1;  (* vertical sync true *)
  hSyncTrue     * = 0;  (* horizontal sync true *)

(* new defines for bplcon0 *)
  useBplCon3 * = 1;

(* new defines for bplcon2 *)
  zdCTen        * = 10; (* colormapped genlock bit *)
  zdBPen        * = 11; (* use bitplane as genlock bits *)
  udBPSel0      * = 12; (* three bits to select one *)
  zdBPSel1      * = 13; (* of 8 bitplanes in *)
  zdBPSel2      * = 14; (* ZDBPEN genlock mode *)

(* defines for bplcon3 register *)
  extBlnkEn     * = 0;  (* external blank enable *)
  extBlkZd      * = 1;  (* external blank ored into trnsprncy *)
  zdClkEn       * = 2;  (* zd pin outputs a 14mhz clock*)
  brdnTran      * = 4;  (* border is opaque *)
  drdnBlnk      * = 5;  (* border is opaque *)

(* write definitions for dmaconw *)
  dmaSet  * = 15;
  audio   * = {0..3};   (* 4 bit mask *)
  aud0    * = 0;
  aud1    * = 1;
  aud2    * = 2;
  aud3    * = 3;
  disk    * = 4;
  sprite  * = 5;
  blitter * = 6;
  copper  * = 7;
  raster  * = 8;
  master  * = 9;
  blithog * = 10;
  all     * = {0..8};    (* all dma channels *)

  bitSet * = {dmaSet};
  bitClr * = {};

(* read definitions for dmaconr *)
(* bits 0-8 correspnd to dmaconw definitions *)
  bltdone * = 14;
  bltnzero* = 13;


CONST

(* intbits: *)

  intSet   * = 15;  (* Set/Clear control bit. Determines if bits *)
                  (* written with a 1 get set or cleared. Bits *)
                  (* written with a zero are allways unchanged *)
  intEn    * = 14;  (* Master interrupt (enable only ) *)
  exter    * = 13;  (* External interrupt *)
  dskSync  * = 12;  (* Disk re-SYNChronized *)
  rbf      * = 11;  (* serial port Receive Buffer Full *)
  aud3i    * = 10;  (* Audio channel 3 block finished *)
  aud2i    * = 9;   (* Audio channel 2 block finished *)
  aud1i    * = 8;   (* Audio channel 1 block finished *)
  aud0i    * = 7;   (* Audio channel 0 block finished *)
  blit     * = 6;   (* Blitter finished *)
  vertb    * = 5;   (* start of Vertical Blank *)
  coper    * = 4;   (* Coprocessor *)
  ports    * = 3;   (* I/O Ports and timers *)
  softint  * = 2;   (* software interrupt request *)
  dskblk   * = 1;   (* Disk Block done *)
  tbe      * = 0;   (* serial port Transmit Buffer Empty *)


END Hardware.


