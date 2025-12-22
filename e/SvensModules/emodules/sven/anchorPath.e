/* PROCs to create and dispose anchorpath-structures used with MatchXXX-calls.
** The special thing about those structures is that they must be longword-
** aligned and have no fixed size.
**
** Example:
**
** PROC countMatches(pattern:PTR TO CHAR) HANDLE
** DEF anchor=NIL:PTR TO anchorpath,
**     fullpath,
**     error
** DEF max=0
**
**   anchor,fullpath:=allocAnchorPath()
**
**   error:=MatchFirst(pattern,anchor)
**   WHILE error=DOSFALSE
**     IF anchor.info.direntrytype<0
**       INC max
**     ENDIF
**     error:=MatchNext(anchor)                    -> Next entry
**   ENDWHILE
**
** EXCEPT DO
**
**   IF anchor
**     MatchEnd(anchor)                            -> Clean up
**     freeAnchorPath(anchor)
**   ENDIF
**
**   ReThrow()
**
** ENDPROC max
**
*/

OPT MODULE


MODULE 'dos/dosasl'
MODULE 'sven/alignedMemory'


/* allocates an new anchorpath with space for an pathname of max
** 'maxlength'-characters.
**
** Returns the anchorpath-structure and the pathname buffer
** (just anchorpath+SIZEOF anchorpath).
**
** may raise "MEM"-exception.
*/
EXPORT PROC allocAnchorPath(maxlength=255)
DEF anchor:PTR TO anchorpath

  /* allocate memory for anchorpath&string buffer plus 1Byte for zero byte (string)
  ** Must be longword-aligned (at least for 68000 systems)
  */
  anchor:=allocAlignedMemory(SIZEOF anchorpath+maxlength+1,ALIGNED_Long)

  /* Initialize the structure.
  */
  anchor.strlen:=maxlength

ENDPROC anchor,(anchor+SIZEOF anchorpath)


/* frees an anchorpath-structure created with allocAnchorPath() !
** returns NIL.
*/
EXPORT PROC freeAnchorPath(mem:PTR TO LONG) IS freeAlignedMemory(mem)

