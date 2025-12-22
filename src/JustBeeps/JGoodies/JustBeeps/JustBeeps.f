\ Audio Device Interface Example for JForth Professional
\
\ Example 1: Play a series of beeps using a just intoned scale.
\    Open one audio channel, play beeps, then close it.
\
\ -----------------------------------------------------
\ A more advanced audio interface is provided as part of
\ HMSL, the Hierarchical Music Specification Language
\ available from:
\
\	Frog Peak Music
\	P.O. Box 1051
\	San Rafael, CA
\	94915
\
\ Write for pricing and availability.
\ HMSL also supports MIDI and provides a rich set of tools
\ for experimental object oriented composition.
\ ------------------------------------------------------
\
\ Author: Phil Burk
\ Hereby placed in the Public Domain. May be freely redistributed.

decimal
getmodule includes
include? CreatePort() ju:Exec_Support
include? BeginIO() ju:device-calls
include? IOAudio ji:devices/audio.j
include? choose ju:random
\ This next file is included to support time delays.
\ It is expected in the same directory as this file.
include? timer.create SimpleTimer.f

ANEW TASK-JustBeeps

\ To really understand this example, and many others, you
\ really should get the ROM Kernel Manual for the Amiga.
\ The Intuition Manual is also extremely helpful.
\ They are expensive but definitely worth it.

\ Low Level Audio Device Support

