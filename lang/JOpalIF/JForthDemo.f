\ A Mindless Demo of the JForth Language Interface for OpalVision's Opal.Library
\
\ Version 1.0 - 31 December 1992
\
\ By Marlin Schwanke

decimal

\ Include the OpalVision support code.

include JFHD:Opal/JForth/Opal.f

\ And now the mindless demo.
: .ESC ( -- , Emit escape character )
   27 emit
;

: IFF24 ( <fileword> -- , load an image into the OpalVision board )
   \ Load Opal library
   opal?                                     ( -- )
   \ Turn off existing display, if any
   closescreen24()                           ( -- )
   \ Display credits
   CR .esc ." [32m"                    ( -- )
   ." IFF24 by Marlin Schwanke"        ( -- )
   .esc ." [31m" CR CR                 ( -- )
   \ Get filename from command line
   0 fileword                                ( 0 $addr )
   \ If filename present then try to open
   dup c@                                    ( 0 $addr count )
   if                                        ( 0 $addr )
      ." Loading..." CR CR                   ( 0 $addr )
      dup $>0 force24 loadiff24()            ( result )
      \ Check status after loadiff24
      dup OL_ERR_MAXERR >                    ( result flag )
      over 0 <= or                           ( result flag )
      \ Display picture if status ok
      if                                     ( result )
         drop                                ( -- )
         refresh24()                         ( -- )
      \ Print error message, error code, and usage on error
      else                                   ( result )
         ." Opal Library Error: " . CR       ( -- )
         ." Syntax is: IFF24 filename" CR CR ( -- )
      then                                   ( -- )
   \ 0 length filename clear stack and exit
   else                                      ( 0 $addr )
      ddrop                                  ( -- )
   then                                      ( -- )
   \ Unload the library and exit
   -Opal
;
