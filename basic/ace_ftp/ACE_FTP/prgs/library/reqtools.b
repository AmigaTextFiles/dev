'..An example of using reqtools.library functions.
'..(reqtools.library must be in your LIBS: directory
'..for this program to work). ReqTools.bmap is also
'..required and has been supplied in ACEbmaps:.

#include <stddef.h>
#include <reqtools.h>	'..Thanks Nisse!

LIBRARY "reqtools.library"

DECLARE FUNCTION rtAllocRequestA& LIBRARY
DECLARE FUNCTION rtEZRequestA& LIBRARY
DECLARE FUNCTION rtFileRequestA& LIBRARY
DECLARE FUNCTION rtFreeRequest& LIBRARY

DECLARE STRUCT rtReqInfo *myreq
DECLARE STRUCT rtFileRequester *filereq

'..Message Requester
myreq = rtAllocRequestA(RT_REQINFO,NULL)
dummy$ = "This is a really"+CHR$(10)
dummy$ = dummy$ + "neat message"+CHR$(10)
dummy$ = dummy$ + "requester!"
button$="Sure|Perhaps|No way"
ret = rtEZRequestA(dummy$,button$,NULL,NULL,NULL)
rtFreeRequest(myreq)

'..File Requester
STRING fileBuffer, theDir
filereq = rtAllocRequestA(RT_FILEREQ,NULL)
ok = rtFileRequestA(filereq,fileBuffer,NULL,NULL)
rtFreeRequest(filereq)
theDir = CSTR(filereq->Dir)
IF theDir <> "" AND RIGHT$(theDir,1) <> ":" THEN theDir = theDir+"/"
IF ok THEN 
  print "You chose: ";theDir;fileBuffer
ELSE
  print "Requester cancelled."
END IF

LIBRARY CLOSE
