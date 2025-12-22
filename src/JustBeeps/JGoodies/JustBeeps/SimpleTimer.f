\ Use the Amiga Timer Device for accurate timing
\ of music and sound.
\ This is more accurate then using DOS_LIB DELAY
\ or software timing loops.
\
\ Author: Phil Burk
\ Hereby placed in the Public Domain. May be freely redistributed.
\
decimal
getmodule includes
include? CreatePort() ju:Exec_Support
include? BeginIO() ju:device-calls
include? TimeRequest ji:devices/timer.j

ANEW TASK-TIMER.F

: TIMER.DELETE ( timereq --  , delete timer request message)
    dup CloseDevice()
\ Delete Port if one attached.
    dup .. io_message ..@ mn_replyport if>rel ?dup
    IF  DeletePort()
    THEN
    sizeof() TimeRequest DeleteExtIO()
;

: TIMER.CREATE  ( units -- timereq , open and initialize timer )
\ Create a reply port
    0 0 createPort() ?dup
    IF  ( -- units port )
\
\ Create an extended IO Request message
        dup sizeof() TimeRequest CreateExtIO() ?dup
        IF  ( -- units port iob )
\
\ Open the device using this message.
            >r TIMERNAME rot r@ 0 OpenDevice()
            IF ( -- port )
               ." Couldn't Open Timer Device!" cr
               r> sizeof() TimeRequest DeleteExtIO()
               DeletePort() NULL
            ELSE drop r>
            THEN
        ELSE ." TIMER.CREATE - Couldn't CreateExtIO" cr
            DeletePort() drop NULL
        THEN
    ELSE ." TIMER.CREATE - Couldn't create port." cr
         drop NULL
    THEN
;

: TIMER.SEND  ( seconds micros timereq -- , send off request)
\ Set time values and command in message and send.
    dup>r .. tr_time ..! tv_micro
    r@ .. tr_time ..! tv_secs
    TR_ADDREQUEST r@ ..! io_command
    r> SendIO() drop ( result is meaningless )
;


\ Example of using Timer
variable TIMER-MSG

: IOB>SIGNAL ( iob -- signal_mask , extract signal from IO request )
    .. io_message ..@ mn_replyport >rel
    ..@ mp_sigbit
    1 swap shift
;

: Wait() ( signalmask -- signals , wait for some signals )
    call exec_lib wait
;

: TEST.TIMER ( -- )
    UNIT_MICROHZ timer.create ?dup
    IF  timer-msg !
        cr ." Delay 2 seconds" cr
        2 0 timer-msg @ timer.send
        timer-msg @  WaitIO() ?dup
        IF ." Error on WaitIO() = " . cr
        THEN
\
        ." Delay 3/4 seconds" cr
        0 750,000 timer-msg @ timer.send
\ Instead of using WaitIO, you could get the signal bits
\ from this message, OR them with other signal bits,
\ then wait on and several signals.
        timer-msg @ iob>signal
\ optionally OR with other bits  ( mouse_signal OR ) etc.
        Wait() ." Signal = " .hex cr
\
        ." Done!" cr
        timer-msg @ timer.delete
    THEN
;
