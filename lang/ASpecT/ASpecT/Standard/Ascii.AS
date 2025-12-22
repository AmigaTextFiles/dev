{
 ==
 == ASCII constants
 == Version 2.0 (3.12.1992, JvH)
 == (Part of the SML Library)
}

SPEC Ascii =

  OPNS nul, soh, stx,
       etx, eot, enq,
       ack, bel, bs ,
       ht , nl , vt ,
       np , cr , so ,
       si , dle, dc1,
       dc2, dc3, dc4,
       nak, syn, etb,
       can, em , sub,
       esc, fs , gs , 
       rs , us , del  :: char.

  EQNS nul = '\NUL'.       soh = '\SOH'.       stx = '\STX'.
       etx = '\ETX'.       eot = '\EOT'.       enq = '\ENQ'.
       ack = '\ACK'.       bel = '\BEL'.       bs  = '\BS' .
       ht  = '\HT' .       nl  = '\LF' .       vt  = '\VT' .
       np  = '\FF' .       cr  = '\CR' .       so  = '\SO' .
       si  = '\SI' .       dle = '\DLE'.       dc1 = '\DC1'.
       dc2 = '\DC2'.       dc3 = '\DC3'.       dc4 = '\DC4'.
       nak = '\NAK'.       syn = '\SYN'.       etb = '\ETB'.
       can = '\CAN'.       em  = '\EM' .       sub = '\SUB'.
       esc = '\ESC'.       fs  = '\FS' .       gs  = '\GS' .
       rs  = '\RS' .       us  = '\US' .       del = '\DEL'.


  OPNS lf, ff :: char.

  EQNS lf  = '\LF' .       ff  = '\FF' .


END.
