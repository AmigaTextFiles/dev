\ JForth Language Interface for OpalVision's OpalReq.Library
\
\ Version 1.0 - 31 December 1992
\
\ By Marlin Schwanke

include? OpalReq ji:opal/opalreqlib.j

ANEW TASK-OPALREQ

\ JForth Amiga shared library words

:Library opalreq
: opalreq? ( -- ) opalreq_NAME opalreq_LIB lib? ;
: -opalreq ( -- ) opalreq_LIB -lib ;

\ OpalReq library call

: OpalRequester ( OpalReq -- Result )
\ The OpalVision file requester.
   call>abs opalreq_LIB OpalRequester
;