\ An IO Request Block is used to communicate with the Audio Device driver.
: AD.ALLOC.IOB  ( -- iob | NULL , dynamically allocate IO Block )
    memf_chip memf_public | memf_clear |  ( memory type )
    sizeof() IOAudio         ( # bytes )
    allocblock
;

\ Allocate a reply port for the IO Request Block
: AD.CREATE.PORT ( iob -- port | NULL )
    0 0 CreatePort() dup
\ Must be absolute for Amiga to use.
    IF  tuck >abs swap .. ioa_Request .. io_Message ..! mn_Replyport
    ELSE nip
    THEN
;

\ Allocate any available channel.
binary
create CHAN-MASK 0001 c, 0010 c, 0100 c, 1000 c,
decimal

: AD.OPEN.ANY.CHAN  ( chan iob -- error , open device with allocation )
    10 over .. ioa_Request .. io_Message .. mn_Node ..! ln_Pri
    0 over ..! ioa_AllocKey
\ must be absolute for Amiga to use.
    chan-mask >abs over ..! ioa_Data
    4 over ..! ioa_Length
\
    >r AudioName 0 r> 0 OpenDevice()
;

\ Variables to keep track of what has been allocated and opened.
variable AUDIOB-0
variable AUDIOB-1
variable AD-DEVICE-OPEN
variable AD-PORT

: FREEVAR ( addr-of-pointer -- , free what's pointed to )
    dup @ ?dup
    IF ( -- addr-of-ptr ptr ) FreeBlock off
    ELSE drop
    THEN
;

: FREE.AUDIO ( -- , free everything but check first )
    ad-device-open @
    IF audiob-0 @ CloseDevice()
       ad-device-open off
    THEN
\
    ad-port @ ?dup
    IF  DeletePort()
    THEN
\
    audiob-0 freevar
    audiob-1 freevar
;

: ALLOC.AUDIO ( -- error , allocate audio for application )
\ Clear variables for proper tracking of allocated data.
    audiob-0 off
    audiob-1 off
    ad-port off
    ad-device-open off

\ Allocate necessary structures.
\ Create 2 IO Request Blocks
    ad.alloc.iob ?dup
    IF  audiob-1 !
        ad.alloc.iob ?dup
        IF dup audiob-0 !
\ Attach a reply port.
           dup ad.create.port ?dup
\ Now open the Audio Device
           IF ad-port ! ad.open.any.chan
              IF free.audio true  ( free everything if not OK )
              ELSE ad-device-open on false
              THEN
           ELSE free.audio true
           THEN
        ELSE free.audio true
        THEN
    THEN
\
\ Second IOB is copy of first.
    audiob-0 @ audiob-1 @ sizeof() IOAudio cmove
;

\ Waveforms must be stored in CHIP RAM for access by
\ Audio DMA hardware.
variable WAVE-PTR
create WAVE-TEMPLATE
here   ( current dictionary pointer for calculating wave size )
    0 c, 40 c, 90 c, 127 c,
    -50 c, -128 c, -70 c, -10 c,
here swap - constant WAVE_SIZE

: MAKE.WAVEFORM ( -- error , copy waveform to CHIP RAM )
    MEMF_CHIP wave_size allocblock ?dup
    IF  dup wave-ptr !
        wave-template swap wave_size cmove false
    ELSE true
    THEN
;

: FREE.WAVEFORM ( -- )
    wave-ptr freevar
;

: SET.SAMPLE ( addr count iob -- , set address and count )
    tuck ..! ioa_Length
    >r >abs r> ..! ioa_Data
;

: SET.PERIOD ( period iob -- , set period, inverse of frequency )
    ..! ioa_Period
;

: SET.DEFAULTS ( iob -- , set volume, etc )
    400 over ..! ioa_Period
    64 over ..! ioa_Volume
    0 swap ..! ioa_Cycles
;

: START.WAVE ( iob -- , start playing a sound )
    CMD_WRITE over .. ioa_Request ..! io_Command
    ADIOF_PERVOL over .. ioa_Request ..! io_Flags
    BeginIO() drop
;

: STOP.WAVE ( iob -- , stop sound from playing )
    ADCMD_FINISH over .. ioa_Request ..! io_Command
    IOF_QUICK ADIOF_SYNCCYCLE | over .. ioa_Request ..! io_Flags
    BeginIO() drop
;

\ Seed the random number generator with the current time
\ so that JustBeeps will always produce different notes.
: RANDOM.INIT ( -- , seed random number generator with time )
\ CurrentTime will write current time into variable.
    rand-seed >abs dup callvoid intuition_lib CurrentTime
;

variable TIMER-IOB

: TA.INIT  ( -- error , set up everything )
    timer-iob off
\
    intuition?
    random.init
\
    alloc.audio
    IF  ." Couldn't open Audio Channel!" cr true
\
    ELSE make.waveform
        IF  ." Couldn't allocate CHIP RAM waveform!" cr true
\
        ELSE audiob-0 @ set.defaults
            wave-ptr @ wave_size audiob-0 @ set.sample
\
\ Create a timer request block for accurate timing.
            UNIT_MICROHZ timer.create ?dup
            IF timer-iob ! false
            ELSE ." Couldn't create timer!" cr true
            THEN
        THEN
    THEN
;

: TA.TERM  ( -- )
    timer-iob @ ?dup
    IF timer.delete
    THEN
    free.waveform
    free.audio
;

: START.NOTE  ( period micros -- , start playing a note )
    swap audiob-0 @ set.period
    audiob-0 @ start.wave
\
\ Start next delay.
    1,000,000 /mod swap timer-iob @ timer.send
;

: FINISH.NOTE ( -- )
\ Wait for previous delay to finish.
    timer-iob @ WaitIO() ?dup
    IF ." Error in wait() for timer = " . cr
    THEN
\
    audiob-1 @ stop.wave
\ Wait for sound to stop.
    audiob-0 @ WaitIO() drop
;

variable LAST-PERIOD
\ Select random numerators and denominators to calculate
\ new period.  Make sure it is within a 4 octave range.
: NEXT.PERIOD  ( -- period , calculate new period )
    10 0  ( try ten times to get a new period within range )
    DO  last-period @ ." *"
        7 choose 1+ dup 1 .r  *  ( choose random number 1 through 7 )
        7 choose 1+ dup ." /" 1 .r /  ( new = last * r1 / r2 )
\ Use it if within 4 octave range.
        dup 300 dup 4 ashift within?
        IF ."  -> "dup . last-period ! LEAVE
        ELSE drop
        THEN ." , "
    LOOP cr
    last-period @
;

variable IF-NOTE-ON

: TA.PLAY  ( -- , play several notes )
    900 last-period !
    if-note-on off
    BEGIN
\ Perform calculations while clock is running
\ for more accurate timing.
        next.period
\ Choose a duration either 200,000 or 400,000 micros long.
        2 choose 1+ 200,000 *
\ Finish previous note, if any.
        if-note-on @
        IF finish.note
        THEN
\ Start next note using precalcuted parameters.
        start.note   if-note-on on
        ?terminal
    UNTIL key drop  ( eat key from ?terminal )
    if-note-on @
    IF finish.note
    THEN

;

: SHOW.BANNER ( -- )
    cr ." Play a series of notes using random just intoned intervals." cr
    ." Written by Phil Burk using JForth Professional!" cr
    ." Public Domain.  Freely Redistributable" cr
;

: JustBeeps ( -- , play a series of just intoned beeps )
    show.banner
    ." Hit <RETURN> to stop!" cr cr
    ta.init 0=
    IF ta.play show.banner
    ELSE cr ." Could not open a sound channel!" cr
    THEN
    ta.term
;

cr
." Enter: JustBeeps     to hear demo!" cr
." Make sure your audio is connected and your volume is up." cr

