/* eTagList are similar to normal Taglist but they don't need to
** be closed by a TAG_DONE.
**
** Just experimental. Maybe you use it in your non-system friendly
** demos where you can't open 'utility.library' :-)
*/

OPT MODULE

MODULE 'utility/tagitem'

/* Same function like GetTagData()
*/
EXPORT PROC eGetTagData(tag,defi,etaglist:PTR TO tagitem)
DEF i:REG,
    tagi:REG

  IF etaglist
    i:=ListLen(etaglist)/2
    WHILE i-->=0
      tagi:=etaglist.tag
      SELECT tagi
        CASE TAG_DONE
          RETURN defi

        CASE TAG_IGNORE
          etaglist++

        CASE TAG_SKIP
          i:=i-etaglist.data
          etaglist:=etaglist+(SIZEOF tagitem*(etaglist.data+1))

        CASE TAG_MORE
          etaglist:=etaglist.data
          IF etaglist=NIL THEN RETURN defi
          i:=ListLen(etaglist)/2

        DEFAULT
          IF etaglist.tag=tag THEN RETURN etaglist.data
          etaglist++

      ENDSELECT
    ENDWHILE
  ENDIF

ENDPROC defi

