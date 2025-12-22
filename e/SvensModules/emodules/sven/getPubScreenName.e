/* tries to find the name of an screen.
** The screen must be an public screen.
*/

OPT MODULE

MODULE 'intuition/screens',
       'exec/nodes','exec/lists'


/* copies the name of 'scr' into 'pubscrname'.
** 'scr' should be an public screen.
** if the name could not be found the string is cleared.
** returns 'pubscrname'
*/
EXPORT PROC getPubScreenName(pubscrname:PTR TO CHAR,scr:PTR TO screen)
DEF ls:PTR TO lh,
    nd:PTR TO pubscreennode

  IF pubscrname
    StrCopy(pubscrname,'')
    IF scr
      IF ls:=LockPubScreenList()
        nd:=ls.head
        /* run done the pubscreen list.
        */
        WHILE nd.ln.succ
          -> did we found the screen?
          EXIT nd.screen=scr
          -> get next screenlist entry
          nd:=nd.ln.succ
        ENDWHILE
        -> did we found the screen?
        IF nd.ln.succ THEN StrCopy(pubscrname,nd.ln.name)
        UnlockPubScreenList()
      ENDIF
    ENDIF
  ENDIF
ENDPROC pubscrname

