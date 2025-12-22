\ Count words and lines and chars in file.
\
\ Author: Phil Burk
\ Copyright Phil Burk 1988
\
\ 00001 10-Aug-92 mdh     Added '>newline'

include? dolines ju:dolines

ANEW TASK-WC.F

variable WC-#WORDS
variable WC-#LINES
variable WC-#CHARS
variable WC-ERROR

: WORDS.LEFT?  ( addr len -- addr' len' true | false )
    bl scan ?dup  ( any left? )
    IF  bl skip ?dup
        IF true
        ELSE drop false
        THEN
    ELSE drop false
    THEN
;

: COUNT.WORDS ( addr len -- count )
    bl skip ?dup
    IF  1 >r
        BEGIN words.left?
        WHILE r> 1+ >r
        REPEAT
        r>
    ELSE drop 0
    THEN
;

: $COUNT.LINE ( $line -- )
    1 wc-#lines +!
    count dup 1+ wc-#chars +!
    count.words wc-#words +!
;

: REPORT.COUNT ( -- )
    >newline    \ 00001
    ." #lines = " wc-#lines @ .
    ." , #words = " wc-#words @ .
    ." , #chars = " wc-#chars @ . cr
;

: WC.USAGE
    cr ." WC by Phil Burk, written in JForth" cr
    ." USAGE:  WC filename" cr
    ." Reports line, word and character count." cr
    wc-error on
;

: WC ( <filename> -- )
    wc-#lines off wc-#words off
    wc-#chars off wc-error off
    what's doline
    what's doline.error
    ' $count.line is doline
    ' wc.usage is doline.error
    dolines
    wc-error @ 0=
    IF report.count
    THEN
    ( reset vectors )
    is doline.error
    is doline
;

cr ." Enter:   WC filename      to print file statistics." cr cr
