/* you must open keymap.library v36 !!!!!
**
** Converts rawkey-codes from an RAWKEY intuimessage into ANSI-characters.
*/

OPT MODULE
OPT PREPROCESS

MODULE 'intuition/intuition',
       'devices/inputevent',
       'keymap'
MODULE 'sven/memset',
       'sven/unsigned'


/* maps an RAWKEY intuimessage into ANSI charcaters.
** The characters are stored in 'buffer' with size 'buffersize'.
** Normally 'buffersize' is 8.
**
** Returns the number of converted characters or -1 if the buffer was
** too small.
*/
EXPORT PROC mapRawKey(imsg:PTR TO intuimessage,buffer,buffersize)
DEF inputevent:inputevent,
    eventptr:PTR TO LONG

  memset(inputevent,0,SIZEOF inputevent)
  eventptr:=imsg.iaddress

  inputevent.class        := IECLASS_RAWKEY
  inputevent.code         := imsg.code
  inputevent.qualifier    := UWORD(imsg.qualifier)
  inputevent.eventaddress := eventptr[]

ENDPROC MapRawKey(inputevent,buffer,buffersize,NIL)

